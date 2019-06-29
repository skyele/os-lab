
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 20 28 80 00       	push   $0x802820
  80003e:	e8 e0 01 00 00       	call   800223 <cprintf>
	exit();
  800043:	e8 12 01 00 00       	call   80015a <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 fd 0f 00 00       	call   801069 <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 11 10 00 00       	call   801099 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 34 28 80 00       	push   $0x802834
  8000c2:	e8 5c 01 00 00       	call   800223 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 b9 15 00 00       	call   801695 <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 34 28 80 00       	push   $0x802834
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 c5 19 00 00       	call   801ac9 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80011c:	e8 15 0c 00 00       	call   800d36 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80012c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800131:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800136:	85 db                	test   %ebx,%ebx
  800138:	7e 07                	jle    800141 <libmain+0x30>
		binaryname = argv[0];
  80013a:	8b 06                	mov    (%esi),%eax
  80013c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	e8 02 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  80014b:	e8 0a 00 00 00       	call   80015a <exit>
}
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800160:	a1 08 40 80 00       	mov    0x804008,%eax
  800165:	8b 40 48             	mov    0x48(%eax),%eax
  800168:	68 74 28 80 00       	push   $0x802874
  80016d:	50                   	push   %eax
  80016e:	68 66 28 80 00       	push   $0x802866
  800173:	e8 ab 00 00 00       	call   800223 <cprintf>
	close_all();
  800178:	e8 11 12 00 00       	call   80138e <close_all>
	sys_env_destroy(0);
  80017d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800184:	e8 6c 0b 00 00       	call   800cf5 <sys_env_destroy>
}
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	53                   	push   %ebx
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800198:	8b 13                	mov    (%ebx),%edx
  80019a:	8d 42 01             	lea    0x1(%edx),%eax
  80019d:	89 03                	mov    %eax,(%ebx)
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	74 09                	je     8001b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 f1 0a 00 00       	call   800cb8 <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb db                	jmp    8001ad <putch+0x1f>

008001d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e2:	00 00 00 
	b.cnt = 0;
  8001e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ef:	ff 75 0c             	pushl  0xc(%ebp)
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	68 8e 01 80 00       	push   $0x80018e
  800201:	e8 4a 01 00 00       	call   800350 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800206:	83 c4 08             	add    $0x8,%esp
  800209:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 9d 0a 00 00       	call   800cb8 <sys_cputs>

	return b.cnt;
}
  80021b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800229:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 9d ff ff ff       	call   8001d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 1c             	sub    $0x1c,%esp
  800240:	89 c6                	mov    %eax,%esi
  800242:	89 d7                	mov    %edx,%edi
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800250:	8b 45 10             	mov    0x10(%ebp),%eax
  800253:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800256:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80025a:	74 2c                	je     800288 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80025c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800266:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800269:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80026c:	39 c2                	cmp    %eax,%edx
  80026e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800271:	73 43                	jae    8002b6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800273:	83 eb 01             	sub    $0x1,%ebx
  800276:	85 db                	test   %ebx,%ebx
  800278:	7e 6c                	jle    8002e6 <printnum+0xaf>
				putch(padc, putdat);
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	57                   	push   %edi
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	ff d6                	call   *%esi
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	eb eb                	jmp    800273 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	6a 20                	push   $0x20
  80028d:	6a 00                	push   $0x0
  80028f:	50                   	push   %eax
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	89 fa                	mov    %edi,%edx
  800298:	89 f0                	mov    %esi,%eax
  80029a:	e8 98 ff ff ff       	call   800237 <printnum>
		while (--width > 0)
  80029f:	83 c4 20             	add    $0x20,%esp
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	85 db                	test   %ebx,%ebx
  8002a7:	7e 65                	jle    80030e <printnum+0xd7>
			putch(padc, putdat);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	57                   	push   %edi
  8002ad:	6a 20                	push   $0x20
  8002af:	ff d6                	call   *%esi
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	eb ec                	jmp    8002a2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	ff 75 18             	pushl  0x18(%ebp)
  8002bc:	83 eb 01             	sub    $0x1,%ebx
  8002bf:	53                   	push   %ebx
  8002c0:	50                   	push   %eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d0:	e8 eb 22 00 00       	call   8025c0 <__udivdi3>
  8002d5:	83 c4 18             	add    $0x18,%esp
  8002d8:	52                   	push   %edx
  8002d9:	50                   	push   %eax
  8002da:	89 fa                	mov    %edi,%edx
  8002dc:	89 f0                	mov    %esi,%eax
  8002de:	e8 54 ff ff ff       	call   800237 <printnum>
  8002e3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002e6:	83 ec 08             	sub    $0x8,%esp
  8002e9:	57                   	push   %edi
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f9:	e8 d2 23 00 00       	call   8026d0 <__umoddi3>
  8002fe:	83 c4 14             	add    $0x14,%esp
  800301:	0f be 80 79 28 80 00 	movsbl 0x802879(%eax),%eax
  800308:	50                   	push   %eax
  800309:	ff d6                	call   *%esi
  80030b:	83 c4 10             	add    $0x10,%esp
	}
}
  80030e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5f                   	pop    %edi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80031c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800320:	8b 10                	mov    (%eax),%edx
  800322:	3b 50 04             	cmp    0x4(%eax),%edx
  800325:	73 0a                	jae    800331 <sprintputch+0x1b>
		*b->buf++ = ch;
  800327:	8d 4a 01             	lea    0x1(%edx),%ecx
  80032a:	89 08                	mov    %ecx,(%eax)
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	88 02                	mov    %al,(%edx)
}
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    

00800333 <printfmt>:
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800339:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033c:	50                   	push   %eax
  80033d:	ff 75 10             	pushl  0x10(%ebp)
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 05 00 00 00       	call   800350 <vprintfmt>
}
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <vprintfmt>:
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 3c             	sub    $0x3c,%esp
  800359:	8b 75 08             	mov    0x8(%ebp),%esi
  80035c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80035f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800362:	e9 32 04 00 00       	jmp    800799 <vprintfmt+0x449>
		padc = ' ';
  800367:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80036b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800372:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800379:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800380:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800387:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80038e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8d 47 01             	lea    0x1(%edi),%eax
  800396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800399:	0f b6 17             	movzbl (%edi),%edx
  80039c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80039f:	3c 55                	cmp    $0x55,%al
  8003a1:	0f 87 12 05 00 00    	ja     8008b9 <vprintfmt+0x569>
  8003a7:	0f b6 c0             	movzbl %al,%eax
  8003aa:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003b8:	eb d9                	jmp    800393 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003bd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003c1:	eb d0                	jmp    800393 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	0f b6 d2             	movzbl %dl,%edx
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d1:	eb 03                	jmp    8003d6 <vprintfmt+0x86>
  8003d3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003dd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003e3:	83 fe 09             	cmp    $0x9,%esi
  8003e6:	76 eb                	jbe    8003d3 <vprintfmt+0x83>
  8003e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ee:	eb 14                	jmp    800404 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 40 04             	lea    0x4(%eax),%eax
  8003fe:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800404:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800408:	79 89                	jns    800393 <vprintfmt+0x43>
				width = precision, precision = -1;
  80040a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800410:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800417:	e9 77 ff ff ff       	jmp    800393 <vprintfmt+0x43>
  80041c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 48 c1             	cmovs  %ecx,%eax
  800424:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042a:	e9 64 ff ff ff       	jmp    800393 <vprintfmt+0x43>
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800432:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800439:	e9 55 ff ff ff       	jmp    800393 <vprintfmt+0x43>
			lflag++;
  80043e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800445:	e9 49 ff ff ff       	jmp    800393 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80044a:	8b 45 14             	mov    0x14(%ebp),%eax
  80044d:	8d 78 04             	lea    0x4(%eax),%edi
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	53                   	push   %ebx
  800454:	ff 30                	pushl  (%eax)
  800456:	ff d6                	call   *%esi
			break;
  800458:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80045e:	e9 33 03 00 00       	jmp    800796 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 78 04             	lea    0x4(%eax),%edi
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	99                   	cltd   
  80046c:	31 d0                	xor    %edx,%eax
  80046e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800470:	83 f8 11             	cmp    $0x11,%eax
  800473:	7f 23                	jg     800498 <vprintfmt+0x148>
  800475:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  80047c:	85 d2                	test   %edx,%edx
  80047e:	74 18                	je     800498 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800480:	52                   	push   %edx
  800481:	68 dd 2c 80 00       	push   $0x802cdd
  800486:	53                   	push   %ebx
  800487:	56                   	push   %esi
  800488:	e8 a6 fe ff ff       	call   800333 <printfmt>
  80048d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800490:	89 7d 14             	mov    %edi,0x14(%ebp)
  800493:	e9 fe 02 00 00       	jmp    800796 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800498:	50                   	push   %eax
  800499:	68 91 28 80 00       	push   $0x802891
  80049e:	53                   	push   %ebx
  80049f:	56                   	push   %esi
  8004a0:	e8 8e fe ff ff       	call   800333 <printfmt>
  8004a5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ab:	e9 e6 02 00 00       	jmp    800796 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	83 c0 04             	add    $0x4,%eax
  8004b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004be:	85 c9                	test   %ecx,%ecx
  8004c0:	b8 8a 28 80 00       	mov    $0x80288a,%eax
  8004c5:	0f 45 c1             	cmovne %ecx,%eax
  8004c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cf:	7e 06                	jle    8004d7 <vprintfmt+0x187>
  8004d1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004d5:	75 0d                	jne    8004e4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	03 45 e0             	add    -0x20(%ebp),%eax
  8004df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e2:	eb 53                	jmp    800537 <vprintfmt+0x1e7>
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	e8 71 04 00 00       	call   800961 <strnlen>
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 c1                	sub    %eax,%ecx
  8004f5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004fd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800501:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	eb 0f                	jmp    800515 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	53                   	push   %ebx
  80050a:	ff 75 e0             	pushl  -0x20(%ebp)
  80050d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050f:	83 ef 01             	sub    $0x1,%edi
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	85 ff                	test   %edi,%edi
  800517:	7f ed                	jg     800506 <vprintfmt+0x1b6>
  800519:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80051c:	85 c9                	test   %ecx,%ecx
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	0f 49 c1             	cmovns %ecx,%eax
  800526:	29 c1                	sub    %eax,%ecx
  800528:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80052b:	eb aa                	jmp    8004d7 <vprintfmt+0x187>
					putch(ch, putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	52                   	push   %edx
  800532:	ff d6                	call   *%esi
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80053a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053c:	83 c7 01             	add    $0x1,%edi
  80053f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800543:	0f be d0             	movsbl %al,%edx
  800546:	85 d2                	test   %edx,%edx
  800548:	74 4b                	je     800595 <vprintfmt+0x245>
  80054a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054e:	78 06                	js     800556 <vprintfmt+0x206>
  800550:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800554:	78 1e                	js     800574 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800556:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80055a:	74 d1                	je     80052d <vprintfmt+0x1dd>
  80055c:	0f be c0             	movsbl %al,%eax
  80055f:	83 e8 20             	sub    $0x20,%eax
  800562:	83 f8 5e             	cmp    $0x5e,%eax
  800565:	76 c6                	jbe    80052d <vprintfmt+0x1dd>
					putch('?', putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	53                   	push   %ebx
  80056b:	6a 3f                	push   $0x3f
  80056d:	ff d6                	call   *%esi
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	eb c3                	jmp    800537 <vprintfmt+0x1e7>
  800574:	89 cf                	mov    %ecx,%edi
  800576:	eb 0e                	jmp    800586 <vprintfmt+0x236>
				putch(' ', putdat);
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	53                   	push   %ebx
  80057c:	6a 20                	push   $0x20
  80057e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800580:	83 ef 01             	sub    $0x1,%edi
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	85 ff                	test   %edi,%edi
  800588:	7f ee                	jg     800578 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80058a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	e9 01 02 00 00       	jmp    800796 <vprintfmt+0x446>
  800595:	89 cf                	mov    %ecx,%edi
  800597:	eb ed                	jmp    800586 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800599:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80059c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005a3:	e9 eb fd ff ff       	jmp    800393 <vprintfmt+0x43>
	if (lflag >= 2)
  8005a8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ac:	7f 21                	jg     8005cf <vprintfmt+0x27f>
	else if (lflag)
  8005ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005b2:	74 68                	je     80061c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005bc:	89 c1                	mov    %eax,%ecx
  8005be:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cd:	eb 17                	jmp    8005e6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 50 04             	mov    0x4(%eax),%edx
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 08             	lea    0x8(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f6:	78 3f                	js     800637 <vprintfmt+0x2e7>
			base = 10;
  8005f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005fd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800601:	0f 84 71 01 00 00    	je     800778 <vprintfmt+0x428>
				putch('+', putdat);
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	53                   	push   %ebx
  80060b:	6a 2b                	push   $0x2b
  80060d:	ff d6                	call   *%esi
  80060f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800612:	b8 0a 00 00 00       	mov    $0xa,%eax
  800617:	e9 5c 01 00 00       	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800624:	89 c1                	mov    %eax,%ecx
  800626:	c1 f9 1f             	sar    $0x1f,%ecx
  800629:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
  800635:	eb af                	jmp    8005e6 <vprintfmt+0x296>
				putch('-', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 2d                	push   $0x2d
  80063d:	ff d6                	call   *%esi
				num = -(long long) num;
  80063f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800642:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800645:	f7 d8                	neg    %eax
  800647:	83 d2 00             	adc    $0x0,%edx
  80064a:	f7 da                	neg    %edx
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	e9 19 01 00 00       	jmp    800778 <vprintfmt+0x428>
	if (lflag >= 2)
  80065f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800663:	7f 29                	jg     80068e <vprintfmt+0x33e>
	else if (lflag)
  800665:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800669:	74 44                	je     8006af <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	ba 00 00 00 00       	mov    $0x0,%edx
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800684:	b8 0a 00 00 00       	mov    $0xa,%eax
  800689:	e9 ea 00 00 00       	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 50 04             	mov    0x4(%eax),%edx
  800694:	8b 00                	mov    (%eax),%eax
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 08             	lea    0x8(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006aa:	e9 c9 00 00 00       	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cd:	e9 a6 00 00 00       	jmp    800778 <vprintfmt+0x428>
			putch('0', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 30                	push   $0x30
  8006d8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e1:	7f 26                	jg     800709 <vprintfmt+0x3b9>
	else if (lflag)
  8006e3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e7:	74 3e                	je     800727 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800702:	b8 08 00 00 00       	mov    $0x8,%eax
  800707:	eb 6f                	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 08             	lea    0x8(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800720:	b8 08 00 00 00       	mov    $0x8,%eax
  800725:	eb 51                	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	ba 00 00 00 00       	mov    $0x0,%edx
  800731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800740:	b8 08 00 00 00       	mov    $0x8,%eax
  800745:	eb 31                	jmp    800778 <vprintfmt+0x428>
			putch('0', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	6a 30                	push   $0x30
  80074d:	ff d6                	call   *%esi
			putch('x', putdat);
  80074f:	83 c4 08             	add    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	6a 78                	push   $0x78
  800755:	ff d6                	call   *%esi
			num = (unsigned long long)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	ba 00 00 00 00       	mov    $0x0,%edx
  800761:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800764:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800767:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 40 04             	lea    0x4(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800773:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800778:	83 ec 0c             	sub    $0xc,%esp
  80077b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80077f:	52                   	push   %edx
  800780:	ff 75 e0             	pushl  -0x20(%ebp)
  800783:	50                   	push   %eax
  800784:	ff 75 dc             	pushl  -0x24(%ebp)
  800787:	ff 75 d8             	pushl  -0x28(%ebp)
  80078a:	89 da                	mov    %ebx,%edx
  80078c:	89 f0                	mov    %esi,%eax
  80078e:	e8 a4 fa ff ff       	call   800237 <printnum>
			break;
  800793:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800796:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800799:	83 c7 01             	add    $0x1,%edi
  80079c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a0:	83 f8 25             	cmp    $0x25,%eax
  8007a3:	0f 84 be fb ff ff    	je     800367 <vprintfmt+0x17>
			if (ch == '\0')
  8007a9:	85 c0                	test   %eax,%eax
  8007ab:	0f 84 28 01 00 00    	je     8008d9 <vprintfmt+0x589>
			putch(ch, putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	50                   	push   %eax
  8007b6:	ff d6                	call   *%esi
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	eb dc                	jmp    800799 <vprintfmt+0x449>
	if (lflag >= 2)
  8007bd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c1:	7f 26                	jg     8007e9 <vprintfmt+0x499>
	else if (lflag)
  8007c3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c7:	74 41                	je     80080a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e7:	eb 8f                	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 50 04             	mov    0x4(%eax),%edx
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8d 40 08             	lea    0x8(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	b8 10 00 00 00       	mov    $0x10,%eax
  800805:	e9 6e ff ff ff       	jmp    800778 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800817:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8d 40 04             	lea    0x4(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800823:	b8 10 00 00 00       	mov    $0x10,%eax
  800828:	e9 4b ff ff ff       	jmp    800778 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	83 c0 04             	add    $0x4,%eax
  800833:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	85 c0                	test   %eax,%eax
  80083d:	74 14                	je     800853 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80083f:	8b 13                	mov    (%ebx),%edx
  800841:	83 fa 7f             	cmp    $0x7f,%edx
  800844:	7f 37                	jg     80087d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800846:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800848:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	e9 43 ff ff ff       	jmp    800796 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800853:	b8 0a 00 00 00       	mov    $0xa,%eax
  800858:	bf ad 29 80 00       	mov    $0x8029ad,%edi
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
  800870:	75 eb                	jne    80085d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800872:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
  800878:	e9 19 ff ff ff       	jmp    800796 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80087d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80087f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800884:	bf e5 29 80 00       	mov    $0x8029e5,%edi
							putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	50                   	push   %eax
  80088e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800890:	83 c7 01             	add    $0x1,%edi
  800893:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	85 c0                	test   %eax,%eax
  80089c:	75 eb                	jne    800889 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	e9 ed fe ff ff       	jmp    800796 <vprintfmt+0x446>
			putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 25                	push   $0x25
  8008af:	ff d6                	call   *%esi
			break;
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	e9 dd fe ff ff       	jmp    800796 <vprintfmt+0x446>
			putch('%', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 25                	push   $0x25
  8008bf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	89 f8                	mov    %edi,%eax
  8008c6:	eb 03                	jmp    8008cb <vprintfmt+0x57b>
  8008c8:	83 e8 01             	sub    $0x1,%eax
  8008cb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008cf:	75 f7                	jne    8008c8 <vprintfmt+0x578>
  8008d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d4:	e9 bd fe ff ff       	jmp    800796 <vprintfmt+0x446>
}
  8008d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008dc:	5b                   	pop    %ebx
  8008dd:	5e                   	pop    %esi
  8008de:	5f                   	pop    %edi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fe:	85 c0                	test   %eax,%eax
  800900:	74 26                	je     800928 <vsnprintf+0x47>
  800902:	85 d2                	test   %edx,%edx
  800904:	7e 22                	jle    800928 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800906:	ff 75 14             	pushl  0x14(%ebp)
  800909:	ff 75 10             	pushl  0x10(%ebp)
  80090c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090f:	50                   	push   %eax
  800910:	68 16 03 80 00       	push   $0x800316
  800915:	e8 36 fa ff ff       	call   800350 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800923:	83 c4 10             	add    $0x10,%esp
}
  800926:	c9                   	leave  
  800927:	c3                   	ret    
		return -E_INVAL;
  800928:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092d:	eb f7                	jmp    800926 <vsnprintf+0x45>

0080092f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800935:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800938:	50                   	push   %eax
  800939:	ff 75 10             	pushl  0x10(%ebp)
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 9a ff ff ff       	call   8008e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800958:	74 05                	je     80095f <strlen+0x16>
		n++;
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	eb f5                	jmp    800954 <strlen+0xb>
	return n;
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096a:	ba 00 00 00 00       	mov    $0x0,%edx
  80096f:	39 c2                	cmp    %eax,%edx
  800971:	74 0d                	je     800980 <strnlen+0x1f>
  800973:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800977:	74 05                	je     80097e <strnlen+0x1d>
		n++;
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	eb f1                	jmp    80096f <strnlen+0xe>
  80097e:	89 d0                	mov    %edx,%eax
	return n;
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	53                   	push   %ebx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800995:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	84 c9                	test   %cl,%cl
  80099d:	75 f2                	jne    800991 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80099f:	5b                   	pop    %ebx
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	83 ec 10             	sub    $0x10,%esp
  8009a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ac:	53                   	push   %ebx
  8009ad:	e8 97 ff ff ff       	call   800949 <strlen>
  8009b2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	01 d8                	add    %ebx,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 c2 ff ff ff       	call   800982 <strcpy>
	return dst;
}
  8009c0:	89 d8                	mov    %ebx,%eax
  8009c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	56                   	push   %esi
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d2:	89 c6                	mov    %eax,%esi
  8009d4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d7:	89 c2                	mov    %eax,%edx
  8009d9:	39 f2                	cmp    %esi,%edx
  8009db:	74 11                	je     8009ee <strncpy+0x27>
		*dst++ = *src;
  8009dd:	83 c2 01             	add    $0x1,%edx
  8009e0:	0f b6 19             	movzbl (%ecx),%ebx
  8009e3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e6:	80 fb 01             	cmp    $0x1,%bl
  8009e9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009ec:	eb eb                	jmp    8009d9 <strncpy+0x12>
	}
	return ret;
}
  8009ee:	5b                   	pop    %ebx
  8009ef:	5e                   	pop    %esi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fd:	8b 55 10             	mov    0x10(%ebp),%edx
  800a00:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a02:	85 d2                	test   %edx,%edx
  800a04:	74 21                	je     800a27 <strlcpy+0x35>
  800a06:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a0a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a0c:	39 c2                	cmp    %eax,%edx
  800a0e:	74 14                	je     800a24 <strlcpy+0x32>
  800a10:	0f b6 19             	movzbl (%ecx),%ebx
  800a13:	84 db                	test   %bl,%bl
  800a15:	74 0b                	je     800a22 <strlcpy+0x30>
			*dst++ = *src++;
  800a17:	83 c1 01             	add    $0x1,%ecx
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a20:	eb ea                	jmp    800a0c <strlcpy+0x1a>
  800a22:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a27:	29 f0                	sub    %esi,%eax
}
  800a29:	5b                   	pop    %ebx
  800a2a:	5e                   	pop    %esi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a36:	0f b6 01             	movzbl (%ecx),%eax
  800a39:	84 c0                	test   %al,%al
  800a3b:	74 0c                	je     800a49 <strcmp+0x1c>
  800a3d:	3a 02                	cmp    (%edx),%al
  800a3f:	75 08                	jne    800a49 <strcmp+0x1c>
		p++, q++;
  800a41:	83 c1 01             	add    $0x1,%ecx
  800a44:	83 c2 01             	add    $0x1,%edx
  800a47:	eb ed                	jmp    800a36 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a49:	0f b6 c0             	movzbl %al,%eax
  800a4c:	0f b6 12             	movzbl (%edx),%edx
  800a4f:	29 d0                	sub    %edx,%eax
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5d:	89 c3                	mov    %eax,%ebx
  800a5f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a62:	eb 06                	jmp    800a6a <strncmp+0x17>
		n--, p++, q++;
  800a64:	83 c0 01             	add    $0x1,%eax
  800a67:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a6a:	39 d8                	cmp    %ebx,%eax
  800a6c:	74 16                	je     800a84 <strncmp+0x31>
  800a6e:	0f b6 08             	movzbl (%eax),%ecx
  800a71:	84 c9                	test   %cl,%cl
  800a73:	74 04                	je     800a79 <strncmp+0x26>
  800a75:	3a 0a                	cmp    (%edx),%cl
  800a77:	74 eb                	je     800a64 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a79:	0f b6 00             	movzbl (%eax),%eax
  800a7c:	0f b6 12             	movzbl (%edx),%edx
  800a7f:	29 d0                	sub    %edx,%eax
}
  800a81:	5b                   	pop    %ebx
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    
		return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
  800a89:	eb f6                	jmp    800a81 <strncmp+0x2e>

00800a8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	0f b6 10             	movzbl (%eax),%edx
  800a98:	84 d2                	test   %dl,%dl
  800a9a:	74 09                	je     800aa5 <strchr+0x1a>
		if (*s == c)
  800a9c:	38 ca                	cmp    %cl,%dl
  800a9e:	74 0a                	je     800aaa <strchr+0x1f>
	for (; *s; s++)
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	eb f0                	jmp    800a95 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ab9:	38 ca                	cmp    %cl,%dl
  800abb:	74 09                	je     800ac6 <strfind+0x1a>
  800abd:	84 d2                	test   %dl,%dl
  800abf:	74 05                	je     800ac6 <strfind+0x1a>
	for (; *s; s++)
  800ac1:	83 c0 01             	add    $0x1,%eax
  800ac4:	eb f0                	jmp    800ab6 <strfind+0xa>
			break;
	return (char *) s;
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad4:	85 c9                	test   %ecx,%ecx
  800ad6:	74 31                	je     800b09 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad8:	89 f8                	mov    %edi,%eax
  800ada:	09 c8                	or     %ecx,%eax
  800adc:	a8 03                	test   $0x3,%al
  800ade:	75 23                	jne    800b03 <memset+0x3b>
		c &= 0xFF;
  800ae0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae4:	89 d3                	mov    %edx,%ebx
  800ae6:	c1 e3 08             	shl    $0x8,%ebx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	c1 e0 18             	shl    $0x18,%eax
  800aee:	89 d6                	mov    %edx,%esi
  800af0:	c1 e6 10             	shl    $0x10,%esi
  800af3:	09 f0                	or     %esi,%eax
  800af5:	09 c2                	or     %eax,%edx
  800af7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800af9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800afc:	89 d0                	mov    %edx,%eax
  800afe:	fc                   	cld    
  800aff:	f3 ab                	rep stos %eax,%es:(%edi)
  800b01:	eb 06                	jmp    800b09 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	fc                   	cld    
  800b07:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b09:	89 f8                	mov    %edi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	57                   	push   %edi
  800b14:	56                   	push   %esi
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b1e:	39 c6                	cmp    %eax,%esi
  800b20:	73 32                	jae    800b54 <memmove+0x44>
  800b22:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b25:	39 c2                	cmp    %eax,%edx
  800b27:	76 2b                	jbe    800b54 <memmove+0x44>
		s += n;
		d += n;
  800b29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2c:	89 fe                	mov    %edi,%esi
  800b2e:	09 ce                	or     %ecx,%esi
  800b30:	09 d6                	or     %edx,%esi
  800b32:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b38:	75 0e                	jne    800b48 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b3a:	83 ef 04             	sub    $0x4,%edi
  800b3d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b43:	fd                   	std    
  800b44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b46:	eb 09                	jmp    800b51 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b48:	83 ef 01             	sub    $0x1,%edi
  800b4b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b4e:	fd                   	std    
  800b4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b51:	fc                   	cld    
  800b52:	eb 1a                	jmp    800b6e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b54:	89 c2                	mov    %eax,%edx
  800b56:	09 ca                	or     %ecx,%edx
  800b58:	09 f2                	or     %esi,%edx
  800b5a:	f6 c2 03             	test   $0x3,%dl
  800b5d:	75 0a                	jne    800b69 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b62:	89 c7                	mov    %eax,%edi
  800b64:	fc                   	cld    
  800b65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b67:	eb 05                	jmp    800b6e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b69:	89 c7                	mov    %eax,%edi
  800b6b:	fc                   	cld    
  800b6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b78:	ff 75 10             	pushl  0x10(%ebp)
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 8a ff ff ff       	call   800b10 <memmove>
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 c6                	mov    %eax,%esi
  800b95:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b98:	39 f0                	cmp    %esi,%eax
  800b9a:	74 1c                	je     800bb8 <memcmp+0x30>
		if (*s1 != *s2)
  800b9c:	0f b6 08             	movzbl (%eax),%ecx
  800b9f:	0f b6 1a             	movzbl (%edx),%ebx
  800ba2:	38 d9                	cmp    %bl,%cl
  800ba4:	75 08                	jne    800bae <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	83 c2 01             	add    $0x1,%edx
  800bac:	eb ea                	jmp    800b98 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bae:	0f b6 c1             	movzbl %cl,%eax
  800bb1:	0f b6 db             	movzbl %bl,%ebx
  800bb4:	29 d8                	sub    %ebx,%eax
  800bb6:	eb 05                	jmp    800bbd <memcmp+0x35>
	}

	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bcf:	39 d0                	cmp    %edx,%eax
  800bd1:	73 09                	jae    800bdc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd3:	38 08                	cmp    %cl,(%eax)
  800bd5:	74 05                	je     800bdc <memfind+0x1b>
	for (; s < ends; s++)
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	eb f3                	jmp    800bcf <memfind+0xe>
			break;
	return (void *) s;
}
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bea:	eb 03                	jmp    800bef <strtol+0x11>
		s++;
  800bec:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bef:	0f b6 01             	movzbl (%ecx),%eax
  800bf2:	3c 20                	cmp    $0x20,%al
  800bf4:	74 f6                	je     800bec <strtol+0xe>
  800bf6:	3c 09                	cmp    $0x9,%al
  800bf8:	74 f2                	je     800bec <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bfa:	3c 2b                	cmp    $0x2b,%al
  800bfc:	74 2a                	je     800c28 <strtol+0x4a>
	int neg = 0;
  800bfe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c03:	3c 2d                	cmp    $0x2d,%al
  800c05:	74 2b                	je     800c32 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c07:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c0d:	75 0f                	jne    800c1e <strtol+0x40>
  800c0f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c12:	74 28                	je     800c3c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c14:	85 db                	test   %ebx,%ebx
  800c16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1b:	0f 44 d8             	cmove  %eax,%ebx
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c26:	eb 50                	jmp    800c78 <strtol+0x9a>
		s++;
  800c28:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c30:	eb d5                	jmp    800c07 <strtol+0x29>
		s++, neg = 1;
  800c32:	83 c1 01             	add    $0x1,%ecx
  800c35:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3a:	eb cb                	jmp    800c07 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c40:	74 0e                	je     800c50 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c42:	85 db                	test   %ebx,%ebx
  800c44:	75 d8                	jne    800c1e <strtol+0x40>
		s++, base = 8;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c4e:	eb ce                	jmp    800c1e <strtol+0x40>
		s += 2, base = 16;
  800c50:	83 c1 02             	add    $0x2,%ecx
  800c53:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c58:	eb c4                	jmp    800c1e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c5a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c5d:	89 f3                	mov    %esi,%ebx
  800c5f:	80 fb 19             	cmp    $0x19,%bl
  800c62:	77 29                	ja     800c8d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c64:	0f be d2             	movsbl %dl,%edx
  800c67:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c6a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c6d:	7d 30                	jge    800c9f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c6f:	83 c1 01             	add    $0x1,%ecx
  800c72:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c76:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c78:	0f b6 11             	movzbl (%ecx),%edx
  800c7b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c7e:	89 f3                	mov    %esi,%ebx
  800c80:	80 fb 09             	cmp    $0x9,%bl
  800c83:	77 d5                	ja     800c5a <strtol+0x7c>
			dig = *s - '0';
  800c85:	0f be d2             	movsbl %dl,%edx
  800c88:	83 ea 30             	sub    $0x30,%edx
  800c8b:	eb dd                	jmp    800c6a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c8d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c90:	89 f3                	mov    %esi,%ebx
  800c92:	80 fb 19             	cmp    $0x19,%bl
  800c95:	77 08                	ja     800c9f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c97:	0f be d2             	movsbl %dl,%edx
  800c9a:	83 ea 37             	sub    $0x37,%edx
  800c9d:	eb cb                	jmp    800c6a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca3:	74 05                	je     800caa <strtol+0xcc>
		*endptr = (char *) s;
  800ca5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800caa:	89 c2                	mov    %eax,%edx
  800cac:	f7 da                	neg    %edx
  800cae:	85 ff                	test   %edi,%edi
  800cb0:	0f 45 c2             	cmovne %edx,%eax
}
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	89 c3                	mov    %eax,%ebx
  800ccb:	89 c7                	mov    %eax,%edi
  800ccd:	89 c6                	mov    %eax,%esi
  800ccf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce6:	89 d1                	mov    %edx,%ecx
  800ce8:	89 d3                	mov    %edx,%ebx
  800cea:	89 d7                	mov    %edx,%edi
  800cec:	89 d6                	mov    %edx,%esi
  800cee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0b:	89 cb                	mov    %ecx,%ebx
  800d0d:	89 cf                	mov    %ecx,%edi
  800d0f:	89 ce                	mov    %ecx,%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 03                	push   $0x3
  800d25:	68 08 2c 80 00       	push   $0x802c08
  800d2a:	6a 43                	push   $0x43
  800d2c:	68 25 2c 80 00       	push   $0x802c25
  800d31:	e8 ea 16 00 00       	call   802420 <_panic>

00800d36 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 02 00 00 00       	mov    $0x2,%eax
  800d46:	89 d1                	mov    %edx,%ecx
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	89 d7                	mov    %edx,%edi
  800d4c:	89 d6                	mov    %edx,%esi
  800d4e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_yield>:

void
sys_yield(void)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7d:	be 00 00 00 00       	mov    $0x0,%esi
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d88:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d90:	89 f7                	mov    %esi,%edi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 04                	push   $0x4
  800da6:	68 08 2c 80 00       	push   $0x802c08
  800dab:	6a 43                	push   $0x43
  800dad:	68 25 2c 80 00       	push   $0x802c25
  800db2:	e8 69 16 00 00       	call   802420 <_panic>

00800db7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 05 00 00 00       	mov    $0x5,%eax
  800dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 05                	push   $0x5
  800de8:	68 08 2c 80 00       	push   $0x802c08
  800ded:	6a 43                	push   $0x43
  800def:	68 25 2c 80 00       	push   $0x802c25
  800df4:	e8 27 16 00 00       	call   802420 <_panic>

00800df9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e12:	89 df                	mov    %ebx,%edi
  800e14:	89 de                	mov    %ebx,%esi
  800e16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7f 08                	jg     800e24 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e24:	83 ec 0c             	sub    $0xc,%esp
  800e27:	50                   	push   %eax
  800e28:	6a 06                	push   $0x6
  800e2a:	68 08 2c 80 00       	push   $0x802c08
  800e2f:	6a 43                	push   $0x43
  800e31:	68 25 2c 80 00       	push   $0x802c25
  800e36:	e8 e5 15 00 00       	call   802420 <_panic>

00800e3b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7f 08                	jg     800e66 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	50                   	push   %eax
  800e6a:	6a 08                	push   $0x8
  800e6c:	68 08 2c 80 00       	push   $0x802c08
  800e71:	6a 43                	push   $0x43
  800e73:	68 25 2c 80 00       	push   $0x802c25
  800e78:	e8 a3 15 00 00       	call   802420 <_panic>

00800e7d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	b8 09 00 00 00       	mov    $0x9,%eax
  800e96:	89 df                	mov    %ebx,%edi
  800e98:	89 de                	mov    %ebx,%esi
  800e9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7f 08                	jg     800ea8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5f                   	pop    %edi
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	50                   	push   %eax
  800eac:	6a 09                	push   $0x9
  800eae:	68 08 2c 80 00       	push   $0x802c08
  800eb3:	6a 43                	push   $0x43
  800eb5:	68 25 2c 80 00       	push   $0x802c25
  800eba:	e8 61 15 00 00       	call   802420 <_panic>

00800ebf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
  800ec5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed8:	89 df                	mov    %ebx,%edi
  800eda:	89 de                	mov    %ebx,%esi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 0a                	push   $0xa
  800ef0:	68 08 2c 80 00       	push   $0x802c08
  800ef5:	6a 43                	push   $0x43
  800ef7:	68 25 2c 80 00       	push   $0x802c25
  800efc:	e8 1f 15 00 00       	call   802420 <_panic>

00800f01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f12:	be 00 00 00 00       	mov    $0x0,%esi
  800f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    

00800f24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3a:	89 cb                	mov    %ecx,%ebx
  800f3c:	89 cf                	mov    %ecx,%edi
  800f3e:	89 ce                	mov    %ecx,%esi
  800f40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7f 08                	jg     800f4e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4e:	83 ec 0c             	sub    $0xc,%esp
  800f51:	50                   	push   %eax
  800f52:	6a 0d                	push   $0xd
  800f54:	68 08 2c 80 00       	push   $0x802c08
  800f59:	6a 43                	push   $0x43
  800f5b:	68 25 2c 80 00       	push   $0x802c25
  800f60:	e8 bb 14 00 00       	call   802420 <_panic>

00800f65 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7b:	89 df                	mov    %ebx,%edi
  800f7d:	89 de                	mov    %ebx,%esi
  800f7f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f99:	89 cb                	mov    %ecx,%ebx
  800f9b:	89 cf                	mov    %ecx,%edi
  800f9d:	89 ce                	mov    %ecx,%esi
  800f9f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fac:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb1:	b8 10 00 00 00       	mov    $0x10,%eax
  800fb6:	89 d1                	mov    %edx,%ecx
  800fb8:	89 d3                	mov    %edx,%ebx
  800fba:	89 d7                	mov    %edx,%edi
  800fbc:	89 d6                	mov    %edx,%esi
  800fbe:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	b8 11 00 00 00       	mov    $0x11,%eax
  800fdb:	89 df                	mov    %ebx,%edi
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff7:	b8 12 00 00 00       	mov    $0x12,%eax
  800ffc:	89 df                	mov    %ebx,%edi
  800ffe:	89 de                	mov    %ebx,%esi
  801000:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801010:	bb 00 00 00 00       	mov    $0x0,%ebx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	b8 13 00 00 00       	mov    $0x13,%eax
  801020:	89 df                	mov    %ebx,%edi
  801022:	89 de                	mov    %ebx,%esi
  801024:	cd 30                	int    $0x30
	if(check && ret > 0)
  801026:	85 c0                	test   %eax,%eax
  801028:	7f 08                	jg     801032 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	50                   	push   %eax
  801036:	6a 13                	push   $0x13
  801038:	68 08 2c 80 00       	push   $0x802c08
  80103d:	6a 43                	push   $0x43
  80103f:	68 25 2c 80 00       	push   $0x802c25
  801044:	e8 d7 13 00 00       	call   802420 <_panic>

00801049 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	b8 14 00 00 00       	mov    $0x14,%eax
  80105c:	89 cb                	mov    %ecx,%ebx
  80105e:	89 cf                	mov    %ecx,%edi
  801060:	89 ce                	mov    %ecx,%esi
  801062:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801075:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801077:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80107a:	83 3a 01             	cmpl   $0x1,(%edx)
  80107d:	7e 09                	jle    801088 <argstart+0x1f>
  80107f:	ba 9b 2d 80 00       	mov    $0x802d9b,%edx
  801084:	85 c9                	test   %ecx,%ecx
  801086:	75 05                	jne    80108d <argstart+0x24>
  801088:	ba 00 00 00 00       	mov    $0x0,%edx
  80108d:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801090:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <argnext>:

int
argnext(struct Argstate *args)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	53                   	push   %ebx
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010a3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010aa:	8b 43 08             	mov    0x8(%ebx),%eax
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	74 72                	je     801123 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8010b1:	80 38 00             	cmpb   $0x0,(%eax)
  8010b4:	75 48                	jne    8010fe <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010b6:	8b 0b                	mov    (%ebx),%ecx
  8010b8:	83 39 01             	cmpl   $0x1,(%ecx)
  8010bb:	74 58                	je     801115 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8010bd:	8b 53 04             	mov    0x4(%ebx),%edx
  8010c0:	8b 42 04             	mov    0x4(%edx),%eax
  8010c3:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010c6:	75 4d                	jne    801115 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8010c8:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010cc:	74 47                	je     801115 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8010ce:	83 c0 01             	add    $0x1,%eax
  8010d1:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010d4:	83 ec 04             	sub    $0x4,%esp
  8010d7:	8b 01                	mov    (%ecx),%eax
  8010d9:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010e0:	50                   	push   %eax
  8010e1:	8d 42 08             	lea    0x8(%edx),%eax
  8010e4:	50                   	push   %eax
  8010e5:	83 c2 04             	add    $0x4,%edx
  8010e8:	52                   	push   %edx
  8010e9:	e8 22 fa ff ff       	call   800b10 <memmove>
		(*args->argc)--;
  8010ee:	8b 03                	mov    (%ebx),%eax
  8010f0:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010f3:	8b 43 08             	mov    0x8(%ebx),%eax
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010fc:	74 11                	je     80110f <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8010fe:	8b 53 08             	mov    0x8(%ebx),%edx
  801101:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801104:	83 c2 01             	add    $0x1,%edx
  801107:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80110a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80110f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801113:	75 e9                	jne    8010fe <argnext+0x65>
	args->curarg = 0;
  801115:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80111c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801121:	eb e7                	jmp    80110a <argnext+0x71>
		return -1;
  801123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801128:	eb e0                	jmp    80110a <argnext+0x71>

0080112a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801134:	8b 43 08             	mov    0x8(%ebx),%eax
  801137:	85 c0                	test   %eax,%eax
  801139:	74 12                	je     80114d <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  80113b:	80 38 00             	cmpb   $0x0,(%eax)
  80113e:	74 12                	je     801152 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801140:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801143:	c7 43 08 9b 2d 80 00 	movl   $0x802d9b,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80114a:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80114d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801150:	c9                   	leave  
  801151:	c3                   	ret    
	} else if (*args->argc > 1) {
  801152:	8b 13                	mov    (%ebx),%edx
  801154:	83 3a 01             	cmpl   $0x1,(%edx)
  801157:	7f 10                	jg     801169 <argnextvalue+0x3f>
		args->argvalue = 0;
  801159:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801160:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801167:	eb e1                	jmp    80114a <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801169:	8b 43 04             	mov    0x4(%ebx),%eax
  80116c:	8b 48 04             	mov    0x4(%eax),%ecx
  80116f:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801172:	83 ec 04             	sub    $0x4,%esp
  801175:	8b 12                	mov    (%edx),%edx
  801177:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80117e:	52                   	push   %edx
  80117f:	8d 50 08             	lea    0x8(%eax),%edx
  801182:	52                   	push   %edx
  801183:	83 c0 04             	add    $0x4,%eax
  801186:	50                   	push   %eax
  801187:	e8 84 f9 ff ff       	call   800b10 <memmove>
		(*args->argc)--;
  80118c:	8b 03                	mov    (%ebx),%eax
  80118e:	83 28 01             	subl   $0x1,(%eax)
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	eb b4                	jmp    80114a <argnextvalue+0x20>

00801196 <argvalue>:
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80119f:	8b 42 0c             	mov    0xc(%edx),%eax
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	74 02                	je     8011a8 <argvalue+0x12>
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	52                   	push   %edx
  8011ac:	e8 79 ff ff ff       	call   80112a <argnextvalue>
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	eb f0                	jmp    8011a6 <argvalue+0x10>

008011b6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	c1 ea 16             	shr    $0x16,%edx
  8011ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f1:	f6 c2 01             	test   $0x1,%dl
  8011f4:	74 2d                	je     801223 <fd_alloc+0x46>
  8011f6:	89 c2                	mov    %eax,%edx
  8011f8:	c1 ea 0c             	shr    $0xc,%edx
  8011fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801202:	f6 c2 01             	test   $0x1,%dl
  801205:	74 1c                	je     801223 <fd_alloc+0x46>
  801207:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80120c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801211:	75 d2                	jne    8011e5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80121c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801221:	eb 0a                	jmp    80122d <fd_alloc+0x50>
			*fd_store = fd;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	89 01                	mov    %eax,(%ecx)
			return 0;
  801228:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801235:	83 f8 1f             	cmp    $0x1f,%eax
  801238:	77 30                	ja     80126a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80123a:	c1 e0 0c             	shl    $0xc,%eax
  80123d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801242:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801248:	f6 c2 01             	test   $0x1,%dl
  80124b:	74 24                	je     801271 <fd_lookup+0x42>
  80124d:	89 c2                	mov    %eax,%edx
  80124f:	c1 ea 0c             	shr    $0xc,%edx
  801252:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801259:	f6 c2 01             	test   $0x1,%dl
  80125c:	74 1a                	je     801278 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80125e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801261:	89 02                	mov    %eax,(%edx)
	return 0;
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    
		return -E_INVAL;
  80126a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126f:	eb f7                	jmp    801268 <fd_lookup+0x39>
		return -E_INVAL;
  801271:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801276:	eb f0                	jmp    801268 <fd_lookup+0x39>
  801278:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127d:	eb e9                	jmp    801268 <fd_lookup+0x39>

0080127f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801288:	ba 00 00 00 00       	mov    $0x0,%edx
  80128d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801292:	39 08                	cmp    %ecx,(%eax)
  801294:	74 38                	je     8012ce <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801296:	83 c2 01             	add    $0x1,%edx
  801299:	8b 04 95 b0 2c 80 00 	mov    0x802cb0(,%edx,4),%eax
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	75 ee                	jne    801292 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a9:	8b 40 48             	mov    0x48(%eax),%eax
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	51                   	push   %ecx
  8012b0:	50                   	push   %eax
  8012b1:	68 34 2c 80 00       	push   $0x802c34
  8012b6:	e8 68 ef ff ff       	call   800223 <cprintf>
	*dev = 0;
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    
			*dev = devtab[i];
  8012ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d8:	eb f2                	jmp    8012cc <dev_lookup+0x4d>

008012da <fd_close>:
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	57                   	push   %edi
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
  8012e0:	83 ec 24             	sub    $0x24,%esp
  8012e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012f3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f6:	50                   	push   %eax
  8012f7:	e8 33 ff ff ff       	call   80122f <fd_lookup>
  8012fc:	89 c3                	mov    %eax,%ebx
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 05                	js     80130a <fd_close+0x30>
	    || fd != fd2)
  801305:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801308:	74 16                	je     801320 <fd_close+0x46>
		return (must_exist ? r : 0);
  80130a:	89 f8                	mov    %edi,%eax
  80130c:	84 c0                	test   %al,%al
  80130e:	b8 00 00 00 00       	mov    $0x0,%eax
  801313:	0f 44 d8             	cmove  %eax,%ebx
}
  801316:	89 d8                	mov    %ebx,%eax
  801318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131b:	5b                   	pop    %ebx
  80131c:	5e                   	pop    %esi
  80131d:	5f                   	pop    %edi
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801326:	50                   	push   %eax
  801327:	ff 36                	pushl  (%esi)
  801329:	e8 51 ff ff ff       	call   80127f <dev_lookup>
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 1a                	js     801351 <fd_close+0x77>
		if (dev->dev_close)
  801337:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80133a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80133d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801342:	85 c0                	test   %eax,%eax
  801344:	74 0b                	je     801351 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	56                   	push   %esi
  80134a:	ff d0                	call   *%eax
  80134c:	89 c3                	mov    %eax,%ebx
  80134e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	56                   	push   %esi
  801355:	6a 00                	push   $0x0
  801357:	e8 9d fa ff ff       	call   800df9 <sys_page_unmap>
	return r;
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	eb b5                	jmp    801316 <fd_close+0x3c>

00801361 <close>:

int
close(int fdnum)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801367:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	e8 bc fe ff ff       	call   80122f <fd_lookup>
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	79 02                	jns    80137c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    
		return fd_close(fd, 1);
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	6a 01                	push   $0x1
  801381:	ff 75 f4             	pushl  -0xc(%ebp)
  801384:	e8 51 ff ff ff       	call   8012da <fd_close>
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	eb ec                	jmp    80137a <close+0x19>

0080138e <close_all>:

void
close_all(void)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801395:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	53                   	push   %ebx
  80139e:	e8 be ff ff ff       	call   801361 <close>
	for (i = 0; i < MAXFD; i++)
  8013a3:	83 c3 01             	add    $0x1,%ebx
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	83 fb 20             	cmp    $0x20,%ebx
  8013ac:	75 ec                	jne    80139a <close_all+0xc>
}
  8013ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 75 08             	pushl  0x8(%ebp)
  8013c3:	e8 67 fe ff ff       	call   80122f <fd_lookup>
  8013c8:	89 c3                	mov    %eax,%ebx
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	0f 88 81 00 00 00    	js     801456 <dup+0xa3>
		return r;
	close(newfdnum);
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	ff 75 0c             	pushl  0xc(%ebp)
  8013db:	e8 81 ff ff ff       	call   801361 <close>

	newfd = INDEX2FD(newfdnum);
  8013e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013e3:	c1 e6 0c             	shl    $0xc,%esi
  8013e6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013ec:	83 c4 04             	add    $0x4,%esp
  8013ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013f2:	e8 cf fd ff ff       	call   8011c6 <fd2data>
  8013f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013f9:	89 34 24             	mov    %esi,(%esp)
  8013fc:	e8 c5 fd ff ff       	call   8011c6 <fd2data>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801406:	89 d8                	mov    %ebx,%eax
  801408:	c1 e8 16             	shr    $0x16,%eax
  80140b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801412:	a8 01                	test   $0x1,%al
  801414:	74 11                	je     801427 <dup+0x74>
  801416:	89 d8                	mov    %ebx,%eax
  801418:	c1 e8 0c             	shr    $0xc,%eax
  80141b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801422:	f6 c2 01             	test   $0x1,%dl
  801425:	75 39                	jne    801460 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801427:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80142a:	89 d0                	mov    %edx,%eax
  80142c:	c1 e8 0c             	shr    $0xc,%eax
  80142f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	25 07 0e 00 00       	and    $0xe07,%eax
  80143e:	50                   	push   %eax
  80143f:	56                   	push   %esi
  801440:	6a 00                	push   $0x0
  801442:	52                   	push   %edx
  801443:	6a 00                	push   $0x0
  801445:	e8 6d f9 ff ff       	call   800db7 <sys_page_map>
  80144a:	89 c3                	mov    %eax,%ebx
  80144c:	83 c4 20             	add    $0x20,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 31                	js     801484 <dup+0xd1>
		goto err;

	return newfdnum;
  801453:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801456:	89 d8                	mov    %ebx,%eax
  801458:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145b:	5b                   	pop    %ebx
  80145c:	5e                   	pop    %esi
  80145d:	5f                   	pop    %edi
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801460:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	25 07 0e 00 00       	and    $0xe07,%eax
  80146f:	50                   	push   %eax
  801470:	57                   	push   %edi
  801471:	6a 00                	push   $0x0
  801473:	53                   	push   %ebx
  801474:	6a 00                	push   $0x0
  801476:	e8 3c f9 ff ff       	call   800db7 <sys_page_map>
  80147b:	89 c3                	mov    %eax,%ebx
  80147d:	83 c4 20             	add    $0x20,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	79 a3                	jns    801427 <dup+0x74>
	sys_page_unmap(0, newfd);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	56                   	push   %esi
  801488:	6a 00                	push   $0x0
  80148a:	e8 6a f9 ff ff       	call   800df9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80148f:	83 c4 08             	add    $0x8,%esp
  801492:	57                   	push   %edi
  801493:	6a 00                	push   $0x0
  801495:	e8 5f f9 ff ff       	call   800df9 <sys_page_unmap>
	return r;
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	eb b7                	jmp    801456 <dup+0xa3>

0080149f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 1c             	sub    $0x1c,%esp
  8014a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ac:	50                   	push   %eax
  8014ad:	53                   	push   %ebx
  8014ae:	e8 7c fd ff ff       	call   80122f <fd_lookup>
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 3f                	js     8014f9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	ff 30                	pushl  (%eax)
  8014c6:	e8 b4 fd ff ff       	call   80127f <dev_lookup>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 27                	js     8014f9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d5:	8b 42 08             	mov    0x8(%edx),%eax
  8014d8:	83 e0 03             	and    $0x3,%eax
  8014db:	83 f8 01             	cmp    $0x1,%eax
  8014de:	74 1e                	je     8014fe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e3:	8b 40 08             	mov    0x8(%eax),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	74 35                	je     80151f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	ff 75 10             	pushl  0x10(%ebp)
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	52                   	push   %edx
  8014f4:	ff d0                	call   *%eax
  8014f6:	83 c4 10             	add    $0x10,%esp
}
  8014f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014fe:	a1 08 40 80 00       	mov    0x804008,%eax
  801503:	8b 40 48             	mov    0x48(%eax),%eax
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	53                   	push   %ebx
  80150a:	50                   	push   %eax
  80150b:	68 75 2c 80 00       	push   $0x802c75
  801510:	e8 0e ed ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151d:	eb da                	jmp    8014f9 <read+0x5a>
		return -E_NOT_SUPP;
  80151f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801524:	eb d3                	jmp    8014f9 <read+0x5a>

00801526 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801532:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153a:	39 f3                	cmp    %esi,%ebx
  80153c:	73 23                	jae    801561 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	89 f0                	mov    %esi,%eax
  801543:	29 d8                	sub    %ebx,%eax
  801545:	50                   	push   %eax
  801546:	89 d8                	mov    %ebx,%eax
  801548:	03 45 0c             	add    0xc(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	57                   	push   %edi
  80154d:	e8 4d ff ff ff       	call   80149f <read>
		if (m < 0)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 06                	js     80155f <readn+0x39>
			return m;
		if (m == 0)
  801559:	74 06                	je     801561 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80155b:	01 c3                	add    %eax,%ebx
  80155d:	eb db                	jmp    80153a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80155f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801561:	89 d8                	mov    %ebx,%eax
  801563:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801566:	5b                   	pop    %ebx
  801567:	5e                   	pop    %esi
  801568:	5f                   	pop    %edi
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	53                   	push   %ebx
  80156f:	83 ec 1c             	sub    $0x1c,%esp
  801572:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801575:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	53                   	push   %ebx
  80157a:	e8 b0 fc ff ff       	call   80122f <fd_lookup>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	78 3a                	js     8015c0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	ff 30                	pushl  (%eax)
  801592:	e8 e8 fc ff ff       	call   80127f <dev_lookup>
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 22                	js     8015c0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a5:	74 1e                	je     8015c5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ad:	85 d2                	test   %edx,%edx
  8015af:	74 35                	je     8015e6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	ff 75 10             	pushl  0x10(%ebp)
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	50                   	push   %eax
  8015bb:	ff d2                	call   *%edx
  8015bd:	83 c4 10             	add    $0x10,%esp
}
  8015c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8015ca:	8b 40 48             	mov    0x48(%eax),%eax
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	53                   	push   %ebx
  8015d1:	50                   	push   %eax
  8015d2:	68 91 2c 80 00       	push   $0x802c91
  8015d7:	e8 47 ec ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e4:	eb da                	jmp    8015c0 <write+0x55>
		return -E_NOT_SUPP;
  8015e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015eb:	eb d3                	jmp    8015c0 <write+0x55>

008015ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	e8 30 fc ff ff       	call   80122f <fd_lookup>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 0e                	js     801614 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801606:	8b 55 0c             	mov    0xc(%ebp),%edx
  801609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 1c             	sub    $0x1c,%esp
  80161d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	53                   	push   %ebx
  801625:	e8 05 fc ff ff       	call   80122f <fd_lookup>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 37                	js     801668 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	ff 30                	pushl  (%eax)
  80163d:	e8 3d fc ff ff       	call   80127f <dev_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 1f                	js     801668 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801650:	74 1b                	je     80166d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801655:	8b 52 18             	mov    0x18(%edx),%edx
  801658:	85 d2                	test   %edx,%edx
  80165a:	74 32                	je     80168e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	50                   	push   %eax
  801663:	ff d2                	call   *%edx
  801665:	83 c4 10             	add    $0x10,%esp
}
  801668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80166d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801672:	8b 40 48             	mov    0x48(%eax),%eax
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	53                   	push   %ebx
  801679:	50                   	push   %eax
  80167a:	68 54 2c 80 00       	push   $0x802c54
  80167f:	e8 9f eb ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168c:	eb da                	jmp    801668 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80168e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801693:	eb d3                	jmp    801668 <ftruncate+0x52>

00801695 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	53                   	push   %ebx
  801699:	83 ec 1c             	sub    $0x1c,%esp
  80169c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a2:	50                   	push   %eax
  8016a3:	ff 75 08             	pushl  0x8(%ebp)
  8016a6:	e8 84 fb ff ff       	call   80122f <fd_lookup>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 4b                	js     8016fd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b8:	50                   	push   %eax
  8016b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bc:	ff 30                	pushl  (%eax)
  8016be:	e8 bc fb ff ff       	call   80127f <dev_lookup>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	78 33                	js     8016fd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016d1:	74 2f                	je     801702 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016d3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016dd:	00 00 00 
	stat->st_isdir = 0;
  8016e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016e7:	00 00 00 
	stat->st_dev = dev;
  8016ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	53                   	push   %ebx
  8016f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f7:	ff 50 14             	call   *0x14(%eax)
  8016fa:	83 c4 10             	add    $0x10,%esp
}
  8016fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801700:	c9                   	leave  
  801701:	c3                   	ret    
		return -E_NOT_SUPP;
  801702:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801707:	eb f4                	jmp    8016fd <fstat+0x68>

00801709 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	6a 00                	push   $0x0
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	e8 22 02 00 00       	call   80193d <open>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	78 1b                	js     80173f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	50                   	push   %eax
  80172b:	e8 65 ff ff ff       	call   801695 <fstat>
  801730:	89 c6                	mov    %eax,%esi
	close(fd);
  801732:	89 1c 24             	mov    %ebx,(%esp)
  801735:	e8 27 fc ff ff       	call   801361 <close>
	return r;
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	89 f3                	mov    %esi,%ebx
}
  80173f:	89 d8                	mov    %ebx,%eax
  801741:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801744:	5b                   	pop    %ebx
  801745:	5e                   	pop    %esi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	89 c6                	mov    %eax,%esi
  80174f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801751:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801758:	74 27                	je     801781 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80175a:	6a 07                	push   $0x7
  80175c:	68 00 50 80 00       	push   $0x805000
  801761:	56                   	push   %esi
  801762:	ff 35 00 40 80 00    	pushl  0x804000
  801768:	e8 7d 0d 00 00       	call   8024ea <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80176d:	83 c4 0c             	add    $0xc,%esp
  801770:	6a 00                	push   $0x0
  801772:	53                   	push   %ebx
  801773:	6a 00                	push   $0x0
  801775:	e8 07 0d 00 00       	call   802481 <ipc_recv>
}
  80177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	6a 01                	push   $0x1
  801786:	e8 b7 0d 00 00       	call   802542 <ipc_find_env>
  80178b:	a3 00 40 80 00       	mov    %eax,0x804000
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	eb c5                	jmp    80175a <fsipc+0x12>

00801795 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	b8 02 00 00 00       	mov    $0x2,%eax
  8017b8:	e8 8b ff ff ff       	call   801748 <fsipc>
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <devfile_flush>:
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017da:	e8 69 ff ff ff       	call   801748 <fsipc>
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <devfile_stat>:
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fb:	b8 05 00 00 00       	mov    $0x5,%eax
  801800:	e8 43 ff ff ff       	call   801748 <fsipc>
  801805:	85 c0                	test   %eax,%eax
  801807:	78 2c                	js     801835 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	68 00 50 80 00       	push   $0x805000
  801811:	53                   	push   %ebx
  801812:	e8 6b f1 ff ff       	call   800982 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801817:	a1 80 50 80 00       	mov    0x805080,%eax
  80181c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801822:	a1 84 50 80 00       	mov    0x805084,%eax
  801827:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <devfile_write>:
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	53                   	push   %ebx
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8b 40 0c             	mov    0xc(%eax),%eax
  80184a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80184f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801855:	53                   	push   %ebx
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	68 08 50 80 00       	push   $0x805008
  80185e:	e8 0f f3 ff ff       	call   800b72 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801863:	ba 00 00 00 00       	mov    $0x0,%edx
  801868:	b8 04 00 00 00       	mov    $0x4,%eax
  80186d:	e8 d6 fe ff ff       	call   801748 <fsipc>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	85 c0                	test   %eax,%eax
  801877:	78 0b                	js     801884 <devfile_write+0x4a>
	assert(r <= n);
  801879:	39 d8                	cmp    %ebx,%eax
  80187b:	77 0c                	ja     801889 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80187d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801882:	7f 1e                	jg     8018a2 <devfile_write+0x68>
}
  801884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801887:	c9                   	leave  
  801888:	c3                   	ret    
	assert(r <= n);
  801889:	68 c4 2c 80 00       	push   $0x802cc4
  80188e:	68 cb 2c 80 00       	push   $0x802ccb
  801893:	68 98 00 00 00       	push   $0x98
  801898:	68 e0 2c 80 00       	push   $0x802ce0
  80189d:	e8 7e 0b 00 00       	call   802420 <_panic>
	assert(r <= PGSIZE);
  8018a2:	68 eb 2c 80 00       	push   $0x802ceb
  8018a7:	68 cb 2c 80 00       	push   $0x802ccb
  8018ac:	68 99 00 00 00       	push   $0x99
  8018b1:	68 e0 2c 80 00       	push   $0x802ce0
  8018b6:	e8 65 0b 00 00       	call   802420 <_panic>

008018bb <devfile_read>:
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8018de:	e8 65 fe ff ff       	call   801748 <fsipc>
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 1f                	js     801908 <devfile_read+0x4d>
	assert(r <= n);
  8018e9:	39 f0                	cmp    %esi,%eax
  8018eb:	77 24                	ja     801911 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f2:	7f 33                	jg     801927 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	50                   	push   %eax
  8018f8:	68 00 50 80 00       	push   $0x805000
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	e8 0b f2 ff ff       	call   800b10 <memmove>
	return r;
  801905:	83 c4 10             	add    $0x10,%esp
}
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    
	assert(r <= n);
  801911:	68 c4 2c 80 00       	push   $0x802cc4
  801916:	68 cb 2c 80 00       	push   $0x802ccb
  80191b:	6a 7c                	push   $0x7c
  80191d:	68 e0 2c 80 00       	push   $0x802ce0
  801922:	e8 f9 0a 00 00       	call   802420 <_panic>
	assert(r <= PGSIZE);
  801927:	68 eb 2c 80 00       	push   $0x802ceb
  80192c:	68 cb 2c 80 00       	push   $0x802ccb
  801931:	6a 7d                	push   $0x7d
  801933:	68 e0 2c 80 00       	push   $0x802ce0
  801938:	e8 e3 0a 00 00       	call   802420 <_panic>

0080193d <open>:
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 1c             	sub    $0x1c,%esp
  801945:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801948:	56                   	push   %esi
  801949:	e8 fb ef ff ff       	call   800949 <strlen>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801956:	7f 6c                	jg     8019c4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195e:	50                   	push   %eax
  80195f:	e8 79 f8 ff ff       	call   8011dd <fd_alloc>
  801964:	89 c3                	mov    %eax,%ebx
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 3c                	js     8019a9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	56                   	push   %esi
  801971:	68 00 50 80 00       	push   $0x805000
  801976:	e8 07 f0 ff ff       	call   800982 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80197b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
  80198b:	e8 b8 fd ff ff       	call   801748 <fsipc>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	85 c0                	test   %eax,%eax
  801997:	78 19                	js     8019b2 <open+0x75>
	return fd2num(fd);
  801999:	83 ec 0c             	sub    $0xc,%esp
  80199c:	ff 75 f4             	pushl  -0xc(%ebp)
  80199f:	e8 12 f8 ff ff       	call   8011b6 <fd2num>
  8019a4:	89 c3                	mov    %eax,%ebx
  8019a6:	83 c4 10             	add    $0x10,%esp
}
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    
		fd_close(fd, 0);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ba:	e8 1b f9 ff ff       	call   8012da <fd_close>
		return r;
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	eb e5                	jmp    8019a9 <open+0x6c>
		return -E_BAD_PATH;
  8019c4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c9:	eb de                	jmp    8019a9 <open+0x6c>

008019cb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8019db:	e8 68 fd ff ff       	call   801748 <fsipc>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019e2:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019e6:	7f 01                	jg     8019e9 <writebuf+0x7>
  8019e8:	c3                   	ret    
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	53                   	push   %ebx
  8019ed:	83 ec 08             	sub    $0x8,%esp
  8019f0:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019f2:	ff 70 04             	pushl  0x4(%eax)
  8019f5:	8d 40 10             	lea    0x10(%eax),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 33                	pushl  (%ebx)
  8019fb:	e8 6b fb ff ff       	call   80156b <write>
		if (result > 0)
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	7e 03                	jle    801a0a <writebuf+0x28>
			b->result += result;
  801a07:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a0a:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a0d:	74 0d                	je     801a1c <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	0f 4f c2             	cmovg  %edx,%eax
  801a19:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <putch>:

static void
putch(int ch, void *thunk)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a2b:	8b 53 04             	mov    0x4(%ebx),%edx
  801a2e:	8d 42 01             	lea    0x1(%edx),%eax
  801a31:	89 43 04             	mov    %eax,0x4(%ebx)
  801a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a37:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a3b:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a40:	74 06                	je     801a48 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a42:	83 c4 04             	add    $0x4,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
		writebuf(b);
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	e8 93 ff ff ff       	call   8019e2 <writebuf>
		b->idx = 0;
  801a4f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a56:	eb ea                	jmp    801a42 <putch+0x21>

00801a58 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a6a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a71:	00 00 00 
	b.result = 0;
  801a74:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a7b:	00 00 00 
	b.error = 1;
  801a7e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a85:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a88:	ff 75 10             	pushl  0x10(%ebp)
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	68 21 1a 80 00       	push   $0x801a21
  801a9a:	e8 b1 e8 ff ff       	call   800350 <vprintfmt>
	if (b.idx > 0)
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801aa9:	7f 11                	jg     801abc <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801aab:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    
		writebuf(&b);
  801abc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ac2:	e8 1b ff ff ff       	call   8019e2 <writebuf>
  801ac7:	eb e2                	jmp    801aab <vfprintf+0x53>

00801ac9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801acf:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ad2:	50                   	push   %eax
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	e8 7a ff ff ff       	call   801a58 <vfprintf>
	va_end(ap);

	return cnt;
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <printf>:

int
printf(const char *fmt, ...)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ae6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ae9:	50                   	push   %eax
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 01                	push   $0x1
  801aef:	e8 64 ff ff ff       	call   801a58 <vfprintf>
	va_end(ap);

	return cnt;
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801afc:	68 f7 2c 80 00       	push   $0x802cf7
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	e8 79 ee ff ff       	call   800982 <strcpy>
	return 0;
}
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <devsock_close>:
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	53                   	push   %ebx
  801b14:	83 ec 10             	sub    $0x10,%esp
  801b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b1a:	53                   	push   %ebx
  801b1b:	e8 61 0a 00 00       	call   802581 <pageref>
  801b20:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b23:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b28:	83 f8 01             	cmp    $0x1,%eax
  801b2b:	74 07                	je     801b34 <devsock_close+0x24>
}
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 73 0c             	pushl  0xc(%ebx)
  801b3a:	e8 b9 02 00 00       	call   801df8 <nsipc_close>
  801b3f:	89 c2                	mov    %eax,%edx
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	eb e7                	jmp    801b2d <devsock_close+0x1d>

00801b46 <devsock_write>:
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	ff 75 10             	pushl  0x10(%ebp)
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	ff 70 0c             	pushl  0xc(%eax)
  801b5a:	e8 76 03 00 00       	call   801ed5 <nsipc_send>
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <devsock_read>:
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	ff 70 0c             	pushl  0xc(%eax)
  801b75:	e8 ef 02 00 00       	call   801e69 <nsipc_recv>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <fd2sockid>:
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b82:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	e8 a3 f6 ff ff       	call   80122f <fd_lookup>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 10                	js     801ba3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b9c:	39 08                	cmp    %ecx,(%eax)
  801b9e:	75 05                	jne    801ba5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ba0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ba5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801baa:	eb f7                	jmp    801ba3 <fd2sockid+0x27>

00801bac <alloc_sockfd>:
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	56                   	push   %esi
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 1c             	sub    $0x1c,%esp
  801bb4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb9:	50                   	push   %eax
  801bba:	e8 1e f6 ff ff       	call   8011dd <fd_alloc>
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 43                	js     801c0b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	68 07 04 00 00       	push   $0x407
  801bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd3:	6a 00                	push   $0x0
  801bd5:	e8 9a f1 ff ff       	call   800d74 <sys_page_alloc>
  801bda:	89 c3                	mov    %eax,%ebx
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 28                	js     801c0b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bf8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bfb:	83 ec 0c             	sub    $0xc,%esp
  801bfe:	50                   	push   %eax
  801bff:	e8 b2 f5 ff ff       	call   8011b6 <fd2num>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	eb 0c                	jmp    801c17 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	56                   	push   %esi
  801c0f:	e8 e4 01 00 00       	call   801df8 <nsipc_close>
		return r;
  801c14:	83 c4 10             	add    $0x10,%esp
}
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <accept>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	e8 4e ff ff ff       	call   801b7c <fd2sockid>
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 1b                	js     801c4d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	ff 75 10             	pushl  0x10(%ebp)
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	e8 0e 01 00 00       	call   801d4f <nsipc_accept>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 05                	js     801c4d <accept+0x2d>
	return alloc_sockfd(r);
  801c48:	e8 5f ff ff ff       	call   801bac <alloc_sockfd>
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <bind>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	e8 1f ff ff ff       	call   801b7c <fd2sockid>
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	78 12                	js     801c73 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	ff 75 10             	pushl  0x10(%ebp)
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	50                   	push   %eax
  801c6b:	e8 31 01 00 00       	call   801da1 <nsipc_bind>
  801c70:	83 c4 10             	add    $0x10,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <shutdown>:
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	e8 f9 fe ff ff       	call   801b7c <fd2sockid>
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 0f                	js     801c96 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c87:	83 ec 08             	sub    $0x8,%esp
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	50                   	push   %eax
  801c8e:	e8 43 01 00 00       	call   801dd6 <nsipc_shutdown>
  801c93:	83 c4 10             	add    $0x10,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <connect>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	e8 d6 fe ff ff       	call   801b7c <fd2sockid>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	78 12                	js     801cbc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	50                   	push   %eax
  801cb4:	e8 59 01 00 00       	call   801e12 <nsipc_connect>
  801cb9:	83 c4 10             	add    $0x10,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <listen>:
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	e8 b0 fe ff ff       	call   801b7c <fd2sockid>
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	78 0f                	js     801cdf <listen+0x21>
	return nsipc_listen(r, backlog);
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	50                   	push   %eax
  801cd7:	e8 6b 01 00 00       	call   801e47 <nsipc_listen>
  801cdc:	83 c4 10             	add    $0x10,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ce7:	ff 75 10             	pushl  0x10(%ebp)
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	e8 3e 02 00 00       	call   801f33 <nsipc_socket>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 05                	js     801d01 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cfc:	e8 ab fe ff ff       	call   801bac <alloc_sockfd>
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	53                   	push   %ebx
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d0c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d13:	74 26                	je     801d3b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d15:	6a 07                	push   $0x7
  801d17:	68 00 60 80 00       	push   $0x806000
  801d1c:	53                   	push   %ebx
  801d1d:	ff 35 04 40 80 00    	pushl  0x804004
  801d23:	e8 c2 07 00 00       	call   8024ea <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d28:	83 c4 0c             	add    $0xc,%esp
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	e8 4b 07 00 00       	call   802481 <ipc_recv>
}
  801d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d3b:	83 ec 0c             	sub    $0xc,%esp
  801d3e:	6a 02                	push   $0x2
  801d40:	e8 fd 07 00 00       	call   802542 <ipc_find_env>
  801d45:	a3 04 40 80 00       	mov    %eax,0x804004
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	eb c6                	jmp    801d15 <nsipc+0x12>

00801d4f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d5f:	8b 06                	mov    (%esi),%eax
  801d61:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	e8 93 ff ff ff       	call   801d03 <nsipc>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	85 c0                	test   %eax,%eax
  801d74:	79 09                	jns    801d7f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d76:	89 d8                	mov    %ebx,%eax
  801d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	ff 35 10 60 80 00    	pushl  0x806010
  801d88:	68 00 60 80 00       	push   $0x806000
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	e8 7b ed ff ff       	call   800b10 <memmove>
		*addrlen = ret->ret_addrlen;
  801d95:	a1 10 60 80 00       	mov    0x806010,%eax
  801d9a:	89 06                	mov    %eax,(%esi)
  801d9c:	83 c4 10             	add    $0x10,%esp
	return r;
  801d9f:	eb d5                	jmp    801d76 <nsipc_accept+0x27>

00801da1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	53                   	push   %ebx
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801db3:	53                   	push   %ebx
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	68 04 60 80 00       	push   $0x806004
  801dbc:	e8 4f ed ff ff       	call   800b10 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dc1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801dc7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dcc:	e8 32 ff ff ff       	call   801d03 <nsipc>
}
  801dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801dec:	b8 03 00 00 00       	mov    $0x3,%eax
  801df1:	e8 0d ff ff ff       	call   801d03 <nsipc>
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <nsipc_close>:

int
nsipc_close(int s)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e06:	b8 04 00 00 00       	mov    $0x4,%eax
  801e0b:	e8 f3 fe ff ff       	call   801d03 <nsipc>
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	53                   	push   %ebx
  801e16:	83 ec 08             	sub    $0x8,%esp
  801e19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e24:	53                   	push   %ebx
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	68 04 60 80 00       	push   $0x806004
  801e2d:	e8 de ec ff ff       	call   800b10 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e32:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e38:	b8 05 00 00 00       	mov    $0x5,%eax
  801e3d:	e8 c1 fe ff ff       	call   801d03 <nsipc>
}
  801e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e5d:	b8 06 00 00 00       	mov    $0x6,%eax
  801e62:	e8 9c fe ff ff       	call   801d03 <nsipc>
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e79:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e82:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e87:	b8 07 00 00 00       	mov    $0x7,%eax
  801e8c:	e8 72 fe ff ff       	call   801d03 <nsipc>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	85 c0                	test   %eax,%eax
  801e95:	78 1f                	js     801eb6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e97:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e9c:	7f 21                	jg     801ebf <nsipc_recv+0x56>
  801e9e:	39 c6                	cmp    %eax,%esi
  801ea0:	7c 1d                	jl     801ebf <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	50                   	push   %eax
  801ea6:	68 00 60 80 00       	push   $0x806000
  801eab:	ff 75 0c             	pushl  0xc(%ebp)
  801eae:	e8 5d ec ff ff       	call   800b10 <memmove>
  801eb3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801eb6:	89 d8                	mov    %ebx,%eax
  801eb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5d                   	pop    %ebp
  801ebe:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ebf:	68 03 2d 80 00       	push   $0x802d03
  801ec4:	68 cb 2c 80 00       	push   $0x802ccb
  801ec9:	6a 62                	push   $0x62
  801ecb:	68 18 2d 80 00       	push   $0x802d18
  801ed0:	e8 4b 05 00 00       	call   802420 <_panic>

00801ed5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	53                   	push   %ebx
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ee7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801eed:	7f 2e                	jg     801f1d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	53                   	push   %ebx
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	68 0c 60 80 00       	push   $0x80600c
  801efb:	e8 10 ec ff ff       	call   800b10 <memmove>
	nsipcbuf.send.req_size = size;
  801f00:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f06:	8b 45 14             	mov    0x14(%ebp),%eax
  801f09:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f0e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f13:	e8 eb fd ff ff       	call   801d03 <nsipc>
}
  801f18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    
	assert(size < 1600);
  801f1d:	68 24 2d 80 00       	push   $0x802d24
  801f22:	68 cb 2c 80 00       	push   $0x802ccb
  801f27:	6a 6d                	push   $0x6d
  801f29:	68 18 2d 80 00       	push   $0x802d18
  801f2e:	e8 ed 04 00 00       	call   802420 <_panic>

00801f33 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f49:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f51:	b8 09 00 00 00       	mov    $0x9,%eax
  801f56:	e8 a8 fd ff ff       	call   801d03 <nsipc>
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	ff 75 08             	pushl  0x8(%ebp)
  801f6b:	e8 56 f2 ff ff       	call   8011c6 <fd2data>
  801f70:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f72:	83 c4 08             	add    $0x8,%esp
  801f75:	68 30 2d 80 00       	push   $0x802d30
  801f7a:	53                   	push   %ebx
  801f7b:	e8 02 ea ff ff       	call   800982 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f80:	8b 46 04             	mov    0x4(%esi),%eax
  801f83:	2b 06                	sub    (%esi),%eax
  801f85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f92:	00 00 00 
	stat->st_dev = &devpipe;
  801f95:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f9c:	30 80 00 
	return 0;
}
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	53                   	push   %ebx
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fb5:	53                   	push   %ebx
  801fb6:	6a 00                	push   $0x0
  801fb8:	e8 3c ee ff ff       	call   800df9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fbd:	89 1c 24             	mov    %ebx,(%esp)
  801fc0:	e8 01 f2 ff ff       	call   8011c6 <fd2data>
  801fc5:	83 c4 08             	add    $0x8,%esp
  801fc8:	50                   	push   %eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 29 ee ff ff       	call   800df9 <sys_page_unmap>
}
  801fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <_pipeisclosed>:
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	57                   	push   %edi
  801fd9:	56                   	push   %esi
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 1c             	sub    $0x1c,%esp
  801fde:	89 c7                	mov    %eax,%edi
  801fe0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fe2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	57                   	push   %edi
  801fee:	e8 8e 05 00 00       	call   802581 <pageref>
  801ff3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ff6:	89 34 24             	mov    %esi,(%esp)
  801ff9:	e8 83 05 00 00       	call   802581 <pageref>
		nn = thisenv->env_runs;
  801ffe:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802004:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	39 cb                	cmp    %ecx,%ebx
  80200c:	74 1b                	je     802029 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80200e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802011:	75 cf                	jne    801fe2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802013:	8b 42 58             	mov    0x58(%edx),%eax
  802016:	6a 01                	push   $0x1
  802018:	50                   	push   %eax
  802019:	53                   	push   %ebx
  80201a:	68 37 2d 80 00       	push   $0x802d37
  80201f:	e8 ff e1 ff ff       	call   800223 <cprintf>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	eb b9                	jmp    801fe2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802029:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80202c:	0f 94 c0             	sete   %al
  80202f:	0f b6 c0             	movzbl %al,%eax
}
  802032:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <devpipe_write>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	57                   	push   %edi
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 28             	sub    $0x28,%esp
  802043:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802046:	56                   	push   %esi
  802047:	e8 7a f1 ff ff       	call   8011c6 <fd2data>
  80204c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	bf 00 00 00 00       	mov    $0x0,%edi
  802056:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802059:	74 4f                	je     8020aa <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80205b:	8b 43 04             	mov    0x4(%ebx),%eax
  80205e:	8b 0b                	mov    (%ebx),%ecx
  802060:	8d 51 20             	lea    0x20(%ecx),%edx
  802063:	39 d0                	cmp    %edx,%eax
  802065:	72 14                	jb     80207b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802067:	89 da                	mov    %ebx,%edx
  802069:	89 f0                	mov    %esi,%eax
  80206b:	e8 65 ff ff ff       	call   801fd5 <_pipeisclosed>
  802070:	85 c0                	test   %eax,%eax
  802072:	75 3b                	jne    8020af <devpipe_write+0x75>
			sys_yield();
  802074:	e8 dc ec ff ff       	call   800d55 <sys_yield>
  802079:	eb e0                	jmp    80205b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80207b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80207e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802082:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802085:	89 c2                	mov    %eax,%edx
  802087:	c1 fa 1f             	sar    $0x1f,%edx
  80208a:	89 d1                	mov    %edx,%ecx
  80208c:	c1 e9 1b             	shr    $0x1b,%ecx
  80208f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802092:	83 e2 1f             	and    $0x1f,%edx
  802095:	29 ca                	sub    %ecx,%edx
  802097:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80209b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80209f:	83 c0 01             	add    $0x1,%eax
  8020a2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020a5:	83 c7 01             	add    $0x1,%edi
  8020a8:	eb ac                	jmp    802056 <devpipe_write+0x1c>
	return i;
  8020aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ad:	eb 05                	jmp    8020b4 <devpipe_write+0x7a>
				return 0;
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    

008020bc <devpipe_read>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	57                   	push   %edi
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	83 ec 18             	sub    $0x18,%esp
  8020c5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020c8:	57                   	push   %edi
  8020c9:	e8 f8 f0 ff ff       	call   8011c6 <fd2data>
  8020ce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	be 00 00 00 00       	mov    $0x0,%esi
  8020d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020db:	75 14                	jne    8020f1 <devpipe_read+0x35>
	return i;
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	eb 02                	jmp    8020e4 <devpipe_read+0x28>
				return i;
  8020e2:	89 f0                	mov    %esi,%eax
}
  8020e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
			sys_yield();
  8020ec:	e8 64 ec ff ff       	call   800d55 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020f1:	8b 03                	mov    (%ebx),%eax
  8020f3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020f6:	75 18                	jne    802110 <devpipe_read+0x54>
			if (i > 0)
  8020f8:	85 f6                	test   %esi,%esi
  8020fa:	75 e6                	jne    8020e2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	89 f8                	mov    %edi,%eax
  802100:	e8 d0 fe ff ff       	call   801fd5 <_pipeisclosed>
  802105:	85 c0                	test   %eax,%eax
  802107:	74 e3                	je     8020ec <devpipe_read+0x30>
				return 0;
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
  80210e:	eb d4                	jmp    8020e4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802110:	99                   	cltd   
  802111:	c1 ea 1b             	shr    $0x1b,%edx
  802114:	01 d0                	add    %edx,%eax
  802116:	83 e0 1f             	and    $0x1f,%eax
  802119:	29 d0                	sub    %edx,%eax
  80211b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802123:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802126:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802129:	83 c6 01             	add    $0x1,%esi
  80212c:	eb aa                	jmp    8020d8 <devpipe_read+0x1c>

0080212e <pipe>:
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802136:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802139:	50                   	push   %eax
  80213a:	e8 9e f0 ff ff       	call   8011dd <fd_alloc>
  80213f:	89 c3                	mov    %eax,%ebx
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 88 23 01 00 00    	js     80226f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	68 07 04 00 00       	push   $0x407
  802154:	ff 75 f4             	pushl  -0xc(%ebp)
  802157:	6a 00                	push   $0x0
  802159:	e8 16 ec ff ff       	call   800d74 <sys_page_alloc>
  80215e:	89 c3                	mov    %eax,%ebx
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	85 c0                	test   %eax,%eax
  802165:	0f 88 04 01 00 00    	js     80226f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802171:	50                   	push   %eax
  802172:	e8 66 f0 ff ff       	call   8011dd <fd_alloc>
  802177:	89 c3                	mov    %eax,%ebx
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 88 db 00 00 00    	js     80225f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	68 07 04 00 00       	push   $0x407
  80218c:	ff 75 f0             	pushl  -0x10(%ebp)
  80218f:	6a 00                	push   $0x0
  802191:	e8 de eb ff ff       	call   800d74 <sys_page_alloc>
  802196:	89 c3                	mov    %eax,%ebx
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	85 c0                	test   %eax,%eax
  80219d:	0f 88 bc 00 00 00    	js     80225f <pipe+0x131>
	va = fd2data(fd0);
  8021a3:	83 ec 0c             	sub    $0xc,%esp
  8021a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a9:	e8 18 f0 ff ff       	call   8011c6 <fd2data>
  8021ae:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021b0:	83 c4 0c             	add    $0xc,%esp
  8021b3:	68 07 04 00 00       	push   $0x407
  8021b8:	50                   	push   %eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	e8 b4 eb ff ff       	call   800d74 <sys_page_alloc>
  8021c0:	89 c3                	mov    %eax,%ebx
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	0f 88 82 00 00 00    	js     80224f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d3:	e8 ee ef ff ff       	call   8011c6 <fd2data>
  8021d8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021df:	50                   	push   %eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	56                   	push   %esi
  8021e3:	6a 00                	push   $0x0
  8021e5:	e8 cd eb ff ff       	call   800db7 <sys_page_map>
  8021ea:	89 c3                	mov    %eax,%ebx
  8021ec:	83 c4 20             	add    $0x20,%esp
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 4e                	js     802241 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8021f3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802200:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	ff 75 f4             	pushl  -0xc(%ebp)
  80221c:	e8 95 ef ff ff       	call   8011b6 <fd2num>
  802221:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802224:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802226:	83 c4 04             	add    $0x4,%esp
  802229:	ff 75 f0             	pushl  -0x10(%ebp)
  80222c:	e8 85 ef ff ff       	call   8011b6 <fd2num>
  802231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802234:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80223f:	eb 2e                	jmp    80226f <pipe+0x141>
	sys_page_unmap(0, va);
  802241:	83 ec 08             	sub    $0x8,%esp
  802244:	56                   	push   %esi
  802245:	6a 00                	push   $0x0
  802247:	e8 ad eb ff ff       	call   800df9 <sys_page_unmap>
  80224c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80224f:	83 ec 08             	sub    $0x8,%esp
  802252:	ff 75 f0             	pushl  -0x10(%ebp)
  802255:	6a 00                	push   $0x0
  802257:	e8 9d eb ff ff       	call   800df9 <sys_page_unmap>
  80225c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80225f:	83 ec 08             	sub    $0x8,%esp
  802262:	ff 75 f4             	pushl  -0xc(%ebp)
  802265:	6a 00                	push   $0x0
  802267:	e8 8d eb ff ff       	call   800df9 <sys_page_unmap>
  80226c:	83 c4 10             	add    $0x10,%esp
}
  80226f:	89 d8                	mov    %ebx,%eax
  802271:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    

00802278 <pipeisclosed>:
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802281:	50                   	push   %eax
  802282:	ff 75 08             	pushl  0x8(%ebp)
  802285:	e8 a5 ef ff ff       	call   80122f <fd_lookup>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 18                	js     8022a9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	ff 75 f4             	pushl  -0xc(%ebp)
  802297:	e8 2a ef ff ff       	call   8011c6 <fd2data>
	return _pipeisclosed(fd, p);
  80229c:	89 c2                	mov    %eax,%edx
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	e8 2f fd ff ff       	call   801fd5 <_pipeisclosed>
  8022a6:	83 c4 10             	add    $0x10,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	c3                   	ret    

008022b1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022b7:	68 4f 2d 80 00       	push   $0x802d4f
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	e8 be e6 ff ff       	call   800982 <strcpy>
	return 0;
}
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <devcons_write>:
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	57                   	push   %edi
  8022cf:	56                   	push   %esi
  8022d0:	53                   	push   %ebx
  8022d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022e5:	73 31                	jae    802318 <devcons_write+0x4d>
		m = n - tot;
  8022e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ea:	29 f3                	sub    %esi,%ebx
  8022ec:	83 fb 7f             	cmp    $0x7f,%ebx
  8022ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022f4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	53                   	push   %ebx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	03 45 0c             	add    0xc(%ebp),%eax
  802300:	50                   	push   %eax
  802301:	57                   	push   %edi
  802302:	e8 09 e8 ff ff       	call   800b10 <memmove>
		sys_cputs(buf, m);
  802307:	83 c4 08             	add    $0x8,%esp
  80230a:	53                   	push   %ebx
  80230b:	57                   	push   %edi
  80230c:	e8 a7 e9 ff ff       	call   800cb8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802311:	01 de                	add    %ebx,%esi
  802313:	83 c4 10             	add    $0x10,%esp
  802316:	eb ca                	jmp    8022e2 <devcons_write+0x17>
}
  802318:	89 f0                	mov    %esi,%eax
  80231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <devcons_read>:
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 08             	sub    $0x8,%esp
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80232d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802331:	74 21                	je     802354 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802333:	e8 9e e9 ff ff       	call   800cd6 <sys_cgetc>
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 07                	jne    802343 <devcons_read+0x21>
		sys_yield();
  80233c:	e8 14 ea ff ff       	call   800d55 <sys_yield>
  802341:	eb f0                	jmp    802333 <devcons_read+0x11>
	if (c < 0)
  802343:	78 0f                	js     802354 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802345:	83 f8 04             	cmp    $0x4,%eax
  802348:	74 0c                	je     802356 <devcons_read+0x34>
	*(char*)vbuf = c;
  80234a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234d:	88 02                	mov    %al,(%edx)
	return 1;
  80234f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    
		return 0;
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
  80235b:	eb f7                	jmp    802354 <devcons_read+0x32>

0080235d <cputchar>:
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802369:	6a 01                	push   $0x1
  80236b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80236e:	50                   	push   %eax
  80236f:	e8 44 e9 ff ff       	call   800cb8 <sys_cputs>
}
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <getchar>:
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80237f:	6a 01                	push   $0x1
  802381:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802384:	50                   	push   %eax
  802385:	6a 00                	push   $0x0
  802387:	e8 13 f1 ff ff       	call   80149f <read>
	if (r < 0)
  80238c:	83 c4 10             	add    $0x10,%esp
  80238f:	85 c0                	test   %eax,%eax
  802391:	78 06                	js     802399 <getchar+0x20>
	if (r < 1)
  802393:	74 06                	je     80239b <getchar+0x22>
	return c;
  802395:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    
		return -E_EOF;
  80239b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023a0:	eb f7                	jmp    802399 <getchar+0x20>

008023a2 <iscons>:
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ab:	50                   	push   %eax
  8023ac:	ff 75 08             	pushl  0x8(%ebp)
  8023af:	e8 7b ee ff ff       	call   80122f <fd_lookup>
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 11                	js     8023cc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c4:	39 10                	cmp    %edx,(%eax)
  8023c6:	0f 94 c0             	sete   %al
  8023c9:	0f b6 c0             	movzbl %al,%eax
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <opencons>:
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d7:	50                   	push   %eax
  8023d8:	e8 00 ee ff ff       	call   8011dd <fd_alloc>
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	78 3a                	js     80241e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 07 04 00 00       	push   $0x407
  8023ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 7e e9 ff ff       	call   800d74 <sys_page_alloc>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	78 21                	js     80241e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802406:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	50                   	push   %eax
  802416:	e8 9b ed ff ff       	call   8011b6 <fd2num>
  80241b:	83 c4 10             	add    $0x10,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	56                   	push   %esi
  802424:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802425:	a1 08 40 80 00       	mov    0x804008,%eax
  80242a:	8b 40 48             	mov    0x48(%eax),%eax
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	68 80 2d 80 00       	push   $0x802d80
  802435:	50                   	push   %eax
  802436:	68 66 28 80 00       	push   $0x802866
  80243b:	e8 e3 dd ff ff       	call   800223 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802440:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802443:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802449:	e8 e8 e8 ff ff       	call   800d36 <sys_getenvid>
  80244e:	83 c4 04             	add    $0x4,%esp
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	56                   	push   %esi
  802458:	50                   	push   %eax
  802459:	68 5c 2d 80 00       	push   $0x802d5c
  80245e:	e8 c0 dd ff ff       	call   800223 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802463:	83 c4 18             	add    $0x18,%esp
  802466:	53                   	push   %ebx
  802467:	ff 75 10             	pushl  0x10(%ebp)
  80246a:	e8 63 dd ff ff       	call   8001d2 <vcprintf>
	cprintf("\n");
  80246f:	c7 04 24 9a 2d 80 00 	movl   $0x802d9a,(%esp)
  802476:	e8 a8 dd ff ff       	call   800223 <cprintf>
  80247b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80247e:	cc                   	int3   
  80247f:	eb fd                	jmp    80247e <_panic+0x5e>

00802481 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	56                   	push   %esi
  802485:	53                   	push   %ebx
  802486:	8b 75 08             	mov    0x8(%ebp),%esi
  802489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80248f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802491:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802496:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802499:	83 ec 0c             	sub    $0xc,%esp
  80249c:	50                   	push   %eax
  80249d:	e8 82 ea ff ff       	call   800f24 <sys_ipc_recv>
	if(ret < 0){
  8024a2:	83 c4 10             	add    $0x10,%esp
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	78 2b                	js     8024d4 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8024a9:	85 f6                	test   %esi,%esi
  8024ab:	74 0a                	je     8024b7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8024ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8024b2:	8b 40 78             	mov    0x78(%eax),%eax
  8024b5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8024b7:	85 db                	test   %ebx,%ebx
  8024b9:	74 0a                	je     8024c5 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8024bb:	a1 08 40 80 00       	mov    0x804008,%eax
  8024c0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8024c3:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8024c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8024ca:	8b 40 74             	mov    0x74(%eax),%eax
}
  8024cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5e                   	pop    %esi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    
		if(from_env_store)
  8024d4:	85 f6                	test   %esi,%esi
  8024d6:	74 06                	je     8024de <ipc_recv+0x5d>
			*from_env_store = 0;
  8024d8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024de:	85 db                	test   %ebx,%ebx
  8024e0:	74 eb                	je     8024cd <ipc_recv+0x4c>
			*perm_store = 0;
  8024e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024e8:	eb e3                	jmp    8024cd <ipc_recv+0x4c>

008024ea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	57                   	push   %edi
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8024fc:	85 db                	test   %ebx,%ebx
  8024fe:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802503:	0f 44 d8             	cmove  %eax,%ebx
  802506:	eb 05                	jmp    80250d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802508:	e8 48 e8 ff ff       	call   800d55 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80250d:	ff 75 14             	pushl  0x14(%ebp)
  802510:	53                   	push   %ebx
  802511:	56                   	push   %esi
  802512:	57                   	push   %edi
  802513:	e8 e9 e9 ff ff       	call   800f01 <sys_ipc_try_send>
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	85 c0                	test   %eax,%eax
  80251d:	74 1b                	je     80253a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80251f:	79 e7                	jns    802508 <ipc_send+0x1e>
  802521:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802524:	74 e2                	je     802508 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 87 2d 80 00       	push   $0x802d87
  80252e:	6a 46                	push   $0x46
  802530:	68 9c 2d 80 00       	push   $0x802d9c
  802535:	e8 e6 fe ff ff       	call   802420 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80253a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5f                   	pop    %edi
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    

00802542 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80254d:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802553:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802559:	8b 52 50             	mov    0x50(%edx),%edx
  80255c:	39 ca                	cmp    %ecx,%edx
  80255e:	74 11                	je     802571 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802560:	83 c0 01             	add    $0x1,%eax
  802563:	3d 00 04 00 00       	cmp    $0x400,%eax
  802568:	75 e3                	jne    80254d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	eb 0e                	jmp    80257f <ipc_find_env+0x3d>
			return envs[i].env_id;
  802571:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802577:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80257c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    

00802581 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802587:	89 d0                	mov    %edx,%eax
  802589:	c1 e8 16             	shr    $0x16,%eax
  80258c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802598:	f6 c1 01             	test   $0x1,%cl
  80259b:	74 1d                	je     8025ba <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80259d:	c1 ea 0c             	shr    $0xc,%edx
  8025a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025a7:	f6 c2 01             	test   $0x1,%dl
  8025aa:	74 0e                	je     8025ba <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025ac:	c1 ea 0c             	shr    $0xc,%edx
  8025af:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025b6:	ef 
  8025b7:	0f b7 c0             	movzwl %ax,%eax
}
  8025ba:	5d                   	pop    %ebp
  8025bb:	c3                   	ret    
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__udivdi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 1c             	sub    $0x1c,%esp
  8025c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025d7:	85 d2                	test   %edx,%edx
  8025d9:	75 4d                	jne    802628 <__udivdi3+0x68>
  8025db:	39 f3                	cmp    %esi,%ebx
  8025dd:	76 19                	jbe    8025f8 <__udivdi3+0x38>
  8025df:	31 ff                	xor    %edi,%edi
  8025e1:	89 e8                	mov    %ebp,%eax
  8025e3:	89 f2                	mov    %esi,%edx
  8025e5:	f7 f3                	div    %ebx
  8025e7:	89 fa                	mov    %edi,%edx
  8025e9:	83 c4 1c             	add    $0x1c,%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    
  8025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	89 d9                	mov    %ebx,%ecx
  8025fa:	85 db                	test   %ebx,%ebx
  8025fc:	75 0b                	jne    802609 <__udivdi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f3                	div    %ebx
  802607:	89 c1                	mov    %eax,%ecx
  802609:	31 d2                	xor    %edx,%edx
  80260b:	89 f0                	mov    %esi,%eax
  80260d:	f7 f1                	div    %ecx
  80260f:	89 c6                	mov    %eax,%esi
  802611:	89 e8                	mov    %ebp,%eax
  802613:	89 f7                	mov    %esi,%edi
  802615:	f7 f1                	div    %ecx
  802617:	89 fa                	mov    %edi,%edx
  802619:	83 c4 1c             	add    $0x1c,%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5f                   	pop    %edi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	77 1c                	ja     802648 <__udivdi3+0x88>
  80262c:	0f bd fa             	bsr    %edx,%edi
  80262f:	83 f7 1f             	xor    $0x1f,%edi
  802632:	75 2c                	jne    802660 <__udivdi3+0xa0>
  802634:	39 f2                	cmp    %esi,%edx
  802636:	72 06                	jb     80263e <__udivdi3+0x7e>
  802638:	31 c0                	xor    %eax,%eax
  80263a:	39 eb                	cmp    %ebp,%ebx
  80263c:	77 a9                	ja     8025e7 <__udivdi3+0x27>
  80263e:	b8 01 00 00 00       	mov    $0x1,%eax
  802643:	eb a2                	jmp    8025e7 <__udivdi3+0x27>
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	31 ff                	xor    %edi,%edi
  80264a:	31 c0                	xor    %eax,%eax
  80264c:	89 fa                	mov    %edi,%edx
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	89 eb                	mov    %ebp,%ebx
  802691:	d3 e6                	shl    %cl,%esi
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 15                	jb     8026c0 <__udivdi3+0x100>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 04                	jae    8026b7 <__udivdi3+0xf7>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	74 09                	je     8026c0 <__udivdi3+0x100>
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	31 ff                	xor    %edi,%edi
  8026bb:	e9 27 ff ff ff       	jmp    8025e7 <__udivdi3+0x27>
  8026c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026c3:	31 ff                	xor    %edi,%edi
  8026c5:	e9 1d ff ff ff       	jmp    8025e7 <__udivdi3+0x27>
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 1c             	sub    $0x1c,%esp
  8026d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026e7:	89 da                	mov    %ebx,%edx
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 43                	jne    802730 <__umoddi3+0x60>
  8026ed:	39 df                	cmp    %ebx,%edi
  8026ef:	76 17                	jbe    802708 <__umoddi3+0x38>
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	f7 f7                	div    %edi
  8026f5:	89 d0                	mov    %edx,%eax
  8026f7:	31 d2                	xor    %edx,%edx
  8026f9:	83 c4 1c             	add    $0x1c,%esp
  8026fc:	5b                   	pop    %ebx
  8026fd:	5e                   	pop    %esi
  8026fe:	5f                   	pop    %edi
  8026ff:	5d                   	pop    %ebp
  802700:	c3                   	ret    
  802701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802708:	89 fd                	mov    %edi,%ebp
  80270a:	85 ff                	test   %edi,%edi
  80270c:	75 0b                	jne    802719 <__umoddi3+0x49>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c5                	mov    %eax,%ebp
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f5                	div    %ebp
  80271f:	89 f0                	mov    %esi,%eax
  802721:	f7 f5                	div    %ebp
  802723:	89 d0                	mov    %edx,%eax
  802725:	eb d0                	jmp    8026f7 <__umoddi3+0x27>
  802727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80272e:	66 90                	xchg   %ax,%ax
  802730:	89 f1                	mov    %esi,%ecx
  802732:	39 d8                	cmp    %ebx,%eax
  802734:	76 0a                	jbe    802740 <__umoddi3+0x70>
  802736:	89 f0                	mov    %esi,%eax
  802738:	83 c4 1c             	add    $0x1c,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	0f bd e8             	bsr    %eax,%ebp
  802743:	83 f5 1f             	xor    $0x1f,%ebp
  802746:	75 20                	jne    802768 <__umoddi3+0x98>
  802748:	39 d8                	cmp    %ebx,%eax
  80274a:	0f 82 b0 00 00 00    	jb     802800 <__umoddi3+0x130>
  802750:	39 f7                	cmp    %esi,%edi
  802752:	0f 86 a8 00 00 00    	jbe    802800 <__umoddi3+0x130>
  802758:	89 c8                	mov    %ecx,%eax
  80275a:	83 c4 1c             	add    $0x1c,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    
  802762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802768:	89 e9                	mov    %ebp,%ecx
  80276a:	ba 20 00 00 00       	mov    $0x20,%edx
  80276f:	29 ea                	sub    %ebp,%edx
  802771:	d3 e0                	shl    %cl,%eax
  802773:	89 44 24 08          	mov    %eax,0x8(%esp)
  802777:	89 d1                	mov    %edx,%ecx
  802779:	89 f8                	mov    %edi,%eax
  80277b:	d3 e8                	shr    %cl,%eax
  80277d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802781:	89 54 24 04          	mov    %edx,0x4(%esp)
  802785:	8b 54 24 04          	mov    0x4(%esp),%edx
  802789:	09 c1                	or     %eax,%ecx
  80278b:	89 d8                	mov    %ebx,%eax
  80278d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802791:	89 e9                	mov    %ebp,%ecx
  802793:	d3 e7                	shl    %cl,%edi
  802795:	89 d1                	mov    %edx,%ecx
  802797:	d3 e8                	shr    %cl,%eax
  802799:	89 e9                	mov    %ebp,%ecx
  80279b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80279f:	d3 e3                	shl    %cl,%ebx
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	89 d1                	mov    %edx,%ecx
  8027a5:	89 f0                	mov    %esi,%eax
  8027a7:	d3 e8                	shr    %cl,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	d3 e6                	shl    %cl,%esi
  8027af:	09 d8                	or     %ebx,%eax
  8027b1:	f7 74 24 08          	divl   0x8(%esp)
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	89 f3                	mov    %esi,%ebx
  8027b9:	f7 64 24 0c          	mull   0xc(%esp)
  8027bd:	89 c6                	mov    %eax,%esi
  8027bf:	89 d7                	mov    %edx,%edi
  8027c1:	39 d1                	cmp    %edx,%ecx
  8027c3:	72 06                	jb     8027cb <__umoddi3+0xfb>
  8027c5:	75 10                	jne    8027d7 <__umoddi3+0x107>
  8027c7:	39 c3                	cmp    %eax,%ebx
  8027c9:	73 0c                	jae    8027d7 <__umoddi3+0x107>
  8027cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027d3:	89 d7                	mov    %edx,%edi
  8027d5:	89 c6                	mov    %eax,%esi
  8027d7:	89 ca                	mov    %ecx,%edx
  8027d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027de:	29 f3                	sub    %esi,%ebx
  8027e0:	19 fa                	sbb    %edi,%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	d3 e0                	shl    %cl,%eax
  8027e6:	89 e9                	mov    %ebp,%ecx
  8027e8:	d3 eb                	shr    %cl,%ebx
  8027ea:	d3 ea                	shr    %cl,%edx
  8027ec:	09 d8                	or     %ebx,%eax
  8027ee:	83 c4 1c             	add    $0x1c,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
  8027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027fd:	8d 76 00             	lea    0x0(%esi),%esi
  802800:	89 da                	mov    %ebx,%edx
  802802:	29 fe                	sub    %edi,%esi
  802804:	19 c2                	sbb    %eax,%edx
  802806:	89 f1                	mov    %esi,%ecx
  802808:	89 c8                	mov    %ecx,%eax
  80280a:	e9 4b ff ff ff       	jmp    80275a <__umoddi3+0x8a>
