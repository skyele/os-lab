
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 5f 12 00 00       	call   8012a0 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 da 14 00 00       	call   801532 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 c2 0c 00 00       	call   800d24 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 36 2b 80 00       	push   $0x802b36
  80006a:	e8 a2 01 00 00       	call   800211 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 14 15 00 00       	call   80159b <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 86 0c 00 00       	call   800d24 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 20 2b 80 00       	push   $0x802b20
  8000a8:	e8 64 01 00 00       	call   800211 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 e0 14 00 00       	call   80159b <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000c9:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000d0:	00 00 00 
	envid_t find = sys_getenvid();
  8000d3:	e8 4c 0c 00 00       	call   800d24 <sys_getenvid>
  8000d8:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8000de:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000e3:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ed:	eb 0b                	jmp    8000fa <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ef:	83 c2 01             	add    $0x1,%edx
  8000f2:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000f8:	74 21                	je     80011b <libmain+0x5b>
		if(envs[i].env_id == find)
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	c1 e1 07             	shl    $0x7,%ecx
  8000ff:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800105:	8b 49 48             	mov    0x48(%ecx),%ecx
  800108:	39 c1                	cmp    %eax,%ecx
  80010a:	75 e3                	jne    8000ef <libmain+0x2f>
  80010c:	89 d3                	mov    %edx,%ebx
  80010e:	c1 e3 07             	shl    $0x7,%ebx
  800111:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800117:	89 fe                	mov    %edi,%esi
  800119:	eb d4                	jmp    8000ef <libmain+0x2f>
  80011b:	89 f0                	mov    %esi,%eax
  80011d:	84 c0                	test   %al,%al
  80011f:	74 06                	je     800127 <libmain+0x67>
  800121:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012b:	7e 0a                	jle    800137 <libmain+0x77>
		binaryname = argv[0];
  80012d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800130:	8b 00                	mov    (%eax),%eax
  800132:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 49 2b 80 00       	push   $0x802b49
  80013f:	e8 cd 00 00 00       	call   800211 <cprintf>
	// call user main routine
	umain(argc, argv);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	ff 75 0c             	pushl  0xc(%ebp)
  80014a:	ff 75 08             	pushl  0x8(%ebp)
  80014d:	e8 e1 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800152:	e8 0b 00 00 00       	call   800162 <exit>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800168:	e8 99 16 00 00       	call   801806 <close_all>
	sys_env_destroy(0);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	6a 00                	push   $0x0
  800172:	e8 6c 0b 00 00       	call   800ce3 <sys_env_destroy>
}
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	53                   	push   %ebx
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800186:	8b 13                	mov    (%ebx),%edx
  800188:	8d 42 01             	lea    0x1(%edx),%eax
  80018b:	89 03                	mov    %eax,(%ebx)
  80018d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800190:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800194:	3d ff 00 00 00       	cmp    $0xff,%eax
  800199:	74 09                	je     8001a4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80019b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a2:	c9                   	leave  
  8001a3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	68 ff 00 00 00       	push   $0xff
  8001ac:	8d 43 08             	lea    0x8(%ebx),%eax
  8001af:	50                   	push   %eax
  8001b0:	e8 f1 0a 00 00       	call   800ca6 <sys_cputs>
		b->idx = 0;
  8001b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001bb:	83 c4 10             	add    $0x10,%esp
  8001be:	eb db                	jmp    80019b <putch+0x1f>

008001c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d0:	00 00 00 
	b.cnt = 0;
  8001d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	68 7c 01 80 00       	push   $0x80017c
  8001ef:	e8 4a 01 00 00       	call   80033e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f4:	83 c4 08             	add    $0x8,%esp
  8001f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	e8 9d 0a 00 00       	call   800ca6 <sys_cputs>

	return b.cnt;
}
  800209:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800217:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021a:	50                   	push   %eax
  80021b:	ff 75 08             	pushl  0x8(%ebp)
  80021e:	e8 9d ff ff ff       	call   8001c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 1c             	sub    $0x1c,%esp
  80022e:	89 c6                	mov    %eax,%esi
  800230:	89 d7                	mov    %edx,%edi
  800232:	8b 45 08             	mov    0x8(%ebp),%eax
  800235:	8b 55 0c             	mov    0xc(%ebp),%edx
  800238:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80023b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80023e:	8b 45 10             	mov    0x10(%ebp),%eax
  800241:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800244:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800248:	74 2c                	je     800276 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800254:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800257:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80025a:	39 c2                	cmp    %eax,%edx
  80025c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80025f:	73 43                	jae    8002a4 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800261:	83 eb 01             	sub    $0x1,%ebx
  800264:	85 db                	test   %ebx,%ebx
  800266:	7e 6c                	jle    8002d4 <printnum+0xaf>
				putch(padc, putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	57                   	push   %edi
  80026c:	ff 75 18             	pushl  0x18(%ebp)
  80026f:	ff d6                	call   *%esi
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	eb eb                	jmp    800261 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	6a 20                	push   $0x20
  80027b:	6a 00                	push   $0x0
  80027d:	50                   	push   %eax
  80027e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800281:	ff 75 e0             	pushl  -0x20(%ebp)
  800284:	89 fa                	mov    %edi,%edx
  800286:	89 f0                	mov    %esi,%eax
  800288:	e8 98 ff ff ff       	call   800225 <printnum>
		while (--width > 0)
  80028d:	83 c4 20             	add    $0x20,%esp
  800290:	83 eb 01             	sub    $0x1,%ebx
  800293:	85 db                	test   %ebx,%ebx
  800295:	7e 65                	jle    8002fc <printnum+0xd7>
			putch(padc, putdat);
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	57                   	push   %edi
  80029b:	6a 20                	push   $0x20
  80029d:	ff d6                	call   *%esi
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb ec                	jmp    800290 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	ff 75 18             	pushl  0x18(%ebp)
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	53                   	push   %ebx
  8002ae:	50                   	push   %eax
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002be:	e8 fd 25 00 00       	call   8028c0 <__udivdi3>
  8002c3:	83 c4 18             	add    $0x18,%esp
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	89 fa                	mov    %edi,%edx
  8002ca:	89 f0                	mov    %esi,%eax
  8002cc:	e8 54 ff ff ff       	call   800225 <printnum>
  8002d1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	57                   	push   %edi
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	ff 75 dc             	pushl  -0x24(%ebp)
  8002de:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e7:	e8 e4 26 00 00       	call   8029d0 <__umoddi3>
  8002ec:	83 c4 14             	add    $0x14,%esp
  8002ef:	0f be 80 60 2b 80 00 	movsbl 0x802b60(%eax),%eax
  8002f6:	50                   	push   %eax
  8002f7:	ff d6                	call   *%esi
  8002f9:	83 c4 10             	add    $0x10,%esp
	}
}
  8002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	3b 50 04             	cmp    0x4(%eax),%edx
  800313:	73 0a                	jae    80031f <sprintputch+0x1b>
		*b->buf++ = ch;
  800315:	8d 4a 01             	lea    0x1(%edx),%ecx
  800318:	89 08                	mov    %ecx,(%eax)
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	88 02                	mov    %al,(%edx)
}
  80031f:	5d                   	pop    %ebp
  800320:	c3                   	ret    

00800321 <printfmt>:
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800327:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	e8 05 00 00 00       	call   80033e <vprintfmt>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <vprintfmt>:
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
  800344:	83 ec 3c             	sub    $0x3c,%esp
  800347:	8b 75 08             	mov    0x8(%ebp),%esi
  80034a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800350:	e9 32 04 00 00       	jmp    800787 <vprintfmt+0x449>
		padc = ' ';
  800355:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800359:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800360:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800367:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80036e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800375:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80037c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8d 47 01             	lea    0x1(%edi),%eax
  800384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800387:	0f b6 17             	movzbl (%edi),%edx
  80038a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80038d:	3c 55                	cmp    $0x55,%al
  80038f:	0f 87 12 05 00 00    	ja     8008a7 <vprintfmt+0x569>
  800395:	0f b6 c0             	movzbl %al,%eax
  800398:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a2:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003a6:	eb d9                	jmp    800381 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ab:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003af:	eb d0                	jmp    800381 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	0f b6 d2             	movzbl %dl,%edx
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003bc:	89 75 08             	mov    %esi,0x8(%ebp)
  8003bf:	eb 03                	jmp    8003c4 <vprintfmt+0x86>
  8003c1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ce:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003d1:	83 fe 09             	cmp    $0x9,%esi
  8003d4:	76 eb                	jbe    8003c1 <vprintfmt+0x83>
  8003d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8003dc:	eb 14                	jmp    8003f2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ec:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f6:	79 89                	jns    800381 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800405:	e9 77 ff ff ff       	jmp    800381 <vprintfmt+0x43>
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	85 c0                	test   %eax,%eax
  80040f:	0f 48 c1             	cmovs  %ecx,%eax
  800412:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800418:	e9 64 ff ff ff       	jmp    800381 <vprintfmt+0x43>
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800420:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800427:	e9 55 ff ff ff       	jmp    800381 <vprintfmt+0x43>
			lflag++;
  80042c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800430:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800433:	e9 49 ff ff ff       	jmp    800381 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 78 04             	lea    0x4(%eax),%edi
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	53                   	push   %ebx
  800442:	ff 30                	pushl  (%eax)
  800444:	ff d6                	call   *%esi
			break;
  800446:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800449:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80044c:	e9 33 03 00 00       	jmp    800784 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 78 04             	lea    0x4(%eax),%edi
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	31 d0                	xor    %edx,%eax
  80045c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045e:	83 f8 10             	cmp    $0x10,%eax
  800461:	7f 23                	jg     800486 <vprintfmt+0x148>
  800463:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  80046a:	85 d2                	test   %edx,%edx
  80046c:	74 18                	je     800486 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80046e:	52                   	push   %edx
  80046f:	68 d1 30 80 00       	push   $0x8030d1
  800474:	53                   	push   %ebx
  800475:	56                   	push   %esi
  800476:	e8 a6 fe ff ff       	call   800321 <printfmt>
  80047b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800481:	e9 fe 02 00 00       	jmp    800784 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800486:	50                   	push   %eax
  800487:	68 78 2b 80 00       	push   $0x802b78
  80048c:	53                   	push   %ebx
  80048d:	56                   	push   %esi
  80048e:	e8 8e fe ff ff       	call   800321 <printfmt>
  800493:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800496:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800499:	e9 e6 02 00 00       	jmp    800784 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	83 c0 04             	add    $0x4,%eax
  8004a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ac:	85 c9                	test   %ecx,%ecx
  8004ae:	b8 71 2b 80 00       	mov    $0x802b71,%eax
  8004b3:	0f 45 c1             	cmovne %ecx,%eax
  8004b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bd:	7e 06                	jle    8004c5 <vprintfmt+0x187>
  8004bf:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004c3:	75 0d                	jne    8004d2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c8:	89 c7                	mov    %eax,%edi
  8004ca:	03 45 e0             	add    -0x20(%ebp),%eax
  8004cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d0:	eb 53                	jmp    800525 <vprintfmt+0x1e7>
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	e8 71 04 00 00       	call   80094f <strnlen>
  8004de:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e1:	29 c1                	sub    %eax,%ecx
  8004e3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004eb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	eb 0f                	jmp    800503 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fd:	83 ef 01             	sub    $0x1,%edi
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	85 ff                	test   %edi,%edi
  800505:	7f ed                	jg     8004f4 <vprintfmt+0x1b6>
  800507:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80050a:	85 c9                	test   %ecx,%ecx
  80050c:	b8 00 00 00 00       	mov    $0x0,%eax
  800511:	0f 49 c1             	cmovns %ecx,%eax
  800514:	29 c1                	sub    %eax,%ecx
  800516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800519:	eb aa                	jmp    8004c5 <vprintfmt+0x187>
					putch(ch, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	52                   	push   %edx
  800520:	ff d6                	call   *%esi
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800528:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052a:	83 c7 01             	add    $0x1,%edi
  80052d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800531:	0f be d0             	movsbl %al,%edx
  800534:	85 d2                	test   %edx,%edx
  800536:	74 4b                	je     800583 <vprintfmt+0x245>
  800538:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053c:	78 06                	js     800544 <vprintfmt+0x206>
  80053e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800542:	78 1e                	js     800562 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800544:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800548:	74 d1                	je     80051b <vprintfmt+0x1dd>
  80054a:	0f be c0             	movsbl %al,%eax
  80054d:	83 e8 20             	sub    $0x20,%eax
  800550:	83 f8 5e             	cmp    $0x5e,%eax
  800553:	76 c6                	jbe    80051b <vprintfmt+0x1dd>
					putch('?', putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	53                   	push   %ebx
  800559:	6a 3f                	push   $0x3f
  80055b:	ff d6                	call   *%esi
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb c3                	jmp    800525 <vprintfmt+0x1e7>
  800562:	89 cf                	mov    %ecx,%edi
  800564:	eb 0e                	jmp    800574 <vprintfmt+0x236>
				putch(' ', putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	53                   	push   %ebx
  80056a:	6a 20                	push   $0x20
  80056c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80056e:	83 ef 01             	sub    $0x1,%edi
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	85 ff                	test   %edi,%edi
  800576:	7f ee                	jg     800566 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	e9 01 02 00 00       	jmp    800784 <vprintfmt+0x446>
  800583:	89 cf                	mov    %ecx,%edi
  800585:	eb ed                	jmp    800574 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80058a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800591:	e9 eb fd ff ff       	jmp    800381 <vprintfmt+0x43>
	if (lflag >= 2)
  800596:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80059a:	7f 21                	jg     8005bd <vprintfmt+0x27f>
	else if (lflag)
  80059c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005a0:	74 68                	je     80060a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005aa:	89 c1                	mov    %eax,%ecx
  8005ac:	c1 f9 1f             	sar    $0x1f,%ecx
  8005af:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb 17                	jmp    8005d4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 50 04             	mov    0x4(%eax),%edx
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 40 08             	lea    0x8(%eax),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005e4:	78 3f                	js     800625 <vprintfmt+0x2e7>
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ef:	0f 84 71 01 00 00    	je     800766 <vprintfmt+0x428>
				putch('+', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	6a 2b                	push   $0x2b
  8005fb:	ff d6                	call   *%esi
  8005fd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	e9 5c 01 00 00       	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800612:	89 c1                	mov    %eax,%ecx
  800614:	c1 f9 1f             	sar    $0x1f,%ecx
  800617:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 04             	lea    0x4(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	eb af                	jmp    8005d4 <vprintfmt+0x296>
				putch('-', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 2d                	push   $0x2d
  80062b:	ff d6                	call   *%esi
				num = -(long long) num;
  80062d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800630:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800633:	f7 d8                	neg    %eax
  800635:	83 d2 00             	adc    $0x0,%edx
  800638:	f7 da                	neg    %edx
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800640:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
  800648:	e9 19 01 00 00       	jmp    800766 <vprintfmt+0x428>
	if (lflag >= 2)
  80064d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800651:	7f 29                	jg     80067c <vprintfmt+0x33e>
	else if (lflag)
  800653:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800657:	74 44                	je     80069d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	ba 00 00 00 00       	mov    $0x0,%edx
  800663:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800666:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 40 04             	lea    0x4(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800672:	b8 0a 00 00 00       	mov    $0xa,%eax
  800677:	e9 ea 00 00 00       	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 50 04             	mov    0x4(%eax),%edx
  800682:	8b 00                	mov    (%eax),%eax
  800684:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800687:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 40 08             	lea    0x8(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 c9 00 00 00       	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bb:	e9 a6 00 00 00       	jmp    800766 <vprintfmt+0x428>
			putch('0', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	6a 30                	push   $0x30
  8006c6:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006cf:	7f 26                	jg     8006f7 <vprintfmt+0x3b9>
	else if (lflag)
  8006d1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d5:	74 3e                	je     800715 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f5:	eb 6f                	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 50 04             	mov    0x4(%eax),%edx
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800702:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 40 08             	lea    0x8(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070e:	b8 08 00 00 00       	mov    $0x8,%eax
  800713:	eb 51                	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
  80071f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800722:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072e:	b8 08 00 00 00       	mov    $0x8,%eax
  800733:	eb 31                	jmp    800766 <vprintfmt+0x428>
			putch('0', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 30                	push   $0x30
  80073b:	ff d6                	call   *%esi
			putch('x', putdat);
  80073d:	83 c4 08             	add    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 78                	push   $0x78
  800743:	ff d6                	call   *%esi
			num = (unsigned long long)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800752:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800755:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800761:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80076d:	52                   	push   %edx
  80076e:	ff 75 e0             	pushl  -0x20(%ebp)
  800771:	50                   	push   %eax
  800772:	ff 75 dc             	pushl  -0x24(%ebp)
  800775:	ff 75 d8             	pushl  -0x28(%ebp)
  800778:	89 da                	mov    %ebx,%edx
  80077a:	89 f0                	mov    %esi,%eax
  80077c:	e8 a4 fa ff ff       	call   800225 <printnum>
			break;
  800781:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800784:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800787:	83 c7 01             	add    $0x1,%edi
  80078a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078e:	83 f8 25             	cmp    $0x25,%eax
  800791:	0f 84 be fb ff ff    	je     800355 <vprintfmt+0x17>
			if (ch == '\0')
  800797:	85 c0                	test   %eax,%eax
  800799:	0f 84 28 01 00 00    	je     8008c7 <vprintfmt+0x589>
			putch(ch, putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	50                   	push   %eax
  8007a4:	ff d6                	call   *%esi
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	eb dc                	jmp    800787 <vprintfmt+0x449>
	if (lflag >= 2)
  8007ab:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007af:	7f 26                	jg     8007d7 <vprintfmt+0x499>
	else if (lflag)
  8007b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b5:	74 41                	je     8007f8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d5:	eb 8f                	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 08             	lea    0x8(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f3:	e9 6e ff ff ff       	jmp    800766 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 04             	lea    0x4(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800811:	b8 10 00 00 00       	mov    $0x10,%eax
  800816:	e9 4b ff ff ff       	jmp    800766 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	85 c0                	test   %eax,%eax
  80082b:	74 14                	je     800841 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80082d:	8b 13                	mov    (%ebx),%edx
  80082f:	83 fa 7f             	cmp    $0x7f,%edx
  800832:	7f 37                	jg     80086b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800834:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800836:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800839:	89 45 14             	mov    %eax,0x14(%ebp)
  80083c:	e9 43 ff ff ff       	jmp    800784 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800841:	b8 0a 00 00 00       	mov    $0xa,%eax
  800846:	bf 95 2c 80 00       	mov    $0x802c95,%edi
							putch(ch, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	53                   	push   %ebx
  80084f:	50                   	push   %eax
  800850:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800852:	83 c7 01             	add    $0x1,%edi
  800855:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	85 c0                	test   %eax,%eax
  80085e:	75 eb                	jne    80084b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800860:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
  800866:	e9 19 ff ff ff       	jmp    800784 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80086b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80086d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800872:	bf cd 2c 80 00       	mov    $0x802ccd,%edi
							putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	50                   	push   %eax
  80087c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80087e:	83 c7 01             	add    $0x1,%edi
  800881:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	85 c0                	test   %eax,%eax
  80088a:	75 eb                	jne    800877 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80088c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	e9 ed fe ff ff       	jmp    800784 <vprintfmt+0x446>
			putch(ch, putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	6a 25                	push   $0x25
  80089d:	ff d6                	call   *%esi
			break;
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	e9 dd fe ff ff       	jmp    800784 <vprintfmt+0x446>
			putch('%', putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 25                	push   $0x25
  8008ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 f8                	mov    %edi,%eax
  8008b4:	eb 03                	jmp    8008b9 <vprintfmt+0x57b>
  8008b6:	83 e8 01             	sub    $0x1,%eax
  8008b9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008bd:	75 f7                	jne    8008b6 <vprintfmt+0x578>
  8008bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c2:	e9 bd fe ff ff       	jmp    800784 <vprintfmt+0x446>
}
  8008c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ca:	5b                   	pop    %ebx
  8008cb:	5e                   	pop    %esi
  8008cc:	5f                   	pop    %edi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 18             	sub    $0x18,%esp
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008de:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	74 26                	je     800916 <vsnprintf+0x47>
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	7e 22                	jle    800916 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f4:	ff 75 14             	pushl  0x14(%ebp)
  8008f7:	ff 75 10             	pushl  0x10(%ebp)
  8008fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	68 04 03 80 00       	push   $0x800304
  800903:	e8 36 fa ff ff       	call   80033e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800911:	83 c4 10             	add    $0x10,%esp
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    
		return -E_INVAL;
  800916:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091b:	eb f7                	jmp    800914 <vsnprintf+0x45>

0080091d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800926:	50                   	push   %eax
  800927:	ff 75 10             	pushl  0x10(%ebp)
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	ff 75 08             	pushl  0x8(%ebp)
  800930:	e8 9a ff ff ff       	call   8008cf <vsnprintf>
	va_end(ap);

	return rc;
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800946:	74 05                	je     80094d <strlen+0x16>
		n++;
  800948:	83 c0 01             	add    $0x1,%eax
  80094b:	eb f5                	jmp    800942 <strlen+0xb>
	return n;
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800958:	ba 00 00 00 00       	mov    $0x0,%edx
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	74 0d                	je     80096e <strnlen+0x1f>
  800961:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800965:	74 05                	je     80096c <strnlen+0x1d>
		n++;
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	eb f1                	jmp    80095d <strnlen+0xe>
  80096c:	89 d0                	mov    %edx,%eax
	return n;
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	53                   	push   %ebx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80097a:	ba 00 00 00 00       	mov    $0x0,%edx
  80097f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800983:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 f2                	jne    80097f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80098d:	5b                   	pop    %ebx
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	83 ec 10             	sub    $0x10,%esp
  800997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80099a:	53                   	push   %ebx
  80099b:	e8 97 ff ff ff       	call   800937 <strlen>
  8009a0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	01 d8                	add    %ebx,%eax
  8009a8:	50                   	push   %eax
  8009a9:	e8 c2 ff ff ff       	call   800970 <strcpy>
	return dst;
}
  8009ae:	89 d8                	mov    %ebx,%eax
  8009b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c0:	89 c6                	mov    %eax,%esi
  8009c2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c5:	89 c2                	mov    %eax,%edx
  8009c7:	39 f2                	cmp    %esi,%edx
  8009c9:	74 11                	je     8009dc <strncpy+0x27>
		*dst++ = *src;
  8009cb:	83 c2 01             	add    $0x1,%edx
  8009ce:	0f b6 19             	movzbl (%ecx),%ebx
  8009d1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d4:	80 fb 01             	cmp    $0x1,%bl
  8009d7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009da:	eb eb                	jmp    8009c7 <strncpy+0x12>
	}
	return ret;
}
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	56                   	push   %esi
  8009e4:	53                   	push   %ebx
  8009e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009eb:	8b 55 10             	mov    0x10(%ebp),%edx
  8009ee:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f0:	85 d2                	test   %edx,%edx
  8009f2:	74 21                	je     800a15 <strlcpy+0x35>
  8009f4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009fa:	39 c2                	cmp    %eax,%edx
  8009fc:	74 14                	je     800a12 <strlcpy+0x32>
  8009fe:	0f b6 19             	movzbl (%ecx),%ebx
  800a01:	84 db                	test   %bl,%bl
  800a03:	74 0b                	je     800a10 <strlcpy+0x30>
			*dst++ = *src++;
  800a05:	83 c1 01             	add    $0x1,%ecx
  800a08:	83 c2 01             	add    $0x1,%edx
  800a0b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a0e:	eb ea                	jmp    8009fa <strlcpy+0x1a>
  800a10:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a12:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a15:	29 f0                	sub    %esi,%eax
}
  800a17:	5b                   	pop    %ebx
  800a18:	5e                   	pop    %esi
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a24:	0f b6 01             	movzbl (%ecx),%eax
  800a27:	84 c0                	test   %al,%al
  800a29:	74 0c                	je     800a37 <strcmp+0x1c>
  800a2b:	3a 02                	cmp    (%edx),%al
  800a2d:	75 08                	jne    800a37 <strcmp+0x1c>
		p++, q++;
  800a2f:	83 c1 01             	add    $0x1,%ecx
  800a32:	83 c2 01             	add    $0x1,%edx
  800a35:	eb ed                	jmp    800a24 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a37:	0f b6 c0             	movzbl %al,%eax
  800a3a:	0f b6 12             	movzbl (%edx),%edx
  800a3d:	29 d0                	sub    %edx,%eax
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	53                   	push   %ebx
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4b:	89 c3                	mov    %eax,%ebx
  800a4d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a50:	eb 06                	jmp    800a58 <strncmp+0x17>
		n--, p++, q++;
  800a52:	83 c0 01             	add    $0x1,%eax
  800a55:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a58:	39 d8                	cmp    %ebx,%eax
  800a5a:	74 16                	je     800a72 <strncmp+0x31>
  800a5c:	0f b6 08             	movzbl (%eax),%ecx
  800a5f:	84 c9                	test   %cl,%cl
  800a61:	74 04                	je     800a67 <strncmp+0x26>
  800a63:	3a 0a                	cmp    (%edx),%cl
  800a65:	74 eb                	je     800a52 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a67:	0f b6 00             	movzbl (%eax),%eax
  800a6a:	0f b6 12             	movzbl (%edx),%edx
  800a6d:	29 d0                	sub    %edx,%eax
}
  800a6f:	5b                   	pop    %ebx
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    
		return 0;
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	eb f6                	jmp    800a6f <strncmp+0x2e>

00800a79 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a83:	0f b6 10             	movzbl (%eax),%edx
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 09                	je     800a93 <strchr+0x1a>
		if (*s == c)
  800a8a:	38 ca                	cmp    %cl,%dl
  800a8c:	74 0a                	je     800a98 <strchr+0x1f>
	for (; *s; s++)
  800a8e:	83 c0 01             	add    $0x1,%eax
  800a91:	eb f0                	jmp    800a83 <strchr+0xa>
			return (char *) s;
	return 0;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa7:	38 ca                	cmp    %cl,%dl
  800aa9:	74 09                	je     800ab4 <strfind+0x1a>
  800aab:	84 d2                	test   %dl,%dl
  800aad:	74 05                	je     800ab4 <strfind+0x1a>
	for (; *s; s++)
  800aaf:	83 c0 01             	add    $0x1,%eax
  800ab2:	eb f0                	jmp    800aa4 <strfind+0xa>
			break;
	return (char *) s;
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac2:	85 c9                	test   %ecx,%ecx
  800ac4:	74 31                	je     800af7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac6:	89 f8                	mov    %edi,%eax
  800ac8:	09 c8                	or     %ecx,%eax
  800aca:	a8 03                	test   $0x3,%al
  800acc:	75 23                	jne    800af1 <memset+0x3b>
		c &= 0xFF;
  800ace:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad2:	89 d3                	mov    %edx,%ebx
  800ad4:	c1 e3 08             	shl    $0x8,%ebx
  800ad7:	89 d0                	mov    %edx,%eax
  800ad9:	c1 e0 18             	shl    $0x18,%eax
  800adc:	89 d6                	mov    %edx,%esi
  800ade:	c1 e6 10             	shl    $0x10,%esi
  800ae1:	09 f0                	or     %esi,%eax
  800ae3:	09 c2                	or     %eax,%edx
  800ae5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ae7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aea:	89 d0                	mov    %edx,%eax
  800aec:	fc                   	cld    
  800aed:	f3 ab                	rep stos %eax,%es:(%edi)
  800aef:	eb 06                	jmp    800af7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	fc                   	cld    
  800af5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af7:	89 f8                	mov    %edi,%eax
  800af9:	5b                   	pop    %ebx
  800afa:	5e                   	pop    %esi
  800afb:	5f                   	pop    %edi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	57                   	push   %edi
  800b02:	56                   	push   %esi
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b0c:	39 c6                	cmp    %eax,%esi
  800b0e:	73 32                	jae    800b42 <memmove+0x44>
  800b10:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b13:	39 c2                	cmp    %eax,%edx
  800b15:	76 2b                	jbe    800b42 <memmove+0x44>
		s += n;
		d += n;
  800b17:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1a:	89 fe                	mov    %edi,%esi
  800b1c:	09 ce                	or     %ecx,%esi
  800b1e:	09 d6                	or     %edx,%esi
  800b20:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b26:	75 0e                	jne    800b36 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b28:	83 ef 04             	sub    $0x4,%edi
  800b2b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b31:	fd                   	std    
  800b32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b34:	eb 09                	jmp    800b3f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b36:	83 ef 01             	sub    $0x1,%edi
  800b39:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b3c:	fd                   	std    
  800b3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b3f:	fc                   	cld    
  800b40:	eb 1a                	jmp    800b5c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	09 ca                	or     %ecx,%edx
  800b46:	09 f2                	or     %esi,%edx
  800b48:	f6 c2 03             	test   $0x3,%dl
  800b4b:	75 0a                	jne    800b57 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b4d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b50:	89 c7                	mov    %eax,%edi
  800b52:	fc                   	cld    
  800b53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b55:	eb 05                	jmp    800b5c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b5c:	5e                   	pop    %esi
  800b5d:	5f                   	pop    %edi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b66:	ff 75 10             	pushl  0x10(%ebp)
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	ff 75 08             	pushl  0x8(%ebp)
  800b6f:	e8 8a ff ff ff       	call   800afe <memmove>
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b81:	89 c6                	mov    %eax,%esi
  800b83:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b86:	39 f0                	cmp    %esi,%eax
  800b88:	74 1c                	je     800ba6 <memcmp+0x30>
		if (*s1 != *s2)
  800b8a:	0f b6 08             	movzbl (%eax),%ecx
  800b8d:	0f b6 1a             	movzbl (%edx),%ebx
  800b90:	38 d9                	cmp    %bl,%cl
  800b92:	75 08                	jne    800b9c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b94:	83 c0 01             	add    $0x1,%eax
  800b97:	83 c2 01             	add    $0x1,%edx
  800b9a:	eb ea                	jmp    800b86 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b9c:	0f b6 c1             	movzbl %cl,%eax
  800b9f:	0f b6 db             	movzbl %bl,%ebx
  800ba2:	29 d8                	sub    %ebx,%eax
  800ba4:	eb 05                	jmp    800bab <memcmp+0x35>
	}

	return 0;
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb8:	89 c2                	mov    %eax,%edx
  800bba:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbd:	39 d0                	cmp    %edx,%eax
  800bbf:	73 09                	jae    800bca <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc1:	38 08                	cmp    %cl,(%eax)
  800bc3:	74 05                	je     800bca <memfind+0x1b>
	for (; s < ends; s++)
  800bc5:	83 c0 01             	add    $0x1,%eax
  800bc8:	eb f3                	jmp    800bbd <memfind+0xe>
			break;
	return (void *) s;
}
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd8:	eb 03                	jmp    800bdd <strtol+0x11>
		s++;
  800bda:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bdd:	0f b6 01             	movzbl (%ecx),%eax
  800be0:	3c 20                	cmp    $0x20,%al
  800be2:	74 f6                	je     800bda <strtol+0xe>
  800be4:	3c 09                	cmp    $0x9,%al
  800be6:	74 f2                	je     800bda <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800be8:	3c 2b                	cmp    $0x2b,%al
  800bea:	74 2a                	je     800c16 <strtol+0x4a>
	int neg = 0;
  800bec:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf1:	3c 2d                	cmp    $0x2d,%al
  800bf3:	74 2b                	je     800c20 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfb:	75 0f                	jne    800c0c <strtol+0x40>
  800bfd:	80 39 30             	cmpb   $0x30,(%ecx)
  800c00:	74 28                	je     800c2a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c09:	0f 44 d8             	cmove  %eax,%ebx
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c14:	eb 50                	jmp    800c66 <strtol+0x9a>
		s++;
  800c16:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c19:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1e:	eb d5                	jmp    800bf5 <strtol+0x29>
		s++, neg = 1;
  800c20:	83 c1 01             	add    $0x1,%ecx
  800c23:	bf 01 00 00 00       	mov    $0x1,%edi
  800c28:	eb cb                	jmp    800bf5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c2e:	74 0e                	je     800c3e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c30:	85 db                	test   %ebx,%ebx
  800c32:	75 d8                	jne    800c0c <strtol+0x40>
		s++, base = 8;
  800c34:	83 c1 01             	add    $0x1,%ecx
  800c37:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3c:	eb ce                	jmp    800c0c <strtol+0x40>
		s += 2, base = 16;
  800c3e:	83 c1 02             	add    $0x2,%ecx
  800c41:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c46:	eb c4                	jmp    800c0c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c48:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c4b:	89 f3                	mov    %esi,%ebx
  800c4d:	80 fb 19             	cmp    $0x19,%bl
  800c50:	77 29                	ja     800c7b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c52:	0f be d2             	movsbl %dl,%edx
  800c55:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c58:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c5b:	7d 30                	jge    800c8d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c5d:	83 c1 01             	add    $0x1,%ecx
  800c60:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c64:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c66:	0f b6 11             	movzbl (%ecx),%edx
  800c69:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c6c:	89 f3                	mov    %esi,%ebx
  800c6e:	80 fb 09             	cmp    $0x9,%bl
  800c71:	77 d5                	ja     800c48 <strtol+0x7c>
			dig = *s - '0';
  800c73:	0f be d2             	movsbl %dl,%edx
  800c76:	83 ea 30             	sub    $0x30,%edx
  800c79:	eb dd                	jmp    800c58 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c7b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c7e:	89 f3                	mov    %esi,%ebx
  800c80:	80 fb 19             	cmp    $0x19,%bl
  800c83:	77 08                	ja     800c8d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c85:	0f be d2             	movsbl %dl,%edx
  800c88:	83 ea 37             	sub    $0x37,%edx
  800c8b:	eb cb                	jmp    800c58 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c91:	74 05                	je     800c98 <strtol+0xcc>
		*endptr = (char *) s;
  800c93:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c96:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c98:	89 c2                	mov    %eax,%edx
  800c9a:	f7 da                	neg    %edx
  800c9c:	85 ff                	test   %edi,%edi
  800c9e:	0f 45 c2             	cmovne %edx,%eax
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	89 c3                	mov    %eax,%ebx
  800cb9:	89 c7                	mov    %eax,%edi
  800cbb:	89 c6                	mov    %eax,%esi
  800cbd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf9:	89 cb                	mov    %ecx,%ebx
  800cfb:	89 cf                	mov    %ecx,%edi
  800cfd:	89 ce                	mov    %ecx,%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 03                	push   $0x3
  800d13:	68 e4 2e 80 00       	push   $0x802ee4
  800d18:	6a 43                	push   $0x43
  800d1a:	68 01 2f 80 00       	push   $0x802f01
  800d1f:	e8 60 1a 00 00       	call   802784 <_panic>

00800d24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 02 00 00 00       	mov    $0x2,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_yield>:

void
sys_yield(void)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d49:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d53:	89 d1                	mov    %edx,%ecx
  800d55:	89 d3                	mov    %edx,%ebx
  800d57:	89 d7                	mov    %edx,%edi
  800d59:	89 d6                	mov    %edx,%esi
  800d5b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6b:	be 00 00 00 00       	mov    $0x0,%esi
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	b8 04 00 00 00       	mov    $0x4,%eax
  800d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7e:	89 f7                	mov    %esi,%edi
  800d80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d82:	85 c0                	test   %eax,%eax
  800d84:	7f 08                	jg     800d8e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	50                   	push   %eax
  800d92:	6a 04                	push   $0x4
  800d94:	68 e4 2e 80 00       	push   $0x802ee4
  800d99:	6a 43                	push   $0x43
  800d9b:	68 01 2f 80 00       	push   $0x802f01
  800da0:	e8 df 19 00 00       	call   802784 <_panic>

00800da5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	b8 05 00 00 00       	mov    $0x5,%eax
  800db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbf:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	7f 08                	jg     800dd0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	83 ec 0c             	sub    $0xc,%esp
  800dd3:	50                   	push   %eax
  800dd4:	6a 05                	push   $0x5
  800dd6:	68 e4 2e 80 00       	push   $0x802ee4
  800ddb:	6a 43                	push   $0x43
  800ddd:	68 01 2f 80 00       	push   $0x802f01
  800de2:	e8 9d 19 00 00       	call   802784 <_panic>

00800de7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df5:	8b 55 08             	mov    0x8(%ebp),%edx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	b8 06 00 00 00       	mov    $0x6,%eax
  800e00:	89 df                	mov    %ebx,%edi
  800e02:	89 de                	mov    %ebx,%esi
  800e04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7f 08                	jg     800e12 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	50                   	push   %eax
  800e16:	6a 06                	push   $0x6
  800e18:	68 e4 2e 80 00       	push   $0x802ee4
  800e1d:	6a 43                	push   $0x43
  800e1f:	68 01 2f 80 00       	push   $0x802f01
  800e24:	e8 5b 19 00 00       	call   802784 <_panic>

00800e29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e42:	89 df                	mov    %ebx,%edi
  800e44:	89 de                	mov    %ebx,%esi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 08                	push   $0x8
  800e5a:	68 e4 2e 80 00       	push   $0x802ee4
  800e5f:	6a 43                	push   $0x43
  800e61:	68 01 2f 80 00       	push   $0x802f01
  800e66:	e8 19 19 00 00       	call   802784 <_panic>

00800e6b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 09                	push   $0x9
  800e9c:	68 e4 2e 80 00       	push   $0x802ee4
  800ea1:	6a 43                	push   $0x43
  800ea3:	68 01 2f 80 00       	push   $0x802f01
  800ea8:	e8 d7 18 00 00       	call   802784 <_panic>

00800ead <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 0a                	push   $0xa
  800ede:	68 e4 2e 80 00       	push   $0x802ee4
  800ee3:	6a 43                	push   $0x43
  800ee5:	68 01 2f 80 00       	push   $0x802f01
  800eea:	e8 95 18 00 00       	call   802784 <_panic>

00800eef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f00:	be 00 00 00 00       	mov    $0x0,%esi
  800f05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f0b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f28:	89 cb                	mov    %ecx,%ebx
  800f2a:	89 cf                	mov    %ecx,%edi
  800f2c:	89 ce                	mov    %ecx,%esi
  800f2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7f 08                	jg     800f3c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	50                   	push   %eax
  800f40:	6a 0d                	push   $0xd
  800f42:	68 e4 2e 80 00       	push   $0x802ee4
  800f47:	6a 43                	push   $0x43
  800f49:	68 01 2f 80 00       	push   $0x802f01
  800f4e:	e8 31 18 00 00       	call   802784 <_panic>

00800f53 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f64:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f69:	89 df                	mov    %ebx,%edi
  800f6b:	89 de                	mov    %ebx,%esi
  800f6d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f87:	89 cb                	mov    %ecx,%ebx
  800f89:	89 cf                	mov    %ecx,%edi
  800f8b:	89 ce                	mov    %ecx,%esi
  800f8d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9f:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa4:	89 d1                	mov    %edx,%ecx
  800fa6:	89 d3                	mov    %edx,%ebx
  800fa8:	89 d7                	mov    %edx,%edi
  800faa:	89 d6                	mov    %edx,%esi
  800fac:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc4:	b8 11 00 00 00       	mov    $0x11,%eax
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5f                   	pop    %edi
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe5:	b8 12 00 00 00       	mov    $0x12,%eax
  800fea:	89 df                	mov    %ebx,%edi
  800fec:	89 de                	mov    %ebx,%esi
  800fee:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	57                   	push   %edi
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
  800ffb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	b8 13 00 00 00       	mov    $0x13,%eax
  80100e:	89 df                	mov    %ebx,%edi
  801010:	89 de                	mov    %ebx,%esi
  801012:	cd 30                	int    $0x30
	if(check && ret > 0)
  801014:	85 c0                	test   %eax,%eax
  801016:	7f 08                	jg     801020 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801018:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	50                   	push   %eax
  801024:	6a 13                	push   $0x13
  801026:	68 e4 2e 80 00       	push   $0x802ee4
  80102b:	6a 43                	push   $0x43
  80102d:	68 01 2f 80 00       	push   $0x802f01
  801032:	e8 4d 17 00 00       	call   802784 <_panic>

00801037 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	53                   	push   %ebx
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801041:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801043:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801047:	0f 84 99 00 00 00    	je     8010e6 <pgfault+0xaf>
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	c1 ea 16             	shr    $0x16,%edx
  801052:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801059:	f6 c2 01             	test   $0x1,%dl
  80105c:	0f 84 84 00 00 00    	je     8010e6 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801062:	89 c2                	mov    %eax,%edx
  801064:	c1 ea 0c             	shr    $0xc,%edx
  801067:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106e:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801074:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80107a:	75 6a                	jne    8010e6 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  80107c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801081:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	6a 07                	push   $0x7
  801088:	68 00 f0 7f 00       	push   $0x7ff000
  80108d:	6a 00                	push   $0x0
  80108f:	e8 ce fc ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	78 5f                	js     8010fa <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80109b:	83 ec 04             	sub    $0x4,%esp
  80109e:	68 00 10 00 00       	push   $0x1000
  8010a3:	53                   	push   %ebx
  8010a4:	68 00 f0 7f 00       	push   $0x7ff000
  8010a9:	e8 b2 fa ff ff       	call   800b60 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8010ae:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010b5:	53                   	push   %ebx
  8010b6:	6a 00                	push   $0x0
  8010b8:	68 00 f0 7f 00       	push   $0x7ff000
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 e1 fc ff ff       	call   800da5 <sys_page_map>
	if(ret < 0)
  8010c4:	83 c4 20             	add    $0x20,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 43                	js     80110e <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	68 00 f0 7f 00       	push   $0x7ff000
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 0d fd ff ff       	call   800de7 <sys_page_unmap>
	if(ret < 0)
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	78 41                	js     801122 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  8010e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    
		panic("panic at pgfault()\n");
  8010e6:	83 ec 04             	sub    $0x4,%esp
  8010e9:	68 0f 2f 80 00       	push   $0x802f0f
  8010ee:	6a 26                	push   $0x26
  8010f0:	68 23 2f 80 00       	push   $0x802f23
  8010f5:	e8 8a 16 00 00       	call   802784 <_panic>
		panic("panic in sys_page_alloc()\n");
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	68 2e 2f 80 00       	push   $0x802f2e
  801102:	6a 31                	push   $0x31
  801104:	68 23 2f 80 00       	push   $0x802f23
  801109:	e8 76 16 00 00       	call   802784 <_panic>
		panic("panic in sys_page_map()\n");
  80110e:	83 ec 04             	sub    $0x4,%esp
  801111:	68 49 2f 80 00       	push   $0x802f49
  801116:	6a 36                	push   $0x36
  801118:	68 23 2f 80 00       	push   $0x802f23
  80111d:	e8 62 16 00 00       	call   802784 <_panic>
		panic("panic in sys_page_unmap()\n");
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	68 62 2f 80 00       	push   $0x802f62
  80112a:	6a 39                	push   $0x39
  80112c:	68 23 2f 80 00       	push   $0x802f23
  801131:	e8 4e 16 00 00       	call   802784 <_panic>

00801136 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	89 c6                	mov    %eax,%esi
  80113d:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	68 00 30 80 00       	push   $0x803000
  801147:	68 53 31 80 00       	push   $0x803153
  80114c:	e8 c0 f0 ff ff       	call   800211 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801151:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	f6 c4 04             	test   $0x4,%ah
  80115e:	75 45                	jne    8011a5 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801160:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801167:	83 e0 07             	and    $0x7,%eax
  80116a:	83 f8 07             	cmp    $0x7,%eax
  80116d:	74 6e                	je     8011dd <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80116f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801176:	25 05 08 00 00       	and    $0x805,%eax
  80117b:	3d 05 08 00 00       	cmp    $0x805,%eax
  801180:	0f 84 b5 00 00 00    	je     80123b <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801186:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80118d:	83 e0 05             	and    $0x5,%eax
  801190:	83 f8 05             	cmp    $0x5,%eax
  801193:	0f 84 d6 00 00 00    	je     80126f <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
  80119e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011a5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ac:	c1 e3 0c             	shl    $0xc,%ebx
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b7:	50                   	push   %eax
  8011b8:	53                   	push   %ebx
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	6a 00                	push   $0x0
  8011bd:	e8 e3 fb ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  8011c2:	83 c4 20             	add    $0x20,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	79 d0                	jns    801199 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8011c9:	83 ec 04             	sub    $0x4,%esp
  8011cc:	68 7d 2f 80 00       	push   $0x802f7d
  8011d1:	6a 55                	push   $0x55
  8011d3:	68 23 2f 80 00       	push   $0x802f23
  8011d8:	e8 a7 15 00 00       	call   802784 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011dd:	c1 e3 0c             	shl    $0xc,%ebx
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	68 05 08 00 00       	push   $0x805
  8011e8:	53                   	push   %ebx
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	6a 00                	push   $0x0
  8011ed:	e8 b3 fb ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  8011f2:	83 c4 20             	add    $0x20,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 2e                	js     801227 <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	68 05 08 00 00       	push   $0x805
  801201:	53                   	push   %ebx
  801202:	6a 00                	push   $0x0
  801204:	53                   	push   %ebx
  801205:	6a 00                	push   $0x0
  801207:	e8 99 fb ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  80120c:	83 c4 20             	add    $0x20,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	79 86                	jns    801199 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801213:	83 ec 04             	sub    $0x4,%esp
  801216:	68 7d 2f 80 00       	push   $0x802f7d
  80121b:	6a 60                	push   $0x60
  80121d:	68 23 2f 80 00       	push   $0x802f23
  801222:	e8 5d 15 00 00       	call   802784 <_panic>
			panic("sys_page_map() panic\n");
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	68 7d 2f 80 00       	push   $0x802f7d
  80122f:	6a 5c                	push   $0x5c
  801231:	68 23 2f 80 00       	push   $0x802f23
  801236:	e8 49 15 00 00       	call   802784 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80123b:	c1 e3 0c             	shl    $0xc,%ebx
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	68 05 08 00 00       	push   $0x805
  801246:	53                   	push   %ebx
  801247:	56                   	push   %esi
  801248:	53                   	push   %ebx
  801249:	6a 00                	push   $0x0
  80124b:	e8 55 fb ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	0f 89 3e ff ff ff    	jns    801199 <duppage+0x63>
			panic("sys_page_map() panic\n");
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	68 7d 2f 80 00       	push   $0x802f7d
  801263:	6a 67                	push   $0x67
  801265:	68 23 2f 80 00       	push   $0x802f23
  80126a:	e8 15 15 00 00       	call   802784 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80126f:	c1 e3 0c             	shl    $0xc,%ebx
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	6a 05                	push   $0x5
  801277:	53                   	push   %ebx
  801278:	56                   	push   %esi
  801279:	53                   	push   %ebx
  80127a:	6a 00                	push   $0x0
  80127c:	e8 24 fb ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  801281:	83 c4 20             	add    $0x20,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	0f 89 0d ff ff ff    	jns    801199 <duppage+0x63>
			panic("sys_page_map() panic\n");
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	68 7d 2f 80 00       	push   $0x802f7d
  801294:	6a 6e                	push   $0x6e
  801296:	68 23 2f 80 00       	push   $0x802f23
  80129b:	e8 e4 14 00 00       	call   802784 <_panic>

008012a0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	57                   	push   %edi
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012a9:	68 37 10 80 00       	push   $0x801037
  8012ae:	e8 32 15 00 00       	call   8027e5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8012b8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 27                	js     8012e8 <fork+0x48>
  8012c1:	89 c6                	mov    %eax,%esi
  8012c3:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012c5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012ca:	75 48                	jne    801314 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012cc:	e8 53 fa ff ff       	call   800d24 <sys_getenvid>
  8012d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012d6:	c1 e0 07             	shl    $0x7,%eax
  8012d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012de:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012e3:	e9 90 00 00 00       	jmp    801378 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 94 2f 80 00       	push   $0x802f94
  8012f0:	68 8d 00 00 00       	push   $0x8d
  8012f5:	68 23 2f 80 00       	push   $0x802f23
  8012fa:	e8 85 14 00 00       	call   802784 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012ff:	89 f8                	mov    %edi,%eax
  801301:	e8 30 fe ff ff       	call   801136 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801306:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80130c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801312:	74 26                	je     80133a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801314:	89 d8                	mov    %ebx,%eax
  801316:	c1 e8 16             	shr    $0x16,%eax
  801319:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801320:	a8 01                	test   $0x1,%al
  801322:	74 e2                	je     801306 <fork+0x66>
  801324:	89 da                	mov    %ebx,%edx
  801326:	c1 ea 0c             	shr    $0xc,%edx
  801329:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801330:	83 e0 05             	and    $0x5,%eax
  801333:	83 f8 05             	cmp    $0x5,%eax
  801336:	75 ce                	jne    801306 <fork+0x66>
  801338:	eb c5                	jmp    8012ff <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	6a 07                	push   $0x7
  80133f:	68 00 f0 bf ee       	push   $0xeebff000
  801344:	56                   	push   %esi
  801345:	e8 18 fa ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 31                	js     801382 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	68 54 28 80 00       	push   $0x802854
  801359:	56                   	push   %esi
  80135a:	e8 4e fb ff ff       	call   800ead <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 33                	js     801399 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	6a 02                	push   $0x2
  80136b:	56                   	push   %esi
  80136c:	e8 b8 fa ff ff       	call   800e29 <sys_env_set_status>
	if(ret < 0)
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 38                	js     8013b0 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801378:	89 f0                	mov    %esi,%eax
  80137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5f                   	pop    %edi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	68 2e 2f 80 00       	push   $0x802f2e
  80138a:	68 99 00 00 00       	push   $0x99
  80138f:	68 23 2f 80 00       	push   $0x802f23
  801394:	e8 eb 13 00 00       	call   802784 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	68 b8 2f 80 00       	push   $0x802fb8
  8013a1:	68 9c 00 00 00       	push   $0x9c
  8013a6:	68 23 2f 80 00       	push   $0x802f23
  8013ab:	e8 d4 13 00 00       	call   802784 <_panic>
		panic("panic in sys_env_set_status()\n");
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	68 e0 2f 80 00       	push   $0x802fe0
  8013b8:	68 9f 00 00 00       	push   $0x9f
  8013bd:	68 23 2f 80 00       	push   $0x802f23
  8013c2:	e8 bd 13 00 00       	call   802784 <_panic>

008013c7 <sfork>:

// Challenge!
int
sfork(void)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	53                   	push   %ebx
  8013cd:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013d0:	68 37 10 80 00       	push   $0x801037
  8013d5:	e8 0b 14 00 00       	call   8027e5 <set_pgfault_handler>
  8013da:	b8 07 00 00 00       	mov    $0x7,%eax
  8013df:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 27                	js     80140f <sfork+0x48>
  8013e8:	89 c7                	mov    %eax,%edi
  8013ea:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ec:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013f1:	75 55                	jne    801448 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013f3:	e8 2c f9 ff ff       	call   800d24 <sys_getenvid>
  8013f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013fd:	c1 e0 07             	shl    $0x7,%eax
  801400:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801405:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80140a:	e9 d4 00 00 00       	jmp    8014e3 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80140f:	83 ec 04             	sub    $0x4,%esp
  801412:	68 94 2f 80 00       	push   $0x802f94
  801417:	68 b0 00 00 00       	push   $0xb0
  80141c:	68 23 2f 80 00       	push   $0x802f23
  801421:	e8 5e 13 00 00       	call   802784 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801426:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	e8 04 fd ff ff       	call   801136 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801432:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801438:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80143e:	77 65                	ja     8014a5 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801440:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801446:	74 de                	je     801426 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	c1 e8 16             	shr    $0x16,%eax
  80144d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801454:	a8 01                	test   $0x1,%al
  801456:	74 da                	je     801432 <sfork+0x6b>
  801458:	89 da                	mov    %ebx,%edx
  80145a:	c1 ea 0c             	shr    $0xc,%edx
  80145d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801464:	83 e0 05             	and    $0x5,%eax
  801467:	83 f8 05             	cmp    $0x5,%eax
  80146a:	75 c6                	jne    801432 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80146c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801473:	c1 e2 0c             	shl    $0xc,%edx
  801476:	83 ec 0c             	sub    $0xc,%esp
  801479:	83 e0 07             	and    $0x7,%eax
  80147c:	50                   	push   %eax
  80147d:	52                   	push   %edx
  80147e:	56                   	push   %esi
  80147f:	52                   	push   %edx
  801480:	6a 00                	push   $0x0
  801482:	e8 1e f9 ff ff       	call   800da5 <sys_page_map>
  801487:	83 c4 20             	add    $0x20,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	74 a4                	je     801432 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	68 7d 2f 80 00       	push   $0x802f7d
  801496:	68 bb 00 00 00       	push   $0xbb
  80149b:	68 23 2f 80 00       	push   $0x802f23
  8014a0:	e8 df 12 00 00       	call   802784 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	6a 07                	push   $0x7
  8014aa:	68 00 f0 bf ee       	push   $0xeebff000
  8014af:	57                   	push   %edi
  8014b0:	e8 ad f8 ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 31                	js     8014ed <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	68 54 28 80 00       	push   $0x802854
  8014c4:	57                   	push   %edi
  8014c5:	e8 e3 f9 ff ff       	call   800ead <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 33                	js     801504 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	6a 02                	push   $0x2
  8014d6:	57                   	push   %edi
  8014d7:	e8 4d f9 ff ff       	call   800e29 <sys_env_set_status>
	if(ret < 0)
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 38                	js     80151b <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014e3:	89 f8                	mov    %edi,%eax
  8014e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e8:	5b                   	pop    %ebx
  8014e9:	5e                   	pop    %esi
  8014ea:	5f                   	pop    %edi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 2e 2f 80 00       	push   $0x802f2e
  8014f5:	68 c1 00 00 00       	push   $0xc1
  8014fa:	68 23 2f 80 00       	push   $0x802f23
  8014ff:	e8 80 12 00 00       	call   802784 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 b8 2f 80 00       	push   $0x802fb8
  80150c:	68 c4 00 00 00       	push   $0xc4
  801511:	68 23 2f 80 00       	push   $0x802f23
  801516:	e8 69 12 00 00       	call   802784 <_panic>
		panic("panic in sys_env_set_status()\n");
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	68 e0 2f 80 00       	push   $0x802fe0
  801523:	68 c7 00 00 00       	push   $0xc7
  801528:	68 23 2f 80 00       	push   $0x802f23
  80152d:	e8 52 12 00 00       	call   802784 <_panic>

00801532 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	56                   	push   %esi
  801536:	53                   	push   %ebx
  801537:	8b 75 08             	mov    0x8(%ebp),%esi
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801540:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801542:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801547:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	50                   	push   %eax
  80154e:	e8 bf f9 ff ff       	call   800f12 <sys_ipc_recv>
	if(ret < 0){
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 2b                	js     801585 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80155a:	85 f6                	test   %esi,%esi
  80155c:	74 0a                	je     801568 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80155e:	a1 08 50 80 00       	mov    0x805008,%eax
  801563:	8b 40 74             	mov    0x74(%eax),%eax
  801566:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801568:	85 db                	test   %ebx,%ebx
  80156a:	74 0a                	je     801576 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80156c:	a1 08 50 80 00       	mov    0x805008,%eax
  801571:	8b 40 78             	mov    0x78(%eax),%eax
  801574:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801576:	a1 08 50 80 00       	mov    0x805008,%eax
  80157b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80157e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    
		if(from_env_store)
  801585:	85 f6                	test   %esi,%esi
  801587:	74 06                	je     80158f <ipc_recv+0x5d>
			*from_env_store = 0;
  801589:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80158f:	85 db                	test   %ebx,%ebx
  801591:	74 eb                	je     80157e <ipc_recv+0x4c>
			*perm_store = 0;
  801593:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801599:	eb e3                	jmp    80157e <ipc_recv+0x4c>

0080159b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	57                   	push   %edi
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8015ad:	85 db                	test   %ebx,%ebx
  8015af:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015b4:	0f 44 d8             	cmove  %eax,%ebx
  8015b7:	eb 05                	jmp    8015be <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015b9:	e8 85 f7 ff ff       	call   800d43 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015be:	ff 75 14             	pushl  0x14(%ebp)
  8015c1:	53                   	push   %ebx
  8015c2:	56                   	push   %esi
  8015c3:	57                   	push   %edi
  8015c4:	e8 26 f9 ff ff       	call   800eef <sys_ipc_try_send>
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 1b                	je     8015eb <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015d0:	79 e7                	jns    8015b9 <ipc_send+0x1e>
  8015d2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015d5:	74 e2                	je     8015b9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	68 08 30 80 00       	push   $0x803008
  8015df:	6a 48                	push   $0x48
  8015e1:	68 1d 30 80 00       	push   $0x80301d
  8015e6:	e8 99 11 00 00       	call   802784 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5f                   	pop    %edi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	c1 e2 07             	shl    $0x7,%edx
  801603:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801609:	8b 52 50             	mov    0x50(%edx),%edx
  80160c:	39 ca                	cmp    %ecx,%edx
  80160e:	74 11                	je     801621 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801610:	83 c0 01             	add    $0x1,%eax
  801613:	3d 00 04 00 00       	cmp    $0x400,%eax
  801618:	75 e4                	jne    8015fe <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
  80161f:	eb 0b                	jmp    80162c <ipc_find_env+0x39>
			return envs[i].env_id;
  801621:	c1 e0 07             	shl    $0x7,%eax
  801624:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801629:	8b 40 48             	mov    0x48(%eax),%eax
}
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	05 00 00 00 30       	add    $0x30000000,%eax
  801639:	c1 e8 0c             	shr    $0xc,%eax
}
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801649:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80164e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80165d:	89 c2                	mov    %eax,%edx
  80165f:	c1 ea 16             	shr    $0x16,%edx
  801662:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801669:	f6 c2 01             	test   $0x1,%dl
  80166c:	74 2d                	je     80169b <fd_alloc+0x46>
  80166e:	89 c2                	mov    %eax,%edx
  801670:	c1 ea 0c             	shr    $0xc,%edx
  801673:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80167a:	f6 c2 01             	test   $0x1,%dl
  80167d:	74 1c                	je     80169b <fd_alloc+0x46>
  80167f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801684:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801689:	75 d2                	jne    80165d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801694:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801699:	eb 0a                	jmp    8016a5 <fd_alloc+0x50>
			*fd_store = fd;
  80169b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169e:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ad:	83 f8 1f             	cmp    $0x1f,%eax
  8016b0:	77 30                	ja     8016e2 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016b2:	c1 e0 0c             	shl    $0xc,%eax
  8016b5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016ba:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016c0:	f6 c2 01             	test   $0x1,%dl
  8016c3:	74 24                	je     8016e9 <fd_lookup+0x42>
  8016c5:	89 c2                	mov    %eax,%edx
  8016c7:	c1 ea 0c             	shr    $0xc,%edx
  8016ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d1:	f6 c2 01             	test   $0x1,%dl
  8016d4:	74 1a                	je     8016f0 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	89 02                	mov    %eax,(%edx)
	return 0;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e0:	5d                   	pop    %ebp
  8016e1:	c3                   	ret    
		return -E_INVAL;
  8016e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e7:	eb f7                	jmp    8016e0 <fd_lookup+0x39>
		return -E_INVAL;
  8016e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ee:	eb f0                	jmp    8016e0 <fd_lookup+0x39>
  8016f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f5:	eb e9                	jmp    8016e0 <fd_lookup+0x39>

008016f7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80170a:	39 08                	cmp    %ecx,(%eax)
  80170c:	74 38                	je     801746 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80170e:	83 c2 01             	add    $0x1,%edx
  801711:	8b 04 95 a4 30 80 00 	mov    0x8030a4(,%edx,4),%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	75 ee                	jne    80170a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80171c:	a1 08 50 80 00       	mov    0x805008,%eax
  801721:	8b 40 48             	mov    0x48(%eax),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	51                   	push   %ecx
  801728:	50                   	push   %eax
  801729:	68 28 30 80 00       	push   $0x803028
  80172e:	e8 de ea ff ff       	call   800211 <cprintf>
	*dev = 0;
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    
			*dev = devtab[i];
  801746:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801749:	89 01                	mov    %eax,(%ecx)
			return 0;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	eb f2                	jmp    801744 <dev_lookup+0x4d>

00801752 <fd_close>:
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	57                   	push   %edi
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	83 ec 24             	sub    $0x24,%esp
  80175b:	8b 75 08             	mov    0x8(%ebp),%esi
  80175e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801761:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801764:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801765:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80176b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80176e:	50                   	push   %eax
  80176f:	e8 33 ff ff ff       	call   8016a7 <fd_lookup>
  801774:	89 c3                	mov    %eax,%ebx
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 05                	js     801782 <fd_close+0x30>
	    || fd != fd2)
  80177d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801780:	74 16                	je     801798 <fd_close+0x46>
		return (must_exist ? r : 0);
  801782:	89 f8                	mov    %edi,%eax
  801784:	84 c0                	test   %al,%al
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	0f 44 d8             	cmove  %eax,%ebx
}
  80178e:	89 d8                	mov    %ebx,%eax
  801790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80179e:	50                   	push   %eax
  80179f:	ff 36                	pushl  (%esi)
  8017a1:	e8 51 ff ff ff       	call   8016f7 <dev_lookup>
  8017a6:	89 c3                	mov    %eax,%ebx
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 1a                	js     8017c9 <fd_close+0x77>
		if (dev->dev_close)
  8017af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017b5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	74 0b                	je     8017c9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	56                   	push   %esi
  8017c2:	ff d0                	call   *%eax
  8017c4:	89 c3                	mov    %eax,%ebx
  8017c6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	56                   	push   %esi
  8017cd:	6a 00                	push   $0x0
  8017cf:	e8 13 f6 ff ff       	call   800de7 <sys_page_unmap>
	return r;
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	eb b5                	jmp    80178e <fd_close+0x3c>

008017d9 <close>:

int
close(int fdnum)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e2:	50                   	push   %eax
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 bc fe ff ff       	call   8016a7 <fd_lookup>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	79 02                	jns    8017f4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    
		return fd_close(fd, 1);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	6a 01                	push   $0x1
  8017f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fc:	e8 51 ff ff ff       	call   801752 <fd_close>
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	eb ec                	jmp    8017f2 <close+0x19>

00801806 <close_all>:

void
close_all(void)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	53                   	push   %ebx
  80180a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80180d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	53                   	push   %ebx
  801816:	e8 be ff ff ff       	call   8017d9 <close>
	for (i = 0; i < MAXFD; i++)
  80181b:	83 c3 01             	add    $0x1,%ebx
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	83 fb 20             	cmp    $0x20,%ebx
  801824:	75 ec                	jne    801812 <close_all+0xc>
}
  801826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801834:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 67 fe ff ff       	call   8016a7 <fd_lookup>
  801840:	89 c3                	mov    %eax,%ebx
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	0f 88 81 00 00 00    	js     8018ce <dup+0xa3>
		return r;
	close(newfdnum);
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	e8 81 ff ff ff       	call   8017d9 <close>

	newfd = INDEX2FD(newfdnum);
  801858:	8b 75 0c             	mov    0xc(%ebp),%esi
  80185b:	c1 e6 0c             	shl    $0xc,%esi
  80185e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801864:	83 c4 04             	add    $0x4,%esp
  801867:	ff 75 e4             	pushl  -0x1c(%ebp)
  80186a:	e8 cf fd ff ff       	call   80163e <fd2data>
  80186f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801871:	89 34 24             	mov    %esi,(%esp)
  801874:	e8 c5 fd ff ff       	call   80163e <fd2data>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80187e:	89 d8                	mov    %ebx,%eax
  801880:	c1 e8 16             	shr    $0x16,%eax
  801883:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80188a:	a8 01                	test   $0x1,%al
  80188c:	74 11                	je     80189f <dup+0x74>
  80188e:	89 d8                	mov    %ebx,%eax
  801890:	c1 e8 0c             	shr    $0xc,%eax
  801893:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80189a:	f6 c2 01             	test   $0x1,%dl
  80189d:	75 39                	jne    8018d8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80189f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018a2:	89 d0                	mov    %edx,%eax
  8018a4:	c1 e8 0c             	shr    $0xc,%eax
  8018a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8018b6:	50                   	push   %eax
  8018b7:	56                   	push   %esi
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	6a 00                	push   $0x0
  8018bd:	e8 e3 f4 ff ff       	call   800da5 <sys_page_map>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	83 c4 20             	add    $0x20,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 31                	js     8018fc <dup+0xd1>
		goto err;

	return newfdnum;
  8018cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018ce:	89 d8                	mov    %ebx,%eax
  8018d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5f                   	pop    %edi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8018e7:	50                   	push   %eax
  8018e8:	57                   	push   %edi
  8018e9:	6a 00                	push   $0x0
  8018eb:	53                   	push   %ebx
  8018ec:	6a 00                	push   $0x0
  8018ee:	e8 b2 f4 ff ff       	call   800da5 <sys_page_map>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	83 c4 20             	add    $0x20,%esp
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	79 a3                	jns    80189f <dup+0x74>
	sys_page_unmap(0, newfd);
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	56                   	push   %esi
  801900:	6a 00                	push   $0x0
  801902:	e8 e0 f4 ff ff       	call   800de7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801907:	83 c4 08             	add    $0x8,%esp
  80190a:	57                   	push   %edi
  80190b:	6a 00                	push   $0x0
  80190d:	e8 d5 f4 ff ff       	call   800de7 <sys_page_unmap>
	return r;
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	eb b7                	jmp    8018ce <dup+0xa3>

00801917 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	53                   	push   %ebx
  80191b:	83 ec 1c             	sub    $0x1c,%esp
  80191e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801921:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	53                   	push   %ebx
  801926:	e8 7c fd ff ff       	call   8016a7 <fd_lookup>
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 3f                	js     801971 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	ff 30                	pushl  (%eax)
  80193e:	e8 b4 fd ff ff       	call   8016f7 <dev_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 27                	js     801971 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80194a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194d:	8b 42 08             	mov    0x8(%edx),%eax
  801950:	83 e0 03             	and    $0x3,%eax
  801953:	83 f8 01             	cmp    $0x1,%eax
  801956:	74 1e                	je     801976 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195b:	8b 40 08             	mov    0x8(%eax),%eax
  80195e:	85 c0                	test   %eax,%eax
  801960:	74 35                	je     801997 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	52                   	push   %edx
  80196c:	ff d0                	call   *%eax
  80196e:	83 c4 10             	add    $0x10,%esp
}
  801971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801974:	c9                   	leave  
  801975:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801976:	a1 08 50 80 00       	mov    0x805008,%eax
  80197b:	8b 40 48             	mov    0x48(%eax),%eax
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	53                   	push   %ebx
  801982:	50                   	push   %eax
  801983:	68 69 30 80 00       	push   $0x803069
  801988:	e8 84 e8 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801995:	eb da                	jmp    801971 <read+0x5a>
		return -E_NOT_SUPP;
  801997:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199c:	eb d3                	jmp    801971 <read+0x5a>

0080199e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b2:	39 f3                	cmp    %esi,%ebx
  8019b4:	73 23                	jae    8019d9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	89 f0                	mov    %esi,%eax
  8019bb:	29 d8                	sub    %ebx,%eax
  8019bd:	50                   	push   %eax
  8019be:	89 d8                	mov    %ebx,%eax
  8019c0:	03 45 0c             	add    0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	57                   	push   %edi
  8019c5:	e8 4d ff ff ff       	call   801917 <read>
		if (m < 0)
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 06                	js     8019d7 <readn+0x39>
			return m;
		if (m == 0)
  8019d1:	74 06                	je     8019d9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019d3:	01 c3                	add    %eax,%ebx
  8019d5:	eb db                	jmp    8019b2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019d7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019d9:	89 d8                	mov    %ebx,%eax
  8019db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5f                   	pop    %edi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 1c             	sub    $0x1c,%esp
  8019ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f0:	50                   	push   %eax
  8019f1:	53                   	push   %ebx
  8019f2:	e8 b0 fc ff ff       	call   8016a7 <fd_lookup>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 3a                	js     801a38 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019fe:	83 ec 08             	sub    $0x8,%esp
  801a01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a04:	50                   	push   %eax
  801a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a08:	ff 30                	pushl  (%eax)
  801a0a:	e8 e8 fc ff ff       	call   8016f7 <dev_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 22                	js     801a38 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a1d:	74 1e                	je     801a3d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a22:	8b 52 0c             	mov    0xc(%edx),%edx
  801a25:	85 d2                	test   %edx,%edx
  801a27:	74 35                	je     801a5e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	ff 75 10             	pushl  0x10(%ebp)
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	50                   	push   %eax
  801a33:	ff d2                	call   *%edx
  801a35:	83 c4 10             	add    $0x10,%esp
}
  801a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3d:	a1 08 50 80 00       	mov    0x805008,%eax
  801a42:	8b 40 48             	mov    0x48(%eax),%eax
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	53                   	push   %ebx
  801a49:	50                   	push   %eax
  801a4a:	68 85 30 80 00       	push   $0x803085
  801a4f:	e8 bd e7 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5c:	eb da                	jmp    801a38 <write+0x55>
		return -E_NOT_SUPP;
  801a5e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a63:	eb d3                	jmp    801a38 <write+0x55>

00801a65 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6e:	50                   	push   %eax
  801a6f:	ff 75 08             	pushl  0x8(%ebp)
  801a72:	e8 30 fc ff ff       	call   8016a7 <fd_lookup>
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 0e                	js     801a8c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a84:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
  801a92:	83 ec 1c             	sub    $0x1c,%esp
  801a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	53                   	push   %ebx
  801a9d:	e8 05 fc ff ff       	call   8016a7 <fd_lookup>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 37                	js     801ae0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aaf:	50                   	push   %eax
  801ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab3:	ff 30                	pushl  (%eax)
  801ab5:	e8 3d fc ff ff       	call   8016f7 <dev_lookup>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 1f                	js     801ae0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ac8:	74 1b                	je     801ae5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801acd:	8b 52 18             	mov    0x18(%edx),%edx
  801ad0:	85 d2                	test   %edx,%edx
  801ad2:	74 32                	je     801b06 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	ff d2                	call   *%edx
  801add:	83 c4 10             	add    $0x10,%esp
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ae5:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aea:	8b 40 48             	mov    0x48(%eax),%eax
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	53                   	push   %ebx
  801af1:	50                   	push   %eax
  801af2:	68 48 30 80 00       	push   $0x803048
  801af7:	e8 15 e7 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b04:	eb da                	jmp    801ae0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0b:	eb d3                	jmp    801ae0 <ftruncate+0x52>

00801b0d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 1c             	sub    $0x1c,%esp
  801b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b17:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	e8 84 fb ff ff       	call   8016a7 <fd_lookup>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 4b                	js     801b75 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b30:	50                   	push   %eax
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	ff 30                	pushl  (%eax)
  801b36:	e8 bc fb ff ff       	call   8016f7 <dev_lookup>
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 33                	js     801b75 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b45:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b49:	74 2f                	je     801b7a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b4b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b4e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b55:	00 00 00 
	stat->st_isdir = 0;
  801b58:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b5f:	00 00 00 
	stat->st_dev = dev;
  801b62:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b68:	83 ec 08             	sub    $0x8,%esp
  801b6b:	53                   	push   %ebx
  801b6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6f:	ff 50 14             	call   *0x14(%eax)
  801b72:	83 c4 10             	add    $0x10,%esp
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    
		return -E_NOT_SUPP;
  801b7a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7f:	eb f4                	jmp    801b75 <fstat+0x68>

00801b81 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 22 02 00 00       	call   801db5 <open>
  801b93:	89 c3                	mov    %eax,%ebx
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 1b                	js     801bb7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	e8 65 ff ff ff       	call   801b0d <fstat>
  801ba8:	89 c6                	mov    %eax,%esi
	close(fd);
  801baa:	89 1c 24             	mov    %ebx,(%esp)
  801bad:	e8 27 fc ff ff       	call   8017d9 <close>
	return r;
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	89 f3                	mov    %esi,%ebx
}
  801bb7:	89 d8                	mov    %ebx,%eax
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	89 c6                	mov    %eax,%esi
  801bc7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bc9:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bd0:	74 27                	je     801bf9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bd2:	6a 07                	push   $0x7
  801bd4:	68 00 60 80 00       	push   $0x806000
  801bd9:	56                   	push   %esi
  801bda:	ff 35 00 50 80 00    	pushl  0x805000
  801be0:	e8 b6 f9 ff ff       	call   80159b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801be5:	83 c4 0c             	add    $0xc,%esp
  801be8:	6a 00                	push   $0x0
  801bea:	53                   	push   %ebx
  801beb:	6a 00                	push   $0x0
  801bed:	e8 40 f9 ff ff       	call   801532 <ipc_recv>
}
  801bf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	6a 01                	push   $0x1
  801bfe:	e8 f0 f9 ff ff       	call   8015f3 <ipc_find_env>
  801c03:	a3 00 50 80 00       	mov    %eax,0x805000
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	eb c5                	jmp    801bd2 <fsipc+0x12>

00801c0d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	8b 40 0c             	mov    0xc(%eax),%eax
  801c19:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c21:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c26:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2b:	b8 02 00 00 00       	mov    $0x2,%eax
  801c30:	e8 8b ff ff ff       	call   801bc0 <fsipc>
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <devfile_flush>:
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8b 40 0c             	mov    0xc(%eax),%eax
  801c43:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c48:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4d:	b8 06 00 00 00       	mov    $0x6,%eax
  801c52:	e8 69 ff ff ff       	call   801bc0 <fsipc>
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <devfile_stat>:
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	8b 40 0c             	mov    0xc(%eax),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c73:	b8 05 00 00 00       	mov    $0x5,%eax
  801c78:	e8 43 ff ff ff       	call   801bc0 <fsipc>
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 2c                	js     801cad <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c81:	83 ec 08             	sub    $0x8,%esp
  801c84:	68 00 60 80 00       	push   $0x806000
  801c89:	53                   	push   %ebx
  801c8a:	e8 e1 ec ff ff       	call   800970 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c8f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c9a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <devfile_write>:
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	53                   	push   %ebx
  801cb6:	83 ec 08             	sub    $0x8,%esp
  801cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cc7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ccd:	53                   	push   %ebx
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	68 08 60 80 00       	push   $0x806008
  801cd6:	e8 85 ee ff ff       	call   800b60 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce5:	e8 d6 fe ff ff       	call   801bc0 <fsipc>
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	85 c0                	test   %eax,%eax
  801cef:	78 0b                	js     801cfc <devfile_write+0x4a>
	assert(r <= n);
  801cf1:	39 d8                	cmp    %ebx,%eax
  801cf3:	77 0c                	ja     801d01 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cf5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cfa:	7f 1e                	jg     801d1a <devfile_write+0x68>
}
  801cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    
	assert(r <= n);
  801d01:	68 b8 30 80 00       	push   $0x8030b8
  801d06:	68 bf 30 80 00       	push   $0x8030bf
  801d0b:	68 98 00 00 00       	push   $0x98
  801d10:	68 d4 30 80 00       	push   $0x8030d4
  801d15:	e8 6a 0a 00 00       	call   802784 <_panic>
	assert(r <= PGSIZE);
  801d1a:	68 df 30 80 00       	push   $0x8030df
  801d1f:	68 bf 30 80 00       	push   $0x8030bf
  801d24:	68 99 00 00 00       	push   $0x99
  801d29:	68 d4 30 80 00       	push   $0x8030d4
  801d2e:	e8 51 0a 00 00       	call   802784 <_panic>

00801d33 <devfile_read>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d41:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d46:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d51:	b8 03 00 00 00       	mov    $0x3,%eax
  801d56:	e8 65 fe ff ff       	call   801bc0 <fsipc>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 1f                	js     801d80 <devfile_read+0x4d>
	assert(r <= n);
  801d61:	39 f0                	cmp    %esi,%eax
  801d63:	77 24                	ja     801d89 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d65:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6a:	7f 33                	jg     801d9f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	50                   	push   %eax
  801d70:	68 00 60 80 00       	push   $0x806000
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	e8 81 ed ff ff       	call   800afe <memmove>
	return r;
  801d7d:	83 c4 10             	add    $0x10,%esp
}
  801d80:	89 d8                	mov    %ebx,%eax
  801d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    
	assert(r <= n);
  801d89:	68 b8 30 80 00       	push   $0x8030b8
  801d8e:	68 bf 30 80 00       	push   $0x8030bf
  801d93:	6a 7c                	push   $0x7c
  801d95:	68 d4 30 80 00       	push   $0x8030d4
  801d9a:	e8 e5 09 00 00       	call   802784 <_panic>
	assert(r <= PGSIZE);
  801d9f:	68 df 30 80 00       	push   $0x8030df
  801da4:	68 bf 30 80 00       	push   $0x8030bf
  801da9:	6a 7d                	push   $0x7d
  801dab:	68 d4 30 80 00       	push   $0x8030d4
  801db0:	e8 cf 09 00 00       	call   802784 <_panic>

00801db5 <open>:
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	56                   	push   %esi
  801db9:	53                   	push   %ebx
  801dba:	83 ec 1c             	sub    $0x1c,%esp
  801dbd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dc0:	56                   	push   %esi
  801dc1:	e8 71 eb ff ff       	call   800937 <strlen>
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dce:	7f 6c                	jg     801e3c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd6:	50                   	push   %eax
  801dd7:	e8 79 f8 ff ff       	call   801655 <fd_alloc>
  801ddc:	89 c3                	mov    %eax,%ebx
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 3c                	js     801e21 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801de5:	83 ec 08             	sub    $0x8,%esp
  801de8:	56                   	push   %esi
  801de9:	68 00 60 80 00       	push   $0x806000
  801dee:	e8 7d eb ff ff       	call   800970 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	e8 b8 fd ff ff       	call   801bc0 <fsipc>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 19                	js     801e2a <open+0x75>
	return fd2num(fd);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 f4             	pushl  -0xc(%ebp)
  801e17:	e8 12 f8 ff ff       	call   80162e <fd2num>
  801e1c:	89 c3                	mov    %eax,%ebx
  801e1e:	83 c4 10             	add    $0x10,%esp
}
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5e                   	pop    %esi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    
		fd_close(fd, 0);
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e32:	e8 1b f9 ff ff       	call   801752 <fd_close>
		return r;
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	eb e5                	jmp    801e21 <open+0x6c>
		return -E_BAD_PATH;
  801e3c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e41:	eb de                	jmp    801e21 <open+0x6c>

00801e43 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e49:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e53:	e8 68 fd ff ff       	call   801bc0 <fsipc>
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e60:	68 eb 30 80 00       	push   $0x8030eb
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	e8 03 eb ff ff       	call   800970 <strcpy>
	return 0;
}
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <devsock_close>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	53                   	push   %ebx
  801e78:	83 ec 10             	sub    $0x10,%esp
  801e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e7e:	53                   	push   %ebx
  801e7f:	e8 f6 09 00 00       	call   80287a <pageref>
  801e84:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e8c:	83 f8 01             	cmp    $0x1,%eax
  801e8f:	74 07                	je     801e98 <devsock_close+0x24>
}
  801e91:	89 d0                	mov    %edx,%eax
  801e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	ff 73 0c             	pushl  0xc(%ebx)
  801e9e:	e8 b9 02 00 00       	call   80215c <nsipc_close>
  801ea3:	89 c2                	mov    %eax,%edx
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	eb e7                	jmp    801e91 <devsock_close+0x1d>

00801eaa <devsock_write>:
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 10             	pushl  0x10(%ebp)
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	ff 70 0c             	pushl  0xc(%eax)
  801ebe:	e8 76 03 00 00       	call   802239 <nsipc_send>
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <devsock_read>:
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	ff 75 10             	pushl  0x10(%ebp)
  801ed0:	ff 75 0c             	pushl  0xc(%ebp)
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	ff 70 0c             	pushl  0xc(%eax)
  801ed9:	e8 ef 02 00 00       	call   8021cd <nsipc_recv>
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <fd2sockid>:
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ee9:	52                   	push   %edx
  801eea:	50                   	push   %eax
  801eeb:	e8 b7 f7 ff ff       	call   8016a7 <fd_lookup>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	78 10                	js     801f07 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f00:	39 08                	cmp    %ecx,(%eax)
  801f02:	75 05                	jne    801f09 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f04:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    
		return -E_NOT_SUPP;
  801f09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f0e:	eb f7                	jmp    801f07 <fd2sockid+0x27>

00801f10 <alloc_sockfd>:
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	56                   	push   %esi
  801f14:	53                   	push   %ebx
  801f15:	83 ec 1c             	sub    $0x1c,%esp
  801f18:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1d:	50                   	push   %eax
  801f1e:	e8 32 f7 ff ff       	call   801655 <fd_alloc>
  801f23:	89 c3                	mov    %eax,%ebx
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 43                	js     801f6f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	68 07 04 00 00       	push   $0x407
  801f34:	ff 75 f4             	pushl  -0xc(%ebp)
  801f37:	6a 00                	push   $0x0
  801f39:	e8 24 ee ff ff       	call   800d62 <sys_page_alloc>
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	85 c0                	test   %eax,%eax
  801f45:	78 28                	js     801f6f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f50:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f5c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	50                   	push   %eax
  801f63:	e8 c6 f6 ff ff       	call   80162e <fd2num>
  801f68:	89 c3                	mov    %eax,%ebx
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	eb 0c                	jmp    801f7b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	56                   	push   %esi
  801f73:	e8 e4 01 00 00       	call   80215c <nsipc_close>
		return r;
  801f78:	83 c4 10             	add    $0x10,%esp
}
  801f7b:	89 d8                	mov    %ebx,%eax
  801f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <accept>:
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	e8 4e ff ff ff       	call   801ee0 <fd2sockid>
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 1b                	js     801fb1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	ff 75 10             	pushl  0x10(%ebp)
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	50                   	push   %eax
  801fa0:	e8 0e 01 00 00       	call   8020b3 <nsipc_accept>
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 05                	js     801fb1 <accept+0x2d>
	return alloc_sockfd(r);
  801fac:	e8 5f ff ff ff       	call   801f10 <alloc_sockfd>
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <bind>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	e8 1f ff ff ff       	call   801ee0 <fd2sockid>
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	78 12                	js     801fd7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	ff 75 10             	pushl  0x10(%ebp)
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	50                   	push   %eax
  801fcf:	e8 31 01 00 00       	call   802105 <nsipc_bind>
  801fd4:	83 c4 10             	add    $0x10,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <shutdown>:
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	e8 f9 fe ff ff       	call   801ee0 <fd2sockid>
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	78 0f                	js     801ffa <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801feb:	83 ec 08             	sub    $0x8,%esp
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	50                   	push   %eax
  801ff2:	e8 43 01 00 00       	call   80213a <nsipc_shutdown>
  801ff7:	83 c4 10             	add    $0x10,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <connect>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	e8 d6 fe ff ff       	call   801ee0 <fd2sockid>
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 12                	js     802020 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	ff 75 10             	pushl  0x10(%ebp)
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	50                   	push   %eax
  802018:	e8 59 01 00 00       	call   802176 <nsipc_connect>
  80201d:	83 c4 10             	add    $0x10,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <listen>:
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	e8 b0 fe ff ff       	call   801ee0 <fd2sockid>
  802030:	85 c0                	test   %eax,%eax
  802032:	78 0f                	js     802043 <listen+0x21>
	return nsipc_listen(r, backlog);
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	50                   	push   %eax
  80203b:	e8 6b 01 00 00       	call   8021ab <nsipc_listen>
  802040:	83 c4 10             	add    $0x10,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <socket>:

int
socket(int domain, int type, int protocol)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204b:	ff 75 10             	pushl  0x10(%ebp)
  80204e:	ff 75 0c             	pushl  0xc(%ebp)
  802051:	ff 75 08             	pushl  0x8(%ebp)
  802054:	e8 3e 02 00 00       	call   802297 <nsipc_socket>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	78 05                	js     802065 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802060:	e8 ab fe ff ff       	call   801f10 <alloc_sockfd>
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	53                   	push   %ebx
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802070:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802077:	74 26                	je     80209f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802079:	6a 07                	push   $0x7
  80207b:	68 00 70 80 00       	push   $0x807000
  802080:	53                   	push   %ebx
  802081:	ff 35 04 50 80 00    	pushl  0x805004
  802087:	e8 0f f5 ff ff       	call   80159b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80208c:	83 c4 0c             	add    $0xc,%esp
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	e8 98 f4 ff ff       	call   801532 <ipc_recv>
}
  80209a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80209f:	83 ec 0c             	sub    $0xc,%esp
  8020a2:	6a 02                	push   $0x2
  8020a4:	e8 4a f5 ff ff       	call   8015f3 <ipc_find_env>
  8020a9:	a3 04 50 80 00       	mov    %eax,0x805004
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	eb c6                	jmp    802079 <nsipc+0x12>

008020b3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020c3:	8b 06                	mov    (%esi),%eax
  8020c5:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cf:	e8 93 ff ff ff       	call   802067 <nsipc>
  8020d4:	89 c3                	mov    %eax,%ebx
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	79 09                	jns    8020e3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020da:	89 d8                	mov    %ebx,%eax
  8020dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	ff 35 10 70 80 00    	pushl  0x807010
  8020ec:	68 00 70 80 00       	push   $0x807000
  8020f1:	ff 75 0c             	pushl  0xc(%ebp)
  8020f4:	e8 05 ea ff ff       	call   800afe <memmove>
		*addrlen = ret->ret_addrlen;
  8020f9:	a1 10 70 80 00       	mov    0x807010,%eax
  8020fe:	89 06                	mov    %eax,(%esi)
  802100:	83 c4 10             	add    $0x10,%esp
	return r;
  802103:	eb d5                	jmp    8020da <nsipc_accept+0x27>

00802105 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 08             	sub    $0x8,%esp
  80210c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802117:	53                   	push   %ebx
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	68 04 70 80 00       	push   $0x807004
  802120:	e8 d9 e9 ff ff       	call   800afe <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802125:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80212b:	b8 02 00 00 00       	mov    $0x2,%eax
  802130:	e8 32 ff ff ff       	call   802067 <nsipc>
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802150:	b8 03 00 00 00       	mov    $0x3,%eax
  802155:	e8 0d ff ff ff       	call   802067 <nsipc>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <nsipc_close>:

int
nsipc_close(int s)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80216a:	b8 04 00 00 00       	mov    $0x4,%eax
  80216f:	e8 f3 fe ff ff       	call   802067 <nsipc>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	53                   	push   %ebx
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802188:	53                   	push   %ebx
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	68 04 70 80 00       	push   $0x807004
  802191:	e8 68 e9 ff ff       	call   800afe <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802196:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80219c:	b8 05 00 00 00       	mov    $0x5,%eax
  8021a1:	e8 c1 fe ff ff       	call   802067 <nsipc>
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8021c6:	e8 9c fe ff ff       	call   802067 <nsipc>
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021dd:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e6:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f0:	e8 72 fe ff ff       	call   802067 <nsipc>
  8021f5:	89 c3                	mov    %eax,%ebx
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 1f                	js     80221a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021fb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802200:	7f 21                	jg     802223 <nsipc_recv+0x56>
  802202:	39 c6                	cmp    %eax,%esi
  802204:	7c 1d                	jl     802223 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	50                   	push   %eax
  80220a:	68 00 70 80 00       	push   $0x807000
  80220f:	ff 75 0c             	pushl  0xc(%ebp)
  802212:	e8 e7 e8 ff ff       	call   800afe <memmove>
  802217:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80221a:	89 d8                	mov    %ebx,%eax
  80221c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802223:	68 f7 30 80 00       	push   $0x8030f7
  802228:	68 bf 30 80 00       	push   $0x8030bf
  80222d:	6a 62                	push   $0x62
  80222f:	68 0c 31 80 00       	push   $0x80310c
  802234:	e8 4b 05 00 00       	call   802784 <_panic>

00802239 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	53                   	push   %ebx
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80224b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802251:	7f 2e                	jg     802281 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	53                   	push   %ebx
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	68 0c 70 80 00       	push   $0x80700c
  80225f:	e8 9a e8 ff ff       	call   800afe <memmove>
	nsipcbuf.send.req_size = size;
  802264:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80226a:	8b 45 14             	mov    0x14(%ebp),%eax
  80226d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802272:	b8 08 00 00 00       	mov    $0x8,%eax
  802277:	e8 eb fd ff ff       	call   802067 <nsipc>
}
  80227c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227f:	c9                   	leave  
  802280:	c3                   	ret    
	assert(size < 1600);
  802281:	68 18 31 80 00       	push   $0x803118
  802286:	68 bf 30 80 00       	push   $0x8030bf
  80228b:	6a 6d                	push   $0x6d
  80228d:	68 0c 31 80 00       	push   $0x80310c
  802292:	e8 ed 04 00 00       	call   802784 <_panic>

00802297 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a8:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8022ba:	e8 a8 fd ff ff       	call   802067 <nsipc>
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	e8 6a f3 ff ff       	call   80163e <fd2data>
  8022d4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022d6:	83 c4 08             	add    $0x8,%esp
  8022d9:	68 24 31 80 00       	push   $0x803124
  8022de:	53                   	push   %ebx
  8022df:	e8 8c e6 ff ff       	call   800970 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022e4:	8b 46 04             	mov    0x4(%esi),%eax
  8022e7:	2b 06                	sub    (%esi),%eax
  8022e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022f6:	00 00 00 
	stat->st_dev = &devpipe;
  8022f9:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802300:	40 80 00 
	return 0;
}
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    

0080230f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	53                   	push   %ebx
  802313:	83 ec 0c             	sub    $0xc,%esp
  802316:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802319:	53                   	push   %ebx
  80231a:	6a 00                	push   $0x0
  80231c:	e8 c6 ea ff ff       	call   800de7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802321:	89 1c 24             	mov    %ebx,(%esp)
  802324:	e8 15 f3 ff ff       	call   80163e <fd2data>
  802329:	83 c4 08             	add    $0x8,%esp
  80232c:	50                   	push   %eax
  80232d:	6a 00                	push   $0x0
  80232f:	e8 b3 ea ff ff       	call   800de7 <sys_page_unmap>
}
  802334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <_pipeisclosed>:
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	57                   	push   %edi
  80233d:	56                   	push   %esi
  80233e:	53                   	push   %ebx
  80233f:	83 ec 1c             	sub    $0x1c,%esp
  802342:	89 c7                	mov    %eax,%edi
  802344:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802346:	a1 08 50 80 00       	mov    0x805008,%eax
  80234b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80234e:	83 ec 0c             	sub    $0xc,%esp
  802351:	57                   	push   %edi
  802352:	e8 23 05 00 00       	call   80287a <pageref>
  802357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80235a:	89 34 24             	mov    %esi,(%esp)
  80235d:	e8 18 05 00 00       	call   80287a <pageref>
		nn = thisenv->env_runs;
  802362:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802368:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80236b:	83 c4 10             	add    $0x10,%esp
  80236e:	39 cb                	cmp    %ecx,%ebx
  802370:	74 1b                	je     80238d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802372:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802375:	75 cf                	jne    802346 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802377:	8b 42 58             	mov    0x58(%edx),%eax
  80237a:	6a 01                	push   $0x1
  80237c:	50                   	push   %eax
  80237d:	53                   	push   %ebx
  80237e:	68 2b 31 80 00       	push   $0x80312b
  802383:	e8 89 de ff ff       	call   800211 <cprintf>
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	eb b9                	jmp    802346 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80238d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802390:	0f 94 c0             	sete   %al
  802393:	0f b6 c0             	movzbl %al,%eax
}
  802396:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802399:	5b                   	pop    %ebx
  80239a:	5e                   	pop    %esi
  80239b:	5f                   	pop    %edi
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <devpipe_write>:
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 28             	sub    $0x28,%esp
  8023a7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023aa:	56                   	push   %esi
  8023ab:	e8 8e f2 ff ff       	call   80163e <fd2data>
  8023b0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023b2:	83 c4 10             	add    $0x10,%esp
  8023b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023bd:	74 4f                	je     80240e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023bf:	8b 43 04             	mov    0x4(%ebx),%eax
  8023c2:	8b 0b                	mov    (%ebx),%ecx
  8023c4:	8d 51 20             	lea    0x20(%ecx),%edx
  8023c7:	39 d0                	cmp    %edx,%eax
  8023c9:	72 14                	jb     8023df <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023cb:	89 da                	mov    %ebx,%edx
  8023cd:	89 f0                	mov    %esi,%eax
  8023cf:	e8 65 ff ff ff       	call   802339 <_pipeisclosed>
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	75 3b                	jne    802413 <devpipe_write+0x75>
			sys_yield();
  8023d8:	e8 66 e9 ff ff       	call   800d43 <sys_yield>
  8023dd:	eb e0                	jmp    8023bf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023e6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023e9:	89 c2                	mov    %eax,%edx
  8023eb:	c1 fa 1f             	sar    $0x1f,%edx
  8023ee:	89 d1                	mov    %edx,%ecx
  8023f0:	c1 e9 1b             	shr    $0x1b,%ecx
  8023f3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023f6:	83 e2 1f             	and    $0x1f,%edx
  8023f9:	29 ca                	sub    %ecx,%edx
  8023fb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802403:	83 c0 01             	add    $0x1,%eax
  802406:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802409:	83 c7 01             	add    $0x1,%edi
  80240c:	eb ac                	jmp    8023ba <devpipe_write+0x1c>
	return i;
  80240e:	8b 45 10             	mov    0x10(%ebp),%eax
  802411:	eb 05                	jmp    802418 <devpipe_write+0x7a>
				return 0;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    

00802420 <devpipe_read>:
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	57                   	push   %edi
  802424:	56                   	push   %esi
  802425:	53                   	push   %ebx
  802426:	83 ec 18             	sub    $0x18,%esp
  802429:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80242c:	57                   	push   %edi
  80242d:	e8 0c f2 ff ff       	call   80163e <fd2data>
  802432:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	be 00 00 00 00       	mov    $0x0,%esi
  80243c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80243f:	75 14                	jne    802455 <devpipe_read+0x35>
	return i;
  802441:	8b 45 10             	mov    0x10(%ebp),%eax
  802444:	eb 02                	jmp    802448 <devpipe_read+0x28>
				return i;
  802446:	89 f0                	mov    %esi,%eax
}
  802448:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    
			sys_yield();
  802450:	e8 ee e8 ff ff       	call   800d43 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802455:	8b 03                	mov    (%ebx),%eax
  802457:	3b 43 04             	cmp    0x4(%ebx),%eax
  80245a:	75 18                	jne    802474 <devpipe_read+0x54>
			if (i > 0)
  80245c:	85 f6                	test   %esi,%esi
  80245e:	75 e6                	jne    802446 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802460:	89 da                	mov    %ebx,%edx
  802462:	89 f8                	mov    %edi,%eax
  802464:	e8 d0 fe ff ff       	call   802339 <_pipeisclosed>
  802469:	85 c0                	test   %eax,%eax
  80246b:	74 e3                	je     802450 <devpipe_read+0x30>
				return 0;
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
  802472:	eb d4                	jmp    802448 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802474:	99                   	cltd   
  802475:	c1 ea 1b             	shr    $0x1b,%edx
  802478:	01 d0                	add    %edx,%eax
  80247a:	83 e0 1f             	and    $0x1f,%eax
  80247d:	29 d0                	sub    %edx,%eax
  80247f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802487:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80248a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80248d:	83 c6 01             	add    $0x1,%esi
  802490:	eb aa                	jmp    80243c <devpipe_read+0x1c>

00802492 <pipe>:
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	56                   	push   %esi
  802496:	53                   	push   %ebx
  802497:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80249a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249d:	50                   	push   %eax
  80249e:	e8 b2 f1 ff ff       	call   801655 <fd_alloc>
  8024a3:	89 c3                	mov    %eax,%ebx
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	0f 88 23 01 00 00    	js     8025d3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 07 04 00 00       	push   $0x407
  8024b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8024bb:	6a 00                	push   $0x0
  8024bd:	e8 a0 e8 ff ff       	call   800d62 <sys_page_alloc>
  8024c2:	89 c3                	mov    %eax,%ebx
  8024c4:	83 c4 10             	add    $0x10,%esp
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	0f 88 04 01 00 00    	js     8025d3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024d5:	50                   	push   %eax
  8024d6:	e8 7a f1 ff ff       	call   801655 <fd_alloc>
  8024db:	89 c3                	mov    %eax,%ebx
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	0f 88 db 00 00 00    	js     8025c3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e8:	83 ec 04             	sub    $0x4,%esp
  8024eb:	68 07 04 00 00       	push   $0x407
  8024f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f3:	6a 00                	push   $0x0
  8024f5:	e8 68 e8 ff ff       	call   800d62 <sys_page_alloc>
  8024fa:	89 c3                	mov    %eax,%ebx
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	85 c0                	test   %eax,%eax
  802501:	0f 88 bc 00 00 00    	js     8025c3 <pipe+0x131>
	va = fd2data(fd0);
  802507:	83 ec 0c             	sub    $0xc,%esp
  80250a:	ff 75 f4             	pushl  -0xc(%ebp)
  80250d:	e8 2c f1 ff ff       	call   80163e <fd2data>
  802512:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802514:	83 c4 0c             	add    $0xc,%esp
  802517:	68 07 04 00 00       	push   $0x407
  80251c:	50                   	push   %eax
  80251d:	6a 00                	push   $0x0
  80251f:	e8 3e e8 ff ff       	call   800d62 <sys_page_alloc>
  802524:	89 c3                	mov    %eax,%ebx
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	85 c0                	test   %eax,%eax
  80252b:	0f 88 82 00 00 00    	js     8025b3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	ff 75 f0             	pushl  -0x10(%ebp)
  802537:	e8 02 f1 ff ff       	call   80163e <fd2data>
  80253c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802543:	50                   	push   %eax
  802544:	6a 00                	push   $0x0
  802546:	56                   	push   %esi
  802547:	6a 00                	push   $0x0
  802549:	e8 57 e8 ff ff       	call   800da5 <sys_page_map>
  80254e:	89 c3                	mov    %eax,%ebx
  802550:	83 c4 20             	add    $0x20,%esp
  802553:	85 c0                	test   %eax,%eax
  802555:	78 4e                	js     8025a5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802557:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80255c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802564:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80256b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802573:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80257a:	83 ec 0c             	sub    $0xc,%esp
  80257d:	ff 75 f4             	pushl  -0xc(%ebp)
  802580:	e8 a9 f0 ff ff       	call   80162e <fd2num>
  802585:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802588:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80258a:	83 c4 04             	add    $0x4,%esp
  80258d:	ff 75 f0             	pushl  -0x10(%ebp)
  802590:	e8 99 f0 ff ff       	call   80162e <fd2num>
  802595:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802598:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025a3:	eb 2e                	jmp    8025d3 <pipe+0x141>
	sys_page_unmap(0, va);
  8025a5:	83 ec 08             	sub    $0x8,%esp
  8025a8:	56                   	push   %esi
  8025a9:	6a 00                	push   $0x0
  8025ab:	e8 37 e8 ff ff       	call   800de7 <sys_page_unmap>
  8025b0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025b3:	83 ec 08             	sub    $0x8,%esp
  8025b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b9:	6a 00                	push   $0x0
  8025bb:	e8 27 e8 ff ff       	call   800de7 <sys_page_unmap>
  8025c0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025c3:	83 ec 08             	sub    $0x8,%esp
  8025c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c9:	6a 00                	push   $0x0
  8025cb:	e8 17 e8 ff ff       	call   800de7 <sys_page_unmap>
  8025d0:	83 c4 10             	add    $0x10,%esp
}
  8025d3:	89 d8                	mov    %ebx,%eax
  8025d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d8:	5b                   	pop    %ebx
  8025d9:	5e                   	pop    %esi
  8025da:	5d                   	pop    %ebp
  8025db:	c3                   	ret    

008025dc <pipeisclosed>:
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e5:	50                   	push   %eax
  8025e6:	ff 75 08             	pushl  0x8(%ebp)
  8025e9:	e8 b9 f0 ff ff       	call   8016a7 <fd_lookup>
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	78 18                	js     80260d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fb:	e8 3e f0 ff ff       	call   80163e <fd2data>
	return _pipeisclosed(fd, p);
  802600:	89 c2                	mov    %eax,%edx
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	e8 2f fd ff ff       	call   802339 <_pipeisclosed>
  80260a:	83 c4 10             	add    $0x10,%esp
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	c3                   	ret    

00802615 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80261b:	68 43 31 80 00       	push   $0x803143
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	e8 48 e3 ff ff       	call   800970 <strcpy>
	return 0;
}
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <devcons_write>:
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	57                   	push   %edi
  802633:	56                   	push   %esi
  802634:	53                   	push   %ebx
  802635:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80263b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802640:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802646:	3b 75 10             	cmp    0x10(%ebp),%esi
  802649:	73 31                	jae    80267c <devcons_write+0x4d>
		m = n - tot;
  80264b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80264e:	29 f3                	sub    %esi,%ebx
  802650:	83 fb 7f             	cmp    $0x7f,%ebx
  802653:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802658:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	53                   	push   %ebx
  80265f:	89 f0                	mov    %esi,%eax
  802661:	03 45 0c             	add    0xc(%ebp),%eax
  802664:	50                   	push   %eax
  802665:	57                   	push   %edi
  802666:	e8 93 e4 ff ff       	call   800afe <memmove>
		sys_cputs(buf, m);
  80266b:	83 c4 08             	add    $0x8,%esp
  80266e:	53                   	push   %ebx
  80266f:	57                   	push   %edi
  802670:	e8 31 e6 ff ff       	call   800ca6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802675:	01 de                	add    %ebx,%esi
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	eb ca                	jmp    802646 <devcons_write+0x17>
}
  80267c:	89 f0                	mov    %esi,%eax
  80267e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802681:	5b                   	pop    %ebx
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    

00802686 <devcons_read>:
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
  802689:	83 ec 08             	sub    $0x8,%esp
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802691:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802695:	74 21                	je     8026b8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802697:	e8 28 e6 ff ff       	call   800cc4 <sys_cgetc>
  80269c:	85 c0                	test   %eax,%eax
  80269e:	75 07                	jne    8026a7 <devcons_read+0x21>
		sys_yield();
  8026a0:	e8 9e e6 ff ff       	call   800d43 <sys_yield>
  8026a5:	eb f0                	jmp    802697 <devcons_read+0x11>
	if (c < 0)
  8026a7:	78 0f                	js     8026b8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026a9:	83 f8 04             	cmp    $0x4,%eax
  8026ac:	74 0c                	je     8026ba <devcons_read+0x34>
	*(char*)vbuf = c;
  8026ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b1:	88 02                	mov    %al,(%edx)
	return 1;
  8026b3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    
		return 0;
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	eb f7                	jmp    8026b8 <devcons_read+0x32>

008026c1 <cputchar>:
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026cd:	6a 01                	push   $0x1
  8026cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d2:	50                   	push   %eax
  8026d3:	e8 ce e5 ff ff       	call   800ca6 <sys_cputs>
}
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <getchar>:
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026e3:	6a 01                	push   $0x1
  8026e5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026e8:	50                   	push   %eax
  8026e9:	6a 00                	push   $0x0
  8026eb:	e8 27 f2 ff ff       	call   801917 <read>
	if (r < 0)
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	78 06                	js     8026fd <getchar+0x20>
	if (r < 1)
  8026f7:	74 06                	je     8026ff <getchar+0x22>
	return c;
  8026f9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    
		return -E_EOF;
  8026ff:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802704:	eb f7                	jmp    8026fd <getchar+0x20>

00802706 <iscons>:
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80270c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80270f:	50                   	push   %eax
  802710:	ff 75 08             	pushl  0x8(%ebp)
  802713:	e8 8f ef ff ff       	call   8016a7 <fd_lookup>
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	85 c0                	test   %eax,%eax
  80271d:	78 11                	js     802730 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802728:	39 10                	cmp    %edx,(%eax)
  80272a:	0f 94 c0             	sete   %al
  80272d:	0f b6 c0             	movzbl %al,%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <opencons>:
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802738:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273b:	50                   	push   %eax
  80273c:	e8 14 ef ff ff       	call   801655 <fd_alloc>
  802741:	83 c4 10             	add    $0x10,%esp
  802744:	85 c0                	test   %eax,%eax
  802746:	78 3a                	js     802782 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 07 04 00 00       	push   $0x407
  802750:	ff 75 f4             	pushl  -0xc(%ebp)
  802753:	6a 00                	push   $0x0
  802755:	e8 08 e6 ff ff       	call   800d62 <sys_page_alloc>
  80275a:	83 c4 10             	add    $0x10,%esp
  80275d:	85 c0                	test   %eax,%eax
  80275f:	78 21                	js     802782 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80276a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802776:	83 ec 0c             	sub    $0xc,%esp
  802779:	50                   	push   %eax
  80277a:	e8 af ee ff ff       	call   80162e <fd2num>
  80277f:	83 c4 10             	add    $0x10,%esp
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	56                   	push   %esi
  802788:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802789:	a1 08 50 80 00       	mov    0x805008,%eax
  80278e:	8b 40 48             	mov    0x48(%eax),%eax
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 80 31 80 00       	push   $0x803180
  802799:	50                   	push   %eax
  80279a:	68 4f 31 80 00       	push   $0x80314f
  80279f:	e8 6d da ff ff       	call   800211 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8027a4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027a7:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8027ad:	e8 72 e5 ff ff       	call   800d24 <sys_getenvid>
  8027b2:	83 c4 04             	add    $0x4,%esp
  8027b5:	ff 75 0c             	pushl  0xc(%ebp)
  8027b8:	ff 75 08             	pushl  0x8(%ebp)
  8027bb:	56                   	push   %esi
  8027bc:	50                   	push   %eax
  8027bd:	68 5c 31 80 00       	push   $0x80315c
  8027c2:	e8 4a da ff ff       	call   800211 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027c7:	83 c4 18             	add    $0x18,%esp
  8027ca:	53                   	push   %ebx
  8027cb:	ff 75 10             	pushl  0x10(%ebp)
  8027ce:	e8 ed d9 ff ff       	call   8001c0 <vcprintf>
	cprintf("\n");
  8027d3:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  8027da:	e8 32 da ff ff       	call   800211 <cprintf>
  8027df:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027e2:	cc                   	int3   
  8027e3:	eb fd                	jmp    8027e2 <_panic+0x5e>

008027e5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027eb:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027f2:	74 0a                	je     8027fe <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	6a 07                	push   $0x7
  802803:	68 00 f0 bf ee       	push   $0xeebff000
  802808:	6a 00                	push   $0x0
  80280a:	e8 53 e5 ff ff       	call   800d62 <sys_page_alloc>
		if(r < 0)
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	85 c0                	test   %eax,%eax
  802814:	78 2a                	js     802840 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802816:	83 ec 08             	sub    $0x8,%esp
  802819:	68 54 28 80 00       	push   $0x802854
  80281e:	6a 00                	push   $0x0
  802820:	e8 88 e6 ff ff       	call   800ead <sys_env_set_pgfault_upcall>
		if(r < 0)
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	85 c0                	test   %eax,%eax
  80282a:	79 c8                	jns    8027f4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 b8 31 80 00       	push   $0x8031b8
  802834:	6a 25                	push   $0x25
  802836:	68 f4 31 80 00       	push   $0x8031f4
  80283b:	e8 44 ff ff ff       	call   802784 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 88 31 80 00       	push   $0x803188
  802848:	6a 22                	push   $0x22
  80284a:	68 f4 31 80 00       	push   $0x8031f4
  80284f:	e8 30 ff ff ff       	call   802784 <_panic>

00802854 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802854:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802855:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80285a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80285c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80285f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802863:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802867:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80286a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80286c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802870:	83 c4 08             	add    $0x8,%esp
	popal
  802873:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802874:	83 c4 04             	add    $0x4,%esp
	popfl
  802877:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802878:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802879:	c3                   	ret    

0080287a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802880:	89 d0                	mov    %edx,%eax
  802882:	c1 e8 16             	shr    $0x16,%eax
  802885:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802891:	f6 c1 01             	test   $0x1,%cl
  802894:	74 1d                	je     8028b3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802896:	c1 ea 0c             	shr    $0xc,%edx
  802899:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028a0:	f6 c2 01             	test   $0x1,%dl
  8028a3:	74 0e                	je     8028b3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028a5:	c1 ea 0c             	shr    $0xc,%edx
  8028a8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028af:	ef 
  8028b0:	0f b7 c0             	movzwl %ax,%eax
}
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
  8028b5:	66 90                	xchg   %ax,%ax
  8028b7:	66 90                	xchg   %ax,%ax
  8028b9:	66 90                	xchg   %ax,%ax
  8028bb:	66 90                	xchg   %ax,%ax
  8028bd:	66 90                	xchg   %ax,%ax
  8028bf:	90                   	nop

008028c0 <__udivdi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028d7:	85 d2                	test   %edx,%edx
  8028d9:	75 4d                	jne    802928 <__udivdi3+0x68>
  8028db:	39 f3                	cmp    %esi,%ebx
  8028dd:	76 19                	jbe    8028f8 <__udivdi3+0x38>
  8028df:	31 ff                	xor    %edi,%edi
  8028e1:	89 e8                	mov    %ebp,%eax
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	f7 f3                	div    %ebx
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 d9                	mov    %ebx,%ecx
  8028fa:	85 db                	test   %ebx,%ebx
  8028fc:	75 0b                	jne    802909 <__udivdi3+0x49>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 c1                	mov    %eax,%ecx
  802909:	31 d2                	xor    %edx,%edx
  80290b:	89 f0                	mov    %esi,%eax
  80290d:	f7 f1                	div    %ecx
  80290f:	89 c6                	mov    %eax,%esi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f7                	mov    %esi,%edi
  802915:	f7 f1                	div    %ecx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	39 f2                	cmp    %esi,%edx
  80292a:	77 1c                	ja     802948 <__udivdi3+0x88>
  80292c:	0f bd fa             	bsr    %edx,%edi
  80292f:	83 f7 1f             	xor    $0x1f,%edi
  802932:	75 2c                	jne    802960 <__udivdi3+0xa0>
  802934:	39 f2                	cmp    %esi,%edx
  802936:	72 06                	jb     80293e <__udivdi3+0x7e>
  802938:	31 c0                	xor    %eax,%eax
  80293a:	39 eb                	cmp    %ebp,%ebx
  80293c:	77 a9                	ja     8028e7 <__udivdi3+0x27>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	eb a2                	jmp    8028e7 <__udivdi3+0x27>
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	31 ff                	xor    %edi,%edi
  80294a:	31 c0                	xor    %eax,%eax
  80294c:	89 fa                	mov    %edi,%edx
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	89 f9                	mov    %edi,%ecx
  802962:	b8 20 00 00 00       	mov    $0x20,%eax
  802967:	29 f8                	sub    %edi,%eax
  802969:	d3 e2                	shl    %cl,%edx
  80296b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80296f:	89 c1                	mov    %eax,%ecx
  802971:	89 da                	mov    %ebx,%edx
  802973:	d3 ea                	shr    %cl,%edx
  802975:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802979:	09 d1                	or     %edx,%ecx
  80297b:	89 f2                	mov    %esi,%edx
  80297d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802981:	89 f9                	mov    %edi,%ecx
  802983:	d3 e3                	shl    %cl,%ebx
  802985:	89 c1                	mov    %eax,%ecx
  802987:	d3 ea                	shr    %cl,%edx
  802989:	89 f9                	mov    %edi,%ecx
  80298b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80298f:	89 eb                	mov    %ebp,%ebx
  802991:	d3 e6                	shl    %cl,%esi
  802993:	89 c1                	mov    %eax,%ecx
  802995:	d3 eb                	shr    %cl,%ebx
  802997:	09 de                	or     %ebx,%esi
  802999:	89 f0                	mov    %esi,%eax
  80299b:	f7 74 24 08          	divl   0x8(%esp)
  80299f:	89 d6                	mov    %edx,%esi
  8029a1:	89 c3                	mov    %eax,%ebx
  8029a3:	f7 64 24 0c          	mull   0xc(%esp)
  8029a7:	39 d6                	cmp    %edx,%esi
  8029a9:	72 15                	jb     8029c0 <__udivdi3+0x100>
  8029ab:	89 f9                	mov    %edi,%ecx
  8029ad:	d3 e5                	shl    %cl,%ebp
  8029af:	39 c5                	cmp    %eax,%ebp
  8029b1:	73 04                	jae    8029b7 <__udivdi3+0xf7>
  8029b3:	39 d6                	cmp    %edx,%esi
  8029b5:	74 09                	je     8029c0 <__udivdi3+0x100>
  8029b7:	89 d8                	mov    %ebx,%eax
  8029b9:	31 ff                	xor    %edi,%edi
  8029bb:	e9 27 ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029c3:	31 ff                	xor    %edi,%edi
  8029c5:	e9 1d ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__umoddi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029e7:	89 da                	mov    %ebx,%edx
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 43                	jne    802a30 <__umoddi3+0x60>
  8029ed:	39 df                	cmp    %ebx,%edi
  8029ef:	76 17                	jbe    802a08 <__umoddi3+0x38>
  8029f1:	89 f0                	mov    %esi,%eax
  8029f3:	f7 f7                	div    %edi
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	31 d2                	xor    %edx,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 fd                	mov    %edi,%ebp
  802a0a:	85 ff                	test   %edi,%edi
  802a0c:	75 0b                	jne    802a19 <__umoddi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f7                	div    %edi
  802a17:	89 c5                	mov    %eax,%ebp
  802a19:	89 d8                	mov    %ebx,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f5                	div    %ebp
  802a1f:	89 f0                	mov    %esi,%eax
  802a21:	f7 f5                	div    %ebp
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	eb d0                	jmp    8029f7 <__umoddi3+0x27>
  802a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2e:	66 90                	xchg   %ax,%ax
  802a30:	89 f1                	mov    %esi,%ecx
  802a32:	39 d8                	cmp    %ebx,%eax
  802a34:	76 0a                	jbe    802a40 <__umoddi3+0x70>
  802a36:	89 f0                	mov    %esi,%eax
  802a38:	83 c4 1c             	add    $0x1c,%esp
  802a3b:	5b                   	pop    %ebx
  802a3c:	5e                   	pop    %esi
  802a3d:	5f                   	pop    %edi
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
  802a40:	0f bd e8             	bsr    %eax,%ebp
  802a43:	83 f5 1f             	xor    $0x1f,%ebp
  802a46:	75 20                	jne    802a68 <__umoddi3+0x98>
  802a48:	39 d8                	cmp    %ebx,%eax
  802a4a:	0f 82 b0 00 00 00    	jb     802b00 <__umoddi3+0x130>
  802a50:	39 f7                	cmp    %esi,%edi
  802a52:	0f 86 a8 00 00 00    	jbe    802b00 <__umoddi3+0x130>
  802a58:	89 c8                	mov    %ecx,%eax
  802a5a:	83 c4 1c             	add    $0x1c,%esp
  802a5d:	5b                   	pop    %ebx
  802a5e:	5e                   	pop    %esi
  802a5f:	5f                   	pop    %edi
  802a60:	5d                   	pop    %ebp
  802a61:	c3                   	ret    
  802a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a68:	89 e9                	mov    %ebp,%ecx
  802a6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a6f:	29 ea                	sub    %ebp,%edx
  802a71:	d3 e0                	shl    %cl,%eax
  802a73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a77:	89 d1                	mov    %edx,%ecx
  802a79:	89 f8                	mov    %edi,%eax
  802a7b:	d3 e8                	shr    %cl,%eax
  802a7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a89:	09 c1                	or     %eax,%ecx
  802a8b:	89 d8                	mov    %ebx,%eax
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 e9                	mov    %ebp,%ecx
  802a93:	d3 e7                	shl    %cl,%edi
  802a95:	89 d1                	mov    %edx,%ecx
  802a97:	d3 e8                	shr    %cl,%eax
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a9f:	d3 e3                	shl    %cl,%ebx
  802aa1:	89 c7                	mov    %eax,%edi
  802aa3:	89 d1                	mov    %edx,%ecx
  802aa5:	89 f0                	mov    %esi,%eax
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 fa                	mov    %edi,%edx
  802aad:	d3 e6                	shl    %cl,%esi
  802aaf:	09 d8                	or     %ebx,%eax
  802ab1:	f7 74 24 08          	divl   0x8(%esp)
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	89 f3                	mov    %esi,%ebx
  802ab9:	f7 64 24 0c          	mull   0xc(%esp)
  802abd:	89 c6                	mov    %eax,%esi
  802abf:	89 d7                	mov    %edx,%edi
  802ac1:	39 d1                	cmp    %edx,%ecx
  802ac3:	72 06                	jb     802acb <__umoddi3+0xfb>
  802ac5:	75 10                	jne    802ad7 <__umoddi3+0x107>
  802ac7:	39 c3                	cmp    %eax,%ebx
  802ac9:	73 0c                	jae    802ad7 <__umoddi3+0x107>
  802acb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802acf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ad3:	89 d7                	mov    %edx,%edi
  802ad5:	89 c6                	mov    %eax,%esi
  802ad7:	89 ca                	mov    %ecx,%edx
  802ad9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ade:	29 f3                	sub    %esi,%ebx
  802ae0:	19 fa                	sbb    %edi,%edx
  802ae2:	89 d0                	mov    %edx,%eax
  802ae4:	d3 e0                	shl    %cl,%eax
  802ae6:	89 e9                	mov    %ebp,%ecx
  802ae8:	d3 eb                	shr    %cl,%ebx
  802aea:	d3 ea                	shr    %cl,%edx
  802aec:	09 d8                	or     %ebx,%eax
  802aee:	83 c4 1c             	add    $0x1c,%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
  802af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afd:	8d 76 00             	lea    0x0(%esi),%esi
  802b00:	89 da                	mov    %ebx,%edx
  802b02:	29 fe                	sub    %edi,%esi
  802b04:	19 c2                	sbb    %eax,%edx
  802b06:	89 f1                	mov    %esi,%ecx
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	e9 4b ff ff ff       	jmp    802a5a <__umoddi3+0x8a>
