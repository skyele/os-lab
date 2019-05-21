
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
  800039:	68 a0 22 80 00       	push   $0x8022a0
  80003e:	e8 0a 02 00 00       	call   80024d <cprintf>
	exit();
  800043:	e8 5e 01 00 00       	call   8001a6 <exit>
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
  800067:	e8 64 0f 00 00       	call   800fd0 <argstart>
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
  800083:	e8 78 0f 00 00       	call   801000 <argnext>
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
  8000bd:	68 b4 22 80 00       	push   $0x8022b4
  8000c2:	e8 86 01 00 00       	call   80024d <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 1b 15 00 00       	call   8015f7 <fstat>
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
  8000f8:	68 b4 22 80 00       	push   $0x8022b4
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 c0 18 00 00       	call   8019c4 <fprintf>
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
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80011a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800121:	00 00 00 
	envid_t find = sys_getenvid();
  800124:	e8 37 0c 00 00       	call   800d60 <sys_getenvid>
  800129:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  80012f:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800139:	bf 01 00 00 00       	mov    $0x1,%edi
  80013e:	eb 0b                	jmp    80014b <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800140:	83 c2 01             	add    $0x1,%edx
  800143:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800149:	74 21                	je     80016c <libmain+0x5b>
		if(envs[i].env_id == find)
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	c1 e1 07             	shl    $0x7,%ecx
  800150:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800156:	8b 49 48             	mov    0x48(%ecx),%ecx
  800159:	39 c1                	cmp    %eax,%ecx
  80015b:	75 e3                	jne    800140 <libmain+0x2f>
  80015d:	89 d3                	mov    %edx,%ebx
  80015f:	c1 e3 07             	shl    $0x7,%ebx
  800162:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800168:	89 fe                	mov    %edi,%esi
  80016a:	eb d4                	jmp    800140 <libmain+0x2f>
  80016c:	89 f0                	mov    %esi,%eax
  80016e:	84 c0                	test   %al,%al
  800170:	74 06                	je     800178 <libmain+0x67>
  800172:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800178:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017c:	7e 0a                	jle    800188 <libmain+0x77>
		binaryname = argv[0];
  80017e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800181:	8b 00                	mov    (%eax),%eax
  800183:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	ff 75 0c             	pushl  0xc(%ebp)
  80018e:	ff 75 08             	pushl  0x8(%ebp)
  800191:	e8 b7 fe ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800196:	e8 0b 00 00 00       	call   8001a6 <exit>
}
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001ac:	6a 00                	push   $0x0
  8001ae:	e8 6c 0b 00 00       	call   800d1f <sys_env_destroy>
}
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 04             	sub    $0x4,%esp
  8001bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c2:	8b 13                	mov    (%ebx),%edx
  8001c4:	8d 42 01             	lea    0x1(%edx),%eax
  8001c7:	89 03                	mov    %eax,(%ebx)
  8001c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001cc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d5:	74 09                	je     8001e0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	68 ff 00 00 00       	push   $0xff
  8001e8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001eb:	50                   	push   %eax
  8001ec:	e8 f1 0a 00 00       	call   800ce2 <sys_cputs>
		b->idx = 0;
  8001f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	eb db                	jmp    8001d7 <putch+0x1f>

008001fc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 b8 01 80 00       	push   $0x8001b8
  80022b:	e8 4a 01 00 00       	call   80037a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800230:	83 c4 08             	add    $0x8,%esp
  800233:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800239:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	e8 9d 0a 00 00       	call   800ce2 <sys_cputs>

	return b.cnt;
}
  800245:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800253:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800256:	50                   	push   %eax
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 9d ff ff ff       	call   8001fc <vcprintf>
	va_end(ap);

	return cnt;
}
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 1c             	sub    $0x1c,%esp
  80026a:	89 c6                	mov    %eax,%esi
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	8b 55 0c             	mov    0xc(%ebp),%edx
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800277:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80027a:	8b 45 10             	mov    0x10(%ebp),%eax
  80027d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800280:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800284:	74 2c                	je     8002b2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800286:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800289:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800290:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800293:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800296:	39 c2                	cmp    %eax,%edx
  800298:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80029b:	73 43                	jae    8002e0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80029d:	83 eb 01             	sub    $0x1,%ebx
  8002a0:	85 db                	test   %ebx,%ebx
  8002a2:	7e 6c                	jle    800310 <printnum+0xaf>
				putch(padc, putdat);
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	57                   	push   %edi
  8002a8:	ff 75 18             	pushl  0x18(%ebp)
  8002ab:	ff d6                	call   *%esi
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	eb eb                	jmp    80029d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	6a 20                	push   $0x20
  8002b7:	6a 00                	push   $0x0
  8002b9:	50                   	push   %eax
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c0:	89 fa                	mov    %edi,%edx
  8002c2:	89 f0                	mov    %esi,%eax
  8002c4:	e8 98 ff ff ff       	call   800261 <printnum>
		while (--width > 0)
  8002c9:	83 c4 20             	add    $0x20,%esp
  8002cc:	83 eb 01             	sub    $0x1,%ebx
  8002cf:	85 db                	test   %ebx,%ebx
  8002d1:	7e 65                	jle    800338 <printnum+0xd7>
			putch(padc, putdat);
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	57                   	push   %edi
  8002d7:	6a 20                	push   $0x20
  8002d9:	ff d6                	call   *%esi
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	eb ec                	jmp    8002cc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	ff 75 18             	pushl  0x18(%ebp)
  8002e6:	83 eb 01             	sub    $0x1,%ebx
  8002e9:	53                   	push   %ebx
  8002ea:	50                   	push   %eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fa:	e8 51 1d 00 00       	call   802050 <__udivdi3>
  8002ff:	83 c4 18             	add    $0x18,%esp
  800302:	52                   	push   %edx
  800303:	50                   	push   %eax
  800304:	89 fa                	mov    %edi,%edx
  800306:	89 f0                	mov    %esi,%eax
  800308:	e8 54 ff ff ff       	call   800261 <printnum>
  80030d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	57                   	push   %edi
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	ff 75 dc             	pushl  -0x24(%ebp)
  80031a:	ff 75 d8             	pushl  -0x28(%ebp)
  80031d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800320:	ff 75 e0             	pushl  -0x20(%ebp)
  800323:	e8 38 1e 00 00       	call   802160 <__umoddi3>
  800328:	83 c4 14             	add    $0x14,%esp
  80032b:	0f be 80 e6 22 80 00 	movsbl 0x8022e6(%eax),%eax
  800332:	50                   	push   %eax
  800333:	ff d6                	call   *%esi
  800335:	83 c4 10             	add    $0x10,%esp
	}
}
  800338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5f                   	pop    %edi
  80033e:	5d                   	pop    %ebp
  80033f:	c3                   	ret    

00800340 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800346:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80034a:	8b 10                	mov    (%eax),%edx
  80034c:	3b 50 04             	cmp    0x4(%eax),%edx
  80034f:	73 0a                	jae    80035b <sprintputch+0x1b>
		*b->buf++ = ch;
  800351:	8d 4a 01             	lea    0x1(%edx),%ecx
  800354:	89 08                	mov    %ecx,(%eax)
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	88 02                	mov    %al,(%edx)
}
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <printfmt>:
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800363:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800366:	50                   	push   %eax
  800367:	ff 75 10             	pushl  0x10(%ebp)
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	e8 05 00 00 00       	call   80037a <vprintfmt>
}
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <vprintfmt>:
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	57                   	push   %edi
  80037e:	56                   	push   %esi
  80037f:	53                   	push   %ebx
  800380:	83 ec 3c             	sub    $0x3c,%esp
  800383:	8b 75 08             	mov    0x8(%ebp),%esi
  800386:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800389:	8b 7d 10             	mov    0x10(%ebp),%edi
  80038c:	e9 32 04 00 00       	jmp    8007c3 <vprintfmt+0x449>
		padc = ' ';
  800391:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800395:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80039c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003b8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	8d 47 01             	lea    0x1(%edi),%eax
  8003c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c3:	0f b6 17             	movzbl (%edi),%edx
  8003c6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003c9:	3c 55                	cmp    $0x55,%al
  8003cb:	0f 87 12 05 00 00    	ja     8008e3 <vprintfmt+0x569>
  8003d1:	0f b6 c0             	movzbl %al,%eax
  8003d4:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
  8003db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003de:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003e2:	eb d9                	jmp    8003bd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003eb:	eb d0                	jmp    8003bd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	0f b6 d2             	movzbl %dl,%edx
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8003fb:	eb 03                	jmp    800400 <vprintfmt+0x86>
  8003fd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800400:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800403:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800407:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80040d:	83 fe 09             	cmp    $0x9,%esi
  800410:	76 eb                	jbe    8003fd <vprintfmt+0x83>
  800412:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800415:	8b 75 08             	mov    0x8(%ebp),%esi
  800418:	eb 14                	jmp    80042e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8d 40 04             	lea    0x4(%eax),%eax
  800428:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800432:	79 89                	jns    8003bd <vprintfmt+0x43>
				width = precision, precision = -1;
  800434:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800441:	e9 77 ff ff ff       	jmp    8003bd <vprintfmt+0x43>
  800446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800449:	85 c0                	test   %eax,%eax
  80044b:	0f 48 c1             	cmovs  %ecx,%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800454:	e9 64 ff ff ff       	jmp    8003bd <vprintfmt+0x43>
  800459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800463:	e9 55 ff ff ff       	jmp    8003bd <vprintfmt+0x43>
			lflag++;
  800468:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80046f:	e9 49 ff ff ff       	jmp    8003bd <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 78 04             	lea    0x4(%eax),%edi
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	53                   	push   %ebx
  80047e:	ff 30                	pushl  (%eax)
  800480:	ff d6                	call   *%esi
			break;
  800482:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800485:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800488:	e9 33 03 00 00       	jmp    8007c0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8d 78 04             	lea    0x4(%eax),%edi
  800493:	8b 00                	mov    (%eax),%eax
  800495:	99                   	cltd   
  800496:	31 d0                	xor    %edx,%eax
  800498:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049a:	83 f8 0f             	cmp    $0xf,%eax
  80049d:	7f 23                	jg     8004c2 <vprintfmt+0x148>
  80049f:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	74 18                	je     8004c2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004aa:	52                   	push   %edx
  8004ab:	68 5a 27 80 00       	push   $0x80275a
  8004b0:	53                   	push   %ebx
  8004b1:	56                   	push   %esi
  8004b2:	e8 a6 fe ff ff       	call   80035d <printfmt>
  8004b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ba:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004bd:	e9 fe 02 00 00       	jmp    8007c0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004c2:	50                   	push   %eax
  8004c3:	68 fe 22 80 00       	push   $0x8022fe
  8004c8:	53                   	push   %ebx
  8004c9:	56                   	push   %esi
  8004ca:	e8 8e fe ff ff       	call   80035d <printfmt>
  8004cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d5:	e9 e6 02 00 00       	jmp    8007c0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	83 c0 04             	add    $0x4,%eax
  8004e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004e8:	85 c9                	test   %ecx,%ecx
  8004ea:	b8 f7 22 80 00       	mov    $0x8022f7,%eax
  8004ef:	0f 45 c1             	cmovne %ecx,%eax
  8004f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f9:	7e 06                	jle    800501 <vprintfmt+0x187>
  8004fb:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ff:	75 0d                	jne    80050e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800501:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800504:	89 c7                	mov    %eax,%edi
  800506:	03 45 e0             	add    -0x20(%ebp),%eax
  800509:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050c:	eb 53                	jmp    800561 <vprintfmt+0x1e7>
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	ff 75 d8             	pushl  -0x28(%ebp)
  800514:	50                   	push   %eax
  800515:	e8 71 04 00 00       	call   80098b <strnlen>
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 c1                	sub    %eax,%ecx
  80051f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800527:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80052b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	eb 0f                	jmp    80053f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	ff 75 e0             	pushl  -0x20(%ebp)
  800537:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ed                	jg     800530 <vprintfmt+0x1b6>
  800543:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800546:	85 c9                	test   %ecx,%ecx
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	0f 49 c1             	cmovns %ecx,%eax
  800550:	29 c1                	sub    %eax,%ecx
  800552:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800555:	eb aa                	jmp    800501 <vprintfmt+0x187>
					putch(ch, putdat);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	53                   	push   %ebx
  80055b:	52                   	push   %edx
  80055c:	ff d6                	call   *%esi
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800564:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800566:	83 c7 01             	add    $0x1,%edi
  800569:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056d:	0f be d0             	movsbl %al,%edx
  800570:	85 d2                	test   %edx,%edx
  800572:	74 4b                	je     8005bf <vprintfmt+0x245>
  800574:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800578:	78 06                	js     800580 <vprintfmt+0x206>
  80057a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80057e:	78 1e                	js     80059e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800580:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800584:	74 d1                	je     800557 <vprintfmt+0x1dd>
  800586:	0f be c0             	movsbl %al,%eax
  800589:	83 e8 20             	sub    $0x20,%eax
  80058c:	83 f8 5e             	cmp    $0x5e,%eax
  80058f:	76 c6                	jbe    800557 <vprintfmt+0x1dd>
					putch('?', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 3f                	push   $0x3f
  800597:	ff d6                	call   *%esi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb c3                	jmp    800561 <vprintfmt+0x1e7>
  80059e:	89 cf                	mov    %ecx,%edi
  8005a0:	eb 0e                	jmp    8005b0 <vprintfmt+0x236>
				putch(' ', putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	6a 20                	push   $0x20
  8005a8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005aa:	83 ef 01             	sub    $0x1,%edi
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	85 ff                	test   %edi,%edi
  8005b2:	7f ee                	jg     8005a2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ba:	e9 01 02 00 00       	jmp    8007c0 <vprintfmt+0x446>
  8005bf:	89 cf                	mov    %ecx,%edi
  8005c1:	eb ed                	jmp    8005b0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005c6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005cd:	e9 eb fd ff ff       	jmp    8003bd <vprintfmt+0x43>
	if (lflag >= 2)
  8005d2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005d6:	7f 21                	jg     8005f9 <vprintfmt+0x27f>
	else if (lflag)
  8005d8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005dc:	74 68                	je     800646 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e6:	89 c1                	mov    %eax,%ecx
  8005e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005eb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 40 04             	lea    0x4(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f7:	eb 17                	jmp    800610 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800604:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 40 08             	lea    0x8(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800610:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800613:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800616:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800619:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80061c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800620:	78 3f                	js     800661 <vprintfmt+0x2e7>
			base = 10;
  800622:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800627:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80062b:	0f 84 71 01 00 00    	je     8007a2 <vprintfmt+0x428>
				putch('+', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 2b                	push   $0x2b
  800637:	ff d6                	call   *%esi
  800639:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800641:	e9 5c 01 00 00       	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064e:	89 c1                	mov    %eax,%ecx
  800650:	c1 f9 1f             	sar    $0x1f,%ecx
  800653:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
  80065f:	eb af                	jmp    800610 <vprintfmt+0x296>
				putch('-', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 2d                	push   $0x2d
  800667:	ff d6                	call   *%esi
				num = -(long long) num;
  800669:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80066f:	f7 d8                	neg    %eax
  800671:	83 d2 00             	adc    $0x0,%edx
  800674:	f7 da                	neg    %edx
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80067f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800684:	e9 19 01 00 00       	jmp    8007a2 <vprintfmt+0x428>
	if (lflag >= 2)
  800689:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80068d:	7f 29                	jg     8006b8 <vprintfmt+0x33e>
	else if (lflag)
  80068f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800693:	74 44                	je     8006d9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
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
  8006b3:	e9 ea 00 00 00       	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 50 04             	mov    0x4(%eax),%edx
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8d 40 08             	lea    0x8(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d4:	e9 c9 00 00 00       	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 04             	lea    0x4(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f7:	e9 a6 00 00 00       	jmp    8007a2 <vprintfmt+0x428>
			putch('0', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	6a 30                	push   $0x30
  800702:	ff d6                	call   *%esi
	if (lflag >= 2)
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070b:	7f 26                	jg     800733 <vprintfmt+0x3b9>
	else if (lflag)
  80070d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800711:	74 3e                	je     800751 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072c:	b8 08 00 00 00       	mov    $0x8,%eax
  800731:	eb 6f                	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 08             	lea    0x8(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074a:	b8 08 00 00 00       	mov    $0x8,%eax
  80074f:	eb 51                	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	ba 00 00 00 00       	mov    $0x0,%edx
  80075b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076a:	b8 08 00 00 00       	mov    $0x8,%eax
  80076f:	eb 31                	jmp    8007a2 <vprintfmt+0x428>
			putch('0', putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	6a 30                	push   $0x30
  800777:	ff d6                	call   *%esi
			putch('x', putdat);
  800779:	83 c4 08             	add    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 78                	push   $0x78
  80077f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800791:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a2:	83 ec 0c             	sub    $0xc,%esp
  8007a5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b4:	89 da                	mov    %ebx,%edx
  8007b6:	89 f0                	mov    %esi,%eax
  8007b8:	e8 a4 fa ff ff       	call   800261 <printnum>
			break;
  8007bd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c3:	83 c7 01             	add    $0x1,%edi
  8007c6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ca:	83 f8 25             	cmp    $0x25,%eax
  8007cd:	0f 84 be fb ff ff    	je     800391 <vprintfmt+0x17>
			if (ch == '\0')
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	0f 84 28 01 00 00    	je     800903 <vprintfmt+0x589>
			putch(ch, putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	53                   	push   %ebx
  8007df:	50                   	push   %eax
  8007e0:	ff d6                	call   *%esi
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	eb dc                	jmp    8007c3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007eb:	7f 26                	jg     800813 <vprintfmt+0x499>
	else if (lflag)
  8007ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f1:	74 41                	je     800834 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
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
  800811:	eb 8f                	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 50 04             	mov    0x4(%eax),%edx
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8d 40 08             	lea    0x8(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082a:	b8 10 00 00 00       	mov    $0x10,%eax
  80082f:	e9 6e ff ff ff       	jmp    8007a2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	ba 00 00 00 00       	mov    $0x0,%edx
  80083e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800841:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 40 04             	lea    0x4(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084d:	b8 10 00 00 00       	mov    $0x10,%eax
  800852:	e9 4b ff ff ff       	jmp    8007a2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 c0 04             	add    $0x4,%eax
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	85 c0                	test   %eax,%eax
  800867:	74 14                	je     80087d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800869:	8b 13                	mov    (%ebx),%edx
  80086b:	83 fa 7f             	cmp    $0x7f,%edx
  80086e:	7f 37                	jg     8008a7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800870:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800872:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
  800878:	e9 43 ff ff ff       	jmp    8007c0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80087d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800882:	bf 1d 24 80 00       	mov    $0x80241d,%edi
							putch(ch, putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	50                   	push   %eax
  80088c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80088e:	83 c7 01             	add    $0x1,%edi
  800891:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	85 c0                	test   %eax,%eax
  80089a:	75 eb                	jne    800887 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80089c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	e9 19 ff ff ff       	jmp    8007c0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008a7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ae:	bf 55 24 80 00       	mov    $0x802455,%edi
							putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	50                   	push   %eax
  8008b8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ba:	83 c7 01             	add    $0x1,%edi
  8008bd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	75 eb                	jne    8008b3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ce:	e9 ed fe ff ff       	jmp    8007c0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	53                   	push   %ebx
  8008d7:	6a 25                	push   $0x25
  8008d9:	ff d6                	call   *%esi
			break;
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	e9 dd fe ff ff       	jmp    8007c0 <vprintfmt+0x446>
			putch('%', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 25                	push   $0x25
  8008e9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 f8                	mov    %edi,%eax
  8008f0:	eb 03                	jmp    8008f5 <vprintfmt+0x57b>
  8008f2:	83 e8 01             	sub    $0x1,%eax
  8008f5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008f9:	75 f7                	jne    8008f2 <vprintfmt+0x578>
  8008fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008fe:	e9 bd fe ff ff       	jmp    8007c0 <vprintfmt+0x446>
}
  800903:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800906:	5b                   	pop    %ebx
  800907:	5e                   	pop    %esi
  800908:	5f                   	pop    %edi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 18             	sub    $0x18,%esp
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800917:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80091e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800928:	85 c0                	test   %eax,%eax
  80092a:	74 26                	je     800952 <vsnprintf+0x47>
  80092c:	85 d2                	test   %edx,%edx
  80092e:	7e 22                	jle    800952 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800930:	ff 75 14             	pushl  0x14(%ebp)
  800933:	ff 75 10             	pushl  0x10(%ebp)
  800936:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800939:	50                   	push   %eax
  80093a:	68 40 03 80 00       	push   $0x800340
  80093f:	e8 36 fa ff ff       	call   80037a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800947:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094d:	83 c4 10             	add    $0x10,%esp
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    
		return -E_INVAL;
  800952:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800957:	eb f7                	jmp    800950 <vsnprintf+0x45>

00800959 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80095f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800962:	50                   	push   %eax
  800963:	ff 75 10             	pushl  0x10(%ebp)
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	ff 75 08             	pushl  0x8(%ebp)
  80096c:	e8 9a ff ff ff       	call   80090b <vsnprintf>
	va_end(ap);

	return rc;
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800982:	74 05                	je     800989 <strlen+0x16>
		n++;
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	eb f5                	jmp    80097e <strlen+0xb>
	return n;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	39 c2                	cmp    %eax,%edx
  80099b:	74 0d                	je     8009aa <strnlen+0x1f>
  80099d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009a1:	74 05                	je     8009a8 <strnlen+0x1d>
		n++;
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	eb f1                	jmp    800999 <strnlen+0xe>
  8009a8:	89 d0                	mov    %edx,%eax
	return n;
}
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009bf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009c2:	83 c2 01             	add    $0x1,%edx
  8009c5:	84 c9                	test   %cl,%cl
  8009c7:	75 f2                	jne    8009bb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009c9:	5b                   	pop    %ebx
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	53                   	push   %ebx
  8009d0:	83 ec 10             	sub    $0x10,%esp
  8009d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d6:	53                   	push   %ebx
  8009d7:	e8 97 ff ff ff       	call   800973 <strlen>
  8009dc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	01 d8                	add    %ebx,%eax
  8009e4:	50                   	push   %eax
  8009e5:	e8 c2 ff ff ff       	call   8009ac <strcpy>
	return dst;
}
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	56                   	push   %esi
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fc:	89 c6                	mov    %eax,%esi
  8009fe:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a01:	89 c2                	mov    %eax,%edx
  800a03:	39 f2                	cmp    %esi,%edx
  800a05:	74 11                	je     800a18 <strncpy+0x27>
		*dst++ = *src;
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	0f b6 19             	movzbl (%ecx),%ebx
  800a0d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a10:	80 fb 01             	cmp    $0x1,%bl
  800a13:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a16:	eb eb                	jmp    800a03 <strncpy+0x12>
	}
	return ret;
}
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	56                   	push   %esi
  800a20:	53                   	push   %ebx
  800a21:	8b 75 08             	mov    0x8(%ebp),%esi
  800a24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a27:	8b 55 10             	mov    0x10(%ebp),%edx
  800a2a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2c:	85 d2                	test   %edx,%edx
  800a2e:	74 21                	je     800a51 <strlcpy+0x35>
  800a30:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a34:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a36:	39 c2                	cmp    %eax,%edx
  800a38:	74 14                	je     800a4e <strlcpy+0x32>
  800a3a:	0f b6 19             	movzbl (%ecx),%ebx
  800a3d:	84 db                	test   %bl,%bl
  800a3f:	74 0b                	je     800a4c <strlcpy+0x30>
			*dst++ = *src++;
  800a41:	83 c1 01             	add    $0x1,%ecx
  800a44:	83 c2 01             	add    $0x1,%edx
  800a47:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a4a:	eb ea                	jmp    800a36 <strlcpy+0x1a>
  800a4c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a4e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a51:	29 f0                	sub    %esi,%eax
}
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a60:	0f b6 01             	movzbl (%ecx),%eax
  800a63:	84 c0                	test   %al,%al
  800a65:	74 0c                	je     800a73 <strcmp+0x1c>
  800a67:	3a 02                	cmp    (%edx),%al
  800a69:	75 08                	jne    800a73 <strcmp+0x1c>
		p++, q++;
  800a6b:	83 c1 01             	add    $0x1,%ecx
  800a6e:	83 c2 01             	add    $0x1,%edx
  800a71:	eb ed                	jmp    800a60 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a73:	0f b6 c0             	movzbl %al,%eax
  800a76:	0f b6 12             	movzbl (%edx),%edx
  800a79:	29 d0                	sub    %edx,%eax
}
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	53                   	push   %ebx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a87:	89 c3                	mov    %eax,%ebx
  800a89:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8c:	eb 06                	jmp    800a94 <strncmp+0x17>
		n--, p++, q++;
  800a8e:	83 c0 01             	add    $0x1,%eax
  800a91:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a94:	39 d8                	cmp    %ebx,%eax
  800a96:	74 16                	je     800aae <strncmp+0x31>
  800a98:	0f b6 08             	movzbl (%eax),%ecx
  800a9b:	84 c9                	test   %cl,%cl
  800a9d:	74 04                	je     800aa3 <strncmp+0x26>
  800a9f:	3a 0a                	cmp    (%edx),%cl
  800aa1:	74 eb                	je     800a8e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa3:	0f b6 00             	movzbl (%eax),%eax
  800aa6:	0f b6 12             	movzbl (%edx),%edx
  800aa9:	29 d0                	sub    %edx,%eax
}
  800aab:	5b                   	pop    %ebx
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    
		return 0;
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	eb f6                	jmp    800aab <strncmp+0x2e>

00800ab5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800abf:	0f b6 10             	movzbl (%eax),%edx
  800ac2:	84 d2                	test   %dl,%dl
  800ac4:	74 09                	je     800acf <strchr+0x1a>
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 0a                	je     800ad4 <strchr+0x1f>
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	eb f0                	jmp    800abf <strchr+0xa>
			return (char *) s;
	return 0;
  800acf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ae3:	38 ca                	cmp    %cl,%dl
  800ae5:	74 09                	je     800af0 <strfind+0x1a>
  800ae7:	84 d2                	test   %dl,%dl
  800ae9:	74 05                	je     800af0 <strfind+0x1a>
	for (; *s; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	eb f0                	jmp    800ae0 <strfind+0xa>
			break;
	return (char *) s;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800afe:	85 c9                	test   %ecx,%ecx
  800b00:	74 31                	je     800b33 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b02:	89 f8                	mov    %edi,%eax
  800b04:	09 c8                	or     %ecx,%eax
  800b06:	a8 03                	test   $0x3,%al
  800b08:	75 23                	jne    800b2d <memset+0x3b>
		c &= 0xFF;
  800b0a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b0e:	89 d3                	mov    %edx,%ebx
  800b10:	c1 e3 08             	shl    $0x8,%ebx
  800b13:	89 d0                	mov    %edx,%eax
  800b15:	c1 e0 18             	shl    $0x18,%eax
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	c1 e6 10             	shl    $0x10,%esi
  800b1d:	09 f0                	or     %esi,%eax
  800b1f:	09 c2                	or     %eax,%edx
  800b21:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b23:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	fc                   	cld    
  800b29:	f3 ab                	rep stos %eax,%es:(%edi)
  800b2b:	eb 06                	jmp    800b33 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	fc                   	cld    
  800b31:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b33:	89 f8                	mov    %edi,%eax
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	57                   	push   %edi
  800b3e:	56                   	push   %esi
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b48:	39 c6                	cmp    %eax,%esi
  800b4a:	73 32                	jae    800b7e <memmove+0x44>
  800b4c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b4f:	39 c2                	cmp    %eax,%edx
  800b51:	76 2b                	jbe    800b7e <memmove+0x44>
		s += n;
		d += n;
  800b53:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b56:	89 fe                	mov    %edi,%esi
  800b58:	09 ce                	or     %ecx,%esi
  800b5a:	09 d6                	or     %edx,%esi
  800b5c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b62:	75 0e                	jne    800b72 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b64:	83 ef 04             	sub    $0x4,%edi
  800b67:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b6d:	fd                   	std    
  800b6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b70:	eb 09                	jmp    800b7b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b72:	83 ef 01             	sub    $0x1,%edi
  800b75:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b78:	fd                   	std    
  800b79:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b7b:	fc                   	cld    
  800b7c:	eb 1a                	jmp    800b98 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7e:	89 c2                	mov    %eax,%edx
  800b80:	09 ca                	or     %ecx,%edx
  800b82:	09 f2                	or     %esi,%edx
  800b84:	f6 c2 03             	test   $0x3,%dl
  800b87:	75 0a                	jne    800b93 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b89:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b8c:	89 c7                	mov    %eax,%edi
  800b8e:	fc                   	cld    
  800b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b91:	eb 05                	jmp    800b98 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b93:	89 c7                	mov    %eax,%edi
  800b95:	fc                   	cld    
  800b96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba2:	ff 75 10             	pushl  0x10(%ebp)
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	ff 75 08             	pushl  0x8(%ebp)
  800bab:	e8 8a ff ff ff       	call   800b3a <memmove>
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbd:	89 c6                	mov    %eax,%esi
  800bbf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc2:	39 f0                	cmp    %esi,%eax
  800bc4:	74 1c                	je     800be2 <memcmp+0x30>
		if (*s1 != *s2)
  800bc6:	0f b6 08             	movzbl (%eax),%ecx
  800bc9:	0f b6 1a             	movzbl (%edx),%ebx
  800bcc:	38 d9                	cmp    %bl,%cl
  800bce:	75 08                	jne    800bd8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bd0:	83 c0 01             	add    $0x1,%eax
  800bd3:	83 c2 01             	add    $0x1,%edx
  800bd6:	eb ea                	jmp    800bc2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bd8:	0f b6 c1             	movzbl %cl,%eax
  800bdb:	0f b6 db             	movzbl %bl,%ebx
  800bde:	29 d8                	sub    %ebx,%eax
  800be0:	eb 05                	jmp    800be7 <memcmp+0x35>
	}

	return 0;
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf4:	89 c2                	mov    %eax,%edx
  800bf6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf9:	39 d0                	cmp    %edx,%eax
  800bfb:	73 09                	jae    800c06 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bfd:	38 08                	cmp    %cl,(%eax)
  800bff:	74 05                	je     800c06 <memfind+0x1b>
	for (; s < ends; s++)
  800c01:	83 c0 01             	add    $0x1,%eax
  800c04:	eb f3                	jmp    800bf9 <memfind+0xe>
			break;
	return (void *) s;
}
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c14:	eb 03                	jmp    800c19 <strtol+0x11>
		s++;
  800c16:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c19:	0f b6 01             	movzbl (%ecx),%eax
  800c1c:	3c 20                	cmp    $0x20,%al
  800c1e:	74 f6                	je     800c16 <strtol+0xe>
  800c20:	3c 09                	cmp    $0x9,%al
  800c22:	74 f2                	je     800c16 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c24:	3c 2b                	cmp    $0x2b,%al
  800c26:	74 2a                	je     800c52 <strtol+0x4a>
	int neg = 0;
  800c28:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c2d:	3c 2d                	cmp    $0x2d,%al
  800c2f:	74 2b                	je     800c5c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c31:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c37:	75 0f                	jne    800c48 <strtol+0x40>
  800c39:	80 39 30             	cmpb   $0x30,(%ecx)
  800c3c:	74 28                	je     800c66 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c3e:	85 db                	test   %ebx,%ebx
  800c40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c45:	0f 44 d8             	cmove  %eax,%ebx
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c50:	eb 50                	jmp    800ca2 <strtol+0x9a>
		s++;
  800c52:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c55:	bf 00 00 00 00       	mov    $0x0,%edi
  800c5a:	eb d5                	jmp    800c31 <strtol+0x29>
		s++, neg = 1;
  800c5c:	83 c1 01             	add    $0x1,%ecx
  800c5f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c64:	eb cb                	jmp    800c31 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c66:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c6a:	74 0e                	je     800c7a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	75 d8                	jne    800c48 <strtol+0x40>
		s++, base = 8;
  800c70:	83 c1 01             	add    $0x1,%ecx
  800c73:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c78:	eb ce                	jmp    800c48 <strtol+0x40>
		s += 2, base = 16;
  800c7a:	83 c1 02             	add    $0x2,%ecx
  800c7d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c82:	eb c4                	jmp    800c48 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c84:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c87:	89 f3                	mov    %esi,%ebx
  800c89:	80 fb 19             	cmp    $0x19,%bl
  800c8c:	77 29                	ja     800cb7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c8e:	0f be d2             	movsbl %dl,%edx
  800c91:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c94:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c97:	7d 30                	jge    800cc9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c99:	83 c1 01             	add    $0x1,%ecx
  800c9c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ca2:	0f b6 11             	movzbl (%ecx),%edx
  800ca5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ca8:	89 f3                	mov    %esi,%ebx
  800caa:	80 fb 09             	cmp    $0x9,%bl
  800cad:	77 d5                	ja     800c84 <strtol+0x7c>
			dig = *s - '0';
  800caf:	0f be d2             	movsbl %dl,%edx
  800cb2:	83 ea 30             	sub    $0x30,%edx
  800cb5:	eb dd                	jmp    800c94 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cb7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cba:	89 f3                	mov    %esi,%ebx
  800cbc:	80 fb 19             	cmp    $0x19,%bl
  800cbf:	77 08                	ja     800cc9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cc1:	0f be d2             	movsbl %dl,%edx
  800cc4:	83 ea 37             	sub    $0x37,%edx
  800cc7:	eb cb                	jmp    800c94 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccd:	74 05                	je     800cd4 <strtol+0xcc>
		*endptr = (char *) s;
  800ccf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	f7 da                	neg    %edx
  800cd8:	85 ff                	test   %edi,%edi
  800cda:	0f 45 c2             	cmovne %edx,%eax
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	89 c3                	mov    %eax,%ebx
  800cf5:	89 c7                	mov    %eax,%edi
  800cf7:	89 c6                	mov    %eax,%esi
  800cf9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d06:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0b:	b8 01 00 00 00       	mov    $0x1,%eax
  800d10:	89 d1                	mov    %edx,%ecx
  800d12:	89 d3                	mov    %edx,%ebx
  800d14:	89 d7                	mov    %edx,%edi
  800d16:	89 d6                	mov    %edx,%esi
  800d18:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	b8 03 00 00 00       	mov    $0x3,%eax
  800d35:	89 cb                	mov    %ecx,%ebx
  800d37:	89 cf                	mov    %ecx,%edi
  800d39:	89 ce                	mov    %ecx,%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 03                	push   $0x3
  800d4f:	68 60 26 80 00       	push   $0x802660
  800d54:	6a 43                	push   $0x43
  800d56:	68 7d 26 80 00       	push   $0x80267d
  800d5b:	e8 54 11 00 00       	call   801eb4 <_panic>

00800d60 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d66:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d70:	89 d1                	mov    %edx,%ecx
  800d72:	89 d3                	mov    %edx,%ebx
  800d74:	89 d7                	mov    %edx,%edi
  800d76:	89 d6                	mov    %edx,%esi
  800d78:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_yield>:

void
sys_yield(void)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	57                   	push   %edi
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d85:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d8f:	89 d1                	mov    %edx,%ecx
  800d91:	89 d3                	mov    %edx,%ebx
  800d93:	89 d7                	mov    %edx,%edi
  800d95:	89 d6                	mov    %edx,%esi
  800d97:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d99:	5b                   	pop    %ebx
  800d9a:	5e                   	pop    %esi
  800d9b:	5f                   	pop    %edi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da7:	be 00 00 00 00       	mov    $0x0,%esi
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db2:	b8 04 00 00 00       	mov    $0x4,%eax
  800db7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dba:	89 f7                	mov    %esi,%edi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 04                	push   $0x4
  800dd0:	68 60 26 80 00       	push   $0x802660
  800dd5:	6a 43                	push   $0x43
  800dd7:	68 7d 26 80 00       	push   $0x80267d
  800ddc:	e8 d3 10 00 00       	call   801eb4 <_panic>

00800de1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
  800de7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 05 00 00 00       	mov    $0x5,%eax
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e00:	85 c0                	test   %eax,%eax
  800e02:	7f 08                	jg     800e0c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	50                   	push   %eax
  800e10:	6a 05                	push   $0x5
  800e12:	68 60 26 80 00       	push   $0x802660
  800e17:	6a 43                	push   $0x43
  800e19:	68 7d 26 80 00       	push   $0x80267d
  800e1e:	e8 91 10 00 00       	call   801eb4 <_panic>

00800e23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	b8 06 00 00 00       	mov    $0x6,%eax
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7f 08                	jg     800e4e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4e:	83 ec 0c             	sub    $0xc,%esp
  800e51:	50                   	push   %eax
  800e52:	6a 06                	push   $0x6
  800e54:	68 60 26 80 00       	push   $0x802660
  800e59:	6a 43                	push   $0x43
  800e5b:	68 7d 26 80 00       	push   $0x80267d
  800e60:	e8 4f 10 00 00       	call   801eb4 <_panic>

00800e65 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 08 00 00 00       	mov    $0x8,%eax
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7f 08                	jg     800e90 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	50                   	push   %eax
  800e94:	6a 08                	push   $0x8
  800e96:	68 60 26 80 00       	push   $0x802660
  800e9b:	6a 43                	push   $0x43
  800e9d:	68 7d 26 80 00       	push   $0x80267d
  800ea2:	e8 0d 10 00 00       	call   801eb4 <_panic>

00800ea7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
  800ead:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec0:	89 df                	mov    %ebx,%edi
  800ec2:	89 de                	mov    %ebx,%esi
  800ec4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	7f 08                	jg     800ed2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	50                   	push   %eax
  800ed6:	6a 09                	push   $0x9
  800ed8:	68 60 26 80 00       	push   $0x802660
  800edd:	6a 43                	push   $0x43
  800edf:	68 7d 26 80 00       	push   $0x80267d
  800ee4:	e8 cb 0f 00 00       	call   801eb4 <_panic>

00800ee9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  800efa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f02:	89 df                	mov    %ebx,%edi
  800f04:	89 de                	mov    %ebx,%esi
  800f06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7f 08                	jg     800f14 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	50                   	push   %eax
  800f18:	6a 0a                	push   $0xa
  800f1a:	68 60 26 80 00       	push   $0x802660
  800f1f:	6a 43                	push   $0x43
  800f21:	68 7d 26 80 00       	push   $0x80267d
  800f26:	e8 89 0f 00 00       	call   801eb4 <_panic>

00800f2b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3c:	be 00 00 00 00       	mov    $0x0,%esi
  800f41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f47:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f64:	89 cb                	mov    %ecx,%ebx
  800f66:	89 cf                	mov    %ecx,%edi
  800f68:	89 ce                	mov    %ecx,%esi
  800f6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	7f 08                	jg     800f78 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	50                   	push   %eax
  800f7c:	6a 0d                	push   $0xd
  800f7e:	68 60 26 80 00       	push   $0x802660
  800f83:	6a 43                	push   $0x43
  800f85:	68 7d 26 80 00       	push   $0x80267d
  800f8a:	e8 25 0f 00 00       	call   801eb4 <_panic>

00800f8f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa5:	89 df                	mov    %ebx,%edi
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fc3:	89 cb                	mov    %ecx,%ebx
  800fc5:	89 cf                	mov    %ecx,%edi
  800fc7:	89 ce                	mov    %ecx,%esi
  800fc9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800fdc:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800fde:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800fe1:	83 3a 01             	cmpl   $0x1,(%edx)
  800fe4:	7e 09                	jle    800fef <argstart+0x1f>
  800fe6:	ba df 27 80 00       	mov    $0x8027df,%edx
  800feb:	85 c9                	test   %ecx,%ecx
  800fed:	75 05                	jne    800ff4 <argstart+0x24>
  800fef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff4:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ff7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <argnext>:

int
argnext(struct Argstate *args)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	53                   	push   %ebx
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80100a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801011:	8b 43 08             	mov    0x8(%ebx),%eax
  801014:	85 c0                	test   %eax,%eax
  801016:	74 72                	je     80108a <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801018:	80 38 00             	cmpb   $0x0,(%eax)
  80101b:	75 48                	jne    801065 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80101d:	8b 0b                	mov    (%ebx),%ecx
  80101f:	83 39 01             	cmpl   $0x1,(%ecx)
  801022:	74 58                	je     80107c <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801024:	8b 53 04             	mov    0x4(%ebx),%edx
  801027:	8b 42 04             	mov    0x4(%edx),%eax
  80102a:	80 38 2d             	cmpb   $0x2d,(%eax)
  80102d:	75 4d                	jne    80107c <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80102f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801033:	74 47                	je     80107c <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801035:	83 c0 01             	add    $0x1,%eax
  801038:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	8b 01                	mov    (%ecx),%eax
  801040:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801047:	50                   	push   %eax
  801048:	8d 42 08             	lea    0x8(%edx),%eax
  80104b:	50                   	push   %eax
  80104c:	83 c2 04             	add    $0x4,%edx
  80104f:	52                   	push   %edx
  801050:	e8 e5 fa ff ff       	call   800b3a <memmove>
		(*args->argc)--;
  801055:	8b 03                	mov    (%ebx),%eax
  801057:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80105a:	8b 43 08             	mov    0x8(%ebx),%eax
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	80 38 2d             	cmpb   $0x2d,(%eax)
  801063:	74 11                	je     801076 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801065:	8b 53 08             	mov    0x8(%ebx),%edx
  801068:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80106b:	83 c2 01             	add    $0x1,%edx
  80106e:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801074:	c9                   	leave  
  801075:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801076:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80107a:	75 e9                	jne    801065 <argnext+0x65>
	args->curarg = 0;
  80107c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801088:	eb e7                	jmp    801071 <argnext+0x71>
		return -1;
  80108a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80108f:	eb e0                	jmp    801071 <argnext+0x71>

00801091 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	53                   	push   %ebx
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80109b:	8b 43 08             	mov    0x8(%ebx),%eax
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	74 12                	je     8010b4 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8010a2:	80 38 00             	cmpb   $0x0,(%eax)
  8010a5:	74 12                	je     8010b9 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8010a7:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8010aa:	c7 43 08 df 27 80 00 	movl   $0x8027df,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8010b1:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8010b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    
	} else if (*args->argc > 1) {
  8010b9:	8b 13                	mov    (%ebx),%edx
  8010bb:	83 3a 01             	cmpl   $0x1,(%edx)
  8010be:	7f 10                	jg     8010d0 <argnextvalue+0x3f>
		args->argvalue = 0;
  8010c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010c7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8010ce:	eb e1                	jmp    8010b1 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8010d0:	8b 43 04             	mov    0x4(%ebx),%eax
  8010d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8010d6:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	8b 12                	mov    (%edx),%edx
  8010de:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8010e5:	52                   	push   %edx
  8010e6:	8d 50 08             	lea    0x8(%eax),%edx
  8010e9:	52                   	push   %edx
  8010ea:	83 c0 04             	add    $0x4,%eax
  8010ed:	50                   	push   %eax
  8010ee:	e8 47 fa ff ff       	call   800b3a <memmove>
		(*args->argc)--;
  8010f3:	8b 03                	mov    (%ebx),%eax
  8010f5:	83 28 01             	subl   $0x1,(%eax)
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	eb b4                	jmp    8010b1 <argnextvalue+0x20>

008010fd <argvalue>:
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801106:	8b 42 0c             	mov    0xc(%edx),%eax
  801109:	85 c0                	test   %eax,%eax
  80110b:	74 02                	je     80110f <argvalue+0x12>
}
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	52                   	push   %edx
  801113:	e8 79 ff ff ff       	call   801091 <argnextvalue>
  801118:	83 c4 10             	add    $0x10,%esp
  80111b:	eb f0                	jmp    80110d <argvalue+0x10>

0080111d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	05 00 00 00 30       	add    $0x30000000,%eax
  801128:	c1 e8 0c             	shr    $0xc,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801138:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80113d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    

00801144 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80114c:	89 c2                	mov    %eax,%edx
  80114e:	c1 ea 16             	shr    $0x16,%edx
  801151:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801158:	f6 c2 01             	test   $0x1,%dl
  80115b:	74 2d                	je     80118a <fd_alloc+0x46>
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	c1 ea 0c             	shr    $0xc,%edx
  801162:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801169:	f6 c2 01             	test   $0x1,%dl
  80116c:	74 1c                	je     80118a <fd_alloc+0x46>
  80116e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801173:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801178:	75 d2                	jne    80114c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801183:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801188:	eb 0a                	jmp    801194 <fd_alloc+0x50>
			*fd_store = fd;
  80118a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80118f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80119c:	83 f8 1f             	cmp    $0x1f,%eax
  80119f:	77 30                	ja     8011d1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a1:	c1 e0 0c             	shl    $0xc,%eax
  8011a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011af:	f6 c2 01             	test   $0x1,%dl
  8011b2:	74 24                	je     8011d8 <fd_lookup+0x42>
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	c1 ea 0c             	shr    $0xc,%edx
  8011b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	74 1a                	je     8011df <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c8:	89 02                	mov    %eax,(%edx)
	return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    
		return -E_INVAL;
  8011d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d6:	eb f7                	jmp    8011cf <fd_lookup+0x39>
		return -E_INVAL;
  8011d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dd:	eb f0                	jmp    8011cf <fd_lookup+0x39>
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e4:	eb e9                	jmp    8011cf <fd_lookup+0x39>

008011e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ef:	ba 08 27 80 00       	mov    $0x802708,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f9:	39 08                	cmp    %ecx,(%eax)
  8011fb:	74 33                	je     801230 <dev_lookup+0x4a>
  8011fd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801200:	8b 02                	mov    (%edx),%eax
  801202:	85 c0                	test   %eax,%eax
  801204:	75 f3                	jne    8011f9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801206:	a1 04 40 80 00       	mov    0x804004,%eax
  80120b:	8b 40 48             	mov    0x48(%eax),%eax
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	51                   	push   %ecx
  801212:	50                   	push   %eax
  801213:	68 8c 26 80 00       	push   $0x80268c
  801218:	e8 30 f0 ff ff       	call   80024d <cprintf>
	*dev = 0;
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    
			*dev = devtab[i];
  801230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801233:	89 01                	mov    %eax,(%ecx)
			return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
  80123a:	eb f2                	jmp    80122e <dev_lookup+0x48>

0080123c <fd_close>:
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 24             	sub    $0x24,%esp
  801245:	8b 75 08             	mov    0x8(%ebp),%esi
  801248:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80124b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801255:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801258:	50                   	push   %eax
  801259:	e8 38 ff ff ff       	call   801196 <fd_lookup>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 05                	js     80126c <fd_close+0x30>
	    || fd != fd2)
  801267:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80126a:	74 16                	je     801282 <fd_close+0x46>
		return (must_exist ? r : 0);
  80126c:	89 f8                	mov    %edi,%eax
  80126e:	84 c0                	test   %al,%al
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	0f 44 d8             	cmove  %eax,%ebx
}
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	ff 36                	pushl  (%esi)
  80128b:	e8 56 ff ff ff       	call   8011e6 <dev_lookup>
  801290:	89 c3                	mov    %eax,%ebx
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	78 1a                	js     8012b3 <fd_close+0x77>
		if (dev->dev_close)
  801299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80129f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 0b                	je     8012b3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	56                   	push   %esi
  8012ac:	ff d0                	call   *%eax
  8012ae:	89 c3                	mov    %eax,%ebx
  8012b0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	56                   	push   %esi
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 65 fb ff ff       	call   800e23 <sys_page_unmap>
	return r;
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	eb b5                	jmp    801278 <fd_close+0x3c>

008012c3 <close>:

int
close(int fdnum)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 c1 fe ff ff       	call   801196 <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	79 02                	jns    8012de <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    
		return fd_close(fd, 1);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	6a 01                	push   $0x1
  8012e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e6:	e8 51 ff ff ff       	call   80123c <fd_close>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	eb ec                	jmp    8012dc <close+0x19>

008012f0 <close_all>:

void
close_all(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	53                   	push   %ebx
  801300:	e8 be ff ff ff       	call   8012c3 <close>
	for (i = 0; i < MAXFD; i++)
  801305:	83 c3 01             	add    $0x1,%ebx
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	83 fb 20             	cmp    $0x20,%ebx
  80130e:	75 ec                	jne    8012fc <close_all+0xc>
}
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	57                   	push   %edi
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80131e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	ff 75 08             	pushl  0x8(%ebp)
  801325:	e8 6c fe ff ff       	call   801196 <fd_lookup>
  80132a:	89 c3                	mov    %eax,%ebx
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	0f 88 81 00 00 00    	js     8013b8 <dup+0xa3>
		return r;
	close(newfdnum);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	e8 81 ff ff ff       	call   8012c3 <close>

	newfd = INDEX2FD(newfdnum);
  801342:	8b 75 0c             	mov    0xc(%ebp),%esi
  801345:	c1 e6 0c             	shl    $0xc,%esi
  801348:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80134e:	83 c4 04             	add    $0x4,%esp
  801351:	ff 75 e4             	pushl  -0x1c(%ebp)
  801354:	e8 d4 fd ff ff       	call   80112d <fd2data>
  801359:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80135b:	89 34 24             	mov    %esi,(%esp)
  80135e:	e8 ca fd ff ff       	call   80112d <fd2data>
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	c1 e8 16             	shr    $0x16,%eax
  80136d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801374:	a8 01                	test   $0x1,%al
  801376:	74 11                	je     801389 <dup+0x74>
  801378:	89 d8                	mov    %ebx,%eax
  80137a:	c1 e8 0c             	shr    $0xc,%eax
  80137d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	75 39                	jne    8013c2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801389:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80138c:	89 d0                	mov    %edx,%eax
  80138e:	c1 e8 0c             	shr    $0xc,%eax
  801391:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a0:	50                   	push   %eax
  8013a1:	56                   	push   %esi
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 35 fa ff ff       	call   800de1 <sys_page_map>
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	83 c4 20             	add    $0x20,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 31                	js     8013e6 <dup+0xd1>
		goto err;

	return newfdnum;
  8013b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5f                   	pop    %edi
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d1:	50                   	push   %eax
  8013d2:	57                   	push   %edi
  8013d3:	6a 00                	push   $0x0
  8013d5:	53                   	push   %ebx
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 04 fa ff ff       	call   800de1 <sys_page_map>
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 20             	add    $0x20,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	79 a3                	jns    801389 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	56                   	push   %esi
  8013ea:	6a 00                	push   $0x0
  8013ec:	e8 32 fa ff ff       	call   800e23 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	57                   	push   %edi
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 27 fa ff ff       	call   800e23 <sys_page_unmap>
	return r;
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	eb b7                	jmp    8013b8 <dup+0xa3>

00801401 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	53                   	push   %ebx
  801405:	83 ec 1c             	sub    $0x1c,%esp
  801408:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	53                   	push   %ebx
  801410:	e8 81 fd ff ff       	call   801196 <fd_lookup>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 3f                	js     80145b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801426:	ff 30                	pushl  (%eax)
  801428:	e8 b9 fd ff ff       	call   8011e6 <dev_lookup>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 27                	js     80145b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801437:	8b 42 08             	mov    0x8(%edx),%eax
  80143a:	83 e0 03             	and    $0x3,%eax
  80143d:	83 f8 01             	cmp    $0x1,%eax
  801440:	74 1e                	je     801460 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801445:	8b 40 08             	mov    0x8(%eax),%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 35                	je     801481 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	ff 75 10             	pushl  0x10(%ebp)
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	52                   	push   %edx
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
}
  80145b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801460:	a1 04 40 80 00       	mov    0x804004,%eax
  801465:	8b 40 48             	mov    0x48(%eax),%eax
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	53                   	push   %ebx
  80146c:	50                   	push   %eax
  80146d:	68 cd 26 80 00       	push   $0x8026cd
  801472:	e8 d6 ed ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147f:	eb da                	jmp    80145b <read+0x5a>
		return -E_NOT_SUPP;
  801481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801486:	eb d3                	jmp    80145b <read+0x5a>

00801488 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	57                   	push   %edi
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	8b 7d 08             	mov    0x8(%ebp),%edi
  801494:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801497:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149c:	39 f3                	cmp    %esi,%ebx
  80149e:	73 23                	jae    8014c3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	89 f0                	mov    %esi,%eax
  8014a5:	29 d8                	sub    %ebx,%eax
  8014a7:	50                   	push   %eax
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	03 45 0c             	add    0xc(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	57                   	push   %edi
  8014af:	e8 4d ff ff ff       	call   801401 <read>
		if (m < 0)
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 06                	js     8014c1 <readn+0x39>
			return m;
		if (m == 0)
  8014bb:	74 06                	je     8014c3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014bd:	01 c3                	add    %eax,%ebx
  8014bf:	eb db                	jmp    80149c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c8:	5b                   	pop    %ebx
  8014c9:	5e                   	pop    %esi
  8014ca:	5f                   	pop    %edi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	53                   	push   %ebx
  8014d1:	83 ec 1c             	sub    $0x1c,%esp
  8014d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	53                   	push   %ebx
  8014dc:	e8 b5 fc ff ff       	call   801196 <fd_lookup>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 3a                	js     801522 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	ff 30                	pushl  (%eax)
  8014f4:	e8 ed fc ff ff       	call   8011e6 <dev_lookup>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 22                	js     801522 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801507:	74 1e                	je     801527 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150c:	8b 52 0c             	mov    0xc(%edx),%edx
  80150f:	85 d2                	test   %edx,%edx
  801511:	74 35                	je     801548 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	ff 75 10             	pushl  0x10(%ebp)
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	50                   	push   %eax
  80151d:	ff d2                	call   *%edx
  80151f:	83 c4 10             	add    $0x10,%esp
}
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801527:	a1 04 40 80 00       	mov    0x804004,%eax
  80152c:	8b 40 48             	mov    0x48(%eax),%eax
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	53                   	push   %ebx
  801533:	50                   	push   %eax
  801534:	68 e9 26 80 00       	push   $0x8026e9
  801539:	e8 0f ed ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801546:	eb da                	jmp    801522 <write+0x55>
		return -E_NOT_SUPP;
  801548:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154d:	eb d3                	jmp    801522 <write+0x55>

0080154f <seek>:

int
seek(int fdnum, off_t offset)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 35 fc ff ff       	call   801196 <fd_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 0e                	js     801576 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	53                   	push   %ebx
  80157c:	83 ec 1c             	sub    $0x1c,%esp
  80157f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801582:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	53                   	push   %ebx
  801587:	e8 0a fc ff ff       	call   801196 <fd_lookup>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 37                	js     8015ca <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	ff 30                	pushl  (%eax)
  80159f:	e8 42 fc ff ff       	call   8011e6 <dev_lookup>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 1f                	js     8015ca <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b2:	74 1b                	je     8015cf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 52 18             	mov    0x18(%edx),%edx
  8015ba:	85 d2                	test   %edx,%edx
  8015bc:	74 32                	je     8015f0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	ff d2                	call   *%edx
  8015c7:	83 c4 10             	add    $0x10,%esp
}
  8015ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015cf:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d4:	8b 40 48             	mov    0x48(%eax),%eax
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	53                   	push   %ebx
  8015db:	50                   	push   %eax
  8015dc:	68 ac 26 80 00       	push   $0x8026ac
  8015e1:	e8 67 ec ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ee:	eb da                	jmp    8015ca <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f5:	eb d3                	jmp    8015ca <ftruncate+0x52>

008015f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 1c             	sub    $0x1c,%esp
  8015fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 89 fb ff ff       	call   801196 <fd_lookup>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 4b                	js     80165f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	ff 30                	pushl  (%eax)
  801620:	e8 c1 fb ff ff       	call   8011e6 <dev_lookup>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 33                	js     80165f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801633:	74 2f                	je     801664 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801635:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801638:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163f:	00 00 00 
	stat->st_isdir = 0;
  801642:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801649:	00 00 00 
	stat->st_dev = dev;
  80164c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	53                   	push   %ebx
  801656:	ff 75 f0             	pushl  -0x10(%ebp)
  801659:	ff 50 14             	call   *0x14(%eax)
  80165c:	83 c4 10             	add    $0x10,%esp
}
  80165f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801662:	c9                   	leave  
  801663:	c3                   	ret    
		return -E_NOT_SUPP;
  801664:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801669:	eb f4                	jmp    80165f <fstat+0x68>

0080166b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	6a 00                	push   $0x0
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 bb 01 00 00       	call   801838 <open>
  80167d:	89 c3                	mov    %eax,%ebx
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 1b                	js     8016a1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	50                   	push   %eax
  80168d:	e8 65 ff ff ff       	call   8015f7 <fstat>
  801692:	89 c6                	mov    %eax,%esi
	close(fd);
  801694:	89 1c 24             	mov    %ebx,(%esp)
  801697:	e8 27 fc ff ff       	call   8012c3 <close>
	return r;
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	89 f3                	mov    %esi,%ebx
}
  8016a1:	89 d8                	mov    %ebx,%eax
  8016a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	89 c6                	mov    %eax,%esi
  8016b1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016b3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016ba:	74 27                	je     8016e3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016bc:	6a 07                	push   $0x7
  8016be:	68 00 50 80 00       	push   $0x805000
  8016c3:	56                   	push   %esi
  8016c4:	ff 35 00 40 80 00    	pushl  0x804000
  8016ca:	e8 af 08 00 00       	call   801f7e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016cf:	83 c4 0c             	add    $0xc,%esp
  8016d2:	6a 00                	push   $0x0
  8016d4:	53                   	push   %ebx
  8016d5:	6a 00                	push   $0x0
  8016d7:	e8 39 08 00 00       	call   801f15 <ipc_recv>
}
  8016dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	6a 01                	push   $0x1
  8016e8:	e8 e9 08 00 00       	call   801fd6 <ipc_find_env>
  8016ed:	a3 00 40 80 00       	mov    %eax,0x804000
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	eb c5                	jmp    8016bc <fsipc+0x12>

008016f7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8b 40 0c             	mov    0xc(%eax),%eax
  801703:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b8 02 00 00 00       	mov    $0x2,%eax
  80171a:	e8 8b ff ff ff       	call   8016aa <fsipc>
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <devfile_flush>:
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	8b 40 0c             	mov    0xc(%eax),%eax
  80172d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801732:	ba 00 00 00 00       	mov    $0x0,%edx
  801737:	b8 06 00 00 00       	mov    $0x6,%eax
  80173c:	e8 69 ff ff ff       	call   8016aa <fsipc>
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <devfile_stat>:
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	53                   	push   %ebx
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8b 40 0c             	mov    0xc(%eax),%eax
  801753:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801758:	ba 00 00 00 00       	mov    $0x0,%edx
  80175d:	b8 05 00 00 00       	mov    $0x5,%eax
  801762:	e8 43 ff ff ff       	call   8016aa <fsipc>
  801767:	85 c0                	test   %eax,%eax
  801769:	78 2c                	js     801797 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	68 00 50 80 00       	push   $0x805000
  801773:	53                   	push   %ebx
  801774:	e8 33 f2 ff ff       	call   8009ac <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801779:	a1 80 50 80 00       	mov    0x805080,%eax
  80177e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801784:	a1 84 50 80 00       	mov    0x805084,%eax
  801789:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <devfile_write>:
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8017a2:	68 18 27 80 00       	push   $0x802718
  8017a7:	68 90 00 00 00       	push   $0x90
  8017ac:	68 36 27 80 00       	push   $0x802736
  8017b1:	e8 fe 06 00 00       	call   801eb4 <_panic>

008017b6 <devfile_read>:
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d9:	e8 cc fe ff ff       	call   8016aa <fsipc>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 1f                	js     801803 <devfile_read+0x4d>
	assert(r <= n);
  8017e4:	39 f0                	cmp    %esi,%eax
  8017e6:	77 24                	ja     80180c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017e8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ed:	7f 33                	jg     801822 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	50                   	push   %eax
  8017f3:	68 00 50 80 00       	push   $0x805000
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	e8 3a f3 ff ff       	call   800b3a <memmove>
	return r;
  801800:	83 c4 10             	add    $0x10,%esp
}
  801803:	89 d8                	mov    %ebx,%eax
  801805:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    
	assert(r <= n);
  80180c:	68 41 27 80 00       	push   $0x802741
  801811:	68 48 27 80 00       	push   $0x802748
  801816:	6a 7c                	push   $0x7c
  801818:	68 36 27 80 00       	push   $0x802736
  80181d:	e8 92 06 00 00       	call   801eb4 <_panic>
	assert(r <= PGSIZE);
  801822:	68 5d 27 80 00       	push   $0x80275d
  801827:	68 48 27 80 00       	push   $0x802748
  80182c:	6a 7d                	push   $0x7d
  80182e:	68 36 27 80 00       	push   $0x802736
  801833:	e8 7c 06 00 00       	call   801eb4 <_panic>

00801838 <open>:
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	56                   	push   %esi
  80183c:	53                   	push   %ebx
  80183d:	83 ec 1c             	sub    $0x1c,%esp
  801840:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801843:	56                   	push   %esi
  801844:	e8 2a f1 ff ff       	call   800973 <strlen>
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801851:	7f 6c                	jg     8018bf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	e8 e5 f8 ff ff       	call   801144 <fd_alloc>
  80185f:	89 c3                	mov    %eax,%ebx
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	78 3c                	js     8018a4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	56                   	push   %esi
  80186c:	68 00 50 80 00       	push   $0x805000
  801871:	e8 36 f1 ff ff       	call   8009ac <strcpy>
	fsipcbuf.open.req_omode = mode;
  801876:	8b 45 0c             	mov    0xc(%ebp),%eax
  801879:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80187e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801881:	b8 01 00 00 00       	mov    $0x1,%eax
  801886:	e8 1f fe ff ff       	call   8016aa <fsipc>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	85 c0                	test   %eax,%eax
  801892:	78 19                	js     8018ad <open+0x75>
	return fd2num(fd);
  801894:	83 ec 0c             	sub    $0xc,%esp
  801897:	ff 75 f4             	pushl  -0xc(%ebp)
  80189a:	e8 7e f8 ff ff       	call   80111d <fd2num>
  80189f:	89 c3                	mov    %eax,%ebx
  8018a1:	83 c4 10             	add    $0x10,%esp
}
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    
		fd_close(fd, 0);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b5:	e8 82 f9 ff ff       	call   80123c <fd_close>
		return r;
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	eb e5                	jmp    8018a4 <open+0x6c>
		return -E_BAD_PATH;
  8018bf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018c4:	eb de                	jmp    8018a4 <open+0x6c>

008018c6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d6:	e8 cf fd ff ff       	call   8016aa <fsipc>
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8018dd:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018e1:	7f 01                	jg     8018e4 <writebuf+0x7>
  8018e3:	c3                   	ret    
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018ed:	ff 70 04             	pushl  0x4(%eax)
  8018f0:	8d 40 10             	lea    0x10(%eax),%eax
  8018f3:	50                   	push   %eax
  8018f4:	ff 33                	pushl  (%ebx)
  8018f6:	e8 d2 fb ff ff       	call   8014cd <write>
		if (result > 0)
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	85 c0                	test   %eax,%eax
  801900:	7e 03                	jle    801905 <writebuf+0x28>
			b->result += result;
  801902:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801905:	39 43 04             	cmp    %eax,0x4(%ebx)
  801908:	74 0d                	je     801917 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80190a:	85 c0                	test   %eax,%eax
  80190c:	ba 00 00 00 00       	mov    $0x0,%edx
  801911:	0f 4f c2             	cmovg  %edx,%eax
  801914:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <putch>:

static void
putch(int ch, void *thunk)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	53                   	push   %ebx
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801926:	8b 53 04             	mov    0x4(%ebx),%edx
  801929:	8d 42 01             	lea    0x1(%edx),%eax
  80192c:	89 43 04             	mov    %eax,0x4(%ebx)
  80192f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801932:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801936:	3d 00 01 00 00       	cmp    $0x100,%eax
  80193b:	74 06                	je     801943 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80193d:	83 c4 04             	add    $0x4,%esp
  801940:	5b                   	pop    %ebx
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    
		writebuf(b);
  801943:	89 d8                	mov    %ebx,%eax
  801945:	e8 93 ff ff ff       	call   8018dd <writebuf>
		b->idx = 0;
  80194a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801951:	eb ea                	jmp    80193d <putch+0x21>

00801953 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801965:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80196c:	00 00 00 
	b.result = 0;
  80196f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801976:	00 00 00 
	b.error = 1;
  801979:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801980:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801983:	ff 75 10             	pushl  0x10(%ebp)
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80198f:	50                   	push   %eax
  801990:	68 1c 19 80 00       	push   $0x80191c
  801995:	e8 e0 e9 ff ff       	call   80037a <vprintfmt>
	if (b.idx > 0)
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019a4:	7f 11                	jg     8019b7 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8019a6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    
		writebuf(&b);
  8019b7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019bd:	e8 1b ff ff ff       	call   8018dd <writebuf>
  8019c2:	eb e2                	jmp    8019a6 <vfprintf+0x53>

008019c4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019ca:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019cd:	50                   	push   %eax
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	e8 7a ff ff ff       	call   801953 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <printf>:

int
printf(const char *fmt, ...)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019e1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019e4:	50                   	push   %eax
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 01                	push   $0x1
  8019ea:	e8 64 ff ff ff       	call   801953 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	e8 29 f7 ff ff       	call   80112d <fd2data>
  801a04:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a06:	83 c4 08             	add    $0x8,%esp
  801a09:	68 69 27 80 00       	push   $0x802769
  801a0e:	53                   	push   %ebx
  801a0f:	e8 98 ef ff ff       	call   8009ac <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a14:	8b 46 04             	mov    0x4(%esi),%eax
  801a17:	2b 06                	sub    (%esi),%eax
  801a19:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a26:	00 00 00 
	stat->st_dev = &devpipe;
  801a29:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a30:	30 80 00 
	return 0;
}
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
  801a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a49:	53                   	push   %ebx
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 d2 f3 ff ff       	call   800e23 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a51:	89 1c 24             	mov    %ebx,(%esp)
  801a54:	e8 d4 f6 ff ff       	call   80112d <fd2data>
  801a59:	83 c4 08             	add    $0x8,%esp
  801a5c:	50                   	push   %eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 bf f3 ff ff       	call   800e23 <sys_page_unmap>
}
  801a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <_pipeisclosed>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	89 c7                	mov    %eax,%edi
  801a74:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a76:	a1 04 40 80 00       	mov    0x804004,%eax
  801a7b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	57                   	push   %edi
  801a82:	e8 8a 05 00 00       	call   802011 <pageref>
  801a87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a8a:	89 34 24             	mov    %esi,(%esp)
  801a8d:	e8 7f 05 00 00       	call   802011 <pageref>
		nn = thisenv->env_runs;
  801a92:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a98:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	39 cb                	cmp    %ecx,%ebx
  801aa0:	74 1b                	je     801abd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801aa2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aa5:	75 cf                	jne    801a76 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801aa7:	8b 42 58             	mov    0x58(%edx),%eax
  801aaa:	6a 01                	push   $0x1
  801aac:	50                   	push   %eax
  801aad:	53                   	push   %ebx
  801aae:	68 70 27 80 00       	push   $0x802770
  801ab3:	e8 95 e7 ff ff       	call   80024d <cprintf>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	eb b9                	jmp    801a76 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801abd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ac0:	0f 94 c0             	sete   %al
  801ac3:	0f b6 c0             	movzbl %al,%eax
}
  801ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5f                   	pop    %edi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    

00801ace <devpipe_write>:
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 28             	sub    $0x28,%esp
  801ad7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ada:	56                   	push   %esi
  801adb:	e8 4d f6 ff ff       	call   80112d <fd2data>
  801ae0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aea:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801aed:	74 4f                	je     801b3e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aef:	8b 43 04             	mov    0x4(%ebx),%eax
  801af2:	8b 0b                	mov    (%ebx),%ecx
  801af4:	8d 51 20             	lea    0x20(%ecx),%edx
  801af7:	39 d0                	cmp    %edx,%eax
  801af9:	72 14                	jb     801b0f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801afb:	89 da                	mov    %ebx,%edx
  801afd:	89 f0                	mov    %esi,%eax
  801aff:	e8 65 ff ff ff       	call   801a69 <_pipeisclosed>
  801b04:	85 c0                	test   %eax,%eax
  801b06:	75 3b                	jne    801b43 <devpipe_write+0x75>
			sys_yield();
  801b08:	e8 72 f2 ff ff       	call   800d7f <sys_yield>
  801b0d:	eb e0                	jmp    801aef <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b12:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b16:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b19:	89 c2                	mov    %eax,%edx
  801b1b:	c1 fa 1f             	sar    $0x1f,%edx
  801b1e:	89 d1                	mov    %edx,%ecx
  801b20:	c1 e9 1b             	shr    $0x1b,%ecx
  801b23:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b26:	83 e2 1f             	and    $0x1f,%edx
  801b29:	29 ca                	sub    %ecx,%edx
  801b2b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b2f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b33:	83 c0 01             	add    $0x1,%eax
  801b36:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b39:	83 c7 01             	add    $0x1,%edi
  801b3c:	eb ac                	jmp    801aea <devpipe_write+0x1c>
	return i;
  801b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b41:	eb 05                	jmp    801b48 <devpipe_write+0x7a>
				return 0;
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5f                   	pop    %edi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <devpipe_read>:
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	57                   	push   %edi
  801b54:	56                   	push   %esi
  801b55:	53                   	push   %ebx
  801b56:	83 ec 18             	sub    $0x18,%esp
  801b59:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b5c:	57                   	push   %edi
  801b5d:	e8 cb f5 ff ff       	call   80112d <fd2data>
  801b62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	be 00 00 00 00       	mov    $0x0,%esi
  801b6c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b6f:	75 14                	jne    801b85 <devpipe_read+0x35>
	return i;
  801b71:	8b 45 10             	mov    0x10(%ebp),%eax
  801b74:	eb 02                	jmp    801b78 <devpipe_read+0x28>
				return i;
  801b76:	89 f0                	mov    %esi,%eax
}
  801b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
			sys_yield();
  801b80:	e8 fa f1 ff ff       	call   800d7f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b85:	8b 03                	mov    (%ebx),%eax
  801b87:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b8a:	75 18                	jne    801ba4 <devpipe_read+0x54>
			if (i > 0)
  801b8c:	85 f6                	test   %esi,%esi
  801b8e:	75 e6                	jne    801b76 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b90:	89 da                	mov    %ebx,%edx
  801b92:	89 f8                	mov    %edi,%eax
  801b94:	e8 d0 fe ff ff       	call   801a69 <_pipeisclosed>
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	74 e3                	je     801b80 <devpipe_read+0x30>
				return 0;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba2:	eb d4                	jmp    801b78 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ba4:	99                   	cltd   
  801ba5:	c1 ea 1b             	shr    $0x1b,%edx
  801ba8:	01 d0                	add    %edx,%eax
  801baa:	83 e0 1f             	and    $0x1f,%eax
  801bad:	29 d0                	sub    %edx,%eax
  801baf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bba:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bbd:	83 c6 01             	add    $0x1,%esi
  801bc0:	eb aa                	jmp    801b6c <devpipe_read+0x1c>

00801bc2 <pipe>:
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcd:	50                   	push   %eax
  801bce:	e8 71 f5 ff ff       	call   801144 <fd_alloc>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 88 23 01 00 00    	js     801d03 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	68 07 04 00 00       	push   $0x407
  801be8:	ff 75 f4             	pushl  -0xc(%ebp)
  801beb:	6a 00                	push   $0x0
  801bed:	e8 ac f1 ff ff       	call   800d9e <sys_page_alloc>
  801bf2:	89 c3                	mov    %eax,%ebx
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	0f 88 04 01 00 00    	js     801d03 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c05:	50                   	push   %eax
  801c06:	e8 39 f5 ff ff       	call   801144 <fd_alloc>
  801c0b:	89 c3                	mov    %eax,%ebx
  801c0d:	83 c4 10             	add    $0x10,%esp
  801c10:	85 c0                	test   %eax,%eax
  801c12:	0f 88 db 00 00 00    	js     801cf3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	68 07 04 00 00       	push   $0x407
  801c20:	ff 75 f0             	pushl  -0x10(%ebp)
  801c23:	6a 00                	push   $0x0
  801c25:	e8 74 f1 ff ff       	call   800d9e <sys_page_alloc>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	0f 88 bc 00 00 00    	js     801cf3 <pipe+0x131>
	va = fd2data(fd0);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3d:	e8 eb f4 ff ff       	call   80112d <fd2data>
  801c42:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c44:	83 c4 0c             	add    $0xc,%esp
  801c47:	68 07 04 00 00       	push   $0x407
  801c4c:	50                   	push   %eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	e8 4a f1 ff ff       	call   800d9e <sys_page_alloc>
  801c54:	89 c3                	mov    %eax,%ebx
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	0f 88 82 00 00 00    	js     801ce3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c61:	83 ec 0c             	sub    $0xc,%esp
  801c64:	ff 75 f0             	pushl  -0x10(%ebp)
  801c67:	e8 c1 f4 ff ff       	call   80112d <fd2data>
  801c6c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c73:	50                   	push   %eax
  801c74:	6a 00                	push   $0x0
  801c76:	56                   	push   %esi
  801c77:	6a 00                	push   $0x0
  801c79:	e8 63 f1 ff ff       	call   800de1 <sys_page_map>
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	83 c4 20             	add    $0x20,%esp
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 4e                	js     801cd5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c87:	a1 20 30 80 00       	mov    0x803020,%eax
  801c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c94:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c9e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	e8 68 f4 ff ff       	call   80111d <fd2num>
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cba:	83 c4 04             	add    $0x4,%esp
  801cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc0:	e8 58 f4 ff ff       	call   80111d <fd2num>
  801cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd3:	eb 2e                	jmp    801d03 <pipe+0x141>
	sys_page_unmap(0, va);
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	56                   	push   %esi
  801cd9:	6a 00                	push   $0x0
  801cdb:	e8 43 f1 ff ff       	call   800e23 <sys_page_unmap>
  801ce0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ce3:	83 ec 08             	sub    $0x8,%esp
  801ce6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 33 f1 ff ff       	call   800e23 <sys_page_unmap>
  801cf0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cf3:	83 ec 08             	sub    $0x8,%esp
  801cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 23 f1 ff ff       	call   800e23 <sys_page_unmap>
  801d00:	83 c4 10             	add    $0x10,%esp
}
  801d03:	89 d8                	mov    %ebx,%eax
  801d05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5e                   	pop    %esi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    

00801d0c <pipeisclosed>:
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d15:	50                   	push   %eax
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 78 f4 ff ff       	call   801196 <fd_lookup>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	78 18                	js     801d3d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2b:	e8 fd f3 ff ff       	call   80112d <fd2data>
	return _pipeisclosed(fd, p);
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	e8 2f fd ff ff       	call   801a69 <_pipeisclosed>
  801d3a:	83 c4 10             	add    $0x10,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	c3                   	ret    

00801d45 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d4b:	68 88 27 80 00       	push   $0x802788
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	e8 54 ec ff ff       	call   8009ac <strcpy>
	return 0;
}
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <devcons_write>:
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	57                   	push   %edi
  801d63:	56                   	push   %esi
  801d64:	53                   	push   %ebx
  801d65:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d6b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d70:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d76:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d79:	73 31                	jae    801dac <devcons_write+0x4d>
		m = n - tot;
  801d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d7e:	29 f3                	sub    %esi,%ebx
  801d80:	83 fb 7f             	cmp    $0x7f,%ebx
  801d83:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d88:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	53                   	push   %ebx
  801d8f:	89 f0                	mov    %esi,%eax
  801d91:	03 45 0c             	add    0xc(%ebp),%eax
  801d94:	50                   	push   %eax
  801d95:	57                   	push   %edi
  801d96:	e8 9f ed ff ff       	call   800b3a <memmove>
		sys_cputs(buf, m);
  801d9b:	83 c4 08             	add    $0x8,%esp
  801d9e:	53                   	push   %ebx
  801d9f:	57                   	push   %edi
  801da0:	e8 3d ef ff ff       	call   800ce2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801da5:	01 de                	add    %ebx,%esi
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	eb ca                	jmp    801d76 <devcons_write+0x17>
}
  801dac:	89 f0                	mov    %esi,%eax
  801dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    

00801db6 <devcons_read>:
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801dc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dc5:	74 21                	je     801de8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801dc7:	e8 34 ef ff ff       	call   800d00 <sys_cgetc>
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	75 07                	jne    801dd7 <devcons_read+0x21>
		sys_yield();
  801dd0:	e8 aa ef ff ff       	call   800d7f <sys_yield>
  801dd5:	eb f0                	jmp    801dc7 <devcons_read+0x11>
	if (c < 0)
  801dd7:	78 0f                	js     801de8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801dd9:	83 f8 04             	cmp    $0x4,%eax
  801ddc:	74 0c                	je     801dea <devcons_read+0x34>
	*(char*)vbuf = c;
  801dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de1:	88 02                	mov    %al,(%edx)
	return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	eb f7                	jmp    801de8 <devcons_read+0x32>

00801df1 <cputchar>:
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dfd:	6a 01                	push   $0x1
  801dff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e02:	50                   	push   %eax
  801e03:	e8 da ee ff ff       	call   800ce2 <sys_cputs>
}
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <getchar>:
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e13:	6a 01                	push   $0x1
  801e15:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	6a 00                	push   $0x0
  801e1b:	e8 e1 f5 ff ff       	call   801401 <read>
	if (r < 0)
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 06                	js     801e2d <getchar+0x20>
	if (r < 1)
  801e27:	74 06                	je     801e2f <getchar+0x22>
	return c;
  801e29:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    
		return -E_EOF;
  801e2f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e34:	eb f7                	jmp    801e2d <getchar+0x20>

00801e36 <iscons>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	e8 4e f3 ff ff       	call   801196 <fd_lookup>
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 11                	js     801e60 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e58:	39 10                	cmp    %edx,(%eax)
  801e5a:	0f 94 c0             	sete   %al
  801e5d:	0f b6 c0             	movzbl %al,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <opencons>:
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6b:	50                   	push   %eax
  801e6c:	e8 d3 f2 ff ff       	call   801144 <fd_alloc>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 3a                	js     801eb2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e78:	83 ec 04             	sub    $0x4,%esp
  801e7b:	68 07 04 00 00       	push   $0x407
  801e80:	ff 75 f4             	pushl  -0xc(%ebp)
  801e83:	6a 00                	push   $0x0
  801e85:	e8 14 ef ff ff       	call   800d9e <sys_page_alloc>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 21                	js     801eb2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e9a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	50                   	push   %eax
  801eaa:	e8 6e f2 ff ff       	call   80111d <fd2num>
  801eaf:	83 c4 10             	add    $0x10,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	56                   	push   %esi
  801eb8:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801eb9:	a1 04 40 80 00       	mov    0x804004,%eax
  801ebe:	8b 40 48             	mov    0x48(%eax),%eax
  801ec1:	83 ec 04             	sub    $0x4,%esp
  801ec4:	68 c4 27 80 00       	push   $0x8027c4
  801ec9:	50                   	push   %eax
  801eca:	68 94 27 80 00       	push   $0x802794
  801ecf:	e8 79 e3 ff ff       	call   80024d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801ed4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ed7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801edd:	e8 7e ee ff ff       	call   800d60 <sys_getenvid>
  801ee2:	83 c4 04             	add    $0x4,%esp
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	56                   	push   %esi
  801eec:	50                   	push   %eax
  801eed:	68 a0 27 80 00       	push   $0x8027a0
  801ef2:	e8 56 e3 ff ff       	call   80024d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ef7:	83 c4 18             	add    $0x18,%esp
  801efa:	53                   	push   %ebx
  801efb:	ff 75 10             	pushl  0x10(%ebp)
  801efe:	e8 f9 e2 ff ff       	call   8001fc <vcprintf>
	cprintf("\n");
  801f03:	c7 04 24 de 27 80 00 	movl   $0x8027de,(%esp)
  801f0a:	e8 3e e3 ff ff       	call   80024d <cprintf>
  801f0f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f12:	cc                   	int3   
  801f13:	eb fd                	jmp    801f12 <_panic+0x5e>

00801f15 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	56                   	push   %esi
  801f19:	53                   	push   %ebx
  801f1a:	8b 75 08             	mov    0x8(%ebp),%esi
  801f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801f23:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f25:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f2a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	50                   	push   %eax
  801f31:	e8 18 f0 ff ff       	call   800f4e <sys_ipc_recv>
	if(ret < 0){
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	78 2b                	js     801f68 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801f3d:	85 f6                	test   %esi,%esi
  801f3f:	74 0a                	je     801f4b <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801f41:	a1 04 40 80 00       	mov    0x804004,%eax
  801f46:	8b 40 74             	mov    0x74(%eax),%eax
  801f49:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801f4b:	85 db                	test   %ebx,%ebx
  801f4d:	74 0a                	je     801f59 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801f4f:	a1 04 40 80 00       	mov    0x804004,%eax
  801f54:	8b 40 78             	mov    0x78(%eax),%eax
  801f57:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801f59:	a1 04 40 80 00       	mov    0x804004,%eax
  801f5e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    
		if(from_env_store)
  801f68:	85 f6                	test   %esi,%esi
  801f6a:	74 06                	je     801f72 <ipc_recv+0x5d>
			*from_env_store = 0;
  801f6c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801f72:	85 db                	test   %ebx,%ebx
  801f74:	74 eb                	je     801f61 <ipc_recv+0x4c>
			*perm_store = 0;
  801f76:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801f7c:	eb e3                	jmp    801f61 <ipc_recv+0x4c>

00801f7e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801f90:	85 db                	test   %ebx,%ebx
  801f92:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f97:	0f 44 d8             	cmove  %eax,%ebx
  801f9a:	eb 05                	jmp    801fa1 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801f9c:	e8 de ed ff ff       	call   800d7f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801fa1:	ff 75 14             	pushl  0x14(%ebp)
  801fa4:	53                   	push   %ebx
  801fa5:	56                   	push   %esi
  801fa6:	57                   	push   %edi
  801fa7:	e8 7f ef ff ff       	call   800f2b <sys_ipc_try_send>
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	74 1b                	je     801fce <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801fb3:	79 e7                	jns    801f9c <ipc_send+0x1e>
  801fb5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fb8:	74 e2                	je     801f9c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	68 cb 27 80 00       	push   $0x8027cb
  801fc2:	6a 49                	push   $0x49
  801fc4:	68 e0 27 80 00       	push   $0x8027e0
  801fc9:	e8 e6 fe ff ff       	call   801eb4 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd1:	5b                   	pop    %ebx
  801fd2:	5e                   	pop    %esi
  801fd3:	5f                   	pop    %edi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    

00801fd6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fe1:	89 c2                	mov    %eax,%edx
  801fe3:	c1 e2 07             	shl    $0x7,%edx
  801fe6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fec:	8b 52 50             	mov    0x50(%edx),%edx
  801fef:	39 ca                	cmp    %ecx,%edx
  801ff1:	74 11                	je     802004 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801ff3:	83 c0 01             	add    $0x1,%eax
  801ff6:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ffb:	75 e4                	jne    801fe1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	eb 0b                	jmp    80200f <ipc_find_env+0x39>
			return envs[i].env_id;
  802004:	c1 e0 07             	shl    $0x7,%eax
  802007:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80200c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802017:	89 d0                	mov    %edx,%eax
  802019:	c1 e8 16             	shr    $0x16,%eax
  80201c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802028:	f6 c1 01             	test   $0x1,%cl
  80202b:	74 1d                	je     80204a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80202d:	c1 ea 0c             	shr    $0xc,%edx
  802030:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802037:	f6 c2 01             	test   $0x1,%dl
  80203a:	74 0e                	je     80204a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80203c:	c1 ea 0c             	shr    $0xc,%edx
  80203f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802046:	ef 
  802047:	0f b7 c0             	movzwl %ax,%eax
}
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	66 90                	xchg   %ax,%ax
  80204e:	66 90                	xchg   %ax,%ax

00802050 <__udivdi3>:
  802050:	55                   	push   %ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 1c             	sub    $0x1c,%esp
  802057:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80205b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80205f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802063:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802067:	85 d2                	test   %edx,%edx
  802069:	75 4d                	jne    8020b8 <__udivdi3+0x68>
  80206b:	39 f3                	cmp    %esi,%ebx
  80206d:	76 19                	jbe    802088 <__udivdi3+0x38>
  80206f:	31 ff                	xor    %edi,%edi
  802071:	89 e8                	mov    %ebp,%eax
  802073:	89 f2                	mov    %esi,%edx
  802075:	f7 f3                	div    %ebx
  802077:	89 fa                	mov    %edi,%edx
  802079:	83 c4 1c             	add    $0x1c,%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5f                   	pop    %edi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
  802081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802088:	89 d9                	mov    %ebx,%ecx
  80208a:	85 db                	test   %ebx,%ebx
  80208c:	75 0b                	jne    802099 <__udivdi3+0x49>
  80208e:	b8 01 00 00 00       	mov    $0x1,%eax
  802093:	31 d2                	xor    %edx,%edx
  802095:	f7 f3                	div    %ebx
  802097:	89 c1                	mov    %eax,%ecx
  802099:	31 d2                	xor    %edx,%edx
  80209b:	89 f0                	mov    %esi,%eax
  80209d:	f7 f1                	div    %ecx
  80209f:	89 c6                	mov    %eax,%esi
  8020a1:	89 e8                	mov    %ebp,%eax
  8020a3:	89 f7                	mov    %esi,%edi
  8020a5:	f7 f1                	div    %ecx
  8020a7:	89 fa                	mov    %edi,%edx
  8020a9:	83 c4 1c             	add    $0x1c,%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5f                   	pop    %edi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    
  8020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	39 f2                	cmp    %esi,%edx
  8020ba:	77 1c                	ja     8020d8 <__udivdi3+0x88>
  8020bc:	0f bd fa             	bsr    %edx,%edi
  8020bf:	83 f7 1f             	xor    $0x1f,%edi
  8020c2:	75 2c                	jne    8020f0 <__udivdi3+0xa0>
  8020c4:	39 f2                	cmp    %esi,%edx
  8020c6:	72 06                	jb     8020ce <__udivdi3+0x7e>
  8020c8:	31 c0                	xor    %eax,%eax
  8020ca:	39 eb                	cmp    %ebp,%ebx
  8020cc:	77 a9                	ja     802077 <__udivdi3+0x27>
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d3:	eb a2                	jmp    802077 <__udivdi3+0x27>
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	31 ff                	xor    %edi,%edi
  8020da:	31 c0                	xor    %eax,%eax
  8020dc:	89 fa                	mov    %edi,%edx
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020ed:	8d 76 00             	lea    0x0(%esi),%esi
  8020f0:	89 f9                	mov    %edi,%ecx
  8020f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020f7:	29 f8                	sub    %edi,%eax
  8020f9:	d3 e2                	shl    %cl,%edx
  8020fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ff:	89 c1                	mov    %eax,%ecx
  802101:	89 da                	mov    %ebx,%edx
  802103:	d3 ea                	shr    %cl,%edx
  802105:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802109:	09 d1                	or     %edx,%ecx
  80210b:	89 f2                	mov    %esi,%edx
  80210d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802111:	89 f9                	mov    %edi,%ecx
  802113:	d3 e3                	shl    %cl,%ebx
  802115:	89 c1                	mov    %eax,%ecx
  802117:	d3 ea                	shr    %cl,%edx
  802119:	89 f9                	mov    %edi,%ecx
  80211b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80211f:	89 eb                	mov    %ebp,%ebx
  802121:	d3 e6                	shl    %cl,%esi
  802123:	89 c1                	mov    %eax,%ecx
  802125:	d3 eb                	shr    %cl,%ebx
  802127:	09 de                	or     %ebx,%esi
  802129:	89 f0                	mov    %esi,%eax
  80212b:	f7 74 24 08          	divl   0x8(%esp)
  80212f:	89 d6                	mov    %edx,%esi
  802131:	89 c3                	mov    %eax,%ebx
  802133:	f7 64 24 0c          	mull   0xc(%esp)
  802137:	39 d6                	cmp    %edx,%esi
  802139:	72 15                	jb     802150 <__udivdi3+0x100>
  80213b:	89 f9                	mov    %edi,%ecx
  80213d:	d3 e5                	shl    %cl,%ebp
  80213f:	39 c5                	cmp    %eax,%ebp
  802141:	73 04                	jae    802147 <__udivdi3+0xf7>
  802143:	39 d6                	cmp    %edx,%esi
  802145:	74 09                	je     802150 <__udivdi3+0x100>
  802147:	89 d8                	mov    %ebx,%eax
  802149:	31 ff                	xor    %edi,%edi
  80214b:	e9 27 ff ff ff       	jmp    802077 <__udivdi3+0x27>
  802150:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802153:	31 ff                	xor    %edi,%edi
  802155:	e9 1d ff ff ff       	jmp    802077 <__udivdi3+0x27>
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <__umoddi3>:
  802160:	55                   	push   %ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 1c             	sub    $0x1c,%esp
  802167:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80216b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80216f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802177:	89 da                	mov    %ebx,%edx
  802179:	85 c0                	test   %eax,%eax
  80217b:	75 43                	jne    8021c0 <__umoddi3+0x60>
  80217d:	39 df                	cmp    %ebx,%edi
  80217f:	76 17                	jbe    802198 <__umoddi3+0x38>
  802181:	89 f0                	mov    %esi,%eax
  802183:	f7 f7                	div    %edi
  802185:	89 d0                	mov    %edx,%eax
  802187:	31 d2                	xor    %edx,%edx
  802189:	83 c4 1c             	add    $0x1c,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    
  802191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802198:	89 fd                	mov    %edi,%ebp
  80219a:	85 ff                	test   %edi,%edi
  80219c:	75 0b                	jne    8021a9 <__umoddi3+0x49>
  80219e:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a3:	31 d2                	xor    %edx,%edx
  8021a5:	f7 f7                	div    %edi
  8021a7:	89 c5                	mov    %eax,%ebp
  8021a9:	89 d8                	mov    %ebx,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	f7 f5                	div    %ebp
  8021af:	89 f0                	mov    %esi,%eax
  8021b1:	f7 f5                	div    %ebp
  8021b3:	89 d0                	mov    %edx,%eax
  8021b5:	eb d0                	jmp    802187 <__umoddi3+0x27>
  8021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	89 f1                	mov    %esi,%ecx
  8021c2:	39 d8                	cmp    %ebx,%eax
  8021c4:	76 0a                	jbe    8021d0 <__umoddi3+0x70>
  8021c6:	89 f0                	mov    %esi,%eax
  8021c8:	83 c4 1c             	add    $0x1c,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5f                   	pop    %edi
  8021ce:	5d                   	pop    %ebp
  8021cf:	c3                   	ret    
  8021d0:	0f bd e8             	bsr    %eax,%ebp
  8021d3:	83 f5 1f             	xor    $0x1f,%ebp
  8021d6:	75 20                	jne    8021f8 <__umoddi3+0x98>
  8021d8:	39 d8                	cmp    %ebx,%eax
  8021da:	0f 82 b0 00 00 00    	jb     802290 <__umoddi3+0x130>
  8021e0:	39 f7                	cmp    %esi,%edi
  8021e2:	0f 86 a8 00 00 00    	jbe    802290 <__umoddi3+0x130>
  8021e8:	89 c8                	mov    %ecx,%eax
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	89 e9                	mov    %ebp,%ecx
  8021fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8021ff:	29 ea                	sub    %ebp,%edx
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 44 24 08          	mov    %eax,0x8(%esp)
  802207:	89 d1                	mov    %edx,%ecx
  802209:	89 f8                	mov    %edi,%eax
  80220b:	d3 e8                	shr    %cl,%eax
  80220d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802211:	89 54 24 04          	mov    %edx,0x4(%esp)
  802215:	8b 54 24 04          	mov    0x4(%esp),%edx
  802219:	09 c1                	or     %eax,%ecx
  80221b:	89 d8                	mov    %ebx,%eax
  80221d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802221:	89 e9                	mov    %ebp,%ecx
  802223:	d3 e7                	shl    %cl,%edi
  802225:	89 d1                	mov    %edx,%ecx
  802227:	d3 e8                	shr    %cl,%eax
  802229:	89 e9                	mov    %ebp,%ecx
  80222b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80222f:	d3 e3                	shl    %cl,%ebx
  802231:	89 c7                	mov    %eax,%edi
  802233:	89 d1                	mov    %edx,%ecx
  802235:	89 f0                	mov    %esi,%eax
  802237:	d3 e8                	shr    %cl,%eax
  802239:	89 e9                	mov    %ebp,%ecx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	d3 e6                	shl    %cl,%esi
  80223f:	09 d8                	or     %ebx,%eax
  802241:	f7 74 24 08          	divl   0x8(%esp)
  802245:	89 d1                	mov    %edx,%ecx
  802247:	89 f3                	mov    %esi,%ebx
  802249:	f7 64 24 0c          	mull   0xc(%esp)
  80224d:	89 c6                	mov    %eax,%esi
  80224f:	89 d7                	mov    %edx,%edi
  802251:	39 d1                	cmp    %edx,%ecx
  802253:	72 06                	jb     80225b <__umoddi3+0xfb>
  802255:	75 10                	jne    802267 <__umoddi3+0x107>
  802257:	39 c3                	cmp    %eax,%ebx
  802259:	73 0c                	jae    802267 <__umoddi3+0x107>
  80225b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80225f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802263:	89 d7                	mov    %edx,%edi
  802265:	89 c6                	mov    %eax,%esi
  802267:	89 ca                	mov    %ecx,%edx
  802269:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80226e:	29 f3                	sub    %esi,%ebx
  802270:	19 fa                	sbb    %edi,%edx
  802272:	89 d0                	mov    %edx,%eax
  802274:	d3 e0                	shl    %cl,%eax
  802276:	89 e9                	mov    %ebp,%ecx
  802278:	d3 eb                	shr    %cl,%ebx
  80227a:	d3 ea                	shr    %cl,%edx
  80227c:	09 d8                	or     %ebx,%eax
  80227e:	83 c4 1c             	add    $0x1c,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
  802286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80228d:	8d 76 00             	lea    0x0(%esi),%esi
  802290:	89 da                	mov    %ebx,%edx
  802292:	29 fe                	sub    %edi,%esi
  802294:	19 c2                	sbb    %eax,%edx
  802296:	89 f1                	mov    %esi,%ecx
  802298:	89 c8                	mov    %ecx,%eax
  80229a:	e9 4b ff ff ff       	jmp    8021ea <__umoddi3+0x8a>
