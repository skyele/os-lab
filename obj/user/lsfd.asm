
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
  80003e:	e8 72 02 00 00       	call   8002b5 <cprintf>
	exit();
  800043:	e8 a4 01 00 00       	call   8001ec <exit>
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
  800067:	e8 8f 10 00 00       	call   8010fb <argstart>
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
  800083:	e8 a3 10 00 00       	call   80112b <argnext>
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
  8000c2:	e8 ee 01 00 00       	call   8002b5 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 4b 16 00 00       	call   801727 <fstat>
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
  8000ff:	e8 57 1a 00 00       	call   801b5b <fprintf>
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
  800124:	e8 9f 0c 00 00       	call   800dc8 <sys_getenvid>
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
  800149:	74 23                	je     80016e <libmain+0x5d>
		if(envs[i].env_id == find)
  80014b:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800151:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800157:	8b 49 48             	mov    0x48(%ecx),%ecx
  80015a:	39 c1                	cmp    %eax,%ecx
  80015c:	75 e2                	jne    800140 <libmain+0x2f>
  80015e:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800164:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80016a:	89 fe                	mov    %edi,%esi
  80016c:	eb d2                	jmp    800140 <libmain+0x2f>
  80016e:	89 f0                	mov    %esi,%eax
  800170:	84 c0                	test   %al,%al
  800172:	74 06                	je     80017a <libmain+0x69>
  800174:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017e:	7e 0a                	jle    80018a <libmain+0x79>
		binaryname = argv[0];
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 00                	mov    (%eax),%eax
  800185:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80018a:	a1 08 40 80 00       	mov    0x804008,%eax
  80018f:	8b 40 48             	mov    0x48(%eax),%eax
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	50                   	push   %eax
  800196:	68 dc 28 80 00       	push   $0x8028dc
  80019b:	e8 15 01 00 00       	call   8002b5 <cprintf>
	cprintf("before umain\n");
  8001a0:	c7 04 24 fa 28 80 00 	movl   $0x8028fa,(%esp)
  8001a7:	e8 09 01 00 00       	call   8002b5 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001ac:	83 c4 08             	add    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 93 fe ff ff       	call   80004d <umain>
	cprintf("after umain\n");
  8001ba:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  8001c1:	e8 ef 00 00 00       	call   8002b5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 c4 08             	add    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 15 29 80 00       	push   $0x802915
  8001d7:	e8 d9 00 00 00       	call   8002b5 <cprintf>
	// exit gracefully
	exit();
  8001dc:	e8 0b 00 00 00       	call   8001ec <exit>
}
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    

008001ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8001f7:	8b 40 48             	mov    0x48(%eax),%eax
  8001fa:	68 40 29 80 00       	push   $0x802940
  8001ff:	50                   	push   %eax
  800200:	68 34 29 80 00       	push   $0x802934
  800205:	e8 ab 00 00 00       	call   8002b5 <cprintf>
	close_all();
  80020a:	e8 11 12 00 00       	call   801420 <close_all>
	sys_env_destroy(0);
  80020f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800216:	e8 6c 0b 00 00       	call   800d87 <sys_env_destroy>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022a:	8b 13                	mov    (%ebx),%edx
  80022c:	8d 42 01             	lea    0x1(%edx),%eax
  80022f:	89 03                	mov    %eax,(%ebx)
  800231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800234:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800238:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023d:	74 09                	je     800248 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80023f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800246:	c9                   	leave  
  800247:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	68 ff 00 00 00       	push   $0xff
  800250:	8d 43 08             	lea    0x8(%ebx),%eax
  800253:	50                   	push   %eax
  800254:	e8 f1 0a 00 00       	call   800d4a <sys_cputs>
		b->idx = 0;
  800259:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb db                	jmp    80023f <putch+0x1f>

00800264 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800274:	00 00 00 
	b.cnt = 0;
  800277:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800281:	ff 75 0c             	pushl  0xc(%ebp)
  800284:	ff 75 08             	pushl  0x8(%ebp)
  800287:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028d:	50                   	push   %eax
  80028e:	68 20 02 80 00       	push   $0x800220
  800293:	e8 4a 01 00 00       	call   8003e2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800298:	83 c4 08             	add    $0x8,%esp
  80029b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a7:	50                   	push   %eax
  8002a8:	e8 9d 0a 00 00       	call   800d4a <sys_cputs>

	return b.cnt;
}
  8002ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002be:	50                   	push   %eax
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 9d ff ff ff       	call   800264 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	57                   	push   %edi
  8002cd:	56                   	push   %esi
  8002ce:	53                   	push   %ebx
  8002cf:	83 ec 1c             	sub    $0x1c,%esp
  8002d2:	89 c6                	mov    %eax,%esi
  8002d4:	89 d7                	mov    %edx,%edi
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002e8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ec:	74 2c                	je     80031a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002fe:	39 c2                	cmp    %eax,%edx
  800300:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800303:	73 43                	jae    800348 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800305:	83 eb 01             	sub    $0x1,%ebx
  800308:	85 db                	test   %ebx,%ebx
  80030a:	7e 6c                	jle    800378 <printnum+0xaf>
				putch(padc, putdat);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	57                   	push   %edi
  800310:	ff 75 18             	pushl  0x18(%ebp)
  800313:	ff d6                	call   *%esi
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	eb eb                	jmp    800305 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80031a:	83 ec 0c             	sub    $0xc,%esp
  80031d:	6a 20                	push   $0x20
  80031f:	6a 00                	push   $0x0
  800321:	50                   	push   %eax
  800322:	ff 75 e4             	pushl  -0x1c(%ebp)
  800325:	ff 75 e0             	pushl  -0x20(%ebp)
  800328:	89 fa                	mov    %edi,%edx
  80032a:	89 f0                	mov    %esi,%eax
  80032c:	e8 98 ff ff ff       	call   8002c9 <printnum>
		while (--width > 0)
  800331:	83 c4 20             	add    $0x20,%esp
  800334:	83 eb 01             	sub    $0x1,%ebx
  800337:	85 db                	test   %ebx,%ebx
  800339:	7e 65                	jle    8003a0 <printnum+0xd7>
			putch(padc, putdat);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	57                   	push   %edi
  80033f:	6a 20                	push   $0x20
  800341:	ff d6                	call   *%esi
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	eb ec                	jmp    800334 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800348:	83 ec 0c             	sub    $0xc,%esp
  80034b:	ff 75 18             	pushl  0x18(%ebp)
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	53                   	push   %ebx
  800352:	50                   	push   %eax
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	ff 75 dc             	pushl  -0x24(%ebp)
  800359:	ff 75 d8             	pushl  -0x28(%ebp)
  80035c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035f:	ff 75 e0             	pushl  -0x20(%ebp)
  800362:	e8 e9 22 00 00       	call   802650 <__udivdi3>
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	89 fa                	mov    %edi,%edx
  80036e:	89 f0                	mov    %esi,%eax
  800370:	e8 54 ff ff ff       	call   8002c9 <printnum>
  800375:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	57                   	push   %edi
  80037c:	83 ec 04             	sub    $0x4,%esp
  80037f:	ff 75 dc             	pushl  -0x24(%ebp)
  800382:	ff 75 d8             	pushl  -0x28(%ebp)
  800385:	ff 75 e4             	pushl  -0x1c(%ebp)
  800388:	ff 75 e0             	pushl  -0x20(%ebp)
  80038b:	e8 d0 23 00 00       	call   802760 <__umoddi3>
  800390:	83 c4 14             	add    $0x14,%esp
  800393:	0f be 80 45 29 80 00 	movsbl 0x802945(%eax),%eax
  80039a:	50                   	push   %eax
  80039b:	ff d6                	call   *%esi
  80039d:	83 c4 10             	add    $0x10,%esp
	}
}
  8003a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a3:	5b                   	pop    %ebx
  8003a4:	5e                   	pop    %esi
  8003a5:	5f                   	pop    %edi
  8003a6:	5d                   	pop    %ebp
  8003a7:	c3                   	ret    

008003a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ae:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b2:	8b 10                	mov    (%eax),%edx
  8003b4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b7:	73 0a                	jae    8003c3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003bc:	89 08                	mov    %ecx,(%eax)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	88 02                	mov    %al,(%edx)
}
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    

008003c5 <printfmt>:
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003cb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ce:	50                   	push   %eax
  8003cf:	ff 75 10             	pushl  0x10(%ebp)
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	ff 75 08             	pushl  0x8(%ebp)
  8003d8:	e8 05 00 00 00       	call   8003e2 <vprintfmt>
}
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <vprintfmt>:
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	57                   	push   %edi
  8003e6:	56                   	push   %esi
  8003e7:	53                   	push   %ebx
  8003e8:	83 ec 3c             	sub    $0x3c,%esp
  8003eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003f1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f4:	e9 32 04 00 00       	jmp    80082b <vprintfmt+0x449>
		padc = ' ';
  8003f9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800404:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80040b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800412:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800419:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800420:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8d 47 01             	lea    0x1(%edi),%eax
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042b:	0f b6 17             	movzbl (%edi),%edx
  80042e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800431:	3c 55                	cmp    $0x55,%al
  800433:	0f 87 12 05 00 00    	ja     80094b <vprintfmt+0x569>
  800439:	0f b6 c0             	movzbl %al,%eax
  80043c:	ff 24 85 20 2b 80 00 	jmp    *0x802b20(,%eax,4)
  800443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800446:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80044a:	eb d9                	jmp    800425 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80044f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800453:	eb d0                	jmp    800425 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800455:	0f b6 d2             	movzbl %dl,%edx
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	89 75 08             	mov    %esi,0x8(%ebp)
  800463:	eb 03                	jmp    800468 <vprintfmt+0x86>
  800465:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800468:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800472:	8d 72 d0             	lea    -0x30(%edx),%esi
  800475:	83 fe 09             	cmp    $0x9,%esi
  800478:	76 eb                	jbe    800465 <vprintfmt+0x83>
  80047a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047d:	8b 75 08             	mov    0x8(%ebp),%esi
  800480:	eb 14                	jmp    800496 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8d 40 04             	lea    0x4(%eax),%eax
  800490:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049a:	79 89                	jns    800425 <vprintfmt+0x43>
				width = precision, precision = -1;
  80049c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a9:	e9 77 ff ff ff       	jmp    800425 <vprintfmt+0x43>
  8004ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	0f 48 c1             	cmovs  %ecx,%eax
  8004b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004bc:	e9 64 ff ff ff       	jmp    800425 <vprintfmt+0x43>
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004cb:	e9 55 ff ff ff       	jmp    800425 <vprintfmt+0x43>
			lflag++;
  8004d0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004d7:	e9 49 ff ff ff       	jmp    800425 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8d 78 04             	lea    0x4(%eax),%edi
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	ff 30                	pushl  (%eax)
  8004e8:	ff d6                	call   *%esi
			break;
  8004ea:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ed:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f0:	e9 33 03 00 00       	jmp    800828 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8d 78 04             	lea    0x4(%eax),%edi
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	99                   	cltd   
  8004fe:	31 d0                	xor    %edx,%eax
  800500:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800502:	83 f8 11             	cmp    $0x11,%eax
  800505:	7f 23                	jg     80052a <vprintfmt+0x148>
  800507:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 18                	je     80052a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800512:	52                   	push   %edx
  800513:	68 9d 2d 80 00       	push   $0x802d9d
  800518:	53                   	push   %ebx
  800519:	56                   	push   %esi
  80051a:	e8 a6 fe ff ff       	call   8003c5 <printfmt>
  80051f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800522:	89 7d 14             	mov    %edi,0x14(%ebp)
  800525:	e9 fe 02 00 00       	jmp    800828 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80052a:	50                   	push   %eax
  80052b:	68 5d 29 80 00       	push   $0x80295d
  800530:	53                   	push   %ebx
  800531:	56                   	push   %esi
  800532:	e8 8e fe ff ff       	call   8003c5 <printfmt>
  800537:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80053d:	e9 e6 02 00 00       	jmp    800828 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	83 c0 04             	add    $0x4,%eax
  800548:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800550:	85 c9                	test   %ecx,%ecx
  800552:	b8 56 29 80 00       	mov    $0x802956,%eax
  800557:	0f 45 c1             	cmovne %ecx,%eax
  80055a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80055d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800561:	7e 06                	jle    800569 <vprintfmt+0x187>
  800563:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800567:	75 0d                	jne    800576 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056c:	89 c7                	mov    %eax,%edi
  80056e:	03 45 e0             	add    -0x20(%ebp),%eax
  800571:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800574:	eb 53                	jmp    8005c9 <vprintfmt+0x1e7>
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 71 04 00 00       	call   8009f3 <strnlen>
  800582:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800585:	29 c1                	sub    %eax,%ecx
  800587:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80058f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	eb 0f                	jmp    8005a7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	ff 75 e0             	pushl  -0x20(%ebp)
  80059f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 ef 01             	sub    $0x1,%edi
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	85 ff                	test   %edi,%edi
  8005a9:	7f ed                	jg     800598 <vprintfmt+0x1b6>
  8005ab:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c1             	cmovns %ecx,%eax
  8005b8:	29 c1                	sub    %eax,%ecx
  8005ba:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005bd:	eb aa                	jmp    800569 <vprintfmt+0x187>
					putch(ch, putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	52                   	push   %edx
  8005c4:	ff d6                	call   *%esi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005cc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ce:	83 c7 01             	add    $0x1,%edi
  8005d1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d5:	0f be d0             	movsbl %al,%edx
  8005d8:	85 d2                	test   %edx,%edx
  8005da:	74 4b                	je     800627 <vprintfmt+0x245>
  8005dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e0:	78 06                	js     8005e8 <vprintfmt+0x206>
  8005e2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e6:	78 1e                	js     800606 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ec:	74 d1                	je     8005bf <vprintfmt+0x1dd>
  8005ee:	0f be c0             	movsbl %al,%eax
  8005f1:	83 e8 20             	sub    $0x20,%eax
  8005f4:	83 f8 5e             	cmp    $0x5e,%eax
  8005f7:	76 c6                	jbe    8005bf <vprintfmt+0x1dd>
					putch('?', putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	6a 3f                	push   $0x3f
  8005ff:	ff d6                	call   *%esi
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	eb c3                	jmp    8005c9 <vprintfmt+0x1e7>
  800606:	89 cf                	mov    %ecx,%edi
  800608:	eb 0e                	jmp    800618 <vprintfmt+0x236>
				putch(' ', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 20                	push   $0x20
  800610:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800612:	83 ef 01             	sub    $0x1,%edi
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	85 ff                	test   %edi,%edi
  80061a:	7f ee                	jg     80060a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80061c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
  800622:	e9 01 02 00 00       	jmp    800828 <vprintfmt+0x446>
  800627:	89 cf                	mov    %ecx,%edi
  800629:	eb ed                	jmp    800618 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80062e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800635:	e9 eb fd ff ff       	jmp    800425 <vprintfmt+0x43>
	if (lflag >= 2)
  80063a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80063e:	7f 21                	jg     800661 <vprintfmt+0x27f>
	else if (lflag)
  800640:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800644:	74 68                	je     8006ae <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064e:	89 c1                	mov    %eax,%ecx
  800650:	c1 f9 1f             	sar    $0x1f,%ecx
  800653:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
  80065f:	eb 17                	jmp    800678 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800678:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800684:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800688:	78 3f                	js     8006c9 <vprintfmt+0x2e7>
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80068f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800693:	0f 84 71 01 00 00    	je     80080a <vprintfmt+0x428>
				putch('+', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 2b                	push   $0x2b
  80069f:	ff d6                	call   *%esi
  8006a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a9:	e9 5c 01 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b6:	89 c1                	mov    %eax,%ecx
  8006b8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 04             	lea    0x4(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c7:	eb af                	jmp    800678 <vprintfmt+0x296>
				putch('-', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 2d                	push   $0x2d
  8006cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d7:	f7 d8                	neg    %eax
  8006d9:	83 d2 00             	adc    $0x0,%edx
  8006dc:	f7 da                	neg    %edx
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ec:	e9 19 01 00 00       	jmp    80080a <vprintfmt+0x428>
	if (lflag >= 2)
  8006f1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f5:	7f 29                	jg     800720 <vprintfmt+0x33e>
	else if (lflag)
  8006f7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fb:	74 44                	je     800741 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
  800707:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800716:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071b:	e9 ea 00 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 50 04             	mov    0x4(%eax),%edx
  800726:	8b 00                	mov    (%eax),%eax
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 08             	lea    0x8(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073c:	e9 c9 00 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075f:	e9 a6 00 00 00       	jmp    80080a <vprintfmt+0x428>
			putch('0', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 30                	push   $0x30
  80076a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800773:	7f 26                	jg     80079b <vprintfmt+0x3b9>
	else if (lflag)
  800775:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800779:	74 3e                	je     8007b9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800794:	b8 08 00 00 00       	mov    $0x8,%eax
  800799:	eb 6f                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 08             	lea    0x8(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b7:	eb 51                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d7:	eb 31                	jmp    80080a <vprintfmt+0x428>
			putch('0', putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	53                   	push   %ebx
  8007dd:	6a 30                	push   $0x30
  8007df:	ff d6                	call   *%esi
			putch('x', putdat);
  8007e1:	83 c4 08             	add    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 78                	push   $0x78
  8007e7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800805:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80080a:	83 ec 0c             	sub    $0xc,%esp
  80080d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800811:	52                   	push   %edx
  800812:	ff 75 e0             	pushl  -0x20(%ebp)
  800815:	50                   	push   %eax
  800816:	ff 75 dc             	pushl  -0x24(%ebp)
  800819:	ff 75 d8             	pushl  -0x28(%ebp)
  80081c:	89 da                	mov    %ebx,%edx
  80081e:	89 f0                	mov    %esi,%eax
  800820:	e8 a4 fa ff ff       	call   8002c9 <printnum>
			break;
  800825:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082b:	83 c7 01             	add    $0x1,%edi
  80082e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800832:	83 f8 25             	cmp    $0x25,%eax
  800835:	0f 84 be fb ff ff    	je     8003f9 <vprintfmt+0x17>
			if (ch == '\0')
  80083b:	85 c0                	test   %eax,%eax
  80083d:	0f 84 28 01 00 00    	je     80096b <vprintfmt+0x589>
			putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	50                   	push   %eax
  800848:	ff d6                	call   *%esi
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	eb dc                	jmp    80082b <vprintfmt+0x449>
	if (lflag >= 2)
  80084f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800853:	7f 26                	jg     80087b <vprintfmt+0x499>
	else if (lflag)
  800855:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800859:	74 41                	je     80089c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800868:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800874:	b8 10 00 00 00       	mov    $0x10,%eax
  800879:	eb 8f                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8b 50 04             	mov    0x4(%eax),%edx
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800886:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 08             	lea    0x8(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800892:	b8 10 00 00 00       	mov    $0x10,%eax
  800897:	e9 6e ff ff ff       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8d 40 04             	lea    0x4(%eax),%eax
  8008b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ba:	e9 4b ff ff ff       	jmp    80080a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 c0 04             	add    $0x4,%eax
  8008c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	74 14                	je     8008e5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008d1:	8b 13                	mov    (%ebx),%edx
  8008d3:	83 fa 7f             	cmp    $0x7f,%edx
  8008d6:	7f 37                	jg     80090f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008d8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	e9 43 ff ff ff       	jmp    800828 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ea:	bf 79 2a 80 00       	mov    $0x802a79,%edi
							putch(ch, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	50                   	push   %eax
  8008f4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f6:	83 c7 01             	add    $0x1,%edi
  8008f9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	85 c0                	test   %eax,%eax
  800902:	75 eb                	jne    8008ef <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	e9 19 ff ff ff       	jmp    800828 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80090f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800911:	b8 0a 00 00 00       	mov    $0xa,%eax
  800916:	bf b1 2a 80 00       	mov    $0x802ab1,%edi
							putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	50                   	push   %eax
  800920:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800922:	83 c7 01             	add    $0x1,%edi
  800925:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	85 c0                	test   %eax,%eax
  80092e:	75 eb                	jne    80091b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800930:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
  800936:	e9 ed fe ff ff       	jmp    800828 <vprintfmt+0x446>
			putch(ch, putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	53                   	push   %ebx
  80093f:	6a 25                	push   $0x25
  800941:	ff d6                	call   *%esi
			break;
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	e9 dd fe ff ff       	jmp    800828 <vprintfmt+0x446>
			putch('%', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	53                   	push   %ebx
  80094f:	6a 25                	push   $0x25
  800951:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	89 f8                	mov    %edi,%eax
  800958:	eb 03                	jmp    80095d <vprintfmt+0x57b>
  80095a:	83 e8 01             	sub    $0x1,%eax
  80095d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800961:	75 f7                	jne    80095a <vprintfmt+0x578>
  800963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800966:	e9 bd fe ff ff       	jmp    800828 <vprintfmt+0x446>
}
  80096b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5f                   	pop    %edi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 18             	sub    $0x18,%esp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800982:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800986:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800989:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800990:	85 c0                	test   %eax,%eax
  800992:	74 26                	je     8009ba <vsnprintf+0x47>
  800994:	85 d2                	test   %edx,%edx
  800996:	7e 22                	jle    8009ba <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800998:	ff 75 14             	pushl  0x14(%ebp)
  80099b:	ff 75 10             	pushl  0x10(%ebp)
  80099e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	68 a8 03 80 00       	push   $0x8003a8
  8009a7:	e8 36 fa ff ff       	call   8003e2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    
		return -E_INVAL;
  8009ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bf:	eb f7                	jmp    8009b8 <vsnprintf+0x45>

008009c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ca:	50                   	push   %eax
  8009cb:	ff 75 10             	pushl  0x10(%ebp)
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 9a ff ff ff       	call   800973 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ea:	74 05                	je     8009f1 <strlen+0x16>
		n++;
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	eb f5                	jmp    8009e6 <strlen+0xb>
	return n;
}
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800a01:	39 c2                	cmp    %eax,%edx
  800a03:	74 0d                	je     800a12 <strnlen+0x1f>
  800a05:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a09:	74 05                	je     800a10 <strnlen+0x1d>
		n++;
  800a0b:	83 c2 01             	add    $0x1,%edx
  800a0e:	eb f1                	jmp    800a01 <strnlen+0xe>
  800a10:	89 d0                	mov    %edx,%eax
	return n;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a23:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a27:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a2a:	83 c2 01             	add    $0x1,%edx
  800a2d:	84 c9                	test   %cl,%cl
  800a2f:	75 f2                	jne    800a23 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a31:	5b                   	pop    %ebx
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	53                   	push   %ebx
  800a38:	83 ec 10             	sub    $0x10,%esp
  800a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a3e:	53                   	push   %ebx
  800a3f:	e8 97 ff ff ff       	call   8009db <strlen>
  800a44:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	01 d8                	add    %ebx,%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 c2 ff ff ff       	call   800a14 <strcpy>
	return dst;
}
  800a52:	89 d8                	mov    %ebx,%eax
  800a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a64:	89 c6                	mov    %eax,%esi
  800a66:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	39 f2                	cmp    %esi,%edx
  800a6d:	74 11                	je     800a80 <strncpy+0x27>
		*dst++ = *src;
  800a6f:	83 c2 01             	add    $0x1,%edx
  800a72:	0f b6 19             	movzbl (%ecx),%ebx
  800a75:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a78:	80 fb 01             	cmp    $0x1,%bl
  800a7b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a7e:	eb eb                	jmp    800a6b <strncpy+0x12>
	}
	return ret;
}
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8f:	8b 55 10             	mov    0x10(%ebp),%edx
  800a92:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a94:	85 d2                	test   %edx,%edx
  800a96:	74 21                	je     800ab9 <strlcpy+0x35>
  800a98:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a9c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a9e:	39 c2                	cmp    %eax,%edx
  800aa0:	74 14                	je     800ab6 <strlcpy+0x32>
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	84 db                	test   %bl,%bl
  800aa7:	74 0b                	je     800ab4 <strlcpy+0x30>
			*dst++ = *src++;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	83 c2 01             	add    $0x1,%edx
  800aaf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab2:	eb ea                	jmp    800a9e <strlcpy+0x1a>
  800ab4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab9:	29 f0                	sub    %esi,%eax
}
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac8:	0f b6 01             	movzbl (%ecx),%eax
  800acb:	84 c0                	test   %al,%al
  800acd:	74 0c                	je     800adb <strcmp+0x1c>
  800acf:	3a 02                	cmp    (%edx),%al
  800ad1:	75 08                	jne    800adb <strcmp+0x1c>
		p++, q++;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	eb ed                	jmp    800ac8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800adb:	0f b6 c0             	movzbl %al,%eax
  800ade:	0f b6 12             	movzbl (%edx),%edx
  800ae1:	29 d0                	sub    %edx,%eax
}
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aef:	89 c3                	mov    %eax,%ebx
  800af1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af4:	eb 06                	jmp    800afc <strncmp+0x17>
		n--, p++, q++;
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afc:	39 d8                	cmp    %ebx,%eax
  800afe:	74 16                	je     800b16 <strncmp+0x31>
  800b00:	0f b6 08             	movzbl (%eax),%ecx
  800b03:	84 c9                	test   %cl,%cl
  800b05:	74 04                	je     800b0b <strncmp+0x26>
  800b07:	3a 0a                	cmp    (%edx),%cl
  800b09:	74 eb                	je     800af6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0b:	0f b6 00             	movzbl (%eax),%eax
  800b0e:	0f b6 12             	movzbl (%edx),%edx
  800b11:	29 d0                	sub    %edx,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    
		return 0;
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1b:	eb f6                	jmp    800b13 <strncmp+0x2e>

00800b1d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b27:	0f b6 10             	movzbl (%eax),%edx
  800b2a:	84 d2                	test   %dl,%dl
  800b2c:	74 09                	je     800b37 <strchr+0x1a>
		if (*s == c)
  800b2e:	38 ca                	cmp    %cl,%dl
  800b30:	74 0a                	je     800b3c <strchr+0x1f>
	for (; *s; s++)
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	eb f0                	jmp    800b27 <strchr+0xa>
			return (char *) s;
	return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b48:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b4b:	38 ca                	cmp    %cl,%dl
  800b4d:	74 09                	je     800b58 <strfind+0x1a>
  800b4f:	84 d2                	test   %dl,%dl
  800b51:	74 05                	je     800b58 <strfind+0x1a>
	for (; *s; s++)
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	eb f0                	jmp    800b48 <strfind+0xa>
			break;
	return (char *) s;
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b66:	85 c9                	test   %ecx,%ecx
  800b68:	74 31                	je     800b9b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6a:	89 f8                	mov    %edi,%eax
  800b6c:	09 c8                	or     %ecx,%eax
  800b6e:	a8 03                	test   $0x3,%al
  800b70:	75 23                	jne    800b95 <memset+0x3b>
		c &= 0xFF;
  800b72:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	c1 e3 08             	shl    $0x8,%ebx
  800b7b:	89 d0                	mov    %edx,%eax
  800b7d:	c1 e0 18             	shl    $0x18,%eax
  800b80:	89 d6                	mov    %edx,%esi
  800b82:	c1 e6 10             	shl    $0x10,%esi
  800b85:	09 f0                	or     %esi,%eax
  800b87:	09 c2                	or     %eax,%edx
  800b89:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	fc                   	cld    
  800b91:	f3 ab                	rep stos %eax,%es:(%edi)
  800b93:	eb 06                	jmp    800b9b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	fc                   	cld    
  800b99:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9b:	89 f8                	mov    %edi,%eax
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb0:	39 c6                	cmp    %eax,%esi
  800bb2:	73 32                	jae    800be6 <memmove+0x44>
  800bb4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	76 2b                	jbe    800be6 <memmove+0x44>
		s += n;
		d += n;
  800bbb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbe:	89 fe                	mov    %edi,%esi
  800bc0:	09 ce                	or     %ecx,%esi
  800bc2:	09 d6                	or     %edx,%esi
  800bc4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bca:	75 0e                	jne    800bda <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bcc:	83 ef 04             	sub    $0x4,%edi
  800bcf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bd5:	fd                   	std    
  800bd6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd8:	eb 09                	jmp    800be3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bda:	83 ef 01             	sub    $0x1,%edi
  800bdd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be0:	fd                   	std    
  800be1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be3:	fc                   	cld    
  800be4:	eb 1a                	jmp    800c00 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	09 ca                	or     %ecx,%edx
  800bea:	09 f2                	or     %esi,%edx
  800bec:	f6 c2 03             	test   $0x3,%dl
  800bef:	75 0a                	jne    800bfb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf4:	89 c7                	mov    %eax,%edi
  800bf6:	fc                   	cld    
  800bf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf9:	eb 05                	jmp    800c00 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bfb:	89 c7                	mov    %eax,%edi
  800bfd:	fc                   	cld    
  800bfe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0a:	ff 75 10             	pushl  0x10(%ebp)
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 08             	pushl  0x8(%ebp)
  800c13:	e8 8a ff ff ff       	call   800ba2 <memmove>
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c25:	89 c6                	mov    %eax,%esi
  800c27:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2a:	39 f0                	cmp    %esi,%eax
  800c2c:	74 1c                	je     800c4a <memcmp+0x30>
		if (*s1 != *s2)
  800c2e:	0f b6 08             	movzbl (%eax),%ecx
  800c31:	0f b6 1a             	movzbl (%edx),%ebx
  800c34:	38 d9                	cmp    %bl,%cl
  800c36:	75 08                	jne    800c40 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c38:	83 c0 01             	add    $0x1,%eax
  800c3b:	83 c2 01             	add    $0x1,%edx
  800c3e:	eb ea                	jmp    800c2a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c40:	0f b6 c1             	movzbl %cl,%eax
  800c43:	0f b6 db             	movzbl %bl,%ebx
  800c46:	29 d8                	sub    %ebx,%eax
  800c48:	eb 05                	jmp    800c4f <memcmp+0x35>
	}

	return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5c:	89 c2                	mov    %eax,%edx
  800c5e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c61:	39 d0                	cmp    %edx,%eax
  800c63:	73 09                	jae    800c6e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c65:	38 08                	cmp    %cl,(%eax)
  800c67:	74 05                	je     800c6e <memfind+0x1b>
	for (; s < ends; s++)
  800c69:	83 c0 01             	add    $0x1,%eax
  800c6c:	eb f3                	jmp    800c61 <memfind+0xe>
			break;
	return (void *) s;
}
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7c:	eb 03                	jmp    800c81 <strtol+0x11>
		s++;
  800c7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c81:	0f b6 01             	movzbl (%ecx),%eax
  800c84:	3c 20                	cmp    $0x20,%al
  800c86:	74 f6                	je     800c7e <strtol+0xe>
  800c88:	3c 09                	cmp    $0x9,%al
  800c8a:	74 f2                	je     800c7e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c8c:	3c 2b                	cmp    $0x2b,%al
  800c8e:	74 2a                	je     800cba <strtol+0x4a>
	int neg = 0;
  800c90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c95:	3c 2d                	cmp    $0x2d,%al
  800c97:	74 2b                	je     800cc4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c9f:	75 0f                	jne    800cb0 <strtol+0x40>
  800ca1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca4:	74 28                	je     800cce <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca6:	85 db                	test   %ebx,%ebx
  800ca8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cad:	0f 44 d8             	cmove  %eax,%ebx
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb8:	eb 50                	jmp    800d0a <strtol+0x9a>
		s++;
  800cba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc2:	eb d5                	jmp    800c99 <strtol+0x29>
		s++, neg = 1;
  800cc4:	83 c1 01             	add    $0x1,%ecx
  800cc7:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccc:	eb cb                	jmp    800c99 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cce:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd2:	74 0e                	je     800ce2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	75 d8                	jne    800cb0 <strtol+0x40>
		s++, base = 8;
  800cd8:	83 c1 01             	add    $0x1,%ecx
  800cdb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce0:	eb ce                	jmp    800cb0 <strtol+0x40>
		s += 2, base = 16;
  800ce2:	83 c1 02             	add    $0x2,%ecx
  800ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cea:	eb c4                	jmp    800cb0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cef:	89 f3                	mov    %esi,%ebx
  800cf1:	80 fb 19             	cmp    $0x19,%bl
  800cf4:	77 29                	ja     800d1f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf6:	0f be d2             	movsbl %dl,%edx
  800cf9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cff:	7d 30                	jge    800d31 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d01:	83 c1 01             	add    $0x1,%ecx
  800d04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0a:	0f b6 11             	movzbl (%ecx),%edx
  800d0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d10:	89 f3                	mov    %esi,%ebx
  800d12:	80 fb 09             	cmp    $0x9,%bl
  800d15:	77 d5                	ja     800cec <strtol+0x7c>
			dig = *s - '0';
  800d17:	0f be d2             	movsbl %dl,%edx
  800d1a:	83 ea 30             	sub    $0x30,%edx
  800d1d:	eb dd                	jmp    800cfc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d22:	89 f3                	mov    %esi,%ebx
  800d24:	80 fb 19             	cmp    $0x19,%bl
  800d27:	77 08                	ja     800d31 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d29:	0f be d2             	movsbl %dl,%edx
  800d2c:	83 ea 37             	sub    $0x37,%edx
  800d2f:	eb cb                	jmp    800cfc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d35:	74 05                	je     800d3c <strtol+0xcc>
		*endptr = (char *) s;
  800d37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3c:	89 c2                	mov    %eax,%edx
  800d3e:	f7 da                	neg    %edx
  800d40:	85 ff                	test   %edi,%edi
  800d42:	0f 45 c2             	cmovne %edx,%eax
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	89 c3                	mov    %eax,%ebx
  800d5d:	89 c7                	mov    %eax,%edi
  800d5f:	89 c6                	mov    %eax,%esi
  800d61:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 01 00 00 00       	mov    $0x1,%eax
  800d78:	89 d1                	mov    %edx,%ecx
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	89 d7                	mov    %edx,%edi
  800d7e:	89 d6                	mov    %edx,%esi
  800d80:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9d:	89 cb                	mov    %ecx,%ebx
  800d9f:	89 cf                	mov    %ecx,%edi
  800da1:	89 ce                	mov    %ecx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 03                	push   $0x3
  800db7:	68 c8 2c 80 00       	push   $0x802cc8
  800dbc:	6a 43                	push   $0x43
  800dbe:	68 e5 2c 80 00       	push   $0x802ce5
  800dc3:	e8 ea 16 00 00       	call   8024b2 <_panic>

00800dc8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_yield>:

void
sys_yield(void)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df7:	89 d1                	mov    %edx,%ecx
  800df9:	89 d3                	mov    %edx,%ebx
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	89 f7                	mov    %esi,%edi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 04                	push   $0x4
  800e38:	68 c8 2c 80 00       	push   $0x802cc8
  800e3d:	6a 43                	push   $0x43
  800e3f:	68 e5 2c 80 00       	push   $0x802ce5
  800e44:	e8 69 16 00 00       	call   8024b2 <_panic>

00800e49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e63:	8b 75 18             	mov    0x18(%ebp),%esi
  800e66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 05                	push   $0x5
  800e7a:	68 c8 2c 80 00       	push   $0x802cc8
  800e7f:	6a 43                	push   $0x43
  800e81:	68 e5 2c 80 00       	push   $0x802ce5
  800e86:	e8 27 16 00 00       	call   8024b2 <_panic>

00800e8b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 06                	push   $0x6
  800ebc:	68 c8 2c 80 00       	push   $0x802cc8
  800ec1:	6a 43                	push   $0x43
  800ec3:	68 e5 2c 80 00       	push   $0x802ce5
  800ec8:	e8 e5 15 00 00       	call   8024b2 <_panic>

00800ecd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 08                	push   $0x8
  800efe:	68 c8 2c 80 00       	push   $0x802cc8
  800f03:	6a 43                	push   $0x43
  800f05:	68 e5 2c 80 00       	push   $0x802ce5
  800f0a:	e8 a3 15 00 00       	call   8024b2 <_panic>

00800f0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 09 00 00 00       	mov    $0x9,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 09                	push   $0x9
  800f40:	68 c8 2c 80 00       	push   $0x802cc8
  800f45:	6a 43                	push   $0x43
  800f47:	68 e5 2c 80 00       	push   $0x802ce5
  800f4c:	e8 61 15 00 00       	call   8024b2 <_panic>

00800f51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	89 de                	mov    %ebx,%esi
  800f6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7f 08                	jg     800f7c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	6a 0a                	push   $0xa
  800f82:	68 c8 2c 80 00       	push   $0x802cc8
  800f87:	6a 43                	push   $0x43
  800f89:	68 e5 2c 80 00       	push   $0x802ce5
  800f8e:	e8 1f 15 00 00       	call   8024b2 <_panic>

00800f93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa4:	be 00 00 00 00       	mov    $0x0,%esi
  800fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800faf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fcc:	89 cb                	mov    %ecx,%ebx
  800fce:	89 cf                	mov    %ecx,%edi
  800fd0:	89 ce                	mov    %ecx,%esi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 0d                	push   $0xd
  800fe6:	68 c8 2c 80 00       	push   $0x802cc8
  800feb:	6a 43                	push   $0x43
  800fed:	68 e5 2c 80 00       	push   $0x802ce5
  800ff2:	e8 bb 14 00 00       	call   8024b2 <_panic>

00800ff7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100d:	89 df                	mov    %ebx,%edi
  80100f:	89 de                	mov    %ebx,%esi
  801011:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102b:	89 cb                	mov    %ecx,%ebx
  80102d:	89 cf                	mov    %ecx,%edi
  80102f:	89 ce                	mov    %ecx,%esi
  801031:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	b8 10 00 00 00       	mov    $0x10,%eax
  801048:	89 d1                	mov    %edx,%ecx
  80104a:	89 d3                	mov    %edx,%ebx
  80104c:	89 d7                	mov    %edx,%edi
  80104e:	89 d6                	mov    %edx,%esi
  801050:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801068:	b8 11 00 00 00       	mov    $0x11,%eax
  80106d:	89 df                	mov    %ebx,%edi
  80106f:	89 de                	mov    %ebx,%esi
  801071:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	b8 12 00 00 00       	mov    $0x12,%eax
  80108e:	89 df                	mov    %ebx,%edi
  801090:	89 de                	mov    %ebx,%esi
  801092:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	b8 13 00 00 00       	mov    $0x13,%eax
  8010b2:	89 df                	mov    %ebx,%edi
  8010b4:	89 de                	mov    %ebx,%esi
  8010b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	7f 08                	jg     8010c4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	50                   	push   %eax
  8010c8:	6a 13                	push   $0x13
  8010ca:	68 c8 2c 80 00       	push   $0x802cc8
  8010cf:	6a 43                	push   $0x43
  8010d1:	68 e5 2c 80 00       	push   $0x802ce5
  8010d6:	e8 d7 13 00 00       	call   8024b2 <_panic>

008010db <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	b8 14 00 00 00       	mov    $0x14,%eax
  8010ee:	89 cb                	mov    %ecx,%ebx
  8010f0:	89 cf                	mov    %ecx,%edi
  8010f2:	89 ce                	mov    %ecx,%esi
  8010f4:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010f6:	5b                   	pop    %ebx
  8010f7:	5e                   	pop    %esi
  8010f8:	5f                   	pop    %edi
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801107:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801109:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80110c:	83 3a 01             	cmpl   $0x1,(%edx)
  80110f:	7e 09                	jle    80111a <argstart+0x1f>
  801111:	ba f9 28 80 00       	mov    $0x8028f9,%edx
  801116:	85 c9                	test   %ecx,%ecx
  801118:	75 05                	jne    80111f <argstart+0x24>
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801122:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <argnext>:

int
argnext(struct Argstate *args)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	53                   	push   %ebx
  80112f:	83 ec 04             	sub    $0x4,%esp
  801132:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801135:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80113c:	8b 43 08             	mov    0x8(%ebx),%eax
  80113f:	85 c0                	test   %eax,%eax
  801141:	74 72                	je     8011b5 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801143:	80 38 00             	cmpb   $0x0,(%eax)
  801146:	75 48                	jne    801190 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801148:	8b 0b                	mov    (%ebx),%ecx
  80114a:	83 39 01             	cmpl   $0x1,(%ecx)
  80114d:	74 58                	je     8011a7 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80114f:	8b 53 04             	mov    0x4(%ebx),%edx
  801152:	8b 42 04             	mov    0x4(%edx),%eax
  801155:	80 38 2d             	cmpb   $0x2d,(%eax)
  801158:	75 4d                	jne    8011a7 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80115a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80115e:	74 47                	je     8011a7 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801160:	83 c0 01             	add    $0x1,%eax
  801163:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	8b 01                	mov    (%ecx),%eax
  80116b:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801172:	50                   	push   %eax
  801173:	8d 42 08             	lea    0x8(%edx),%eax
  801176:	50                   	push   %eax
  801177:	83 c2 04             	add    $0x4,%edx
  80117a:	52                   	push   %edx
  80117b:	e8 22 fa ff ff       	call   800ba2 <memmove>
		(*args->argc)--;
  801180:	8b 03                	mov    (%ebx),%eax
  801182:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801185:	8b 43 08             	mov    0x8(%ebx),%eax
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80118e:	74 11                	je     8011a1 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801190:	8b 53 08             	mov    0x8(%ebx),%edx
  801193:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801196:	83 c2 01             	add    $0x1,%edx
  801199:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80119c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011a1:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011a5:	75 e9                	jne    801190 <argnext+0x65>
	args->curarg = 0;
  8011a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8011ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011b3:	eb e7                	jmp    80119c <argnext+0x71>
		return -1;
  8011b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011ba:	eb e0                	jmp    80119c <argnext+0x71>

008011bc <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 04             	sub    $0x4,%esp
  8011c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8011c6:	8b 43 08             	mov    0x8(%ebx),%eax
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	74 12                	je     8011df <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8011cd:	80 38 00             	cmpb   $0x0,(%eax)
  8011d0:	74 12                	je     8011e4 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8011d2:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8011d5:	c7 43 08 f9 28 80 00 	movl   $0x8028f9,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8011dc:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8011df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    
	} else if (*args->argc > 1) {
  8011e4:	8b 13                	mov    (%ebx),%edx
  8011e6:	83 3a 01             	cmpl   $0x1,(%edx)
  8011e9:	7f 10                	jg     8011fb <argnextvalue+0x3f>
		args->argvalue = 0;
  8011eb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011f9:	eb e1                	jmp    8011dc <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8011fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8011fe:	8b 48 04             	mov    0x4(%eax),%ecx
  801201:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	8b 12                	mov    (%edx),%edx
  801209:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801210:	52                   	push   %edx
  801211:	8d 50 08             	lea    0x8(%eax),%edx
  801214:	52                   	push   %edx
  801215:	83 c0 04             	add    $0x4,%eax
  801218:	50                   	push   %eax
  801219:	e8 84 f9 ff ff       	call   800ba2 <memmove>
		(*args->argc)--;
  80121e:	8b 03                	mov    (%ebx),%eax
  801220:	83 28 01             	subl   $0x1,(%eax)
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	eb b4                	jmp    8011dc <argnextvalue+0x20>

00801228 <argvalue>:
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801231:	8b 42 0c             	mov    0xc(%edx),%eax
  801234:	85 c0                	test   %eax,%eax
  801236:	74 02                	je     80123a <argvalue+0x12>
}
  801238:	c9                   	leave  
  801239:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80123a:	83 ec 0c             	sub    $0xc,%esp
  80123d:	52                   	push   %edx
  80123e:	e8 79 ff ff ff       	call   8011bc <argnextvalue>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	eb f0                	jmp    801238 <argvalue+0x10>

00801248 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	05 00 00 00 30       	add    $0x30000000,%eax
  801253:	c1 e8 0c             	shr    $0xc,%eax
}
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801263:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801268:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801277:	89 c2                	mov    %eax,%edx
  801279:	c1 ea 16             	shr    $0x16,%edx
  80127c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801283:	f6 c2 01             	test   $0x1,%dl
  801286:	74 2d                	je     8012b5 <fd_alloc+0x46>
  801288:	89 c2                	mov    %eax,%edx
  80128a:	c1 ea 0c             	shr    $0xc,%edx
  80128d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801294:	f6 c2 01             	test   $0x1,%dl
  801297:	74 1c                	je     8012b5 <fd_alloc+0x46>
  801299:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80129e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a3:	75 d2                	jne    801277 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ae:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b3:	eb 0a                	jmp    8012bf <fd_alloc+0x50>
			*fd_store = fd;
  8012b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c7:	83 f8 1f             	cmp    $0x1f,%eax
  8012ca:	77 30                	ja     8012fc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cc:	c1 e0 0c             	shl    $0xc,%eax
  8012cf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012da:	f6 c2 01             	test   $0x1,%dl
  8012dd:	74 24                	je     801303 <fd_lookup+0x42>
  8012df:	89 c2                	mov    %eax,%edx
  8012e1:	c1 ea 0c             	shr    $0xc,%edx
  8012e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012eb:	f6 c2 01             	test   $0x1,%dl
  8012ee:	74 1a                	je     80130a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    
		return -E_INVAL;
  8012fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801301:	eb f7                	jmp    8012fa <fd_lookup+0x39>
		return -E_INVAL;
  801303:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801308:	eb f0                	jmp    8012fa <fd_lookup+0x39>
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb e9                	jmp    8012fa <fd_lookup+0x39>

00801311 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80131a:	ba 00 00 00 00       	mov    $0x0,%edx
  80131f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801324:	39 08                	cmp    %ecx,(%eax)
  801326:	74 38                	je     801360 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801328:	83 c2 01             	add    $0x1,%edx
  80132b:	8b 04 95 70 2d 80 00 	mov    0x802d70(,%edx,4),%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	75 ee                	jne    801324 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801336:	a1 08 40 80 00       	mov    0x804008,%eax
  80133b:	8b 40 48             	mov    0x48(%eax),%eax
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	51                   	push   %ecx
  801342:	50                   	push   %eax
  801343:	68 f4 2c 80 00       	push   $0x802cf4
  801348:	e8 68 ef ff ff       	call   8002b5 <cprintf>
	*dev = 0;
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    
			*dev = devtab[i];
  801360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801363:	89 01                	mov    %eax,(%ecx)
			return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	eb f2                	jmp    80135e <dev_lookup+0x4d>

0080136c <fd_close>:
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 24             	sub    $0x24,%esp
  801375:	8b 75 08             	mov    0x8(%ebp),%esi
  801378:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80137e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80137f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801385:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801388:	50                   	push   %eax
  801389:	e8 33 ff ff ff       	call   8012c1 <fd_lookup>
  80138e:	89 c3                	mov    %eax,%ebx
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	78 05                	js     80139c <fd_close+0x30>
	    || fd != fd2)
  801397:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80139a:	74 16                	je     8013b2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80139c:	89 f8                	mov    %edi,%eax
  80139e:	84 c0                	test   %al,%al
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a5:	0f 44 d8             	cmove  %eax,%ebx
}
  8013a8:	89 d8                	mov    %ebx,%eax
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	ff 36                	pushl  (%esi)
  8013bb:	e8 51 ff ff ff       	call   801311 <dev_lookup>
  8013c0:	89 c3                	mov    %eax,%ebx
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 1a                	js     8013e3 <fd_close+0x77>
		if (dev->dev_close)
  8013c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	74 0b                	je     8013e3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	56                   	push   %esi
  8013dc:	ff d0                	call   *%eax
  8013de:	89 c3                	mov    %eax,%ebx
  8013e0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	56                   	push   %esi
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 9d fa ff ff       	call   800e8b <sys_page_unmap>
	return r;
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	eb b5                	jmp    8013a8 <fd_close+0x3c>

008013f3 <close>:

int
close(int fdnum)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 bc fe ff ff       	call   8012c1 <fd_lookup>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	79 02                	jns    80140e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    
		return fd_close(fd, 1);
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	6a 01                	push   $0x1
  801413:	ff 75 f4             	pushl  -0xc(%ebp)
  801416:	e8 51 ff ff ff       	call   80136c <fd_close>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	eb ec                	jmp    80140c <close+0x19>

00801420 <close_all>:

void
close_all(void)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801427:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	53                   	push   %ebx
  801430:	e8 be ff ff ff       	call   8013f3 <close>
	for (i = 0; i < MAXFD; i++)
  801435:	83 c3 01             	add    $0x1,%ebx
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	83 fb 20             	cmp    $0x20,%ebx
  80143e:	75 ec                	jne    80142c <close_all+0xc>
}
  801440:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	57                   	push   %edi
  801449:	56                   	push   %esi
  80144a:	53                   	push   %ebx
  80144b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80144e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	e8 67 fe ff ff       	call   8012c1 <fd_lookup>
  80145a:	89 c3                	mov    %eax,%ebx
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	0f 88 81 00 00 00    	js     8014e8 <dup+0xa3>
		return r;
	close(newfdnum);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	e8 81 ff ff ff       	call   8013f3 <close>

	newfd = INDEX2FD(newfdnum);
  801472:	8b 75 0c             	mov    0xc(%ebp),%esi
  801475:	c1 e6 0c             	shl    $0xc,%esi
  801478:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80147e:	83 c4 04             	add    $0x4,%esp
  801481:	ff 75 e4             	pushl  -0x1c(%ebp)
  801484:	e8 cf fd ff ff       	call   801258 <fd2data>
  801489:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80148b:	89 34 24             	mov    %esi,(%esp)
  80148e:	e8 c5 fd ff ff       	call   801258 <fd2data>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801498:	89 d8                	mov    %ebx,%eax
  80149a:	c1 e8 16             	shr    $0x16,%eax
  80149d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a4:	a8 01                	test   $0x1,%al
  8014a6:	74 11                	je     8014b9 <dup+0x74>
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	c1 e8 0c             	shr    $0xc,%eax
  8014ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014b4:	f6 c2 01             	test   $0x1,%dl
  8014b7:	75 39                	jne    8014f2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	c1 e8 0c             	shr    $0xc,%eax
  8014c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c8:	83 ec 0c             	sub    $0xc,%esp
  8014cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d0:	50                   	push   %eax
  8014d1:	56                   	push   %esi
  8014d2:	6a 00                	push   $0x0
  8014d4:	52                   	push   %edx
  8014d5:	6a 00                	push   $0x0
  8014d7:	e8 6d f9 ff ff       	call   800e49 <sys_page_map>
  8014dc:	89 c3                	mov    %eax,%ebx
  8014de:	83 c4 20             	add    $0x20,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 31                	js     801516 <dup+0xd1>
		goto err;

	return newfdnum;
  8014e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5f                   	pop    %edi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	25 07 0e 00 00       	and    $0xe07,%eax
  801501:	50                   	push   %eax
  801502:	57                   	push   %edi
  801503:	6a 00                	push   $0x0
  801505:	53                   	push   %ebx
  801506:	6a 00                	push   $0x0
  801508:	e8 3c f9 ff ff       	call   800e49 <sys_page_map>
  80150d:	89 c3                	mov    %eax,%ebx
  80150f:	83 c4 20             	add    $0x20,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	79 a3                	jns    8014b9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	56                   	push   %esi
  80151a:	6a 00                	push   $0x0
  80151c:	e8 6a f9 ff ff       	call   800e8b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801521:	83 c4 08             	add    $0x8,%esp
  801524:	57                   	push   %edi
  801525:	6a 00                	push   $0x0
  801527:	e8 5f f9 ff ff       	call   800e8b <sys_page_unmap>
	return r;
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	eb b7                	jmp    8014e8 <dup+0xa3>

00801531 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	53                   	push   %ebx
  801535:	83 ec 1c             	sub    $0x1c,%esp
  801538:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	53                   	push   %ebx
  801540:	e8 7c fd ff ff       	call   8012c1 <fd_lookup>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 3f                	js     80158b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801552:	50                   	push   %eax
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	ff 30                	pushl  (%eax)
  801558:	e8 b4 fd ff ff       	call   801311 <dev_lookup>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 27                	js     80158b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801567:	8b 42 08             	mov    0x8(%edx),%eax
  80156a:	83 e0 03             	and    $0x3,%eax
  80156d:	83 f8 01             	cmp    $0x1,%eax
  801570:	74 1e                	je     801590 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801575:	8b 40 08             	mov    0x8(%eax),%eax
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 35                	je     8015b1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	ff 75 10             	pushl  0x10(%ebp)
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	52                   	push   %edx
  801586:	ff d0                	call   *%eax
  801588:	83 c4 10             	add    $0x10,%esp
}
  80158b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801590:	a1 08 40 80 00       	mov    0x804008,%eax
  801595:	8b 40 48             	mov    0x48(%eax),%eax
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	53                   	push   %ebx
  80159c:	50                   	push   %eax
  80159d:	68 35 2d 80 00       	push   $0x802d35
  8015a2:	e8 0e ed ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015af:	eb da                	jmp    80158b <read+0x5a>
		return -E_NOT_SUPP;
  8015b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b6:	eb d3                	jmp    80158b <read+0x5a>

008015b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	57                   	push   %edi
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cc:	39 f3                	cmp    %esi,%ebx
  8015ce:	73 23                	jae    8015f3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	89 f0                	mov    %esi,%eax
  8015d5:	29 d8                	sub    %ebx,%eax
  8015d7:	50                   	push   %eax
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	03 45 0c             	add    0xc(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	57                   	push   %edi
  8015df:	e8 4d ff ff ff       	call   801531 <read>
		if (m < 0)
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 06                	js     8015f1 <readn+0x39>
			return m;
		if (m == 0)
  8015eb:	74 06                	je     8015f3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015ed:	01 c3                	add    %eax,%ebx
  8015ef:	eb db                	jmp    8015cc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015f3:	89 d8                	mov    %ebx,%eax
  8015f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5f                   	pop    %edi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	53                   	push   %ebx
  801601:	83 ec 1c             	sub    $0x1c,%esp
  801604:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801607:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	53                   	push   %ebx
  80160c:	e8 b0 fc ff ff       	call   8012c1 <fd_lookup>
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 3a                	js     801652 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	ff 30                	pushl  (%eax)
  801624:	e8 e8 fc ff ff       	call   801311 <dev_lookup>
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 22                	js     801652 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801637:	74 1e                	je     801657 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801639:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163c:	8b 52 0c             	mov    0xc(%edx),%edx
  80163f:	85 d2                	test   %edx,%edx
  801641:	74 35                	je     801678 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	ff 75 10             	pushl  0x10(%ebp)
  801649:	ff 75 0c             	pushl  0xc(%ebp)
  80164c:	50                   	push   %eax
  80164d:	ff d2                	call   *%edx
  80164f:	83 c4 10             	add    $0x10,%esp
}
  801652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801655:	c9                   	leave  
  801656:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801657:	a1 08 40 80 00       	mov    0x804008,%eax
  80165c:	8b 40 48             	mov    0x48(%eax),%eax
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	53                   	push   %ebx
  801663:	50                   	push   %eax
  801664:	68 51 2d 80 00       	push   $0x802d51
  801669:	e8 47 ec ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801676:	eb da                	jmp    801652 <write+0x55>
		return -E_NOT_SUPP;
  801678:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167d:	eb d3                	jmp    801652 <write+0x55>

0080167f <seek>:

int
seek(int fdnum, off_t offset)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801685:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801688:	50                   	push   %eax
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	e8 30 fc ff ff       	call   8012c1 <fd_lookup>
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	85 c0                	test   %eax,%eax
  801696:	78 0e                	js     8016a6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 1c             	sub    $0x1c,%esp
  8016af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	53                   	push   %ebx
  8016b7:	e8 05 fc ff ff       	call   8012c1 <fd_lookup>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 37                	js     8016fa <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c9:	50                   	push   %eax
  8016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cd:	ff 30                	pushl  (%eax)
  8016cf:	e8 3d fc ff ff       	call   801311 <dev_lookup>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 1f                	js     8016fa <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e2:	74 1b                	je     8016ff <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e7:	8b 52 18             	mov    0x18(%edx),%edx
  8016ea:	85 d2                	test   %edx,%edx
  8016ec:	74 32                	je     801720 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	ff 75 0c             	pushl  0xc(%ebp)
  8016f4:	50                   	push   %eax
  8016f5:	ff d2                	call   *%edx
  8016f7:	83 c4 10             	add    $0x10,%esp
}
  8016fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ff:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801704:	8b 40 48             	mov    0x48(%eax),%eax
  801707:	83 ec 04             	sub    $0x4,%esp
  80170a:	53                   	push   %ebx
  80170b:	50                   	push   %eax
  80170c:	68 14 2d 80 00       	push   $0x802d14
  801711:	e8 9f eb ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171e:	eb da                	jmp    8016fa <ftruncate+0x52>
		return -E_NOT_SUPP;
  801720:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801725:	eb d3                	jmp    8016fa <ftruncate+0x52>

00801727 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
  80172b:	83 ec 1c             	sub    $0x1c,%esp
  80172e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801731:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801734:	50                   	push   %eax
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	e8 84 fb ff ff       	call   8012c1 <fd_lookup>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 4b                	js     80178f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174a:	50                   	push   %eax
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	ff 30                	pushl  (%eax)
  801750:	e8 bc fb ff ff       	call   801311 <dev_lookup>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 33                	js     80178f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801763:	74 2f                	je     801794 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801765:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801768:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80176f:	00 00 00 
	stat->st_isdir = 0;
  801772:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801779:	00 00 00 
	stat->st_dev = dev;
  80177c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801782:	83 ec 08             	sub    $0x8,%esp
  801785:	53                   	push   %ebx
  801786:	ff 75 f0             	pushl  -0x10(%ebp)
  801789:	ff 50 14             	call   *0x14(%eax)
  80178c:	83 c4 10             	add    $0x10,%esp
}
  80178f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801792:	c9                   	leave  
  801793:	c3                   	ret    
		return -E_NOT_SUPP;
  801794:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801799:	eb f4                	jmp    80178f <fstat+0x68>

0080179b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	e8 22 02 00 00       	call   8019cf <open>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 1b                	js     8017d1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	50                   	push   %eax
  8017bd:	e8 65 ff ff ff       	call   801727 <fstat>
  8017c2:	89 c6                	mov    %eax,%esi
	close(fd);
  8017c4:	89 1c 24             	mov    %ebx,(%esp)
  8017c7:	e8 27 fc ff ff       	call   8013f3 <close>
	return r;
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	89 f3                	mov    %esi,%ebx
}
  8017d1:	89 d8                	mov    %ebx,%eax
  8017d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d6:	5b                   	pop    %ebx
  8017d7:	5e                   	pop    %esi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	89 c6                	mov    %eax,%esi
  8017e1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017e3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017ea:	74 27                	je     801813 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017ec:	6a 07                	push   $0x7
  8017ee:	68 00 50 80 00       	push   $0x805000
  8017f3:	56                   	push   %esi
  8017f4:	ff 35 00 40 80 00    	pushl  0x804000
  8017fa:	e8 7d 0d 00 00       	call   80257c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ff:	83 c4 0c             	add    $0xc,%esp
  801802:	6a 00                	push   $0x0
  801804:	53                   	push   %ebx
  801805:	6a 00                	push   $0x0
  801807:	e8 07 0d 00 00       	call   802513 <ipc_recv>
}
  80180c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	6a 01                	push   $0x1
  801818:	e8 b7 0d 00 00       	call   8025d4 <ipc_find_env>
  80181d:	a3 00 40 80 00       	mov    %eax,0x804000
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	eb c5                	jmp    8017ec <fsipc+0x12>

00801827 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 40 0c             	mov    0xc(%eax),%eax
  801833:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	b8 02 00 00 00       	mov    $0x2,%eax
  80184a:	e8 8b ff ff ff       	call   8017da <fsipc>
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <devfile_flush>:
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8b 40 0c             	mov    0xc(%eax),%eax
  80185d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
  801867:	b8 06 00 00 00       	mov    $0x6,%eax
  80186c:	e8 69 ff ff ff       	call   8017da <fsipc>
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <devfile_stat>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801888:	ba 00 00 00 00       	mov    $0x0,%edx
  80188d:	b8 05 00 00 00       	mov    $0x5,%eax
  801892:	e8 43 ff ff ff       	call   8017da <fsipc>
  801897:	85 c0                	test   %eax,%eax
  801899:	78 2c                	js     8018c7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	68 00 50 80 00       	push   $0x805000
  8018a3:	53                   	push   %ebx
  8018a4:	e8 6b f1 ff ff       	call   800a14 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a9:	a1 80 50 80 00       	mov    0x805080,%eax
  8018ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018b4:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <devfile_write>:
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 08             	sub    $0x8,%esp
  8018d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018e1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018e7:	53                   	push   %ebx
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	68 08 50 80 00       	push   $0x805008
  8018f0:	e8 0f f3 ff ff       	call   800c04 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	b8 04 00 00 00       	mov    $0x4,%eax
  8018ff:	e8 d6 fe ff ff       	call   8017da <fsipc>
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 0b                	js     801916 <devfile_write+0x4a>
	assert(r <= n);
  80190b:	39 d8                	cmp    %ebx,%eax
  80190d:	77 0c                	ja     80191b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80190f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801914:	7f 1e                	jg     801934 <devfile_write+0x68>
}
  801916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
	assert(r <= n);
  80191b:	68 84 2d 80 00       	push   $0x802d84
  801920:	68 8b 2d 80 00       	push   $0x802d8b
  801925:	68 98 00 00 00       	push   $0x98
  80192a:	68 a0 2d 80 00       	push   $0x802da0
  80192f:	e8 7e 0b 00 00       	call   8024b2 <_panic>
	assert(r <= PGSIZE);
  801934:	68 ab 2d 80 00       	push   $0x802dab
  801939:	68 8b 2d 80 00       	push   $0x802d8b
  80193e:	68 99 00 00 00       	push   $0x99
  801943:	68 a0 2d 80 00       	push   $0x802da0
  801948:	e8 65 0b 00 00       	call   8024b2 <_panic>

0080194d <devfile_read>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8b 40 0c             	mov    0xc(%eax),%eax
  80195b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801960:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801966:	ba 00 00 00 00       	mov    $0x0,%edx
  80196b:	b8 03 00 00 00       	mov    $0x3,%eax
  801970:	e8 65 fe ff ff       	call   8017da <fsipc>
  801975:	89 c3                	mov    %eax,%ebx
  801977:	85 c0                	test   %eax,%eax
  801979:	78 1f                	js     80199a <devfile_read+0x4d>
	assert(r <= n);
  80197b:	39 f0                	cmp    %esi,%eax
  80197d:	77 24                	ja     8019a3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80197f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801984:	7f 33                	jg     8019b9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	50                   	push   %eax
  80198a:	68 00 50 80 00       	push   $0x805000
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	e8 0b f2 ff ff       	call   800ba2 <memmove>
	return r;
  801997:	83 c4 10             	add    $0x10,%esp
}
  80199a:	89 d8                	mov    %ebx,%eax
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
	assert(r <= n);
  8019a3:	68 84 2d 80 00       	push   $0x802d84
  8019a8:	68 8b 2d 80 00       	push   $0x802d8b
  8019ad:	6a 7c                	push   $0x7c
  8019af:	68 a0 2d 80 00       	push   $0x802da0
  8019b4:	e8 f9 0a 00 00       	call   8024b2 <_panic>
	assert(r <= PGSIZE);
  8019b9:	68 ab 2d 80 00       	push   $0x802dab
  8019be:	68 8b 2d 80 00       	push   $0x802d8b
  8019c3:	6a 7d                	push   $0x7d
  8019c5:	68 a0 2d 80 00       	push   $0x802da0
  8019ca:	e8 e3 0a 00 00       	call   8024b2 <_panic>

008019cf <open>:
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	56                   	push   %esi
  8019d3:	53                   	push   %ebx
  8019d4:	83 ec 1c             	sub    $0x1c,%esp
  8019d7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019da:	56                   	push   %esi
  8019db:	e8 fb ef ff ff       	call   8009db <strlen>
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019e8:	7f 6c                	jg     801a56 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019ea:	83 ec 0c             	sub    $0xc,%esp
  8019ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f0:	50                   	push   %eax
  8019f1:	e8 79 f8 ff ff       	call   80126f <fd_alloc>
  8019f6:	89 c3                	mov    %eax,%ebx
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 3c                	js     801a3b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	56                   	push   %esi
  801a03:	68 00 50 80 00       	push   $0x805000
  801a08:	e8 07 f0 ff ff       	call   800a14 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a18:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1d:	e8 b8 fd ff ff       	call   8017da <fsipc>
  801a22:	89 c3                	mov    %eax,%ebx
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 19                	js     801a44 <open+0x75>
	return fd2num(fd);
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a31:	e8 12 f8 ff ff       	call   801248 <fd2num>
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	83 c4 10             	add    $0x10,%esp
}
  801a3b:	89 d8                	mov    %ebx,%eax
  801a3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    
		fd_close(fd, 0);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4c:	e8 1b f9 ff ff       	call   80136c <fd_close>
		return r;
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	eb e5                	jmp    801a3b <open+0x6c>
		return -E_BAD_PATH;
  801a56:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a5b:	eb de                	jmp    801a3b <open+0x6c>

00801a5d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a63:	ba 00 00 00 00       	mov    $0x0,%edx
  801a68:	b8 08 00 00 00       	mov    $0x8,%eax
  801a6d:	e8 68 fd ff ff       	call   8017da <fsipc>
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a74:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a78:	7f 01                	jg     801a7b <writebuf+0x7>
  801a7a:	c3                   	ret    
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a84:	ff 70 04             	pushl  0x4(%eax)
  801a87:	8d 40 10             	lea    0x10(%eax),%eax
  801a8a:	50                   	push   %eax
  801a8b:	ff 33                	pushl  (%ebx)
  801a8d:	e8 6b fb ff ff       	call   8015fd <write>
		if (result > 0)
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	7e 03                	jle    801a9c <writebuf+0x28>
			b->result += result;
  801a99:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a9c:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a9f:	74 0d                	je     801aae <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa8:	0f 4f c2             	cmovg  %edx,%eax
  801aab:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <putch>:

static void
putch(int ch, void *thunk)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801abd:	8b 53 04             	mov    0x4(%ebx),%edx
  801ac0:	8d 42 01             	lea    0x1(%edx),%eax
  801ac3:	89 43 04             	mov    %eax,0x4(%ebx)
  801ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801acd:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ad2:	74 06                	je     801ada <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801ad4:	83 c4 04             	add    $0x4,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5d                   	pop    %ebp
  801ad9:	c3                   	ret    
		writebuf(b);
  801ada:	89 d8                	mov    %ebx,%eax
  801adc:	e8 93 ff ff ff       	call   801a74 <writebuf>
		b->idx = 0;
  801ae1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801ae8:	eb ea                	jmp    801ad4 <putch+0x21>

00801aea <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801afc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b03:	00 00 00 
	b.result = 0;
  801b06:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b0d:	00 00 00 
	b.error = 1;
  801b10:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b17:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b26:	50                   	push   %eax
  801b27:	68 b3 1a 80 00       	push   $0x801ab3
  801b2c:	e8 b1 e8 ff ff       	call   8003e2 <vprintfmt>
	if (b.idx > 0)
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b3b:	7f 11                	jg     801b4e <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b3d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b43:	85 c0                	test   %eax,%eax
  801b45:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    
		writebuf(&b);
  801b4e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b54:	e8 1b ff ff ff       	call   801a74 <writebuf>
  801b59:	eb e2                	jmp    801b3d <vfprintf+0x53>

00801b5b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b61:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b64:	50                   	push   %eax
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 7a ff ff ff       	call   801aea <vfprintf>
	va_end(ap);

	return cnt;
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <printf>:

int
printf(const char *fmt, ...)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b78:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 01                	push   $0x1
  801b81:	e8 64 ff ff ff       	call   801aea <vfprintf>
	va_end(ap);

	return cnt;
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b8e:	68 b7 2d 80 00       	push   $0x802db7
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	e8 79 ee ff ff       	call   800a14 <strcpy>
	return 0;
}
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <devsock_close>:
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 10             	sub    $0x10,%esp
  801ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bac:	53                   	push   %ebx
  801bad:	e8 61 0a 00 00       	call   802613 <pageref>
  801bb2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801bba:	83 f8 01             	cmp    $0x1,%eax
  801bbd:	74 07                	je     801bc6 <devsock_close+0x24>
}
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bc6:	83 ec 0c             	sub    $0xc,%esp
  801bc9:	ff 73 0c             	pushl  0xc(%ebx)
  801bcc:	e8 b9 02 00 00       	call   801e8a <nsipc_close>
  801bd1:	89 c2                	mov    %eax,%edx
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	eb e7                	jmp    801bbf <devsock_close+0x1d>

00801bd8 <devsock_write>:
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 10             	pushl  0x10(%ebp)
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	ff 70 0c             	pushl  0xc(%eax)
  801bec:	e8 76 03 00 00       	call   801f67 <nsipc_send>
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <devsock_read>:
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 10             	pushl  0x10(%ebp)
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	ff 70 0c             	pushl  0xc(%eax)
  801c07:	e8 ef 02 00 00       	call   801efb <nsipc_recv>
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <fd2sockid>:
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c14:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	e8 a3 f6 ff ff       	call   8012c1 <fd_lookup>
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 10                	js     801c35 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c2e:	39 08                	cmp    %ecx,(%eax)
  801c30:	75 05                	jne    801c37 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c32:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    
		return -E_NOT_SUPP;
  801c37:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3c:	eb f7                	jmp    801c35 <fd2sockid+0x27>

00801c3e <alloc_sockfd>:
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	83 ec 1c             	sub    $0x1c,%esp
  801c46:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4b:	50                   	push   %eax
  801c4c:	e8 1e f6 ff ff       	call   80126f <fd_alloc>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 43                	js     801c9d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	68 07 04 00 00       	push   $0x407
  801c62:	ff 75 f4             	pushl  -0xc(%ebp)
  801c65:	6a 00                	push   $0x0
  801c67:	e8 9a f1 ff ff       	call   800e06 <sys_page_alloc>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 28                	js     801c9d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c7e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c8a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	50                   	push   %eax
  801c91:	e8 b2 f5 ff ff       	call   801248 <fd2num>
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	eb 0c                	jmp    801ca9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	56                   	push   %esi
  801ca1:	e8 e4 01 00 00       	call   801e8a <nsipc_close>
		return r;
  801ca6:	83 c4 10             	add    $0x10,%esp
}
  801ca9:	89 d8                	mov    %ebx,%eax
  801cab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cae:	5b                   	pop    %ebx
  801caf:	5e                   	pop    %esi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    

00801cb2 <accept>:
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	e8 4e ff ff ff       	call   801c0e <fd2sockid>
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 1b                	js     801cdf <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	ff 75 10             	pushl  0x10(%ebp)
  801cca:	ff 75 0c             	pushl  0xc(%ebp)
  801ccd:	50                   	push   %eax
  801cce:	e8 0e 01 00 00       	call   801de1 <nsipc_accept>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 05                	js     801cdf <accept+0x2d>
	return alloc_sockfd(r);
  801cda:	e8 5f ff ff ff       	call   801c3e <alloc_sockfd>
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <bind>:
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	e8 1f ff ff ff       	call   801c0e <fd2sockid>
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 12                	js     801d05 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	ff 75 10             	pushl  0x10(%ebp)
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	50                   	push   %eax
  801cfd:	e8 31 01 00 00       	call   801e33 <nsipc_bind>
  801d02:	83 c4 10             	add    $0x10,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <shutdown>:
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	e8 f9 fe ff ff       	call   801c0e <fd2sockid>
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 0f                	js     801d28 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d19:	83 ec 08             	sub    $0x8,%esp
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	50                   	push   %eax
  801d20:	e8 43 01 00 00       	call   801e68 <nsipc_shutdown>
  801d25:	83 c4 10             	add    $0x10,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <connect>:
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	e8 d6 fe ff ff       	call   801c0e <fd2sockid>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 12                	js     801d4e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	e8 59 01 00 00       	call   801ea4 <nsipc_connect>
  801d4b:	83 c4 10             	add    $0x10,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <listen>:
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	e8 b0 fe ff ff       	call   801c0e <fd2sockid>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 0f                	js     801d71 <listen+0x21>
	return nsipc_listen(r, backlog);
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	e8 6b 01 00 00       	call   801ed9 <nsipc_listen>
  801d6e:	83 c4 10             	add    $0x10,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d79:	ff 75 10             	pushl  0x10(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	e8 3e 02 00 00       	call   801fc5 <nsipc_socket>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 05                	js     801d93 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d8e:	e8 ab fe ff ff       	call   801c3e <alloc_sockfd>
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d9e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801da5:	74 26                	je     801dcd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801da7:	6a 07                	push   $0x7
  801da9:	68 00 60 80 00       	push   $0x806000
  801dae:	53                   	push   %ebx
  801daf:	ff 35 04 40 80 00    	pushl  0x804004
  801db5:	e8 c2 07 00 00       	call   80257c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dba:	83 c4 0c             	add    $0xc,%esp
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	e8 4b 07 00 00       	call   802513 <ipc_recv>
}
  801dc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	6a 02                	push   $0x2
  801dd2:	e8 fd 07 00 00       	call   8025d4 <ipc_find_env>
  801dd7:	a3 04 40 80 00       	mov    %eax,0x804004
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	eb c6                	jmp    801da7 <nsipc+0x12>

00801de1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	56                   	push   %esi
  801de5:	53                   	push   %ebx
  801de6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801df1:	8b 06                	mov    (%esi),%eax
  801df3:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801df8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfd:	e8 93 ff ff ff       	call   801d95 <nsipc>
  801e02:	89 c3                	mov    %eax,%ebx
  801e04:	85 c0                	test   %eax,%eax
  801e06:	79 09                	jns    801e11 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	ff 35 10 60 80 00    	pushl  0x806010
  801e1a:	68 00 60 80 00       	push   $0x806000
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	e8 7b ed ff ff       	call   800ba2 <memmove>
		*addrlen = ret->ret_addrlen;
  801e27:	a1 10 60 80 00       	mov    0x806010,%eax
  801e2c:	89 06                	mov    %eax,(%esi)
  801e2e:	83 c4 10             	add    $0x10,%esp
	return r;
  801e31:	eb d5                	jmp    801e08 <nsipc_accept+0x27>

00801e33 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	53                   	push   %ebx
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e45:	53                   	push   %ebx
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	68 04 60 80 00       	push   $0x806004
  801e4e:	e8 4f ed ff ff       	call   800ba2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e53:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e59:	b8 02 00 00 00       	mov    $0x2,%eax
  801e5e:	e8 32 ff ff ff       	call   801d95 <nsipc>
}
  801e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e7e:	b8 03 00 00 00       	mov    $0x3,%eax
  801e83:	e8 0d ff ff ff       	call   801d95 <nsipc>
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <nsipc_close>:

int
nsipc_close(int s)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e98:	b8 04 00 00 00       	mov    $0x4,%eax
  801e9d:	e8 f3 fe ff ff       	call   801d95 <nsipc>
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801eb6:	53                   	push   %ebx
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	68 04 60 80 00       	push   $0x806004
  801ebf:	e8 de ec ff ff       	call   800ba2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ec4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801eca:	b8 05 00 00 00       	mov    $0x5,%eax
  801ecf:	e8 c1 fe ff ff       	call   801d95 <nsipc>
}
  801ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eea:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801eef:	b8 06 00 00 00       	mov    $0x6,%eax
  801ef4:	e8 9c fe ff ff       	call   801d95 <nsipc>
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f0b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f11:	8b 45 14             	mov    0x14(%ebp),%eax
  801f14:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f19:	b8 07 00 00 00       	mov    $0x7,%eax
  801f1e:	e8 72 fe ff ff       	call   801d95 <nsipc>
  801f23:	89 c3                	mov    %eax,%ebx
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 1f                	js     801f48 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f29:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f2e:	7f 21                	jg     801f51 <nsipc_recv+0x56>
  801f30:	39 c6                	cmp    %eax,%esi
  801f32:	7c 1d                	jl     801f51 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f34:	83 ec 04             	sub    $0x4,%esp
  801f37:	50                   	push   %eax
  801f38:	68 00 60 80 00       	push   $0x806000
  801f3d:	ff 75 0c             	pushl  0xc(%ebp)
  801f40:	e8 5d ec ff ff       	call   800ba2 <memmove>
  801f45:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4d:	5b                   	pop    %ebx
  801f4e:	5e                   	pop    %esi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f51:	68 c3 2d 80 00       	push   $0x802dc3
  801f56:	68 8b 2d 80 00       	push   $0x802d8b
  801f5b:	6a 62                	push   $0x62
  801f5d:	68 d8 2d 80 00       	push   $0x802dd8
  801f62:	e8 4b 05 00 00       	call   8024b2 <_panic>

00801f67 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	53                   	push   %ebx
  801f6b:	83 ec 04             	sub    $0x4,%esp
  801f6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f79:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f7f:	7f 2e                	jg     801faf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	53                   	push   %ebx
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	68 0c 60 80 00       	push   $0x80600c
  801f8d:	e8 10 ec ff ff       	call   800ba2 <memmove>
	nsipcbuf.send.req_size = size;
  801f92:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f98:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fa0:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa5:	e8 eb fd ff ff       	call   801d95 <nsipc>
}
  801faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    
	assert(size < 1600);
  801faf:	68 e4 2d 80 00       	push   $0x802de4
  801fb4:	68 8b 2d 80 00       	push   $0x802d8b
  801fb9:	6a 6d                	push   $0x6d
  801fbb:	68 d8 2d 80 00       	push   $0x802dd8
  801fc0:	e8 ed 04 00 00       	call   8024b2 <_panic>

00801fc5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fe3:	b8 09 00 00 00       	mov    $0x9,%eax
  801fe8:	e8 a8 fd ff ff       	call   801d95 <nsipc>
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 56 f2 ff ff       	call   801258 <fd2data>
  802002:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802004:	83 c4 08             	add    $0x8,%esp
  802007:	68 f0 2d 80 00       	push   $0x802df0
  80200c:	53                   	push   %ebx
  80200d:	e8 02 ea ff ff       	call   800a14 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802012:	8b 46 04             	mov    0x4(%esi),%eax
  802015:	2b 06                	sub    (%esi),%eax
  802017:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80201d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802024:	00 00 00 
	stat->st_dev = &devpipe;
  802027:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80202e:	30 80 00 
	return 0;
}
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802039:	5b                   	pop    %ebx
  80203a:	5e                   	pop    %esi
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    

0080203d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	53                   	push   %ebx
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802047:	53                   	push   %ebx
  802048:	6a 00                	push   $0x0
  80204a:	e8 3c ee ff ff       	call   800e8b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80204f:	89 1c 24             	mov    %ebx,(%esp)
  802052:	e8 01 f2 ff ff       	call   801258 <fd2data>
  802057:	83 c4 08             	add    $0x8,%esp
  80205a:	50                   	push   %eax
  80205b:	6a 00                	push   $0x0
  80205d:	e8 29 ee ff ff       	call   800e8b <sys_page_unmap>
}
  802062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <_pipeisclosed>:
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	57                   	push   %edi
  80206b:	56                   	push   %esi
  80206c:	53                   	push   %ebx
  80206d:	83 ec 1c             	sub    $0x1c,%esp
  802070:	89 c7                	mov    %eax,%edi
  802072:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802074:	a1 08 40 80 00       	mov    0x804008,%eax
  802079:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	57                   	push   %edi
  802080:	e8 8e 05 00 00       	call   802613 <pageref>
  802085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802088:	89 34 24             	mov    %esi,(%esp)
  80208b:	e8 83 05 00 00       	call   802613 <pageref>
		nn = thisenv->env_runs;
  802090:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802096:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	39 cb                	cmp    %ecx,%ebx
  80209e:	74 1b                	je     8020bb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020a0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020a3:	75 cf                	jne    802074 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a5:	8b 42 58             	mov    0x58(%edx),%eax
  8020a8:	6a 01                	push   $0x1
  8020aa:	50                   	push   %eax
  8020ab:	53                   	push   %ebx
  8020ac:	68 f7 2d 80 00       	push   $0x802df7
  8020b1:	e8 ff e1 ff ff       	call   8002b5 <cprintf>
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	eb b9                	jmp    802074 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020bb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020be:	0f 94 c0             	sete   %al
  8020c1:	0f b6 c0             	movzbl %al,%eax
}
  8020c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    

008020cc <devpipe_write>:
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	57                   	push   %edi
  8020d0:	56                   	push   %esi
  8020d1:	53                   	push   %ebx
  8020d2:	83 ec 28             	sub    $0x28,%esp
  8020d5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020d8:	56                   	push   %esi
  8020d9:	e8 7a f1 ff ff       	call   801258 <fd2data>
  8020de:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020eb:	74 4f                	je     80213c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020ed:	8b 43 04             	mov    0x4(%ebx),%eax
  8020f0:	8b 0b                	mov    (%ebx),%ecx
  8020f2:	8d 51 20             	lea    0x20(%ecx),%edx
  8020f5:	39 d0                	cmp    %edx,%eax
  8020f7:	72 14                	jb     80210d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020f9:	89 da                	mov    %ebx,%edx
  8020fb:	89 f0                	mov    %esi,%eax
  8020fd:	e8 65 ff ff ff       	call   802067 <_pipeisclosed>
  802102:	85 c0                	test   %eax,%eax
  802104:	75 3b                	jne    802141 <devpipe_write+0x75>
			sys_yield();
  802106:	e8 dc ec ff ff       	call   800de7 <sys_yield>
  80210b:	eb e0                	jmp    8020ed <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80210d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802110:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802114:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802117:	89 c2                	mov    %eax,%edx
  802119:	c1 fa 1f             	sar    $0x1f,%edx
  80211c:	89 d1                	mov    %edx,%ecx
  80211e:	c1 e9 1b             	shr    $0x1b,%ecx
  802121:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802124:	83 e2 1f             	and    $0x1f,%edx
  802127:	29 ca                	sub    %ecx,%edx
  802129:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80212d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802131:	83 c0 01             	add    $0x1,%eax
  802134:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802137:	83 c7 01             	add    $0x1,%edi
  80213a:	eb ac                	jmp    8020e8 <devpipe_write+0x1c>
	return i;
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	eb 05                	jmp    802146 <devpipe_write+0x7a>
				return 0;
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802149:	5b                   	pop    %ebx
  80214a:	5e                   	pop    %esi
  80214b:	5f                   	pop    %edi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    

0080214e <devpipe_read>:
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	57                   	push   %edi
  802152:	56                   	push   %esi
  802153:	53                   	push   %ebx
  802154:	83 ec 18             	sub    $0x18,%esp
  802157:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80215a:	57                   	push   %edi
  80215b:	e8 f8 f0 ff ff       	call   801258 <fd2data>
  802160:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	be 00 00 00 00       	mov    $0x0,%esi
  80216a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80216d:	75 14                	jne    802183 <devpipe_read+0x35>
	return i;
  80216f:	8b 45 10             	mov    0x10(%ebp),%eax
  802172:	eb 02                	jmp    802176 <devpipe_read+0x28>
				return i;
  802174:	89 f0                	mov    %esi,%eax
}
  802176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802179:	5b                   	pop    %ebx
  80217a:	5e                   	pop    %esi
  80217b:	5f                   	pop    %edi
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    
			sys_yield();
  80217e:	e8 64 ec ff ff       	call   800de7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802183:	8b 03                	mov    (%ebx),%eax
  802185:	3b 43 04             	cmp    0x4(%ebx),%eax
  802188:	75 18                	jne    8021a2 <devpipe_read+0x54>
			if (i > 0)
  80218a:	85 f6                	test   %esi,%esi
  80218c:	75 e6                	jne    802174 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80218e:	89 da                	mov    %ebx,%edx
  802190:	89 f8                	mov    %edi,%eax
  802192:	e8 d0 fe ff ff       	call   802067 <_pipeisclosed>
  802197:	85 c0                	test   %eax,%eax
  802199:	74 e3                	je     80217e <devpipe_read+0x30>
				return 0;
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	eb d4                	jmp    802176 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021a2:	99                   	cltd   
  8021a3:	c1 ea 1b             	shr    $0x1b,%edx
  8021a6:	01 d0                	add    %edx,%eax
  8021a8:	83 e0 1f             	and    $0x1f,%eax
  8021ab:	29 d0                	sub    %edx,%eax
  8021ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021b8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021bb:	83 c6 01             	add    $0x1,%esi
  8021be:	eb aa                	jmp    80216a <devpipe_read+0x1c>

008021c0 <pipe>:
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	56                   	push   %esi
  8021c4:	53                   	push   %ebx
  8021c5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021cb:	50                   	push   %eax
  8021cc:	e8 9e f0 ff ff       	call   80126f <fd_alloc>
  8021d1:	89 c3                	mov    %eax,%ebx
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	0f 88 23 01 00 00    	js     802301 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	68 07 04 00 00       	push   $0x407
  8021e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e9:	6a 00                	push   $0x0
  8021eb:	e8 16 ec ff ff       	call   800e06 <sys_page_alloc>
  8021f0:	89 c3                	mov    %eax,%ebx
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	0f 88 04 01 00 00    	js     802301 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802203:	50                   	push   %eax
  802204:	e8 66 f0 ff ff       	call   80126f <fd_alloc>
  802209:	89 c3                	mov    %eax,%ebx
  80220b:	83 c4 10             	add    $0x10,%esp
  80220e:	85 c0                	test   %eax,%eax
  802210:	0f 88 db 00 00 00    	js     8022f1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 07 04 00 00       	push   $0x407
  80221e:	ff 75 f0             	pushl  -0x10(%ebp)
  802221:	6a 00                	push   $0x0
  802223:	e8 de eb ff ff       	call   800e06 <sys_page_alloc>
  802228:	89 c3                	mov    %eax,%ebx
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	0f 88 bc 00 00 00    	js     8022f1 <pipe+0x131>
	va = fd2data(fd0);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	ff 75 f4             	pushl  -0xc(%ebp)
  80223b:	e8 18 f0 ff ff       	call   801258 <fd2data>
  802240:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802242:	83 c4 0c             	add    $0xc,%esp
  802245:	68 07 04 00 00       	push   $0x407
  80224a:	50                   	push   %eax
  80224b:	6a 00                	push   $0x0
  80224d:	e8 b4 eb ff ff       	call   800e06 <sys_page_alloc>
  802252:	89 c3                	mov    %eax,%ebx
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 88 82 00 00 00    	js     8022e1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225f:	83 ec 0c             	sub    $0xc,%esp
  802262:	ff 75 f0             	pushl  -0x10(%ebp)
  802265:	e8 ee ef ff ff       	call   801258 <fd2data>
  80226a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802271:	50                   	push   %eax
  802272:	6a 00                	push   $0x0
  802274:	56                   	push   %esi
  802275:	6a 00                	push   $0x0
  802277:	e8 cd eb ff ff       	call   800e49 <sys_page_map>
  80227c:	89 c3                	mov    %eax,%ebx
  80227e:	83 c4 20             	add    $0x20,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	78 4e                	js     8022d3 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802285:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80228a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80228f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802292:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802299:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ae:	e8 95 ef ff ff       	call   801248 <fd2num>
  8022b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022b8:	83 c4 04             	add    $0x4,%esp
  8022bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8022be:	e8 85 ef ff ff       	call   801248 <fd2num>
  8022c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022d1:	eb 2e                	jmp    802301 <pipe+0x141>
	sys_page_unmap(0, va);
  8022d3:	83 ec 08             	sub    $0x8,%esp
  8022d6:	56                   	push   %esi
  8022d7:	6a 00                	push   $0x0
  8022d9:	e8 ad eb ff ff       	call   800e8b <sys_page_unmap>
  8022de:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022e1:	83 ec 08             	sub    $0x8,%esp
  8022e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e7:	6a 00                	push   $0x0
  8022e9:	e8 9d eb ff ff       	call   800e8b <sys_page_unmap>
  8022ee:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022f1:	83 ec 08             	sub    $0x8,%esp
  8022f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f7:	6a 00                	push   $0x0
  8022f9:	e8 8d eb ff ff       	call   800e8b <sys_page_unmap>
  8022fe:	83 c4 10             	add    $0x10,%esp
}
  802301:	89 d8                	mov    %ebx,%eax
  802303:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802306:	5b                   	pop    %ebx
  802307:	5e                   	pop    %esi
  802308:	5d                   	pop    %ebp
  802309:	c3                   	ret    

0080230a <pipeisclosed>:
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802310:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802313:	50                   	push   %eax
  802314:	ff 75 08             	pushl  0x8(%ebp)
  802317:	e8 a5 ef ff ff       	call   8012c1 <fd_lookup>
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	85 c0                	test   %eax,%eax
  802321:	78 18                	js     80233b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	ff 75 f4             	pushl  -0xc(%ebp)
  802329:	e8 2a ef ff ff       	call   801258 <fd2data>
	return _pipeisclosed(fd, p);
  80232e:	89 c2                	mov    %eax,%edx
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	e8 2f fd ff ff       	call   802067 <_pipeisclosed>
  802338:	83 c4 10             	add    $0x10,%esp
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	c3                   	ret    

00802343 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802349:	68 0f 2e 80 00       	push   $0x802e0f
  80234e:	ff 75 0c             	pushl  0xc(%ebp)
  802351:	e8 be e6 ff ff       	call   800a14 <strcpy>
	return 0;
}
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <devcons_write>:
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	57                   	push   %edi
  802361:	56                   	push   %esi
  802362:	53                   	push   %ebx
  802363:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802369:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80236e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802374:	3b 75 10             	cmp    0x10(%ebp),%esi
  802377:	73 31                	jae    8023aa <devcons_write+0x4d>
		m = n - tot;
  802379:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80237c:	29 f3                	sub    %esi,%ebx
  80237e:	83 fb 7f             	cmp    $0x7f,%ebx
  802381:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802386:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	53                   	push   %ebx
  80238d:	89 f0                	mov    %esi,%eax
  80238f:	03 45 0c             	add    0xc(%ebp),%eax
  802392:	50                   	push   %eax
  802393:	57                   	push   %edi
  802394:	e8 09 e8 ff ff       	call   800ba2 <memmove>
		sys_cputs(buf, m);
  802399:	83 c4 08             	add    $0x8,%esp
  80239c:	53                   	push   %ebx
  80239d:	57                   	push   %edi
  80239e:	e8 a7 e9 ff ff       	call   800d4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023a3:	01 de                	add    %ebx,%esi
  8023a5:	83 c4 10             	add    $0x10,%esp
  8023a8:	eb ca                	jmp    802374 <devcons_write+0x17>
}
  8023aa:	89 f0                	mov    %esi,%eax
  8023ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <devcons_read>:
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 08             	sub    $0x8,%esp
  8023ba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023c3:	74 21                	je     8023e6 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8023c5:	e8 9e e9 ff ff       	call   800d68 <sys_cgetc>
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 07                	jne    8023d5 <devcons_read+0x21>
		sys_yield();
  8023ce:	e8 14 ea ff ff       	call   800de7 <sys_yield>
  8023d3:	eb f0                	jmp    8023c5 <devcons_read+0x11>
	if (c < 0)
  8023d5:	78 0f                	js     8023e6 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8023d7:	83 f8 04             	cmp    $0x4,%eax
  8023da:	74 0c                	je     8023e8 <devcons_read+0x34>
	*(char*)vbuf = c;
  8023dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023df:	88 02                	mov    %al,(%edx)
	return 1;
  8023e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    
		return 0;
  8023e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ed:	eb f7                	jmp    8023e6 <devcons_read+0x32>

008023ef <cputchar>:
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023fb:	6a 01                	push   $0x1
  8023fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802400:	50                   	push   %eax
  802401:	e8 44 e9 ff ff       	call   800d4a <sys_cputs>
}
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <getchar>:
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802411:	6a 01                	push   $0x1
  802413:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802416:	50                   	push   %eax
  802417:	6a 00                	push   $0x0
  802419:	e8 13 f1 ff ff       	call   801531 <read>
	if (r < 0)
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	85 c0                	test   %eax,%eax
  802423:	78 06                	js     80242b <getchar+0x20>
	if (r < 1)
  802425:	74 06                	je     80242d <getchar+0x22>
	return c;
  802427:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    
		return -E_EOF;
  80242d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802432:	eb f7                	jmp    80242b <getchar+0x20>

00802434 <iscons>:
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243d:	50                   	push   %eax
  80243e:	ff 75 08             	pushl  0x8(%ebp)
  802441:	e8 7b ee ff ff       	call   8012c1 <fd_lookup>
  802446:	83 c4 10             	add    $0x10,%esp
  802449:	85 c0                	test   %eax,%eax
  80244b:	78 11                	js     80245e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802456:	39 10                	cmp    %edx,(%eax)
  802458:	0f 94 c0             	sete   %al
  80245b:	0f b6 c0             	movzbl %al,%eax
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <opencons>:
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802466:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802469:	50                   	push   %eax
  80246a:	e8 00 ee ff ff       	call   80126f <fd_alloc>
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	85 c0                	test   %eax,%eax
  802474:	78 3a                	js     8024b0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 07 04 00 00       	push   $0x407
  80247e:	ff 75 f4             	pushl  -0xc(%ebp)
  802481:	6a 00                	push   $0x0
  802483:	e8 7e e9 ff ff       	call   800e06 <sys_page_alloc>
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	85 c0                	test   %eax,%eax
  80248d:	78 21                	js     8024b0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802498:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024a4:	83 ec 0c             	sub    $0xc,%esp
  8024a7:	50                   	push   %eax
  8024a8:	e8 9b ed ff ff       	call   801248 <fd2num>
  8024ad:	83 c4 10             	add    $0x10,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8024b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8024bc:	8b 40 48             	mov    0x48(%eax),%eax
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 40 2e 80 00       	push   $0x802e40
  8024c7:	50                   	push   %eax
  8024c8:	68 34 29 80 00       	push   $0x802934
  8024cd:	e8 e3 dd ff ff       	call   8002b5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8024d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024d5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024db:	e8 e8 e8 ff ff       	call   800dc8 <sys_getenvid>
  8024e0:	83 c4 04             	add    $0x4,%esp
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	56                   	push   %esi
  8024ea:	50                   	push   %eax
  8024eb:	68 1c 2e 80 00       	push   $0x802e1c
  8024f0:	e8 c0 dd ff ff       	call   8002b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024f5:	83 c4 18             	add    $0x18,%esp
  8024f8:	53                   	push   %ebx
  8024f9:	ff 75 10             	pushl  0x10(%ebp)
  8024fc:	e8 63 dd ff ff       	call   800264 <vcprintf>
	cprintf("\n");
  802501:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  802508:	e8 a8 dd ff ff       	call   8002b5 <cprintf>
  80250d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802510:	cc                   	int3   
  802511:	eb fd                	jmp    802510 <_panic+0x5e>

00802513 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	56                   	push   %esi
  802517:	53                   	push   %ebx
  802518:	8b 75 08             	mov    0x8(%ebp),%esi
  80251b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802521:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802523:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802528:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80252b:	83 ec 0c             	sub    $0xc,%esp
  80252e:	50                   	push   %eax
  80252f:	e8 82 ea ff ff       	call   800fb6 <sys_ipc_recv>
	if(ret < 0){
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 2b                	js     802566 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80253b:	85 f6                	test   %esi,%esi
  80253d:	74 0a                	je     802549 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80253f:	a1 08 40 80 00       	mov    0x804008,%eax
  802544:	8b 40 78             	mov    0x78(%eax),%eax
  802547:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802549:	85 db                	test   %ebx,%ebx
  80254b:	74 0a                	je     802557 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80254d:	a1 08 40 80 00       	mov    0x804008,%eax
  802552:	8b 40 7c             	mov    0x7c(%eax),%eax
  802555:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802557:	a1 08 40 80 00       	mov    0x804008,%eax
  80255c:	8b 40 74             	mov    0x74(%eax),%eax
}
  80255f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
		if(from_env_store)
  802566:	85 f6                	test   %esi,%esi
  802568:	74 06                	je     802570 <ipc_recv+0x5d>
			*from_env_store = 0;
  80256a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802570:	85 db                	test   %ebx,%ebx
  802572:	74 eb                	je     80255f <ipc_recv+0x4c>
			*perm_store = 0;
  802574:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80257a:	eb e3                	jmp    80255f <ipc_recv+0x4c>

0080257c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	57                   	push   %edi
  802580:	56                   	push   %esi
  802581:	53                   	push   %ebx
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	8b 7d 08             	mov    0x8(%ebp),%edi
  802588:	8b 75 0c             	mov    0xc(%ebp),%esi
  80258b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80258e:	85 db                	test   %ebx,%ebx
  802590:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802595:	0f 44 d8             	cmove  %eax,%ebx
  802598:	eb 05                	jmp    80259f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80259a:	e8 48 e8 ff ff       	call   800de7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80259f:	ff 75 14             	pushl  0x14(%ebp)
  8025a2:	53                   	push   %ebx
  8025a3:	56                   	push   %esi
  8025a4:	57                   	push   %edi
  8025a5:	e8 e9 e9 ff ff       	call   800f93 <sys_ipc_try_send>
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	74 1b                	je     8025cc <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8025b1:	79 e7                	jns    80259a <ipc_send+0x1e>
  8025b3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025b6:	74 e2                	je     80259a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	68 47 2e 80 00       	push   $0x802e47
  8025c0:	6a 46                	push   $0x46
  8025c2:	68 5c 2e 80 00       	push   $0x802e5c
  8025c7:	e8 e6 fe ff ff       	call   8024b2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8025cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025df:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8025e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025eb:	8b 52 50             	mov    0x50(%edx),%edx
  8025ee:	39 ca                	cmp    %ecx,%edx
  8025f0:	74 11                	je     802603 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8025f2:	83 c0 01             	add    $0x1,%eax
  8025f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025fa:	75 e3                	jne    8025df <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802601:	eb 0e                	jmp    802611 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802603:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802609:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80260e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    

00802613 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802619:	89 d0                	mov    %edx,%eax
  80261b:	c1 e8 16             	shr    $0x16,%eax
  80261e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80262a:	f6 c1 01             	test   $0x1,%cl
  80262d:	74 1d                	je     80264c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80262f:	c1 ea 0c             	shr    $0xc,%edx
  802632:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802639:	f6 c2 01             	test   $0x1,%dl
  80263c:	74 0e                	je     80264c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80263e:	c1 ea 0c             	shr    $0xc,%edx
  802641:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802648:	ef 
  802649:	0f b7 c0             	movzwl %ax,%eax
}
  80264c:	5d                   	pop    %ebp
  80264d:	c3                   	ret    
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
