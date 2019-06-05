
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
  80003c:	e8 4b 12 00 00       	call   80128c <fork>
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
  800053:	e8 c6 14 00 00       	call   80151e <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 c2 0c 00 00       	call   800d24 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 16 2b 80 00       	push   $0x802b16
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
  800082:	e8 00 15 00 00       	call   801587 <ipc_send>
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
  8000a3:	68 00 2b 80 00       	push   $0x802b00
  8000a8:	e8 64 01 00 00       	call   800211 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 cc 14 00 00       	call   801587 <ipc_send>
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

	cprintf("in libmain.c call umain!\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 29 2b 80 00       	push   $0x802b29
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
  800168:	e8 85 16 00 00       	call   8017f2 <close_all>
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
  8002be:	e8 ed 25 00 00       	call   8028b0 <__udivdi3>
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
  8002e7:	e8 d4 26 00 00       	call   8029c0 <__umoddi3>
  8002ec:	83 c4 14             	add    $0x14,%esp
  8002ef:	0f be 80 4d 2b 80 00 	movsbl 0x802b4d(%eax),%eax
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
  800398:	ff 24 85 20 2d 80 00 	jmp    *0x802d20(,%eax,4)
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
  800463:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  80046a:	85 d2                	test   %edx,%edx
  80046c:	74 18                	je     800486 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80046e:	52                   	push   %edx
  80046f:	68 a9 30 80 00       	push   $0x8030a9
  800474:	53                   	push   %ebx
  800475:	56                   	push   %esi
  800476:	e8 a6 fe ff ff       	call   800321 <printfmt>
  80047b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800481:	e9 fe 02 00 00       	jmp    800784 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800486:	50                   	push   %eax
  800487:	68 65 2b 80 00       	push   $0x802b65
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
  8004ae:	b8 5e 2b 80 00       	mov    $0x802b5e,%eax
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
  800846:	bf 81 2c 80 00       	mov    $0x802c81,%edi
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
  800872:	bf b9 2c 80 00       	mov    $0x802cb9,%edi
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
  800d13:	68 c4 2e 80 00       	push   $0x802ec4
  800d18:	6a 43                	push   $0x43
  800d1a:	68 e1 2e 80 00       	push   $0x802ee1
  800d1f:	e8 4c 1a 00 00       	call   802770 <_panic>

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
  800d94:	68 c4 2e 80 00       	push   $0x802ec4
  800d99:	6a 43                	push   $0x43
  800d9b:	68 e1 2e 80 00       	push   $0x802ee1
  800da0:	e8 cb 19 00 00       	call   802770 <_panic>

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
  800dd6:	68 c4 2e 80 00       	push   $0x802ec4
  800ddb:	6a 43                	push   $0x43
  800ddd:	68 e1 2e 80 00       	push   $0x802ee1
  800de2:	e8 89 19 00 00       	call   802770 <_panic>

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
  800e18:	68 c4 2e 80 00       	push   $0x802ec4
  800e1d:	6a 43                	push   $0x43
  800e1f:	68 e1 2e 80 00       	push   $0x802ee1
  800e24:	e8 47 19 00 00       	call   802770 <_panic>

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
  800e5a:	68 c4 2e 80 00       	push   $0x802ec4
  800e5f:	6a 43                	push   $0x43
  800e61:	68 e1 2e 80 00       	push   $0x802ee1
  800e66:	e8 05 19 00 00       	call   802770 <_panic>

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
  800e9c:	68 c4 2e 80 00       	push   $0x802ec4
  800ea1:	6a 43                	push   $0x43
  800ea3:	68 e1 2e 80 00       	push   $0x802ee1
  800ea8:	e8 c3 18 00 00       	call   802770 <_panic>

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
  800ede:	68 c4 2e 80 00       	push   $0x802ec4
  800ee3:	6a 43                	push   $0x43
  800ee5:	68 e1 2e 80 00       	push   $0x802ee1
  800eea:	e8 81 18 00 00       	call   802770 <_panic>

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
  800f42:	68 c4 2e 80 00       	push   $0x802ec4
  800f47:	6a 43                	push   $0x43
  800f49:	68 e1 2e 80 00       	push   $0x802ee1
  800f4e:	e8 1d 18 00 00       	call   802770 <_panic>

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
  801026:	68 c4 2e 80 00       	push   $0x802ec4
  80102b:	6a 43                	push   $0x43
  80102d:	68 e1 2e 80 00       	push   $0x802ee1
  801032:	e8 39 17 00 00       	call   802770 <_panic>

00801037 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	53                   	push   %ebx
  80103b:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80103e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801045:	f6 c5 04             	test   $0x4,%ch
  801048:	75 45                	jne    80108f <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80104a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801051:	83 e1 07             	and    $0x7,%ecx
  801054:	83 f9 07             	cmp    $0x7,%ecx
  801057:	74 6f                	je     8010c8 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801059:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801060:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801066:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80106c:	0f 84 b6 00 00 00    	je     801128 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801072:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801079:	83 e1 05             	and    $0x5,%ecx
  80107c:	83 f9 05             	cmp    $0x5,%ecx
  80107f:	0f 84 d7 00 00 00    	je     80115c <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
  80108a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80108f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801096:	c1 e2 0c             	shl    $0xc,%edx
  801099:	83 ec 0c             	sub    $0xc,%esp
  80109c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010a2:	51                   	push   %ecx
  8010a3:	52                   	push   %edx
  8010a4:	50                   	push   %eax
  8010a5:	52                   	push   %edx
  8010a6:	6a 00                	push   $0x0
  8010a8:	e8 f8 fc ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  8010ad:	83 c4 20             	add    $0x20,%esp
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	79 d1                	jns    801085 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010b4:	83 ec 04             	sub    $0x4,%esp
  8010b7:	68 ef 2e 80 00       	push   $0x802eef
  8010bc:	6a 54                	push   $0x54
  8010be:	68 05 2f 80 00       	push   $0x802f05
  8010c3:	e8 a8 16 00 00       	call   802770 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010c8:	89 d3                	mov    %edx,%ebx
  8010ca:	c1 e3 0c             	shl    $0xc,%ebx
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	68 05 08 00 00       	push   $0x805
  8010d5:	53                   	push   %ebx
  8010d6:	50                   	push   %eax
  8010d7:	53                   	push   %ebx
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 c6 fc ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  8010df:	83 c4 20             	add    $0x20,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	78 2e                	js     801114 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 05 08 00 00       	push   $0x805
  8010ee:	53                   	push   %ebx
  8010ef:	6a 00                	push   $0x0
  8010f1:	53                   	push   %ebx
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 ac fc ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  8010f9:	83 c4 20             	add    $0x20,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	79 85                	jns    801085 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	68 ef 2e 80 00       	push   $0x802eef
  801108:	6a 5f                	push   $0x5f
  80110a:	68 05 2f 80 00       	push   $0x802f05
  80110f:	e8 5c 16 00 00       	call   802770 <_panic>
			panic("sys_page_map() panic\n");
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	68 ef 2e 80 00       	push   $0x802eef
  80111c:	6a 5b                	push   $0x5b
  80111e:	68 05 2f 80 00       	push   $0x802f05
  801123:	e8 48 16 00 00       	call   802770 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801128:	c1 e2 0c             	shl    $0xc,%edx
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	68 05 08 00 00       	push   $0x805
  801133:	52                   	push   %edx
  801134:	50                   	push   %eax
  801135:	52                   	push   %edx
  801136:	6a 00                	push   $0x0
  801138:	e8 68 fc ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  80113d:	83 c4 20             	add    $0x20,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	0f 89 3d ff ff ff    	jns    801085 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801148:	83 ec 04             	sub    $0x4,%esp
  80114b:	68 ef 2e 80 00       	push   $0x802eef
  801150:	6a 66                	push   $0x66
  801152:	68 05 2f 80 00       	push   $0x802f05
  801157:	e8 14 16 00 00       	call   802770 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115c:	c1 e2 0c             	shl    $0xc,%edx
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	6a 05                	push   $0x5
  801164:	52                   	push   %edx
  801165:	50                   	push   %eax
  801166:	52                   	push   %edx
  801167:	6a 00                	push   $0x0
  801169:	e8 37 fc ff ff       	call   800da5 <sys_page_map>
		if(r < 0)
  80116e:	83 c4 20             	add    $0x20,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	0f 89 0c ff ff ff    	jns    801085 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	68 ef 2e 80 00       	push   $0x802eef
  801181:	6a 6d                	push   $0x6d
  801183:	68 05 2f 80 00       	push   $0x802f05
  801188:	e8 e3 15 00 00       	call   802770 <_panic>

0080118d <pgfault>:
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	53                   	push   %ebx
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801197:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801199:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80119d:	0f 84 99 00 00 00    	je     80123c <pgfault+0xaf>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	c1 ea 16             	shr    $0x16,%edx
  8011a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011af:	f6 c2 01             	test   $0x1,%dl
  8011b2:	0f 84 84 00 00 00    	je     80123c <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	c1 ea 0c             	shr    $0xc,%edx
  8011bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c4:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ca:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011d0:	75 6a                	jne    80123c <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d7:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	6a 07                	push   $0x7
  8011de:	68 00 f0 7f 00       	push   $0x7ff000
  8011e3:	6a 00                	push   $0x0
  8011e5:	e8 78 fb ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	78 5f                	js     801250 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	68 00 10 00 00       	push   $0x1000
  8011f9:	53                   	push   %ebx
  8011fa:	68 00 f0 7f 00       	push   $0x7ff000
  8011ff:	e8 5c f9 ff ff       	call   800b60 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801204:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80120b:	53                   	push   %ebx
  80120c:	6a 00                	push   $0x0
  80120e:	68 00 f0 7f 00       	push   $0x7ff000
  801213:	6a 00                	push   $0x0
  801215:	e8 8b fb ff ff       	call   800da5 <sys_page_map>
	if(ret < 0)
  80121a:	83 c4 20             	add    $0x20,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 43                	js     801264 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	68 00 f0 7f 00       	push   $0x7ff000
  801229:	6a 00                	push   $0x0
  80122b:	e8 b7 fb ff ff       	call   800de7 <sys_page_unmap>
	if(ret < 0)
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 41                	js     801278 <pgfault+0xeb>
}
  801237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    
		panic("panic at pgfault()\n");
  80123c:	83 ec 04             	sub    $0x4,%esp
  80123f:	68 10 2f 80 00       	push   $0x802f10
  801244:	6a 26                	push   $0x26
  801246:	68 05 2f 80 00       	push   $0x802f05
  80124b:	e8 20 15 00 00       	call   802770 <_panic>
		panic("panic in sys_page_alloc()\n");
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	68 24 2f 80 00       	push   $0x802f24
  801258:	6a 31                	push   $0x31
  80125a:	68 05 2f 80 00       	push   $0x802f05
  80125f:	e8 0c 15 00 00       	call   802770 <_panic>
		panic("panic in sys_page_map()\n");
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	68 3f 2f 80 00       	push   $0x802f3f
  80126c:	6a 36                	push   $0x36
  80126e:	68 05 2f 80 00       	push   $0x802f05
  801273:	e8 f8 14 00 00       	call   802770 <_panic>
		panic("panic in sys_page_unmap()\n");
  801278:	83 ec 04             	sub    $0x4,%esp
  80127b:	68 58 2f 80 00       	push   $0x802f58
  801280:	6a 39                	push   $0x39
  801282:	68 05 2f 80 00       	push   $0x802f05
  801287:	e8 e4 14 00 00       	call   802770 <_panic>

0080128c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
  801292:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801295:	68 8d 11 80 00       	push   $0x80118d
  80129a:	e8 32 15 00 00       	call   8027d1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80129f:	b8 07 00 00 00       	mov    $0x7,%eax
  8012a4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 27                	js     8012d4 <fork+0x48>
  8012ad:	89 c6                	mov    %eax,%esi
  8012af:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012b1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012b6:	75 48                	jne    801300 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012b8:	e8 67 fa ff ff       	call   800d24 <sys_getenvid>
  8012bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012c2:	c1 e0 07             	shl    $0x7,%eax
  8012c5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ca:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012cf:	e9 90 00 00 00       	jmp    801364 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	68 74 2f 80 00       	push   $0x802f74
  8012dc:	68 8c 00 00 00       	push   $0x8c
  8012e1:	68 05 2f 80 00       	push   $0x802f05
  8012e6:	e8 85 14 00 00       	call   802770 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012eb:	89 f8                	mov    %edi,%eax
  8012ed:	e8 45 fd ff ff       	call   801037 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012f8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012fe:	74 26                	je     801326 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801300:	89 d8                	mov    %ebx,%eax
  801302:	c1 e8 16             	shr    $0x16,%eax
  801305:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80130c:	a8 01                	test   $0x1,%al
  80130e:	74 e2                	je     8012f2 <fork+0x66>
  801310:	89 da                	mov    %ebx,%edx
  801312:	c1 ea 0c             	shr    $0xc,%edx
  801315:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80131c:	83 e0 05             	and    $0x5,%eax
  80131f:	83 f8 05             	cmp    $0x5,%eax
  801322:	75 ce                	jne    8012f2 <fork+0x66>
  801324:	eb c5                	jmp    8012eb <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	6a 07                	push   $0x7
  80132b:	68 00 f0 bf ee       	push   $0xeebff000
  801330:	56                   	push   %esi
  801331:	e8 2c fa ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 31                	js     80136e <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	68 40 28 80 00       	push   $0x802840
  801345:	56                   	push   %esi
  801346:	e8 62 fb ff ff       	call   800ead <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 33                	js     801385 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	6a 02                	push   $0x2
  801357:	56                   	push   %esi
  801358:	e8 cc fa ff ff       	call   800e29 <sys_env_set_status>
	if(ret < 0)
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 38                	js     80139c <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801364:	89 f0                	mov    %esi,%eax
  801366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5f                   	pop    %edi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 24 2f 80 00       	push   $0x802f24
  801376:	68 98 00 00 00       	push   $0x98
  80137b:	68 05 2f 80 00       	push   $0x802f05
  801380:	e8 eb 13 00 00       	call   802770 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 98 2f 80 00       	push   $0x802f98
  80138d:	68 9b 00 00 00       	push   $0x9b
  801392:	68 05 2f 80 00       	push   $0x802f05
  801397:	e8 d4 13 00 00       	call   802770 <_panic>
		panic("panic in sys_env_set_status()\n");
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 c0 2f 80 00       	push   $0x802fc0
  8013a4:	68 9e 00 00 00       	push   $0x9e
  8013a9:	68 05 2f 80 00       	push   $0x802f05
  8013ae:	e8 bd 13 00 00       	call   802770 <_panic>

008013b3 <sfork>:

// Challenge!
int
sfork(void)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013bc:	68 8d 11 80 00       	push   $0x80118d
  8013c1:	e8 0b 14 00 00       	call   8027d1 <set_pgfault_handler>
  8013c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8013cb:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 27                	js     8013fb <sfork+0x48>
  8013d4:	89 c7                	mov    %eax,%edi
  8013d6:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013d8:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013dd:	75 55                	jne    801434 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013df:	e8 40 f9 ff ff       	call   800d24 <sys_getenvid>
  8013e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013e9:	c1 e0 07             	shl    $0x7,%eax
  8013ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013f1:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013f6:	e9 d4 00 00 00       	jmp    8014cf <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 74 2f 80 00       	push   $0x802f74
  801403:	68 af 00 00 00       	push   $0xaf
  801408:	68 05 2f 80 00       	push   $0x802f05
  80140d:	e8 5e 13 00 00       	call   802770 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801412:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801417:	89 f0                	mov    %esi,%eax
  801419:	e8 19 fc ff ff       	call   801037 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801424:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80142a:	77 65                	ja     801491 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80142c:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801432:	74 de                	je     801412 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801434:	89 d8                	mov    %ebx,%eax
  801436:	c1 e8 16             	shr    $0x16,%eax
  801439:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801440:	a8 01                	test   $0x1,%al
  801442:	74 da                	je     80141e <sfork+0x6b>
  801444:	89 da                	mov    %ebx,%edx
  801446:	c1 ea 0c             	shr    $0xc,%edx
  801449:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801450:	83 e0 05             	and    $0x5,%eax
  801453:	83 f8 05             	cmp    $0x5,%eax
  801456:	75 c6                	jne    80141e <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801458:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80145f:	c1 e2 0c             	shl    $0xc,%edx
  801462:	83 ec 0c             	sub    $0xc,%esp
  801465:	83 e0 07             	and    $0x7,%eax
  801468:	50                   	push   %eax
  801469:	52                   	push   %edx
  80146a:	56                   	push   %esi
  80146b:	52                   	push   %edx
  80146c:	6a 00                	push   $0x0
  80146e:	e8 32 f9 ff ff       	call   800da5 <sys_page_map>
  801473:	83 c4 20             	add    $0x20,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	74 a4                	je     80141e <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	68 ef 2e 80 00       	push   $0x802eef
  801482:	68 ba 00 00 00       	push   $0xba
  801487:	68 05 2f 80 00       	push   $0x802f05
  80148c:	e8 df 12 00 00       	call   802770 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	6a 07                	push   $0x7
  801496:	68 00 f0 bf ee       	push   $0xeebff000
  80149b:	57                   	push   %edi
  80149c:	e8 c1 f8 ff ff       	call   800d62 <sys_page_alloc>
	if(ret < 0)
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 31                	js     8014d9 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	68 40 28 80 00       	push   $0x802840
  8014b0:	57                   	push   %edi
  8014b1:	e8 f7 f9 ff ff       	call   800ead <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 33                	js     8014f0 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	6a 02                	push   $0x2
  8014c2:	57                   	push   %edi
  8014c3:	e8 61 f9 ff ff       	call   800e29 <sys_env_set_status>
	if(ret < 0)
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 38                	js     801507 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014cf:	89 f8                	mov    %edi,%eax
  8014d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5f                   	pop    %edi
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	68 24 2f 80 00       	push   $0x802f24
  8014e1:	68 c0 00 00 00       	push   $0xc0
  8014e6:	68 05 2f 80 00       	push   $0x802f05
  8014eb:	e8 80 12 00 00       	call   802770 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	68 98 2f 80 00       	push   $0x802f98
  8014f8:	68 c3 00 00 00       	push   $0xc3
  8014fd:	68 05 2f 80 00       	push   $0x802f05
  801502:	e8 69 12 00 00       	call   802770 <_panic>
		panic("panic in sys_env_set_status()\n");
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	68 c0 2f 80 00       	push   $0x802fc0
  80150f:	68 c6 00 00 00       	push   $0xc6
  801514:	68 05 2f 80 00       	push   $0x802f05
  801519:	e8 52 12 00 00       	call   802770 <_panic>

0080151e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	56                   	push   %esi
  801522:	53                   	push   %ebx
  801523:	8b 75 08             	mov    0x8(%ebp),%esi
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80152c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80152e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801533:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	50                   	push   %eax
  80153a:	e8 d3 f9 ff ff       	call   800f12 <sys_ipc_recv>
	if(ret < 0){
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	78 2b                	js     801571 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801546:	85 f6                	test   %esi,%esi
  801548:	74 0a                	je     801554 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80154a:	a1 08 50 80 00       	mov    0x805008,%eax
  80154f:	8b 40 74             	mov    0x74(%eax),%eax
  801552:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801554:	85 db                	test   %ebx,%ebx
  801556:	74 0a                	je     801562 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801558:	a1 08 50 80 00       	mov    0x805008,%eax
  80155d:	8b 40 78             	mov    0x78(%eax),%eax
  801560:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801562:	a1 08 50 80 00       	mov    0x805008,%eax
  801567:	8b 40 70             	mov    0x70(%eax),%eax
}
  80156a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    
		if(from_env_store)
  801571:	85 f6                	test   %esi,%esi
  801573:	74 06                	je     80157b <ipc_recv+0x5d>
			*from_env_store = 0;
  801575:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80157b:	85 db                	test   %ebx,%ebx
  80157d:	74 eb                	je     80156a <ipc_recv+0x4c>
			*perm_store = 0;
  80157f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801585:	eb e3                	jmp    80156a <ipc_recv+0x4c>

00801587 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	57                   	push   %edi
  80158b:	56                   	push   %esi
  80158c:	53                   	push   %ebx
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	8b 7d 08             	mov    0x8(%ebp),%edi
  801593:	8b 75 0c             	mov    0xc(%ebp),%esi
  801596:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801599:	85 db                	test   %ebx,%ebx
  80159b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015a0:	0f 44 d8             	cmove  %eax,%ebx
  8015a3:	eb 05                	jmp    8015aa <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015a5:	e8 99 f7 ff ff       	call   800d43 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015aa:	ff 75 14             	pushl  0x14(%ebp)
  8015ad:	53                   	push   %ebx
  8015ae:	56                   	push   %esi
  8015af:	57                   	push   %edi
  8015b0:	e8 3a f9 ff ff       	call   800eef <sys_ipc_try_send>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	74 1b                	je     8015d7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015bc:	79 e7                	jns    8015a5 <ipc_send+0x1e>
  8015be:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015c1:	74 e2                	je     8015a5 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	68 df 2f 80 00       	push   $0x802fdf
  8015cb:	6a 48                	push   $0x48
  8015cd:	68 f4 2f 80 00       	push   $0x802ff4
  8015d2:	e8 99 11 00 00       	call   802770 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015da:	5b                   	pop    %ebx
  8015db:	5e                   	pop    %esi
  8015dc:	5f                   	pop    %edi
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	c1 e2 07             	shl    $0x7,%edx
  8015ef:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015f5:	8b 52 50             	mov    0x50(%edx),%edx
  8015f8:	39 ca                	cmp    %ecx,%edx
  8015fa:	74 11                	je     80160d <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8015fc:	83 c0 01             	add    $0x1,%eax
  8015ff:	3d 00 04 00 00       	cmp    $0x400,%eax
  801604:	75 e4                	jne    8015ea <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 0b                	jmp    801618 <ipc_find_env+0x39>
			return envs[i].env_id;
  80160d:	c1 e0 07             	shl    $0x7,%eax
  801610:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801615:	8b 40 48             	mov    0x48(%eax),%eax
}
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	05 00 00 00 30       	add    $0x30000000,%eax
  801625:	c1 e8 0c             	shr    $0xc,%eax
}
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801635:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80163a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 ea 16             	shr    $0x16,%edx
  80164e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 2d                	je     801687 <fd_alloc+0x46>
  80165a:	89 c2                	mov    %eax,%edx
  80165c:	c1 ea 0c             	shr    $0xc,%edx
  80165f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801666:	f6 c2 01             	test   $0x1,%dl
  801669:	74 1c                	je     801687 <fd_alloc+0x46>
  80166b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801670:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801675:	75 d2                	jne    801649 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801680:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801685:	eb 0a                	jmp    801691 <fd_alloc+0x50>
			*fd_store = fd;
  801687:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801699:	83 f8 1f             	cmp    $0x1f,%eax
  80169c:	77 30                	ja     8016ce <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80169e:	c1 e0 0c             	shl    $0xc,%eax
  8016a1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016a6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016ac:	f6 c2 01             	test   $0x1,%dl
  8016af:	74 24                	je     8016d5 <fd_lookup+0x42>
  8016b1:	89 c2                	mov    %eax,%edx
  8016b3:	c1 ea 0c             	shr    $0xc,%edx
  8016b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016bd:	f6 c2 01             	test   $0x1,%dl
  8016c0:	74 1a                	je     8016dc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c5:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
		return -E_INVAL;
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb f7                	jmp    8016cc <fd_lookup+0x39>
		return -E_INVAL;
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016da:	eb f0                	jmp    8016cc <fd_lookup+0x39>
  8016dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e1:	eb e9                	jmp    8016cc <fd_lookup+0x39>

008016e3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016f6:	39 08                	cmp    %ecx,(%eax)
  8016f8:	74 38                	je     801732 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016fa:	83 c2 01             	add    $0x1,%edx
  8016fd:	8b 04 95 7c 30 80 00 	mov    0x80307c(,%edx,4),%eax
  801704:	85 c0                	test   %eax,%eax
  801706:	75 ee                	jne    8016f6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801708:	a1 08 50 80 00       	mov    0x805008,%eax
  80170d:	8b 40 48             	mov    0x48(%eax),%eax
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	51                   	push   %ecx
  801714:	50                   	push   %eax
  801715:	68 00 30 80 00       	push   $0x803000
  80171a:	e8 f2 ea ff ff       	call   800211 <cprintf>
	*dev = 0;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    
			*dev = devtab[i];
  801732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801735:	89 01                	mov    %eax,(%ecx)
			return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb f2                	jmp    801730 <dev_lookup+0x4d>

0080173e <fd_close>:
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 24             	sub    $0x24,%esp
  801747:	8b 75 08             	mov    0x8(%ebp),%esi
  80174a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80174d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801750:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801751:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801757:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80175a:	50                   	push   %eax
  80175b:	e8 33 ff ff ff       	call   801693 <fd_lookup>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	78 05                	js     80176e <fd_close+0x30>
	    || fd != fd2)
  801769:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80176c:	74 16                	je     801784 <fd_close+0x46>
		return (must_exist ? r : 0);
  80176e:	89 f8                	mov    %edi,%eax
  801770:	84 c0                	test   %al,%al
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
  801777:	0f 44 d8             	cmove  %eax,%ebx
}
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5f                   	pop    %edi
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	ff 36                	pushl  (%esi)
  80178d:	e8 51 ff ff ff       	call   8016e3 <dev_lookup>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	78 1a                	js     8017b5 <fd_close+0x77>
		if (dev->dev_close)
  80179b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	74 0b                	je     8017b5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	56                   	push   %esi
  8017ae:	ff d0                	call   *%eax
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	56                   	push   %esi
  8017b9:	6a 00                	push   $0x0
  8017bb:	e8 27 f6 ff ff       	call   800de7 <sys_page_unmap>
	return r;
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	eb b5                	jmp    80177a <fd_close+0x3c>

008017c5 <close>:

int
close(int fdnum)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	e8 bc fe ff ff       	call   801693 <fd_lookup>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	79 02                	jns    8017e0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    
		return fd_close(fd, 1);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	6a 01                	push   $0x1
  8017e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e8:	e8 51 ff ff ff       	call   80173e <fd_close>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	eb ec                	jmp    8017de <close+0x19>

008017f2 <close_all>:

void
close_all(void)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	53                   	push   %ebx
  801802:	e8 be ff ff ff       	call   8017c5 <close>
	for (i = 0; i < MAXFD; i++)
  801807:	83 c3 01             	add    $0x1,%ebx
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	83 fb 20             	cmp    $0x20,%ebx
  801810:	75 ec                	jne    8017fe <close_all+0xc>
}
  801812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	57                   	push   %edi
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
  80181d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801820:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801823:	50                   	push   %eax
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	e8 67 fe ff ff       	call   801693 <fd_lookup>
  80182c:	89 c3                	mov    %eax,%ebx
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	85 c0                	test   %eax,%eax
  801833:	0f 88 81 00 00 00    	js     8018ba <dup+0xa3>
		return r;
	close(newfdnum);
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	e8 81 ff ff ff       	call   8017c5 <close>

	newfd = INDEX2FD(newfdnum);
  801844:	8b 75 0c             	mov    0xc(%ebp),%esi
  801847:	c1 e6 0c             	shl    $0xc,%esi
  80184a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801850:	83 c4 04             	add    $0x4,%esp
  801853:	ff 75 e4             	pushl  -0x1c(%ebp)
  801856:	e8 cf fd ff ff       	call   80162a <fd2data>
  80185b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80185d:	89 34 24             	mov    %esi,(%esp)
  801860:	e8 c5 fd ff ff       	call   80162a <fd2data>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80186a:	89 d8                	mov    %ebx,%eax
  80186c:	c1 e8 16             	shr    $0x16,%eax
  80186f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801876:	a8 01                	test   $0x1,%al
  801878:	74 11                	je     80188b <dup+0x74>
  80187a:	89 d8                	mov    %ebx,%eax
  80187c:	c1 e8 0c             	shr    $0xc,%eax
  80187f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801886:	f6 c2 01             	test   $0x1,%dl
  801889:	75 39                	jne    8018c4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80188b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80188e:	89 d0                	mov    %edx,%eax
  801890:	c1 e8 0c             	shr    $0xc,%eax
  801893:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80189a:	83 ec 0c             	sub    $0xc,%esp
  80189d:	25 07 0e 00 00       	and    $0xe07,%eax
  8018a2:	50                   	push   %eax
  8018a3:	56                   	push   %esi
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	6a 00                	push   $0x0
  8018a9:	e8 f7 f4 ff ff       	call   800da5 <sys_page_map>
  8018ae:	89 c3                	mov    %eax,%ebx
  8018b0:	83 c4 20             	add    $0x20,%esp
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	78 31                	js     8018e8 <dup+0xd1>
		goto err;

	return newfdnum;
  8018b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018ba:	89 d8                	mov    %ebx,%eax
  8018bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d3:	50                   	push   %eax
  8018d4:	57                   	push   %edi
  8018d5:	6a 00                	push   $0x0
  8018d7:	53                   	push   %ebx
  8018d8:	6a 00                	push   $0x0
  8018da:	e8 c6 f4 ff ff       	call   800da5 <sys_page_map>
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	83 c4 20             	add    $0x20,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	79 a3                	jns    80188b <dup+0x74>
	sys_page_unmap(0, newfd);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	56                   	push   %esi
  8018ec:	6a 00                	push   $0x0
  8018ee:	e8 f4 f4 ff ff       	call   800de7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018f3:	83 c4 08             	add    $0x8,%esp
  8018f6:	57                   	push   %edi
  8018f7:	6a 00                	push   $0x0
  8018f9:	e8 e9 f4 ff ff       	call   800de7 <sys_page_unmap>
	return r;
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	eb b7                	jmp    8018ba <dup+0xa3>

00801903 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	53                   	push   %ebx
  801907:	83 ec 1c             	sub    $0x1c,%esp
  80190a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801910:	50                   	push   %eax
  801911:	53                   	push   %ebx
  801912:	e8 7c fd ff ff       	call   801693 <fd_lookup>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 3f                	js     80195d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801928:	ff 30                	pushl  (%eax)
  80192a:	e8 b4 fd ff ff       	call   8016e3 <dev_lookup>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 27                	js     80195d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801936:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801939:	8b 42 08             	mov    0x8(%edx),%eax
  80193c:	83 e0 03             	and    $0x3,%eax
  80193f:	83 f8 01             	cmp    $0x1,%eax
  801942:	74 1e                	je     801962 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	8b 40 08             	mov    0x8(%eax),%eax
  80194a:	85 c0                	test   %eax,%eax
  80194c:	74 35                	je     801983 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	52                   	push   %edx
  801958:	ff d0                	call   *%eax
  80195a:	83 c4 10             	add    $0x10,%esp
}
  80195d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801960:	c9                   	leave  
  801961:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801962:	a1 08 50 80 00       	mov    0x805008,%eax
  801967:	8b 40 48             	mov    0x48(%eax),%eax
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	53                   	push   %ebx
  80196e:	50                   	push   %eax
  80196f:	68 41 30 80 00       	push   $0x803041
  801974:	e8 98 e8 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801981:	eb da                	jmp    80195d <read+0x5a>
		return -E_NOT_SUPP;
  801983:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801988:	eb d3                	jmp    80195d <read+0x5a>

0080198a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	8b 7d 08             	mov    0x8(%ebp),%edi
  801996:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801999:	bb 00 00 00 00       	mov    $0x0,%ebx
  80199e:	39 f3                	cmp    %esi,%ebx
  8019a0:	73 23                	jae    8019c5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	89 f0                	mov    %esi,%eax
  8019a7:	29 d8                	sub    %ebx,%eax
  8019a9:	50                   	push   %eax
  8019aa:	89 d8                	mov    %ebx,%eax
  8019ac:	03 45 0c             	add    0xc(%ebp),%eax
  8019af:	50                   	push   %eax
  8019b0:	57                   	push   %edi
  8019b1:	e8 4d ff ff ff       	call   801903 <read>
		if (m < 0)
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	78 06                	js     8019c3 <readn+0x39>
			return m;
		if (m == 0)
  8019bd:	74 06                	je     8019c5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019bf:	01 c3                	add    %eax,%ebx
  8019c1:	eb db                	jmp    80199e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019c5:	89 d8                	mov    %ebx,%eax
  8019c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5f                   	pop    %edi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    

008019cf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	53                   	push   %ebx
  8019d3:	83 ec 1c             	sub    $0x1c,%esp
  8019d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019dc:	50                   	push   %eax
  8019dd:	53                   	push   %ebx
  8019de:	e8 b0 fc ff ff       	call   801693 <fd_lookup>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 3a                	js     801a24 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f0:	50                   	push   %eax
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	ff 30                	pushl  (%eax)
  8019f6:	e8 e8 fc ff ff       	call   8016e3 <dev_lookup>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 22                	js     801a24 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a05:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a09:	74 1e                	je     801a29 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	74 35                	je     801a4a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	ff 75 10             	pushl  0x10(%ebp)
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	ff d2                	call   *%edx
  801a21:	83 c4 10             	add    $0x10,%esp
}
  801a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a29:	a1 08 50 80 00       	mov    0x805008,%eax
  801a2e:	8b 40 48             	mov    0x48(%eax),%eax
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	53                   	push   %ebx
  801a35:	50                   	push   %eax
  801a36:	68 5d 30 80 00       	push   $0x80305d
  801a3b:	e8 d1 e7 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a48:	eb da                	jmp    801a24 <write+0x55>
		return -E_NOT_SUPP;
  801a4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4f:	eb d3                	jmp    801a24 <write+0x55>

00801a51 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5a:	50                   	push   %eax
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	e8 30 fc ff ff       	call   801693 <fd_lookup>
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 0e                	js     801a78 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 1c             	sub    $0x1c,%esp
  801a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	53                   	push   %ebx
  801a89:	e8 05 fc ff ff       	call   801693 <fd_lookup>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 37                	js     801acc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	ff 30                	pushl  (%eax)
  801aa1:	e8 3d fc ff ff       	call   8016e3 <dev_lookup>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 1f                	js     801acc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab4:	74 1b                	je     801ad1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab9:	8b 52 18             	mov    0x18(%edx),%edx
  801abc:	85 d2                	test   %edx,%edx
  801abe:	74 32                	je     801af2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	50                   	push   %eax
  801ac7:	ff d2                	call   *%edx
  801ac9:	83 c4 10             	add    $0x10,%esp
}
  801acc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ad1:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ad6:	8b 40 48             	mov    0x48(%eax),%eax
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	53                   	push   %ebx
  801add:	50                   	push   %eax
  801ade:	68 20 30 80 00       	push   $0x803020
  801ae3:	e8 29 e7 ff ff       	call   800211 <cprintf>
		return -E_INVAL;
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af0:	eb da                	jmp    801acc <ftruncate+0x52>
		return -E_NOT_SUPP;
  801af2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af7:	eb d3                	jmp    801acc <ftruncate+0x52>

00801af9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	53                   	push   %ebx
  801afd:	83 ec 1c             	sub    $0x1c,%esp
  801b00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b06:	50                   	push   %eax
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	e8 84 fb ff ff       	call   801693 <fd_lookup>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 4b                	js     801b61 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b16:	83 ec 08             	sub    $0x8,%esp
  801b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1c:	50                   	push   %eax
  801b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b20:	ff 30                	pushl  (%eax)
  801b22:	e8 bc fb ff ff       	call   8016e3 <dev_lookup>
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 33                	js     801b61 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b31:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b35:	74 2f                	je     801b66 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b37:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b3a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b41:	00 00 00 
	stat->st_isdir = 0;
  801b44:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b4b:	00 00 00 
	stat->st_dev = dev;
  801b4e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	53                   	push   %ebx
  801b58:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5b:	ff 50 14             	call   *0x14(%eax)
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    
		return -E_NOT_SUPP;
  801b66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6b:	eb f4                	jmp    801b61 <fstat+0x68>

00801b6d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 08             	pushl  0x8(%ebp)
  801b7a:	e8 22 02 00 00       	call   801da1 <open>
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 1b                	js     801ba3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b88:	83 ec 08             	sub    $0x8,%esp
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	50                   	push   %eax
  801b8f:	e8 65 ff ff ff       	call   801af9 <fstat>
  801b94:	89 c6                	mov    %eax,%esi
	close(fd);
  801b96:	89 1c 24             	mov    %ebx,(%esp)
  801b99:	e8 27 fc ff ff       	call   8017c5 <close>
	return r;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	89 f3                	mov    %esi,%ebx
}
  801ba3:	89 d8                	mov    %ebx,%eax
  801ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	56                   	push   %esi
  801bb0:	53                   	push   %ebx
  801bb1:	89 c6                	mov    %eax,%esi
  801bb3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bb5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bbc:	74 27                	je     801be5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bbe:	6a 07                	push   $0x7
  801bc0:	68 00 60 80 00       	push   $0x806000
  801bc5:	56                   	push   %esi
  801bc6:	ff 35 00 50 80 00    	pushl  0x805000
  801bcc:	e8 b6 f9 ff ff       	call   801587 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bd1:	83 c4 0c             	add    $0xc,%esp
  801bd4:	6a 00                	push   $0x0
  801bd6:	53                   	push   %ebx
  801bd7:	6a 00                	push   $0x0
  801bd9:	e8 40 f9 ff ff       	call   80151e <ipc_recv>
}
  801bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	6a 01                	push   $0x1
  801bea:	e8 f0 f9 ff ff       	call   8015df <ipc_find_env>
  801bef:	a3 00 50 80 00       	mov    %eax,0x805000
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	eb c5                	jmp    801bbe <fsipc+0x12>

00801bf9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8b 40 0c             	mov    0xc(%eax),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c12:	ba 00 00 00 00       	mov    $0x0,%edx
  801c17:	b8 02 00 00 00       	mov    $0x2,%eax
  801c1c:	e8 8b ff ff ff       	call   801bac <fsipc>
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <devfile_flush>:
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c34:	ba 00 00 00 00       	mov    $0x0,%edx
  801c39:	b8 06 00 00 00       	mov    $0x6,%eax
  801c3e:	e8 69 ff ff ff       	call   801bac <fsipc>
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <devfile_stat>:
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8b 40 0c             	mov    0xc(%eax),%eax
  801c55:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c64:	e8 43 ff ff ff       	call   801bac <fsipc>
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	78 2c                	js     801c99 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c6d:	83 ec 08             	sub    $0x8,%esp
  801c70:	68 00 60 80 00       	push   $0x806000
  801c75:	53                   	push   %ebx
  801c76:	e8 f5 ec ff ff       	call   800970 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c7b:	a1 80 60 80 00       	mov    0x806080,%eax
  801c80:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c86:	a1 84 60 80 00       	mov    0x806084,%eax
  801c8b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <devfile_write>:
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	8b 40 0c             	mov    0xc(%eax),%eax
  801cae:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cb3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cb9:	53                   	push   %ebx
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	68 08 60 80 00       	push   $0x806008
  801cc2:	e8 99 ee ff ff       	call   800b60 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccc:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd1:	e8 d6 fe ff ff       	call   801bac <fsipc>
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 0b                	js     801ce8 <devfile_write+0x4a>
	assert(r <= n);
  801cdd:	39 d8                	cmp    %ebx,%eax
  801cdf:	77 0c                	ja     801ced <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ce1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce6:	7f 1e                	jg     801d06 <devfile_write+0x68>
}
  801ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    
	assert(r <= n);
  801ced:	68 90 30 80 00       	push   $0x803090
  801cf2:	68 97 30 80 00       	push   $0x803097
  801cf7:	68 98 00 00 00       	push   $0x98
  801cfc:	68 ac 30 80 00       	push   $0x8030ac
  801d01:	e8 6a 0a 00 00       	call   802770 <_panic>
	assert(r <= PGSIZE);
  801d06:	68 b7 30 80 00       	push   $0x8030b7
  801d0b:	68 97 30 80 00       	push   $0x803097
  801d10:	68 99 00 00 00       	push   $0x99
  801d15:	68 ac 30 80 00       	push   $0x8030ac
  801d1a:	e8 51 0a 00 00       	call   802770 <_panic>

00801d1f <devfile_read>:
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d32:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d38:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3d:	b8 03 00 00 00       	mov    $0x3,%eax
  801d42:	e8 65 fe ff ff       	call   801bac <fsipc>
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 1f                	js     801d6c <devfile_read+0x4d>
	assert(r <= n);
  801d4d:	39 f0                	cmp    %esi,%eax
  801d4f:	77 24                	ja     801d75 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d51:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d56:	7f 33                	jg     801d8b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d58:	83 ec 04             	sub    $0x4,%esp
  801d5b:	50                   	push   %eax
  801d5c:	68 00 60 80 00       	push   $0x806000
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	e8 95 ed ff ff       	call   800afe <memmove>
	return r;
  801d69:	83 c4 10             	add    $0x10,%esp
}
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    
	assert(r <= n);
  801d75:	68 90 30 80 00       	push   $0x803090
  801d7a:	68 97 30 80 00       	push   $0x803097
  801d7f:	6a 7c                	push   $0x7c
  801d81:	68 ac 30 80 00       	push   $0x8030ac
  801d86:	e8 e5 09 00 00       	call   802770 <_panic>
	assert(r <= PGSIZE);
  801d8b:	68 b7 30 80 00       	push   $0x8030b7
  801d90:	68 97 30 80 00       	push   $0x803097
  801d95:	6a 7d                	push   $0x7d
  801d97:	68 ac 30 80 00       	push   $0x8030ac
  801d9c:	e8 cf 09 00 00       	call   802770 <_panic>

00801da1 <open>:
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
  801da6:	83 ec 1c             	sub    $0x1c,%esp
  801da9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dac:	56                   	push   %esi
  801dad:	e8 85 eb ff ff       	call   800937 <strlen>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dba:	7f 6c                	jg     801e28 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc2:	50                   	push   %eax
  801dc3:	e8 79 f8 ff ff       	call   801641 <fd_alloc>
  801dc8:	89 c3                	mov    %eax,%ebx
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	78 3c                	js     801e0d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dd1:	83 ec 08             	sub    $0x8,%esp
  801dd4:	56                   	push   %esi
  801dd5:	68 00 60 80 00       	push   $0x806000
  801dda:	e8 91 eb ff ff       	call   800970 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dea:	b8 01 00 00 00       	mov    $0x1,%eax
  801def:	e8 b8 fd ff ff       	call   801bac <fsipc>
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 19                	js     801e16 <open+0x75>
	return fd2num(fd);
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	ff 75 f4             	pushl  -0xc(%ebp)
  801e03:	e8 12 f8 ff ff       	call   80161a <fd2num>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 10             	add    $0x10,%esp
}
  801e0d:	89 d8                	mov    %ebx,%eax
  801e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
		fd_close(fd, 0);
  801e16:	83 ec 08             	sub    $0x8,%esp
  801e19:	6a 00                	push   $0x0
  801e1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1e:	e8 1b f9 ff ff       	call   80173e <fd_close>
		return r;
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	eb e5                	jmp    801e0d <open+0x6c>
		return -E_BAD_PATH;
  801e28:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e2d:	eb de                	jmp    801e0d <open+0x6c>

00801e2f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e35:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e3f:	e8 68 fd ff ff       	call   801bac <fsipc>
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e4c:	68 c3 30 80 00       	push   $0x8030c3
  801e51:	ff 75 0c             	pushl  0xc(%ebp)
  801e54:	e8 17 eb ff ff       	call   800970 <strcpy>
	return 0;
}
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <devsock_close>:
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	53                   	push   %ebx
  801e64:	83 ec 10             	sub    $0x10,%esp
  801e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e6a:	53                   	push   %ebx
  801e6b:	e8 f6 09 00 00       	call   802866 <pageref>
  801e70:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e78:	83 f8 01             	cmp    $0x1,%eax
  801e7b:	74 07                	je     801e84 <devsock_close+0x24>
}
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	ff 73 0c             	pushl  0xc(%ebx)
  801e8a:	e8 b9 02 00 00       	call   802148 <nsipc_close>
  801e8f:	89 c2                	mov    %eax,%edx
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	eb e7                	jmp    801e7d <devsock_close+0x1d>

00801e96 <devsock_write>:
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	ff 75 10             	pushl  0x10(%ebp)
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	ff 70 0c             	pushl  0xc(%eax)
  801eaa:	e8 76 03 00 00       	call   802225 <nsipc_send>
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <devsock_read>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	ff 75 10             	pushl  0x10(%ebp)
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	ff 70 0c             	pushl  0xc(%eax)
  801ec5:	e8 ef 02 00 00       	call   8021b9 <nsipc_recv>
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <fd2sockid>:
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ed2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	e8 b7 f7 ff ff       	call   801693 <fd_lookup>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 10                	js     801ef3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801eec:	39 08                	cmp    %ecx,(%eax)
  801eee:	75 05                	jne    801ef5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ef0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ef5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801efa:	eb f7                	jmp    801ef3 <fd2sockid+0x27>

00801efc <alloc_sockfd>:
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
  801f01:	83 ec 1c             	sub    $0x1c,%esp
  801f04:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f09:	50                   	push   %eax
  801f0a:	e8 32 f7 ff ff       	call   801641 <fd_alloc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	78 43                	js     801f5b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	68 07 04 00 00       	push   $0x407
  801f20:	ff 75 f4             	pushl  -0xc(%ebp)
  801f23:	6a 00                	push   $0x0
  801f25:	e8 38 ee ff ff       	call   800d62 <sys_page_alloc>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 28                	js     801f5b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f48:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	50                   	push   %eax
  801f4f:	e8 c6 f6 ff ff       	call   80161a <fd2num>
  801f54:	89 c3                	mov    %eax,%ebx
  801f56:	83 c4 10             	add    $0x10,%esp
  801f59:	eb 0c                	jmp    801f67 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	56                   	push   %esi
  801f5f:	e8 e4 01 00 00       	call   802148 <nsipc_close>
		return r;
  801f64:	83 c4 10             	add    $0x10,%esp
}
  801f67:	89 d8                	mov    %ebx,%eax
  801f69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6c:	5b                   	pop    %ebx
  801f6d:	5e                   	pop    %esi
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <accept>:
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	e8 4e ff ff ff       	call   801ecc <fd2sockid>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 1b                	js     801f9d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	ff 75 10             	pushl  0x10(%ebp)
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	50                   	push   %eax
  801f8c:	e8 0e 01 00 00       	call   80209f <nsipc_accept>
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 05                	js     801f9d <accept+0x2d>
	return alloc_sockfd(r);
  801f98:	e8 5f ff ff ff       	call   801efc <alloc_sockfd>
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <bind>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	e8 1f ff ff ff       	call   801ecc <fd2sockid>
  801fad:	85 c0                	test   %eax,%eax
  801faf:	78 12                	js     801fc3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	ff 75 10             	pushl  0x10(%ebp)
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	50                   	push   %eax
  801fbb:	e8 31 01 00 00       	call   8020f1 <nsipc_bind>
  801fc0:	83 c4 10             	add    $0x10,%esp
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <shutdown>:
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	e8 f9 fe ff ff       	call   801ecc <fd2sockid>
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 0f                	js     801fe6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fd7:	83 ec 08             	sub    $0x8,%esp
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	50                   	push   %eax
  801fde:	e8 43 01 00 00       	call   802126 <nsipc_shutdown>
  801fe3:	83 c4 10             	add    $0x10,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <connect>:
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	e8 d6 fe ff ff       	call   801ecc <fd2sockid>
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 12                	js     80200c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	ff 75 10             	pushl  0x10(%ebp)
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	50                   	push   %eax
  802004:	e8 59 01 00 00       	call   802162 <nsipc_connect>
  802009:	83 c4 10             	add    $0x10,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <listen>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	e8 b0 fe ff ff       	call   801ecc <fd2sockid>
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 0f                	js     80202f <listen+0x21>
	return nsipc_listen(r, backlog);
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	50                   	push   %eax
  802027:	e8 6b 01 00 00       	call   802197 <nsipc_listen>
  80202c:	83 c4 10             	add    $0x10,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <socket>:

int
socket(int domain, int type, int protocol)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802037:	ff 75 10             	pushl  0x10(%ebp)
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	e8 3e 02 00 00       	call   802283 <nsipc_socket>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 05                	js     802051 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80204c:	e8 ab fe ff ff       	call   801efc <alloc_sockfd>
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	53                   	push   %ebx
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80205c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802063:	74 26                	je     80208b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802065:	6a 07                	push   $0x7
  802067:	68 00 70 80 00       	push   $0x807000
  80206c:	53                   	push   %ebx
  80206d:	ff 35 04 50 80 00    	pushl  0x805004
  802073:	e8 0f f5 ff ff       	call   801587 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802078:	83 c4 0c             	add    $0xc,%esp
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	e8 98 f4 ff ff       	call   80151e <ipc_recv>
}
  802086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802089:	c9                   	leave  
  80208a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	6a 02                	push   $0x2
  802090:	e8 4a f5 ff ff       	call   8015df <ipc_find_env>
  802095:	a3 04 50 80 00       	mov    %eax,0x805004
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	eb c6                	jmp    802065 <nsipc+0x12>

0080209f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020af:	8b 06                	mov    (%esi),%eax
  8020b1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bb:	e8 93 ff ff ff       	call   802053 <nsipc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	79 09                	jns    8020cf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020c6:	89 d8                	mov    %ebx,%eax
  8020c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	ff 35 10 70 80 00    	pushl  0x807010
  8020d8:	68 00 70 80 00       	push   $0x807000
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	e8 19 ea ff ff       	call   800afe <memmove>
		*addrlen = ret->ret_addrlen;
  8020e5:	a1 10 70 80 00       	mov    0x807010,%eax
  8020ea:	89 06                	mov    %eax,(%esi)
  8020ec:	83 c4 10             	add    $0x10,%esp
	return r;
  8020ef:	eb d5                	jmp    8020c6 <nsipc_accept+0x27>

008020f1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	53                   	push   %ebx
  8020f5:	83 ec 08             	sub    $0x8,%esp
  8020f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802103:	53                   	push   %ebx
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	68 04 70 80 00       	push   $0x807004
  80210c:	e8 ed e9 ff ff       	call   800afe <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802111:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802117:	b8 02 00 00 00       	mov    $0x2,%eax
  80211c:	e8 32 ff ff ff       	call   802053 <nsipc>
}
  802121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80213c:	b8 03 00 00 00       	mov    $0x3,%eax
  802141:	e8 0d ff ff ff       	call   802053 <nsipc>
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <nsipc_close>:

int
nsipc_close(int s)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802156:	b8 04 00 00 00       	mov    $0x4,%eax
  80215b:	e8 f3 fe ff ff       	call   802053 <nsipc>
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	53                   	push   %ebx
  802166:	83 ec 08             	sub    $0x8,%esp
  802169:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802174:	53                   	push   %ebx
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	68 04 70 80 00       	push   $0x807004
  80217d:	e8 7c e9 ff ff       	call   800afe <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802182:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802188:	b8 05 00 00 00       	mov    $0x5,%eax
  80218d:	e8 c1 fe ff ff       	call   802053 <nsipc>
}
  802192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8021b2:	e8 9c fe ff ff       	call   802053 <nsipc>
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	56                   	push   %esi
  8021bd:	53                   	push   %ebx
  8021be:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021c9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021d7:	b8 07 00 00 00       	mov    $0x7,%eax
  8021dc:	e8 72 fe ff ff       	call   802053 <nsipc>
  8021e1:	89 c3                	mov    %eax,%ebx
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 1f                	js     802206 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021e7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021ec:	7f 21                	jg     80220f <nsipc_recv+0x56>
  8021ee:	39 c6                	cmp    %eax,%esi
  8021f0:	7c 1d                	jl     80220f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	50                   	push   %eax
  8021f6:	68 00 70 80 00       	push   $0x807000
  8021fb:	ff 75 0c             	pushl  0xc(%ebp)
  8021fe:	e8 fb e8 ff ff       	call   800afe <memmove>
  802203:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802206:	89 d8                	mov    %ebx,%eax
  802208:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5e                   	pop    %esi
  80220d:	5d                   	pop    %ebp
  80220e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80220f:	68 cf 30 80 00       	push   $0x8030cf
  802214:	68 97 30 80 00       	push   $0x803097
  802219:	6a 62                	push   $0x62
  80221b:	68 e4 30 80 00       	push   $0x8030e4
  802220:	e8 4b 05 00 00       	call   802770 <_panic>

00802225 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	53                   	push   %ebx
  802229:	83 ec 04             	sub    $0x4,%esp
  80222c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802237:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80223d:	7f 2e                	jg     80226d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	53                   	push   %ebx
  802243:	ff 75 0c             	pushl  0xc(%ebp)
  802246:	68 0c 70 80 00       	push   $0x80700c
  80224b:	e8 ae e8 ff ff       	call   800afe <memmove>
	nsipcbuf.send.req_size = size;
  802250:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802256:	8b 45 14             	mov    0x14(%ebp),%eax
  802259:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80225e:	b8 08 00 00 00       	mov    $0x8,%eax
  802263:	e8 eb fd ff ff       	call   802053 <nsipc>
}
  802268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    
	assert(size < 1600);
  80226d:	68 f0 30 80 00       	push   $0x8030f0
  802272:	68 97 30 80 00       	push   $0x803097
  802277:	6a 6d                	push   $0x6d
  802279:	68 e4 30 80 00       	push   $0x8030e4
  80227e:	e8 ed 04 00 00       	call   802770 <_panic>

00802283 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802291:	8b 45 0c             	mov    0xc(%ebp),%eax
  802294:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802299:	8b 45 10             	mov    0x10(%ebp),%eax
  80229c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022a1:	b8 09 00 00 00       	mov    $0x9,%eax
  8022a6:	e8 a8 fd ff ff       	call   802053 <nsipc>
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	56                   	push   %esi
  8022b1:	53                   	push   %ebx
  8022b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022b5:	83 ec 0c             	sub    $0xc,%esp
  8022b8:	ff 75 08             	pushl  0x8(%ebp)
  8022bb:	e8 6a f3 ff ff       	call   80162a <fd2data>
  8022c0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022c2:	83 c4 08             	add    $0x8,%esp
  8022c5:	68 fc 30 80 00       	push   $0x8030fc
  8022ca:	53                   	push   %ebx
  8022cb:	e8 a0 e6 ff ff       	call   800970 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022d0:	8b 46 04             	mov    0x4(%esi),%eax
  8022d3:	2b 06                	sub    (%esi),%eax
  8022d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022e2:	00 00 00 
	stat->st_dev = &devpipe;
  8022e5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022ec:	40 80 00 
	return 0;
}
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802305:	53                   	push   %ebx
  802306:	6a 00                	push   $0x0
  802308:	e8 da ea ff ff       	call   800de7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80230d:	89 1c 24             	mov    %ebx,(%esp)
  802310:	e8 15 f3 ff ff       	call   80162a <fd2data>
  802315:	83 c4 08             	add    $0x8,%esp
  802318:	50                   	push   %eax
  802319:	6a 00                	push   $0x0
  80231b:	e8 c7 ea ff ff       	call   800de7 <sys_page_unmap>
}
  802320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <_pipeisclosed>:
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	57                   	push   %edi
  802329:	56                   	push   %esi
  80232a:	53                   	push   %ebx
  80232b:	83 ec 1c             	sub    $0x1c,%esp
  80232e:	89 c7                	mov    %eax,%edi
  802330:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802332:	a1 08 50 80 00       	mov    0x805008,%eax
  802337:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	57                   	push   %edi
  80233e:	e8 23 05 00 00       	call   802866 <pageref>
  802343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802346:	89 34 24             	mov    %esi,(%esp)
  802349:	e8 18 05 00 00       	call   802866 <pageref>
		nn = thisenv->env_runs;
  80234e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802354:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	39 cb                	cmp    %ecx,%ebx
  80235c:	74 1b                	je     802379 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80235e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802361:	75 cf                	jne    802332 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802363:	8b 42 58             	mov    0x58(%edx),%eax
  802366:	6a 01                	push   $0x1
  802368:	50                   	push   %eax
  802369:	53                   	push   %ebx
  80236a:	68 03 31 80 00       	push   $0x803103
  80236f:	e8 9d de ff ff       	call   800211 <cprintf>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	eb b9                	jmp    802332 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802379:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80237c:	0f 94 c0             	sete   %al
  80237f:	0f b6 c0             	movzbl %al,%eax
}
  802382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802385:	5b                   	pop    %ebx
  802386:	5e                   	pop    %esi
  802387:	5f                   	pop    %edi
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    

0080238a <devpipe_write>:
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 28             	sub    $0x28,%esp
  802393:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802396:	56                   	push   %esi
  802397:	e8 8e f2 ff ff       	call   80162a <fd2data>
  80239c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023a9:	74 4f                	je     8023fa <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8023ae:	8b 0b                	mov    (%ebx),%ecx
  8023b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8023b3:	39 d0                	cmp    %edx,%eax
  8023b5:	72 14                	jb     8023cb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023b7:	89 da                	mov    %ebx,%edx
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	e8 65 ff ff ff       	call   802325 <_pipeisclosed>
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	75 3b                	jne    8023ff <devpipe_write+0x75>
			sys_yield();
  8023c4:	e8 7a e9 ff ff       	call   800d43 <sys_yield>
  8023c9:	eb e0                	jmp    8023ab <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ce:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023d2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023d5:	89 c2                	mov    %eax,%edx
  8023d7:	c1 fa 1f             	sar    $0x1f,%edx
  8023da:	89 d1                	mov    %edx,%ecx
  8023dc:	c1 e9 1b             	shr    $0x1b,%ecx
  8023df:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023e2:	83 e2 1f             	and    $0x1f,%edx
  8023e5:	29 ca                	sub    %ecx,%edx
  8023e7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023eb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023ef:	83 c0 01             	add    $0x1,%eax
  8023f2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023f5:	83 c7 01             	add    $0x1,%edi
  8023f8:	eb ac                	jmp    8023a6 <devpipe_write+0x1c>
	return i;
  8023fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fd:	eb 05                	jmp    802404 <devpipe_write+0x7a>
				return 0;
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802404:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    

0080240c <devpipe_read>:
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	83 ec 18             	sub    $0x18,%esp
  802415:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802418:	57                   	push   %edi
  802419:	e8 0c f2 ff ff       	call   80162a <fd2data>
  80241e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	be 00 00 00 00       	mov    $0x0,%esi
  802428:	3b 75 10             	cmp    0x10(%ebp),%esi
  80242b:	75 14                	jne    802441 <devpipe_read+0x35>
	return i;
  80242d:	8b 45 10             	mov    0x10(%ebp),%eax
  802430:	eb 02                	jmp    802434 <devpipe_read+0x28>
				return i;
  802432:	89 f0                	mov    %esi,%eax
}
  802434:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    
			sys_yield();
  80243c:	e8 02 e9 ff ff       	call   800d43 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802441:	8b 03                	mov    (%ebx),%eax
  802443:	3b 43 04             	cmp    0x4(%ebx),%eax
  802446:	75 18                	jne    802460 <devpipe_read+0x54>
			if (i > 0)
  802448:	85 f6                	test   %esi,%esi
  80244a:	75 e6                	jne    802432 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80244c:	89 da                	mov    %ebx,%edx
  80244e:	89 f8                	mov    %edi,%eax
  802450:	e8 d0 fe ff ff       	call   802325 <_pipeisclosed>
  802455:	85 c0                	test   %eax,%eax
  802457:	74 e3                	je     80243c <devpipe_read+0x30>
				return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	eb d4                	jmp    802434 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802460:	99                   	cltd   
  802461:	c1 ea 1b             	shr    $0x1b,%edx
  802464:	01 d0                	add    %edx,%eax
  802466:	83 e0 1f             	and    $0x1f,%eax
  802469:	29 d0                	sub    %edx,%eax
  80246b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802473:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802476:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802479:	83 c6 01             	add    $0x1,%esi
  80247c:	eb aa                	jmp    802428 <devpipe_read+0x1c>

0080247e <pipe>:
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	56                   	push   %esi
  802482:	53                   	push   %ebx
  802483:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802489:	50                   	push   %eax
  80248a:	e8 b2 f1 ff ff       	call   801641 <fd_alloc>
  80248f:	89 c3                	mov    %eax,%ebx
  802491:	83 c4 10             	add    $0x10,%esp
  802494:	85 c0                	test   %eax,%eax
  802496:	0f 88 23 01 00 00    	js     8025bf <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 07 04 00 00       	push   $0x407
  8024a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a7:	6a 00                	push   $0x0
  8024a9:	e8 b4 e8 ff ff       	call   800d62 <sys_page_alloc>
  8024ae:	89 c3                	mov    %eax,%ebx
  8024b0:	83 c4 10             	add    $0x10,%esp
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	0f 88 04 01 00 00    	js     8025bf <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024c1:	50                   	push   %eax
  8024c2:	e8 7a f1 ff ff       	call   801641 <fd_alloc>
  8024c7:	89 c3                	mov    %eax,%ebx
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	0f 88 db 00 00 00    	js     8025af <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 07 04 00 00       	push   $0x407
  8024dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8024df:	6a 00                	push   $0x0
  8024e1:	e8 7c e8 ff ff       	call   800d62 <sys_page_alloc>
  8024e6:	89 c3                	mov    %eax,%ebx
  8024e8:	83 c4 10             	add    $0x10,%esp
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	0f 88 bc 00 00 00    	js     8025af <pipe+0x131>
	va = fd2data(fd0);
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f9:	e8 2c f1 ff ff       	call   80162a <fd2data>
  8024fe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802500:	83 c4 0c             	add    $0xc,%esp
  802503:	68 07 04 00 00       	push   $0x407
  802508:	50                   	push   %eax
  802509:	6a 00                	push   $0x0
  80250b:	e8 52 e8 ff ff       	call   800d62 <sys_page_alloc>
  802510:	89 c3                	mov    %eax,%ebx
  802512:	83 c4 10             	add    $0x10,%esp
  802515:	85 c0                	test   %eax,%eax
  802517:	0f 88 82 00 00 00    	js     80259f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	ff 75 f0             	pushl  -0x10(%ebp)
  802523:	e8 02 f1 ff ff       	call   80162a <fd2data>
  802528:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80252f:	50                   	push   %eax
  802530:	6a 00                	push   $0x0
  802532:	56                   	push   %esi
  802533:	6a 00                	push   $0x0
  802535:	e8 6b e8 ff ff       	call   800da5 <sys_page_map>
  80253a:	89 c3                	mov    %eax,%ebx
  80253c:	83 c4 20             	add    $0x20,%esp
  80253f:	85 c0                	test   %eax,%eax
  802541:	78 4e                	js     802591 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802543:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80255c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	ff 75 f4             	pushl  -0xc(%ebp)
  80256c:	e8 a9 f0 ff ff       	call   80161a <fd2num>
  802571:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802574:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802576:	83 c4 04             	add    $0x4,%esp
  802579:	ff 75 f0             	pushl  -0x10(%ebp)
  80257c:	e8 99 f0 ff ff       	call   80161a <fd2num>
  802581:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802584:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80258f:	eb 2e                	jmp    8025bf <pipe+0x141>
	sys_page_unmap(0, va);
  802591:	83 ec 08             	sub    $0x8,%esp
  802594:	56                   	push   %esi
  802595:	6a 00                	push   $0x0
  802597:	e8 4b e8 ff ff       	call   800de7 <sys_page_unmap>
  80259c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80259f:	83 ec 08             	sub    $0x8,%esp
  8025a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a5:	6a 00                	push   $0x0
  8025a7:	e8 3b e8 ff ff       	call   800de7 <sys_page_unmap>
  8025ac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025af:	83 ec 08             	sub    $0x8,%esp
  8025b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b5:	6a 00                	push   $0x0
  8025b7:	e8 2b e8 ff ff       	call   800de7 <sys_page_unmap>
  8025bc:	83 c4 10             	add    $0x10,%esp
}
  8025bf:	89 d8                	mov    %ebx,%eax
  8025c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c4:	5b                   	pop    %ebx
  8025c5:	5e                   	pop    %esi
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    

008025c8 <pipeisclosed>:
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d1:	50                   	push   %eax
  8025d2:	ff 75 08             	pushl  0x8(%ebp)
  8025d5:	e8 b9 f0 ff ff       	call   801693 <fd_lookup>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	78 18                	js     8025f9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e7:	e8 3e f0 ff ff       	call   80162a <fd2data>
	return _pipeisclosed(fd, p);
  8025ec:	89 c2                	mov    %eax,%edx
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	e8 2f fd ff ff       	call   802325 <_pipeisclosed>
  8025f6:	83 c4 10             	add    $0x10,%esp
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802600:	c3                   	ret    

00802601 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802607:	68 1b 31 80 00       	push   $0x80311b
  80260c:	ff 75 0c             	pushl  0xc(%ebp)
  80260f:	e8 5c e3 ff ff       	call   800970 <strcpy>
	return 0;
}
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <devcons_write>:
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	57                   	push   %edi
  80261f:	56                   	push   %esi
  802620:	53                   	push   %ebx
  802621:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802627:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80262c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802632:	3b 75 10             	cmp    0x10(%ebp),%esi
  802635:	73 31                	jae    802668 <devcons_write+0x4d>
		m = n - tot;
  802637:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80263a:	29 f3                	sub    %esi,%ebx
  80263c:	83 fb 7f             	cmp    $0x7f,%ebx
  80263f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802644:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802647:	83 ec 04             	sub    $0x4,%esp
  80264a:	53                   	push   %ebx
  80264b:	89 f0                	mov    %esi,%eax
  80264d:	03 45 0c             	add    0xc(%ebp),%eax
  802650:	50                   	push   %eax
  802651:	57                   	push   %edi
  802652:	e8 a7 e4 ff ff       	call   800afe <memmove>
		sys_cputs(buf, m);
  802657:	83 c4 08             	add    $0x8,%esp
  80265a:	53                   	push   %ebx
  80265b:	57                   	push   %edi
  80265c:	e8 45 e6 ff ff       	call   800ca6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802661:	01 de                	add    %ebx,%esi
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	eb ca                	jmp    802632 <devcons_write+0x17>
}
  802668:	89 f0                	mov    %esi,%eax
  80266a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80266d:	5b                   	pop    %ebx
  80266e:	5e                   	pop    %esi
  80266f:	5f                   	pop    %edi
  802670:	5d                   	pop    %ebp
  802671:	c3                   	ret    

00802672 <devcons_read>:
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80267d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802681:	74 21                	je     8026a4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802683:	e8 3c e6 ff ff       	call   800cc4 <sys_cgetc>
  802688:	85 c0                	test   %eax,%eax
  80268a:	75 07                	jne    802693 <devcons_read+0x21>
		sys_yield();
  80268c:	e8 b2 e6 ff ff       	call   800d43 <sys_yield>
  802691:	eb f0                	jmp    802683 <devcons_read+0x11>
	if (c < 0)
  802693:	78 0f                	js     8026a4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802695:	83 f8 04             	cmp    $0x4,%eax
  802698:	74 0c                	je     8026a6 <devcons_read+0x34>
	*(char*)vbuf = c;
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	88 02                	mov    %al,(%edx)
	return 1;
  80269f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    
		return 0;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	eb f7                	jmp    8026a4 <devcons_read+0x32>

008026ad <cputchar>:
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026b9:	6a 01                	push   $0x1
  8026bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026be:	50                   	push   %eax
  8026bf:	e8 e2 e5 ff ff       	call   800ca6 <sys_cputs>
}
  8026c4:	83 c4 10             	add    $0x10,%esp
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <getchar>:
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026cf:	6a 01                	push   $0x1
  8026d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d4:	50                   	push   %eax
  8026d5:	6a 00                	push   $0x0
  8026d7:	e8 27 f2 ff ff       	call   801903 <read>
	if (r < 0)
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	78 06                	js     8026e9 <getchar+0x20>
	if (r < 1)
  8026e3:	74 06                	je     8026eb <getchar+0x22>
	return c;
  8026e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    
		return -E_EOF;
  8026eb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026f0:	eb f7                	jmp    8026e9 <getchar+0x20>

008026f2 <iscons>:
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026fb:	50                   	push   %eax
  8026fc:	ff 75 08             	pushl  0x8(%ebp)
  8026ff:	e8 8f ef ff ff       	call   801693 <fd_lookup>
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	85 c0                	test   %eax,%eax
  802709:	78 11                	js     80271c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802714:	39 10                	cmp    %edx,(%eax)
  802716:	0f 94 c0             	sete   %al
  802719:	0f b6 c0             	movzbl %al,%eax
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <opencons>:
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802724:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802727:	50                   	push   %eax
  802728:	e8 14 ef ff ff       	call   801641 <fd_alloc>
  80272d:	83 c4 10             	add    $0x10,%esp
  802730:	85 c0                	test   %eax,%eax
  802732:	78 3a                	js     80276e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	68 07 04 00 00       	push   $0x407
  80273c:	ff 75 f4             	pushl  -0xc(%ebp)
  80273f:	6a 00                	push   $0x0
  802741:	e8 1c e6 ff ff       	call   800d62 <sys_page_alloc>
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 21                	js     80276e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802756:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802762:	83 ec 0c             	sub    $0xc,%esp
  802765:	50                   	push   %eax
  802766:	e8 af ee ff ff       	call   80161a <fd2num>
  80276b:	83 c4 10             	add    $0x10,%esp
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	56                   	push   %esi
  802774:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802775:	a1 08 50 80 00       	mov    0x805008,%eax
  80277a:	8b 40 48             	mov    0x48(%eax),%eax
  80277d:	83 ec 04             	sub    $0x4,%esp
  802780:	68 58 31 80 00       	push   $0x803158
  802785:	50                   	push   %eax
  802786:	68 27 31 80 00       	push   $0x803127
  80278b:	e8 81 da ff ff       	call   800211 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802790:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802793:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802799:	e8 86 e5 ff ff       	call   800d24 <sys_getenvid>
  80279e:	83 c4 04             	add    $0x4,%esp
  8027a1:	ff 75 0c             	pushl  0xc(%ebp)
  8027a4:	ff 75 08             	pushl  0x8(%ebp)
  8027a7:	56                   	push   %esi
  8027a8:	50                   	push   %eax
  8027a9:	68 34 31 80 00       	push   $0x803134
  8027ae:	e8 5e da ff ff       	call   800211 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027b3:	83 c4 18             	add    $0x18,%esp
  8027b6:	53                   	push   %ebx
  8027b7:	ff 75 10             	pushl  0x10(%ebp)
  8027ba:	e8 01 da ff ff       	call   8001c0 <vcprintf>
	cprintf("\n");
  8027bf:	c7 04 24 41 2b 80 00 	movl   $0x802b41,(%esp)
  8027c6:	e8 46 da ff ff       	call   800211 <cprintf>
  8027cb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027ce:	cc                   	int3   
  8027cf:	eb fd                	jmp    8027ce <_panic+0x5e>

008027d1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027d7:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027de:	74 0a                	je     8027ea <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027ea:	83 ec 04             	sub    $0x4,%esp
  8027ed:	6a 07                	push   $0x7
  8027ef:	68 00 f0 bf ee       	push   $0xeebff000
  8027f4:	6a 00                	push   $0x0
  8027f6:	e8 67 e5 ff ff       	call   800d62 <sys_page_alloc>
		if(r < 0)
  8027fb:	83 c4 10             	add    $0x10,%esp
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 2a                	js     80282c <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802802:	83 ec 08             	sub    $0x8,%esp
  802805:	68 40 28 80 00       	push   $0x802840
  80280a:	6a 00                	push   $0x0
  80280c:	e8 9c e6 ff ff       	call   800ead <sys_env_set_pgfault_upcall>
		if(r < 0)
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	85 c0                	test   %eax,%eax
  802816:	79 c8                	jns    8027e0 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 90 31 80 00       	push   $0x803190
  802820:	6a 25                	push   $0x25
  802822:	68 cc 31 80 00       	push   $0x8031cc
  802827:	e8 44 ff ff ff       	call   802770 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 60 31 80 00       	push   $0x803160
  802834:	6a 22                	push   $0x22
  802836:	68 cc 31 80 00       	push   $0x8031cc
  80283b:	e8 30 ff ff ff       	call   802770 <_panic>

00802840 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802840:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802841:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802846:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802848:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80284b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80284f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802853:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802856:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802858:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80285c:	83 c4 08             	add    $0x8,%esp
	popal
  80285f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802860:	83 c4 04             	add    $0x4,%esp
	popfl
  802863:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802864:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802865:	c3                   	ret    

00802866 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80286c:	89 d0                	mov    %edx,%eax
  80286e:	c1 e8 16             	shr    $0x16,%eax
  802871:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802878:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80287d:	f6 c1 01             	test   $0x1,%cl
  802880:	74 1d                	je     80289f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802882:	c1 ea 0c             	shr    $0xc,%edx
  802885:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80288c:	f6 c2 01             	test   $0x1,%dl
  80288f:	74 0e                	je     80289f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802891:	c1 ea 0c             	shr    $0xc,%edx
  802894:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80289b:	ef 
  80289c:	0f b7 c0             	movzwl %ax,%eax
}
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
  8028a1:	66 90                	xchg   %ax,%ax
  8028a3:	66 90                	xchg   %ax,%ax
  8028a5:	66 90                	xchg   %ax,%ax
  8028a7:	66 90                	xchg   %ax,%ax
  8028a9:	66 90                	xchg   %ax,%ax
  8028ab:	66 90                	xchg   %ax,%ax
  8028ad:	66 90                	xchg   %ax,%ax
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
