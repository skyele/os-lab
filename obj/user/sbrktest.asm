
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
  80003e:	e8 17 0f 00 00       	call   800f5a <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 07 0f 00 00       	call   800f5a <sys_sbrk>

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
  800094:	68 60 12 80 00       	push   $0x801260
  800099:	e8 59 01 00 00       	call   8001f7 <cprintf>
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
  8000ac:	68 40 12 80 00       	push   $0x801240
  8000b1:	e8 41 01 00 00       	call   8001f7 <cprintf>
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
  8000c4:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000cb:	00 00 00 
	envid_t find = sys_getenvid();
  8000ce:	e8 37 0c 00 00       	call   800d0a <sys_getenvid>
  8000d3:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
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
  80011c:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800126:	7e 0a                	jle    800132 <libmain+0x77>
		binaryname = argv[0];
  800128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012b:	8b 00                	mov    (%eax),%eax
  80012d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	ff 75 0c             	pushl  0xc(%ebp)
  800138:	ff 75 08             	pushl  0x8(%ebp)
  80013b:	e8 f3 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800140:	e8 0b 00 00 00       	call   800150 <exit>
}
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014b:	5b                   	pop    %ebx
  80014c:	5e                   	pop    %esi
  80014d:	5f                   	pop    %edi
  80014e:	5d                   	pop    %ebp
  80014f:	c3                   	ret    

00800150 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800156:	6a 00                	push   $0x0
  800158:	e8 6c 0b 00 00       	call   800cc9 <sys_env_destroy>
}
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	53                   	push   %ebx
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016c:	8b 13                	mov    (%ebx),%edx
  80016e:	8d 42 01             	lea    0x1(%edx),%eax
  800171:	89 03                	mov    %eax,(%ebx)
  800173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800176:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017f:	74 09                	je     80018a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800181:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800188:	c9                   	leave  
  800189:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	68 ff 00 00 00       	push   $0xff
  800192:	8d 43 08             	lea    0x8(%ebx),%eax
  800195:	50                   	push   %eax
  800196:	e8 f1 0a 00 00       	call   800c8c <sys_cputs>
		b->idx = 0;
  80019b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	eb db                	jmp    800181 <putch+0x1f>

008001a6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b6:	00 00 00 
	b.cnt = 0;
  8001b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c3:	ff 75 0c             	pushl  0xc(%ebp)
  8001c6:	ff 75 08             	pushl  0x8(%ebp)
  8001c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cf:	50                   	push   %eax
  8001d0:	68 62 01 80 00       	push   $0x800162
  8001d5:	e8 4a 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001da:	83 c4 08             	add    $0x8,%esp
  8001dd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 9d 0a 00 00       	call   800c8c <sys_cputs>

	return b.cnt;
}
  8001ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800200:	50                   	push   %eax
  800201:	ff 75 08             	pushl  0x8(%ebp)
  800204:	e8 9d ff ff ff       	call   8001a6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	83 ec 1c             	sub    $0x1c,%esp
  800214:	89 c6                	mov    %eax,%esi
  800216:	89 d7                	mov    %edx,%edi
  800218:	8b 45 08             	mov    0x8(%ebp),%eax
  80021b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800221:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800224:	8b 45 10             	mov    0x10(%ebp),%eax
  800227:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80022a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022e:	74 2c                	je     80025c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800230:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800233:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80023a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80023d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800240:	39 c2                	cmp    %eax,%edx
  800242:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800245:	73 43                	jae    80028a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800247:	83 eb 01             	sub    $0x1,%ebx
  80024a:	85 db                	test   %ebx,%ebx
  80024c:	7e 6c                	jle    8002ba <printnum+0xaf>
				putch(padc, putdat);
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	57                   	push   %edi
  800252:	ff 75 18             	pushl  0x18(%ebp)
  800255:	ff d6                	call   *%esi
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	eb eb                	jmp    800247 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	6a 20                	push   $0x20
  800261:	6a 00                	push   $0x0
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	ff 75 e0             	pushl  -0x20(%ebp)
  80026a:	89 fa                	mov    %edi,%edx
  80026c:	89 f0                	mov    %esi,%eax
  80026e:	e8 98 ff ff ff       	call   80020b <printnum>
		while (--width > 0)
  800273:	83 c4 20             	add    $0x20,%esp
  800276:	83 eb 01             	sub    $0x1,%ebx
  800279:	85 db                	test   %ebx,%ebx
  80027b:	7e 65                	jle    8002e2 <printnum+0xd7>
			putch(padc, putdat);
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	57                   	push   %edi
  800281:	6a 20                	push   $0x20
  800283:	ff d6                	call   *%esi
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	eb ec                	jmp    800276 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	ff 75 18             	pushl  0x18(%ebp)
  800290:	83 eb 01             	sub    $0x1,%ebx
  800293:	53                   	push   %ebx
  800294:	50                   	push   %eax
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	ff 75 dc             	pushl  -0x24(%ebp)
  80029b:	ff 75 d8             	pushl  -0x28(%ebp)
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a4:	e8 37 0d 00 00       	call   800fe0 <__udivdi3>
  8002a9:	83 c4 18             	add    $0x18,%esp
  8002ac:	52                   	push   %edx
  8002ad:	50                   	push   %eax
  8002ae:	89 fa                	mov    %edi,%edx
  8002b0:	89 f0                	mov    %esi,%eax
  8002b2:	e8 54 ff ff ff       	call   80020b <printnum>
  8002b7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	57                   	push   %edi
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cd:	e8 1e 0e 00 00       	call   8010f0 <__umoddi3>
  8002d2:	83 c4 14             	add    $0x14,%esp
  8002d5:	0f be 80 79 12 80 00 	movsbl 0x801279(%eax),%eax
  8002dc:	50                   	push   %eax
  8002dd:	ff d6                	call   *%esi
  8002df:	83 c4 10             	add    $0x10,%esp
	}
}
  8002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f4:	8b 10                	mov    (%eax),%edx
  8002f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f9:	73 0a                	jae    800305 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fe:	89 08                	mov    %ecx,(%eax)
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	88 02                	mov    %al,(%edx)
}
  800305:	5d                   	pop    %ebp
  800306:	c3                   	ret    

00800307 <printfmt>:
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 05 00 00 00       	call   800324 <vprintfmt>
}
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vprintfmt>:
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	57                   	push   %edi
  800328:	56                   	push   %esi
  800329:	53                   	push   %ebx
  80032a:	83 ec 3c             	sub    $0x3c,%esp
  80032d:	8b 75 08             	mov    0x8(%ebp),%esi
  800330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800333:	8b 7d 10             	mov    0x10(%ebp),%edi
  800336:	e9 32 04 00 00       	jmp    80076d <vprintfmt+0x449>
		padc = ' ';
  80033b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80033f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800346:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80034d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800354:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8d 47 01             	lea    0x1(%edi),%eax
  80036a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036d:	0f b6 17             	movzbl (%edi),%edx
  800370:	8d 42 dd             	lea    -0x23(%edx),%eax
  800373:	3c 55                	cmp    $0x55,%al
  800375:	0f 87 12 05 00 00    	ja     80088d <vprintfmt+0x569>
  80037b:	0f b6 c0             	movzbl %al,%eax
  80037e:	ff 24 85 60 14 80 00 	jmp    *0x801460(,%eax,4)
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800388:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80038c:	eb d9                	jmp    800367 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800391:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800395:	eb d0                	jmp    800367 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800397:	0f b6 d2             	movzbl %dl,%edx
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039d:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a5:	eb 03                	jmp    8003aa <vprintfmt+0x86>
  8003a7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b7:	83 fe 09             	cmp    $0x9,%esi
  8003ba:	76 eb                	jbe    8003a7 <vprintfmt+0x83>
  8003bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c2:	eb 14                	jmp    8003d8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 40 04             	lea    0x4(%eax),%eax
  8003d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003dc:	79 89                	jns    800367 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003eb:	e9 77 ff ff ff       	jmp    800367 <vprintfmt+0x43>
  8003f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	0f 48 c1             	cmovs  %ecx,%eax
  8003f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003fe:	e9 64 ff ff ff       	jmp    800367 <vprintfmt+0x43>
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800406:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80040d:	e9 55 ff ff ff       	jmp    800367 <vprintfmt+0x43>
			lflag++;
  800412:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800419:	e9 49 ff ff ff       	jmp    800367 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 78 04             	lea    0x4(%eax),%edi
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	53                   	push   %ebx
  800428:	ff 30                	pushl  (%eax)
  80042a:	ff d6                	call   *%esi
			break;
  80042c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800432:	e9 33 03 00 00       	jmp    80076a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 78 04             	lea    0x4(%eax),%edi
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	99                   	cltd   
  800440:	31 d0                	xor    %edx,%eax
  800442:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800444:	83 f8 0f             	cmp    $0xf,%eax
  800447:	7f 23                	jg     80046c <vprintfmt+0x148>
  800449:	8b 14 85 c0 15 80 00 	mov    0x8015c0(,%eax,4),%edx
  800450:	85 d2                	test   %edx,%edx
  800452:	74 18                	je     80046c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800454:	52                   	push   %edx
  800455:	68 9a 12 80 00       	push   $0x80129a
  80045a:	53                   	push   %ebx
  80045b:	56                   	push   %esi
  80045c:	e8 a6 fe ff ff       	call   800307 <printfmt>
  800461:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800464:	89 7d 14             	mov    %edi,0x14(%ebp)
  800467:	e9 fe 02 00 00       	jmp    80076a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046c:	50                   	push   %eax
  80046d:	68 91 12 80 00       	push   $0x801291
  800472:	53                   	push   %ebx
  800473:	56                   	push   %esi
  800474:	e8 8e fe ff ff       	call   800307 <printfmt>
  800479:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047f:	e9 e6 02 00 00       	jmp    80076a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	83 c0 04             	add    $0x4,%eax
  80048a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800492:	85 c9                	test   %ecx,%ecx
  800494:	b8 8a 12 80 00       	mov    $0x80128a,%eax
  800499:	0f 45 c1             	cmovne %ecx,%eax
  80049c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80049f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a3:	7e 06                	jle    8004ab <vprintfmt+0x187>
  8004a5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a9:	75 0d                	jne    8004b8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ae:	89 c7                	mov    %eax,%edi
  8004b0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b6:	eb 53                	jmp    80050b <vprintfmt+0x1e7>
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	e8 71 04 00 00       	call   800935 <strnlen>
  8004c4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c7:	29 c1                	sub    %eax,%ecx
  8004c9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	eb 0f                	jmp    8004e9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	83 ef 01             	sub    $0x1,%edi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	7f ed                	jg     8004da <vprintfmt+0x1b6>
  8004ed:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004f0:	85 c9                	test   %ecx,%ecx
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	0f 49 c1             	cmovns %ecx,%eax
  8004fa:	29 c1                	sub    %eax,%ecx
  8004fc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004ff:	eb aa                	jmp    8004ab <vprintfmt+0x187>
					putch(ch, putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	52                   	push   %edx
  800506:	ff d6                	call   *%esi
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800510:	83 c7 01             	add    $0x1,%edi
  800513:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800517:	0f be d0             	movsbl %al,%edx
  80051a:	85 d2                	test   %edx,%edx
  80051c:	74 4b                	je     800569 <vprintfmt+0x245>
  80051e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800522:	78 06                	js     80052a <vprintfmt+0x206>
  800524:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800528:	78 1e                	js     800548 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80052a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80052e:	74 d1                	je     800501 <vprintfmt+0x1dd>
  800530:	0f be c0             	movsbl %al,%eax
  800533:	83 e8 20             	sub    $0x20,%eax
  800536:	83 f8 5e             	cmp    $0x5e,%eax
  800539:	76 c6                	jbe    800501 <vprintfmt+0x1dd>
					putch('?', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 3f                	push   $0x3f
  800541:	ff d6                	call   *%esi
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	eb c3                	jmp    80050b <vprintfmt+0x1e7>
  800548:	89 cf                	mov    %ecx,%edi
  80054a:	eb 0e                	jmp    80055a <vprintfmt+0x236>
				putch(' ', putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	53                   	push   %ebx
  800550:	6a 20                	push   $0x20
  800552:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800554:	83 ef 01             	sub    $0x1,%edi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	85 ff                	test   %edi,%edi
  80055c:	7f ee                	jg     80054c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80055e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
  800564:	e9 01 02 00 00       	jmp    80076a <vprintfmt+0x446>
  800569:	89 cf                	mov    %ecx,%edi
  80056b:	eb ed                	jmp    80055a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800570:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800577:	e9 eb fd ff ff       	jmp    800367 <vprintfmt+0x43>
	if (lflag >= 2)
  80057c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800580:	7f 21                	jg     8005a3 <vprintfmt+0x27f>
	else if (lflag)
  800582:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800586:	74 68                	je     8005f0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800590:	89 c1                	mov    %eax,%ecx
  800592:	c1 f9 1f             	sar    $0x1f,%ecx
  800595:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a1:	eb 17                	jmp    8005ba <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8b 50 04             	mov    0x4(%eax),%edx
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 40 08             	lea    0x8(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ca:	78 3f                	js     80060b <vprintfmt+0x2e7>
			base = 10;
  8005cc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005d1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d5:	0f 84 71 01 00 00    	je     80074c <vprintfmt+0x428>
				putch('+', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 2b                	push   $0x2b
  8005e1:	ff d6                	call   *%esi
  8005e3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 5c 01 00 00       	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f8:	89 c1                	mov    %eax,%ecx
  8005fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb af                	jmp    8005ba <vprintfmt+0x296>
				putch('-', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 2d                	push   $0x2d
  800611:	ff d6                	call   *%esi
				num = -(long long) num;
  800613:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800616:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800619:	f7 d8                	neg    %eax
  80061b:	83 d2 00             	adc    $0x0,%edx
  80061e:	f7 da                	neg    %edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800629:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062e:	e9 19 01 00 00       	jmp    80074c <vprintfmt+0x428>
	if (lflag >= 2)
  800633:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800637:	7f 29                	jg     800662 <vprintfmt+0x33e>
	else if (lflag)
  800639:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80063d:	74 44                	je     800683 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	e9 ea 00 00 00       	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 08             	lea    0x8(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800679:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067e:	e9 c9 00 00 00       	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a1:	e9 a6 00 00 00       	jmp    80074c <vprintfmt+0x428>
			putch('0', putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	53                   	push   %ebx
  8006aa:	6a 30                	push   $0x30
  8006ac:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b5:	7f 26                	jg     8006dd <vprintfmt+0x3b9>
	else if (lflag)
  8006b7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006bb:	74 3e                	je     8006fb <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006db:	eb 6f                	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 50 04             	mov    0x4(%eax),%edx
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 08             	lea    0x8(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f9:	eb 51                	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800714:	b8 08 00 00 00       	mov    $0x8,%eax
  800719:	eb 31                	jmp    80074c <vprintfmt+0x428>
			putch('0', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 30                	push   $0x30
  800721:	ff d6                	call   *%esi
			putch('x', putdat);
  800723:	83 c4 08             	add    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 78                	push   $0x78
  800729:	ff d6                	call   *%esi
			num = (unsigned long long)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80073b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800747:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800753:	52                   	push   %edx
  800754:	ff 75 e0             	pushl  -0x20(%ebp)
  800757:	50                   	push   %eax
  800758:	ff 75 dc             	pushl  -0x24(%ebp)
  80075b:	ff 75 d8             	pushl  -0x28(%ebp)
  80075e:	89 da                	mov    %ebx,%edx
  800760:	89 f0                	mov    %esi,%eax
  800762:	e8 a4 fa ff ff       	call   80020b <printnum>
			break;
  800767:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80076a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076d:	83 c7 01             	add    $0x1,%edi
  800770:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800774:	83 f8 25             	cmp    $0x25,%eax
  800777:	0f 84 be fb ff ff    	je     80033b <vprintfmt+0x17>
			if (ch == '\0')
  80077d:	85 c0                	test   %eax,%eax
  80077f:	0f 84 28 01 00 00    	je     8008ad <vprintfmt+0x589>
			putch(ch, putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	53                   	push   %ebx
  800789:	50                   	push   %eax
  80078a:	ff d6                	call   *%esi
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	eb dc                	jmp    80076d <vprintfmt+0x449>
	if (lflag >= 2)
  800791:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800795:	7f 26                	jg     8007bd <vprintfmt+0x499>
	else if (lflag)
  800797:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80079b:	74 41                	je     8007de <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 04             	lea    0x4(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bb:	eb 8f                	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 50 04             	mov    0x4(%eax),%edx
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8d 40 08             	lea    0x8(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d9:	e9 6e ff ff ff       	jmp    80074c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fc:	e9 4b ff ff ff       	jmp    80074c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 c0 04             	add    $0x4,%eax
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 14                	je     800827 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800813:	8b 13                	mov    (%ebx),%edx
  800815:	83 fa 7f             	cmp    $0x7f,%edx
  800818:	7f 37                	jg     800851 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80081a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80081c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
  800822:	e9 43 ff ff ff       	jmp    80076a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800827:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082c:	bf b1 13 80 00       	mov    $0x8013b1,%edi
							putch(ch, putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	50                   	push   %eax
  800836:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800838:	83 c7 01             	add    $0x1,%edi
  80083b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 c0                	test   %eax,%eax
  800844:	75 eb                	jne    800831 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800846:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	e9 19 ff ff ff       	jmp    80076a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800851:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800853:	b8 0a 00 00 00       	mov    $0xa,%eax
  800858:	bf e9 13 80 00       	mov    $0x8013e9,%edi
							putch(ch, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	50                   	push   %eax
  800862:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800864:	83 c7 01             	add    $0x1,%edi
  800867:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	75 eb                	jne    80085d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800872:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
  800878:	e9 ed fe ff ff       	jmp    80076a <vprintfmt+0x446>
			putch(ch, putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	6a 25                	push   $0x25
  800883:	ff d6                	call   *%esi
			break;
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	e9 dd fe ff ff       	jmp    80076a <vprintfmt+0x446>
			putch('%', putdat);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	53                   	push   %ebx
  800891:	6a 25                	push   $0x25
  800893:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	89 f8                	mov    %edi,%eax
  80089a:	eb 03                	jmp    80089f <vprintfmt+0x57b>
  80089c:	83 e8 01             	sub    $0x1,%eax
  80089f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a3:	75 f7                	jne    80089c <vprintfmt+0x578>
  8008a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a8:	e9 bd fe ff ff       	jmp    80076a <vprintfmt+0x446>
}
  8008ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5f                   	pop    %edi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d2:	85 c0                	test   %eax,%eax
  8008d4:	74 26                	je     8008fc <vsnprintf+0x47>
  8008d6:	85 d2                	test   %edx,%edx
  8008d8:	7e 22                	jle    8008fc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008da:	ff 75 14             	pushl  0x14(%ebp)
  8008dd:	ff 75 10             	pushl  0x10(%ebp)
  8008e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e3:	50                   	push   %eax
  8008e4:	68 ea 02 80 00       	push   $0x8002ea
  8008e9:	e8 36 fa ff ff       	call   800324 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
}
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    
		return -E_INVAL;
  8008fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800901:	eb f7                	jmp    8008fa <vsnprintf+0x45>

00800903 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800909:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090c:	50                   	push   %eax
  80090d:	ff 75 10             	pushl  0x10(%ebp)
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	ff 75 08             	pushl  0x8(%ebp)
  800916:	e8 9a ff ff ff       	call   8008b5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800923:	b8 00 00 00 00       	mov    $0x0,%eax
  800928:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092c:	74 05                	je     800933 <strlen+0x16>
		n++;
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	eb f5                	jmp    800928 <strlen+0xb>
	return n;
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093e:	ba 00 00 00 00       	mov    $0x0,%edx
  800943:	39 c2                	cmp    %eax,%edx
  800945:	74 0d                	je     800954 <strnlen+0x1f>
  800947:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80094b:	74 05                	je     800952 <strnlen+0x1d>
		n++;
  80094d:	83 c2 01             	add    $0x1,%edx
  800950:	eb f1                	jmp    800943 <strnlen+0xe>
  800952:	89 d0                	mov    %edx,%eax
	return n;
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800969:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	84 c9                	test   %cl,%cl
  800971:	75 f2                	jne    800965 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800973:	5b                   	pop    %ebx
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	53                   	push   %ebx
  80097a:	83 ec 10             	sub    $0x10,%esp
  80097d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800980:	53                   	push   %ebx
  800981:	e8 97 ff ff ff       	call   80091d <strlen>
  800986:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	01 d8                	add    %ebx,%eax
  80098e:	50                   	push   %eax
  80098f:	e8 c2 ff ff ff       	call   800956 <strcpy>
	return dst;
}
  800994:	89 d8                	mov    %ebx,%eax
  800996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a6:	89 c6                	mov    %eax,%esi
  8009a8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ab:	89 c2                	mov    %eax,%edx
  8009ad:	39 f2                	cmp    %esi,%edx
  8009af:	74 11                	je     8009c2 <strncpy+0x27>
		*dst++ = *src;
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	0f b6 19             	movzbl (%ecx),%ebx
  8009b7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ba:	80 fb 01             	cmp    $0x1,%bl
  8009bd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009c0:	eb eb                	jmp    8009ad <strncpy+0x12>
	}
	return ret;
}
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d6:	85 d2                	test   %edx,%edx
  8009d8:	74 21                	je     8009fb <strlcpy+0x35>
  8009da:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009de:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e0:	39 c2                	cmp    %eax,%edx
  8009e2:	74 14                	je     8009f8 <strlcpy+0x32>
  8009e4:	0f b6 19             	movzbl (%ecx),%ebx
  8009e7:	84 db                	test   %bl,%bl
  8009e9:	74 0b                	je     8009f6 <strlcpy+0x30>
			*dst++ = *src++;
  8009eb:	83 c1 01             	add    $0x1,%ecx
  8009ee:	83 c2 01             	add    $0x1,%edx
  8009f1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f4:	eb ea                	jmp    8009e0 <strlcpy+0x1a>
  8009f6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fb:	29 f0                	sub    %esi,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a07:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0a:	0f b6 01             	movzbl (%ecx),%eax
  800a0d:	84 c0                	test   %al,%al
  800a0f:	74 0c                	je     800a1d <strcmp+0x1c>
  800a11:	3a 02                	cmp    (%edx),%al
  800a13:	75 08                	jne    800a1d <strcmp+0x1c>
		p++, q++;
  800a15:	83 c1 01             	add    $0x1,%ecx
  800a18:	83 c2 01             	add    $0x1,%edx
  800a1b:	eb ed                	jmp    800a0a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 c0             	movzbl %al,%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	89 c3                	mov    %eax,%ebx
  800a33:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a36:	eb 06                	jmp    800a3e <strncmp+0x17>
		n--, p++, q++;
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3e:	39 d8                	cmp    %ebx,%eax
  800a40:	74 16                	je     800a58 <strncmp+0x31>
  800a42:	0f b6 08             	movzbl (%eax),%ecx
  800a45:	84 c9                	test   %cl,%cl
  800a47:	74 04                	je     800a4d <strncmp+0x26>
  800a49:	3a 0a                	cmp    (%edx),%cl
  800a4b:	74 eb                	je     800a38 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4d:	0f b6 00             	movzbl (%eax),%eax
  800a50:	0f b6 12             	movzbl (%edx),%edx
  800a53:	29 d0                	sub    %edx,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    
		return 0;
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	eb f6                	jmp    800a55 <strncmp+0x2e>

00800a5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a69:	0f b6 10             	movzbl (%eax),%edx
  800a6c:	84 d2                	test   %dl,%dl
  800a6e:	74 09                	je     800a79 <strchr+0x1a>
		if (*s == c)
  800a70:	38 ca                	cmp    %cl,%dl
  800a72:	74 0a                	je     800a7e <strchr+0x1f>
	for (; *s; s++)
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	eb f0                	jmp    800a69 <strchr+0xa>
			return (char *) s;
	return 0;
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8d:	38 ca                	cmp    %cl,%dl
  800a8f:	74 09                	je     800a9a <strfind+0x1a>
  800a91:	84 d2                	test   %dl,%dl
  800a93:	74 05                	je     800a9a <strfind+0x1a>
	for (; *s; s++)
  800a95:	83 c0 01             	add    $0x1,%eax
  800a98:	eb f0                	jmp    800a8a <strfind+0xa>
			break;
	return (char *) s;
}
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa8:	85 c9                	test   %ecx,%ecx
  800aaa:	74 31                	je     800add <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aac:	89 f8                	mov    %edi,%eax
  800aae:	09 c8                	or     %ecx,%eax
  800ab0:	a8 03                	test   $0x3,%al
  800ab2:	75 23                	jne    800ad7 <memset+0x3b>
		c &= 0xFF;
  800ab4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab8:	89 d3                	mov    %edx,%ebx
  800aba:	c1 e3 08             	shl    $0x8,%ebx
  800abd:	89 d0                	mov    %edx,%eax
  800abf:	c1 e0 18             	shl    $0x18,%eax
  800ac2:	89 d6                	mov    %edx,%esi
  800ac4:	c1 e6 10             	shl    $0x10,%esi
  800ac7:	09 f0                	or     %esi,%eax
  800ac9:	09 c2                	or     %eax,%edx
  800acb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	fc                   	cld    
  800ad3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad5:	eb 06                	jmp    800add <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	fc                   	cld    
  800adb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800add:	89 f8                	mov    %edi,%eax
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af2:	39 c6                	cmp    %eax,%esi
  800af4:	73 32                	jae    800b28 <memmove+0x44>
  800af6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af9:	39 c2                	cmp    %eax,%edx
  800afb:	76 2b                	jbe    800b28 <memmove+0x44>
		s += n;
		d += n;
  800afd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b00:	89 fe                	mov    %edi,%esi
  800b02:	09 ce                	or     %ecx,%esi
  800b04:	09 d6                	or     %edx,%esi
  800b06:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0c:	75 0e                	jne    800b1c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0e:	83 ef 04             	sub    $0x4,%edi
  800b11:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b17:	fd                   	std    
  800b18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1a:	eb 09                	jmp    800b25 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1c:	83 ef 01             	sub    $0x1,%edi
  800b1f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b22:	fd                   	std    
  800b23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b25:	fc                   	cld    
  800b26:	eb 1a                	jmp    800b42 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	09 ca                	or     %ecx,%edx
  800b2c:	09 f2                	or     %esi,%edx
  800b2e:	f6 c2 03             	test   $0x3,%dl
  800b31:	75 0a                	jne    800b3d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b36:	89 c7                	mov    %eax,%edi
  800b38:	fc                   	cld    
  800b39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3b:	eb 05                	jmp    800b42 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b3d:	89 c7                	mov    %eax,%edi
  800b3f:	fc                   	cld    
  800b40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4c:	ff 75 10             	pushl  0x10(%ebp)
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	ff 75 08             	pushl  0x8(%ebp)
  800b55:	e8 8a ff ff ff       	call   800ae4 <memmove>
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 c6                	mov    %eax,%esi
  800b69:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6c:	39 f0                	cmp    %esi,%eax
  800b6e:	74 1c                	je     800b8c <memcmp+0x30>
		if (*s1 != *s2)
  800b70:	0f b6 08             	movzbl (%eax),%ecx
  800b73:	0f b6 1a             	movzbl (%edx),%ebx
  800b76:	38 d9                	cmp    %bl,%cl
  800b78:	75 08                	jne    800b82 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	83 c2 01             	add    $0x1,%edx
  800b80:	eb ea                	jmp    800b6c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b82:	0f b6 c1             	movzbl %cl,%eax
  800b85:	0f b6 db             	movzbl %bl,%ebx
  800b88:	29 d8                	sub    %ebx,%eax
  800b8a:	eb 05                	jmp    800b91 <memcmp+0x35>
	}

	return 0;
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9e:	89 c2                	mov    %eax,%edx
  800ba0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba3:	39 d0                	cmp    %edx,%eax
  800ba5:	73 09                	jae    800bb0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba7:	38 08                	cmp    %cl,(%eax)
  800ba9:	74 05                	je     800bb0 <memfind+0x1b>
	for (; s < ends; s++)
  800bab:	83 c0 01             	add    $0x1,%eax
  800bae:	eb f3                	jmp    800ba3 <memfind+0xe>
			break;
	return (void *) s;
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbe:	eb 03                	jmp    800bc3 <strtol+0x11>
		s++;
  800bc0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc3:	0f b6 01             	movzbl (%ecx),%eax
  800bc6:	3c 20                	cmp    $0x20,%al
  800bc8:	74 f6                	je     800bc0 <strtol+0xe>
  800bca:	3c 09                	cmp    $0x9,%al
  800bcc:	74 f2                	je     800bc0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bce:	3c 2b                	cmp    $0x2b,%al
  800bd0:	74 2a                	je     800bfc <strtol+0x4a>
	int neg = 0;
  800bd2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd7:	3c 2d                	cmp    $0x2d,%al
  800bd9:	74 2b                	je     800c06 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be1:	75 0f                	jne    800bf2 <strtol+0x40>
  800be3:	80 39 30             	cmpb   $0x30,(%ecx)
  800be6:	74 28                	je     800c10 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be8:	85 db                	test   %ebx,%ebx
  800bea:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bef:	0f 44 d8             	cmove  %eax,%ebx
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bfa:	eb 50                	jmp    800c4c <strtol+0x9a>
		s++;
  800bfc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bff:	bf 00 00 00 00       	mov    $0x0,%edi
  800c04:	eb d5                	jmp    800bdb <strtol+0x29>
		s++, neg = 1;
  800c06:	83 c1 01             	add    $0x1,%ecx
  800c09:	bf 01 00 00 00       	mov    $0x1,%edi
  800c0e:	eb cb                	jmp    800bdb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c10:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c14:	74 0e                	je     800c24 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c16:	85 db                	test   %ebx,%ebx
  800c18:	75 d8                	jne    800bf2 <strtol+0x40>
		s++, base = 8;
  800c1a:	83 c1 01             	add    $0x1,%ecx
  800c1d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c22:	eb ce                	jmp    800bf2 <strtol+0x40>
		s += 2, base = 16;
  800c24:	83 c1 02             	add    $0x2,%ecx
  800c27:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c2c:	eb c4                	jmp    800bf2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c2e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c31:	89 f3                	mov    %esi,%ebx
  800c33:	80 fb 19             	cmp    $0x19,%bl
  800c36:	77 29                	ja     800c61 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c38:	0f be d2             	movsbl %dl,%edx
  800c3b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c41:	7d 30                	jge    800c73 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c43:	83 c1 01             	add    $0x1,%ecx
  800c46:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4c:	0f b6 11             	movzbl (%ecx),%edx
  800c4f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c52:	89 f3                	mov    %esi,%ebx
  800c54:	80 fb 09             	cmp    $0x9,%bl
  800c57:	77 d5                	ja     800c2e <strtol+0x7c>
			dig = *s - '0';
  800c59:	0f be d2             	movsbl %dl,%edx
  800c5c:	83 ea 30             	sub    $0x30,%edx
  800c5f:	eb dd                	jmp    800c3e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c61:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c64:	89 f3                	mov    %esi,%ebx
  800c66:	80 fb 19             	cmp    $0x19,%bl
  800c69:	77 08                	ja     800c73 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c6b:	0f be d2             	movsbl %dl,%edx
  800c6e:	83 ea 37             	sub    $0x37,%edx
  800c71:	eb cb                	jmp    800c3e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c77:	74 05                	je     800c7e <strtol+0xcc>
		*endptr = (char *) s;
  800c79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	f7 da                	neg    %edx
  800c82:	85 ff                	test   %edi,%edi
  800c84:	0f 45 c2             	cmovne %edx,%eax
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	89 c3                	mov    %eax,%ebx
  800c9f:	89 c7                	mov    %eax,%edi
  800ca1:	89 c6                	mov    %eax,%esi
  800ca3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_cgetc>:

int
sys_cgetc(void)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cba:	89 d1                	mov    %edx,%ecx
  800cbc:	89 d3                	mov    %edx,%ebx
  800cbe:	89 d7                	mov    %edx,%edi
  800cc0:	89 d6                	mov    %edx,%esi
  800cc2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdf:	89 cb                	mov    %ecx,%ebx
  800ce1:	89 cf                	mov    %ecx,%edi
  800ce3:	89 ce                	mov    %ecx,%esi
  800ce5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	7f 08                	jg     800cf3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	50                   	push   %eax
  800cf7:	6a 03                	push   $0x3
  800cf9:	68 00 16 80 00       	push   $0x801600
  800cfe:	6a 43                	push   $0x43
  800d00:	68 1d 16 80 00       	push   $0x80161d
  800d05:	e8 70 02 00 00       	call   800f7a <_panic>

00800d0a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
  800d15:	b8 02 00 00 00       	mov    $0x2,%eax
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	89 d7                	mov    %edx,%edi
  800d20:	89 d6                	mov    %edx,%esi
  800d22:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_yield>:

void
sys_yield(void)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d39:	89 d1                	mov    %edx,%ecx
  800d3b:	89 d3                	mov    %edx,%ebx
  800d3d:	89 d7                	mov    %edx,%edi
  800d3f:	89 d6                	mov    %edx,%esi
  800d41:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	be 00 00 00 00       	mov    $0x0,%esi
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d64:	89 f7                	mov    %esi,%edi
  800d66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d68:	85 c0                	test   %eax,%eax
  800d6a:	7f 08                	jg     800d74 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 04                	push   $0x4
  800d7a:	68 00 16 80 00       	push   $0x801600
  800d7f:	6a 43                	push   $0x43
  800d81:	68 1d 16 80 00       	push   $0x80161d
  800d86:	e8 ef 01 00 00       	call   800f7a <_panic>

00800d8b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da5:	8b 75 18             	mov    0x18(%ebp),%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 05                	push   $0x5
  800dbc:	68 00 16 80 00       	push   $0x801600
  800dc1:	6a 43                	push   $0x43
  800dc3:	68 1d 16 80 00       	push   $0x80161d
  800dc8:	e8 ad 01 00 00       	call   800f7a <_panic>

00800dcd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 06 00 00 00       	mov    $0x6,%eax
  800de6:	89 df                	mov    %ebx,%edi
  800de8:	89 de                	mov    %ebx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 06                	push   $0x6
  800dfe:	68 00 16 80 00       	push   $0x801600
  800e03:	6a 43                	push   $0x43
  800e05:	68 1d 16 80 00       	push   $0x80161d
  800e0a:	e8 6b 01 00 00       	call   800f7a <_panic>

00800e0f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
  800e15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	b8 08 00 00 00       	mov    $0x8,%eax
  800e28:	89 df                	mov    %ebx,%edi
  800e2a:	89 de                	mov    %ebx,%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 08                	push   $0x8
  800e40:	68 00 16 80 00       	push   $0x801600
  800e45:	6a 43                	push   $0x43
  800e47:	68 1d 16 80 00       	push   $0x80161d
  800e4c:	e8 29 01 00 00       	call   800f7a <_panic>

00800e51 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6a:	89 df                	mov    %ebx,%edi
  800e6c:	89 de                	mov    %ebx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 09                	push   $0x9
  800e82:	68 00 16 80 00       	push   $0x801600
  800e87:	6a 43                	push   $0x43
  800e89:	68 1d 16 80 00       	push   $0x80161d
  800e8e:	e8 e7 00 00 00       	call   800f7a <_panic>

00800e93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7f 08                	jg     800ebe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	50                   	push   %eax
  800ec2:	6a 0a                	push   $0xa
  800ec4:	68 00 16 80 00       	push   $0x801600
  800ec9:	6a 43                	push   $0x43
  800ecb:	68 1d 16 80 00       	push   $0x80161d
  800ed0:	e8 a5 00 00 00       	call   800f7a <_panic>

00800ed5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee6:	be 00 00 00 00       	mov    $0x0,%esi
  800eeb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0e:	89 cb                	mov    %ecx,%ebx
  800f10:	89 cf                	mov    %ecx,%edi
  800f12:	89 ce                	mov    %ecx,%esi
  800f14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	7f 08                	jg     800f22 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	83 ec 0c             	sub    $0xc,%esp
  800f25:	50                   	push   %eax
  800f26:	6a 0d                	push   $0xd
  800f28:	68 00 16 80 00       	push   $0x801600
  800f2d:	6a 43                	push   $0x43
  800f2f:	68 1d 16 80 00       	push   $0x80161d
  800f34:	e8 41 00 00 00       	call   800f7a <_panic>

00800f39 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4f:	89 df                	mov    %ebx,%edi
  800f51:	89 de                	mov    %ebx,%esi
  800f53:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f60:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f6d:	89 cb                	mov    %ecx,%ebx
  800f6f:	89 cf                	mov    %ecx,%edi
  800f71:	89 ce                	mov    %ecx,%esi
  800f73:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f7f:	a1 04 20 80 00       	mov    0x802004,%eax
  800f84:	8b 40 48             	mov    0x48(%eax),%eax
  800f87:	83 ec 04             	sub    $0x4,%esp
  800f8a:	68 5c 16 80 00       	push   $0x80165c
  800f8f:	50                   	push   %eax
  800f90:	68 2b 16 80 00       	push   $0x80162b
  800f95:	e8 5d f2 ff ff       	call   8001f7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f9a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f9d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800fa3:	e8 62 fd ff ff       	call   800d0a <sys_getenvid>
  800fa8:	83 c4 04             	add    $0x4,%esp
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	ff 75 08             	pushl  0x8(%ebp)
  800fb1:	56                   	push   %esi
  800fb2:	50                   	push   %eax
  800fb3:	68 38 16 80 00       	push   $0x801638
  800fb8:	e8 3a f2 ff ff       	call   8001f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800fbd:	83 c4 18             	add    $0x18,%esp
  800fc0:	53                   	push   %ebx
  800fc1:	ff 75 10             	pushl  0x10(%ebp)
  800fc4:	e8 dd f1 ff ff       	call   8001a6 <vcprintf>
	cprintf("\n");
  800fc9:	c7 04 24 6d 12 80 00 	movl   $0x80126d,(%esp)
  800fd0:	e8 22 f2 ff ff       	call   8001f7 <cprintf>
  800fd5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800fd8:	cc                   	int3   
  800fd9:	eb fd                	jmp    800fd8 <_panic+0x5e>
  800fdb:	66 90                	xchg   %ax,%ax
  800fdd:	66 90                	xchg   %ax,%ax
  800fdf:	90                   	nop

00800fe0 <__udivdi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800feb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fef:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ff3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ff7:	85 d2                	test   %edx,%edx
  800ff9:	75 4d                	jne    801048 <__udivdi3+0x68>
  800ffb:	39 f3                	cmp    %esi,%ebx
  800ffd:	76 19                	jbe    801018 <__udivdi3+0x38>
  800fff:	31 ff                	xor    %edi,%edi
  801001:	89 e8                	mov    %ebp,%eax
  801003:	89 f2                	mov    %esi,%edx
  801005:	f7 f3                	div    %ebx
  801007:	89 fa                	mov    %edi,%edx
  801009:	83 c4 1c             	add    $0x1c,%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
  801011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801018:	89 d9                	mov    %ebx,%ecx
  80101a:	85 db                	test   %ebx,%ebx
  80101c:	75 0b                	jne    801029 <__udivdi3+0x49>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f3                	div    %ebx
  801027:	89 c1                	mov    %eax,%ecx
  801029:	31 d2                	xor    %edx,%edx
  80102b:	89 f0                	mov    %esi,%eax
  80102d:	f7 f1                	div    %ecx
  80102f:	89 c6                	mov    %eax,%esi
  801031:	89 e8                	mov    %ebp,%eax
  801033:	89 f7                	mov    %esi,%edi
  801035:	f7 f1                	div    %ecx
  801037:	89 fa                	mov    %edi,%edx
  801039:	83 c4 1c             	add    $0x1c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801048:	39 f2                	cmp    %esi,%edx
  80104a:	77 1c                	ja     801068 <__udivdi3+0x88>
  80104c:	0f bd fa             	bsr    %edx,%edi
  80104f:	83 f7 1f             	xor    $0x1f,%edi
  801052:	75 2c                	jne    801080 <__udivdi3+0xa0>
  801054:	39 f2                	cmp    %esi,%edx
  801056:	72 06                	jb     80105e <__udivdi3+0x7e>
  801058:	31 c0                	xor    %eax,%eax
  80105a:	39 eb                	cmp    %ebp,%ebx
  80105c:	77 a9                	ja     801007 <__udivdi3+0x27>
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
  801063:	eb a2                	jmp    801007 <__udivdi3+0x27>
  801065:	8d 76 00             	lea    0x0(%esi),%esi
  801068:	31 ff                	xor    %edi,%edi
  80106a:	31 c0                	xor    %eax,%eax
  80106c:	89 fa                	mov    %edi,%edx
  80106e:	83 c4 1c             	add    $0x1c,%esp
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    
  801076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80107d:	8d 76 00             	lea    0x0(%esi),%esi
  801080:	89 f9                	mov    %edi,%ecx
  801082:	b8 20 00 00 00       	mov    $0x20,%eax
  801087:	29 f8                	sub    %edi,%eax
  801089:	d3 e2                	shl    %cl,%edx
  80108b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80108f:	89 c1                	mov    %eax,%ecx
  801091:	89 da                	mov    %ebx,%edx
  801093:	d3 ea                	shr    %cl,%edx
  801095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801099:	09 d1                	or     %edx,%ecx
  80109b:	89 f2                	mov    %esi,%edx
  80109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010a1:	89 f9                	mov    %edi,%ecx
  8010a3:	d3 e3                	shl    %cl,%ebx
  8010a5:	89 c1                	mov    %eax,%ecx
  8010a7:	d3 ea                	shr    %cl,%edx
  8010a9:	89 f9                	mov    %edi,%ecx
  8010ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010af:	89 eb                	mov    %ebp,%ebx
  8010b1:	d3 e6                	shl    %cl,%esi
  8010b3:	89 c1                	mov    %eax,%ecx
  8010b5:	d3 eb                	shr    %cl,%ebx
  8010b7:	09 de                	or     %ebx,%esi
  8010b9:	89 f0                	mov    %esi,%eax
  8010bb:	f7 74 24 08          	divl   0x8(%esp)
  8010bf:	89 d6                	mov    %edx,%esi
  8010c1:	89 c3                	mov    %eax,%ebx
  8010c3:	f7 64 24 0c          	mull   0xc(%esp)
  8010c7:	39 d6                	cmp    %edx,%esi
  8010c9:	72 15                	jb     8010e0 <__udivdi3+0x100>
  8010cb:	89 f9                	mov    %edi,%ecx
  8010cd:	d3 e5                	shl    %cl,%ebp
  8010cf:	39 c5                	cmp    %eax,%ebp
  8010d1:	73 04                	jae    8010d7 <__udivdi3+0xf7>
  8010d3:	39 d6                	cmp    %edx,%esi
  8010d5:	74 09                	je     8010e0 <__udivdi3+0x100>
  8010d7:	89 d8                	mov    %ebx,%eax
  8010d9:	31 ff                	xor    %edi,%edi
  8010db:	e9 27 ff ff ff       	jmp    801007 <__udivdi3+0x27>
  8010e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010e3:	31 ff                	xor    %edi,%edi
  8010e5:	e9 1d ff ff ff       	jmp    801007 <__udivdi3+0x27>
  8010ea:	66 90                	xchg   %ax,%ax
  8010ec:	66 90                	xchg   %ax,%ax
  8010ee:	66 90                	xchg   %ax,%ax

008010f0 <__umoddi3>:
  8010f0:	55                   	push   %ebp
  8010f1:	57                   	push   %edi
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 1c             	sub    $0x1c,%esp
  8010f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801103:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801107:	89 da                	mov    %ebx,%edx
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 43                	jne    801150 <__umoddi3+0x60>
  80110d:	39 df                	cmp    %ebx,%edi
  80110f:	76 17                	jbe    801128 <__umoddi3+0x38>
  801111:	89 f0                	mov    %esi,%eax
  801113:	f7 f7                	div    %edi
  801115:	89 d0                	mov    %edx,%eax
  801117:	31 d2                	xor    %edx,%edx
  801119:	83 c4 1c             	add    $0x1c,%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    
  801121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801128:	89 fd                	mov    %edi,%ebp
  80112a:	85 ff                	test   %edi,%edi
  80112c:	75 0b                	jne    801139 <__umoddi3+0x49>
  80112e:	b8 01 00 00 00       	mov    $0x1,%eax
  801133:	31 d2                	xor    %edx,%edx
  801135:	f7 f7                	div    %edi
  801137:	89 c5                	mov    %eax,%ebp
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	31 d2                	xor    %edx,%edx
  80113d:	f7 f5                	div    %ebp
  80113f:	89 f0                	mov    %esi,%eax
  801141:	f7 f5                	div    %ebp
  801143:	89 d0                	mov    %edx,%eax
  801145:	eb d0                	jmp    801117 <__umoddi3+0x27>
  801147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80114e:	66 90                	xchg   %ax,%ax
  801150:	89 f1                	mov    %esi,%ecx
  801152:	39 d8                	cmp    %ebx,%eax
  801154:	76 0a                	jbe    801160 <__umoddi3+0x70>
  801156:	89 f0                	mov    %esi,%eax
  801158:	83 c4 1c             	add    $0x1c,%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5f                   	pop    %edi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    
  801160:	0f bd e8             	bsr    %eax,%ebp
  801163:	83 f5 1f             	xor    $0x1f,%ebp
  801166:	75 20                	jne    801188 <__umoddi3+0x98>
  801168:	39 d8                	cmp    %ebx,%eax
  80116a:	0f 82 b0 00 00 00    	jb     801220 <__umoddi3+0x130>
  801170:	39 f7                	cmp    %esi,%edi
  801172:	0f 86 a8 00 00 00    	jbe    801220 <__umoddi3+0x130>
  801178:	89 c8                	mov    %ecx,%eax
  80117a:	83 c4 1c             	add    $0x1c,%esp
  80117d:	5b                   	pop    %ebx
  80117e:	5e                   	pop    %esi
  80117f:	5f                   	pop    %edi
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    
  801182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801188:	89 e9                	mov    %ebp,%ecx
  80118a:	ba 20 00 00 00       	mov    $0x20,%edx
  80118f:	29 ea                	sub    %ebp,%edx
  801191:	d3 e0                	shl    %cl,%eax
  801193:	89 44 24 08          	mov    %eax,0x8(%esp)
  801197:	89 d1                	mov    %edx,%ecx
  801199:	89 f8                	mov    %edi,%eax
  80119b:	d3 e8                	shr    %cl,%eax
  80119d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011a9:	09 c1                	or     %eax,%ecx
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011b1:	89 e9                	mov    %ebp,%ecx
  8011b3:	d3 e7                	shl    %cl,%edi
  8011b5:	89 d1                	mov    %edx,%ecx
  8011b7:	d3 e8                	shr    %cl,%eax
  8011b9:	89 e9                	mov    %ebp,%ecx
  8011bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011bf:	d3 e3                	shl    %cl,%ebx
  8011c1:	89 c7                	mov    %eax,%edi
  8011c3:	89 d1                	mov    %edx,%ecx
  8011c5:	89 f0                	mov    %esi,%eax
  8011c7:	d3 e8                	shr    %cl,%eax
  8011c9:	89 e9                	mov    %ebp,%ecx
  8011cb:	89 fa                	mov    %edi,%edx
  8011cd:	d3 e6                	shl    %cl,%esi
  8011cf:	09 d8                	or     %ebx,%eax
  8011d1:	f7 74 24 08          	divl   0x8(%esp)
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	89 f3                	mov    %esi,%ebx
  8011d9:	f7 64 24 0c          	mull   0xc(%esp)
  8011dd:	89 c6                	mov    %eax,%esi
  8011df:	89 d7                	mov    %edx,%edi
  8011e1:	39 d1                	cmp    %edx,%ecx
  8011e3:	72 06                	jb     8011eb <__umoddi3+0xfb>
  8011e5:	75 10                	jne    8011f7 <__umoddi3+0x107>
  8011e7:	39 c3                	cmp    %eax,%ebx
  8011e9:	73 0c                	jae    8011f7 <__umoddi3+0x107>
  8011eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011f3:	89 d7                	mov    %edx,%edi
  8011f5:	89 c6                	mov    %eax,%esi
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011fe:	29 f3                	sub    %esi,%ebx
  801200:	19 fa                	sbb    %edi,%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	d3 e0                	shl    %cl,%eax
  801206:	89 e9                	mov    %ebp,%ecx
  801208:	d3 eb                	shr    %cl,%ebx
  80120a:	d3 ea                	shr    %cl,%edx
  80120c:	09 d8                	or     %ebx,%eax
  80120e:	83 c4 1c             	add    $0x1c,%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    
  801216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80121d:	8d 76 00             	lea    0x0(%esi),%esi
  801220:	89 da                	mov    %ebx,%edx
  801222:	29 fe                	sub    %edi,%esi
  801224:	19 c2                	sbb    %eax,%edx
  801226:	89 f1                	mov    %esi,%ecx
  801228:	89 c8                	mov    %ecx,%eax
  80122a:	e9 4b ff ff ff       	jmp    80117a <__umoddi3+0x8a>
