
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
  80003e:	e8 2c 0f 00 00       	call   800f6f <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 1c 0f 00 00       	call   800f6f <sys_sbrk>

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
  800094:	68 a0 25 80 00       	push   $0x8025a0
  800099:	e8 6e 01 00 00       	call   80020c <cprintf>
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
  8000ac:	68 80 25 80 00       	push   $0x802580
  8000b1:	e8 56 01 00 00       	call   80020c <cprintf>
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
  8000ce:	e8 4c 0c 00 00       	call   800d1f <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 af 25 80 00       	push   $0x8025af
  80013a:	e8 cd 00 00 00       	call   80020c <cprintf>
	// call user main routine
	umain(argc, argv);
  80013f:	83 c4 08             	add    $0x8,%esp
  800142:	ff 75 0c             	pushl  0xc(%ebp)
  800145:	ff 75 08             	pushl  0x8(%ebp)
  800148:	e8 e6 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80014d:	e8 0b 00 00 00       	call   80015d <exit>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    

0080015d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800163:	e8 a2 10 00 00       	call   80120a <close_all>
	sys_env_destroy(0);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	e8 6c 0b 00 00       	call   800cde <sys_env_destroy>
}
  800172:	83 c4 10             	add    $0x10,%esp
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	53                   	push   %ebx
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800181:	8b 13                	mov    (%ebx),%edx
  800183:	8d 42 01             	lea    0x1(%edx),%eax
  800186:	89 03                	mov    %eax,(%ebx)
  800188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800194:	74 09                	je     80019f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800196:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	68 ff 00 00 00       	push   $0xff
  8001a7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 f1 0a 00 00       	call   800ca1 <sys_cputs>
		b->idx = 0;
  8001b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	eb db                	jmp    800196 <putch+0x1f>

008001bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cb:	00 00 00 
	b.cnt = 0;
  8001ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 77 01 80 00       	push   $0x800177
  8001ea:	e8 4a 01 00 00       	call   800339 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 9d 0a 00 00       	call   800ca1 <sys_cputs>

	return b.cnt;
}
  800204:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800212:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800215:	50                   	push   %eax
  800216:	ff 75 08             	pushl  0x8(%ebp)
  800219:	e8 9d ff ff ff       	call   8001bb <vcprintf>
	va_end(ap);

	return cnt;
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 1c             	sub    $0x1c,%esp
  800229:	89 c6                	mov    %eax,%esi
  80022b:	89 d7                	mov    %edx,%edi
  80022d:	8b 45 08             	mov    0x8(%ebp),%eax
  800230:	8b 55 0c             	mov    0xc(%ebp),%edx
  800233:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800236:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800239:	8b 45 10             	mov    0x10(%ebp),%eax
  80023c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80023f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800243:	74 2c                	je     800271 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800245:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800248:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80024f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800252:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800255:	39 c2                	cmp    %eax,%edx
  800257:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80025a:	73 43                	jae    80029f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80025c:	83 eb 01             	sub    $0x1,%ebx
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 6c                	jle    8002cf <printnum+0xaf>
				putch(padc, putdat);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	57                   	push   %edi
  800267:	ff 75 18             	pushl  0x18(%ebp)
  80026a:	ff d6                	call   *%esi
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	eb eb                	jmp    80025c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	6a 20                	push   $0x20
  800276:	6a 00                	push   $0x0
  800278:	50                   	push   %eax
  800279:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027c:	ff 75 e0             	pushl  -0x20(%ebp)
  80027f:	89 fa                	mov    %edi,%edx
  800281:	89 f0                	mov    %esi,%eax
  800283:	e8 98 ff ff ff       	call   800220 <printnum>
		while (--width > 0)
  800288:	83 c4 20             	add    $0x20,%esp
  80028b:	83 eb 01             	sub    $0x1,%ebx
  80028e:	85 db                	test   %ebx,%ebx
  800290:	7e 65                	jle    8002f7 <printnum+0xd7>
			putch(padc, putdat);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	57                   	push   %edi
  800296:	6a 20                	push   $0x20
  800298:	ff d6                	call   *%esi
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	eb ec                	jmp    80028b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 18             	pushl  0x18(%ebp)
  8002a5:	83 eb 01             	sub    $0x1,%ebx
  8002a8:	53                   	push   %ebx
  8002a9:	50                   	push   %eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b9:	e8 62 20 00 00       	call   802320 <__udivdi3>
  8002be:	83 c4 18             	add    $0x18,%esp
  8002c1:	52                   	push   %edx
  8002c2:	50                   	push   %eax
  8002c3:	89 fa                	mov    %edi,%edx
  8002c5:	89 f0                	mov    %esi,%eax
  8002c7:	e8 54 ff ff ff       	call   800220 <printnum>
  8002cc:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	57                   	push   %edi
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e2:	e8 49 21 00 00       	call   802430 <__umoddi3>
  8002e7:	83 c4 14             	add    $0x14,%esp
  8002ea:	0f be 80 d3 25 80 00 	movsbl 0x8025d3(%eax),%eax
  8002f1:	50                   	push   %eax
  8002f2:	ff d6                	call   *%esi
  8002f4:	83 c4 10             	add    $0x10,%esp
	}
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800305:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	3b 50 04             	cmp    0x4(%eax),%edx
  80030e:	73 0a                	jae    80031a <sprintputch+0x1b>
		*b->buf++ = ch;
  800310:	8d 4a 01             	lea    0x1(%edx),%ecx
  800313:	89 08                	mov    %ecx,(%eax)
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  800318:	88 02                	mov    %al,(%edx)
}
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <printfmt>:
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800322:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800325:	50                   	push   %eax
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	ff 75 0c             	pushl  0xc(%ebp)
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 05 00 00 00       	call   800339 <vprintfmt>
}
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <vprintfmt>:
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
  80033f:	83 ec 3c             	sub    $0x3c,%esp
  800342:	8b 75 08             	mov    0x8(%ebp),%esi
  800345:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800348:	8b 7d 10             	mov    0x10(%ebp),%edi
  80034b:	e9 32 04 00 00       	jmp    800782 <vprintfmt+0x449>
		padc = ' ';
  800350:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800354:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80035b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800362:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800369:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800370:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800377:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8d 47 01             	lea    0x1(%edi),%eax
  80037f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800382:	0f b6 17             	movzbl (%edi),%edx
  800385:	8d 42 dd             	lea    -0x23(%edx),%eax
  800388:	3c 55                	cmp    $0x55,%al
  80038a:	0f 87 12 05 00 00    	ja     8008a2 <vprintfmt+0x569>
  800390:	0f b6 c0             	movzbl %al,%eax
  800393:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80039d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003a1:	eb d9                	jmp    80037c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003aa:	eb d0                	jmp    80037c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	0f b6 d2             	movzbl %dl,%edx
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b7:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ba:	eb 03                	jmp    8003bf <vprintfmt+0x86>
  8003bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003cc:	83 fe 09             	cmp    $0x9,%esi
  8003cf:	76 eb                	jbe    8003bc <vprintfmt+0x83>
  8003d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d7:	eb 14                	jmp    8003ed <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 40 04             	lea    0x4(%eax),%eax
  8003e7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f1:	79 89                	jns    80037c <vprintfmt+0x43>
				width = precision, precision = -1;
  8003f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800400:	e9 77 ff ff ff       	jmp    80037c <vprintfmt+0x43>
  800405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	0f 48 c1             	cmovs  %ecx,%eax
  80040d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800413:	e9 64 ff ff ff       	jmp    80037c <vprintfmt+0x43>
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800422:	e9 55 ff ff ff       	jmp    80037c <vprintfmt+0x43>
			lflag++;
  800427:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80042e:	e9 49 ff ff ff       	jmp    80037c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800433:	8b 45 14             	mov    0x14(%ebp),%eax
  800436:	8d 78 04             	lea    0x4(%eax),%edi
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	53                   	push   %ebx
  80043d:	ff 30                	pushl  (%eax)
  80043f:	ff d6                	call   *%esi
			break;
  800441:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800444:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800447:	e9 33 03 00 00       	jmp    80077f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80044c:	8b 45 14             	mov    0x14(%ebp),%eax
  80044f:	8d 78 04             	lea    0x4(%eax),%edi
  800452:	8b 00                	mov    (%eax),%eax
  800454:	99                   	cltd   
  800455:	31 d0                	xor    %edx,%eax
  800457:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800459:	83 f8 10             	cmp    $0x10,%eax
  80045c:	7f 23                	jg     800481 <vprintfmt+0x148>
  80045e:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800465:	85 d2                	test   %edx,%edx
  800467:	74 18                	je     800481 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800469:	52                   	push   %edx
  80046a:	68 39 2a 80 00       	push   $0x802a39
  80046f:	53                   	push   %ebx
  800470:	56                   	push   %esi
  800471:	e8 a6 fe ff ff       	call   80031c <printfmt>
  800476:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800479:	89 7d 14             	mov    %edi,0x14(%ebp)
  80047c:	e9 fe 02 00 00       	jmp    80077f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800481:	50                   	push   %eax
  800482:	68 eb 25 80 00       	push   $0x8025eb
  800487:	53                   	push   %ebx
  800488:	56                   	push   %esi
  800489:	e8 8e fe ff ff       	call   80031c <printfmt>
  80048e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800491:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800494:	e9 e6 02 00 00       	jmp    80077f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	83 c0 04             	add    $0x4,%eax
  80049f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004a7:	85 c9                	test   %ecx,%ecx
  8004a9:	b8 e4 25 80 00       	mov    $0x8025e4,%eax
  8004ae:	0f 45 c1             	cmovne %ecx,%eax
  8004b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b8:	7e 06                	jle    8004c0 <vprintfmt+0x187>
  8004ba:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004be:	75 0d                	jne    8004cd <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c3:	89 c7                	mov    %eax,%edi
  8004c5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cb:	eb 53                	jmp    800520 <vprintfmt+0x1e7>
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d3:	50                   	push   %eax
  8004d4:	e8 71 04 00 00       	call   80094a <strnlen>
  8004d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004dc:	29 c1                	sub    %eax,%ecx
  8004de:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	eb 0f                	jmp    8004fe <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f8:	83 ef 01             	sub    $0x1,%edi
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7f ed                	jg     8004ef <vprintfmt+0x1b6>
  800502:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800505:	85 c9                	test   %ecx,%ecx
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	0f 49 c1             	cmovns %ecx,%eax
  80050f:	29 c1                	sub    %eax,%ecx
  800511:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800514:	eb aa                	jmp    8004c0 <vprintfmt+0x187>
					putch(ch, putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	53                   	push   %ebx
  80051a:	52                   	push   %edx
  80051b:	ff d6                	call   *%esi
  80051d:	83 c4 10             	add    $0x10,%esp
  800520:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800523:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800525:	83 c7 01             	add    $0x1,%edi
  800528:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80052c:	0f be d0             	movsbl %al,%edx
  80052f:	85 d2                	test   %edx,%edx
  800531:	74 4b                	je     80057e <vprintfmt+0x245>
  800533:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800537:	78 06                	js     80053f <vprintfmt+0x206>
  800539:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80053d:	78 1e                	js     80055d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80053f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800543:	74 d1                	je     800516 <vprintfmt+0x1dd>
  800545:	0f be c0             	movsbl %al,%eax
  800548:	83 e8 20             	sub    $0x20,%eax
  80054b:	83 f8 5e             	cmp    $0x5e,%eax
  80054e:	76 c6                	jbe    800516 <vprintfmt+0x1dd>
					putch('?', putdat);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	53                   	push   %ebx
  800554:	6a 3f                	push   $0x3f
  800556:	ff d6                	call   *%esi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	eb c3                	jmp    800520 <vprintfmt+0x1e7>
  80055d:	89 cf                	mov    %ecx,%edi
  80055f:	eb 0e                	jmp    80056f <vprintfmt+0x236>
				putch(' ', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	6a 20                	push   $0x20
  800567:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800569:	83 ef 01             	sub    $0x1,%edi
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	85 ff                	test   %edi,%edi
  800571:	7f ee                	jg     800561 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800573:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800576:	89 45 14             	mov    %eax,0x14(%ebp)
  800579:	e9 01 02 00 00       	jmp    80077f <vprintfmt+0x446>
  80057e:	89 cf                	mov    %ecx,%edi
  800580:	eb ed                	jmp    80056f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800582:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800585:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80058c:	e9 eb fd ff ff       	jmp    80037c <vprintfmt+0x43>
	if (lflag >= 2)
  800591:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800595:	7f 21                	jg     8005b8 <vprintfmt+0x27f>
	else if (lflag)
  800597:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80059b:	74 68                	je     800605 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a5:	89 c1                	mov    %eax,%ecx
  8005a7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005aa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b6:	eb 17                	jmp    8005cf <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 50 04             	mov    0x4(%eax),%edx
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 40 08             	lea    0x8(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005df:	78 3f                	js     800620 <vprintfmt+0x2e7>
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005e6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ea:	0f 84 71 01 00 00    	je     800761 <vprintfmt+0x428>
				putch('+', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2b                	push   $0x2b
  8005f6:	ff d6                	call   *%esi
  8005f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800600:	e9 5c 01 00 00       	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80060d:	89 c1                	mov    %eax,%ecx
  80060f:	c1 f9 1f             	sar    $0x1f,%ecx
  800612:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
  80061e:	eb af                	jmp    8005cf <vprintfmt+0x296>
				putch('-', putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	6a 2d                	push   $0x2d
  800626:	ff d6                	call   *%esi
				num = -(long long) num;
  800628:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80062b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062e:	f7 d8                	neg    %eax
  800630:	83 d2 00             	adc    $0x0,%edx
  800633:	f7 da                	neg    %edx
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800643:	e9 19 01 00 00       	jmp    800761 <vprintfmt+0x428>
	if (lflag >= 2)
  800648:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80064c:	7f 29                	jg     800677 <vprintfmt+0x33e>
	else if (lflag)
  80064e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800652:	74 44                	je     800698 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800672:	e9 ea 00 00 00       	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 50 04             	mov    0x4(%eax),%edx
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800693:	e9 c9 00 00 00       	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b6:	e9 a6 00 00 00       	jmp    800761 <vprintfmt+0x428>
			putch('0', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 30                	push   $0x30
  8006c1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ca:	7f 26                	jg     8006f2 <vprintfmt+0x3b9>
	else if (lflag)
  8006cc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d0:	74 3e                	je     800710 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f0:	eb 6f                	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800709:	b8 08 00 00 00       	mov    $0x8,%eax
  80070e:	eb 51                	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	ba 00 00 00 00       	mov    $0x0,%edx
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 04             	lea    0x4(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800729:	b8 08 00 00 00       	mov    $0x8,%eax
  80072e:	eb 31                	jmp    800761 <vprintfmt+0x428>
			putch('0', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 30                	push   $0x30
  800736:	ff d6                	call   *%esi
			putch('x', putdat);
  800738:	83 c4 08             	add    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 78                	push   $0x78
  80073e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
  80074a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800750:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800768:	52                   	push   %edx
  800769:	ff 75 e0             	pushl  -0x20(%ebp)
  80076c:	50                   	push   %eax
  80076d:	ff 75 dc             	pushl  -0x24(%ebp)
  800770:	ff 75 d8             	pushl  -0x28(%ebp)
  800773:	89 da                	mov    %ebx,%edx
  800775:	89 f0                	mov    %esi,%eax
  800777:	e8 a4 fa ff ff       	call   800220 <printnum>
			break;
  80077c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80077f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800782:	83 c7 01             	add    $0x1,%edi
  800785:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800789:	83 f8 25             	cmp    $0x25,%eax
  80078c:	0f 84 be fb ff ff    	je     800350 <vprintfmt+0x17>
			if (ch == '\0')
  800792:	85 c0                	test   %eax,%eax
  800794:	0f 84 28 01 00 00    	je     8008c2 <vprintfmt+0x589>
			putch(ch, putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	50                   	push   %eax
  80079f:	ff d6                	call   *%esi
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	eb dc                	jmp    800782 <vprintfmt+0x449>
	if (lflag >= 2)
  8007a6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007aa:	7f 26                	jg     8007d2 <vprintfmt+0x499>
	else if (lflag)
  8007ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b0:	74 41                	je     8007f3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8d 40 04             	lea    0x4(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d0:	eb 8f                	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 50 04             	mov    0x4(%eax),%edx
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ee:	e9 6e ff ff ff       	jmp    800761 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
  800811:	e9 4b ff ff ff       	jmp    800761 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 c0 04             	add    $0x4,%eax
  80081c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	85 c0                	test   %eax,%eax
  800826:	74 14                	je     80083c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800828:	8b 13                	mov    (%ebx),%edx
  80082a:	83 fa 7f             	cmp    $0x7f,%edx
  80082d:	7f 37                	jg     800866 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80082f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
  800837:	e9 43 ff ff ff       	jmp    80077f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80083c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800841:	bf 09 27 80 00       	mov    $0x802709,%edi
							putch(ch, putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	50                   	push   %eax
  80084b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084d:	83 c7 01             	add    $0x1,%edi
  800850:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	85 c0                	test   %eax,%eax
  800859:	75 eb                	jne    800846 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80085b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	e9 19 ff ff ff       	jmp    80077f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800866:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800868:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086d:	bf 41 27 80 00       	mov    $0x802741,%edi
							putch(ch, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	50                   	push   %eax
  800877:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800879:	83 c7 01             	add    $0x1,%edi
  80087c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	75 eb                	jne    800872 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	e9 ed fe ff ff       	jmp    80077f <vprintfmt+0x446>
			putch(ch, putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 25                	push   $0x25
  800898:	ff d6                	call   *%esi
			break;
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	e9 dd fe ff ff       	jmp    80077f <vprintfmt+0x446>
			putch('%', putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	53                   	push   %ebx
  8008a6:	6a 25                	push   $0x25
  8008a8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	89 f8                	mov    %edi,%eax
  8008af:	eb 03                	jmp    8008b4 <vprintfmt+0x57b>
  8008b1:	83 e8 01             	sub    $0x1,%eax
  8008b4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b8:	75 f7                	jne    8008b1 <vprintfmt+0x578>
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	e9 bd fe ff ff       	jmp    80077f <vprintfmt+0x446>
}
  8008c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5f                   	pop    %edi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 18             	sub    $0x18,%esp
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008dd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e7:	85 c0                	test   %eax,%eax
  8008e9:	74 26                	je     800911 <vsnprintf+0x47>
  8008eb:	85 d2                	test   %edx,%edx
  8008ed:	7e 22                	jle    800911 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ef:	ff 75 14             	pushl  0x14(%ebp)
  8008f2:	ff 75 10             	pushl  0x10(%ebp)
  8008f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	68 ff 02 80 00       	push   $0x8002ff
  8008fe:	e8 36 fa ff ff       	call   800339 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800906:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090c:	83 c4 10             	add    $0x10,%esp
}
  80090f:	c9                   	leave  
  800910:	c3                   	ret    
		return -E_INVAL;
  800911:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800916:	eb f7                	jmp    80090f <vsnprintf+0x45>

00800918 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80091e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800921:	50                   	push   %eax
  800922:	ff 75 10             	pushl  0x10(%ebp)
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	ff 75 08             	pushl  0x8(%ebp)
  80092b:	e8 9a ff ff ff       	call   8008ca <vsnprintf>
	va_end(ap);

	return rc;
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    

00800932 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800938:	b8 00 00 00 00       	mov    $0x0,%eax
  80093d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800941:	74 05                	je     800948 <strlen+0x16>
		n++;
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	eb f5                	jmp    80093d <strlen+0xb>
	return n;
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800950:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	74 0d                	je     800969 <strnlen+0x1f>
  80095c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800960:	74 05                	je     800967 <strnlen+0x1d>
		n++;
  800962:	83 c2 01             	add    $0x1,%edx
  800965:	eb f1                	jmp    800958 <strnlen+0xe>
  800967:	89 d0                	mov    %edx,%eax
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800975:	ba 00 00 00 00       	mov    $0x0,%edx
  80097a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	84 c9                	test   %cl,%cl
  800986:	75 f2                	jne    80097a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800988:	5b                   	pop    %ebx
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	53                   	push   %ebx
  80098f:	83 ec 10             	sub    $0x10,%esp
  800992:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800995:	53                   	push   %ebx
  800996:	e8 97 ff ff ff       	call   800932 <strlen>
  80099b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	01 d8                	add    %ebx,%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 c2 ff ff ff       	call   80096b <strcpy>
	return dst;
}
  8009a9:	89 d8                	mov    %ebx,%eax
  8009ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	56                   	push   %esi
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bb:	89 c6                	mov    %eax,%esi
  8009bd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c0:	89 c2                	mov    %eax,%edx
  8009c2:	39 f2                	cmp    %esi,%edx
  8009c4:	74 11                	je     8009d7 <strncpy+0x27>
		*dst++ = *src;
  8009c6:	83 c2 01             	add    $0x1,%edx
  8009c9:	0f b6 19             	movzbl (%ecx),%ebx
  8009cc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009cf:	80 fb 01             	cmp    $0x1,%bl
  8009d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009d5:	eb eb                	jmp    8009c2 <strncpy+0x12>
	}
	return ret;
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
  8009e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	74 21                	je     800a10 <strlcpy+0x35>
  8009ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009f5:	39 c2                	cmp    %eax,%edx
  8009f7:	74 14                	je     800a0d <strlcpy+0x32>
  8009f9:	0f b6 19             	movzbl (%ecx),%ebx
  8009fc:	84 db                	test   %bl,%bl
  8009fe:	74 0b                	je     800a0b <strlcpy+0x30>
			*dst++ = *src++;
  800a00:	83 c1 01             	add    $0x1,%ecx
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a09:	eb ea                	jmp    8009f5 <strlcpy+0x1a>
  800a0b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a10:	29 f0                	sub    %esi,%eax
}
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1f:	0f b6 01             	movzbl (%ecx),%eax
  800a22:	84 c0                	test   %al,%al
  800a24:	74 0c                	je     800a32 <strcmp+0x1c>
  800a26:	3a 02                	cmp    (%edx),%al
  800a28:	75 08                	jne    800a32 <strcmp+0x1c>
		p++, q++;
  800a2a:	83 c1 01             	add    $0x1,%ecx
  800a2d:	83 c2 01             	add    $0x1,%edx
  800a30:	eb ed                	jmp    800a1f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a32:	0f b6 c0             	movzbl %al,%eax
  800a35:	0f b6 12             	movzbl (%edx),%edx
  800a38:	29 d0                	sub    %edx,%eax
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	53                   	push   %ebx
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a46:	89 c3                	mov    %eax,%ebx
  800a48:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a4b:	eb 06                	jmp    800a53 <strncmp+0x17>
		n--, p++, q++;
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a53:	39 d8                	cmp    %ebx,%eax
  800a55:	74 16                	je     800a6d <strncmp+0x31>
  800a57:	0f b6 08             	movzbl (%eax),%ecx
  800a5a:	84 c9                	test   %cl,%cl
  800a5c:	74 04                	je     800a62 <strncmp+0x26>
  800a5e:	3a 0a                	cmp    (%edx),%cl
  800a60:	74 eb                	je     800a4d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a62:	0f b6 00             	movzbl (%eax),%eax
  800a65:	0f b6 12             	movzbl (%edx),%edx
  800a68:	29 d0                	sub    %edx,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    
		return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	eb f6                	jmp    800a6a <strncmp+0x2e>

00800a74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	74 09                	je     800a8e <strchr+0x1a>
		if (*s == c)
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	74 0a                	je     800a93 <strchr+0x1f>
	for (; *s; s++)
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	eb f0                	jmp    800a7e <strchr+0xa>
			return (char *) s;
	return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa2:	38 ca                	cmp    %cl,%dl
  800aa4:	74 09                	je     800aaf <strfind+0x1a>
  800aa6:	84 d2                	test   %dl,%dl
  800aa8:	74 05                	je     800aaf <strfind+0x1a>
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	eb f0                	jmp    800a9f <strfind+0xa>
			break;
	return (char *) s;
}
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800abd:	85 c9                	test   %ecx,%ecx
  800abf:	74 31                	je     800af2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac1:	89 f8                	mov    %edi,%eax
  800ac3:	09 c8                	or     %ecx,%eax
  800ac5:	a8 03                	test   $0x3,%al
  800ac7:	75 23                	jne    800aec <memset+0x3b>
		c &= 0xFF;
  800ac9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800acd:	89 d3                	mov    %edx,%ebx
  800acf:	c1 e3 08             	shl    $0x8,%ebx
  800ad2:	89 d0                	mov    %edx,%eax
  800ad4:	c1 e0 18             	shl    $0x18,%eax
  800ad7:	89 d6                	mov    %edx,%esi
  800ad9:	c1 e6 10             	shl    $0x10,%esi
  800adc:	09 f0                	or     %esi,%eax
  800ade:	09 c2                	or     %eax,%edx
  800ae0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ae2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae5:	89 d0                	mov    %edx,%eax
  800ae7:	fc                   	cld    
  800ae8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aea:	eb 06                	jmp    800af2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	fc                   	cld    
  800af0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af2:	89 f8                	mov    %edi,%eax
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5f                   	pop    %edi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b07:	39 c6                	cmp    %eax,%esi
  800b09:	73 32                	jae    800b3d <memmove+0x44>
  800b0b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b0e:	39 c2                	cmp    %eax,%edx
  800b10:	76 2b                	jbe    800b3d <memmove+0x44>
		s += n;
		d += n;
  800b12:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b15:	89 fe                	mov    %edi,%esi
  800b17:	09 ce                	or     %ecx,%esi
  800b19:	09 d6                	or     %edx,%esi
  800b1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b21:	75 0e                	jne    800b31 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b23:	83 ef 04             	sub    $0x4,%edi
  800b26:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b2c:	fd                   	std    
  800b2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2f:	eb 09                	jmp    800b3a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b31:	83 ef 01             	sub    $0x1,%edi
  800b34:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b37:	fd                   	std    
  800b38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b3a:	fc                   	cld    
  800b3b:	eb 1a                	jmp    800b57 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	09 ca                	or     %ecx,%edx
  800b41:	09 f2                	or     %esi,%edx
  800b43:	f6 c2 03             	test   $0x3,%dl
  800b46:	75 0a                	jne    800b52 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b48:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b4b:	89 c7                	mov    %eax,%edi
  800b4d:	fc                   	cld    
  800b4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b50:	eb 05                	jmp    800b57 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b52:	89 c7                	mov    %eax,%edi
  800b54:	fc                   	cld    
  800b55:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	ff 75 08             	pushl  0x8(%ebp)
  800b6a:	e8 8a ff ff ff       	call   800af9 <memmove>
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c6                	mov    %eax,%esi
  800b7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b81:	39 f0                	cmp    %esi,%eax
  800b83:	74 1c                	je     800ba1 <memcmp+0x30>
		if (*s1 != *s2)
  800b85:	0f b6 08             	movzbl (%eax),%ecx
  800b88:	0f b6 1a             	movzbl (%edx),%ebx
  800b8b:	38 d9                	cmp    %bl,%cl
  800b8d:	75 08                	jne    800b97 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	83 c2 01             	add    $0x1,%edx
  800b95:	eb ea                	jmp    800b81 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b97:	0f b6 c1             	movzbl %cl,%eax
  800b9a:	0f b6 db             	movzbl %bl,%ebx
  800b9d:	29 d8                	sub    %ebx,%eax
  800b9f:	eb 05                	jmp    800ba6 <memcmp+0x35>
	}

	return 0;
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb8:	39 d0                	cmp    %edx,%eax
  800bba:	73 09                	jae    800bc5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bbc:	38 08                	cmp    %cl,(%eax)
  800bbe:	74 05                	je     800bc5 <memfind+0x1b>
	for (; s < ends; s++)
  800bc0:	83 c0 01             	add    $0x1,%eax
  800bc3:	eb f3                	jmp    800bb8 <memfind+0xe>
			break;
	return (void *) s;
}
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	57                   	push   %edi
  800bcb:	56                   	push   %esi
  800bcc:	53                   	push   %ebx
  800bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd3:	eb 03                	jmp    800bd8 <strtol+0x11>
		s++;
  800bd5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd8:	0f b6 01             	movzbl (%ecx),%eax
  800bdb:	3c 20                	cmp    $0x20,%al
  800bdd:	74 f6                	je     800bd5 <strtol+0xe>
  800bdf:	3c 09                	cmp    $0x9,%al
  800be1:	74 f2                	je     800bd5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800be3:	3c 2b                	cmp    $0x2b,%al
  800be5:	74 2a                	je     800c11 <strtol+0x4a>
	int neg = 0;
  800be7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bec:	3c 2d                	cmp    $0x2d,%al
  800bee:	74 2b                	je     800c1b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf6:	75 0f                	jne    800c07 <strtol+0x40>
  800bf8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bfb:	74 28                	je     800c25 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bfd:	85 db                	test   %ebx,%ebx
  800bff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c04:	0f 44 d8             	cmove  %eax,%ebx
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0f:	eb 50                	jmp    800c61 <strtol+0x9a>
		s++;
  800c11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c14:	bf 00 00 00 00       	mov    $0x0,%edi
  800c19:	eb d5                	jmp    800bf0 <strtol+0x29>
		s++, neg = 1;
  800c1b:	83 c1 01             	add    $0x1,%ecx
  800c1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c23:	eb cb                	jmp    800bf0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c29:	74 0e                	je     800c39 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c2b:	85 db                	test   %ebx,%ebx
  800c2d:	75 d8                	jne    800c07 <strtol+0x40>
		s++, base = 8;
  800c2f:	83 c1 01             	add    $0x1,%ecx
  800c32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c37:	eb ce                	jmp    800c07 <strtol+0x40>
		s += 2, base = 16;
  800c39:	83 c1 02             	add    $0x2,%ecx
  800c3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c41:	eb c4                	jmp    800c07 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c43:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c46:	89 f3                	mov    %esi,%ebx
  800c48:	80 fb 19             	cmp    $0x19,%bl
  800c4b:	77 29                	ja     800c76 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c4d:	0f be d2             	movsbl %dl,%edx
  800c50:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c56:	7d 30                	jge    800c88 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c58:	83 c1 01             	add    $0x1,%ecx
  800c5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c61:	0f b6 11             	movzbl (%ecx),%edx
  800c64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c67:	89 f3                	mov    %esi,%ebx
  800c69:	80 fb 09             	cmp    $0x9,%bl
  800c6c:	77 d5                	ja     800c43 <strtol+0x7c>
			dig = *s - '0';
  800c6e:	0f be d2             	movsbl %dl,%edx
  800c71:	83 ea 30             	sub    $0x30,%edx
  800c74:	eb dd                	jmp    800c53 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c79:	89 f3                	mov    %esi,%ebx
  800c7b:	80 fb 19             	cmp    $0x19,%bl
  800c7e:	77 08                	ja     800c88 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c80:	0f be d2             	movsbl %dl,%edx
  800c83:	83 ea 37             	sub    $0x37,%edx
  800c86:	eb cb                	jmp    800c53 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8c:	74 05                	je     800c93 <strtol+0xcc>
		*endptr = (char *) s;
  800c8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c93:	89 c2                	mov    %eax,%edx
  800c95:	f7 da                	neg    %edx
  800c97:	85 ff                	test   %edi,%edi
  800c99:	0f 45 c2             	cmovne %edx,%eax
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	89 c3                	mov    %eax,%ebx
  800cb4:	89 c7                	mov    %eax,%edi
  800cb6:	89 c6                	mov    %eax,%esi
  800cb8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cba:	5b                   	pop    %ebx
  800cbb:	5e                   	pop    %esi
  800cbc:	5f                   	pop    %edi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d3                	mov    %edx,%ebx
  800cd3:	89 d7                	mov    %edx,%edi
  800cd5:	89 d6                	mov    %edx,%esi
  800cd7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf4:	89 cb                	mov    %ecx,%ebx
  800cf6:	89 cf                	mov    %ecx,%edi
  800cf8:	89 ce                	mov    %ecx,%esi
  800cfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7f 08                	jg     800d08 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	6a 03                	push   $0x3
  800d0e:	68 64 29 80 00       	push   $0x802964
  800d13:	6a 43                	push   $0x43
  800d15:	68 81 29 80 00       	push   $0x802981
  800d1a:	e8 69 14 00 00       	call   802188 <_panic>

00800d1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d25:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d2f:	89 d1                	mov    %edx,%ecx
  800d31:	89 d3                	mov    %edx,%ebx
  800d33:	89 d7                	mov    %edx,%edi
  800d35:	89 d6                	mov    %edx,%esi
  800d37:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <sys_yield>:

void
sys_yield(void)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d44:	ba 00 00 00 00       	mov    $0x0,%edx
  800d49:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d4e:	89 d1                	mov    %edx,%ecx
  800d50:	89 d3                	mov    %edx,%ebx
  800d52:	89 d7                	mov    %edx,%edi
  800d54:	89 d6                	mov    %edx,%esi
  800d56:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    

00800d5d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d66:	be 00 00 00 00       	mov    $0x0,%esi
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 04 00 00 00       	mov    $0x4,%eax
  800d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d79:	89 f7                	mov    %esi,%edi
  800d7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	7f 08                	jg     800d89 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d89:	83 ec 0c             	sub    $0xc,%esp
  800d8c:	50                   	push   %eax
  800d8d:	6a 04                	push   $0x4
  800d8f:	68 64 29 80 00       	push   $0x802964
  800d94:	6a 43                	push   $0x43
  800d96:	68 81 29 80 00       	push   $0x802981
  800d9b:	e8 e8 13 00 00       	call   802188 <_panic>

00800da0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	b8 05 00 00 00       	mov    $0x5,%eax
  800db4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dba:	8b 75 18             	mov    0x18(%ebp),%esi
  800dbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7f 08                	jg     800dcb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcb:	83 ec 0c             	sub    $0xc,%esp
  800dce:	50                   	push   %eax
  800dcf:	6a 05                	push   $0x5
  800dd1:	68 64 29 80 00       	push   $0x802964
  800dd6:	6a 43                	push   $0x43
  800dd8:	68 81 29 80 00       	push   $0x802981
  800ddd:	e8 a6 13 00 00       	call   802188 <_panic>

00800de2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800deb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dfb:	89 df                	mov    %ebx,%edi
  800dfd:	89 de                	mov    %ebx,%esi
  800dff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	7f 08                	jg     800e0d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	83 ec 0c             	sub    $0xc,%esp
  800e10:	50                   	push   %eax
  800e11:	6a 06                	push   $0x6
  800e13:	68 64 29 80 00       	push   $0x802964
  800e18:	6a 43                	push   $0x43
  800e1a:	68 81 29 80 00       	push   $0x802981
  800e1f:	e8 64 13 00 00       	call   802188 <_panic>

00800e24 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
  800e2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3d:	89 df                	mov    %ebx,%edi
  800e3f:	89 de                	mov    %ebx,%esi
  800e41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	7f 08                	jg     800e4f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4f:	83 ec 0c             	sub    $0xc,%esp
  800e52:	50                   	push   %eax
  800e53:	6a 08                	push   $0x8
  800e55:	68 64 29 80 00       	push   $0x802964
  800e5a:	6a 43                	push   $0x43
  800e5c:	68 81 29 80 00       	push   $0x802981
  800e61:	e8 22 13 00 00       	call   802188 <_panic>

00800e66 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
  800e6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7f:	89 df                	mov    %ebx,%edi
  800e81:	89 de                	mov    %ebx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 09                	push   $0x9
  800e97:	68 64 29 80 00       	push   $0x802964
  800e9c:	6a 43                	push   $0x43
  800e9e:	68 81 29 80 00       	push   $0x802981
  800ea3:	e8 e0 12 00 00       	call   802188 <_panic>

00800ea8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec1:	89 df                	mov    %ebx,%edi
  800ec3:	89 de                	mov    %ebx,%esi
  800ec5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7f 08                	jg     800ed3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	50                   	push   %eax
  800ed7:	6a 0a                	push   $0xa
  800ed9:	68 64 29 80 00       	push   $0x802964
  800ede:	6a 43                	push   $0x43
  800ee0:	68 81 29 80 00       	push   $0x802981
  800ee5:	e8 9e 12 00 00       	call   802188 <_panic>

00800eea <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800efb:	be 00 00 00 00       	mov    $0x0,%esi
  800f00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f03:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f06:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f23:	89 cb                	mov    %ecx,%ebx
  800f25:	89 cf                	mov    %ecx,%edi
  800f27:	89 ce                	mov    %ecx,%esi
  800f29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7f 08                	jg     800f37 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	50                   	push   %eax
  800f3b:	6a 0d                	push   $0xd
  800f3d:	68 64 29 80 00       	push   $0x802964
  800f42:	6a 43                	push   $0x43
  800f44:	68 81 29 80 00       	push   $0x802981
  800f49:	e8 3a 12 00 00       	call   802188 <_panic>

00800f4e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f82:	89 cb                	mov    %ecx,%ebx
  800f84:	89 cf                	mov    %ecx,%edi
  800f86:	89 ce                	mov    %ecx,%esi
  800f88:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f95:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9f:	89 d1                	mov    %edx,%ecx
  800fa1:	89 d3                	mov    %edx,%ebx
  800fa3:	89 d7                	mov    %edx,%edi
  800fa5:	89 d6                	mov    %edx,%esi
  800fa7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	b8 11 00 00 00       	mov    $0x11,%eax
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	b8 12 00 00 00       	mov    $0x12,%eax
  800fe5:	89 df                	mov    %ebx,%edi
  800fe7:	89 de                	mov    %ebx,%esi
  800fe9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	57                   	push   %edi
  800ff4:	56                   	push   %esi
  800ff5:	53                   	push   %ebx
  800ff6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  801001:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801004:	b8 13 00 00 00       	mov    $0x13,%eax
  801009:	89 df                	mov    %ebx,%edi
  80100b:	89 de                	mov    %ebx,%esi
  80100d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100f:	85 c0                	test   %eax,%eax
  801011:	7f 08                	jg     80101b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801013:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5f                   	pop    %edi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	50                   	push   %eax
  80101f:	6a 13                	push   $0x13
  801021:	68 64 29 80 00       	push   $0x802964
  801026:	6a 43                	push   $0x43
  801028:	68 81 29 80 00       	push   $0x802981
  80102d:	e8 56 11 00 00       	call   802188 <_panic>

00801032 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	05 00 00 00 30       	add    $0x30000000,%eax
  80103d:	c1 e8 0c             	shr    $0xc,%eax
}
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80104d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801052:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801061:	89 c2                	mov    %eax,%edx
  801063:	c1 ea 16             	shr    $0x16,%edx
  801066:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106d:	f6 c2 01             	test   $0x1,%dl
  801070:	74 2d                	je     80109f <fd_alloc+0x46>
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 0c             	shr    $0xc,%edx
  801077:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 1c                	je     80109f <fd_alloc+0x46>
  801083:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801088:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80108d:	75 d2                	jne    801061 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801098:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80109d:	eb 0a                	jmp    8010a9 <fd_alloc+0x50>
			*fd_store = fd;
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010b1:	83 f8 1f             	cmp    $0x1f,%eax
  8010b4:	77 30                	ja     8010e6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b6:	c1 e0 0c             	shl    $0xc,%eax
  8010b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010be:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010c4:	f6 c2 01             	test   $0x1,%dl
  8010c7:	74 24                	je     8010ed <fd_lookup+0x42>
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	c1 ea 0c             	shr    $0xc,%edx
  8010ce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d5:	f6 c2 01             	test   $0x1,%dl
  8010d8:	74 1a                	je     8010f4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dd:	89 02                	mov    %eax,(%edx)
	return 0;
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    
		return -E_INVAL;
  8010e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010eb:	eb f7                	jmp    8010e4 <fd_lookup+0x39>
		return -E_INVAL;
  8010ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f2:	eb f0                	jmp    8010e4 <fd_lookup+0x39>
  8010f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f9:	eb e9                	jmp    8010e4 <fd_lookup+0x39>

008010fb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801104:	ba 00 00 00 00       	mov    $0x0,%edx
  801109:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80110e:	39 08                	cmp    %ecx,(%eax)
  801110:	74 38                	je     80114a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801112:	83 c2 01             	add    $0x1,%edx
  801115:	8b 04 95 0c 2a 80 00 	mov    0x802a0c(,%edx,4),%eax
  80111c:	85 c0                	test   %eax,%eax
  80111e:	75 ee                	jne    80110e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801120:	a1 08 40 80 00       	mov    0x804008,%eax
  801125:	8b 40 48             	mov    0x48(%eax),%eax
  801128:	83 ec 04             	sub    $0x4,%esp
  80112b:	51                   	push   %ecx
  80112c:	50                   	push   %eax
  80112d:	68 90 29 80 00       	push   $0x802990
  801132:	e8 d5 f0 ff ff       	call   80020c <cprintf>
	*dev = 0;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    
			*dev = devtab[i];
  80114a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	eb f2                	jmp    801148 <dev_lookup+0x4d>

00801156 <fd_close>:
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
  80115c:	83 ec 24             	sub    $0x24,%esp
  80115f:	8b 75 08             	mov    0x8(%ebp),%esi
  801162:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801165:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801168:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801169:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80116f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801172:	50                   	push   %eax
  801173:	e8 33 ff ff ff       	call   8010ab <fd_lookup>
  801178:	89 c3                	mov    %eax,%ebx
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 05                	js     801186 <fd_close+0x30>
	    || fd != fd2)
  801181:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801184:	74 16                	je     80119c <fd_close+0x46>
		return (must_exist ? r : 0);
  801186:	89 f8                	mov    %edi,%eax
  801188:	84 c0                	test   %al,%al
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
  80118f:	0f 44 d8             	cmove  %eax,%ebx
}
  801192:	89 d8                	mov    %ebx,%eax
  801194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	ff 36                	pushl  (%esi)
  8011a5:	e8 51 ff ff ff       	call   8010fb <dev_lookup>
  8011aa:	89 c3                	mov    %eax,%ebx
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 1a                	js     8011cd <fd_close+0x77>
		if (dev->dev_close)
  8011b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	74 0b                	je     8011cd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	56                   	push   %esi
  8011c6:	ff d0                	call   *%eax
  8011c8:	89 c3                	mov    %eax,%ebx
  8011ca:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	56                   	push   %esi
  8011d1:	6a 00                	push   $0x0
  8011d3:	e8 0a fc ff ff       	call   800de2 <sys_page_unmap>
	return r;
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	eb b5                	jmp    801192 <fd_close+0x3c>

008011dd <close>:

int
close(int fdnum)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e6:	50                   	push   %eax
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	e8 bc fe ff ff       	call   8010ab <fd_lookup>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	79 02                	jns    8011f8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    
		return fd_close(fd, 1);
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	6a 01                	push   $0x1
  8011fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801200:	e8 51 ff ff ff       	call   801156 <fd_close>
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	eb ec                	jmp    8011f6 <close+0x19>

0080120a <close_all>:

void
close_all(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	53                   	push   %ebx
  80120e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801211:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	53                   	push   %ebx
  80121a:	e8 be ff ff ff       	call   8011dd <close>
	for (i = 0; i < MAXFD; i++)
  80121f:	83 c3 01             	add    $0x1,%ebx
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	83 fb 20             	cmp    $0x20,%ebx
  801228:	75 ec                	jne    801216 <close_all+0xc>
}
  80122a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
  801235:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801238:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123b:	50                   	push   %eax
  80123c:	ff 75 08             	pushl  0x8(%ebp)
  80123f:	e8 67 fe ff ff       	call   8010ab <fd_lookup>
  801244:	89 c3                	mov    %eax,%ebx
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	0f 88 81 00 00 00    	js     8012d2 <dup+0xa3>
		return r;
	close(newfdnum);
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	ff 75 0c             	pushl  0xc(%ebp)
  801257:	e8 81 ff ff ff       	call   8011dd <close>

	newfd = INDEX2FD(newfdnum);
  80125c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80125f:	c1 e6 0c             	shl    $0xc,%esi
  801262:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801268:	83 c4 04             	add    $0x4,%esp
  80126b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126e:	e8 cf fd ff ff       	call   801042 <fd2data>
  801273:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801275:	89 34 24             	mov    %esi,(%esp)
  801278:	e8 c5 fd ff ff       	call   801042 <fd2data>
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801282:	89 d8                	mov    %ebx,%eax
  801284:	c1 e8 16             	shr    $0x16,%eax
  801287:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128e:	a8 01                	test   $0x1,%al
  801290:	74 11                	je     8012a3 <dup+0x74>
  801292:	89 d8                	mov    %ebx,%eax
  801294:	c1 e8 0c             	shr    $0xc,%eax
  801297:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129e:	f6 c2 01             	test   $0x1,%dl
  8012a1:	75 39                	jne    8012dc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a6:	89 d0                	mov    %edx,%eax
  8012a8:	c1 e8 0c             	shr    $0xc,%eax
  8012ab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ba:	50                   	push   %eax
  8012bb:	56                   	push   %esi
  8012bc:	6a 00                	push   $0x0
  8012be:	52                   	push   %edx
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 da fa ff ff       	call   800da0 <sys_page_map>
  8012c6:	89 c3                	mov    %eax,%ebx
  8012c8:	83 c4 20             	add    $0x20,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 31                	js     801300 <dup+0xd1>
		goto err;

	return newfdnum;
  8012cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012d2:	89 d8                	mov    %ebx,%eax
  8012d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5f                   	pop    %edi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012eb:	50                   	push   %eax
  8012ec:	57                   	push   %edi
  8012ed:	6a 00                	push   $0x0
  8012ef:	53                   	push   %ebx
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 a9 fa ff ff       	call   800da0 <sys_page_map>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 20             	add    $0x20,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	79 a3                	jns    8012a3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	56                   	push   %esi
  801304:	6a 00                	push   $0x0
  801306:	e8 d7 fa ff ff       	call   800de2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	57                   	push   %edi
  80130f:	6a 00                	push   $0x0
  801311:	e8 cc fa ff ff       	call   800de2 <sys_page_unmap>
	return r;
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	eb b7                	jmp    8012d2 <dup+0xa3>

0080131b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	53                   	push   %ebx
  80131f:	83 ec 1c             	sub    $0x1c,%esp
  801322:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801325:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801328:	50                   	push   %eax
  801329:	53                   	push   %ebx
  80132a:	e8 7c fd ff ff       	call   8010ab <fd_lookup>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 3f                	js     801375 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801340:	ff 30                	pushl  (%eax)
  801342:	e8 b4 fd ff ff       	call   8010fb <dev_lookup>
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	78 27                	js     801375 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80134e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801351:	8b 42 08             	mov    0x8(%edx),%eax
  801354:	83 e0 03             	and    $0x3,%eax
  801357:	83 f8 01             	cmp    $0x1,%eax
  80135a:	74 1e                	je     80137a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80135c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135f:	8b 40 08             	mov    0x8(%eax),%eax
  801362:	85 c0                	test   %eax,%eax
  801364:	74 35                	je     80139b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	ff 75 10             	pushl  0x10(%ebp)
  80136c:	ff 75 0c             	pushl  0xc(%ebp)
  80136f:	52                   	push   %edx
  801370:	ff d0                	call   *%eax
  801372:	83 c4 10             	add    $0x10,%esp
}
  801375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801378:	c9                   	leave  
  801379:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80137a:	a1 08 40 80 00       	mov    0x804008,%eax
  80137f:	8b 40 48             	mov    0x48(%eax),%eax
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	53                   	push   %ebx
  801386:	50                   	push   %eax
  801387:	68 d1 29 80 00       	push   $0x8029d1
  80138c:	e8 7b ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801399:	eb da                	jmp    801375 <read+0x5a>
		return -E_NOT_SUPP;
  80139b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a0:	eb d3                	jmp    801375 <read+0x5a>

008013a2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	57                   	push   %edi
  8013a6:	56                   	push   %esi
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 0c             	sub    $0xc,%esp
  8013ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b6:	39 f3                	cmp    %esi,%ebx
  8013b8:	73 23                	jae    8013dd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	89 f0                	mov    %esi,%eax
  8013bf:	29 d8                	sub    %ebx,%eax
  8013c1:	50                   	push   %eax
  8013c2:	89 d8                	mov    %ebx,%eax
  8013c4:	03 45 0c             	add    0xc(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	57                   	push   %edi
  8013c9:	e8 4d ff ff ff       	call   80131b <read>
		if (m < 0)
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 06                	js     8013db <readn+0x39>
			return m;
		if (m == 0)
  8013d5:	74 06                	je     8013dd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013d7:	01 c3                	add    %eax,%ebx
  8013d9:	eb db                	jmp    8013b6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013db:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	53                   	push   %ebx
  8013eb:	83 ec 1c             	sub    $0x1c,%esp
  8013ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	53                   	push   %ebx
  8013f6:	e8 b0 fc ff ff       	call   8010ab <fd_lookup>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 3a                	js     80143c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801402:	83 ec 08             	sub    $0x8,%esp
  801405:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801408:	50                   	push   %eax
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140c:	ff 30                	pushl  (%eax)
  80140e:	e8 e8 fc ff ff       	call   8010fb <dev_lookup>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 22                	js     80143c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801421:	74 1e                	je     801441 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801426:	8b 52 0c             	mov    0xc(%edx),%edx
  801429:	85 d2                	test   %edx,%edx
  80142b:	74 35                	je     801462 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	ff 75 10             	pushl  0x10(%ebp)
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	50                   	push   %eax
  801437:	ff d2                	call   *%edx
  801439:	83 c4 10             	add    $0x10,%esp
}
  80143c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143f:	c9                   	leave  
  801440:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801441:	a1 08 40 80 00       	mov    0x804008,%eax
  801446:	8b 40 48             	mov    0x48(%eax),%eax
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	53                   	push   %ebx
  80144d:	50                   	push   %eax
  80144e:	68 ed 29 80 00       	push   $0x8029ed
  801453:	e8 b4 ed ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801460:	eb da                	jmp    80143c <write+0x55>
		return -E_NOT_SUPP;
  801462:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801467:	eb d3                	jmp    80143c <write+0x55>

00801469 <seek>:

int
seek(int fdnum, off_t offset)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	ff 75 08             	pushl  0x8(%ebp)
  801476:	e8 30 fc ff ff       	call   8010ab <fd_lookup>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 0e                	js     801490 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	53                   	push   %ebx
  801496:	83 ec 1c             	sub    $0x1c,%esp
  801499:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	53                   	push   %ebx
  8014a1:	e8 05 fc ff ff       	call   8010ab <fd_lookup>
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 37                	js     8014e4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b3:	50                   	push   %eax
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	ff 30                	pushl  (%eax)
  8014b9:	e8 3d fc ff ff       	call   8010fb <dev_lookup>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 1f                	js     8014e4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014cc:	74 1b                	je     8014e9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d1:	8b 52 18             	mov    0x18(%edx),%edx
  8014d4:	85 d2                	test   %edx,%edx
  8014d6:	74 32                	je     80150a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	50                   	push   %eax
  8014df:	ff d2                	call   *%edx
  8014e1:	83 c4 10             	add    $0x10,%esp
}
  8014e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ee:	8b 40 48             	mov    0x48(%eax),%eax
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	50                   	push   %eax
  8014f6:	68 b0 29 80 00       	push   $0x8029b0
  8014fb:	e8 0c ed ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801508:	eb da                	jmp    8014e4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80150a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150f:	eb d3                	jmp    8014e4 <ftruncate+0x52>

00801511 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	53                   	push   %ebx
  801515:	83 ec 1c             	sub    $0x1c,%esp
  801518:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151e:	50                   	push   %eax
  80151f:	ff 75 08             	pushl  0x8(%ebp)
  801522:	e8 84 fb ff ff       	call   8010ab <fd_lookup>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 4b                	js     801579 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801534:	50                   	push   %eax
  801535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801538:	ff 30                	pushl  (%eax)
  80153a:	e8 bc fb ff ff       	call   8010fb <dev_lookup>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	78 33                	js     801579 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80154d:	74 2f                	je     80157e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80154f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801552:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801559:	00 00 00 
	stat->st_isdir = 0;
  80155c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801563:	00 00 00 
	stat->st_dev = dev;
  801566:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	53                   	push   %ebx
  801570:	ff 75 f0             	pushl  -0x10(%ebp)
  801573:	ff 50 14             	call   *0x14(%eax)
  801576:	83 c4 10             	add    $0x10,%esp
}
  801579:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    
		return -E_NOT_SUPP;
  80157e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801583:	eb f4                	jmp    801579 <fstat+0x68>

00801585 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	6a 00                	push   $0x0
  80158f:	ff 75 08             	pushl  0x8(%ebp)
  801592:	e8 22 02 00 00       	call   8017b9 <open>
  801597:	89 c3                	mov    %eax,%ebx
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 1b                	js     8015bb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	e8 65 ff ff ff       	call   801511 <fstat>
  8015ac:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ae:	89 1c 24             	mov    %ebx,(%esp)
  8015b1:	e8 27 fc ff ff       	call   8011dd <close>
	return r;
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	89 f3                	mov    %esi,%ebx
}
  8015bb:	89 d8                	mov    %ebx,%eax
  8015bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	56                   	push   %esi
  8015c8:	53                   	push   %ebx
  8015c9:	89 c6                	mov    %eax,%esi
  8015cb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d4:	74 27                	je     8015fd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d6:	6a 07                	push   $0x7
  8015d8:	68 00 50 80 00       	push   $0x805000
  8015dd:	56                   	push   %esi
  8015de:	ff 35 00 40 80 00    	pushl  0x804000
  8015e4:	e8 69 0c 00 00       	call   802252 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e9:	83 c4 0c             	add    $0xc,%esp
  8015ec:	6a 00                	push   $0x0
  8015ee:	53                   	push   %ebx
  8015ef:	6a 00                	push   $0x0
  8015f1:	e8 f3 0b 00 00       	call   8021e9 <ipc_recv>
}
  8015f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	6a 01                	push   $0x1
  801602:	e8 a3 0c 00 00       	call   8022aa <ipc_find_env>
  801607:	a3 00 40 80 00       	mov    %eax,0x804000
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	eb c5                	jmp    8015d6 <fsipc+0x12>

00801611 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8b 40 0c             	mov    0xc(%eax),%eax
  80161d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80162a:	ba 00 00 00 00       	mov    $0x0,%edx
  80162f:	b8 02 00 00 00       	mov    $0x2,%eax
  801634:	e8 8b ff ff ff       	call   8015c4 <fsipc>
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <devfile_flush>:
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	8b 40 0c             	mov    0xc(%eax),%eax
  801647:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80164c:	ba 00 00 00 00       	mov    $0x0,%edx
  801651:	b8 06 00 00 00       	mov    $0x6,%eax
  801656:	e8 69 ff ff ff       	call   8015c4 <fsipc>
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <devfile_stat>:
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	53                   	push   %ebx
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8b 40 0c             	mov    0xc(%eax),%eax
  80166d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 05 00 00 00       	mov    $0x5,%eax
  80167c:	e8 43 ff ff ff       	call   8015c4 <fsipc>
  801681:	85 c0                	test   %eax,%eax
  801683:	78 2c                	js     8016b1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	68 00 50 80 00       	push   $0x805000
  80168d:	53                   	push   %ebx
  80168e:	e8 d8 f2 ff ff       	call   80096b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801693:	a1 80 50 80 00       	mov    0x805080,%eax
  801698:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169e:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <devfile_write>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016cb:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016d1:	53                   	push   %ebx
  8016d2:	ff 75 0c             	pushl  0xc(%ebp)
  8016d5:	68 08 50 80 00       	push   $0x805008
  8016da:	e8 7c f4 ff ff       	call   800b5b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016df:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e9:	e8 d6 fe ff ff       	call   8015c4 <fsipc>
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 0b                	js     801700 <devfile_write+0x4a>
	assert(r <= n);
  8016f5:	39 d8                	cmp    %ebx,%eax
  8016f7:	77 0c                	ja     801705 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016f9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016fe:	7f 1e                	jg     80171e <devfile_write+0x68>
}
  801700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801703:	c9                   	leave  
  801704:	c3                   	ret    
	assert(r <= n);
  801705:	68 20 2a 80 00       	push   $0x802a20
  80170a:	68 27 2a 80 00       	push   $0x802a27
  80170f:	68 98 00 00 00       	push   $0x98
  801714:	68 3c 2a 80 00       	push   $0x802a3c
  801719:	e8 6a 0a 00 00       	call   802188 <_panic>
	assert(r <= PGSIZE);
  80171e:	68 47 2a 80 00       	push   $0x802a47
  801723:	68 27 2a 80 00       	push   $0x802a27
  801728:	68 99 00 00 00       	push   $0x99
  80172d:	68 3c 2a 80 00       	push   $0x802a3c
  801732:	e8 51 0a 00 00       	call   802188 <_panic>

00801737 <devfile_read>:
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
  80173c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	b8 03 00 00 00       	mov    $0x3,%eax
  80175a:	e8 65 fe ff ff       	call   8015c4 <fsipc>
  80175f:	89 c3                	mov    %eax,%ebx
  801761:	85 c0                	test   %eax,%eax
  801763:	78 1f                	js     801784 <devfile_read+0x4d>
	assert(r <= n);
  801765:	39 f0                	cmp    %esi,%eax
  801767:	77 24                	ja     80178d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801769:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176e:	7f 33                	jg     8017a3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	50                   	push   %eax
  801774:	68 00 50 80 00       	push   $0x805000
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	e8 78 f3 ff ff       	call   800af9 <memmove>
	return r;
  801781:	83 c4 10             	add    $0x10,%esp
}
  801784:	89 d8                	mov    %ebx,%eax
  801786:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    
	assert(r <= n);
  80178d:	68 20 2a 80 00       	push   $0x802a20
  801792:	68 27 2a 80 00       	push   $0x802a27
  801797:	6a 7c                	push   $0x7c
  801799:	68 3c 2a 80 00       	push   $0x802a3c
  80179e:	e8 e5 09 00 00       	call   802188 <_panic>
	assert(r <= PGSIZE);
  8017a3:	68 47 2a 80 00       	push   $0x802a47
  8017a8:	68 27 2a 80 00       	push   $0x802a27
  8017ad:	6a 7d                	push   $0x7d
  8017af:	68 3c 2a 80 00       	push   $0x802a3c
  8017b4:	e8 cf 09 00 00       	call   802188 <_panic>

008017b9 <open>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	56                   	push   %esi
  8017bd:	53                   	push   %ebx
  8017be:	83 ec 1c             	sub    $0x1c,%esp
  8017c1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c4:	56                   	push   %esi
  8017c5:	e8 68 f1 ff ff       	call   800932 <strlen>
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d2:	7f 6c                	jg     801840 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017da:	50                   	push   %eax
  8017db:	e8 79 f8 ff ff       	call   801059 <fd_alloc>
  8017e0:	89 c3                	mov    %eax,%ebx
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	78 3c                	js     801825 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017e9:	83 ec 08             	sub    $0x8,%esp
  8017ec:	56                   	push   %esi
  8017ed:	68 00 50 80 00       	push   $0x805000
  8017f2:	e8 74 f1 ff ff       	call   80096b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	b8 01 00 00 00       	mov    $0x1,%eax
  801807:	e8 b8 fd ff ff       	call   8015c4 <fsipc>
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	85 c0                	test   %eax,%eax
  801813:	78 19                	js     80182e <open+0x75>
	return fd2num(fd);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 f4             	pushl  -0xc(%ebp)
  80181b:	e8 12 f8 ff ff       	call   801032 <fd2num>
  801820:	89 c3                	mov    %eax,%ebx
  801822:	83 c4 10             	add    $0x10,%esp
}
  801825:	89 d8                	mov    %ebx,%eax
  801827:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    
		fd_close(fd, 0);
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	6a 00                	push   $0x0
  801833:	ff 75 f4             	pushl  -0xc(%ebp)
  801836:	e8 1b f9 ff ff       	call   801156 <fd_close>
		return r;
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	eb e5                	jmp    801825 <open+0x6c>
		return -E_BAD_PATH;
  801840:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801845:	eb de                	jmp    801825 <open+0x6c>

00801847 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 08 00 00 00       	mov    $0x8,%eax
  801857:	e8 68 fd ff ff       	call   8015c4 <fsipc>
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801864:	68 53 2a 80 00       	push   $0x802a53
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	e8 fa f0 ff ff       	call   80096b <strcpy>
	return 0;
}
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <devsock_close>:
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	53                   	push   %ebx
  80187c:	83 ec 10             	sub    $0x10,%esp
  80187f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801882:	53                   	push   %ebx
  801883:	e8 5d 0a 00 00       	call   8022e5 <pageref>
  801888:	83 c4 10             	add    $0x10,%esp
		return 0;
  80188b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801890:	83 f8 01             	cmp    $0x1,%eax
  801893:	74 07                	je     80189c <devsock_close+0x24>
}
  801895:	89 d0                	mov    %edx,%eax
  801897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80189c:	83 ec 0c             	sub    $0xc,%esp
  80189f:	ff 73 0c             	pushl  0xc(%ebx)
  8018a2:	e8 b9 02 00 00       	call   801b60 <nsipc_close>
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	eb e7                	jmp    801895 <devsock_close+0x1d>

008018ae <devsock_write>:
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	ff 75 10             	pushl  0x10(%ebp)
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	ff 70 0c             	pushl  0xc(%eax)
  8018c2:	e8 76 03 00 00       	call   801c3d <nsipc_send>
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <devsock_read>:
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	ff 75 10             	pushl  0x10(%ebp)
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	ff 70 0c             	pushl  0xc(%eax)
  8018dd:	e8 ef 02 00 00       	call   801bd1 <nsipc_recv>
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <fd2sockid>:
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	e8 b7 f7 ff ff       	call   8010ab <fd_lookup>
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 10                	js     80190b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801904:	39 08                	cmp    %ecx,(%eax)
  801906:	75 05                	jne    80190d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801908:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    
		return -E_NOT_SUPP;
  80190d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801912:	eb f7                	jmp    80190b <fd2sockid+0x27>

00801914 <alloc_sockfd>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	83 ec 1c             	sub    $0x1c,%esp
  80191c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80191e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801921:	50                   	push   %eax
  801922:	e8 32 f7 ff ff       	call   801059 <fd_alloc>
  801927:	89 c3                	mov    %eax,%ebx
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 43                	js     801973 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	68 07 04 00 00       	push   $0x407
  801938:	ff 75 f4             	pushl  -0xc(%ebp)
  80193b:	6a 00                	push   $0x0
  80193d:	e8 1b f4 ff ff       	call   800d5d <sys_page_alloc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 28                	js     801973 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80194b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801954:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801960:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	50                   	push   %eax
  801967:	e8 c6 f6 ff ff       	call   801032 <fd2num>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	eb 0c                	jmp    80197f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	56                   	push   %esi
  801977:	e8 e4 01 00 00       	call   801b60 <nsipc_close>
		return r;
  80197c:	83 c4 10             	add    $0x10,%esp
}
  80197f:	89 d8                	mov    %ebx,%eax
  801981:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <accept>:
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	e8 4e ff ff ff       	call   8018e4 <fd2sockid>
  801996:	85 c0                	test   %eax,%eax
  801998:	78 1b                	js     8019b5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	e8 0e 01 00 00       	call   801ab7 <nsipc_accept>
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 05                	js     8019b5 <accept+0x2d>
	return alloc_sockfd(r);
  8019b0:	e8 5f ff ff ff       	call   801914 <alloc_sockfd>
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <bind>:
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	e8 1f ff ff ff       	call   8018e4 <fd2sockid>
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 12                	js     8019db <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	ff 75 10             	pushl  0x10(%ebp)
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	e8 31 01 00 00       	call   801b09 <nsipc_bind>
  8019d8:	83 c4 10             	add    $0x10,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <shutdown>:
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	e8 f9 fe ff ff       	call   8018e4 <fd2sockid>
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	78 0f                	js     8019fe <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	50                   	push   %eax
  8019f6:	e8 43 01 00 00       	call   801b3e <nsipc_shutdown>
  8019fb:	83 c4 10             	add    $0x10,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <connect>:
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	e8 d6 fe ff ff       	call   8018e4 <fd2sockid>
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 12                	js     801a24 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	ff 75 10             	pushl  0x10(%ebp)
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	50                   	push   %eax
  801a1c:	e8 59 01 00 00       	call   801b7a <nsipc_connect>
  801a21:	83 c4 10             	add    $0x10,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <listen>:
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	e8 b0 fe ff ff       	call   8018e4 <fd2sockid>
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 0f                	js     801a47 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	50                   	push   %eax
  801a3f:	e8 6b 01 00 00       	call   801baf <nsipc_listen>
  801a44:	83 c4 10             	add    $0x10,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	e8 3e 02 00 00       	call   801c9b <nsipc_socket>
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 05                	js     801a69 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a64:	e8 ab fe ff ff       	call   801914 <alloc_sockfd>
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a74:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a7b:	74 26                	je     801aa3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a7d:	6a 07                	push   $0x7
  801a7f:	68 00 60 80 00       	push   $0x806000
  801a84:	53                   	push   %ebx
  801a85:	ff 35 04 40 80 00    	pushl  0x804004
  801a8b:	e8 c2 07 00 00       	call   802252 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a90:	83 c4 0c             	add    $0xc,%esp
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	e8 4b 07 00 00       	call   8021e9 <ipc_recv>
}
  801a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa3:	83 ec 0c             	sub    $0xc,%esp
  801aa6:	6a 02                	push   $0x2
  801aa8:	e8 fd 07 00 00       	call   8022aa <ipc_find_env>
  801aad:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	eb c6                	jmp    801a7d <nsipc+0x12>

00801ab7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ac7:	8b 06                	mov    (%esi),%eax
  801ac9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ace:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad3:	e8 93 ff ff ff       	call   801a6b <nsipc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	85 c0                	test   %eax,%eax
  801adc:	79 09                	jns    801ae7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ade:	89 d8                	mov    %ebx,%eax
  801ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	ff 35 10 60 80 00    	pushl  0x806010
  801af0:	68 00 60 80 00       	push   $0x806000
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	e8 fc ef ff ff       	call   800af9 <memmove>
		*addrlen = ret->ret_addrlen;
  801afd:	a1 10 60 80 00       	mov    0x806010,%eax
  801b02:	89 06                	mov    %eax,(%esi)
  801b04:	83 c4 10             	add    $0x10,%esp
	return r;
  801b07:	eb d5                	jmp    801ade <nsipc_accept+0x27>

00801b09 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	53                   	push   %ebx
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1b:	53                   	push   %ebx
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	68 04 60 80 00       	push   $0x806004
  801b24:	e8 d0 ef ff ff       	call   800af9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b29:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b2f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b34:	e8 32 ff ff ff       	call   801a6b <nsipc>
}
  801b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b54:	b8 03 00 00 00       	mov    $0x3,%eax
  801b59:	e8 0d ff ff ff       	call   801a6b <nsipc>
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <nsipc_close>:

int
nsipc_close(int s)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b6e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b73:	e8 f3 fe ff ff       	call   801a6b <nsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b8c:	53                   	push   %ebx
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	68 04 60 80 00       	push   $0x806004
  801b95:	e8 5f ef ff ff       	call   800af9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b9a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ba0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba5:	e8 c1 fe ff ff       	call   801a6b <nsipc>
}
  801baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc5:	b8 06 00 00 00       	mov    $0x6,%eax
  801bca:	e8 9c fe ff ff       	call   801a6b <nsipc>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bef:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf4:	e8 72 fe ff ff       	call   801a6b <nsipc>
  801bf9:	89 c3                	mov    %eax,%ebx
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 1f                	js     801c1e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bff:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c04:	7f 21                	jg     801c27 <nsipc_recv+0x56>
  801c06:	39 c6                	cmp    %eax,%esi
  801c08:	7c 1d                	jl     801c27 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	50                   	push   %eax
  801c0e:	68 00 60 80 00       	push   $0x806000
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	e8 de ee ff ff       	call   800af9 <memmove>
  801c1b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c1e:	89 d8                	mov    %ebx,%eax
  801c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c27:	68 5f 2a 80 00       	push   $0x802a5f
  801c2c:	68 27 2a 80 00       	push   $0x802a27
  801c31:	6a 62                	push   $0x62
  801c33:	68 74 2a 80 00       	push   $0x802a74
  801c38:	e8 4b 05 00 00       	call   802188 <_panic>

00801c3d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	53                   	push   %ebx
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c4f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c55:	7f 2e                	jg     801c85 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	53                   	push   %ebx
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	68 0c 60 80 00       	push   $0x80600c
  801c63:	e8 91 ee ff ff       	call   800af9 <memmove>
	nsipcbuf.send.req_size = size;
  801c68:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c71:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c76:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7b:	e8 eb fd ff ff       	call   801a6b <nsipc>
}
  801c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    
	assert(size < 1600);
  801c85:	68 80 2a 80 00       	push   $0x802a80
  801c8a:	68 27 2a 80 00       	push   $0x802a27
  801c8f:	6a 6d                	push   $0x6d
  801c91:	68 74 2a 80 00       	push   $0x802a74
  801c96:	e8 ed 04 00 00       	call   802188 <_panic>

00801c9b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cac:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cb9:	b8 09 00 00 00       	mov    $0x9,%eax
  801cbe:	e8 a8 fd ff ff       	call   801a6b <nsipc>
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	56                   	push   %esi
  801cc9:	53                   	push   %ebx
  801cca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 6a f3 ff ff       	call   801042 <fd2data>
  801cd8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cda:	83 c4 08             	add    $0x8,%esp
  801cdd:	68 8c 2a 80 00       	push   $0x802a8c
  801ce2:	53                   	push   %ebx
  801ce3:	e8 83 ec ff ff       	call   80096b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ce8:	8b 46 04             	mov    0x4(%esi),%eax
  801ceb:	2b 06                	sub    (%esi),%eax
  801ced:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cfa:	00 00 00 
	stat->st_dev = &devpipe;
  801cfd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d04:	30 80 00 
	return 0;
}
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5d                   	pop    %ebp
  801d12:	c3                   	ret    

00801d13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 0c             	sub    $0xc,%esp
  801d1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d1d:	53                   	push   %ebx
  801d1e:	6a 00                	push   $0x0
  801d20:	e8 bd f0 ff ff       	call   800de2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d25:	89 1c 24             	mov    %ebx,(%esp)
  801d28:	e8 15 f3 ff ff       	call   801042 <fd2data>
  801d2d:	83 c4 08             	add    $0x8,%esp
  801d30:	50                   	push   %eax
  801d31:	6a 00                	push   $0x0
  801d33:	e8 aa f0 ff ff       	call   800de2 <sys_page_unmap>
}
  801d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <_pipeisclosed>:
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	57                   	push   %edi
  801d41:	56                   	push   %esi
  801d42:	53                   	push   %ebx
  801d43:	83 ec 1c             	sub    $0x1c,%esp
  801d46:	89 c7                	mov    %eax,%edi
  801d48:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d4a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d4f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	57                   	push   %edi
  801d56:	e8 8a 05 00 00       	call   8022e5 <pageref>
  801d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d5e:	89 34 24             	mov    %esi,(%esp)
  801d61:	e8 7f 05 00 00       	call   8022e5 <pageref>
		nn = thisenv->env_runs;
  801d66:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d6c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	39 cb                	cmp    %ecx,%ebx
  801d74:	74 1b                	je     801d91 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d76:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d79:	75 cf                	jne    801d4a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d7b:	8b 42 58             	mov    0x58(%edx),%eax
  801d7e:	6a 01                	push   $0x1
  801d80:	50                   	push   %eax
  801d81:	53                   	push   %ebx
  801d82:	68 93 2a 80 00       	push   $0x802a93
  801d87:	e8 80 e4 ff ff       	call   80020c <cprintf>
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	eb b9                	jmp    801d4a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d94:	0f 94 c0             	sete   %al
  801d97:	0f b6 c0             	movzbl %al,%eax
}
  801d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5f                   	pop    %edi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <devpipe_write>:
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	57                   	push   %edi
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	83 ec 28             	sub    $0x28,%esp
  801dab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dae:	56                   	push   %esi
  801daf:	e8 8e f2 ff ff       	call   801042 <fd2data>
  801db4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc1:	74 4f                	je     801e12 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc3:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc6:	8b 0b                	mov    (%ebx),%ecx
  801dc8:	8d 51 20             	lea    0x20(%ecx),%edx
  801dcb:	39 d0                	cmp    %edx,%eax
  801dcd:	72 14                	jb     801de3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dcf:	89 da                	mov    %ebx,%edx
  801dd1:	89 f0                	mov    %esi,%eax
  801dd3:	e8 65 ff ff ff       	call   801d3d <_pipeisclosed>
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	75 3b                	jne    801e17 <devpipe_write+0x75>
			sys_yield();
  801ddc:	e8 5d ef ff ff       	call   800d3e <sys_yield>
  801de1:	eb e0                	jmp    801dc3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ded:	89 c2                	mov    %eax,%edx
  801def:	c1 fa 1f             	sar    $0x1f,%edx
  801df2:	89 d1                	mov    %edx,%ecx
  801df4:	c1 e9 1b             	shr    $0x1b,%ecx
  801df7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dfa:	83 e2 1f             	and    $0x1f,%edx
  801dfd:	29 ca                	sub    %ecx,%edx
  801dff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e03:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e07:	83 c0 01             	add    $0x1,%eax
  801e0a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0d:	83 c7 01             	add    $0x1,%edi
  801e10:	eb ac                	jmp    801dbe <devpipe_write+0x1c>
	return i;
  801e12:	8b 45 10             	mov    0x10(%ebp),%eax
  801e15:	eb 05                	jmp    801e1c <devpipe_write+0x7a>
				return 0;
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <devpipe_read>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	57                   	push   %edi
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 18             	sub    $0x18,%esp
  801e2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e30:	57                   	push   %edi
  801e31:	e8 0c f2 ff ff       	call   801042 <fd2data>
  801e36:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	be 00 00 00 00       	mov    $0x0,%esi
  801e40:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e43:	75 14                	jne    801e59 <devpipe_read+0x35>
	return i;
  801e45:	8b 45 10             	mov    0x10(%ebp),%eax
  801e48:	eb 02                	jmp    801e4c <devpipe_read+0x28>
				return i;
  801e4a:	89 f0                	mov    %esi,%eax
}
  801e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
			sys_yield();
  801e54:	e8 e5 ee ff ff       	call   800d3e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e59:	8b 03                	mov    (%ebx),%eax
  801e5b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e5e:	75 18                	jne    801e78 <devpipe_read+0x54>
			if (i > 0)
  801e60:	85 f6                	test   %esi,%esi
  801e62:	75 e6                	jne    801e4a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e64:	89 da                	mov    %ebx,%edx
  801e66:	89 f8                	mov    %edi,%eax
  801e68:	e8 d0 fe ff ff       	call   801d3d <_pipeisclosed>
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	74 e3                	je     801e54 <devpipe_read+0x30>
				return 0;
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	eb d4                	jmp    801e4c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e78:	99                   	cltd   
  801e79:	c1 ea 1b             	shr    $0x1b,%edx
  801e7c:	01 d0                	add    %edx,%eax
  801e7e:	83 e0 1f             	and    $0x1f,%eax
  801e81:	29 d0                	sub    %edx,%eax
  801e83:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e8e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e91:	83 c6 01             	add    $0x1,%esi
  801e94:	eb aa                	jmp    801e40 <devpipe_read+0x1c>

00801e96 <pipe>:
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea1:	50                   	push   %eax
  801ea2:	e8 b2 f1 ff ff       	call   801059 <fd_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 23 01 00 00    	js     801fd7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	68 07 04 00 00       	push   $0x407
  801ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebf:	6a 00                	push   $0x0
  801ec1:	e8 97 ee ff ff       	call   800d5d <sys_page_alloc>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	0f 88 04 01 00 00    	js     801fd7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ed9:	50                   	push   %eax
  801eda:	e8 7a f1 ff ff       	call   801059 <fd_alloc>
  801edf:	89 c3                	mov    %eax,%ebx
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	0f 88 db 00 00 00    	js     801fc7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 07 04 00 00       	push   $0x407
  801ef4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 5f ee ff ff       	call   800d5d <sys_page_alloc>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	85 c0                	test   %eax,%eax
  801f05:	0f 88 bc 00 00 00    	js     801fc7 <pipe+0x131>
	va = fd2data(fd0);
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f11:	e8 2c f1 ff ff       	call   801042 <fd2data>
  801f16:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f18:	83 c4 0c             	add    $0xc,%esp
  801f1b:	68 07 04 00 00       	push   $0x407
  801f20:	50                   	push   %eax
  801f21:	6a 00                	push   $0x0
  801f23:	e8 35 ee ff ff       	call   800d5d <sys_page_alloc>
  801f28:	89 c3                	mov    %eax,%ebx
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	0f 88 82 00 00 00    	js     801fb7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3b:	e8 02 f1 ff ff       	call   801042 <fd2data>
  801f40:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f47:	50                   	push   %eax
  801f48:	6a 00                	push   $0x0
  801f4a:	56                   	push   %esi
  801f4b:	6a 00                	push   $0x0
  801f4d:	e8 4e ee ff ff       	call   800da0 <sys_page_map>
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	83 c4 20             	add    $0x20,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 4e                	js     801fa9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f68:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f72:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	ff 75 f4             	pushl  -0xc(%ebp)
  801f84:	e8 a9 f0 ff ff       	call   801032 <fd2num>
  801f89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f8e:	83 c4 04             	add    $0x4,%esp
  801f91:	ff 75 f0             	pushl  -0x10(%ebp)
  801f94:	e8 99 f0 ff ff       	call   801032 <fd2num>
  801f99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa7:	eb 2e                	jmp    801fd7 <pipe+0x141>
	sys_page_unmap(0, va);
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	56                   	push   %esi
  801fad:	6a 00                	push   $0x0
  801faf:	e8 2e ee ff ff       	call   800de2 <sys_page_unmap>
  801fb4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 1e ee ff ff       	call   800de2 <sys_page_unmap>
  801fc4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fc7:	83 ec 08             	sub    $0x8,%esp
  801fca:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 0e ee ff ff       	call   800de2 <sys_page_unmap>
  801fd4:	83 c4 10             	add    $0x10,%esp
}
  801fd7:	89 d8                	mov    %ebx,%eax
  801fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <pipeisclosed>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 b9 f0 ff ff       	call   8010ab <fd_lookup>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 18                	js     802011 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	e8 3e f0 ff ff       	call   801042 <fd2data>
	return _pipeisclosed(fd, p);
  802004:	89 c2                	mov    %eax,%edx
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	e8 2f fd ff ff       	call   801d3d <_pipeisclosed>
  80200e:	83 c4 10             	add    $0x10,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	c3                   	ret    

00802019 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80201f:	68 ab 2a 80 00       	push   $0x802aab
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	e8 3f e9 ff ff       	call   80096b <strcpy>
	return 0;
}
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <devcons_write>:
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	57                   	push   %edi
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80203f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802044:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80204a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80204d:	73 31                	jae    802080 <devcons_write+0x4d>
		m = n - tot;
  80204f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802052:	29 f3                	sub    %esi,%ebx
  802054:	83 fb 7f             	cmp    $0x7f,%ebx
  802057:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80205c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	53                   	push   %ebx
  802063:	89 f0                	mov    %esi,%eax
  802065:	03 45 0c             	add    0xc(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	57                   	push   %edi
  80206a:	e8 8a ea ff ff       	call   800af9 <memmove>
		sys_cputs(buf, m);
  80206f:	83 c4 08             	add    $0x8,%esp
  802072:	53                   	push   %ebx
  802073:	57                   	push   %edi
  802074:	e8 28 ec ff ff       	call   800ca1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802079:	01 de                	add    %ebx,%esi
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	eb ca                	jmp    80204a <devcons_write+0x17>
}
  802080:	89 f0                	mov    %esi,%eax
  802082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <devcons_read>:
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802099:	74 21                	je     8020bc <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80209b:	e8 1f ec ff ff       	call   800cbf <sys_cgetc>
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	75 07                	jne    8020ab <devcons_read+0x21>
		sys_yield();
  8020a4:	e8 95 ec ff ff       	call   800d3e <sys_yield>
  8020a9:	eb f0                	jmp    80209b <devcons_read+0x11>
	if (c < 0)
  8020ab:	78 0f                	js     8020bc <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020ad:	83 f8 04             	cmp    $0x4,%eax
  8020b0:	74 0c                	je     8020be <devcons_read+0x34>
	*(char*)vbuf = c;
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	88 02                	mov    %al,(%edx)
	return 1;
  8020b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    
		return 0;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c3:	eb f7                	jmp    8020bc <devcons_read+0x32>

008020c5 <cputchar>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d1:	6a 01                	push   $0x1
  8020d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d6:	50                   	push   %eax
  8020d7:	e8 c5 eb ff ff       	call   800ca1 <sys_cputs>
}
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <getchar>:
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e7:	6a 01                	push   $0x1
  8020e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ec:	50                   	push   %eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	e8 27 f2 ff ff       	call   80131b <read>
	if (r < 0)
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 06                	js     802101 <getchar+0x20>
	if (r < 1)
  8020fb:	74 06                	je     802103 <getchar+0x22>
	return c;
  8020fd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    
		return -E_EOF;
  802103:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802108:	eb f7                	jmp    802101 <getchar+0x20>

0080210a <iscons>:
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802113:	50                   	push   %eax
  802114:	ff 75 08             	pushl  0x8(%ebp)
  802117:	e8 8f ef ff ff       	call   8010ab <fd_lookup>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 11                	js     802134 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212c:	39 10                	cmp    %edx,(%eax)
  80212e:	0f 94 c0             	sete   %al
  802131:	0f b6 c0             	movzbl %al,%eax
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <opencons>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80213c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213f:	50                   	push   %eax
  802140:	e8 14 ef ff ff       	call   801059 <fd_alloc>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 3a                	js     802186 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	68 07 04 00 00       	push   $0x407
  802154:	ff 75 f4             	pushl  -0xc(%ebp)
  802157:	6a 00                	push   $0x0
  802159:	e8 ff eb ff ff       	call   800d5d <sys_page_alloc>
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	85 c0                	test   %eax,%eax
  802163:	78 21                	js     802186 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80216e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	50                   	push   %eax
  80217e:	e8 af ee ff ff       	call   801032 <fd2num>
  802183:	83 c4 10             	add    $0x10,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	56                   	push   %esi
  80218c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80218d:	a1 08 40 80 00       	mov    0x804008,%eax
  802192:	8b 40 48             	mov    0x48(%eax),%eax
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 e8 2a 80 00       	push   $0x802ae8
  80219d:	50                   	push   %eax
  80219e:	68 b7 2a 80 00       	push   $0x802ab7
  8021a3:	e8 64 e0 ff ff       	call   80020c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021a8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021ab:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021b1:	e8 69 eb ff ff       	call   800d1f <sys_getenvid>
  8021b6:	83 c4 04             	add    $0x4,%esp
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	ff 75 08             	pushl  0x8(%ebp)
  8021bf:	56                   	push   %esi
  8021c0:	50                   	push   %eax
  8021c1:	68 c4 2a 80 00       	push   $0x802ac4
  8021c6:	e8 41 e0 ff ff       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021cb:	83 c4 18             	add    $0x18,%esp
  8021ce:	53                   	push   %ebx
  8021cf:	ff 75 10             	pushl  0x10(%ebp)
  8021d2:	e8 e4 df ff ff       	call   8001bb <vcprintf>
	cprintf("\n");
  8021d7:	c7 04 24 c7 25 80 00 	movl   $0x8025c7,(%esp)
  8021de:	e8 29 e0 ff ff       	call   80020c <cprintf>
  8021e3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e6:	cc                   	int3   
  8021e7:	eb fd                	jmp    8021e6 <_panic+0x5e>

008021e9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021f9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021fe:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	50                   	push   %eax
  802205:	e8 03 ed ff ff       	call   800f0d <sys_ipc_recv>
	if(ret < 0){
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	85 c0                	test   %eax,%eax
  80220f:	78 2b                	js     80223c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802211:	85 f6                	test   %esi,%esi
  802213:	74 0a                	je     80221f <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802215:	a1 08 40 80 00       	mov    0x804008,%eax
  80221a:	8b 40 74             	mov    0x74(%eax),%eax
  80221d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80221f:	85 db                	test   %ebx,%ebx
  802221:	74 0a                	je     80222d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802223:	a1 08 40 80 00       	mov    0x804008,%eax
  802228:	8b 40 78             	mov    0x78(%eax),%eax
  80222b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80222d:	a1 08 40 80 00       	mov    0x804008,%eax
  802232:	8b 40 70             	mov    0x70(%eax),%eax
}
  802235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802238:	5b                   	pop    %ebx
  802239:	5e                   	pop    %esi
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    
		if(from_env_store)
  80223c:	85 f6                	test   %esi,%esi
  80223e:	74 06                	je     802246 <ipc_recv+0x5d>
			*from_env_store = 0;
  802240:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802246:	85 db                	test   %ebx,%ebx
  802248:	74 eb                	je     802235 <ipc_recv+0x4c>
			*perm_store = 0;
  80224a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802250:	eb e3                	jmp    802235 <ipc_recv+0x4c>

00802252 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	57                   	push   %edi
  802256:	56                   	push   %esi
  802257:	53                   	push   %ebx
  802258:	83 ec 0c             	sub    $0xc,%esp
  80225b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80225e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802261:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802264:	85 db                	test   %ebx,%ebx
  802266:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226b:	0f 44 d8             	cmove  %eax,%ebx
  80226e:	eb 05                	jmp    802275 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802270:	e8 c9 ea ff ff       	call   800d3e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802275:	ff 75 14             	pushl  0x14(%ebp)
  802278:	53                   	push   %ebx
  802279:	56                   	push   %esi
  80227a:	57                   	push   %edi
  80227b:	e8 6a ec ff ff       	call   800eea <sys_ipc_try_send>
  802280:	83 c4 10             	add    $0x10,%esp
  802283:	85 c0                	test   %eax,%eax
  802285:	74 1b                	je     8022a2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802287:	79 e7                	jns    802270 <ipc_send+0x1e>
  802289:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80228c:	74 e2                	je     802270 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 ef 2a 80 00       	push   $0x802aef
  802296:	6a 48                	push   $0x48
  802298:	68 04 2b 80 00       	push   $0x802b04
  80229d:	e8 e6 fe ff ff       	call   802188 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    

008022aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b5:	89 c2                	mov    %eax,%edx
  8022b7:	c1 e2 07             	shl    $0x7,%edx
  8022ba:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c0:	8b 52 50             	mov    0x50(%edx),%edx
  8022c3:	39 ca                	cmp    %ecx,%edx
  8022c5:	74 11                	je     8022d8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022c7:	83 c0 01             	add    $0x1,%eax
  8022ca:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022cf:	75 e4                	jne    8022b5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	eb 0b                	jmp    8022e3 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022d8:	c1 e0 07             	shl    $0x7,%eax
  8022db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022e0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    

008022e5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	c1 e8 16             	shr    $0x16,%eax
  8022f0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022fc:	f6 c1 01             	test   $0x1,%cl
  8022ff:	74 1d                	je     80231e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802301:	c1 ea 0c             	shr    $0xc,%edx
  802304:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80230b:	f6 c2 01             	test   $0x1,%dl
  80230e:	74 0e                	je     80231e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802310:	c1 ea 0c             	shr    $0xc,%edx
  802313:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80231a:	ef 
  80231b:	0f b7 c0             	movzwl %ax,%eax
}
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    

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
