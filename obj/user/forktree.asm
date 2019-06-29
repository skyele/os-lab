
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 c6 0c 00 00       	call   800d08 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 00 2b 80 00       	push   $0x802b00
  80004c:	e8 a4 01 00 00       	call   8001f5 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 98 08 00 00       	call   80091b <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 11 2b 80 00       	push   $0x802b11
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 55 08 00 00       	call   800901 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 06 13 00 00       	call   8013ba <sfork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 63 00 00 00       	call   80012c <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 10 2b 80 00       	push   $0x802b10
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000ee:	e8 15 0c 00 00       	call   800d08 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800103:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	85 db                	test   %ebx,%ebx
  80010a:	7e 07                	jle    800113 <libmain+0x30>
		binaryname = argv[0];
  80010c:	8b 06                	mov    (%esi),%eax
  80010e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	e8 b1 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011d:	e8 0a 00 00 00       	call   80012c <exit>
}
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    

0080012c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800132:	a1 08 50 80 00       	mov    0x805008,%eax
  800137:	8b 40 48             	mov    0x48(%eax),%eax
  80013a:	68 2c 2b 80 00       	push   $0x802b2c
  80013f:	50                   	push   %eax
  800140:	68 20 2b 80 00       	push   $0x802b20
  800145:	e8 ab 00 00 00       	call   8001f5 <cprintf>
	close_all();
  80014a:	e8 b1 15 00 00       	call   801700 <close_all>
	sys_env_destroy(0);
  80014f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800156:	e8 6c 0b 00 00       	call   800cc7 <sys_env_destroy>
}
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

00800160 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	53                   	push   %ebx
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016a:	8b 13                	mov    (%ebx),%edx
  80016c:	8d 42 01             	lea    0x1(%edx),%eax
  80016f:	89 03                	mov    %eax,(%ebx)
  800171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800174:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800178:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017d:	74 09                	je     800188 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800186:	c9                   	leave  
  800187:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	68 ff 00 00 00       	push   $0xff
  800190:	8d 43 08             	lea    0x8(%ebx),%eax
  800193:	50                   	push   %eax
  800194:	e8 f1 0a 00 00       	call   800c8a <sys_cputs>
		b->idx = 0;
  800199:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	eb db                	jmp    80017f <putch+0x1f>

008001a4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b4:	00 00 00 
	b.cnt = 0;
  8001b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001be:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c1:	ff 75 0c             	pushl  0xc(%ebp)
  8001c4:	ff 75 08             	pushl  0x8(%ebp)
  8001c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cd:	50                   	push   %eax
  8001ce:	68 60 01 80 00       	push   $0x800160
  8001d3:	e8 4a 01 00 00       	call   800322 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d8:	83 c4 08             	add    $0x8,%esp
  8001db:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 9d 0a 00 00       	call   800c8a <sys_cputs>

	return b.cnt;
}
  8001ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fe:	50                   	push   %eax
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	e8 9d ff ff ff       	call   8001a4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	57                   	push   %edi
  80020d:	56                   	push   %esi
  80020e:	53                   	push   %ebx
  80020f:	83 ec 1c             	sub    $0x1c,%esp
  800212:	89 c6                	mov    %eax,%esi
  800214:	89 d7                	mov    %edx,%edi
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800222:	8b 45 10             	mov    0x10(%ebp),%eax
  800225:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800228:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022c:	74 2c                	je     80025a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80022e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800231:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800238:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80023b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023e:	39 c2                	cmp    %eax,%edx
  800240:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800243:	73 43                	jae    800288 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800245:	83 eb 01             	sub    $0x1,%ebx
  800248:	85 db                	test   %ebx,%ebx
  80024a:	7e 6c                	jle    8002b8 <printnum+0xaf>
				putch(padc, putdat);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	57                   	push   %edi
  800250:	ff 75 18             	pushl  0x18(%ebp)
  800253:	ff d6                	call   *%esi
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	eb eb                	jmp    800245 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	6a 20                	push   $0x20
  80025f:	6a 00                	push   $0x0
  800261:	50                   	push   %eax
  800262:	ff 75 e4             	pushl  -0x1c(%ebp)
  800265:	ff 75 e0             	pushl  -0x20(%ebp)
  800268:	89 fa                	mov    %edi,%edx
  80026a:	89 f0                	mov    %esi,%eax
  80026c:	e8 98 ff ff ff       	call   800209 <printnum>
		while (--width > 0)
  800271:	83 c4 20             	add    $0x20,%esp
  800274:	83 eb 01             	sub    $0x1,%ebx
  800277:	85 db                	test   %ebx,%ebx
  800279:	7e 65                	jle    8002e0 <printnum+0xd7>
			putch(padc, putdat);
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	57                   	push   %edi
  80027f:	6a 20                	push   $0x20
  800281:	ff d6                	call   *%esi
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	eb ec                	jmp    800274 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 18             	pushl  0x18(%ebp)
  80028e:	83 eb 01             	sub    $0x1,%ebx
  800291:	53                   	push   %ebx
  800292:	50                   	push   %eax
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	ff 75 dc             	pushl  -0x24(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029f:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a2:	e8 09 26 00 00       	call   8028b0 <__udivdi3>
  8002a7:	83 c4 18             	add    $0x18,%esp
  8002aa:	52                   	push   %edx
  8002ab:	50                   	push   %eax
  8002ac:	89 fa                	mov    %edi,%edx
  8002ae:	89 f0                	mov    %esi,%eax
  8002b0:	e8 54 ff ff ff       	call   800209 <printnum>
  8002b5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	57                   	push   %edi
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cb:	e8 f0 26 00 00       	call   8029c0 <__umoddi3>
  8002d0:	83 c4 14             	add    $0x14,%esp
  8002d3:	0f be 80 31 2b 80 00 	movsbl 0x802b31(%eax),%eax
  8002da:	50                   	push   %eax
  8002db:	ff d6                	call   *%esi
  8002dd:	83 c4 10             	add    $0x10,%esp
	}
}
  8002e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e3:	5b                   	pop    %ebx
  8002e4:	5e                   	pop    %esi
  8002e5:	5f                   	pop    %edi
  8002e6:	5d                   	pop    %ebp
  8002e7:	c3                   	ret    

008002e8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f2:	8b 10                	mov    (%eax),%edx
  8002f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f7:	73 0a                	jae    800303 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fc:	89 08                	mov    %ecx,(%eax)
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	88 02                	mov    %al,(%edx)
}
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <printfmt>:
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030e:	50                   	push   %eax
  80030f:	ff 75 10             	pushl  0x10(%ebp)
  800312:	ff 75 0c             	pushl  0xc(%ebp)
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	e8 05 00 00 00       	call   800322 <vprintfmt>
}
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <vprintfmt>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	57                   	push   %edi
  800326:	56                   	push   %esi
  800327:	53                   	push   %ebx
  800328:	83 ec 3c             	sub    $0x3c,%esp
  80032b:	8b 75 08             	mov    0x8(%ebp),%esi
  80032e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800331:	8b 7d 10             	mov    0x10(%ebp),%edi
  800334:	e9 32 04 00 00       	jmp    80076b <vprintfmt+0x449>
		padc = ' ';
  800339:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80033d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800344:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80034b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800352:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800359:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800360:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8d 47 01             	lea    0x1(%edi),%eax
  800368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036b:	0f b6 17             	movzbl (%edi),%edx
  80036e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800371:	3c 55                	cmp    $0x55,%al
  800373:	0f 87 12 05 00 00    	ja     80088b <vprintfmt+0x569>
  800379:	0f b6 c0             	movzbl %al,%eax
  80037c:	ff 24 85 00 2d 80 00 	jmp    *0x802d00(,%eax,4)
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800386:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80038a:	eb d9                	jmp    800365 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800393:	eb d0                	jmp    800365 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800395:	0f b6 d2             	movzbl %dl,%edx
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a3:	eb 03                	jmp    8003a8 <vprintfmt+0x86>
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b5:	83 fe 09             	cmp    $0x9,%esi
  8003b8:	76 eb                	jbe    8003a5 <vprintfmt+0x83>
  8003ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	eb 14                	jmp    8003d6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	8d 40 04             	lea    0x4(%eax),%eax
  8003d0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003da:	79 89                	jns    800365 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e9:	e9 77 ff ff ff       	jmp    800365 <vprintfmt+0x43>
  8003ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f1:	85 c0                	test   %eax,%eax
  8003f3:	0f 48 c1             	cmovs  %ecx,%eax
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003fc:	e9 64 ff ff ff       	jmp    800365 <vprintfmt+0x43>
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800404:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80040b:	e9 55 ff ff ff       	jmp    800365 <vprintfmt+0x43>
			lflag++;
  800410:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800417:	e9 49 ff ff ff       	jmp    800365 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8d 78 04             	lea    0x4(%eax),%edi
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	53                   	push   %ebx
  800426:	ff 30                	pushl  (%eax)
  800428:	ff d6                	call   *%esi
			break;
  80042a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800430:	e9 33 03 00 00       	jmp    800768 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8d 78 04             	lea    0x4(%eax),%edi
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	99                   	cltd   
  80043e:	31 d0                	xor    %edx,%eax
  800440:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800442:	83 f8 11             	cmp    $0x11,%eax
  800445:	7f 23                	jg     80046a <vprintfmt+0x148>
  800447:	8b 14 85 60 2e 80 00 	mov    0x802e60(,%eax,4),%edx
  80044e:	85 d2                	test   %edx,%edx
  800450:	74 18                	je     80046a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800452:	52                   	push   %edx
  800453:	68 6d 30 80 00       	push   $0x80306d
  800458:	53                   	push   %ebx
  800459:	56                   	push   %esi
  80045a:	e8 a6 fe ff ff       	call   800305 <printfmt>
  80045f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800462:	89 7d 14             	mov    %edi,0x14(%ebp)
  800465:	e9 fe 02 00 00       	jmp    800768 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046a:	50                   	push   %eax
  80046b:	68 49 2b 80 00       	push   $0x802b49
  800470:	53                   	push   %ebx
  800471:	56                   	push   %esi
  800472:	e8 8e fe ff ff       	call   800305 <printfmt>
  800477:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047d:	e9 e6 02 00 00       	jmp    800768 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	83 c0 04             	add    $0x4,%eax
  800488:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800490:	85 c9                	test   %ecx,%ecx
  800492:	b8 42 2b 80 00       	mov    $0x802b42,%eax
  800497:	0f 45 c1             	cmovne %ecx,%eax
  80049a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80049d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a1:	7e 06                	jle    8004a9 <vprintfmt+0x187>
  8004a3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a7:	75 0d                	jne    8004b6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ac:	89 c7                	mov    %eax,%edi
  8004ae:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	eb 53                	jmp    800509 <vprintfmt+0x1e7>
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bc:	50                   	push   %eax
  8004bd:	e8 71 04 00 00       	call   800933 <strnlen>
  8004c2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c5:	29 c1                	sub    %eax,%ecx
  8004c7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004cf:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d6:	eb 0f                	jmp    8004e7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	53                   	push   %ebx
  8004dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8004df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	83 ef 01             	sub    $0x1,%edi
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	85 ff                	test   %edi,%edi
  8004e9:	7f ed                	jg     8004d8 <vprintfmt+0x1b6>
  8004eb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f5:	0f 49 c1             	cmovns %ecx,%eax
  8004f8:	29 c1                	sub    %eax,%ecx
  8004fa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004fd:	eb aa                	jmp    8004a9 <vprintfmt+0x187>
					putch(ch, putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	52                   	push   %edx
  800504:	ff d6                	call   *%esi
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050e:	83 c7 01             	add    $0x1,%edi
  800511:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800515:	0f be d0             	movsbl %al,%edx
  800518:	85 d2                	test   %edx,%edx
  80051a:	74 4b                	je     800567 <vprintfmt+0x245>
  80051c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800520:	78 06                	js     800528 <vprintfmt+0x206>
  800522:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800526:	78 1e                	js     800546 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800528:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80052c:	74 d1                	je     8004ff <vprintfmt+0x1dd>
  80052e:	0f be c0             	movsbl %al,%eax
  800531:	83 e8 20             	sub    $0x20,%eax
  800534:	83 f8 5e             	cmp    $0x5e,%eax
  800537:	76 c6                	jbe    8004ff <vprintfmt+0x1dd>
					putch('?', putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	53                   	push   %ebx
  80053d:	6a 3f                	push   $0x3f
  80053f:	ff d6                	call   *%esi
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb c3                	jmp    800509 <vprintfmt+0x1e7>
  800546:	89 cf                	mov    %ecx,%edi
  800548:	eb 0e                	jmp    800558 <vprintfmt+0x236>
				putch(' ', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 20                	push   $0x20
  800550:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800552:	83 ef 01             	sub    $0x1,%edi
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	85 ff                	test   %edi,%edi
  80055a:	7f ee                	jg     80054a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80055c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
  800562:	e9 01 02 00 00       	jmp    800768 <vprintfmt+0x446>
  800567:	89 cf                	mov    %ecx,%edi
  800569:	eb ed                	jmp    800558 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80056e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800575:	e9 eb fd ff ff       	jmp    800365 <vprintfmt+0x43>
	if (lflag >= 2)
  80057a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80057e:	7f 21                	jg     8005a1 <vprintfmt+0x27f>
	else if (lflag)
  800580:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800584:	74 68                	je     8005ee <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058e:	89 c1                	mov    %eax,%ecx
  800590:	c1 f9 1f             	sar    $0x1f,%ecx
  800593:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 40 04             	lea    0x4(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
  80059f:	eb 17                	jmp    8005b8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 50 04             	mov    0x4(%eax),%edx
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c8:	78 3f                	js     800609 <vprintfmt+0x2e7>
			base = 10;
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005cf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d3:	0f 84 71 01 00 00    	je     80074a <vprintfmt+0x428>
				putch('+', putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	53                   	push   %ebx
  8005dd:	6a 2b                	push   $0x2b
  8005df:	ff d6                	call   *%esi
  8005e1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e9:	e9 5c 01 00 00       	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f6:	89 c1                	mov    %eax,%ecx
  8005f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8d 40 04             	lea    0x4(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
  800607:	eb af                	jmp    8005b8 <vprintfmt+0x296>
				putch('-', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	53                   	push   %ebx
  80060d:	6a 2d                	push   $0x2d
  80060f:	ff d6                	call   *%esi
				num = -(long long) num;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800617:	f7 d8                	neg    %eax
  800619:	83 d2 00             	adc    $0x0,%edx
  80061c:	f7 da                	neg    %edx
  80061e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800621:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800624:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800627:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062c:	e9 19 01 00 00       	jmp    80074a <vprintfmt+0x428>
	if (lflag >= 2)
  800631:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800635:	7f 29                	jg     800660 <vprintfmt+0x33e>
	else if (lflag)
  800637:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80063b:	74 44                	je     800681 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800656:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065b:	e9 ea 00 00 00       	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 50 04             	mov    0x4(%eax),%edx
  800666:	8b 00                	mov    (%eax),%eax
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 08             	lea    0x8(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800677:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067c:	e9 c9 00 00 00       	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	ba 00 00 00 00       	mov    $0x0,%edx
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 04             	lea    0x4(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069f:	e9 a6 00 00 00       	jmp    80074a <vprintfmt+0x428>
			putch('0', putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	53                   	push   %ebx
  8006a8:	6a 30                	push   $0x30
  8006aa:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b3:	7f 26                	jg     8006db <vprintfmt+0x3b9>
	else if (lflag)
  8006b5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b9:	74 3e                	je     8006f9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d9:	eb 6f                	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f7:	eb 51                	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800703:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800706:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 40 04             	lea    0x4(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800712:	b8 08 00 00 00       	mov    $0x8,%eax
  800717:	eb 31                	jmp    80074a <vprintfmt+0x428>
			putch('0', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 30                	push   $0x30
  80071f:	ff d6                	call   *%esi
			putch('x', putdat);
  800721:	83 c4 08             	add    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 78                	push   $0x78
  800727:	ff d6                	call   *%esi
			num = (unsigned long long)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800739:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800745:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074a:	83 ec 0c             	sub    $0xc,%esp
  80074d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800751:	52                   	push   %edx
  800752:	ff 75 e0             	pushl  -0x20(%ebp)
  800755:	50                   	push   %eax
  800756:	ff 75 dc             	pushl  -0x24(%ebp)
  800759:	ff 75 d8             	pushl  -0x28(%ebp)
  80075c:	89 da                	mov    %ebx,%edx
  80075e:	89 f0                	mov    %esi,%eax
  800760:	e8 a4 fa ff ff       	call   800209 <printnum>
			break;
  800765:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076b:	83 c7 01             	add    $0x1,%edi
  80076e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800772:	83 f8 25             	cmp    $0x25,%eax
  800775:	0f 84 be fb ff ff    	je     800339 <vprintfmt+0x17>
			if (ch == '\0')
  80077b:	85 c0                	test   %eax,%eax
  80077d:	0f 84 28 01 00 00    	je     8008ab <vprintfmt+0x589>
			putch(ch, putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	50                   	push   %eax
  800788:	ff d6                	call   *%esi
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	eb dc                	jmp    80076b <vprintfmt+0x449>
	if (lflag >= 2)
  80078f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800793:	7f 26                	jg     8007bb <vprintfmt+0x499>
	else if (lflag)
  800795:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800799:	74 41                	je     8007dc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b9:	eb 8f                	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 50 04             	mov    0x4(%eax),%edx
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 40 08             	lea    0x8(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d7:	e9 6e ff ff ff       	jmp    80074a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 40 04             	lea    0x4(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fa:	e9 4b ff ff ff       	jmp    80074a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	83 c0 04             	add    $0x4,%eax
  800805:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	85 c0                	test   %eax,%eax
  80080f:	74 14                	je     800825 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800811:	8b 13                	mov    (%ebx),%edx
  800813:	83 fa 7f             	cmp    $0x7f,%edx
  800816:	7f 37                	jg     80084f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800818:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80081a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
  800820:	e9 43 ff ff ff       	jmp    800768 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800825:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082a:	bf 65 2c 80 00       	mov    $0x802c65,%edi
							putch(ch, putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	53                   	push   %ebx
  800833:	50                   	push   %eax
  800834:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800836:	83 c7 01             	add    $0x1,%edi
  800839:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	85 c0                	test   %eax,%eax
  800842:	75 eb                	jne    80082f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800844:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
  80084a:	e9 19 ff ff ff       	jmp    800768 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80084f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800851:	b8 0a 00 00 00       	mov    $0xa,%eax
  800856:	bf 9d 2c 80 00       	mov    $0x802c9d,%edi
							putch(ch, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	53                   	push   %ebx
  80085f:	50                   	push   %eax
  800860:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800862:	83 c7 01             	add    $0x1,%edi
  800865:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	85 c0                	test   %eax,%eax
  80086e:	75 eb                	jne    80085b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800870:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	e9 ed fe ff ff       	jmp    800768 <vprintfmt+0x446>
			putch(ch, putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	53                   	push   %ebx
  80087f:	6a 25                	push   $0x25
  800881:	ff d6                	call   *%esi
			break;
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	e9 dd fe ff ff       	jmp    800768 <vprintfmt+0x446>
			putch('%', putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	6a 25                	push   $0x25
  800891:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	89 f8                	mov    %edi,%eax
  800898:	eb 03                	jmp    80089d <vprintfmt+0x57b>
  80089a:	83 e8 01             	sub    $0x1,%eax
  80089d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a1:	75 f7                	jne    80089a <vprintfmt+0x578>
  8008a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a6:	e9 bd fe ff ff       	jmp    800768 <vprintfmt+0x446>
}
  8008ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ae:	5b                   	pop    %ebx
  8008af:	5e                   	pop    %esi
  8008b0:	5f                   	pop    %edi
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 18             	sub    $0x18,%esp
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	74 26                	je     8008fa <vsnprintf+0x47>
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	7e 22                	jle    8008fa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d8:	ff 75 14             	pushl  0x14(%ebp)
  8008db:	ff 75 10             	pushl  0x10(%ebp)
  8008de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e1:	50                   	push   %eax
  8008e2:	68 e8 02 80 00       	push   $0x8002e8
  8008e7:	e8 36 fa ff ff       	call   800322 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    
		return -E_INVAL;
  8008fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ff:	eb f7                	jmp    8008f8 <vsnprintf+0x45>

00800901 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800907:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090a:	50                   	push   %eax
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	ff 75 08             	pushl  0x8(%ebp)
  800914:	e8 9a ff ff ff       	call   8008b3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092a:	74 05                	je     800931 <strlen+0x16>
		n++;
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	eb f5                	jmp    800926 <strlen+0xb>
	return n;
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	39 c2                	cmp    %eax,%edx
  800943:	74 0d                	je     800952 <strnlen+0x1f>
  800945:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800949:	74 05                	je     800950 <strnlen+0x1d>
		n++;
  80094b:	83 c2 01             	add    $0x1,%edx
  80094e:	eb f1                	jmp    800941 <strnlen+0xe>
  800950:	89 d0                	mov    %edx,%eax
	return n;
}
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	53                   	push   %ebx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800967:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80096a:	83 c2 01             	add    $0x1,%edx
  80096d:	84 c9                	test   %cl,%cl
  80096f:	75 f2                	jne    800963 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800971:	5b                   	pop    %ebx
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	53                   	push   %ebx
  800978:	83 ec 10             	sub    $0x10,%esp
  80097b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097e:	53                   	push   %ebx
  80097f:	e8 97 ff ff ff       	call   80091b <strlen>
  800984:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	01 d8                	add    %ebx,%eax
  80098c:	50                   	push   %eax
  80098d:	e8 c2 ff ff ff       	call   800954 <strcpy>
	return dst;
}
  800992:	89 d8                	mov    %ebx,%eax
  800994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	56                   	push   %esi
  80099d:	53                   	push   %ebx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a4:	89 c6                	mov    %eax,%esi
  8009a6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a9:	89 c2                	mov    %eax,%edx
  8009ab:	39 f2                	cmp    %esi,%edx
  8009ad:	74 11                	je     8009c0 <strncpy+0x27>
		*dst++ = *src;
  8009af:	83 c2 01             	add    $0x1,%edx
  8009b2:	0f b6 19             	movzbl (%ecx),%ebx
  8009b5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b8:	80 fb 01             	cmp    $0x1,%bl
  8009bb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009be:	eb eb                	jmp    8009ab <strncpy+0x12>
	}
	return ret;
}
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8009cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cf:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d4:	85 d2                	test   %edx,%edx
  8009d6:	74 21                	je     8009f9 <strlcpy+0x35>
  8009d8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009dc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009de:	39 c2                	cmp    %eax,%edx
  8009e0:	74 14                	je     8009f6 <strlcpy+0x32>
  8009e2:	0f b6 19             	movzbl (%ecx),%ebx
  8009e5:	84 db                	test   %bl,%bl
  8009e7:	74 0b                	je     8009f4 <strlcpy+0x30>
			*dst++ = *src++;
  8009e9:	83 c1 01             	add    $0x1,%ecx
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f2:	eb ea                	jmp    8009de <strlcpy+0x1a>
  8009f4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f9:	29 f0                	sub    %esi,%eax
}
  8009fb:	5b                   	pop    %ebx
  8009fc:	5e                   	pop    %esi
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a05:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a08:	0f b6 01             	movzbl (%ecx),%eax
  800a0b:	84 c0                	test   %al,%al
  800a0d:	74 0c                	je     800a1b <strcmp+0x1c>
  800a0f:	3a 02                	cmp    (%edx),%al
  800a11:	75 08                	jne    800a1b <strcmp+0x1c>
		p++, q++;
  800a13:	83 c1 01             	add    $0x1,%ecx
  800a16:	83 c2 01             	add    $0x1,%edx
  800a19:	eb ed                	jmp    800a08 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1b:	0f b6 c0             	movzbl %al,%eax
  800a1e:	0f b6 12             	movzbl (%edx),%edx
  800a21:	29 d0                	sub    %edx,%eax
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	53                   	push   %ebx
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2f:	89 c3                	mov    %eax,%ebx
  800a31:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a34:	eb 06                	jmp    800a3c <strncmp+0x17>
		n--, p++, q++;
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3c:	39 d8                	cmp    %ebx,%eax
  800a3e:	74 16                	je     800a56 <strncmp+0x31>
  800a40:	0f b6 08             	movzbl (%eax),%ecx
  800a43:	84 c9                	test   %cl,%cl
  800a45:	74 04                	je     800a4b <strncmp+0x26>
  800a47:	3a 0a                	cmp    (%edx),%cl
  800a49:	74 eb                	je     800a36 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4b:	0f b6 00             	movzbl (%eax),%eax
  800a4e:	0f b6 12             	movzbl (%edx),%edx
  800a51:	29 d0                	sub    %edx,%eax
}
  800a53:	5b                   	pop    %ebx
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    
		return 0;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	eb f6                	jmp    800a53 <strncmp+0x2e>

00800a5d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a67:	0f b6 10             	movzbl (%eax),%edx
  800a6a:	84 d2                	test   %dl,%dl
  800a6c:	74 09                	je     800a77 <strchr+0x1a>
		if (*s == c)
  800a6e:	38 ca                	cmp    %cl,%dl
  800a70:	74 0a                	je     800a7c <strchr+0x1f>
	for (; *s; s++)
  800a72:	83 c0 01             	add    $0x1,%eax
  800a75:	eb f0                	jmp    800a67 <strchr+0xa>
			return (char *) s;
	return 0;
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a88:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8b:	38 ca                	cmp    %cl,%dl
  800a8d:	74 09                	je     800a98 <strfind+0x1a>
  800a8f:	84 d2                	test   %dl,%dl
  800a91:	74 05                	je     800a98 <strfind+0x1a>
	for (; *s; s++)
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	eb f0                	jmp    800a88 <strfind+0xa>
			break;
	return (char *) s;
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	57                   	push   %edi
  800a9e:	56                   	push   %esi
  800a9f:	53                   	push   %ebx
  800aa0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa6:	85 c9                	test   %ecx,%ecx
  800aa8:	74 31                	je     800adb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aaa:	89 f8                	mov    %edi,%eax
  800aac:	09 c8                	or     %ecx,%eax
  800aae:	a8 03                	test   $0x3,%al
  800ab0:	75 23                	jne    800ad5 <memset+0x3b>
		c &= 0xFF;
  800ab2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab6:	89 d3                	mov    %edx,%ebx
  800ab8:	c1 e3 08             	shl    $0x8,%ebx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	c1 e0 18             	shl    $0x18,%eax
  800ac0:	89 d6                	mov    %edx,%esi
  800ac2:	c1 e6 10             	shl    $0x10,%esi
  800ac5:	09 f0                	or     %esi,%eax
  800ac7:	09 c2                	or     %eax,%edx
  800ac9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	fc                   	cld    
  800ad1:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad3:	eb 06                	jmp    800adb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	fc                   	cld    
  800ad9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adb:	89 f8                	mov    %edi,%eax
  800add:	5b                   	pop    %ebx
  800ade:	5e                   	pop    %esi
  800adf:	5f                   	pop    %edi
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	57                   	push   %edi
  800ae6:	56                   	push   %esi
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af0:	39 c6                	cmp    %eax,%esi
  800af2:	73 32                	jae    800b26 <memmove+0x44>
  800af4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af7:	39 c2                	cmp    %eax,%edx
  800af9:	76 2b                	jbe    800b26 <memmove+0x44>
		s += n;
		d += n;
  800afb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afe:	89 fe                	mov    %edi,%esi
  800b00:	09 ce                	or     %ecx,%esi
  800b02:	09 d6                	or     %edx,%esi
  800b04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0a:	75 0e                	jne    800b1a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0c:	83 ef 04             	sub    $0x4,%edi
  800b0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b15:	fd                   	std    
  800b16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b18:	eb 09                	jmp    800b23 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1a:	83 ef 01             	sub    $0x1,%edi
  800b1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b20:	fd                   	std    
  800b21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b23:	fc                   	cld    
  800b24:	eb 1a                	jmp    800b40 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b26:	89 c2                	mov    %eax,%edx
  800b28:	09 ca                	or     %ecx,%edx
  800b2a:	09 f2                	or     %esi,%edx
  800b2c:	f6 c2 03             	test   $0x3,%dl
  800b2f:	75 0a                	jne    800b3b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b34:	89 c7                	mov    %eax,%edi
  800b36:	fc                   	cld    
  800b37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b39:	eb 05                	jmp    800b40 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	fc                   	cld    
  800b3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4a:	ff 75 10             	pushl  0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 8a ff ff ff       	call   800ae2 <memmove>
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b65:	89 c6                	mov    %eax,%esi
  800b67:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6a:	39 f0                	cmp    %esi,%eax
  800b6c:	74 1c                	je     800b8a <memcmp+0x30>
		if (*s1 != *s2)
  800b6e:	0f b6 08             	movzbl (%eax),%ecx
  800b71:	0f b6 1a             	movzbl (%edx),%ebx
  800b74:	38 d9                	cmp    %bl,%cl
  800b76:	75 08                	jne    800b80 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b78:	83 c0 01             	add    $0x1,%eax
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	eb ea                	jmp    800b6a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b80:	0f b6 c1             	movzbl %cl,%eax
  800b83:	0f b6 db             	movzbl %bl,%ebx
  800b86:	29 d8                	sub    %ebx,%eax
  800b88:	eb 05                	jmp    800b8f <memcmp+0x35>
	}

	return 0;
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba1:	39 d0                	cmp    %edx,%eax
  800ba3:	73 09                	jae    800bae <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba5:	38 08                	cmp    %cl,(%eax)
  800ba7:	74 05                	je     800bae <memfind+0x1b>
	for (; s < ends; s++)
  800ba9:	83 c0 01             	add    $0x1,%eax
  800bac:	eb f3                	jmp    800ba1 <memfind+0xe>
			break;
	return (void *) s;
}
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbc:	eb 03                	jmp    800bc1 <strtol+0x11>
		s++;
  800bbe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc1:	0f b6 01             	movzbl (%ecx),%eax
  800bc4:	3c 20                	cmp    $0x20,%al
  800bc6:	74 f6                	je     800bbe <strtol+0xe>
  800bc8:	3c 09                	cmp    $0x9,%al
  800bca:	74 f2                	je     800bbe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bcc:	3c 2b                	cmp    $0x2b,%al
  800bce:	74 2a                	je     800bfa <strtol+0x4a>
	int neg = 0;
  800bd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd5:	3c 2d                	cmp    $0x2d,%al
  800bd7:	74 2b                	je     800c04 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bdf:	75 0f                	jne    800bf0 <strtol+0x40>
  800be1:	80 39 30             	cmpb   $0x30,(%ecx)
  800be4:	74 28                	je     800c0e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bed:	0f 44 d8             	cmove  %eax,%ebx
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf8:	eb 50                	jmp    800c4a <strtol+0x9a>
		s++;
  800bfa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  800c02:	eb d5                	jmp    800bd9 <strtol+0x29>
		s++, neg = 1;
  800c04:	83 c1 01             	add    $0x1,%ecx
  800c07:	bf 01 00 00 00       	mov    $0x1,%edi
  800c0c:	eb cb                	jmp    800bd9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c12:	74 0e                	je     800c22 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c14:	85 db                	test   %ebx,%ebx
  800c16:	75 d8                	jne    800bf0 <strtol+0x40>
		s++, base = 8;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c20:	eb ce                	jmp    800bf0 <strtol+0x40>
		s += 2, base = 16;
  800c22:	83 c1 02             	add    $0x2,%ecx
  800c25:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c2a:	eb c4                	jmp    800bf0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c2c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2f:	89 f3                	mov    %esi,%ebx
  800c31:	80 fb 19             	cmp    $0x19,%bl
  800c34:	77 29                	ja     800c5f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c36:	0f be d2             	movsbl %dl,%edx
  800c39:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3f:	7d 30                	jge    800c71 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c41:	83 c1 01             	add    $0x1,%ecx
  800c44:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c48:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4a:	0f b6 11             	movzbl (%ecx),%edx
  800c4d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	80 fb 09             	cmp    $0x9,%bl
  800c55:	77 d5                	ja     800c2c <strtol+0x7c>
			dig = *s - '0';
  800c57:	0f be d2             	movsbl %dl,%edx
  800c5a:	83 ea 30             	sub    $0x30,%edx
  800c5d:	eb dd                	jmp    800c3c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c62:	89 f3                	mov    %esi,%ebx
  800c64:	80 fb 19             	cmp    $0x19,%bl
  800c67:	77 08                	ja     800c71 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c69:	0f be d2             	movsbl %dl,%edx
  800c6c:	83 ea 37             	sub    $0x37,%edx
  800c6f:	eb cb                	jmp    800c3c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c75:	74 05                	je     800c7c <strtol+0xcc>
		*endptr = (char *) s;
  800c77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c7c:	89 c2                	mov    %eax,%edx
  800c7e:	f7 da                	neg    %edx
  800c80:	85 ff                	test   %edi,%edi
  800c82:	0f 45 c2             	cmovne %edx,%eax
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	89 c3                	mov    %eax,%ebx
  800c9d:	89 c7                	mov    %eax,%edi
  800c9f:	89 c6                	mov    %eax,%esi
  800ca1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cae:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb8:	89 d1                	mov    %edx,%ecx
  800cba:	89 d3                	mov    %edx,%ebx
  800cbc:	89 d7                	mov    %edx,%edi
  800cbe:	89 d6                	mov    %edx,%esi
  800cc0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdd:	89 cb                	mov    %ecx,%ebx
  800cdf:	89 cf                	mov    %ecx,%edi
  800ce1:	89 ce                	mov    %ecx,%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 03                	push   $0x3
  800cf7:	68 a8 2e 80 00       	push   $0x802ea8
  800cfc:	6a 43                	push   $0x43
  800cfe:	68 c5 2e 80 00       	push   $0x802ec5
  800d03:	e8 76 19 00 00       	call   80267e <_panic>

00800d08 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d13:	b8 02 00 00 00       	mov    $0x2,%eax
  800d18:	89 d1                	mov    %edx,%ecx
  800d1a:	89 d3                	mov    %edx,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 d6                	mov    %edx,%esi
  800d20:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_yield>:

void
sys_yield(void)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	be 00 00 00 00       	mov    $0x0,%esi
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d62:	89 f7                	mov    %esi,%edi
  800d64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7f 08                	jg     800d72 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	83 ec 0c             	sub    $0xc,%esp
  800d75:	50                   	push   %eax
  800d76:	6a 04                	push   $0x4
  800d78:	68 a8 2e 80 00       	push   $0x802ea8
  800d7d:	6a 43                	push   $0x43
  800d7f:	68 c5 2e 80 00       	push   $0x802ec5
  800d84:	e8 f5 18 00 00       	call   80267e <_panic>

00800d89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d92:	8b 55 08             	mov    0x8(%ebp),%edx
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	8b 75 18             	mov    0x18(%ebp),%esi
  800da6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7f 08                	jg     800db4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db4:	83 ec 0c             	sub    $0xc,%esp
  800db7:	50                   	push   %eax
  800db8:	6a 05                	push   $0x5
  800dba:	68 a8 2e 80 00       	push   $0x802ea8
  800dbf:	6a 43                	push   $0x43
  800dc1:	68 c5 2e 80 00       	push   $0x802ec5
  800dc6:	e8 b3 18 00 00       	call   80267e <_panic>

00800dcb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	b8 06 00 00 00       	mov    $0x6,%eax
  800de4:	89 df                	mov    %ebx,%edi
  800de6:	89 de                	mov    %ebx,%esi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 06                	push   $0x6
  800dfc:	68 a8 2e 80 00       	push   $0x802ea8
  800e01:	6a 43                	push   $0x43
  800e03:	68 c5 2e 80 00       	push   $0x802ec5
  800e08:	e8 71 18 00 00       	call   80267e <_panic>

00800e0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 08 00 00 00       	mov    $0x8,%eax
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 08                	push   $0x8
  800e3e:	68 a8 2e 80 00       	push   $0x802ea8
  800e43:	6a 43                	push   $0x43
  800e45:	68 c5 2e 80 00       	push   $0x802ec5
  800e4a:	e8 2f 18 00 00       	call   80267e <_panic>

00800e4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 09 00 00 00       	mov    $0x9,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 09                	push   $0x9
  800e80:	68 a8 2e 80 00       	push   $0x802ea8
  800e85:	6a 43                	push   $0x43
  800e87:	68 c5 2e 80 00       	push   $0x802ec5
  800e8c:	e8 ed 17 00 00       	call   80267e <_panic>

00800e91 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7f 08                	jg     800ebc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	50                   	push   %eax
  800ec0:	6a 0a                	push   $0xa
  800ec2:	68 a8 2e 80 00       	push   $0x802ea8
  800ec7:	6a 43                	push   $0x43
  800ec9:	68 c5 2e 80 00       	push   $0x802ec5
  800ece:	e8 ab 17 00 00       	call   80267e <_panic>

00800ed3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee4:	be 00 00 00 00       	mov    $0x0,%esi
  800ee9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eec:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eef:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
  800efc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0c:	89 cb                	mov    %ecx,%ebx
  800f0e:	89 cf                	mov    %ecx,%edi
  800f10:	89 ce                	mov    %ecx,%esi
  800f12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7f 08                	jg     800f20 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	50                   	push   %eax
  800f24:	6a 0d                	push   $0xd
  800f26:	68 a8 2e 80 00       	push   $0x802ea8
  800f2b:	6a 43                	push   $0x43
  800f2d:	68 c5 2e 80 00       	push   $0x802ec5
  800f32:	e8 47 17 00 00       	call   80267e <_panic>

00800f37 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4d:	89 df                	mov    %ebx,%edi
  800f4f:	89 de                	mov    %ebx,%esi
  800f51:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f6b:	89 cb                	mov    %ecx,%ebx
  800f6d:	89 cf                	mov    %ecx,%edi
  800f6f:	89 ce                	mov    %ecx,%esi
  800f71:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    

00800f78 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f83:	b8 10 00 00 00       	mov    $0x10,%eax
  800f88:	89 d1                	mov    %edx,%ecx
  800f8a:	89 d3                	mov    %edx,%ebx
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	89 d6                	mov    %edx,%esi
  800f90:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa8:	b8 11 00 00 00       	mov    $0x11,%eax
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	b8 12 00 00 00       	mov    $0x12,%eax
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fed:	b8 13 00 00 00       	mov    $0x13,%eax
  800ff2:	89 df                	mov    %ebx,%edi
  800ff4:	89 de                	mov    %ebx,%esi
  800ff6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	7f 08                	jg     801004 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	50                   	push   %eax
  801008:	6a 13                	push   $0x13
  80100a:	68 a8 2e 80 00       	push   $0x802ea8
  80100f:	6a 43                	push   $0x43
  801011:	68 c5 2e 80 00       	push   $0x802ec5
  801016:	e8 63 16 00 00       	call   80267e <_panic>

0080101b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
	asm volatile("int %1\n"
  801021:	b9 00 00 00 00       	mov    $0x0,%ecx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	b8 14 00 00 00       	mov    $0x14,%eax
  80102e:	89 cb                	mov    %ecx,%ebx
  801030:	89 cf                	mov    %ecx,%edi
  801032:	89 ce                	mov    %ecx,%esi
  801034:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	53                   	push   %ebx
  80103f:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801042:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801049:	f6 c5 04             	test   $0x4,%ch
  80104c:	75 45                	jne    801093 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80104e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801055:	83 e1 07             	and    $0x7,%ecx
  801058:	83 f9 07             	cmp    $0x7,%ecx
  80105b:	74 6f                	je     8010cc <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80105d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801064:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80106a:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801070:	0f 84 b6 00 00 00    	je     80112c <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801076:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80107d:	83 e1 05             	and    $0x5,%ecx
  801080:	83 f9 05             	cmp    $0x5,%ecx
  801083:	0f 84 d7 00 00 00    	je     801160 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
  80108e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801091:	c9                   	leave  
  801092:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801093:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80109a:	c1 e2 0c             	shl    $0xc,%edx
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010a6:	51                   	push   %ecx
  8010a7:	52                   	push   %edx
  8010a8:	50                   	push   %eax
  8010a9:	52                   	push   %edx
  8010aa:	6a 00                	push   $0x0
  8010ac:	e8 d8 fc ff ff       	call   800d89 <sys_page_map>
		if(r < 0)
  8010b1:	83 c4 20             	add    $0x20,%esp
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	79 d1                	jns    801089 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010b8:	83 ec 04             	sub    $0x4,%esp
  8010bb:	68 d3 2e 80 00       	push   $0x802ed3
  8010c0:	6a 54                	push   $0x54
  8010c2:	68 e9 2e 80 00       	push   $0x802ee9
  8010c7:	e8 b2 15 00 00       	call   80267e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010cc:	89 d3                	mov    %edx,%ebx
  8010ce:	c1 e3 0c             	shl    $0xc,%ebx
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	68 05 08 00 00       	push   $0x805
  8010d9:	53                   	push   %ebx
  8010da:	50                   	push   %eax
  8010db:	53                   	push   %ebx
  8010dc:	6a 00                	push   $0x0
  8010de:	e8 a6 fc ff ff       	call   800d89 <sys_page_map>
		if(r < 0)
  8010e3:	83 c4 20             	add    $0x20,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	78 2e                	js     801118 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	68 05 08 00 00       	push   $0x805
  8010f2:	53                   	push   %ebx
  8010f3:	6a 00                	push   $0x0
  8010f5:	53                   	push   %ebx
  8010f6:	6a 00                	push   $0x0
  8010f8:	e8 8c fc ff ff       	call   800d89 <sys_page_map>
		if(r < 0)
  8010fd:	83 c4 20             	add    $0x20,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	79 85                	jns    801089 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	68 d3 2e 80 00       	push   $0x802ed3
  80110c:	6a 5f                	push   $0x5f
  80110e:	68 e9 2e 80 00       	push   $0x802ee9
  801113:	e8 66 15 00 00       	call   80267e <_panic>
			panic("sys_page_map() panic\n");
  801118:	83 ec 04             	sub    $0x4,%esp
  80111b:	68 d3 2e 80 00       	push   $0x802ed3
  801120:	6a 5b                	push   $0x5b
  801122:	68 e9 2e 80 00       	push   $0x802ee9
  801127:	e8 52 15 00 00       	call   80267e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80112c:	c1 e2 0c             	shl    $0xc,%edx
  80112f:	83 ec 0c             	sub    $0xc,%esp
  801132:	68 05 08 00 00       	push   $0x805
  801137:	52                   	push   %edx
  801138:	50                   	push   %eax
  801139:	52                   	push   %edx
  80113a:	6a 00                	push   $0x0
  80113c:	e8 48 fc ff ff       	call   800d89 <sys_page_map>
		if(r < 0)
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	0f 89 3d ff ff ff    	jns    801089 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	68 d3 2e 80 00       	push   $0x802ed3
  801154:	6a 66                	push   $0x66
  801156:	68 e9 2e 80 00       	push   $0x802ee9
  80115b:	e8 1e 15 00 00       	call   80267e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801160:	c1 e2 0c             	shl    $0xc,%edx
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	6a 05                	push   $0x5
  801168:	52                   	push   %edx
  801169:	50                   	push   %eax
  80116a:	52                   	push   %edx
  80116b:	6a 00                	push   $0x0
  80116d:	e8 17 fc ff ff       	call   800d89 <sys_page_map>
		if(r < 0)
  801172:	83 c4 20             	add    $0x20,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	0f 89 0c ff ff ff    	jns    801089 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80117d:	83 ec 04             	sub    $0x4,%esp
  801180:	68 d3 2e 80 00       	push   $0x802ed3
  801185:	6a 6d                	push   $0x6d
  801187:	68 e9 2e 80 00       	push   $0x802ee9
  80118c:	e8 ed 14 00 00       	call   80267e <_panic>

00801191 <pgfault>:
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	53                   	push   %ebx
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80119b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80119d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011a1:	0f 84 99 00 00 00    	je     801240 <pgfault+0xaf>
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	c1 ea 16             	shr    $0x16,%edx
  8011ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b3:	f6 c2 01             	test   $0x1,%dl
  8011b6:	0f 84 84 00 00 00    	je     801240 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011bc:	89 c2                	mov    %eax,%edx
  8011be:	c1 ea 0c             	shr    $0xc,%edx
  8011c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c8:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ce:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011d4:	75 6a                	jne    801240 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	6a 07                	push   $0x7
  8011e2:	68 00 f0 7f 00       	push   $0x7ff000
  8011e7:	6a 00                	push   $0x0
  8011e9:	e8 58 fb ff ff       	call   800d46 <sys_page_alloc>
	if(ret < 0)
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 5f                	js     801254 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011f5:	83 ec 04             	sub    $0x4,%esp
  8011f8:	68 00 10 00 00       	push   $0x1000
  8011fd:	53                   	push   %ebx
  8011fe:	68 00 f0 7f 00       	push   $0x7ff000
  801203:	e8 3c f9 ff ff       	call   800b44 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801208:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80120f:	53                   	push   %ebx
  801210:	6a 00                	push   $0x0
  801212:	68 00 f0 7f 00       	push   $0x7ff000
  801217:	6a 00                	push   $0x0
  801219:	e8 6b fb ff ff       	call   800d89 <sys_page_map>
	if(ret < 0)
  80121e:	83 c4 20             	add    $0x20,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 43                	js     801268 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	68 00 f0 7f 00       	push   $0x7ff000
  80122d:	6a 00                	push   $0x0
  80122f:	e8 97 fb ff ff       	call   800dcb <sys_page_unmap>
	if(ret < 0)
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 41                	js     80127c <pgfault+0xeb>
}
  80123b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801240:	83 ec 04             	sub    $0x4,%esp
  801243:	68 f4 2e 80 00       	push   $0x802ef4
  801248:	6a 26                	push   $0x26
  80124a:	68 e9 2e 80 00       	push   $0x802ee9
  80124f:	e8 2a 14 00 00       	call   80267e <_panic>
		panic("panic in sys_page_alloc()\n");
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	68 08 2f 80 00       	push   $0x802f08
  80125c:	6a 31                	push   $0x31
  80125e:	68 e9 2e 80 00       	push   $0x802ee9
  801263:	e8 16 14 00 00       	call   80267e <_panic>
		panic("panic in sys_page_map()\n");
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	68 23 2f 80 00       	push   $0x802f23
  801270:	6a 36                	push   $0x36
  801272:	68 e9 2e 80 00       	push   $0x802ee9
  801277:	e8 02 14 00 00       	call   80267e <_panic>
		panic("panic in sys_page_unmap()\n");
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	68 3c 2f 80 00       	push   $0x802f3c
  801284:	6a 39                	push   $0x39
  801286:	68 e9 2e 80 00       	push   $0x802ee9
  80128b:	e8 ee 13 00 00       	call   80267e <_panic>

00801290 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801299:	68 91 11 80 00       	push   $0x801191
  80129e:	e8 3c 14 00 00       	call   8026df <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012a3:	b8 07 00 00 00       	mov    $0x7,%eax
  8012a8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 2a                	js     8012db <fork+0x4b>
  8012b1:	89 c6                	mov    %eax,%esi
  8012b3:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012b5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012ba:	75 4b                	jne    801307 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012bc:	e8 47 fa ff ff       	call   800d08 <sys_getenvid>
  8012c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012c6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8012cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012d1:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012d6:	e9 90 00 00 00       	jmp    80136b <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8012db:	83 ec 04             	sub    $0x4,%esp
  8012de:	68 58 2f 80 00       	push   $0x802f58
  8012e3:	68 8c 00 00 00       	push   $0x8c
  8012e8:	68 e9 2e 80 00       	push   $0x802ee9
  8012ed:	e8 8c 13 00 00       	call   80267e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012f2:	89 f8                	mov    %edi,%eax
  8012f4:	e8 42 fd ff ff       	call   80103b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012ff:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801305:	74 26                	je     80132d <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801307:	89 d8                	mov    %ebx,%eax
  801309:	c1 e8 16             	shr    $0x16,%eax
  80130c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801313:	a8 01                	test   $0x1,%al
  801315:	74 e2                	je     8012f9 <fork+0x69>
  801317:	89 da                	mov    %ebx,%edx
  801319:	c1 ea 0c             	shr    $0xc,%edx
  80131c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801323:	83 e0 05             	and    $0x5,%eax
  801326:	83 f8 05             	cmp    $0x5,%eax
  801329:	75 ce                	jne    8012f9 <fork+0x69>
  80132b:	eb c5                	jmp    8012f2 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80132d:	83 ec 04             	sub    $0x4,%esp
  801330:	6a 07                	push   $0x7
  801332:	68 00 f0 bf ee       	push   $0xeebff000
  801337:	56                   	push   %esi
  801338:	e8 09 fa ff ff       	call   800d46 <sys_page_alloc>
	if(ret < 0)
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	78 31                	js     801375 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801344:	83 ec 08             	sub    $0x8,%esp
  801347:	68 4e 27 80 00       	push   $0x80274e
  80134c:	56                   	push   %esi
  80134d:	e8 3f fb ff ff       	call   800e91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 33                	js     80138c <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	6a 02                	push   $0x2
  80135e:	56                   	push   %esi
  80135f:	e8 a9 fa ff ff       	call   800e0d <sys_env_set_status>
	if(ret < 0)
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 38                	js     8013a3 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801370:	5b                   	pop    %ebx
  801371:	5e                   	pop    %esi
  801372:	5f                   	pop    %edi
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 08 2f 80 00       	push   $0x802f08
  80137d:	68 98 00 00 00       	push   $0x98
  801382:	68 e9 2e 80 00       	push   $0x802ee9
  801387:	e8 f2 12 00 00       	call   80267e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	68 7c 2f 80 00       	push   $0x802f7c
  801394:	68 9b 00 00 00       	push   $0x9b
  801399:	68 e9 2e 80 00       	push   $0x802ee9
  80139e:	e8 db 12 00 00       	call   80267e <_panic>
		panic("panic in sys_env_set_status()\n");
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 a4 2f 80 00       	push   $0x802fa4
  8013ab:	68 9e 00 00 00       	push   $0x9e
  8013b0:	68 e9 2e 80 00       	push   $0x802ee9
  8013b5:	e8 c4 12 00 00       	call   80267e <_panic>

008013ba <sfork>:

// Challenge!
int
sfork(void)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013c3:	68 91 11 80 00       	push   $0x801191
  8013c8:	e8 12 13 00 00       	call   8026df <set_pgfault_handler>
  8013cd:	b8 07 00 00 00       	mov    $0x7,%eax
  8013d2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013d4:	83 c4 10             	add    $0x10,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 2a                	js     801405 <sfork+0x4b>
  8013db:	89 c7                	mov    %eax,%edi
  8013dd:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013df:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013e4:	75 58                	jne    80143e <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013e6:	e8 1d f9 ff ff       	call   800d08 <sys_getenvid>
  8013eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013f0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013fb:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801400:	e9 d4 00 00 00       	jmp    8014d9 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801405:	83 ec 04             	sub    $0x4,%esp
  801408:	68 58 2f 80 00       	push   $0x802f58
  80140d:	68 af 00 00 00       	push   $0xaf
  801412:	68 e9 2e 80 00       	push   $0x802ee9
  801417:	e8 62 12 00 00       	call   80267e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80141c:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801421:	89 f0                	mov    %esi,%eax
  801423:	e8 13 fc ff ff       	call   80103b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801428:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80142e:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801434:	77 65                	ja     80149b <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801436:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80143c:	74 de                	je     80141c <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80143e:	89 d8                	mov    %ebx,%eax
  801440:	c1 e8 16             	shr    $0x16,%eax
  801443:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80144a:	a8 01                	test   $0x1,%al
  80144c:	74 da                	je     801428 <sfork+0x6e>
  80144e:	89 da                	mov    %ebx,%edx
  801450:	c1 ea 0c             	shr    $0xc,%edx
  801453:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80145a:	83 e0 05             	and    $0x5,%eax
  80145d:	83 f8 05             	cmp    $0x5,%eax
  801460:	75 c6                	jne    801428 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801462:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801469:	c1 e2 0c             	shl    $0xc,%edx
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	83 e0 07             	and    $0x7,%eax
  801472:	50                   	push   %eax
  801473:	52                   	push   %edx
  801474:	56                   	push   %esi
  801475:	52                   	push   %edx
  801476:	6a 00                	push   $0x0
  801478:	e8 0c f9 ff ff       	call   800d89 <sys_page_map>
  80147d:	83 c4 20             	add    $0x20,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	74 a4                	je     801428 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	68 d3 2e 80 00       	push   $0x802ed3
  80148c:	68 ba 00 00 00       	push   $0xba
  801491:	68 e9 2e 80 00       	push   $0x802ee9
  801496:	e8 e3 11 00 00       	call   80267e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	6a 07                	push   $0x7
  8014a0:	68 00 f0 bf ee       	push   $0xeebff000
  8014a5:	57                   	push   %edi
  8014a6:	e8 9b f8 ff ff       	call   800d46 <sys_page_alloc>
	if(ret < 0)
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 31                	js     8014e3 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	68 4e 27 80 00       	push   $0x80274e
  8014ba:	57                   	push   %edi
  8014bb:	e8 d1 f9 ff ff       	call   800e91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 33                	js     8014fa <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	6a 02                	push   $0x2
  8014cc:	57                   	push   %edi
  8014cd:	e8 3b f9 ff ff       	call   800e0d <sys_env_set_status>
	if(ret < 0)
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	78 38                	js     801511 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014d9:	89 f8                	mov    %edi,%eax
  8014db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014de:	5b                   	pop    %ebx
  8014df:	5e                   	pop    %esi
  8014e0:	5f                   	pop    %edi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 08 2f 80 00       	push   $0x802f08
  8014eb:	68 c0 00 00 00       	push   $0xc0
  8014f0:	68 e9 2e 80 00       	push   $0x802ee9
  8014f5:	e8 84 11 00 00       	call   80267e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	68 7c 2f 80 00       	push   $0x802f7c
  801502:	68 c3 00 00 00       	push   $0xc3
  801507:	68 e9 2e 80 00       	push   $0x802ee9
  80150c:	e8 6d 11 00 00       	call   80267e <_panic>
		panic("panic in sys_env_set_status()\n");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 a4 2f 80 00       	push   $0x802fa4
  801519:	68 c6 00 00 00       	push   $0xc6
  80151e:	68 e9 2e 80 00       	push   $0x802ee9
  801523:	e8 56 11 00 00       	call   80267e <_panic>

00801528 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	05 00 00 00 30       	add    $0x30000000,%eax
  801533:	c1 e8 0c             	shr    $0xc,%eax
}
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801548:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801557:	89 c2                	mov    %eax,%edx
  801559:	c1 ea 16             	shr    $0x16,%edx
  80155c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801563:	f6 c2 01             	test   $0x1,%dl
  801566:	74 2d                	je     801595 <fd_alloc+0x46>
  801568:	89 c2                	mov    %eax,%edx
  80156a:	c1 ea 0c             	shr    $0xc,%edx
  80156d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801574:	f6 c2 01             	test   $0x1,%dl
  801577:	74 1c                	je     801595 <fd_alloc+0x46>
  801579:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80157e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801583:	75 d2                	jne    801557 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80158e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801593:	eb 0a                	jmp    80159f <fd_alloc+0x50>
			*fd_store = fd;
  801595:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801598:	89 01                	mov    %eax,(%ecx)
			return 0;
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015a7:	83 f8 1f             	cmp    $0x1f,%eax
  8015aa:	77 30                	ja     8015dc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015ac:	c1 e0 0c             	shl    $0xc,%eax
  8015af:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015b4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015ba:	f6 c2 01             	test   $0x1,%dl
  8015bd:	74 24                	je     8015e3 <fd_lookup+0x42>
  8015bf:	89 c2                	mov    %eax,%edx
  8015c1:	c1 ea 0c             	shr    $0xc,%edx
  8015c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015cb:	f6 c2 01             	test   $0x1,%dl
  8015ce:	74 1a                	je     8015ea <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    
		return -E_INVAL;
  8015dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e1:	eb f7                	jmp    8015da <fd_lookup+0x39>
		return -E_INVAL;
  8015e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e8:	eb f0                	jmp    8015da <fd_lookup+0x39>
  8015ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ef:	eb e9                	jmp    8015da <fd_lookup+0x39>

008015f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801604:	39 08                	cmp    %ecx,(%eax)
  801606:	74 38                	je     801640 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801608:	83 c2 01             	add    $0x1,%edx
  80160b:	8b 04 95 40 30 80 00 	mov    0x803040(,%edx,4),%eax
  801612:	85 c0                	test   %eax,%eax
  801614:	75 ee                	jne    801604 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801616:	a1 08 50 80 00       	mov    0x805008,%eax
  80161b:	8b 40 48             	mov    0x48(%eax),%eax
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	51                   	push   %ecx
  801622:	50                   	push   %eax
  801623:	68 c4 2f 80 00       	push   $0x802fc4
  801628:	e8 c8 eb ff ff       	call   8001f5 <cprintf>
	*dev = 0;
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    
			*dev = devtab[i];
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 01                	mov    %eax,(%ecx)
			return 0;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb f2                	jmp    80163e <dev_lookup+0x4d>

0080164c <fd_close>:
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	57                   	push   %edi
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	83 ec 24             	sub    $0x24,%esp
  801655:	8b 75 08             	mov    0x8(%ebp),%esi
  801658:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80165b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80165e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80165f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801665:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801668:	50                   	push   %eax
  801669:	e8 33 ff ff ff       	call   8015a1 <fd_lookup>
  80166e:	89 c3                	mov    %eax,%ebx
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	78 05                	js     80167c <fd_close+0x30>
	    || fd != fd2)
  801677:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80167a:	74 16                	je     801692 <fd_close+0x46>
		return (must_exist ? r : 0);
  80167c:	89 f8                	mov    %edi,%eax
  80167e:	84 c0                	test   %al,%al
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
  801685:	0f 44 d8             	cmove  %eax,%ebx
}
  801688:	89 d8                	mov    %ebx,%eax
  80168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801698:	50                   	push   %eax
  801699:	ff 36                	pushl  (%esi)
  80169b:	e8 51 ff ff ff       	call   8015f1 <dev_lookup>
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 1a                	js     8016c3 <fd_close+0x77>
		if (dev->dev_close)
  8016a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ac:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016af:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	74 0b                	je     8016c3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	56                   	push   %esi
  8016bc:	ff d0                	call   *%eax
  8016be:	89 c3                	mov    %eax,%ebx
  8016c0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	56                   	push   %esi
  8016c7:	6a 00                	push   $0x0
  8016c9:	e8 fd f6 ff ff       	call   800dcb <sys_page_unmap>
	return r;
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	eb b5                	jmp    801688 <fd_close+0x3c>

008016d3 <close>:

int
close(int fdnum)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 bc fe ff ff       	call   8015a1 <fd_lookup>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	79 02                	jns    8016ee <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    
		return fd_close(fd, 1);
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	6a 01                	push   $0x1
  8016f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f6:	e8 51 ff ff ff       	call   80164c <fd_close>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	eb ec                	jmp    8016ec <close+0x19>

00801700 <close_all>:

void
close_all(void)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	53                   	push   %ebx
  801704:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801707:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	53                   	push   %ebx
  801710:	e8 be ff ff ff       	call   8016d3 <close>
	for (i = 0; i < MAXFD; i++)
  801715:	83 c3 01             	add    $0x1,%ebx
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	83 fb 20             	cmp    $0x20,%ebx
  80171e:	75 ec                	jne    80170c <close_all+0xc>
}
  801720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	57                   	push   %edi
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
  80172b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80172e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 67 fe ff ff       	call   8015a1 <fd_lookup>
  80173a:	89 c3                	mov    %eax,%ebx
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	85 c0                	test   %eax,%eax
  801741:	0f 88 81 00 00 00    	js     8017c8 <dup+0xa3>
		return r;
	close(newfdnum);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	ff 75 0c             	pushl  0xc(%ebp)
  80174d:	e8 81 ff ff ff       	call   8016d3 <close>

	newfd = INDEX2FD(newfdnum);
  801752:	8b 75 0c             	mov    0xc(%ebp),%esi
  801755:	c1 e6 0c             	shl    $0xc,%esi
  801758:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80175e:	83 c4 04             	add    $0x4,%esp
  801761:	ff 75 e4             	pushl  -0x1c(%ebp)
  801764:	e8 cf fd ff ff       	call   801538 <fd2data>
  801769:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80176b:	89 34 24             	mov    %esi,(%esp)
  80176e:	e8 c5 fd ff ff       	call   801538 <fd2data>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	c1 e8 16             	shr    $0x16,%eax
  80177d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801784:	a8 01                	test   $0x1,%al
  801786:	74 11                	je     801799 <dup+0x74>
  801788:	89 d8                	mov    %ebx,%eax
  80178a:	c1 e8 0c             	shr    $0xc,%eax
  80178d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801794:	f6 c2 01             	test   $0x1,%dl
  801797:	75 39                	jne    8017d2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801799:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	c1 e8 0c             	shr    $0xc,%eax
  8017a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8017b0:	50                   	push   %eax
  8017b1:	56                   	push   %esi
  8017b2:	6a 00                	push   $0x0
  8017b4:	52                   	push   %edx
  8017b5:	6a 00                	push   $0x0
  8017b7:	e8 cd f5 ff ff       	call   800d89 <sys_page_map>
  8017bc:	89 c3                	mov    %eax,%ebx
  8017be:	83 c4 20             	add    $0x20,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 31                	js     8017f6 <dup+0xd1>
		goto err;

	return newfdnum;
  8017c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017c8:	89 d8                	mov    %ebx,%eax
  8017ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e1:	50                   	push   %eax
  8017e2:	57                   	push   %edi
  8017e3:	6a 00                	push   $0x0
  8017e5:	53                   	push   %ebx
  8017e6:	6a 00                	push   $0x0
  8017e8:	e8 9c f5 ff ff       	call   800d89 <sys_page_map>
  8017ed:	89 c3                	mov    %eax,%ebx
  8017ef:	83 c4 20             	add    $0x20,%esp
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	79 a3                	jns    801799 <dup+0x74>
	sys_page_unmap(0, newfd);
  8017f6:	83 ec 08             	sub    $0x8,%esp
  8017f9:	56                   	push   %esi
  8017fa:	6a 00                	push   $0x0
  8017fc:	e8 ca f5 ff ff       	call   800dcb <sys_page_unmap>
	sys_page_unmap(0, nva);
  801801:	83 c4 08             	add    $0x8,%esp
  801804:	57                   	push   %edi
  801805:	6a 00                	push   $0x0
  801807:	e8 bf f5 ff ff       	call   800dcb <sys_page_unmap>
	return r;
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	eb b7                	jmp    8017c8 <dup+0xa3>

00801811 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	53                   	push   %ebx
  801815:	83 ec 1c             	sub    $0x1c,%esp
  801818:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	53                   	push   %ebx
  801820:	e8 7c fd ff ff       	call   8015a1 <fd_lookup>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 3f                	js     80186b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182c:	83 ec 08             	sub    $0x8,%esp
  80182f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801832:	50                   	push   %eax
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	ff 30                	pushl  (%eax)
  801838:	e8 b4 fd ff ff       	call   8015f1 <dev_lookup>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 27                	js     80186b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801847:	8b 42 08             	mov    0x8(%edx),%eax
  80184a:	83 e0 03             	and    $0x3,%eax
  80184d:	83 f8 01             	cmp    $0x1,%eax
  801850:	74 1e                	je     801870 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	8b 40 08             	mov    0x8(%eax),%eax
  801858:	85 c0                	test   %eax,%eax
  80185a:	74 35                	je     801891 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	52                   	push   %edx
  801866:	ff d0                	call   *%eax
  801868:	83 c4 10             	add    $0x10,%esp
}
  80186b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801870:	a1 08 50 80 00       	mov    0x805008,%eax
  801875:	8b 40 48             	mov    0x48(%eax),%eax
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	53                   	push   %ebx
  80187c:	50                   	push   %eax
  80187d:	68 05 30 80 00       	push   $0x803005
  801882:	e8 6e e9 ff ff       	call   8001f5 <cprintf>
		return -E_INVAL;
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188f:	eb da                	jmp    80186b <read+0x5a>
		return -E_NOT_SUPP;
  801891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801896:	eb d3                	jmp    80186b <read+0x5a>

00801898 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	57                   	push   %edi
  80189c:	56                   	push   %esi
  80189d:	53                   	push   %ebx
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ac:	39 f3                	cmp    %esi,%ebx
  8018ae:	73 23                	jae    8018d3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	89 f0                	mov    %esi,%eax
  8018b5:	29 d8                	sub    %ebx,%eax
  8018b7:	50                   	push   %eax
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	03 45 0c             	add    0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	57                   	push   %edi
  8018bf:	e8 4d ff ff ff       	call   801811 <read>
		if (m < 0)
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 06                	js     8018d1 <readn+0x39>
			return m;
		if (m == 0)
  8018cb:	74 06                	je     8018d3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018cd:	01 c3                	add    %eax,%ebx
  8018cf:	eb db                	jmp    8018ac <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018d1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018d3:	89 d8                	mov    %ebx,%eax
  8018d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5f                   	pop    %edi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    

008018dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 1c             	sub    $0x1c,%esp
  8018e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ea:	50                   	push   %eax
  8018eb:	53                   	push   %ebx
  8018ec:	e8 b0 fc ff ff       	call   8015a1 <fd_lookup>
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 3a                	js     801932 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	ff 30                	pushl  (%eax)
  801904:	e8 e8 fc ff ff       	call   8015f1 <dev_lookup>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 22                	js     801932 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801913:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801917:	74 1e                	je     801937 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191c:	8b 52 0c             	mov    0xc(%edx),%edx
  80191f:	85 d2                	test   %edx,%edx
  801921:	74 35                	je     801958 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	ff 75 10             	pushl  0x10(%ebp)
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	50                   	push   %eax
  80192d:	ff d2                	call   *%edx
  80192f:	83 c4 10             	add    $0x10,%esp
}
  801932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801935:	c9                   	leave  
  801936:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801937:	a1 08 50 80 00       	mov    0x805008,%eax
  80193c:	8b 40 48             	mov    0x48(%eax),%eax
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	53                   	push   %ebx
  801943:	50                   	push   %eax
  801944:	68 21 30 80 00       	push   $0x803021
  801949:	e8 a7 e8 ff ff       	call   8001f5 <cprintf>
		return -E_INVAL;
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801956:	eb da                	jmp    801932 <write+0x55>
		return -E_NOT_SUPP;
  801958:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80195d:	eb d3                	jmp    801932 <write+0x55>

0080195f <seek>:

int
seek(int fdnum, off_t offset)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801965:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801968:	50                   	push   %eax
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	e8 30 fc ff ff       	call   8015a1 <fd_lookup>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 0e                	js     801986 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	53                   	push   %ebx
  80198c:	83 ec 1c             	sub    $0x1c,%esp
  80198f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801992:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801995:	50                   	push   %eax
  801996:	53                   	push   %ebx
  801997:	e8 05 fc ff ff       	call   8015a1 <fd_lookup>
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 37                	js     8019da <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ad:	ff 30                	pushl  (%eax)
  8019af:	e8 3d fc ff ff       	call   8015f1 <dev_lookup>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 1f                	js     8019da <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c2:	74 1b                	je     8019df <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c7:	8b 52 18             	mov    0x18(%edx),%edx
  8019ca:	85 d2                	test   %edx,%edx
  8019cc:	74 32                	je     801a00 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	50                   	push   %eax
  8019d5:	ff d2                	call   *%edx
  8019d7:	83 c4 10             	add    $0x10,%esp
}
  8019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019df:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e4:	8b 40 48             	mov    0x48(%eax),%eax
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	53                   	push   %ebx
  8019eb:	50                   	push   %eax
  8019ec:	68 e4 2f 80 00       	push   $0x802fe4
  8019f1:	e8 ff e7 ff ff       	call   8001f5 <cprintf>
		return -E_INVAL;
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019fe:	eb da                	jmp    8019da <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a05:	eb d3                	jmp    8019da <ftruncate+0x52>

00801a07 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 1c             	sub    $0x1c,%esp
  801a0e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a14:	50                   	push   %eax
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	e8 84 fb ff ff       	call   8015a1 <fd_lookup>
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 4b                	js     801a6f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2e:	ff 30                	pushl  (%eax)
  801a30:	e8 bc fb ff ff       	call   8015f1 <dev_lookup>
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 33                	js     801a6f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a43:	74 2f                	je     801a74 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a45:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a48:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a4f:	00 00 00 
	stat->st_isdir = 0;
  801a52:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a59:	00 00 00 
	stat->st_dev = dev;
  801a5c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	53                   	push   %ebx
  801a66:	ff 75 f0             	pushl  -0x10(%ebp)
  801a69:	ff 50 14             	call   *0x14(%eax)
  801a6c:	83 c4 10             	add    $0x10,%esp
}
  801a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    
		return -E_NOT_SUPP;
  801a74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a79:	eb f4                	jmp    801a6f <fstat+0x68>

00801a7b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	e8 22 02 00 00       	call   801caf <open>
  801a8d:	89 c3                	mov    %eax,%ebx
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 1b                	js     801ab1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	e8 65 ff ff ff       	call   801a07 <fstat>
  801aa2:	89 c6                	mov    %eax,%esi
	close(fd);
  801aa4:	89 1c 24             	mov    %ebx,(%esp)
  801aa7:	e8 27 fc ff ff       	call   8016d3 <close>
	return r;
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	89 f3                	mov    %esi,%ebx
}
  801ab1:	89 d8                	mov    %ebx,%eax
  801ab3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5e                   	pop    %esi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    

00801aba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	89 c6                	mov    %eax,%esi
  801ac1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ac3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801aca:	74 27                	je     801af3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801acc:	6a 07                	push   $0x7
  801ace:	68 00 60 80 00       	push   $0x806000
  801ad3:	56                   	push   %esi
  801ad4:	ff 35 00 50 80 00    	pushl  0x805000
  801ada:	e8 fe 0c 00 00       	call   8027dd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801adf:	83 c4 0c             	add    $0xc,%esp
  801ae2:	6a 00                	push   $0x0
  801ae4:	53                   	push   %ebx
  801ae5:	6a 00                	push   $0x0
  801ae7:	e8 88 0c 00 00       	call   802774 <ipc_recv>
}
  801aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801af3:	83 ec 0c             	sub    $0xc,%esp
  801af6:	6a 01                	push   $0x1
  801af8:	e8 38 0d 00 00       	call   802835 <ipc_find_env>
  801afd:	a3 00 50 80 00       	mov    %eax,0x805000
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	eb c5                	jmp    801acc <fsipc+0x12>

00801b07 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8b 40 0c             	mov    0xc(%eax),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b20:	ba 00 00 00 00       	mov    $0x0,%edx
  801b25:	b8 02 00 00 00       	mov    $0x2,%eax
  801b2a:	e8 8b ff ff ff       	call   801aba <fsipc>
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <devfile_flush>:
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b42:	ba 00 00 00 00       	mov    $0x0,%edx
  801b47:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4c:	e8 69 ff ff ff       	call   801aba <fsipc>
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <devfile_stat>:
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	53                   	push   %ebx
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8b 40 0c             	mov    0xc(%eax),%eax
  801b63:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b68:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6d:	b8 05 00 00 00       	mov    $0x5,%eax
  801b72:	e8 43 ff ff ff       	call   801aba <fsipc>
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 2c                	js     801ba7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	68 00 60 80 00       	push   $0x806000
  801b83:	53                   	push   %ebx
  801b84:	e8 cb ed ff ff       	call   800954 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b89:	a1 80 60 80 00       	mov    0x806080,%eax
  801b8e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b94:	a1 84 60 80 00       	mov    0x806084,%eax
  801b99:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <devfile_write>:
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bbc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bc1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bc7:	53                   	push   %ebx
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	68 08 60 80 00       	push   $0x806008
  801bd0:	e8 6f ef ff ff       	call   800b44 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bda:	b8 04 00 00 00       	mov    $0x4,%eax
  801bdf:	e8 d6 fe ff ff       	call   801aba <fsipc>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 0b                	js     801bf6 <devfile_write+0x4a>
	assert(r <= n);
  801beb:	39 d8                	cmp    %ebx,%eax
  801bed:	77 0c                	ja     801bfb <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf4:	7f 1e                	jg     801c14 <devfile_write+0x68>
}
  801bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    
	assert(r <= n);
  801bfb:	68 54 30 80 00       	push   $0x803054
  801c00:	68 5b 30 80 00       	push   $0x80305b
  801c05:	68 98 00 00 00       	push   $0x98
  801c0a:	68 70 30 80 00       	push   $0x803070
  801c0f:	e8 6a 0a 00 00       	call   80267e <_panic>
	assert(r <= PGSIZE);
  801c14:	68 7b 30 80 00       	push   $0x80307b
  801c19:	68 5b 30 80 00       	push   $0x80305b
  801c1e:	68 99 00 00 00       	push   $0x99
  801c23:	68 70 30 80 00       	push   $0x803070
  801c28:	e8 51 0a 00 00       	call   80267e <_panic>

00801c2d <devfile_read>:
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
  801c32:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c40:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c50:	e8 65 fe ff ff       	call   801aba <fsipc>
  801c55:	89 c3                	mov    %eax,%ebx
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 1f                	js     801c7a <devfile_read+0x4d>
	assert(r <= n);
  801c5b:	39 f0                	cmp    %esi,%eax
  801c5d:	77 24                	ja     801c83 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c64:	7f 33                	jg     801c99 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	50                   	push   %eax
  801c6a:	68 00 60 80 00       	push   $0x806000
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	e8 6b ee ff ff       	call   800ae2 <memmove>
	return r;
  801c77:	83 c4 10             	add    $0x10,%esp
}
  801c7a:	89 d8                	mov    %ebx,%eax
  801c7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    
	assert(r <= n);
  801c83:	68 54 30 80 00       	push   $0x803054
  801c88:	68 5b 30 80 00       	push   $0x80305b
  801c8d:	6a 7c                	push   $0x7c
  801c8f:	68 70 30 80 00       	push   $0x803070
  801c94:	e8 e5 09 00 00       	call   80267e <_panic>
	assert(r <= PGSIZE);
  801c99:	68 7b 30 80 00       	push   $0x80307b
  801c9e:	68 5b 30 80 00       	push   $0x80305b
  801ca3:	6a 7d                	push   $0x7d
  801ca5:	68 70 30 80 00       	push   $0x803070
  801caa:	e8 cf 09 00 00       	call   80267e <_panic>

00801caf <open>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cba:	56                   	push   %esi
  801cbb:	e8 5b ec ff ff       	call   80091b <strlen>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc8:	7f 6c                	jg     801d36 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd0:	50                   	push   %eax
  801cd1:	e8 79 f8 ff ff       	call   80154f <fd_alloc>
  801cd6:	89 c3                	mov    %eax,%ebx
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 3c                	js     801d1b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	56                   	push   %esi
  801ce3:	68 00 60 80 00       	push   $0x806000
  801ce8:	e8 67 ec ff ff       	call   800954 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf0:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfd:	e8 b8 fd ff ff       	call   801aba <fsipc>
  801d02:	89 c3                	mov    %eax,%ebx
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 19                	js     801d24 <open+0x75>
	return fd2num(fd);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d11:	e8 12 f8 ff ff       	call   801528 <fd2num>
  801d16:	89 c3                	mov    %eax,%ebx
  801d18:	83 c4 10             	add    $0x10,%esp
}
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    
		fd_close(fd, 0);
  801d24:	83 ec 08             	sub    $0x8,%esp
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2c:	e8 1b f9 ff ff       	call   80164c <fd_close>
		return r;
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	eb e5                	jmp    801d1b <open+0x6c>
		return -E_BAD_PATH;
  801d36:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d3b:	eb de                	jmp    801d1b <open+0x6c>

00801d3d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d43:	ba 00 00 00 00       	mov    $0x0,%edx
  801d48:	b8 08 00 00 00       	mov    $0x8,%eax
  801d4d:	e8 68 fd ff ff       	call   801aba <fsipc>
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d5a:	68 87 30 80 00       	push   $0x803087
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	e8 ed eb ff ff       	call   800954 <strcpy>
	return 0;
}
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <devsock_close>:
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	53                   	push   %ebx
  801d72:	83 ec 10             	sub    $0x10,%esp
  801d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d78:	53                   	push   %ebx
  801d79:	e8 f6 0a 00 00       	call   802874 <pageref>
  801d7e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d81:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d86:	83 f8 01             	cmp    $0x1,%eax
  801d89:	74 07                	je     801d92 <devsock_close+0x24>
}
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	ff 73 0c             	pushl  0xc(%ebx)
  801d98:	e8 b9 02 00 00       	call   802056 <nsipc_close>
  801d9d:	89 c2                	mov    %eax,%edx
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	eb e7                	jmp    801d8b <devsock_close+0x1d>

00801da4 <devsock_write>:
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	ff 70 0c             	pushl  0xc(%eax)
  801db8:	e8 76 03 00 00       	call   802133 <nsipc_send>
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <devsock_read>:
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	ff 70 0c             	pushl  0xc(%eax)
  801dd3:	e8 ef 02 00 00       	call   8020c7 <nsipc_recv>
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <fd2sockid>:
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801de0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	e8 b7 f7 ff ff       	call   8015a1 <fd_lookup>
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 10                	js     801e01 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801dfa:	39 08                	cmp    %ecx,(%eax)
  801dfc:	75 05                	jne    801e03 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dfe:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    
		return -E_NOT_SUPP;
  801e03:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e08:	eb f7                	jmp    801e01 <fd2sockid+0x27>

00801e0a <alloc_sockfd>:
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	56                   	push   %esi
  801e0e:	53                   	push   %ebx
  801e0f:	83 ec 1c             	sub    $0x1c,%esp
  801e12:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e17:	50                   	push   %eax
  801e18:	e8 32 f7 ff ff       	call   80154f <fd_alloc>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 43                	js     801e69 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 07 04 00 00       	push   $0x407
  801e2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e31:	6a 00                	push   $0x0
  801e33:	e8 0e ef ff ff       	call   800d46 <sys_page_alloc>
  801e38:	89 c3                	mov    %eax,%ebx
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 28                	js     801e69 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e4a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e56:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	50                   	push   %eax
  801e5d:	e8 c6 f6 ff ff       	call   801528 <fd2num>
  801e62:	89 c3                	mov    %eax,%ebx
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	eb 0c                	jmp    801e75 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	56                   	push   %esi
  801e6d:	e8 e4 01 00 00       	call   802056 <nsipc_close>
		return r;
  801e72:	83 c4 10             	add    $0x10,%esp
}
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <accept>:
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	e8 4e ff ff ff       	call   801dda <fd2sockid>
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 1b                	js     801eab <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	ff 75 10             	pushl  0x10(%ebp)
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	50                   	push   %eax
  801e9a:	e8 0e 01 00 00       	call   801fad <nsipc_accept>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	78 05                	js     801eab <accept+0x2d>
	return alloc_sockfd(r);
  801ea6:	e8 5f ff ff ff       	call   801e0a <alloc_sockfd>
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <bind>:
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	e8 1f ff ff ff       	call   801dda <fd2sockid>
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	78 12                	js     801ed1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	ff 75 10             	pushl  0x10(%ebp)
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	50                   	push   %eax
  801ec9:	e8 31 01 00 00       	call   801fff <nsipc_bind>
  801ece:	83 c4 10             	add    $0x10,%esp
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <shutdown>:
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	e8 f9 fe ff ff       	call   801dda <fd2sockid>
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 0f                	js     801ef4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ee5:	83 ec 08             	sub    $0x8,%esp
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	50                   	push   %eax
  801eec:	e8 43 01 00 00       	call   802034 <nsipc_shutdown>
  801ef1:	83 c4 10             	add    $0x10,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <connect>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	e8 d6 fe ff ff       	call   801dda <fd2sockid>
  801f04:	85 c0                	test   %eax,%eax
  801f06:	78 12                	js     801f1a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	ff 75 10             	pushl  0x10(%ebp)
  801f0e:	ff 75 0c             	pushl  0xc(%ebp)
  801f11:	50                   	push   %eax
  801f12:	e8 59 01 00 00       	call   802070 <nsipc_connect>
  801f17:	83 c4 10             	add    $0x10,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <listen>:
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	e8 b0 fe ff ff       	call   801dda <fd2sockid>
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 0f                	js     801f3d <listen+0x21>
	return nsipc_listen(r, backlog);
  801f2e:	83 ec 08             	sub    $0x8,%esp
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	50                   	push   %eax
  801f35:	e8 6b 01 00 00       	call   8020a5 <nsipc_listen>
  801f3a:	83 c4 10             	add    $0x10,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <socket>:

int
socket(int domain, int type, int protocol)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f45:	ff 75 10             	pushl  0x10(%ebp)
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	ff 75 08             	pushl  0x8(%ebp)
  801f4e:	e8 3e 02 00 00       	call   802191 <nsipc_socket>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 05                	js     801f5f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f5a:	e8 ab fe ff ff       	call   801e0a <alloc_sockfd>
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	53                   	push   %ebx
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f6a:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f71:	74 26                	je     801f99 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f73:	6a 07                	push   $0x7
  801f75:	68 00 70 80 00       	push   $0x807000
  801f7a:	53                   	push   %ebx
  801f7b:	ff 35 04 50 80 00    	pushl  0x805004
  801f81:	e8 57 08 00 00       	call   8027dd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f86:	83 c4 0c             	add    $0xc,%esp
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 e0 07 00 00       	call   802774 <ipc_recv>
}
  801f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	6a 02                	push   $0x2
  801f9e:	e8 92 08 00 00       	call   802835 <ipc_find_env>
  801fa3:	a3 04 50 80 00       	mov    %eax,0x805004
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	eb c6                	jmp    801f73 <nsipc+0x12>

00801fad <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
  801fb2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fbd:	8b 06                	mov    (%esi),%eax
  801fbf:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc9:	e8 93 ff ff ff       	call   801f61 <nsipc>
  801fce:	89 c3                	mov    %eax,%ebx
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	79 09                	jns    801fdd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fd4:	89 d8                	mov    %ebx,%eax
  801fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5d                   	pop    %ebp
  801fdc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	ff 35 10 70 80 00    	pushl  0x807010
  801fe6:	68 00 70 80 00       	push   $0x807000
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	e8 ef ea ff ff       	call   800ae2 <memmove>
		*addrlen = ret->ret_addrlen;
  801ff3:	a1 10 70 80 00       	mov    0x807010,%eax
  801ff8:	89 06                	mov    %eax,(%esi)
  801ffa:	83 c4 10             	add    $0x10,%esp
	return r;
  801ffd:	eb d5                	jmp    801fd4 <nsipc_accept+0x27>

00801fff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	53                   	push   %ebx
  802003:	83 ec 08             	sub    $0x8,%esp
  802006:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802011:	53                   	push   %ebx
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	68 04 70 80 00       	push   $0x807004
  80201a:	e8 c3 ea ff ff       	call   800ae2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80201f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802025:	b8 02 00 00 00       	mov    $0x2,%eax
  80202a:	e8 32 ff ff ff       	call   801f61 <nsipc>
}
  80202f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802042:	8b 45 0c             	mov    0xc(%ebp),%eax
  802045:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80204a:	b8 03 00 00 00       	mov    $0x3,%eax
  80204f:	e8 0d ff ff ff       	call   801f61 <nsipc>
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <nsipc_close>:

int
nsipc_close(int s)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802064:	b8 04 00 00 00       	mov    $0x4,%eax
  802069:	e8 f3 fe ff ff       	call   801f61 <nsipc>
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	53                   	push   %ebx
  802074:	83 ec 08             	sub    $0x8,%esp
  802077:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802082:	53                   	push   %ebx
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	68 04 70 80 00       	push   $0x807004
  80208b:	e8 52 ea ff ff       	call   800ae2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802090:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802096:	b8 05 00 00 00       	mov    $0x5,%eax
  80209b:	e8 c1 fe ff ff       	call   801f61 <nsipc>
}
  8020a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020bb:	b8 06 00 00 00       	mov    $0x6,%eax
  8020c0:	e8 9c fe ff ff       	call   801f61 <nsipc>
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	56                   	push   %esi
  8020cb:	53                   	push   %ebx
  8020cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020d7:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e0:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8020ea:	e8 72 fe ff ff       	call   801f61 <nsipc>
  8020ef:	89 c3                	mov    %eax,%ebx
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 1f                	js     802114 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020f5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020fa:	7f 21                	jg     80211d <nsipc_recv+0x56>
  8020fc:	39 c6                	cmp    %eax,%esi
  8020fe:	7c 1d                	jl     80211d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	50                   	push   %eax
  802104:	68 00 70 80 00       	push   $0x807000
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	e8 d1 e9 ff ff       	call   800ae2 <memmove>
  802111:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802114:	89 d8                	mov    %ebx,%eax
  802116:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5d                   	pop    %ebp
  80211c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80211d:	68 93 30 80 00       	push   $0x803093
  802122:	68 5b 30 80 00       	push   $0x80305b
  802127:	6a 62                	push   $0x62
  802129:	68 a8 30 80 00       	push   $0x8030a8
  80212e:	e8 4b 05 00 00       	call   80267e <_panic>

00802133 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802145:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80214b:	7f 2e                	jg     80217b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	53                   	push   %ebx
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	68 0c 70 80 00       	push   $0x80700c
  802159:	e8 84 e9 ff ff       	call   800ae2 <memmove>
	nsipcbuf.send.req_size = size;
  80215e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802164:	8b 45 14             	mov    0x14(%ebp),%eax
  802167:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80216c:	b8 08 00 00 00       	mov    $0x8,%eax
  802171:	e8 eb fd ff ff       	call   801f61 <nsipc>
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    
	assert(size < 1600);
  80217b:	68 b4 30 80 00       	push   $0x8030b4
  802180:	68 5b 30 80 00       	push   $0x80305b
  802185:	6a 6d                	push   $0x6d
  802187:	68 a8 30 80 00       	push   $0x8030a8
  80218c:	e8 ed 04 00 00       	call   80267e <_panic>

00802191 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80219f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021aa:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021af:	b8 09 00 00 00       	mov    $0x9,%eax
  8021b4:	e8 a8 fd ff ff       	call   801f61 <nsipc>
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
  8021c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	e8 6a f3 ff ff       	call   801538 <fd2data>
  8021ce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021d0:	83 c4 08             	add    $0x8,%esp
  8021d3:	68 c0 30 80 00       	push   $0x8030c0
  8021d8:	53                   	push   %ebx
  8021d9:	e8 76 e7 ff ff       	call   800954 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021de:	8b 46 04             	mov    0x4(%esi),%eax
  8021e1:	2b 06                	sub    (%esi),%eax
  8021e3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021f0:	00 00 00 
	stat->st_dev = &devpipe;
  8021f3:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021fa:	40 80 00 
	return 0;
}
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    

00802209 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	53                   	push   %ebx
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802213:	53                   	push   %ebx
  802214:	6a 00                	push   $0x0
  802216:	e8 b0 eb ff ff       	call   800dcb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80221b:	89 1c 24             	mov    %ebx,(%esp)
  80221e:	e8 15 f3 ff ff       	call   801538 <fd2data>
  802223:	83 c4 08             	add    $0x8,%esp
  802226:	50                   	push   %eax
  802227:	6a 00                	push   $0x0
  802229:	e8 9d eb ff ff       	call   800dcb <sys_page_unmap>
}
  80222e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <_pipeisclosed>:
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	57                   	push   %edi
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	83 ec 1c             	sub    $0x1c,%esp
  80223c:	89 c7                	mov    %eax,%edi
  80223e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802240:	a1 08 50 80 00       	mov    0x805008,%eax
  802245:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	57                   	push   %edi
  80224c:	e8 23 06 00 00       	call   802874 <pageref>
  802251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802254:	89 34 24             	mov    %esi,(%esp)
  802257:	e8 18 06 00 00       	call   802874 <pageref>
		nn = thisenv->env_runs;
  80225c:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802262:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	39 cb                	cmp    %ecx,%ebx
  80226a:	74 1b                	je     802287 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80226c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80226f:	75 cf                	jne    802240 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802271:	8b 42 58             	mov    0x58(%edx),%eax
  802274:	6a 01                	push   $0x1
  802276:	50                   	push   %eax
  802277:	53                   	push   %ebx
  802278:	68 c7 30 80 00       	push   $0x8030c7
  80227d:	e8 73 df ff ff       	call   8001f5 <cprintf>
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	eb b9                	jmp    802240 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802287:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80228a:	0f 94 c0             	sete   %al
  80228d:	0f b6 c0             	movzbl %al,%eax
}
  802290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5f                   	pop    %edi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    

00802298 <devpipe_write>:
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	57                   	push   %edi
  80229c:	56                   	push   %esi
  80229d:	53                   	push   %ebx
  80229e:	83 ec 28             	sub    $0x28,%esp
  8022a1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022a4:	56                   	push   %esi
  8022a5:	e8 8e f2 ff ff       	call   801538 <fd2data>
  8022aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022b7:	74 4f                	je     802308 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022b9:	8b 43 04             	mov    0x4(%ebx),%eax
  8022bc:	8b 0b                	mov    (%ebx),%ecx
  8022be:	8d 51 20             	lea    0x20(%ecx),%edx
  8022c1:	39 d0                	cmp    %edx,%eax
  8022c3:	72 14                	jb     8022d9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	89 f0                	mov    %esi,%eax
  8022c9:	e8 65 ff ff ff       	call   802233 <_pipeisclosed>
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	75 3b                	jne    80230d <devpipe_write+0x75>
			sys_yield();
  8022d2:	e8 50 ea ff ff       	call   800d27 <sys_yield>
  8022d7:	eb e0                	jmp    8022b9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022dc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022e0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022e3:	89 c2                	mov    %eax,%edx
  8022e5:	c1 fa 1f             	sar    $0x1f,%edx
  8022e8:	89 d1                	mov    %edx,%ecx
  8022ea:	c1 e9 1b             	shr    $0x1b,%ecx
  8022ed:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022f0:	83 e2 1f             	and    $0x1f,%edx
  8022f3:	29 ca                	sub    %ecx,%edx
  8022f5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022fd:	83 c0 01             	add    $0x1,%eax
  802300:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802303:	83 c7 01             	add    $0x1,%edi
  802306:	eb ac                	jmp    8022b4 <devpipe_write+0x1c>
	return i;
  802308:	8b 45 10             	mov    0x10(%ebp),%eax
  80230b:	eb 05                	jmp    802312 <devpipe_write+0x7a>
				return 0;
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    

0080231a <devpipe_read>:
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	57                   	push   %edi
  80231e:	56                   	push   %esi
  80231f:	53                   	push   %ebx
  802320:	83 ec 18             	sub    $0x18,%esp
  802323:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802326:	57                   	push   %edi
  802327:	e8 0c f2 ff ff       	call   801538 <fd2data>
  80232c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80232e:	83 c4 10             	add    $0x10,%esp
  802331:	be 00 00 00 00       	mov    $0x0,%esi
  802336:	3b 75 10             	cmp    0x10(%ebp),%esi
  802339:	75 14                	jne    80234f <devpipe_read+0x35>
	return i;
  80233b:	8b 45 10             	mov    0x10(%ebp),%eax
  80233e:	eb 02                	jmp    802342 <devpipe_read+0x28>
				return i;
  802340:	89 f0                	mov    %esi,%eax
}
  802342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
			sys_yield();
  80234a:	e8 d8 e9 ff ff       	call   800d27 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80234f:	8b 03                	mov    (%ebx),%eax
  802351:	3b 43 04             	cmp    0x4(%ebx),%eax
  802354:	75 18                	jne    80236e <devpipe_read+0x54>
			if (i > 0)
  802356:	85 f6                	test   %esi,%esi
  802358:	75 e6                	jne    802340 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80235a:	89 da                	mov    %ebx,%edx
  80235c:	89 f8                	mov    %edi,%eax
  80235e:	e8 d0 fe ff ff       	call   802233 <_pipeisclosed>
  802363:	85 c0                	test   %eax,%eax
  802365:	74 e3                	je     80234a <devpipe_read+0x30>
				return 0;
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	eb d4                	jmp    802342 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80236e:	99                   	cltd   
  80236f:	c1 ea 1b             	shr    $0x1b,%edx
  802372:	01 d0                	add    %edx,%eax
  802374:	83 e0 1f             	and    $0x1f,%eax
  802377:	29 d0                	sub    %edx,%eax
  802379:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80237e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802381:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802384:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802387:	83 c6 01             	add    $0x1,%esi
  80238a:	eb aa                	jmp    802336 <devpipe_read+0x1c>

0080238c <pipe>:
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	56                   	push   %esi
  802390:	53                   	push   %ebx
  802391:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802397:	50                   	push   %eax
  802398:	e8 b2 f1 ff ff       	call   80154f <fd_alloc>
  80239d:	89 c3                	mov    %eax,%ebx
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 23 01 00 00    	js     8024cd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023aa:	83 ec 04             	sub    $0x4,%esp
  8023ad:	68 07 04 00 00       	push   $0x407
  8023b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b5:	6a 00                	push   $0x0
  8023b7:	e8 8a e9 ff ff       	call   800d46 <sys_page_alloc>
  8023bc:	89 c3                	mov    %eax,%ebx
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	0f 88 04 01 00 00    	js     8024cd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023c9:	83 ec 0c             	sub    $0xc,%esp
  8023cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023cf:	50                   	push   %eax
  8023d0:	e8 7a f1 ff ff       	call   80154f <fd_alloc>
  8023d5:	89 c3                	mov    %eax,%ebx
  8023d7:	83 c4 10             	add    $0x10,%esp
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	0f 88 db 00 00 00    	js     8024bd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 07 04 00 00       	push   $0x407
  8023ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ed:	6a 00                	push   $0x0
  8023ef:	e8 52 e9 ff ff       	call   800d46 <sys_page_alloc>
  8023f4:	89 c3                	mov    %eax,%ebx
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	0f 88 bc 00 00 00    	js     8024bd <pipe+0x131>
	va = fd2data(fd0);
  802401:	83 ec 0c             	sub    $0xc,%esp
  802404:	ff 75 f4             	pushl  -0xc(%ebp)
  802407:	e8 2c f1 ff ff       	call   801538 <fd2data>
  80240c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240e:	83 c4 0c             	add    $0xc,%esp
  802411:	68 07 04 00 00       	push   $0x407
  802416:	50                   	push   %eax
  802417:	6a 00                	push   $0x0
  802419:	e8 28 e9 ff ff       	call   800d46 <sys_page_alloc>
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	85 c0                	test   %eax,%eax
  802425:	0f 88 82 00 00 00    	js     8024ad <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242b:	83 ec 0c             	sub    $0xc,%esp
  80242e:	ff 75 f0             	pushl  -0x10(%ebp)
  802431:	e8 02 f1 ff ff       	call   801538 <fd2data>
  802436:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80243d:	50                   	push   %eax
  80243e:	6a 00                	push   $0x0
  802440:	56                   	push   %esi
  802441:	6a 00                	push   $0x0
  802443:	e8 41 e9 ff ff       	call   800d89 <sys_page_map>
  802448:	89 c3                	mov    %eax,%ebx
  80244a:	83 c4 20             	add    $0x20,%esp
  80244d:	85 c0                	test   %eax,%eax
  80244f:	78 4e                	js     80249f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802451:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802456:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802459:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80245b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802465:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802468:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	ff 75 f4             	pushl  -0xc(%ebp)
  80247a:	e8 a9 f0 ff ff       	call   801528 <fd2num>
  80247f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802482:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802484:	83 c4 04             	add    $0x4,%esp
  802487:	ff 75 f0             	pushl  -0x10(%ebp)
  80248a:	e8 99 f0 ff ff       	call   801528 <fd2num>
  80248f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802492:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	bb 00 00 00 00       	mov    $0x0,%ebx
  80249d:	eb 2e                	jmp    8024cd <pipe+0x141>
	sys_page_unmap(0, va);
  80249f:	83 ec 08             	sub    $0x8,%esp
  8024a2:	56                   	push   %esi
  8024a3:	6a 00                	push   $0x0
  8024a5:	e8 21 e9 ff ff       	call   800dcb <sys_page_unmap>
  8024aa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024ad:	83 ec 08             	sub    $0x8,%esp
  8024b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024b3:	6a 00                	push   $0x0
  8024b5:	e8 11 e9 ff ff       	call   800dcb <sys_page_unmap>
  8024ba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024bd:	83 ec 08             	sub    $0x8,%esp
  8024c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c3:	6a 00                	push   $0x0
  8024c5:	e8 01 e9 ff ff       	call   800dcb <sys_page_unmap>
  8024ca:	83 c4 10             	add    $0x10,%esp
}
  8024cd:	89 d8                	mov    %ebx,%eax
  8024cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d2:	5b                   	pop    %ebx
  8024d3:	5e                   	pop    %esi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <pipeisclosed>:
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024df:	50                   	push   %eax
  8024e0:	ff 75 08             	pushl  0x8(%ebp)
  8024e3:	e8 b9 f0 ff ff       	call   8015a1 <fd_lookup>
  8024e8:	83 c4 10             	add    $0x10,%esp
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	78 18                	js     802507 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f5:	e8 3e f0 ff ff       	call   801538 <fd2data>
	return _pipeisclosed(fd, p);
  8024fa:	89 c2                	mov    %eax,%edx
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	e8 2f fd ff ff       	call   802233 <_pipeisclosed>
  802504:	83 c4 10             	add    $0x10,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	c3                   	ret    

0080250f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802515:	68 df 30 80 00       	push   $0x8030df
  80251a:	ff 75 0c             	pushl  0xc(%ebp)
  80251d:	e8 32 e4 ff ff       	call   800954 <strcpy>
	return 0;
}
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <devcons_write>:
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	57                   	push   %edi
  80252d:	56                   	push   %esi
  80252e:	53                   	push   %ebx
  80252f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802535:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80253a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802540:	3b 75 10             	cmp    0x10(%ebp),%esi
  802543:	73 31                	jae    802576 <devcons_write+0x4d>
		m = n - tot;
  802545:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802548:	29 f3                	sub    %esi,%ebx
  80254a:	83 fb 7f             	cmp    $0x7f,%ebx
  80254d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802552:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	53                   	push   %ebx
  802559:	89 f0                	mov    %esi,%eax
  80255b:	03 45 0c             	add    0xc(%ebp),%eax
  80255e:	50                   	push   %eax
  80255f:	57                   	push   %edi
  802560:	e8 7d e5 ff ff       	call   800ae2 <memmove>
		sys_cputs(buf, m);
  802565:	83 c4 08             	add    $0x8,%esp
  802568:	53                   	push   %ebx
  802569:	57                   	push   %edi
  80256a:	e8 1b e7 ff ff       	call   800c8a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80256f:	01 de                	add    %ebx,%esi
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	eb ca                	jmp    802540 <devcons_write+0x17>
}
  802576:	89 f0                	mov    %esi,%eax
  802578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    

00802580 <devcons_read>:
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 08             	sub    $0x8,%esp
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80258b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80258f:	74 21                	je     8025b2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802591:	e8 12 e7 ff ff       	call   800ca8 <sys_cgetc>
  802596:	85 c0                	test   %eax,%eax
  802598:	75 07                	jne    8025a1 <devcons_read+0x21>
		sys_yield();
  80259a:	e8 88 e7 ff ff       	call   800d27 <sys_yield>
  80259f:	eb f0                	jmp    802591 <devcons_read+0x11>
	if (c < 0)
  8025a1:	78 0f                	js     8025b2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025a3:	83 f8 04             	cmp    $0x4,%eax
  8025a6:	74 0c                	je     8025b4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8025a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ab:	88 02                	mov    %al,(%edx)
	return 1;
  8025ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    
		return 0;
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	eb f7                	jmp    8025b2 <devcons_read+0x32>

008025bb <cputchar>:
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025c7:	6a 01                	push   $0x1
  8025c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025cc:	50                   	push   %eax
  8025cd:	e8 b8 e6 ff ff       	call   800c8a <sys_cputs>
}
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <getchar>:
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025dd:	6a 01                	push   $0x1
  8025df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e2:	50                   	push   %eax
  8025e3:	6a 00                	push   $0x0
  8025e5:	e8 27 f2 ff ff       	call   801811 <read>
	if (r < 0)
  8025ea:	83 c4 10             	add    $0x10,%esp
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	78 06                	js     8025f7 <getchar+0x20>
	if (r < 1)
  8025f1:	74 06                	je     8025f9 <getchar+0x22>
	return c;
  8025f3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    
		return -E_EOF;
  8025f9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025fe:	eb f7                	jmp    8025f7 <getchar+0x20>

00802600 <iscons>:
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802609:	50                   	push   %eax
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	e8 8f ef ff ff       	call   8015a1 <fd_lookup>
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	85 c0                	test   %eax,%eax
  802617:	78 11                	js     80262a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802622:	39 10                	cmp    %edx,(%eax)
  802624:	0f 94 c0             	sete   %al
  802627:	0f b6 c0             	movzbl %al,%eax
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <opencons>:
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802635:	50                   	push   %eax
  802636:	e8 14 ef ff ff       	call   80154f <fd_alloc>
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	85 c0                	test   %eax,%eax
  802640:	78 3a                	js     80267c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 07 04 00 00       	push   $0x407
  80264a:	ff 75 f4             	pushl  -0xc(%ebp)
  80264d:	6a 00                	push   $0x0
  80264f:	e8 f2 e6 ff ff       	call   800d46 <sys_page_alloc>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 21                	js     80267c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802664:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	50                   	push   %eax
  802674:	e8 af ee ff ff       	call   801528 <fd2num>
  802679:	83 c4 10             	add    $0x10,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	56                   	push   %esi
  802682:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802683:	a1 08 50 80 00       	mov    0x805008,%eax
  802688:	8b 40 48             	mov    0x48(%eax),%eax
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	68 10 31 80 00       	push   $0x803110
  802693:	50                   	push   %eax
  802694:	68 20 2b 80 00       	push   $0x802b20
  802699:	e8 57 db ff ff       	call   8001f5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80269e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026a1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026a7:	e8 5c e6 ff ff       	call   800d08 <sys_getenvid>
  8026ac:	83 c4 04             	add    $0x4,%esp
  8026af:	ff 75 0c             	pushl  0xc(%ebp)
  8026b2:	ff 75 08             	pushl  0x8(%ebp)
  8026b5:	56                   	push   %esi
  8026b6:	50                   	push   %eax
  8026b7:	68 ec 30 80 00       	push   $0x8030ec
  8026bc:	e8 34 db ff ff       	call   8001f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026c1:	83 c4 18             	add    $0x18,%esp
  8026c4:	53                   	push   %ebx
  8026c5:	ff 75 10             	pushl  0x10(%ebp)
  8026c8:	e8 d7 da ff ff       	call   8001a4 <vcprintf>
	cprintf("\n");
  8026cd:	c7 04 24 0f 2b 80 00 	movl   $0x802b0f,(%esp)
  8026d4:	e8 1c db ff ff       	call   8001f5 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026dc:	cc                   	int3   
  8026dd:	eb fd                	jmp    8026dc <_panic+0x5e>

008026df <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026e5:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026ec:	74 0a                	je     8026f8 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	6a 07                	push   $0x7
  8026fd:	68 00 f0 bf ee       	push   $0xeebff000
  802702:	6a 00                	push   $0x0
  802704:	e8 3d e6 ff ff       	call   800d46 <sys_page_alloc>
		if(r < 0)
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	85 c0                	test   %eax,%eax
  80270e:	78 2a                	js     80273a <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802710:	83 ec 08             	sub    $0x8,%esp
  802713:	68 4e 27 80 00       	push   $0x80274e
  802718:	6a 00                	push   $0x0
  80271a:	e8 72 e7 ff ff       	call   800e91 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80271f:	83 c4 10             	add    $0x10,%esp
  802722:	85 c0                	test   %eax,%eax
  802724:	79 c8                	jns    8026ee <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	68 48 31 80 00       	push   $0x803148
  80272e:	6a 25                	push   $0x25
  802730:	68 84 31 80 00       	push   $0x803184
  802735:	e8 44 ff ff ff       	call   80267e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 18 31 80 00       	push   $0x803118
  802742:	6a 22                	push   $0x22
  802744:	68 84 31 80 00       	push   $0x803184
  802749:	e8 30 ff ff ff       	call   80267e <_panic>

0080274e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80274e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80274f:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802754:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802756:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802759:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80275d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802761:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802764:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802766:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80276a:	83 c4 08             	add    $0x8,%esp
	popal
  80276d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80276e:	83 c4 04             	add    $0x4,%esp
	popfl
  802771:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802772:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802773:	c3                   	ret    

00802774 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	8b 75 08             	mov    0x8(%ebp),%esi
  80277c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802782:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802784:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802789:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80278c:	83 ec 0c             	sub    $0xc,%esp
  80278f:	50                   	push   %eax
  802790:	e8 61 e7 ff ff       	call   800ef6 <sys_ipc_recv>
	if(ret < 0){
  802795:	83 c4 10             	add    $0x10,%esp
  802798:	85 c0                	test   %eax,%eax
  80279a:	78 2b                	js     8027c7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80279c:	85 f6                	test   %esi,%esi
  80279e:	74 0a                	je     8027aa <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8027a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8027a5:	8b 40 78             	mov    0x78(%eax),%eax
  8027a8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027aa:	85 db                	test   %ebx,%ebx
  8027ac:	74 0a                	je     8027b8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8027ae:	a1 08 50 80 00       	mov    0x805008,%eax
  8027b3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8027b6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8027b8:	a1 08 50 80 00       	mov    0x805008,%eax
  8027bd:	8b 40 74             	mov    0x74(%eax),%eax
}
  8027c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027c3:	5b                   	pop    %ebx
  8027c4:	5e                   	pop    %esi
  8027c5:	5d                   	pop    %ebp
  8027c6:	c3                   	ret    
		if(from_env_store)
  8027c7:	85 f6                	test   %esi,%esi
  8027c9:	74 06                	je     8027d1 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027d1:	85 db                	test   %ebx,%ebx
  8027d3:	74 eb                	je     8027c0 <ipc_recv+0x4c>
			*perm_store = 0;
  8027d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027db:	eb e3                	jmp    8027c0 <ipc_recv+0x4c>

008027dd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	57                   	push   %edi
  8027e1:	56                   	push   %esi
  8027e2:	53                   	push   %ebx
  8027e3:	83 ec 0c             	sub    $0xc,%esp
  8027e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8027ef:	85 db                	test   %ebx,%ebx
  8027f1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027f6:	0f 44 d8             	cmove  %eax,%ebx
  8027f9:	eb 05                	jmp    802800 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8027fb:	e8 27 e5 ff ff       	call   800d27 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802800:	ff 75 14             	pushl  0x14(%ebp)
  802803:	53                   	push   %ebx
  802804:	56                   	push   %esi
  802805:	57                   	push   %edi
  802806:	e8 c8 e6 ff ff       	call   800ed3 <sys_ipc_try_send>
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 1b                	je     80282d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802812:	79 e7                	jns    8027fb <ipc_send+0x1e>
  802814:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802817:	74 e2                	je     8027fb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	68 92 31 80 00       	push   $0x803192
  802821:	6a 46                	push   $0x46
  802823:	68 a7 31 80 00       	push   $0x8031a7
  802828:	e8 51 fe ff ff       	call   80267e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80282d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802830:	5b                   	pop    %ebx
  802831:	5e                   	pop    %esi
  802832:	5f                   	pop    %edi
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    

00802835 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802840:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802846:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80284c:	8b 52 50             	mov    0x50(%edx),%edx
  80284f:	39 ca                	cmp    %ecx,%edx
  802851:	74 11                	je     802864 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802853:	83 c0 01             	add    $0x1,%eax
  802856:	3d 00 04 00 00       	cmp    $0x400,%eax
  80285b:	75 e3                	jne    802840 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
  802862:	eb 0e                	jmp    802872 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802864:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80286a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80286f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802872:	5d                   	pop    %ebp
  802873:	c3                   	ret    

00802874 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80287a:	89 d0                	mov    %edx,%eax
  80287c:	c1 e8 16             	shr    $0x16,%eax
  80287f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80288b:	f6 c1 01             	test   $0x1,%cl
  80288e:	74 1d                	je     8028ad <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802890:	c1 ea 0c             	shr    $0xc,%edx
  802893:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80289a:	f6 c2 01             	test   $0x1,%dl
  80289d:	74 0e                	je     8028ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80289f:	c1 ea 0c             	shr    $0xc,%edx
  8028a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028a9:	ef 
  8028aa:	0f b7 c0             	movzwl %ax,%eax
}
  8028ad:	5d                   	pop    %ebp
  8028ae:	c3                   	ret    
  8028af:	90                   	nop

008028b0 <__udivdi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 1c             	sub    $0x1c,%esp
  8028b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028c7:	85 d2                	test   %edx,%edx
  8028c9:	75 4d                	jne    802918 <__udivdi3+0x68>
  8028cb:	39 f3                	cmp    %esi,%ebx
  8028cd:	76 19                	jbe    8028e8 <__udivdi3+0x38>
  8028cf:	31 ff                	xor    %edi,%edi
  8028d1:	89 e8                	mov    %ebp,%eax
  8028d3:	89 f2                	mov    %esi,%edx
  8028d5:	f7 f3                	div    %ebx
  8028d7:	89 fa                	mov    %edi,%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	89 d9                	mov    %ebx,%ecx
  8028ea:	85 db                	test   %ebx,%ebx
  8028ec:	75 0b                	jne    8028f9 <__udivdi3+0x49>
  8028ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f3:	31 d2                	xor    %edx,%edx
  8028f5:	f7 f3                	div    %ebx
  8028f7:	89 c1                	mov    %eax,%ecx
  8028f9:	31 d2                	xor    %edx,%edx
  8028fb:	89 f0                	mov    %esi,%eax
  8028fd:	f7 f1                	div    %ecx
  8028ff:	89 c6                	mov    %eax,%esi
  802901:	89 e8                	mov    %ebp,%eax
  802903:	89 f7                	mov    %esi,%edi
  802905:	f7 f1                	div    %ecx
  802907:	89 fa                	mov    %edi,%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	39 f2                	cmp    %esi,%edx
  80291a:	77 1c                	ja     802938 <__udivdi3+0x88>
  80291c:	0f bd fa             	bsr    %edx,%edi
  80291f:	83 f7 1f             	xor    $0x1f,%edi
  802922:	75 2c                	jne    802950 <__udivdi3+0xa0>
  802924:	39 f2                	cmp    %esi,%edx
  802926:	72 06                	jb     80292e <__udivdi3+0x7e>
  802928:	31 c0                	xor    %eax,%eax
  80292a:	39 eb                	cmp    %ebp,%ebx
  80292c:	77 a9                	ja     8028d7 <__udivdi3+0x27>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	eb a2                	jmp    8028d7 <__udivdi3+0x27>
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	31 ff                	xor    %edi,%edi
  80293a:	31 c0                	xor    %eax,%eax
  80293c:	89 fa                	mov    %edi,%edx
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	89 f9                	mov    %edi,%ecx
  802952:	b8 20 00 00 00       	mov    $0x20,%eax
  802957:	29 f8                	sub    %edi,%eax
  802959:	d3 e2                	shl    %cl,%edx
  80295b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80295f:	89 c1                	mov    %eax,%ecx
  802961:	89 da                	mov    %ebx,%edx
  802963:	d3 ea                	shr    %cl,%edx
  802965:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802969:	09 d1                	or     %edx,%ecx
  80296b:	89 f2                	mov    %esi,%edx
  80296d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802971:	89 f9                	mov    %edi,%ecx
  802973:	d3 e3                	shl    %cl,%ebx
  802975:	89 c1                	mov    %eax,%ecx
  802977:	d3 ea                	shr    %cl,%edx
  802979:	89 f9                	mov    %edi,%ecx
  80297b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80297f:	89 eb                	mov    %ebp,%ebx
  802981:	d3 e6                	shl    %cl,%esi
  802983:	89 c1                	mov    %eax,%ecx
  802985:	d3 eb                	shr    %cl,%ebx
  802987:	09 de                	or     %ebx,%esi
  802989:	89 f0                	mov    %esi,%eax
  80298b:	f7 74 24 08          	divl   0x8(%esp)
  80298f:	89 d6                	mov    %edx,%esi
  802991:	89 c3                	mov    %eax,%ebx
  802993:	f7 64 24 0c          	mull   0xc(%esp)
  802997:	39 d6                	cmp    %edx,%esi
  802999:	72 15                	jb     8029b0 <__udivdi3+0x100>
  80299b:	89 f9                	mov    %edi,%ecx
  80299d:	d3 e5                	shl    %cl,%ebp
  80299f:	39 c5                	cmp    %eax,%ebp
  8029a1:	73 04                	jae    8029a7 <__udivdi3+0xf7>
  8029a3:	39 d6                	cmp    %edx,%esi
  8029a5:	74 09                	je     8029b0 <__udivdi3+0x100>
  8029a7:	89 d8                	mov    %ebx,%eax
  8029a9:	31 ff                	xor    %edi,%edi
  8029ab:	e9 27 ff ff ff       	jmp    8028d7 <__udivdi3+0x27>
  8029b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029b3:	31 ff                	xor    %edi,%edi
  8029b5:	e9 1d ff ff ff       	jmp    8028d7 <__udivdi3+0x27>
  8029ba:	66 90                	xchg   %ax,%ax
  8029bc:	66 90                	xchg   %ax,%ax
  8029be:	66 90                	xchg   %ax,%ax

008029c0 <__umoddi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029d7:	89 da                	mov    %ebx,%edx
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	75 43                	jne    802a20 <__umoddi3+0x60>
  8029dd:	39 df                	cmp    %ebx,%edi
  8029df:	76 17                	jbe    8029f8 <__umoddi3+0x38>
  8029e1:	89 f0                	mov    %esi,%eax
  8029e3:	f7 f7                	div    %edi
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	31 d2                	xor    %edx,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 fd                	mov    %edi,%ebp
  8029fa:	85 ff                	test   %edi,%edi
  8029fc:	75 0b                	jne    802a09 <__umoddi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f7                	div    %edi
  802a07:	89 c5                	mov    %eax,%ebp
  802a09:	89 d8                	mov    %ebx,%eax
  802a0b:	31 d2                	xor    %edx,%edx
  802a0d:	f7 f5                	div    %ebp
  802a0f:	89 f0                	mov    %esi,%eax
  802a11:	f7 f5                	div    %ebp
  802a13:	89 d0                	mov    %edx,%eax
  802a15:	eb d0                	jmp    8029e7 <__umoddi3+0x27>
  802a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a1e:	66 90                	xchg   %ax,%ax
  802a20:	89 f1                	mov    %esi,%ecx
  802a22:	39 d8                	cmp    %ebx,%eax
  802a24:	76 0a                	jbe    802a30 <__umoddi3+0x70>
  802a26:	89 f0                	mov    %esi,%eax
  802a28:	83 c4 1c             	add    $0x1c,%esp
  802a2b:	5b                   	pop    %ebx
  802a2c:	5e                   	pop    %esi
  802a2d:	5f                   	pop    %edi
  802a2e:	5d                   	pop    %ebp
  802a2f:	c3                   	ret    
  802a30:	0f bd e8             	bsr    %eax,%ebp
  802a33:	83 f5 1f             	xor    $0x1f,%ebp
  802a36:	75 20                	jne    802a58 <__umoddi3+0x98>
  802a38:	39 d8                	cmp    %ebx,%eax
  802a3a:	0f 82 b0 00 00 00    	jb     802af0 <__umoddi3+0x130>
  802a40:	39 f7                	cmp    %esi,%edi
  802a42:	0f 86 a8 00 00 00    	jbe    802af0 <__umoddi3+0x130>
  802a48:	89 c8                	mov    %ecx,%eax
  802a4a:	83 c4 1c             	add    $0x1c,%esp
  802a4d:	5b                   	pop    %ebx
  802a4e:	5e                   	pop    %esi
  802a4f:	5f                   	pop    %edi
  802a50:	5d                   	pop    %ebp
  802a51:	c3                   	ret    
  802a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a58:	89 e9                	mov    %ebp,%ecx
  802a5a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a5f:	29 ea                	sub    %ebp,%edx
  802a61:	d3 e0                	shl    %cl,%eax
  802a63:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a67:	89 d1                	mov    %edx,%ecx
  802a69:	89 f8                	mov    %edi,%eax
  802a6b:	d3 e8                	shr    %cl,%eax
  802a6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a71:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a75:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a79:	09 c1                	or     %eax,%ecx
  802a7b:	89 d8                	mov    %ebx,%eax
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 e9                	mov    %ebp,%ecx
  802a83:	d3 e7                	shl    %cl,%edi
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	d3 e8                	shr    %cl,%eax
  802a89:	89 e9                	mov    %ebp,%ecx
  802a8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a8f:	d3 e3                	shl    %cl,%ebx
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	89 d1                	mov    %edx,%ecx
  802a95:	89 f0                	mov    %esi,%eax
  802a97:	d3 e8                	shr    %cl,%eax
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	89 fa                	mov    %edi,%edx
  802a9d:	d3 e6                	shl    %cl,%esi
  802a9f:	09 d8                	or     %ebx,%eax
  802aa1:	f7 74 24 08          	divl   0x8(%esp)
  802aa5:	89 d1                	mov    %edx,%ecx
  802aa7:	89 f3                	mov    %esi,%ebx
  802aa9:	f7 64 24 0c          	mull   0xc(%esp)
  802aad:	89 c6                	mov    %eax,%esi
  802aaf:	89 d7                	mov    %edx,%edi
  802ab1:	39 d1                	cmp    %edx,%ecx
  802ab3:	72 06                	jb     802abb <__umoddi3+0xfb>
  802ab5:	75 10                	jne    802ac7 <__umoddi3+0x107>
  802ab7:	39 c3                	cmp    %eax,%ebx
  802ab9:	73 0c                	jae    802ac7 <__umoddi3+0x107>
  802abb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802abf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ac3:	89 d7                	mov    %edx,%edi
  802ac5:	89 c6                	mov    %eax,%esi
  802ac7:	89 ca                	mov    %ecx,%edx
  802ac9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ace:	29 f3                	sub    %esi,%ebx
  802ad0:	19 fa                	sbb    %edi,%edx
  802ad2:	89 d0                	mov    %edx,%eax
  802ad4:	d3 e0                	shl    %cl,%eax
  802ad6:	89 e9                	mov    %ebp,%ecx
  802ad8:	d3 eb                	shr    %cl,%ebx
  802ada:	d3 ea                	shr    %cl,%edx
  802adc:	09 d8                	or     %ebx,%eax
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	89 da                	mov    %ebx,%edx
  802af2:	29 fe                	sub    %edi,%esi
  802af4:	19 c2                	sbb    %eax,%edx
  802af6:	89 f1                	mov    %esi,%ecx
  802af8:	89 c8                	mov    %ecx,%eax
  802afa:	e9 4b ff ff ff       	jmp    802a4a <__umoddi3+0x8a>
