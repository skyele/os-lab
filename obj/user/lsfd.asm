
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
  800039:	68 a0 28 80 00       	push   $0x8028a0
  80003e:	e8 70 02 00 00       	call   8002b3 <cprintf>
	exit();
  800043:	e8 a2 01 00 00       	call   8001ea <exit>
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
  800067:	e8 8d 10 00 00       	call   8010f9 <argstart>
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
  800083:	e8 a1 10 00 00       	call   801129 <argnext>
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
  8000bd:	68 b4 28 80 00       	push   $0x8028b4
  8000c2:	e8 ec 01 00 00       	call   8002b3 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 49 16 00 00       	call   801725 <fstat>
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
  8000f8:	68 b4 28 80 00       	push   $0x8028b4
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 55 1a 00 00       	call   801b59 <fprintf>
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
  800124:	e8 9d 0c 00 00       	call   800dc6 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800188:	a1 08 40 80 00       	mov    0x804008,%eax
  80018d:	8b 40 48             	mov    0x48(%eax),%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	50                   	push   %eax
  800194:	68 dc 28 80 00       	push   $0x8028dc
  800199:	e8 15 01 00 00       	call   8002b3 <cprintf>
	cprintf("before umain\n");
  80019e:	c7 04 24 fa 28 80 00 	movl   $0x8028fa,(%esp)
  8001a5:	e8 09 01 00 00       	call   8002b3 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001aa:	83 c4 08             	add    $0x8,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 95 fe ff ff       	call   80004d <umain>
	cprintf("after umain\n");
  8001b8:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  8001bf:	e8 ef 00 00 00       	call   8002b3 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	83 c4 08             	add    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	68 15 29 80 00       	push   $0x802915
  8001d5:	e8 d9 00 00 00       	call   8002b3 <cprintf>
	// exit gracefully
	exit();
  8001da:	e8 0b 00 00 00       	call   8001ea <exit>
}
  8001df:	83 c4 10             	add    $0x10,%esp
  8001e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8001f5:	8b 40 48             	mov    0x48(%eax),%eax
  8001f8:	68 40 29 80 00       	push   $0x802940
  8001fd:	50                   	push   %eax
  8001fe:	68 34 29 80 00       	push   $0x802934
  800203:	e8 ab 00 00 00       	call   8002b3 <cprintf>
	close_all();
  800208:	e8 11 12 00 00       	call   80141e <close_all>
	sys_env_destroy(0);
  80020d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800214:	e8 6c 0b 00 00       	call   800d85 <sys_env_destroy>
}
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	53                   	push   %ebx
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800228:	8b 13                	mov    (%ebx),%edx
  80022a:	8d 42 01             	lea    0x1(%edx),%eax
  80022d:	89 03                	mov    %eax,(%ebx)
  80022f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800232:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800236:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023b:	74 09                	je     800246 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80023d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800244:	c9                   	leave  
  800245:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800246:	83 ec 08             	sub    $0x8,%esp
  800249:	68 ff 00 00 00       	push   $0xff
  80024e:	8d 43 08             	lea    0x8(%ebx),%eax
  800251:	50                   	push   %eax
  800252:	e8 f1 0a 00 00       	call   800d48 <sys_cputs>
		b->idx = 0;
  800257:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	eb db                	jmp    80023d <putch+0x1f>

00800262 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800272:	00 00 00 
	b.cnt = 0;
  800275:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028b:	50                   	push   %eax
  80028c:	68 1e 02 80 00       	push   $0x80021e
  800291:	e8 4a 01 00 00       	call   8003e0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800296:	83 c4 08             	add    $0x8,%esp
  800299:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80029f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	e8 9d 0a 00 00       	call   800d48 <sys_cputs>

	return b.cnt;
}
  8002ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bc:	50                   	push   %eax
  8002bd:	ff 75 08             	pushl  0x8(%ebp)
  8002c0:	e8 9d ff ff ff       	call   800262 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	57                   	push   %edi
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	83 ec 1c             	sub    $0x1c,%esp
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	89 d7                	mov    %edx,%edi
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002e6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ea:	74 2c                	je     800318 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002fc:	39 c2                	cmp    %eax,%edx
  8002fe:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800301:	73 43                	jae    800346 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800303:	83 eb 01             	sub    $0x1,%ebx
  800306:	85 db                	test   %ebx,%ebx
  800308:	7e 6c                	jle    800376 <printnum+0xaf>
				putch(padc, putdat);
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	57                   	push   %edi
  80030e:	ff 75 18             	pushl  0x18(%ebp)
  800311:	ff d6                	call   *%esi
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	eb eb                	jmp    800303 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	6a 20                	push   $0x20
  80031d:	6a 00                	push   $0x0
  80031f:	50                   	push   %eax
  800320:	ff 75 e4             	pushl  -0x1c(%ebp)
  800323:	ff 75 e0             	pushl  -0x20(%ebp)
  800326:	89 fa                	mov    %edi,%edx
  800328:	89 f0                	mov    %esi,%eax
  80032a:	e8 98 ff ff ff       	call   8002c7 <printnum>
		while (--width > 0)
  80032f:	83 c4 20             	add    $0x20,%esp
  800332:	83 eb 01             	sub    $0x1,%ebx
  800335:	85 db                	test   %ebx,%ebx
  800337:	7e 65                	jle    80039e <printnum+0xd7>
			putch(padc, putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	57                   	push   %edi
  80033d:	6a 20                	push   $0x20
  80033f:	ff d6                	call   *%esi
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	eb ec                	jmp    800332 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	ff 75 18             	pushl  0x18(%ebp)
  80034c:	83 eb 01             	sub    $0x1,%ebx
  80034f:	53                   	push   %ebx
  800350:	50                   	push   %eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	ff 75 dc             	pushl  -0x24(%ebp)
  800357:	ff 75 d8             	pushl  -0x28(%ebp)
  80035a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035d:	ff 75 e0             	pushl  -0x20(%ebp)
  800360:	e8 eb 22 00 00       	call   802650 <__udivdi3>
  800365:	83 c4 18             	add    $0x18,%esp
  800368:	52                   	push   %edx
  800369:	50                   	push   %eax
  80036a:	89 fa                	mov    %edi,%edx
  80036c:	89 f0                	mov    %esi,%eax
  80036e:	e8 54 ff ff ff       	call   8002c7 <printnum>
  800373:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	57                   	push   %edi
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	ff 75 dc             	pushl  -0x24(%ebp)
  800380:	ff 75 d8             	pushl  -0x28(%ebp)
  800383:	ff 75 e4             	pushl  -0x1c(%ebp)
  800386:	ff 75 e0             	pushl  -0x20(%ebp)
  800389:	e8 d2 23 00 00       	call   802760 <__umoddi3>
  80038e:	83 c4 14             	add    $0x14,%esp
  800391:	0f be 80 45 29 80 00 	movsbl 0x802945(%eax),%eax
  800398:	50                   	push   %eax
  800399:	ff d6                	call   *%esi
  80039b:	83 c4 10             	add    $0x10,%esp
	}
}
  80039e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a1:	5b                   	pop    %ebx
  8003a2:	5e                   	pop    %esi
  8003a3:	5f                   	pop    %edi
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b0:	8b 10                	mov    (%eax),%edx
  8003b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b5:	73 0a                	jae    8003c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ba:	89 08                	mov    %ecx,(%eax)
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	88 02                	mov    %al,(%edx)
}
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    

008003c3 <printfmt>:
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003c9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003cc:	50                   	push   %eax
  8003cd:	ff 75 10             	pushl  0x10(%ebp)
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	e8 05 00 00 00       	call   8003e0 <vprintfmt>
}
  8003db:	83 c4 10             	add    $0x10,%esp
  8003de:	c9                   	leave  
  8003df:	c3                   	ret    

008003e0 <vprintfmt>:
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	57                   	push   %edi
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 3c             	sub    $0x3c,%esp
  8003e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f2:	e9 32 04 00 00       	jmp    800829 <vprintfmt+0x449>
		padc = ' ';
  8003f7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003fb:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800402:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800409:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800410:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800417:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80041e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8d 47 01             	lea    0x1(%edi),%eax
  800426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800429:	0f b6 17             	movzbl (%edi),%edx
  80042c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80042f:	3c 55                	cmp    $0x55,%al
  800431:	0f 87 12 05 00 00    	ja     800949 <vprintfmt+0x569>
  800437:	0f b6 c0             	movzbl %al,%eax
  80043a:	ff 24 85 20 2b 80 00 	jmp    *0x802b20(,%eax,4)
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800444:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800448:	eb d9                	jmp    800423 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80044d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800451:	eb d0                	jmp    800423 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800453:	0f b6 d2             	movzbl %dl,%edx
  800456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800459:	b8 00 00 00 00       	mov    $0x0,%eax
  80045e:	89 75 08             	mov    %esi,0x8(%ebp)
  800461:	eb 03                	jmp    800466 <vprintfmt+0x86>
  800463:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800466:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800469:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800470:	8d 72 d0             	lea    -0x30(%edx),%esi
  800473:	83 fe 09             	cmp    $0x9,%esi
  800476:	76 eb                	jbe    800463 <vprintfmt+0x83>
  800478:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047b:	8b 75 08             	mov    0x8(%ebp),%esi
  80047e:	eb 14                	jmp    800494 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800480:	8b 45 14             	mov    0x14(%ebp),%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 40 04             	lea    0x4(%eax),%eax
  80048e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800494:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800498:	79 89                	jns    800423 <vprintfmt+0x43>
				width = precision, precision = -1;
  80049a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a7:	e9 77 ff ff ff       	jmp    800423 <vprintfmt+0x43>
  8004ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	0f 48 c1             	cmovs  %ecx,%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ba:	e9 64 ff ff ff       	jmp    800423 <vprintfmt+0x43>
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004c9:	e9 55 ff ff ff       	jmp    800423 <vprintfmt+0x43>
			lflag++;
  8004ce:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004d5:	e9 49 ff ff ff       	jmp    800423 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 78 04             	lea    0x4(%eax),%edi
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	53                   	push   %ebx
  8004e4:	ff 30                	pushl  (%eax)
  8004e6:	ff d6                	call   *%esi
			break;
  8004e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ee:	e9 33 03 00 00       	jmp    800826 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8d 78 04             	lea    0x4(%eax),%edi
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	99                   	cltd   
  8004fc:	31 d0                	xor    %edx,%eax
  8004fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800500:	83 f8 11             	cmp    $0x11,%eax
  800503:	7f 23                	jg     800528 <vprintfmt+0x148>
  800505:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  80050c:	85 d2                	test   %edx,%edx
  80050e:	74 18                	je     800528 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800510:	52                   	push   %edx
  800511:	68 9d 2d 80 00       	push   $0x802d9d
  800516:	53                   	push   %ebx
  800517:	56                   	push   %esi
  800518:	e8 a6 fe ff ff       	call   8003c3 <printfmt>
  80051d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800520:	89 7d 14             	mov    %edi,0x14(%ebp)
  800523:	e9 fe 02 00 00       	jmp    800826 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800528:	50                   	push   %eax
  800529:	68 5d 29 80 00       	push   $0x80295d
  80052e:	53                   	push   %ebx
  80052f:	56                   	push   %esi
  800530:	e8 8e fe ff ff       	call   8003c3 <printfmt>
  800535:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800538:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80053b:	e9 e6 02 00 00       	jmp    800826 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	83 c0 04             	add    $0x4,%eax
  800546:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80054e:	85 c9                	test   %ecx,%ecx
  800550:	b8 56 29 80 00       	mov    $0x802956,%eax
  800555:	0f 45 c1             	cmovne %ecx,%eax
  800558:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80055b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80055f:	7e 06                	jle    800567 <vprintfmt+0x187>
  800561:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800565:	75 0d                	jne    800574 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056a:	89 c7                	mov    %eax,%edi
  80056c:	03 45 e0             	add    -0x20(%ebp),%eax
  80056f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800572:	eb 53                	jmp    8005c7 <vprintfmt+0x1e7>
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 d8             	pushl  -0x28(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 71 04 00 00       	call   8009f1 <strnlen>
  800580:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800583:	29 c1                	sub    %eax,%ecx
  800585:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80058d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800594:	eb 0f                	jmp    8005a5 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	53                   	push   %ebx
  80059a:	ff 75 e0             	pushl  -0x20(%ebp)
  80059d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	83 ef 01             	sub    $0x1,%edi
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	85 ff                	test   %edi,%edi
  8005a7:	7f ed                	jg     800596 <vprintfmt+0x1b6>
  8005a9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ac:	85 c9                	test   %ecx,%ecx
  8005ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b3:	0f 49 c1             	cmovns %ecx,%eax
  8005b6:	29 c1                	sub    %eax,%ecx
  8005b8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005bb:	eb aa                	jmp    800567 <vprintfmt+0x187>
					putch(ch, putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	52                   	push   %edx
  8005c2:	ff d6                	call   *%esi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ca:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005cc:	83 c7 01             	add    $0x1,%edi
  8005cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d3:	0f be d0             	movsbl %al,%edx
  8005d6:	85 d2                	test   %edx,%edx
  8005d8:	74 4b                	je     800625 <vprintfmt+0x245>
  8005da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005de:	78 06                	js     8005e6 <vprintfmt+0x206>
  8005e0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e4:	78 1e                	js     800604 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ea:	74 d1                	je     8005bd <vprintfmt+0x1dd>
  8005ec:	0f be c0             	movsbl %al,%eax
  8005ef:	83 e8 20             	sub    $0x20,%eax
  8005f2:	83 f8 5e             	cmp    $0x5e,%eax
  8005f5:	76 c6                	jbe    8005bd <vprintfmt+0x1dd>
					putch('?', putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	6a 3f                	push   $0x3f
  8005fd:	ff d6                	call   *%esi
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	eb c3                	jmp    8005c7 <vprintfmt+0x1e7>
  800604:	89 cf                	mov    %ecx,%edi
  800606:	eb 0e                	jmp    800616 <vprintfmt+0x236>
				putch(' ', putdat);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	53                   	push   %ebx
  80060c:	6a 20                	push   $0x20
  80060e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800610:	83 ef 01             	sub    $0x1,%edi
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	85 ff                	test   %edi,%edi
  800618:	7f ee                	jg     800608 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80061a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	e9 01 02 00 00       	jmp    800826 <vprintfmt+0x446>
  800625:	89 cf                	mov    %ecx,%edi
  800627:	eb ed                	jmp    800616 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800629:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80062c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800633:	e9 eb fd ff ff       	jmp    800423 <vprintfmt+0x43>
	if (lflag >= 2)
  800638:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80063c:	7f 21                	jg     80065f <vprintfmt+0x27f>
	else if (lflag)
  80063e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800642:	74 68                	je     8006ac <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	c1 f9 1f             	sar    $0x1f,%ecx
  800651:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	eb 17                	jmp    800676 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 50 04             	mov    0x4(%eax),%edx
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800676:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800679:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800682:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800686:	78 3f                	js     8006c7 <vprintfmt+0x2e7>
			base = 10;
  800688:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80068d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800691:	0f 84 71 01 00 00    	je     800808 <vprintfmt+0x428>
				putch('+', putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	6a 2b                	push   $0x2b
  80069d:	ff d6                	call   *%esi
  80069f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a7:	e9 5c 01 00 00       	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b4:	89 c1                	mov    %eax,%ecx
  8006b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	eb af                	jmp    800676 <vprintfmt+0x296>
				putch('-', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 2d                	push   $0x2d
  8006cd:	ff d6                	call   *%esi
				num = -(long long) num;
  8006cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d5:	f7 d8                	neg    %eax
  8006d7:	83 d2 00             	adc    $0x0,%edx
  8006da:	f7 da                	neg    %edx
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ea:	e9 19 01 00 00       	jmp    800808 <vprintfmt+0x428>
	if (lflag >= 2)
  8006ef:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f3:	7f 29                	jg     80071e <vprintfmt+0x33e>
	else if (lflag)
  8006f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f9:	74 44                	je     80073f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	b8 0a 00 00 00       	mov    $0xa,%eax
  800719:	e9 ea 00 00 00       	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 50 04             	mov    0x4(%eax),%edx
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 08             	lea    0x8(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	e9 c9 00 00 00       	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800758:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075d:	e9 a6 00 00 00       	jmp    800808 <vprintfmt+0x428>
			putch('0', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 30                	push   $0x30
  800768:	ff d6                	call   *%esi
	if (lflag >= 2)
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800771:	7f 26                	jg     800799 <vprintfmt+0x3b9>
	else if (lflag)
  800773:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800777:	74 3e                	je     8007b7 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800792:	b8 08 00 00 00       	mov    $0x8,%eax
  800797:	eb 6f                	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 50 04             	mov    0x4(%eax),%edx
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 08             	lea    0x8(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b5:	eb 51                	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d5:	eb 31                	jmp    800808 <vprintfmt+0x428>
			putch('0', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	53                   	push   %ebx
  8007db:	6a 30                	push   $0x30
  8007dd:	ff d6                	call   *%esi
			putch('x', putdat);
  8007df:	83 c4 08             	add    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	6a 78                	push   $0x78
  8007e5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007f7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800803:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800808:	83 ec 0c             	sub    $0xc,%esp
  80080b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80080f:	52                   	push   %edx
  800810:	ff 75 e0             	pushl  -0x20(%ebp)
  800813:	50                   	push   %eax
  800814:	ff 75 dc             	pushl  -0x24(%ebp)
  800817:	ff 75 d8             	pushl  -0x28(%ebp)
  80081a:	89 da                	mov    %ebx,%edx
  80081c:	89 f0                	mov    %esi,%eax
  80081e:	e8 a4 fa ff ff       	call   8002c7 <printnum>
			break;
  800823:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800826:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800829:	83 c7 01             	add    $0x1,%edi
  80082c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800830:	83 f8 25             	cmp    $0x25,%eax
  800833:	0f 84 be fb ff ff    	je     8003f7 <vprintfmt+0x17>
			if (ch == '\0')
  800839:	85 c0                	test   %eax,%eax
  80083b:	0f 84 28 01 00 00    	je     800969 <vprintfmt+0x589>
			putch(ch, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	50                   	push   %eax
  800846:	ff d6                	call   *%esi
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	eb dc                	jmp    800829 <vprintfmt+0x449>
	if (lflag >= 2)
  80084d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800851:	7f 26                	jg     800879 <vprintfmt+0x499>
	else if (lflag)
  800853:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800857:	74 41                	je     80089a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	ba 00 00 00 00       	mov    $0x0,%edx
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8d 40 04             	lea    0x4(%eax),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800872:	b8 10 00 00 00       	mov    $0x10,%eax
  800877:	eb 8f                	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 50 04             	mov    0x4(%eax),%edx
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800884:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 40 08             	lea    0x8(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800890:	b8 10 00 00 00       	mov    $0x10,%eax
  800895:	e9 6e ff ff ff       	jmp    800808 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b8:	e9 4b ff ff ff       	jmp    800808 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	74 14                	je     8008e3 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008cf:	8b 13                	mov    (%ebx),%edx
  8008d1:	83 fa 7f             	cmp    $0x7f,%edx
  8008d4:	7f 37                	jg     80090d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008d6:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
  8008de:	e9 43 ff ff ff       	jmp    800826 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e8:	bf 79 2a 80 00       	mov    $0x802a79,%edi
							putch(ch, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	50                   	push   %eax
  8008f2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f4:	83 c7 01             	add    $0x1,%edi
  8008f7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	85 c0                	test   %eax,%eax
  800900:	75 eb                	jne    8008ed <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800902:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
  800908:	e9 19 ff ff ff       	jmp    800826 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80090d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80090f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800914:	bf b1 2a 80 00       	mov    $0x802ab1,%edi
							putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	50                   	push   %eax
  80091e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800920:	83 c7 01             	add    $0x1,%edi
  800923:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 c0                	test   %eax,%eax
  80092c:	75 eb                	jne    800919 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80092e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	e9 ed fe ff ff       	jmp    800826 <vprintfmt+0x446>
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	53                   	push   %ebx
  80093d:	6a 25                	push   $0x25
  80093f:	ff d6                	call   *%esi
			break;
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	e9 dd fe ff ff       	jmp    800826 <vprintfmt+0x446>
			putch('%', putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	53                   	push   %ebx
  80094d:	6a 25                	push   $0x25
  80094f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800951:	83 c4 10             	add    $0x10,%esp
  800954:	89 f8                	mov    %edi,%eax
  800956:	eb 03                	jmp    80095b <vprintfmt+0x57b>
  800958:	83 e8 01             	sub    $0x1,%eax
  80095b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80095f:	75 f7                	jne    800958 <vprintfmt+0x578>
  800961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800964:	e9 bd fe ff ff       	jmp    800826 <vprintfmt+0x446>
}
  800969:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096c:	5b                   	pop    %ebx
  80096d:	5e                   	pop    %esi
  80096e:	5f                   	pop    %edi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 18             	sub    $0x18,%esp
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800980:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800984:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80098e:	85 c0                	test   %eax,%eax
  800990:	74 26                	je     8009b8 <vsnprintf+0x47>
  800992:	85 d2                	test   %edx,%edx
  800994:	7e 22                	jle    8009b8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800996:	ff 75 14             	pushl  0x14(%ebp)
  800999:	ff 75 10             	pushl  0x10(%ebp)
  80099c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	68 a6 03 80 00       	push   $0x8003a6
  8009a5:	e8 36 fa ff ff       	call   8003e0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b3:	83 c4 10             	add    $0x10,%esp
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    
		return -E_INVAL;
  8009b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bd:	eb f7                	jmp    8009b6 <vsnprintf+0x45>

008009bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009c8:	50                   	push   %eax
  8009c9:	ff 75 10             	pushl  0x10(%ebp)
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	ff 75 08             	pushl  0x8(%ebp)
  8009d2:	e8 9a ff ff ff       	call   800971 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009df:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009e8:	74 05                	je     8009ef <strlen+0x16>
		n++;
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	eb f5                	jmp    8009e4 <strlen+0xb>
	return n;
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ff:	39 c2                	cmp    %eax,%edx
  800a01:	74 0d                	je     800a10 <strnlen+0x1f>
  800a03:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a07:	74 05                	je     800a0e <strnlen+0x1d>
		n++;
  800a09:	83 c2 01             	add    $0x1,%edx
  800a0c:	eb f1                	jmp    8009ff <strnlen+0xe>
  800a0e:	89 d0                	mov    %edx,%eax
	return n;
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a21:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a25:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a28:	83 c2 01             	add    $0x1,%edx
  800a2b:	84 c9                	test   %cl,%cl
  800a2d:	75 f2                	jne    800a21 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a2f:	5b                   	pop    %ebx
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	53                   	push   %ebx
  800a36:	83 ec 10             	sub    $0x10,%esp
  800a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a3c:	53                   	push   %ebx
  800a3d:	e8 97 ff ff ff       	call   8009d9 <strlen>
  800a42:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	01 d8                	add    %ebx,%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 c2 ff ff ff       	call   800a12 <strcpy>
	return dst;
}
  800a50:	89 d8                	mov    %ebx,%eax
  800a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a62:	89 c6                	mov    %eax,%esi
  800a64:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a67:	89 c2                	mov    %eax,%edx
  800a69:	39 f2                	cmp    %esi,%edx
  800a6b:	74 11                	je     800a7e <strncpy+0x27>
		*dst++ = *src;
  800a6d:	83 c2 01             	add    $0x1,%edx
  800a70:	0f b6 19             	movzbl (%ecx),%ebx
  800a73:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a76:	80 fb 01             	cmp    $0x1,%bl
  800a79:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a7c:	eb eb                	jmp    800a69 <strncpy+0x12>
	}
	return ret;
}
  800a7e:	5b                   	pop    %ebx
  800a7f:	5e                   	pop    %esi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8d:	8b 55 10             	mov    0x10(%ebp),%edx
  800a90:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a92:	85 d2                	test   %edx,%edx
  800a94:	74 21                	je     800ab7 <strlcpy+0x35>
  800a96:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a9a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	74 14                	je     800ab4 <strlcpy+0x32>
  800aa0:	0f b6 19             	movzbl (%ecx),%ebx
  800aa3:	84 db                	test   %bl,%bl
  800aa5:	74 0b                	je     800ab2 <strlcpy+0x30>
			*dst++ = *src++;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	83 c2 01             	add    $0x1,%edx
  800aad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab0:	eb ea                	jmp    800a9c <strlcpy+0x1a>
  800ab2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab7:	29 f0                	sub    %esi,%eax
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac6:	0f b6 01             	movzbl (%ecx),%eax
  800ac9:	84 c0                	test   %al,%al
  800acb:	74 0c                	je     800ad9 <strcmp+0x1c>
  800acd:	3a 02                	cmp    (%edx),%al
  800acf:	75 08                	jne    800ad9 <strcmp+0x1c>
		p++, q++;
  800ad1:	83 c1 01             	add    $0x1,%ecx
  800ad4:	83 c2 01             	add    $0x1,%edx
  800ad7:	eb ed                	jmp    800ac6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	0f b6 12             	movzbl (%edx),%edx
  800adf:	29 d0                	sub    %edx,%eax
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	53                   	push   %ebx
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	89 c3                	mov    %eax,%ebx
  800aef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af2:	eb 06                	jmp    800afa <strncmp+0x17>
		n--, p++, q++;
  800af4:	83 c0 01             	add    $0x1,%eax
  800af7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afa:	39 d8                	cmp    %ebx,%eax
  800afc:	74 16                	je     800b14 <strncmp+0x31>
  800afe:	0f b6 08             	movzbl (%eax),%ecx
  800b01:	84 c9                	test   %cl,%cl
  800b03:	74 04                	je     800b09 <strncmp+0x26>
  800b05:	3a 0a                	cmp    (%edx),%cl
  800b07:	74 eb                	je     800af4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b09:	0f b6 00             	movzbl (%eax),%eax
  800b0c:	0f b6 12             	movzbl (%edx),%edx
  800b0f:	29 d0                	sub    %edx,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    
		return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	eb f6                	jmp    800b11 <strncmp+0x2e>

00800b1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b25:	0f b6 10             	movzbl (%eax),%edx
  800b28:	84 d2                	test   %dl,%dl
  800b2a:	74 09                	je     800b35 <strchr+0x1a>
		if (*s == c)
  800b2c:	38 ca                	cmp    %cl,%dl
  800b2e:	74 0a                	je     800b3a <strchr+0x1f>
	for (; *s; s++)
  800b30:	83 c0 01             	add    $0x1,%eax
  800b33:	eb f0                	jmp    800b25 <strchr+0xa>
			return (char *) s;
	return 0;
  800b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b46:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b49:	38 ca                	cmp    %cl,%dl
  800b4b:	74 09                	je     800b56 <strfind+0x1a>
  800b4d:	84 d2                	test   %dl,%dl
  800b4f:	74 05                	je     800b56 <strfind+0x1a>
	for (; *s; s++)
  800b51:	83 c0 01             	add    $0x1,%eax
  800b54:	eb f0                	jmp    800b46 <strfind+0xa>
			break;
	return (char *) s;
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b64:	85 c9                	test   %ecx,%ecx
  800b66:	74 31                	je     800b99 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b68:	89 f8                	mov    %edi,%eax
  800b6a:	09 c8                	or     %ecx,%eax
  800b6c:	a8 03                	test   $0x3,%al
  800b6e:	75 23                	jne    800b93 <memset+0x3b>
		c &= 0xFF;
  800b70:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b74:	89 d3                	mov    %edx,%ebx
  800b76:	c1 e3 08             	shl    $0x8,%ebx
  800b79:	89 d0                	mov    %edx,%eax
  800b7b:	c1 e0 18             	shl    $0x18,%eax
  800b7e:	89 d6                	mov    %edx,%esi
  800b80:	c1 e6 10             	shl    $0x10,%esi
  800b83:	09 f0                	or     %esi,%eax
  800b85:	09 c2                	or     %eax,%edx
  800b87:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b89:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b8c:	89 d0                	mov    %edx,%eax
  800b8e:	fc                   	cld    
  800b8f:	f3 ab                	rep stos %eax,%es:(%edi)
  800b91:	eb 06                	jmp    800b99 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	fc                   	cld    
  800b97:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b99:	89 f8                	mov    %edi,%eax
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bae:	39 c6                	cmp    %eax,%esi
  800bb0:	73 32                	jae    800be4 <memmove+0x44>
  800bb2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	76 2b                	jbe    800be4 <memmove+0x44>
		s += n;
		d += n;
  800bb9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbc:	89 fe                	mov    %edi,%esi
  800bbe:	09 ce                	or     %ecx,%esi
  800bc0:	09 d6                	or     %edx,%esi
  800bc2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc8:	75 0e                	jne    800bd8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bca:	83 ef 04             	sub    $0x4,%edi
  800bcd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bd3:	fd                   	std    
  800bd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd6:	eb 09                	jmp    800be1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bd8:	83 ef 01             	sub    $0x1,%edi
  800bdb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bde:	fd                   	std    
  800bdf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be1:	fc                   	cld    
  800be2:	eb 1a                	jmp    800bfe <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be4:	89 c2                	mov    %eax,%edx
  800be6:	09 ca                	or     %ecx,%edx
  800be8:	09 f2                	or     %esi,%edx
  800bea:	f6 c2 03             	test   $0x3,%dl
  800bed:	75 0a                	jne    800bf9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf2:	89 c7                	mov    %eax,%edi
  800bf4:	fc                   	cld    
  800bf5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf7:	eb 05                	jmp    800bfe <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	fc                   	cld    
  800bfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c08:	ff 75 10             	pushl  0x10(%ebp)
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	ff 75 08             	pushl  0x8(%ebp)
  800c11:	e8 8a ff ff ff       	call   800ba0 <memmove>
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	89 c6                	mov    %eax,%esi
  800c25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c28:	39 f0                	cmp    %esi,%eax
  800c2a:	74 1c                	je     800c48 <memcmp+0x30>
		if (*s1 != *s2)
  800c2c:	0f b6 08             	movzbl (%eax),%ecx
  800c2f:	0f b6 1a             	movzbl (%edx),%ebx
  800c32:	38 d9                	cmp    %bl,%cl
  800c34:	75 08                	jne    800c3e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c36:	83 c0 01             	add    $0x1,%eax
  800c39:	83 c2 01             	add    $0x1,%edx
  800c3c:	eb ea                	jmp    800c28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c3e:	0f b6 c1             	movzbl %cl,%eax
  800c41:	0f b6 db             	movzbl %bl,%ebx
  800c44:	29 d8                	sub    %ebx,%eax
  800c46:	eb 05                	jmp    800c4d <memcmp+0x35>
	}

	return 0;
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5a:	89 c2                	mov    %eax,%edx
  800c5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c5f:	39 d0                	cmp    %edx,%eax
  800c61:	73 09                	jae    800c6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c63:	38 08                	cmp    %cl,(%eax)
  800c65:	74 05                	je     800c6c <memfind+0x1b>
	for (; s < ends; s++)
  800c67:	83 c0 01             	add    $0x1,%eax
  800c6a:	eb f3                	jmp    800c5f <memfind+0xe>
			break;
	return (void *) s;
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7a:	eb 03                	jmp    800c7f <strtol+0x11>
		s++;
  800c7c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c7f:	0f b6 01             	movzbl (%ecx),%eax
  800c82:	3c 20                	cmp    $0x20,%al
  800c84:	74 f6                	je     800c7c <strtol+0xe>
  800c86:	3c 09                	cmp    $0x9,%al
  800c88:	74 f2                	je     800c7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c8a:	3c 2b                	cmp    $0x2b,%al
  800c8c:	74 2a                	je     800cb8 <strtol+0x4a>
	int neg = 0;
  800c8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c93:	3c 2d                	cmp    $0x2d,%al
  800c95:	74 2b                	je     800cc2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c9d:	75 0f                	jne    800cae <strtol+0x40>
  800c9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca2:	74 28                	je     800ccc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca4:	85 db                	test   %ebx,%ebx
  800ca6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cab:	0f 44 d8             	cmove  %eax,%ebx
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb6:	eb 50                	jmp    800d08 <strtol+0x9a>
		s++;
  800cb8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc0:	eb d5                	jmp    800c97 <strtol+0x29>
		s++, neg = 1;
  800cc2:	83 c1 01             	add    $0x1,%ecx
  800cc5:	bf 01 00 00 00       	mov    $0x1,%edi
  800cca:	eb cb                	jmp    800c97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd0:	74 0e                	je     800ce0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	75 d8                	jne    800cae <strtol+0x40>
		s++, base = 8;
  800cd6:	83 c1 01             	add    $0x1,%ecx
  800cd9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cde:	eb ce                	jmp    800cae <strtol+0x40>
		s += 2, base = 16;
  800ce0:	83 c1 02             	add    $0x2,%ecx
  800ce3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ce8:	eb c4                	jmp    800cae <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cea:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ced:	89 f3                	mov    %esi,%ebx
  800cef:	80 fb 19             	cmp    $0x19,%bl
  800cf2:	77 29                	ja     800d1d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf4:	0f be d2             	movsbl %dl,%edx
  800cf7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cfd:	7d 30                	jge    800d2f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cff:	83 c1 01             	add    $0x1,%ecx
  800d02:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d06:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d08:	0f b6 11             	movzbl (%ecx),%edx
  800d0b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d0e:	89 f3                	mov    %esi,%ebx
  800d10:	80 fb 09             	cmp    $0x9,%bl
  800d13:	77 d5                	ja     800cea <strtol+0x7c>
			dig = *s - '0';
  800d15:	0f be d2             	movsbl %dl,%edx
  800d18:	83 ea 30             	sub    $0x30,%edx
  800d1b:	eb dd                	jmp    800cfa <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d20:	89 f3                	mov    %esi,%ebx
  800d22:	80 fb 19             	cmp    $0x19,%bl
  800d25:	77 08                	ja     800d2f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d27:	0f be d2             	movsbl %dl,%edx
  800d2a:	83 ea 37             	sub    $0x37,%edx
  800d2d:	eb cb                	jmp    800cfa <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d33:	74 05                	je     800d3a <strtol+0xcc>
		*endptr = (char *) s;
  800d35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3a:	89 c2                	mov    %eax,%edx
  800d3c:	f7 da                	neg    %edx
  800d3e:	85 ff                	test   %edi,%edi
  800d40:	0f 45 c2             	cmovne %edx,%eax
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	89 c3                	mov    %eax,%ebx
  800d5b:	89 c7                	mov    %eax,%edi
  800d5d:	89 c6                	mov    %eax,%esi
  800d5f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d71:	b8 01 00 00 00       	mov    $0x1,%eax
  800d76:	89 d1                	mov    %edx,%ecx
  800d78:	89 d3                	mov    %edx,%ebx
  800d7a:	89 d7                	mov    %edx,%edi
  800d7c:	89 d6                	mov    %edx,%esi
  800d7e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 03                	push   $0x3
  800db5:	68 c8 2c 80 00       	push   $0x802cc8
  800dba:	6a 43                	push   $0x43
  800dbc:	68 e5 2c 80 00       	push   $0x802ce5
  800dc1:	e8 ea 16 00 00       	call   8024b0 <_panic>

00800dc6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd1:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd6:	89 d1                	mov    %edx,%ecx
  800dd8:	89 d3                	mov    %edx,%ebx
  800dda:	89 d7                	mov    %edx,%edi
  800ddc:	89 d6                	mov    %edx,%esi
  800dde:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <sys_yield>:

void
sys_yield(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800deb:	ba 00 00 00 00       	mov    $0x0,%edx
  800df0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df5:	89 d1                	mov    %edx,%ecx
  800df7:	89 d3                	mov    %edx,%ebx
  800df9:	89 d7                	mov    %edx,%edi
  800dfb:	89 d6                	mov    %edx,%esi
  800dfd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	be 00 00 00 00       	mov    $0x0,%esi
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 04 00 00 00       	mov    $0x4,%eax
  800e1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e20:	89 f7                	mov    %esi,%edi
  800e22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 04                	push   $0x4
  800e36:	68 c8 2c 80 00       	push   $0x802cc8
  800e3b:	6a 43                	push   $0x43
  800e3d:	68 e5 2c 80 00       	push   $0x802ce5
  800e42:	e8 69 16 00 00       	call   8024b0 <_panic>

00800e47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e61:	8b 75 18             	mov    0x18(%ebp),%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 05                	push   $0x5
  800e78:	68 c8 2c 80 00       	push   $0x802cc8
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 e5 2c 80 00       	push   $0x802ce5
  800e84:	e8 27 16 00 00       	call   8024b0 <_panic>

00800e89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9d:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea2:	89 df                	mov    %ebx,%edi
  800ea4:	89 de                	mov    %ebx,%esi
  800ea6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7f 08                	jg     800eb4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 06                	push   $0x6
  800eba:	68 c8 2c 80 00       	push   $0x802cc8
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 e5 2c 80 00       	push   $0x802ce5
  800ec6:	e8 e5 15 00 00       	call   8024b0 <_panic>

00800ecb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7f 08                	jg     800ef6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 08                	push   $0x8
  800efc:	68 c8 2c 80 00       	push   $0x802cc8
  800f01:	6a 43                	push   $0x43
  800f03:	68 e5 2c 80 00       	push   $0x802ce5
  800f08:	e8 a3 15 00 00       	call   8024b0 <_panic>

00800f0d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	b8 09 00 00 00       	mov    $0x9,%eax
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7f 08                	jg     800f38 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	50                   	push   %eax
  800f3c:	6a 09                	push   $0x9
  800f3e:	68 c8 2c 80 00       	push   $0x802cc8
  800f43:	6a 43                	push   $0x43
  800f45:	68 e5 2c 80 00       	push   $0x802ce5
  800f4a:	e8 61 15 00 00       	call   8024b0 <_panic>

00800f4f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f68:	89 df                	mov    %ebx,%edi
  800f6a:	89 de                	mov    %ebx,%esi
  800f6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	7f 08                	jg     800f7a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	50                   	push   %eax
  800f7e:	6a 0a                	push   $0xa
  800f80:	68 c8 2c 80 00       	push   $0x802cc8
  800f85:	6a 43                	push   $0x43
  800f87:	68 e5 2c 80 00       	push   $0x802ce5
  800f8c:	e8 1f 15 00 00       	call   8024b0 <_panic>

00800f91 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa2:	be 00 00 00 00       	mov    $0x0,%esi
  800fa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800faa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fad:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fca:	89 cb                	mov    %ecx,%ebx
  800fcc:	89 cf                	mov    %ecx,%edi
  800fce:	89 ce                	mov    %ecx,%esi
  800fd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	7f 08                	jg     800fde <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fde:	83 ec 0c             	sub    $0xc,%esp
  800fe1:	50                   	push   %eax
  800fe2:	6a 0d                	push   $0xd
  800fe4:	68 c8 2c 80 00       	push   $0x802cc8
  800fe9:	6a 43                	push   $0x43
  800feb:	68 e5 2c 80 00       	push   $0x802ce5
  800ff0:	e8 bb 14 00 00       	call   8024b0 <_panic>

00800ff5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	57                   	push   %edi
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801006:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100b:	89 df                	mov    %ebx,%edi
  80100d:	89 de                	mov    %ebx,%esi
  80100f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	b8 0f 00 00 00       	mov    $0xf,%eax
  801029:	89 cb                	mov    %ecx,%ebx
  80102b:	89 cf                	mov    %ecx,%edi
  80102d:	89 ce                	mov    %ecx,%esi
  80102f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	57                   	push   %edi
  80103a:	56                   	push   %esi
  80103b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103c:	ba 00 00 00 00       	mov    $0x0,%edx
  801041:	b8 10 00 00 00       	mov    $0x10,%eax
  801046:	89 d1                	mov    %edx,%ecx
  801048:	89 d3                	mov    %edx,%ebx
  80104a:	89 d7                	mov    %edx,%edi
  80104c:	89 d6                	mov    %edx,%esi
  80104e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	b8 11 00 00 00       	mov    $0x11,%eax
  80106b:	89 df                	mov    %ebx,%edi
  80106d:	89 de                	mov    %ebx,%esi
  80106f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801087:	b8 12 00 00 00       	mov    $0x12,%eax
  80108c:	89 df                	mov    %ebx,%edi
  80108e:	89 de                	mov    %ebx,%esi
  801090:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5f                   	pop    %edi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ab:	b8 13 00 00 00       	mov    $0x13,%eax
  8010b0:	89 df                	mov    %ebx,%edi
  8010b2:	89 de                	mov    %ebx,%esi
  8010b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	7f 08                	jg     8010c2 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	50                   	push   %eax
  8010c6:	6a 13                	push   $0x13
  8010c8:	68 c8 2c 80 00       	push   $0x802cc8
  8010cd:	6a 43                	push   $0x43
  8010cf:	68 e5 2c 80 00       	push   $0x802ce5
  8010d4:	e8 d7 13 00 00       	call   8024b0 <_panic>

008010d9 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	b8 14 00 00 00       	mov    $0x14,%eax
  8010ec:	89 cb                	mov    %ecx,%ebx
  8010ee:	89 cf                	mov    %ecx,%edi
  8010f0:	89 ce                	mov    %ecx,%esi
  8010f2:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801105:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801107:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80110a:	83 3a 01             	cmpl   $0x1,(%edx)
  80110d:	7e 09                	jle    801118 <argstart+0x1f>
  80110f:	ba f9 28 80 00       	mov    $0x8028f9,%edx
  801114:	85 c9                	test   %ecx,%ecx
  801116:	75 05                	jne    80111d <argstart+0x24>
  801118:	ba 00 00 00 00       	mov    $0x0,%edx
  80111d:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801120:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    

00801129 <argnext>:

int
argnext(struct Argstate *args)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	53                   	push   %ebx
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801133:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80113a:	8b 43 08             	mov    0x8(%ebx),%eax
  80113d:	85 c0                	test   %eax,%eax
  80113f:	74 72                	je     8011b3 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801141:	80 38 00             	cmpb   $0x0,(%eax)
  801144:	75 48                	jne    80118e <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801146:	8b 0b                	mov    (%ebx),%ecx
  801148:	83 39 01             	cmpl   $0x1,(%ecx)
  80114b:	74 58                	je     8011a5 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80114d:	8b 53 04             	mov    0x4(%ebx),%edx
  801150:	8b 42 04             	mov    0x4(%edx),%eax
  801153:	80 38 2d             	cmpb   $0x2d,(%eax)
  801156:	75 4d                	jne    8011a5 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801158:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80115c:	74 47                	je     8011a5 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80115e:	83 c0 01             	add    $0x1,%eax
  801161:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801164:	83 ec 04             	sub    $0x4,%esp
  801167:	8b 01                	mov    (%ecx),%eax
  801169:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801170:	50                   	push   %eax
  801171:	8d 42 08             	lea    0x8(%edx),%eax
  801174:	50                   	push   %eax
  801175:	83 c2 04             	add    $0x4,%edx
  801178:	52                   	push   %edx
  801179:	e8 22 fa ff ff       	call   800ba0 <memmove>
		(*args->argc)--;
  80117e:	8b 03                	mov    (%ebx),%eax
  801180:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801183:	8b 43 08             	mov    0x8(%ebx),%eax
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	80 38 2d             	cmpb   $0x2d,(%eax)
  80118c:	74 11                	je     80119f <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80118e:	8b 53 08             	mov    0x8(%ebx),%edx
  801191:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801194:	83 c2 01             	add    $0x1,%edx
  801197:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80119a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80119f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011a3:	75 e9                	jne    80118e <argnext+0x65>
	args->curarg = 0;
  8011a5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8011ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011b1:	eb e7                	jmp    80119a <argnext+0x71>
		return -1;
  8011b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011b8:	eb e0                	jmp    80119a <argnext+0x71>

008011ba <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8011c4:	8b 43 08             	mov    0x8(%ebx),%eax
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	74 12                	je     8011dd <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8011cb:	80 38 00             	cmpb   $0x0,(%eax)
  8011ce:	74 12                	je     8011e2 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8011d0:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8011d3:	c7 43 08 f9 28 80 00 	movl   $0x8028f9,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8011da:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8011dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    
	} else if (*args->argc > 1) {
  8011e2:	8b 13                	mov    (%ebx),%edx
  8011e4:	83 3a 01             	cmpl   $0x1,(%edx)
  8011e7:	7f 10                	jg     8011f9 <argnextvalue+0x3f>
		args->argvalue = 0;
  8011e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011f7:	eb e1                	jmp    8011da <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8011f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8011fc:	8b 48 04             	mov    0x4(%eax),%ecx
  8011ff:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	8b 12                	mov    (%edx),%edx
  801207:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80120e:	52                   	push   %edx
  80120f:	8d 50 08             	lea    0x8(%eax),%edx
  801212:	52                   	push   %edx
  801213:	83 c0 04             	add    $0x4,%eax
  801216:	50                   	push   %eax
  801217:	e8 84 f9 ff ff       	call   800ba0 <memmove>
		(*args->argc)--;
  80121c:	8b 03                	mov    (%ebx),%eax
  80121e:	83 28 01             	subl   $0x1,(%eax)
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	eb b4                	jmp    8011da <argnextvalue+0x20>

00801226 <argvalue>:
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	83 ec 08             	sub    $0x8,%esp
  80122c:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80122f:	8b 42 0c             	mov    0xc(%edx),%eax
  801232:	85 c0                	test   %eax,%eax
  801234:	74 02                	je     801238 <argvalue+0x12>
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	52                   	push   %edx
  80123c:	e8 79 ff ff ff       	call   8011ba <argnextvalue>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	eb f0                	jmp    801236 <argvalue+0x10>

00801246 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	05 00 00 00 30       	add    $0x30000000,%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
}
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801261:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801266:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801275:	89 c2                	mov    %eax,%edx
  801277:	c1 ea 16             	shr    $0x16,%edx
  80127a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801281:	f6 c2 01             	test   $0x1,%dl
  801284:	74 2d                	je     8012b3 <fd_alloc+0x46>
  801286:	89 c2                	mov    %eax,%edx
  801288:	c1 ea 0c             	shr    $0xc,%edx
  80128b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801292:	f6 c2 01             	test   $0x1,%dl
  801295:	74 1c                	je     8012b3 <fd_alloc+0x46>
  801297:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80129c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a1:	75 d2                	jne    801275 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b1:	eb 0a                	jmp    8012bd <fd_alloc+0x50>
			*fd_store = fd;
  8012b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c5:	83 f8 1f             	cmp    $0x1f,%eax
  8012c8:	77 30                	ja     8012fa <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012ca:	c1 e0 0c             	shl    $0xc,%eax
  8012cd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012d8:	f6 c2 01             	test   $0x1,%dl
  8012db:	74 24                	je     801301 <fd_lookup+0x42>
  8012dd:	89 c2                	mov    %eax,%edx
  8012df:	c1 ea 0c             	shr    $0xc,%edx
  8012e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e9:	f6 c2 01             	test   $0x1,%dl
  8012ec:	74 1a                	je     801308 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    
		return -E_INVAL;
  8012fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ff:	eb f7                	jmp    8012f8 <fd_lookup+0x39>
		return -E_INVAL;
  801301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801306:	eb f0                	jmp    8012f8 <fd_lookup+0x39>
  801308:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130d:	eb e9                	jmp    8012f8 <fd_lookup+0x39>

0080130f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801318:	ba 00 00 00 00       	mov    $0x0,%edx
  80131d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801322:	39 08                	cmp    %ecx,(%eax)
  801324:	74 38                	je     80135e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801326:	83 c2 01             	add    $0x1,%edx
  801329:	8b 04 95 70 2d 80 00 	mov    0x802d70(,%edx,4),%eax
  801330:	85 c0                	test   %eax,%eax
  801332:	75 ee                	jne    801322 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801334:	a1 08 40 80 00       	mov    0x804008,%eax
  801339:	8b 40 48             	mov    0x48(%eax),%eax
  80133c:	83 ec 04             	sub    $0x4,%esp
  80133f:	51                   	push   %ecx
  801340:	50                   	push   %eax
  801341:	68 f4 2c 80 00       	push   $0x802cf4
  801346:	e8 68 ef ff ff       	call   8002b3 <cprintf>
	*dev = 0;
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    
			*dev = devtab[i];
  80135e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801361:	89 01                	mov    %eax,(%ecx)
			return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb f2                	jmp    80135c <dev_lookup+0x4d>

0080136a <fd_close>:
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
  801370:	83 ec 24             	sub    $0x24,%esp
  801373:	8b 75 08             	mov    0x8(%ebp),%esi
  801376:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801379:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80137c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80137d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801383:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801386:	50                   	push   %eax
  801387:	e8 33 ff ff ff       	call   8012bf <fd_lookup>
  80138c:	89 c3                	mov    %eax,%ebx
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 05                	js     80139a <fd_close+0x30>
	    || fd != fd2)
  801395:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801398:	74 16                	je     8013b0 <fd_close+0x46>
		return (must_exist ? r : 0);
  80139a:	89 f8                	mov    %edi,%eax
  80139c:	84 c0                	test   %al,%al
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	0f 44 d8             	cmove  %eax,%ebx
}
  8013a6:	89 d8                	mov    %ebx,%eax
  8013a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ab:	5b                   	pop    %ebx
  8013ac:	5e                   	pop    %esi
  8013ad:	5f                   	pop    %edi
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013b6:	50                   	push   %eax
  8013b7:	ff 36                	pushl  (%esi)
  8013b9:	e8 51 ff ff ff       	call   80130f <dev_lookup>
  8013be:	89 c3                	mov    %eax,%ebx
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 1a                	js     8013e1 <fd_close+0x77>
		if (dev->dev_close)
  8013c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ca:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	74 0b                	je     8013e1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	56                   	push   %esi
  8013da:	ff d0                	call   *%eax
  8013dc:	89 c3                	mov    %eax,%ebx
  8013de:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013e1:	83 ec 08             	sub    $0x8,%esp
  8013e4:	56                   	push   %esi
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 9d fa ff ff       	call   800e89 <sys_page_unmap>
	return r;
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	eb b5                	jmp    8013a6 <fd_close+0x3c>

008013f1 <close>:

int
close(int fdnum)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	ff 75 08             	pushl  0x8(%ebp)
  8013fe:	e8 bc fe ff ff       	call   8012bf <fd_lookup>
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	79 02                	jns    80140c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    
		return fd_close(fd, 1);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	6a 01                	push   $0x1
  801411:	ff 75 f4             	pushl  -0xc(%ebp)
  801414:	e8 51 ff ff ff       	call   80136a <fd_close>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	eb ec                	jmp    80140a <close+0x19>

0080141e <close_all>:

void
close_all(void)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	53                   	push   %ebx
  801422:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	53                   	push   %ebx
  80142e:	e8 be ff ff ff       	call   8013f1 <close>
	for (i = 0; i < MAXFD; i++)
  801433:	83 c3 01             	add    $0x1,%ebx
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	83 fb 20             	cmp    $0x20,%ebx
  80143c:	75 ec                	jne    80142a <close_all+0xc>
}
  80143e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80144c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80144f:	50                   	push   %eax
  801450:	ff 75 08             	pushl  0x8(%ebp)
  801453:	e8 67 fe ff ff       	call   8012bf <fd_lookup>
  801458:	89 c3                	mov    %eax,%ebx
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	0f 88 81 00 00 00    	js     8014e6 <dup+0xa3>
		return r;
	close(newfdnum);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 81 ff ff ff       	call   8013f1 <close>

	newfd = INDEX2FD(newfdnum);
  801470:	8b 75 0c             	mov    0xc(%ebp),%esi
  801473:	c1 e6 0c             	shl    $0xc,%esi
  801476:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80147c:	83 c4 04             	add    $0x4,%esp
  80147f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801482:	e8 cf fd ff ff       	call   801256 <fd2data>
  801487:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801489:	89 34 24             	mov    %esi,(%esp)
  80148c:	e8 c5 fd ff ff       	call   801256 <fd2data>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801496:	89 d8                	mov    %ebx,%eax
  801498:	c1 e8 16             	shr    $0x16,%eax
  80149b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a2:	a8 01                	test   $0x1,%al
  8014a4:	74 11                	je     8014b7 <dup+0x74>
  8014a6:	89 d8                	mov    %ebx,%eax
  8014a8:	c1 e8 0c             	shr    $0xc,%eax
  8014ab:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014b2:	f6 c2 01             	test   $0x1,%dl
  8014b5:	75 39                	jne    8014f0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014ba:	89 d0                	mov    %edx,%eax
  8014bc:	c1 e8 0c             	shr    $0xc,%eax
  8014bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c6:	83 ec 0c             	sub    $0xc,%esp
  8014c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ce:	50                   	push   %eax
  8014cf:	56                   	push   %esi
  8014d0:	6a 00                	push   $0x0
  8014d2:	52                   	push   %edx
  8014d3:	6a 00                	push   $0x0
  8014d5:	e8 6d f9 ff ff       	call   800e47 <sys_page_map>
  8014da:	89 c3                	mov    %eax,%ebx
  8014dc:	83 c4 20             	add    $0x20,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 31                	js     801514 <dup+0xd1>
		goto err;

	return newfdnum;
  8014e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014e6:	89 d8                	mov    %ebx,%eax
  8014e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014eb:	5b                   	pop    %ebx
  8014ec:	5e                   	pop    %esi
  8014ed:	5f                   	pop    %edi
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014f7:	83 ec 0c             	sub    $0xc,%esp
  8014fa:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ff:	50                   	push   %eax
  801500:	57                   	push   %edi
  801501:	6a 00                	push   $0x0
  801503:	53                   	push   %ebx
  801504:	6a 00                	push   $0x0
  801506:	e8 3c f9 ff ff       	call   800e47 <sys_page_map>
  80150b:	89 c3                	mov    %eax,%ebx
  80150d:	83 c4 20             	add    $0x20,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	79 a3                	jns    8014b7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	56                   	push   %esi
  801518:	6a 00                	push   $0x0
  80151a:	e8 6a f9 ff ff       	call   800e89 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80151f:	83 c4 08             	add    $0x8,%esp
  801522:	57                   	push   %edi
  801523:	6a 00                	push   $0x0
  801525:	e8 5f f9 ff ff       	call   800e89 <sys_page_unmap>
	return r;
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	eb b7                	jmp    8014e6 <dup+0xa3>

0080152f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	53                   	push   %ebx
  801533:	83 ec 1c             	sub    $0x1c,%esp
  801536:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801539:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153c:	50                   	push   %eax
  80153d:	53                   	push   %ebx
  80153e:	e8 7c fd ff ff       	call   8012bf <fd_lookup>
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 3f                	js     801589 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801550:	50                   	push   %eax
  801551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801554:	ff 30                	pushl  (%eax)
  801556:	e8 b4 fd ff ff       	call   80130f <dev_lookup>
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 27                	js     801589 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801562:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801565:	8b 42 08             	mov    0x8(%edx),%eax
  801568:	83 e0 03             	and    $0x3,%eax
  80156b:	83 f8 01             	cmp    $0x1,%eax
  80156e:	74 1e                	je     80158e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	8b 40 08             	mov    0x8(%eax),%eax
  801576:	85 c0                	test   %eax,%eax
  801578:	74 35                	je     8015af <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	ff 75 10             	pushl  0x10(%ebp)
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	52                   	push   %edx
  801584:	ff d0                	call   *%eax
  801586:	83 c4 10             	add    $0x10,%esp
}
  801589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80158e:	a1 08 40 80 00       	mov    0x804008,%eax
  801593:	8b 40 48             	mov    0x48(%eax),%eax
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	53                   	push   %ebx
  80159a:	50                   	push   %eax
  80159b:	68 35 2d 80 00       	push   $0x802d35
  8015a0:	e8 0e ed ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ad:	eb da                	jmp    801589 <read+0x5a>
		return -E_NOT_SUPP;
  8015af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b4:	eb d3                	jmp    801589 <read+0x5a>

008015b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	57                   	push   %edi
  8015ba:	56                   	push   %esi
  8015bb:	53                   	push   %ebx
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ca:	39 f3                	cmp    %esi,%ebx
  8015cc:	73 23                	jae    8015f1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	89 f0                	mov    %esi,%eax
  8015d3:	29 d8                	sub    %ebx,%eax
  8015d5:	50                   	push   %eax
  8015d6:	89 d8                	mov    %ebx,%eax
  8015d8:	03 45 0c             	add    0xc(%ebp),%eax
  8015db:	50                   	push   %eax
  8015dc:	57                   	push   %edi
  8015dd:	e8 4d ff ff ff       	call   80152f <read>
		if (m < 0)
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 06                	js     8015ef <readn+0x39>
			return m;
		if (m == 0)
  8015e9:	74 06                	je     8015f1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015eb:	01 c3                	add    %eax,%ebx
  8015ed:	eb db                	jmp    8015ca <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ef:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015f1:	89 d8                	mov    %ebx,%eax
  8015f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5f                   	pop    %edi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 1c             	sub    $0x1c,%esp
  801602:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801605:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801608:	50                   	push   %eax
  801609:	53                   	push   %ebx
  80160a:	e8 b0 fc ff ff       	call   8012bf <fd_lookup>
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	78 3a                	js     801650 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	50                   	push   %eax
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	ff 30                	pushl  (%eax)
  801622:	e8 e8 fc ff ff       	call   80130f <dev_lookup>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 22                	js     801650 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801635:	74 1e                	je     801655 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163a:	8b 52 0c             	mov    0xc(%edx),%edx
  80163d:	85 d2                	test   %edx,%edx
  80163f:	74 35                	je     801676 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	ff 75 10             	pushl  0x10(%ebp)
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	50                   	push   %eax
  80164b:	ff d2                	call   *%edx
  80164d:	83 c4 10             	add    $0x10,%esp
}
  801650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801653:	c9                   	leave  
  801654:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801655:	a1 08 40 80 00       	mov    0x804008,%eax
  80165a:	8b 40 48             	mov    0x48(%eax),%eax
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	53                   	push   %ebx
  801661:	50                   	push   %eax
  801662:	68 51 2d 80 00       	push   $0x802d51
  801667:	e8 47 ec ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801674:	eb da                	jmp    801650 <write+0x55>
		return -E_NOT_SUPP;
  801676:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167b:	eb d3                	jmp    801650 <write+0x55>

0080167d <seek>:

int
seek(int fdnum, off_t offset)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801683:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801686:	50                   	push   %eax
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	e8 30 fc ff ff       	call   8012bf <fd_lookup>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	85 c0                	test   %eax,%eax
  801694:	78 0e                	js     8016a4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 1c             	sub    $0x1c,%esp
  8016ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b3:	50                   	push   %eax
  8016b4:	53                   	push   %ebx
  8016b5:	e8 05 fc ff ff       	call   8012bf <fd_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 37                	js     8016f8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	ff 30                	pushl  (%eax)
  8016cd:	e8 3d fc ff ff       	call   80130f <dev_lookup>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 1f                	js     8016f8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e0:	74 1b                	je     8016fd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e5:	8b 52 18             	mov    0x18(%edx),%edx
  8016e8:	85 d2                	test   %edx,%edx
  8016ea:	74 32                	je     80171e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	50                   	push   %eax
  8016f3:	ff d2                	call   *%edx
  8016f5:	83 c4 10             	add    $0x10,%esp
}
  8016f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016fd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801702:	8b 40 48             	mov    0x48(%eax),%eax
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	53                   	push   %ebx
  801709:	50                   	push   %eax
  80170a:	68 14 2d 80 00       	push   $0x802d14
  80170f:	e8 9f eb ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171c:	eb da                	jmp    8016f8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80171e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801723:	eb d3                	jmp    8016f8 <ftruncate+0x52>

00801725 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 1c             	sub    $0x1c,%esp
  80172c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 84 fb ff ff       	call   8012bf <fd_lookup>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 4b                	js     80178d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801742:	83 ec 08             	sub    $0x8,%esp
  801745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801748:	50                   	push   %eax
  801749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174c:	ff 30                	pushl  (%eax)
  80174e:	e8 bc fb ff ff       	call   80130f <dev_lookup>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 33                	js     80178d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801761:	74 2f                	je     801792 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801763:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801766:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80176d:	00 00 00 
	stat->st_isdir = 0;
  801770:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801777:	00 00 00 
	stat->st_dev = dev;
  80177a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	53                   	push   %ebx
  801784:	ff 75 f0             	pushl  -0x10(%ebp)
  801787:	ff 50 14             	call   *0x14(%eax)
  80178a:	83 c4 10             	add    $0x10,%esp
}
  80178d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801790:	c9                   	leave  
  801791:	c3                   	ret    
		return -E_NOT_SUPP;
  801792:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801797:	eb f4                	jmp    80178d <fstat+0x68>

00801799 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	56                   	push   %esi
  80179d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	e8 22 02 00 00       	call   8019cd <open>
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 1b                	js     8017cf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	50                   	push   %eax
  8017bb:	e8 65 ff ff ff       	call   801725 <fstat>
  8017c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017c2:	89 1c 24             	mov    %ebx,(%esp)
  8017c5:	e8 27 fc ff ff       	call   8013f1 <close>
	return r;
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	89 f3                	mov    %esi,%ebx
}
  8017cf:	89 d8                	mov    %ebx,%eax
  8017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	89 c6                	mov    %eax,%esi
  8017df:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017e1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017e8:	74 27                	je     801811 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017ea:	6a 07                	push   $0x7
  8017ec:	68 00 50 80 00       	push   $0x805000
  8017f1:	56                   	push   %esi
  8017f2:	ff 35 00 40 80 00    	pushl  0x804000
  8017f8:	e8 7d 0d 00 00       	call   80257a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017fd:	83 c4 0c             	add    $0xc,%esp
  801800:	6a 00                	push   $0x0
  801802:	53                   	push   %ebx
  801803:	6a 00                	push   $0x0
  801805:	e8 07 0d 00 00       	call   802511 <ipc_recv>
}
  80180a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180d:	5b                   	pop    %ebx
  80180e:	5e                   	pop    %esi
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	6a 01                	push   $0x1
  801816:	e8 b7 0d 00 00       	call   8025d2 <ipc_find_env>
  80181b:	a3 00 40 80 00       	mov    %eax,0x804000
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	eb c5                	jmp    8017ea <fsipc+0x12>

00801825 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	8b 40 0c             	mov    0xc(%eax),%eax
  801831:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80183e:	ba 00 00 00 00       	mov    $0x0,%edx
  801843:	b8 02 00 00 00       	mov    $0x2,%eax
  801848:	e8 8b ff ff ff       	call   8017d8 <fsipc>
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <devfile_flush>:
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	8b 40 0c             	mov    0xc(%eax),%eax
  80185b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	b8 06 00 00 00       	mov    $0x6,%eax
  80186a:	e8 69 ff ff ff       	call   8017d8 <fsipc>
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <devfile_stat>:
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	53                   	push   %ebx
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8b 40 0c             	mov    0xc(%eax),%eax
  801881:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 05 00 00 00       	mov    $0x5,%eax
  801890:	e8 43 ff ff ff       	call   8017d8 <fsipc>
  801895:	85 c0                	test   %eax,%eax
  801897:	78 2c                	js     8018c5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	68 00 50 80 00       	push   $0x805000
  8018a1:	53                   	push   %ebx
  8018a2:	e8 6b f1 ff ff       	call   800a12 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a7:	a1 80 50 80 00       	mov    0x805080,%eax
  8018ac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018b2:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <devfile_write>:
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 08             	sub    $0x8,%esp
  8018d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018da:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018df:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018e5:	53                   	push   %ebx
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	68 08 50 80 00       	push   $0x805008
  8018ee:	e8 0f f3 ff ff       	call   800c02 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8018fd:	e8 d6 fe ff ff       	call   8017d8 <fsipc>
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	85 c0                	test   %eax,%eax
  801907:	78 0b                	js     801914 <devfile_write+0x4a>
	assert(r <= n);
  801909:	39 d8                	cmp    %ebx,%eax
  80190b:	77 0c                	ja     801919 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80190d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801912:	7f 1e                	jg     801932 <devfile_write+0x68>
}
  801914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801917:	c9                   	leave  
  801918:	c3                   	ret    
	assert(r <= n);
  801919:	68 84 2d 80 00       	push   $0x802d84
  80191e:	68 8b 2d 80 00       	push   $0x802d8b
  801923:	68 98 00 00 00       	push   $0x98
  801928:	68 a0 2d 80 00       	push   $0x802da0
  80192d:	e8 7e 0b 00 00       	call   8024b0 <_panic>
	assert(r <= PGSIZE);
  801932:	68 ab 2d 80 00       	push   $0x802dab
  801937:	68 8b 2d 80 00       	push   $0x802d8b
  80193c:	68 99 00 00 00       	push   $0x99
  801941:	68 a0 2d 80 00       	push   $0x802da0
  801946:	e8 65 0b 00 00       	call   8024b0 <_panic>

0080194b <devfile_read>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 40 0c             	mov    0xc(%eax),%eax
  801959:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80195e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801964:	ba 00 00 00 00       	mov    $0x0,%edx
  801969:	b8 03 00 00 00       	mov    $0x3,%eax
  80196e:	e8 65 fe ff ff       	call   8017d8 <fsipc>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	85 c0                	test   %eax,%eax
  801977:	78 1f                	js     801998 <devfile_read+0x4d>
	assert(r <= n);
  801979:	39 f0                	cmp    %esi,%eax
  80197b:	77 24                	ja     8019a1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80197d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801982:	7f 33                	jg     8019b7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	50                   	push   %eax
  801988:	68 00 50 80 00       	push   $0x805000
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	e8 0b f2 ff ff       	call   800ba0 <memmove>
	return r;
  801995:	83 c4 10             	add    $0x10,%esp
}
  801998:	89 d8                	mov    %ebx,%eax
  80199a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    
	assert(r <= n);
  8019a1:	68 84 2d 80 00       	push   $0x802d84
  8019a6:	68 8b 2d 80 00       	push   $0x802d8b
  8019ab:	6a 7c                	push   $0x7c
  8019ad:	68 a0 2d 80 00       	push   $0x802da0
  8019b2:	e8 f9 0a 00 00       	call   8024b0 <_panic>
	assert(r <= PGSIZE);
  8019b7:	68 ab 2d 80 00       	push   $0x802dab
  8019bc:	68 8b 2d 80 00       	push   $0x802d8b
  8019c1:	6a 7d                	push   $0x7d
  8019c3:	68 a0 2d 80 00       	push   $0x802da0
  8019c8:	e8 e3 0a 00 00       	call   8024b0 <_panic>

008019cd <open>:
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	56                   	push   %esi
  8019d1:	53                   	push   %ebx
  8019d2:	83 ec 1c             	sub    $0x1c,%esp
  8019d5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019d8:	56                   	push   %esi
  8019d9:	e8 fb ef ff ff       	call   8009d9 <strlen>
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019e6:	7f 6c                	jg     801a54 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ee:	50                   	push   %eax
  8019ef:	e8 79 f8 ff ff       	call   80126d <fd_alloc>
  8019f4:	89 c3                	mov    %eax,%ebx
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 3c                	js     801a39 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019fd:	83 ec 08             	sub    $0x8,%esp
  801a00:	56                   	push   %esi
  801a01:	68 00 50 80 00       	push   $0x805000
  801a06:	e8 07 f0 ff ff       	call   800a12 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a16:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1b:	e8 b8 fd ff ff       	call   8017d8 <fsipc>
  801a20:	89 c3                	mov    %eax,%ebx
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 19                	js     801a42 <open+0x75>
	return fd2num(fd);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2f:	e8 12 f8 ff ff       	call   801246 <fd2num>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	83 c4 10             	add    $0x10,%esp
}
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    
		fd_close(fd, 0);
  801a42:	83 ec 08             	sub    $0x8,%esp
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4a:	e8 1b f9 ff ff       	call   80136a <fd_close>
		return r;
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	eb e5                	jmp    801a39 <open+0x6c>
		return -E_BAD_PATH;
  801a54:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a59:	eb de                	jmp    801a39 <open+0x6c>

00801a5b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	b8 08 00 00 00       	mov    $0x8,%eax
  801a6b:	e8 68 fd ff ff       	call   8017d8 <fsipc>
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a72:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a76:	7f 01                	jg     801a79 <writebuf+0x7>
  801a78:	c3                   	ret    
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	53                   	push   %ebx
  801a7d:	83 ec 08             	sub    $0x8,%esp
  801a80:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a82:	ff 70 04             	pushl  0x4(%eax)
  801a85:	8d 40 10             	lea    0x10(%eax),%eax
  801a88:	50                   	push   %eax
  801a89:	ff 33                	pushl  (%ebx)
  801a8b:	e8 6b fb ff ff       	call   8015fb <write>
		if (result > 0)
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	7e 03                	jle    801a9a <writebuf+0x28>
			b->result += result;
  801a97:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a9a:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a9d:	74 0d                	je     801aac <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	0f 4f c2             	cmovg  %edx,%eax
  801aa9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <putch>:

static void
putch(int ch, void *thunk)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801abb:	8b 53 04             	mov    0x4(%ebx),%edx
  801abe:	8d 42 01             	lea    0x1(%edx),%eax
  801ac1:	89 43 04             	mov    %eax,0x4(%ebx)
  801ac4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801acb:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ad0:	74 06                	je     801ad8 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801ad2:	83 c4 04             	add    $0x4,%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
		writebuf(b);
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	e8 93 ff ff ff       	call   801a72 <writebuf>
		b->idx = 0;
  801adf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801ae6:	eb ea                	jmp    801ad2 <putch+0x21>

00801ae8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801afa:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b01:	00 00 00 
	b.result = 0;
  801b04:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b0b:	00 00 00 
	b.error = 1;
  801b0e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b15:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b18:	ff 75 10             	pushl  0x10(%ebp)
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b24:	50                   	push   %eax
  801b25:	68 b1 1a 80 00       	push   $0x801ab1
  801b2a:	e8 b1 e8 ff ff       	call   8003e0 <vprintfmt>
	if (b.idx > 0)
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b39:	7f 11                	jg     801b4c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b3b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b41:	85 c0                	test   %eax,%eax
  801b43:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    
		writebuf(&b);
  801b4c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b52:	e8 1b ff ff ff       	call   801a72 <writebuf>
  801b57:	eb e2                	jmp    801b3b <vfprintf+0x53>

00801b59 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b5f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b62:	50                   	push   %eax
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	e8 7a ff ff ff       	call   801ae8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <printf>:

int
printf(const char *fmt, ...)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b76:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b79:	50                   	push   %eax
  801b7a:	ff 75 08             	pushl  0x8(%ebp)
  801b7d:	6a 01                	push   $0x1
  801b7f:	e8 64 ff ff ff       	call   801ae8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b8c:	68 b7 2d 80 00       	push   $0x802db7
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	e8 79 ee ff ff       	call   800a12 <strcpy>
	return 0;
}
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <devsock_close>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 10             	sub    $0x10,%esp
  801ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801baa:	53                   	push   %ebx
  801bab:	e8 5d 0a 00 00       	call   80260d <pageref>
  801bb0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bb3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801bb8:	83 f8 01             	cmp    $0x1,%eax
  801bbb:	74 07                	je     801bc4 <devsock_close+0x24>
}
  801bbd:	89 d0                	mov    %edx,%eax
  801bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 73 0c             	pushl  0xc(%ebx)
  801bca:	e8 b9 02 00 00       	call   801e88 <nsipc_close>
  801bcf:	89 c2                	mov    %eax,%edx
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	eb e7                	jmp    801bbd <devsock_close+0x1d>

00801bd6 <devsock_write>:
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 10             	pushl  0x10(%ebp)
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	ff 70 0c             	pushl  0xc(%eax)
  801bea:	e8 76 03 00 00       	call   801f65 <nsipc_send>
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <devsock_read>:
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	ff 70 0c             	pushl  0xc(%eax)
  801c05:	e8 ef 02 00 00       	call   801ef9 <nsipc_recv>
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <fd2sockid>:
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c12:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	e8 a3 f6 ff ff       	call   8012bf <fd_lookup>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 10                	js     801c33 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c26:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c2c:	39 08                	cmp    %ecx,(%eax)
  801c2e:	75 05                	jne    801c35 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    
		return -E_NOT_SUPP;
  801c35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3a:	eb f7                	jmp    801c33 <fd2sockid+0x27>

00801c3c <alloc_sockfd>:
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
  801c41:	83 ec 1c             	sub    $0x1c,%esp
  801c44:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c49:	50                   	push   %eax
  801c4a:	e8 1e f6 ff ff       	call   80126d <fd_alloc>
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	85 c0                	test   %eax,%eax
  801c56:	78 43                	js     801c9b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	68 07 04 00 00       	push   $0x407
  801c60:	ff 75 f4             	pushl  -0xc(%ebp)
  801c63:	6a 00                	push   $0x0
  801c65:	e8 9a f1 ff ff       	call   800e04 <sys_page_alloc>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 28                	js     801c9b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c81:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c88:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	50                   	push   %eax
  801c8f:	e8 b2 f5 ff ff       	call   801246 <fd2num>
  801c94:	89 c3                	mov    %eax,%ebx
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	eb 0c                	jmp    801ca7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c9b:	83 ec 0c             	sub    $0xc,%esp
  801c9e:	56                   	push   %esi
  801c9f:	e8 e4 01 00 00       	call   801e88 <nsipc_close>
		return r;
  801ca4:	83 c4 10             	add    $0x10,%esp
}
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <accept>:
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	e8 4e ff ff ff       	call   801c0c <fd2sockid>
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 1b                	js     801cdd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	ff 75 10             	pushl  0x10(%ebp)
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	50                   	push   %eax
  801ccc:	e8 0e 01 00 00       	call   801ddf <nsipc_accept>
  801cd1:	83 c4 10             	add    $0x10,%esp
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	78 05                	js     801cdd <accept+0x2d>
	return alloc_sockfd(r);
  801cd8:	e8 5f ff ff ff       	call   801c3c <alloc_sockfd>
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <bind>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	e8 1f ff ff ff       	call   801c0c <fd2sockid>
  801ced:	85 c0                	test   %eax,%eax
  801cef:	78 12                	js     801d03 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	ff 75 10             	pushl  0x10(%ebp)
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	50                   	push   %eax
  801cfb:	e8 31 01 00 00       	call   801e31 <nsipc_bind>
  801d00:	83 c4 10             	add    $0x10,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <shutdown>:
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	e8 f9 fe ff ff       	call   801c0c <fd2sockid>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 0f                	js     801d26 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	50                   	push   %eax
  801d1e:	e8 43 01 00 00       	call   801e66 <nsipc_shutdown>
  801d23:	83 c4 10             	add    $0x10,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <connect>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	e8 d6 fe ff ff       	call   801c0c <fd2sockid>
  801d36:	85 c0                	test   %eax,%eax
  801d38:	78 12                	js     801d4c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	ff 75 10             	pushl  0x10(%ebp)
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	50                   	push   %eax
  801d44:	e8 59 01 00 00       	call   801ea2 <nsipc_connect>
  801d49:	83 c4 10             	add    $0x10,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <listen>:
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	e8 b0 fe ff ff       	call   801c0c <fd2sockid>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 0f                	js     801d6f <listen+0x21>
	return nsipc_listen(r, backlog);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	50                   	push   %eax
  801d67:	e8 6b 01 00 00       	call   801ed7 <nsipc_listen>
  801d6c:	83 c4 10             	add    $0x10,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d77:	ff 75 10             	pushl  0x10(%ebp)
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	ff 75 08             	pushl  0x8(%ebp)
  801d80:	e8 3e 02 00 00       	call   801fc3 <nsipc_socket>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 05                	js     801d91 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d8c:	e8 ab fe ff ff       	call   801c3c <alloc_sockfd>
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	53                   	push   %ebx
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d9c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801da3:	74 26                	je     801dcb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801da5:	6a 07                	push   $0x7
  801da7:	68 00 60 80 00       	push   $0x806000
  801dac:	53                   	push   %ebx
  801dad:	ff 35 04 40 80 00    	pushl  0x804004
  801db3:	e8 c2 07 00 00       	call   80257a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801db8:	83 c4 0c             	add    $0xc,%esp
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 4b 07 00 00       	call   802511 <ipc_recv>
}
  801dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	6a 02                	push   $0x2
  801dd0:	e8 fd 07 00 00       	call   8025d2 <ipc_find_env>
  801dd5:	a3 04 40 80 00       	mov    %eax,0x804004
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	eb c6                	jmp    801da5 <nsipc+0x12>

00801ddf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801def:	8b 06                	mov    (%esi),%eax
  801df1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	e8 93 ff ff ff       	call   801d93 <nsipc>
  801e00:	89 c3                	mov    %eax,%ebx
  801e02:	85 c0                	test   %eax,%eax
  801e04:	79 09                	jns    801e0f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e06:	89 d8                	mov    %ebx,%eax
  801e08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	ff 35 10 60 80 00    	pushl  0x806010
  801e18:	68 00 60 80 00       	push   $0x806000
  801e1d:	ff 75 0c             	pushl  0xc(%ebp)
  801e20:	e8 7b ed ff ff       	call   800ba0 <memmove>
		*addrlen = ret->ret_addrlen;
  801e25:	a1 10 60 80 00       	mov    0x806010,%eax
  801e2a:	89 06                	mov    %eax,(%esi)
  801e2c:	83 c4 10             	add    $0x10,%esp
	return r;
  801e2f:	eb d5                	jmp    801e06 <nsipc_accept+0x27>

00801e31 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	53                   	push   %ebx
  801e35:	83 ec 08             	sub    $0x8,%esp
  801e38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e43:	53                   	push   %ebx
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	68 04 60 80 00       	push   $0x806004
  801e4c:	e8 4f ed ff ff       	call   800ba0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e51:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e57:	b8 02 00 00 00       	mov    $0x2,%eax
  801e5c:	e8 32 ff ff ff       	call   801d93 <nsipc>
}
  801e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e7c:	b8 03 00 00 00       	mov    $0x3,%eax
  801e81:	e8 0d ff ff ff       	call   801d93 <nsipc>
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <nsipc_close>:

int
nsipc_close(int s)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e96:	b8 04 00 00 00       	mov    $0x4,%eax
  801e9b:	e8 f3 fe ff ff       	call   801d93 <nsipc>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	53                   	push   %ebx
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801eb4:	53                   	push   %ebx
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	68 04 60 80 00       	push   $0x806004
  801ebd:	e8 de ec ff ff       	call   800ba0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ec2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ec8:	b8 05 00 00 00       	mov    $0x5,%eax
  801ecd:	e8 c1 fe ff ff       	call   801d93 <nsipc>
}
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801eed:	b8 06 00 00 00       	mov    $0x6,%eax
  801ef2:	e8 9c fe ff ff       	call   801d93 <nsipc>
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f09:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f12:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f17:	b8 07 00 00 00       	mov    $0x7,%eax
  801f1c:	e8 72 fe ff ff       	call   801d93 <nsipc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	85 c0                	test   %eax,%eax
  801f25:	78 1f                	js     801f46 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f27:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f2c:	7f 21                	jg     801f4f <nsipc_recv+0x56>
  801f2e:	39 c6                	cmp    %eax,%esi
  801f30:	7c 1d                	jl     801f4f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	50                   	push   %eax
  801f36:	68 00 60 80 00       	push   $0x806000
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	e8 5d ec ff ff       	call   800ba0 <memmove>
  801f43:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f46:	89 d8                	mov    %ebx,%eax
  801f48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5d                   	pop    %ebp
  801f4e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f4f:	68 c3 2d 80 00       	push   $0x802dc3
  801f54:	68 8b 2d 80 00       	push   $0x802d8b
  801f59:	6a 62                	push   $0x62
  801f5b:	68 d8 2d 80 00       	push   $0x802dd8
  801f60:	e8 4b 05 00 00       	call   8024b0 <_panic>

00801f65 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	53                   	push   %ebx
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f77:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f7d:	7f 2e                	jg     801fad <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	53                   	push   %ebx
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	68 0c 60 80 00       	push   $0x80600c
  801f8b:	e8 10 ec ff ff       	call   800ba0 <memmove>
	nsipcbuf.send.req_size = size;
  801f90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f96:	8b 45 14             	mov    0x14(%ebp),%eax
  801f99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa3:	e8 eb fd ff ff       	call   801d93 <nsipc>
}
  801fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    
	assert(size < 1600);
  801fad:	68 e4 2d 80 00       	push   $0x802de4
  801fb2:	68 8b 2d 80 00       	push   $0x802d8b
  801fb7:	6a 6d                	push   $0x6d
  801fb9:	68 d8 2d 80 00       	push   $0x802dd8
  801fbe:	e8 ed 04 00 00       	call   8024b0 <_panic>

00801fc3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fe1:	b8 09 00 00 00       	mov    $0x9,%eax
  801fe6:	e8 a8 fd ff ff       	call   801d93 <nsipc>
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
  801ff2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	e8 56 f2 ff ff       	call   801256 <fd2data>
  802000:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802002:	83 c4 08             	add    $0x8,%esp
  802005:	68 f0 2d 80 00       	push   $0x802df0
  80200a:	53                   	push   %ebx
  80200b:	e8 02 ea ff ff       	call   800a12 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802010:	8b 46 04             	mov    0x4(%esi),%eax
  802013:	2b 06                	sub    (%esi),%eax
  802015:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80201b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802022:	00 00 00 
	stat->st_dev = &devpipe;
  802025:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80202c:	30 80 00 
	return 0;
}
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802037:	5b                   	pop    %ebx
  802038:	5e                   	pop    %esi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    

0080203b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802045:	53                   	push   %ebx
  802046:	6a 00                	push   $0x0
  802048:	e8 3c ee ff ff       	call   800e89 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80204d:	89 1c 24             	mov    %ebx,(%esp)
  802050:	e8 01 f2 ff ff       	call   801256 <fd2data>
  802055:	83 c4 08             	add    $0x8,%esp
  802058:	50                   	push   %eax
  802059:	6a 00                	push   $0x0
  80205b:	e8 29 ee ff ff       	call   800e89 <sys_page_unmap>
}
  802060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <_pipeisclosed>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	57                   	push   %edi
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	83 ec 1c             	sub    $0x1c,%esp
  80206e:	89 c7                	mov    %eax,%edi
  802070:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802072:	a1 08 40 80 00       	mov    0x804008,%eax
  802077:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	57                   	push   %edi
  80207e:	e8 8a 05 00 00       	call   80260d <pageref>
  802083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802086:	89 34 24             	mov    %esi,(%esp)
  802089:	e8 7f 05 00 00       	call   80260d <pageref>
		nn = thisenv->env_runs;
  80208e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802094:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	39 cb                	cmp    %ecx,%ebx
  80209c:	74 1b                	je     8020b9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80209e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020a1:	75 cf                	jne    802072 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a3:	8b 42 58             	mov    0x58(%edx),%eax
  8020a6:	6a 01                	push   $0x1
  8020a8:	50                   	push   %eax
  8020a9:	53                   	push   %ebx
  8020aa:	68 f7 2d 80 00       	push   $0x802df7
  8020af:	e8 ff e1 ff ff       	call   8002b3 <cprintf>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	eb b9                	jmp    802072 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020bc:	0f 94 c0             	sete   %al
  8020bf:	0f b6 c0             	movzbl %al,%eax
}
  8020c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c5:	5b                   	pop    %ebx
  8020c6:	5e                   	pop    %esi
  8020c7:	5f                   	pop    %edi
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <devpipe_write>:
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	57                   	push   %edi
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 28             	sub    $0x28,%esp
  8020d3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020d6:	56                   	push   %esi
  8020d7:	e8 7a f1 ff ff       	call   801256 <fd2data>
  8020dc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020e9:	74 4f                	je     80213a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8020ee:	8b 0b                	mov    (%ebx),%ecx
  8020f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8020f3:	39 d0                	cmp    %edx,%eax
  8020f5:	72 14                	jb     80210b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020f7:	89 da                	mov    %ebx,%edx
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	e8 65 ff ff ff       	call   802065 <_pipeisclosed>
  802100:	85 c0                	test   %eax,%eax
  802102:	75 3b                	jne    80213f <devpipe_write+0x75>
			sys_yield();
  802104:	e8 dc ec ff ff       	call   800de5 <sys_yield>
  802109:	eb e0                	jmp    8020eb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80210b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80210e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802112:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802115:	89 c2                	mov    %eax,%edx
  802117:	c1 fa 1f             	sar    $0x1f,%edx
  80211a:	89 d1                	mov    %edx,%ecx
  80211c:	c1 e9 1b             	shr    $0x1b,%ecx
  80211f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802122:	83 e2 1f             	and    $0x1f,%edx
  802125:	29 ca                	sub    %ecx,%edx
  802127:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80212b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80212f:	83 c0 01             	add    $0x1,%eax
  802132:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802135:	83 c7 01             	add    $0x1,%edi
  802138:	eb ac                	jmp    8020e6 <devpipe_write+0x1c>
	return i;
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	eb 05                	jmp    802144 <devpipe_write+0x7a>
				return 0;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    

0080214c <devpipe_read>:
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	57                   	push   %edi
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	83 ec 18             	sub    $0x18,%esp
  802155:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802158:	57                   	push   %edi
  802159:	e8 f8 f0 ff ff       	call   801256 <fd2data>
  80215e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	be 00 00 00 00       	mov    $0x0,%esi
  802168:	3b 75 10             	cmp    0x10(%ebp),%esi
  80216b:	75 14                	jne    802181 <devpipe_read+0x35>
	return i;
  80216d:	8b 45 10             	mov    0x10(%ebp),%eax
  802170:	eb 02                	jmp    802174 <devpipe_read+0x28>
				return i;
  802172:	89 f0                	mov    %esi,%eax
}
  802174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802177:	5b                   	pop    %ebx
  802178:	5e                   	pop    %esi
  802179:	5f                   	pop    %edi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    
			sys_yield();
  80217c:	e8 64 ec ff ff       	call   800de5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802181:	8b 03                	mov    (%ebx),%eax
  802183:	3b 43 04             	cmp    0x4(%ebx),%eax
  802186:	75 18                	jne    8021a0 <devpipe_read+0x54>
			if (i > 0)
  802188:	85 f6                	test   %esi,%esi
  80218a:	75 e6                	jne    802172 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80218c:	89 da                	mov    %ebx,%edx
  80218e:	89 f8                	mov    %edi,%eax
  802190:	e8 d0 fe ff ff       	call   802065 <_pipeisclosed>
  802195:	85 c0                	test   %eax,%eax
  802197:	74 e3                	je     80217c <devpipe_read+0x30>
				return 0;
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	eb d4                	jmp    802174 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021a0:	99                   	cltd   
  8021a1:	c1 ea 1b             	shr    $0x1b,%edx
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	83 e0 1f             	and    $0x1f,%eax
  8021a9:	29 d0                	sub    %edx,%eax
  8021ab:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021b6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021b9:	83 c6 01             	add    $0x1,%esi
  8021bc:	eb aa                	jmp    802168 <devpipe_read+0x1c>

008021be <pipe>:
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	56                   	push   %esi
  8021c2:	53                   	push   %ebx
  8021c3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	e8 9e f0 ff ff       	call   80126d <fd_alloc>
  8021cf:	89 c3                	mov    %eax,%ebx
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	0f 88 23 01 00 00    	js     8022ff <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 07 04 00 00       	push   $0x407
  8021e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e7:	6a 00                	push   $0x0
  8021e9:	e8 16 ec ff ff       	call   800e04 <sys_page_alloc>
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	0f 88 04 01 00 00    	js     8022ff <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802201:	50                   	push   %eax
  802202:	e8 66 f0 ff ff       	call   80126d <fd_alloc>
  802207:	89 c3                	mov    %eax,%ebx
  802209:	83 c4 10             	add    $0x10,%esp
  80220c:	85 c0                	test   %eax,%eax
  80220e:	0f 88 db 00 00 00    	js     8022ef <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 07 04 00 00       	push   $0x407
  80221c:	ff 75 f0             	pushl  -0x10(%ebp)
  80221f:	6a 00                	push   $0x0
  802221:	e8 de eb ff ff       	call   800e04 <sys_page_alloc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	83 c4 10             	add    $0x10,%esp
  80222b:	85 c0                	test   %eax,%eax
  80222d:	0f 88 bc 00 00 00    	js     8022ef <pipe+0x131>
	va = fd2data(fd0);
  802233:	83 ec 0c             	sub    $0xc,%esp
  802236:	ff 75 f4             	pushl  -0xc(%ebp)
  802239:	e8 18 f0 ff ff       	call   801256 <fd2data>
  80223e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802240:	83 c4 0c             	add    $0xc,%esp
  802243:	68 07 04 00 00       	push   $0x407
  802248:	50                   	push   %eax
  802249:	6a 00                	push   $0x0
  80224b:	e8 b4 eb ff ff       	call   800e04 <sys_page_alloc>
  802250:	89 c3                	mov    %eax,%ebx
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	85 c0                	test   %eax,%eax
  802257:	0f 88 82 00 00 00    	js     8022df <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225d:	83 ec 0c             	sub    $0xc,%esp
  802260:	ff 75 f0             	pushl  -0x10(%ebp)
  802263:	e8 ee ef ff ff       	call   801256 <fd2data>
  802268:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80226f:	50                   	push   %eax
  802270:	6a 00                	push   $0x0
  802272:	56                   	push   %esi
  802273:	6a 00                	push   $0x0
  802275:	e8 cd eb ff ff       	call   800e47 <sys_page_map>
  80227a:	89 c3                	mov    %eax,%ebx
  80227c:	83 c4 20             	add    $0x20,%esp
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 4e                	js     8022d1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802283:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80228d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802290:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80229c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022a6:	83 ec 0c             	sub    $0xc,%esp
  8022a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ac:	e8 95 ef ff ff       	call   801246 <fd2num>
  8022b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022b6:	83 c4 04             	add    $0x4,%esp
  8022b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8022bc:	e8 85 ef ff ff       	call   801246 <fd2num>
  8022c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022cf:	eb 2e                	jmp    8022ff <pipe+0x141>
	sys_page_unmap(0, va);
  8022d1:	83 ec 08             	sub    $0x8,%esp
  8022d4:	56                   	push   %esi
  8022d5:	6a 00                	push   $0x0
  8022d7:	e8 ad eb ff ff       	call   800e89 <sys_page_unmap>
  8022dc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022df:	83 ec 08             	sub    $0x8,%esp
  8022e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e5:	6a 00                	push   $0x0
  8022e7:	e8 9d eb ff ff       	call   800e89 <sys_page_unmap>
  8022ec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022ef:	83 ec 08             	sub    $0x8,%esp
  8022f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f5:	6a 00                	push   $0x0
  8022f7:	e8 8d eb ff ff       	call   800e89 <sys_page_unmap>
  8022fc:	83 c4 10             	add    $0x10,%esp
}
  8022ff:	89 d8                	mov    %ebx,%eax
  802301:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802304:	5b                   	pop    %ebx
  802305:	5e                   	pop    %esi
  802306:	5d                   	pop    %ebp
  802307:	c3                   	ret    

00802308 <pipeisclosed>:
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80230e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802311:	50                   	push   %eax
  802312:	ff 75 08             	pushl  0x8(%ebp)
  802315:	e8 a5 ef ff ff       	call   8012bf <fd_lookup>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 18                	js     802339 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	ff 75 f4             	pushl  -0xc(%ebp)
  802327:	e8 2a ef ff ff       	call   801256 <fd2data>
	return _pipeisclosed(fd, p);
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	e8 2f fd ff ff       	call   802065 <_pipeisclosed>
  802336:	83 c4 10             	add    $0x10,%esp
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	c3                   	ret    

00802341 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802347:	68 0f 2e 80 00       	push   $0x802e0f
  80234c:	ff 75 0c             	pushl  0xc(%ebp)
  80234f:	e8 be e6 ff ff       	call   800a12 <strcpy>
	return 0;
}
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <devcons_write>:
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	57                   	push   %edi
  80235f:	56                   	push   %esi
  802360:	53                   	push   %ebx
  802361:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802367:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80236c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802372:	3b 75 10             	cmp    0x10(%ebp),%esi
  802375:	73 31                	jae    8023a8 <devcons_write+0x4d>
		m = n - tot;
  802377:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80237a:	29 f3                	sub    %esi,%ebx
  80237c:	83 fb 7f             	cmp    $0x7f,%ebx
  80237f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802384:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	53                   	push   %ebx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	03 45 0c             	add    0xc(%ebp),%eax
  802390:	50                   	push   %eax
  802391:	57                   	push   %edi
  802392:	e8 09 e8 ff ff       	call   800ba0 <memmove>
		sys_cputs(buf, m);
  802397:	83 c4 08             	add    $0x8,%esp
  80239a:	53                   	push   %ebx
  80239b:	57                   	push   %edi
  80239c:	e8 a7 e9 ff ff       	call   800d48 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023a1:	01 de                	add    %ebx,%esi
  8023a3:	83 c4 10             	add    $0x10,%esp
  8023a6:	eb ca                	jmp    802372 <devcons_write+0x17>
}
  8023a8:	89 f0                	mov    %esi,%eax
  8023aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    

008023b2 <devcons_read>:
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
  8023b5:	83 ec 08             	sub    $0x8,%esp
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023c1:	74 21                	je     8023e4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8023c3:	e8 9e e9 ff ff       	call   800d66 <sys_cgetc>
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 07                	jne    8023d3 <devcons_read+0x21>
		sys_yield();
  8023cc:	e8 14 ea ff ff       	call   800de5 <sys_yield>
  8023d1:	eb f0                	jmp    8023c3 <devcons_read+0x11>
	if (c < 0)
  8023d3:	78 0f                	js     8023e4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8023d5:	83 f8 04             	cmp    $0x4,%eax
  8023d8:	74 0c                	je     8023e6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8023da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023dd:	88 02                	mov    %al,(%edx)
	return 1;
  8023df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    
		return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	eb f7                	jmp    8023e4 <devcons_read+0x32>

008023ed <cputchar>:
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023f9:	6a 01                	push   $0x1
  8023fb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023fe:	50                   	push   %eax
  8023ff:	e8 44 e9 ff ff       	call   800d48 <sys_cputs>
}
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <getchar>:
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80240f:	6a 01                	push   $0x1
  802411:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802414:	50                   	push   %eax
  802415:	6a 00                	push   $0x0
  802417:	e8 13 f1 ff ff       	call   80152f <read>
	if (r < 0)
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 06                	js     802429 <getchar+0x20>
	if (r < 1)
  802423:	74 06                	je     80242b <getchar+0x22>
	return c;
  802425:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    
		return -E_EOF;
  80242b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802430:	eb f7                	jmp    802429 <getchar+0x20>

00802432 <iscons>:
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802438:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243b:	50                   	push   %eax
  80243c:	ff 75 08             	pushl  0x8(%ebp)
  80243f:	e8 7b ee ff ff       	call   8012bf <fd_lookup>
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	85 c0                	test   %eax,%eax
  802449:	78 11                	js     80245c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802454:	39 10                	cmp    %edx,(%eax)
  802456:	0f 94 c0             	sete   %al
  802459:	0f b6 c0             	movzbl %al,%eax
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <opencons>:
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802464:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802467:	50                   	push   %eax
  802468:	e8 00 ee ff ff       	call   80126d <fd_alloc>
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	85 c0                	test   %eax,%eax
  802472:	78 3a                	js     8024ae <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802474:	83 ec 04             	sub    $0x4,%esp
  802477:	68 07 04 00 00       	push   $0x407
  80247c:	ff 75 f4             	pushl  -0xc(%ebp)
  80247f:	6a 00                	push   $0x0
  802481:	e8 7e e9 ff ff       	call   800e04 <sys_page_alloc>
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	85 c0                	test   %eax,%eax
  80248b:	78 21                	js     8024ae <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802496:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024a2:	83 ec 0c             	sub    $0xc,%esp
  8024a5:	50                   	push   %eax
  8024a6:	e8 9b ed ff ff       	call   801246 <fd2num>
  8024ab:	83 c4 10             	add    $0x10,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	56                   	push   %esi
  8024b4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8024b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8024ba:	8b 40 48             	mov    0x48(%eax),%eax
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	68 40 2e 80 00       	push   $0x802e40
  8024c5:	50                   	push   %eax
  8024c6:	68 34 29 80 00       	push   $0x802934
  8024cb:	e8 e3 dd ff ff       	call   8002b3 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8024d0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024d3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024d9:	e8 e8 e8 ff ff       	call   800dc6 <sys_getenvid>
  8024de:	83 c4 04             	add    $0x4,%esp
  8024e1:	ff 75 0c             	pushl  0xc(%ebp)
  8024e4:	ff 75 08             	pushl  0x8(%ebp)
  8024e7:	56                   	push   %esi
  8024e8:	50                   	push   %eax
  8024e9:	68 1c 2e 80 00       	push   $0x802e1c
  8024ee:	e8 c0 dd ff ff       	call   8002b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024f3:	83 c4 18             	add    $0x18,%esp
  8024f6:	53                   	push   %ebx
  8024f7:	ff 75 10             	pushl  0x10(%ebp)
  8024fa:	e8 63 dd ff ff       	call   800262 <vcprintf>
	cprintf("\n");
  8024ff:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  802506:	e8 a8 dd ff ff       	call   8002b3 <cprintf>
  80250b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80250e:	cc                   	int3   
  80250f:	eb fd                	jmp    80250e <_panic+0x5e>

00802511 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	8b 75 08             	mov    0x8(%ebp),%esi
  802519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80251f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802521:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802526:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	50                   	push   %eax
  80252d:	e8 82 ea ff ff       	call   800fb4 <sys_ipc_recv>
	if(ret < 0){
  802532:	83 c4 10             	add    $0x10,%esp
  802535:	85 c0                	test   %eax,%eax
  802537:	78 2b                	js     802564 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802539:	85 f6                	test   %esi,%esi
  80253b:	74 0a                	je     802547 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80253d:	a1 08 40 80 00       	mov    0x804008,%eax
  802542:	8b 40 74             	mov    0x74(%eax),%eax
  802545:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802547:	85 db                	test   %ebx,%ebx
  802549:	74 0a                	je     802555 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80254b:	a1 08 40 80 00       	mov    0x804008,%eax
  802550:	8b 40 78             	mov    0x78(%eax),%eax
  802553:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802555:	a1 08 40 80 00       	mov    0x804008,%eax
  80255a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80255d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802560:	5b                   	pop    %ebx
  802561:	5e                   	pop    %esi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
		if(from_env_store)
  802564:	85 f6                	test   %esi,%esi
  802566:	74 06                	je     80256e <ipc_recv+0x5d>
			*from_env_store = 0;
  802568:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80256e:	85 db                	test   %ebx,%ebx
  802570:	74 eb                	je     80255d <ipc_recv+0x4c>
			*perm_store = 0;
  802572:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802578:	eb e3                	jmp    80255d <ipc_recv+0x4c>

0080257a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	57                   	push   %edi
  80257e:	56                   	push   %esi
  80257f:	53                   	push   %ebx
  802580:	83 ec 0c             	sub    $0xc,%esp
  802583:	8b 7d 08             	mov    0x8(%ebp),%edi
  802586:	8b 75 0c             	mov    0xc(%ebp),%esi
  802589:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80258c:	85 db                	test   %ebx,%ebx
  80258e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802593:	0f 44 d8             	cmove  %eax,%ebx
  802596:	eb 05                	jmp    80259d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802598:	e8 48 e8 ff ff       	call   800de5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80259d:	ff 75 14             	pushl  0x14(%ebp)
  8025a0:	53                   	push   %ebx
  8025a1:	56                   	push   %esi
  8025a2:	57                   	push   %edi
  8025a3:	e8 e9 e9 ff ff       	call   800f91 <sys_ipc_try_send>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	74 1b                	je     8025ca <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8025af:	79 e7                	jns    802598 <ipc_send+0x1e>
  8025b1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025b4:	74 e2                	je     802598 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8025b6:	83 ec 04             	sub    $0x4,%esp
  8025b9:	68 47 2e 80 00       	push   $0x802e47
  8025be:	6a 46                	push   $0x46
  8025c0:	68 5c 2e 80 00       	push   $0x802e5c
  8025c5:	e8 e6 fe ff ff       	call   8024b0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8025ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025cd:	5b                   	pop    %ebx
  8025ce:	5e                   	pop    %esi
  8025cf:	5f                   	pop    %edi
  8025d0:	5d                   	pop    %ebp
  8025d1:	c3                   	ret    

008025d2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025dd:	89 c2                	mov    %eax,%edx
  8025df:	c1 e2 07             	shl    $0x7,%edx
  8025e2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025e8:	8b 52 50             	mov    0x50(%edx),%edx
  8025eb:	39 ca                	cmp    %ecx,%edx
  8025ed:	74 11                	je     802600 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8025ef:	83 c0 01             	add    $0x1,%eax
  8025f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025f7:	75 e4                	jne    8025dd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	eb 0b                	jmp    80260b <ipc_find_env+0x39>
			return envs[i].env_id;
  802600:	c1 e0 07             	shl    $0x7,%eax
  802603:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802608:	8b 40 48             	mov    0x48(%eax),%eax
}
  80260b:	5d                   	pop    %ebp
  80260c:	c3                   	ret    

0080260d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802613:	89 d0                	mov    %edx,%eax
  802615:	c1 e8 16             	shr    $0x16,%eax
  802618:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802624:	f6 c1 01             	test   $0x1,%cl
  802627:	74 1d                	je     802646 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802629:	c1 ea 0c             	shr    $0xc,%edx
  80262c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802633:	f6 c2 01             	test   $0x1,%dl
  802636:	74 0e                	je     802646 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802638:	c1 ea 0c             	shr    $0xc,%edx
  80263b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802642:	ef 
  802643:	0f b7 c0             	movzwl %ax,%eax
}
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__udivdi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 1c             	sub    $0x1c,%esp
  802657:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80265f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802663:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802667:	85 d2                	test   %edx,%edx
  802669:	75 4d                	jne    8026b8 <__udivdi3+0x68>
  80266b:	39 f3                	cmp    %esi,%ebx
  80266d:	76 19                	jbe    802688 <__udivdi3+0x38>
  80266f:	31 ff                	xor    %edi,%edi
  802671:	89 e8                	mov    %ebp,%eax
  802673:	89 f2                	mov    %esi,%edx
  802675:	f7 f3                	div    %ebx
  802677:	89 fa                	mov    %edi,%edx
  802679:	83 c4 1c             	add    $0x1c,%esp
  80267c:	5b                   	pop    %ebx
  80267d:	5e                   	pop    %esi
  80267e:	5f                   	pop    %edi
  80267f:	5d                   	pop    %ebp
  802680:	c3                   	ret    
  802681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802688:	89 d9                	mov    %ebx,%ecx
  80268a:	85 db                	test   %ebx,%ebx
  80268c:	75 0b                	jne    802699 <__udivdi3+0x49>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f3                	div    %ebx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	31 d2                	xor    %edx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	f7 f1                	div    %ecx
  80269f:	89 c6                	mov    %eax,%esi
  8026a1:	89 e8                	mov    %ebp,%eax
  8026a3:	89 f7                	mov    %esi,%edi
  8026a5:	f7 f1                	div    %ecx
  8026a7:	89 fa                	mov    %edi,%edx
  8026a9:	83 c4 1c             	add    $0x1c,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
  8026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	39 f2                	cmp    %esi,%edx
  8026ba:	77 1c                	ja     8026d8 <__udivdi3+0x88>
  8026bc:	0f bd fa             	bsr    %edx,%edi
  8026bf:	83 f7 1f             	xor    $0x1f,%edi
  8026c2:	75 2c                	jne    8026f0 <__udivdi3+0xa0>
  8026c4:	39 f2                	cmp    %esi,%edx
  8026c6:	72 06                	jb     8026ce <__udivdi3+0x7e>
  8026c8:	31 c0                	xor    %eax,%eax
  8026ca:	39 eb                	cmp    %ebp,%ebx
  8026cc:	77 a9                	ja     802677 <__udivdi3+0x27>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb a2                	jmp    802677 <__udivdi3+0x27>
  8026d5:	8d 76 00             	lea    0x0(%esi),%esi
  8026d8:	31 ff                	xor    %edi,%edi
  8026da:	31 c0                	xor    %eax,%eax
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 27 ff ff ff       	jmp    802677 <__udivdi3+0x27>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 1d ff ff ff       	jmp    802677 <__udivdi3+0x27>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	55                   	push   %ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 1c             	sub    $0x1c,%esp
  802767:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80276b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80276f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802777:	89 da                	mov    %ebx,%edx
  802779:	85 c0                	test   %eax,%eax
  80277b:	75 43                	jne    8027c0 <__umoddi3+0x60>
  80277d:	39 df                	cmp    %ebx,%edi
  80277f:	76 17                	jbe    802798 <__umoddi3+0x38>
  802781:	89 f0                	mov    %esi,%eax
  802783:	f7 f7                	div    %edi
  802785:	89 d0                	mov    %edx,%eax
  802787:	31 d2                	xor    %edx,%edx
  802789:	83 c4 1c             	add    $0x1c,%esp
  80278c:	5b                   	pop    %ebx
  80278d:	5e                   	pop    %esi
  80278e:	5f                   	pop    %edi
  80278f:	5d                   	pop    %ebp
  802790:	c3                   	ret    
  802791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802798:	89 fd                	mov    %edi,%ebp
  80279a:	85 ff                	test   %edi,%edi
  80279c:	75 0b                	jne    8027a9 <__umoddi3+0x49>
  80279e:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f7                	div    %edi
  8027a7:	89 c5                	mov    %eax,%ebp
  8027a9:	89 d8                	mov    %ebx,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f5                	div    %ebp
  8027af:	89 f0                	mov    %esi,%eax
  8027b1:	f7 f5                	div    %ebp
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	eb d0                	jmp    802787 <__umoddi3+0x27>
  8027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	89 f1                	mov    %esi,%ecx
  8027c2:	39 d8                	cmp    %ebx,%eax
  8027c4:	76 0a                	jbe    8027d0 <__umoddi3+0x70>
  8027c6:	89 f0                	mov    %esi,%eax
  8027c8:	83 c4 1c             	add    $0x1c,%esp
  8027cb:	5b                   	pop    %ebx
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	0f bd e8             	bsr    %eax,%ebp
  8027d3:	83 f5 1f             	xor    $0x1f,%ebp
  8027d6:	75 20                	jne    8027f8 <__umoddi3+0x98>
  8027d8:	39 d8                	cmp    %ebx,%eax
  8027da:	0f 82 b0 00 00 00    	jb     802890 <__umoddi3+0x130>
  8027e0:	39 f7                	cmp    %esi,%edi
  8027e2:	0f 86 a8 00 00 00    	jbe    802890 <__umoddi3+0x130>
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	83 c4 1c             	add    $0x1c,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ff:	29 ea                	sub    %ebp,%edx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 44 24 08          	mov    %eax,0x8(%esp)
  802807:	89 d1                	mov    %edx,%ecx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	d3 e8                	shr    %cl,%eax
  80280d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802811:	89 54 24 04          	mov    %edx,0x4(%esp)
  802815:	8b 54 24 04          	mov    0x4(%esp),%edx
  802819:	09 c1                	or     %eax,%ecx
  80281b:	89 d8                	mov    %ebx,%eax
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e7                	shl    %cl,%edi
  802825:	89 d1                	mov    %edx,%ecx
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80282f:	d3 e3                	shl    %cl,%ebx
  802831:	89 c7                	mov    %eax,%edi
  802833:	89 d1                	mov    %edx,%ecx
  802835:	89 f0                	mov    %esi,%eax
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 fa                	mov    %edi,%edx
  80283d:	d3 e6                	shl    %cl,%esi
  80283f:	09 d8                	or     %ebx,%eax
  802841:	f7 74 24 08          	divl   0x8(%esp)
  802845:	89 d1                	mov    %edx,%ecx
  802847:	89 f3                	mov    %esi,%ebx
  802849:	f7 64 24 0c          	mull   0xc(%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d7                	mov    %edx,%edi
  802851:	39 d1                	cmp    %edx,%ecx
  802853:	72 06                	jb     80285b <__umoddi3+0xfb>
  802855:	75 10                	jne    802867 <__umoddi3+0x107>
  802857:	39 c3                	cmp    %eax,%ebx
  802859:	73 0c                	jae    802867 <__umoddi3+0x107>
  80285b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80285f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802863:	89 d7                	mov    %edx,%edi
  802865:	89 c6                	mov    %eax,%esi
  802867:	89 ca                	mov    %ecx,%edx
  802869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286e:	29 f3                	sub    %esi,%ebx
  802870:	19 fa                	sbb    %edi,%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	d3 e0                	shl    %cl,%eax
  802876:	89 e9                	mov    %ebp,%ecx
  802878:	d3 eb                	shr    %cl,%ebx
  80287a:	d3 ea                	shr    %cl,%edx
  80287c:	09 d8                	or     %ebx,%eax
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	89 da                	mov    %ebx,%edx
  802892:	29 fe                	sub    %edi,%esi
  802894:	19 c2                	sbb    %eax,%edx
  802896:	89 f1                	mov    %esi,%ecx
  802898:	89 c8                	mov    %ecx,%eax
  80289a:	e9 4b ff ff ff       	jmp    8027ea <__umoddi3+0x8a>
