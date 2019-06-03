
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
  800039:	68 40 28 80 00       	push   $0x802840
  80003e:	e8 1f 02 00 00       	call   800262 <cprintf>
	exit();
  800043:	e8 6b 01 00 00       	call   8001b3 <exit>
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
  800067:	e8 1c 10 00 00       	call   801088 <argstart>
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
  800083:	e8 30 10 00 00       	call   8010b8 <argnext>
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
  8000bd:	68 54 28 80 00       	push   $0x802854
  8000c2:	e8 9b 01 00 00       	call   800262 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 d8 15 00 00       	call   8016b4 <fstat>
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
  8000f8:	68 54 28 80 00       	push   $0x802854
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 e4 19 00 00       	call   801ae8 <fprintf>
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
  80011a:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800121:	00 00 00 
	envid_t find = sys_getenvid();
  800124:	e8 4c 0c 00 00       	call   800d75 <sys_getenvid>
  800129:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
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
  800172:	89 1d 08 40 80 00    	mov    %ebx,0x804008
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

	cprintf("call umain!\n");
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	68 7c 28 80 00       	push   $0x80287c
  800190:	e8 cd 00 00 00       	call   800262 <cprintf>
	// call user main routine
	umain(argc, argv);
  800195:	83 c4 08             	add    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 aa fe ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  8001a3:	e8 0b 00 00 00       	call   8001b3 <exit>
}
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ae:	5b                   	pop    %ebx
  8001af:	5e                   	pop    %esi
  8001b0:	5f                   	pop    %edi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    

008001b3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001b9:	e8 ef 11 00 00       	call   8013ad <close_all>
	sys_env_destroy(0);
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	6a 00                	push   $0x0
  8001c3:	e8 6c 0b 00 00       	call   800d34 <sys_env_destroy>
}
  8001c8:	83 c4 10             	add    $0x10,%esp
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d7:	8b 13                	mov    (%ebx),%edx
  8001d9:	8d 42 01             	lea    0x1(%edx),%eax
  8001dc:	89 03                	mov    %eax,(%ebx)
  8001de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ea:	74 09                	je     8001f5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ec:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	68 ff 00 00 00       	push   $0xff
  8001fd:	8d 43 08             	lea    0x8(%ebx),%eax
  800200:	50                   	push   %eax
  800201:	e8 f1 0a 00 00       	call   800cf7 <sys_cputs>
		b->idx = 0;
  800206:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	eb db                	jmp    8001ec <putch+0x1f>

00800211 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800221:	00 00 00 
	b.cnt = 0;
  800224:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022e:	ff 75 0c             	pushl  0xc(%ebp)
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	68 cd 01 80 00       	push   $0x8001cd
  800240:	e8 4a 01 00 00       	call   80038f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800245:	83 c4 08             	add    $0x8,%esp
  800248:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800254:	50                   	push   %eax
  800255:	e8 9d 0a 00 00       	call   800cf7 <sys_cputs>

	return b.cnt;
}
  80025a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800268:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026b:	50                   	push   %eax
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	e8 9d ff ff ff       	call   800211 <vcprintf>
	va_end(ap);

	return cnt;
}
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	57                   	push   %edi
  80027a:	56                   	push   %esi
  80027b:	53                   	push   %ebx
  80027c:	83 ec 1c             	sub    $0x1c,%esp
  80027f:	89 c6                	mov    %eax,%esi
  800281:	89 d7                	mov    %edx,%edi
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	8b 55 0c             	mov    0xc(%ebp),%edx
  800289:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80028f:	8b 45 10             	mov    0x10(%ebp),%eax
  800292:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800295:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800299:	74 2c                	je     8002c7 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80029b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ab:	39 c2                	cmp    %eax,%edx
  8002ad:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b0:	73 43                	jae    8002f5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7e 6c                	jle    800325 <printnum+0xaf>
				putch(padc, putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	57                   	push   %edi
  8002bd:	ff 75 18             	pushl  0x18(%ebp)
  8002c0:	ff d6                	call   *%esi
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	eb eb                	jmp    8002b2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	6a 20                	push   $0x20
  8002cc:	6a 00                	push   $0x0
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d5:	89 fa                	mov    %edi,%edx
  8002d7:	89 f0                	mov    %esi,%eax
  8002d9:	e8 98 ff ff ff       	call   800276 <printnum>
		while (--width > 0)
  8002de:	83 c4 20             	add    $0x20,%esp
  8002e1:	83 eb 01             	sub    $0x1,%ebx
  8002e4:	85 db                	test   %ebx,%ebx
  8002e6:	7e 65                	jle    80034d <printnum+0xd7>
			putch(padc, putdat);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	57                   	push   %edi
  8002ec:	6a 20                	push   $0x20
  8002ee:	ff d6                	call   *%esi
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	eb ec                	jmp    8002e1 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	ff 75 18             	pushl  0x18(%ebp)
  8002fb:	83 eb 01             	sub    $0x1,%ebx
  8002fe:	53                   	push   %ebx
  8002ff:	50                   	push   %eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 dc             	pushl  -0x24(%ebp)
  800306:	ff 75 d8             	pushl  -0x28(%ebp)
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	ff 75 e0             	pushl  -0x20(%ebp)
  80030f:	e8 cc 22 00 00       	call   8025e0 <__udivdi3>
  800314:	83 c4 18             	add    $0x18,%esp
  800317:	52                   	push   %edx
  800318:	50                   	push   %eax
  800319:	89 fa                	mov    %edi,%edx
  80031b:	89 f0                	mov    %esi,%eax
  80031d:	e8 54 ff ff ff       	call   800276 <printnum>
  800322:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	57                   	push   %edi
  800329:	83 ec 04             	sub    $0x4,%esp
  80032c:	ff 75 dc             	pushl  -0x24(%ebp)
  80032f:	ff 75 d8             	pushl  -0x28(%ebp)
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	ff 75 e0             	pushl  -0x20(%ebp)
  800338:	e8 b3 23 00 00       	call   8026f0 <__umoddi3>
  80033d:	83 c4 14             	add    $0x14,%esp
  800340:	0f be 80 93 28 80 00 	movsbl 0x802893(%eax),%eax
  800347:	50                   	push   %eax
  800348:	ff d6                	call   *%esi
  80034a:	83 c4 10             	add    $0x10,%esp
	}
}
  80034d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800350:	5b                   	pop    %ebx
  800351:	5e                   	pop    %esi
  800352:	5f                   	pop    %edi
  800353:	5d                   	pop    %ebp
  800354:	c3                   	ret    

00800355 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	3b 50 04             	cmp    0x4(%eax),%edx
  800364:	73 0a                	jae    800370 <sprintputch+0x1b>
		*b->buf++ = ch;
  800366:	8d 4a 01             	lea    0x1(%edx),%ecx
  800369:	89 08                	mov    %ecx,(%eax)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	88 02                	mov    %al,(%edx)
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <printfmt>:
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800378:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037b:	50                   	push   %eax
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	e8 05 00 00 00       	call   80038f <vprintfmt>
}
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <vprintfmt>:
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
  800395:	83 ec 3c             	sub    $0x3c,%esp
  800398:	8b 75 08             	mov    0x8(%ebp),%esi
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a1:	e9 32 04 00 00       	jmp    8007d8 <vprintfmt+0x449>
		padc = ' ';
  8003a6:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003b1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003cd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8d 47 01             	lea    0x1(%edi),%eax
  8003d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d8:	0f b6 17             	movzbl (%edi),%edx
  8003db:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003de:	3c 55                	cmp    $0x55,%al
  8003e0:	0f 87 12 05 00 00    	ja     8008f8 <vprintfmt+0x569>
  8003e6:	0f b6 c0             	movzbl %al,%eax
  8003e9:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003f7:	eb d9                	jmp    8003d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003fc:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800400:	eb d0                	jmp    8003d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800402:	0f b6 d2             	movzbl %dl,%edx
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	89 75 08             	mov    %esi,0x8(%ebp)
  800410:	eb 03                	jmp    800415 <vprintfmt+0x86>
  800412:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800415:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800418:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80041c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800422:	83 fe 09             	cmp    $0x9,%esi
  800425:	76 eb                	jbe    800412 <vprintfmt+0x83>
  800427:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042a:	8b 75 08             	mov    0x8(%ebp),%esi
  80042d:	eb 14                	jmp    800443 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 40 04             	lea    0x4(%eax),%eax
  80043d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800443:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800447:	79 89                	jns    8003d2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800449:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800456:	e9 77 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	85 c0                	test   %eax,%eax
  800460:	0f 48 c1             	cmovs  %ecx,%eax
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800469:	e9 64 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800471:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800478:	e9 55 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
			lflag++;
  80047d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800484:	e9 49 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	8d 78 04             	lea    0x4(%eax),%edi
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	53                   	push   %ebx
  800493:	ff 30                	pushl  (%eax)
  800495:	ff d6                	call   *%esi
			break;
  800497:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80049d:	e9 33 03 00 00       	jmp    8007d5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	99                   	cltd   
  8004ab:	31 d0                	xor    %edx,%eax
  8004ad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004af:	83 f8 10             	cmp    $0x10,%eax
  8004b2:	7f 23                	jg     8004d7 <vprintfmt+0x148>
  8004b4:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  8004bb:	85 d2                	test   %edx,%edx
  8004bd:	74 18                	je     8004d7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004bf:	52                   	push   %edx
  8004c0:	68 f9 2c 80 00       	push   $0x802cf9
  8004c5:	53                   	push   %ebx
  8004c6:	56                   	push   %esi
  8004c7:	e8 a6 fe ff ff       	call   800372 <printfmt>
  8004cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004cf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004d2:	e9 fe 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d7:	50                   	push   %eax
  8004d8:	68 ab 28 80 00       	push   $0x8028ab
  8004dd:	53                   	push   %ebx
  8004de:	56                   	push   %esi
  8004df:	e8 8e fe ff ff       	call   800372 <printfmt>
  8004e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ea:	e9 e6 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	83 c0 04             	add    $0x4,%eax
  8004f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 a4 28 80 00       	mov    $0x8028a4,%eax
  800504:	0f 45 c1             	cmovne %ecx,%eax
  800507:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80050a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050e:	7e 06                	jle    800516 <vprintfmt+0x187>
  800510:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800514:	75 0d                	jne    800523 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800516:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800519:	89 c7                	mov    %eax,%edi
  80051b:	03 45 e0             	add    -0x20(%ebp),%eax
  80051e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800521:	eb 53                	jmp    800576 <vprintfmt+0x1e7>
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	ff 75 d8             	pushl  -0x28(%ebp)
  800529:	50                   	push   %eax
  80052a:	e8 71 04 00 00       	call   8009a0 <strnlen>
  80052f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800532:	29 c1                	sub    %eax,%ecx
  800534:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80053c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800540:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	eb 0f                	jmp    800554 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	53                   	push   %ebx
  800549:	ff 75 e0             	pushl  -0x20(%ebp)
  80054c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ed                	jg     800545 <vprintfmt+0x1b6>
  800558:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	0f 49 c1             	cmovns %ecx,%eax
  800565:	29 c1                	sub    %eax,%ecx
  800567:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80056a:	eb aa                	jmp    800516 <vprintfmt+0x187>
					putch(ch, putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	53                   	push   %ebx
  800570:	52                   	push   %edx
  800571:	ff d6                	call   *%esi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800579:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057b:	83 c7 01             	add    $0x1,%edi
  80057e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800582:	0f be d0             	movsbl %al,%edx
  800585:	85 d2                	test   %edx,%edx
  800587:	74 4b                	je     8005d4 <vprintfmt+0x245>
  800589:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058d:	78 06                	js     800595 <vprintfmt+0x206>
  80058f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800593:	78 1e                	js     8005b3 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800595:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800599:	74 d1                	je     80056c <vprintfmt+0x1dd>
  80059b:	0f be c0             	movsbl %al,%eax
  80059e:	83 e8 20             	sub    $0x20,%eax
  8005a1:	83 f8 5e             	cmp    $0x5e,%eax
  8005a4:	76 c6                	jbe    80056c <vprintfmt+0x1dd>
					putch('?', putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	53                   	push   %ebx
  8005aa:	6a 3f                	push   $0x3f
  8005ac:	ff d6                	call   *%esi
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	eb c3                	jmp    800576 <vprintfmt+0x1e7>
  8005b3:	89 cf                	mov    %ecx,%edi
  8005b5:	eb 0e                	jmp    8005c5 <vprintfmt+0x236>
				putch(' ', putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	53                   	push   %ebx
  8005bb:	6a 20                	push   $0x20
  8005bd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005bf:	83 ef 01             	sub    $0x1,%edi
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	85 ff                	test   %edi,%edi
  8005c7:	7f ee                	jg     8005b7 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cf:	e9 01 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
  8005d4:	89 cf                	mov    %ecx,%edi
  8005d6:	eb ed                	jmp    8005c5 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005db:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005e2:	e9 eb fd ff ff       	jmp    8003d2 <vprintfmt+0x43>
	if (lflag >= 2)
  8005e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005eb:	7f 21                	jg     80060e <vprintfmt+0x27f>
	else if (lflag)
  8005ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f1:	74 68                	je     80065b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fb:	89 c1                	mov    %eax,%ecx
  8005fd:	c1 f9 1f             	sar    $0x1f,%ecx
  800600:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb 17                	jmp    800625 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 50 04             	mov    0x4(%eax),%edx
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800619:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 08             	lea    0x8(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800625:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800628:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800631:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800635:	78 3f                	js     800676 <vprintfmt+0x2e7>
			base = 10;
  800637:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80063c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800640:	0f 84 71 01 00 00    	je     8007b7 <vprintfmt+0x428>
				putch('+', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 2b                	push   $0x2b
  80064c:	ff d6                	call   *%esi
  80064e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
  800656:	e9 5c 01 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800663:	89 c1                	mov    %eax,%ecx
  800665:	c1 f9 1f             	sar    $0x1f,%ecx
  800668:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb af                	jmp    800625 <vprintfmt+0x296>
				putch('-', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 2d                	push   $0x2d
  80067c:	ff d6                	call   *%esi
				num = -(long long) num;
  80067e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800681:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800684:	f7 d8                	neg    %eax
  800686:	83 d2 00             	adc    $0x0,%edx
  800689:	f7 da                	neg    %edx
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800694:	b8 0a 00 00 00       	mov    $0xa,%eax
  800699:	e9 19 01 00 00       	jmp    8007b7 <vprintfmt+0x428>
	if (lflag >= 2)
  80069e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a2:	7f 29                	jg     8006cd <vprintfmt+0x33e>
	else if (lflag)
  8006a4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a8:	74 44                	je     8006ee <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 40 04             	lea    0x4(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c8:	e9 ea 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 50 04             	mov    0x4(%eax),%edx
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 08             	lea    0x8(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	e9 c9 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800707:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070c:	e9 a6 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
			putch('0', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	6a 30                	push   $0x30
  800717:	ff d6                	call   *%esi
	if (lflag >= 2)
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800720:	7f 26                	jg     800748 <vprintfmt+0x3b9>
	else if (lflag)
  800722:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800726:	74 3e                	je     800766 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800735:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800741:	b8 08 00 00 00       	mov    $0x8,%eax
  800746:	eb 6f                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 50 04             	mov    0x4(%eax),%edx
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 40 08             	lea    0x8(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075f:	b8 08 00 00 00       	mov    $0x8,%eax
  800764:	eb 51                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 31                	jmp    8007b7 <vprintfmt+0x428>
			putch('0', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 30                	push   $0x30
  80078c:	ff d6                	call   *%esi
			putch('x', putdat);
  80078e:	83 c4 08             	add    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 78                	push   $0x78
  800794:	ff d6                	call   *%esi
			num = (unsigned long long)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007be:	52                   	push   %edx
  8007bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c9:	89 da                	mov    %ebx,%edx
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	e8 a4 fa ff ff       	call   800276 <printnum>
			break;
  8007d2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	83 c7 01             	add    $0x1,%edi
  8007db:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007df:	83 f8 25             	cmp    $0x25,%eax
  8007e2:	0f 84 be fb ff ff    	je     8003a6 <vprintfmt+0x17>
			if (ch == '\0')
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	0f 84 28 01 00 00    	je     800918 <vprintfmt+0x589>
			putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	50                   	push   %eax
  8007f5:	ff d6                	call   *%esi
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	eb dc                	jmp    8007d8 <vprintfmt+0x449>
	if (lflag >= 2)
  8007fc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800800:	7f 26                	jg     800828 <vprintfmt+0x499>
	else if (lflag)
  800802:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800806:	74 41                	je     800849 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8d 40 04             	lea    0x4(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
  800826:	eb 8f                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
  800844:	e9 6e ff ff ff       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	ba 00 00 00 00       	mov    $0x0,%edx
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 04             	lea    0x4(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	b8 10 00 00 00       	mov    $0x10,%eax
  800867:	e9 4b ff ff ff       	jmp    8007b7 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	85 c0                	test   %eax,%eax
  80087c:	74 14                	je     800892 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80087e:	8b 13                	mov    (%ebx),%edx
  800880:	83 fa 7f             	cmp    $0x7f,%edx
  800883:	7f 37                	jg     8008bc <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800885:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	e9 43 ff ff ff       	jmp    8007d5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800892:	b8 0a 00 00 00       	mov    $0xa,%eax
  800897:	bf c9 29 80 00       	mov    $0x8029c9,%edi
							putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	53                   	push   %ebx
  8008a0:	50                   	push   %eax
  8008a1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a3:	83 c7 01             	add    $0x1,%edi
  8008a6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	85 c0                	test   %eax,%eax
  8008af:	75 eb                	jne    80089c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b7:	e9 19 ff ff ff       	jmp    8007d5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008bc:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c3:	bf 01 2a 80 00       	mov    $0x802a01,%edi
							putch(ch, putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	50                   	push   %eax
  8008cd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008cf:	83 c7 01             	add    $0x1,%edi
  8008d2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	75 eb                	jne    8008c8 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	e9 ed fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
			putch(ch, putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 25                	push   $0x25
  8008ee:	ff d6                	call   *%esi
			break;
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	e9 dd fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
			putch('%', putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	6a 25                	push   $0x25
  8008fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	89 f8                	mov    %edi,%eax
  800905:	eb 03                	jmp    80090a <vprintfmt+0x57b>
  800907:	83 e8 01             	sub    $0x1,%eax
  80090a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80090e:	75 f7                	jne    800907 <vprintfmt+0x578>
  800910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800913:	e9 bd fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
}
  800918:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5f                   	pop    %edi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 18             	sub    $0x18,%esp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800933:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093d:	85 c0                	test   %eax,%eax
  80093f:	74 26                	je     800967 <vsnprintf+0x47>
  800941:	85 d2                	test   %edx,%edx
  800943:	7e 22                	jle    800967 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800945:	ff 75 14             	pushl  0x14(%ebp)
  800948:	ff 75 10             	pushl  0x10(%ebp)
  80094b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	68 55 03 80 00       	push   $0x800355
  800954:	e8 36 fa ff ff       	call   80038f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800962:	83 c4 10             	add    $0x10,%esp
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    
		return -E_INVAL;
  800967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096c:	eb f7                	jmp    800965 <vsnprintf+0x45>

0080096e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800974:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800977:	50                   	push   %eax
  800978:	ff 75 10             	pushl  0x10(%ebp)
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	ff 75 08             	pushl  0x8(%ebp)
  800981:	e8 9a ff ff ff       	call   800920 <vsnprintf>
	va_end(ap);

	return rc;
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800997:	74 05                	je     80099e <strlen+0x16>
		n++;
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	eb f5                	jmp    800993 <strlen+0xb>
	return n;
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ae:	39 c2                	cmp    %eax,%edx
  8009b0:	74 0d                	je     8009bf <strnlen+0x1f>
  8009b2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009b6:	74 05                	je     8009bd <strnlen+0x1d>
		n++;
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	eb f1                	jmp    8009ae <strnlen+0xe>
  8009bd:	89 d0                	mov    %edx,%eax
	return n;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	53                   	push   %ebx
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	84 c9                	test   %cl,%cl
  8009dc:	75 f2                	jne    8009d0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009de:	5b                   	pop    %ebx
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	83 ec 10             	sub    $0x10,%esp
  8009e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009eb:	53                   	push   %ebx
  8009ec:	e8 97 ff ff ff       	call   800988 <strlen>
  8009f1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	01 d8                	add    %ebx,%eax
  8009f9:	50                   	push   %eax
  8009fa:	e8 c2 ff ff ff       	call   8009c1 <strcpy>
	return dst;
}
  8009ff:	89 d8                	mov    %ebx,%eax
  800a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a11:	89 c6                	mov    %eax,%esi
  800a13:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	39 f2                	cmp    %esi,%edx
  800a1a:	74 11                	je     800a2d <strncpy+0x27>
		*dst++ = *src;
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	0f b6 19             	movzbl (%ecx),%ebx
  800a22:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a25:	80 fb 01             	cmp    $0x1,%bl
  800a28:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a2b:	eb eb                	jmp    800a18 <strncpy+0x12>
	}
	return ret;
}
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	8b 75 08             	mov    0x8(%ebp),%esi
  800a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3c:	8b 55 10             	mov    0x10(%ebp),%edx
  800a3f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a41:	85 d2                	test   %edx,%edx
  800a43:	74 21                	je     800a66 <strlcpy+0x35>
  800a45:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a49:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a4b:	39 c2                	cmp    %eax,%edx
  800a4d:	74 14                	je     800a63 <strlcpy+0x32>
  800a4f:	0f b6 19             	movzbl (%ecx),%ebx
  800a52:	84 db                	test   %bl,%bl
  800a54:	74 0b                	je     800a61 <strlcpy+0x30>
			*dst++ = *src++;
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	83 c2 01             	add    $0x1,%edx
  800a5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5f:	eb ea                	jmp    800a4b <strlcpy+0x1a>
  800a61:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a66:	29 f0                	sub    %esi,%eax
}
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a75:	0f b6 01             	movzbl (%ecx),%eax
  800a78:	84 c0                	test   %al,%al
  800a7a:	74 0c                	je     800a88 <strcmp+0x1c>
  800a7c:	3a 02                	cmp    (%edx),%al
  800a7e:	75 08                	jne    800a88 <strcmp+0x1c>
		p++, q++;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ed                	jmp    800a75 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a88:	0f b6 c0             	movzbl %al,%eax
  800a8b:	0f b6 12             	movzbl (%edx),%edx
  800a8e:	29 d0                	sub    %edx,%eax
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa1:	eb 06                	jmp    800aa9 <strncmp+0x17>
		n--, p++, q++;
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa9:	39 d8                	cmp    %ebx,%eax
  800aab:	74 16                	je     800ac3 <strncmp+0x31>
  800aad:	0f b6 08             	movzbl (%eax),%ecx
  800ab0:	84 c9                	test   %cl,%cl
  800ab2:	74 04                	je     800ab8 <strncmp+0x26>
  800ab4:	3a 0a                	cmp    (%edx),%cl
  800ab6:	74 eb                	je     800aa3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	0f b6 00             	movzbl (%eax),%eax
  800abb:	0f b6 12             	movzbl (%edx),%edx
  800abe:	29 d0                	sub    %edx,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    
		return 0;
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	eb f6                	jmp    800ac0 <strncmp+0x2e>

00800aca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad4:	0f b6 10             	movzbl (%eax),%edx
  800ad7:	84 d2                	test   %dl,%dl
  800ad9:	74 09                	je     800ae4 <strchr+0x1a>
		if (*s == c)
  800adb:	38 ca                	cmp    %cl,%dl
  800add:	74 0a                	je     800ae9 <strchr+0x1f>
	for (; *s; s++)
  800adf:	83 c0 01             	add    $0x1,%eax
  800ae2:	eb f0                	jmp    800ad4 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af8:	38 ca                	cmp    %cl,%dl
  800afa:	74 09                	je     800b05 <strfind+0x1a>
  800afc:	84 d2                	test   %dl,%dl
  800afe:	74 05                	je     800b05 <strfind+0x1a>
	for (; *s; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	eb f0                	jmp    800af5 <strfind+0xa>
			break;
	return (char *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b13:	85 c9                	test   %ecx,%ecx
  800b15:	74 31                	je     800b48 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b17:	89 f8                	mov    %edi,%eax
  800b19:	09 c8                	or     %ecx,%eax
  800b1b:	a8 03                	test   $0x3,%al
  800b1d:	75 23                	jne    800b42 <memset+0x3b>
		c &= 0xFF;
  800b1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b23:	89 d3                	mov    %edx,%ebx
  800b25:	c1 e3 08             	shl    $0x8,%ebx
  800b28:	89 d0                	mov    %edx,%eax
  800b2a:	c1 e0 18             	shl    $0x18,%eax
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	c1 e6 10             	shl    $0x10,%esi
  800b32:	09 f0                	or     %esi,%eax
  800b34:	09 c2                	or     %eax,%edx
  800b36:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b3b:	89 d0                	mov    %edx,%eax
  800b3d:	fc                   	cld    
  800b3e:	f3 ab                	rep stos %eax,%es:(%edi)
  800b40:	eb 06                	jmp    800b48 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	fc                   	cld    
  800b46:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b48:	89 f8                	mov    %edi,%eax
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5d:	39 c6                	cmp    %eax,%esi
  800b5f:	73 32                	jae    800b93 <memmove+0x44>
  800b61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	76 2b                	jbe    800b93 <memmove+0x44>
		s += n;
		d += n;
  800b68:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6b:	89 fe                	mov    %edi,%esi
  800b6d:	09 ce                	or     %ecx,%esi
  800b6f:	09 d6                	or     %edx,%esi
  800b71:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b77:	75 0e                	jne    800b87 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b79:	83 ef 04             	sub    $0x4,%edi
  800b7c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b82:	fd                   	std    
  800b83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b85:	eb 09                	jmp    800b90 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b87:	83 ef 01             	sub    $0x1,%edi
  800b8a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8d:	fd                   	std    
  800b8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b90:	fc                   	cld    
  800b91:	eb 1a                	jmp    800bad <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	09 ca                	or     %ecx,%edx
  800b97:	09 f2                	or     %esi,%edx
  800b99:	f6 c2 03             	test   $0x3,%dl
  800b9c:	75 0a                	jne    800ba8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba1:	89 c7                	mov    %eax,%edi
  800ba3:	fc                   	cld    
  800ba4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba6:	eb 05                	jmp    800bad <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	fc                   	cld    
  800bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb7:	ff 75 10             	pushl  0x10(%ebp)
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	ff 75 08             	pushl  0x8(%ebp)
  800bc0:	e8 8a ff ff ff       	call   800b4f <memmove>
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	89 c6                	mov    %eax,%esi
  800bd4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd7:	39 f0                	cmp    %esi,%eax
  800bd9:	74 1c                	je     800bf7 <memcmp+0x30>
		if (*s1 != *s2)
  800bdb:	0f b6 08             	movzbl (%eax),%ecx
  800bde:	0f b6 1a             	movzbl (%edx),%ebx
  800be1:	38 d9                	cmp    %bl,%cl
  800be3:	75 08                	jne    800bed <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be5:	83 c0 01             	add    $0x1,%eax
  800be8:	83 c2 01             	add    $0x1,%edx
  800beb:	eb ea                	jmp    800bd7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bed:	0f b6 c1             	movzbl %cl,%eax
  800bf0:	0f b6 db             	movzbl %bl,%ebx
  800bf3:	29 d8                	sub    %ebx,%eax
  800bf5:	eb 05                	jmp    800bfc <memcmp+0x35>
	}

	return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c0e:	39 d0                	cmp    %edx,%eax
  800c10:	73 09                	jae    800c1b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c12:	38 08                	cmp    %cl,(%eax)
  800c14:	74 05                	je     800c1b <memfind+0x1b>
	for (; s < ends; s++)
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	eb f3                	jmp    800c0e <memfind+0xe>
			break;
	return (void *) s;
}
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c29:	eb 03                	jmp    800c2e <strtol+0x11>
		s++;
  800c2b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c2e:	0f b6 01             	movzbl (%ecx),%eax
  800c31:	3c 20                	cmp    $0x20,%al
  800c33:	74 f6                	je     800c2b <strtol+0xe>
  800c35:	3c 09                	cmp    $0x9,%al
  800c37:	74 f2                	je     800c2b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c39:	3c 2b                	cmp    $0x2b,%al
  800c3b:	74 2a                	je     800c67 <strtol+0x4a>
	int neg = 0;
  800c3d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c42:	3c 2d                	cmp    $0x2d,%al
  800c44:	74 2b                	je     800c71 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c46:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c4c:	75 0f                	jne    800c5d <strtol+0x40>
  800c4e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c51:	74 28                	je     800c7b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c53:	85 db                	test   %ebx,%ebx
  800c55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5a:	0f 44 d8             	cmove  %eax,%ebx
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c65:	eb 50                	jmp    800cb7 <strtol+0x9a>
		s++;
  800c67:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c6f:	eb d5                	jmp    800c46 <strtol+0x29>
		s++, neg = 1;
  800c71:	83 c1 01             	add    $0x1,%ecx
  800c74:	bf 01 00 00 00       	mov    $0x1,%edi
  800c79:	eb cb                	jmp    800c46 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c7f:	74 0e                	je     800c8f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c81:	85 db                	test   %ebx,%ebx
  800c83:	75 d8                	jne    800c5d <strtol+0x40>
		s++, base = 8;
  800c85:	83 c1 01             	add    $0x1,%ecx
  800c88:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c8d:	eb ce                	jmp    800c5d <strtol+0x40>
		s += 2, base = 16;
  800c8f:	83 c1 02             	add    $0x2,%ecx
  800c92:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c97:	eb c4                	jmp    800c5d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c99:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c9c:	89 f3                	mov    %esi,%ebx
  800c9e:	80 fb 19             	cmp    $0x19,%bl
  800ca1:	77 29                	ja     800ccc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca3:	0f be d2             	movsbl %dl,%edx
  800ca6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cac:	7d 30                	jge    800cde <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cae:	83 c1 01             	add    $0x1,%ecx
  800cb1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb7:	0f b6 11             	movzbl (%ecx),%edx
  800cba:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cbd:	89 f3                	mov    %esi,%ebx
  800cbf:	80 fb 09             	cmp    $0x9,%bl
  800cc2:	77 d5                	ja     800c99 <strtol+0x7c>
			dig = *s - '0';
  800cc4:	0f be d2             	movsbl %dl,%edx
  800cc7:	83 ea 30             	sub    $0x30,%edx
  800cca:	eb dd                	jmp    800ca9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ccc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ccf:	89 f3                	mov    %esi,%ebx
  800cd1:	80 fb 19             	cmp    $0x19,%bl
  800cd4:	77 08                	ja     800cde <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd6:	0f be d2             	movsbl %dl,%edx
  800cd9:	83 ea 37             	sub    $0x37,%edx
  800cdc:	eb cb                	jmp    800ca9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce2:	74 05                	je     800ce9 <strtol+0xcc>
		*endptr = (char *) s;
  800ce4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	f7 da                	neg    %edx
  800ced:	85 ff                	test   %edi,%edi
  800cef:	0f 45 c2             	cmovne %edx,%eax
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	89 c3                	mov    %eax,%ebx
  800d0a:	89 c7                	mov    %eax,%edi
  800d0c:	89 c6                	mov    %eax,%esi
  800d0e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 01 00 00 00       	mov    $0x1,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4a:	89 cb                	mov    %ecx,%ebx
  800d4c:	89 cf                	mov    %ecx,%edi
  800d4e:	89 ce                	mov    %ecx,%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 03                	push   $0x3
  800d64:	68 24 2c 80 00       	push   $0x802c24
  800d69:	6a 43                	push   $0x43
  800d6b:	68 41 2c 80 00       	push   $0x802c41
  800d70:	e8 ca 16 00 00       	call   80243f <_panic>

00800d75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 02 00 00 00       	mov    $0x2,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_yield>:

void
sys_yield(void)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da4:	89 d1                	mov    %edx,%ecx
  800da6:	89 d3                	mov    %edx,%ebx
  800da8:	89 d7                	mov    %edx,%edi
  800daa:	89 d6                	mov    %edx,%esi
  800dac:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	be 00 00 00 00       	mov    $0x0,%esi
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcf:	89 f7                	mov    %esi,%edi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 04                	push   $0x4
  800de5:	68 24 2c 80 00       	push   $0x802c24
  800dea:	6a 43                	push   $0x43
  800dec:	68 41 2c 80 00       	push   $0x802c41
  800df1:	e8 49 16 00 00       	call   80243f <_panic>

00800df6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
  800dfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 05 00 00 00       	mov    $0x5,%eax
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e10:	8b 75 18             	mov    0x18(%ebp),%esi
  800e13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7f 08                	jg     800e21 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	50                   	push   %eax
  800e25:	6a 05                	push   $0x5
  800e27:	68 24 2c 80 00       	push   $0x802c24
  800e2c:	6a 43                	push   $0x43
  800e2e:	68 41 2c 80 00       	push   $0x802c41
  800e33:	e8 07 16 00 00       	call   80243f <_panic>

00800e38 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e51:	89 df                	mov    %ebx,%edi
  800e53:	89 de                	mov    %ebx,%esi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 06                	push   $0x6
  800e69:	68 24 2c 80 00       	push   $0x802c24
  800e6e:	6a 43                	push   $0x43
  800e70:	68 41 2c 80 00       	push   $0x802c41
  800e75:	e8 c5 15 00 00       	call   80243f <_panic>

00800e7a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e93:	89 df                	mov    %ebx,%edi
  800e95:	89 de                	mov    %ebx,%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 08                	push   $0x8
  800eab:	68 24 2c 80 00       	push   $0x802c24
  800eb0:	6a 43                	push   $0x43
  800eb2:	68 41 2c 80 00       	push   $0x802c41
  800eb7:	e8 83 15 00 00       	call   80243f <_panic>

00800ebc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed5:	89 df                	mov    %ebx,%edi
  800ed7:	89 de                	mov    %ebx,%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 09                	push   $0x9
  800eed:	68 24 2c 80 00       	push   $0x802c24
  800ef2:	6a 43                	push   $0x43
  800ef4:	68 41 2c 80 00       	push   $0x802c41
  800ef9:	e8 41 15 00 00       	call   80243f <_panic>

00800efe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	89 de                	mov    %ebx,%esi
  800f1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	7f 08                	jg     800f29 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	50                   	push   %eax
  800f2d:	6a 0a                	push   $0xa
  800f2f:	68 24 2c 80 00       	push   $0x802c24
  800f34:	6a 43                	push   $0x43
  800f36:	68 41 2c 80 00       	push   $0x802c41
  800f3b:	e8 ff 14 00 00       	call   80243f <_panic>

00800f40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f51:	be 00 00 00 00       	mov    $0x0,%esi
  800f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f59:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f5c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f79:	89 cb                	mov    %ecx,%ebx
  800f7b:	89 cf                	mov    %ecx,%edi
  800f7d:	89 ce                	mov    %ecx,%esi
  800f7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7f 08                	jg     800f8d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	50                   	push   %eax
  800f91:	6a 0d                	push   $0xd
  800f93:	68 24 2c 80 00       	push   $0x802c24
  800f98:	6a 43                	push   $0x43
  800f9a:	68 41 2c 80 00       	push   $0x802c41
  800f9f:	e8 9b 14 00 00       	call   80243f <_panic>

00800fa4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fba:	89 df                	mov    %ebx,%edi
  800fbc:	89 de                	mov    %ebx,%esi
  800fbe:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd8:	89 cb                	mov    %ecx,%ebx
  800fda:	89 cf                	mov    %ecx,%edi
  800fdc:	89 ce                	mov    %ecx,%esi
  800fde:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800feb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff5:	89 d1                	mov    %edx,%ecx
  800ff7:	89 d3                	mov    %edx,%ebx
  800ff9:	89 d7                	mov    %edx,%edi
  800ffb:	89 d6                	mov    %edx,%esi
  800ffd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	b8 11 00 00 00       	mov    $0x11,%eax
  80101a:	89 df                	mov    %ebx,%edi
  80101c:	89 de                	mov    %ebx,%esi
  80101e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 12 00 00 00       	mov    $0x12,%eax
  80103b:	89 df                	mov    %ebx,%edi
  80103d:	89 de                	mov    %ebx,%esi
  80103f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 13 00 00 00       	mov    $0x13,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 13                	push   $0x13
  801077:	68 24 2c 80 00       	push   $0x802c24
  80107c:	6a 43                	push   $0x43
  80107e:	68 41 2c 80 00       	push   $0x802c41
  801083:	e8 b7 13 00 00       	call   80243f <_panic>

00801088 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	8b 55 08             	mov    0x8(%ebp),%edx
  80108e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801091:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801094:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801096:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801099:	83 3a 01             	cmpl   $0x1,(%edx)
  80109c:	7e 09                	jle    8010a7 <argstart+0x1f>
  80109e:	ba 88 28 80 00       	mov    $0x802888,%edx
  8010a3:	85 c9                	test   %ecx,%ecx
  8010a5:	75 05                	jne    8010ac <argstart+0x24>
  8010a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ac:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8010af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <argnext>:

int
argnext(struct Argstate *args)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010c2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010c9:	8b 43 08             	mov    0x8(%ebx),%eax
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	74 72                	je     801142 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8010d0:	80 38 00             	cmpb   $0x0,(%eax)
  8010d3:	75 48                	jne    80111d <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010d5:	8b 0b                	mov    (%ebx),%ecx
  8010d7:	83 39 01             	cmpl   $0x1,(%ecx)
  8010da:	74 58                	je     801134 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8010dc:	8b 53 04             	mov    0x4(%ebx),%edx
  8010df:	8b 42 04             	mov    0x4(%edx),%eax
  8010e2:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010e5:	75 4d                	jne    801134 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8010e7:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010eb:	74 47                	je     801134 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8010ed:	83 c0 01             	add    $0x1,%eax
  8010f0:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	8b 01                	mov    (%ecx),%eax
  8010f8:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010ff:	50                   	push   %eax
  801100:	8d 42 08             	lea    0x8(%edx),%eax
  801103:	50                   	push   %eax
  801104:	83 c2 04             	add    $0x4,%edx
  801107:	52                   	push   %edx
  801108:	e8 42 fa ff ff       	call   800b4f <memmove>
		(*args->argc)--;
  80110d:	8b 03                	mov    (%ebx),%eax
  80110f:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801112:	8b 43 08             	mov    0x8(%ebx),%eax
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	80 38 2d             	cmpb   $0x2d,(%eax)
  80111b:	74 11                	je     80112e <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80111d:	8b 53 08             	mov    0x8(%ebx),%edx
  801120:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801123:	83 c2 01             	add    $0x1,%edx
  801126:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80112e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801132:	75 e9                	jne    80111d <argnext+0x65>
	args->curarg = 0;
  801134:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80113b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801140:	eb e7                	jmp    801129 <argnext+0x71>
		return -1;
  801142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801147:	eb e0                	jmp    801129 <argnext+0x71>

00801149 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	53                   	push   %ebx
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801153:	8b 43 08             	mov    0x8(%ebx),%eax
  801156:	85 c0                	test   %eax,%eax
  801158:	74 12                	je     80116c <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  80115a:	80 38 00             	cmpb   $0x0,(%eax)
  80115d:	74 12                	je     801171 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  80115f:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801162:	c7 43 08 88 28 80 00 	movl   $0x802888,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801169:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80116c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80116f:	c9                   	leave  
  801170:	c3                   	ret    
	} else if (*args->argc > 1) {
  801171:	8b 13                	mov    (%ebx),%edx
  801173:	83 3a 01             	cmpl   $0x1,(%edx)
  801176:	7f 10                	jg     801188 <argnextvalue+0x3f>
		args->argvalue = 0;
  801178:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80117f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801186:	eb e1                	jmp    801169 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801188:	8b 43 04             	mov    0x4(%ebx),%eax
  80118b:	8b 48 04             	mov    0x4(%eax),%ecx
  80118e:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	8b 12                	mov    (%edx),%edx
  801196:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80119d:	52                   	push   %edx
  80119e:	8d 50 08             	lea    0x8(%eax),%edx
  8011a1:	52                   	push   %edx
  8011a2:	83 c0 04             	add    $0x4,%eax
  8011a5:	50                   	push   %eax
  8011a6:	e8 a4 f9 ff ff       	call   800b4f <memmove>
		(*args->argc)--;
  8011ab:	8b 03                	mov    (%ebx),%eax
  8011ad:	83 28 01             	subl   $0x1,(%eax)
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	eb b4                	jmp    801169 <argnextvalue+0x20>

008011b5 <argvalue>:
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011be:	8b 42 0c             	mov    0xc(%edx),%eax
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	74 02                	je     8011c7 <argvalue+0x12>
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	52                   	push   %edx
  8011cb:	e8 79 ff ff ff       	call   801149 <argnextvalue>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	eb f0                	jmp    8011c5 <argvalue+0x10>

008011d5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	05 00 00 00 30       	add    $0x30000000,%eax
  8011e0:	c1 e8 0c             	shr    $0xc,%eax
}
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801204:	89 c2                	mov    %eax,%edx
  801206:	c1 ea 16             	shr    $0x16,%edx
  801209:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801210:	f6 c2 01             	test   $0x1,%dl
  801213:	74 2d                	je     801242 <fd_alloc+0x46>
  801215:	89 c2                	mov    %eax,%edx
  801217:	c1 ea 0c             	shr    $0xc,%edx
  80121a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801221:	f6 c2 01             	test   $0x1,%dl
  801224:	74 1c                	je     801242 <fd_alloc+0x46>
  801226:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80122b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801230:	75 d2                	jne    801204 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80123b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801240:	eb 0a                	jmp    80124c <fd_alloc+0x50>
			*fd_store = fd;
  801242:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801245:	89 01                	mov    %eax,(%ecx)
			return 0;
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801254:	83 f8 1f             	cmp    $0x1f,%eax
  801257:	77 30                	ja     801289 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801259:	c1 e0 0c             	shl    $0xc,%eax
  80125c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801261:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801267:	f6 c2 01             	test   $0x1,%dl
  80126a:	74 24                	je     801290 <fd_lookup+0x42>
  80126c:	89 c2                	mov    %eax,%edx
  80126e:	c1 ea 0c             	shr    $0xc,%edx
  801271:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801278:	f6 c2 01             	test   $0x1,%dl
  80127b:	74 1a                	je     801297 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80127d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801280:	89 02                	mov    %eax,(%edx)
	return 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    
		return -E_INVAL;
  801289:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128e:	eb f7                	jmp    801287 <fd_lookup+0x39>
		return -E_INVAL;
  801290:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801295:	eb f0                	jmp    801287 <fd_lookup+0x39>
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129c:	eb e9                	jmp    801287 <fd_lookup+0x39>

0080129e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ac:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b1:	39 08                	cmp    %ecx,(%eax)
  8012b3:	74 38                	je     8012ed <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012b5:	83 c2 01             	add    $0x1,%edx
  8012b8:	8b 04 95 cc 2c 80 00 	mov    0x802ccc(,%edx,4),%eax
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 ee                	jne    8012b1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8012c8:	8b 40 48             	mov    0x48(%eax),%eax
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	51                   	push   %ecx
  8012cf:	50                   	push   %eax
  8012d0:	68 50 2c 80 00       	push   $0x802c50
  8012d5:	e8 88 ef ff ff       	call   800262 <cprintf>
	*dev = 0;
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    
			*dev = devtab[i];
  8012ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	eb f2                	jmp    8012eb <dev_lookup+0x4d>

008012f9 <fd_close>:
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 24             	sub    $0x24,%esp
  801302:	8b 75 08             	mov    0x8(%ebp),%esi
  801305:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801308:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80130b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801312:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801315:	50                   	push   %eax
  801316:	e8 33 ff ff ff       	call   80124e <fd_lookup>
  80131b:	89 c3                	mov    %eax,%ebx
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	78 05                	js     801329 <fd_close+0x30>
	    || fd != fd2)
  801324:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801327:	74 16                	je     80133f <fd_close+0x46>
		return (must_exist ? r : 0);
  801329:	89 f8                	mov    %edi,%eax
  80132b:	84 c0                	test   %al,%al
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	0f 44 d8             	cmove  %eax,%ebx
}
  801335:	89 d8                	mov    %ebx,%eax
  801337:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133a:	5b                   	pop    %ebx
  80133b:	5e                   	pop    %esi
  80133c:	5f                   	pop    %edi
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801345:	50                   	push   %eax
  801346:	ff 36                	pushl  (%esi)
  801348:	e8 51 ff ff ff       	call   80129e <dev_lookup>
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 1a                	js     801370 <fd_close+0x77>
		if (dev->dev_close)
  801356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801359:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80135c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801361:	85 c0                	test   %eax,%eax
  801363:	74 0b                	je     801370 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801365:	83 ec 0c             	sub    $0xc,%esp
  801368:	56                   	push   %esi
  801369:	ff d0                	call   *%eax
  80136b:	89 c3                	mov    %eax,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	56                   	push   %esi
  801374:	6a 00                	push   $0x0
  801376:	e8 bd fa ff ff       	call   800e38 <sys_page_unmap>
	return r;
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	eb b5                	jmp    801335 <fd_close+0x3c>

00801380 <close>:

int
close(int fdnum)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801389:	50                   	push   %eax
  80138a:	ff 75 08             	pushl  0x8(%ebp)
  80138d:	e8 bc fe ff ff       	call   80124e <fd_lookup>
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	79 02                	jns    80139b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    
		return fd_close(fd, 1);
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	6a 01                	push   $0x1
  8013a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a3:	e8 51 ff ff ff       	call   8012f9 <fd_close>
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	eb ec                	jmp    801399 <close+0x19>

008013ad <close_all>:

void
close_all(void)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	53                   	push   %ebx
  8013b1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b9:	83 ec 0c             	sub    $0xc,%esp
  8013bc:	53                   	push   %ebx
  8013bd:	e8 be ff ff ff       	call   801380 <close>
	for (i = 0; i < MAXFD; i++)
  8013c2:	83 c3 01             	add    $0x1,%ebx
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	83 fb 20             	cmp    $0x20,%ebx
  8013cb:	75 ec                	jne    8013b9 <close_all+0xc>
}
  8013cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	57                   	push   %edi
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013de:	50                   	push   %eax
  8013df:	ff 75 08             	pushl  0x8(%ebp)
  8013e2:	e8 67 fe ff ff       	call   80124e <fd_lookup>
  8013e7:	89 c3                	mov    %eax,%ebx
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	0f 88 81 00 00 00    	js     801475 <dup+0xa3>
		return r;
	close(newfdnum);
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	ff 75 0c             	pushl  0xc(%ebp)
  8013fa:	e8 81 ff ff ff       	call   801380 <close>

	newfd = INDEX2FD(newfdnum);
  8013ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801402:	c1 e6 0c             	shl    $0xc,%esi
  801405:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80140b:	83 c4 04             	add    $0x4,%esp
  80140e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801411:	e8 cf fd ff ff       	call   8011e5 <fd2data>
  801416:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801418:	89 34 24             	mov    %esi,(%esp)
  80141b:	e8 c5 fd ff ff       	call   8011e5 <fd2data>
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801425:	89 d8                	mov    %ebx,%eax
  801427:	c1 e8 16             	shr    $0x16,%eax
  80142a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801431:	a8 01                	test   $0x1,%al
  801433:	74 11                	je     801446 <dup+0x74>
  801435:	89 d8                	mov    %ebx,%eax
  801437:	c1 e8 0c             	shr    $0xc,%eax
  80143a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801441:	f6 c2 01             	test   $0x1,%dl
  801444:	75 39                	jne    80147f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801449:	89 d0                	mov    %edx,%eax
  80144b:	c1 e8 0c             	shr    $0xc,%eax
  80144e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	25 07 0e 00 00       	and    $0xe07,%eax
  80145d:	50                   	push   %eax
  80145e:	56                   	push   %esi
  80145f:	6a 00                	push   $0x0
  801461:	52                   	push   %edx
  801462:	6a 00                	push   $0x0
  801464:	e8 8d f9 ff ff       	call   800df6 <sys_page_map>
  801469:	89 c3                	mov    %eax,%ebx
  80146b:	83 c4 20             	add    $0x20,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 31                	js     8014a3 <dup+0xd1>
		goto err;

	return newfdnum;
  801472:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801475:	89 d8                	mov    %ebx,%eax
  801477:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5f                   	pop    %edi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80147f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	25 07 0e 00 00       	and    $0xe07,%eax
  80148e:	50                   	push   %eax
  80148f:	57                   	push   %edi
  801490:	6a 00                	push   $0x0
  801492:	53                   	push   %ebx
  801493:	6a 00                	push   $0x0
  801495:	e8 5c f9 ff ff       	call   800df6 <sys_page_map>
  80149a:	89 c3                	mov    %eax,%ebx
  80149c:	83 c4 20             	add    $0x20,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	79 a3                	jns    801446 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	56                   	push   %esi
  8014a7:	6a 00                	push   $0x0
  8014a9:	e8 8a f9 ff ff       	call   800e38 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ae:	83 c4 08             	add    $0x8,%esp
  8014b1:	57                   	push   %edi
  8014b2:	6a 00                	push   $0x0
  8014b4:	e8 7f f9 ff ff       	call   800e38 <sys_page_unmap>
	return r;
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	eb b7                	jmp    801475 <dup+0xa3>

008014be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 1c             	sub    $0x1c,%esp
  8014c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cb:	50                   	push   %eax
  8014cc:	53                   	push   %ebx
  8014cd:	e8 7c fd ff ff       	call   80124e <fd_lookup>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	78 3f                	js     801518 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014df:	50                   	push   %eax
  8014e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e3:	ff 30                	pushl  (%eax)
  8014e5:	e8 b4 fd ff ff       	call   80129e <dev_lookup>
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	78 27                	js     801518 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f4:	8b 42 08             	mov    0x8(%edx),%eax
  8014f7:	83 e0 03             	and    $0x3,%eax
  8014fa:	83 f8 01             	cmp    $0x1,%eax
  8014fd:	74 1e                	je     80151d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801502:	8b 40 08             	mov    0x8(%eax),%eax
  801505:	85 c0                	test   %eax,%eax
  801507:	74 35                	je     80153e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	ff 75 10             	pushl  0x10(%ebp)
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	52                   	push   %edx
  801513:	ff d0                	call   *%eax
  801515:	83 c4 10             	add    $0x10,%esp
}
  801518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80151d:	a1 08 40 80 00       	mov    0x804008,%eax
  801522:	8b 40 48             	mov    0x48(%eax),%eax
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	53                   	push   %ebx
  801529:	50                   	push   %eax
  80152a:	68 91 2c 80 00       	push   $0x802c91
  80152f:	e8 2e ed ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80153c:	eb da                	jmp    801518 <read+0x5a>
		return -E_NOT_SUPP;
  80153e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801543:	eb d3                	jmp    801518 <read+0x5a>

00801545 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801551:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801554:	bb 00 00 00 00       	mov    $0x0,%ebx
  801559:	39 f3                	cmp    %esi,%ebx
  80155b:	73 23                	jae    801580 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	89 f0                	mov    %esi,%eax
  801562:	29 d8                	sub    %ebx,%eax
  801564:	50                   	push   %eax
  801565:	89 d8                	mov    %ebx,%eax
  801567:	03 45 0c             	add    0xc(%ebp),%eax
  80156a:	50                   	push   %eax
  80156b:	57                   	push   %edi
  80156c:	e8 4d ff ff ff       	call   8014be <read>
		if (m < 0)
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	78 06                	js     80157e <readn+0x39>
			return m;
		if (m == 0)
  801578:	74 06                	je     801580 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80157a:	01 c3                	add    %eax,%ebx
  80157c:	eb db                	jmp    801559 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80157e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801580:	89 d8                	mov    %ebx,%eax
  801582:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	53                   	push   %ebx
  80158e:	83 ec 1c             	sub    $0x1c,%esp
  801591:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801594:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	53                   	push   %ebx
  801599:	e8 b0 fc ff ff       	call   80124e <fd_lookup>
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 3a                	js     8015df <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015af:	ff 30                	pushl  (%eax)
  8015b1:	e8 e8 fc ff ff       	call   80129e <dev_lookup>
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 22                	js     8015df <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c4:	74 1e                	je     8015e4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015cc:	85 d2                	test   %edx,%edx
  8015ce:	74 35                	je     801605 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	ff 75 10             	pushl  0x10(%ebp)
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	50                   	push   %eax
  8015da:	ff d2                	call   *%edx
  8015dc:	83 c4 10             	add    $0x10,%esp
}
  8015df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8015e9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	50                   	push   %eax
  8015f1:	68 ad 2c 80 00       	push   $0x802cad
  8015f6:	e8 67 ec ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801603:	eb da                	jmp    8015df <write+0x55>
		return -E_NOT_SUPP;
  801605:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160a:	eb d3                	jmp    8015df <write+0x55>

0080160c <seek>:

int
seek(int fdnum, off_t offset)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	e8 30 fc ff ff       	call   80124e <fd_lookup>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 0e                	js     801633 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 1c             	sub    $0x1c,%esp
  80163c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	53                   	push   %ebx
  801644:	e8 05 fc ff ff       	call   80124e <fd_lookup>
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 37                	js     801687 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801656:	50                   	push   %eax
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	ff 30                	pushl  (%eax)
  80165c:	e8 3d fc ff ff       	call   80129e <dev_lookup>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 1f                	js     801687 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166f:	74 1b                	je     80168c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801674:	8b 52 18             	mov    0x18(%edx),%edx
  801677:	85 d2                	test   %edx,%edx
  801679:	74 32                	je     8016ad <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	50                   	push   %eax
  801682:	ff d2                	call   *%edx
  801684:	83 c4 10             	add    $0x10,%esp
}
  801687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80168c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801691:	8b 40 48             	mov    0x48(%eax),%eax
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	53                   	push   %ebx
  801698:	50                   	push   %eax
  801699:	68 70 2c 80 00       	push   $0x802c70
  80169e:	e8 bf eb ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ab:	eb da                	jmp    801687 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b2:	eb d3                	jmp    801687 <ftruncate+0x52>

008016b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 1c             	sub    $0x1c,%esp
  8016bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	e8 84 fb ff ff       	call   80124e <fd_lookup>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 4b                	js     80171c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	ff 30                	pushl  (%eax)
  8016dd:	e8 bc fb ff ff       	call   80129e <dev_lookup>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 33                	js     80171c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016f0:	74 2f                	je     801721 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016f2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016f5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016fc:	00 00 00 
	stat->st_isdir = 0;
  8016ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801706:	00 00 00 
	stat->st_dev = dev;
  801709:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	53                   	push   %ebx
  801713:	ff 75 f0             	pushl  -0x10(%ebp)
  801716:	ff 50 14             	call   *0x14(%eax)
  801719:	83 c4 10             	add    $0x10,%esp
}
  80171c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171f:	c9                   	leave  
  801720:	c3                   	ret    
		return -E_NOT_SUPP;
  801721:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801726:	eb f4                	jmp    80171c <fstat+0x68>

00801728 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	56                   	push   %esi
  80172c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	6a 00                	push   $0x0
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 22 02 00 00       	call   80195c <open>
  80173a:	89 c3                	mov    %eax,%ebx
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	85 c0                	test   %eax,%eax
  801741:	78 1b                	js     80175e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	50                   	push   %eax
  80174a:	e8 65 ff ff ff       	call   8016b4 <fstat>
  80174f:	89 c6                	mov    %eax,%esi
	close(fd);
  801751:	89 1c 24             	mov    %ebx,(%esp)
  801754:	e8 27 fc ff ff       	call   801380 <close>
	return r;
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	89 f3                	mov    %esi,%ebx
}
  80175e:	89 d8                	mov    %ebx,%eax
  801760:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	89 c6                	mov    %eax,%esi
  80176e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801770:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801777:	74 27                	je     8017a0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801779:	6a 07                	push   $0x7
  80177b:	68 00 50 80 00       	push   $0x805000
  801780:	56                   	push   %esi
  801781:	ff 35 00 40 80 00    	pushl  0x804000
  801787:	e8 7d 0d 00 00       	call   802509 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80178c:	83 c4 0c             	add    $0xc,%esp
  80178f:	6a 00                	push   $0x0
  801791:	53                   	push   %ebx
  801792:	6a 00                	push   $0x0
  801794:	e8 07 0d 00 00       	call   8024a0 <ipc_recv>
}
  801799:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	6a 01                	push   $0x1
  8017a5:	e8 b7 0d 00 00       	call   802561 <ipc_find_env>
  8017aa:	a3 00 40 80 00       	mov    %eax,0x804000
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	eb c5                	jmp    801779 <fsipc+0x12>

008017b4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d7:	e8 8b ff ff ff       	call   801767 <fsipc>
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <devfile_flush>:
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ea:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f9:	e8 69 ff ff ff       	call   801767 <fsipc>
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <devfile_stat>:
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 40 0c             	mov    0xc(%eax),%eax
  801810:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	b8 05 00 00 00       	mov    $0x5,%eax
  80181f:	e8 43 ff ff ff       	call   801767 <fsipc>
  801824:	85 c0                	test   %eax,%eax
  801826:	78 2c                	js     801854 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801828:	83 ec 08             	sub    $0x8,%esp
  80182b:	68 00 50 80 00       	push   $0x805000
  801830:	53                   	push   %ebx
  801831:	e8 8b f1 ff ff       	call   8009c1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801836:	a1 80 50 80 00       	mov    0x805080,%eax
  80183b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801841:	a1 84 50 80 00       	mov    0x805084,%eax
  801846:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <devfile_write>:
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8b 40 0c             	mov    0xc(%eax),%eax
  801869:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80186e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801874:	53                   	push   %ebx
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	68 08 50 80 00       	push   $0x805008
  80187d:	e8 2f f3 ff ff       	call   800bb1 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
  801887:	b8 04 00 00 00       	mov    $0x4,%eax
  80188c:	e8 d6 fe ff ff       	call   801767 <fsipc>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 0b                	js     8018a3 <devfile_write+0x4a>
	assert(r <= n);
  801898:	39 d8                	cmp    %ebx,%eax
  80189a:	77 0c                	ja     8018a8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80189c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a1:	7f 1e                	jg     8018c1 <devfile_write+0x68>
}
  8018a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    
	assert(r <= n);
  8018a8:	68 e0 2c 80 00       	push   $0x802ce0
  8018ad:	68 e7 2c 80 00       	push   $0x802ce7
  8018b2:	68 98 00 00 00       	push   $0x98
  8018b7:	68 fc 2c 80 00       	push   $0x802cfc
  8018bc:	e8 7e 0b 00 00       	call   80243f <_panic>
	assert(r <= PGSIZE);
  8018c1:	68 07 2d 80 00       	push   $0x802d07
  8018c6:	68 e7 2c 80 00       	push   $0x802ce7
  8018cb:	68 99 00 00 00       	push   $0x99
  8018d0:	68 fc 2c 80 00       	push   $0x802cfc
  8018d5:	e8 65 0b 00 00       	call   80243f <_panic>

008018da <devfile_read>:
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	56                   	push   %esi
  8018de:	53                   	push   %ebx
  8018df:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ed:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8018fd:	e8 65 fe ff ff       	call   801767 <fsipc>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	85 c0                	test   %eax,%eax
  801906:	78 1f                	js     801927 <devfile_read+0x4d>
	assert(r <= n);
  801908:	39 f0                	cmp    %esi,%eax
  80190a:	77 24                	ja     801930 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80190c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801911:	7f 33                	jg     801946 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	50                   	push   %eax
  801917:	68 00 50 80 00       	push   $0x805000
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	e8 2b f2 ff ff       	call   800b4f <memmove>
	return r;
  801924:	83 c4 10             	add    $0x10,%esp
}
  801927:	89 d8                	mov    %ebx,%eax
  801929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5e                   	pop    %esi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
	assert(r <= n);
  801930:	68 e0 2c 80 00       	push   $0x802ce0
  801935:	68 e7 2c 80 00       	push   $0x802ce7
  80193a:	6a 7c                	push   $0x7c
  80193c:	68 fc 2c 80 00       	push   $0x802cfc
  801941:	e8 f9 0a 00 00       	call   80243f <_panic>
	assert(r <= PGSIZE);
  801946:	68 07 2d 80 00       	push   $0x802d07
  80194b:	68 e7 2c 80 00       	push   $0x802ce7
  801950:	6a 7d                	push   $0x7d
  801952:	68 fc 2c 80 00       	push   $0x802cfc
  801957:	e8 e3 0a 00 00       	call   80243f <_panic>

0080195c <open>:
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	83 ec 1c             	sub    $0x1c,%esp
  801964:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801967:	56                   	push   %esi
  801968:	e8 1b f0 ff ff       	call   800988 <strlen>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801975:	7f 6c                	jg     8019e3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	e8 79 f8 ff ff       	call   8011fc <fd_alloc>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 3c                	js     8019c8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80198c:	83 ec 08             	sub    $0x8,%esp
  80198f:	56                   	push   %esi
  801990:	68 00 50 80 00       	push   $0x805000
  801995:	e8 27 f0 ff ff       	call   8009c1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80199a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019aa:	e8 b8 fd ff ff       	call   801767 <fsipc>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 19                	js     8019d1 <open+0x75>
	return fd2num(fd);
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019be:	e8 12 f8 ff ff       	call   8011d5 <fd2num>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
}
  8019c8:	89 d8                	mov    %ebx,%eax
  8019ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5e                   	pop    %esi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
		fd_close(fd, 0);
  8019d1:	83 ec 08             	sub    $0x8,%esp
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d9:	e8 1b f9 ff ff       	call   8012f9 <fd_close>
		return r;
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	eb e5                	jmp    8019c8 <open+0x6c>
		return -E_BAD_PATH;
  8019e3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019e8:	eb de                	jmp    8019c8 <open+0x6c>

008019ea <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fa:	e8 68 fd ff ff       	call   801767 <fsipc>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a01:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a05:	7f 01                	jg     801a08 <writebuf+0x7>
  801a07:	c3                   	ret    
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a11:	ff 70 04             	pushl  0x4(%eax)
  801a14:	8d 40 10             	lea    0x10(%eax),%eax
  801a17:	50                   	push   %eax
  801a18:	ff 33                	pushl  (%ebx)
  801a1a:	e8 6b fb ff ff       	call   80158a <write>
		if (result > 0)
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	85 c0                	test   %eax,%eax
  801a24:	7e 03                	jle    801a29 <writebuf+0x28>
			b->result += result;
  801a26:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a29:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a2c:	74 0d                	je     801a3b <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	0f 4f c2             	cmovg  %edx,%eax
  801a38:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <putch>:

static void
putch(int ch, void *thunk)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a4a:	8b 53 04             	mov    0x4(%ebx),%edx
  801a4d:	8d 42 01             	lea    0x1(%edx),%eax
  801a50:	89 43 04             	mov    %eax,0x4(%ebx)
  801a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a56:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a5a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a5f:	74 06                	je     801a67 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a61:	83 c4 04             	add    $0x4,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    
		writebuf(b);
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	e8 93 ff ff ff       	call   801a01 <writebuf>
		b->idx = 0;
  801a6e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a75:	eb ea                	jmp    801a61 <putch+0x21>

00801a77 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a89:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a90:	00 00 00 
	b.result = 0;
  801a93:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a9a:	00 00 00 
	b.error = 1;
  801a9d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801aa4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801aa7:	ff 75 10             	pushl  0x10(%ebp)
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ab3:	50                   	push   %eax
  801ab4:	68 40 1a 80 00       	push   $0x801a40
  801ab9:	e8 d1 e8 ff ff       	call   80038f <vprintfmt>
	if (b.idx > 0)
  801abe:	83 c4 10             	add    $0x10,%esp
  801ac1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ac8:	7f 11                	jg     801adb <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801aca:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    
		writebuf(&b);
  801adb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ae1:	e8 1b ff ff ff       	call   801a01 <writebuf>
  801ae6:	eb e2                	jmp    801aca <vfprintf+0x53>

00801ae8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aee:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801af1:	50                   	push   %eax
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	ff 75 08             	pushl  0x8(%ebp)
  801af8:	e8 7a ff ff ff       	call   801a77 <vfprintf>
	va_end(ap);

	return cnt;
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <printf>:

int
printf(const char *fmt, ...)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b05:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b08:	50                   	push   %eax
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	6a 01                	push   $0x1
  801b0e:	e8 64 ff ff ff       	call   801a77 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b1b:	68 13 2d 80 00       	push   $0x802d13
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	e8 99 ee ff ff       	call   8009c1 <strcpy>
	return 0;
}
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <devsock_close>:
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	53                   	push   %ebx
  801b33:	83 ec 10             	sub    $0x10,%esp
  801b36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b39:	53                   	push   %ebx
  801b3a:	e8 5d 0a 00 00       	call   80259c <pageref>
  801b3f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b42:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b47:	83 f8 01             	cmp    $0x1,%eax
  801b4a:	74 07                	je     801b53 <devsock_close+0x24>
}
  801b4c:	89 d0                	mov    %edx,%eax
  801b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	ff 73 0c             	pushl  0xc(%ebx)
  801b59:	e8 b9 02 00 00       	call   801e17 <nsipc_close>
  801b5e:	89 c2                	mov    %eax,%edx
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	eb e7                	jmp    801b4c <devsock_close+0x1d>

00801b65 <devsock_write>:
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 10             	pushl  0x10(%ebp)
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	ff 70 0c             	pushl  0xc(%eax)
  801b79:	e8 76 03 00 00       	call   801ef4 <nsipc_send>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <devsock_read>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	ff 75 10             	pushl  0x10(%ebp)
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	ff 70 0c             	pushl  0xc(%eax)
  801b94:	e8 ef 02 00 00       	call   801e88 <nsipc_recv>
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <fd2sockid>:
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ba1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	e8 a3 f6 ff ff       	call   80124e <fd_lookup>
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 10                	js     801bc2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bbb:	39 08                	cmp    %ecx,(%eax)
  801bbd:	75 05                	jne    801bc4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bbf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    
		return -E_NOT_SUPP;
  801bc4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc9:	eb f7                	jmp    801bc2 <fd2sockid+0x27>

00801bcb <alloc_sockfd>:
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 1c             	sub    $0x1c,%esp
  801bd3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd8:	50                   	push   %eax
  801bd9:	e8 1e f6 ff ff       	call   8011fc <fd_alloc>
  801bde:	89 c3                	mov    %eax,%ebx
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 43                	js     801c2a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	68 07 04 00 00       	push   $0x407
  801bef:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf2:	6a 00                	push   $0x0
  801bf4:	e8 ba f1 ff ff       	call   800db3 <sys_page_alloc>
  801bf9:	89 c3                	mov    %eax,%ebx
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 28                	js     801c2a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c0b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c17:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	50                   	push   %eax
  801c1e:	e8 b2 f5 ff ff       	call   8011d5 <fd2num>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	eb 0c                	jmp    801c36 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	56                   	push   %esi
  801c2e:	e8 e4 01 00 00       	call   801e17 <nsipc_close>
		return r;
  801c33:	83 c4 10             	add    $0x10,%esp
}
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    

00801c3f <accept>:
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	e8 4e ff ff ff       	call   801b9b <fd2sockid>
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 1b                	js     801c6c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	50                   	push   %eax
  801c5b:	e8 0e 01 00 00       	call   801d6e <nsipc_accept>
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 05                	js     801c6c <accept+0x2d>
	return alloc_sockfd(r);
  801c67:	e8 5f ff ff ff       	call   801bcb <alloc_sockfd>
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <bind>:
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	e8 1f ff ff ff       	call   801b9b <fd2sockid>
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 12                	js     801c92 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	50                   	push   %eax
  801c8a:	e8 31 01 00 00       	call   801dc0 <nsipc_bind>
  801c8f:	83 c4 10             	add    $0x10,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <shutdown>:
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	e8 f9 fe ff ff       	call   801b9b <fd2sockid>
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	78 0f                	js     801cb5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	50                   	push   %eax
  801cad:	e8 43 01 00 00       	call   801df5 <nsipc_shutdown>
  801cb2:	83 c4 10             	add    $0x10,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <connect>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	e8 d6 fe ff ff       	call   801b9b <fd2sockid>
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	78 12                	js     801cdb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	50                   	push   %eax
  801cd3:	e8 59 01 00 00       	call   801e31 <nsipc_connect>
  801cd8:	83 c4 10             	add    $0x10,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <listen>:
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	e8 b0 fe ff ff       	call   801b9b <fd2sockid>
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	78 0f                	js     801cfe <listen+0x21>
	return nsipc_listen(r, backlog);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	50                   	push   %eax
  801cf6:	e8 6b 01 00 00       	call   801e66 <nsipc_listen>
  801cfb:	83 c4 10             	add    $0x10,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d06:	ff 75 10             	pushl  0x10(%ebp)
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	e8 3e 02 00 00       	call   801f52 <nsipc_socket>
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 05                	js     801d20 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d1b:	e8 ab fe ff ff       	call   801bcb <alloc_sockfd>
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	53                   	push   %ebx
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d2b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d32:	74 26                	je     801d5a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d34:	6a 07                	push   $0x7
  801d36:	68 00 60 80 00       	push   $0x806000
  801d3b:	53                   	push   %ebx
  801d3c:	ff 35 04 40 80 00    	pushl  0x804004
  801d42:	e8 c2 07 00 00       	call   802509 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d47:	83 c4 0c             	add    $0xc,%esp
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 4b 07 00 00       	call   8024a0 <ipc_recv>
}
  801d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d5a:	83 ec 0c             	sub    $0xc,%esp
  801d5d:	6a 02                	push   $0x2
  801d5f:	e8 fd 07 00 00       	call   802561 <ipc_find_env>
  801d64:	a3 04 40 80 00       	mov    %eax,0x804004
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	eb c6                	jmp    801d34 <nsipc+0x12>

00801d6e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	56                   	push   %esi
  801d72:	53                   	push   %ebx
  801d73:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d7e:	8b 06                	mov    (%esi),%eax
  801d80:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d85:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8a:	e8 93 ff ff ff       	call   801d22 <nsipc>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	85 c0                	test   %eax,%eax
  801d93:	79 09                	jns    801d9e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d95:	89 d8                	mov    %ebx,%eax
  801d97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5d                   	pop    %ebp
  801d9d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	ff 35 10 60 80 00    	pushl  0x806010
  801da7:	68 00 60 80 00       	push   $0x806000
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	e8 9b ed ff ff       	call   800b4f <memmove>
		*addrlen = ret->ret_addrlen;
  801db4:	a1 10 60 80 00       	mov    0x806010,%eax
  801db9:	89 06                	mov    %eax,(%esi)
  801dbb:	83 c4 10             	add    $0x10,%esp
	return r;
  801dbe:	eb d5                	jmp    801d95 <nsipc_accept+0x27>

00801dc0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 08             	sub    $0x8,%esp
  801dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dd2:	53                   	push   %ebx
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	68 04 60 80 00       	push   $0x806004
  801ddb:	e8 6f ed ff ff       	call   800b4f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801de0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801de6:	b8 02 00 00 00       	mov    $0x2,%eax
  801deb:	e8 32 ff ff ff       	call   801d22 <nsipc>
}
  801df0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e0b:	b8 03 00 00 00       	mov    $0x3,%eax
  801e10:	e8 0d ff ff ff       	call   801d22 <nsipc>
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <nsipc_close>:

int
nsipc_close(int s)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e25:	b8 04 00 00 00       	mov    $0x4,%eax
  801e2a:	e8 f3 fe ff ff       	call   801d22 <nsipc>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	53                   	push   %ebx
  801e35:	83 ec 08             	sub    $0x8,%esp
  801e38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e43:	53                   	push   %ebx
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	68 04 60 80 00       	push   $0x806004
  801e4c:	e8 fe ec ff ff       	call   800b4f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e51:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e57:	b8 05 00 00 00       	mov    $0x5,%eax
  801e5c:	e8 c1 fe ff ff       	call   801d22 <nsipc>
}
  801e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e7c:	b8 06 00 00 00       	mov    $0x6,%eax
  801e81:	e8 9c fe ff ff       	call   801d22 <nsipc>
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	56                   	push   %esi
  801e8c:	53                   	push   %ebx
  801e8d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e98:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ea6:	b8 07 00 00 00       	mov    $0x7,%eax
  801eab:	e8 72 fe ff ff       	call   801d22 <nsipc>
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	78 1f                	js     801ed5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801eb6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ebb:	7f 21                	jg     801ede <nsipc_recv+0x56>
  801ebd:	39 c6                	cmp    %eax,%esi
  801ebf:	7c 1d                	jl     801ede <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ec1:	83 ec 04             	sub    $0x4,%esp
  801ec4:	50                   	push   %eax
  801ec5:	68 00 60 80 00       	push   $0x806000
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	e8 7d ec ff ff       	call   800b4f <memmove>
  801ed2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ed5:	89 d8                	mov    %ebx,%eax
  801ed7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ede:	68 1f 2d 80 00       	push   $0x802d1f
  801ee3:	68 e7 2c 80 00       	push   $0x802ce7
  801ee8:	6a 62                	push   $0x62
  801eea:	68 34 2d 80 00       	push   $0x802d34
  801eef:	e8 4b 05 00 00       	call   80243f <_panic>

00801ef4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f06:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f0c:	7f 2e                	jg     801f3c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f0e:	83 ec 04             	sub    $0x4,%esp
  801f11:	53                   	push   %ebx
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	68 0c 60 80 00       	push   $0x80600c
  801f1a:	e8 30 ec ff ff       	call   800b4f <memmove>
	nsipcbuf.send.req_size = size;
  801f1f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f25:	8b 45 14             	mov    0x14(%ebp),%eax
  801f28:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f2d:	b8 08 00 00 00       	mov    $0x8,%eax
  801f32:	e8 eb fd ff ff       	call   801d22 <nsipc>
}
  801f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    
	assert(size < 1600);
  801f3c:	68 40 2d 80 00       	push   $0x802d40
  801f41:	68 e7 2c 80 00       	push   $0x802ce7
  801f46:	6a 6d                	push   $0x6d
  801f48:	68 34 2d 80 00       	push   $0x802d34
  801f4d:	e8 ed 04 00 00       	call   80243f <_panic>

00801f52 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f68:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f70:	b8 09 00 00 00       	mov    $0x9,%eax
  801f75:	e8 a8 fd ff ff       	call   801d22 <nsipc>
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	56                   	push   %esi
  801f80:	53                   	push   %ebx
  801f81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 56 f2 ff ff       	call   8011e5 <fd2data>
  801f8f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f91:	83 c4 08             	add    $0x8,%esp
  801f94:	68 4c 2d 80 00       	push   $0x802d4c
  801f99:	53                   	push   %ebx
  801f9a:	e8 22 ea ff ff       	call   8009c1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f9f:	8b 46 04             	mov    0x4(%esi),%eax
  801fa2:	2b 06                	sub    (%esi),%eax
  801fa4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801faa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fb1:	00 00 00 
	stat->st_dev = &devpipe;
  801fb4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801fbb:	30 80 00 
	return 0;
}
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	53                   	push   %ebx
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fd4:	53                   	push   %ebx
  801fd5:	6a 00                	push   $0x0
  801fd7:	e8 5c ee ff ff       	call   800e38 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fdc:	89 1c 24             	mov    %ebx,(%esp)
  801fdf:	e8 01 f2 ff ff       	call   8011e5 <fd2data>
  801fe4:	83 c4 08             	add    $0x8,%esp
  801fe7:	50                   	push   %eax
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 49 ee ff ff       	call   800e38 <sys_page_unmap>
}
  801fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <_pipeisclosed>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	57                   	push   %edi
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 1c             	sub    $0x1c,%esp
  801ffd:	89 c7                	mov    %eax,%edi
  801fff:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802001:	a1 08 40 80 00       	mov    0x804008,%eax
  802006:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	57                   	push   %edi
  80200d:	e8 8a 05 00 00       	call   80259c <pageref>
  802012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802015:	89 34 24             	mov    %esi,(%esp)
  802018:	e8 7f 05 00 00       	call   80259c <pageref>
		nn = thisenv->env_runs;
  80201d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802023:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	39 cb                	cmp    %ecx,%ebx
  80202b:	74 1b                	je     802048 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80202d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802030:	75 cf                	jne    802001 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802032:	8b 42 58             	mov    0x58(%edx),%eax
  802035:	6a 01                	push   $0x1
  802037:	50                   	push   %eax
  802038:	53                   	push   %ebx
  802039:	68 53 2d 80 00       	push   $0x802d53
  80203e:	e8 1f e2 ff ff       	call   800262 <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	eb b9                	jmp    802001 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802048:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80204b:	0f 94 c0             	sete   %al
  80204e:	0f b6 c0             	movzbl %al,%eax
}
  802051:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802054:	5b                   	pop    %ebx
  802055:	5e                   	pop    %esi
  802056:	5f                   	pop    %edi
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    

00802059 <devpipe_write>:
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	57                   	push   %edi
  80205d:	56                   	push   %esi
  80205e:	53                   	push   %ebx
  80205f:	83 ec 28             	sub    $0x28,%esp
  802062:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802065:	56                   	push   %esi
  802066:	e8 7a f1 ff ff       	call   8011e5 <fd2data>
  80206b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	bf 00 00 00 00       	mov    $0x0,%edi
  802075:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802078:	74 4f                	je     8020c9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80207a:	8b 43 04             	mov    0x4(%ebx),%eax
  80207d:	8b 0b                	mov    (%ebx),%ecx
  80207f:	8d 51 20             	lea    0x20(%ecx),%edx
  802082:	39 d0                	cmp    %edx,%eax
  802084:	72 14                	jb     80209a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802086:	89 da                	mov    %ebx,%edx
  802088:	89 f0                	mov    %esi,%eax
  80208a:	e8 65 ff ff ff       	call   801ff4 <_pipeisclosed>
  80208f:	85 c0                	test   %eax,%eax
  802091:	75 3b                	jne    8020ce <devpipe_write+0x75>
			sys_yield();
  802093:	e8 fc ec ff ff       	call   800d94 <sys_yield>
  802098:	eb e0                	jmp    80207a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80209a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80209d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020a1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	c1 fa 1f             	sar    $0x1f,%edx
  8020a9:	89 d1                	mov    %edx,%ecx
  8020ab:	c1 e9 1b             	shr    $0x1b,%ecx
  8020ae:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020b1:	83 e2 1f             	and    $0x1f,%edx
  8020b4:	29 ca                	sub    %ecx,%edx
  8020b6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020ba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020be:	83 c0 01             	add    $0x1,%eax
  8020c1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020c4:	83 c7 01             	add    $0x1,%edi
  8020c7:	eb ac                	jmp    802075 <devpipe_write+0x1c>
	return i;
  8020c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cc:	eb 05                	jmp    8020d3 <devpipe_write+0x7a>
				return 0;
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <devpipe_read>:
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	57                   	push   %edi
  8020df:	56                   	push   %esi
  8020e0:	53                   	push   %ebx
  8020e1:	83 ec 18             	sub    $0x18,%esp
  8020e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020e7:	57                   	push   %edi
  8020e8:	e8 f8 f0 ff ff       	call   8011e5 <fd2data>
  8020ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	be 00 00 00 00       	mov    $0x0,%esi
  8020f7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020fa:	75 14                	jne    802110 <devpipe_read+0x35>
	return i;
  8020fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ff:	eb 02                	jmp    802103 <devpipe_read+0x28>
				return i;
  802101:	89 f0                	mov    %esi,%eax
}
  802103:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5f                   	pop    %edi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    
			sys_yield();
  80210b:	e8 84 ec ff ff       	call   800d94 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802110:	8b 03                	mov    (%ebx),%eax
  802112:	3b 43 04             	cmp    0x4(%ebx),%eax
  802115:	75 18                	jne    80212f <devpipe_read+0x54>
			if (i > 0)
  802117:	85 f6                	test   %esi,%esi
  802119:	75 e6                	jne    802101 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80211b:	89 da                	mov    %ebx,%edx
  80211d:	89 f8                	mov    %edi,%eax
  80211f:	e8 d0 fe ff ff       	call   801ff4 <_pipeisclosed>
  802124:	85 c0                	test   %eax,%eax
  802126:	74 e3                	je     80210b <devpipe_read+0x30>
				return 0;
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
  80212d:	eb d4                	jmp    802103 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80212f:	99                   	cltd   
  802130:	c1 ea 1b             	shr    $0x1b,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	83 e0 1f             	and    $0x1f,%eax
  802138:	29 d0                	sub    %edx,%eax
  80213a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80213f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802142:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802145:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802148:	83 c6 01             	add    $0x1,%esi
  80214b:	eb aa                	jmp    8020f7 <devpipe_read+0x1c>

0080214d <pipe>:
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	50                   	push   %eax
  802159:	e8 9e f0 ff ff       	call   8011fc <fd_alloc>
  80215e:	89 c3                	mov    %eax,%ebx
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	85 c0                	test   %eax,%eax
  802165:	0f 88 23 01 00 00    	js     80228e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	68 07 04 00 00       	push   $0x407
  802173:	ff 75 f4             	pushl  -0xc(%ebp)
  802176:	6a 00                	push   $0x0
  802178:	e8 36 ec ff ff       	call   800db3 <sys_page_alloc>
  80217d:	89 c3                	mov    %eax,%ebx
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 88 04 01 00 00    	js     80228e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802190:	50                   	push   %eax
  802191:	e8 66 f0 ff ff       	call   8011fc <fd_alloc>
  802196:	89 c3                	mov    %eax,%ebx
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	85 c0                	test   %eax,%eax
  80219d:	0f 88 db 00 00 00    	js     80227e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 07 04 00 00       	push   $0x407
  8021ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ae:	6a 00                	push   $0x0
  8021b0:	e8 fe eb ff ff       	call   800db3 <sys_page_alloc>
  8021b5:	89 c3                	mov    %eax,%ebx
  8021b7:	83 c4 10             	add    $0x10,%esp
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	0f 88 bc 00 00 00    	js     80227e <pipe+0x131>
	va = fd2data(fd0);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c8:	e8 18 f0 ff ff       	call   8011e5 <fd2data>
  8021cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021cf:	83 c4 0c             	add    $0xc,%esp
  8021d2:	68 07 04 00 00       	push   $0x407
  8021d7:	50                   	push   %eax
  8021d8:	6a 00                	push   $0x0
  8021da:	e8 d4 eb ff ff       	call   800db3 <sys_page_alloc>
  8021df:	89 c3                	mov    %eax,%ebx
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	0f 88 82 00 00 00    	js     80226e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ec:	83 ec 0c             	sub    $0xc,%esp
  8021ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f2:	e8 ee ef ff ff       	call   8011e5 <fd2data>
  8021f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021fe:	50                   	push   %eax
  8021ff:	6a 00                	push   $0x0
  802201:	56                   	push   %esi
  802202:	6a 00                	push   $0x0
  802204:	e8 ed eb ff ff       	call   800df6 <sys_page_map>
  802209:	89 c3                	mov    %eax,%ebx
  80220b:	83 c4 20             	add    $0x20,%esp
  80220e:	85 c0                	test   %eax,%eax
  802210:	78 4e                	js     802260 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802212:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80221c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802226:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802229:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	ff 75 f4             	pushl  -0xc(%ebp)
  80223b:	e8 95 ef ff ff       	call   8011d5 <fd2num>
  802240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802243:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802245:	83 c4 04             	add    $0x4,%esp
  802248:	ff 75 f0             	pushl  -0x10(%ebp)
  80224b:	e8 85 ef ff ff       	call   8011d5 <fd2num>
  802250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802253:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	bb 00 00 00 00       	mov    $0x0,%ebx
  80225e:	eb 2e                	jmp    80228e <pipe+0x141>
	sys_page_unmap(0, va);
  802260:	83 ec 08             	sub    $0x8,%esp
  802263:	56                   	push   %esi
  802264:	6a 00                	push   $0x0
  802266:	e8 cd eb ff ff       	call   800e38 <sys_page_unmap>
  80226b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80226e:	83 ec 08             	sub    $0x8,%esp
  802271:	ff 75 f0             	pushl  -0x10(%ebp)
  802274:	6a 00                	push   $0x0
  802276:	e8 bd eb ff ff       	call   800e38 <sys_page_unmap>
  80227b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80227e:	83 ec 08             	sub    $0x8,%esp
  802281:	ff 75 f4             	pushl  -0xc(%ebp)
  802284:	6a 00                	push   $0x0
  802286:	e8 ad eb ff ff       	call   800e38 <sys_page_unmap>
  80228b:	83 c4 10             	add    $0x10,%esp
}
  80228e:	89 d8                	mov    %ebx,%eax
  802290:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <pipeisclosed>:
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80229d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a0:	50                   	push   %eax
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	e8 a5 ef ff ff       	call   80124e <fd_lookup>
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	78 18                	js     8022c8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b6:	e8 2a ef ff ff       	call   8011e5 <fd2data>
	return _pipeisclosed(fd, p);
  8022bb:	89 c2                	mov    %eax,%edx
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	e8 2f fd ff ff       	call   801ff4 <_pipeisclosed>
  8022c5:	83 c4 10             	add    $0x10,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	c3                   	ret    

008022d0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022d6:	68 6b 2d 80 00       	push   $0x802d6b
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	e8 de e6 ff ff       	call   8009c1 <strcpy>
	return 0;
}
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <devcons_write>:
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	57                   	push   %edi
  8022ee:	56                   	push   %esi
  8022ef:	53                   	push   %ebx
  8022f0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022f6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802301:	3b 75 10             	cmp    0x10(%ebp),%esi
  802304:	73 31                	jae    802337 <devcons_write+0x4d>
		m = n - tot;
  802306:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802309:	29 f3                	sub    %esi,%ebx
  80230b:	83 fb 7f             	cmp    $0x7f,%ebx
  80230e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802313:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	53                   	push   %ebx
  80231a:	89 f0                	mov    %esi,%eax
  80231c:	03 45 0c             	add    0xc(%ebp),%eax
  80231f:	50                   	push   %eax
  802320:	57                   	push   %edi
  802321:	e8 29 e8 ff ff       	call   800b4f <memmove>
		sys_cputs(buf, m);
  802326:	83 c4 08             	add    $0x8,%esp
  802329:	53                   	push   %ebx
  80232a:	57                   	push   %edi
  80232b:	e8 c7 e9 ff ff       	call   800cf7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802330:	01 de                	add    %ebx,%esi
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	eb ca                	jmp    802301 <devcons_write+0x17>
}
  802337:	89 f0                	mov    %esi,%eax
  802339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    

00802341 <devcons_read>:
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 08             	sub    $0x8,%esp
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80234c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802350:	74 21                	je     802373 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802352:	e8 be e9 ff ff       	call   800d15 <sys_cgetc>
  802357:	85 c0                	test   %eax,%eax
  802359:	75 07                	jne    802362 <devcons_read+0x21>
		sys_yield();
  80235b:	e8 34 ea ff ff       	call   800d94 <sys_yield>
  802360:	eb f0                	jmp    802352 <devcons_read+0x11>
	if (c < 0)
  802362:	78 0f                	js     802373 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802364:	83 f8 04             	cmp    $0x4,%eax
  802367:	74 0c                	je     802375 <devcons_read+0x34>
	*(char*)vbuf = c;
  802369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236c:	88 02                	mov    %al,(%edx)
	return 1;
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    
		return 0;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	eb f7                	jmp    802373 <devcons_read+0x32>

0080237c <cputchar>:
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802388:	6a 01                	push   $0x1
  80238a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80238d:	50                   	push   %eax
  80238e:	e8 64 e9 ff ff       	call   800cf7 <sys_cputs>
}
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <getchar>:
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80239e:	6a 01                	push   $0x1
  8023a0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a3:	50                   	push   %eax
  8023a4:	6a 00                	push   $0x0
  8023a6:	e8 13 f1 ff ff       	call   8014be <read>
	if (r < 0)
  8023ab:	83 c4 10             	add    $0x10,%esp
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	78 06                	js     8023b8 <getchar+0x20>
	if (r < 1)
  8023b2:	74 06                	je     8023ba <getchar+0x22>
	return c;
  8023b4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    
		return -E_EOF;
  8023ba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023bf:	eb f7                	jmp    8023b8 <getchar+0x20>

008023c1 <iscons>:
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ca:	50                   	push   %eax
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	e8 7b ee ff ff       	call   80124e <fd_lookup>
  8023d3:	83 c4 10             	add    $0x10,%esp
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	78 11                	js     8023eb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023e3:	39 10                	cmp    %edx,(%eax)
  8023e5:	0f 94 c0             	sete   %al
  8023e8:	0f b6 c0             	movzbl %al,%eax
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <opencons>:
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f6:	50                   	push   %eax
  8023f7:	e8 00 ee ff ff       	call   8011fc <fd_alloc>
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 3a                	js     80243d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 07 04 00 00       	push   $0x407
  80240b:	ff 75 f4             	pushl  -0xc(%ebp)
  80240e:	6a 00                	push   $0x0
  802410:	e8 9e e9 ff ff       	call   800db3 <sys_page_alloc>
  802415:	83 c4 10             	add    $0x10,%esp
  802418:	85 c0                	test   %eax,%eax
  80241a:	78 21                	js     80243d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802425:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	50                   	push   %eax
  802435:	e8 9b ed ff ff       	call   8011d5 <fd2num>
  80243a:	83 c4 10             	add    $0x10,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802444:	a1 08 40 80 00       	mov    0x804008,%eax
  802449:	8b 40 48             	mov    0x48(%eax),%eax
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 a8 2d 80 00       	push   $0x802da8
  802454:	50                   	push   %eax
  802455:	68 77 2d 80 00       	push   $0x802d77
  80245a:	e8 03 de ff ff       	call   800262 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80245f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802462:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802468:	e8 08 e9 ff ff       	call   800d75 <sys_getenvid>
  80246d:	83 c4 04             	add    $0x4,%esp
  802470:	ff 75 0c             	pushl  0xc(%ebp)
  802473:	ff 75 08             	pushl  0x8(%ebp)
  802476:	56                   	push   %esi
  802477:	50                   	push   %eax
  802478:	68 84 2d 80 00       	push   $0x802d84
  80247d:	e8 e0 dd ff ff       	call   800262 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802482:	83 c4 18             	add    $0x18,%esp
  802485:	53                   	push   %ebx
  802486:	ff 75 10             	pushl  0x10(%ebp)
  802489:	e8 83 dd ff ff       	call   800211 <vcprintf>
	cprintf("\n");
  80248e:	c7 04 24 87 28 80 00 	movl   $0x802887,(%esp)
  802495:	e8 c8 dd ff ff       	call   800262 <cprintf>
  80249a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80249d:	cc                   	int3   
  80249e:	eb fd                	jmp    80249d <_panic+0x5e>

008024a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	56                   	push   %esi
  8024a4:	53                   	push   %ebx
  8024a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8024ae:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8024b0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8024b5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8024b8:	83 ec 0c             	sub    $0xc,%esp
  8024bb:	50                   	push   %eax
  8024bc:	e8 a2 ea ff ff       	call   800f63 <sys_ipc_recv>
	if(ret < 0){
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	78 2b                	js     8024f3 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8024c8:	85 f6                	test   %esi,%esi
  8024ca:	74 0a                	je     8024d6 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8024cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8024d1:	8b 40 74             	mov    0x74(%eax),%eax
  8024d4:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8024d6:	85 db                	test   %ebx,%ebx
  8024d8:	74 0a                	je     8024e4 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8024da:	a1 08 40 80 00       	mov    0x804008,%eax
  8024df:	8b 40 78             	mov    0x78(%eax),%eax
  8024e2:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8024e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8024e9:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
		if(from_env_store)
  8024f3:	85 f6                	test   %esi,%esi
  8024f5:	74 06                	je     8024fd <ipc_recv+0x5d>
			*from_env_store = 0;
  8024f7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024fd:	85 db                	test   %ebx,%ebx
  8024ff:	74 eb                	je     8024ec <ipc_recv+0x4c>
			*perm_store = 0;
  802501:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802507:	eb e3                	jmp    8024ec <ipc_recv+0x4c>

00802509 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	57                   	push   %edi
  80250d:	56                   	push   %esi
  80250e:	53                   	push   %ebx
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	8b 7d 08             	mov    0x8(%ebp),%edi
  802515:	8b 75 0c             	mov    0xc(%ebp),%esi
  802518:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80251b:	85 db                	test   %ebx,%ebx
  80251d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802522:	0f 44 d8             	cmove  %eax,%ebx
  802525:	eb 05                	jmp    80252c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802527:	e8 68 e8 ff ff       	call   800d94 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80252c:	ff 75 14             	pushl  0x14(%ebp)
  80252f:	53                   	push   %ebx
  802530:	56                   	push   %esi
  802531:	57                   	push   %edi
  802532:	e8 09 ea ff ff       	call   800f40 <sys_ipc_try_send>
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 1b                	je     802559 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80253e:	79 e7                	jns    802527 <ipc_send+0x1e>
  802540:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802543:	74 e2                	je     802527 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 af 2d 80 00       	push   $0x802daf
  80254d:	6a 48                	push   $0x48
  80254f:	68 c4 2d 80 00       	push   $0x802dc4
  802554:	e8 e6 fe ff ff       	call   80243f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    

00802561 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80256c:	89 c2                	mov    %eax,%edx
  80256e:	c1 e2 07             	shl    $0x7,%edx
  802571:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802577:	8b 52 50             	mov    0x50(%edx),%edx
  80257a:	39 ca                	cmp    %ecx,%edx
  80257c:	74 11                	je     80258f <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80257e:	83 c0 01             	add    $0x1,%eax
  802581:	3d 00 04 00 00       	cmp    $0x400,%eax
  802586:	75 e4                	jne    80256c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	eb 0b                	jmp    80259a <ipc_find_env+0x39>
			return envs[i].env_id;
  80258f:	c1 e0 07             	shl    $0x7,%eax
  802592:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802597:	8b 40 48             	mov    0x48(%eax),%eax
}
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    

0080259c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025a2:	89 d0                	mov    %edx,%eax
  8025a4:	c1 e8 16             	shr    $0x16,%eax
  8025a7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025b3:	f6 c1 01             	test   $0x1,%cl
  8025b6:	74 1d                	je     8025d5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025b8:	c1 ea 0c             	shr    $0xc,%edx
  8025bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025c2:	f6 c2 01             	test   $0x1,%dl
  8025c5:	74 0e                	je     8025d5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025c7:	c1 ea 0c             	shr    $0xc,%edx
  8025ca:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025d1:	ef 
  8025d2:	0f b7 c0             	movzwl %ax,%eax
}
  8025d5:	5d                   	pop    %ebp
  8025d6:	c3                   	ret    
  8025d7:	66 90                	xchg   %ax,%ax
  8025d9:	66 90                	xchg   %ax,%ax
  8025db:	66 90                	xchg   %ax,%ax
  8025dd:	66 90                	xchg   %ax,%ax
  8025df:	90                   	nop

008025e0 <__udivdi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 1c             	sub    $0x1c,%esp
  8025e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025f7:	85 d2                	test   %edx,%edx
  8025f9:	75 4d                	jne    802648 <__udivdi3+0x68>
  8025fb:	39 f3                	cmp    %esi,%ebx
  8025fd:	76 19                	jbe    802618 <__udivdi3+0x38>
  8025ff:	31 ff                	xor    %edi,%edi
  802601:	89 e8                	mov    %ebp,%eax
  802603:	89 f2                	mov    %esi,%edx
  802605:	f7 f3                	div    %ebx
  802607:	89 fa                	mov    %edi,%edx
  802609:	83 c4 1c             	add    $0x1c,%esp
  80260c:	5b                   	pop    %ebx
  80260d:	5e                   	pop    %esi
  80260e:	5f                   	pop    %edi
  80260f:	5d                   	pop    %ebp
  802610:	c3                   	ret    
  802611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802618:	89 d9                	mov    %ebx,%ecx
  80261a:	85 db                	test   %ebx,%ebx
  80261c:	75 0b                	jne    802629 <__udivdi3+0x49>
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	31 d2                	xor    %edx,%edx
  802625:	f7 f3                	div    %ebx
  802627:	89 c1                	mov    %eax,%ecx
  802629:	31 d2                	xor    %edx,%edx
  80262b:	89 f0                	mov    %esi,%eax
  80262d:	f7 f1                	div    %ecx
  80262f:	89 c6                	mov    %eax,%esi
  802631:	89 e8                	mov    %ebp,%eax
  802633:	89 f7                	mov    %esi,%edi
  802635:	f7 f1                	div    %ecx
  802637:	89 fa                	mov    %edi,%edx
  802639:	83 c4 1c             	add    $0x1c,%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5f                   	pop    %edi
  80263f:	5d                   	pop    %ebp
  802640:	c3                   	ret    
  802641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	77 1c                	ja     802668 <__udivdi3+0x88>
  80264c:	0f bd fa             	bsr    %edx,%edi
  80264f:	83 f7 1f             	xor    $0x1f,%edi
  802652:	75 2c                	jne    802680 <__udivdi3+0xa0>
  802654:	39 f2                	cmp    %esi,%edx
  802656:	72 06                	jb     80265e <__udivdi3+0x7e>
  802658:	31 c0                	xor    %eax,%eax
  80265a:	39 eb                	cmp    %ebp,%ebx
  80265c:	77 a9                	ja     802607 <__udivdi3+0x27>
  80265e:	b8 01 00 00 00       	mov    $0x1,%eax
  802663:	eb a2                	jmp    802607 <__udivdi3+0x27>
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	31 ff                	xor    %edi,%edi
  80266a:	31 c0                	xor    %eax,%eax
  80266c:	89 fa                	mov    %edi,%edx
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80267d:	8d 76 00             	lea    0x0(%esi),%esi
  802680:	89 f9                	mov    %edi,%ecx
  802682:	b8 20 00 00 00       	mov    $0x20,%eax
  802687:	29 f8                	sub    %edi,%eax
  802689:	d3 e2                	shl    %cl,%edx
  80268b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	89 da                	mov    %ebx,%edx
  802693:	d3 ea                	shr    %cl,%edx
  802695:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802699:	09 d1                	or     %edx,%ecx
  80269b:	89 f2                	mov    %esi,%edx
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 f9                	mov    %edi,%ecx
  8026a3:	d3 e3                	shl    %cl,%ebx
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	d3 ea                	shr    %cl,%edx
  8026a9:	89 f9                	mov    %edi,%ecx
  8026ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026af:	89 eb                	mov    %ebp,%ebx
  8026b1:	d3 e6                	shl    %cl,%esi
  8026b3:	89 c1                	mov    %eax,%ecx
  8026b5:	d3 eb                	shr    %cl,%ebx
  8026b7:	09 de                	or     %ebx,%esi
  8026b9:	89 f0                	mov    %esi,%eax
  8026bb:	f7 74 24 08          	divl   0x8(%esp)
  8026bf:	89 d6                	mov    %edx,%esi
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	f7 64 24 0c          	mull   0xc(%esp)
  8026c7:	39 d6                	cmp    %edx,%esi
  8026c9:	72 15                	jb     8026e0 <__udivdi3+0x100>
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	39 c5                	cmp    %eax,%ebp
  8026d1:	73 04                	jae    8026d7 <__udivdi3+0xf7>
  8026d3:	39 d6                	cmp    %edx,%esi
  8026d5:	74 09                	je     8026e0 <__udivdi3+0x100>
  8026d7:	89 d8                	mov    %ebx,%eax
  8026d9:	31 ff                	xor    %edi,%edi
  8026db:	e9 27 ff ff ff       	jmp    802607 <__udivdi3+0x27>
  8026e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026e3:	31 ff                	xor    %edi,%edi
  8026e5:	e9 1d ff ff ff       	jmp    802607 <__udivdi3+0x27>
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	66 90                	xchg   %ax,%ax
  8026ee:	66 90                	xchg   %ax,%ax

008026f0 <__umoddi3>:
  8026f0:	55                   	push   %ebp
  8026f1:	57                   	push   %edi
  8026f2:	56                   	push   %esi
  8026f3:	53                   	push   %ebx
  8026f4:	83 ec 1c             	sub    $0x1c,%esp
  8026f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802707:	89 da                	mov    %ebx,%edx
  802709:	85 c0                	test   %eax,%eax
  80270b:	75 43                	jne    802750 <__umoddi3+0x60>
  80270d:	39 df                	cmp    %ebx,%edi
  80270f:	76 17                	jbe    802728 <__umoddi3+0x38>
  802711:	89 f0                	mov    %esi,%eax
  802713:	f7 f7                	div    %edi
  802715:	89 d0                	mov    %edx,%eax
  802717:	31 d2                	xor    %edx,%edx
  802719:	83 c4 1c             	add    $0x1c,%esp
  80271c:	5b                   	pop    %ebx
  80271d:	5e                   	pop    %esi
  80271e:	5f                   	pop    %edi
  80271f:	5d                   	pop    %ebp
  802720:	c3                   	ret    
  802721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802728:	89 fd                	mov    %edi,%ebp
  80272a:	85 ff                	test   %edi,%edi
  80272c:	75 0b                	jne    802739 <__umoddi3+0x49>
  80272e:	b8 01 00 00 00       	mov    $0x1,%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	f7 f7                	div    %edi
  802737:	89 c5                	mov    %eax,%ebp
  802739:	89 d8                	mov    %ebx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f5                	div    %ebp
  80273f:	89 f0                	mov    %esi,%eax
  802741:	f7 f5                	div    %ebp
  802743:	89 d0                	mov    %edx,%eax
  802745:	eb d0                	jmp    802717 <__umoddi3+0x27>
  802747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80274e:	66 90                	xchg   %ax,%ax
  802750:	89 f1                	mov    %esi,%ecx
  802752:	39 d8                	cmp    %ebx,%eax
  802754:	76 0a                	jbe    802760 <__umoddi3+0x70>
  802756:	89 f0                	mov    %esi,%eax
  802758:	83 c4 1c             	add    $0x1c,%esp
  80275b:	5b                   	pop    %ebx
  80275c:	5e                   	pop    %esi
  80275d:	5f                   	pop    %edi
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    
  802760:	0f bd e8             	bsr    %eax,%ebp
  802763:	83 f5 1f             	xor    $0x1f,%ebp
  802766:	75 20                	jne    802788 <__umoddi3+0x98>
  802768:	39 d8                	cmp    %ebx,%eax
  80276a:	0f 82 b0 00 00 00    	jb     802820 <__umoddi3+0x130>
  802770:	39 f7                	cmp    %esi,%edi
  802772:	0f 86 a8 00 00 00    	jbe    802820 <__umoddi3+0x130>
  802778:	89 c8                	mov    %ecx,%eax
  80277a:	83 c4 1c             	add    $0x1c,%esp
  80277d:	5b                   	pop    %ebx
  80277e:	5e                   	pop    %esi
  80277f:	5f                   	pop    %edi
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    
  802782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	ba 20 00 00 00       	mov    $0x20,%edx
  80278f:	29 ea                	sub    %ebp,%edx
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 44 24 08          	mov    %eax,0x8(%esp)
  802797:	89 d1                	mov    %edx,%ecx
  802799:	89 f8                	mov    %edi,%eax
  80279b:	d3 e8                	shr    %cl,%eax
  80279d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027a9:	09 c1                	or     %eax,%ecx
  8027ab:	89 d8                	mov    %ebx,%eax
  8027ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b1:	89 e9                	mov    %ebp,%ecx
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	d3 e8                	shr    %cl,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 c7                	mov    %eax,%edi
  8027c3:	89 d1                	mov    %edx,%ecx
  8027c5:	89 f0                	mov    %esi,%eax
  8027c7:	d3 e8                	shr    %cl,%eax
  8027c9:	89 e9                	mov    %ebp,%ecx
  8027cb:	89 fa                	mov    %edi,%edx
  8027cd:	d3 e6                	shl    %cl,%esi
  8027cf:	09 d8                	or     %ebx,%eax
  8027d1:	f7 74 24 08          	divl   0x8(%esp)
  8027d5:	89 d1                	mov    %edx,%ecx
  8027d7:	89 f3                	mov    %esi,%ebx
  8027d9:	f7 64 24 0c          	mull   0xc(%esp)
  8027dd:	89 c6                	mov    %eax,%esi
  8027df:	89 d7                	mov    %edx,%edi
  8027e1:	39 d1                	cmp    %edx,%ecx
  8027e3:	72 06                	jb     8027eb <__umoddi3+0xfb>
  8027e5:	75 10                	jne    8027f7 <__umoddi3+0x107>
  8027e7:	39 c3                	cmp    %eax,%ebx
  8027e9:	73 0c                	jae    8027f7 <__umoddi3+0x107>
  8027eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027f3:	89 d7                	mov    %edx,%edi
  8027f5:	89 c6                	mov    %eax,%esi
  8027f7:	89 ca                	mov    %ecx,%edx
  8027f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027fe:	29 f3                	sub    %esi,%ebx
  802800:	19 fa                	sbb    %edi,%edx
  802802:	89 d0                	mov    %edx,%eax
  802804:	d3 e0                	shl    %cl,%eax
  802806:	89 e9                	mov    %ebp,%ecx
  802808:	d3 eb                	shr    %cl,%ebx
  80280a:	d3 ea                	shr    %cl,%edx
  80280c:	09 d8                	or     %ebx,%eax
  80280e:	83 c4 1c             	add    $0x1c,%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	89 da                	mov    %ebx,%edx
  802822:	29 fe                	sub    %edi,%esi
  802824:	19 c2                	sbb    %eax,%edx
  802826:	89 f1                	mov    %esi,%ecx
  802828:	89 c8                	mov    %ecx,%eax
  80282a:	e9 4b ff ff ff       	jmp    80277a <__umoddi3+0x8a>
