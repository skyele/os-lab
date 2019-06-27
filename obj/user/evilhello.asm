
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 3e 0c 00 00       	call   800c83 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	57                   	push   %edi
  80004e:	56                   	push   %esi
  80004f:	53                   	push   %ebx
  800050:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800053:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80005a:	00 00 00 
	envid_t find = sys_getenvid();
  80005d:	e8 9f 0c 00 00       	call   800d01 <sys_getenvid>
  800062:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800068:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800072:	bf 01 00 00 00       	mov    $0x1,%edi
  800077:	eb 0b                	jmp    800084 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800079:	83 c2 01             	add    $0x1,%edx
  80007c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800082:	74 23                	je     8000a7 <libmain+0x5d>
		if(envs[i].env_id == find)
  800084:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80008a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800090:	8b 49 48             	mov    0x48(%ecx),%ecx
  800093:	39 c1                	cmp    %eax,%ecx
  800095:	75 e2                	jne    800079 <libmain+0x2f>
  800097:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80009d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a3:	89 fe                	mov    %edi,%esi
  8000a5:	eb d2                	jmp    800079 <libmain+0x2f>
  8000a7:	89 f0                	mov    %esi,%eax
  8000a9:	84 c0                	test   %al,%al
  8000ab:	74 06                	je     8000b3 <libmain+0x69>
  8000ad:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b7:	7e 0a                	jle    8000c3 <libmain+0x79>
		binaryname = argv[0];
  8000b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bc:	8b 00                	mov    (%eax),%eax
  8000be:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8000c8:	8b 40 48             	mov    0x48(%eax),%eax
  8000cb:	83 ec 08             	sub    $0x8,%esp
  8000ce:	50                   	push   %eax
  8000cf:	68 80 25 80 00       	push   $0x802580
  8000d4:	e8 15 01 00 00       	call   8001ee <cprintf>
	cprintf("before umain\n");
  8000d9:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000e0:	e8 09 01 00 00       	call   8001ee <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e5:	83 c4 08             	add    $0x8,%esp
  8000e8:	ff 75 0c             	pushl  0xc(%ebp)
  8000eb:	ff 75 08             	pushl  0x8(%ebp)
  8000ee:	e8 40 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f3:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000fa:	e8 ef 00 00 00       	call   8001ee <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000ff:	a1 08 40 80 00       	mov    0x804008,%eax
  800104:	8b 40 48             	mov    0x48(%eax),%eax
  800107:	83 c4 08             	add    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	68 b9 25 80 00       	push   $0x8025b9
  800110:	e8 d9 00 00 00       	call   8001ee <cprintf>
	// exit gracefully
	exit();
  800115:	e8 0b 00 00 00       	call   800125 <exit>
}
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800120:	5b                   	pop    %ebx
  800121:	5e                   	pop    %esi
  800122:	5f                   	pop    %edi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80012b:	a1 08 40 80 00       	mov    0x804008,%eax
  800130:	8b 40 48             	mov    0x48(%eax),%eax
  800133:	68 e4 25 80 00       	push   $0x8025e4
  800138:	50                   	push   %eax
  800139:	68 d8 25 80 00       	push   $0x8025d8
  80013e:	e8 ab 00 00 00       	call   8001ee <cprintf>
	close_all();
  800143:	e8 c4 10 00 00       	call   80120c <close_all>
	sys_env_destroy(0);
  800148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014f:	e8 6c 0b 00 00       	call   800cc0 <sys_env_destroy>
}
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	53                   	push   %ebx
  80015d:	83 ec 04             	sub    $0x4,%esp
  800160:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800163:	8b 13                	mov    (%ebx),%edx
  800165:	8d 42 01             	lea    0x1(%edx),%eax
  800168:	89 03                	mov    %eax,(%ebx)
  80016a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800171:	3d ff 00 00 00       	cmp    $0xff,%eax
  800176:	74 09                	je     800181 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800178:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017f:	c9                   	leave  
  800180:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	68 ff 00 00 00       	push   $0xff
  800189:	8d 43 08             	lea    0x8(%ebx),%eax
  80018c:	50                   	push   %eax
  80018d:	e8 f1 0a 00 00       	call   800c83 <sys_cputs>
		b->idx = 0;
  800192:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	eb db                	jmp    800178 <putch+0x1f>

0080019d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ad:	00 00 00 
	b.cnt = 0;
  8001b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	68 59 01 80 00       	push   $0x800159
  8001cc:	e8 4a 01 00 00       	call   80031b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d1:	83 c4 08             	add    $0x8,%esp
  8001d4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001da:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e0:	50                   	push   %eax
  8001e1:	e8 9d 0a 00 00       	call   800c83 <sys_cputs>

	return b.cnt;
}
  8001e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f7:	50                   	push   %eax
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 9d ff ff ff       	call   80019d <vcprintf>
	va_end(ap);

	return cnt;
}
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	57                   	push   %edi
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
  800208:	83 ec 1c             	sub    $0x1c,%esp
  80020b:	89 c6                	mov    %eax,%esi
  80020d:	89 d7                	mov    %edx,%edi
  80020f:	8b 45 08             	mov    0x8(%ebp),%eax
  800212:	8b 55 0c             	mov    0xc(%ebp),%edx
  800215:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800218:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021b:	8b 45 10             	mov    0x10(%ebp),%eax
  80021e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800221:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800225:	74 2c                	je     800253 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800227:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800231:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800234:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800237:	39 c2                	cmp    %eax,%edx
  800239:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023c:	73 43                	jae    800281 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	85 db                	test   %ebx,%ebx
  800243:	7e 6c                	jle    8002b1 <printnum+0xaf>
				putch(padc, putdat);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	57                   	push   %edi
  800249:	ff 75 18             	pushl  0x18(%ebp)
  80024c:	ff d6                	call   *%esi
  80024e:	83 c4 10             	add    $0x10,%esp
  800251:	eb eb                	jmp    80023e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 20                	push   $0x20
  800258:	6a 00                	push   $0x0
  80025a:	50                   	push   %eax
  80025b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025e:	ff 75 e0             	pushl  -0x20(%ebp)
  800261:	89 fa                	mov    %edi,%edx
  800263:	89 f0                	mov    %esi,%eax
  800265:	e8 98 ff ff ff       	call   800202 <printnum>
		while (--width > 0)
  80026a:	83 c4 20             	add    $0x20,%esp
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	85 db                	test   %ebx,%ebx
  800272:	7e 65                	jle    8002d9 <printnum+0xd7>
			putch(padc, putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	6a 20                	push   $0x20
  80027a:	ff d6                	call   *%esi
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	eb ec                	jmp    80026d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	83 eb 01             	sub    $0x1,%ebx
  80028a:	53                   	push   %ebx
  80028b:	50                   	push   %eax
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 dc             	pushl  -0x24(%ebp)
  800292:	ff 75 d8             	pushl  -0x28(%ebp)
  800295:	ff 75 e4             	pushl  -0x1c(%ebp)
  800298:	ff 75 e0             	pushl  -0x20(%ebp)
  80029b:	e8 90 20 00 00       	call   802330 <__udivdi3>
  8002a0:	83 c4 18             	add    $0x18,%esp
  8002a3:	52                   	push   %edx
  8002a4:	50                   	push   %eax
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	89 f0                	mov    %esi,%eax
  8002a9:	e8 54 ff ff ff       	call   800202 <printnum>
  8002ae:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	57                   	push   %edi
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c4:	e8 77 21 00 00       	call   802440 <__umoddi3>
  8002c9:	83 c4 14             	add    $0x14,%esp
  8002cc:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff d6                	call   *%esi
  8002d6:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    

008002e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002eb:	8b 10                	mov    (%eax),%edx
  8002ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f0:	73 0a                	jae    8002fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f5:	89 08                	mov    %ecx,(%eax)
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	88 02                	mov    %al,(%edx)
}
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    

008002fe <printfmt>:
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800304:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800307:	50                   	push   %eax
  800308:	ff 75 10             	pushl  0x10(%ebp)
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 05 00 00 00       	call   80031b <vprintfmt>
}
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <vprintfmt>:
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 3c             	sub    $0x3c,%esp
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032d:	e9 32 04 00 00       	jmp    800764 <vprintfmt+0x449>
		padc = ' ';
  800332:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800336:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800344:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800352:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800359:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8d 47 01             	lea    0x1(%edi),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800364:	0f b6 17             	movzbl (%edi),%edx
  800367:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036a:	3c 55                	cmp    $0x55,%al
  80036c:	0f 87 12 05 00 00    	ja     800884 <vprintfmt+0x569>
  800372:	0f b6 c0             	movzbl %al,%eax
  800375:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800383:	eb d9                	jmp    80035e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800388:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038c:	eb d0                	jmp    80035e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 75 08             	mov    %esi,0x8(%ebp)
  80039c:	eb 03                	jmp    8003a1 <vprintfmt+0x86>
  80039e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ab:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ae:	83 fe 09             	cmp    $0x9,%esi
  8003b1:	76 eb                	jbe    80039e <vprintfmt+0x83>
  8003b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b9:	eb 14                	jmp    8003cf <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 40 04             	lea    0x4(%eax),%eax
  8003c9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d3:	79 89                	jns    80035e <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e2:	e9 77 ff ff ff       	jmp    80035e <vprintfmt+0x43>
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	0f 48 c1             	cmovs  %ecx,%eax
  8003ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f5:	e9 64 ff ff ff       	jmp    80035e <vprintfmt+0x43>
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800404:	e9 55 ff ff ff       	jmp    80035e <vprintfmt+0x43>
			lflag++;
  800409:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800410:	e9 49 ff ff ff       	jmp    80035e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 78 04             	lea    0x4(%eax),%edi
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	ff 30                	pushl  (%eax)
  800421:	ff d6                	call   *%esi
			break;
  800423:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800429:	e9 33 03 00 00       	jmp    800761 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 78 04             	lea    0x4(%eax),%edi
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	31 d0                	xor    %edx,%eax
  800439:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043b:	83 f8 11             	cmp    $0x11,%eax
  80043e:	7f 23                	jg     800463 <vprintfmt+0x148>
  800440:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800447:	85 d2                	test   %edx,%edx
  800449:	74 18                	je     800463 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044b:	52                   	push   %edx
  80044c:	68 3d 2a 80 00       	push   $0x802a3d
  800451:	53                   	push   %ebx
  800452:	56                   	push   %esi
  800453:	e8 a6 fe ff ff       	call   8002fe <printfmt>
  800458:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045e:	e9 fe 02 00 00       	jmp    800761 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800463:	50                   	push   %eax
  800464:	68 01 26 80 00       	push   $0x802601
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 8e fe ff ff       	call   8002fe <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800476:	e9 e6 02 00 00       	jmp    800761 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	83 c0 04             	add    $0x4,%eax
  800481:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800489:	85 c9                	test   %ecx,%ecx
  80048b:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  800490:	0f 45 c1             	cmovne %ecx,%eax
  800493:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049a:	7e 06                	jle    8004a2 <vprintfmt+0x187>
  80049c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a0:	75 0d                	jne    8004af <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a5:	89 c7                	mov    %eax,%edi
  8004a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8004aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ad:	eb 53                	jmp    800502 <vprintfmt+0x1e7>
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b5:	50                   	push   %eax
  8004b6:	e8 71 04 00 00       	call   80092c <strnlen>
  8004bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	eb 0f                	jmp    8004e0 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004da:	83 ef 01             	sub    $0x1,%edi
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7f ed                	jg     8004d1 <vprintfmt+0x1b6>
  8004e4:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c1             	cmovns %ecx,%eax
  8004f1:	29 c1                	sub    %eax,%ecx
  8004f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f6:	eb aa                	jmp    8004a2 <vprintfmt+0x187>
					putch(ch, putdat);
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	53                   	push   %ebx
  8004fc:	52                   	push   %edx
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 c7 01             	add    $0x1,%edi
  80050a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050e:	0f be d0             	movsbl %al,%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	74 4b                	je     800560 <vprintfmt+0x245>
  800515:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800519:	78 06                	js     800521 <vprintfmt+0x206>
  80051b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051f:	78 1e                	js     80053f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800521:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800525:	74 d1                	je     8004f8 <vprintfmt+0x1dd>
  800527:	0f be c0             	movsbl %al,%eax
  80052a:	83 e8 20             	sub    $0x20,%eax
  80052d:	83 f8 5e             	cmp    $0x5e,%eax
  800530:	76 c6                	jbe    8004f8 <vprintfmt+0x1dd>
					putch('?', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 3f                	push   $0x3f
  800538:	ff d6                	call   *%esi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb c3                	jmp    800502 <vprintfmt+0x1e7>
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	eb 0e                	jmp    800551 <vprintfmt+0x236>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 01 02 00 00       	jmp    800761 <vprintfmt+0x446>
  800560:	89 cf                	mov    %ecx,%edi
  800562:	eb ed                	jmp    800551 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800567:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80056e:	e9 eb fd ff ff       	jmp    80035e <vprintfmt+0x43>
	if (lflag >= 2)
  800573:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800577:	7f 21                	jg     80059a <vprintfmt+0x27f>
	else if (lflag)
  800579:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057d:	74 68                	je     8005e7 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800587:	89 c1                	mov    %eax,%ecx
  800589:	c1 f9 1f             	sar    $0x1f,%ecx
  80058c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	eb 17                	jmp    8005b1 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 50 04             	mov    0x4(%eax),%edx
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 08             	lea    0x8(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c1:	78 3f                	js     800602 <vprintfmt+0x2e7>
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005cc:	0f 84 71 01 00 00    	je     800743 <vprintfmt+0x428>
				putch('+', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 2b                	push   $0x2b
  8005d8:	ff d6                	call   *%esi
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	e9 5c 01 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ef:	89 c1                	mov    %eax,%ecx
  8005f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800600:	eb af                	jmp    8005b1 <vprintfmt+0x296>
				putch('-', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 2d                	push   $0x2d
  800608:	ff d6                	call   *%esi
				num = -(long long) num;
  80060a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800610:	f7 d8                	neg    %eax
  800612:	83 d2 00             	adc    $0x0,%edx
  800615:	f7 da                	neg    %edx
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 19 01 00 00       	jmp    800743 <vprintfmt+0x428>
	if (lflag >= 2)
  80062a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062e:	7f 29                	jg     800659 <vprintfmt+0x33e>
	else if (lflag)
  800630:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800634:	74 44                	je     80067a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	ba 00 00 00 00       	mov    $0x0,%edx
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800654:	e9 ea 00 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 50 04             	mov    0x4(%eax),%edx
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 08             	lea    0x8(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800670:	b8 0a 00 00 00       	mov    $0xa,%eax
  800675:	e9 c9 00 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	ba 00 00 00 00       	mov    $0x0,%edx
  800684:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800687:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 a6 00 00 00       	jmp    800743 <vprintfmt+0x428>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ac:	7f 26                	jg     8006d4 <vprintfmt+0x3b9>
	else if (lflag)
  8006ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b2:	74 3e                	je     8006f2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d2:	eb 6f                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 50 04             	mov    0x4(%eax),%edx
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f0:	eb 51                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070b:	b8 08 00 00 00       	mov    $0x8,%eax
  800710:	eb 31                	jmp    800743 <vprintfmt+0x428>
			putch('0', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 30                	push   $0x30
  800718:	ff d6                	call   *%esi
			putch('x', putdat);
  80071a:	83 c4 08             	add    $0x8,%esp
  80071d:	53                   	push   %ebx
  80071e:	6a 78                	push   $0x78
  800720:	ff d6                	call   *%esi
			num = (unsigned long long)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800732:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074a:	52                   	push   %edx
  80074b:	ff 75 e0             	pushl  -0x20(%ebp)
  80074e:	50                   	push   %eax
  80074f:	ff 75 dc             	pushl  -0x24(%ebp)
  800752:	ff 75 d8             	pushl  -0x28(%ebp)
  800755:	89 da                	mov    %ebx,%edx
  800757:	89 f0                	mov    %esi,%eax
  800759:	e8 a4 fa ff ff       	call   800202 <printnum>
			break;
  80075e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	83 c7 01             	add    $0x1,%edi
  800767:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076b:	83 f8 25             	cmp    $0x25,%eax
  80076e:	0f 84 be fb ff ff    	je     800332 <vprintfmt+0x17>
			if (ch == '\0')
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 84 28 01 00 00    	je     8008a4 <vprintfmt+0x589>
			putch(ch, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	ff d6                	call   *%esi
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	eb dc                	jmp    800764 <vprintfmt+0x449>
	if (lflag >= 2)
  800788:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078c:	7f 26                	jg     8007b4 <vprintfmt+0x499>
	else if (lflag)
  80078e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800792:	74 41                	je     8007d5 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b2:	eb 8f                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8d 40 08             	lea    0x8(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d0:	e9 6e ff ff ff       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f3:	e9 4b ff ff ff       	jmp    800743 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	74 14                	je     80081e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080a:	8b 13                	mov    (%ebx),%edx
  80080c:	83 fa 7f             	cmp    $0x7f,%edx
  80080f:	7f 37                	jg     800848 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800811:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800813:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	e9 43 ff ff ff       	jmp    800761 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80081e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800823:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	53                   	push   %ebx
  80082c:	50                   	push   %eax
  80082d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082f:	83 c7 01             	add    $0x1,%edi
  800832:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	75 eb                	jne    800828 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
  800843:	e9 19 ff ff ff       	jmp    800761 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800848:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084f:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	53                   	push   %ebx
  800858:	50                   	push   %eax
  800859:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085b:	83 c7 01             	add    $0x1,%edi
  80085e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	85 c0                	test   %eax,%eax
  800867:	75 eb                	jne    800854 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800869:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	e9 ed fe ff ff       	jmp    800761 <vprintfmt+0x446>
			putch(ch, putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 25                	push   $0x25
  80087a:	ff d6                	call   *%esi
			break;
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	e9 dd fe ff ff       	jmp    800761 <vprintfmt+0x446>
			putch('%', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 25                	push   $0x25
  80088a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	89 f8                	mov    %edi,%eax
  800891:	eb 03                	jmp    800896 <vprintfmt+0x57b>
  800893:	83 e8 01             	sub    $0x1,%eax
  800896:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089a:	75 f7                	jne    800893 <vprintfmt+0x578>
  80089c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089f:	e9 bd fe ff ff       	jmp    800761 <vprintfmt+0x446>
}
  8008a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5f                   	pop    %edi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 18             	sub    $0x18,%esp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c9:	85 c0                	test   %eax,%eax
  8008cb:	74 26                	je     8008f3 <vsnprintf+0x47>
  8008cd:	85 d2                	test   %edx,%edx
  8008cf:	7e 22                	jle    8008f3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d1:	ff 75 14             	pushl  0x14(%ebp)
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008da:	50                   	push   %eax
  8008db:	68 e1 02 80 00       	push   $0x8002e1
  8008e0:	e8 36 fa ff ff       	call   80031b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
}
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    
		return -E_INVAL;
  8008f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f8:	eb f7                	jmp    8008f1 <vsnprintf+0x45>

008008fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800900:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800903:	50                   	push   %eax
  800904:	ff 75 10             	pushl  0x10(%ebp)
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 9a ff ff ff       	call   8008ac <vsnprintf>
	va_end(ap);

	return rc;
}
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800923:	74 05                	je     80092a <strlen+0x16>
		n++;
  800925:	83 c0 01             	add    $0x1,%eax
  800928:	eb f5                	jmp    80091f <strlen+0xb>
	return n;
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	39 c2                	cmp    %eax,%edx
  80093c:	74 0d                	je     80094b <strnlen+0x1f>
  80093e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800942:	74 05                	je     800949 <strnlen+0x1d>
		n++;
  800944:	83 c2 01             	add    $0x1,%edx
  800947:	eb f1                	jmp    80093a <strnlen+0xe>
  800949:	89 d0                	mov    %edx,%eax
	return n;
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
  80095c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800960:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	84 c9                	test   %cl,%cl
  800968:	75 f2                	jne    80095c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096a:	5b                   	pop    %ebx
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	53                   	push   %ebx
  800971:	83 ec 10             	sub    $0x10,%esp
  800974:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800977:	53                   	push   %ebx
  800978:	e8 97 ff ff ff       	call   800914 <strlen>
  80097d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	01 d8                	add    %ebx,%eax
  800985:	50                   	push   %eax
  800986:	e8 c2 ff ff ff       	call   80094d <strcpy>
	return dst;
}
  80098b:	89 d8                	mov    %ebx,%eax
  80098d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800990:	c9                   	leave  
  800991:	c3                   	ret    

00800992 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099d:	89 c6                	mov    %eax,%esi
  80099f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 c2                	mov    %eax,%edx
  8009a4:	39 f2                	cmp    %esi,%edx
  8009a6:	74 11                	je     8009b9 <strncpy+0x27>
		*dst++ = *src;
  8009a8:	83 c2 01             	add    $0x1,%edx
  8009ab:	0f b6 19             	movzbl (%ecx),%ebx
  8009ae:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b1:	80 fb 01             	cmp    $0x1,%bl
  8009b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b7:	eb eb                	jmp    8009a4 <strncpy+0x12>
	}
	return ret;
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c8:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cd:	85 d2                	test   %edx,%edx
  8009cf:	74 21                	je     8009f2 <strlcpy+0x35>
  8009d1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d7:	39 c2                	cmp    %eax,%edx
  8009d9:	74 14                	je     8009ef <strlcpy+0x32>
  8009db:	0f b6 19             	movzbl (%ecx),%ebx
  8009de:	84 db                	test   %bl,%bl
  8009e0:	74 0b                	je     8009ed <strlcpy+0x30>
			*dst++ = *src++;
  8009e2:	83 c1 01             	add    $0x1,%ecx
  8009e5:	83 c2 01             	add    $0x1,%edx
  8009e8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009eb:	eb ea                	jmp    8009d7 <strlcpy+0x1a>
  8009ed:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f2:	29 f0                	sub    %esi,%eax
}
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a01:	0f b6 01             	movzbl (%ecx),%eax
  800a04:	84 c0                	test   %al,%al
  800a06:	74 0c                	je     800a14 <strcmp+0x1c>
  800a08:	3a 02                	cmp    (%edx),%al
  800a0a:	75 08                	jne    800a14 <strcmp+0x1c>
		p++, q++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ed                	jmp    800a01 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a14:	0f b6 c0             	movzbl %al,%eax
  800a17:	0f b6 12             	movzbl (%edx),%edx
  800a1a:	29 d0                	sub    %edx,%eax
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	53                   	push   %ebx
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	89 c3                	mov    %eax,%ebx
  800a2a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2d:	eb 06                	jmp    800a35 <strncmp+0x17>
		n--, p++, q++;
  800a2f:	83 c0 01             	add    $0x1,%eax
  800a32:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a35:	39 d8                	cmp    %ebx,%eax
  800a37:	74 16                	je     800a4f <strncmp+0x31>
  800a39:	0f b6 08             	movzbl (%eax),%ecx
  800a3c:	84 c9                	test   %cl,%cl
  800a3e:	74 04                	je     800a44 <strncmp+0x26>
  800a40:	3a 0a                	cmp    (%edx),%cl
  800a42:	74 eb                	je     800a2f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a44:	0f b6 00             	movzbl (%eax),%eax
  800a47:	0f b6 12             	movzbl (%edx),%edx
  800a4a:	29 d0                	sub    %edx,%eax
}
  800a4c:	5b                   	pop    %ebx
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    
		return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	eb f6                	jmp    800a4c <strncmp+0x2e>

00800a56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
  800a63:	84 d2                	test   %dl,%dl
  800a65:	74 09                	je     800a70 <strchr+0x1a>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strchr+0x1f>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strchr+0xa>
			return (char *) s;
	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a84:	38 ca                	cmp    %cl,%dl
  800a86:	74 09                	je     800a91 <strfind+0x1a>
  800a88:	84 d2                	test   %dl,%dl
  800a8a:	74 05                	je     800a91 <strfind+0x1a>
	for (; *s; s++)
  800a8c:	83 c0 01             	add    $0x1,%eax
  800a8f:	eb f0                	jmp    800a81 <strfind+0xa>
			break;
	return (char *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9f:	85 c9                	test   %ecx,%ecx
  800aa1:	74 31                	je     800ad4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa3:	89 f8                	mov    %edi,%eax
  800aa5:	09 c8                	or     %ecx,%eax
  800aa7:	a8 03                	test   $0x3,%al
  800aa9:	75 23                	jne    800ace <memset+0x3b>
		c &= 0xFF;
  800aab:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaf:	89 d3                	mov    %edx,%ebx
  800ab1:	c1 e3 08             	shl    $0x8,%ebx
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 18             	shl    $0x18,%eax
  800ab9:	89 d6                	mov    %edx,%esi
  800abb:	c1 e6 10             	shl    $0x10,%esi
  800abe:	09 f0                	or     %esi,%eax
  800ac0:	09 c2                	or     %eax,%edx
  800ac2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac7:	89 d0                	mov    %edx,%eax
  800ac9:	fc                   	cld    
  800aca:	f3 ab                	rep stos %eax,%es:(%edi)
  800acc:	eb 06                	jmp    800ad4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad4:	89 f8                	mov    %edi,%eax
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5f                   	pop    %edi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	57                   	push   %edi
  800adf:	56                   	push   %esi
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae9:	39 c6                	cmp    %eax,%esi
  800aeb:	73 32                	jae    800b1f <memmove+0x44>
  800aed:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af0:	39 c2                	cmp    %eax,%edx
  800af2:	76 2b                	jbe    800b1f <memmove+0x44>
		s += n;
		d += n;
  800af4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af7:	89 fe                	mov    %edi,%esi
  800af9:	09 ce                	or     %ecx,%esi
  800afb:	09 d6                	or     %edx,%esi
  800afd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b03:	75 0e                	jne    800b13 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b05:	83 ef 04             	sub    $0x4,%edi
  800b08:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0e:	fd                   	std    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b11:	eb 09                	jmp    800b1c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b13:	83 ef 01             	sub    $0x1,%edi
  800b16:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b19:	fd                   	std    
  800b1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1c:	fc                   	cld    
  800b1d:	eb 1a                	jmp    800b39 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	09 ca                	or     %ecx,%edx
  800b23:	09 f2                	or     %esi,%edx
  800b25:	f6 c2 03             	test   $0x3,%dl
  800b28:	75 0a                	jne    800b34 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2d:	89 c7                	mov    %eax,%edi
  800b2f:	fc                   	cld    
  800b30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b32:	eb 05                	jmp    800b39 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b34:	89 c7                	mov    %eax,%edi
  800b36:	fc                   	cld    
  800b37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	ff 75 08             	pushl  0x8(%ebp)
  800b4c:	e8 8a ff ff ff       	call   800adb <memmove>
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b63:	39 f0                	cmp    %esi,%eax
  800b65:	74 1c                	je     800b83 <memcmp+0x30>
		if (*s1 != *s2)
  800b67:	0f b6 08             	movzbl (%eax),%ecx
  800b6a:	0f b6 1a             	movzbl (%edx),%ebx
  800b6d:	38 d9                	cmp    %bl,%cl
  800b6f:	75 08                	jne    800b79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	83 c2 01             	add    $0x1,%edx
  800b77:	eb ea                	jmp    800b63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c1             	movzbl %cl,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 05                	jmp    800b88 <memcmp+0x35>
	}

	return 0;
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9a:	39 d0                	cmp    %edx,%eax
  800b9c:	73 09                	jae    800ba7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9e:	38 08                	cmp    %cl,(%eax)
  800ba0:	74 05                	je     800ba7 <memfind+0x1b>
	for (; s < ends; s++)
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	eb f3                	jmp    800b9a <memfind+0xe>
			break;
	return (void *) s;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb5:	eb 03                	jmp    800bba <strtol+0x11>
		s++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bba:	0f b6 01             	movzbl (%ecx),%eax
  800bbd:	3c 20                	cmp    $0x20,%al
  800bbf:	74 f6                	je     800bb7 <strtol+0xe>
  800bc1:	3c 09                	cmp    $0x9,%al
  800bc3:	74 f2                	je     800bb7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc5:	3c 2b                	cmp    $0x2b,%al
  800bc7:	74 2a                	je     800bf3 <strtol+0x4a>
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bce:	3c 2d                	cmp    $0x2d,%al
  800bd0:	74 2b                	je     800bfd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd8:	75 0f                	jne    800be9 <strtol+0x40>
  800bda:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdd:	74 28                	je     800c07 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdf:	85 db                	test   %ebx,%ebx
  800be1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be6:	0f 44 d8             	cmove  %eax,%ebx
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf1:	eb 50                	jmp    800c43 <strtol+0x9a>
		s++;
  800bf3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfb:	eb d5                	jmp    800bd2 <strtol+0x29>
		s++, neg = 1;
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	bf 01 00 00 00       	mov    $0x1,%edi
  800c05:	eb cb                	jmp    800bd2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0b:	74 0e                	je     800c1b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0d:	85 db                	test   %ebx,%ebx
  800c0f:	75 d8                	jne    800be9 <strtol+0x40>
		s++, base = 8;
  800c11:	83 c1 01             	add    $0x1,%ecx
  800c14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c19:	eb ce                	jmp    800be9 <strtol+0x40>
		s += 2, base = 16;
  800c1b:	83 c1 02             	add    $0x2,%ecx
  800c1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c23:	eb c4                	jmp    800be9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c28:	89 f3                	mov    %esi,%ebx
  800c2a:	80 fb 19             	cmp    $0x19,%bl
  800c2d:	77 29                	ja     800c58 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2f:	0f be d2             	movsbl %dl,%edx
  800c32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c38:	7d 30                	jge    800c6a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3a:	83 c1 01             	add    $0x1,%ecx
  800c3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c43:	0f b6 11             	movzbl (%ecx),%edx
  800c46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c49:	89 f3                	mov    %esi,%ebx
  800c4b:	80 fb 09             	cmp    $0x9,%bl
  800c4e:	77 d5                	ja     800c25 <strtol+0x7c>
			dig = *s - '0';
  800c50:	0f be d2             	movsbl %dl,%edx
  800c53:	83 ea 30             	sub    $0x30,%edx
  800c56:	eb dd                	jmp    800c35 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5b:	89 f3                	mov    %esi,%ebx
  800c5d:	80 fb 19             	cmp    $0x19,%bl
  800c60:	77 08                	ja     800c6a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c62:	0f be d2             	movsbl %dl,%edx
  800c65:	83 ea 37             	sub    $0x37,%edx
  800c68:	eb cb                	jmp    800c35 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6e:	74 05                	je     800c75 <strtol+0xcc>
		*endptr = (char *) s;
  800c70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c75:	89 c2                	mov    %eax,%edx
  800c77:	f7 da                	neg    %edx
  800c79:	85 ff                	test   %edi,%edi
  800c7b:	0f 45 c2             	cmovne %edx,%eax
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	89 c3                	mov    %eax,%ebx
  800c96:	89 c7                	mov    %eax,%edi
  800c98:	89 c6                	mov    %eax,%esi
  800c9a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb1:	89 d1                	mov    %edx,%ecx
  800cb3:	89 d3                	mov    %edx,%ebx
  800cb5:	89 d7                	mov    %edx,%edi
  800cb7:	89 d6                	mov    %edx,%esi
  800cb9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	89 cb                	mov    %ecx,%ebx
  800cd8:	89 cf                	mov    %ecx,%edi
  800cda:	89 ce                	mov    %ecx,%esi
  800cdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	7f 08                	jg     800cea <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	50                   	push   %eax
  800cee:	6a 03                	push   $0x3
  800cf0:	68 68 29 80 00       	push   $0x802968
  800cf5:	6a 43                	push   $0x43
  800cf7:	68 85 29 80 00       	push   $0x802985
  800cfc:	e8 89 14 00 00       	call   80218a <_panic>

00800d01 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d07:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800d11:	89 d1                	mov    %edx,%ecx
  800d13:	89 d3                	mov    %edx,%ebx
  800d15:	89 d7                	mov    %edx,%edi
  800d17:	89 d6                	mov    %edx,%esi
  800d19:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_yield>:

void
sys_yield(void)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d26:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d30:	89 d1                	mov    %edx,%ecx
  800d32:	89 d3                	mov    %edx,%ebx
  800d34:	89 d7                	mov    %edx,%edi
  800d36:	89 d6                	mov    %edx,%esi
  800d38:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	be 00 00 00 00       	mov    $0x0,%esi
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 04 00 00 00       	mov    $0x4,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	89 f7                	mov    %esi,%edi
  800d5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7f 08                	jg     800d6b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	50                   	push   %eax
  800d6f:	6a 04                	push   $0x4
  800d71:	68 68 29 80 00       	push   $0x802968
  800d76:	6a 43                	push   $0x43
  800d78:	68 85 29 80 00       	push   $0x802985
  800d7d:	e8 08 14 00 00       	call   80218a <_panic>

00800d82 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 05 00 00 00       	mov    $0x5,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 05                	push   $0x5
  800db3:	68 68 29 80 00       	push   $0x802968
  800db8:	6a 43                	push   $0x43
  800dba:	68 85 29 80 00       	push   $0x802985
  800dbf:	e8 c6 13 00 00       	call   80218a <_panic>

00800dc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddd:	89 df                	mov    %ebx,%edi
  800ddf:	89 de                	mov    %ebx,%esi
  800de1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 06                	push   $0x6
  800df5:	68 68 29 80 00       	push   $0x802968
  800dfa:	6a 43                	push   $0x43
  800dfc:	68 85 29 80 00       	push   $0x802985
  800e01:	e8 84 13 00 00       	call   80218a <_panic>

00800e06 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1f:	89 df                	mov    %ebx,%edi
  800e21:	89 de                	mov    %ebx,%esi
  800e23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	7f 08                	jg     800e31 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5f                   	pop    %edi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	50                   	push   %eax
  800e35:	6a 08                	push   $0x8
  800e37:	68 68 29 80 00       	push   $0x802968
  800e3c:	6a 43                	push   $0x43
  800e3e:	68 85 29 80 00       	push   $0x802985
  800e43:	e8 42 13 00 00       	call   80218a <_panic>

00800e48 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 09 00 00 00       	mov    $0x9,%eax
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7f 08                	jg     800e73 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	50                   	push   %eax
  800e77:	6a 09                	push   $0x9
  800e79:	68 68 29 80 00       	push   $0x802968
  800e7e:	6a 43                	push   $0x43
  800e80:	68 85 29 80 00       	push   $0x802985
  800e85:	e8 00 13 00 00       	call   80218a <_panic>

00800e8a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea3:	89 df                	mov    %ebx,%edi
  800ea5:	89 de                	mov    %ebx,%esi
  800ea7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	7f 08                	jg     800eb5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	6a 0a                	push   $0xa
  800ebb:	68 68 29 80 00       	push   $0x802968
  800ec0:	6a 43                	push   $0x43
  800ec2:	68 85 29 80 00       	push   $0x802985
  800ec7:	e8 be 12 00 00       	call   80218a <_panic>

00800ecc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edd:	be 00 00 00 00       	mov    $0x0,%esi
  800ee2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f05:	89 cb                	mov    %ecx,%ebx
  800f07:	89 cf                	mov    %ecx,%edi
  800f09:	89 ce                	mov    %ecx,%esi
  800f0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7f 08                	jg     800f19 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	50                   	push   %eax
  800f1d:	6a 0d                	push   $0xd
  800f1f:	68 68 29 80 00       	push   $0x802968
  800f24:	6a 43                	push   $0x43
  800f26:	68 85 29 80 00       	push   $0x802985
  800f2b:	e8 5a 12 00 00       	call   80218a <_panic>

00800f30 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f64:	89 cb                	mov    %ecx,%ebx
  800f66:	89 cf                	mov    %ecx,%edi
  800f68:	89 ce                	mov    %ecx,%esi
  800f6a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f77:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f81:	89 d1                	mov    %edx,%ecx
  800f83:	89 d3                	mov    %edx,%ebx
  800f85:	89 d7                	mov    %edx,%edi
  800f87:	89 d6                	mov    %edx,%esi
  800f89:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc2:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc7:	89 df                	mov    %ebx,%edi
  800fc9:	89 de                	mov    %ebx,%esi
  800fcb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe6:	b8 13 00 00 00       	mov    $0x13,%eax
  800feb:	89 df                	mov    %ebx,%edi
  800fed:	89 de                	mov    %ebx,%esi
  800fef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7f 08                	jg     800ffd <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	50                   	push   %eax
  801001:	6a 13                	push   $0x13
  801003:	68 68 29 80 00       	push   $0x802968
  801008:	6a 43                	push   $0x43
  80100a:	68 85 29 80 00       	push   $0x802985
  80100f:	e8 76 11 00 00       	call   80218a <_panic>

00801014 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	57                   	push   %edi
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	b8 14 00 00 00       	mov    $0x14,%eax
  801027:	89 cb                	mov    %ecx,%ebx
  801029:	89 cf                	mov    %ecx,%edi
  80102b:	89 ce                	mov    %ecx,%esi
  80102d:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	05 00 00 00 30       	add    $0x30000000,%eax
  80103f:	c1 e8 0c             	shr    $0xc,%eax
}
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80104f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801054:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801063:	89 c2                	mov    %eax,%edx
  801065:	c1 ea 16             	shr    $0x16,%edx
  801068:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106f:	f6 c2 01             	test   $0x1,%dl
  801072:	74 2d                	je     8010a1 <fd_alloc+0x46>
  801074:	89 c2                	mov    %eax,%edx
  801076:	c1 ea 0c             	shr    $0xc,%edx
  801079:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801080:	f6 c2 01             	test   $0x1,%dl
  801083:	74 1c                	je     8010a1 <fd_alloc+0x46>
  801085:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80108a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80108f:	75 d2                	jne    801063 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80109a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80109f:	eb 0a                	jmp    8010ab <fd_alloc+0x50>
			*fd_store = fd;
  8010a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010b3:	83 f8 1f             	cmp    $0x1f,%eax
  8010b6:	77 30                	ja     8010e8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b8:	c1 e0 0c             	shl    $0xc,%eax
  8010bb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010c6:	f6 c2 01             	test   $0x1,%dl
  8010c9:	74 24                	je     8010ef <fd_lookup+0x42>
  8010cb:	89 c2                	mov    %eax,%edx
  8010cd:	c1 ea 0c             	shr    $0xc,%edx
  8010d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d7:	f6 c2 01             	test   $0x1,%dl
  8010da:	74 1a                	je     8010f6 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    
		return -E_INVAL;
  8010e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ed:	eb f7                	jmp    8010e6 <fd_lookup+0x39>
		return -E_INVAL;
  8010ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f4:	eb f0                	jmp    8010e6 <fd_lookup+0x39>
  8010f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fb:	eb e9                	jmp    8010e6 <fd_lookup+0x39>

008010fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801106:	ba 00 00 00 00       	mov    $0x0,%edx
  80110b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801110:	39 08                	cmp    %ecx,(%eax)
  801112:	74 38                	je     80114c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801114:	83 c2 01             	add    $0x1,%edx
  801117:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  80111e:	85 c0                	test   %eax,%eax
  801120:	75 ee                	jne    801110 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801122:	a1 08 40 80 00       	mov    0x804008,%eax
  801127:	8b 40 48             	mov    0x48(%eax),%eax
  80112a:	83 ec 04             	sub    $0x4,%esp
  80112d:	51                   	push   %ecx
  80112e:	50                   	push   %eax
  80112f:	68 94 29 80 00       	push   $0x802994
  801134:	e8 b5 f0 ff ff       	call   8001ee <cprintf>
	*dev = 0;
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    
			*dev = devtab[i];
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	eb f2                	jmp    80114a <dev_lookup+0x4d>

00801158 <fd_close>:
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	83 ec 24             	sub    $0x24,%esp
  801161:	8b 75 08             	mov    0x8(%ebp),%esi
  801164:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801167:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80116a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801171:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801174:	50                   	push   %eax
  801175:	e8 33 ff ff ff       	call   8010ad <fd_lookup>
  80117a:	89 c3                	mov    %eax,%ebx
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 05                	js     801188 <fd_close+0x30>
	    || fd != fd2)
  801183:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801186:	74 16                	je     80119e <fd_close+0x46>
		return (must_exist ? r : 0);
  801188:	89 f8                	mov    %edi,%eax
  80118a:	84 c0                	test   %al,%al
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	0f 44 d8             	cmove  %eax,%ebx
}
  801194:	89 d8                	mov    %ebx,%eax
  801196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011a4:	50                   	push   %eax
  8011a5:	ff 36                	pushl  (%esi)
  8011a7:	e8 51 ff ff ff       	call   8010fd <dev_lookup>
  8011ac:	89 c3                	mov    %eax,%ebx
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	78 1a                	js     8011cf <fd_close+0x77>
		if (dev->dev_close)
  8011b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	74 0b                	je     8011cf <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	56                   	push   %esi
  8011c8:	ff d0                	call   *%eax
  8011ca:	89 c3                	mov    %eax,%ebx
  8011cc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011cf:	83 ec 08             	sub    $0x8,%esp
  8011d2:	56                   	push   %esi
  8011d3:	6a 00                	push   $0x0
  8011d5:	e8 ea fb ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	eb b5                	jmp    801194 <fd_close+0x3c>

008011df <close>:

int
close(int fdnum)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	ff 75 08             	pushl  0x8(%ebp)
  8011ec:	e8 bc fe ff ff       	call   8010ad <fd_lookup>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	79 02                	jns    8011fa <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
		return fd_close(fd, 1);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	6a 01                	push   $0x1
  8011ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801202:	e8 51 ff ff ff       	call   801158 <fd_close>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	eb ec                	jmp    8011f8 <close+0x19>

0080120c <close_all>:

void
close_all(void)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	53                   	push   %ebx
  801210:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801213:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	53                   	push   %ebx
  80121c:	e8 be ff ff ff       	call   8011df <close>
	for (i = 0; i < MAXFD; i++)
  801221:	83 c3 01             	add    $0x1,%ebx
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	83 fb 20             	cmp    $0x20,%ebx
  80122a:	75 ec                	jne    801218 <close_all+0xc>
}
  80122c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	57                   	push   %edi
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
  801237:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80123a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123d:	50                   	push   %eax
  80123e:	ff 75 08             	pushl  0x8(%ebp)
  801241:	e8 67 fe ff ff       	call   8010ad <fd_lookup>
  801246:	89 c3                	mov    %eax,%ebx
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	0f 88 81 00 00 00    	js     8012d4 <dup+0xa3>
		return r;
	close(newfdnum);
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 81 ff ff ff       	call   8011df <close>

	newfd = INDEX2FD(newfdnum);
  80125e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801261:	c1 e6 0c             	shl    $0xc,%esi
  801264:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80126a:	83 c4 04             	add    $0x4,%esp
  80126d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801270:	e8 cf fd ff ff       	call   801044 <fd2data>
  801275:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801277:	89 34 24             	mov    %esi,(%esp)
  80127a:	e8 c5 fd ff ff       	call   801044 <fd2data>
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801284:	89 d8                	mov    %ebx,%eax
  801286:	c1 e8 16             	shr    $0x16,%eax
  801289:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801290:	a8 01                	test   $0x1,%al
  801292:	74 11                	je     8012a5 <dup+0x74>
  801294:	89 d8                	mov    %ebx,%eax
  801296:	c1 e8 0c             	shr    $0xc,%eax
  801299:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a0:	f6 c2 01             	test   $0x1,%dl
  8012a3:	75 39                	jne    8012de <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a8:	89 d0                	mov    %edx,%eax
  8012aa:	c1 e8 0c             	shr    $0xc,%eax
  8012ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bc:	50                   	push   %eax
  8012bd:	56                   	push   %esi
  8012be:	6a 00                	push   $0x0
  8012c0:	52                   	push   %edx
  8012c1:	6a 00                	push   $0x0
  8012c3:	e8 ba fa ff ff       	call   800d82 <sys_page_map>
  8012c8:	89 c3                	mov    %eax,%ebx
  8012ca:	83 c4 20             	add    $0x20,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 31                	js     801302 <dup+0xd1>
		goto err;

	return newfdnum;
  8012d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012d4:	89 d8                	mov    %ebx,%eax
  8012d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d9:	5b                   	pop    %ebx
  8012da:	5e                   	pop    %esi
  8012db:	5f                   	pop    %edi
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ed:	50                   	push   %eax
  8012ee:	57                   	push   %edi
  8012ef:	6a 00                	push   $0x0
  8012f1:	53                   	push   %ebx
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 89 fa ff ff       	call   800d82 <sys_page_map>
  8012f9:	89 c3                	mov    %eax,%ebx
  8012fb:	83 c4 20             	add    $0x20,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	79 a3                	jns    8012a5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	56                   	push   %esi
  801306:	6a 00                	push   $0x0
  801308:	e8 b7 fa ff ff       	call   800dc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80130d:	83 c4 08             	add    $0x8,%esp
  801310:	57                   	push   %edi
  801311:	6a 00                	push   $0x0
  801313:	e8 ac fa ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	eb b7                	jmp    8012d4 <dup+0xa3>

0080131d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	53                   	push   %ebx
  801321:	83 ec 1c             	sub    $0x1c,%esp
  801324:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801327:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	53                   	push   %ebx
  80132c:	e8 7c fd ff ff       	call   8010ad <fd_lookup>
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	78 3f                	js     801377 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801342:	ff 30                	pushl  (%eax)
  801344:	e8 b4 fd ff ff       	call   8010fd <dev_lookup>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 27                	js     801377 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801350:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801353:	8b 42 08             	mov    0x8(%edx),%eax
  801356:	83 e0 03             	and    $0x3,%eax
  801359:	83 f8 01             	cmp    $0x1,%eax
  80135c:	74 1e                	je     80137c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801361:	8b 40 08             	mov    0x8(%eax),%eax
  801364:	85 c0                	test   %eax,%eax
  801366:	74 35                	je     80139d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	ff 75 10             	pushl  0x10(%ebp)
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	52                   	push   %edx
  801372:	ff d0                	call   *%eax
  801374:	83 c4 10             	add    $0x10,%esp
}
  801377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80137c:	a1 08 40 80 00       	mov    0x804008,%eax
  801381:	8b 40 48             	mov    0x48(%eax),%eax
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	53                   	push   %ebx
  801388:	50                   	push   %eax
  801389:	68 d5 29 80 00       	push   $0x8029d5
  80138e:	e8 5b ee ff ff       	call   8001ee <cprintf>
		return -E_INVAL;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139b:	eb da                	jmp    801377 <read+0x5a>
		return -E_NOT_SUPP;
  80139d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a2:	eb d3                	jmp    801377 <read+0x5a>

008013a4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	57                   	push   %edi
  8013a8:	56                   	push   %esi
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b8:	39 f3                	cmp    %esi,%ebx
  8013ba:	73 23                	jae    8013df <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	89 f0                	mov    %esi,%eax
  8013c1:	29 d8                	sub    %ebx,%eax
  8013c3:	50                   	push   %eax
  8013c4:	89 d8                	mov    %ebx,%eax
  8013c6:	03 45 0c             	add    0xc(%ebp),%eax
  8013c9:	50                   	push   %eax
  8013ca:	57                   	push   %edi
  8013cb:	e8 4d ff ff ff       	call   80131d <read>
		if (m < 0)
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 06                	js     8013dd <readn+0x39>
			return m;
		if (m == 0)
  8013d7:	74 06                	je     8013df <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013d9:	01 c3                	add    %eax,%ebx
  8013db:	eb db                	jmp    8013b8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013dd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013df:	89 d8                	mov    %ebx,%eax
  8013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5f                   	pop    %edi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    

008013e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	53                   	push   %ebx
  8013ed:	83 ec 1c             	sub    $0x1c,%esp
  8013f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	53                   	push   %ebx
  8013f8:	e8 b0 fc ff ff       	call   8010ad <fd_lookup>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 3a                	js     80143e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801404:	83 ec 08             	sub    $0x8,%esp
  801407:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140a:	50                   	push   %eax
  80140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140e:	ff 30                	pushl  (%eax)
  801410:	e8 e8 fc ff ff       	call   8010fd <dev_lookup>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 22                	js     80143e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801423:	74 1e                	je     801443 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801428:	8b 52 0c             	mov    0xc(%edx),%edx
  80142b:	85 d2                	test   %edx,%edx
  80142d:	74 35                	je     801464 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142f:	83 ec 04             	sub    $0x4,%esp
  801432:	ff 75 10             	pushl  0x10(%ebp)
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	50                   	push   %eax
  801439:	ff d2                	call   *%edx
  80143b:	83 c4 10             	add    $0x10,%esp
}
  80143e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801441:	c9                   	leave  
  801442:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801443:	a1 08 40 80 00       	mov    0x804008,%eax
  801448:	8b 40 48             	mov    0x48(%eax),%eax
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	53                   	push   %ebx
  80144f:	50                   	push   %eax
  801450:	68 f1 29 80 00       	push   $0x8029f1
  801455:	e8 94 ed ff ff       	call   8001ee <cprintf>
		return -E_INVAL;
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801462:	eb da                	jmp    80143e <write+0x55>
		return -E_NOT_SUPP;
  801464:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801469:	eb d3                	jmp    80143e <write+0x55>

0080146b <seek>:

int
seek(int fdnum, off_t offset)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801471:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801474:	50                   	push   %eax
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	e8 30 fc ff ff       	call   8010ad <fd_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 0e                	js     801492 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801484:	8b 55 0c             	mov    0xc(%ebp),%edx
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	53                   	push   %ebx
  801498:	83 ec 1c             	sub    $0x1c,%esp
  80149b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	53                   	push   %ebx
  8014a3:	e8 05 fc ff ff       	call   8010ad <fd_lookup>
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 37                	js     8014e6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b5:	50                   	push   %eax
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b9:	ff 30                	pushl  (%eax)
  8014bb:	e8 3d fc ff ff       	call   8010fd <dev_lookup>
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 1f                	js     8014e6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ce:	74 1b                	je     8014eb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d3:	8b 52 18             	mov    0x18(%edx),%edx
  8014d6:	85 d2                	test   %edx,%edx
  8014d8:	74 32                	je     80150c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	50                   	push   %eax
  8014e1:	ff d2                	call   *%edx
  8014e3:	83 c4 10             	add    $0x10,%esp
}
  8014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014eb:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f0:	8b 40 48             	mov    0x48(%eax),%eax
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	53                   	push   %ebx
  8014f7:	50                   	push   %eax
  8014f8:	68 b4 29 80 00       	push   $0x8029b4
  8014fd:	e8 ec ec ff ff       	call   8001ee <cprintf>
		return -E_INVAL;
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150a:	eb da                	jmp    8014e6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80150c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801511:	eb d3                	jmp    8014e6 <ftruncate+0x52>

00801513 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	53                   	push   %ebx
  801517:	83 ec 1c             	sub    $0x1c,%esp
  80151a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	e8 84 fb ff ff       	call   8010ad <fd_lookup>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 4b                	js     80157b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801530:	83 ec 08             	sub    $0x8,%esp
  801533:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801536:	50                   	push   %eax
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153a:	ff 30                	pushl  (%eax)
  80153c:	e8 bc fb ff ff       	call   8010fd <dev_lookup>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	78 33                	js     80157b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80154f:	74 2f                	je     801580 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801551:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801554:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80155b:	00 00 00 
	stat->st_isdir = 0;
  80155e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801565:	00 00 00 
	stat->st_dev = dev;
  801568:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	53                   	push   %ebx
  801572:	ff 75 f0             	pushl  -0x10(%ebp)
  801575:	ff 50 14             	call   *0x14(%eax)
  801578:	83 c4 10             	add    $0x10,%esp
}
  80157b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    
		return -E_NOT_SUPP;
  801580:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801585:	eb f4                	jmp    80157b <fstat+0x68>

00801587 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	6a 00                	push   $0x0
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	e8 22 02 00 00       	call   8017bb <open>
  801599:	89 c3                	mov    %eax,%ebx
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 1b                	js     8015bd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	50                   	push   %eax
  8015a9:	e8 65 ff ff ff       	call   801513 <fstat>
  8015ae:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b0:	89 1c 24             	mov    %ebx,(%esp)
  8015b3:	e8 27 fc ff ff       	call   8011df <close>
	return r;
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	89 f3                	mov    %esi,%ebx
}
  8015bd:	89 d8                	mov    %ebx,%eax
  8015bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5e                   	pop    %esi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d6:	74 27                	je     8015ff <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d8:	6a 07                	push   $0x7
  8015da:	68 00 50 80 00       	push   $0x805000
  8015df:	56                   	push   %esi
  8015e0:	ff 35 00 40 80 00    	pushl  0x804000
  8015e6:	e8 69 0c 00 00       	call   802254 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015eb:	83 c4 0c             	add    $0xc,%esp
  8015ee:	6a 00                	push   $0x0
  8015f0:	53                   	push   %ebx
  8015f1:	6a 00                	push   $0x0
  8015f3:	e8 f3 0b 00 00       	call   8021eb <ipc_recv>
}
  8015f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	6a 01                	push   $0x1
  801604:	e8 a3 0c 00 00       	call   8022ac <ipc_find_env>
  801609:	a3 00 40 80 00       	mov    %eax,0x804000
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	eb c5                	jmp    8015d8 <fsipc+0x12>

00801613 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8b 40 0c             	mov    0xc(%eax),%eax
  80161f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80162c:	ba 00 00 00 00       	mov    $0x0,%edx
  801631:	b8 02 00 00 00       	mov    $0x2,%eax
  801636:	e8 8b ff ff ff       	call   8015c6 <fsipc>
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <devfile_flush>:
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8b 40 0c             	mov    0xc(%eax),%eax
  801649:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80164e:	ba 00 00 00 00       	mov    $0x0,%edx
  801653:	b8 06 00 00 00       	mov    $0x6,%eax
  801658:	e8 69 ff ff ff       	call   8015c6 <fsipc>
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <devfile_stat>:
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	53                   	push   %ebx
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8b 40 0c             	mov    0xc(%eax),%eax
  80166f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	b8 05 00 00 00       	mov    $0x5,%eax
  80167e:	e8 43 ff ff ff       	call   8015c6 <fsipc>
  801683:	85 c0                	test   %eax,%eax
  801685:	78 2c                	js     8016b3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	68 00 50 80 00       	push   $0x805000
  80168f:	53                   	push   %ebx
  801690:	e8 b8 f2 ff ff       	call   80094d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801695:	a1 80 50 80 00       	mov    0x805080,%eax
  80169a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016a0:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <devfile_write>:
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	53                   	push   %ebx
  8016bc:	83 ec 08             	sub    $0x8,%esp
  8016bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016cd:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016d3:	53                   	push   %ebx
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	68 08 50 80 00       	push   $0x805008
  8016dc:	e8 5c f4 ff ff       	call   800b3d <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016eb:	e8 d6 fe ff ff       	call   8015c6 <fsipc>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 0b                	js     801702 <devfile_write+0x4a>
	assert(r <= n);
  8016f7:	39 d8                	cmp    %ebx,%eax
  8016f9:	77 0c                	ja     801707 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016fb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801700:	7f 1e                	jg     801720 <devfile_write+0x68>
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    
	assert(r <= n);
  801707:	68 24 2a 80 00       	push   $0x802a24
  80170c:	68 2b 2a 80 00       	push   $0x802a2b
  801711:	68 98 00 00 00       	push   $0x98
  801716:	68 40 2a 80 00       	push   $0x802a40
  80171b:	e8 6a 0a 00 00       	call   80218a <_panic>
	assert(r <= PGSIZE);
  801720:	68 4b 2a 80 00       	push   $0x802a4b
  801725:	68 2b 2a 80 00       	push   $0x802a2b
  80172a:	68 99 00 00 00       	push   $0x99
  80172f:	68 40 2a 80 00       	push   $0x802a40
  801734:	e8 51 0a 00 00       	call   80218a <_panic>

00801739 <devfile_read>:
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8b 40 0c             	mov    0xc(%eax),%eax
  801747:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	b8 03 00 00 00       	mov    $0x3,%eax
  80175c:	e8 65 fe ff ff       	call   8015c6 <fsipc>
  801761:	89 c3                	mov    %eax,%ebx
  801763:	85 c0                	test   %eax,%eax
  801765:	78 1f                	js     801786 <devfile_read+0x4d>
	assert(r <= n);
  801767:	39 f0                	cmp    %esi,%eax
  801769:	77 24                	ja     80178f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801770:	7f 33                	jg     8017a5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	50                   	push   %eax
  801776:	68 00 50 80 00       	push   $0x805000
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	e8 58 f3 ff ff       	call   800adb <memmove>
	return r;
  801783:	83 c4 10             	add    $0x10,%esp
}
  801786:	89 d8                	mov    %ebx,%eax
  801788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    
	assert(r <= n);
  80178f:	68 24 2a 80 00       	push   $0x802a24
  801794:	68 2b 2a 80 00       	push   $0x802a2b
  801799:	6a 7c                	push   $0x7c
  80179b:	68 40 2a 80 00       	push   $0x802a40
  8017a0:	e8 e5 09 00 00       	call   80218a <_panic>
	assert(r <= PGSIZE);
  8017a5:	68 4b 2a 80 00       	push   $0x802a4b
  8017aa:	68 2b 2a 80 00       	push   $0x802a2b
  8017af:	6a 7d                	push   $0x7d
  8017b1:	68 40 2a 80 00       	push   $0x802a40
  8017b6:	e8 cf 09 00 00       	call   80218a <_panic>

008017bb <open>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 1c             	sub    $0x1c,%esp
  8017c3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c6:	56                   	push   %esi
  8017c7:	e8 48 f1 ff ff       	call   800914 <strlen>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d4:	7f 6c                	jg     801842 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dc:	50                   	push   %eax
  8017dd:	e8 79 f8 ff ff       	call   80105b <fd_alloc>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 3c                	js     801827 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	56                   	push   %esi
  8017ef:	68 00 50 80 00       	push   $0x805000
  8017f4:	e8 54 f1 ff ff       	call   80094d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801804:	b8 01 00 00 00       	mov    $0x1,%eax
  801809:	e8 b8 fd ff ff       	call   8015c6 <fsipc>
  80180e:	89 c3                	mov    %eax,%ebx
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	85 c0                	test   %eax,%eax
  801815:	78 19                	js     801830 <open+0x75>
	return fd2num(fd);
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	ff 75 f4             	pushl  -0xc(%ebp)
  80181d:	e8 12 f8 ff ff       	call   801034 <fd2num>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	83 c4 10             	add    $0x10,%esp
}
  801827:	89 d8                	mov    %ebx,%eax
  801829:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    
		fd_close(fd, 0);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	6a 00                	push   $0x0
  801835:	ff 75 f4             	pushl  -0xc(%ebp)
  801838:	e8 1b f9 ff ff       	call   801158 <fd_close>
		return r;
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	eb e5                	jmp    801827 <open+0x6c>
		return -E_BAD_PATH;
  801842:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801847:	eb de                	jmp    801827 <open+0x6c>

00801849 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	b8 08 00 00 00       	mov    $0x8,%eax
  801859:	e8 68 fd ff ff       	call   8015c6 <fsipc>
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801866:	68 57 2a 80 00       	push   $0x802a57
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	e8 da f0 ff ff       	call   80094d <strcpy>
	return 0;
}
  801873:	b8 00 00 00 00       	mov    $0x0,%eax
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <devsock_close>:
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	53                   	push   %ebx
  80187e:	83 ec 10             	sub    $0x10,%esp
  801881:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801884:	53                   	push   %ebx
  801885:	e8 61 0a 00 00       	call   8022eb <pageref>
  80188a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80188d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801892:	83 f8 01             	cmp    $0x1,%eax
  801895:	74 07                	je     80189e <devsock_close+0x24>
}
  801897:	89 d0                	mov    %edx,%eax
  801899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 73 0c             	pushl  0xc(%ebx)
  8018a4:	e8 b9 02 00 00       	call   801b62 <nsipc_close>
  8018a9:	89 c2                	mov    %eax,%edx
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	eb e7                	jmp    801897 <devsock_close+0x1d>

008018b0 <devsock_write>:
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	ff 75 10             	pushl  0x10(%ebp)
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	ff 70 0c             	pushl  0xc(%eax)
  8018c4:	e8 76 03 00 00       	call   801c3f <nsipc_send>
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <devsock_read>:
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	ff 70 0c             	pushl  0xc(%eax)
  8018df:	e8 ef 02 00 00       	call   801bd3 <nsipc_recv>
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <fd2sockid>:
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ec:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	e8 b7 f7 ff ff       	call   8010ad <fd_lookup>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 10                	js     80190d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801906:	39 08                	cmp    %ecx,(%eax)
  801908:	75 05                	jne    80190f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80190a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    
		return -E_NOT_SUPP;
  80190f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801914:	eb f7                	jmp    80190d <fd2sockid+0x27>

00801916 <alloc_sockfd>:
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
  80191b:	83 ec 1c             	sub    $0x1c,%esp
  80191e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801920:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801923:	50                   	push   %eax
  801924:	e8 32 f7 ff ff       	call   80105b <fd_alloc>
  801929:	89 c3                	mov    %eax,%ebx
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 43                	js     801975 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	68 07 04 00 00       	push   $0x407
  80193a:	ff 75 f4             	pushl  -0xc(%ebp)
  80193d:	6a 00                	push   $0x0
  80193f:	e8 fb f3 ff ff       	call   800d3f <sys_page_alloc>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 28                	js     801975 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801956:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801962:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801965:	83 ec 0c             	sub    $0xc,%esp
  801968:	50                   	push   %eax
  801969:	e8 c6 f6 ff ff       	call   801034 <fd2num>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	eb 0c                	jmp    801981 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	56                   	push   %esi
  801979:	e8 e4 01 00 00       	call   801b62 <nsipc_close>
		return r;
  80197e:	83 c4 10             	add    $0x10,%esp
}
  801981:	89 d8                	mov    %ebx,%eax
  801983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <accept>:
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	e8 4e ff ff ff       	call   8018e6 <fd2sockid>
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 1b                	js     8019b7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	ff 75 10             	pushl  0x10(%ebp)
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	e8 0e 01 00 00       	call   801ab9 <nsipc_accept>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 05                	js     8019b7 <accept+0x2d>
	return alloc_sockfd(r);
  8019b2:	e8 5f ff ff ff       	call   801916 <alloc_sockfd>
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <bind>:
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	e8 1f ff ff ff       	call   8018e6 <fd2sockid>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 12                	js     8019dd <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	ff 75 10             	pushl  0x10(%ebp)
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	50                   	push   %eax
  8019d5:	e8 31 01 00 00       	call   801b0b <nsipc_bind>
  8019da:	83 c4 10             	add    $0x10,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <shutdown>:
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	e8 f9 fe ff ff       	call   8018e6 <fd2sockid>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 0f                	js     801a00 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	50                   	push   %eax
  8019f8:	e8 43 01 00 00       	call   801b40 <nsipc_shutdown>
  8019fd:	83 c4 10             	add    $0x10,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <connect>:
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	e8 d6 fe ff ff       	call   8018e6 <fd2sockid>
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 12                	js     801a26 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	ff 75 10             	pushl  0x10(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	50                   	push   %eax
  801a1e:	e8 59 01 00 00       	call   801b7c <nsipc_connect>
  801a23:	83 c4 10             	add    $0x10,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <listen>:
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	e8 b0 fe ff ff       	call   8018e6 <fd2sockid>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 0f                	js     801a49 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	50                   	push   %eax
  801a41:	e8 6b 01 00 00       	call   801bb1 <nsipc_listen>
  801a46:	83 c4 10             	add    $0x10,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <socket>:

int
socket(int domain, int type, int protocol)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	e8 3e 02 00 00       	call   801c9d <nsipc_socket>
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 05                	js     801a6b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a66:	e8 ab fe ff ff       	call   801916 <alloc_sockfd>
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	53                   	push   %ebx
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a76:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a7d:	74 26                	je     801aa5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a7f:	6a 07                	push   $0x7
  801a81:	68 00 60 80 00       	push   $0x806000
  801a86:	53                   	push   %ebx
  801a87:	ff 35 04 40 80 00    	pushl  0x804004
  801a8d:	e8 c2 07 00 00       	call   802254 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a92:	83 c4 0c             	add    $0xc,%esp
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	e8 4b 07 00 00       	call   8021eb <ipc_recv>
}
  801aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	6a 02                	push   $0x2
  801aaa:	e8 fd 07 00 00       	call   8022ac <ipc_find_env>
  801aaf:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	eb c6                	jmp    801a7f <nsipc+0x12>

00801ab9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	56                   	push   %esi
  801abd:	53                   	push   %ebx
  801abe:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ac9:	8b 06                	mov    (%esi),%eax
  801acb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ad0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad5:	e8 93 ff ff ff       	call   801a6d <nsipc>
  801ada:	89 c3                	mov    %eax,%ebx
  801adc:	85 c0                	test   %eax,%eax
  801ade:	79 09                	jns    801ae9 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ae0:	89 d8                	mov    %ebx,%eax
  801ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	ff 35 10 60 80 00    	pushl  0x806010
  801af2:	68 00 60 80 00       	push   $0x806000
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	e8 dc ef ff ff       	call   800adb <memmove>
		*addrlen = ret->ret_addrlen;
  801aff:	a1 10 60 80 00       	mov    0x806010,%eax
  801b04:	89 06                	mov    %eax,(%esi)
  801b06:	83 c4 10             	add    $0x10,%esp
	return r;
  801b09:	eb d5                	jmp    801ae0 <nsipc_accept+0x27>

00801b0b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	53                   	push   %ebx
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1d:	53                   	push   %ebx
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	68 04 60 80 00       	push   $0x806004
  801b26:	e8 b0 ef ff ff       	call   800adb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b2b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b31:	b8 02 00 00 00       	mov    $0x2,%eax
  801b36:	e8 32 ff ff ff       	call   801a6d <nsipc>
}
  801b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b56:	b8 03 00 00 00       	mov    $0x3,%eax
  801b5b:	e8 0d ff ff ff       	call   801a6d <nsipc>
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <nsipc_close>:

int
nsipc_close(int s)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b70:	b8 04 00 00 00       	mov    $0x4,%eax
  801b75:	e8 f3 fe ff ff       	call   801a6d <nsipc>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 08             	sub    $0x8,%esp
  801b83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b8e:	53                   	push   %ebx
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	68 04 60 80 00       	push   $0x806004
  801b97:	e8 3f ef ff ff       	call   800adb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b9c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ba2:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba7:	e8 c1 fe ff ff       	call   801a6d <nsipc>
}
  801bac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc7:	b8 06 00 00 00       	mov    $0x6,%eax
  801bcc:	e8 9c fe ff ff       	call   801a6d <nsipc>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bec:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf1:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf6:	e8 72 fe ff ff       	call   801a6d <nsipc>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 1f                	js     801c20 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c01:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c06:	7f 21                	jg     801c29 <nsipc_recv+0x56>
  801c08:	39 c6                	cmp    %eax,%esi
  801c0a:	7c 1d                	jl     801c29 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	50                   	push   %eax
  801c10:	68 00 60 80 00       	push   $0x806000
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	e8 be ee ff ff       	call   800adb <memmove>
  801c1d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5e                   	pop    %esi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c29:	68 63 2a 80 00       	push   $0x802a63
  801c2e:	68 2b 2a 80 00       	push   $0x802a2b
  801c33:	6a 62                	push   $0x62
  801c35:	68 78 2a 80 00       	push   $0x802a78
  801c3a:	e8 4b 05 00 00       	call   80218a <_panic>

00801c3f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	53                   	push   %ebx
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c51:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c57:	7f 2e                	jg     801c87 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	53                   	push   %ebx
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	68 0c 60 80 00       	push   $0x80600c
  801c65:	e8 71 ee ff ff       	call   800adb <memmove>
	nsipcbuf.send.req_size = size;
  801c6a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c70:	8b 45 14             	mov    0x14(%ebp),%eax
  801c73:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c78:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7d:	e8 eb fd ff ff       	call   801a6d <nsipc>
}
  801c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    
	assert(size < 1600);
  801c87:	68 84 2a 80 00       	push   $0x802a84
  801c8c:	68 2b 2a 80 00       	push   $0x802a2b
  801c91:	6a 6d                	push   $0x6d
  801c93:	68 78 2a 80 00       	push   $0x802a78
  801c98:	e8 ed 04 00 00       	call   80218a <_panic>

00801c9d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cae:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cbb:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc0:	e8 a8 fd ff ff       	call   801a6d <nsipc>
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	e8 6a f3 ff ff       	call   801044 <fd2data>
  801cda:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cdc:	83 c4 08             	add    $0x8,%esp
  801cdf:	68 90 2a 80 00       	push   $0x802a90
  801ce4:	53                   	push   %ebx
  801ce5:	e8 63 ec ff ff       	call   80094d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cea:	8b 46 04             	mov    0x4(%esi),%eax
  801ced:	2b 06                	sub    (%esi),%eax
  801cef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cfc:	00 00 00 
	stat->st_dev = &devpipe;
  801cff:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d06:	30 80 00 
	return 0;
}
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	53                   	push   %ebx
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d1f:	53                   	push   %ebx
  801d20:	6a 00                	push   $0x0
  801d22:	e8 9d f0 ff ff       	call   800dc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d27:	89 1c 24             	mov    %ebx,(%esp)
  801d2a:	e8 15 f3 ff ff       	call   801044 <fd2data>
  801d2f:	83 c4 08             	add    $0x8,%esp
  801d32:	50                   	push   %eax
  801d33:	6a 00                	push   $0x0
  801d35:	e8 8a f0 ff ff       	call   800dc4 <sys_page_unmap>
}
  801d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <_pipeisclosed>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	57                   	push   %edi
  801d43:	56                   	push   %esi
  801d44:	53                   	push   %ebx
  801d45:	83 ec 1c             	sub    $0x1c,%esp
  801d48:	89 c7                	mov    %eax,%edi
  801d4a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d4c:	a1 08 40 80 00       	mov    0x804008,%eax
  801d51:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	57                   	push   %edi
  801d58:	e8 8e 05 00 00       	call   8022eb <pageref>
  801d5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d60:	89 34 24             	mov    %esi,(%esp)
  801d63:	e8 83 05 00 00       	call   8022eb <pageref>
		nn = thisenv->env_runs;
  801d68:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d6e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	39 cb                	cmp    %ecx,%ebx
  801d76:	74 1b                	je     801d93 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d78:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d7b:	75 cf                	jne    801d4c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d7d:	8b 42 58             	mov    0x58(%edx),%eax
  801d80:	6a 01                	push   $0x1
  801d82:	50                   	push   %eax
  801d83:	53                   	push   %ebx
  801d84:	68 97 2a 80 00       	push   $0x802a97
  801d89:	e8 60 e4 ff ff       	call   8001ee <cprintf>
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	eb b9                	jmp    801d4c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d96:	0f 94 c0             	sete   %al
  801d99:	0f b6 c0             	movzbl %al,%eax
}
  801d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <devpipe_write>:
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	57                   	push   %edi
  801da8:	56                   	push   %esi
  801da9:	53                   	push   %ebx
  801daa:	83 ec 28             	sub    $0x28,%esp
  801dad:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801db0:	56                   	push   %esi
  801db1:	e8 8e f2 ff ff       	call   801044 <fd2data>
  801db6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc3:	74 4f                	je     801e14 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc5:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc8:	8b 0b                	mov    (%ebx),%ecx
  801dca:	8d 51 20             	lea    0x20(%ecx),%edx
  801dcd:	39 d0                	cmp    %edx,%eax
  801dcf:	72 14                	jb     801de5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dd1:	89 da                	mov    %ebx,%edx
  801dd3:	89 f0                	mov    %esi,%eax
  801dd5:	e8 65 ff ff ff       	call   801d3f <_pipeisclosed>
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	75 3b                	jne    801e19 <devpipe_write+0x75>
			sys_yield();
  801dde:	e8 3d ef ff ff       	call   800d20 <sys_yield>
  801de3:	eb e0                	jmp    801dc5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801def:	89 c2                	mov    %eax,%edx
  801df1:	c1 fa 1f             	sar    $0x1f,%edx
  801df4:	89 d1                	mov    %edx,%ecx
  801df6:	c1 e9 1b             	shr    $0x1b,%ecx
  801df9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dfc:	83 e2 1f             	and    $0x1f,%edx
  801dff:	29 ca                	sub    %ecx,%edx
  801e01:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e05:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e09:	83 c0 01             	add    $0x1,%eax
  801e0c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0f:	83 c7 01             	add    $0x1,%edi
  801e12:	eb ac                	jmp    801dc0 <devpipe_write+0x1c>
	return i;
  801e14:	8b 45 10             	mov    0x10(%ebp),%eax
  801e17:	eb 05                	jmp    801e1e <devpipe_write+0x7a>
				return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    

00801e26 <devpipe_read>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	57                   	push   %edi
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	83 ec 18             	sub    $0x18,%esp
  801e2f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e32:	57                   	push   %edi
  801e33:	e8 0c f2 ff ff       	call   801044 <fd2data>
  801e38:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	be 00 00 00 00       	mov    $0x0,%esi
  801e42:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e45:	75 14                	jne    801e5b <devpipe_read+0x35>
	return i;
  801e47:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4a:	eb 02                	jmp    801e4e <devpipe_read+0x28>
				return i;
  801e4c:	89 f0                	mov    %esi,%eax
}
  801e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    
			sys_yield();
  801e56:	e8 c5 ee ff ff       	call   800d20 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e5b:	8b 03                	mov    (%ebx),%eax
  801e5d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e60:	75 18                	jne    801e7a <devpipe_read+0x54>
			if (i > 0)
  801e62:	85 f6                	test   %esi,%esi
  801e64:	75 e6                	jne    801e4c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e66:	89 da                	mov    %ebx,%edx
  801e68:	89 f8                	mov    %edi,%eax
  801e6a:	e8 d0 fe ff ff       	call   801d3f <_pipeisclosed>
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	74 e3                	je     801e56 <devpipe_read+0x30>
				return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	eb d4                	jmp    801e4e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e7a:	99                   	cltd   
  801e7b:	c1 ea 1b             	shr    $0x1b,%edx
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	83 e0 1f             	and    $0x1f,%eax
  801e83:	29 d0                	sub    %edx,%eax
  801e85:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e90:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e93:	83 c6 01             	add    $0x1,%esi
  801e96:	eb aa                	jmp    801e42 <devpipe_read+0x1c>

00801e98 <pipe>:
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
  801e9d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea3:	50                   	push   %eax
  801ea4:	e8 b2 f1 ff ff       	call   80105b <fd_alloc>
  801ea9:	89 c3                	mov    %eax,%ebx
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	0f 88 23 01 00 00    	js     801fd9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 07 04 00 00       	push   $0x407
  801ebe:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec1:	6a 00                	push   $0x0
  801ec3:	e8 77 ee ff ff       	call   800d3f <sys_page_alloc>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	0f 88 04 01 00 00    	js     801fd9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edb:	50                   	push   %eax
  801edc:	e8 7a f1 ff ff       	call   80105b <fd_alloc>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	0f 88 db 00 00 00    	js     801fc9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	68 07 04 00 00       	push   $0x407
  801ef6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef9:	6a 00                	push   $0x0
  801efb:	e8 3f ee ff ff       	call   800d3f <sys_page_alloc>
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	85 c0                	test   %eax,%eax
  801f07:	0f 88 bc 00 00 00    	js     801fc9 <pipe+0x131>
	va = fd2data(fd0);
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	ff 75 f4             	pushl  -0xc(%ebp)
  801f13:	e8 2c f1 ff ff       	call   801044 <fd2data>
  801f18:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1a:	83 c4 0c             	add    $0xc,%esp
  801f1d:	68 07 04 00 00       	push   $0x407
  801f22:	50                   	push   %eax
  801f23:	6a 00                	push   $0x0
  801f25:	e8 15 ee ff ff       	call   800d3f <sys_page_alloc>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	0f 88 82 00 00 00    	js     801fb9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3d:	e8 02 f1 ff ff       	call   801044 <fd2data>
  801f42:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f49:	50                   	push   %eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	56                   	push   %esi
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 2e ee ff ff       	call   800d82 <sys_page_map>
  801f54:	89 c3                	mov    %eax,%ebx
  801f56:	83 c4 20             	add    $0x20,%esp
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 4e                	js     801fab <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f74:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f79:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	ff 75 f4             	pushl  -0xc(%ebp)
  801f86:	e8 a9 f0 ff ff       	call   801034 <fd2num>
  801f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f90:	83 c4 04             	add    $0x4,%esp
  801f93:	ff 75 f0             	pushl  -0x10(%ebp)
  801f96:	e8 99 f0 ff ff       	call   801034 <fd2num>
  801f9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa9:	eb 2e                	jmp    801fd9 <pipe+0x141>
	sys_page_unmap(0, va);
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	56                   	push   %esi
  801faf:	6a 00                	push   $0x0
  801fb1:	e8 0e ee ff ff       	call   800dc4 <sys_page_unmap>
  801fb6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 fe ed ff ff       	call   800dc4 <sys_page_unmap>
  801fc6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fc9:	83 ec 08             	sub    $0x8,%esp
  801fcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcf:	6a 00                	push   $0x0
  801fd1:	e8 ee ed ff ff       	call   800dc4 <sys_page_unmap>
  801fd6:	83 c4 10             	add    $0x10,%esp
}
  801fd9:	89 d8                	mov    %ebx,%eax
  801fdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fde:	5b                   	pop    %ebx
  801fdf:	5e                   	pop    %esi
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    

00801fe2 <pipeisclosed>:
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	50                   	push   %eax
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	e8 b9 f0 ff ff       	call   8010ad <fd_lookup>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 18                	js     802013 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  802001:	e8 3e f0 ff ff       	call   801044 <fd2data>
	return _pipeisclosed(fd, p);
  802006:	89 c2                	mov    %eax,%edx
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	e8 2f fd ff ff       	call   801d3f <_pipeisclosed>
  802010:	83 c4 10             	add    $0x10,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	c3                   	ret    

0080201b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802021:	68 af 2a 80 00       	push   $0x802aaf
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	e8 1f e9 ff ff       	call   80094d <strcpy>
	return 0;
}
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <devcons_write>:
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	57                   	push   %edi
  802039:	56                   	push   %esi
  80203a:	53                   	push   %ebx
  80203b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802041:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802046:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80204c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80204f:	73 31                	jae    802082 <devcons_write+0x4d>
		m = n - tot;
  802051:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802054:	29 f3                	sub    %esi,%ebx
  802056:	83 fb 7f             	cmp    $0x7f,%ebx
  802059:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80205e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	53                   	push   %ebx
  802065:	89 f0                	mov    %esi,%eax
  802067:	03 45 0c             	add    0xc(%ebp),%eax
  80206a:	50                   	push   %eax
  80206b:	57                   	push   %edi
  80206c:	e8 6a ea ff ff       	call   800adb <memmove>
		sys_cputs(buf, m);
  802071:	83 c4 08             	add    $0x8,%esp
  802074:	53                   	push   %ebx
  802075:	57                   	push   %edi
  802076:	e8 08 ec ff ff       	call   800c83 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80207b:	01 de                	add    %ebx,%esi
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	eb ca                	jmp    80204c <devcons_write+0x17>
}
  802082:	89 f0                	mov    %esi,%eax
  802084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5f                   	pop    %edi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    

0080208c <devcons_read>:
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	83 ec 08             	sub    $0x8,%esp
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80209b:	74 21                	je     8020be <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80209d:	e8 ff eb ff ff       	call   800ca1 <sys_cgetc>
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 07                	jne    8020ad <devcons_read+0x21>
		sys_yield();
  8020a6:	e8 75 ec ff ff       	call   800d20 <sys_yield>
  8020ab:	eb f0                	jmp    80209d <devcons_read+0x11>
	if (c < 0)
  8020ad:	78 0f                	js     8020be <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020af:	83 f8 04             	cmp    $0x4,%eax
  8020b2:	74 0c                	je     8020c0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	88 02                	mov    %al,(%edx)
	return 1;
  8020b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    
		return 0;
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c5:	eb f7                	jmp    8020be <devcons_read+0x32>

008020c7 <cputchar>:
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d3:	6a 01                	push   $0x1
  8020d5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d8:	50                   	push   %eax
  8020d9:	e8 a5 eb ff ff       	call   800c83 <sys_cputs>
}
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <getchar>:
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e9:	6a 01                	push   $0x1
  8020eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ee:	50                   	push   %eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	e8 27 f2 ff ff       	call   80131d <read>
	if (r < 0)
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 06                	js     802103 <getchar+0x20>
	if (r < 1)
  8020fd:	74 06                	je     802105 <getchar+0x22>
	return c;
  8020ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    
		return -E_EOF;
  802105:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80210a:	eb f7                	jmp    802103 <getchar+0x20>

0080210c <iscons>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802112:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802115:	50                   	push   %eax
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	e8 8f ef ff ff       	call   8010ad <fd_lookup>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	85 c0                	test   %eax,%eax
  802123:	78 11                	js     802136 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212e:	39 10                	cmp    %edx,(%eax)
  802130:	0f 94 c0             	sete   %al
  802133:	0f b6 c0             	movzbl %al,%eax
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <opencons>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80213e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802141:	50                   	push   %eax
  802142:	e8 14 ef ff ff       	call   80105b <fd_alloc>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	85 c0                	test   %eax,%eax
  80214c:	78 3a                	js     802188 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80214e:	83 ec 04             	sub    $0x4,%esp
  802151:	68 07 04 00 00       	push   $0x407
  802156:	ff 75 f4             	pushl  -0xc(%ebp)
  802159:	6a 00                	push   $0x0
  80215b:	e8 df eb ff ff       	call   800d3f <sys_page_alloc>
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	85 c0                	test   %eax,%eax
  802165:	78 21                	js     802188 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802170:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	50                   	push   %eax
  802180:	e8 af ee ff ff       	call   801034 <fd2num>
  802185:	83 c4 10             	add    $0x10,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	56                   	push   %esi
  80218e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80218f:	a1 08 40 80 00       	mov    0x804008,%eax
  802194:	8b 40 48             	mov    0x48(%eax),%eax
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	68 e0 2a 80 00       	push   $0x802ae0
  80219f:	50                   	push   %eax
  8021a0:	68 d8 25 80 00       	push   $0x8025d8
  8021a5:	e8 44 e0 ff ff       	call   8001ee <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021ad:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021b3:	e8 49 eb ff ff       	call   800d01 <sys_getenvid>
  8021b8:	83 c4 04             	add    $0x4,%esp
  8021bb:	ff 75 0c             	pushl  0xc(%ebp)
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	56                   	push   %esi
  8021c2:	50                   	push   %eax
  8021c3:	68 bc 2a 80 00       	push   $0x802abc
  8021c8:	e8 21 e0 ff ff       	call   8001ee <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021cd:	83 c4 18             	add    $0x18,%esp
  8021d0:	53                   	push   %ebx
  8021d1:	ff 75 10             	pushl  0x10(%ebp)
  8021d4:	e8 c4 df ff ff       	call   80019d <vcprintf>
	cprintf("\n");
  8021d9:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021e0:	e8 09 e0 ff ff       	call   8001ee <cprintf>
  8021e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e8:	cc                   	int3   
  8021e9:	eb fd                	jmp    8021e8 <_panic+0x5e>

008021eb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021fb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802200:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	50                   	push   %eax
  802207:	e8 e3 ec ff ff       	call   800eef <sys_ipc_recv>
	if(ret < 0){
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 2b                	js     80223e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802213:	85 f6                	test   %esi,%esi
  802215:	74 0a                	je     802221 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802217:	a1 08 40 80 00       	mov    0x804008,%eax
  80221c:	8b 40 78             	mov    0x78(%eax),%eax
  80221f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802221:	85 db                	test   %ebx,%ebx
  802223:	74 0a                	je     80222f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802225:	a1 08 40 80 00       	mov    0x804008,%eax
  80222a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80222d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80222f:	a1 08 40 80 00       	mov    0x804008,%eax
  802234:	8b 40 74             	mov    0x74(%eax),%eax
}
  802237:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223a:	5b                   	pop    %ebx
  80223b:	5e                   	pop    %esi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
		if(from_env_store)
  80223e:	85 f6                	test   %esi,%esi
  802240:	74 06                	je     802248 <ipc_recv+0x5d>
			*from_env_store = 0;
  802242:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802248:	85 db                	test   %ebx,%ebx
  80224a:	74 eb                	je     802237 <ipc_recv+0x4c>
			*perm_store = 0;
  80224c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802252:	eb e3                	jmp    802237 <ipc_recv+0x4c>

00802254 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	57                   	push   %edi
  802258:	56                   	push   %esi
  802259:	53                   	push   %ebx
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802260:	8b 75 0c             	mov    0xc(%ebp),%esi
  802263:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802266:	85 db                	test   %ebx,%ebx
  802268:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226d:	0f 44 d8             	cmove  %eax,%ebx
  802270:	eb 05                	jmp    802277 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802272:	e8 a9 ea ff ff       	call   800d20 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802277:	ff 75 14             	pushl  0x14(%ebp)
  80227a:	53                   	push   %ebx
  80227b:	56                   	push   %esi
  80227c:	57                   	push   %edi
  80227d:	e8 4a ec ff ff       	call   800ecc <sys_ipc_try_send>
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	85 c0                	test   %eax,%eax
  802287:	74 1b                	je     8022a4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802289:	79 e7                	jns    802272 <ipc_send+0x1e>
  80228b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80228e:	74 e2                	je     802272 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 e7 2a 80 00       	push   $0x802ae7
  802298:	6a 46                	push   $0x46
  80229a:	68 fc 2a 80 00       	push   $0x802afc
  80229f:	e8 e6 fe ff ff       	call   80218a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    

008022ac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b7:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c3:	8b 52 50             	mov    0x50(%edx),%edx
  8022c6:	39 ca                	cmp    %ecx,%edx
  8022c8:	74 11                	je     8022db <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022ca:	83 c0 01             	add    $0x1,%eax
  8022cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022d2:	75 e3                	jne    8022b7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	eb 0e                	jmp    8022e9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022db:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022e6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f1:	89 d0                	mov    %edx,%eax
  8022f3:	c1 e8 16             	shr    $0x16,%eax
  8022f6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802302:	f6 c1 01             	test   $0x1,%cl
  802305:	74 1d                	je     802324 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802307:	c1 ea 0c             	shr    $0xc,%edx
  80230a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802311:	f6 c2 01             	test   $0x1,%dl
  802314:	74 0e                	je     802324 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802316:	c1 ea 0c             	shr    $0xc,%edx
  802319:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802320:	ef 
  802321:	0f b7 c0             	movzwl %ax,%eax
}
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	66 90                	xchg   %ax,%ax
  802328:	66 90                	xchg   %ax,%ax
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 4d                	jne    802398 <__udivdi3+0x68>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	76 19                	jbe    802368 <__udivdi3+0x38>
  80234f:	31 ff                	xor    %edi,%edi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f2                	mov    %esi,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 d9                	mov    %ebx,%ecx
  80236a:	85 db                	test   %ebx,%ebx
  80236c:	75 0b                	jne    802379 <__udivdi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	31 d2                	xor    %edx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	f7 f1                	div    %ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f7                	mov    %esi,%edi
  802385:	f7 f1                	div    %ecx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f2                	cmp    %esi,%edx
  80239a:	77 1c                	ja     8023b8 <__udivdi3+0x88>
  80239c:	0f bd fa             	bsr    %edx,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 2c                	jne    8023d0 <__udivdi3+0xa0>
  8023a4:	39 f2                	cmp    %esi,%edx
  8023a6:	72 06                	jb     8023ae <__udivdi3+0x7e>
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	39 eb                	cmp    %ebp,%ebx
  8023ac:	77 a9                	ja     802357 <__udivdi3+0x27>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb a2                	jmp    802357 <__udivdi3+0x27>
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 27 ff ff ff       	jmp    802357 <__udivdi3+0x27>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 1d ff ff ff       	jmp    802357 <__udivdi3+0x27>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802457:	89 da                	mov    %ebx,%edx
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 43                	jne    8024a0 <__umoddi3+0x60>
  80245d:	39 df                	cmp    %ebx,%edi
  80245f:	76 17                	jbe    802478 <__umoddi3+0x38>
  802461:	89 f0                	mov    %esi,%eax
  802463:	f7 f7                	div    %edi
  802465:	89 d0                	mov    %edx,%eax
  802467:	31 d2                	xor    %edx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 fd                	mov    %edi,%ebp
  80247a:	85 ff                	test   %edi,%edi
  80247c:	75 0b                	jne    802489 <__umoddi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f7                	div    %edi
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d8                	mov    %ebx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f5                	div    %ebp
  80248f:	89 f0                	mov    %esi,%eax
  802491:	f7 f5                	div    %ebp
  802493:	89 d0                	mov    %edx,%eax
  802495:	eb d0                	jmp    802467 <__umoddi3+0x27>
  802497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 f1                	mov    %esi,%ecx
  8024a2:	39 d8                	cmp    %ebx,%eax
  8024a4:	76 0a                	jbe    8024b0 <__umoddi3+0x70>
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	75 20                	jne    8024d8 <__umoddi3+0x98>
  8024b8:	39 d8                	cmp    %ebx,%eax
  8024ba:	0f 82 b0 00 00 00    	jb     802570 <__umoddi3+0x130>
  8024c0:	39 f7                	cmp    %esi,%edi
  8024c2:	0f 86 a8 00 00 00    	jbe    802570 <__umoddi3+0x130>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0xfb>
  802535:	75 10                	jne    802547 <__umoddi3+0x107>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x107>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 da                	mov    %ebx,%edx
  802572:	29 fe                	sub    %edi,%esi
  802574:	19 c2                	sbb    %eax,%edx
  802576:	89 f1                	mov    %esi,%ecx
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	e9 4b ff ff ff       	jmp    8024ca <__umoddi3+0x8a>
