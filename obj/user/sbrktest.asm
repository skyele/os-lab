
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
  800094:	68 00 26 80 00       	push   $0x802600
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
  8000ac:	68 e0 25 80 00       	push   $0x8025e0
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
  80013e:	68 0f 26 80 00       	push   $0x80260f
  800143:	e8 15 01 00 00       	call   80025d <cprintf>
	cprintf("before umain\n");
  800148:	c7 04 24 2d 26 80 00 	movl   $0x80262d,(%esp)
  80014f:	e8 09 01 00 00       	call   80025d <cprintf>
	// call user main routine
	umain(argc, argv);
  800154:	83 c4 08             	add    $0x8,%esp
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 d1 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800162:	c7 04 24 3b 26 80 00 	movl   $0x80263b,(%esp)
  800169:	e8 ef 00 00 00       	call   80025d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80016e:	a1 08 40 80 00       	mov    0x804008,%eax
  800173:	8b 40 48             	mov    0x48(%eax),%eax
  800176:	83 c4 08             	add    $0x8,%esp
  800179:	50                   	push   %eax
  80017a:	68 48 26 80 00       	push   $0x802648
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
  8001a2:	68 74 26 80 00       	push   $0x802674
  8001a7:	50                   	push   %eax
  8001a8:	68 67 26 80 00       	push   $0x802667
  8001ad:	e8 ab 00 00 00       	call   80025d <cprintf>
	close_all();
  8001b2:	e8 a4 10 00 00       	call   80125b <close_all>
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
  80030a:	e8 71 20 00 00       	call   802380 <__udivdi3>
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
  800333:	e8 58 21 00 00       	call   802490 <__umoddi3>
  800338:	83 c4 14             	add    $0x14,%esp
  80033b:	0f be 80 79 26 80 00 	movsbl 0x802679(%eax),%eax
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
  8003e4:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
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
  8004af:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	74 18                	je     8004d2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004ba:	52                   	push   %edx
  8004bb:	68 dd 2a 80 00       	push   $0x802add
  8004c0:	53                   	push   %ebx
  8004c1:	56                   	push   %esi
  8004c2:	e8 a6 fe ff ff       	call   80036d <printfmt>
  8004c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004cd:	e9 fe 02 00 00       	jmp    8007d0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d2:	50                   	push   %eax
  8004d3:	68 91 26 80 00       	push   $0x802691
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
  8004fa:	b8 8a 26 80 00       	mov    $0x80268a,%eax
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
  800892:	bf ad 27 80 00       	mov    $0x8027ad,%edi
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
  8008be:	bf e5 27 80 00       	mov    $0x8027e5,%edi
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
  800d5f:	68 08 2a 80 00       	push   $0x802a08
  800d64:	6a 43                	push   $0x43
  800d66:	68 25 2a 80 00       	push   $0x802a25
  800d6b:	e8 69 14 00 00       	call   8021d9 <_panic>

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
  800de0:	68 08 2a 80 00       	push   $0x802a08
  800de5:	6a 43                	push   $0x43
  800de7:	68 25 2a 80 00       	push   $0x802a25
  800dec:	e8 e8 13 00 00       	call   8021d9 <_panic>

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
  800e22:	68 08 2a 80 00       	push   $0x802a08
  800e27:	6a 43                	push   $0x43
  800e29:	68 25 2a 80 00       	push   $0x802a25
  800e2e:	e8 a6 13 00 00       	call   8021d9 <_panic>

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
  800e64:	68 08 2a 80 00       	push   $0x802a08
  800e69:	6a 43                	push   $0x43
  800e6b:	68 25 2a 80 00       	push   $0x802a25
  800e70:	e8 64 13 00 00       	call   8021d9 <_panic>

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
  800ea6:	68 08 2a 80 00       	push   $0x802a08
  800eab:	6a 43                	push   $0x43
  800ead:	68 25 2a 80 00       	push   $0x802a25
  800eb2:	e8 22 13 00 00       	call   8021d9 <_panic>

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
  800ee8:	68 08 2a 80 00       	push   $0x802a08
  800eed:	6a 43                	push   $0x43
  800eef:	68 25 2a 80 00       	push   $0x802a25
  800ef4:	e8 e0 12 00 00       	call   8021d9 <_panic>

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
  800f2a:	68 08 2a 80 00       	push   $0x802a08
  800f2f:	6a 43                	push   $0x43
  800f31:	68 25 2a 80 00       	push   $0x802a25
  800f36:	e8 9e 12 00 00       	call   8021d9 <_panic>

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
  800f8e:	68 08 2a 80 00       	push   $0x802a08
  800f93:	6a 43                	push   $0x43
  800f95:	68 25 2a 80 00       	push   $0x802a25
  800f9a:	e8 3a 12 00 00       	call   8021d9 <_panic>

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
  801072:	68 08 2a 80 00       	push   $0x802a08
  801077:	6a 43                	push   $0x43
  801079:	68 25 2a 80 00       	push   $0x802a25
  80107e:	e8 56 11 00 00       	call   8021d9 <_panic>

00801083 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	05 00 00 00 30       	add    $0x30000000,%eax
  80108e:	c1 e8 0c             	shr    $0xc,%eax
}
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80109e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b2:	89 c2                	mov    %eax,%edx
  8010b4:	c1 ea 16             	shr    $0x16,%edx
  8010b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010be:	f6 c2 01             	test   $0x1,%dl
  8010c1:	74 2d                	je     8010f0 <fd_alloc+0x46>
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	c1 ea 0c             	shr    $0xc,%edx
  8010c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cf:	f6 c2 01             	test   $0x1,%dl
  8010d2:	74 1c                	je     8010f0 <fd_alloc+0x46>
  8010d4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010d9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010de:	75 d2                	jne    8010b2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010e9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ee:	eb 0a                	jmp    8010fa <fd_alloc+0x50>
			*fd_store = fd;
  8010f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801102:	83 f8 1f             	cmp    $0x1f,%eax
  801105:	77 30                	ja     801137 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801107:	c1 e0 0c             	shl    $0xc,%eax
  80110a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80110f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801115:	f6 c2 01             	test   $0x1,%dl
  801118:	74 24                	je     80113e <fd_lookup+0x42>
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	c1 ea 0c             	shr    $0xc,%edx
  80111f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801126:	f6 c2 01             	test   $0x1,%dl
  801129:	74 1a                	je     801145 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80112b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112e:	89 02                	mov    %eax,(%edx)
	return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    
		return -E_INVAL;
  801137:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113c:	eb f7                	jmp    801135 <fd_lookup+0x39>
		return -E_INVAL;
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801143:	eb f0                	jmp    801135 <fd_lookup+0x39>
  801145:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114a:	eb e9                	jmp    801135 <fd_lookup+0x39>

0080114c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801155:	ba 00 00 00 00       	mov    $0x0,%edx
  80115a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80115f:	39 08                	cmp    %ecx,(%eax)
  801161:	74 38                	je     80119b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801163:	83 c2 01             	add    $0x1,%edx
  801166:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  80116d:	85 c0                	test   %eax,%eax
  80116f:	75 ee                	jne    80115f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801171:	a1 08 40 80 00       	mov    0x804008,%eax
  801176:	8b 40 48             	mov    0x48(%eax),%eax
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	51                   	push   %ecx
  80117d:	50                   	push   %eax
  80117e:	68 34 2a 80 00       	push   $0x802a34
  801183:	e8 d5 f0 ff ff       	call   80025d <cprintf>
	*dev = 0;
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    
			*dev = devtab[i];
  80119b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119e:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a5:	eb f2                	jmp    801199 <dev_lookup+0x4d>

008011a7 <fd_close>:
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 24             	sub    $0x24,%esp
  8011b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8011b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ba:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011c0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c3:	50                   	push   %eax
  8011c4:	e8 33 ff ff ff       	call   8010fc <fd_lookup>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 05                	js     8011d7 <fd_close+0x30>
	    || fd != fd2)
  8011d2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011d5:	74 16                	je     8011ed <fd_close+0x46>
		return (must_exist ? r : 0);
  8011d7:	89 f8                	mov    %edi,%eax
  8011d9:	84 c0                	test   %al,%al
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e0:	0f 44 d8             	cmove  %eax,%ebx
}
  8011e3:	89 d8                	mov    %ebx,%eax
  8011e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ed:	83 ec 08             	sub    $0x8,%esp
  8011f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	ff 36                	pushl  (%esi)
  8011f6:	e8 51 ff ff ff       	call   80114c <dev_lookup>
  8011fb:	89 c3                	mov    %eax,%ebx
  8011fd:	83 c4 10             	add    $0x10,%esp
  801200:	85 c0                	test   %eax,%eax
  801202:	78 1a                	js     80121e <fd_close+0x77>
		if (dev->dev_close)
  801204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801207:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80120a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80120f:	85 c0                	test   %eax,%eax
  801211:	74 0b                	je     80121e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	56                   	push   %esi
  801217:	ff d0                	call   *%eax
  801219:	89 c3                	mov    %eax,%ebx
  80121b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	56                   	push   %esi
  801222:	6a 00                	push   $0x0
  801224:	e8 0a fc ff ff       	call   800e33 <sys_page_unmap>
	return r;
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	eb b5                	jmp    8011e3 <fd_close+0x3c>

0080122e <close>:

int
close(int fdnum)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	ff 75 08             	pushl  0x8(%ebp)
  80123b:	e8 bc fe ff ff       	call   8010fc <fd_lookup>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	79 02                	jns    801249 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    
		return fd_close(fd, 1);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	6a 01                	push   $0x1
  80124e:	ff 75 f4             	pushl  -0xc(%ebp)
  801251:	e8 51 ff ff ff       	call   8011a7 <fd_close>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	eb ec                	jmp    801247 <close+0x19>

0080125b <close_all>:

void
close_all(void)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801262:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	53                   	push   %ebx
  80126b:	e8 be ff ff ff       	call   80122e <close>
	for (i = 0; i < MAXFD; i++)
  801270:	83 c3 01             	add    $0x1,%ebx
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	83 fb 20             	cmp    $0x20,%ebx
  801279:	75 ec                	jne    801267 <close_all+0xc>
}
  80127b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	57                   	push   %edi
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801289:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 08             	pushl  0x8(%ebp)
  801290:	e8 67 fe ff ff       	call   8010fc <fd_lookup>
  801295:	89 c3                	mov    %eax,%ebx
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	0f 88 81 00 00 00    	js     801323 <dup+0xa3>
		return r;
	close(newfdnum);
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	e8 81 ff ff ff       	call   80122e <close>

	newfd = INDEX2FD(newfdnum);
  8012ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012b0:	c1 e6 0c             	shl    $0xc,%esi
  8012b3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012b9:	83 c4 04             	add    $0x4,%esp
  8012bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012bf:	e8 cf fd ff ff       	call   801093 <fd2data>
  8012c4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012c6:	89 34 24             	mov    %esi,(%esp)
  8012c9:	e8 c5 fd ff ff       	call   801093 <fd2data>
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012d3:	89 d8                	mov    %ebx,%eax
  8012d5:	c1 e8 16             	shr    $0x16,%eax
  8012d8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012df:	a8 01                	test   $0x1,%al
  8012e1:	74 11                	je     8012f4 <dup+0x74>
  8012e3:	89 d8                	mov    %ebx,%eax
  8012e5:	c1 e8 0c             	shr    $0xc,%eax
  8012e8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ef:	f6 c2 01             	test   $0x1,%dl
  8012f2:	75 39                	jne    80132d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f7:	89 d0                	mov    %edx,%eax
  8012f9:	c1 e8 0c             	shr    $0xc,%eax
  8012fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	25 07 0e 00 00       	and    $0xe07,%eax
  80130b:	50                   	push   %eax
  80130c:	56                   	push   %esi
  80130d:	6a 00                	push   $0x0
  80130f:	52                   	push   %edx
  801310:	6a 00                	push   $0x0
  801312:	e8 da fa ff ff       	call   800df1 <sys_page_map>
  801317:	89 c3                	mov    %eax,%ebx
  801319:	83 c4 20             	add    $0x20,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 31                	js     801351 <dup+0xd1>
		goto err;

	return newfdnum;
  801320:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801323:	89 d8                	mov    %ebx,%eax
  801325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801328:	5b                   	pop    %ebx
  801329:	5e                   	pop    %esi
  80132a:	5f                   	pop    %edi
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80132d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	25 07 0e 00 00       	and    $0xe07,%eax
  80133c:	50                   	push   %eax
  80133d:	57                   	push   %edi
  80133e:	6a 00                	push   $0x0
  801340:	53                   	push   %ebx
  801341:	6a 00                	push   $0x0
  801343:	e8 a9 fa ff ff       	call   800df1 <sys_page_map>
  801348:	89 c3                	mov    %eax,%ebx
  80134a:	83 c4 20             	add    $0x20,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	79 a3                	jns    8012f4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	56                   	push   %esi
  801355:	6a 00                	push   $0x0
  801357:	e8 d7 fa ff ff       	call   800e33 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80135c:	83 c4 08             	add    $0x8,%esp
  80135f:	57                   	push   %edi
  801360:	6a 00                	push   $0x0
  801362:	e8 cc fa ff ff       	call   800e33 <sys_page_unmap>
	return r;
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	eb b7                	jmp    801323 <dup+0xa3>

0080136c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	53                   	push   %ebx
  801370:	83 ec 1c             	sub    $0x1c,%esp
  801373:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801376:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	53                   	push   %ebx
  80137b:	e8 7c fd ff ff       	call   8010fc <fd_lookup>
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 3f                	js     8013c6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	ff 30                	pushl  (%eax)
  801393:	e8 b4 fd ff ff       	call   80114c <dev_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 27                	js     8013c6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80139f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a2:	8b 42 08             	mov    0x8(%edx),%eax
  8013a5:	83 e0 03             	and    $0x3,%eax
  8013a8:	83 f8 01             	cmp    $0x1,%eax
  8013ab:	74 1e                	je     8013cb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b0:	8b 40 08             	mov    0x8(%eax),%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 35                	je     8013ec <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	ff 75 10             	pushl  0x10(%ebp)
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	52                   	push   %edx
  8013c1:	ff d0                	call   *%eax
  8013c3:	83 c4 10             	add    $0x10,%esp
}
  8013c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d0:	8b 40 48             	mov    0x48(%eax),%eax
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	53                   	push   %ebx
  8013d7:	50                   	push   %eax
  8013d8:	68 75 2a 80 00       	push   $0x802a75
  8013dd:	e8 7b ee ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ea:	eb da                	jmp    8013c6 <read+0x5a>
		return -E_NOT_SUPP;
  8013ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f1:	eb d3                	jmp    8013c6 <read+0x5a>

008013f3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	57                   	push   %edi
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ff:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801402:	bb 00 00 00 00       	mov    $0x0,%ebx
  801407:	39 f3                	cmp    %esi,%ebx
  801409:	73 23                	jae    80142e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	89 f0                	mov    %esi,%eax
  801410:	29 d8                	sub    %ebx,%eax
  801412:	50                   	push   %eax
  801413:	89 d8                	mov    %ebx,%eax
  801415:	03 45 0c             	add    0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	57                   	push   %edi
  80141a:	e8 4d ff ff ff       	call   80136c <read>
		if (m < 0)
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 06                	js     80142c <readn+0x39>
			return m;
		if (m == 0)
  801426:	74 06                	je     80142e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801428:	01 c3                	add    %eax,%ebx
  80142a:	eb db                	jmp    801407 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80142e:	89 d8                	mov    %ebx,%eax
  801430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5f                   	pop    %edi
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	53                   	push   %ebx
  80143c:	83 ec 1c             	sub    $0x1c,%esp
  80143f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801442:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801445:	50                   	push   %eax
  801446:	53                   	push   %ebx
  801447:	e8 b0 fc ff ff       	call   8010fc <fd_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 3a                	js     80148d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145d:	ff 30                	pushl  (%eax)
  80145f:	e8 e8 fc ff ff       	call   80114c <dev_lookup>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 22                	js     80148d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801472:	74 1e                	je     801492 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801477:	8b 52 0c             	mov    0xc(%edx),%edx
  80147a:	85 d2                	test   %edx,%edx
  80147c:	74 35                	je     8014b3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	ff 75 10             	pushl  0x10(%ebp)
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	50                   	push   %eax
  801488:	ff d2                	call   *%edx
  80148a:	83 c4 10             	add    $0x10,%esp
}
  80148d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801490:	c9                   	leave  
  801491:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801492:	a1 08 40 80 00       	mov    0x804008,%eax
  801497:	8b 40 48             	mov    0x48(%eax),%eax
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	53                   	push   %ebx
  80149e:	50                   	push   %eax
  80149f:	68 91 2a 80 00       	push   $0x802a91
  8014a4:	e8 b4 ed ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b1:	eb da                	jmp    80148d <write+0x55>
		return -E_NOT_SUPP;
  8014b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b8:	eb d3                	jmp    80148d <write+0x55>

008014ba <seek>:

int
seek(int fdnum, off_t offset)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	ff 75 08             	pushl  0x8(%ebp)
  8014c7:	e8 30 fc ff ff       	call   8010fc <fd_lookup>
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 0e                	js     8014e1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 1c             	sub    $0x1c,%esp
  8014ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f0:	50                   	push   %eax
  8014f1:	53                   	push   %ebx
  8014f2:	e8 05 fc ff ff       	call   8010fc <fd_lookup>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 37                	js     801535 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	ff 30                	pushl  (%eax)
  80150a:	e8 3d fc ff ff       	call   80114c <dev_lookup>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 1f                	js     801535 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151d:	74 1b                	je     80153a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	8b 52 18             	mov    0x18(%edx),%edx
  801525:	85 d2                	test   %edx,%edx
  801527:	74 32                	je     80155b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	50                   	push   %eax
  801530:	ff d2                	call   *%edx
  801532:	83 c4 10             	add    $0x10,%esp
}
  801535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801538:	c9                   	leave  
  801539:	c3                   	ret    
			thisenv->env_id, fdnum);
  80153a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80153f:	8b 40 48             	mov    0x48(%eax),%eax
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	53                   	push   %ebx
  801546:	50                   	push   %eax
  801547:	68 54 2a 80 00       	push   $0x802a54
  80154c:	e8 0c ed ff ff       	call   80025d <cprintf>
		return -E_INVAL;
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801559:	eb da                	jmp    801535 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80155b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801560:	eb d3                	jmp    801535 <ftruncate+0x52>

00801562 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	53                   	push   %ebx
  801566:	83 ec 1c             	sub    $0x1c,%esp
  801569:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	ff 75 08             	pushl  0x8(%ebp)
  801573:	e8 84 fb ff ff       	call   8010fc <fd_lookup>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 4b                	js     8015ca <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	ff 30                	pushl  (%eax)
  80158b:	e8 bc fb ff ff       	call   80114c <dev_lookup>
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	85 c0                	test   %eax,%eax
  801595:	78 33                	js     8015ca <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80159e:	74 2f                	je     8015cf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015aa:	00 00 00 
	stat->st_isdir = 0;
  8015ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015b4:	00 00 00 
	stat->st_dev = dev;
  8015b7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	53                   	push   %ebx
  8015c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c4:	ff 50 14             	call   *0x14(%eax)
  8015c7:	83 c4 10             	add    $0x10,%esp
}
  8015ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    
		return -E_NOT_SUPP;
  8015cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d4:	eb f4                	jmp    8015ca <fstat+0x68>

008015d6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	56                   	push   %esi
  8015da:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	6a 00                	push   $0x0
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 22 02 00 00       	call   80180a <open>
  8015e8:	89 c3                	mov    %eax,%ebx
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 1b                	js     80160c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	ff 75 0c             	pushl  0xc(%ebp)
  8015f7:	50                   	push   %eax
  8015f8:	e8 65 ff ff ff       	call   801562 <fstat>
  8015fd:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ff:	89 1c 24             	mov    %ebx,(%esp)
  801602:	e8 27 fc ff ff       	call   80122e <close>
	return r;
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	89 f3                	mov    %esi,%ebx
}
  80160c:	89 d8                	mov    %ebx,%eax
  80160e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	56                   	push   %esi
  801619:	53                   	push   %ebx
  80161a:	89 c6                	mov    %eax,%esi
  80161c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80161e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801625:	74 27                	je     80164e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801627:	6a 07                	push   $0x7
  801629:	68 00 50 80 00       	push   $0x805000
  80162e:	56                   	push   %esi
  80162f:	ff 35 00 40 80 00    	pushl  0x804000
  801635:	e8 69 0c 00 00       	call   8022a3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80163a:	83 c4 0c             	add    $0xc,%esp
  80163d:	6a 00                	push   $0x0
  80163f:	53                   	push   %ebx
  801640:	6a 00                	push   $0x0
  801642:	e8 f3 0b 00 00       	call   80223a <ipc_recv>
}
  801647:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	6a 01                	push   $0x1
  801653:	e8 a3 0c 00 00       	call   8022fb <ipc_find_env>
  801658:	a3 00 40 80 00       	mov    %eax,0x804000
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	eb c5                	jmp    801627 <fsipc+0x12>

00801662 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8b 40 0c             	mov    0xc(%eax),%eax
  80166e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	b8 02 00 00 00       	mov    $0x2,%eax
  801685:	e8 8b ff ff ff       	call   801615 <fsipc>
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <devfile_flush>:
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8b 40 0c             	mov    0xc(%eax),%eax
  801698:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80169d:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a2:	b8 06 00 00 00       	mov    $0x6,%eax
  8016a7:	e8 69 ff ff ff       	call   801615 <fsipc>
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <devfile_stat>:
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016be:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8016cd:	e8 43 ff ff ff       	call   801615 <fsipc>
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 2c                	js     801702 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	68 00 50 80 00       	push   $0x805000
  8016de:	53                   	push   %ebx
  8016df:	e8 d8 f2 ff ff       	call   8009bc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016e4:	a1 80 50 80 00       	mov    0x805080,%eax
  8016e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ef:	a1 84 50 80 00       	mov    0x805084,%eax
  8016f4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <devfile_write>:
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	53                   	push   %ebx
  80170b:	83 ec 08             	sub    $0x8,%esp
  80170e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 40 0c             	mov    0xc(%eax),%eax
  801717:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80171c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801722:	53                   	push   %ebx
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	68 08 50 80 00       	push   $0x805008
  80172b:	e8 7c f4 ff ff       	call   800bac <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801730:	ba 00 00 00 00       	mov    $0x0,%edx
  801735:	b8 04 00 00 00       	mov    $0x4,%eax
  80173a:	e8 d6 fe ff ff       	call   801615 <fsipc>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 0b                	js     801751 <devfile_write+0x4a>
	assert(r <= n);
  801746:	39 d8                	cmp    %ebx,%eax
  801748:	77 0c                	ja     801756 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80174a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174f:	7f 1e                	jg     80176f <devfile_write+0x68>
}
  801751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801754:	c9                   	leave  
  801755:	c3                   	ret    
	assert(r <= n);
  801756:	68 c4 2a 80 00       	push   $0x802ac4
  80175b:	68 cb 2a 80 00       	push   $0x802acb
  801760:	68 98 00 00 00       	push   $0x98
  801765:	68 e0 2a 80 00       	push   $0x802ae0
  80176a:	e8 6a 0a 00 00       	call   8021d9 <_panic>
	assert(r <= PGSIZE);
  80176f:	68 eb 2a 80 00       	push   $0x802aeb
  801774:	68 cb 2a 80 00       	push   $0x802acb
  801779:	68 99 00 00 00       	push   $0x99
  80177e:	68 e0 2a 80 00       	push   $0x802ae0
  801783:	e8 51 0a 00 00       	call   8021d9 <_panic>

00801788 <devfile_read>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	56                   	push   %esi
  80178c:	53                   	push   %ebx
  80178d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8b 40 0c             	mov    0xc(%eax),%eax
  801796:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80179b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ab:	e8 65 fe ff ff       	call   801615 <fsipc>
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 1f                	js     8017d5 <devfile_read+0x4d>
	assert(r <= n);
  8017b6:	39 f0                	cmp    %esi,%eax
  8017b8:	77 24                	ja     8017de <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017ba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017bf:	7f 33                	jg     8017f4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	50                   	push   %eax
  8017c5:	68 00 50 80 00       	push   $0x805000
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	e8 78 f3 ff ff       	call   800b4a <memmove>
	return r;
  8017d2:	83 c4 10             	add    $0x10,%esp
}
  8017d5:	89 d8                	mov    %ebx,%eax
  8017d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017da:	5b                   	pop    %ebx
  8017db:	5e                   	pop    %esi
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    
	assert(r <= n);
  8017de:	68 c4 2a 80 00       	push   $0x802ac4
  8017e3:	68 cb 2a 80 00       	push   $0x802acb
  8017e8:	6a 7c                	push   $0x7c
  8017ea:	68 e0 2a 80 00       	push   $0x802ae0
  8017ef:	e8 e5 09 00 00       	call   8021d9 <_panic>
	assert(r <= PGSIZE);
  8017f4:	68 eb 2a 80 00       	push   $0x802aeb
  8017f9:	68 cb 2a 80 00       	push   $0x802acb
  8017fe:	6a 7d                	push   $0x7d
  801800:	68 e0 2a 80 00       	push   $0x802ae0
  801805:	e8 cf 09 00 00       	call   8021d9 <_panic>

0080180a <open>:
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	56                   	push   %esi
  80180e:	53                   	push   %ebx
  80180f:	83 ec 1c             	sub    $0x1c,%esp
  801812:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801815:	56                   	push   %esi
  801816:	e8 68 f1 ff ff       	call   800983 <strlen>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801823:	7f 6c                	jg     801891 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182b:	50                   	push   %eax
  80182c:	e8 79 f8 ff ff       	call   8010aa <fd_alloc>
  801831:	89 c3                	mov    %eax,%ebx
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 3c                	js     801876 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	56                   	push   %esi
  80183e:	68 00 50 80 00       	push   $0x805000
  801843:	e8 74 f1 ff ff       	call   8009bc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	b8 01 00 00 00       	mov    $0x1,%eax
  801858:	e8 b8 fd ff ff       	call   801615 <fsipc>
  80185d:	89 c3                	mov    %eax,%ebx
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	78 19                	js     80187f <open+0x75>
	return fd2num(fd);
  801866:	83 ec 0c             	sub    $0xc,%esp
  801869:	ff 75 f4             	pushl  -0xc(%ebp)
  80186c:	e8 12 f8 ff ff       	call   801083 <fd2num>
  801871:	89 c3                	mov    %eax,%ebx
  801873:	83 c4 10             	add    $0x10,%esp
}
  801876:	89 d8                	mov    %ebx,%eax
  801878:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    
		fd_close(fd, 0);
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	6a 00                	push   $0x0
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	e8 1b f9 ff ff       	call   8011a7 <fd_close>
		return r;
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	eb e5                	jmp    801876 <open+0x6c>
		return -E_BAD_PATH;
  801891:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801896:	eb de                	jmp    801876 <open+0x6c>

00801898 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a8:	e8 68 fd ff ff       	call   801615 <fsipc>
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018b5:	68 f7 2a 80 00       	push   $0x802af7
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	e8 fa f0 ff ff       	call   8009bc <strcpy>
	return 0;
}
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <devsock_close>:
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 10             	sub    $0x10,%esp
  8018d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018d3:	53                   	push   %ebx
  8018d4:	e8 5d 0a 00 00       	call   802336 <pageref>
  8018d9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018dc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018e1:	83 f8 01             	cmp    $0x1,%eax
  8018e4:	74 07                	je     8018ed <devsock_close+0x24>
}
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	ff 73 0c             	pushl  0xc(%ebx)
  8018f3:	e8 b9 02 00 00       	call   801bb1 <nsipc_close>
  8018f8:	89 c2                	mov    %eax,%edx
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	eb e7                	jmp    8018e6 <devsock_close+0x1d>

008018ff <devsock_write>:
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801905:	6a 00                	push   $0x0
  801907:	ff 75 10             	pushl  0x10(%ebp)
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	ff 70 0c             	pushl  0xc(%eax)
  801913:	e8 76 03 00 00       	call   801c8e <nsipc_send>
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <devsock_read>:
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801920:	6a 00                	push   $0x0
  801922:	ff 75 10             	pushl  0x10(%ebp)
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	ff 70 0c             	pushl  0xc(%eax)
  80192e:	e8 ef 02 00 00       	call   801c22 <nsipc_recv>
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <fd2sockid>:
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80193b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	e8 b7 f7 ff ff       	call   8010fc <fd_lookup>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 10                	js     80195c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801955:	39 08                	cmp    %ecx,(%eax)
  801957:	75 05                	jne    80195e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801959:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    
		return -E_NOT_SUPP;
  80195e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801963:	eb f7                	jmp    80195c <fd2sockid+0x27>

00801965 <alloc_sockfd>:
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
  80196a:	83 ec 1c             	sub    $0x1c,%esp
  80196d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80196f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	e8 32 f7 ff ff       	call   8010aa <fd_alloc>
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	83 c4 10             	add    $0x10,%esp
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 43                	js     8019c4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801981:	83 ec 04             	sub    $0x4,%esp
  801984:	68 07 04 00 00       	push   $0x407
  801989:	ff 75 f4             	pushl  -0xc(%ebp)
  80198c:	6a 00                	push   $0x0
  80198e:	e8 1b f4 ff ff       	call   800dae <sys_page_alloc>
  801993:	89 c3                	mov    %eax,%ebx
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 28                	js     8019c4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019a5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019aa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019b1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	50                   	push   %eax
  8019b8:	e8 c6 f6 ff ff       	call   801083 <fd2num>
  8019bd:	89 c3                	mov    %eax,%ebx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	eb 0c                	jmp    8019d0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	56                   	push   %esi
  8019c8:	e8 e4 01 00 00       	call   801bb1 <nsipc_close>
		return r;
  8019cd:	83 c4 10             	add    $0x10,%esp
}
  8019d0:	89 d8                	mov    %ebx,%eax
  8019d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <accept>:
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	e8 4e ff ff ff       	call   801935 <fd2sockid>
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 1b                	js     801a06 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	ff 75 10             	pushl  0x10(%ebp)
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	50                   	push   %eax
  8019f5:	e8 0e 01 00 00       	call   801b08 <nsipc_accept>
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 05                	js     801a06 <accept+0x2d>
	return alloc_sockfd(r);
  801a01:	e8 5f ff ff ff       	call   801965 <alloc_sockfd>
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <bind>:
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	e8 1f ff ff ff       	call   801935 <fd2sockid>
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 12                	js     801a2c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	ff 75 10             	pushl  0x10(%ebp)
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	50                   	push   %eax
  801a24:	e8 31 01 00 00       	call   801b5a <nsipc_bind>
  801a29:	83 c4 10             	add    $0x10,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <shutdown>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	e8 f9 fe ff ff       	call   801935 <fd2sockid>
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 0f                	js     801a4f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	50                   	push   %eax
  801a47:	e8 43 01 00 00       	call   801b8f <nsipc_shutdown>
  801a4c:	83 c4 10             	add    $0x10,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <connect>:
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	e8 d6 fe ff ff       	call   801935 <fd2sockid>
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 12                	js     801a75 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	ff 75 10             	pushl  0x10(%ebp)
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	e8 59 01 00 00       	call   801bcb <nsipc_connect>
  801a72:	83 c4 10             	add    $0x10,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <listen>:
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	e8 b0 fe ff ff       	call   801935 <fd2sockid>
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 0f                	js     801a98 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	50                   	push   %eax
  801a90:	e8 6b 01 00 00       	call   801c00 <nsipc_listen>
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <socket>:

int
socket(int domain, int type, int protocol)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	e8 3e 02 00 00       	call   801cec <nsipc_socket>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 05                	js     801aba <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ab5:	e8 ab fe ff ff       	call   801965 <alloc_sockfd>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ac5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801acc:	74 26                	je     801af4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ace:	6a 07                	push   $0x7
  801ad0:	68 00 60 80 00       	push   $0x806000
  801ad5:	53                   	push   %ebx
  801ad6:	ff 35 04 40 80 00    	pushl  0x804004
  801adc:	e8 c2 07 00 00       	call   8022a3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ae1:	83 c4 0c             	add    $0xc,%esp
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	e8 4b 07 00 00       	call   80223a <ipc_recv>
}
  801aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	6a 02                	push   $0x2
  801af9:	e8 fd 07 00 00       	call   8022fb <ipc_find_env>
  801afe:	a3 04 40 80 00       	mov    %eax,0x804004
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	eb c6                	jmp    801ace <nsipc+0x12>

00801b08 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b18:	8b 06                	mov    (%esi),%eax
  801b1a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b24:	e8 93 ff ff ff       	call   801abc <nsipc>
  801b29:	89 c3                	mov    %eax,%ebx
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	79 09                	jns    801b38 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	ff 35 10 60 80 00    	pushl  0x806010
  801b41:	68 00 60 80 00       	push   $0x806000
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	e8 fc ef ff ff       	call   800b4a <memmove>
		*addrlen = ret->ret_addrlen;
  801b4e:	a1 10 60 80 00       	mov    0x806010,%eax
  801b53:	89 06                	mov    %eax,(%esi)
  801b55:	83 c4 10             	add    $0x10,%esp
	return r;
  801b58:	eb d5                	jmp    801b2f <nsipc_accept+0x27>

00801b5a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b6c:	53                   	push   %ebx
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	68 04 60 80 00       	push   $0x806004
  801b75:	e8 d0 ef ff ff       	call   800b4a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b7a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b80:	b8 02 00 00 00       	mov    $0x2,%eax
  801b85:	e8 32 ff ff ff       	call   801abc <nsipc>
}
  801b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ba5:	b8 03 00 00 00       	mov    $0x3,%eax
  801baa:	e8 0d ff ff ff       	call   801abc <nsipc>
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <nsipc_close>:

int
nsipc_close(int s)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bbf:	b8 04 00 00 00       	mov    $0x4,%eax
  801bc4:	e8 f3 fe ff ff       	call   801abc <nsipc>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 08             	sub    $0x8,%esp
  801bd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bdd:	53                   	push   %ebx
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	68 04 60 80 00       	push   $0x806004
  801be6:	e8 5f ef ff ff       	call   800b4a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801beb:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bf1:	b8 05 00 00 00       	mov    $0x5,%eax
  801bf6:	e8 c1 fe ff ff       	call   801abc <nsipc>
}
  801bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c11:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c16:	b8 06 00 00 00       	mov    $0x6,%eax
  801c1b:	e8 9c fe ff ff       	call   801abc <nsipc>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	56                   	push   %esi
  801c26:	53                   	push   %ebx
  801c27:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c32:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c38:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c40:	b8 07 00 00 00       	mov    $0x7,%eax
  801c45:	e8 72 fe ff ff       	call   801abc <nsipc>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	78 1f                	js     801c6f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c50:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c55:	7f 21                	jg     801c78 <nsipc_recv+0x56>
  801c57:	39 c6                	cmp    %eax,%esi
  801c59:	7c 1d                	jl     801c78 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	50                   	push   %eax
  801c5f:	68 00 60 80 00       	push   $0x806000
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	e8 de ee ff ff       	call   800b4a <memmove>
  801c6c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c78:	68 03 2b 80 00       	push   $0x802b03
  801c7d:	68 cb 2a 80 00       	push   $0x802acb
  801c82:	6a 62                	push   $0x62
  801c84:	68 18 2b 80 00       	push   $0x802b18
  801c89:	e8 4b 05 00 00       	call   8021d9 <_panic>

00801c8e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ca0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ca6:	7f 2e                	jg     801cd6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	53                   	push   %ebx
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	68 0c 60 80 00       	push   $0x80600c
  801cb4:	e8 91 ee ff ff       	call   800b4a <memmove>
	nsipcbuf.send.req_size = size;
  801cb9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cc7:	b8 08 00 00 00       	mov    $0x8,%eax
  801ccc:	e8 eb fd ff ff       	call   801abc <nsipc>
}
  801cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    
	assert(size < 1600);
  801cd6:	68 24 2b 80 00       	push   $0x802b24
  801cdb:	68 cb 2a 80 00       	push   $0x802acb
  801ce0:	6a 6d                	push   $0x6d
  801ce2:	68 18 2b 80 00       	push   $0x802b18
  801ce7:	e8 ed 04 00 00       	call   8021d9 <_panic>

00801cec <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfd:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d02:	8b 45 10             	mov    0x10(%ebp),%eax
  801d05:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d0a:	b8 09 00 00 00       	mov    $0x9,%eax
  801d0f:	e8 a8 fd ff ff       	call   801abc <nsipc>
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	56                   	push   %esi
  801d1a:	53                   	push   %ebx
  801d1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	ff 75 08             	pushl  0x8(%ebp)
  801d24:	e8 6a f3 ff ff       	call   801093 <fd2data>
  801d29:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d2b:	83 c4 08             	add    $0x8,%esp
  801d2e:	68 30 2b 80 00       	push   $0x802b30
  801d33:	53                   	push   %ebx
  801d34:	e8 83 ec ff ff       	call   8009bc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d39:	8b 46 04             	mov    0x4(%esi),%eax
  801d3c:	2b 06                	sub    (%esi),%eax
  801d3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d44:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d4b:	00 00 00 
	stat->st_dev = &devpipe;
  801d4e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d55:	30 80 00 
	return 0;
}
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	53                   	push   %ebx
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d6e:	53                   	push   %ebx
  801d6f:	6a 00                	push   $0x0
  801d71:	e8 bd f0 ff ff       	call   800e33 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d76:	89 1c 24             	mov    %ebx,(%esp)
  801d79:	e8 15 f3 ff ff       	call   801093 <fd2data>
  801d7e:	83 c4 08             	add    $0x8,%esp
  801d81:	50                   	push   %eax
  801d82:	6a 00                	push   $0x0
  801d84:	e8 aa f0 ff ff       	call   800e33 <sys_page_unmap>
}
  801d89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <_pipeisclosed>:
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 1c             	sub    $0x1c,%esp
  801d97:	89 c7                	mov    %eax,%edi
  801d99:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d9b:	a1 08 40 80 00       	mov    0x804008,%eax
  801da0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	57                   	push   %edi
  801da7:	e8 8a 05 00 00       	call   802336 <pageref>
  801dac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801daf:	89 34 24             	mov    %esi,(%esp)
  801db2:	e8 7f 05 00 00       	call   802336 <pageref>
		nn = thisenv->env_runs;
  801db7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dbd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	39 cb                	cmp    %ecx,%ebx
  801dc5:	74 1b                	je     801de2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dc7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dca:	75 cf                	jne    801d9b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dcc:	8b 42 58             	mov    0x58(%edx),%eax
  801dcf:	6a 01                	push   $0x1
  801dd1:	50                   	push   %eax
  801dd2:	53                   	push   %ebx
  801dd3:	68 37 2b 80 00       	push   $0x802b37
  801dd8:	e8 80 e4 ff ff       	call   80025d <cprintf>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	eb b9                	jmp    801d9b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801de2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de5:	0f 94 c0             	sete   %al
  801de8:	0f b6 c0             	movzbl %al,%eax
}
  801deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <devpipe_write>:
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	57                   	push   %edi
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	83 ec 28             	sub    $0x28,%esp
  801dfc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dff:	56                   	push   %esi
  801e00:	e8 8e f2 ff ff       	call   801093 <fd2data>
  801e05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e12:	74 4f                	je     801e63 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e14:	8b 43 04             	mov    0x4(%ebx),%eax
  801e17:	8b 0b                	mov    (%ebx),%ecx
  801e19:	8d 51 20             	lea    0x20(%ecx),%edx
  801e1c:	39 d0                	cmp    %edx,%eax
  801e1e:	72 14                	jb     801e34 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e20:	89 da                	mov    %ebx,%edx
  801e22:	89 f0                	mov    %esi,%eax
  801e24:	e8 65 ff ff ff       	call   801d8e <_pipeisclosed>
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	75 3b                	jne    801e68 <devpipe_write+0x75>
			sys_yield();
  801e2d:	e8 5d ef ff ff       	call   800d8f <sys_yield>
  801e32:	eb e0                	jmp    801e14 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e37:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e3b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e3e:	89 c2                	mov    %eax,%edx
  801e40:	c1 fa 1f             	sar    $0x1f,%edx
  801e43:	89 d1                	mov    %edx,%ecx
  801e45:	c1 e9 1b             	shr    $0x1b,%ecx
  801e48:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e4b:	83 e2 1f             	and    $0x1f,%edx
  801e4e:	29 ca                	sub    %ecx,%edx
  801e50:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e54:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e58:	83 c0 01             	add    $0x1,%eax
  801e5b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e5e:	83 c7 01             	add    $0x1,%edi
  801e61:	eb ac                	jmp    801e0f <devpipe_write+0x1c>
	return i;
  801e63:	8b 45 10             	mov    0x10(%ebp),%eax
  801e66:	eb 05                	jmp    801e6d <devpipe_write+0x7a>
				return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5f                   	pop    %edi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    

00801e75 <devpipe_read>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	57                   	push   %edi
  801e79:	56                   	push   %esi
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 18             	sub    $0x18,%esp
  801e7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e81:	57                   	push   %edi
  801e82:	e8 0c f2 ff ff       	call   801093 <fd2data>
  801e87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	be 00 00 00 00       	mov    $0x0,%esi
  801e91:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e94:	75 14                	jne    801eaa <devpipe_read+0x35>
	return i;
  801e96:	8b 45 10             	mov    0x10(%ebp),%eax
  801e99:	eb 02                	jmp    801e9d <devpipe_read+0x28>
				return i;
  801e9b:	89 f0                	mov    %esi,%eax
}
  801e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    
			sys_yield();
  801ea5:	e8 e5 ee ff ff       	call   800d8f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eaa:	8b 03                	mov    (%ebx),%eax
  801eac:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eaf:	75 18                	jne    801ec9 <devpipe_read+0x54>
			if (i > 0)
  801eb1:	85 f6                	test   %esi,%esi
  801eb3:	75 e6                	jne    801e9b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801eb5:	89 da                	mov    %ebx,%edx
  801eb7:	89 f8                	mov    %edi,%eax
  801eb9:	e8 d0 fe ff ff       	call   801d8e <_pipeisclosed>
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	74 e3                	je     801ea5 <devpipe_read+0x30>
				return 0;
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	eb d4                	jmp    801e9d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ec9:	99                   	cltd   
  801eca:	c1 ea 1b             	shr    $0x1b,%edx
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	83 e0 1f             	and    $0x1f,%eax
  801ed2:	29 d0                	sub    %edx,%eax
  801ed4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801edf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ee2:	83 c6 01             	add    $0x1,%esi
  801ee5:	eb aa                	jmp    801e91 <devpipe_read+0x1c>

00801ee7 <pipe>:
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef2:	50                   	push   %eax
  801ef3:	e8 b2 f1 ff ff       	call   8010aa <fd_alloc>
  801ef8:	89 c3                	mov    %eax,%ebx
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 23 01 00 00    	js     802028 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	68 07 04 00 00       	push   $0x407
  801f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f10:	6a 00                	push   $0x0
  801f12:	e8 97 ee ff ff       	call   800dae <sys_page_alloc>
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	0f 88 04 01 00 00    	js     802028 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f2a:	50                   	push   %eax
  801f2b:	e8 7a f1 ff ff       	call   8010aa <fd_alloc>
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	85 c0                	test   %eax,%eax
  801f37:	0f 88 db 00 00 00    	js     802018 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	68 07 04 00 00       	push   $0x407
  801f45:	ff 75 f0             	pushl  -0x10(%ebp)
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 5f ee ff ff       	call   800dae <sys_page_alloc>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	0f 88 bc 00 00 00    	js     802018 <pipe+0x131>
	va = fd2data(fd0);
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f62:	e8 2c f1 ff ff       	call   801093 <fd2data>
  801f67:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f69:	83 c4 0c             	add    $0xc,%esp
  801f6c:	68 07 04 00 00       	push   $0x407
  801f71:	50                   	push   %eax
  801f72:	6a 00                	push   $0x0
  801f74:	e8 35 ee ff ff       	call   800dae <sys_page_alloc>
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	0f 88 82 00 00 00    	js     802008 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8c:	e8 02 f1 ff ff       	call   801093 <fd2data>
  801f91:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f98:	50                   	push   %eax
  801f99:	6a 00                	push   $0x0
  801f9b:	56                   	push   %esi
  801f9c:	6a 00                	push   $0x0
  801f9e:	e8 4e ee ff ff       	call   800df1 <sys_page_map>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	83 c4 20             	add    $0x20,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 4e                	js     801ffa <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fac:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd5:	e8 a9 f0 ff ff       	call   801083 <fd2num>
  801fda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fdd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fdf:	83 c4 04             	add    $0x4,%esp
  801fe2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe5:	e8 99 f0 ff ff       	call   801083 <fd2num>
  801fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fed:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff8:	eb 2e                	jmp    802028 <pipe+0x141>
	sys_page_unmap(0, va);
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	56                   	push   %esi
  801ffe:	6a 00                	push   $0x0
  802000:	e8 2e ee ff ff       	call   800e33 <sys_page_unmap>
  802005:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802008:	83 ec 08             	sub    $0x8,%esp
  80200b:	ff 75 f0             	pushl  -0x10(%ebp)
  80200e:	6a 00                	push   $0x0
  802010:	e8 1e ee ff ff       	call   800e33 <sys_page_unmap>
  802015:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	ff 75 f4             	pushl  -0xc(%ebp)
  80201e:	6a 00                	push   $0x0
  802020:	e8 0e ee ff ff       	call   800e33 <sys_page_unmap>
  802025:	83 c4 10             	add    $0x10,%esp
}
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202d:	5b                   	pop    %ebx
  80202e:	5e                   	pop    %esi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    

00802031 <pipeisclosed>:
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802037:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203a:	50                   	push   %eax
  80203b:	ff 75 08             	pushl  0x8(%ebp)
  80203e:	e8 b9 f0 ff ff       	call   8010fc <fd_lookup>
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	85 c0                	test   %eax,%eax
  802048:	78 18                	js     802062 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	ff 75 f4             	pushl  -0xc(%ebp)
  802050:	e8 3e f0 ff ff       	call   801093 <fd2data>
	return _pipeisclosed(fd, p);
  802055:	89 c2                	mov    %eax,%edx
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	e8 2f fd ff ff       	call   801d8e <_pipeisclosed>
  80205f:	83 c4 10             	add    $0x10,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	c3                   	ret    

0080206a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802070:	68 4f 2b 80 00       	push   $0x802b4f
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	e8 3f e9 ff ff       	call   8009bc <strcpy>
	return 0;
}
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <devcons_write>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	57                   	push   %edi
  802088:	56                   	push   %esi
  802089:	53                   	push   %ebx
  80208a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802090:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802095:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80209b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209e:	73 31                	jae    8020d1 <devcons_write+0x4d>
		m = n - tot;
  8020a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020a3:	29 f3                	sub    %esi,%ebx
  8020a5:	83 fb 7f             	cmp    $0x7f,%ebx
  8020a8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ad:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	53                   	push   %ebx
  8020b4:	89 f0                	mov    %esi,%eax
  8020b6:	03 45 0c             	add    0xc(%ebp),%eax
  8020b9:	50                   	push   %eax
  8020ba:	57                   	push   %edi
  8020bb:	e8 8a ea ff ff       	call   800b4a <memmove>
		sys_cputs(buf, m);
  8020c0:	83 c4 08             	add    $0x8,%esp
  8020c3:	53                   	push   %ebx
  8020c4:	57                   	push   %edi
  8020c5:	e8 28 ec ff ff       	call   800cf2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ca:	01 de                	add    %ebx,%esi
  8020cc:	83 c4 10             	add    $0x10,%esp
  8020cf:	eb ca                	jmp    80209b <devcons_write+0x17>
}
  8020d1:	89 f0                	mov    %esi,%eax
  8020d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <devcons_read>:
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 08             	sub    $0x8,%esp
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ea:	74 21                	je     80210d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020ec:	e8 1f ec ff ff       	call   800d10 <sys_cgetc>
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	75 07                	jne    8020fc <devcons_read+0x21>
		sys_yield();
  8020f5:	e8 95 ec ff ff       	call   800d8f <sys_yield>
  8020fa:	eb f0                	jmp    8020ec <devcons_read+0x11>
	if (c < 0)
  8020fc:	78 0f                	js     80210d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020fe:	83 f8 04             	cmp    $0x4,%eax
  802101:	74 0c                	je     80210f <devcons_read+0x34>
	*(char*)vbuf = c;
  802103:	8b 55 0c             	mov    0xc(%ebp),%edx
  802106:	88 02                	mov    %al,(%edx)
	return 1;
  802108:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    
		return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	eb f7                	jmp    80210d <devcons_read+0x32>

00802116 <cputchar>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802122:	6a 01                	push   $0x1
  802124:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802127:	50                   	push   %eax
  802128:	e8 c5 eb ff ff       	call   800cf2 <sys_cputs>
}
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <getchar>:
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802138:	6a 01                	push   $0x1
  80213a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213d:	50                   	push   %eax
  80213e:	6a 00                	push   $0x0
  802140:	e8 27 f2 ff ff       	call   80136c <read>
	if (r < 0)
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 06                	js     802152 <getchar+0x20>
	if (r < 1)
  80214c:	74 06                	je     802154 <getchar+0x22>
	return c;
  80214e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    
		return -E_EOF;
  802154:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802159:	eb f7                	jmp    802152 <getchar+0x20>

0080215b <iscons>:
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802161:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802164:	50                   	push   %eax
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	e8 8f ef ff ff       	call   8010fc <fd_lookup>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 11                	js     802185 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80217d:	39 10                	cmp    %edx,(%eax)
  80217f:	0f 94 c0             	sete   %al
  802182:	0f b6 c0             	movzbl %al,%eax
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <opencons>:
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80218d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802190:	50                   	push   %eax
  802191:	e8 14 ef ff ff       	call   8010aa <fd_alloc>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 3a                	js     8021d7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 07 04 00 00       	push   $0x407
  8021a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a8:	6a 00                	push   $0x0
  8021aa:	e8 ff eb ff ff       	call   800dae <sys_page_alloc>
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 21                	js     8021d7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021bf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	50                   	push   %eax
  8021cf:	e8 af ee ff ff       	call   801083 <fd2num>
  8021d4:	83 c4 10             	add    $0x10,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021de:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e3:	8b 40 48             	mov    0x48(%eax),%eax
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 80 2b 80 00       	push   $0x802b80
  8021ee:	50                   	push   %eax
  8021ef:	68 67 26 80 00       	push   $0x802667
  8021f4:	e8 64 e0 ff ff       	call   80025d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021fc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802202:	e8 69 eb ff ff       	call   800d70 <sys_getenvid>
  802207:	83 c4 04             	add    $0x4,%esp
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	56                   	push   %esi
  802211:	50                   	push   %eax
  802212:	68 5c 2b 80 00       	push   $0x802b5c
  802217:	e8 41 e0 ff ff       	call   80025d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80221c:	83 c4 18             	add    $0x18,%esp
  80221f:	53                   	push   %ebx
  802220:	ff 75 10             	pushl  0x10(%ebp)
  802223:	e8 e4 df ff ff       	call   80020c <vcprintf>
	cprintf("\n");
  802228:	c7 04 24 2b 26 80 00 	movl   $0x80262b,(%esp)
  80222f:	e8 29 e0 ff ff       	call   80025d <cprintf>
  802234:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802237:	cc                   	int3   
  802238:	eb fd                	jmp    802237 <_panic+0x5e>

0080223a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	56                   	push   %esi
  80223e:	53                   	push   %ebx
  80223f:	8b 75 08             	mov    0x8(%ebp),%esi
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802248:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80224a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80224f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	50                   	push   %eax
  802256:	e8 03 ed ff ff       	call   800f5e <sys_ipc_recv>
	if(ret < 0){
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 2b                	js     80228d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802262:	85 f6                	test   %esi,%esi
  802264:	74 0a                	je     802270 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802266:	a1 08 40 80 00       	mov    0x804008,%eax
  80226b:	8b 40 74             	mov    0x74(%eax),%eax
  80226e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802270:	85 db                	test   %ebx,%ebx
  802272:	74 0a                	je     80227e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802274:	a1 08 40 80 00       	mov    0x804008,%eax
  802279:	8b 40 78             	mov    0x78(%eax),%eax
  80227c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80227e:	a1 08 40 80 00       	mov    0x804008,%eax
  802283:	8b 40 70             	mov    0x70(%eax),%eax
}
  802286:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802289:	5b                   	pop    %ebx
  80228a:	5e                   	pop    %esi
  80228b:	5d                   	pop    %ebp
  80228c:	c3                   	ret    
		if(from_env_store)
  80228d:	85 f6                	test   %esi,%esi
  80228f:	74 06                	je     802297 <ipc_recv+0x5d>
			*from_env_store = 0;
  802291:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802297:	85 db                	test   %ebx,%ebx
  802299:	74 eb                	je     802286 <ipc_recv+0x4c>
			*perm_store = 0;
  80229b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022a1:	eb e3                	jmp    802286 <ipc_recv+0x4c>

008022a3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	57                   	push   %edi
  8022a7:	56                   	push   %esi
  8022a8:	53                   	push   %ebx
  8022a9:	83 ec 0c             	sub    $0xc,%esp
  8022ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022b5:	85 db                	test   %ebx,%ebx
  8022b7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022bc:	0f 44 d8             	cmove  %eax,%ebx
  8022bf:	eb 05                	jmp    8022c6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022c1:	e8 c9 ea ff ff       	call   800d8f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022c6:	ff 75 14             	pushl  0x14(%ebp)
  8022c9:	53                   	push   %ebx
  8022ca:	56                   	push   %esi
  8022cb:	57                   	push   %edi
  8022cc:	e8 6a ec ff ff       	call   800f3b <sys_ipc_try_send>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 1b                	je     8022f3 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022d8:	79 e7                	jns    8022c1 <ipc_send+0x1e>
  8022da:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022dd:	74 e2                	je     8022c1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	68 87 2b 80 00       	push   $0x802b87
  8022e7:	6a 46                	push   $0x46
  8022e9:	68 9c 2b 80 00       	push   $0x802b9c
  8022ee:	e8 e6 fe ff ff       	call   8021d9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f6:	5b                   	pop    %ebx
  8022f7:	5e                   	pop    %esi
  8022f8:	5f                   	pop    %edi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802306:	89 c2                	mov    %eax,%edx
  802308:	c1 e2 07             	shl    $0x7,%edx
  80230b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802311:	8b 52 50             	mov    0x50(%edx),%edx
  802314:	39 ca                	cmp    %ecx,%edx
  802316:	74 11                	je     802329 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802318:	83 c0 01             	add    $0x1,%eax
  80231b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802320:	75 e4                	jne    802306 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
  802327:	eb 0b                	jmp    802334 <ipc_find_env+0x39>
			return envs[i].env_id;
  802329:	c1 e0 07             	shl    $0x7,%eax
  80232c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802331:	8b 40 48             	mov    0x48(%eax),%eax
}
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80233c:	89 d0                	mov    %edx,%eax
  80233e:	c1 e8 16             	shr    $0x16,%eax
  802341:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80234d:	f6 c1 01             	test   $0x1,%cl
  802350:	74 1d                	je     80236f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802352:	c1 ea 0c             	shr    $0xc,%edx
  802355:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80235c:	f6 c2 01             	test   $0x1,%dl
  80235f:	74 0e                	je     80236f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802361:	c1 ea 0c             	shr    $0xc,%edx
  802364:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80236b:	ef 
  80236c:	0f b7 c0             	movzwl %ax,%eax
}
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	66 90                	xchg   %ax,%ax
  802373:	66 90                	xchg   %ax,%ax
  802375:	66 90                	xchg   %ax,%ax
  802377:	66 90                	xchg   %ax,%ax
  802379:	66 90                	xchg   %ax,%ax
  80237b:	66 90                	xchg   %ax,%ax
  80237d:	66 90                	xchg   %ax,%ax
  80237f:	90                   	nop

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
