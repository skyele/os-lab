
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
  80003d:	e8 f0 0c 00 00       	call   800d32 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 a0 17 80 00       	push   $0x8017a0
  80004c:	e8 ce 01 00 00       	call   80021f <cprintf>

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
  80007e:	e8 c2 08 00 00       	call   800945 <strlen>
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
  80009c:	68 b1 17 80 00       	push   $0x8017b1
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 7f 08 00 00       	call   80092b <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 21 12 00 00       	call   8012d5 <sfork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 af 00 00 00       	call   800178 <exit>
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
  8000d4:	68 b0 17 80 00       	push   $0x8017b0
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ec:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000f3:	00 00 00 
	envid_t find = sys_getenvid();
  8000f6:	e8 37 0c 00 00       	call   800d32 <sys_getenvid>
  8000fb:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800101:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800106:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010b:	bf 01 00 00 00       	mov    $0x1,%edi
  800110:	eb 0b                	jmp    80011d <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800112:	83 c2 01             	add    $0x1,%edx
  800115:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011b:	74 21                	je     80013e <libmain+0x5b>
		if(envs[i].env_id == find)
  80011d:	89 d1                	mov    %edx,%ecx
  80011f:	c1 e1 07             	shl    $0x7,%ecx
  800122:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800128:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012b:	39 c1                	cmp    %eax,%ecx
  80012d:	75 e3                	jne    800112 <libmain+0x2f>
  80012f:	89 d3                	mov    %edx,%ebx
  800131:	c1 e3 07             	shl    $0x7,%ebx
  800134:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013a:	89 fe                	mov    %edi,%esi
  80013c:	eb d4                	jmp    800112 <libmain+0x2f>
  80013e:	89 f0                	mov    %esi,%eax
  800140:	84 c0                	test   %al,%al
  800142:	74 06                	je     80014a <libmain+0x67>
  800144:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014e:	7e 0a                	jle    80015a <libmain+0x77>
		binaryname = argv[0];
  800150:	8b 45 0c             	mov    0xc(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	ff 75 0c             	pushl  0xc(%ebp)
  800160:	ff 75 08             	pushl  0x8(%ebp)
  800163:	e8 66 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  800168:	e8 0b 00 00 00       	call   800178 <exit>
}
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5f                   	pop    %edi
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80017e:	6a 00                	push   $0x0
  800180:	e8 6c 0b 00 00       	call   800cf1 <sys_env_destroy>
}
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	53                   	push   %ebx
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800194:	8b 13                	mov    (%ebx),%edx
  800196:	8d 42 01             	lea    0x1(%edx),%eax
  800199:	89 03                	mov    %eax,(%ebx)
  80019b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a7:	74 09                	je     8001b2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b0:	c9                   	leave  
  8001b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	68 ff 00 00 00       	push   $0xff
  8001ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bd:	50                   	push   %eax
  8001be:	e8 f1 0a 00 00       	call   800cb4 <sys_cputs>
		b->idx = 0;
  8001c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	eb db                	jmp    8001a9 <putch+0x1f>

008001ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001de:	00 00 00 
	b.cnt = 0;
  8001e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001eb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ee:	ff 75 08             	pushl  0x8(%ebp)
  8001f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f7:	50                   	push   %eax
  8001f8:	68 8a 01 80 00       	push   $0x80018a
  8001fd:	e8 4a 01 00 00       	call   80034c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800202:	83 c4 08             	add    $0x8,%esp
  800205:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	e8 9d 0a 00 00       	call   800cb4 <sys_cputs>

	return b.cnt;
}
  800217:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

0080021f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800225:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800228:	50                   	push   %eax
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	e8 9d ff ff ff       	call   8001ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	57                   	push   %edi
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	83 ec 1c             	sub    $0x1c,%esp
  80023c:	89 c6                	mov    %eax,%esi
  80023e:	89 d7                	mov    %edx,%edi
  800240:	8b 45 08             	mov    0x8(%ebp),%eax
  800243:	8b 55 0c             	mov    0xc(%ebp),%edx
  800246:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80024c:	8b 45 10             	mov    0x10(%ebp),%eax
  80024f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800252:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800256:	74 2c                	je     800284 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800258:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800262:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800265:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800268:	39 c2                	cmp    %eax,%edx
  80026a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80026d:	73 43                	jae    8002b2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	85 db                	test   %ebx,%ebx
  800274:	7e 6c                	jle    8002e2 <printnum+0xaf>
				putch(padc, putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	57                   	push   %edi
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	ff d6                	call   *%esi
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	eb eb                	jmp    80026f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	6a 20                	push   $0x20
  800289:	6a 00                	push   $0x0
  80028b:	50                   	push   %eax
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	89 fa                	mov    %edi,%edx
  800294:	89 f0                	mov    %esi,%eax
  800296:	e8 98 ff ff ff       	call   800233 <printnum>
		while (--width > 0)
  80029b:	83 c4 20             	add    $0x20,%esp
  80029e:	83 eb 01             	sub    $0x1,%ebx
  8002a1:	85 db                	test   %ebx,%ebx
  8002a3:	7e 65                	jle    80030a <printnum+0xd7>
			putch(padc, putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	57                   	push   %edi
  8002a9:	6a 20                	push   $0x20
  8002ab:	ff d6                	call   *%esi
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	eb ec                	jmp    80029e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	ff 75 18             	pushl  0x18(%ebp)
  8002b8:	83 eb 01             	sub    $0x1,%ebx
  8002bb:	53                   	push   %ebx
  8002bc:	50                   	push   %eax
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	e8 7f 12 00 00       	call   801550 <__udivdi3>
  8002d1:	83 c4 18             	add    $0x18,%esp
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	89 fa                	mov    %edi,%edx
  8002d8:	89 f0                	mov    %esi,%eax
  8002da:	e8 54 ff ff ff       	call   800233 <printnum>
  8002df:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	57                   	push   %edi
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f5:	e8 66 13 00 00       	call   801660 <__umoddi3>
  8002fa:	83 c4 14             	add    $0x14,%esp
  8002fd:	0f be 80 c0 17 80 00 	movsbl 0x8017c0(%eax),%eax
  800304:	50                   	push   %eax
  800305:	ff d6                	call   *%esi
  800307:	83 c4 10             	add    $0x10,%esp
	}
}
  80030a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030d:	5b                   	pop    %ebx
  80030e:	5e                   	pop    %esi
  80030f:	5f                   	pop    %edi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800318:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031c:	8b 10                	mov    (%eax),%edx
  80031e:	3b 50 04             	cmp    0x4(%eax),%edx
  800321:	73 0a                	jae    80032d <sprintputch+0x1b>
		*b->buf++ = ch;
  800323:	8d 4a 01             	lea    0x1(%edx),%ecx
  800326:	89 08                	mov    %ecx,(%eax)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	88 02                	mov    %al,(%edx)
}
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    

0080032f <printfmt>:
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800335:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800338:	50                   	push   %eax
  800339:	ff 75 10             	pushl  0x10(%ebp)
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	e8 05 00 00 00       	call   80034c <vprintfmt>
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	c9                   	leave  
  80034b:	c3                   	ret    

0080034c <vprintfmt>:
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	57                   	push   %edi
  800350:	56                   	push   %esi
  800351:	53                   	push   %ebx
  800352:	83 ec 3c             	sub    $0x3c,%esp
  800355:	8b 75 08             	mov    0x8(%ebp),%esi
  800358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80035b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035e:	e9 32 04 00 00       	jmp    800795 <vprintfmt+0x449>
		padc = ' ';
  800363:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800367:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800375:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800383:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80038a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8d 47 01             	lea    0x1(%edi),%eax
  800392:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800395:	0f b6 17             	movzbl (%edi),%edx
  800398:	8d 42 dd             	lea    -0x23(%edx),%eax
  80039b:	3c 55                	cmp    $0x55,%al
  80039d:	0f 87 12 05 00 00    	ja     8008b5 <vprintfmt+0x569>
  8003a3:	0f b6 c0             	movzbl %al,%eax
  8003a6:	ff 24 85 a0 19 80 00 	jmp    *0x8019a0(,%eax,4)
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003b4:	eb d9                	jmp    80038f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003bd:	eb d0                	jmp    80038f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	0f b6 d2             	movzbl %dl,%edx
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	89 75 08             	mov    %esi,0x8(%ebp)
  8003cd:	eb 03                	jmp    8003d2 <vprintfmt+0x86>
  8003cf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003d9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003dc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003df:	83 fe 09             	cmp    $0x9,%esi
  8003e2:	76 eb                	jbe    8003cf <vprintfmt+0x83>
  8003e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ea:	eb 14                	jmp    800400 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8d 40 04             	lea    0x4(%eax),%eax
  8003fa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800400:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800404:	79 89                	jns    80038f <vprintfmt+0x43>
				width = precision, precision = -1;
  800406:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800409:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800413:	e9 77 ff ff ff       	jmp    80038f <vprintfmt+0x43>
  800418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041b:	85 c0                	test   %eax,%eax
  80041d:	0f 48 c1             	cmovs  %ecx,%eax
  800420:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800426:	e9 64 ff ff ff       	jmp    80038f <vprintfmt+0x43>
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80042e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800435:	e9 55 ff ff ff       	jmp    80038f <vprintfmt+0x43>
			lflag++;
  80043a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800441:	e9 49 ff ff ff       	jmp    80038f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8d 78 04             	lea    0x4(%eax),%edi
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	53                   	push   %ebx
  800450:	ff 30                	pushl  (%eax)
  800452:	ff d6                	call   *%esi
			break;
  800454:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800457:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80045a:	e9 33 03 00 00       	jmp    800792 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8d 78 04             	lea    0x4(%eax),%edi
  800465:	8b 00                	mov    (%eax),%eax
  800467:	99                   	cltd   
  800468:	31 d0                	xor    %edx,%eax
  80046a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80046c:	83 f8 0f             	cmp    $0xf,%eax
  80046f:	7f 23                	jg     800494 <vprintfmt+0x148>
  800471:	8b 14 85 00 1b 80 00 	mov    0x801b00(,%eax,4),%edx
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 18                	je     800494 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80047c:	52                   	push   %edx
  80047d:	68 e1 17 80 00       	push   $0x8017e1
  800482:	53                   	push   %ebx
  800483:	56                   	push   %esi
  800484:	e8 a6 fe ff ff       	call   80032f <printfmt>
  800489:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048f:	e9 fe 02 00 00       	jmp    800792 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800494:	50                   	push   %eax
  800495:	68 d8 17 80 00       	push   $0x8017d8
  80049a:	53                   	push   %ebx
  80049b:	56                   	push   %esi
  80049c:	e8 8e fe ff ff       	call   80032f <printfmt>
  8004a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a7:	e9 e6 02 00 00       	jmp    800792 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	83 c0 04             	add    $0x4,%eax
  8004b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ba:	85 c9                	test   %ecx,%ecx
  8004bc:	b8 d1 17 80 00       	mov    $0x8017d1,%eax
  8004c1:	0f 45 c1             	cmovne %ecx,%eax
  8004c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cb:	7e 06                	jle    8004d3 <vprintfmt+0x187>
  8004cd:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004d1:	75 0d                	jne    8004e0 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d6:	89 c7                	mov    %eax,%edi
  8004d8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004de:	eb 53                	jmp    800533 <vprintfmt+0x1e7>
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	e8 71 04 00 00       	call   80095d <strnlen>
  8004ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ef:	29 c1                	sub    %eax,%ecx
  8004f1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004f9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800500:	eb 0f                	jmp    800511 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	ff 75 e0             	pushl  -0x20(%ebp)
  800509:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ef 01             	sub    $0x1,%edi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	85 ff                	test   %edi,%edi
  800513:	7f ed                	jg     800502 <vprintfmt+0x1b6>
  800515:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800518:	85 c9                	test   %ecx,%ecx
  80051a:	b8 00 00 00 00       	mov    $0x0,%eax
  80051f:	0f 49 c1             	cmovns %ecx,%eax
  800522:	29 c1                	sub    %eax,%ecx
  800524:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800527:	eb aa                	jmp    8004d3 <vprintfmt+0x187>
					putch(ch, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	52                   	push   %edx
  80052e:	ff d6                	call   *%esi
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800536:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800538:	83 c7 01             	add    $0x1,%edi
  80053b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053f:	0f be d0             	movsbl %al,%edx
  800542:	85 d2                	test   %edx,%edx
  800544:	74 4b                	je     800591 <vprintfmt+0x245>
  800546:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054a:	78 06                	js     800552 <vprintfmt+0x206>
  80054c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800550:	78 1e                	js     800570 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800552:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800556:	74 d1                	je     800529 <vprintfmt+0x1dd>
  800558:	0f be c0             	movsbl %al,%eax
  80055b:	83 e8 20             	sub    $0x20,%eax
  80055e:	83 f8 5e             	cmp    $0x5e,%eax
  800561:	76 c6                	jbe    800529 <vprintfmt+0x1dd>
					putch('?', putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	6a 3f                	push   $0x3f
  800569:	ff d6                	call   *%esi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb c3                	jmp    800533 <vprintfmt+0x1e7>
  800570:	89 cf                	mov    %ecx,%edi
  800572:	eb 0e                	jmp    800582 <vprintfmt+0x236>
				putch(' ', putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	6a 20                	push   $0x20
  80057a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057c:	83 ef 01             	sub    $0x1,%edi
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	85 ff                	test   %edi,%edi
  800584:	7f ee                	jg     800574 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800586:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
  80058c:	e9 01 02 00 00       	jmp    800792 <vprintfmt+0x446>
  800591:	89 cf                	mov    %ecx,%edi
  800593:	eb ed                	jmp    800582 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800598:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80059f:	e9 eb fd ff ff       	jmp    80038f <vprintfmt+0x43>
	if (lflag >= 2)
  8005a4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005a8:	7f 21                	jg     8005cb <vprintfmt+0x27f>
	else if (lflag)
  8005aa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005ae:	74 68                	je     800618 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 40 04             	lea    0x4(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c9:	eb 17                	jmp    8005e2 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f2:	78 3f                	js     800633 <vprintfmt+0x2e7>
			base = 10;
  8005f4:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005f9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005fd:	0f 84 71 01 00 00    	je     800774 <vprintfmt+0x428>
				putch('+', putdat);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	53                   	push   %ebx
  800607:	6a 2b                	push   $0x2b
  800609:	ff d6                	call   *%esi
  80060b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800613:	e9 5c 01 00 00       	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800620:	89 c1                	mov    %eax,%ecx
  800622:	c1 f9 1f             	sar    $0x1f,%ecx
  800625:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	eb af                	jmp    8005e2 <vprintfmt+0x296>
				putch('-', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	6a 2d                	push   $0x2d
  800639:	ff d6                	call   *%esi
				num = -(long long) num;
  80063b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80063e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800641:	f7 d8                	neg    %eax
  800643:	83 d2 00             	adc    $0x0,%edx
  800646:	f7 da                	neg    %edx
  800648:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
  800656:	e9 19 01 00 00       	jmp    800774 <vprintfmt+0x428>
	if (lflag >= 2)
  80065b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80065f:	7f 29                	jg     80068a <vprintfmt+0x33e>
	else if (lflag)
  800661:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800665:	74 44                	je     8006ab <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	ba 00 00 00 00       	mov    $0x0,%edx
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 40 04             	lea    0x4(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800680:	b8 0a 00 00 00       	mov    $0xa,%eax
  800685:	e9 ea 00 00 00       	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 50 04             	mov    0x4(%eax),%edx
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a6:	e9 c9 00 00 00       	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c9:	e9 a6 00 00 00       	jmp    800774 <vprintfmt+0x428>
			putch('0', putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	53                   	push   %ebx
  8006d2:	6a 30                	push   $0x30
  8006d4:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006dd:	7f 26                	jg     800705 <vprintfmt+0x3b9>
	else if (lflag)
  8006df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e3:	74 3e                	je     800723 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 40 04             	lea    0x4(%eax),%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006fe:	b8 08 00 00 00       	mov    $0x8,%eax
  800703:	eb 6f                	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 50 04             	mov    0x4(%eax),%edx
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 40 08             	lea    0x8(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071c:	b8 08 00 00 00       	mov    $0x8,%eax
  800721:	eb 51                	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	b8 08 00 00 00       	mov    $0x8,%eax
  800741:	eb 31                	jmp    800774 <vprintfmt+0x428>
			putch('0', putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	53                   	push   %ebx
  800747:	6a 30                	push   $0x30
  800749:	ff d6                	call   *%esi
			putch('x', putdat);
  80074b:	83 c4 08             	add    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 78                	push   $0x78
  800751:	ff d6                	call   *%esi
			num = (unsigned long long)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800763:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8d 40 04             	lea    0x4(%eax),%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80077b:	52                   	push   %edx
  80077c:	ff 75 e0             	pushl  -0x20(%ebp)
  80077f:	50                   	push   %eax
  800780:	ff 75 dc             	pushl  -0x24(%ebp)
  800783:	ff 75 d8             	pushl  -0x28(%ebp)
  800786:	89 da                	mov    %ebx,%edx
  800788:	89 f0                	mov    %esi,%eax
  80078a:	e8 a4 fa ff ff       	call   800233 <printnum>
			break;
  80078f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800792:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800795:	83 c7 01             	add    $0x1,%edi
  800798:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079c:	83 f8 25             	cmp    $0x25,%eax
  80079f:	0f 84 be fb ff ff    	je     800363 <vprintfmt+0x17>
			if (ch == '\0')
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	0f 84 28 01 00 00    	je     8008d5 <vprintfmt+0x589>
			putch(ch, putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	50                   	push   %eax
  8007b2:	ff d6                	call   *%esi
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	eb dc                	jmp    800795 <vprintfmt+0x449>
	if (lflag >= 2)
  8007b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bd:	7f 26                	jg     8007e5 <vprintfmt+0x499>
	else if (lflag)
  8007bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c3:	74 41                	je     800806 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e3:	eb 8f                	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 50 04             	mov    0x4(%eax),%edx
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 08             	lea    0x8(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800801:	e9 6e ff ff ff       	jmp    800774 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	ba 00 00 00 00       	mov    $0x0,%edx
  800810:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800813:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8d 40 04             	lea    0x4(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081f:	b8 10 00 00 00       	mov    $0x10,%eax
  800824:	e9 4b ff ff ff       	jmp    800774 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 c0 04             	add    $0x4,%eax
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	85 c0                	test   %eax,%eax
  800839:	74 14                	je     80084f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80083b:	8b 13                	mov    (%ebx),%edx
  80083d:	83 fa 7f             	cmp    $0x7f,%edx
  800840:	7f 37                	jg     800879 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800842:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800844:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
  80084a:	e9 43 ff ff ff       	jmp    800792 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80084f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800854:	bf f9 18 80 00       	mov    $0x8018f9,%edi
							putch(ch, putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	53                   	push   %ebx
  80085d:	50                   	push   %eax
  80085e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800860:	83 c7 01             	add    $0x1,%edi
  800863:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	85 c0                	test   %eax,%eax
  80086c:	75 eb                	jne    800859 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80086e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
  800874:	e9 19 ff ff ff       	jmp    800792 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800879:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80087b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800880:	bf 31 19 80 00       	mov    $0x801931,%edi
							putch(ch, putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	53                   	push   %ebx
  800889:	50                   	push   %eax
  80088a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80088c:	83 c7 01             	add    $0x1,%edi
  80088f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	85 c0                	test   %eax,%eax
  800898:	75 eb                	jne    800885 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80089a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	e9 ed fe ff ff       	jmp    800792 <vprintfmt+0x446>
			putch(ch, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	6a 25                	push   $0x25
  8008ab:	ff d6                	call   *%esi
			break;
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	e9 dd fe ff ff       	jmp    800792 <vprintfmt+0x446>
			putch('%', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	6a 25                	push   $0x25
  8008bb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 f8                	mov    %edi,%eax
  8008c2:	eb 03                	jmp    8008c7 <vprintfmt+0x57b>
  8008c4:	83 e8 01             	sub    $0x1,%eax
  8008c7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008cb:	75 f7                	jne    8008c4 <vprintfmt+0x578>
  8008cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d0:	e9 bd fe ff ff       	jmp    800792 <vprintfmt+0x446>
}
  8008d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5f                   	pop    %edi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	74 26                	je     800924 <vsnprintf+0x47>
  8008fe:	85 d2                	test   %edx,%edx
  800900:	7e 22                	jle    800924 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800902:	ff 75 14             	pushl  0x14(%ebp)
  800905:	ff 75 10             	pushl  0x10(%ebp)
  800908:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090b:	50                   	push   %eax
  80090c:	68 12 03 80 00       	push   $0x800312
  800911:	e8 36 fa ff ff       	call   80034c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800919:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091f:	83 c4 10             	add    $0x10,%esp
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    
		return -E_INVAL;
  800924:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800929:	eb f7                	jmp    800922 <vsnprintf+0x45>

0080092b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800931:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800934:	50                   	push   %eax
  800935:	ff 75 10             	pushl  0x10(%ebp)
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	ff 75 08             	pushl  0x8(%ebp)
  80093e:	e8 9a ff ff ff       	call   8008dd <vsnprintf>
	va_end(ap);

	return rc;
}
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800954:	74 05                	je     80095b <strlen+0x16>
		n++;
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	eb f5                	jmp    800950 <strlen+0xb>
	return n;
}
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	74 0d                	je     80097c <strnlen+0x1f>
  80096f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800973:	74 05                	je     80097a <strnlen+0x1d>
		n++;
  800975:	83 c2 01             	add    $0x1,%edx
  800978:	eb f1                	jmp    80096b <strnlen+0xe>
  80097a:	89 d0                	mov    %edx,%eax
	return n;
}
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800991:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800994:	83 c2 01             	add    $0x1,%edx
  800997:	84 c9                	test   %cl,%cl
  800999:	75 f2                	jne    80098d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80099b:	5b                   	pop    %ebx
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 10             	sub    $0x10,%esp
  8009a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a8:	53                   	push   %ebx
  8009a9:	e8 97 ff ff ff       	call   800945 <strlen>
  8009ae:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	01 d8                	add    %ebx,%eax
  8009b6:	50                   	push   %eax
  8009b7:	e8 c2 ff ff ff       	call   80097e <strcpy>
	return dst;
}
  8009bc:	89 d8                	mov    %ebx,%eax
  8009be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ce:	89 c6                	mov    %eax,%esi
  8009d0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d3:	89 c2                	mov    %eax,%edx
  8009d5:	39 f2                	cmp    %esi,%edx
  8009d7:	74 11                	je     8009ea <strncpy+0x27>
		*dst++ = *src;
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	0f b6 19             	movzbl (%ecx),%ebx
  8009df:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e2:	80 fb 01             	cmp    $0x1,%bl
  8009e5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009e8:	eb eb                	jmp    8009d5 <strncpy+0x12>
	}
	return ret;
}
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f9:	8b 55 10             	mov    0x10(%ebp),%edx
  8009fc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009fe:	85 d2                	test   %edx,%edx
  800a00:	74 21                	je     800a23 <strlcpy+0x35>
  800a02:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a06:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	74 14                	je     800a20 <strlcpy+0x32>
  800a0c:	0f b6 19             	movzbl (%ecx),%ebx
  800a0f:	84 db                	test   %bl,%bl
  800a11:	74 0b                	je     800a1e <strlcpy+0x30>
			*dst++ = *src++;
  800a13:	83 c1 01             	add    $0x1,%ecx
  800a16:	83 c2 01             	add    $0x1,%edx
  800a19:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a1c:	eb ea                	jmp    800a08 <strlcpy+0x1a>
  800a1e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a20:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a23:	29 f0                	sub    %esi,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5e                   	pop    %esi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a32:	0f b6 01             	movzbl (%ecx),%eax
  800a35:	84 c0                	test   %al,%al
  800a37:	74 0c                	je     800a45 <strcmp+0x1c>
  800a39:	3a 02                	cmp    (%edx),%al
  800a3b:	75 08                	jne    800a45 <strcmp+0x1c>
		p++, q++;
  800a3d:	83 c1 01             	add    $0x1,%ecx
  800a40:	83 c2 01             	add    $0x1,%edx
  800a43:	eb ed                	jmp    800a32 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a45:	0f b6 c0             	movzbl %al,%eax
  800a48:	0f b6 12             	movzbl (%edx),%edx
  800a4b:	29 d0                	sub    %edx,%eax
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	53                   	push   %ebx
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a59:	89 c3                	mov    %eax,%ebx
  800a5b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a5e:	eb 06                	jmp    800a66 <strncmp+0x17>
		n--, p++, q++;
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a66:	39 d8                	cmp    %ebx,%eax
  800a68:	74 16                	je     800a80 <strncmp+0x31>
  800a6a:	0f b6 08             	movzbl (%eax),%ecx
  800a6d:	84 c9                	test   %cl,%cl
  800a6f:	74 04                	je     800a75 <strncmp+0x26>
  800a71:	3a 0a                	cmp    (%edx),%cl
  800a73:	74 eb                	je     800a60 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a75:	0f b6 00             	movzbl (%eax),%eax
  800a78:	0f b6 12             	movzbl (%edx),%edx
  800a7b:	29 d0                	sub    %edx,%eax
}
  800a7d:	5b                   	pop    %ebx
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    
		return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	eb f6                	jmp    800a7d <strncmp+0x2e>

00800a87 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a91:	0f b6 10             	movzbl (%eax),%edx
  800a94:	84 d2                	test   %dl,%dl
  800a96:	74 09                	je     800aa1 <strchr+0x1a>
		if (*s == c)
  800a98:	38 ca                	cmp    %cl,%dl
  800a9a:	74 0a                	je     800aa6 <strchr+0x1f>
	for (; *s; s++)
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	eb f0                	jmp    800a91 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ab5:	38 ca                	cmp    %cl,%dl
  800ab7:	74 09                	je     800ac2 <strfind+0x1a>
  800ab9:	84 d2                	test   %dl,%dl
  800abb:	74 05                	je     800ac2 <strfind+0x1a>
	for (; *s; s++)
  800abd:	83 c0 01             	add    $0x1,%eax
  800ac0:	eb f0                	jmp    800ab2 <strfind+0xa>
			break;
	return (char *) s;
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 7d 08             	mov    0x8(%ebp),%edi
  800acd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad0:	85 c9                	test   %ecx,%ecx
  800ad2:	74 31                	je     800b05 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad4:	89 f8                	mov    %edi,%eax
  800ad6:	09 c8                	or     %ecx,%eax
  800ad8:	a8 03                	test   $0x3,%al
  800ada:	75 23                	jne    800aff <memset+0x3b>
		c &= 0xFF;
  800adc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae0:	89 d3                	mov    %edx,%ebx
  800ae2:	c1 e3 08             	shl    $0x8,%ebx
  800ae5:	89 d0                	mov    %edx,%eax
  800ae7:	c1 e0 18             	shl    $0x18,%eax
  800aea:	89 d6                	mov    %edx,%esi
  800aec:	c1 e6 10             	shl    $0x10,%esi
  800aef:	09 f0                	or     %esi,%eax
  800af1:	09 c2                	or     %eax,%edx
  800af3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800af5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800af8:	89 d0                	mov    %edx,%eax
  800afa:	fc                   	cld    
  800afb:	f3 ab                	rep stos %eax,%es:(%edi)
  800afd:	eb 06                	jmp    800b05 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	fc                   	cld    
  800b03:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b05:	89 f8                	mov    %edi,%eax
  800b07:	5b                   	pop    %ebx
  800b08:	5e                   	pop    %esi
  800b09:	5f                   	pop    %edi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b1a:	39 c6                	cmp    %eax,%esi
  800b1c:	73 32                	jae    800b50 <memmove+0x44>
  800b1e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b21:	39 c2                	cmp    %eax,%edx
  800b23:	76 2b                	jbe    800b50 <memmove+0x44>
		s += n;
		d += n;
  800b25:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b28:	89 fe                	mov    %edi,%esi
  800b2a:	09 ce                	or     %ecx,%esi
  800b2c:	09 d6                	or     %edx,%esi
  800b2e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b34:	75 0e                	jne    800b44 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b36:	83 ef 04             	sub    $0x4,%edi
  800b39:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b3c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b3f:	fd                   	std    
  800b40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b42:	eb 09                	jmp    800b4d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b44:	83 ef 01             	sub    $0x1,%edi
  800b47:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b4a:	fd                   	std    
  800b4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b4d:	fc                   	cld    
  800b4e:	eb 1a                	jmp    800b6a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	09 ca                	or     %ecx,%edx
  800b54:	09 f2                	or     %esi,%edx
  800b56:	f6 c2 03             	test   $0x3,%dl
  800b59:	75 0a                	jne    800b65 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b63:	eb 05                	jmp    800b6a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	fc                   	cld    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b74:	ff 75 10             	pushl  0x10(%ebp)
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	ff 75 08             	pushl  0x8(%ebp)
  800b7d:	e8 8a ff ff ff       	call   800b0c <memmove>
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8f:	89 c6                	mov    %eax,%esi
  800b91:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b94:	39 f0                	cmp    %esi,%eax
  800b96:	74 1c                	je     800bb4 <memcmp+0x30>
		if (*s1 != *s2)
  800b98:	0f b6 08             	movzbl (%eax),%ecx
  800b9b:	0f b6 1a             	movzbl (%edx),%ebx
  800b9e:	38 d9                	cmp    %bl,%cl
  800ba0:	75 08                	jne    800baa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	83 c2 01             	add    $0x1,%edx
  800ba8:	eb ea                	jmp    800b94 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800baa:	0f b6 c1             	movzbl %cl,%eax
  800bad:	0f b6 db             	movzbl %bl,%ebx
  800bb0:	29 d8                	sub    %ebx,%eax
  800bb2:	eb 05                	jmp    800bb9 <memcmp+0x35>
	}

	return 0;
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc6:	89 c2                	mov    %eax,%edx
  800bc8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bcb:	39 d0                	cmp    %edx,%eax
  800bcd:	73 09                	jae    800bd8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bcf:	38 08                	cmp    %cl,(%eax)
  800bd1:	74 05                	je     800bd8 <memfind+0x1b>
	for (; s < ends; s++)
  800bd3:	83 c0 01             	add    $0x1,%eax
  800bd6:	eb f3                	jmp    800bcb <memfind+0xe>
			break;
	return (void *) s;
}
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	57                   	push   %edi
  800bde:	56                   	push   %esi
  800bdf:	53                   	push   %ebx
  800be0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be6:	eb 03                	jmp    800beb <strtol+0x11>
		s++;
  800be8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800beb:	0f b6 01             	movzbl (%ecx),%eax
  800bee:	3c 20                	cmp    $0x20,%al
  800bf0:	74 f6                	je     800be8 <strtol+0xe>
  800bf2:	3c 09                	cmp    $0x9,%al
  800bf4:	74 f2                	je     800be8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bf6:	3c 2b                	cmp    $0x2b,%al
  800bf8:	74 2a                	je     800c24 <strtol+0x4a>
	int neg = 0;
  800bfa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bff:	3c 2d                	cmp    $0x2d,%al
  800c01:	74 2b                	je     800c2e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c03:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c09:	75 0f                	jne    800c1a <strtol+0x40>
  800c0b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c0e:	74 28                	je     800c38 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c10:	85 db                	test   %ebx,%ebx
  800c12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c17:	0f 44 d8             	cmove  %eax,%ebx
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c22:	eb 50                	jmp    800c74 <strtol+0x9a>
		s++;
  800c24:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c27:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2c:	eb d5                	jmp    800c03 <strtol+0x29>
		s++, neg = 1;
  800c2e:	83 c1 01             	add    $0x1,%ecx
  800c31:	bf 01 00 00 00       	mov    $0x1,%edi
  800c36:	eb cb                	jmp    800c03 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c38:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c3c:	74 0e                	je     800c4c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c3e:	85 db                	test   %ebx,%ebx
  800c40:	75 d8                	jne    800c1a <strtol+0x40>
		s++, base = 8;
  800c42:	83 c1 01             	add    $0x1,%ecx
  800c45:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c4a:	eb ce                	jmp    800c1a <strtol+0x40>
		s += 2, base = 16;
  800c4c:	83 c1 02             	add    $0x2,%ecx
  800c4f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c54:	eb c4                	jmp    800c1a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c56:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 29                	ja     800c89 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c66:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c69:	7d 30                	jge    800c9b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c6b:	83 c1 01             	add    $0x1,%ecx
  800c6e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c72:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c74:	0f b6 11             	movzbl (%ecx),%edx
  800c77:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c7a:	89 f3                	mov    %esi,%ebx
  800c7c:	80 fb 09             	cmp    $0x9,%bl
  800c7f:	77 d5                	ja     800c56 <strtol+0x7c>
			dig = *s - '0';
  800c81:	0f be d2             	movsbl %dl,%edx
  800c84:	83 ea 30             	sub    $0x30,%edx
  800c87:	eb dd                	jmp    800c66 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c89:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c8c:	89 f3                	mov    %esi,%ebx
  800c8e:	80 fb 19             	cmp    $0x19,%bl
  800c91:	77 08                	ja     800c9b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c93:	0f be d2             	movsbl %dl,%edx
  800c96:	83 ea 37             	sub    $0x37,%edx
  800c99:	eb cb                	jmp    800c66 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9f:	74 05                	je     800ca6 <strtol+0xcc>
		*endptr = (char *) s;
  800ca1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ca6:	89 c2                	mov    %eax,%edx
  800ca8:	f7 da                	neg    %edx
  800caa:	85 ff                	test   %edi,%edi
  800cac:	0f 45 c2             	cmovne %edx,%eax
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	89 c3                	mov    %eax,%ebx
  800cc7:	89 c7                	mov    %eax,%edi
  800cc9:	89 c6                	mov    %eax,%esi
  800ccb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce2:	89 d1                	mov    %edx,%ecx
  800ce4:	89 d3                	mov    %edx,%ebx
  800ce6:	89 d7                	mov    %edx,%edi
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	b8 03 00 00 00       	mov    $0x3,%eax
  800d07:	89 cb                	mov    %ecx,%ebx
  800d09:	89 cf                	mov    %ecx,%edi
  800d0b:	89 ce                	mov    %ecx,%esi
  800d0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	7f 08                	jg     800d1b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	50                   	push   %eax
  800d1f:	6a 03                	push   $0x3
  800d21:	68 40 1b 80 00       	push   $0x801b40
  800d26:	6a 43                	push   $0x43
  800d28:	68 5d 1b 80 00       	push   $0x801b5d
  800d2d:	e8 28 07 00 00       	call   80145a <_panic>

00800d32 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d38:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d42:	89 d1                	mov    %edx,%ecx
  800d44:	89 d3                	mov    %edx,%ebx
  800d46:	89 d7                	mov    %edx,%edi
  800d48:	89 d6                	mov    %edx,%esi
  800d4a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <sys_yield>:

void
sys_yield(void)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d57:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d61:	89 d1                	mov    %edx,%ecx
  800d63:	89 d3                	mov    %edx,%ebx
  800d65:	89 d7                	mov    %edx,%edi
  800d67:	89 d6                	mov    %edx,%esi
  800d69:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	be 00 00 00 00       	mov    $0x0,%esi
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 04 00 00 00       	mov    $0x4,%eax
  800d89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8c:	89 f7                	mov    %esi,%edi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 04                	push   $0x4
  800da2:	68 40 1b 80 00       	push   $0x801b40
  800da7:	6a 43                	push   $0x43
  800da9:	68 5d 1b 80 00       	push   $0x801b5d
  800dae:	e8 a7 06 00 00       	call   80145a <_panic>

00800db3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcd:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 05                	push   $0x5
  800de4:	68 40 1b 80 00       	push   $0x801b40
  800de9:	6a 43                	push   $0x43
  800deb:	68 5d 1b 80 00       	push   $0x801b5d
  800df0:	e8 65 06 00 00       	call   80145a <_panic>

00800df5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 06 00 00 00       	mov    $0x6,%eax
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 06                	push   $0x6
  800e26:	68 40 1b 80 00       	push   $0x801b40
  800e2b:	6a 43                	push   $0x43
  800e2d:	68 5d 1b 80 00       	push   $0x801b5d
  800e32:	e8 23 06 00 00       	call   80145a <_panic>

00800e37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	89 de                	mov    %ebx,%esi
  800e54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 08                	push   $0x8
  800e68:	68 40 1b 80 00       	push   $0x801b40
  800e6d:	6a 43                	push   $0x43
  800e6f:	68 5d 1b 80 00       	push   $0x801b5d
  800e74:	e8 e1 05 00 00       	call   80145a <_panic>

00800e79 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7f 08                	jg     800ea4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	50                   	push   %eax
  800ea8:	6a 09                	push   $0x9
  800eaa:	68 40 1b 80 00       	push   $0x801b40
  800eaf:	6a 43                	push   $0x43
  800eb1:	68 5d 1b 80 00       	push   $0x801b5d
  800eb6:	e8 9f 05 00 00       	call   80145a <_panic>

00800ebb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed4:	89 df                	mov    %ebx,%edi
  800ed6:	89 de                	mov    %ebx,%esi
  800ed8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eda:	85 c0                	test   %eax,%eax
  800edc:	7f 08                	jg     800ee6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	6a 0a                	push   $0xa
  800eec:	68 40 1b 80 00       	push   $0x801b40
  800ef1:	6a 43                	push   $0x43
  800ef3:	68 5d 1b 80 00       	push   $0x801b5d
  800ef8:	e8 5d 05 00 00       	call   80145a <_panic>

00800efd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f0e:	be 00 00 00 00       	mov    $0x0,%esi
  800f13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f16:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f19:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f29:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f36:	89 cb                	mov    %ecx,%ebx
  800f38:	89 cf                	mov    %ecx,%edi
  800f3a:	89 ce                	mov    %ecx,%esi
  800f3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	7f 08                	jg     800f4a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	50                   	push   %eax
  800f4e:	6a 0d                	push   $0xd
  800f50:	68 40 1b 80 00       	push   $0x801b40
  800f55:	6a 43                	push   $0x43
  800f57:	68 5d 1b 80 00       	push   $0x801b5d
  800f5c:	e8 f9 04 00 00       	call   80145a <_panic>

00800f61 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f77:	89 df                	mov    %ebx,%edi
  800f79:	89 de                	mov    %ebx,%esi
  800f7b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  800fa9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fb0:	83 e1 07             	and    $0x7,%ecx
  800fb3:	83 f9 07             	cmp    $0x7,%ecx
  800fb6:	74 32                	je     800fea <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  800fb8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fbf:	81 e1 05 08 00 00    	and    $0x805,%ecx
  800fc5:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  800fcb:	74 7d                	je     80104a <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  800fcd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fd4:	83 e1 05             	and    $0x5,%ecx
  800fd7:	83 f9 05             	cmp    $0x5,%ecx
  800fda:	0f 84 9e 00 00 00    	je     80107e <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  800fea:	89 d3                	mov    %edx,%ebx
  800fec:	c1 e3 0c             	shl    $0xc,%ebx
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	68 05 08 00 00       	push   $0x805
  800ff7:	53                   	push   %ebx
  800ff8:	50                   	push   %eax
  800ff9:	53                   	push   %ebx
  800ffa:	6a 00                	push   $0x0
  800ffc:	e8 b2 fd ff ff       	call   800db3 <sys_page_map>
		if(r < 0)
  801001:	83 c4 20             	add    $0x20,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	78 2e                	js     801036 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	68 05 08 00 00       	push   $0x805
  801010:	53                   	push   %ebx
  801011:	6a 00                	push   $0x0
  801013:	53                   	push   %ebx
  801014:	6a 00                	push   $0x0
  801016:	e8 98 fd ff ff       	call   800db3 <sys_page_map>
		if(r < 0)
  80101b:	83 c4 20             	add    $0x20,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	79 be                	jns    800fe0 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801022:	83 ec 04             	sub    $0x4,%esp
  801025:	68 6b 1b 80 00       	push   $0x801b6b
  80102a:	6a 57                	push   $0x57
  80102c:	68 81 1b 80 00       	push   $0x801b81
  801031:	e8 24 04 00 00       	call   80145a <_panic>
			panic("sys_page_map() panic\n");
  801036:	83 ec 04             	sub    $0x4,%esp
  801039:	68 6b 1b 80 00       	push   $0x801b6b
  80103e:	6a 53                	push   $0x53
  801040:	68 81 1b 80 00       	push   $0x801b81
  801045:	e8 10 04 00 00       	call   80145a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80104a:	c1 e2 0c             	shl    $0xc,%edx
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	68 05 08 00 00       	push   $0x805
  801055:	52                   	push   %edx
  801056:	50                   	push   %eax
  801057:	52                   	push   %edx
  801058:	6a 00                	push   $0x0
  80105a:	e8 54 fd ff ff       	call   800db3 <sys_page_map>
		if(r < 0)
  80105f:	83 c4 20             	add    $0x20,%esp
  801062:	85 c0                	test   %eax,%eax
  801064:	0f 89 76 ff ff ff    	jns    800fe0 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	68 6b 1b 80 00       	push   $0x801b6b
  801072:	6a 5e                	push   $0x5e
  801074:	68 81 1b 80 00       	push   $0x801b81
  801079:	e8 dc 03 00 00       	call   80145a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80107e:	c1 e2 0c             	shl    $0xc,%edx
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	6a 05                	push   $0x5
  801086:	52                   	push   %edx
  801087:	50                   	push   %eax
  801088:	52                   	push   %edx
  801089:	6a 00                	push   $0x0
  80108b:	e8 23 fd ff ff       	call   800db3 <sys_page_map>
		if(r < 0)
  801090:	83 c4 20             	add    $0x20,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	0f 89 45 ff ff ff    	jns    800fe0 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80109b:	83 ec 04             	sub    $0x4,%esp
  80109e:	68 6b 1b 80 00       	push   $0x801b6b
  8010a3:	6a 65                	push   $0x65
  8010a5:	68 81 1b 80 00       	push   $0x801b81
  8010aa:	e8 ab 03 00 00       	call   80145a <_panic>

008010af <pgfault>:
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8010b9:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010bb:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8010bf:	0f 84 99 00 00 00    	je     80115e <pgfault+0xaf>
  8010c5:	89 c2                	mov    %eax,%edx
  8010c7:	c1 ea 16             	shr    $0x16,%edx
  8010ca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d1:	f6 c2 01             	test   $0x1,%dl
  8010d4:	0f 84 84 00 00 00    	je     80115e <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	c1 ea 0c             	shr    $0xc,%edx
  8010df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e6:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010ec:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8010f2:	75 6a                	jne    80115e <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8010f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f9:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8010fb:	83 ec 04             	sub    $0x4,%esp
  8010fe:	6a 07                	push   $0x7
  801100:	68 00 f0 7f 00       	push   $0x7ff000
  801105:	6a 00                	push   $0x0
  801107:	e8 64 fc ff ff       	call   800d70 <sys_page_alloc>
	if(ret < 0)
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 5f                	js     801172 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801113:	83 ec 04             	sub    $0x4,%esp
  801116:	68 00 10 00 00       	push   $0x1000
  80111b:	53                   	push   %ebx
  80111c:	68 00 f0 7f 00       	push   $0x7ff000
  801121:	e8 48 fa ff ff       	call   800b6e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801126:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80112d:	53                   	push   %ebx
  80112e:	6a 00                	push   $0x0
  801130:	68 00 f0 7f 00       	push   $0x7ff000
  801135:	6a 00                	push   $0x0
  801137:	e8 77 fc ff ff       	call   800db3 <sys_page_map>
	if(ret < 0)
  80113c:	83 c4 20             	add    $0x20,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	78 43                	js     801186 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801143:	83 ec 08             	sub    $0x8,%esp
  801146:	68 00 f0 7f 00       	push   $0x7ff000
  80114b:	6a 00                	push   $0x0
  80114d:	e8 a3 fc ff ff       	call   800df5 <sys_page_unmap>
	if(ret < 0)
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	78 41                	js     80119a <pgfault+0xeb>
}
  801159:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    
		panic("panic at pgfault()\n");
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	68 8c 1b 80 00       	push   $0x801b8c
  801166:	6a 26                	push   $0x26
  801168:	68 81 1b 80 00       	push   $0x801b81
  80116d:	e8 e8 02 00 00       	call   80145a <_panic>
		panic("panic in sys_page_alloc()\n");
  801172:	83 ec 04             	sub    $0x4,%esp
  801175:	68 a0 1b 80 00       	push   $0x801ba0
  80117a:	6a 31                	push   $0x31
  80117c:	68 81 1b 80 00       	push   $0x801b81
  801181:	e8 d4 02 00 00       	call   80145a <_panic>
		panic("panic in sys_page_map()\n");
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	68 bb 1b 80 00       	push   $0x801bbb
  80118e:	6a 36                	push   $0x36
  801190:	68 81 1b 80 00       	push   $0x801b81
  801195:	e8 c0 02 00 00       	call   80145a <_panic>
		panic("panic in sys_page_unmap()\n");
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	68 d4 1b 80 00       	push   $0x801bd4
  8011a2:	6a 39                	push   $0x39
  8011a4:	68 81 1b 80 00       	push   $0x801b81
  8011a9:	e8 ac 02 00 00       	call   80145a <_panic>

008011ae <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	57                   	push   %edi
  8011b2:	56                   	push   %esi
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  8011b7:	68 af 10 80 00       	push   $0x8010af
  8011bc:	e8 fa 02 00 00       	call   8014bb <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011c1:	b8 07 00 00 00       	mov    $0x7,%eax
  8011c6:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	78 27                	js     8011f6 <fork+0x48>
  8011cf:	89 c6                	mov    %eax,%esi
  8011d1:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8011d3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8011d8:	75 48                	jne    801222 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011da:	e8 53 fb ff ff       	call   800d32 <sys_getenvid>
  8011df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011e4:	c1 e0 07             	shl    $0x7,%eax
  8011e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ec:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8011f1:	e9 90 00 00 00       	jmp    801286 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	68 fc 1b 80 00       	push   $0x801bfc
  8011fe:	68 85 00 00 00       	push   $0x85
  801203:	68 81 1b 80 00       	push   $0x801b81
  801208:	e8 4d 02 00 00       	call   80145a <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80120d:	89 f8                	mov    %edi,%eax
  80120f:	e8 8e fd ff ff       	call   800fa2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801214:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80121a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801220:	74 26                	je     801248 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801222:	89 d8                	mov    %ebx,%eax
  801224:	c1 e8 16             	shr    $0x16,%eax
  801227:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122e:	a8 01                	test   $0x1,%al
  801230:	74 e2                	je     801214 <fork+0x66>
  801232:	89 da                	mov    %ebx,%edx
  801234:	c1 ea 0c             	shr    $0xc,%edx
  801237:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80123e:	83 e0 05             	and    $0x5,%eax
  801241:	83 f8 05             	cmp    $0x5,%eax
  801244:	75 ce                	jne    801214 <fork+0x66>
  801246:	eb c5                	jmp    80120d <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801248:	83 ec 04             	sub    $0x4,%esp
  80124b:	6a 07                	push   $0x7
  80124d:	68 00 f0 bf ee       	push   $0xeebff000
  801252:	56                   	push   %esi
  801253:	e8 18 fb ff ff       	call   800d70 <sys_page_alloc>
	if(ret < 0)
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 31                	js     801290 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	68 2a 15 80 00       	push   $0x80152a
  801267:	56                   	push   %esi
  801268:	e8 4e fc ff ff       	call   800ebb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 33                	js     8012a7 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	6a 02                	push   $0x2
  801279:	56                   	push   %esi
  80127a:	e8 b8 fb ff ff       	call   800e37 <sys_env_set_status>
	if(ret < 0)
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 38                	js     8012be <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801286:	89 f0                	mov    %esi,%eax
  801288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	68 a0 1b 80 00       	push   $0x801ba0
  801298:	68 91 00 00 00       	push   $0x91
  80129d:	68 81 1b 80 00       	push   $0x801b81
  8012a2:	e8 b3 01 00 00       	call   80145a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	68 20 1c 80 00       	push   $0x801c20
  8012af:	68 94 00 00 00       	push   $0x94
  8012b4:	68 81 1b 80 00       	push   $0x801b81
  8012b9:	e8 9c 01 00 00       	call   80145a <_panic>
		panic("panic in sys_env_set_status()\n");
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	68 48 1c 80 00       	push   $0x801c48
  8012c6:	68 97 00 00 00       	push   $0x97
  8012cb:	68 81 1b 80 00       	push   $0x801b81
  8012d0:	e8 85 01 00 00       	call   80145a <_panic>

008012d5 <sfork>:

// Challenge!
int
sfork(void)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8012de:	a1 04 20 80 00       	mov    0x802004,%eax
  8012e3:	8b 40 48             	mov    0x48(%eax),%eax
  8012e6:	68 68 1c 80 00       	push   $0x801c68
  8012eb:	50                   	push   %eax
  8012ec:	68 ef 1b 80 00       	push   $0x801bef
  8012f1:	e8 29 ef ff ff       	call   80021f <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8012f6:	c7 04 24 af 10 80 00 	movl   $0x8010af,(%esp)
  8012fd:	e8 b9 01 00 00       	call   8014bb <set_pgfault_handler>
  801302:	b8 07 00 00 00       	mov    $0x7,%eax
  801307:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 27                	js     801337 <sfork+0x62>
  801310:	89 c7                	mov    %eax,%edi
  801312:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801314:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801319:	75 55                	jne    801370 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80131b:	e8 12 fa ff ff       	call   800d32 <sys_getenvid>
  801320:	25 ff 03 00 00       	and    $0x3ff,%eax
  801325:	c1 e0 07             	shl    $0x7,%eax
  801328:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80132d:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801332:	e9 d4 00 00 00       	jmp    80140b <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	68 fc 1b 80 00       	push   $0x801bfc
  80133f:	68 a9 00 00 00       	push   $0xa9
  801344:	68 81 1b 80 00       	push   $0x801b81
  801349:	e8 0c 01 00 00       	call   80145a <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80134e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801353:	89 f0                	mov    %esi,%eax
  801355:	e8 48 fc ff ff       	call   800fa2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80135a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801360:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801366:	77 65                	ja     8013cd <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  801368:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80136e:	74 de                	je     80134e <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801370:	89 d8                	mov    %ebx,%eax
  801372:	c1 e8 16             	shr    $0x16,%eax
  801375:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137c:	a8 01                	test   $0x1,%al
  80137e:	74 da                	je     80135a <sfork+0x85>
  801380:	89 da                	mov    %ebx,%edx
  801382:	c1 ea 0c             	shr    $0xc,%edx
  801385:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80138c:	83 e0 05             	and    $0x5,%eax
  80138f:	83 f8 05             	cmp    $0x5,%eax
  801392:	75 c6                	jne    80135a <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801394:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80139b:	c1 e2 0c             	shl    $0xc,%edx
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	83 e0 07             	and    $0x7,%eax
  8013a4:	50                   	push   %eax
  8013a5:	52                   	push   %edx
  8013a6:	56                   	push   %esi
  8013a7:	52                   	push   %edx
  8013a8:	6a 00                	push   $0x0
  8013aa:	e8 04 fa ff ff       	call   800db3 <sys_page_map>
  8013af:	83 c4 20             	add    $0x20,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	74 a4                	je     80135a <sfork+0x85>
				panic("sys_page_map() panic\n");
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	68 6b 1b 80 00       	push   $0x801b6b
  8013be:	68 b4 00 00 00       	push   $0xb4
  8013c3:	68 81 1b 80 00       	push   $0x801b81
  8013c8:	e8 8d 00 00 00       	call   80145a <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	6a 07                	push   $0x7
  8013d2:	68 00 f0 bf ee       	push   $0xeebff000
  8013d7:	57                   	push   %edi
  8013d8:	e8 93 f9 ff ff       	call   800d70 <sys_page_alloc>
	if(ret < 0)
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	78 31                	js     801415 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	68 2a 15 80 00       	push   $0x80152a
  8013ec:	57                   	push   %edi
  8013ed:	e8 c9 fa ff ff       	call   800ebb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 33                	js     80142c <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	6a 02                	push   $0x2
  8013fe:	57                   	push   %edi
  8013ff:	e8 33 fa ff ff       	call   800e37 <sys_env_set_status>
	if(ret < 0)
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	78 38                	js     801443 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80140b:	89 f8                	mov    %edi,%eax
  80140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801410:	5b                   	pop    %ebx
  801411:	5e                   	pop    %esi
  801412:	5f                   	pop    %edi
  801413:	5d                   	pop    %ebp
  801414:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	68 a0 1b 80 00       	push   $0x801ba0
  80141d:	68 ba 00 00 00       	push   $0xba
  801422:	68 81 1b 80 00       	push   $0x801b81
  801427:	e8 2e 00 00 00       	call   80145a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 20 1c 80 00       	push   $0x801c20
  801434:	68 bd 00 00 00       	push   $0xbd
  801439:	68 81 1b 80 00       	push   $0x801b81
  80143e:	e8 17 00 00 00       	call   80145a <_panic>
		panic("panic in sys_env_set_status()\n");
  801443:	83 ec 04             	sub    $0x4,%esp
  801446:	68 48 1c 80 00       	push   $0x801c48
  80144b:	68 c0 00 00 00       	push   $0xc0
  801450:	68 81 1b 80 00       	push   $0x801b81
  801455:	e8 00 00 00 00       	call   80145a <_panic>

0080145a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	56                   	push   %esi
  80145e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80145f:	a1 04 20 80 00       	mov    0x802004,%eax
  801464:	8b 40 48             	mov    0x48(%eax),%eax
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 94 1c 80 00       	push   $0x801c94
  80146f:	50                   	push   %eax
  801470:	68 ef 1b 80 00       	push   $0x801bef
  801475:	e8 a5 ed ff ff       	call   80021f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80147a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80147d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801483:	e8 aa f8 ff ff       	call   800d32 <sys_getenvid>
  801488:	83 c4 04             	add    $0x4,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	56                   	push   %esi
  801492:	50                   	push   %eax
  801493:	68 70 1c 80 00       	push   $0x801c70
  801498:	e8 82 ed ff ff       	call   80021f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80149d:	83 c4 18             	add    $0x18,%esp
  8014a0:	53                   	push   %ebx
  8014a1:	ff 75 10             	pushl  0x10(%ebp)
  8014a4:	e8 25 ed ff ff       	call   8001ce <vcprintf>
	cprintf("\n");
  8014a9:	c7 04 24 af 17 80 00 	movl   $0x8017af,(%esp)
  8014b0:	e8 6a ed ff ff       	call   80021f <cprintf>
  8014b5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014b8:	cc                   	int3   
  8014b9:	eb fd                	jmp    8014b8 <_panic+0x5e>

008014bb <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8014c1:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8014c8:	74 0a                	je     8014d4 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	6a 07                	push   $0x7
  8014d9:	68 00 f0 bf ee       	push   $0xeebff000
  8014de:	6a 00                	push   $0x0
  8014e0:	e8 8b f8 ff ff       	call   800d70 <sys_page_alloc>
		if(r < 0)
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 2a                	js     801516 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8014ec:	83 ec 08             	sub    $0x8,%esp
  8014ef:	68 2a 15 80 00       	push   $0x80152a
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 c0 f9 ff ff       	call   800ebb <sys_env_set_pgfault_upcall>
		if(r < 0)
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	79 c8                	jns    8014ca <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 cc 1c 80 00       	push   $0x801ccc
  80150a:	6a 25                	push   $0x25
  80150c:	68 08 1d 80 00       	push   $0x801d08
  801511:	e8 44 ff ff ff       	call   80145a <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	68 9c 1c 80 00       	push   $0x801c9c
  80151e:	6a 22                	push   $0x22
  801520:	68 08 1d 80 00       	push   $0x801d08
  801525:	e8 30 ff ff ff       	call   80145a <_panic>

0080152a <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80152a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80152b:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801530:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801532:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801535:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801539:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80153d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801540:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801542:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801546:	83 c4 08             	add    $0x8,%esp
	popal
  801549:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80154a:	83 c4 04             	add    $0x4,%esp
	popfl
  80154d:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80154e:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80154f:	c3                   	ret    

00801550 <__udivdi3>:
  801550:	55                   	push   %ebp
  801551:	57                   	push   %edi
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
  801554:	83 ec 1c             	sub    $0x1c,%esp
  801557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80155b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80155f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801567:	85 d2                	test   %edx,%edx
  801569:	75 4d                	jne    8015b8 <__udivdi3+0x68>
  80156b:	39 f3                	cmp    %esi,%ebx
  80156d:	76 19                	jbe    801588 <__udivdi3+0x38>
  80156f:	31 ff                	xor    %edi,%edi
  801571:	89 e8                	mov    %ebp,%eax
  801573:	89 f2                	mov    %esi,%edx
  801575:	f7 f3                	div    %ebx
  801577:	89 fa                	mov    %edi,%edx
  801579:	83 c4 1c             	add    $0x1c,%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
  801581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801588:	89 d9                	mov    %ebx,%ecx
  80158a:	85 db                	test   %ebx,%ebx
  80158c:	75 0b                	jne    801599 <__udivdi3+0x49>
  80158e:	b8 01 00 00 00       	mov    $0x1,%eax
  801593:	31 d2                	xor    %edx,%edx
  801595:	f7 f3                	div    %ebx
  801597:	89 c1                	mov    %eax,%ecx
  801599:	31 d2                	xor    %edx,%edx
  80159b:	89 f0                	mov    %esi,%eax
  80159d:	f7 f1                	div    %ecx
  80159f:	89 c6                	mov    %eax,%esi
  8015a1:	89 e8                	mov    %ebp,%eax
  8015a3:	89 f7                	mov    %esi,%edi
  8015a5:	f7 f1                	div    %ecx
  8015a7:	89 fa                	mov    %edi,%edx
  8015a9:	83 c4 1c             	add    $0x1c,%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5f                   	pop    %edi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    
  8015b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015b8:	39 f2                	cmp    %esi,%edx
  8015ba:	77 1c                	ja     8015d8 <__udivdi3+0x88>
  8015bc:	0f bd fa             	bsr    %edx,%edi
  8015bf:	83 f7 1f             	xor    $0x1f,%edi
  8015c2:	75 2c                	jne    8015f0 <__udivdi3+0xa0>
  8015c4:	39 f2                	cmp    %esi,%edx
  8015c6:	72 06                	jb     8015ce <__udivdi3+0x7e>
  8015c8:	31 c0                	xor    %eax,%eax
  8015ca:	39 eb                	cmp    %ebp,%ebx
  8015cc:	77 a9                	ja     801577 <__udivdi3+0x27>
  8015ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d3:	eb a2                	jmp    801577 <__udivdi3+0x27>
  8015d5:	8d 76 00             	lea    0x0(%esi),%esi
  8015d8:	31 ff                	xor    %edi,%edi
  8015da:	31 c0                	xor    %eax,%eax
  8015dc:	89 fa                	mov    %edi,%edx
  8015de:	83 c4 1c             	add    $0x1c,%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5f                   	pop    %edi
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    
  8015e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015ed:	8d 76 00             	lea    0x0(%esi),%esi
  8015f0:	89 f9                	mov    %edi,%ecx
  8015f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015f7:	29 f8                	sub    %edi,%eax
  8015f9:	d3 e2                	shl    %cl,%edx
  8015fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015ff:	89 c1                	mov    %eax,%ecx
  801601:	89 da                	mov    %ebx,%edx
  801603:	d3 ea                	shr    %cl,%edx
  801605:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801609:	09 d1                	or     %edx,%ecx
  80160b:	89 f2                	mov    %esi,%edx
  80160d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801611:	89 f9                	mov    %edi,%ecx
  801613:	d3 e3                	shl    %cl,%ebx
  801615:	89 c1                	mov    %eax,%ecx
  801617:	d3 ea                	shr    %cl,%edx
  801619:	89 f9                	mov    %edi,%ecx
  80161b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80161f:	89 eb                	mov    %ebp,%ebx
  801621:	d3 e6                	shl    %cl,%esi
  801623:	89 c1                	mov    %eax,%ecx
  801625:	d3 eb                	shr    %cl,%ebx
  801627:	09 de                	or     %ebx,%esi
  801629:	89 f0                	mov    %esi,%eax
  80162b:	f7 74 24 08          	divl   0x8(%esp)
  80162f:	89 d6                	mov    %edx,%esi
  801631:	89 c3                	mov    %eax,%ebx
  801633:	f7 64 24 0c          	mull   0xc(%esp)
  801637:	39 d6                	cmp    %edx,%esi
  801639:	72 15                	jb     801650 <__udivdi3+0x100>
  80163b:	89 f9                	mov    %edi,%ecx
  80163d:	d3 e5                	shl    %cl,%ebp
  80163f:	39 c5                	cmp    %eax,%ebp
  801641:	73 04                	jae    801647 <__udivdi3+0xf7>
  801643:	39 d6                	cmp    %edx,%esi
  801645:	74 09                	je     801650 <__udivdi3+0x100>
  801647:	89 d8                	mov    %ebx,%eax
  801649:	31 ff                	xor    %edi,%edi
  80164b:	e9 27 ff ff ff       	jmp    801577 <__udivdi3+0x27>
  801650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801653:	31 ff                	xor    %edi,%edi
  801655:	e9 1d ff ff ff       	jmp    801577 <__udivdi3+0x27>
  80165a:	66 90                	xchg   %ax,%ax
  80165c:	66 90                	xchg   %ax,%ax
  80165e:	66 90                	xchg   %ax,%ax

00801660 <__umoddi3>:
  801660:	55                   	push   %ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 1c             	sub    $0x1c,%esp
  801667:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80166b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80166f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801677:	89 da                	mov    %ebx,%edx
  801679:	85 c0                	test   %eax,%eax
  80167b:	75 43                	jne    8016c0 <__umoddi3+0x60>
  80167d:	39 df                	cmp    %ebx,%edi
  80167f:	76 17                	jbe    801698 <__umoddi3+0x38>
  801681:	89 f0                	mov    %esi,%eax
  801683:	f7 f7                	div    %edi
  801685:	89 d0                	mov    %edx,%eax
  801687:	31 d2                	xor    %edx,%edx
  801689:	83 c4 1c             	add    $0x1c,%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
  801691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801698:	89 fd                	mov    %edi,%ebp
  80169a:	85 ff                	test   %edi,%edi
  80169c:	75 0b                	jne    8016a9 <__umoddi3+0x49>
  80169e:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a3:	31 d2                	xor    %edx,%edx
  8016a5:	f7 f7                	div    %edi
  8016a7:	89 c5                	mov    %eax,%ebp
  8016a9:	89 d8                	mov    %ebx,%eax
  8016ab:	31 d2                	xor    %edx,%edx
  8016ad:	f7 f5                	div    %ebp
  8016af:	89 f0                	mov    %esi,%eax
  8016b1:	f7 f5                	div    %ebp
  8016b3:	89 d0                	mov    %edx,%eax
  8016b5:	eb d0                	jmp    801687 <__umoddi3+0x27>
  8016b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016be:	66 90                	xchg   %ax,%ax
  8016c0:	89 f1                	mov    %esi,%ecx
  8016c2:	39 d8                	cmp    %ebx,%eax
  8016c4:	76 0a                	jbe    8016d0 <__umoddi3+0x70>
  8016c6:	89 f0                	mov    %esi,%eax
  8016c8:	83 c4 1c             	add    $0x1c,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
  8016d0:	0f bd e8             	bsr    %eax,%ebp
  8016d3:	83 f5 1f             	xor    $0x1f,%ebp
  8016d6:	75 20                	jne    8016f8 <__umoddi3+0x98>
  8016d8:	39 d8                	cmp    %ebx,%eax
  8016da:	0f 82 b0 00 00 00    	jb     801790 <__umoddi3+0x130>
  8016e0:	39 f7                	cmp    %esi,%edi
  8016e2:	0f 86 a8 00 00 00    	jbe    801790 <__umoddi3+0x130>
  8016e8:	89 c8                	mov    %ecx,%eax
  8016ea:	83 c4 1c             	add    $0x1c,%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5f                   	pop    %edi
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    
  8016f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016f8:	89 e9                	mov    %ebp,%ecx
  8016fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8016ff:	29 ea                	sub    %ebp,%edx
  801701:	d3 e0                	shl    %cl,%eax
  801703:	89 44 24 08          	mov    %eax,0x8(%esp)
  801707:	89 d1                	mov    %edx,%ecx
  801709:	89 f8                	mov    %edi,%eax
  80170b:	d3 e8                	shr    %cl,%eax
  80170d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801711:	89 54 24 04          	mov    %edx,0x4(%esp)
  801715:	8b 54 24 04          	mov    0x4(%esp),%edx
  801719:	09 c1                	or     %eax,%ecx
  80171b:	89 d8                	mov    %ebx,%eax
  80171d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801721:	89 e9                	mov    %ebp,%ecx
  801723:	d3 e7                	shl    %cl,%edi
  801725:	89 d1                	mov    %edx,%ecx
  801727:	d3 e8                	shr    %cl,%eax
  801729:	89 e9                	mov    %ebp,%ecx
  80172b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80172f:	d3 e3                	shl    %cl,%ebx
  801731:	89 c7                	mov    %eax,%edi
  801733:	89 d1                	mov    %edx,%ecx
  801735:	89 f0                	mov    %esi,%eax
  801737:	d3 e8                	shr    %cl,%eax
  801739:	89 e9                	mov    %ebp,%ecx
  80173b:	89 fa                	mov    %edi,%edx
  80173d:	d3 e6                	shl    %cl,%esi
  80173f:	09 d8                	or     %ebx,%eax
  801741:	f7 74 24 08          	divl   0x8(%esp)
  801745:	89 d1                	mov    %edx,%ecx
  801747:	89 f3                	mov    %esi,%ebx
  801749:	f7 64 24 0c          	mull   0xc(%esp)
  80174d:	89 c6                	mov    %eax,%esi
  80174f:	89 d7                	mov    %edx,%edi
  801751:	39 d1                	cmp    %edx,%ecx
  801753:	72 06                	jb     80175b <__umoddi3+0xfb>
  801755:	75 10                	jne    801767 <__umoddi3+0x107>
  801757:	39 c3                	cmp    %eax,%ebx
  801759:	73 0c                	jae    801767 <__umoddi3+0x107>
  80175b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80175f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801763:	89 d7                	mov    %edx,%edi
  801765:	89 c6                	mov    %eax,%esi
  801767:	89 ca                	mov    %ecx,%edx
  801769:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80176e:	29 f3                	sub    %esi,%ebx
  801770:	19 fa                	sbb    %edi,%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	d3 e0                	shl    %cl,%eax
  801776:	89 e9                	mov    %ebp,%ecx
  801778:	d3 eb                	shr    %cl,%ebx
  80177a:	d3 ea                	shr    %cl,%edx
  80177c:	09 d8                	or     %ebx,%eax
  80177e:	83 c4 1c             	add    $0x1c,%esp
  801781:	5b                   	pop    %ebx
  801782:	5e                   	pop    %esi
  801783:	5f                   	pop    %edi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    
  801786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80178d:	8d 76 00             	lea    0x0(%esi),%esi
  801790:	89 da                	mov    %ebx,%edx
  801792:	29 fe                	sub    %edi,%esi
  801794:	19 c2                	sbb    %eax,%edx
  801796:	89 f1                	mov    %esi,%ecx
  801798:	89 c8                	mov    %ecx,%eax
  80179a:	e9 4b ff ff ff       	jmp    8016ea <__umoddi3+0x8a>
