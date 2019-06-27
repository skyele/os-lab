
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	57                   	push   %edi
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800045:	00 00 00 
	envid_t find = sys_getenvid();
  800048:	e8 9f 0c 00 00       	call   800cec <sys_getenvid>
  80004d:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800053:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800058:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005d:	bf 01 00 00 00       	mov    $0x1,%edi
  800062:	eb 0b                	jmp    80006f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800064:	83 c2 01             	add    $0x1,%edx
  800067:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006d:	74 23                	je     800092 <libmain+0x5d>
		if(envs[i].env_id == find)
  80006f:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800075:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007e:	39 c1                	cmp    %eax,%ecx
  800080:	75 e2                	jne    800064 <libmain+0x2f>
  800082:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800088:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008e:	89 fe                	mov    %edi,%esi
  800090:	eb d2                	jmp    800064 <libmain+0x2f>
  800092:	89 f0                	mov    %esi,%eax
  800094:	84 c0                	test   %al,%al
  800096:	74 06                	je     80009e <libmain+0x69>
  800098:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a2:	7e 0a                	jle    8000ae <libmain+0x79>
		binaryname = argv[0];
  8000a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a7:	8b 00                	mov    (%eax),%eax
  8000a9:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	83 ec 08             	sub    $0x8,%esp
  8000b9:	50                   	push   %eax
  8000ba:	68 80 25 80 00       	push   $0x802580
  8000bf:	e8 15 01 00 00       	call   8001d9 <cprintf>
	cprintf("before umain\n");
  8000c4:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000cb:	e8 09 01 00 00       	call   8001d9 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d0:	83 c4 08             	add    $0x8,%esp
  8000d3:	ff 75 0c             	pushl  0xc(%ebp)
  8000d6:	ff 75 08             	pushl  0x8(%ebp)
  8000d9:	e8 55 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000de:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000e5:	e8 ef 00 00 00       	call   8001d9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ef:	8b 40 48             	mov    0x48(%eax),%eax
  8000f2:	83 c4 08             	add    $0x8,%esp
  8000f5:	50                   	push   %eax
  8000f6:	68 b9 25 80 00       	push   $0x8025b9
  8000fb:	e8 d9 00 00 00       	call   8001d9 <cprintf>
	// exit gracefully
	exit();
  800100:	e8 0b 00 00 00       	call   800110 <exit>
}
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800116:	a1 08 40 80 00       	mov    0x804008,%eax
  80011b:	8b 40 48             	mov    0x48(%eax),%eax
  80011e:	68 e4 25 80 00       	push   $0x8025e4
  800123:	50                   	push   %eax
  800124:	68 d8 25 80 00       	push   $0x8025d8
  800129:	e8 ab 00 00 00       	call   8001d9 <cprintf>
	close_all();
  80012e:	e8 c4 10 00 00       	call   8011f7 <close_all>
	sys_env_destroy(0);
  800133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013a:	e8 6c 0b 00 00       	call   800cab <sys_env_destroy>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	c9                   	leave  
  800143:	c3                   	ret    

00800144 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	53                   	push   %ebx
  800148:	83 ec 04             	sub    $0x4,%esp
  80014b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014e:	8b 13                	mov    (%ebx),%edx
  800150:	8d 42 01             	lea    0x1(%edx),%eax
  800153:	89 03                	mov    %eax,(%ebx)
  800155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800158:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800161:	74 09                	je     80016c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800163:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	68 ff 00 00 00       	push   $0xff
  800174:	8d 43 08             	lea    0x8(%ebx),%eax
  800177:	50                   	push   %eax
  800178:	e8 f1 0a 00 00       	call   800c6e <sys_cputs>
		b->idx = 0;
  80017d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	eb db                	jmp    800163 <putch+0x1f>

00800188 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800191:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800198:	00 00 00 
	b.cnt = 0;
  80019b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b1:	50                   	push   %eax
  8001b2:	68 44 01 80 00       	push   $0x800144
  8001b7:	e8 4a 01 00 00       	call   800306 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bc:	83 c4 08             	add    $0x8,%esp
  8001bf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 9d 0a 00 00       	call   800c6e <sys_cputs>

	return b.cnt;
}
  8001d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001df:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e2:	50                   	push   %eax
  8001e3:	ff 75 08             	pushl  0x8(%ebp)
  8001e6:	e8 9d ff ff ff       	call   800188 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    

008001ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 1c             	sub    $0x1c,%esp
  8001f6:	89 c6                	mov    %eax,%esi
  8001f8:	89 d7                	mov    %edx,%edi
  8001fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800200:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800203:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800206:	8b 45 10             	mov    0x10(%ebp),%eax
  800209:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80020c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800210:	74 2c                	je     80023e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800212:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800215:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80021c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80021f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800222:	39 c2                	cmp    %eax,%edx
  800224:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800227:	73 43                	jae    80026c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800229:	83 eb 01             	sub    $0x1,%ebx
  80022c:	85 db                	test   %ebx,%ebx
  80022e:	7e 6c                	jle    80029c <printnum+0xaf>
				putch(padc, putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	57                   	push   %edi
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	ff d6                	call   *%esi
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb eb                	jmp    800229 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	6a 20                	push   $0x20
  800243:	6a 00                	push   $0x0
  800245:	50                   	push   %eax
  800246:	ff 75 e4             	pushl  -0x1c(%ebp)
  800249:	ff 75 e0             	pushl  -0x20(%ebp)
  80024c:	89 fa                	mov    %edi,%edx
  80024e:	89 f0                	mov    %esi,%eax
  800250:	e8 98 ff ff ff       	call   8001ed <printnum>
		while (--width > 0)
  800255:	83 c4 20             	add    $0x20,%esp
  800258:	83 eb 01             	sub    $0x1,%ebx
  80025b:	85 db                	test   %ebx,%ebx
  80025d:	7e 65                	jle    8002c4 <printnum+0xd7>
			putch(padc, putdat);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	57                   	push   %edi
  800263:	6a 20                	push   $0x20
  800265:	ff d6                	call   *%esi
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	eb ec                	jmp    800258 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	83 eb 01             	sub    $0x1,%ebx
  800275:	53                   	push   %ebx
  800276:	50                   	push   %eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	ff 75 dc             	pushl  -0x24(%ebp)
  80027d:	ff 75 d8             	pushl  -0x28(%ebp)
  800280:	ff 75 e4             	pushl  -0x1c(%ebp)
  800283:	ff 75 e0             	pushl  -0x20(%ebp)
  800286:	e8 95 20 00 00       	call   802320 <__udivdi3>
  80028b:	83 c4 18             	add    $0x18,%esp
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	89 fa                	mov    %edi,%edx
  800292:	89 f0                	mov    %esi,%eax
  800294:	e8 54 ff ff ff       	call   8001ed <printnum>
  800299:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	57                   	push   %edi
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8002af:	e8 7c 21 00 00       	call   802430 <__umoddi3>
  8002b4:	83 c4 14             	add    $0x14,%esp
  8002b7:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff d6                	call   *%esi
  8002c1:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d6:	8b 10                	mov    (%eax),%edx
  8002d8:	3b 50 04             	cmp    0x4(%eax),%edx
  8002db:	73 0a                	jae    8002e7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e0:	89 08                	mov    %ecx,(%eax)
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	88 02                	mov    %al,(%edx)
}
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <printfmt>:
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ef:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f2:	50                   	push   %eax
  8002f3:	ff 75 10             	pushl  0x10(%ebp)
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 05 00 00 00       	call   800306 <vprintfmt>
}
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <vprintfmt>:
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 3c             	sub    $0x3c,%esp
  80030f:	8b 75 08             	mov    0x8(%ebp),%esi
  800312:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800315:	8b 7d 10             	mov    0x10(%ebp),%edi
  800318:	e9 32 04 00 00       	jmp    80074f <vprintfmt+0x449>
		padc = ' ';
  80031d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800321:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800328:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80032f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800336:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800344:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8d 47 01             	lea    0x1(%edi),%eax
  80034c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034f:	0f b6 17             	movzbl (%edi),%edx
  800352:	8d 42 dd             	lea    -0x23(%edx),%eax
  800355:	3c 55                	cmp    $0x55,%al
  800357:	0f 87 12 05 00 00    	ja     80086f <vprintfmt+0x569>
  80035d:	0f b6 c0             	movzbl %al,%eax
  800360:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80036e:	eb d9                	jmp    800349 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800373:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800377:	eb d0                	jmp    800349 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 75 08             	mov    %esi,0x8(%ebp)
  800387:	eb 03                	jmp    80038c <vprintfmt+0x86>
  800389:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800393:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800396:	8d 72 d0             	lea    -0x30(%edx),%esi
  800399:	83 fe 09             	cmp    $0x9,%esi
  80039c:	76 eb                	jbe    800389 <vprintfmt+0x83>
  80039e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a4:	eb 14                	jmp    8003ba <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8d 40 04             	lea    0x4(%eax),%eax
  8003b4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003be:	79 89                	jns    800349 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003cd:	e9 77 ff ff ff       	jmp    800349 <vprintfmt+0x43>
  8003d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	0f 48 c1             	cmovs  %ecx,%eax
  8003da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e0:	e9 64 ff ff ff       	jmp    800349 <vprintfmt+0x43>
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ef:	e9 55 ff ff ff       	jmp    800349 <vprintfmt+0x43>
			lflag++;
  8003f4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fb:	e9 49 ff ff ff       	jmp    800349 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 78 04             	lea    0x4(%eax),%edi
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	53                   	push   %ebx
  80040a:	ff 30                	pushl  (%eax)
  80040c:	ff d6                	call   *%esi
			break;
  80040e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800414:	e9 33 03 00 00       	jmp    80074c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	99                   	cltd   
  800422:	31 d0                	xor    %edx,%eax
  800424:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800426:	83 f8 11             	cmp    $0x11,%eax
  800429:	7f 23                	jg     80044e <vprintfmt+0x148>
  80042b:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800432:	85 d2                	test   %edx,%edx
  800434:	74 18                	je     80044e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800436:	52                   	push   %edx
  800437:	68 3d 2a 80 00       	push   $0x802a3d
  80043c:	53                   	push   %ebx
  80043d:	56                   	push   %esi
  80043e:	e8 a6 fe ff ff       	call   8002e9 <printfmt>
  800443:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800446:	89 7d 14             	mov    %edi,0x14(%ebp)
  800449:	e9 fe 02 00 00       	jmp    80074c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044e:	50                   	push   %eax
  80044f:	68 01 26 80 00       	push   $0x802601
  800454:	53                   	push   %ebx
  800455:	56                   	push   %esi
  800456:	e8 8e fe ff ff       	call   8002e9 <printfmt>
  80045b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800461:	e9 e6 02 00 00       	jmp    80074c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800466:	8b 45 14             	mov    0x14(%ebp),%eax
  800469:	83 c0 04             	add    $0x4,%eax
  80046c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80046f:	8b 45 14             	mov    0x14(%ebp),%eax
  800472:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800474:	85 c9                	test   %ecx,%ecx
  800476:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  80047b:	0f 45 c1             	cmovne %ecx,%eax
  80047e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800481:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800485:	7e 06                	jle    80048d <vprintfmt+0x187>
  800487:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048b:	75 0d                	jne    80049a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	89 c7                	mov    %eax,%edi
  800492:	03 45 e0             	add    -0x20(%ebp),%eax
  800495:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800498:	eb 53                	jmp    8004ed <vprintfmt+0x1e7>
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a0:	50                   	push   %eax
  8004a1:	e8 71 04 00 00       	call   800917 <strnlen>
  8004a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a9:	29 c1                	sub    %eax,%ecx
  8004ab:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	eb 0f                	jmp    8004cb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	53                   	push   %ebx
  8004c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	83 ef 01             	sub    $0x1,%edi
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	85 ff                	test   %edi,%edi
  8004cd:	7f ed                	jg     8004bc <vprintfmt+0x1b6>
  8004cf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d2:	85 c9                	test   %ecx,%ecx
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d9:	0f 49 c1             	cmovns %ecx,%eax
  8004dc:	29 c1                	sub    %eax,%ecx
  8004de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e1:	eb aa                	jmp    80048d <vprintfmt+0x187>
					putch(ch, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	52                   	push   %edx
  8004e8:	ff d6                	call   *%esi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f2:	83 c7 01             	add    $0x1,%edi
  8004f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f9:	0f be d0             	movsbl %al,%edx
  8004fc:	85 d2                	test   %edx,%edx
  8004fe:	74 4b                	je     80054b <vprintfmt+0x245>
  800500:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800504:	78 06                	js     80050c <vprintfmt+0x206>
  800506:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050a:	78 1e                	js     80052a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800510:	74 d1                	je     8004e3 <vprintfmt+0x1dd>
  800512:	0f be c0             	movsbl %al,%eax
  800515:	83 e8 20             	sub    $0x20,%eax
  800518:	83 f8 5e             	cmp    $0x5e,%eax
  80051b:	76 c6                	jbe    8004e3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 3f                	push   $0x3f
  800523:	ff d6                	call   *%esi
  800525:	83 c4 10             	add    $0x10,%esp
  800528:	eb c3                	jmp    8004ed <vprintfmt+0x1e7>
  80052a:	89 cf                	mov    %ecx,%edi
  80052c:	eb 0e                	jmp    80053c <vprintfmt+0x236>
				putch(' ', putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	53                   	push   %ebx
  800532:	6a 20                	push   $0x20
  800534:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800536:	83 ef 01             	sub    $0x1,%edi
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	85 ff                	test   %edi,%edi
  80053e:	7f ee                	jg     80052e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800540:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
  800546:	e9 01 02 00 00       	jmp    80074c <vprintfmt+0x446>
  80054b:	89 cf                	mov    %ecx,%edi
  80054d:	eb ed                	jmp    80053c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800552:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800559:	e9 eb fd ff ff       	jmp    800349 <vprintfmt+0x43>
	if (lflag >= 2)
  80055e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800562:	7f 21                	jg     800585 <vprintfmt+0x27f>
	else if (lflag)
  800564:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800568:	74 68                	je     8005d2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800572:	89 c1                	mov    %eax,%ecx
  800574:	c1 f9 1f             	sar    $0x1f,%ecx
  800577:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8d 40 04             	lea    0x4(%eax),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
  800583:	eb 17                	jmp    80059c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 50 04             	mov    0x4(%eax),%edx
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800590:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 08             	lea    0x8(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80059c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ac:	78 3f                	js     8005ed <vprintfmt+0x2e7>
			base = 10;
  8005ae:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b7:	0f 84 71 01 00 00    	je     80072e <vprintfmt+0x428>
				putch('+', putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	6a 2b                	push   $0x2b
  8005c3:	ff d6                	call   *%esi
  8005c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cd:	e9 5c 01 00 00       	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005da:	89 c1                	mov    %eax,%ecx
  8005dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb af                	jmp    80059c <vprintfmt+0x296>
				putch('-', putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	6a 2d                	push   $0x2d
  8005f3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fb:	f7 d8                	neg    %eax
  8005fd:	83 d2 00             	adc    $0x0,%edx
  800600:	f7 da                	neg    %edx
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 19 01 00 00       	jmp    80072e <vprintfmt+0x428>
	if (lflag >= 2)
  800615:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800619:	7f 29                	jg     800644 <vprintfmt+0x33e>
	else if (lflag)
  80061b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061f:	74 44                	je     800665 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063f:	e9 ea 00 00 00       	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 50 04             	mov    0x4(%eax),%edx
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 40 08             	lea    0x8(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800660:	e9 c9 00 00 00       	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800683:	e9 a6 00 00 00       	jmp    80072e <vprintfmt+0x428>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800697:	7f 26                	jg     8006bf <vprintfmt+0x3b9>
	else if (lflag)
  800699:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069d:	74 3e                	je     8006dd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bd:	eb 6f                	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 50 04             	mov    0x4(%eax),%edx
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 08             	lea    0x8(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006db:	eb 51                	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 40 04             	lea    0x4(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fb:	eb 31                	jmp    80072e <vprintfmt+0x428>
			putch('0', putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	53                   	push   %ebx
  800701:	6a 30                	push   $0x30
  800703:	ff d6                	call   *%esi
			putch('x', putdat);
  800705:	83 c4 08             	add    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 78                	push   $0x78
  80070b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 04             	lea    0x4(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800729:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072e:	83 ec 0c             	sub    $0xc,%esp
  800731:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800735:	52                   	push   %edx
  800736:	ff 75 e0             	pushl  -0x20(%ebp)
  800739:	50                   	push   %eax
  80073a:	ff 75 dc             	pushl  -0x24(%ebp)
  80073d:	ff 75 d8             	pushl  -0x28(%ebp)
  800740:	89 da                	mov    %ebx,%edx
  800742:	89 f0                	mov    %esi,%eax
  800744:	e8 a4 fa ff ff       	call   8001ed <printnum>
			break;
  800749:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074f:	83 c7 01             	add    $0x1,%edi
  800752:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800756:	83 f8 25             	cmp    $0x25,%eax
  800759:	0f 84 be fb ff ff    	je     80031d <vprintfmt+0x17>
			if (ch == '\0')
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 84 28 01 00 00    	je     80088f <vprintfmt+0x589>
			putch(ch, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	50                   	push   %eax
  80076c:	ff d6                	call   *%esi
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	eb dc                	jmp    80074f <vprintfmt+0x449>
	if (lflag >= 2)
  800773:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800777:	7f 26                	jg     80079f <vprintfmt+0x499>
	else if (lflag)
  800779:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077d:	74 41                	je     8007c0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800798:	b8 10 00 00 00       	mov    $0x10,%eax
  80079d:	eb 8f                	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 50 04             	mov    0x4(%eax),%edx
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 08             	lea    0x8(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bb:	e9 6e ff ff ff       	jmp    80072e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8d 40 04             	lea    0x4(%eax),%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007de:	e9 4b ff ff ff       	jmp    80072e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	83 c0 04             	add    $0x4,%eax
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	74 14                	je     800809 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f5:	8b 13                	mov    (%ebx),%edx
  8007f7:	83 fa 7f             	cmp    $0x7f,%edx
  8007fa:	7f 37                	jg     800833 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007fc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
  800804:	e9 43 ff ff ff       	jmp    80074c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800809:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080e:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	50                   	push   %eax
  800818:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081a:	83 c7 01             	add    $0x1,%edi
  80081d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	85 c0                	test   %eax,%eax
  800826:	75 eb                	jne    800813 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	e9 19 ff ff ff       	jmp    80074c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800833:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800835:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083a:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	53                   	push   %ebx
  800843:	50                   	push   %eax
  800844:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800846:	83 c7 01             	add    $0x1,%edi
  800849:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	85 c0                	test   %eax,%eax
  800852:	75 eb                	jne    80083f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800854:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	e9 ed fe ff ff       	jmp    80074c <vprintfmt+0x446>
			putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 25                	push   $0x25
  800865:	ff d6                	call   *%esi
			break;
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	e9 dd fe ff ff       	jmp    80074c <vprintfmt+0x446>
			putch('%', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	6a 25                	push   $0x25
  800875:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	89 f8                	mov    %edi,%eax
  80087c:	eb 03                	jmp    800881 <vprintfmt+0x57b>
  80087e:	83 e8 01             	sub    $0x1,%eax
  800881:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800885:	75 f7                	jne    80087e <vprintfmt+0x578>
  800887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088a:	e9 bd fe ff ff       	jmp    80074c <vprintfmt+0x446>
}
  80088f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5f                   	pop    %edi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 18             	sub    $0x18,%esp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	74 26                	je     8008de <vsnprintf+0x47>
  8008b8:	85 d2                	test   %edx,%edx
  8008ba:	7e 22                	jle    8008de <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bc:	ff 75 14             	pushl  0x14(%ebp)
  8008bf:	ff 75 10             	pushl  0x10(%ebp)
  8008c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c5:	50                   	push   %eax
  8008c6:	68 cc 02 80 00       	push   $0x8002cc
  8008cb:	e8 36 fa ff ff       	call   800306 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d9:	83 c4 10             	add    $0x10,%esp
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    
		return -E_INVAL;
  8008de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e3:	eb f7                	jmp    8008dc <vsnprintf+0x45>

008008e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ee:	50                   	push   %eax
  8008ef:	ff 75 10             	pushl  0x10(%ebp)
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	ff 75 08             	pushl  0x8(%ebp)
  8008f8:	e8 9a ff ff ff       	call   800897 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fd:	c9                   	leave  
  8008fe:	c3                   	ret    

008008ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090e:	74 05                	je     800915 <strlen+0x16>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	eb f5                	jmp    80090a <strlen+0xb>
	return n;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800920:	ba 00 00 00 00       	mov    $0x0,%edx
  800925:	39 c2                	cmp    %eax,%edx
  800927:	74 0d                	je     800936 <strnlen+0x1f>
  800929:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092d:	74 05                	je     800934 <strnlen+0x1d>
		n++;
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb f1                	jmp    800925 <strnlen+0xe>
  800934:	89 d0                	mov    %edx,%eax
	return n;
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094e:	83 c2 01             	add    $0x1,%edx
  800951:	84 c9                	test   %cl,%cl
  800953:	75 f2                	jne    800947 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800955:	5b                   	pop    %ebx
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	53                   	push   %ebx
  80095c:	83 ec 10             	sub    $0x10,%esp
  80095f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800962:	53                   	push   %ebx
  800963:	e8 97 ff ff ff       	call   8008ff <strlen>
  800968:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	01 d8                	add    %ebx,%eax
  800970:	50                   	push   %eax
  800971:	e8 c2 ff ff ff       	call   800938 <strcpy>
	return dst;
}
  800976:	89 d8                	mov    %ebx,%eax
  800978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800988:	89 c6                	mov    %eax,%esi
  80098a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	39 f2                	cmp    %esi,%edx
  800991:	74 11                	je     8009a4 <strncpy+0x27>
		*dst++ = *src;
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	0f b6 19             	movzbl (%ecx),%ebx
  800999:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099c:	80 fb 01             	cmp    $0x1,%bl
  80099f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a2:	eb eb                	jmp    80098f <strncpy+0x12>
	}
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	74 21                	je     8009dd <strlcpy+0x35>
  8009bc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c2:	39 c2                	cmp    %eax,%edx
  8009c4:	74 14                	je     8009da <strlcpy+0x32>
  8009c6:	0f b6 19             	movzbl (%ecx),%ebx
  8009c9:	84 db                	test   %bl,%bl
  8009cb:	74 0b                	je     8009d8 <strlcpy+0x30>
			*dst++ = *src++;
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d6:	eb ea                	jmp    8009c2 <strlcpy+0x1a>
  8009d8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009dd:	29 f0                	sub    %esi,%eax
}
  8009df:	5b                   	pop    %ebx
  8009e0:	5e                   	pop    %esi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ec:	0f b6 01             	movzbl (%ecx),%eax
  8009ef:	84 c0                	test   %al,%al
  8009f1:	74 0c                	je     8009ff <strcmp+0x1c>
  8009f3:	3a 02                	cmp    (%edx),%al
  8009f5:	75 08                	jne    8009ff <strcmp+0x1c>
		p++, q++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	eb ed                	jmp    8009ec <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ff:	0f b6 c0             	movzbl %al,%eax
  800a02:	0f b6 12             	movzbl (%edx),%edx
  800a05:	29 d0                	sub    %edx,%eax
}
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a13:	89 c3                	mov    %eax,%ebx
  800a15:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a18:	eb 06                	jmp    800a20 <strncmp+0x17>
		n--, p++, q++;
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a20:	39 d8                	cmp    %ebx,%eax
  800a22:	74 16                	je     800a3a <strncmp+0x31>
  800a24:	0f b6 08             	movzbl (%eax),%ecx
  800a27:	84 c9                	test   %cl,%cl
  800a29:	74 04                	je     800a2f <strncmp+0x26>
  800a2b:	3a 0a                	cmp    (%edx),%cl
  800a2d:	74 eb                	je     800a1a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2f:	0f b6 00             	movzbl (%eax),%eax
  800a32:	0f b6 12             	movzbl (%edx),%edx
  800a35:	29 d0                	sub    %edx,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    
		return 0;
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3f:	eb f6                	jmp    800a37 <strncmp+0x2e>

00800a41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4b:	0f b6 10             	movzbl (%eax),%edx
  800a4e:	84 d2                	test   %dl,%dl
  800a50:	74 09                	je     800a5b <strchr+0x1a>
		if (*s == c)
  800a52:	38 ca                	cmp    %cl,%dl
  800a54:	74 0a                	je     800a60 <strchr+0x1f>
	for (; *s; s++)
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	eb f0                	jmp    800a4b <strchr+0xa>
			return (char *) s;
	return 0;
  800a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6f:	38 ca                	cmp    %cl,%dl
  800a71:	74 09                	je     800a7c <strfind+0x1a>
  800a73:	84 d2                	test   %dl,%dl
  800a75:	74 05                	je     800a7c <strfind+0x1a>
	for (; *s; s++)
  800a77:	83 c0 01             	add    $0x1,%eax
  800a7a:	eb f0                	jmp    800a6c <strfind+0xa>
			break;
	return (char *) s;
}
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	57                   	push   %edi
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8a:	85 c9                	test   %ecx,%ecx
  800a8c:	74 31                	je     800abf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8e:	89 f8                	mov    %edi,%eax
  800a90:	09 c8                	or     %ecx,%eax
  800a92:	a8 03                	test   $0x3,%al
  800a94:	75 23                	jne    800ab9 <memset+0x3b>
		c &= 0xFF;
  800a96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9a:	89 d3                	mov    %edx,%ebx
  800a9c:	c1 e3 08             	shl    $0x8,%ebx
  800a9f:	89 d0                	mov    %edx,%eax
  800aa1:	c1 e0 18             	shl    $0x18,%eax
  800aa4:	89 d6                	mov    %edx,%esi
  800aa6:	c1 e6 10             	shl    $0x10,%esi
  800aa9:	09 f0                	or     %esi,%eax
  800aab:	09 c2                	or     %eax,%edx
  800aad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aaf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	fc                   	cld    
  800ab5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab7:	eb 06                	jmp    800abf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	fc                   	cld    
  800abd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abf:	89 f8                	mov    %edi,%eax
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad4:	39 c6                	cmp    %eax,%esi
  800ad6:	73 32                	jae    800b0a <memmove+0x44>
  800ad8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800adb:	39 c2                	cmp    %eax,%edx
  800add:	76 2b                	jbe    800b0a <memmove+0x44>
		s += n;
		d += n;
  800adf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae2:	89 fe                	mov    %edi,%esi
  800ae4:	09 ce                	or     %ecx,%esi
  800ae6:	09 d6                	or     %edx,%esi
  800ae8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aee:	75 0e                	jne    800afe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af0:	83 ef 04             	sub    $0x4,%edi
  800af3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af9:	fd                   	std    
  800afa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afc:	eb 09                	jmp    800b07 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afe:	83 ef 01             	sub    $0x1,%edi
  800b01:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b04:	fd                   	std    
  800b05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b07:	fc                   	cld    
  800b08:	eb 1a                	jmp    800b24 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	09 ca                	or     %ecx,%edx
  800b0e:	09 f2                	or     %esi,%edx
  800b10:	f6 c2 03             	test   $0x3,%dl
  800b13:	75 0a                	jne    800b1f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b18:	89 c7                	mov    %eax,%edi
  800b1a:	fc                   	cld    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 05                	jmp    800b24 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1f:	89 c7                	mov    %eax,%edi
  800b21:	fc                   	cld    
  800b22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2e:	ff 75 10             	pushl  0x10(%ebp)
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 08             	pushl  0x8(%ebp)
  800b37:	e8 8a ff ff ff       	call   800ac6 <memmove>
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b49:	89 c6                	mov    %eax,%esi
  800b4b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4e:	39 f0                	cmp    %esi,%eax
  800b50:	74 1c                	je     800b6e <memcmp+0x30>
		if (*s1 != *s2)
  800b52:	0f b6 08             	movzbl (%eax),%ecx
  800b55:	0f b6 1a             	movzbl (%edx),%ebx
  800b58:	38 d9                	cmp    %bl,%cl
  800b5a:	75 08                	jne    800b64 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	83 c2 01             	add    $0x1,%edx
  800b62:	eb ea                	jmp    800b4e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b64:	0f b6 c1             	movzbl %cl,%eax
  800b67:	0f b6 db             	movzbl %bl,%ebx
  800b6a:	29 d8                	sub    %ebx,%eax
  800b6c:	eb 05                	jmp    800b73 <memcmp+0x35>
	}

	return 0;
  800b6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b80:	89 c2                	mov    %eax,%edx
  800b82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b85:	39 d0                	cmp    %edx,%eax
  800b87:	73 09                	jae    800b92 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b89:	38 08                	cmp    %cl,(%eax)
  800b8b:	74 05                	je     800b92 <memfind+0x1b>
	for (; s < ends; s++)
  800b8d:	83 c0 01             	add    $0x1,%eax
  800b90:	eb f3                	jmp    800b85 <memfind+0xe>
			break;
	return (void *) s;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba0:	eb 03                	jmp    800ba5 <strtol+0x11>
		s++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba5:	0f b6 01             	movzbl (%ecx),%eax
  800ba8:	3c 20                	cmp    $0x20,%al
  800baa:	74 f6                	je     800ba2 <strtol+0xe>
  800bac:	3c 09                	cmp    $0x9,%al
  800bae:	74 f2                	je     800ba2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb0:	3c 2b                	cmp    $0x2b,%al
  800bb2:	74 2a                	je     800bde <strtol+0x4a>
	int neg = 0;
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb9:	3c 2d                	cmp    $0x2d,%al
  800bbb:	74 2b                	je     800be8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc3:	75 0f                	jne    800bd4 <strtol+0x40>
  800bc5:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc8:	74 28                	je     800bf2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd1:	0f 44 d8             	cmove  %eax,%ebx
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdc:	eb 50                	jmp    800c2e <strtol+0x9a>
		s++;
  800bde:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be1:	bf 00 00 00 00       	mov    $0x0,%edi
  800be6:	eb d5                	jmp    800bbd <strtol+0x29>
		s++, neg = 1;
  800be8:	83 c1 01             	add    $0x1,%ecx
  800beb:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf0:	eb cb                	jmp    800bbd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf6:	74 0e                	je     800c06 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	75 d8                	jne    800bd4 <strtol+0x40>
		s++, base = 8;
  800bfc:	83 c1 01             	add    $0x1,%ecx
  800bff:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c04:	eb ce                	jmp    800bd4 <strtol+0x40>
		s += 2, base = 16;
  800c06:	83 c1 02             	add    $0x2,%ecx
  800c09:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0e:	eb c4                	jmp    800bd4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c10:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c13:	89 f3                	mov    %esi,%ebx
  800c15:	80 fb 19             	cmp    $0x19,%bl
  800c18:	77 29                	ja     800c43 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1a:	0f be d2             	movsbl %dl,%edx
  800c1d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c20:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c23:	7d 30                	jge    800c55 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2e:	0f b6 11             	movzbl (%ecx),%edx
  800c31:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 09             	cmp    $0x9,%bl
  800c39:	77 d5                	ja     800c10 <strtol+0x7c>
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
  800c41:	eb dd                	jmp    800c20 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c43:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c46:	89 f3                	mov    %esi,%ebx
  800c48:	80 fb 19             	cmp    $0x19,%bl
  800c4b:	77 08                	ja     800c55 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4d:	0f be d2             	movsbl %dl,%edx
  800c50:	83 ea 37             	sub    $0x37,%edx
  800c53:	eb cb                	jmp    800c20 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xcc>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	f7 da                	neg    %edx
  800c64:	85 ff                	test   %edi,%edi
  800c66:	0f 45 c2             	cmovne %edx,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7f:	89 c3                	mov    %eax,%ebx
  800c81:	89 c7                	mov    %eax,%edi
  800c83:	89 c6                	mov    %eax,%esi
  800c85:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9c:	89 d1                	mov    %edx,%ecx
  800c9e:	89 d3                	mov    %edx,%ebx
  800ca0:	89 d7                	mov    %edx,%edi
  800ca2:	89 d6                	mov    %edx,%esi
  800ca4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc1:	89 cb                	mov    %ecx,%ebx
  800cc3:	89 cf                	mov    %ecx,%edi
  800cc5:	89 ce                	mov    %ecx,%esi
  800cc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 03                	push   $0x3
  800cdb:	68 68 29 80 00       	push   $0x802968
  800ce0:	6a 43                	push   $0x43
  800ce2:	68 85 29 80 00       	push   $0x802985
  800ce7:	e8 89 14 00 00       	call   802175 <_panic>

00800cec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfc:	89 d1                	mov    %edx,%ecx
  800cfe:	89 d3                	mov    %edx,%ebx
  800d00:	89 d7                	mov    %edx,%edi
  800d02:	89 d6                	mov    %edx,%esi
  800d04:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_yield>:

void
sys_yield(void)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d11:	ba 00 00 00 00       	mov    $0x0,%edx
  800d16:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1b:	89 d1                	mov    %edx,%ecx
  800d1d:	89 d3                	mov    %edx,%ebx
  800d1f:	89 d7                	mov    %edx,%edi
  800d21:	89 d6                	mov    %edx,%esi
  800d23:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	be 00 00 00 00       	mov    $0x0,%esi
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d46:	89 f7                	mov    %esi,%edi
  800d48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7f 08                	jg     800d56 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	50                   	push   %eax
  800d5a:	6a 04                	push   $0x4
  800d5c:	68 68 29 80 00       	push   $0x802968
  800d61:	6a 43                	push   $0x43
  800d63:	68 85 29 80 00       	push   $0x802985
  800d68:	e8 08 14 00 00       	call   802175 <_panic>

00800d6d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d84:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d87:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 05                	push   $0x5
  800d9e:	68 68 29 80 00       	push   $0x802968
  800da3:	6a 43                	push   $0x43
  800da5:	68 85 29 80 00       	push   $0x802985
  800daa:	e8 c6 13 00 00       	call   802175 <_panic>

00800daf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7f 08                	jg     800dda <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800dde:	6a 06                	push   $0x6
  800de0:	68 68 29 80 00       	push   $0x802968
  800de5:	6a 43                	push   $0x43
  800de7:	68 85 29 80 00       	push   $0x802985
  800dec:	e8 84 13 00 00       	call   802175 <_panic>

00800df1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0a:	89 df                	mov    %ebx,%edi
  800e0c:	89 de                	mov    %ebx,%esi
  800e0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	7f 08                	jg     800e1c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800e20:	6a 08                	push   $0x8
  800e22:	68 68 29 80 00       	push   $0x802968
  800e27:	6a 43                	push   $0x43
  800e29:	68 85 29 80 00       	push   $0x802985
  800e2e:	e8 42 13 00 00       	call   802175 <_panic>

00800e33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800e47:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800e62:	6a 09                	push   $0x9
  800e64:	68 68 29 80 00       	push   $0x802968
  800e69:	6a 43                	push   $0x43
  800e6b:	68 85 29 80 00       	push   $0x802985
  800e70:	e8 00 13 00 00       	call   802175 <_panic>

00800e75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8e:	89 df                	mov    %ebx,%edi
  800e90:	89 de                	mov    %ebx,%esi
  800e92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800ea4:	6a 0a                	push   $0xa
  800ea6:	68 68 29 80 00       	push   $0x802968
  800eab:	6a 43                	push   $0x43
  800ead:	68 85 29 80 00       	push   $0x802985
  800eb2:	e8 be 12 00 00       	call   802175 <_panic>

00800eb7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec8:	be 00 00 00 00       	mov    $0x0,%esi
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef0:	89 cb                	mov    %ecx,%ebx
  800ef2:	89 cf                	mov    %ecx,%edi
  800ef4:	89 ce                	mov    %ecx,%esi
  800ef6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0d                	push   $0xd
  800f0a:	68 68 29 80 00       	push   $0x802968
  800f0f:	6a 43                	push   $0x43
  800f11:	68 85 29 80 00       	push   $0x802985
  800f16:	e8 5a 12 00 00       	call   802175 <_panic>

00800f1b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f31:	89 df                	mov    %ebx,%edi
  800f33:	89 de                	mov    %ebx,%esi
  800f35:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f62:	ba 00 00 00 00       	mov    $0x0,%edx
  800f67:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6c:	89 d1                	mov    %edx,%ecx
  800f6e:	89 d3                	mov    %edx,%ebx
  800f70:	89 d7                	mov    %edx,%edi
  800f72:	89 d6                	mov    %edx,%esi
  800f74:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8c:	b8 11 00 00 00       	mov    $0x11,%eax
  800f91:	89 df                	mov    %ebx,%edi
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb2:	89 df                	mov    %ebx,%edi
  800fb4:	89 de                	mov    %ebx,%esi
  800fb6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7f 08                	jg     800fe8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	50                   	push   %eax
  800fec:	6a 13                	push   $0x13
  800fee:	68 68 29 80 00       	push   $0x802968
  800ff3:	6a 43                	push   $0x43
  800ff5:	68 85 29 80 00       	push   $0x802985
  800ffa:	e8 76 11 00 00       	call   802175 <_panic>

00800fff <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	b8 14 00 00 00       	mov    $0x14,%eax
  801012:	89 cb                	mov    %ecx,%ebx
  801014:	89 cf                	mov    %ecx,%edi
  801016:	89 ce                	mov    %ecx,%esi
  801018:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	05 00 00 00 30       	add    $0x30000000,%eax
  80102a:	c1 e8 0c             	shr    $0xc,%eax
}
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80103a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80103f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80104e:	89 c2                	mov    %eax,%edx
  801050:	c1 ea 16             	shr    $0x16,%edx
  801053:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105a:	f6 c2 01             	test   $0x1,%dl
  80105d:	74 2d                	je     80108c <fd_alloc+0x46>
  80105f:	89 c2                	mov    %eax,%edx
  801061:	c1 ea 0c             	shr    $0xc,%edx
  801064:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106b:	f6 c2 01             	test   $0x1,%dl
  80106e:	74 1c                	je     80108c <fd_alloc+0x46>
  801070:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801075:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80107a:	75 d2                	jne    80104e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801085:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80108a:	eb 0a                	jmp    801096 <fd_alloc+0x50>
			*fd_store = fd;
  80108c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80109e:	83 f8 1f             	cmp    $0x1f,%eax
  8010a1:	77 30                	ja     8010d3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a3:	c1 e0 0c             	shl    $0xc,%eax
  8010a6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ab:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010b1:	f6 c2 01             	test   $0x1,%dl
  8010b4:	74 24                	je     8010da <fd_lookup+0x42>
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	c1 ea 0c             	shr    $0xc,%edx
  8010bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c2:	f6 c2 01             	test   $0x1,%dl
  8010c5:	74 1a                	je     8010e1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ca:	89 02                	mov    %eax,(%edx)
	return 0;
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    
		return -E_INVAL;
  8010d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d8:	eb f7                	jmp    8010d1 <fd_lookup+0x39>
		return -E_INVAL;
  8010da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010df:	eb f0                	jmp    8010d1 <fd_lookup+0x39>
  8010e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e6:	eb e9                	jmp    8010d1 <fd_lookup+0x39>

008010e8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 08             	sub    $0x8,%esp
  8010ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010fb:	39 08                	cmp    %ecx,(%eax)
  8010fd:	74 38                	je     801137 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010ff:	83 c2 01             	add    $0x1,%edx
  801102:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 ee                	jne    8010fb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80110d:	a1 08 40 80 00       	mov    0x804008,%eax
  801112:	8b 40 48             	mov    0x48(%eax),%eax
  801115:	83 ec 04             	sub    $0x4,%esp
  801118:	51                   	push   %ecx
  801119:	50                   	push   %eax
  80111a:	68 94 29 80 00       	push   $0x802994
  80111f:	e8 b5 f0 ff ff       	call   8001d9 <cprintf>
	*dev = 0;
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    
			*dev = devtab[i];
  801137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113c:	b8 00 00 00 00       	mov    $0x0,%eax
  801141:	eb f2                	jmp    801135 <dev_lookup+0x4d>

00801143 <fd_close>:
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 24             	sub    $0x24,%esp
  80114c:	8b 75 08             	mov    0x8(%ebp),%esi
  80114f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801152:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801155:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801156:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80115c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115f:	50                   	push   %eax
  801160:	e8 33 ff ff ff       	call   801098 <fd_lookup>
  801165:	89 c3                	mov    %eax,%ebx
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 05                	js     801173 <fd_close+0x30>
	    || fd != fd2)
  80116e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801171:	74 16                	je     801189 <fd_close+0x46>
		return (must_exist ? r : 0);
  801173:	89 f8                	mov    %edi,%eax
  801175:	84 c0                	test   %al,%al
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
  80117c:	0f 44 d8             	cmove  %eax,%ebx
}
  80117f:	89 d8                	mov    %ebx,%eax
  801181:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801184:	5b                   	pop    %ebx
  801185:	5e                   	pop    %esi
  801186:	5f                   	pop    %edi
  801187:	5d                   	pop    %ebp
  801188:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80118f:	50                   	push   %eax
  801190:	ff 36                	pushl  (%esi)
  801192:	e8 51 ff ff ff       	call   8010e8 <dev_lookup>
  801197:	89 c3                	mov    %eax,%ebx
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 1a                	js     8011ba <fd_close+0x77>
		if (dev->dev_close)
  8011a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	74 0b                	je     8011ba <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	56                   	push   %esi
  8011b3:	ff d0                	call   *%eax
  8011b5:	89 c3                	mov    %eax,%ebx
  8011b7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	56                   	push   %esi
  8011be:	6a 00                	push   $0x0
  8011c0:	e8 ea fb ff ff       	call   800daf <sys_page_unmap>
	return r;
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	eb b5                	jmp    80117f <fd_close+0x3c>

008011ca <close>:

int
close(int fdnum)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d3:	50                   	push   %eax
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 bc fe ff ff       	call   801098 <fd_lookup>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	79 02                	jns    8011e5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    
		return fd_close(fd, 1);
  8011e5:	83 ec 08             	sub    $0x8,%esp
  8011e8:	6a 01                	push   $0x1
  8011ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ed:	e8 51 ff ff ff       	call   801143 <fd_close>
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	eb ec                	jmp    8011e3 <close+0x19>

008011f7 <close_all>:

void
close_all(void)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011fe:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	53                   	push   %ebx
  801207:	e8 be ff ff ff       	call   8011ca <close>
	for (i = 0; i < MAXFD; i++)
  80120c:	83 c3 01             	add    $0x1,%ebx
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	83 fb 20             	cmp    $0x20,%ebx
  801215:	75 ec                	jne    801203 <close_all+0xc>
}
  801217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	57                   	push   %edi
  801220:	56                   	push   %esi
  801221:	53                   	push   %ebx
  801222:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801225:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801228:	50                   	push   %eax
  801229:	ff 75 08             	pushl  0x8(%ebp)
  80122c:	e8 67 fe ff ff       	call   801098 <fd_lookup>
  801231:	89 c3                	mov    %eax,%ebx
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	0f 88 81 00 00 00    	js     8012bf <dup+0xa3>
		return r;
	close(newfdnum);
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	ff 75 0c             	pushl  0xc(%ebp)
  801244:	e8 81 ff ff ff       	call   8011ca <close>

	newfd = INDEX2FD(newfdnum);
  801249:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124c:	c1 e6 0c             	shl    $0xc,%esi
  80124f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801255:	83 c4 04             	add    $0x4,%esp
  801258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125b:	e8 cf fd ff ff       	call   80102f <fd2data>
  801260:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801262:	89 34 24             	mov    %esi,(%esp)
  801265:	e8 c5 fd ff ff       	call   80102f <fd2data>
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80126f:	89 d8                	mov    %ebx,%eax
  801271:	c1 e8 16             	shr    $0x16,%eax
  801274:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127b:	a8 01                	test   $0x1,%al
  80127d:	74 11                	je     801290 <dup+0x74>
  80127f:	89 d8                	mov    %ebx,%eax
  801281:	c1 e8 0c             	shr    $0xc,%eax
  801284:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128b:	f6 c2 01             	test   $0x1,%dl
  80128e:	75 39                	jne    8012c9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801293:	89 d0                	mov    %edx,%eax
  801295:	c1 e8 0c             	shr    $0xc,%eax
  801298:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a7:	50                   	push   %eax
  8012a8:	56                   	push   %esi
  8012a9:	6a 00                	push   $0x0
  8012ab:	52                   	push   %edx
  8012ac:	6a 00                	push   $0x0
  8012ae:	e8 ba fa ff ff       	call   800d6d <sys_page_map>
  8012b3:	89 c3                	mov    %eax,%ebx
  8012b5:	83 c4 20             	add    $0x20,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 31                	js     8012ed <dup+0xd1>
		goto err;

	return newfdnum;
  8012bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012bf:	89 d8                	mov    %ebx,%eax
  8012c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5f                   	pop    %edi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d0:	83 ec 0c             	sub    $0xc,%esp
  8012d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d8:	50                   	push   %eax
  8012d9:	57                   	push   %edi
  8012da:	6a 00                	push   $0x0
  8012dc:	53                   	push   %ebx
  8012dd:	6a 00                	push   $0x0
  8012df:	e8 89 fa ff ff       	call   800d6d <sys_page_map>
  8012e4:	89 c3                	mov    %eax,%ebx
  8012e6:	83 c4 20             	add    $0x20,%esp
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	79 a3                	jns    801290 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	56                   	push   %esi
  8012f1:	6a 00                	push   $0x0
  8012f3:	e8 b7 fa ff ff       	call   800daf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012f8:	83 c4 08             	add    $0x8,%esp
  8012fb:	57                   	push   %edi
  8012fc:	6a 00                	push   $0x0
  8012fe:	e8 ac fa ff ff       	call   800daf <sys_page_unmap>
	return r;
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	eb b7                	jmp    8012bf <dup+0xa3>

00801308 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	53                   	push   %ebx
  80130c:	83 ec 1c             	sub    $0x1c,%esp
  80130f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801312:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801315:	50                   	push   %eax
  801316:	53                   	push   %ebx
  801317:	e8 7c fd ff ff       	call   801098 <fd_lookup>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	78 3f                	js     801362 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801329:	50                   	push   %eax
  80132a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132d:	ff 30                	pushl  (%eax)
  80132f:	e8 b4 fd ff ff       	call   8010e8 <dev_lookup>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	78 27                	js     801362 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80133b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133e:	8b 42 08             	mov    0x8(%edx),%eax
  801341:	83 e0 03             	and    $0x3,%eax
  801344:	83 f8 01             	cmp    $0x1,%eax
  801347:	74 1e                	je     801367 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	8b 40 08             	mov    0x8(%eax),%eax
  80134f:	85 c0                	test   %eax,%eax
  801351:	74 35                	je     801388 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	ff 75 10             	pushl  0x10(%ebp)
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	52                   	push   %edx
  80135d:	ff d0                	call   *%eax
  80135f:	83 c4 10             	add    $0x10,%esp
}
  801362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801365:	c9                   	leave  
  801366:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801367:	a1 08 40 80 00       	mov    0x804008,%eax
  80136c:	8b 40 48             	mov    0x48(%eax),%eax
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	53                   	push   %ebx
  801373:	50                   	push   %eax
  801374:	68 d5 29 80 00       	push   $0x8029d5
  801379:	e8 5b ee ff ff       	call   8001d9 <cprintf>
		return -E_INVAL;
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801386:	eb da                	jmp    801362 <read+0x5a>
		return -E_NOT_SUPP;
  801388:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138d:	eb d3                	jmp    801362 <read+0x5a>

0080138f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	57                   	push   %edi
  801393:	56                   	push   %esi
  801394:	53                   	push   %ebx
  801395:	83 ec 0c             	sub    $0xc,%esp
  801398:	8b 7d 08             	mov    0x8(%ebp),%edi
  80139b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a3:	39 f3                	cmp    %esi,%ebx
  8013a5:	73 23                	jae    8013ca <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	89 f0                	mov    %esi,%eax
  8013ac:	29 d8                	sub    %ebx,%eax
  8013ae:	50                   	push   %eax
  8013af:	89 d8                	mov    %ebx,%eax
  8013b1:	03 45 0c             	add    0xc(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	57                   	push   %edi
  8013b6:	e8 4d ff ff ff       	call   801308 <read>
		if (m < 0)
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 06                	js     8013c8 <readn+0x39>
			return m;
		if (m == 0)
  8013c2:	74 06                	je     8013ca <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013c4:	01 c3                	add    %eax,%ebx
  8013c6:	eb db                	jmp    8013a3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013ca:	89 d8                	mov    %ebx,%eax
  8013cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cf:	5b                   	pop    %ebx
  8013d0:	5e                   	pop    %esi
  8013d1:	5f                   	pop    %edi
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 1c             	sub    $0x1c,%esp
  8013db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e1:	50                   	push   %eax
  8013e2:	53                   	push   %ebx
  8013e3:	e8 b0 fc ff ff       	call   801098 <fd_lookup>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 3a                	js     801429 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ef:	83 ec 08             	sub    $0x8,%esp
  8013f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f9:	ff 30                	pushl  (%eax)
  8013fb:	e8 e8 fc ff ff       	call   8010e8 <dev_lookup>
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 22                	js     801429 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140e:	74 1e                	je     80142e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801413:	8b 52 0c             	mov    0xc(%edx),%edx
  801416:	85 d2                	test   %edx,%edx
  801418:	74 35                	je     80144f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	ff 75 10             	pushl  0x10(%ebp)
  801420:	ff 75 0c             	pushl  0xc(%ebp)
  801423:	50                   	push   %eax
  801424:	ff d2                	call   *%edx
  801426:	83 c4 10             	add    $0x10,%esp
}
  801429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80142e:	a1 08 40 80 00       	mov    0x804008,%eax
  801433:	8b 40 48             	mov    0x48(%eax),%eax
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	53                   	push   %ebx
  80143a:	50                   	push   %eax
  80143b:	68 f1 29 80 00       	push   $0x8029f1
  801440:	e8 94 ed ff ff       	call   8001d9 <cprintf>
		return -E_INVAL;
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144d:	eb da                	jmp    801429 <write+0x55>
		return -E_NOT_SUPP;
  80144f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801454:	eb d3                	jmp    801429 <write+0x55>

00801456 <seek>:

int
seek(int fdnum, off_t offset)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	ff 75 08             	pushl  0x8(%ebp)
  801463:	e8 30 fc ff ff       	call   801098 <fd_lookup>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 0e                	js     80147d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80146f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801475:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	53                   	push   %ebx
  801483:	83 ec 1c             	sub    $0x1c,%esp
  801486:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801489:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148c:	50                   	push   %eax
  80148d:	53                   	push   %ebx
  80148e:	e8 05 fc ff ff       	call   801098 <fd_lookup>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	78 37                	js     8014d1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a4:	ff 30                	pushl  (%eax)
  8014a6:	e8 3d fc ff ff       	call   8010e8 <dev_lookup>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 1f                	js     8014d1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b9:	74 1b                	je     8014d6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014be:	8b 52 18             	mov    0x18(%edx),%edx
  8014c1:	85 d2                	test   %edx,%edx
  8014c3:	74 32                	je     8014f7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	ff 75 0c             	pushl  0xc(%ebp)
  8014cb:	50                   	push   %eax
  8014cc:	ff d2                	call   *%edx
  8014ce:	83 c4 10             	add    $0x10,%esp
}
  8014d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014d6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014db:	8b 40 48             	mov    0x48(%eax),%eax
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	53                   	push   %ebx
  8014e2:	50                   	push   %eax
  8014e3:	68 b4 29 80 00       	push   $0x8029b4
  8014e8:	e8 ec ec ff ff       	call   8001d9 <cprintf>
		return -E_INVAL;
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f5:	eb da                	jmp    8014d1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fc:	eb d3                	jmp    8014d1 <ftruncate+0x52>

008014fe <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	53                   	push   %ebx
  801502:	83 ec 1c             	sub    $0x1c,%esp
  801505:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801508:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150b:	50                   	push   %eax
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 84 fb ff ff       	call   801098 <fd_lookup>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 4b                	js     801566 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	ff 30                	pushl  (%eax)
  801527:	e8 bc fb ff ff       	call   8010e8 <dev_lookup>
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 33                	js     801566 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801536:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80153a:	74 2f                	je     80156b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80153c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80153f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801546:	00 00 00 
	stat->st_isdir = 0;
  801549:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801550:	00 00 00 
	stat->st_dev = dev;
  801553:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	53                   	push   %ebx
  80155d:	ff 75 f0             	pushl  -0x10(%ebp)
  801560:	ff 50 14             	call   *0x14(%eax)
  801563:	83 c4 10             	add    $0x10,%esp
}
  801566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801569:	c9                   	leave  
  80156a:	c3                   	ret    
		return -E_NOT_SUPP;
  80156b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801570:	eb f4                	jmp    801566 <fstat+0x68>

00801572 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	6a 00                	push   $0x0
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	e8 22 02 00 00       	call   8017a6 <open>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 1b                	js     8015a8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80158d:	83 ec 08             	sub    $0x8,%esp
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	50                   	push   %eax
  801594:	e8 65 ff ff ff       	call   8014fe <fstat>
  801599:	89 c6                	mov    %eax,%esi
	close(fd);
  80159b:	89 1c 24             	mov    %ebx,(%esp)
  80159e:	e8 27 fc ff ff       	call   8011ca <close>
	return r;
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	89 f3                	mov    %esi,%ebx
}
  8015a8:	89 d8                	mov    %ebx,%eax
  8015aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	56                   	push   %esi
  8015b5:	53                   	push   %ebx
  8015b6:	89 c6                	mov    %eax,%esi
  8015b8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ba:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c1:	74 27                	je     8015ea <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c3:	6a 07                	push   $0x7
  8015c5:	68 00 50 80 00       	push   $0x805000
  8015ca:	56                   	push   %esi
  8015cb:	ff 35 00 40 80 00    	pushl  0x804000
  8015d1:	e8 69 0c 00 00       	call   80223f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015d6:	83 c4 0c             	add    $0xc,%esp
  8015d9:	6a 00                	push   $0x0
  8015db:	53                   	push   %ebx
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 f3 0b 00 00       	call   8021d6 <ipc_recv>
}
  8015e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015ea:	83 ec 0c             	sub    $0xc,%esp
  8015ed:	6a 01                	push   $0x1
  8015ef:	e8 a3 0c 00 00       	call   802297 <ipc_find_env>
  8015f4:	a3 00 40 80 00       	mov    %eax,0x804000
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	eb c5                	jmp    8015c3 <fsipc+0x12>

008015fe <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8b 40 0c             	mov    0xc(%eax),%eax
  80160a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801617:	ba 00 00 00 00       	mov    $0x0,%edx
  80161c:	b8 02 00 00 00       	mov    $0x2,%eax
  801621:	e8 8b ff ff ff       	call   8015b1 <fsipc>
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <devfile_flush>:
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8b 40 0c             	mov    0xc(%eax),%eax
  801634:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	b8 06 00 00 00       	mov    $0x6,%eax
  801643:	e8 69 ff ff ff       	call   8015b1 <fsipc>
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <devfile_stat>:
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8b 40 0c             	mov    0xc(%eax),%eax
  80165a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165f:	ba 00 00 00 00       	mov    $0x0,%edx
  801664:	b8 05 00 00 00       	mov    $0x5,%eax
  801669:	e8 43 ff ff ff       	call   8015b1 <fsipc>
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 2c                	js     80169e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	68 00 50 80 00       	push   $0x805000
  80167a:	53                   	push   %ebx
  80167b:	e8 b8 f2 ff ff       	call   800938 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801680:	a1 80 50 80 00       	mov    0x805080,%eax
  801685:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168b:	a1 84 50 80 00       	mov    0x805084,%eax
  801690:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <devfile_write>:
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016b8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016be:	53                   	push   %ebx
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	68 08 50 80 00       	push   $0x805008
  8016c7:	e8 5c f4 ff ff       	call   800b28 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d1:	b8 04 00 00 00       	mov    $0x4,%eax
  8016d6:	e8 d6 fe ff ff       	call   8015b1 <fsipc>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	78 0b                	js     8016ed <devfile_write+0x4a>
	assert(r <= n);
  8016e2:	39 d8                	cmp    %ebx,%eax
  8016e4:	77 0c                	ja     8016f2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016e6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016eb:	7f 1e                	jg     80170b <devfile_write+0x68>
}
  8016ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    
	assert(r <= n);
  8016f2:	68 24 2a 80 00       	push   $0x802a24
  8016f7:	68 2b 2a 80 00       	push   $0x802a2b
  8016fc:	68 98 00 00 00       	push   $0x98
  801701:	68 40 2a 80 00       	push   $0x802a40
  801706:	e8 6a 0a 00 00       	call   802175 <_panic>
	assert(r <= PGSIZE);
  80170b:	68 4b 2a 80 00       	push   $0x802a4b
  801710:	68 2b 2a 80 00       	push   $0x802a2b
  801715:	68 99 00 00 00       	push   $0x99
  80171a:	68 40 2a 80 00       	push   $0x802a40
  80171f:	e8 51 0a 00 00       	call   802175 <_panic>

00801724 <devfile_read>:
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
  801729:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8b 40 0c             	mov    0xc(%eax),%eax
  801732:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801737:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80173d:	ba 00 00 00 00       	mov    $0x0,%edx
  801742:	b8 03 00 00 00       	mov    $0x3,%eax
  801747:	e8 65 fe ff ff       	call   8015b1 <fsipc>
  80174c:	89 c3                	mov    %eax,%ebx
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 1f                	js     801771 <devfile_read+0x4d>
	assert(r <= n);
  801752:	39 f0                	cmp    %esi,%eax
  801754:	77 24                	ja     80177a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801756:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80175b:	7f 33                	jg     801790 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	50                   	push   %eax
  801761:	68 00 50 80 00       	push   $0x805000
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	e8 58 f3 ff ff       	call   800ac6 <memmove>
	return r;
  80176e:	83 c4 10             	add    $0x10,%esp
}
  801771:	89 d8                	mov    %ebx,%eax
  801773:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801776:	5b                   	pop    %ebx
  801777:	5e                   	pop    %esi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    
	assert(r <= n);
  80177a:	68 24 2a 80 00       	push   $0x802a24
  80177f:	68 2b 2a 80 00       	push   $0x802a2b
  801784:	6a 7c                	push   $0x7c
  801786:	68 40 2a 80 00       	push   $0x802a40
  80178b:	e8 e5 09 00 00       	call   802175 <_panic>
	assert(r <= PGSIZE);
  801790:	68 4b 2a 80 00       	push   $0x802a4b
  801795:	68 2b 2a 80 00       	push   $0x802a2b
  80179a:	6a 7d                	push   $0x7d
  80179c:	68 40 2a 80 00       	push   $0x802a40
  8017a1:	e8 cf 09 00 00       	call   802175 <_panic>

008017a6 <open>:
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	56                   	push   %esi
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 1c             	sub    $0x1c,%esp
  8017ae:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017b1:	56                   	push   %esi
  8017b2:	e8 48 f1 ff ff       	call   8008ff <strlen>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017bf:	7f 6c                	jg     80182d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017c1:	83 ec 0c             	sub    $0xc,%esp
  8017c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c7:	50                   	push   %eax
  8017c8:	e8 79 f8 ff ff       	call   801046 <fd_alloc>
  8017cd:	89 c3                	mov    %eax,%ebx
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 3c                	js     801812 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	56                   	push   %esi
  8017da:	68 00 50 80 00       	push   $0x805000
  8017df:	e8 54 f1 ff ff       	call   800938 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f4:	e8 b8 fd ff ff       	call   8015b1 <fsipc>
  8017f9:	89 c3                	mov    %eax,%ebx
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 19                	js     80181b <open+0x75>
	return fd2num(fd);
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	ff 75 f4             	pushl  -0xc(%ebp)
  801808:	e8 12 f8 ff ff       	call   80101f <fd2num>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	83 c4 10             	add    $0x10,%esp
}
  801812:	89 d8                	mov    %ebx,%eax
  801814:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    
		fd_close(fd, 0);
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	6a 00                	push   $0x0
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	e8 1b f9 ff ff       	call   801143 <fd_close>
		return r;
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	eb e5                	jmp    801812 <open+0x6c>
		return -E_BAD_PATH;
  80182d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801832:	eb de                	jmp    801812 <open+0x6c>

00801834 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80183a:	ba 00 00 00 00       	mov    $0x0,%edx
  80183f:	b8 08 00 00 00       	mov    $0x8,%eax
  801844:	e8 68 fd ff ff       	call   8015b1 <fsipc>
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801851:	68 57 2a 80 00       	push   $0x802a57
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	e8 da f0 ff ff       	call   800938 <strcpy>
	return 0;
}
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <devsock_close>:
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	53                   	push   %ebx
  801869:	83 ec 10             	sub    $0x10,%esp
  80186c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80186f:	53                   	push   %ebx
  801870:	e8 61 0a 00 00       	call   8022d6 <pageref>
  801875:	83 c4 10             	add    $0x10,%esp
		return 0;
  801878:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80187d:	83 f8 01             	cmp    $0x1,%eax
  801880:	74 07                	je     801889 <devsock_close+0x24>
}
  801882:	89 d0                	mov    %edx,%eax
  801884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801887:	c9                   	leave  
  801888:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	ff 73 0c             	pushl  0xc(%ebx)
  80188f:	e8 b9 02 00 00       	call   801b4d <nsipc_close>
  801894:	89 c2                	mov    %eax,%edx
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	eb e7                	jmp    801882 <devsock_close+0x1d>

0080189b <devsock_write>:
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 10             	pushl  0x10(%ebp)
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	ff 70 0c             	pushl  0xc(%eax)
  8018af:	e8 76 03 00 00       	call   801c2a <nsipc_send>
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <devsock_read>:
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 10             	pushl  0x10(%ebp)
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	ff 70 0c             	pushl  0xc(%eax)
  8018ca:	e8 ef 02 00 00       	call   801bbe <nsipc_recv>
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <fd2sockid>:
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	e8 b7 f7 ff ff       	call   801098 <fd_lookup>
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 10                	js     8018f8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018eb:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018f1:	39 08                	cmp    %ecx,(%eax)
  8018f3:	75 05                	jne    8018fa <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018f5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    
		return -E_NOT_SUPP;
  8018fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ff:	eb f7                	jmp    8018f8 <fd2sockid+0x27>

00801901 <alloc_sockfd>:
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	83 ec 1c             	sub    $0x1c,%esp
  801909:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	e8 32 f7 ff ff       	call   801046 <fd_alloc>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 43                	js     801960 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	68 07 04 00 00       	push   $0x407
  801925:	ff 75 f4             	pushl  -0xc(%ebp)
  801928:	6a 00                	push   $0x0
  80192a:	e8 fb f3 ff ff       	call   800d2a <sys_page_alloc>
  80192f:	89 c3                	mov    %eax,%ebx
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	78 28                	js     801960 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801941:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80194d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	50                   	push   %eax
  801954:	e8 c6 f6 ff ff       	call   80101f <fd2num>
  801959:	89 c3                	mov    %eax,%ebx
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	eb 0c                	jmp    80196c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	56                   	push   %esi
  801964:	e8 e4 01 00 00       	call   801b4d <nsipc_close>
		return r;
  801969:	83 c4 10             	add    $0x10,%esp
}
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <accept>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	e8 4e ff ff ff       	call   8018d1 <fd2sockid>
  801983:	85 c0                	test   %eax,%eax
  801985:	78 1b                	js     8019a2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	ff 75 10             	pushl  0x10(%ebp)
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	50                   	push   %eax
  801991:	e8 0e 01 00 00       	call   801aa4 <nsipc_accept>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 05                	js     8019a2 <accept+0x2d>
	return alloc_sockfd(r);
  80199d:	e8 5f ff ff ff       	call   801901 <alloc_sockfd>
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <bind>:
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	e8 1f ff ff ff       	call   8018d1 <fd2sockid>
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 12                	js     8019c8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	ff 75 10             	pushl  0x10(%ebp)
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	50                   	push   %eax
  8019c0:	e8 31 01 00 00       	call   801af6 <nsipc_bind>
  8019c5:	83 c4 10             	add    $0x10,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <shutdown>:
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	e8 f9 fe ff ff       	call   8018d1 <fd2sockid>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 0f                	js     8019eb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	50                   	push   %eax
  8019e3:	e8 43 01 00 00       	call   801b2b <nsipc_shutdown>
  8019e8:	83 c4 10             	add    $0x10,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <connect>:
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	e8 d6 fe ff ff       	call   8018d1 <fd2sockid>
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 12                	js     801a11 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	ff 75 10             	pushl  0x10(%ebp)
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	50                   	push   %eax
  801a09:	e8 59 01 00 00       	call   801b67 <nsipc_connect>
  801a0e:	83 c4 10             	add    $0x10,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <listen>:
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	e8 b0 fe ff ff       	call   8018d1 <fd2sockid>
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 0f                	js     801a34 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	e8 6b 01 00 00       	call   801b9c <nsipc_listen>
  801a31:	83 c4 10             	add    $0x10,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a3c:	ff 75 10             	pushl  0x10(%ebp)
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	e8 3e 02 00 00       	call   801c88 <nsipc_socket>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 05                	js     801a56 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a51:	e8 ab fe ff ff       	call   801901 <alloc_sockfd>
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a61:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a68:	74 26                	je     801a90 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a6a:	6a 07                	push   $0x7
  801a6c:	68 00 60 80 00       	push   $0x806000
  801a71:	53                   	push   %ebx
  801a72:	ff 35 04 40 80 00    	pushl  0x804004
  801a78:	e8 c2 07 00 00       	call   80223f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a7d:	83 c4 0c             	add    $0xc,%esp
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	e8 4b 07 00 00       	call   8021d6 <ipc_recv>
}
  801a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a90:	83 ec 0c             	sub    $0xc,%esp
  801a93:	6a 02                	push   $0x2
  801a95:	e8 fd 07 00 00       	call   802297 <ipc_find_env>
  801a9a:	a3 04 40 80 00       	mov    %eax,0x804004
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	eb c6                	jmp    801a6a <nsipc+0x12>

00801aa4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab4:	8b 06                	mov    (%esi),%eax
  801ab6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801abb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac0:	e8 93 ff ff ff       	call   801a58 <nsipc>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	79 09                	jns    801ad4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801acb:	89 d8                	mov    %ebx,%eax
  801acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad0:	5b                   	pop    %ebx
  801ad1:	5e                   	pop    %esi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	ff 35 10 60 80 00    	pushl  0x806010
  801add:	68 00 60 80 00       	push   $0x806000
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	e8 dc ef ff ff       	call   800ac6 <memmove>
		*addrlen = ret->ret_addrlen;
  801aea:	a1 10 60 80 00       	mov    0x806010,%eax
  801aef:	89 06                	mov    %eax,(%esi)
  801af1:	83 c4 10             	add    $0x10,%esp
	return r;
  801af4:	eb d5                	jmp    801acb <nsipc_accept+0x27>

00801af6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	53                   	push   %ebx
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b08:	53                   	push   %ebx
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	68 04 60 80 00       	push   $0x806004
  801b11:	e8 b0 ef ff ff       	call   800ac6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b16:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1c:	b8 02 00 00 00       	mov    $0x2,%eax
  801b21:	e8 32 ff ff ff       	call   801a58 <nsipc>
}
  801b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b41:	b8 03 00 00 00       	mov    $0x3,%eax
  801b46:	e8 0d ff ff ff       	call   801a58 <nsipc>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <nsipc_close>:

int
nsipc_close(int s)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b5b:	b8 04 00 00 00       	mov    $0x4,%eax
  801b60:	e8 f3 fe ff ff       	call   801a58 <nsipc>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b79:	53                   	push   %ebx
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	68 04 60 80 00       	push   $0x806004
  801b82:	e8 3f ef ff ff       	call   800ac6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b87:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b8d:	b8 05 00 00 00       	mov    $0x5,%eax
  801b92:	e8 c1 fe ff ff       	call   801a58 <nsipc>
}
  801b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb2:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb7:	e8 9c fe ff ff       	call   801a58 <nsipc>
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	56                   	push   %esi
  801bc2:	53                   	push   %ebx
  801bc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bdc:	b8 07 00 00 00       	mov    $0x7,%eax
  801be1:	e8 72 fe ff ff       	call   801a58 <nsipc>
  801be6:	89 c3                	mov    %eax,%ebx
  801be8:	85 c0                	test   %eax,%eax
  801bea:	78 1f                	js     801c0b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bec:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf1:	7f 21                	jg     801c14 <nsipc_recv+0x56>
  801bf3:	39 c6                	cmp    %eax,%esi
  801bf5:	7c 1d                	jl     801c14 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	50                   	push   %eax
  801bfb:	68 00 60 80 00       	push   $0x806000
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	e8 be ee ff ff       	call   800ac6 <memmove>
  801c08:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c14:	68 63 2a 80 00       	push   $0x802a63
  801c19:	68 2b 2a 80 00       	push   $0x802a2b
  801c1e:	6a 62                	push   $0x62
  801c20:	68 78 2a 80 00       	push   $0x802a78
  801c25:	e8 4b 05 00 00       	call   802175 <_panic>

00801c2a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	53                   	push   %ebx
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c42:	7f 2e                	jg     801c72 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	53                   	push   %ebx
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	68 0c 60 80 00       	push   $0x80600c
  801c50:	e8 71 ee ff ff       	call   800ac6 <memmove>
	nsipcbuf.send.req_size = size;
  801c55:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c63:	b8 08 00 00 00       	mov    $0x8,%eax
  801c68:	e8 eb fd ff ff       	call   801a58 <nsipc>
}
  801c6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    
	assert(size < 1600);
  801c72:	68 84 2a 80 00       	push   $0x802a84
  801c77:	68 2b 2a 80 00       	push   $0x802a2b
  801c7c:	6a 6d                	push   $0x6d
  801c7e:	68 78 2a 80 00       	push   $0x802a78
  801c83:	e8 ed 04 00 00       	call   802175 <_panic>

00801c88 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c99:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ca6:	b8 09 00 00 00       	mov    $0x9,%eax
  801cab:	e8 a8 fd ff ff       	call   801a58 <nsipc>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	56                   	push   %esi
  801cb6:	53                   	push   %ebx
  801cb7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cba:	83 ec 0c             	sub    $0xc,%esp
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	e8 6a f3 ff ff       	call   80102f <fd2data>
  801cc5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cc7:	83 c4 08             	add    $0x8,%esp
  801cca:	68 90 2a 80 00       	push   $0x802a90
  801ccf:	53                   	push   %ebx
  801cd0:	e8 63 ec ff ff       	call   800938 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cd5:	8b 46 04             	mov    0x4(%esi),%eax
  801cd8:	2b 06                	sub    (%esi),%eax
  801cda:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce7:	00 00 00 
	stat->st_dev = &devpipe;
  801cea:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf1:	30 80 00 
	return 0;
}
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfc:	5b                   	pop    %ebx
  801cfd:	5e                   	pop    %esi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	53                   	push   %ebx
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d0a:	53                   	push   %ebx
  801d0b:	6a 00                	push   $0x0
  801d0d:	e8 9d f0 ff ff       	call   800daf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d12:	89 1c 24             	mov    %ebx,(%esp)
  801d15:	e8 15 f3 ff ff       	call   80102f <fd2data>
  801d1a:	83 c4 08             	add    $0x8,%esp
  801d1d:	50                   	push   %eax
  801d1e:	6a 00                	push   $0x0
  801d20:	e8 8a f0 ff ff       	call   800daf <sys_page_unmap>
}
  801d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <_pipeisclosed>:
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	57                   	push   %edi
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 1c             	sub    $0x1c,%esp
  801d33:	89 c7                	mov    %eax,%edi
  801d35:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d37:	a1 08 40 80 00       	mov    0x804008,%eax
  801d3c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	57                   	push   %edi
  801d43:	e8 8e 05 00 00       	call   8022d6 <pageref>
  801d48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4b:	89 34 24             	mov    %esi,(%esp)
  801d4e:	e8 83 05 00 00       	call   8022d6 <pageref>
		nn = thisenv->env_runs;
  801d53:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d59:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	39 cb                	cmp    %ecx,%ebx
  801d61:	74 1b                	je     801d7e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d63:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d66:	75 cf                	jne    801d37 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d68:	8b 42 58             	mov    0x58(%edx),%eax
  801d6b:	6a 01                	push   $0x1
  801d6d:	50                   	push   %eax
  801d6e:	53                   	push   %ebx
  801d6f:	68 97 2a 80 00       	push   $0x802a97
  801d74:	e8 60 e4 ff ff       	call   8001d9 <cprintf>
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	eb b9                	jmp    801d37 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d81:	0f 94 c0             	sete   %al
  801d84:	0f b6 c0             	movzbl %al,%eax
}
  801d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8a:	5b                   	pop    %ebx
  801d8b:	5e                   	pop    %esi
  801d8c:	5f                   	pop    %edi
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    

00801d8f <devpipe_write>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	57                   	push   %edi
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 28             	sub    $0x28,%esp
  801d98:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d9b:	56                   	push   %esi
  801d9c:	e8 8e f2 ff ff       	call   80102f <fd2data>
  801da1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dab:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dae:	74 4f                	je     801dff <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db0:	8b 43 04             	mov    0x4(%ebx),%eax
  801db3:	8b 0b                	mov    (%ebx),%ecx
  801db5:	8d 51 20             	lea    0x20(%ecx),%edx
  801db8:	39 d0                	cmp    %edx,%eax
  801dba:	72 14                	jb     801dd0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dbc:	89 da                	mov    %ebx,%edx
  801dbe:	89 f0                	mov    %esi,%eax
  801dc0:	e8 65 ff ff ff       	call   801d2a <_pipeisclosed>
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	75 3b                	jne    801e04 <devpipe_write+0x75>
			sys_yield();
  801dc9:	e8 3d ef ff ff       	call   800d0b <sys_yield>
  801dce:	eb e0                	jmp    801db0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dd7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dda:	89 c2                	mov    %eax,%edx
  801ddc:	c1 fa 1f             	sar    $0x1f,%edx
  801ddf:	89 d1                	mov    %edx,%ecx
  801de1:	c1 e9 1b             	shr    $0x1b,%ecx
  801de4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801de7:	83 e2 1f             	and    $0x1f,%edx
  801dea:	29 ca                	sub    %ecx,%edx
  801dec:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801df4:	83 c0 01             	add    $0x1,%eax
  801df7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dfa:	83 c7 01             	add    $0x1,%edi
  801dfd:	eb ac                	jmp    801dab <devpipe_write+0x1c>
	return i;
  801dff:	8b 45 10             	mov    0x10(%ebp),%eax
  801e02:	eb 05                	jmp    801e09 <devpipe_write+0x7a>
				return 0;
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    

00801e11 <devpipe_read>:
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	57                   	push   %edi
  801e15:	56                   	push   %esi
  801e16:	53                   	push   %ebx
  801e17:	83 ec 18             	sub    $0x18,%esp
  801e1a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e1d:	57                   	push   %edi
  801e1e:	e8 0c f2 ff ff       	call   80102f <fd2data>
  801e23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	be 00 00 00 00       	mov    $0x0,%esi
  801e2d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e30:	75 14                	jne    801e46 <devpipe_read+0x35>
	return i;
  801e32:	8b 45 10             	mov    0x10(%ebp),%eax
  801e35:	eb 02                	jmp    801e39 <devpipe_read+0x28>
				return i;
  801e37:	89 f0                	mov    %esi,%eax
}
  801e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
			sys_yield();
  801e41:	e8 c5 ee ff ff       	call   800d0b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e46:	8b 03                	mov    (%ebx),%eax
  801e48:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e4b:	75 18                	jne    801e65 <devpipe_read+0x54>
			if (i > 0)
  801e4d:	85 f6                	test   %esi,%esi
  801e4f:	75 e6                	jne    801e37 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e51:	89 da                	mov    %ebx,%edx
  801e53:	89 f8                	mov    %edi,%eax
  801e55:	e8 d0 fe ff ff       	call   801d2a <_pipeisclosed>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	74 e3                	je     801e41 <devpipe_read+0x30>
				return 0;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	eb d4                	jmp    801e39 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e65:	99                   	cltd   
  801e66:	c1 ea 1b             	shr    $0x1b,%edx
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	83 e0 1f             	and    $0x1f,%eax
  801e6e:	29 d0                	sub    %edx,%eax
  801e70:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e78:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e7b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e7e:	83 c6 01             	add    $0x1,%esi
  801e81:	eb aa                	jmp    801e2d <devpipe_read+0x1c>

00801e83 <pipe>:
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8e:	50                   	push   %eax
  801e8f:	e8 b2 f1 ff ff       	call   801046 <fd_alloc>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	0f 88 23 01 00 00    	js     801fc4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	68 07 04 00 00       	push   $0x407
  801ea9:	ff 75 f4             	pushl  -0xc(%ebp)
  801eac:	6a 00                	push   $0x0
  801eae:	e8 77 ee ff ff       	call   800d2a <sys_page_alloc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 88 04 01 00 00    	js     801fc4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec6:	50                   	push   %eax
  801ec7:	e8 7a f1 ff ff       	call   801046 <fd_alloc>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	0f 88 db 00 00 00    	js     801fb4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	68 07 04 00 00       	push   $0x407
  801ee1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee4:	6a 00                	push   $0x0
  801ee6:	e8 3f ee ff ff       	call   800d2a <sys_page_alloc>
  801eeb:	89 c3                	mov    %eax,%ebx
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	0f 88 bc 00 00 00    	js     801fb4 <pipe+0x131>
	va = fd2data(fd0);
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	e8 2c f1 ff ff       	call   80102f <fd2data>
  801f03:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f05:	83 c4 0c             	add    $0xc,%esp
  801f08:	68 07 04 00 00       	push   $0x407
  801f0d:	50                   	push   %eax
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 15 ee ff ff       	call   800d2a <sys_page_alloc>
  801f15:	89 c3                	mov    %eax,%ebx
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	0f 88 82 00 00 00    	js     801fa4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	ff 75 f0             	pushl  -0x10(%ebp)
  801f28:	e8 02 f1 ff ff       	call   80102f <fd2data>
  801f2d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f34:	50                   	push   %eax
  801f35:	6a 00                	push   $0x0
  801f37:	56                   	push   %esi
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 2e ee ff ff       	call   800d6d <sys_page_map>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 20             	add    $0x20,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 4e                	js     801f96 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f48:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f50:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f55:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f5f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f64:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f71:	e8 a9 f0 ff ff       	call   80101f <fd2num>
  801f76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f79:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f7b:	83 c4 04             	add    $0x4,%esp
  801f7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f81:	e8 99 f0 ff ff       	call   80101f <fd2num>
  801f86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f89:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f94:	eb 2e                	jmp    801fc4 <pipe+0x141>
	sys_page_unmap(0, va);
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	56                   	push   %esi
  801f9a:	6a 00                	push   $0x0
  801f9c:	e8 0e ee ff ff       	call   800daf <sys_page_unmap>
  801fa1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fa4:	83 ec 08             	sub    $0x8,%esp
  801fa7:	ff 75 f0             	pushl  -0x10(%ebp)
  801faa:	6a 00                	push   $0x0
  801fac:	e8 fe ed ff ff       	call   800daf <sys_page_unmap>
  801fb1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fb4:	83 ec 08             	sub    $0x8,%esp
  801fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 ee ed ff ff       	call   800daf <sys_page_unmap>
  801fc1:	83 c4 10             	add    $0x10,%esp
}
  801fc4:	89 d8                	mov    %ebx,%eax
  801fc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    

00801fcd <pipeisclosed>:
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd6:	50                   	push   %eax
  801fd7:	ff 75 08             	pushl  0x8(%ebp)
  801fda:	e8 b9 f0 ff ff       	call   801098 <fd_lookup>
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 18                	js     801ffe <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fec:	e8 3e f0 ff ff       	call   80102f <fd2data>
	return _pipeisclosed(fd, p);
  801ff1:	89 c2                	mov    %eax,%edx
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	e8 2f fd ff ff       	call   801d2a <_pipeisclosed>
  801ffb:	83 c4 10             	add    $0x10,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	c3                   	ret    

00802006 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80200c:	68 af 2a 80 00       	push   $0x802aaf
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	e8 1f e9 ff ff       	call   800938 <strcpy>
	return 0;
}
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <devcons_write>:
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	57                   	push   %edi
  802024:	56                   	push   %esi
  802025:	53                   	push   %ebx
  802026:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80202c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802031:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802037:	3b 75 10             	cmp    0x10(%ebp),%esi
  80203a:	73 31                	jae    80206d <devcons_write+0x4d>
		m = n - tot;
  80203c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80203f:	29 f3                	sub    %esi,%ebx
  802041:	83 fb 7f             	cmp    $0x7f,%ebx
  802044:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802049:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	53                   	push   %ebx
  802050:	89 f0                	mov    %esi,%eax
  802052:	03 45 0c             	add    0xc(%ebp),%eax
  802055:	50                   	push   %eax
  802056:	57                   	push   %edi
  802057:	e8 6a ea ff ff       	call   800ac6 <memmove>
		sys_cputs(buf, m);
  80205c:	83 c4 08             	add    $0x8,%esp
  80205f:	53                   	push   %ebx
  802060:	57                   	push   %edi
  802061:	e8 08 ec ff ff       	call   800c6e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802066:	01 de                	add    %ebx,%esi
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	eb ca                	jmp    802037 <devcons_write+0x17>
}
  80206d:	89 f0                	mov    %esi,%eax
  80206f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802072:	5b                   	pop    %ebx
  802073:	5e                   	pop    %esi
  802074:	5f                   	pop    %edi
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <devcons_read>:
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802082:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802086:	74 21                	je     8020a9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802088:	e8 ff eb ff ff       	call   800c8c <sys_cgetc>
  80208d:	85 c0                	test   %eax,%eax
  80208f:	75 07                	jne    802098 <devcons_read+0x21>
		sys_yield();
  802091:	e8 75 ec ff ff       	call   800d0b <sys_yield>
  802096:	eb f0                	jmp    802088 <devcons_read+0x11>
	if (c < 0)
  802098:	78 0f                	js     8020a9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80209a:	83 f8 04             	cmp    $0x4,%eax
  80209d:	74 0c                	je     8020ab <devcons_read+0x34>
	*(char*)vbuf = c;
  80209f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a2:	88 02                	mov    %al,(%edx)
	return 1;
  8020a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    
		return 0;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	eb f7                	jmp    8020a9 <devcons_read+0x32>

008020b2 <cputchar>:
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020be:	6a 01                	push   $0x1
  8020c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c3:	50                   	push   %eax
  8020c4:	e8 a5 eb ff ff       	call   800c6e <sys_cputs>
}
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <getchar>:
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d4:	6a 01                	push   $0x1
  8020d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d9:	50                   	push   %eax
  8020da:	6a 00                	push   $0x0
  8020dc:	e8 27 f2 ff ff       	call   801308 <read>
	if (r < 0)
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	78 06                	js     8020ee <getchar+0x20>
	if (r < 1)
  8020e8:	74 06                	je     8020f0 <getchar+0x22>
	return c;
  8020ea:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    
		return -E_EOF;
  8020f0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020f5:	eb f7                	jmp    8020ee <getchar+0x20>

008020f7 <iscons>:
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802100:	50                   	push   %eax
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	e8 8f ef ff ff       	call   801098 <fd_lookup>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 11                	js     802121 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802119:	39 10                	cmp    %edx,(%eax)
  80211b:	0f 94 c0             	sete   %al
  80211e:	0f b6 c0             	movzbl %al,%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <opencons>:
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802129:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212c:	50                   	push   %eax
  80212d:	e8 14 ef ff ff       	call   801046 <fd_alloc>
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	85 c0                	test   %eax,%eax
  802137:	78 3a                	js     802173 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	68 07 04 00 00       	push   $0x407
  802141:	ff 75 f4             	pushl  -0xc(%ebp)
  802144:	6a 00                	push   $0x0
  802146:	e8 df eb ff ff       	call   800d2a <sys_page_alloc>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 21                	js     802173 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	50                   	push   %eax
  80216b:	e8 af ee ff ff       	call   80101f <fd2num>
  802170:	83 c4 10             	add    $0x10,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	56                   	push   %esi
  802179:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80217a:	a1 08 40 80 00       	mov    0x804008,%eax
  80217f:	8b 40 48             	mov    0x48(%eax),%eax
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	68 e0 2a 80 00       	push   $0x802ae0
  80218a:	50                   	push   %eax
  80218b:	68 d8 25 80 00       	push   $0x8025d8
  802190:	e8 44 e0 ff ff       	call   8001d9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802195:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802198:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80219e:	e8 49 eb ff ff       	call   800cec <sys_getenvid>
  8021a3:	83 c4 04             	add    $0x4,%esp
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	56                   	push   %esi
  8021ad:	50                   	push   %eax
  8021ae:	68 bc 2a 80 00       	push   $0x802abc
  8021b3:	e8 21 e0 ff ff       	call   8001d9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021b8:	83 c4 18             	add    $0x18,%esp
  8021bb:	53                   	push   %ebx
  8021bc:	ff 75 10             	pushl  0x10(%ebp)
  8021bf:	e8 c4 df ff ff       	call   800188 <vcprintf>
	cprintf("\n");
  8021c4:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021cb:	e8 09 e0 ff ff       	call   8001d9 <cprintf>
  8021d0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d3:	cc                   	int3   
  8021d4:	eb fd                	jmp    8021d3 <_panic+0x5e>

008021d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	56                   	push   %esi
  8021da:	53                   	push   %ebx
  8021db:	8b 75 08             	mov    0x8(%ebp),%esi
  8021de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021e4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021e6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021eb:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	50                   	push   %eax
  8021f2:	e8 e3 ec ff ff       	call   800eda <sys_ipc_recv>
	if(ret < 0){
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 2b                	js     802229 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021fe:	85 f6                	test   %esi,%esi
  802200:	74 0a                	je     80220c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802202:	a1 08 40 80 00       	mov    0x804008,%eax
  802207:	8b 40 78             	mov    0x78(%eax),%eax
  80220a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80220c:	85 db                	test   %ebx,%ebx
  80220e:	74 0a                	je     80221a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802210:	a1 08 40 80 00       	mov    0x804008,%eax
  802215:	8b 40 7c             	mov    0x7c(%eax),%eax
  802218:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80221a:	a1 08 40 80 00       	mov    0x804008,%eax
  80221f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802222:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
		if(from_env_store)
  802229:	85 f6                	test   %esi,%esi
  80222b:	74 06                	je     802233 <ipc_recv+0x5d>
			*from_env_store = 0;
  80222d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802233:	85 db                	test   %ebx,%ebx
  802235:	74 eb                	je     802222 <ipc_recv+0x4c>
			*perm_store = 0;
  802237:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223d:	eb e3                	jmp    802222 <ipc_recv+0x4c>

0080223f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	57                   	push   %edi
  802243:	56                   	push   %esi
  802244:	53                   	push   %ebx
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	8b 7d 08             	mov    0x8(%ebp),%edi
  80224b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802251:	85 db                	test   %ebx,%ebx
  802253:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802258:	0f 44 d8             	cmove  %eax,%ebx
  80225b:	eb 05                	jmp    802262 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80225d:	e8 a9 ea ff ff       	call   800d0b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802262:	ff 75 14             	pushl  0x14(%ebp)
  802265:	53                   	push   %ebx
  802266:	56                   	push   %esi
  802267:	57                   	push   %edi
  802268:	e8 4a ec ff ff       	call   800eb7 <sys_ipc_try_send>
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	85 c0                	test   %eax,%eax
  802272:	74 1b                	je     80228f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802274:	79 e7                	jns    80225d <ipc_send+0x1e>
  802276:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802279:	74 e2                	je     80225d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 e7 2a 80 00       	push   $0x802ae7
  802283:	6a 46                	push   $0x46
  802285:	68 fc 2a 80 00       	push   $0x802afc
  80228a:	e8 e6 fe ff ff       	call   802175 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80228f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5f                   	pop    %edi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ae:	8b 52 50             	mov    0x50(%edx),%edx
  8022b1:	39 ca                	cmp    %ecx,%edx
  8022b3:	74 11                	je     8022c6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022b5:	83 c0 01             	add    $0x1,%eax
  8022b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022bd:	75 e3                	jne    8022a2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	eb 0e                	jmp    8022d4 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022c6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022dc:	89 d0                	mov    %edx,%eax
  8022de:	c1 e8 16             	shr    $0x16,%eax
  8022e1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022ed:	f6 c1 01             	test   $0x1,%cl
  8022f0:	74 1d                	je     80230f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022f2:	c1 ea 0c             	shr    $0xc,%edx
  8022f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022fc:	f6 c2 01             	test   $0x1,%dl
  8022ff:	74 0e                	je     80230f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802301:	c1 ea 0c             	shr    $0xc,%edx
  802304:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80230b:	ef 
  80230c:	0f b7 c0             	movzwl %ax,%eax
}
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	66 90                	xchg   %ax,%ax
  802313:	66 90                	xchg   %ax,%ax
  802315:	66 90                	xchg   %ax,%ax
  802317:	66 90                	xchg   %ax,%ax
  802319:	66 90                	xchg   %ax,%ax
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
