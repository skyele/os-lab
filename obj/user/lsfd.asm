
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
  800039:	68 80 28 80 00       	push   $0x802880
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
  800067:	e8 6d 10 00 00       	call   8010d9 <argstart>
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
  800083:	e8 81 10 00 00       	call   801109 <argnext>
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
  8000bd:	68 94 28 80 00       	push   $0x802894
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
  8000d7:	e8 29 16 00 00       	call   801705 <fstat>
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
  8000f8:	68 94 28 80 00       	push   $0x802894
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 35 1a 00 00       	call   801b39 <fprintf>
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
  800194:	68 bc 28 80 00       	push   $0x8028bc
  800199:	e8 15 01 00 00       	call   8002b3 <cprintf>
	cprintf("before umain\n");
  80019e:	c7 04 24 da 28 80 00 	movl   $0x8028da,(%esp)
  8001a5:	e8 09 01 00 00       	call   8002b3 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001aa:	83 c4 08             	add    $0x8,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 95 fe ff ff       	call   80004d <umain>
	cprintf("after umain\n");
  8001b8:	c7 04 24 e8 28 80 00 	movl   $0x8028e8,(%esp)
  8001bf:	e8 ef 00 00 00       	call   8002b3 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	83 c4 08             	add    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	68 f5 28 80 00       	push   $0x8028f5
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
  8001f8:	68 20 29 80 00       	push   $0x802920
  8001fd:	50                   	push   %eax
  8001fe:	68 14 29 80 00       	push   $0x802914
  800203:	e8 ab 00 00 00       	call   8002b3 <cprintf>
	close_all();
  800208:	e8 f1 11 00 00       	call   8013fe <close_all>
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
  800360:	e8 cb 22 00 00       	call   802630 <__udivdi3>
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
  800389:	e8 b2 23 00 00       	call   802740 <__umoddi3>
  80038e:	83 c4 14             	add    $0x14,%esp
  800391:	0f be 80 25 29 80 00 	movsbl 0x802925(%eax),%eax
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
  80043a:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
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
  800505:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  80050c:	85 d2                	test   %edx,%edx
  80050e:	74 18                	je     800528 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800510:	52                   	push   %edx
  800511:	68 7d 2d 80 00       	push   $0x802d7d
  800516:	53                   	push   %ebx
  800517:	56                   	push   %esi
  800518:	e8 a6 fe ff ff       	call   8003c3 <printfmt>
  80051d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800520:	89 7d 14             	mov    %edi,0x14(%ebp)
  800523:	e9 fe 02 00 00       	jmp    800826 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800528:	50                   	push   %eax
  800529:	68 3d 29 80 00       	push   $0x80293d
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
  800550:	b8 36 29 80 00       	mov    $0x802936,%eax
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
  8008e8:	bf 59 2a 80 00       	mov    $0x802a59,%edi
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
  800914:	bf 91 2a 80 00       	mov    $0x802a91,%edi
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
  800db5:	68 a8 2c 80 00       	push   $0x802ca8
  800dba:	6a 43                	push   $0x43
  800dbc:	68 c5 2c 80 00       	push   $0x802cc5
  800dc1:	e8 ca 16 00 00       	call   802490 <_panic>

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
  800e36:	68 a8 2c 80 00       	push   $0x802ca8
  800e3b:	6a 43                	push   $0x43
  800e3d:	68 c5 2c 80 00       	push   $0x802cc5
  800e42:	e8 49 16 00 00       	call   802490 <_panic>

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
  800e78:	68 a8 2c 80 00       	push   $0x802ca8
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 c5 2c 80 00       	push   $0x802cc5
  800e84:	e8 07 16 00 00       	call   802490 <_panic>

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
  800eba:	68 a8 2c 80 00       	push   $0x802ca8
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 c5 2c 80 00       	push   $0x802cc5
  800ec6:	e8 c5 15 00 00       	call   802490 <_panic>

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
  800efc:	68 a8 2c 80 00       	push   $0x802ca8
  800f01:	6a 43                	push   $0x43
  800f03:	68 c5 2c 80 00       	push   $0x802cc5
  800f08:	e8 83 15 00 00       	call   802490 <_panic>

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
  800f3e:	68 a8 2c 80 00       	push   $0x802ca8
  800f43:	6a 43                	push   $0x43
  800f45:	68 c5 2c 80 00       	push   $0x802cc5
  800f4a:	e8 41 15 00 00       	call   802490 <_panic>

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
  800f80:	68 a8 2c 80 00       	push   $0x802ca8
  800f85:	6a 43                	push   $0x43
  800f87:	68 c5 2c 80 00       	push   $0x802cc5
  800f8c:	e8 ff 14 00 00       	call   802490 <_panic>

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
  800fe4:	68 a8 2c 80 00       	push   $0x802ca8
  800fe9:	6a 43                	push   $0x43
  800feb:	68 c5 2c 80 00       	push   $0x802cc5
  800ff0:	e8 9b 14 00 00       	call   802490 <_panic>

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
  8010c8:	68 a8 2c 80 00       	push   $0x802ca8
  8010cd:	6a 43                	push   $0x43
  8010cf:	68 c5 2c 80 00       	push   $0x802cc5
  8010d4:	e8 b7 13 00 00       	call   802490 <_panic>

008010d9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010e5:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8010e7:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010ea:	83 3a 01             	cmpl   $0x1,(%edx)
  8010ed:	7e 09                	jle    8010f8 <argstart+0x1f>
  8010ef:	ba d9 28 80 00       	mov    $0x8028d9,%edx
  8010f4:	85 c9                	test   %ecx,%ecx
  8010f6:	75 05                	jne    8010fd <argstart+0x24>
  8010f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fd:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801100:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <argnext>:

int
argnext(struct Argstate *args)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	53                   	push   %ebx
  80110d:	83 ec 04             	sub    $0x4,%esp
  801110:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801113:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80111a:	8b 43 08             	mov    0x8(%ebx),%eax
  80111d:	85 c0                	test   %eax,%eax
  80111f:	74 72                	je     801193 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801121:	80 38 00             	cmpb   $0x0,(%eax)
  801124:	75 48                	jne    80116e <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801126:	8b 0b                	mov    (%ebx),%ecx
  801128:	83 39 01             	cmpl   $0x1,(%ecx)
  80112b:	74 58                	je     801185 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80112d:	8b 53 04             	mov    0x4(%ebx),%edx
  801130:	8b 42 04             	mov    0x4(%edx),%eax
  801133:	80 38 2d             	cmpb   $0x2d,(%eax)
  801136:	75 4d                	jne    801185 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801138:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80113c:	74 47                	je     801185 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80113e:	83 c0 01             	add    $0x1,%eax
  801141:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801144:	83 ec 04             	sub    $0x4,%esp
  801147:	8b 01                	mov    (%ecx),%eax
  801149:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801150:	50                   	push   %eax
  801151:	8d 42 08             	lea    0x8(%edx),%eax
  801154:	50                   	push   %eax
  801155:	83 c2 04             	add    $0x4,%edx
  801158:	52                   	push   %edx
  801159:	e8 42 fa ff ff       	call   800ba0 <memmove>
		(*args->argc)--;
  80115e:	8b 03                	mov    (%ebx),%eax
  801160:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801163:	8b 43 08             	mov    0x8(%ebx),%eax
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	80 38 2d             	cmpb   $0x2d,(%eax)
  80116c:	74 11                	je     80117f <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80116e:	8b 53 08             	mov    0x8(%ebx),%edx
  801171:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801174:	83 c2 01             	add    $0x1,%edx
  801177:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80117a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80117f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801183:	75 e9                	jne    80116e <argnext+0x65>
	args->curarg = 0;
  801185:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80118c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801191:	eb e7                	jmp    80117a <argnext+0x71>
		return -1;
  801193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801198:	eb e0                	jmp    80117a <argnext+0x71>

0080119a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	53                   	push   %ebx
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8011a4:	8b 43 08             	mov    0x8(%ebx),%eax
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	74 12                	je     8011bd <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8011ab:	80 38 00             	cmpb   $0x0,(%eax)
  8011ae:	74 12                	je     8011c2 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8011b0:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8011b3:	c7 43 08 d9 28 80 00 	movl   $0x8028d9,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8011ba:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8011bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    
	} else if (*args->argc > 1) {
  8011c2:	8b 13                	mov    (%ebx),%edx
  8011c4:	83 3a 01             	cmpl   $0x1,(%edx)
  8011c7:	7f 10                	jg     8011d9 <argnextvalue+0x3f>
		args->argvalue = 0;
  8011c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011d7:	eb e1                	jmp    8011ba <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8011d9:	8b 43 04             	mov    0x4(%ebx),%eax
  8011dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8011df:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011e2:	83 ec 04             	sub    $0x4,%esp
  8011e5:	8b 12                	mov    (%edx),%edx
  8011e7:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011ee:	52                   	push   %edx
  8011ef:	8d 50 08             	lea    0x8(%eax),%edx
  8011f2:	52                   	push   %edx
  8011f3:	83 c0 04             	add    $0x4,%eax
  8011f6:	50                   	push   %eax
  8011f7:	e8 a4 f9 ff ff       	call   800ba0 <memmove>
		(*args->argc)--;
  8011fc:	8b 03                	mov    (%ebx),%eax
  8011fe:	83 28 01             	subl   $0x1,(%eax)
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	eb b4                	jmp    8011ba <argnextvalue+0x20>

00801206 <argvalue>:
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 08             	sub    $0x8,%esp
  80120c:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80120f:	8b 42 0c             	mov    0xc(%edx),%eax
  801212:	85 c0                	test   %eax,%eax
  801214:	74 02                	je     801218 <argvalue+0x12>
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	52                   	push   %edx
  80121c:	e8 79 ff ff ff       	call   80119a <argnextvalue>
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	eb f0                	jmp    801216 <argvalue+0x10>

00801226 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	05 00 00 00 30       	add    $0x30000000,%eax
  801231:	c1 e8 0c             	shr    $0xc,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801241:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801246:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801255:	89 c2                	mov    %eax,%edx
  801257:	c1 ea 16             	shr    $0x16,%edx
  80125a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801261:	f6 c2 01             	test   $0x1,%dl
  801264:	74 2d                	je     801293 <fd_alloc+0x46>
  801266:	89 c2                	mov    %eax,%edx
  801268:	c1 ea 0c             	shr    $0xc,%edx
  80126b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801272:	f6 c2 01             	test   $0x1,%dl
  801275:	74 1c                	je     801293 <fd_alloc+0x46>
  801277:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80127c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801281:	75 d2                	jne    801255 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80128c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801291:	eb 0a                	jmp    80129d <fd_alloc+0x50>
			*fd_store = fd;
  801293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801296:	89 01                	mov    %eax,(%ecx)
			return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012a5:	83 f8 1f             	cmp    $0x1f,%eax
  8012a8:	77 30                	ja     8012da <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012aa:	c1 e0 0c             	shl    $0xc,%eax
  8012ad:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012b2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012b8:	f6 c2 01             	test   $0x1,%dl
  8012bb:	74 24                	je     8012e1 <fd_lookup+0x42>
  8012bd:	89 c2                	mov    %eax,%edx
  8012bf:	c1 ea 0c             	shr    $0xc,%edx
  8012c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c9:	f6 c2 01             	test   $0x1,%dl
  8012cc:	74 1a                	je     8012e8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 02                	mov    %eax,(%edx)
	return 0;
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
		return -E_INVAL;
  8012da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012df:	eb f7                	jmp    8012d8 <fd_lookup+0x39>
		return -E_INVAL;
  8012e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e6:	eb f0                	jmp    8012d8 <fd_lookup+0x39>
  8012e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ed:	eb e9                	jmp    8012d8 <fd_lookup+0x39>

008012ef <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801302:	39 08                	cmp    %ecx,(%eax)
  801304:	74 38                	je     80133e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801306:	83 c2 01             	add    $0x1,%edx
  801309:	8b 04 95 50 2d 80 00 	mov    0x802d50(,%edx,4),%eax
  801310:	85 c0                	test   %eax,%eax
  801312:	75 ee                	jne    801302 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801314:	a1 08 40 80 00       	mov    0x804008,%eax
  801319:	8b 40 48             	mov    0x48(%eax),%eax
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	51                   	push   %ecx
  801320:	50                   	push   %eax
  801321:	68 d4 2c 80 00       	push   $0x802cd4
  801326:	e8 88 ef ff ff       	call   8002b3 <cprintf>
	*dev = 0;
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    
			*dev = devtab[i];
  80133e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801341:	89 01                	mov    %eax,(%ecx)
			return 0;
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
  801348:	eb f2                	jmp    80133c <dev_lookup+0x4d>

0080134a <fd_close>:
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	57                   	push   %edi
  80134e:	56                   	push   %esi
  80134f:	53                   	push   %ebx
  801350:	83 ec 24             	sub    $0x24,%esp
  801353:	8b 75 08             	mov    0x8(%ebp),%esi
  801356:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801359:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80135c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80135d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801363:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801366:	50                   	push   %eax
  801367:	e8 33 ff ff ff       	call   80129f <fd_lookup>
  80136c:	89 c3                	mov    %eax,%ebx
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 05                	js     80137a <fd_close+0x30>
	    || fd != fd2)
  801375:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801378:	74 16                	je     801390 <fd_close+0x46>
		return (must_exist ? r : 0);
  80137a:	89 f8                	mov    %edi,%eax
  80137c:	84 c0                	test   %al,%al
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	0f 44 d8             	cmove  %eax,%ebx
}
  801386:	89 d8                	mov    %ebx,%eax
  801388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801396:	50                   	push   %eax
  801397:	ff 36                	pushl  (%esi)
  801399:	e8 51 ff ff ff       	call   8012ef <dev_lookup>
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 1a                	js     8013c1 <fd_close+0x77>
		if (dev->dev_close)
  8013a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013aa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	74 0b                	je     8013c1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	56                   	push   %esi
  8013ba:	ff d0                	call   *%eax
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	56                   	push   %esi
  8013c5:	6a 00                	push   $0x0
  8013c7:	e8 bd fa ff ff       	call   800e89 <sys_page_unmap>
	return r;
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	eb b5                	jmp    801386 <fd_close+0x3c>

008013d1 <close>:

int
close(int fdnum)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	ff 75 08             	pushl  0x8(%ebp)
  8013de:	e8 bc fe ff ff       	call   80129f <fd_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	79 02                	jns    8013ec <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    
		return fd_close(fd, 1);
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	6a 01                	push   $0x1
  8013f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f4:	e8 51 ff ff ff       	call   80134a <fd_close>
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	eb ec                	jmp    8013ea <close+0x19>

008013fe <close_all>:

void
close_all(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	53                   	push   %ebx
  801402:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801405:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	53                   	push   %ebx
  80140e:	e8 be ff ff ff       	call   8013d1 <close>
	for (i = 0; i < MAXFD; i++)
  801413:	83 c3 01             	add    $0x1,%ebx
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	83 fb 20             	cmp    $0x20,%ebx
  80141c:	75 ec                	jne    80140a <close_all+0xc>
}
  80141e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	57                   	push   %edi
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80142c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	ff 75 08             	pushl  0x8(%ebp)
  801433:	e8 67 fe ff ff       	call   80129f <fd_lookup>
  801438:	89 c3                	mov    %eax,%ebx
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	0f 88 81 00 00 00    	js     8014c6 <dup+0xa3>
		return r;
	close(newfdnum);
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	e8 81 ff ff ff       	call   8013d1 <close>

	newfd = INDEX2FD(newfdnum);
  801450:	8b 75 0c             	mov    0xc(%ebp),%esi
  801453:	c1 e6 0c             	shl    $0xc,%esi
  801456:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80145c:	83 c4 04             	add    $0x4,%esp
  80145f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801462:	e8 cf fd ff ff       	call   801236 <fd2data>
  801467:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801469:	89 34 24             	mov    %esi,(%esp)
  80146c:	e8 c5 fd ff ff       	call   801236 <fd2data>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801476:	89 d8                	mov    %ebx,%eax
  801478:	c1 e8 16             	shr    $0x16,%eax
  80147b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801482:	a8 01                	test   $0x1,%al
  801484:	74 11                	je     801497 <dup+0x74>
  801486:	89 d8                	mov    %ebx,%eax
  801488:	c1 e8 0c             	shr    $0xc,%eax
  80148b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801492:	f6 c2 01             	test   $0x1,%dl
  801495:	75 39                	jne    8014d0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801497:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80149a:	89 d0                	mov    %edx,%eax
  80149c:	c1 e8 0c             	shr    $0xc,%eax
  80149f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ae:	50                   	push   %eax
  8014af:	56                   	push   %esi
  8014b0:	6a 00                	push   $0x0
  8014b2:	52                   	push   %edx
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 8d f9 ff ff       	call   800e47 <sys_page_map>
  8014ba:	89 c3                	mov    %eax,%ebx
  8014bc:	83 c4 20             	add    $0x20,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 31                	js     8014f4 <dup+0xd1>
		goto err;

	return newfdnum;
  8014c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014c6:	89 d8                	mov    %ebx,%eax
  8014c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014cb:	5b                   	pop    %ebx
  8014cc:	5e                   	pop    %esi
  8014cd:	5f                   	pop    %edi
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	25 07 0e 00 00       	and    $0xe07,%eax
  8014df:	50                   	push   %eax
  8014e0:	57                   	push   %edi
  8014e1:	6a 00                	push   $0x0
  8014e3:	53                   	push   %ebx
  8014e4:	6a 00                	push   $0x0
  8014e6:	e8 5c f9 ff ff       	call   800e47 <sys_page_map>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	83 c4 20             	add    $0x20,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	79 a3                	jns    801497 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	56                   	push   %esi
  8014f8:	6a 00                	push   $0x0
  8014fa:	e8 8a f9 ff ff       	call   800e89 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	57                   	push   %edi
  801503:	6a 00                	push   $0x0
  801505:	e8 7f f9 ff ff       	call   800e89 <sys_page_unmap>
	return r;
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	eb b7                	jmp    8014c6 <dup+0xa3>

0080150f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 1c             	sub    $0x1c,%esp
  801516:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	53                   	push   %ebx
  80151e:	e8 7c fd ff ff       	call   80129f <fd_lookup>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 3f                	js     801569 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ff 30                	pushl  (%eax)
  801536:	e8 b4 fd ff ff       	call   8012ef <dev_lookup>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 27                	js     801569 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801545:	8b 42 08             	mov    0x8(%edx),%eax
  801548:	83 e0 03             	and    $0x3,%eax
  80154b:	83 f8 01             	cmp    $0x1,%eax
  80154e:	74 1e                	je     80156e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	8b 40 08             	mov    0x8(%eax),%eax
  801556:	85 c0                	test   %eax,%eax
  801558:	74 35                	je     80158f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	ff 75 10             	pushl  0x10(%ebp)
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	52                   	push   %edx
  801564:	ff d0                	call   *%eax
  801566:	83 c4 10             	add    $0x10,%esp
}
  801569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80156e:	a1 08 40 80 00       	mov    0x804008,%eax
  801573:	8b 40 48             	mov    0x48(%eax),%eax
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	53                   	push   %ebx
  80157a:	50                   	push   %eax
  80157b:	68 15 2d 80 00       	push   $0x802d15
  801580:	e8 2e ed ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158d:	eb da                	jmp    801569 <read+0x5a>
		return -E_NOT_SUPP;
  80158f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801594:	eb d3                	jmp    801569 <read+0x5a>

00801596 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	57                   	push   %edi
  80159a:	56                   	push   %esi
  80159b:	53                   	push   %ebx
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015aa:	39 f3                	cmp    %esi,%ebx
  8015ac:	73 23                	jae    8015d1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	89 f0                	mov    %esi,%eax
  8015b3:	29 d8                	sub    %ebx,%eax
  8015b5:	50                   	push   %eax
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	03 45 0c             	add    0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	57                   	push   %edi
  8015bd:	e8 4d ff ff ff       	call   80150f <read>
		if (m < 0)
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 06                	js     8015cf <readn+0x39>
			return m;
		if (m == 0)
  8015c9:	74 06                	je     8015d1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015cb:	01 c3                	add    %eax,%ebx
  8015cd:	eb db                	jmp    8015aa <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015cf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5f                   	pop    %edi
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    

008015db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 1c             	sub    $0x1c,%esp
  8015e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	53                   	push   %ebx
  8015ea:	e8 b0 fc ff ff       	call   80129f <fd_lookup>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 3a                	js     801630 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801600:	ff 30                	pushl  (%eax)
  801602:	e8 e8 fc ff ff       	call   8012ef <dev_lookup>
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 22                	js     801630 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801615:	74 1e                	je     801635 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161a:	8b 52 0c             	mov    0xc(%edx),%edx
  80161d:	85 d2                	test   %edx,%edx
  80161f:	74 35                	je     801656 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	ff 75 10             	pushl  0x10(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	50                   	push   %eax
  80162b:	ff d2                	call   *%edx
  80162d:	83 c4 10             	add    $0x10,%esp
}
  801630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801633:	c9                   	leave  
  801634:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801635:	a1 08 40 80 00       	mov    0x804008,%eax
  80163a:	8b 40 48             	mov    0x48(%eax),%eax
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	53                   	push   %ebx
  801641:	50                   	push   %eax
  801642:	68 31 2d 80 00       	push   $0x802d31
  801647:	e8 67 ec ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801654:	eb da                	jmp    801630 <write+0x55>
		return -E_NOT_SUPP;
  801656:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165b:	eb d3                	jmp    801630 <write+0x55>

0080165d <seek>:

int
seek(int fdnum, off_t offset)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801663:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	ff 75 08             	pushl  0x8(%ebp)
  80166a:	e8 30 fc ff ff       	call   80129f <fd_lookup>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 0e                	js     801684 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 1c             	sub    $0x1c,%esp
  80168d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801690:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801693:	50                   	push   %eax
  801694:	53                   	push   %ebx
  801695:	e8 05 fc ff ff       	call   80129f <fd_lookup>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 37                	js     8016d8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	ff 30                	pushl  (%eax)
  8016ad:	e8 3d fc ff ff       	call   8012ef <dev_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 1f                	js     8016d8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c0:	74 1b                	je     8016dd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	8b 52 18             	mov    0x18(%edx),%edx
  8016c8:	85 d2                	test   %edx,%edx
  8016ca:	74 32                	je     8016fe <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	50                   	push   %eax
  8016d3:	ff d2                	call   *%edx
  8016d5:	83 c4 10             	add    $0x10,%esp
}
  8016d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016dd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016e2:	8b 40 48             	mov    0x48(%eax),%eax
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	53                   	push   %ebx
  8016e9:	50                   	push   %eax
  8016ea:	68 f4 2c 80 00       	push   $0x802cf4
  8016ef:	e8 bf eb ff ff       	call   8002b3 <cprintf>
		return -E_INVAL;
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fc:	eb da                	jmp    8016d8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801703:	eb d3                	jmp    8016d8 <ftruncate+0x52>

00801705 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	53                   	push   %ebx
  801709:	83 ec 1c             	sub    $0x1c,%esp
  80170c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801712:	50                   	push   %eax
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	e8 84 fb ff ff       	call   80129f <fd_lookup>
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 4b                	js     80176d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801728:	50                   	push   %eax
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	ff 30                	pushl  (%eax)
  80172e:	e8 bc fb ff ff       	call   8012ef <dev_lookup>
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	85 c0                	test   %eax,%eax
  801738:	78 33                	js     80176d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80173a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801741:	74 2f                	je     801772 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801743:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801746:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80174d:	00 00 00 
	stat->st_isdir = 0;
  801750:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801757:	00 00 00 
	stat->st_dev = dev;
  80175a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	53                   	push   %ebx
  801764:	ff 75 f0             	pushl  -0x10(%ebp)
  801767:	ff 50 14             	call   *0x14(%eax)
  80176a:	83 c4 10             	add    $0x10,%esp
}
  80176d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801770:	c9                   	leave  
  801771:	c3                   	ret    
		return -E_NOT_SUPP;
  801772:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801777:	eb f4                	jmp    80176d <fstat+0x68>

00801779 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	56                   	push   %esi
  80177d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	6a 00                	push   $0x0
  801783:	ff 75 08             	pushl  0x8(%ebp)
  801786:	e8 22 02 00 00       	call   8019ad <open>
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	85 c0                	test   %eax,%eax
  801792:	78 1b                	js     8017af <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	50                   	push   %eax
  80179b:	e8 65 ff ff ff       	call   801705 <fstat>
  8017a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017a2:	89 1c 24             	mov    %ebx,(%esp)
  8017a5:	e8 27 fc ff ff       	call   8013d1 <close>
	return r;
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	89 f3                	mov    %esi,%ebx
}
  8017af:	89 d8                	mov    %ebx,%eax
  8017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b4:	5b                   	pop    %ebx
  8017b5:	5e                   	pop    %esi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	89 c6                	mov    %eax,%esi
  8017bf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017c1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017c8:	74 27                	je     8017f1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017ca:	6a 07                	push   $0x7
  8017cc:	68 00 50 80 00       	push   $0x805000
  8017d1:	56                   	push   %esi
  8017d2:	ff 35 00 40 80 00    	pushl  0x804000
  8017d8:	e8 7d 0d 00 00       	call   80255a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017dd:	83 c4 0c             	add    $0xc,%esp
  8017e0:	6a 00                	push   $0x0
  8017e2:	53                   	push   %ebx
  8017e3:	6a 00                	push   $0x0
  8017e5:	e8 07 0d 00 00       	call   8024f1 <ipc_recv>
}
  8017ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017f1:	83 ec 0c             	sub    $0xc,%esp
  8017f4:	6a 01                	push   $0x1
  8017f6:	e8 b7 0d 00 00       	call   8025b2 <ipc_find_env>
  8017fb:	a3 00 40 80 00       	mov    %eax,0x804000
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	eb c5                	jmp    8017ca <fsipc+0x12>

00801805 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801816:	8b 45 0c             	mov    0xc(%ebp),%eax
  801819:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	b8 02 00 00 00       	mov    $0x2,%eax
  801828:	e8 8b ff ff ff       	call   8017b8 <fsipc>
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <devfile_flush>:
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8b 40 0c             	mov    0xc(%eax),%eax
  80183b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	b8 06 00 00 00       	mov    $0x6,%eax
  80184a:	e8 69 ff ff ff       	call   8017b8 <fsipc>
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <devfile_stat>:
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	53                   	push   %ebx
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8b 40 0c             	mov    0xc(%eax),%eax
  801861:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801866:	ba 00 00 00 00       	mov    $0x0,%edx
  80186b:	b8 05 00 00 00       	mov    $0x5,%eax
  801870:	e8 43 ff ff ff       	call   8017b8 <fsipc>
  801875:	85 c0                	test   %eax,%eax
  801877:	78 2c                	js     8018a5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801879:	83 ec 08             	sub    $0x8,%esp
  80187c:	68 00 50 80 00       	push   $0x805000
  801881:	53                   	push   %ebx
  801882:	e8 8b f1 ff ff       	call   800a12 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801887:	a1 80 50 80 00       	mov    0x805080,%eax
  80188c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801892:	a1 84 50 80 00       	mov    0x805084,%eax
  801897:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <devfile_write>:
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ba:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018bf:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018c5:	53                   	push   %ebx
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	68 08 50 80 00       	push   $0x805008
  8018ce:	e8 2f f3 ff ff       	call   800c02 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8018dd:	e8 d6 fe ff ff       	call   8017b8 <fsipc>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 0b                	js     8018f4 <devfile_write+0x4a>
	assert(r <= n);
  8018e9:	39 d8                	cmp    %ebx,%eax
  8018eb:	77 0c                	ja     8018f9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f2:	7f 1e                	jg     801912 <devfile_write+0x68>
}
  8018f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    
	assert(r <= n);
  8018f9:	68 64 2d 80 00       	push   $0x802d64
  8018fe:	68 6b 2d 80 00       	push   $0x802d6b
  801903:	68 98 00 00 00       	push   $0x98
  801908:	68 80 2d 80 00       	push   $0x802d80
  80190d:	e8 7e 0b 00 00       	call   802490 <_panic>
	assert(r <= PGSIZE);
  801912:	68 8b 2d 80 00       	push   $0x802d8b
  801917:	68 6b 2d 80 00       	push   $0x802d6b
  80191c:	68 99 00 00 00       	push   $0x99
  801921:	68 80 2d 80 00       	push   $0x802d80
  801926:	e8 65 0b 00 00       	call   802490 <_panic>

0080192b <devfile_read>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	8b 40 0c             	mov    0xc(%eax),%eax
  801939:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80193e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801944:	ba 00 00 00 00       	mov    $0x0,%edx
  801949:	b8 03 00 00 00       	mov    $0x3,%eax
  80194e:	e8 65 fe ff ff       	call   8017b8 <fsipc>
  801953:	89 c3                	mov    %eax,%ebx
  801955:	85 c0                	test   %eax,%eax
  801957:	78 1f                	js     801978 <devfile_read+0x4d>
	assert(r <= n);
  801959:	39 f0                	cmp    %esi,%eax
  80195b:	77 24                	ja     801981 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80195d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801962:	7f 33                	jg     801997 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	50                   	push   %eax
  801968:	68 00 50 80 00       	push   $0x805000
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	e8 2b f2 ff ff       	call   800ba0 <memmove>
	return r;
  801975:	83 c4 10             	add    $0x10,%esp
}
  801978:	89 d8                	mov    %ebx,%eax
  80197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
	assert(r <= n);
  801981:	68 64 2d 80 00       	push   $0x802d64
  801986:	68 6b 2d 80 00       	push   $0x802d6b
  80198b:	6a 7c                	push   $0x7c
  80198d:	68 80 2d 80 00       	push   $0x802d80
  801992:	e8 f9 0a 00 00       	call   802490 <_panic>
	assert(r <= PGSIZE);
  801997:	68 8b 2d 80 00       	push   $0x802d8b
  80199c:	68 6b 2d 80 00       	push   $0x802d6b
  8019a1:	6a 7d                	push   $0x7d
  8019a3:	68 80 2d 80 00       	push   $0x802d80
  8019a8:	e8 e3 0a 00 00       	call   802490 <_panic>

008019ad <open>:
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 1c             	sub    $0x1c,%esp
  8019b5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019b8:	56                   	push   %esi
  8019b9:	e8 1b f0 ff ff       	call   8009d9 <strlen>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019c6:	7f 6c                	jg     801a34 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019c8:	83 ec 0c             	sub    $0xc,%esp
  8019cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ce:	50                   	push   %eax
  8019cf:	e8 79 f8 ff ff       	call   80124d <fd_alloc>
  8019d4:	89 c3                	mov    %eax,%ebx
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 3c                	js     801a19 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	56                   	push   %esi
  8019e1:	68 00 50 80 00       	push   $0x805000
  8019e6:	e8 27 f0 ff ff       	call   800a12 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fb:	e8 b8 fd ff ff       	call   8017b8 <fsipc>
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 19                	js     801a22 <open+0x75>
	return fd2num(fd);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0f:	e8 12 f8 ff ff       	call   801226 <fd2num>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
}
  801a19:	89 d8                	mov    %ebx,%eax
  801a1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    
		fd_close(fd, 0);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	6a 00                	push   $0x0
  801a27:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2a:	e8 1b f9 ff ff       	call   80134a <fd_close>
		return r;
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	eb e5                	jmp    801a19 <open+0x6c>
		return -E_BAD_PATH;
  801a34:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a39:	eb de                	jmp    801a19 <open+0x6c>

00801a3b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a41:	ba 00 00 00 00       	mov    $0x0,%edx
  801a46:	b8 08 00 00 00       	mov    $0x8,%eax
  801a4b:	e8 68 fd ff ff       	call   8017b8 <fsipc>
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a52:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a56:	7f 01                	jg     801a59 <writebuf+0x7>
  801a58:	c3                   	ret    
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a62:	ff 70 04             	pushl  0x4(%eax)
  801a65:	8d 40 10             	lea    0x10(%eax),%eax
  801a68:	50                   	push   %eax
  801a69:	ff 33                	pushl  (%ebx)
  801a6b:	e8 6b fb ff ff       	call   8015db <write>
		if (result > 0)
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	7e 03                	jle    801a7a <writebuf+0x28>
			b->result += result;
  801a77:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a7a:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a7d:	74 0d                	je     801a8c <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	0f 4f c2             	cmovg  %edx,%eax
  801a89:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <putch>:

static void
putch(int ch, void *thunk)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	53                   	push   %ebx
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a9b:	8b 53 04             	mov    0x4(%ebx),%edx
  801a9e:	8d 42 01             	lea    0x1(%edx),%eax
  801aa1:	89 43 04             	mov    %eax,0x4(%ebx)
  801aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801aab:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ab0:	74 06                	je     801ab8 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801ab2:	83 c4 04             	add    $0x4,%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
		writebuf(b);
  801ab8:	89 d8                	mov    %ebx,%eax
  801aba:	e8 93 ff ff ff       	call   801a52 <writebuf>
		b->idx = 0;
  801abf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801ac6:	eb ea                	jmp    801ab2 <putch+0x21>

00801ac8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801ada:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ae1:	00 00 00 
	b.result = 0;
  801ae4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801aeb:	00 00 00 
	b.error = 1;
  801aee:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801af5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	68 91 1a 80 00       	push   $0x801a91
  801b0a:	e8 d1 e8 ff ff       	call   8003e0 <vprintfmt>
	if (b.idx > 0)
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b19:	7f 11                	jg     801b2c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b1b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b21:	85 c0                	test   %eax,%eax
  801b23:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    
		writebuf(&b);
  801b2c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b32:	e8 1b ff ff ff       	call   801a52 <writebuf>
  801b37:	eb e2                	jmp    801b1b <vfprintf+0x53>

00801b39 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b3f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b42:	50                   	push   %eax
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	ff 75 08             	pushl  0x8(%ebp)
  801b49:	e8 7a ff ff ff       	call   801ac8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <printf>:

int
printf(const char *fmt, ...)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b56:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b59:	50                   	push   %eax
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	6a 01                	push   $0x1
  801b5f:	e8 64 ff ff ff       	call   801ac8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b6c:	68 97 2d 80 00       	push   $0x802d97
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	e8 99 ee ff ff       	call   800a12 <strcpy>
	return 0;
}
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <devsock_close>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 10             	sub    $0x10,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b8a:	53                   	push   %ebx
  801b8b:	e8 5d 0a 00 00       	call   8025ed <pageref>
  801b90:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b93:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b98:	83 f8 01             	cmp    $0x1,%eax
  801b9b:	74 07                	je     801ba4 <devsock_close+0x24>
}
  801b9d:	89 d0                	mov    %edx,%eax
  801b9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	ff 73 0c             	pushl  0xc(%ebx)
  801baa:	e8 b9 02 00 00       	call   801e68 <nsipc_close>
  801baf:	89 c2                	mov    %eax,%edx
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	eb e7                	jmp    801b9d <devsock_close+0x1d>

00801bb6 <devsock_write>:
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	ff 75 10             	pushl  0x10(%ebp)
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	ff 70 0c             	pushl  0xc(%eax)
  801bca:	e8 76 03 00 00       	call   801f45 <nsipc_send>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <devsock_read>:
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	ff 75 10             	pushl  0x10(%ebp)
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	ff 70 0c             	pushl  0xc(%eax)
  801be5:	e8 ef 02 00 00       	call   801ed9 <nsipc_recv>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <fd2sockid>:
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bf2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	e8 a3 f6 ff ff       	call   80129f <fd_lookup>
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 10                	js     801c13 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c0c:	39 08                	cmp    %ecx,(%eax)
  801c0e:	75 05                	jne    801c15 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c10:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    
		return -E_NOT_SUPP;
  801c15:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c1a:	eb f7                	jmp    801c13 <fd2sockid+0x27>

00801c1c <alloc_sockfd>:
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	56                   	push   %esi
  801c20:	53                   	push   %ebx
  801c21:	83 ec 1c             	sub    $0x1c,%esp
  801c24:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	e8 1e f6 ff ff       	call   80124d <fd_alloc>
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 43                	js     801c7b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	68 07 04 00 00       	push   $0x407
  801c40:	ff 75 f4             	pushl  -0xc(%ebp)
  801c43:	6a 00                	push   $0x0
  801c45:	e8 ba f1 ff ff       	call   800e04 <sys_page_alloc>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	78 28                	js     801c7b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c56:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c68:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	50                   	push   %eax
  801c6f:	e8 b2 f5 ff ff       	call   801226 <fd2num>
  801c74:	89 c3                	mov    %eax,%ebx
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	eb 0c                	jmp    801c87 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c7b:	83 ec 0c             	sub    $0xc,%esp
  801c7e:	56                   	push   %esi
  801c7f:	e8 e4 01 00 00       	call   801e68 <nsipc_close>
		return r;
  801c84:	83 c4 10             	add    $0x10,%esp
}
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <accept>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	e8 4e ff ff ff       	call   801bec <fd2sockid>
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 1b                	js     801cbd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	50                   	push   %eax
  801cac:	e8 0e 01 00 00       	call   801dbf <nsipc_accept>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 05                	js     801cbd <accept+0x2d>
	return alloc_sockfd(r);
  801cb8:	e8 5f ff ff ff       	call   801c1c <alloc_sockfd>
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <bind>:
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	e8 1f ff ff ff       	call   801bec <fd2sockid>
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	78 12                	js     801ce3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	50                   	push   %eax
  801cdb:	e8 31 01 00 00       	call   801e11 <nsipc_bind>
  801ce0:	83 c4 10             	add    $0x10,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <shutdown>:
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	e8 f9 fe ff ff       	call   801bec <fd2sockid>
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 0f                	js     801d06 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801cf7:	83 ec 08             	sub    $0x8,%esp
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	50                   	push   %eax
  801cfe:	e8 43 01 00 00       	call   801e46 <nsipc_shutdown>
  801d03:	83 c4 10             	add    $0x10,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <connect>:
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	e8 d6 fe ff ff       	call   801bec <fd2sockid>
  801d16:	85 c0                	test   %eax,%eax
  801d18:	78 12                	js     801d2c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	ff 75 10             	pushl  0x10(%ebp)
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	50                   	push   %eax
  801d24:	e8 59 01 00 00       	call   801e82 <nsipc_connect>
  801d29:	83 c4 10             	add    $0x10,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <listen>:
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	e8 b0 fe ff ff       	call   801bec <fd2sockid>
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 0f                	js     801d4f <listen+0x21>
	return nsipc_listen(r, backlog);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	50                   	push   %eax
  801d47:	e8 6b 01 00 00       	call   801eb7 <nsipc_listen>
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d57:	ff 75 10             	pushl  0x10(%ebp)
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	ff 75 08             	pushl  0x8(%ebp)
  801d60:	e8 3e 02 00 00       	call   801fa3 <nsipc_socket>
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 05                	js     801d71 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d6c:	e8 ab fe ff ff       	call   801c1c <alloc_sockfd>
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	53                   	push   %ebx
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d7c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d83:	74 26                	je     801dab <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d85:	6a 07                	push   $0x7
  801d87:	68 00 60 80 00       	push   $0x806000
  801d8c:	53                   	push   %ebx
  801d8d:	ff 35 04 40 80 00    	pushl  0x804004
  801d93:	e8 c2 07 00 00       	call   80255a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d98:	83 c4 0c             	add    $0xc,%esp
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	e8 4b 07 00 00       	call   8024f1 <ipc_recv>
}
  801da6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	6a 02                	push   $0x2
  801db0:	e8 fd 07 00 00       	call   8025b2 <ipc_find_env>
  801db5:	a3 04 40 80 00       	mov    %eax,0x804004
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	eb c6                	jmp    801d85 <nsipc+0x12>

00801dbf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dcf:	8b 06                	mov    (%esi),%eax
  801dd1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	e8 93 ff ff ff       	call   801d73 <nsipc>
  801de0:	89 c3                	mov    %eax,%ebx
  801de2:	85 c0                	test   %eax,%eax
  801de4:	79 09                	jns    801def <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801de6:	89 d8                	mov    %ebx,%eax
  801de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	ff 35 10 60 80 00    	pushl  0x806010
  801df8:	68 00 60 80 00       	push   $0x806000
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	e8 9b ed ff ff       	call   800ba0 <memmove>
		*addrlen = ret->ret_addrlen;
  801e05:	a1 10 60 80 00       	mov    0x806010,%eax
  801e0a:	89 06                	mov    %eax,(%esi)
  801e0c:	83 c4 10             	add    $0x10,%esp
	return r;
  801e0f:	eb d5                	jmp    801de6 <nsipc_accept+0x27>

00801e11 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	53                   	push   %ebx
  801e15:	83 ec 08             	sub    $0x8,%esp
  801e18:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e23:	53                   	push   %ebx
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	68 04 60 80 00       	push   $0x806004
  801e2c:	e8 6f ed ff ff       	call   800ba0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e31:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e37:	b8 02 00 00 00       	mov    $0x2,%eax
  801e3c:	e8 32 ff ff ff       	call   801d73 <nsipc>
}
  801e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801e61:	e8 0d ff ff ff       	call   801d73 <nsipc>
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <nsipc_close>:

int
nsipc_close(int s)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e76:	b8 04 00 00 00       	mov    $0x4,%eax
  801e7b:	e8 f3 fe ff ff       	call   801d73 <nsipc>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	53                   	push   %ebx
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e94:	53                   	push   %ebx
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	68 04 60 80 00       	push   $0x806004
  801e9d:	e8 fe ec ff ff       	call   800ba0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ea2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ea8:	b8 05 00 00 00       	mov    $0x5,%eax
  801ead:	e8 c1 fe ff ff       	call   801d73 <nsipc>
}
  801eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ecd:	b8 06 00 00 00       	mov    $0x6,%eax
  801ed2:	e8 9c fe ff ff       	call   801d73 <nsipc>
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	56                   	push   %esi
  801edd:	53                   	push   %ebx
  801ede:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ee9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801eef:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ef7:	b8 07 00 00 00       	mov    $0x7,%eax
  801efc:	e8 72 fe ff ff       	call   801d73 <nsipc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 1f                	js     801f26 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f07:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f0c:	7f 21                	jg     801f2f <nsipc_recv+0x56>
  801f0e:	39 c6                	cmp    %eax,%esi
  801f10:	7c 1d                	jl     801f2f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	50                   	push   %eax
  801f16:	68 00 60 80 00       	push   $0x806000
  801f1b:	ff 75 0c             	pushl  0xc(%ebp)
  801f1e:	e8 7d ec ff ff       	call   800ba0 <memmove>
  801f23:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f26:	89 d8                	mov    %ebx,%eax
  801f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f2f:	68 a3 2d 80 00       	push   $0x802da3
  801f34:	68 6b 2d 80 00       	push   $0x802d6b
  801f39:	6a 62                	push   $0x62
  801f3b:	68 b8 2d 80 00       	push   $0x802db8
  801f40:	e8 4b 05 00 00       	call   802490 <_panic>

00801f45 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	53                   	push   %ebx
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f57:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f5d:	7f 2e                	jg     801f8d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	53                   	push   %ebx
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	68 0c 60 80 00       	push   $0x80600c
  801f6b:	e8 30 ec ff ff       	call   800ba0 <memmove>
	nsipcbuf.send.req_size = size;
  801f70:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f76:	8b 45 14             	mov    0x14(%ebp),%eax
  801f79:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f83:	e8 eb fd ff ff       	call   801d73 <nsipc>
}
  801f88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    
	assert(size < 1600);
  801f8d:	68 c4 2d 80 00       	push   $0x802dc4
  801f92:	68 6b 2d 80 00       	push   $0x802d6b
  801f97:	6a 6d                	push   $0x6d
  801f99:	68 b8 2d 80 00       	push   $0x802db8
  801f9e:	e8 ed 04 00 00       	call   802490 <_panic>

00801fa3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fc1:	b8 09 00 00 00       	mov    $0x9,%eax
  801fc6:	e8 a8 fd ff ff       	call   801d73 <nsipc>
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	56                   	push   %esi
  801fd1:	53                   	push   %ebx
  801fd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 56 f2 ff ff       	call   801236 <fd2data>
  801fe0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fe2:	83 c4 08             	add    $0x8,%esp
  801fe5:	68 d0 2d 80 00       	push   $0x802dd0
  801fea:	53                   	push   %ebx
  801feb:	e8 22 ea ff ff       	call   800a12 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ff0:	8b 46 04             	mov    0x4(%esi),%eax
  801ff3:	2b 06                	sub    (%esi),%eax
  801ff5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ffb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802002:	00 00 00 
	stat->st_dev = &devpipe;
  802005:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80200c:	30 80 00 
	return 0;
}
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
  802014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802025:	53                   	push   %ebx
  802026:	6a 00                	push   $0x0
  802028:	e8 5c ee ff ff       	call   800e89 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80202d:	89 1c 24             	mov    %ebx,(%esp)
  802030:	e8 01 f2 ff ff       	call   801236 <fd2data>
  802035:	83 c4 08             	add    $0x8,%esp
  802038:	50                   	push   %eax
  802039:	6a 00                	push   $0x0
  80203b:	e8 49 ee ff ff       	call   800e89 <sys_page_unmap>
}
  802040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <_pipeisclosed>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	57                   	push   %edi
  802049:	56                   	push   %esi
  80204a:	53                   	push   %ebx
  80204b:	83 ec 1c             	sub    $0x1c,%esp
  80204e:	89 c7                	mov    %eax,%edi
  802050:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802052:	a1 08 40 80 00       	mov    0x804008,%eax
  802057:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80205a:	83 ec 0c             	sub    $0xc,%esp
  80205d:	57                   	push   %edi
  80205e:	e8 8a 05 00 00       	call   8025ed <pageref>
  802063:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802066:	89 34 24             	mov    %esi,(%esp)
  802069:	e8 7f 05 00 00       	call   8025ed <pageref>
		nn = thisenv->env_runs;
  80206e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802074:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	39 cb                	cmp    %ecx,%ebx
  80207c:	74 1b                	je     802099 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80207e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802081:	75 cf                	jne    802052 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802083:	8b 42 58             	mov    0x58(%edx),%eax
  802086:	6a 01                	push   $0x1
  802088:	50                   	push   %eax
  802089:	53                   	push   %ebx
  80208a:	68 d7 2d 80 00       	push   $0x802dd7
  80208f:	e8 1f e2 ff ff       	call   8002b3 <cprintf>
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	eb b9                	jmp    802052 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802099:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80209c:	0f 94 c0             	sete   %al
  80209f:	0f b6 c0             	movzbl %al,%eax
}
  8020a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a5:	5b                   	pop    %ebx
  8020a6:	5e                   	pop    %esi
  8020a7:	5f                   	pop    %edi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <devpipe_write>:
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	57                   	push   %edi
  8020ae:	56                   	push   %esi
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 28             	sub    $0x28,%esp
  8020b3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020b6:	56                   	push   %esi
  8020b7:	e8 7a f1 ff ff       	call   801236 <fd2data>
  8020bc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020c9:	74 4f                	je     80211a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8020ce:	8b 0b                	mov    (%ebx),%ecx
  8020d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8020d3:	39 d0                	cmp    %edx,%eax
  8020d5:	72 14                	jb     8020eb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020d7:	89 da                	mov    %ebx,%edx
  8020d9:	89 f0                	mov    %esi,%eax
  8020db:	e8 65 ff ff ff       	call   802045 <_pipeisclosed>
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 3b                	jne    80211f <devpipe_write+0x75>
			sys_yield();
  8020e4:	e8 fc ec ff ff       	call   800de5 <sys_yield>
  8020e9:	eb e0                	jmp    8020cb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020ee:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020f2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020f5:	89 c2                	mov    %eax,%edx
  8020f7:	c1 fa 1f             	sar    $0x1f,%edx
  8020fa:	89 d1                	mov    %edx,%ecx
  8020fc:	c1 e9 1b             	shr    $0x1b,%ecx
  8020ff:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802102:	83 e2 1f             	and    $0x1f,%edx
  802105:	29 ca                	sub    %ecx,%edx
  802107:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80210b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80210f:	83 c0 01             	add    $0x1,%eax
  802112:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802115:	83 c7 01             	add    $0x1,%edi
  802118:	eb ac                	jmp    8020c6 <devpipe_write+0x1c>
	return i;
  80211a:	8b 45 10             	mov    0x10(%ebp),%eax
  80211d:	eb 05                	jmp    802124 <devpipe_write+0x7a>
				return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <devpipe_read>:
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	57                   	push   %edi
  802130:	56                   	push   %esi
  802131:	53                   	push   %ebx
  802132:	83 ec 18             	sub    $0x18,%esp
  802135:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802138:	57                   	push   %edi
  802139:	e8 f8 f0 ff ff       	call   801236 <fd2data>
  80213e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	be 00 00 00 00       	mov    $0x0,%esi
  802148:	3b 75 10             	cmp    0x10(%ebp),%esi
  80214b:	75 14                	jne    802161 <devpipe_read+0x35>
	return i;
  80214d:	8b 45 10             	mov    0x10(%ebp),%eax
  802150:	eb 02                	jmp    802154 <devpipe_read+0x28>
				return i;
  802152:	89 f0                	mov    %esi,%eax
}
  802154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
			sys_yield();
  80215c:	e8 84 ec ff ff       	call   800de5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802161:	8b 03                	mov    (%ebx),%eax
  802163:	3b 43 04             	cmp    0x4(%ebx),%eax
  802166:	75 18                	jne    802180 <devpipe_read+0x54>
			if (i > 0)
  802168:	85 f6                	test   %esi,%esi
  80216a:	75 e6                	jne    802152 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80216c:	89 da                	mov    %ebx,%edx
  80216e:	89 f8                	mov    %edi,%eax
  802170:	e8 d0 fe ff ff       	call   802045 <_pipeisclosed>
  802175:	85 c0                	test   %eax,%eax
  802177:	74 e3                	je     80215c <devpipe_read+0x30>
				return 0;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	eb d4                	jmp    802154 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802180:	99                   	cltd   
  802181:	c1 ea 1b             	shr    $0x1b,%edx
  802184:	01 d0                	add    %edx,%eax
  802186:	83 e0 1f             	and    $0x1f,%eax
  802189:	29 d0                	sub    %edx,%eax
  80218b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802193:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802196:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802199:	83 c6 01             	add    $0x1,%esi
  80219c:	eb aa                	jmp    802148 <devpipe_read+0x1c>

0080219e <pipe>:
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	56                   	push   %esi
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a9:	50                   	push   %eax
  8021aa:	e8 9e f0 ff ff       	call   80124d <fd_alloc>
  8021af:	89 c3                	mov    %eax,%ebx
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	0f 88 23 01 00 00    	js     8022df <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021bc:	83 ec 04             	sub    $0x4,%esp
  8021bf:	68 07 04 00 00       	push   $0x407
  8021c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c7:	6a 00                	push   $0x0
  8021c9:	e8 36 ec ff ff       	call   800e04 <sys_page_alloc>
  8021ce:	89 c3                	mov    %eax,%ebx
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	0f 88 04 01 00 00    	js     8022df <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021e1:	50                   	push   %eax
  8021e2:	e8 66 f0 ff ff       	call   80124d <fd_alloc>
  8021e7:	89 c3                	mov    %eax,%ebx
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	0f 88 db 00 00 00    	js     8022cf <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	68 07 04 00 00       	push   $0x407
  8021fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ff:	6a 00                	push   $0x0
  802201:	e8 fe eb ff ff       	call   800e04 <sys_page_alloc>
  802206:	89 c3                	mov    %eax,%ebx
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	85 c0                	test   %eax,%eax
  80220d:	0f 88 bc 00 00 00    	js     8022cf <pipe+0x131>
	va = fd2data(fd0);
  802213:	83 ec 0c             	sub    $0xc,%esp
  802216:	ff 75 f4             	pushl  -0xc(%ebp)
  802219:	e8 18 f0 ff ff       	call   801236 <fd2data>
  80221e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802220:	83 c4 0c             	add    $0xc,%esp
  802223:	68 07 04 00 00       	push   $0x407
  802228:	50                   	push   %eax
  802229:	6a 00                	push   $0x0
  80222b:	e8 d4 eb ff ff       	call   800e04 <sys_page_alloc>
  802230:	89 c3                	mov    %eax,%ebx
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 88 82 00 00 00    	js     8022bf <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223d:	83 ec 0c             	sub    $0xc,%esp
  802240:	ff 75 f0             	pushl  -0x10(%ebp)
  802243:	e8 ee ef ff ff       	call   801236 <fd2data>
  802248:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80224f:	50                   	push   %eax
  802250:	6a 00                	push   $0x0
  802252:	56                   	push   %esi
  802253:	6a 00                	push   $0x0
  802255:	e8 ed eb ff ff       	call   800e47 <sys_page_map>
  80225a:	89 c3                	mov    %eax,%ebx
  80225c:	83 c4 20             	add    $0x20,%esp
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 4e                	js     8022b1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802263:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80226d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802270:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	ff 75 f4             	pushl  -0xc(%ebp)
  80228c:	e8 95 ef ff ff       	call   801226 <fd2num>
  802291:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802294:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802296:	83 c4 04             	add    $0x4,%esp
  802299:	ff 75 f0             	pushl  -0x10(%ebp)
  80229c:	e8 85 ef ff ff       	call   801226 <fd2num>
  8022a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022a4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022af:	eb 2e                	jmp    8022df <pipe+0x141>
	sys_page_unmap(0, va);
  8022b1:	83 ec 08             	sub    $0x8,%esp
  8022b4:	56                   	push   %esi
  8022b5:	6a 00                	push   $0x0
  8022b7:	e8 cd eb ff ff       	call   800e89 <sys_page_unmap>
  8022bc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022bf:	83 ec 08             	sub    $0x8,%esp
  8022c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c5:	6a 00                	push   $0x0
  8022c7:	e8 bd eb ff ff       	call   800e89 <sys_page_unmap>
  8022cc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022cf:	83 ec 08             	sub    $0x8,%esp
  8022d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d5:	6a 00                	push   $0x0
  8022d7:	e8 ad eb ff ff       	call   800e89 <sys_page_unmap>
  8022dc:	83 c4 10             	add    $0x10,%esp
}
  8022df:	89 d8                	mov    %ebx,%eax
  8022e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    

008022e8 <pipeisclosed>:
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f1:	50                   	push   %eax
  8022f2:	ff 75 08             	pushl  0x8(%ebp)
  8022f5:	e8 a5 ef ff ff       	call   80129f <fd_lookup>
  8022fa:	83 c4 10             	add    $0x10,%esp
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	78 18                	js     802319 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802301:	83 ec 0c             	sub    $0xc,%esp
  802304:	ff 75 f4             	pushl  -0xc(%ebp)
  802307:	e8 2a ef ff ff       	call   801236 <fd2data>
	return _pipeisclosed(fd, p);
  80230c:	89 c2                	mov    %eax,%edx
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	e8 2f fd ff ff       	call   802045 <_pipeisclosed>
  802316:	83 c4 10             	add    $0x10,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	c3                   	ret    

00802321 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802327:	68 ef 2d 80 00       	push   $0x802def
  80232c:	ff 75 0c             	pushl  0xc(%ebp)
  80232f:	e8 de e6 ff ff       	call   800a12 <strcpy>
	return 0;
}
  802334:	b8 00 00 00 00       	mov    $0x0,%eax
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <devcons_write>:
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	57                   	push   %edi
  80233f:	56                   	push   %esi
  802340:	53                   	push   %ebx
  802341:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802347:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80234c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802352:	3b 75 10             	cmp    0x10(%ebp),%esi
  802355:	73 31                	jae    802388 <devcons_write+0x4d>
		m = n - tot;
  802357:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80235a:	29 f3                	sub    %esi,%ebx
  80235c:	83 fb 7f             	cmp    $0x7f,%ebx
  80235f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802364:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	53                   	push   %ebx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	03 45 0c             	add    0xc(%ebp),%eax
  802370:	50                   	push   %eax
  802371:	57                   	push   %edi
  802372:	e8 29 e8 ff ff       	call   800ba0 <memmove>
		sys_cputs(buf, m);
  802377:	83 c4 08             	add    $0x8,%esp
  80237a:	53                   	push   %ebx
  80237b:	57                   	push   %edi
  80237c:	e8 c7 e9 ff ff       	call   800d48 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802381:	01 de                	add    %ebx,%esi
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	eb ca                	jmp    802352 <devcons_write+0x17>
}
  802388:	89 f0                	mov    %esi,%eax
  80238a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238d:	5b                   	pop    %ebx
  80238e:	5e                   	pop    %esi
  80238f:	5f                   	pop    %edi
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    

00802392 <devcons_read>:
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 08             	sub    $0x8,%esp
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80239d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023a1:	74 21                	je     8023c4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8023a3:	e8 be e9 ff ff       	call   800d66 <sys_cgetc>
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	75 07                	jne    8023b3 <devcons_read+0x21>
		sys_yield();
  8023ac:	e8 34 ea ff ff       	call   800de5 <sys_yield>
  8023b1:	eb f0                	jmp    8023a3 <devcons_read+0x11>
	if (c < 0)
  8023b3:	78 0f                	js     8023c4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8023b5:	83 f8 04             	cmp    $0x4,%eax
  8023b8:	74 0c                	je     8023c6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8023ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bd:	88 02                	mov    %al,(%edx)
	return 1;
  8023bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    
		return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	eb f7                	jmp    8023c4 <devcons_read+0x32>

008023cd <cputchar>:
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023d9:	6a 01                	push   $0x1
  8023db:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023de:	50                   	push   %eax
  8023df:	e8 64 e9 ff ff       	call   800d48 <sys_cputs>
}
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <getchar>:
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023ef:	6a 01                	push   $0x1
  8023f1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023f4:	50                   	push   %eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	e8 13 f1 ff ff       	call   80150f <read>
	if (r < 0)
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 06                	js     802409 <getchar+0x20>
	if (r < 1)
  802403:	74 06                	je     80240b <getchar+0x22>
	return c;
  802405:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    
		return -E_EOF;
  80240b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802410:	eb f7                	jmp    802409 <getchar+0x20>

00802412 <iscons>:
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80241b:	50                   	push   %eax
  80241c:	ff 75 08             	pushl  0x8(%ebp)
  80241f:	e8 7b ee ff ff       	call   80129f <fd_lookup>
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	85 c0                	test   %eax,%eax
  802429:	78 11                	js     80243c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802434:	39 10                	cmp    %edx,(%eax)
  802436:	0f 94 c0             	sete   %al
  802439:	0f b6 c0             	movzbl %al,%eax
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <opencons>:
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802447:	50                   	push   %eax
  802448:	e8 00 ee ff ff       	call   80124d <fd_alloc>
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	85 c0                	test   %eax,%eax
  802452:	78 3a                	js     80248e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 07 04 00 00       	push   $0x407
  80245c:	ff 75 f4             	pushl  -0xc(%ebp)
  80245f:	6a 00                	push   $0x0
  802461:	e8 9e e9 ff ff       	call   800e04 <sys_page_alloc>
  802466:	83 c4 10             	add    $0x10,%esp
  802469:	85 c0                	test   %eax,%eax
  80246b:	78 21                	js     80248e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802476:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802482:	83 ec 0c             	sub    $0xc,%esp
  802485:	50                   	push   %eax
  802486:	e8 9b ed ff ff       	call   801226 <fd2num>
  80248b:	83 c4 10             	add    $0x10,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	56                   	push   %esi
  802494:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802495:	a1 08 40 80 00       	mov    0x804008,%eax
  80249a:	8b 40 48             	mov    0x48(%eax),%eax
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 20 2e 80 00       	push   $0x802e20
  8024a5:	50                   	push   %eax
  8024a6:	68 14 29 80 00       	push   $0x802914
  8024ab:	e8 03 de ff ff       	call   8002b3 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8024b0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024b3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024b9:	e8 08 e9 ff ff       	call   800dc6 <sys_getenvid>
  8024be:	83 c4 04             	add    $0x4,%esp
  8024c1:	ff 75 0c             	pushl  0xc(%ebp)
  8024c4:	ff 75 08             	pushl  0x8(%ebp)
  8024c7:	56                   	push   %esi
  8024c8:	50                   	push   %eax
  8024c9:	68 fc 2d 80 00       	push   $0x802dfc
  8024ce:	e8 e0 dd ff ff       	call   8002b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024d3:	83 c4 18             	add    $0x18,%esp
  8024d6:	53                   	push   %ebx
  8024d7:	ff 75 10             	pushl  0x10(%ebp)
  8024da:	e8 83 dd ff ff       	call   800262 <vcprintf>
	cprintf("\n");
  8024df:	c7 04 24 d8 28 80 00 	movl   $0x8028d8,(%esp)
  8024e6:	e8 c8 dd ff ff       	call   8002b3 <cprintf>
  8024eb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024ee:	cc                   	int3   
  8024ef:	eb fd                	jmp    8024ee <_panic+0x5e>

008024f1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	56                   	push   %esi
  8024f5:	53                   	push   %ebx
  8024f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8024f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8024ff:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802501:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802506:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	50                   	push   %eax
  80250d:	e8 a2 ea ff ff       	call   800fb4 <sys_ipc_recv>
	if(ret < 0){
  802512:	83 c4 10             	add    $0x10,%esp
  802515:	85 c0                	test   %eax,%eax
  802517:	78 2b                	js     802544 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802519:	85 f6                	test   %esi,%esi
  80251b:	74 0a                	je     802527 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80251d:	a1 08 40 80 00       	mov    0x804008,%eax
  802522:	8b 40 74             	mov    0x74(%eax),%eax
  802525:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802527:	85 db                	test   %ebx,%ebx
  802529:	74 0a                	je     802535 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80252b:	a1 08 40 80 00       	mov    0x804008,%eax
  802530:	8b 40 78             	mov    0x78(%eax),%eax
  802533:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802535:	a1 08 40 80 00       	mov    0x804008,%eax
  80253a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80253d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
		if(from_env_store)
  802544:	85 f6                	test   %esi,%esi
  802546:	74 06                	je     80254e <ipc_recv+0x5d>
			*from_env_store = 0;
  802548:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80254e:	85 db                	test   %ebx,%ebx
  802550:	74 eb                	je     80253d <ipc_recv+0x4c>
			*perm_store = 0;
  802552:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802558:	eb e3                	jmp    80253d <ipc_recv+0x4c>

0080255a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	8b 7d 08             	mov    0x8(%ebp),%edi
  802566:	8b 75 0c             	mov    0xc(%ebp),%esi
  802569:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80256c:	85 db                	test   %ebx,%ebx
  80256e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802573:	0f 44 d8             	cmove  %eax,%ebx
  802576:	eb 05                	jmp    80257d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802578:	e8 68 e8 ff ff       	call   800de5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80257d:	ff 75 14             	pushl  0x14(%ebp)
  802580:	53                   	push   %ebx
  802581:	56                   	push   %esi
  802582:	57                   	push   %edi
  802583:	e8 09 ea ff ff       	call   800f91 <sys_ipc_try_send>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 1b                	je     8025aa <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80258f:	79 e7                	jns    802578 <ipc_send+0x1e>
  802591:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802594:	74 e2                	je     802578 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 27 2e 80 00       	push   $0x802e27
  80259e:	6a 46                	push   $0x46
  8025a0:	68 3c 2e 80 00       	push   $0x802e3c
  8025a5:	e8 e6 fe ff ff       	call   802490 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8025aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5e                   	pop    %esi
  8025af:	5f                   	pop    %edi
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    

008025b2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	c1 e2 07             	shl    $0x7,%edx
  8025c2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025c8:	8b 52 50             	mov    0x50(%edx),%edx
  8025cb:	39 ca                	cmp    %ecx,%edx
  8025cd:	74 11                	je     8025e0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8025cf:	83 c0 01             	add    $0x1,%eax
  8025d2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025d7:	75 e4                	jne    8025bd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025de:	eb 0b                	jmp    8025eb <ipc_find_env+0x39>
			return envs[i].env_id;
  8025e0:	c1 e0 07             	shl    $0x7,%eax
  8025e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025e8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025eb:	5d                   	pop    %ebp
  8025ec:	c3                   	ret    

008025ed <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025f3:	89 d0                	mov    %edx,%eax
  8025f5:	c1 e8 16             	shr    $0x16,%eax
  8025f8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802604:	f6 c1 01             	test   $0x1,%cl
  802607:	74 1d                	je     802626 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802609:	c1 ea 0c             	shr    $0xc,%edx
  80260c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802613:	f6 c2 01             	test   $0x1,%dl
  802616:	74 0e                	je     802626 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802618:	c1 ea 0c             	shr    $0xc,%edx
  80261b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802622:	ef 
  802623:	0f b7 c0             	movzwl %ax,%eax
}
  802626:	5d                   	pop    %ebp
  802627:	c3                   	ret    
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__udivdi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80263b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80263f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802643:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802647:	85 d2                	test   %edx,%edx
  802649:	75 4d                	jne    802698 <__udivdi3+0x68>
  80264b:	39 f3                	cmp    %esi,%ebx
  80264d:	76 19                	jbe    802668 <__udivdi3+0x38>
  80264f:	31 ff                	xor    %edi,%edi
  802651:	89 e8                	mov    %ebp,%eax
  802653:	89 f2                	mov    %esi,%edx
  802655:	f7 f3                	div    %ebx
  802657:	89 fa                	mov    %edi,%edx
  802659:	83 c4 1c             	add    $0x1c,%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    
  802661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802668:	89 d9                	mov    %ebx,%ecx
  80266a:	85 db                	test   %ebx,%ebx
  80266c:	75 0b                	jne    802679 <__udivdi3+0x49>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f3                	div    %ebx
  802677:	89 c1                	mov    %eax,%ecx
  802679:	31 d2                	xor    %edx,%edx
  80267b:	89 f0                	mov    %esi,%eax
  80267d:	f7 f1                	div    %ecx
  80267f:	89 c6                	mov    %eax,%esi
  802681:	89 e8                	mov    %ebp,%eax
  802683:	89 f7                	mov    %esi,%edi
  802685:	f7 f1                	div    %ecx
  802687:	89 fa                	mov    %edi,%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	39 f2                	cmp    %esi,%edx
  80269a:	77 1c                	ja     8026b8 <__udivdi3+0x88>
  80269c:	0f bd fa             	bsr    %edx,%edi
  80269f:	83 f7 1f             	xor    $0x1f,%edi
  8026a2:	75 2c                	jne    8026d0 <__udivdi3+0xa0>
  8026a4:	39 f2                	cmp    %esi,%edx
  8026a6:	72 06                	jb     8026ae <__udivdi3+0x7e>
  8026a8:	31 c0                	xor    %eax,%eax
  8026aa:	39 eb                	cmp    %ebp,%ebx
  8026ac:	77 a9                	ja     802657 <__udivdi3+0x27>
  8026ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b3:	eb a2                	jmp    802657 <__udivdi3+0x27>
  8026b5:	8d 76 00             	lea    0x0(%esi),%esi
  8026b8:	31 ff                	xor    %edi,%edi
  8026ba:	31 c0                	xor    %eax,%eax
  8026bc:	89 fa                	mov    %edi,%edx
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	89 f9                	mov    %edi,%ecx
  8026d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026d7:	29 f8                	sub    %edi,%eax
  8026d9:	d3 e2                	shl    %cl,%edx
  8026db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026df:	89 c1                	mov    %eax,%ecx
  8026e1:	89 da                	mov    %ebx,%edx
  8026e3:	d3 ea                	shr    %cl,%edx
  8026e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e9:	09 d1                	or     %edx,%ecx
  8026eb:	89 f2                	mov    %esi,%edx
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 f9                	mov    %edi,%ecx
  8026f3:	d3 e3                	shl    %cl,%ebx
  8026f5:	89 c1                	mov    %eax,%ecx
  8026f7:	d3 ea                	shr    %cl,%edx
  8026f9:	89 f9                	mov    %edi,%ecx
  8026fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026ff:	89 eb                	mov    %ebp,%ebx
  802701:	d3 e6                	shl    %cl,%esi
  802703:	89 c1                	mov    %eax,%ecx
  802705:	d3 eb                	shr    %cl,%ebx
  802707:	09 de                	or     %ebx,%esi
  802709:	89 f0                	mov    %esi,%eax
  80270b:	f7 74 24 08          	divl   0x8(%esp)
  80270f:	89 d6                	mov    %edx,%esi
  802711:	89 c3                	mov    %eax,%ebx
  802713:	f7 64 24 0c          	mull   0xc(%esp)
  802717:	39 d6                	cmp    %edx,%esi
  802719:	72 15                	jb     802730 <__udivdi3+0x100>
  80271b:	89 f9                	mov    %edi,%ecx
  80271d:	d3 e5                	shl    %cl,%ebp
  80271f:	39 c5                	cmp    %eax,%ebp
  802721:	73 04                	jae    802727 <__udivdi3+0xf7>
  802723:	39 d6                	cmp    %edx,%esi
  802725:	74 09                	je     802730 <__udivdi3+0x100>
  802727:	89 d8                	mov    %ebx,%eax
  802729:	31 ff                	xor    %edi,%edi
  80272b:	e9 27 ff ff ff       	jmp    802657 <__udivdi3+0x27>
  802730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802733:	31 ff                	xor    %edi,%edi
  802735:	e9 1d ff ff ff       	jmp    802657 <__udivdi3+0x27>
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	55                   	push   %ebp
  802741:	57                   	push   %edi
  802742:	56                   	push   %esi
  802743:	53                   	push   %ebx
  802744:	83 ec 1c             	sub    $0x1c,%esp
  802747:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80274b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80274f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802757:	89 da                	mov    %ebx,%edx
  802759:	85 c0                	test   %eax,%eax
  80275b:	75 43                	jne    8027a0 <__umoddi3+0x60>
  80275d:	39 df                	cmp    %ebx,%edi
  80275f:	76 17                	jbe    802778 <__umoddi3+0x38>
  802761:	89 f0                	mov    %esi,%eax
  802763:	f7 f7                	div    %edi
  802765:	89 d0                	mov    %edx,%eax
  802767:	31 d2                	xor    %edx,%edx
  802769:	83 c4 1c             	add    $0x1c,%esp
  80276c:	5b                   	pop    %ebx
  80276d:	5e                   	pop    %esi
  80276e:	5f                   	pop    %edi
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
  802771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802778:	89 fd                	mov    %edi,%ebp
  80277a:	85 ff                	test   %edi,%edi
  80277c:	75 0b                	jne    802789 <__umoddi3+0x49>
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	31 d2                	xor    %edx,%edx
  802785:	f7 f7                	div    %edi
  802787:	89 c5                	mov    %eax,%ebp
  802789:	89 d8                	mov    %ebx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	f7 f5                	div    %ebp
  80278f:	89 f0                	mov    %esi,%eax
  802791:	f7 f5                	div    %ebp
  802793:	89 d0                	mov    %edx,%eax
  802795:	eb d0                	jmp    802767 <__umoddi3+0x27>
  802797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	89 f1                	mov    %esi,%ecx
  8027a2:	39 d8                	cmp    %ebx,%eax
  8027a4:	76 0a                	jbe    8027b0 <__umoddi3+0x70>
  8027a6:	89 f0                	mov    %esi,%eax
  8027a8:	83 c4 1c             	add    $0x1c,%esp
  8027ab:	5b                   	pop    %ebx
  8027ac:	5e                   	pop    %esi
  8027ad:	5f                   	pop    %edi
  8027ae:	5d                   	pop    %ebp
  8027af:	c3                   	ret    
  8027b0:	0f bd e8             	bsr    %eax,%ebp
  8027b3:	83 f5 1f             	xor    $0x1f,%ebp
  8027b6:	75 20                	jne    8027d8 <__umoddi3+0x98>
  8027b8:	39 d8                	cmp    %ebx,%eax
  8027ba:	0f 82 b0 00 00 00    	jb     802870 <__umoddi3+0x130>
  8027c0:	39 f7                	cmp    %esi,%edi
  8027c2:	0f 86 a8 00 00 00    	jbe    802870 <__umoddi3+0x130>
  8027c8:	89 c8                	mov    %ecx,%eax
  8027ca:	83 c4 1c             	add    $0x1c,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5f                   	pop    %edi
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    
  8027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027d8:	89 e9                	mov    %ebp,%ecx
  8027da:	ba 20 00 00 00       	mov    $0x20,%edx
  8027df:	29 ea                	sub    %ebp,%edx
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e7:	89 d1                	mov    %edx,%ecx
  8027e9:	89 f8                	mov    %edi,%eax
  8027eb:	d3 e8                	shr    %cl,%eax
  8027ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027f9:	09 c1                	or     %eax,%ecx
  8027fb:	89 d8                	mov    %ebx,%eax
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 e9                	mov    %ebp,%ecx
  802803:	d3 e7                	shl    %cl,%edi
  802805:	89 d1                	mov    %edx,%ecx
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80280f:	d3 e3                	shl    %cl,%ebx
  802811:	89 c7                	mov    %eax,%edi
  802813:	89 d1                	mov    %edx,%ecx
  802815:	89 f0                	mov    %esi,%eax
  802817:	d3 e8                	shr    %cl,%eax
  802819:	89 e9                	mov    %ebp,%ecx
  80281b:	89 fa                	mov    %edi,%edx
  80281d:	d3 e6                	shl    %cl,%esi
  80281f:	09 d8                	or     %ebx,%eax
  802821:	f7 74 24 08          	divl   0x8(%esp)
  802825:	89 d1                	mov    %edx,%ecx
  802827:	89 f3                	mov    %esi,%ebx
  802829:	f7 64 24 0c          	mull   0xc(%esp)
  80282d:	89 c6                	mov    %eax,%esi
  80282f:	89 d7                	mov    %edx,%edi
  802831:	39 d1                	cmp    %edx,%ecx
  802833:	72 06                	jb     80283b <__umoddi3+0xfb>
  802835:	75 10                	jne    802847 <__umoddi3+0x107>
  802837:	39 c3                	cmp    %eax,%ebx
  802839:	73 0c                	jae    802847 <__umoddi3+0x107>
  80283b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80283f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802843:	89 d7                	mov    %edx,%edi
  802845:	89 c6                	mov    %eax,%esi
  802847:	89 ca                	mov    %ecx,%edx
  802849:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80284e:	29 f3                	sub    %esi,%ebx
  802850:	19 fa                	sbb    %edi,%edx
  802852:	89 d0                	mov    %edx,%eax
  802854:	d3 e0                	shl    %cl,%eax
  802856:	89 e9                	mov    %ebp,%ecx
  802858:	d3 eb                	shr    %cl,%ebx
  80285a:	d3 ea                	shr    %cl,%edx
  80285c:	09 d8                	or     %ebx,%eax
  80285e:	83 c4 1c             	add    $0x1c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	89 da                	mov    %ebx,%edx
  802872:	29 fe                	sub    %edi,%esi
  802874:	19 c2                	sbb    %eax,%edx
  802876:	89 f1                	mov    %esi,%ecx
  802878:	89 c8                	mov    %ecx,%eax
  80287a:	e9 4b ff ff ff       	jmp    8027ca <__umoddi3+0x8a>
