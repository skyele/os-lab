
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
  80003e:	e8 7d 0f 00 00       	call   800fc0 <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 6d 0f 00 00       	call   800fc0 <sys_sbrk>

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
  800099:	e8 bf 01 00 00       	call   80025d <cprintf>
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
  8000b1:	e8 a7 01 00 00       	call   80025d <cprintf>
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
  8000ce:	e8 9d 0c 00 00       	call   800d70 <sys_getenvid>
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
  8000f3:	74 21                	je     800116 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000f5:	89 d1                	mov    %edx,%ecx
  8000f7:	c1 e1 07             	shl    $0x7,%ecx
  8000fa:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800100:	8b 49 48             	mov    0x48(%ecx),%ecx
  800103:	39 c1                	cmp    %eax,%ecx
  800105:	75 e3                	jne    8000ea <libmain+0x2f>
  800107:	89 d3                	mov    %edx,%ebx
  800109:	c1 e3 07             	shl    $0x7,%ebx
  80010c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800112:	89 fe                	mov    %edi,%esi
  800114:	eb d4                	jmp    8000ea <libmain+0x2f>
  800116:	89 f0                	mov    %esi,%eax
  800118:	84 c0                	test   %al,%al
  80011a:	74 06                	je     800122 <libmain+0x67>
  80011c:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800126:	7e 0a                	jle    800132 <libmain+0x77>
		binaryname = argv[0];
  800128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012b:	8b 00                	mov    (%eax),%eax
  80012d:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800132:	a1 08 40 80 00       	mov    0x804008,%eax
  800137:	8b 40 48             	mov    0x48(%eax),%eax
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 2f 26 80 00       	push   $0x80262f
  800143:	e8 15 01 00 00       	call   80025d <cprintf>
	cprintf("before umain\n");
  800148:	c7 04 24 4d 26 80 00 	movl   $0x80264d,(%esp)
  80014f:	e8 09 01 00 00       	call   80025d <cprintf>
	// call user main routine
	umain(argc, argv);
  800154:	83 c4 08             	add    $0x8,%esp
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 d1 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800162:	c7 04 24 5b 26 80 00 	movl   $0x80265b,(%esp)
  800169:	e8 ef 00 00 00       	call   80025d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80016e:	a1 08 40 80 00       	mov    0x804008,%eax
  800173:	8b 40 48             	mov    0x48(%eax),%eax
  800176:	83 c4 08             	add    $0x8,%esp
  800179:	50                   	push   %eax
  80017a:	68 68 26 80 00       	push   $0x802668
  80017f:	e8 d9 00 00 00       	call   80025d <cprintf>
	// exit gracefully
	exit();
  800184:	e8 0b 00 00 00       	call   800194 <exit>
}
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	5f                   	pop    %edi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    

00800194 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80019a:	a1 08 40 80 00       	mov    0x804008,%eax
  80019f:	8b 40 48             	mov    0x48(%eax),%eax
  8001a2:	68 94 26 80 00       	push   $0x802694
  8001a7:	50                   	push   %eax
  8001a8:	68 87 26 80 00       	push   $0x802687
  8001ad:	e8 ab 00 00 00       	call   80025d <cprintf>
	close_all();
  8001b2:	e8 c4 10 00 00       	call   80127b <close_all>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 6c 0b 00 00       	call   800d2f <sys_env_destroy>
}
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 04             	sub    $0x4,%esp
  8001cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d2:	8b 13                	mov    (%ebx),%edx
  8001d4:	8d 42 01             	lea    0x1(%edx),%eax
  8001d7:	89 03                	mov    %eax,(%ebx)
  8001d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e5:	74 09                	je     8001f0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	68 ff 00 00 00       	push   $0xff
  8001f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fb:	50                   	push   %eax
  8001fc:	e8 f1 0a 00 00       	call   800cf2 <sys_cputs>
		b->idx = 0;
  800201:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	eb db                	jmp    8001e7 <putch+0x1f>

0080020c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800215:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021c:	00 00 00 
	b.cnt = 0;
  80021f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800226:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800229:	ff 75 0c             	pushl  0xc(%ebp)
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	68 c8 01 80 00       	push   $0x8001c8
  80023b:	e8 4a 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800240:	83 c4 08             	add    $0x8,%esp
  800243:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800249:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80024f:	50                   	push   %eax
  800250:	e8 9d 0a 00 00       	call   800cf2 <sys_cputs>

	return b.cnt;
}
  800255:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800263:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800266:	50                   	push   %eax
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 9d ff ff ff       	call   80020c <vcprintf>
	va_end(ap);

	return cnt;
}
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 1c             	sub    $0x1c,%esp
  80027a:	89 c6                	mov    %eax,%esi
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	8b 55 0c             	mov    0xc(%ebp),%edx
  800284:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800287:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80028a:	8b 45 10             	mov    0x10(%ebp),%eax
  80028d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800290:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800294:	74 2c                	je     8002c2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002a6:	39 c2                	cmp    %eax,%edx
  8002a8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ab:	73 43                	jae    8002f0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002ad:	83 eb 01             	sub    $0x1,%ebx
  8002b0:	85 db                	test   %ebx,%ebx
  8002b2:	7e 6c                	jle    800320 <printnum+0xaf>
				putch(padc, putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	57                   	push   %edi
  8002b8:	ff 75 18             	pushl  0x18(%ebp)
  8002bb:	ff d6                	call   *%esi
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	eb eb                	jmp    8002ad <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	6a 20                	push   $0x20
  8002c7:	6a 00                	push   $0x0
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d0:	89 fa                	mov    %edi,%edx
  8002d2:	89 f0                	mov    %esi,%eax
  8002d4:	e8 98 ff ff ff       	call   800271 <printnum>
		while (--width > 0)
  8002d9:	83 c4 20             	add    $0x20,%esp
  8002dc:	83 eb 01             	sub    $0x1,%ebx
  8002df:	85 db                	test   %ebx,%ebx
  8002e1:	7e 65                	jle    800348 <printnum+0xd7>
			putch(padc, putdat);
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	57                   	push   %edi
  8002e7:	6a 20                	push   $0x20
  8002e9:	ff d6                	call   *%esi
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb ec                	jmp    8002dc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	ff 75 18             	pushl  0x18(%ebp)
  8002f6:	83 eb 01             	sub    $0x1,%ebx
  8002f9:	53                   	push   %ebx
  8002fa:	50                   	push   %eax
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800301:	ff 75 d8             	pushl  -0x28(%ebp)
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	e8 91 20 00 00       	call   8023a0 <__udivdi3>
  80030f:	83 c4 18             	add    $0x18,%esp
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	89 fa                	mov    %edi,%edx
  800316:	89 f0                	mov    %esi,%eax
  800318:	e8 54 ff ff ff       	call   800271 <printnum>
  80031d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	57                   	push   %edi
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	ff 75 dc             	pushl  -0x24(%ebp)
  80032a:	ff 75 d8             	pushl  -0x28(%ebp)
  80032d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800330:	ff 75 e0             	pushl  -0x20(%ebp)
  800333:	e8 78 21 00 00       	call   8024b0 <__umoddi3>
  800338:	83 c4 14             	add    $0x14,%esp
  80033b:	0f be 80 99 26 80 00 	movsbl 0x802699(%eax),%eax
  800342:	50                   	push   %eax
  800343:	ff d6                	call   *%esi
  800345:	83 c4 10             	add    $0x10,%esp
	}
}
  800348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034b:	5b                   	pop    %ebx
  80034c:	5e                   	pop    %esi
  80034d:	5f                   	pop    %edi
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    

00800350 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800356:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80035a:	8b 10                	mov    (%eax),%edx
  80035c:	3b 50 04             	cmp    0x4(%eax),%edx
  80035f:	73 0a                	jae    80036b <sprintputch+0x1b>
		*b->buf++ = ch;
  800361:	8d 4a 01             	lea    0x1(%edx),%ecx
  800364:	89 08                	mov    %ecx,(%eax)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	88 02                	mov    %al,(%edx)
}
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <printfmt>:
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800373:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800376:	50                   	push   %eax
  800377:	ff 75 10             	pushl  0x10(%ebp)
  80037a:	ff 75 0c             	pushl  0xc(%ebp)
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	e8 05 00 00 00       	call   80038a <vprintfmt>
}
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <vprintfmt>:
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	57                   	push   %edi
  80038e:	56                   	push   %esi
  80038f:	53                   	push   %ebx
  800390:	83 ec 3c             	sub    $0x3c,%esp
  800393:	8b 75 08             	mov    0x8(%ebp),%esi
  800396:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800399:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039c:	e9 32 04 00 00       	jmp    8007d3 <vprintfmt+0x449>
		padc = ' ';
  8003a1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003a5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003ac:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	8d 47 01             	lea    0x1(%edi),%eax
  8003d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d3:	0f b6 17             	movzbl (%edi),%edx
  8003d6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d9:	3c 55                	cmp    $0x55,%al
  8003db:	0f 87 12 05 00 00    	ja     8008f3 <vprintfmt+0x569>
  8003e1:	0f b6 c0             	movzbl %al,%eax
  8003e4:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ee:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003f2:	eb d9                	jmp    8003cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003fb:	eb d0                	jmp    8003cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	0f b6 d2             	movzbl %dl,%edx
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
  800408:	89 75 08             	mov    %esi,0x8(%ebp)
  80040b:	eb 03                	jmp    800410 <vprintfmt+0x86>
  80040d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800410:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800413:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800417:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80041d:	83 fe 09             	cmp    $0x9,%esi
  800420:	76 eb                	jbe    80040d <vprintfmt+0x83>
  800422:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800425:	8b 75 08             	mov    0x8(%ebp),%esi
  800428:	eb 14                	jmp    80043e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 40 04             	lea    0x4(%eax),%eax
  800438:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80043e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800442:	79 89                	jns    8003cd <vprintfmt+0x43>
				width = precision, precision = -1;
  800444:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800451:	e9 77 ff ff ff       	jmp    8003cd <vprintfmt+0x43>
  800456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800459:	85 c0                	test   %eax,%eax
  80045b:	0f 48 c1             	cmovs  %ecx,%eax
  80045e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800464:	e9 64 ff ff ff       	jmp    8003cd <vprintfmt+0x43>
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80046c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800473:	e9 55 ff ff ff       	jmp    8003cd <vprintfmt+0x43>
			lflag++;
  800478:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047f:	e9 49 ff ff ff       	jmp    8003cd <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 78 04             	lea    0x4(%eax),%edi
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	53                   	push   %ebx
  80048e:	ff 30                	pushl  (%eax)
  800490:	ff d6                	call   *%esi
			break;
  800492:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800495:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800498:	e9 33 03 00 00       	jmp    8007d0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	8d 78 04             	lea    0x4(%eax),%edi
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	99                   	cltd   
  8004a6:	31 d0                	xor    %edx,%eax
  8004a8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004aa:	83 f8 11             	cmp    $0x11,%eax
  8004ad:	7f 23                	jg     8004d2 <vprintfmt+0x148>
  8004af:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	74 18                	je     8004d2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004ba:	52                   	push   %edx
  8004bb:	68 fd 2a 80 00       	push   $0x802afd
  8004c0:	53                   	push   %ebx
  8004c1:	56                   	push   %esi
  8004c2:	e8 a6 fe ff ff       	call   80036d <printfmt>
  8004c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004cd:	e9 fe 02 00 00       	jmp    8007d0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d2:	50                   	push   %eax
  8004d3:	68 b1 26 80 00       	push   $0x8026b1
  8004d8:	53                   	push   %ebx
  8004d9:	56                   	push   %esi
  8004da:	e8 8e fe ff ff       	call   80036d <printfmt>
  8004df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e5:	e9 e6 02 00 00       	jmp    8007d0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	83 c0 04             	add    $0x4,%eax
  8004f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004f8:	85 c9                	test   %ecx,%ecx
  8004fa:	b8 aa 26 80 00       	mov    $0x8026aa,%eax
  8004ff:	0f 45 c1             	cmovne %ecx,%eax
  800502:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800505:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800509:	7e 06                	jle    800511 <vprintfmt+0x187>
  80050b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80050f:	75 0d                	jne    80051e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800511:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800514:	89 c7                	mov    %eax,%edi
  800516:	03 45 e0             	add    -0x20(%ebp),%eax
  800519:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051c:	eb 53                	jmp    800571 <vprintfmt+0x1e7>
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 d8             	pushl  -0x28(%ebp)
  800524:	50                   	push   %eax
  800525:	e8 71 04 00 00       	call   80099b <strnlen>
  80052a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052d:	29 c1                	sub    %eax,%ecx
  80052f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800537:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80053b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80053e:	eb 0f                	jmp    80054f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	53                   	push   %ebx
  800544:	ff 75 e0             	pushl  -0x20(%ebp)
  800547:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800549:	83 ef 01             	sub    $0x1,%edi
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	85 ff                	test   %edi,%edi
  800551:	7f ed                	jg     800540 <vprintfmt+0x1b6>
  800553:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800556:	85 c9                	test   %ecx,%ecx
  800558:	b8 00 00 00 00       	mov    $0x0,%eax
  80055d:	0f 49 c1             	cmovns %ecx,%eax
  800560:	29 c1                	sub    %eax,%ecx
  800562:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800565:	eb aa                	jmp    800511 <vprintfmt+0x187>
					putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	53                   	push   %ebx
  80056b:	52                   	push   %edx
  80056c:	ff d6                	call   *%esi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800574:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800576:	83 c7 01             	add    $0x1,%edi
  800579:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80057d:	0f be d0             	movsbl %al,%edx
  800580:	85 d2                	test   %edx,%edx
  800582:	74 4b                	je     8005cf <vprintfmt+0x245>
  800584:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800588:	78 06                	js     800590 <vprintfmt+0x206>
  80058a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80058e:	78 1e                	js     8005ae <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800590:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800594:	74 d1                	je     800567 <vprintfmt+0x1dd>
  800596:	0f be c0             	movsbl %al,%eax
  800599:	83 e8 20             	sub    $0x20,%eax
  80059c:	83 f8 5e             	cmp    $0x5e,%eax
  80059f:	76 c6                	jbe    800567 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 3f                	push   $0x3f
  8005a7:	ff d6                	call   *%esi
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	eb c3                	jmp    800571 <vprintfmt+0x1e7>
  8005ae:	89 cf                	mov    %ecx,%edi
  8005b0:	eb 0e                	jmp    8005c0 <vprintfmt+0x236>
				putch(' ', putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	6a 20                	push   $0x20
  8005b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005ba:	83 ef 01             	sub    $0x1,%edi
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	85 ff                	test   %edi,%edi
  8005c2:	7f ee                	jg     8005b2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ca:	e9 01 02 00 00       	jmp    8007d0 <vprintfmt+0x446>
  8005cf:	89 cf                	mov    %ecx,%edi
  8005d1:	eb ed                	jmp    8005c0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005d6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005dd:	e9 eb fd ff ff       	jmp    8003cd <vprintfmt+0x43>
	if (lflag >= 2)
  8005e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005e6:	7f 21                	jg     800609 <vprintfmt+0x27f>
	else if (lflag)
  8005e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005ec:	74 68                	je     800656 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f6:	89 c1                	mov    %eax,%ecx
  8005f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8d 40 04             	lea    0x4(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
  800607:	eb 17                	jmp    800620 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 50 04             	mov    0x4(%eax),%edx
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800614:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8d 40 08             	lea    0x8(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800629:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80062c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800630:	78 3f                	js     800671 <vprintfmt+0x2e7>
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800637:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80063b:	0f 84 71 01 00 00    	je     8007b2 <vprintfmt+0x428>
				putch('+', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 2b                	push   $0x2b
  800647:	ff d6                	call   *%esi
  800649:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800651:	e9 5c 01 00 00       	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80065e:	89 c1                	mov    %eax,%ecx
  800660:	c1 f9 1f             	sar    $0x1f,%ecx
  800663:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 04             	lea    0x4(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	eb af                	jmp    800620 <vprintfmt+0x296>
				putch('-', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 2d                	push   $0x2d
  800677:	ff d6                	call   *%esi
				num = -(long long) num;
  800679:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067f:	f7 d8                	neg    %eax
  800681:	83 d2 00             	adc    $0x0,%edx
  800684:	f7 da                	neg    %edx
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800694:	e9 19 01 00 00       	jmp    8007b2 <vprintfmt+0x428>
	if (lflag >= 2)
  800699:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069d:	7f 29                	jg     8006c8 <vprintfmt+0x33e>
	else if (lflag)
  80069f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a3:	74 44                	je     8006e9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 04             	lea    0x4(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c3:	e9 ea 00 00 00       	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 08             	lea    0x8(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e4:	e9 c9 00 00 00       	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800702:	b8 0a 00 00 00       	mov    $0xa,%eax
  800707:	e9 a6 00 00 00       	jmp    8007b2 <vprintfmt+0x428>
			putch('0', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 30                	push   $0x30
  800712:	ff d6                	call   *%esi
	if (lflag >= 2)
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80071b:	7f 26                	jg     800743 <vprintfmt+0x3b9>
	else if (lflag)
  80071d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800721:	74 3e                	je     800761 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	b8 08 00 00 00       	mov    $0x8,%eax
  800741:	eb 6f                	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 50 04             	mov    0x4(%eax),%edx
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
  80075f:	eb 51                	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8d 40 04             	lea    0x4(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077a:	b8 08 00 00 00       	mov    $0x8,%eax
  80077f:	eb 31                	jmp    8007b2 <vprintfmt+0x428>
			putch('0', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	6a 30                	push   $0x30
  800787:	ff d6                	call   *%esi
			putch('x', putdat);
  800789:	83 c4 08             	add    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 78                	push   $0x78
  80078f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007a1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007b9:	52                   	push   %edx
  8007ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c4:	89 da                	mov    %ebx,%edx
  8007c6:	89 f0                	mov    %esi,%eax
  8007c8:	e8 a4 fa ff ff       	call   800271 <printnum>
			break;
  8007cd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d3:	83 c7 01             	add    $0x1,%edi
  8007d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007da:	83 f8 25             	cmp    $0x25,%eax
  8007dd:	0f 84 be fb ff ff    	je     8003a1 <vprintfmt+0x17>
			if (ch == '\0')
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	0f 84 28 01 00 00    	je     800913 <vprintfmt+0x589>
			putch(ch, putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	53                   	push   %ebx
  8007ef:	50                   	push   %eax
  8007f0:	ff d6                	call   *%esi
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb dc                	jmp    8007d3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007fb:	7f 26                	jg     800823 <vprintfmt+0x499>
	else if (lflag)
  8007fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800801:	74 41                	je     800844 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800810:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8d 40 04             	lea    0x4(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081c:	b8 10 00 00 00       	mov    $0x10,%eax
  800821:	eb 8f                	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8b 50 04             	mov    0x4(%eax),%edx
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 40 08             	lea    0x8(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083a:	b8 10 00 00 00       	mov    $0x10,%eax
  80083f:	e9 6e ff ff ff       	jmp    8007b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
  800862:	e9 4b ff ff ff       	jmp    8007b2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	83 c0 04             	add    $0x4,%eax
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	85 c0                	test   %eax,%eax
  800877:	74 14                	je     80088d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800879:	8b 13                	mov    (%ebx),%edx
  80087b:	83 fa 7f             	cmp    $0x7f,%edx
  80087e:	7f 37                	jg     8008b7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800880:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800882:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	e9 43 ff ff ff       	jmp    8007d0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80088d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800892:	bf cd 27 80 00       	mov    $0x8027cd,%edi
							putch(ch, putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	50                   	push   %eax
  80089c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80089e:	83 c7 01             	add    $0x1,%edi
  8008a1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	85 c0                	test   %eax,%eax
  8008aa:	75 eb                	jne    800897 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b2:	e9 19 ff ff ff       	jmp    8007d0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008b7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008be:	bf 05 28 80 00       	mov    $0x802805,%edi
							putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	50                   	push   %eax
  8008c8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ca:	83 c7 01             	add    $0x1,%edi
  8008cd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	75 eb                	jne    8008c3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
  8008de:	e9 ed fe ff ff       	jmp    8007d0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 25                	push   $0x25
  8008e9:	ff d6                	call   *%esi
			break;
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	e9 dd fe ff ff       	jmp    8007d0 <vprintfmt+0x446>
			putch('%', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	53                   	push   %ebx
  8008f7:	6a 25                	push   $0x25
  8008f9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 f8                	mov    %edi,%eax
  800900:	eb 03                	jmp    800905 <vprintfmt+0x57b>
  800902:	83 e8 01             	sub    $0x1,%eax
  800905:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800909:	75 f7                	jne    800902 <vprintfmt+0x578>
  80090b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090e:	e9 bd fe ff ff       	jmp    8007d0 <vprintfmt+0x446>
}
  800913:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800916:	5b                   	pop    %ebx
  800917:	5e                   	pop    %esi
  800918:	5f                   	pop    %edi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	83 ec 18             	sub    $0x18,%esp
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800927:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800931:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800938:	85 c0                	test   %eax,%eax
  80093a:	74 26                	je     800962 <vsnprintf+0x47>
  80093c:	85 d2                	test   %edx,%edx
  80093e:	7e 22                	jle    800962 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800940:	ff 75 14             	pushl  0x14(%ebp)
  800943:	ff 75 10             	pushl  0x10(%ebp)
  800946:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800949:	50                   	push   %eax
  80094a:	68 50 03 80 00       	push   $0x800350
  80094f:	e8 36 fa ff ff       	call   80038a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800957:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	83 c4 10             	add    $0x10,%esp
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    
		return -E_INVAL;
  800962:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800967:	eb f7                	jmp    800960 <vsnprintf+0x45>

00800969 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800972:	50                   	push   %eax
  800973:	ff 75 10             	pushl  0x10(%ebp)
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	ff 75 08             	pushl  0x8(%ebp)
  80097c:	e8 9a ff ff ff       	call   80091b <vsnprintf>
	va_end(ap);

	return rc;
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
  80098e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800992:	74 05                	je     800999 <strlen+0x16>
		n++;
  800994:	83 c0 01             	add    $0x1,%eax
  800997:	eb f5                	jmp    80098e <strlen+0xb>
	return n;
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a9:	39 c2                	cmp    %eax,%edx
  8009ab:	74 0d                	je     8009ba <strnlen+0x1f>
  8009ad:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009b1:	74 05                	je     8009b8 <strnlen+0x1d>
		n++;
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	eb f1                	jmp    8009a9 <strnlen+0xe>
  8009b8:	89 d0                	mov    %edx,%eax
	return n;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009cf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d2:	83 c2 01             	add    $0x1,%edx
  8009d5:	84 c9                	test   %cl,%cl
  8009d7:	75 f2                	jne    8009cb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009d9:	5b                   	pop    %ebx
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	53                   	push   %ebx
  8009e0:	83 ec 10             	sub    $0x10,%esp
  8009e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e6:	53                   	push   %ebx
  8009e7:	e8 97 ff ff ff       	call   800983 <strlen>
  8009ec:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	01 d8                	add    %ebx,%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 c2 ff ff ff       	call   8009bc <strcpy>
	return dst;
}
  8009fa:	89 d8                	mov    %ebx,%eax
  8009fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ff:	c9                   	leave  
  800a00:	c3                   	ret    

00800a01 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	56                   	push   %esi
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0c:	89 c6                	mov    %eax,%esi
  800a0e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a11:	89 c2                	mov    %eax,%edx
  800a13:	39 f2                	cmp    %esi,%edx
  800a15:	74 11                	je     800a28 <strncpy+0x27>
		*dst++ = *src;
  800a17:	83 c2 01             	add    $0x1,%edx
  800a1a:	0f b6 19             	movzbl (%ecx),%ebx
  800a1d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a20:	80 fb 01             	cmp    $0x1,%bl
  800a23:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a26:	eb eb                	jmp    800a13 <strncpy+0x12>
	}
	return ret;
}
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 75 08             	mov    0x8(%ebp),%esi
  800a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a37:	8b 55 10             	mov    0x10(%ebp),%edx
  800a3a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a3c:	85 d2                	test   %edx,%edx
  800a3e:	74 21                	je     800a61 <strlcpy+0x35>
  800a40:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a44:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a46:	39 c2                	cmp    %eax,%edx
  800a48:	74 14                	je     800a5e <strlcpy+0x32>
  800a4a:	0f b6 19             	movzbl (%ecx),%ebx
  800a4d:	84 db                	test   %bl,%bl
  800a4f:	74 0b                	je     800a5c <strlcpy+0x30>
			*dst++ = *src++;
  800a51:	83 c1 01             	add    $0x1,%ecx
  800a54:	83 c2 01             	add    $0x1,%edx
  800a57:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5a:	eb ea                	jmp    800a46 <strlcpy+0x1a>
  800a5c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a5e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a61:	29 f0                	sub    %esi,%eax
}
  800a63:	5b                   	pop    %ebx
  800a64:	5e                   	pop    %esi
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a70:	0f b6 01             	movzbl (%ecx),%eax
  800a73:	84 c0                	test   %al,%al
  800a75:	74 0c                	je     800a83 <strcmp+0x1c>
  800a77:	3a 02                	cmp    (%edx),%al
  800a79:	75 08                	jne    800a83 <strcmp+0x1c>
		p++, q++;
  800a7b:	83 c1 01             	add    $0x1,%ecx
  800a7e:	83 c2 01             	add    $0x1,%edx
  800a81:	eb ed                	jmp    800a70 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a83:	0f b6 c0             	movzbl %al,%eax
  800a86:	0f b6 12             	movzbl (%edx),%edx
  800a89:	29 d0                	sub    %edx,%eax
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	53                   	push   %ebx
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a97:	89 c3                	mov    %eax,%ebx
  800a99:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a9c:	eb 06                	jmp    800aa4 <strncmp+0x17>
		n--, p++, q++;
  800a9e:	83 c0 01             	add    $0x1,%eax
  800aa1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa4:	39 d8                	cmp    %ebx,%eax
  800aa6:	74 16                	je     800abe <strncmp+0x31>
  800aa8:	0f b6 08             	movzbl (%eax),%ecx
  800aab:	84 c9                	test   %cl,%cl
  800aad:	74 04                	je     800ab3 <strncmp+0x26>
  800aaf:	3a 0a                	cmp    (%edx),%cl
  800ab1:	74 eb                	je     800a9e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab3:	0f b6 00             	movzbl (%eax),%eax
  800ab6:	0f b6 12             	movzbl (%edx),%edx
  800ab9:	29 d0                	sub    %edx,%eax
}
  800abb:	5b                   	pop    %ebx
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    
		return 0;
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac3:	eb f6                	jmp    800abb <strncmp+0x2e>

00800ac5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800acf:	0f b6 10             	movzbl (%eax),%edx
  800ad2:	84 d2                	test   %dl,%dl
  800ad4:	74 09                	je     800adf <strchr+0x1a>
		if (*s == c)
  800ad6:	38 ca                	cmp    %cl,%dl
  800ad8:	74 0a                	je     800ae4 <strchr+0x1f>
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	eb f0                	jmp    800acf <strchr+0xa>
			return (char *) s;
	return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af3:	38 ca                	cmp    %cl,%dl
  800af5:	74 09                	je     800b00 <strfind+0x1a>
  800af7:	84 d2                	test   %dl,%dl
  800af9:	74 05                	je     800b00 <strfind+0x1a>
	for (; *s; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f0                	jmp    800af0 <strfind+0xa>
			break;
	return (char *) s;
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
  800b08:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0e:	85 c9                	test   %ecx,%ecx
  800b10:	74 31                	je     800b43 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b12:	89 f8                	mov    %edi,%eax
  800b14:	09 c8                	or     %ecx,%eax
  800b16:	a8 03                	test   $0x3,%al
  800b18:	75 23                	jne    800b3d <memset+0x3b>
		c &= 0xFF;
  800b1a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1e:	89 d3                	mov    %edx,%ebx
  800b20:	c1 e3 08             	shl    $0x8,%ebx
  800b23:	89 d0                	mov    %edx,%eax
  800b25:	c1 e0 18             	shl    $0x18,%eax
  800b28:	89 d6                	mov    %edx,%esi
  800b2a:	c1 e6 10             	shl    $0x10,%esi
  800b2d:	09 f0                	or     %esi,%eax
  800b2f:	09 c2                	or     %eax,%edx
  800b31:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b33:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b36:	89 d0                	mov    %edx,%eax
  800b38:	fc                   	cld    
  800b39:	f3 ab                	rep stos %eax,%es:(%edi)
  800b3b:	eb 06                	jmp    800b43 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	fc                   	cld    
  800b41:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b43:	89 f8                	mov    %edi,%eax
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	57                   	push   %edi
  800b4e:	56                   	push   %esi
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b58:	39 c6                	cmp    %eax,%esi
  800b5a:	73 32                	jae    800b8e <memmove+0x44>
  800b5c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	76 2b                	jbe    800b8e <memmove+0x44>
		s += n;
		d += n;
  800b63:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	89 fe                	mov    %edi,%esi
  800b68:	09 ce                	or     %ecx,%esi
  800b6a:	09 d6                	or     %edx,%esi
  800b6c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b72:	75 0e                	jne    800b82 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b74:	83 ef 04             	sub    $0x4,%edi
  800b77:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7d:	fd                   	std    
  800b7e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b80:	eb 09                	jmp    800b8b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b82:	83 ef 01             	sub    $0x1,%edi
  800b85:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b88:	fd                   	std    
  800b89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8b:	fc                   	cld    
  800b8c:	eb 1a                	jmp    800ba8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	09 ca                	or     %ecx,%edx
  800b92:	09 f2                	or     %esi,%edx
  800b94:	f6 c2 03             	test   $0x3,%dl
  800b97:	75 0a                	jne    800ba3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 05                	jmp    800ba8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb2:	ff 75 10             	pushl  0x10(%ebp)
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	ff 75 08             	pushl  0x8(%ebp)
  800bbb:	e8 8a ff ff ff       	call   800b4a <memmove>
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	56                   	push   %esi
  800bc6:	53                   	push   %ebx
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcd:	89 c6                	mov    %eax,%esi
  800bcf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd2:	39 f0                	cmp    %esi,%eax
  800bd4:	74 1c                	je     800bf2 <memcmp+0x30>
		if (*s1 != *s2)
  800bd6:	0f b6 08             	movzbl (%eax),%ecx
  800bd9:	0f b6 1a             	movzbl (%edx),%ebx
  800bdc:	38 d9                	cmp    %bl,%cl
  800bde:	75 08                	jne    800be8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be0:	83 c0 01             	add    $0x1,%eax
  800be3:	83 c2 01             	add    $0x1,%edx
  800be6:	eb ea                	jmp    800bd2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800be8:	0f b6 c1             	movzbl %cl,%eax
  800beb:	0f b6 db             	movzbl %bl,%ebx
  800bee:	29 d8                	sub    %ebx,%eax
  800bf0:	eb 05                	jmp    800bf7 <memcmp+0x35>
	}

	return 0;
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf7:	5b                   	pop    %ebx
  800bf8:	5e                   	pop    %esi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c04:	89 c2                	mov    %eax,%edx
  800c06:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c09:	39 d0                	cmp    %edx,%eax
  800c0b:	73 09                	jae    800c16 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c0d:	38 08                	cmp    %cl,(%eax)
  800c0f:	74 05                	je     800c16 <memfind+0x1b>
	for (; s < ends; s++)
  800c11:	83 c0 01             	add    $0x1,%eax
  800c14:	eb f3                	jmp    800c09 <memfind+0xe>
			break;
	return (void *) s;
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
  800c1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c24:	eb 03                	jmp    800c29 <strtol+0x11>
		s++;
  800c26:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c29:	0f b6 01             	movzbl (%ecx),%eax
  800c2c:	3c 20                	cmp    $0x20,%al
  800c2e:	74 f6                	je     800c26 <strtol+0xe>
  800c30:	3c 09                	cmp    $0x9,%al
  800c32:	74 f2                	je     800c26 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c34:	3c 2b                	cmp    $0x2b,%al
  800c36:	74 2a                	je     800c62 <strtol+0x4a>
	int neg = 0;
  800c38:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c3d:	3c 2d                	cmp    $0x2d,%al
  800c3f:	74 2b                	je     800c6c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c41:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c47:	75 0f                	jne    800c58 <strtol+0x40>
  800c49:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4c:	74 28                	je     800c76 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c4e:	85 db                	test   %ebx,%ebx
  800c50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c55:	0f 44 d8             	cmove  %eax,%ebx
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c60:	eb 50                	jmp    800cb2 <strtol+0x9a>
		s++;
  800c62:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c65:	bf 00 00 00 00       	mov    $0x0,%edi
  800c6a:	eb d5                	jmp    800c41 <strtol+0x29>
		s++, neg = 1;
  800c6c:	83 c1 01             	add    $0x1,%ecx
  800c6f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c74:	eb cb                	jmp    800c41 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c76:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c7a:	74 0e                	je     800c8a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c7c:	85 db                	test   %ebx,%ebx
  800c7e:	75 d8                	jne    800c58 <strtol+0x40>
		s++, base = 8;
  800c80:	83 c1 01             	add    $0x1,%ecx
  800c83:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c88:	eb ce                	jmp    800c58 <strtol+0x40>
		s += 2, base = 16;
  800c8a:	83 c1 02             	add    $0x2,%ecx
  800c8d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c92:	eb c4                	jmp    800c58 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c94:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c97:	89 f3                	mov    %esi,%ebx
  800c99:	80 fb 19             	cmp    $0x19,%bl
  800c9c:	77 29                	ja     800cc7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c9e:	0f be d2             	movsbl %dl,%edx
  800ca1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ca7:	7d 30                	jge    800cd9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ca9:	83 c1 01             	add    $0x1,%ecx
  800cac:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb2:	0f b6 11             	movzbl (%ecx),%edx
  800cb5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cb8:	89 f3                	mov    %esi,%ebx
  800cba:	80 fb 09             	cmp    $0x9,%bl
  800cbd:	77 d5                	ja     800c94 <strtol+0x7c>
			dig = *s - '0';
  800cbf:	0f be d2             	movsbl %dl,%edx
  800cc2:	83 ea 30             	sub    $0x30,%edx
  800cc5:	eb dd                	jmp    800ca4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cc7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cca:	89 f3                	mov    %esi,%ebx
  800ccc:	80 fb 19             	cmp    $0x19,%bl
  800ccf:	77 08                	ja     800cd9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd1:	0f be d2             	movsbl %dl,%edx
  800cd4:	83 ea 37             	sub    $0x37,%edx
  800cd7:	eb cb                	jmp    800ca4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdd:	74 05                	je     800ce4 <strtol+0xcc>
		*endptr = (char *) s;
  800cdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce4:	89 c2                	mov    %eax,%edx
  800ce6:	f7 da                	neg    %edx
  800ce8:	85 ff                	test   %edi,%edi
  800cea:	0f 45 c2             	cmovne %edx,%eax
}
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d03:	89 c3                	mov    %eax,%ebx
  800d05:	89 c7                	mov    %eax,%edi
  800d07:	89 c6                	mov    %eax,%esi
  800d09:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 01 00 00 00       	mov    $0x1,%eax
  800d20:	89 d1                	mov    %edx,%ecx
  800d22:	89 d3                	mov    %edx,%ebx
  800d24:	89 d7                	mov    %edx,%edi
  800d26:	89 d6                	mov    %edx,%esi
  800d28:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	b8 03 00 00 00       	mov    $0x3,%eax
  800d45:	89 cb                	mov    %ecx,%ebx
  800d47:	89 cf                	mov    %ecx,%edi
  800d49:	89 ce                	mov    %ecx,%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 03                	push   $0x3
  800d5f:	68 28 2a 80 00       	push   $0x802a28
  800d64:	6a 43                	push   $0x43
  800d66:	68 45 2a 80 00       	push   $0x802a45
  800d6b:	e8 89 14 00 00       	call   8021f9 <_panic>

00800d70 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d76:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d80:	89 d1                	mov    %edx,%ecx
  800d82:	89 d3                	mov    %edx,%ebx
  800d84:	89 d7                	mov    %edx,%edi
  800d86:	89 d6                	mov    %edx,%esi
  800d88:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <sys_yield>:

void
sys_yield(void)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d95:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d9f:	89 d1                	mov    %edx,%ecx
  800da1:	89 d3                	mov    %edx,%ebx
  800da3:	89 d7                	mov    %edx,%edi
  800da5:	89 d6                	mov    %edx,%esi
  800da7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db7:	be 00 00 00 00       	mov    $0x0,%esi
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dca:	89 f7                	mov    %esi,%edi
  800dcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7f 08                	jg     800dda <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	83 ec 0c             	sub    $0xc,%esp
  800ddd:	50                   	push   %eax
  800dde:	6a 04                	push   $0x4
  800de0:	68 28 2a 80 00       	push   $0x802a28
  800de5:	6a 43                	push   $0x43
  800de7:	68 45 2a 80 00       	push   $0x802a45
  800dec:	e8 08 14 00 00       	call   8021f9 <_panic>

00800df1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 05 00 00 00       	mov    $0x5,%eax
  800e05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e0b:	8b 75 18             	mov    0x18(%ebp),%esi
  800e0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	7f 08                	jg     800e1c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	6a 05                	push   $0x5
  800e22:	68 28 2a 80 00       	push   $0x802a28
  800e27:	6a 43                	push   $0x43
  800e29:	68 45 2a 80 00       	push   $0x802a45
  800e2e:	e8 c6 13 00 00       	call   8021f9 <_panic>

00800e33 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 06                	push   $0x6
  800e64:	68 28 2a 80 00       	push   $0x802a28
  800e69:	6a 43                	push   $0x43
  800e6b:	68 45 2a 80 00       	push   $0x802a45
  800e70:	e8 84 13 00 00       	call   8021f9 <_panic>

00800e75 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 08 00 00 00       	mov    $0x8,%eax
  800e8e:	89 df                	mov    %ebx,%edi
  800e90:	89 de                	mov    %ebx,%esi
  800e92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 08                	push   $0x8
  800ea6:	68 28 2a 80 00       	push   $0x802a28
  800eab:	6a 43                	push   $0x43
  800ead:	68 45 2a 80 00       	push   $0x802a45
  800eb2:	e8 42 13 00 00       	call   8021f9 <_panic>

00800eb7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	89 de                	mov    %ebx,%esi
  800ed4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7f 08                	jg     800ee2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edd:	5b                   	pop    %ebx
  800ede:	5e                   	pop    %esi
  800edf:	5f                   	pop    %edi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	50                   	push   %eax
  800ee6:	6a 09                	push   $0x9
  800ee8:	68 28 2a 80 00       	push   $0x802a28
  800eed:	6a 43                	push   $0x43
  800eef:	68 45 2a 80 00       	push   $0x802a45
  800ef4:	e8 00 13 00 00       	call   8021f9 <_panic>

00800ef9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f12:	89 df                	mov    %ebx,%edi
  800f14:	89 de                	mov    %ebx,%esi
  800f16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	7f 08                	jg     800f24 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	50                   	push   %eax
  800f28:	6a 0a                	push   $0xa
  800f2a:	68 28 2a 80 00       	push   $0x802a28
  800f2f:	6a 43                	push   $0x43
  800f31:	68 45 2a 80 00       	push   $0x802a45
  800f36:	e8 be 12 00 00       	call   8021f9 <_panic>

00800f3b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
  800f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f47:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f4c:	be 00 00 00 00       	mov    $0x0,%esi
  800f51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f54:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f57:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f74:	89 cb                	mov    %ecx,%ebx
  800f76:	89 cf                	mov    %ecx,%edi
  800f78:	89 ce                	mov    %ecx,%esi
  800f7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7f 08                	jg     800f88 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	6a 0d                	push   $0xd
  800f8e:	68 28 2a 80 00       	push   $0x802a28
  800f93:	6a 43                	push   $0x43
  800f95:	68 45 2a 80 00       	push   $0x802a45
  800f9a:	e8 5a 12 00 00       	call   8021f9 <_panic>

00800f9f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb5:	89 df                	mov    %ebx,%edi
  800fb7:	89 de                	mov    %ebx,%esi
  800fb9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd3:	89 cb                	mov    %ecx,%ebx
  800fd5:	89 cf                	mov    %ecx,%edi
  800fd7:	89 ce                	mov    %ecx,%esi
  800fd9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe6:	ba 00 00 00 00       	mov    $0x0,%edx
  800feb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff0:	89 d1                	mov    %edx,%ecx
  800ff2:	89 d3                	mov    %edx,%ebx
  800ff4:	89 d7                	mov    %edx,%edi
  800ff6:	89 d6                	mov    %edx,%esi
  800ff8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	b8 11 00 00 00       	mov    $0x11,%eax
  801015:	89 df                	mov    %ebx,%edi
  801017:	89 de                	mov    %ebx,%esi
  801019:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
	asm volatile("int %1\n"
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	b8 12 00 00 00       	mov    $0x12,%eax
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801055:	b8 13 00 00 00       	mov    $0x13,%eax
  80105a:	89 df                	mov    %ebx,%edi
  80105c:	89 de                	mov    %ebx,%esi
  80105e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801060:	85 c0                	test   %eax,%eax
  801062:	7f 08                	jg     80106c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801064:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5f                   	pop    %edi
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106c:	83 ec 0c             	sub    $0xc,%esp
  80106f:	50                   	push   %eax
  801070:	6a 13                	push   $0x13
  801072:	68 28 2a 80 00       	push   $0x802a28
  801077:	6a 43                	push   $0x43
  801079:	68 45 2a 80 00       	push   $0x802a45
  80107e:	e8 76 11 00 00       	call   8021f9 <_panic>

00801083 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
	asm volatile("int %1\n"
  801089:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108e:	8b 55 08             	mov    0x8(%ebp),%edx
  801091:	b8 14 00 00 00       	mov    $0x14,%eax
  801096:	89 cb                	mov    %ecx,%ebx
  801098:	89 cf                	mov    %ecx,%edi
  80109a:	89 ce                	mov    %ecx,%esi
  80109c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ae:	c1 e8 0c             	shr    $0xc,%eax
}
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	c1 ea 16             	shr    $0x16,%edx
  8010d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010de:	f6 c2 01             	test   $0x1,%dl
  8010e1:	74 2d                	je     801110 <fd_alloc+0x46>
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 0c             	shr    $0xc,%edx
  8010e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ef:	f6 c2 01             	test   $0x1,%dl
  8010f2:	74 1c                	je     801110 <fd_alloc+0x46>
  8010f4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010fe:	75 d2                	jne    8010d2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801109:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80110e:	eb 0a                	jmp    80111a <fd_alloc+0x50>
			*fd_store = fd;
  801110:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801113:	89 01                	mov    %eax,(%ecx)
			return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801122:	83 f8 1f             	cmp    $0x1f,%eax
  801125:	77 30                	ja     801157 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801127:	c1 e0 0c             	shl    $0xc,%eax
  80112a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80112f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801135:	f6 c2 01             	test   $0x1,%dl
  801138:	74 24                	je     80115e <fd_lookup+0x42>
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	c1 ea 0c             	shr    $0xc,%edx
  80113f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801146:	f6 c2 01             	test   $0x1,%dl
  801149:	74 1a                	je     801165 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80114b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114e:	89 02                	mov    %eax,(%edx)
	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
		return -E_INVAL;
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb f7                	jmp    801155 <fd_lookup+0x39>
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb f0                	jmp    801155 <fd_lookup+0x39>
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116a:	eb e9                	jmp    801155 <fd_lookup+0x39>

0080116c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801175:	ba 00 00 00 00       	mov    $0x0,%edx
  80117a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80117f:	39 08                	cmp    %ecx,(%eax)
  801181:	74 38                	je     8011bb <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801183:	83 c2 01             	add    $0x1,%edx
  801186:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 ee                	jne    80117f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801191:	a1 08 40 80 00       	mov    0x804008,%eax
  801196:	8b 40 48             	mov    0x48(%eax),%eax
  801199:	83 ec 04             	sub    $0x4,%esp
  80119c:	51                   	push   %ecx
  80119d:	50                   	push   %eax
  80119e:	68 54 2a 80 00       	push   $0x802a54
  8011a3:	e8 b5 f0 ff ff       	call   80025d <cprintf>
	*dev = 0;
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    
			*dev = devtab[i];
  8011bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb f2                	jmp    8011b9 <dev_lookup+0x4d>

008011c7 <fd_close>:
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	57                   	push   %edi
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 24             	sub    $0x24,%esp
  8011d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011da:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e3:	50                   	push   %eax
  8011e4:	e8 33 ff ff ff       	call   80111c <fd_lookup>
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 05                	js     8011f7 <fd_close+0x30>
	    || fd != fd2)
  8011f2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011f5:	74 16                	je     80120d <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f7:	89 f8                	mov    %edi,%eax
  8011f9:	84 c0                	test   %al,%al
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801200:	0f 44 d8             	cmove  %eax,%ebx
}
  801203:	89 d8                	mov    %ebx,%eax
  801205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801208:	5b                   	pop    %ebx
  801209:	5e                   	pop    %esi
  80120a:	5f                   	pop    %edi
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801213:	50                   	push   %eax
  801214:	ff 36                	pushl  (%esi)
  801216:	e8 51 ff ff ff       	call   80116c <dev_lookup>
  80121b:	89 c3                	mov    %eax,%ebx
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	78 1a                	js     80123e <fd_close+0x77>
		if (dev->dev_close)
  801224:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801227:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80122a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80122f:	85 c0                	test   %eax,%eax
  801231:	74 0b                	je     80123e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	56                   	push   %esi
  801237:	ff d0                	call   *%eax
  801239:	89 c3                	mov    %eax,%ebx
  80123b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	56                   	push   %esi
  801242:	6a 00                	push   $0x0
  801244:	e8 ea fb ff ff       	call   800e33 <sys_page_unmap>
	return r;
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	eb b5                	jmp    801203 <fd_close+0x3c>

0080124e <close>:

int
close(int fdnum)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 bc fe ff ff       	call   80111c <fd_lookup>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	79 02                	jns    801269 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    
		return fd_close(fd, 1);
  801269:	83 ec 08             	sub    $0x8,%esp
  80126c:	6a 01                	push   $0x1
  80126e:	ff 75 f4             	pushl  -0xc(%ebp)
  801271:	e8 51 ff ff ff       	call   8011c7 <fd_close>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	eb ec                	jmp    801267 <close+0x19>

0080127b <close_all>:

void
close_all(void)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	53                   	push   %ebx
  80127f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801282:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	53                   	push   %ebx
  80128b:	e8 be ff ff ff       	call   80124e <close>
	for (i = 0; i < MAXFD; i++)
  801290:	83 c3 01             	add    $0x1,%ebx
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	83 fb 20             	cmp    $0x20,%ebx
  801299:	75 ec                	jne    801287 <close_all+0xc>
}
  80129b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	57                   	push   %edi
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	ff 75 08             	pushl  0x8(%ebp)
  8012b0:	e8 67 fe ff ff       	call   80111c <fd_lookup>
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	0f 88 81 00 00 00    	js     801343 <dup+0xa3>
		return r;
	close(newfdnum);
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	ff 75 0c             	pushl  0xc(%ebp)
  8012c8:	e8 81 ff ff ff       	call   80124e <close>

	newfd = INDEX2FD(newfdnum);
  8012cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d0:	c1 e6 0c             	shl    $0xc,%esi
  8012d3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012df:	e8 cf fd ff ff       	call   8010b3 <fd2data>
  8012e4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e6:	89 34 24             	mov    %esi,(%esp)
  8012e9:	e8 c5 fd ff ff       	call   8010b3 <fd2data>
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f3:	89 d8                	mov    %ebx,%eax
  8012f5:	c1 e8 16             	shr    $0x16,%eax
  8012f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ff:	a8 01                	test   $0x1,%al
  801301:	74 11                	je     801314 <dup+0x74>
  801303:	89 d8                	mov    %ebx,%eax
  801305:	c1 e8 0c             	shr    $0xc,%eax
  801308:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80130f:	f6 c2 01             	test   $0x1,%dl
  801312:	75 39                	jne    80134d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e8 0c             	shr    $0xc,%eax
  80131c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	25 07 0e 00 00       	and    $0xe07,%eax
  80132b:	50                   	push   %eax
  80132c:	56                   	push   %esi
  80132d:	6a 00                	push   $0x0
  80132f:	52                   	push   %edx
  801330:	6a 00                	push   $0x0
  801332:	e8 ba fa ff ff       	call   800df1 <sys_page_map>
  801337:	89 c3                	mov    %eax,%ebx
  801339:	83 c4 20             	add    $0x20,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 31                	js     801371 <dup+0xd1>
		goto err;

	return newfdnum;
  801340:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801343:	89 d8                	mov    %ebx,%eax
  801345:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801348:	5b                   	pop    %ebx
  801349:	5e                   	pop    %esi
  80134a:	5f                   	pop    %edi
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	25 07 0e 00 00       	and    $0xe07,%eax
  80135c:	50                   	push   %eax
  80135d:	57                   	push   %edi
  80135e:	6a 00                	push   $0x0
  801360:	53                   	push   %ebx
  801361:	6a 00                	push   $0x0
  801363:	e8 89 fa ff ff       	call   800df1 <sys_page_map>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	83 c4 20             	add    $0x20,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	79 a3                	jns    801314 <dup+0x74>
	sys_page_unmap(0, newfd);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	56                   	push   %esi
  801375:	6a 00                	push   $0x0
  801377:	e8 b7 fa ff ff       	call   800e33 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80137c:	83 c4 08             	add    $0x8,%esp
  80137f:	57                   	push   %edi
  801380:	6a 00                	push   $0x0
  801382:	e8 ac fa ff ff       	call   800e33 <sys_page_unmap>
	return r;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	eb b7                	jmp    801343 <dup+0xa3>

0080138c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	53                   	push   %ebx
  801390:	83 ec 1c             	sub    $0x1c,%esp
  801393:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801396:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801399:	50                   	push   %eax
  80139a:	53                   	push   %ebx
  80139b:	e8 7c fd ff ff       	call   80111c <fd_lookup>
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 3f                	js     8013e6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	ff 30                	pushl  (%eax)
  8013b3:	e8 b4 fd ff ff       	call   80116c <dev_lookup>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 27                	js     8013e6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c2:	8b 42 08             	mov    0x8(%edx),%eax
  8013c5:	83 e0 03             	and    $0x3,%eax
  8013c8:	83 f8 01             	cmp    $0x1,%eax
  8013cb:	74 1e                	je     8013eb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d0:	8b 40 08             	mov    0x8(%eax),%eax
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	74 35                	je     80140c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	ff 75 10             	pushl  0x10(%ebp)
  8013dd:	ff 75 0c             	pushl  0xc(%ebp)
  8013e0:	52                   	push   %edx
  8013e1:	ff d0                	call   *%eax
  8013e3:	83 c4 10             	add    $0x10,%esp
}
  8013e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f0:	8b 40 48             	mov    0x48(%eax),%eax
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	53                   	push   %ebx
  8013f7:	50                   	push   %eax
  8013f8:	68 95 2a 80 00       	push   $0x802a95
  8013fd:	e8 5b ee ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140a:	eb da                	jmp    8013e6 <read+0x5a>
		return -E_NOT_SUPP;
  80140c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801411:	eb d3                	jmp    8013e6 <read+0x5a>

00801413 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	57                   	push   %edi
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
  801419:	83 ec 0c             	sub    $0xc,%esp
  80141c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80141f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801422:	bb 00 00 00 00       	mov    $0x0,%ebx
  801427:	39 f3                	cmp    %esi,%ebx
  801429:	73 23                	jae    80144e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	89 f0                	mov    %esi,%eax
  801430:	29 d8                	sub    %ebx,%eax
  801432:	50                   	push   %eax
  801433:	89 d8                	mov    %ebx,%eax
  801435:	03 45 0c             	add    0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	57                   	push   %edi
  80143a:	e8 4d ff ff ff       	call   80138c <read>
		if (m < 0)
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	78 06                	js     80144c <readn+0x39>
			return m;
		if (m == 0)
  801446:	74 06                	je     80144e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801448:	01 c3                	add    %eax,%ebx
  80144a:	eb db                	jmp    801427 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80144e:	89 d8                	mov    %ebx,%eax
  801450:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801453:	5b                   	pop    %ebx
  801454:	5e                   	pop    %esi
  801455:	5f                   	pop    %edi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	53                   	push   %ebx
  80145c:	83 ec 1c             	sub    $0x1c,%esp
  80145f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801462:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	53                   	push   %ebx
  801467:	e8 b0 fc ff ff       	call   80111c <fd_lookup>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 3a                	js     8014ad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147d:	ff 30                	pushl  (%eax)
  80147f:	e8 e8 fc ff ff       	call   80116c <dev_lookup>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 22                	js     8014ad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801492:	74 1e                	je     8014b2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801497:	8b 52 0c             	mov    0xc(%edx),%edx
  80149a:	85 d2                	test   %edx,%edx
  80149c:	74 35                	je     8014d3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	ff 75 10             	pushl  0x10(%ebp)
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	50                   	push   %eax
  8014a8:	ff d2                	call   *%edx
  8014aa:	83 c4 10             	add    $0x10,%esp
}
  8014ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b7:	8b 40 48             	mov    0x48(%eax),%eax
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	53                   	push   %ebx
  8014be:	50                   	push   %eax
  8014bf:	68 b1 2a 80 00       	push   $0x802ab1
  8014c4:	e8 94 ed ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d1:	eb da                	jmp    8014ad <write+0x55>
		return -E_NOT_SUPP;
  8014d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d8:	eb d3                	jmp    8014ad <write+0x55>

008014da <seek>:

int
seek(int fdnum, off_t offset)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	ff 75 08             	pushl  0x8(%ebp)
  8014e7:	e8 30 fc ff ff       	call   80111c <fd_lookup>
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 0e                	js     801501 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	53                   	push   %ebx
  801507:	83 ec 1c             	sub    $0x1c,%esp
  80150a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	53                   	push   %ebx
  801512:	e8 05 fc ff ff       	call   80111c <fd_lookup>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 37                	js     801555 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801528:	ff 30                	pushl  (%eax)
  80152a:	e8 3d fc ff ff       	call   80116c <dev_lookup>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 1f                	js     801555 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153d:	74 1b                	je     80155a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801542:	8b 52 18             	mov    0x18(%edx),%edx
  801545:	85 d2                	test   %edx,%edx
  801547:	74 32                	je     80157b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	50                   	push   %eax
  801550:	ff d2                	call   *%edx
  801552:	83 c4 10             	add    $0x10,%esp
}
  801555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801558:	c9                   	leave  
  801559:	c3                   	ret    
			thisenv->env_id, fdnum);
  80155a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80155f:	8b 40 48             	mov    0x48(%eax),%eax
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	53                   	push   %ebx
  801566:	50                   	push   %eax
  801567:	68 74 2a 80 00       	push   $0x802a74
  80156c:	e8 ec ec ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801579:	eb da                	jmp    801555 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80157b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801580:	eb d3                	jmp    801555 <ftruncate+0x52>

00801582 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	53                   	push   %ebx
  801586:	83 ec 1c             	sub    $0x1c,%esp
  801589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 84 fb ff ff       	call   80111c <fd_lookup>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 4b                	js     8015ea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	ff 30                	pushl  (%eax)
  8015ab:	e8 bc fb ff ff       	call   80116c <dev_lookup>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 33                	js     8015ea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015be:	74 2f                	je     8015ef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ca:	00 00 00 
	stat->st_isdir = 0;
  8015cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d4:	00 00 00 
	stat->st_dev = dev;
  8015d7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	53                   	push   %ebx
  8015e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e4:	ff 50 14             	call   *0x14(%eax)
  8015e7:	83 c4 10             	add    $0x10,%esp
}
  8015ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f4:	eb f4                	jmp    8015ea <fstat+0x68>

008015f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	56                   	push   %esi
  8015fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	6a 00                	push   $0x0
  801600:	ff 75 08             	pushl  0x8(%ebp)
  801603:	e8 22 02 00 00       	call   80182a <open>
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 1b                	js     80162c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	50                   	push   %eax
  801618:	e8 65 ff ff ff       	call   801582 <fstat>
  80161d:	89 c6                	mov    %eax,%esi
	close(fd);
  80161f:	89 1c 24             	mov    %ebx,(%esp)
  801622:	e8 27 fc ff ff       	call   80124e <close>
	return r;
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	89 f3                	mov    %esi,%ebx
}
  80162c:	89 d8                	mov    %ebx,%eax
  80162e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
  80163a:	89 c6                	mov    %eax,%esi
  80163c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801645:	74 27                	je     80166e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801647:	6a 07                	push   $0x7
  801649:	68 00 50 80 00       	push   $0x805000
  80164e:	56                   	push   %esi
  80164f:	ff 35 00 40 80 00    	pushl  0x804000
  801655:	e8 69 0c 00 00       	call   8022c3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165a:	83 c4 0c             	add    $0xc,%esp
  80165d:	6a 00                	push   $0x0
  80165f:	53                   	push   %ebx
  801660:	6a 00                	push   $0x0
  801662:	e8 f3 0b 00 00       	call   80225a <ipc_recv>
}
  801667:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	6a 01                	push   $0x1
  801673:	e8 a3 0c 00 00       	call   80231b <ipc_find_env>
  801678:	a3 00 40 80 00       	mov    %eax,0x804000
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	eb c5                	jmp    801647 <fsipc+0x12>

00801682 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 40 0c             	mov    0xc(%eax),%eax
  80168e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80169b:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a5:	e8 8b ff ff ff       	call   801635 <fsipc>
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <devfile_flush>:
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c7:	e8 69 ff ff ff       	call   801635 <fsipc>
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <devfile_stat>:
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8b 40 0c             	mov    0xc(%eax),%eax
  8016de:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e8:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ed:	e8 43 ff ff ff       	call   801635 <fsipc>
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 2c                	js     801722 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	68 00 50 80 00       	push   $0x805000
  8016fe:	53                   	push   %ebx
  8016ff:	e8 b8 f2 ff ff       	call   8009bc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801704:	a1 80 50 80 00       	mov    0x805080,%eax
  801709:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80170f:	a1 84 50 80 00       	mov    0x805084,%eax
  801714:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <devfile_write>:
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 40 0c             	mov    0xc(%eax),%eax
  801737:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80173c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801742:	53                   	push   %ebx
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	68 08 50 80 00       	push   $0x805008
  80174b:	e8 5c f4 ff ff       	call   800bac <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	b8 04 00 00 00       	mov    $0x4,%eax
  80175a:	e8 d6 fe ff ff       	call   801635 <fsipc>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 0b                	js     801771 <devfile_write+0x4a>
	assert(r <= n);
  801766:	39 d8                	cmp    %ebx,%eax
  801768:	77 0c                	ja     801776 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80176a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176f:	7f 1e                	jg     80178f <devfile_write+0x68>
}
  801771:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801774:	c9                   	leave  
  801775:	c3                   	ret    
	assert(r <= n);
  801776:	68 e4 2a 80 00       	push   $0x802ae4
  80177b:	68 eb 2a 80 00       	push   $0x802aeb
  801780:	68 98 00 00 00       	push   $0x98
  801785:	68 00 2b 80 00       	push   $0x802b00
  80178a:	e8 6a 0a 00 00       	call   8021f9 <_panic>
	assert(r <= PGSIZE);
  80178f:	68 0b 2b 80 00       	push   $0x802b0b
  801794:	68 eb 2a 80 00       	push   $0x802aeb
  801799:	68 99 00 00 00       	push   $0x99
  80179e:	68 00 2b 80 00       	push   $0x802b00
  8017a3:	e8 51 0a 00 00       	call   8021f9 <_panic>

008017a8 <devfile_read>:
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017bb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8017cb:	e8 65 fe ff ff       	call   801635 <fsipc>
  8017d0:	89 c3                	mov    %eax,%ebx
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 1f                	js     8017f5 <devfile_read+0x4d>
	assert(r <= n);
  8017d6:	39 f0                	cmp    %esi,%eax
  8017d8:	77 24                	ja     8017fe <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017df:	7f 33                	jg     801814 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	50                   	push   %eax
  8017e5:	68 00 50 80 00       	push   $0x805000
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	e8 58 f3 ff ff       	call   800b4a <memmove>
	return r;
  8017f2:	83 c4 10             	add    $0x10,%esp
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
	assert(r <= n);
  8017fe:	68 e4 2a 80 00       	push   $0x802ae4
  801803:	68 eb 2a 80 00       	push   $0x802aeb
  801808:	6a 7c                	push   $0x7c
  80180a:	68 00 2b 80 00       	push   $0x802b00
  80180f:	e8 e5 09 00 00       	call   8021f9 <_panic>
	assert(r <= PGSIZE);
  801814:	68 0b 2b 80 00       	push   $0x802b0b
  801819:	68 eb 2a 80 00       	push   $0x802aeb
  80181e:	6a 7d                	push   $0x7d
  801820:	68 00 2b 80 00       	push   $0x802b00
  801825:	e8 cf 09 00 00       	call   8021f9 <_panic>

0080182a <open>:
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	83 ec 1c             	sub    $0x1c,%esp
  801832:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801835:	56                   	push   %esi
  801836:	e8 48 f1 ff ff       	call   800983 <strlen>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801843:	7f 6c                	jg     8018b1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	e8 79 f8 ff ff       	call   8010ca <fd_alloc>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 3c                	js     801896 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	56                   	push   %esi
  80185e:	68 00 50 80 00       	push   $0x805000
  801863:	e8 54 f1 ff ff       	call   8009bc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801873:	b8 01 00 00 00       	mov    $0x1,%eax
  801878:	e8 b8 fd ff ff       	call   801635 <fsipc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 19                	js     80189f <open+0x75>
	return fd2num(fd);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	ff 75 f4             	pushl  -0xc(%ebp)
  80188c:	e8 12 f8 ff ff       	call   8010a3 <fd2num>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	89 d8                	mov    %ebx,%eax
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
		fd_close(fd, 0);
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a7:	e8 1b f9 ff ff       	call   8011c7 <fd_close>
		return r;
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	eb e5                	jmp    801896 <open+0x6c>
		return -E_BAD_PATH;
  8018b1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018b6:	eb de                	jmp    801896 <open+0x6c>

008018b8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018be:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c8:	e8 68 fd ff ff       	call   801635 <fsipc>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018d5:	68 17 2b 80 00       	push   $0x802b17
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	e8 da f0 ff ff       	call   8009bc <strcpy>
	return 0;
}
  8018e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <devsock_close>:
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	53                   	push   %ebx
  8018ed:	83 ec 10             	sub    $0x10,%esp
  8018f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018f3:	53                   	push   %ebx
  8018f4:	e8 5d 0a 00 00       	call   802356 <pageref>
  8018f9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018fc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801901:	83 f8 01             	cmp    $0x1,%eax
  801904:	74 07                	je     80190d <devsock_close+0x24>
}
  801906:	89 d0                	mov    %edx,%eax
  801908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	ff 73 0c             	pushl  0xc(%ebx)
  801913:	e8 b9 02 00 00       	call   801bd1 <nsipc_close>
  801918:	89 c2                	mov    %eax,%edx
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	eb e7                	jmp    801906 <devsock_close+0x1d>

0080191f <devsock_write>:
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801925:	6a 00                	push   $0x0
  801927:	ff 75 10             	pushl  0x10(%ebp)
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	ff 70 0c             	pushl  0xc(%eax)
  801933:	e8 76 03 00 00       	call   801cae <nsipc_send>
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <devsock_read>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801940:	6a 00                	push   $0x0
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	ff 70 0c             	pushl  0xc(%eax)
  80194e:	e8 ef 02 00 00       	call   801c42 <nsipc_recv>
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <fd2sockid>:
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80195b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	e8 b7 f7 ff ff       	call   80111c <fd_lookup>
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 10                	js     80197c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80196c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801975:	39 08                	cmp    %ecx,(%eax)
  801977:	75 05                	jne    80197e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801979:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    
		return -E_NOT_SUPP;
  80197e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801983:	eb f7                	jmp    80197c <fd2sockid+0x27>

00801985 <alloc_sockfd>:
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
  80198a:	83 ec 1c             	sub    $0x1c,%esp
  80198d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80198f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801992:	50                   	push   %eax
  801993:	e8 32 f7 ff ff       	call   8010ca <fd_alloc>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 43                	js     8019e4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	68 07 04 00 00       	push   $0x407
  8019a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ac:	6a 00                	push   $0x0
  8019ae:	e8 fb f3 ff ff       	call   800dae <sys_page_alloc>
  8019b3:	89 c3                	mov    %eax,%ebx
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 28                	js     8019e4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019c5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019d1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	50                   	push   %eax
  8019d8:	e8 c6 f6 ff ff       	call   8010a3 <fd2num>
  8019dd:	89 c3                	mov    %eax,%ebx
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	eb 0c                	jmp    8019f0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019e4:	83 ec 0c             	sub    $0xc,%esp
  8019e7:	56                   	push   %esi
  8019e8:	e8 e4 01 00 00       	call   801bd1 <nsipc_close>
		return r;
  8019ed:	83 c4 10             	add    $0x10,%esp
}
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f5:	5b                   	pop    %ebx
  8019f6:	5e                   	pop    %esi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    

008019f9 <accept>:
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	e8 4e ff ff ff       	call   801955 <fd2sockid>
  801a07:	85 c0                	test   %eax,%eax
  801a09:	78 1b                	js     801a26 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	50                   	push   %eax
  801a15:	e8 0e 01 00 00       	call   801b28 <nsipc_accept>
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 05                	js     801a26 <accept+0x2d>
	return alloc_sockfd(r);
  801a21:	e8 5f ff ff ff       	call   801985 <alloc_sockfd>
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <bind>:
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	e8 1f ff ff ff       	call   801955 <fd2sockid>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 12                	js     801a4c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	ff 75 10             	pushl  0x10(%ebp)
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	50                   	push   %eax
  801a44:	e8 31 01 00 00       	call   801b7a <nsipc_bind>
  801a49:	83 c4 10             	add    $0x10,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <shutdown>:
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	e8 f9 fe ff ff       	call   801955 <fd2sockid>
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 0f                	js     801a6f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	e8 43 01 00 00       	call   801baf <nsipc_shutdown>
  801a6c:	83 c4 10             	add    $0x10,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <connect>:
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	e8 d6 fe ff ff       	call   801955 <fd2sockid>
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 12                	js     801a95 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	e8 59 01 00 00       	call   801beb <nsipc_connect>
  801a92:	83 c4 10             	add    $0x10,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <listen>:
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	e8 b0 fe ff ff       	call   801955 <fd2sockid>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 0f                	js     801ab8 <listen+0x21>
	return nsipc_listen(r, backlog);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	50                   	push   %eax
  801ab0:	e8 6b 01 00 00       	call   801c20 <nsipc_listen>
  801ab5:	83 c4 10             	add    $0x10,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <socket>:

int
socket(int domain, int type, int protocol)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ac0:	ff 75 10             	pushl  0x10(%ebp)
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	e8 3e 02 00 00       	call   801d0c <nsipc_socket>
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	78 05                	js     801ada <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ad5:	e8 ab fe ff ff       	call   801985 <alloc_sockfd>
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ae5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aec:	74 26                	je     801b14 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aee:	6a 07                	push   $0x7
  801af0:	68 00 60 80 00       	push   $0x806000
  801af5:	53                   	push   %ebx
  801af6:	ff 35 04 40 80 00    	pushl  0x804004
  801afc:	e8 c2 07 00 00       	call   8022c3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b01:	83 c4 0c             	add    $0xc,%esp
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 4b 07 00 00       	call   80225a <ipc_recv>
}
  801b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	6a 02                	push   $0x2
  801b19:	e8 fd 07 00 00       	call   80231b <ipc_find_env>
  801b1e:	a3 04 40 80 00       	mov    %eax,0x804004
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	eb c6                	jmp    801aee <nsipc+0x12>

00801b28 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b38:	8b 06                	mov    (%esi),%eax
  801b3a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b44:	e8 93 ff ff ff       	call   801adc <nsipc>
  801b49:	89 c3                	mov    %eax,%ebx
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	79 09                	jns    801b58 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b4f:	89 d8                	mov    %ebx,%eax
  801b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	ff 35 10 60 80 00    	pushl  0x806010
  801b61:	68 00 60 80 00       	push   $0x806000
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	e8 dc ef ff ff       	call   800b4a <memmove>
		*addrlen = ret->ret_addrlen;
  801b6e:	a1 10 60 80 00       	mov    0x806010,%eax
  801b73:	89 06                	mov    %eax,(%esi)
  801b75:	83 c4 10             	add    $0x10,%esp
	return r;
  801b78:	eb d5                	jmp    801b4f <nsipc_accept+0x27>

00801b7a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b8c:	53                   	push   %ebx
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	68 04 60 80 00       	push   $0x806004
  801b95:	e8 b0 ef ff ff       	call   800b4a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b9a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ba0:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba5:	e8 32 ff ff ff       	call   801adc <nsipc>
}
  801baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bc5:	b8 03 00 00 00       	mov    $0x3,%eax
  801bca:	e8 0d ff ff ff       	call   801adc <nsipc>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <nsipc_close>:

int
nsipc_close(int s)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bdf:	b8 04 00 00 00       	mov    $0x4,%eax
  801be4:	e8 f3 fe ff ff       	call   801adc <nsipc>
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	53                   	push   %ebx
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bfd:	53                   	push   %ebx
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	68 04 60 80 00       	push   $0x806004
  801c06:	e8 3f ef ff ff       	call   800b4a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c0b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c11:	b8 05 00 00 00       	mov    $0x5,%eax
  801c16:	e8 c1 fe ff ff       	call   801adc <nsipc>
}
  801c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c31:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c36:	b8 06 00 00 00       	mov    $0x6,%eax
  801c3b:	e8 9c fe ff ff       	call   801adc <nsipc>
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	56                   	push   %esi
  801c46:	53                   	push   %ebx
  801c47:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c52:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c58:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c60:	b8 07 00 00 00       	mov    $0x7,%eax
  801c65:	e8 72 fe ff ff       	call   801adc <nsipc>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 1f                	js     801c8f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c75:	7f 21                	jg     801c98 <nsipc_recv+0x56>
  801c77:	39 c6                	cmp    %eax,%esi
  801c79:	7c 1d                	jl     801c98 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	50                   	push   %eax
  801c7f:	68 00 60 80 00       	push   $0x806000
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	e8 be ee ff ff       	call   800b4a <memmove>
  801c8c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c8f:	89 d8                	mov    %ebx,%eax
  801c91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c98:	68 23 2b 80 00       	push   $0x802b23
  801c9d:	68 eb 2a 80 00       	push   $0x802aeb
  801ca2:	6a 62                	push   $0x62
  801ca4:	68 38 2b 80 00       	push   $0x802b38
  801ca9:	e8 4b 05 00 00       	call   8021f9 <_panic>

00801cae <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	53                   	push   %ebx
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cc0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cc6:	7f 2e                	jg     801cf6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	53                   	push   %ebx
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	68 0c 60 80 00       	push   $0x80600c
  801cd4:	e8 71 ee ff ff       	call   800b4a <memmove>
	nsipcbuf.send.req_size = size;
  801cd9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ce7:	b8 08 00 00 00       	mov    $0x8,%eax
  801cec:	e8 eb fd ff ff       	call   801adc <nsipc>
}
  801cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    
	assert(size < 1600);
  801cf6:	68 44 2b 80 00       	push   $0x802b44
  801cfb:	68 eb 2a 80 00       	push   $0x802aeb
  801d00:	6a 6d                	push   $0x6d
  801d02:	68 38 2b 80 00       	push   $0x802b38
  801d07:	e8 ed 04 00 00       	call   8021f9 <_panic>

00801d0c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d22:	8b 45 10             	mov    0x10(%ebp),%eax
  801d25:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d2a:	b8 09 00 00 00       	mov    $0x9,%eax
  801d2f:	e8 a8 fd ff ff       	call   801adc <nsipc>
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	56                   	push   %esi
  801d3a:	53                   	push   %ebx
  801d3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	e8 6a f3 ff ff       	call   8010b3 <fd2data>
  801d49:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d4b:	83 c4 08             	add    $0x8,%esp
  801d4e:	68 50 2b 80 00       	push   $0x802b50
  801d53:	53                   	push   %ebx
  801d54:	e8 63 ec ff ff       	call   8009bc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d59:	8b 46 04             	mov    0x4(%esi),%eax
  801d5c:	2b 06                	sub    (%esi),%eax
  801d5e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d64:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6b:	00 00 00 
	stat->st_dev = &devpipe;
  801d6e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d75:	30 80 00 
	return 0;
}
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	53                   	push   %ebx
  801d88:	83 ec 0c             	sub    $0xc,%esp
  801d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d8e:	53                   	push   %ebx
  801d8f:	6a 00                	push   $0x0
  801d91:	e8 9d f0 ff ff       	call   800e33 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d96:	89 1c 24             	mov    %ebx,(%esp)
  801d99:	e8 15 f3 ff ff       	call   8010b3 <fd2data>
  801d9e:	83 c4 08             	add    $0x8,%esp
  801da1:	50                   	push   %eax
  801da2:	6a 00                	push   $0x0
  801da4:	e8 8a f0 ff ff       	call   800e33 <sys_page_unmap>
}
  801da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <_pipeisclosed>:
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	57                   	push   %edi
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 1c             	sub    $0x1c,%esp
  801db7:	89 c7                	mov    %eax,%edi
  801db9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dbb:	a1 08 40 80 00       	mov    0x804008,%eax
  801dc0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	57                   	push   %edi
  801dc7:	e8 8a 05 00 00       	call   802356 <pageref>
  801dcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dcf:	89 34 24             	mov    %esi,(%esp)
  801dd2:	e8 7f 05 00 00       	call   802356 <pageref>
		nn = thisenv->env_runs;
  801dd7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ddd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	39 cb                	cmp    %ecx,%ebx
  801de5:	74 1b                	je     801e02 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801de7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dea:	75 cf                	jne    801dbb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dec:	8b 42 58             	mov    0x58(%edx),%eax
  801def:	6a 01                	push   $0x1
  801df1:	50                   	push   %eax
  801df2:	53                   	push   %ebx
  801df3:	68 57 2b 80 00       	push   $0x802b57
  801df8:	e8 60 e4 ff ff       	call   80025d <cprintf>
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	eb b9                	jmp    801dbb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e02:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e05:	0f 94 c0             	sete   %al
  801e08:	0f b6 c0             	movzbl %al,%eax
}
  801e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5f                   	pop    %edi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <devpipe_write>:
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	57                   	push   %edi
  801e17:	56                   	push   %esi
  801e18:	53                   	push   %ebx
  801e19:	83 ec 28             	sub    $0x28,%esp
  801e1c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e1f:	56                   	push   %esi
  801e20:	e8 8e f2 ff ff       	call   8010b3 <fd2data>
  801e25:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e32:	74 4f                	je     801e83 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e34:	8b 43 04             	mov    0x4(%ebx),%eax
  801e37:	8b 0b                	mov    (%ebx),%ecx
  801e39:	8d 51 20             	lea    0x20(%ecx),%edx
  801e3c:	39 d0                	cmp    %edx,%eax
  801e3e:	72 14                	jb     801e54 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e40:	89 da                	mov    %ebx,%edx
  801e42:	89 f0                	mov    %esi,%eax
  801e44:	e8 65 ff ff ff       	call   801dae <_pipeisclosed>
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	75 3b                	jne    801e88 <devpipe_write+0x75>
			sys_yield();
  801e4d:	e8 3d ef ff ff       	call   800d8f <sys_yield>
  801e52:	eb e0                	jmp    801e34 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e57:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e5b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e5e:	89 c2                	mov    %eax,%edx
  801e60:	c1 fa 1f             	sar    $0x1f,%edx
  801e63:	89 d1                	mov    %edx,%ecx
  801e65:	c1 e9 1b             	shr    $0x1b,%ecx
  801e68:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e6b:	83 e2 1f             	and    $0x1f,%edx
  801e6e:	29 ca                	sub    %ecx,%edx
  801e70:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e74:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e78:	83 c0 01             	add    $0x1,%eax
  801e7b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e7e:	83 c7 01             	add    $0x1,%edi
  801e81:	eb ac                	jmp    801e2f <devpipe_write+0x1c>
	return i;
  801e83:	8b 45 10             	mov    0x10(%ebp),%eax
  801e86:	eb 05                	jmp    801e8d <devpipe_write+0x7a>
				return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    

00801e95 <devpipe_read>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	57                   	push   %edi
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 18             	sub    $0x18,%esp
  801e9e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ea1:	57                   	push   %edi
  801ea2:	e8 0c f2 ff ff       	call   8010b3 <fd2data>
  801ea7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	be 00 00 00 00       	mov    $0x0,%esi
  801eb1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb4:	75 14                	jne    801eca <devpipe_read+0x35>
	return i;
  801eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb9:	eb 02                	jmp    801ebd <devpipe_read+0x28>
				return i;
  801ebb:	89 f0                	mov    %esi,%eax
}
  801ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5f                   	pop    %edi
  801ec3:	5d                   	pop    %ebp
  801ec4:	c3                   	ret    
			sys_yield();
  801ec5:	e8 c5 ee ff ff       	call   800d8f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eca:	8b 03                	mov    (%ebx),%eax
  801ecc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ecf:	75 18                	jne    801ee9 <devpipe_read+0x54>
			if (i > 0)
  801ed1:	85 f6                	test   %esi,%esi
  801ed3:	75 e6                	jne    801ebb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ed5:	89 da                	mov    %ebx,%edx
  801ed7:	89 f8                	mov    %edi,%eax
  801ed9:	e8 d0 fe ff ff       	call   801dae <_pipeisclosed>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	74 e3                	je     801ec5 <devpipe_read+0x30>
				return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	eb d4                	jmp    801ebd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee9:	99                   	cltd   
  801eea:	c1 ea 1b             	shr    $0x1b,%edx
  801eed:	01 d0                	add    %edx,%eax
  801eef:	83 e0 1f             	and    $0x1f,%eax
  801ef2:	29 d0                	sub    %edx,%eax
  801ef4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801efc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eff:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f02:	83 c6 01             	add    $0x1,%esi
  801f05:	eb aa                	jmp    801eb1 <devpipe_read+0x1c>

00801f07 <pipe>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f12:	50                   	push   %eax
  801f13:	e8 b2 f1 ff ff       	call   8010ca <fd_alloc>
  801f18:	89 c3                	mov    %eax,%ebx
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 23 01 00 00    	js     802048 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 07 04 00 00       	push   $0x407
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	6a 00                	push   $0x0
  801f32:	e8 77 ee ff ff       	call   800dae <sys_page_alloc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	0f 88 04 01 00 00    	js     802048 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f4a:	50                   	push   %eax
  801f4b:	e8 7a f1 ff ff       	call   8010ca <fd_alloc>
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	0f 88 db 00 00 00    	js     802038 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	68 07 04 00 00       	push   $0x407
  801f65:	ff 75 f0             	pushl  -0x10(%ebp)
  801f68:	6a 00                	push   $0x0
  801f6a:	e8 3f ee ff ff       	call   800dae <sys_page_alloc>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	0f 88 bc 00 00 00    	js     802038 <pipe+0x131>
	va = fd2data(fd0);
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f82:	e8 2c f1 ff ff       	call   8010b3 <fd2data>
  801f87:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f89:	83 c4 0c             	add    $0xc,%esp
  801f8c:	68 07 04 00 00       	push   $0x407
  801f91:	50                   	push   %eax
  801f92:	6a 00                	push   $0x0
  801f94:	e8 15 ee ff ff       	call   800dae <sys_page_alloc>
  801f99:	89 c3                	mov    %eax,%ebx
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	0f 88 82 00 00 00    	js     802028 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fac:	e8 02 f1 ff ff       	call   8010b3 <fd2data>
  801fb1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fb8:	50                   	push   %eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	56                   	push   %esi
  801fbc:	6a 00                	push   $0x0
  801fbe:	e8 2e ee ff ff       	call   800df1 <sys_page_map>
  801fc3:	89 c3                	mov    %eax,%ebx
  801fc5:	83 c4 20             	add    $0x20,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 4e                	js     80201a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fcc:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fe0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff5:	e8 a9 f0 ff ff       	call   8010a3 <fd2num>
  801ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ffd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fff:	83 c4 04             	add    $0x4,%esp
  802002:	ff 75 f0             	pushl  -0x10(%ebp)
  802005:	e8 99 f0 ff ff       	call   8010a3 <fd2num>
  80200a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	bb 00 00 00 00       	mov    $0x0,%ebx
  802018:	eb 2e                	jmp    802048 <pipe+0x141>
	sys_page_unmap(0, va);
  80201a:	83 ec 08             	sub    $0x8,%esp
  80201d:	56                   	push   %esi
  80201e:	6a 00                	push   $0x0
  802020:	e8 0e ee ff ff       	call   800e33 <sys_page_unmap>
  802025:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	ff 75 f0             	pushl  -0x10(%ebp)
  80202e:	6a 00                	push   $0x0
  802030:	e8 fe ed ff ff       	call   800e33 <sys_page_unmap>
  802035:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802038:	83 ec 08             	sub    $0x8,%esp
  80203b:	ff 75 f4             	pushl  -0xc(%ebp)
  80203e:	6a 00                	push   $0x0
  802040:	e8 ee ed ff ff       	call   800e33 <sys_page_unmap>
  802045:	83 c4 10             	add    $0x10,%esp
}
  802048:	89 d8                	mov    %ebx,%eax
  80204a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <pipeisclosed>:
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802057:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205a:	50                   	push   %eax
  80205b:	ff 75 08             	pushl  0x8(%ebp)
  80205e:	e8 b9 f0 ff ff       	call   80111c <fd_lookup>
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	85 c0                	test   %eax,%eax
  802068:	78 18                	js     802082 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	ff 75 f4             	pushl  -0xc(%ebp)
  802070:	e8 3e f0 ff ff       	call   8010b3 <fd2data>
	return _pipeisclosed(fd, p);
  802075:	89 c2                	mov    %eax,%edx
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207a:	e8 2f fd ff ff       	call   801dae <_pipeisclosed>
  80207f:	83 c4 10             	add    $0x10,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	c3                   	ret    

0080208a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802090:	68 6f 2b 80 00       	push   $0x802b6f
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	e8 1f e9 ff ff       	call   8009bc <strcpy>
	return 0;
}
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <devcons_write>:
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	57                   	push   %edi
  8020a8:	56                   	push   %esi
  8020a9:	53                   	push   %ebx
  8020aa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020b0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020b5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020be:	73 31                	jae    8020f1 <devcons_write+0x4d>
		m = n - tot;
  8020c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020c3:	29 f3                	sub    %esi,%ebx
  8020c5:	83 fb 7f             	cmp    $0x7f,%ebx
  8020c8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020cd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	53                   	push   %ebx
  8020d4:	89 f0                	mov    %esi,%eax
  8020d6:	03 45 0c             	add    0xc(%ebp),%eax
  8020d9:	50                   	push   %eax
  8020da:	57                   	push   %edi
  8020db:	e8 6a ea ff ff       	call   800b4a <memmove>
		sys_cputs(buf, m);
  8020e0:	83 c4 08             	add    $0x8,%esp
  8020e3:	53                   	push   %ebx
  8020e4:	57                   	push   %edi
  8020e5:	e8 08 ec ff ff       	call   800cf2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ea:	01 de                	add    %ebx,%esi
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	eb ca                	jmp    8020bb <devcons_write+0x17>
}
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f6:	5b                   	pop    %ebx
  8020f7:	5e                   	pop    %esi
  8020f8:	5f                   	pop    %edi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <devcons_read>:
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 08             	sub    $0x8,%esp
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802106:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210a:	74 21                	je     80212d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80210c:	e8 ff eb ff ff       	call   800d10 <sys_cgetc>
  802111:	85 c0                	test   %eax,%eax
  802113:	75 07                	jne    80211c <devcons_read+0x21>
		sys_yield();
  802115:	e8 75 ec ff ff       	call   800d8f <sys_yield>
  80211a:	eb f0                	jmp    80210c <devcons_read+0x11>
	if (c < 0)
  80211c:	78 0f                	js     80212d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80211e:	83 f8 04             	cmp    $0x4,%eax
  802121:	74 0c                	je     80212f <devcons_read+0x34>
	*(char*)vbuf = c;
  802123:	8b 55 0c             	mov    0xc(%ebp),%edx
  802126:	88 02                	mov    %al,(%edx)
	return 1;
  802128:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    
		return 0;
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	eb f7                	jmp    80212d <devcons_read+0x32>

00802136 <cputchar>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802142:	6a 01                	push   $0x1
  802144:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802147:	50                   	push   %eax
  802148:	e8 a5 eb ff ff       	call   800cf2 <sys_cputs>
}
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <getchar>:
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802158:	6a 01                	push   $0x1
  80215a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80215d:	50                   	push   %eax
  80215e:	6a 00                	push   $0x0
  802160:	e8 27 f2 ff ff       	call   80138c <read>
	if (r < 0)
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 06                	js     802172 <getchar+0x20>
	if (r < 1)
  80216c:	74 06                	je     802174 <getchar+0x22>
	return c;
  80216e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    
		return -E_EOF;
  802174:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802179:	eb f7                	jmp    802172 <getchar+0x20>

0080217b <iscons>:
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802181:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802184:	50                   	push   %eax
  802185:	ff 75 08             	pushl  0x8(%ebp)
  802188:	e8 8f ef ff ff       	call   80111c <fd_lookup>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	85 c0                	test   %eax,%eax
  802192:	78 11                	js     8021a5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80219d:	39 10                	cmp    %edx,(%eax)
  80219f:	0f 94 c0             	sete   %al
  8021a2:	0f b6 c0             	movzbl %al,%eax
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <opencons>:
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b0:	50                   	push   %eax
  8021b1:	e8 14 ef ff ff       	call   8010ca <fd_alloc>
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	78 3a                	js     8021f7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	68 07 04 00 00       	push   $0x407
  8021c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c8:	6a 00                	push   $0x0
  8021ca:	e8 df eb ff ff       	call   800dae <sys_page_alloc>
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	78 21                	js     8021f7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021df:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	50                   	push   %eax
  8021ef:	e8 af ee ff ff       	call   8010a3 <fd2num>
  8021f4:	83 c4 10             	add    $0x10,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	56                   	push   %esi
  8021fd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021fe:	a1 08 40 80 00       	mov    0x804008,%eax
  802203:	8b 40 48             	mov    0x48(%eax),%eax
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 a0 2b 80 00       	push   $0x802ba0
  80220e:	50                   	push   %eax
  80220f:	68 87 26 80 00       	push   $0x802687
  802214:	e8 44 e0 ff ff       	call   80025d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802219:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80221c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802222:	e8 49 eb ff ff       	call   800d70 <sys_getenvid>
  802227:	83 c4 04             	add    $0x4,%esp
  80222a:	ff 75 0c             	pushl  0xc(%ebp)
  80222d:	ff 75 08             	pushl  0x8(%ebp)
  802230:	56                   	push   %esi
  802231:	50                   	push   %eax
  802232:	68 7c 2b 80 00       	push   $0x802b7c
  802237:	e8 21 e0 ff ff       	call   80025d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80223c:	83 c4 18             	add    $0x18,%esp
  80223f:	53                   	push   %ebx
  802240:	ff 75 10             	pushl  0x10(%ebp)
  802243:	e8 c4 df ff ff       	call   80020c <vcprintf>
	cprintf("\n");
  802248:	c7 04 24 4b 26 80 00 	movl   $0x80264b,(%esp)
  80224f:	e8 09 e0 ff ff       	call   80025d <cprintf>
  802254:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802257:	cc                   	int3   
  802258:	eb fd                	jmp    802257 <_panic+0x5e>

0080225a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	56                   	push   %esi
  80225e:	53                   	push   %ebx
  80225f:	8b 75 08             	mov    0x8(%ebp),%esi
  802262:	8b 45 0c             	mov    0xc(%ebp),%eax
  802265:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802268:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80226a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80226f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802272:	83 ec 0c             	sub    $0xc,%esp
  802275:	50                   	push   %eax
  802276:	e8 e3 ec ff ff       	call   800f5e <sys_ipc_recv>
	if(ret < 0){
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	85 c0                	test   %eax,%eax
  802280:	78 2b                	js     8022ad <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802282:	85 f6                	test   %esi,%esi
  802284:	74 0a                	je     802290 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802286:	a1 08 40 80 00       	mov    0x804008,%eax
  80228b:	8b 40 74             	mov    0x74(%eax),%eax
  80228e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802290:	85 db                	test   %ebx,%ebx
  802292:	74 0a                	je     80229e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802294:	a1 08 40 80 00       	mov    0x804008,%eax
  802299:	8b 40 78             	mov    0x78(%eax),%eax
  80229c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80229e:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5d                   	pop    %ebp
  8022ac:	c3                   	ret    
		if(from_env_store)
  8022ad:	85 f6                	test   %esi,%esi
  8022af:	74 06                	je     8022b7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022b7:	85 db                	test   %ebx,%ebx
  8022b9:	74 eb                	je     8022a6 <ipc_recv+0x4c>
			*perm_store = 0;
  8022bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022c1:	eb e3                	jmp    8022a6 <ipc_recv+0x4c>

008022c3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	57                   	push   %edi
  8022c7:	56                   	push   %esi
  8022c8:	53                   	push   %ebx
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022d5:	85 db                	test   %ebx,%ebx
  8022d7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022dc:	0f 44 d8             	cmove  %eax,%ebx
  8022df:	eb 05                	jmp    8022e6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022e1:	e8 a9 ea ff ff       	call   800d8f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022e6:	ff 75 14             	pushl  0x14(%ebp)
  8022e9:	53                   	push   %ebx
  8022ea:	56                   	push   %esi
  8022eb:	57                   	push   %edi
  8022ec:	e8 4a ec ff ff       	call   800f3b <sys_ipc_try_send>
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 1b                	je     802313 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022f8:	79 e7                	jns    8022e1 <ipc_send+0x1e>
  8022fa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022fd:	74 e2                	je     8022e1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	68 a7 2b 80 00       	push   $0x802ba7
  802307:	6a 46                	push   $0x46
  802309:	68 bc 2b 80 00       	push   $0x802bbc
  80230e:	e8 e6 fe ff ff       	call   8021f9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802313:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802316:	5b                   	pop    %ebx
  802317:	5e                   	pop    %esi
  802318:	5f                   	pop    %edi
  802319:	5d                   	pop    %ebp
  80231a:	c3                   	ret    

0080231b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802326:	89 c2                	mov    %eax,%edx
  802328:	c1 e2 07             	shl    $0x7,%edx
  80232b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802331:	8b 52 50             	mov    0x50(%edx),%edx
  802334:	39 ca                	cmp    %ecx,%edx
  802336:	74 11                	je     802349 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802338:	83 c0 01             	add    $0x1,%eax
  80233b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802340:	75 e4                	jne    802326 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
  802347:	eb 0b                	jmp    802354 <ipc_find_env+0x39>
			return envs[i].env_id;
  802349:	c1 e0 07             	shl    $0x7,%eax
  80234c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802351:	8b 40 48             	mov    0x48(%eax),%eax
}
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80235c:	89 d0                	mov    %edx,%eax
  80235e:	c1 e8 16             	shr    $0x16,%eax
  802361:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80236d:	f6 c1 01             	test   $0x1,%cl
  802370:	74 1d                	je     80238f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802372:	c1 ea 0c             	shr    $0xc,%edx
  802375:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80237c:	f6 c2 01             	test   $0x1,%dl
  80237f:	74 0e                	je     80238f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802381:	c1 ea 0c             	shr    $0xc,%edx
  802384:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80238b:	ef 
  80238c:	0f b7 c0             	movzwl %ax,%eax
}
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	66 90                	xchg   %ax,%ax
  802393:	66 90                	xchg   %ax,%ax
  802395:	66 90                	xchg   %ax,%ax
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
