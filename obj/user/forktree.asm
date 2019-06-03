
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
  80003d:	e8 05 0d 00 00       	call   800d47 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 40 2b 80 00       	push   $0x802b40
  80004c:	e8 e3 01 00 00       	call   800234 <cprintf>

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
  80007e:	e8 d7 08 00 00       	call   80095a <strlen>
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
  80009c:	68 51 2b 80 00       	push   $0x802b51
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 94 08 00 00       	call   800940 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 36 13 00 00       	call   8013ea <sfork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 bc 00 00 00       	call   800185 <exit>
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
  8000d4:	68 62 2b 80 00       	push   $0x802b62
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
  8000ec:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000f3:	00 00 00 
	envid_t find = sys_getenvid();
  8000f6:	e8 4c 0c 00 00       	call   800d47 <sys_getenvid>
  8000fb:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  800144:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014e:	7e 0a                	jle    80015a <libmain+0x77>
		binaryname = argv[0];
  800150:	8b 45 0c             	mov    0xc(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 56 2b 80 00       	push   $0x802b56
  800162:	e8 cd 00 00 00       	call   800234 <cprintf>
	// call user main routine
	umain(argc, argv);
  800167:	83 c4 08             	add    $0x8,%esp
  80016a:	ff 75 0c             	pushl  0xc(%ebp)
  80016d:	ff 75 08             	pushl  0x8(%ebp)
  800170:	e8 59 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  800175:	e8 0b 00 00 00       	call   800185 <exit>
}
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800180:	5b                   	pop    %ebx
  800181:	5e                   	pop    %esi
  800182:	5f                   	pop    %edi
  800183:	5d                   	pop    %ebp
  800184:	c3                   	ret    

00800185 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018b:	e8 9d 15 00 00       	call   80172d <close_all>
	sys_env_destroy(0);
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	6a 00                	push   $0x0
  800195:	e8 6c 0b 00 00       	call   800d06 <sys_env_destroy>
}
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a9:	8b 13                	mov    (%ebx),%edx
  8001ab:	8d 42 01             	lea    0x1(%edx),%eax
  8001ae:	89 03                	mov    %eax,(%ebx)
  8001b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bc:	74 09                	je     8001c7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	68 ff 00 00 00       	push   $0xff
  8001cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d2:	50                   	push   %eax
  8001d3:	e8 f1 0a 00 00       	call   800cc9 <sys_cputs>
		b->idx = 0;
  8001d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	eb db                	jmp    8001be <putch+0x1f>

008001e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f3:	00 00 00 
	b.cnt = 0;
  8001f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800200:	ff 75 0c             	pushl  0xc(%ebp)
  800203:	ff 75 08             	pushl  0x8(%ebp)
  800206:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	68 9f 01 80 00       	push   $0x80019f
  800212:	e8 4a 01 00 00       	call   800361 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800217:	83 c4 08             	add    $0x8,%esp
  80021a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800220:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800226:	50                   	push   %eax
  800227:	e8 9d 0a 00 00       	call   800cc9 <sys_cputs>

	return b.cnt;
}
  80022c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023d:	50                   	push   %eax
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	e8 9d ff ff ff       	call   8001e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 1c             	sub    $0x1c,%esp
  800251:	89 c6                	mov    %eax,%esi
  800253:	89 d7                	mov    %edx,%edi
  800255:	8b 45 08             	mov    0x8(%ebp),%eax
  800258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800261:	8b 45 10             	mov    0x10(%ebp),%eax
  800264:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800267:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80026b:	74 2c                	je     800299 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80026d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800270:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800277:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80027a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80027d:	39 c2                	cmp    %eax,%edx
  80027f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800282:	73 43                	jae    8002c7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	85 db                	test   %ebx,%ebx
  800289:	7e 6c                	jle    8002f7 <printnum+0xaf>
				putch(padc, putdat);
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	57                   	push   %edi
  80028f:	ff 75 18             	pushl  0x18(%ebp)
  800292:	ff d6                	call   *%esi
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	eb eb                	jmp    800284 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 20                	push   $0x20
  80029e:	6a 00                	push   $0x0
  8002a0:	50                   	push   %eax
  8002a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a7:	89 fa                	mov    %edi,%edx
  8002a9:	89 f0                	mov    %esi,%eax
  8002ab:	e8 98 ff ff ff       	call   800248 <printnum>
		while (--width > 0)
  8002b0:	83 c4 20             	add    $0x20,%esp
  8002b3:	83 eb 01             	sub    $0x1,%ebx
  8002b6:	85 db                	test   %ebx,%ebx
  8002b8:	7e 65                	jle    80031f <printnum+0xd7>
			putch(padc, putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	57                   	push   %edi
  8002be:	6a 20                	push   $0x20
  8002c0:	ff d6                	call   *%esi
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	eb ec                	jmp    8002b3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	ff 75 18             	pushl  0x18(%ebp)
  8002cd:	83 eb 01             	sub    $0x1,%ebx
  8002d0:	53                   	push   %ebx
  8002d1:	50                   	push   %eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002de:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e1:	e8 fa 25 00 00       	call   8028e0 <__udivdi3>
  8002e6:	83 c4 18             	add    $0x18,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	89 fa                	mov    %edi,%edx
  8002ed:	89 f0                	mov    %esi,%eax
  8002ef:	e8 54 ff ff ff       	call   800248 <printnum>
  8002f4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002f7:	83 ec 08             	sub    $0x8,%esp
  8002fa:	57                   	push   %edi
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800301:	ff 75 d8             	pushl  -0x28(%ebp)
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	e8 e1 26 00 00       	call   8029f0 <__umoddi3>
  80030f:	83 c4 14             	add    $0x14,%esp
  800312:	0f be 80 6d 2b 80 00 	movsbl 0x802b6d(%eax),%eax
  800319:	50                   	push   %eax
  80031a:	ff d6                	call   *%esi
  80031c:	83 c4 10             	add    $0x10,%esp
	}
}
  80031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800322:	5b                   	pop    %ebx
  800323:	5e                   	pop    %esi
  800324:	5f                   	pop    %edi
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    

00800327 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80032d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800331:	8b 10                	mov    (%eax),%edx
  800333:	3b 50 04             	cmp    0x4(%eax),%edx
  800336:	73 0a                	jae    800342 <sprintputch+0x1b>
		*b->buf++ = ch;
  800338:	8d 4a 01             	lea    0x1(%edx),%ecx
  80033b:	89 08                	mov    %ecx,(%eax)
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	88 02                	mov    %al,(%edx)
}
  800342:	5d                   	pop    %ebp
  800343:	c3                   	ret    

00800344 <printfmt>:
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80034a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80034d:	50                   	push   %eax
  80034e:	ff 75 10             	pushl  0x10(%ebp)
  800351:	ff 75 0c             	pushl  0xc(%ebp)
  800354:	ff 75 08             	pushl  0x8(%ebp)
  800357:	e8 05 00 00 00       	call   800361 <vprintfmt>
}
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <vprintfmt>:
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 3c             	sub    $0x3c,%esp
  80036a:	8b 75 08             	mov    0x8(%ebp),%esi
  80036d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800370:	8b 7d 10             	mov    0x10(%ebp),%edi
  800373:	e9 32 04 00 00       	jmp    8007aa <vprintfmt+0x449>
		padc = ' ';
  800378:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80037c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800383:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80038a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800391:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800398:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80039f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	8d 47 01             	lea    0x1(%edi),%eax
  8003a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003aa:	0f b6 17             	movzbl (%edi),%edx
  8003ad:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b0:	3c 55                	cmp    $0x55,%al
  8003b2:	0f 87 12 05 00 00    	ja     8008ca <vprintfmt+0x569>
  8003b8:	0f b6 c0             	movzbl %al,%eax
  8003bb:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003c9:	eb d9                	jmp    8003a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ce:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003d2:	eb d0                	jmp    8003a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	0f b6 d2             	movzbl %dl,%edx
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003da:	b8 00 00 00 00       	mov    $0x0,%eax
  8003df:	89 75 08             	mov    %esi,0x8(%ebp)
  8003e2:	eb 03                	jmp    8003e7 <vprintfmt+0x86>
  8003e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ea:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ee:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003f4:	83 fe 09             	cmp    $0x9,%esi
  8003f7:	76 eb                	jbe    8003e4 <vprintfmt+0x83>
  8003f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ff:	eb 14                	jmp    800415 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 40 04             	lea    0x4(%eax),%eax
  80040f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800419:	79 89                	jns    8003a4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80041b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800421:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800428:	e9 77 ff ff ff       	jmp    8003a4 <vprintfmt+0x43>
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	85 c0                	test   %eax,%eax
  800432:	0f 48 c1             	cmovs  %ecx,%eax
  800435:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043b:	e9 64 ff ff ff       	jmp    8003a4 <vprintfmt+0x43>
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800443:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80044a:	e9 55 ff ff ff       	jmp    8003a4 <vprintfmt+0x43>
			lflag++;
  80044f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800453:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800456:	e9 49 ff ff ff       	jmp    8003a4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 78 04             	lea    0x4(%eax),%edi
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	53                   	push   %ebx
  800465:	ff 30                	pushl  (%eax)
  800467:	ff d6                	call   *%esi
			break;
  800469:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80046c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80046f:	e9 33 03 00 00       	jmp    8007a7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 78 04             	lea    0x4(%eax),%edi
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	99                   	cltd   
  80047d:	31 d0                	xor    %edx,%eax
  80047f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800481:	83 f8 10             	cmp    $0x10,%eax
  800484:	7f 23                	jg     8004a9 <vprintfmt+0x148>
  800486:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  80048d:	85 d2                	test   %edx,%edx
  80048f:	74 18                	je     8004a9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800491:	52                   	push   %edx
  800492:	68 b1 30 80 00       	push   $0x8030b1
  800497:	53                   	push   %ebx
  800498:	56                   	push   %esi
  800499:	e8 a6 fe ff ff       	call   800344 <printfmt>
  80049e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a4:	e9 fe 02 00 00       	jmp    8007a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a9:	50                   	push   %eax
  8004aa:	68 85 2b 80 00       	push   $0x802b85
  8004af:	53                   	push   %ebx
  8004b0:	56                   	push   %esi
  8004b1:	e8 8e fe ff ff       	call   800344 <printfmt>
  8004b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004bc:	e9 e6 02 00 00       	jmp    8007a7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004cf:	85 c9                	test   %ecx,%ecx
  8004d1:	b8 7e 2b 80 00       	mov    $0x802b7e,%eax
  8004d6:	0f 45 c1             	cmovne %ecx,%eax
  8004d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e0:	7e 06                	jle    8004e8 <vprintfmt+0x187>
  8004e2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004e6:	75 0d                	jne    8004f5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004eb:	89 c7                	mov    %eax,%edi
  8004ed:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	eb 53                	jmp    800548 <vprintfmt+0x1e7>
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004fb:	50                   	push   %eax
  8004fc:	e8 71 04 00 00       	call   800972 <strnlen>
  800501:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800504:	29 c1                	sub    %eax,%ecx
  800506:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80050e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800512:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800515:	eb 0f                	jmp    800526 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	53                   	push   %ebx
  80051b:	ff 75 e0             	pushl  -0x20(%ebp)
  80051e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800520:	83 ef 01             	sub    $0x1,%edi
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	85 ff                	test   %edi,%edi
  800528:	7f ed                	jg     800517 <vprintfmt+0x1b6>
  80052a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80052d:	85 c9                	test   %ecx,%ecx
  80052f:	b8 00 00 00 00       	mov    $0x0,%eax
  800534:	0f 49 c1             	cmovns %ecx,%eax
  800537:	29 c1                	sub    %eax,%ecx
  800539:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80053c:	eb aa                	jmp    8004e8 <vprintfmt+0x187>
					putch(ch, putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	53                   	push   %ebx
  800542:	52                   	push   %edx
  800543:	ff d6                	call   *%esi
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054d:	83 c7 01             	add    $0x1,%edi
  800550:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800554:	0f be d0             	movsbl %al,%edx
  800557:	85 d2                	test   %edx,%edx
  800559:	74 4b                	je     8005a6 <vprintfmt+0x245>
  80055b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80055f:	78 06                	js     800567 <vprintfmt+0x206>
  800561:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800565:	78 1e                	js     800585 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800567:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80056b:	74 d1                	je     80053e <vprintfmt+0x1dd>
  80056d:	0f be c0             	movsbl %al,%eax
  800570:	83 e8 20             	sub    $0x20,%eax
  800573:	83 f8 5e             	cmp    $0x5e,%eax
  800576:	76 c6                	jbe    80053e <vprintfmt+0x1dd>
					putch('?', putdat);
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	53                   	push   %ebx
  80057c:	6a 3f                	push   $0x3f
  80057e:	ff d6                	call   *%esi
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	eb c3                	jmp    800548 <vprintfmt+0x1e7>
  800585:	89 cf                	mov    %ecx,%edi
  800587:	eb 0e                	jmp    800597 <vprintfmt+0x236>
				putch(' ', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	53                   	push   %ebx
  80058d:	6a 20                	push   $0x20
  80058f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800591:	83 ef 01             	sub    $0x1,%edi
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	85 ff                	test   %edi,%edi
  800599:	7f ee                	jg     800589 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80059b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a1:	e9 01 02 00 00       	jmp    8007a7 <vprintfmt+0x446>
  8005a6:	89 cf                	mov    %ecx,%edi
  8005a8:	eb ed                	jmp    800597 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005b4:	e9 eb fd ff ff       	jmp    8003a4 <vprintfmt+0x43>
	if (lflag >= 2)
  8005b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005bd:	7f 21                	jg     8005e0 <vprintfmt+0x27f>
	else if (lflag)
  8005bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005c3:	74 68                	je     80062d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005cd:	89 c1                	mov    %eax,%ecx
  8005cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb 17                	jmp    8005f7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 50 04             	mov    0x4(%eax),%edx
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 40 08             	lea    0x8(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800603:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800607:	78 3f                	js     800648 <vprintfmt+0x2e7>
			base = 10;
  800609:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80060e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800612:	0f 84 71 01 00 00    	je     800789 <vprintfmt+0x428>
				putch('+', putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	53                   	push   %ebx
  80061c:	6a 2b                	push   $0x2b
  80061e:	ff d6                	call   *%esi
  800620:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800623:	b8 0a 00 00 00       	mov    $0xa,%eax
  800628:	e9 5c 01 00 00       	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800635:	89 c1                	mov    %eax,%ecx
  800637:	c1 f9 1f             	sar    $0x1f,%ecx
  80063a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
  800646:	eb af                	jmp    8005f7 <vprintfmt+0x296>
				putch('-', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	6a 2d                	push   $0x2d
  80064e:	ff d6                	call   *%esi
				num = -(long long) num;
  800650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800653:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800656:	f7 d8                	neg    %eax
  800658:	83 d2 00             	adc    $0x0,%edx
  80065b:	f7 da                	neg    %edx
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800663:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800666:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066b:	e9 19 01 00 00       	jmp    800789 <vprintfmt+0x428>
	if (lflag >= 2)
  800670:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800674:	7f 29                	jg     80069f <vprintfmt+0x33e>
	else if (lflag)
  800676:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80067a:	74 44                	je     8006c0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800695:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069a:	e9 ea 00 00 00       	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 50 04             	mov    0x4(%eax),%edx
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 08             	lea    0x8(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bb:	e9 c9 00 00 00       	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 04             	lea    0x4(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006de:	e9 a6 00 00 00       	jmp    800789 <vprintfmt+0x428>
			putch('0', putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	6a 30                	push   $0x30
  8006e9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f2:	7f 26                	jg     80071a <vprintfmt+0x3b9>
	else if (lflag)
  8006f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f8:	74 3e                	je     800738 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800707:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800713:	b8 08 00 00 00       	mov    $0x8,%eax
  800718:	eb 6f                	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 50 04             	mov    0x4(%eax),%edx
  800720:	8b 00                	mov    (%eax),%eax
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 08             	lea    0x8(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800731:	b8 08 00 00 00       	mov    $0x8,%eax
  800736:	eb 51                	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800745:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800751:	b8 08 00 00 00       	mov    $0x8,%eax
  800756:	eb 31                	jmp    800789 <vprintfmt+0x428>
			putch('0', putdat);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	53                   	push   %ebx
  80075c:	6a 30                	push   $0x30
  80075e:	ff d6                	call   *%esi
			putch('x', putdat);
  800760:	83 c4 08             	add    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 78                	push   $0x78
  800766:	ff d6                	call   *%esi
			num = (unsigned long long)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800775:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800778:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800784:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800789:	83 ec 0c             	sub    $0xc,%esp
  80078c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800790:	52                   	push   %edx
  800791:	ff 75 e0             	pushl  -0x20(%ebp)
  800794:	50                   	push   %eax
  800795:	ff 75 dc             	pushl  -0x24(%ebp)
  800798:	ff 75 d8             	pushl  -0x28(%ebp)
  80079b:	89 da                	mov    %ebx,%edx
  80079d:	89 f0                	mov    %esi,%eax
  80079f:	e8 a4 fa ff ff       	call   800248 <printnum>
			break;
  8007a4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007aa:	83 c7 01             	add    $0x1,%edi
  8007ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b1:	83 f8 25             	cmp    $0x25,%eax
  8007b4:	0f 84 be fb ff ff    	je     800378 <vprintfmt+0x17>
			if (ch == '\0')
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	0f 84 28 01 00 00    	je     8008ea <vprintfmt+0x589>
			putch(ch, putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	50                   	push   %eax
  8007c7:	ff d6                	call   *%esi
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	eb dc                	jmp    8007aa <vprintfmt+0x449>
	if (lflag >= 2)
  8007ce:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d2:	7f 26                	jg     8007fa <vprintfmt+0x499>
	else if (lflag)
  8007d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d8:	74 41                	je     80081b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8d 40 04             	lea    0x4(%eax),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f8:	eb 8f                	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 08             	lea    0x8(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800811:	b8 10 00 00 00       	mov    $0x10,%eax
  800816:	e9 6e ff ff ff       	jmp    800789 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	ba 00 00 00 00       	mov    $0x0,%edx
  800825:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800828:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
  800839:	e9 4b ff ff ff       	jmp    800789 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	85 c0                	test   %eax,%eax
  80084e:	74 14                	je     800864 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800850:	8b 13                	mov    (%ebx),%edx
  800852:	83 fa 7f             	cmp    $0x7f,%edx
  800855:	7f 37                	jg     80088e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800857:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800859:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
  80085f:	e9 43 ff ff ff       	jmp    8007a7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800864:	b8 0a 00 00 00       	mov    $0xa,%eax
  800869:	bf a1 2c 80 00       	mov    $0x802ca1,%edi
							putch(ch, putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	50                   	push   %eax
  800873:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800875:	83 c7 01             	add    $0x1,%edi
  800878:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	85 c0                	test   %eax,%eax
  800881:	75 eb                	jne    80086e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800883:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
  800889:	e9 19 ff ff ff       	jmp    8007a7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80088e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800890:	b8 0a 00 00 00       	mov    $0xa,%eax
  800895:	bf d9 2c 80 00       	mov    $0x802cd9,%edi
							putch(ch, putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	53                   	push   %ebx
  80089e:	50                   	push   %eax
  80089f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a1:	83 c7 01             	add    $0x1,%edi
  8008a4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	85 c0                	test   %eax,%eax
  8008ad:	75 eb                	jne    80089a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b5:	e9 ed fe ff ff       	jmp    8007a7 <vprintfmt+0x446>
			putch(ch, putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	53                   	push   %ebx
  8008be:	6a 25                	push   $0x25
  8008c0:	ff d6                	call   *%esi
			break;
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	e9 dd fe ff ff       	jmp    8007a7 <vprintfmt+0x446>
			putch('%', putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	53                   	push   %ebx
  8008ce:	6a 25                	push   $0x25
  8008d0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	89 f8                	mov    %edi,%eax
  8008d7:	eb 03                	jmp    8008dc <vprintfmt+0x57b>
  8008d9:	83 e8 01             	sub    $0x1,%eax
  8008dc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e0:	75 f7                	jne    8008d9 <vprintfmt+0x578>
  8008e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e5:	e9 bd fe ff ff       	jmp    8007a7 <vprintfmt+0x446>
}
  8008ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5f                   	pop    %edi
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	83 ec 18             	sub    $0x18,%esp
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800901:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800905:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800908:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090f:	85 c0                	test   %eax,%eax
  800911:	74 26                	je     800939 <vsnprintf+0x47>
  800913:	85 d2                	test   %edx,%edx
  800915:	7e 22                	jle    800939 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800917:	ff 75 14             	pushl  0x14(%ebp)
  80091a:	ff 75 10             	pushl  0x10(%ebp)
  80091d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800920:	50                   	push   %eax
  800921:	68 27 03 80 00       	push   $0x800327
  800926:	e8 36 fa ff ff       	call   800361 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80092b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800934:	83 c4 10             	add    $0x10,%esp
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    
		return -E_INVAL;
  800939:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093e:	eb f7                	jmp    800937 <vsnprintf+0x45>

00800940 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800946:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800949:	50                   	push   %eax
  80094a:	ff 75 10             	pushl  0x10(%ebp)
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 9a ff ff ff       	call   8008f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800969:	74 05                	je     800970 <strlen+0x16>
		n++;
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	eb f5                	jmp    800965 <strlen+0xb>
	return n;
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097b:	ba 00 00 00 00       	mov    $0x0,%edx
  800980:	39 c2                	cmp    %eax,%edx
  800982:	74 0d                	je     800991 <strnlen+0x1f>
  800984:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800988:	74 05                	je     80098f <strnlen+0x1d>
		n++;
  80098a:	83 c2 01             	add    $0x1,%edx
  80098d:	eb f1                	jmp    800980 <strnlen+0xe>
  80098f:	89 d0                	mov    %edx,%eax
	return n;
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009a6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a9:	83 c2 01             	add    $0x1,%edx
  8009ac:	84 c9                	test   %cl,%cl
  8009ae:	75 f2                	jne    8009a2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	53                   	push   %ebx
  8009b7:	83 ec 10             	sub    $0x10,%esp
  8009ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009bd:	53                   	push   %ebx
  8009be:	e8 97 ff ff ff       	call   80095a <strlen>
  8009c3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	01 d8                	add    %ebx,%eax
  8009cb:	50                   	push   %eax
  8009cc:	e8 c2 ff ff ff       	call   800993 <strcpy>
	return dst;
}
  8009d1:	89 d8                	mov    %ebx,%eax
  8009d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e3:	89 c6                	mov    %eax,%esi
  8009e5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e8:	89 c2                	mov    %eax,%edx
  8009ea:	39 f2                	cmp    %esi,%edx
  8009ec:	74 11                	je     8009ff <strncpy+0x27>
		*dst++ = *src;
  8009ee:	83 c2 01             	add    $0x1,%edx
  8009f1:	0f b6 19             	movzbl (%ecx),%ebx
  8009f4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f7:	80 fb 01             	cmp    $0x1,%bl
  8009fa:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009fd:	eb eb                	jmp    8009ea <strncpy+0x12>
	}
	return ret;
}
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	56                   	push   %esi
  800a07:	53                   	push   %ebx
  800a08:	8b 75 08             	mov    0x8(%ebp),%esi
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0e:	8b 55 10             	mov    0x10(%ebp),%edx
  800a11:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a13:	85 d2                	test   %edx,%edx
  800a15:	74 21                	je     800a38 <strlcpy+0x35>
  800a17:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a1b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a1d:	39 c2                	cmp    %eax,%edx
  800a1f:	74 14                	je     800a35 <strlcpy+0x32>
  800a21:	0f b6 19             	movzbl (%ecx),%ebx
  800a24:	84 db                	test   %bl,%bl
  800a26:	74 0b                	je     800a33 <strlcpy+0x30>
			*dst++ = *src++;
  800a28:	83 c1 01             	add    $0x1,%ecx
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a31:	eb ea                	jmp    800a1d <strlcpy+0x1a>
  800a33:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a35:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a38:	29 f0                	sub    %esi,%eax
}
  800a3a:	5b                   	pop    %ebx
  800a3b:	5e                   	pop    %esi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a47:	0f b6 01             	movzbl (%ecx),%eax
  800a4a:	84 c0                	test   %al,%al
  800a4c:	74 0c                	je     800a5a <strcmp+0x1c>
  800a4e:	3a 02                	cmp    (%edx),%al
  800a50:	75 08                	jne    800a5a <strcmp+0x1c>
		p++, q++;
  800a52:	83 c1 01             	add    $0x1,%ecx
  800a55:	83 c2 01             	add    $0x1,%edx
  800a58:	eb ed                	jmp    800a47 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5a:	0f b6 c0             	movzbl %al,%eax
  800a5d:	0f b6 12             	movzbl (%edx),%edx
  800a60:	29 d0                	sub    %edx,%eax
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	53                   	push   %ebx
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	89 c3                	mov    %eax,%ebx
  800a70:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a73:	eb 06                	jmp    800a7b <strncmp+0x17>
		n--, p++, q++;
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a7b:	39 d8                	cmp    %ebx,%eax
  800a7d:	74 16                	je     800a95 <strncmp+0x31>
  800a7f:	0f b6 08             	movzbl (%eax),%ecx
  800a82:	84 c9                	test   %cl,%cl
  800a84:	74 04                	je     800a8a <strncmp+0x26>
  800a86:	3a 0a                	cmp    (%edx),%cl
  800a88:	74 eb                	je     800a75 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	0f b6 00             	movzbl (%eax),%eax
  800a8d:	0f b6 12             	movzbl (%edx),%edx
  800a90:	29 d0                	sub    %edx,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    
		return 0;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	eb f6                	jmp    800a92 <strncmp+0x2e>

00800a9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa6:	0f b6 10             	movzbl (%eax),%edx
  800aa9:	84 d2                	test   %dl,%dl
  800aab:	74 09                	je     800ab6 <strchr+0x1a>
		if (*s == c)
  800aad:	38 ca                	cmp    %cl,%dl
  800aaf:	74 0a                	je     800abb <strchr+0x1f>
	for (; *s; s++)
  800ab1:	83 c0 01             	add    $0x1,%eax
  800ab4:	eb f0                	jmp    800aa6 <strchr+0xa>
			return (char *) s;
	return 0;
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aca:	38 ca                	cmp    %cl,%dl
  800acc:	74 09                	je     800ad7 <strfind+0x1a>
  800ace:	84 d2                	test   %dl,%dl
  800ad0:	74 05                	je     800ad7 <strfind+0x1a>
	for (; *s; s++)
  800ad2:	83 c0 01             	add    $0x1,%eax
  800ad5:	eb f0                	jmp    800ac7 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae5:	85 c9                	test   %ecx,%ecx
  800ae7:	74 31                	je     800b1a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae9:	89 f8                	mov    %edi,%eax
  800aeb:	09 c8                	or     %ecx,%eax
  800aed:	a8 03                	test   $0x3,%al
  800aef:	75 23                	jne    800b14 <memset+0x3b>
		c &= 0xFF;
  800af1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af5:	89 d3                	mov    %edx,%ebx
  800af7:	c1 e3 08             	shl    $0x8,%ebx
  800afa:	89 d0                	mov    %edx,%eax
  800afc:	c1 e0 18             	shl    $0x18,%eax
  800aff:	89 d6                	mov    %edx,%esi
  800b01:	c1 e6 10             	shl    $0x10,%esi
  800b04:	09 f0                	or     %esi,%eax
  800b06:	09 c2                	or     %eax,%edx
  800b08:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b0d:	89 d0                	mov    %edx,%eax
  800b0f:	fc                   	cld    
  800b10:	f3 ab                	rep stos %eax,%es:(%edi)
  800b12:	eb 06                	jmp    800b1a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	fc                   	cld    
  800b18:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1a:	89 f8                	mov    %edi,%eax
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5f                   	pop    %edi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	57                   	push   %edi
  800b25:	56                   	push   %esi
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b2f:	39 c6                	cmp    %eax,%esi
  800b31:	73 32                	jae    800b65 <memmove+0x44>
  800b33:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b36:	39 c2                	cmp    %eax,%edx
  800b38:	76 2b                	jbe    800b65 <memmove+0x44>
		s += n;
		d += n;
  800b3a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3d:	89 fe                	mov    %edi,%esi
  800b3f:	09 ce                	or     %ecx,%esi
  800b41:	09 d6                	or     %edx,%esi
  800b43:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b49:	75 0e                	jne    800b59 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b4b:	83 ef 04             	sub    $0x4,%edi
  800b4e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b54:	fd                   	std    
  800b55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b57:	eb 09                	jmp    800b62 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b59:	83 ef 01             	sub    $0x1,%edi
  800b5c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b5f:	fd                   	std    
  800b60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b62:	fc                   	cld    
  800b63:	eb 1a                	jmp    800b7f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	09 ca                	or     %ecx,%edx
  800b69:	09 f2                	or     %esi,%edx
  800b6b:	f6 c2 03             	test   $0x3,%dl
  800b6e:	75 0a                	jne    800b7a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b70:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	fc                   	cld    
  800b76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b78:	eb 05                	jmp    800b7f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b7a:	89 c7                	mov    %eax,%edi
  800b7c:	fc                   	cld    
  800b7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b89:	ff 75 10             	pushl  0x10(%ebp)
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	ff 75 08             	pushl  0x8(%ebp)
  800b92:	e8 8a ff ff ff       	call   800b21 <memmove>
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba4:	89 c6                	mov    %eax,%esi
  800ba6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba9:	39 f0                	cmp    %esi,%eax
  800bab:	74 1c                	je     800bc9 <memcmp+0x30>
		if (*s1 != *s2)
  800bad:	0f b6 08             	movzbl (%eax),%ecx
  800bb0:	0f b6 1a             	movzbl (%edx),%ebx
  800bb3:	38 d9                	cmp    %bl,%cl
  800bb5:	75 08                	jne    800bbf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb7:	83 c0 01             	add    $0x1,%eax
  800bba:	83 c2 01             	add    $0x1,%edx
  800bbd:	eb ea                	jmp    800ba9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bbf:	0f b6 c1             	movzbl %cl,%eax
  800bc2:	0f b6 db             	movzbl %bl,%ebx
  800bc5:	29 d8                	sub    %ebx,%eax
  800bc7:	eb 05                	jmp    800bce <memcmp+0x35>
	}

	return 0;
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bdb:	89 c2                	mov    %eax,%edx
  800bdd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be0:	39 d0                	cmp    %edx,%eax
  800be2:	73 09                	jae    800bed <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be4:	38 08                	cmp    %cl,(%eax)
  800be6:	74 05                	je     800bed <memfind+0x1b>
	for (; s < ends; s++)
  800be8:	83 c0 01             	add    $0x1,%eax
  800beb:	eb f3                	jmp    800be0 <memfind+0xe>
			break;
	return (void *) s;
}
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfb:	eb 03                	jmp    800c00 <strtol+0x11>
		s++;
  800bfd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c00:	0f b6 01             	movzbl (%ecx),%eax
  800c03:	3c 20                	cmp    $0x20,%al
  800c05:	74 f6                	je     800bfd <strtol+0xe>
  800c07:	3c 09                	cmp    $0x9,%al
  800c09:	74 f2                	je     800bfd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c0b:	3c 2b                	cmp    $0x2b,%al
  800c0d:	74 2a                	je     800c39 <strtol+0x4a>
	int neg = 0;
  800c0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c14:	3c 2d                	cmp    $0x2d,%al
  800c16:	74 2b                	je     800c43 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1e:	75 0f                	jne    800c2f <strtol+0x40>
  800c20:	80 39 30             	cmpb   $0x30,(%ecx)
  800c23:	74 28                	je     800c4d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2c:	0f 44 d8             	cmove  %eax,%ebx
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c37:	eb 50                	jmp    800c89 <strtol+0x9a>
		s++;
  800c39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c41:	eb d5                	jmp    800c18 <strtol+0x29>
		s++, neg = 1;
  800c43:	83 c1 01             	add    $0x1,%ecx
  800c46:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4b:	eb cb                	jmp    800c18 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c51:	74 0e                	je     800c61 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c53:	85 db                	test   %ebx,%ebx
  800c55:	75 d8                	jne    800c2f <strtol+0x40>
		s++, base = 8;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5f:	eb ce                	jmp    800c2f <strtol+0x40>
		s += 2, base = 16;
  800c61:	83 c1 02             	add    $0x2,%ecx
  800c64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c69:	eb c4                	jmp    800c2f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c6b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6e:	89 f3                	mov    %esi,%ebx
  800c70:	80 fb 19             	cmp    $0x19,%bl
  800c73:	77 29                	ja     800c9e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c75:	0f be d2             	movsbl %dl,%edx
  800c78:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7e:	7d 30                	jge    800cb0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c80:	83 c1 01             	add    $0x1,%ecx
  800c83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c89:	0f b6 11             	movzbl (%ecx),%edx
  800c8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8f:	89 f3                	mov    %esi,%ebx
  800c91:	80 fb 09             	cmp    $0x9,%bl
  800c94:	77 d5                	ja     800c6b <strtol+0x7c>
			dig = *s - '0';
  800c96:	0f be d2             	movsbl %dl,%edx
  800c99:	83 ea 30             	sub    $0x30,%edx
  800c9c:	eb dd                	jmp    800c7b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca1:	89 f3                	mov    %esi,%ebx
  800ca3:	80 fb 19             	cmp    $0x19,%bl
  800ca6:	77 08                	ja     800cb0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca8:	0f be d2             	movsbl %dl,%edx
  800cab:	83 ea 37             	sub    $0x37,%edx
  800cae:	eb cb                	jmp    800c7b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb4:	74 05                	je     800cbb <strtol+0xcc>
		*endptr = (char *) s;
  800cb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cbb:	89 c2                	mov    %eax,%edx
  800cbd:	f7 da                	neg    %edx
  800cbf:	85 ff                	test   %edi,%edi
  800cc1:	0f 45 c2             	cmovne %edx,%eax
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	89 c3                	mov    %eax,%ebx
  800cdc:	89 c7                	mov    %eax,%edi
  800cde:	89 c6                	mov    %eax,%esi
  800ce0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf7:	89 d1                	mov    %edx,%ecx
  800cf9:	89 d3                	mov    %edx,%ebx
  800cfb:	89 d7                	mov    %edx,%edi
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1c:	89 cb                	mov    %ecx,%ebx
  800d1e:	89 cf                	mov    %ecx,%edi
  800d20:	89 ce                	mov    %ecx,%esi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 03                	push   $0x3
  800d36:	68 e4 2e 80 00       	push   $0x802ee4
  800d3b:	6a 43                	push   $0x43
  800d3d:	68 01 2f 80 00       	push   $0x802f01
  800d42:	e8 64 19 00 00       	call   8026ab <_panic>

00800d47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d52:	b8 02 00 00 00       	mov    $0x2,%eax
  800d57:	89 d1                	mov    %edx,%ecx
  800d59:	89 d3                	mov    %edx,%ebx
  800d5b:	89 d7                	mov    %edx,%edi
  800d5d:	89 d6                	mov    %edx,%esi
  800d5f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <sys_yield>:

void
sys_yield(void)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d71:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d76:	89 d1                	mov    %edx,%ecx
  800d78:	89 d3                	mov    %edx,%ebx
  800d7a:	89 d7                	mov    %edx,%edi
  800d7c:	89 d6                	mov    %edx,%esi
  800d7e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	89 f7                	mov    %esi,%edi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800db5:	6a 04                	push   $0x4
  800db7:	68 e4 2e 80 00       	push   $0x802ee4
  800dbc:	6a 43                	push   $0x43
  800dbe:	68 01 2f 80 00       	push   $0x802f01
  800dc3:	e8 e3 18 00 00       	call   8026ab <_panic>

00800dc8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd7:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de2:	8b 75 18             	mov    0x18(%ebp),%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 05                	push   $0x5
  800df9:	68 e4 2e 80 00       	push   $0x802ee4
  800dfe:	6a 43                	push   $0x43
  800e00:	68 01 2f 80 00       	push   $0x802f01
  800e05:	e8 a1 18 00 00       	call   8026ab <_panic>

00800e0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 06                	push   $0x6
  800e3b:	68 e4 2e 80 00       	push   $0x802ee4
  800e40:	6a 43                	push   $0x43
  800e42:	68 01 2f 80 00       	push   $0x802f01
  800e47:	e8 5f 18 00 00       	call   8026ab <_panic>

00800e4c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 08 00 00 00       	mov    $0x8,%eax
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 08                	push   $0x8
  800e7d:	68 e4 2e 80 00       	push   $0x802ee4
  800e82:	6a 43                	push   $0x43
  800e84:	68 01 2f 80 00       	push   $0x802f01
  800e89:	e8 1d 18 00 00       	call   8026ab <_panic>

00800e8e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7f 08                	jg     800eb9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 09                	push   $0x9
  800ebf:	68 e4 2e 80 00       	push   $0x802ee4
  800ec4:	6a 43                	push   $0x43
  800ec6:	68 01 2f 80 00       	push   $0x802f01
  800ecb:	e8 db 17 00 00       	call   8026ab <_panic>

00800ed0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee9:	89 df                	mov    %ebx,%edi
  800eeb:	89 de                	mov    %ebx,%esi
  800eed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7f 08                	jg     800efb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	50                   	push   %eax
  800eff:	6a 0a                	push   $0xa
  800f01:	68 e4 2e 80 00       	push   $0x802ee4
  800f06:	6a 43                	push   $0x43
  800f08:	68 01 2f 80 00       	push   $0x802f01
  800f0d:	e8 99 17 00 00       	call   8026ab <_panic>

00800f12 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
  800f3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4b:	89 cb                	mov    %ecx,%ebx
  800f4d:	89 cf                	mov    %ecx,%edi
  800f4f:	89 ce                	mov    %ecx,%esi
  800f51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	7f 08                	jg     800f5f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	50                   	push   %eax
  800f63:	6a 0d                	push   $0xd
  800f65:	68 e4 2e 80 00       	push   $0x802ee4
  800f6a:	6a 43                	push   $0x43
  800f6c:	68 01 2f 80 00       	push   $0x802f01
  800f71:	e8 35 17 00 00       	call   8026ab <_panic>

00800f76 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800faa:	89 cb                	mov    %ecx,%ebx
  800fac:	89 cf                	mov    %ecx,%edi
  800fae:	89 ce                	mov    %ecx,%esi
  800fb0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 d3                	mov    %edx,%ebx
  800fcb:	89 d7                	mov    %edx,%edi
  800fcd:	89 d6                	mov    %edx,%esi
  800fcf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fec:	89 df                	mov    %ebx,%edi
  800fee:	89 de                	mov    %ebx,%esi
  800ff0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5f                   	pop    %edi
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
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
  801008:	b8 12 00 00 00       	mov    $0x12,%eax
  80100d:	89 df                	mov    %ebx,%edi
  80100f:	89 de                	mov    %ebx,%esi
  801011:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801021:	bb 00 00 00 00       	mov    $0x0,%ebx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102c:	b8 13 00 00 00       	mov    $0x13,%eax
  801031:	89 df                	mov    %ebx,%edi
  801033:	89 de                	mov    %ebx,%esi
  801035:	cd 30                	int    $0x30
	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7f 08                	jg     801043 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80103b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	50                   	push   %eax
  801047:	6a 13                	push   $0x13
  801049:	68 e4 2e 80 00       	push   $0x802ee4
  80104e:	6a 43                	push   $0x43
  801050:	68 01 2f 80 00       	push   $0x802f01
  801055:	e8 51 16 00 00       	call   8026ab <_panic>

0080105a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	53                   	push   %ebx
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801064:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801066:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80106a:	0f 84 99 00 00 00    	je     801109 <pgfault+0xaf>
  801070:	89 c2                	mov    %eax,%edx
  801072:	c1 ea 16             	shr    $0x16,%edx
  801075:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107c:	f6 c2 01             	test   $0x1,%dl
  80107f:	0f 84 84 00 00 00    	je     801109 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801085:	89 c2                	mov    %eax,%edx
  801087:	c1 ea 0c             	shr    $0xc,%edx
  80108a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801091:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801097:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80109d:	75 6a                	jne    801109 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  80109f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a4:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8010a6:	83 ec 04             	sub    $0x4,%esp
  8010a9:	6a 07                	push   $0x7
  8010ab:	68 00 f0 7f 00       	push   $0x7ff000
  8010b0:	6a 00                	push   $0x0
  8010b2:	e8 ce fc ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	78 5f                	js     80111d <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	68 00 10 00 00       	push   $0x1000
  8010c6:	53                   	push   %ebx
  8010c7:	68 00 f0 7f 00       	push   $0x7ff000
  8010cc:	e8 b2 fa ff ff       	call   800b83 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8010d1:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010d8:	53                   	push   %ebx
  8010d9:	6a 00                	push   $0x0
  8010db:	68 00 f0 7f 00       	push   $0x7ff000
  8010e0:	6a 00                	push   $0x0
  8010e2:	e8 e1 fc ff ff       	call   800dc8 <sys_page_map>
	if(ret < 0)
  8010e7:	83 c4 20             	add    $0x20,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 43                	js     801131 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	68 00 f0 7f 00       	push   $0x7ff000
  8010f6:	6a 00                	push   $0x0
  8010f8:	e8 0d fd ff ff       	call   800e0a <sys_page_unmap>
	if(ret < 0)
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 41                	js     801145 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801107:	c9                   	leave  
  801108:	c3                   	ret    
		panic("panic at pgfault()\n");
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	68 0f 2f 80 00       	push   $0x802f0f
  801111:	6a 26                	push   $0x26
  801113:	68 23 2f 80 00       	push   $0x802f23
  801118:	e8 8e 15 00 00       	call   8026ab <_panic>
		panic("panic in sys_page_alloc()\n");
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	68 2e 2f 80 00       	push   $0x802f2e
  801125:	6a 31                	push   $0x31
  801127:	68 23 2f 80 00       	push   $0x802f23
  80112c:	e8 7a 15 00 00       	call   8026ab <_panic>
		panic("panic in sys_page_map()\n");
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 49 2f 80 00       	push   $0x802f49
  801139:	6a 36                	push   $0x36
  80113b:	68 23 2f 80 00       	push   $0x802f23
  801140:	e8 66 15 00 00       	call   8026ab <_panic>
		panic("panic in sys_page_unmap()\n");
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	68 62 2f 80 00       	push   $0x802f62
  80114d:	6a 39                	push   $0x39
  80114f:	68 23 2f 80 00       	push   $0x802f23
  801154:	e8 52 15 00 00       	call   8026ab <_panic>

00801159 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	89 c6                	mov    %eax,%esi
  801160:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	68 00 30 80 00       	push   $0x803000
  80116a:	68 33 31 80 00       	push   $0x803133
  80116f:	e8 c0 f0 ff ff       	call   800234 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801174:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	f6 c4 04             	test   $0x4,%ah
  801181:	75 45                	jne    8011c8 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801183:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80118a:	83 e0 07             	and    $0x7,%eax
  80118d:	83 f8 07             	cmp    $0x7,%eax
  801190:	74 6e                	je     801200 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801192:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801199:	25 05 08 00 00       	and    $0x805,%eax
  80119e:	3d 05 08 00 00       	cmp    $0x805,%eax
  8011a3:	0f 84 b5 00 00 00    	je     80125e <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011a9:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011b0:	83 e0 05             	and    $0x5,%eax
  8011b3:	83 f8 05             	cmp    $0x5,%eax
  8011b6:	0f 84 d6 00 00 00    	je     801292 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c4:	5b                   	pop    %ebx
  8011c5:	5e                   	pop    %esi
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011c8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cf:	c1 e3 0c             	shl    $0xc,%ebx
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8011da:	50                   	push   %eax
  8011db:	53                   	push   %ebx
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	6a 00                	push   $0x0
  8011e0:	e8 e3 fb ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  8011e5:	83 c4 20             	add    $0x20,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	79 d0                	jns    8011bc <duppage+0x63>
			panic("sys_page_map() panic\n");
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	68 7d 2f 80 00       	push   $0x802f7d
  8011f4:	6a 55                	push   $0x55
  8011f6:	68 23 2f 80 00       	push   $0x802f23
  8011fb:	e8 ab 14 00 00       	call   8026ab <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801200:	c1 e3 0c             	shl    $0xc,%ebx
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	68 05 08 00 00       	push   $0x805
  80120b:	53                   	push   %ebx
  80120c:	56                   	push   %esi
  80120d:	53                   	push   %ebx
  80120e:	6a 00                	push   $0x0
  801210:	e8 b3 fb ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  801215:	83 c4 20             	add    $0x20,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	78 2e                	js     80124a <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	68 05 08 00 00       	push   $0x805
  801224:	53                   	push   %ebx
  801225:	6a 00                	push   $0x0
  801227:	53                   	push   %ebx
  801228:	6a 00                	push   $0x0
  80122a:	e8 99 fb ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  80122f:	83 c4 20             	add    $0x20,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	79 86                	jns    8011bc <duppage+0x63>
			panic("sys_page_map() panic\n");
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	68 7d 2f 80 00       	push   $0x802f7d
  80123e:	6a 60                	push   $0x60
  801240:	68 23 2f 80 00       	push   $0x802f23
  801245:	e8 61 14 00 00       	call   8026ab <_panic>
			panic("sys_page_map() panic\n");
  80124a:	83 ec 04             	sub    $0x4,%esp
  80124d:	68 7d 2f 80 00       	push   $0x802f7d
  801252:	6a 5c                	push   $0x5c
  801254:	68 23 2f 80 00       	push   $0x802f23
  801259:	e8 4d 14 00 00       	call   8026ab <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80125e:	c1 e3 0c             	shl    $0xc,%ebx
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	68 05 08 00 00       	push   $0x805
  801269:	53                   	push   %ebx
  80126a:	56                   	push   %esi
  80126b:	53                   	push   %ebx
  80126c:	6a 00                	push   $0x0
  80126e:	e8 55 fb ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  801273:	83 c4 20             	add    $0x20,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	0f 89 3e ff ff ff    	jns    8011bc <duppage+0x63>
			panic("sys_page_map() panic\n");
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	68 7d 2f 80 00       	push   $0x802f7d
  801286:	6a 67                	push   $0x67
  801288:	68 23 2f 80 00       	push   $0x802f23
  80128d:	e8 19 14 00 00       	call   8026ab <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801292:	c1 e3 0c             	shl    $0xc,%ebx
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	6a 05                	push   $0x5
  80129a:	53                   	push   %ebx
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	6a 00                	push   $0x0
  80129f:	e8 24 fb ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  8012a4:	83 c4 20             	add    $0x20,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	0f 89 0d ff ff ff    	jns    8011bc <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	68 7d 2f 80 00       	push   $0x802f7d
  8012b7:	6a 6e                	push   $0x6e
  8012b9:	68 23 2f 80 00       	push   $0x802f23
  8012be:	e8 e8 13 00 00       	call   8026ab <_panic>

008012c3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	57                   	push   %edi
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012cc:	68 5a 10 80 00       	push   $0x80105a
  8012d1:	e8 36 14 00 00       	call   80270c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012d6:	b8 07 00 00 00       	mov    $0x7,%eax
  8012db:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	78 27                	js     80130b <fork+0x48>
  8012e4:	89 c6                	mov    %eax,%esi
  8012e6:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012e8:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012ed:	75 48                	jne    801337 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ef:	e8 53 fa ff ff       	call   800d47 <sys_getenvid>
  8012f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f9:	c1 e0 07             	shl    $0x7,%eax
  8012fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801301:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801306:	e9 90 00 00 00       	jmp    80139b <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	68 94 2f 80 00       	push   $0x802f94
  801313:	68 8d 00 00 00       	push   $0x8d
  801318:	68 23 2f 80 00       	push   $0x802f23
  80131d:	e8 89 13 00 00       	call   8026ab <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801322:	89 f8                	mov    %edi,%eax
  801324:	e8 30 fe ff ff       	call   801159 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801329:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80132f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801335:	74 26                	je     80135d <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801337:	89 d8                	mov    %ebx,%eax
  801339:	c1 e8 16             	shr    $0x16,%eax
  80133c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801343:	a8 01                	test   $0x1,%al
  801345:	74 e2                	je     801329 <fork+0x66>
  801347:	89 da                	mov    %ebx,%edx
  801349:	c1 ea 0c             	shr    $0xc,%edx
  80134c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801353:	83 e0 05             	and    $0x5,%eax
  801356:	83 f8 05             	cmp    $0x5,%eax
  801359:	75 ce                	jne    801329 <fork+0x66>
  80135b:	eb c5                	jmp    801322 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	6a 07                	push   $0x7
  801362:	68 00 f0 bf ee       	push   $0xeebff000
  801367:	56                   	push   %esi
  801368:	e8 18 fa ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	78 31                	js     8013a5 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801374:	83 ec 08             	sub    $0x8,%esp
  801377:	68 7b 27 80 00       	push   $0x80277b
  80137c:	56                   	push   %esi
  80137d:	e8 4e fb ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 33                	js     8013bc <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	6a 02                	push   $0x2
  80138e:	56                   	push   %esi
  80138f:	e8 b8 fa ff ff       	call   800e4c <sys_env_set_status>
	if(ret < 0)
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	78 38                	js     8013d3 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80139b:	89 f0                	mov    %esi,%eax
  80139d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5e                   	pop    %esi
  8013a2:	5f                   	pop    %edi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	68 2e 2f 80 00       	push   $0x802f2e
  8013ad:	68 99 00 00 00       	push   $0x99
  8013b2:	68 23 2f 80 00       	push   $0x802f23
  8013b7:	e8 ef 12 00 00       	call   8026ab <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 b8 2f 80 00       	push   $0x802fb8
  8013c4:	68 9c 00 00 00       	push   $0x9c
  8013c9:	68 23 2f 80 00       	push   $0x802f23
  8013ce:	e8 d8 12 00 00       	call   8026ab <_panic>
		panic("panic in sys_env_set_status()\n");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 e0 2f 80 00       	push   $0x802fe0
  8013db:	68 9f 00 00 00       	push   $0x9f
  8013e0:	68 23 2f 80 00       	push   $0x802f23
  8013e5:	e8 c1 12 00 00       	call   8026ab <_panic>

008013ea <sfork>:

// Challenge!
int
sfork(void)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	57                   	push   %edi
  8013ee:	56                   	push   %esi
  8013ef:	53                   	push   %ebx
  8013f0:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013f3:	68 5a 10 80 00       	push   $0x80105a
  8013f8:	e8 0f 13 00 00       	call   80270c <set_pgfault_handler>
  8013fd:	b8 07 00 00 00       	mov    $0x7,%eax
  801402:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	78 27                	js     801432 <sfork+0x48>
  80140b:	89 c7                	mov    %eax,%edi
  80140d:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80140f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801414:	75 55                	jne    80146b <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801416:	e8 2c f9 ff ff       	call   800d47 <sys_getenvid>
  80141b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801420:	c1 e0 07             	shl    $0x7,%eax
  801423:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801428:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80142d:	e9 d4 00 00 00       	jmp    801506 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	68 94 2f 80 00       	push   $0x802f94
  80143a:	68 b0 00 00 00       	push   $0xb0
  80143f:	68 23 2f 80 00       	push   $0x802f23
  801444:	e8 62 12 00 00       	call   8026ab <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801449:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80144e:	89 f0                	mov    %esi,%eax
  801450:	e8 04 fd ff ff       	call   801159 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801455:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80145b:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801461:	77 65                	ja     8014c8 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801463:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801469:	74 de                	je     801449 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80146b:	89 d8                	mov    %ebx,%eax
  80146d:	c1 e8 16             	shr    $0x16,%eax
  801470:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801477:	a8 01                	test   $0x1,%al
  801479:	74 da                	je     801455 <sfork+0x6b>
  80147b:	89 da                	mov    %ebx,%edx
  80147d:	c1 ea 0c             	shr    $0xc,%edx
  801480:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801487:	83 e0 05             	and    $0x5,%eax
  80148a:	83 f8 05             	cmp    $0x5,%eax
  80148d:	75 c6                	jne    801455 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80148f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801496:	c1 e2 0c             	shl    $0xc,%edx
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	83 e0 07             	and    $0x7,%eax
  80149f:	50                   	push   %eax
  8014a0:	52                   	push   %edx
  8014a1:	56                   	push   %esi
  8014a2:	52                   	push   %edx
  8014a3:	6a 00                	push   $0x0
  8014a5:	e8 1e f9 ff ff       	call   800dc8 <sys_page_map>
  8014aa:	83 c4 20             	add    $0x20,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	74 a4                	je     801455 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	68 7d 2f 80 00       	push   $0x802f7d
  8014b9:	68 bb 00 00 00       	push   $0xbb
  8014be:	68 23 2f 80 00       	push   $0x802f23
  8014c3:	e8 e3 11 00 00       	call   8026ab <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	6a 07                	push   $0x7
  8014cd:	68 00 f0 bf ee       	push   $0xeebff000
  8014d2:	57                   	push   %edi
  8014d3:	e8 ad f8 ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 31                	js     801510 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	68 7b 27 80 00       	push   $0x80277b
  8014e7:	57                   	push   %edi
  8014e8:	e8 e3 f9 ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 33                	js     801527 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	6a 02                	push   $0x2
  8014f9:	57                   	push   %edi
  8014fa:	e8 4d f9 ff ff       	call   800e4c <sys_env_set_status>
	if(ret < 0)
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 38                	js     80153e <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801506:	89 f8                	mov    %edi,%eax
  801508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150b:	5b                   	pop    %ebx
  80150c:	5e                   	pop    %esi
  80150d:	5f                   	pop    %edi
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 2e 2f 80 00       	push   $0x802f2e
  801518:	68 c1 00 00 00       	push   $0xc1
  80151d:	68 23 2f 80 00       	push   $0x802f23
  801522:	e8 84 11 00 00       	call   8026ab <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 b8 2f 80 00       	push   $0x802fb8
  80152f:	68 c4 00 00 00       	push   $0xc4
  801534:	68 23 2f 80 00       	push   $0x802f23
  801539:	e8 6d 11 00 00       	call   8026ab <_panic>
		panic("panic in sys_env_set_status()\n");
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 e0 2f 80 00       	push   $0x802fe0
  801546:	68 c7 00 00 00       	push   $0xc7
  80154b:	68 23 2f 80 00       	push   $0x802f23
  801550:	e8 56 11 00 00       	call   8026ab <_panic>

00801555 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	05 00 00 00 30       	add    $0x30000000,%eax
  801560:	c1 e8 0c             	shr    $0xc,%eax
}
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801570:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801575:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801584:	89 c2                	mov    %eax,%edx
  801586:	c1 ea 16             	shr    $0x16,%edx
  801589:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801590:	f6 c2 01             	test   $0x1,%dl
  801593:	74 2d                	je     8015c2 <fd_alloc+0x46>
  801595:	89 c2                	mov    %eax,%edx
  801597:	c1 ea 0c             	shr    $0xc,%edx
  80159a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015a1:	f6 c2 01             	test   $0x1,%dl
  8015a4:	74 1c                	je     8015c2 <fd_alloc+0x46>
  8015a6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015ab:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015b0:	75 d2                	jne    801584 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015bb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015c0:	eb 0a                	jmp    8015cc <fd_alloc+0x50>
			*fd_store = fd;
  8015c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015d4:	83 f8 1f             	cmp    $0x1f,%eax
  8015d7:	77 30                	ja     801609 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015d9:	c1 e0 0c             	shl    $0xc,%eax
  8015dc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015e1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015e7:	f6 c2 01             	test   $0x1,%dl
  8015ea:	74 24                	je     801610 <fd_lookup+0x42>
  8015ec:	89 c2                	mov    %eax,%edx
  8015ee:	c1 ea 0c             	shr    $0xc,%edx
  8015f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f8:	f6 c2 01             	test   $0x1,%dl
  8015fb:	74 1a                	je     801617 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801600:	89 02                	mov    %eax,(%edx)
	return 0;
  801602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801607:	5d                   	pop    %ebp
  801608:	c3                   	ret    
		return -E_INVAL;
  801609:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160e:	eb f7                	jmp    801607 <fd_lookup+0x39>
		return -E_INVAL;
  801610:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801615:	eb f0                	jmp    801607 <fd_lookup+0x39>
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb e9                	jmp    801607 <fd_lookup+0x39>

0080161e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801631:	39 08                	cmp    %ecx,(%eax)
  801633:	74 38                	je     80166d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801635:	83 c2 01             	add    $0x1,%edx
  801638:	8b 04 95 84 30 80 00 	mov    0x803084(,%edx,4),%eax
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 ee                	jne    801631 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801643:	a1 08 50 80 00       	mov    0x805008,%eax
  801648:	8b 40 48             	mov    0x48(%eax),%eax
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	51                   	push   %ecx
  80164f:	50                   	push   %eax
  801650:	68 08 30 80 00       	push   $0x803008
  801655:	e8 da eb ff ff       	call   800234 <cprintf>
	*dev = 0;
  80165a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    
			*dev = devtab[i];
  80166d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801670:	89 01                	mov    %eax,(%ecx)
			return 0;
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
  801677:	eb f2                	jmp    80166b <dev_lookup+0x4d>

00801679 <fd_close>:
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	57                   	push   %edi
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
  80167f:	83 ec 24             	sub    $0x24,%esp
  801682:	8b 75 08             	mov    0x8(%ebp),%esi
  801685:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801688:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80168b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80168c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801692:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801695:	50                   	push   %eax
  801696:	e8 33 ff ff ff       	call   8015ce <fd_lookup>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 05                	js     8016a9 <fd_close+0x30>
	    || fd != fd2)
  8016a4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016a7:	74 16                	je     8016bf <fd_close+0x46>
		return (must_exist ? r : 0);
  8016a9:	89 f8                	mov    %edi,%eax
  8016ab:	84 c0                	test   %al,%al
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	0f 44 d8             	cmove  %eax,%ebx
}
  8016b5:	89 d8                	mov    %ebx,%eax
  8016b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5f                   	pop    %edi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	ff 36                	pushl  (%esi)
  8016c8:	e8 51 ff ff ff       	call   80161e <dev_lookup>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 1a                	js     8016f0 <fd_close+0x77>
		if (dev->dev_close)
  8016d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016dc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	74 0b                	je     8016f0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	56                   	push   %esi
  8016e9:	ff d0                	call   *%eax
  8016eb:	89 c3                	mov    %eax,%ebx
  8016ed:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	56                   	push   %esi
  8016f4:	6a 00                	push   $0x0
  8016f6:	e8 0f f7 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	eb b5                	jmp    8016b5 <fd_close+0x3c>

00801700 <close>:

int
close(int fdnum)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801706:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801709:	50                   	push   %eax
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	e8 bc fe ff ff       	call   8015ce <fd_lookup>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	85 c0                	test   %eax,%eax
  801717:	79 02                	jns    80171b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    
		return fd_close(fd, 1);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	6a 01                	push   $0x1
  801720:	ff 75 f4             	pushl  -0xc(%ebp)
  801723:	e8 51 ff ff ff       	call   801679 <fd_close>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	eb ec                	jmp    801719 <close+0x19>

0080172d <close_all>:

void
close_all(void)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
  801731:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801734:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801739:	83 ec 0c             	sub    $0xc,%esp
  80173c:	53                   	push   %ebx
  80173d:	e8 be ff ff ff       	call   801700 <close>
	for (i = 0; i < MAXFD; i++)
  801742:	83 c3 01             	add    $0x1,%ebx
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	83 fb 20             	cmp    $0x20,%ebx
  80174b:	75 ec                	jne    801739 <close_all+0xc>
}
  80174d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	57                   	push   %edi
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80175b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	e8 67 fe ff ff       	call   8015ce <fd_lookup>
  801767:	89 c3                	mov    %eax,%ebx
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	0f 88 81 00 00 00    	js     8017f5 <dup+0xa3>
		return r;
	close(newfdnum);
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	e8 81 ff ff ff       	call   801700 <close>

	newfd = INDEX2FD(newfdnum);
  80177f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801782:	c1 e6 0c             	shl    $0xc,%esi
  801785:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80178b:	83 c4 04             	add    $0x4,%esp
  80178e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801791:	e8 cf fd ff ff       	call   801565 <fd2data>
  801796:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801798:	89 34 24             	mov    %esi,(%esp)
  80179b:	e8 c5 fd ff ff       	call   801565 <fd2data>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	c1 e8 16             	shr    $0x16,%eax
  8017aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017b1:	a8 01                	test   $0x1,%al
  8017b3:	74 11                	je     8017c6 <dup+0x74>
  8017b5:	89 d8                	mov    %ebx,%eax
  8017b7:	c1 e8 0c             	shr    $0xc,%eax
  8017ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017c1:	f6 c2 01             	test   $0x1,%dl
  8017c4:	75 39                	jne    8017ff <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	c1 e8 0c             	shr    $0xc,%eax
  8017ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8017dd:	50                   	push   %eax
  8017de:	56                   	push   %esi
  8017df:	6a 00                	push   $0x0
  8017e1:	52                   	push   %edx
  8017e2:	6a 00                	push   $0x0
  8017e4:	e8 df f5 ff ff       	call   800dc8 <sys_page_map>
  8017e9:	89 c3                	mov    %eax,%ebx
  8017eb:	83 c4 20             	add    $0x20,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 31                	js     801823 <dup+0xd1>
		goto err;

	return newfdnum;
  8017f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5f                   	pop    %edi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	25 07 0e 00 00       	and    $0xe07,%eax
  80180e:	50                   	push   %eax
  80180f:	57                   	push   %edi
  801810:	6a 00                	push   $0x0
  801812:	53                   	push   %ebx
  801813:	6a 00                	push   $0x0
  801815:	e8 ae f5 ff ff       	call   800dc8 <sys_page_map>
  80181a:	89 c3                	mov    %eax,%ebx
  80181c:	83 c4 20             	add    $0x20,%esp
  80181f:	85 c0                	test   %eax,%eax
  801821:	79 a3                	jns    8017c6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	56                   	push   %esi
  801827:	6a 00                	push   $0x0
  801829:	e8 dc f5 ff ff       	call   800e0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80182e:	83 c4 08             	add    $0x8,%esp
  801831:	57                   	push   %edi
  801832:	6a 00                	push   $0x0
  801834:	e8 d1 f5 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	eb b7                	jmp    8017f5 <dup+0xa3>

0080183e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	53                   	push   %ebx
  801842:	83 ec 1c             	sub    $0x1c,%esp
  801845:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801848:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	53                   	push   %ebx
  80184d:	e8 7c fd ff ff       	call   8015ce <fd_lookup>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	85 c0                	test   %eax,%eax
  801857:	78 3f                	js     801898 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185f:	50                   	push   %eax
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	ff 30                	pushl  (%eax)
  801865:	e8 b4 fd ff ff       	call   80161e <dev_lookup>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 27                	js     801898 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801871:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801874:	8b 42 08             	mov    0x8(%edx),%eax
  801877:	83 e0 03             	and    $0x3,%eax
  80187a:	83 f8 01             	cmp    $0x1,%eax
  80187d:	74 1e                	je     80189d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	8b 40 08             	mov    0x8(%eax),%eax
  801885:	85 c0                	test   %eax,%eax
  801887:	74 35                	je     8018be <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	ff 75 10             	pushl  0x10(%ebp)
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	52                   	push   %edx
  801893:	ff d0                	call   *%eax
  801895:	83 c4 10             	add    $0x10,%esp
}
  801898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80189d:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a2:	8b 40 48             	mov    0x48(%eax),%eax
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	53                   	push   %ebx
  8018a9:	50                   	push   %eax
  8018aa:	68 49 30 80 00       	push   $0x803049
  8018af:	e8 80 e9 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bc:	eb da                	jmp    801898 <read+0x5a>
		return -E_NOT_SUPP;
  8018be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c3:	eb d3                	jmp    801898 <read+0x5a>

008018c5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d9:	39 f3                	cmp    %esi,%ebx
  8018db:	73 23                	jae    801900 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	89 f0                	mov    %esi,%eax
  8018e2:	29 d8                	sub    %ebx,%eax
  8018e4:	50                   	push   %eax
  8018e5:	89 d8                	mov    %ebx,%eax
  8018e7:	03 45 0c             	add    0xc(%ebp),%eax
  8018ea:	50                   	push   %eax
  8018eb:	57                   	push   %edi
  8018ec:	e8 4d ff ff ff       	call   80183e <read>
		if (m < 0)
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 06                	js     8018fe <readn+0x39>
			return m;
		if (m == 0)
  8018f8:	74 06                	je     801900 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018fa:	01 c3                	add    %eax,%ebx
  8018fc:	eb db                	jmp    8018d9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018fe:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801900:	89 d8                	mov    %ebx,%eax
  801902:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 1c             	sub    $0x1c,%esp
  801911:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801914:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	53                   	push   %ebx
  801919:	e8 b0 fc ff ff       	call   8015ce <fd_lookup>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	78 3a                	js     80195f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	ff 30                	pushl  (%eax)
  801931:	e8 e8 fc ff ff       	call   80161e <dev_lookup>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 22                	js     80195f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801940:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801944:	74 1e                	je     801964 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801949:	8b 52 0c             	mov    0xc(%edx),%edx
  80194c:	85 d2                	test   %edx,%edx
  80194e:	74 35                	je     801985 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	50                   	push   %eax
  80195a:	ff d2                	call   *%edx
  80195c:	83 c4 10             	add    $0x10,%esp
}
  80195f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801962:	c9                   	leave  
  801963:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801964:	a1 08 50 80 00       	mov    0x805008,%eax
  801969:	8b 40 48             	mov    0x48(%eax),%eax
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	53                   	push   %ebx
  801970:	50                   	push   %eax
  801971:	68 65 30 80 00       	push   $0x803065
  801976:	e8 b9 e8 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801983:	eb da                	jmp    80195f <write+0x55>
		return -E_NOT_SUPP;
  801985:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198a:	eb d3                	jmp    80195f <write+0x55>

0080198c <seek>:

int
seek(int fdnum, off_t offset)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801995:	50                   	push   %eax
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	e8 30 fc ff ff       	call   8015ce <fd_lookup>
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 0e                	js     8019b3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ab:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 1c             	sub    $0x1c,%esp
  8019bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	53                   	push   %ebx
  8019c4:	e8 05 fc ff ff       	call   8015ce <fd_lookup>
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 37                	js     801a07 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d6:	50                   	push   %eax
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	ff 30                	pushl  (%eax)
  8019dc:	e8 3d fc ff ff       	call   80161e <dev_lookup>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 1f                	js     801a07 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ef:	74 1b                	je     801a0c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f4:	8b 52 18             	mov    0x18(%edx),%edx
  8019f7:	85 d2                	test   %edx,%edx
  8019f9:	74 32                	je     801a2d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	50                   	push   %eax
  801a02:	ff d2                	call   *%edx
  801a04:	83 c4 10             	add    $0x10,%esp
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a0c:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a11:	8b 40 48             	mov    0x48(%eax),%eax
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	53                   	push   %ebx
  801a18:	50                   	push   %eax
  801a19:	68 28 30 80 00       	push   $0x803028
  801a1e:	e8 11 e8 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a2b:	eb da                	jmp    801a07 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a2d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a32:	eb d3                	jmp    801a07 <ftruncate+0x52>

00801a34 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	53                   	push   %ebx
  801a38:	83 ec 1c             	sub    $0x1c,%esp
  801a3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a41:	50                   	push   %eax
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	e8 84 fb ff ff       	call   8015ce <fd_lookup>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 4b                	js     801a9c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a51:	83 ec 08             	sub    $0x8,%esp
  801a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a57:	50                   	push   %eax
  801a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5b:	ff 30                	pushl  (%eax)
  801a5d:	e8 bc fb ff ff       	call   80161e <dev_lookup>
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 33                	js     801a9c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a70:	74 2f                	je     801aa1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a72:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a75:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a7c:	00 00 00 
	stat->st_isdir = 0;
  801a7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a86:	00 00 00 
	stat->st_dev = dev;
  801a89:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	53                   	push   %ebx
  801a93:	ff 75 f0             	pushl  -0x10(%ebp)
  801a96:	ff 50 14             	call   *0x14(%eax)
  801a99:	83 c4 10             	add    $0x10,%esp
}
  801a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    
		return -E_NOT_SUPP;
  801aa1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa6:	eb f4                	jmp    801a9c <fstat+0x68>

00801aa8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aad:	83 ec 08             	sub    $0x8,%esp
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	e8 22 02 00 00       	call   801cdc <open>
  801aba:	89 c3                	mov    %eax,%ebx
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 1b                	js     801ade <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	50                   	push   %eax
  801aca:	e8 65 ff ff ff       	call   801a34 <fstat>
  801acf:	89 c6                	mov    %eax,%esi
	close(fd);
  801ad1:	89 1c 24             	mov    %ebx,(%esp)
  801ad4:	e8 27 fc ff ff       	call   801700 <close>
	return r;
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	89 f3                	mov    %esi,%ebx
}
  801ade:	89 d8                	mov    %ebx,%eax
  801ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    

00801ae7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	89 c6                	mov    %eax,%esi
  801aee:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801af0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801af7:	74 27                	je     801b20 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801af9:	6a 07                	push   $0x7
  801afb:	68 00 60 80 00       	push   $0x806000
  801b00:	56                   	push   %esi
  801b01:	ff 35 00 50 80 00    	pushl  0x805000
  801b07:	e8 fe 0c 00 00       	call   80280a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b0c:	83 c4 0c             	add    $0xc,%esp
  801b0f:	6a 00                	push   $0x0
  801b11:	53                   	push   %ebx
  801b12:	6a 00                	push   $0x0
  801b14:	e8 88 0c 00 00       	call   8027a1 <ipc_recv>
}
  801b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	6a 01                	push   $0x1
  801b25:	e8 38 0d 00 00       	call   802862 <ipc_find_env>
  801b2a:	a3 00 50 80 00       	mov    %eax,0x805000
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	eb c5                	jmp    801af9 <fsipc+0x12>

00801b34 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b40:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b48:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	b8 02 00 00 00       	mov    $0x2,%eax
  801b57:	e8 8b ff ff ff       	call   801ae7 <fsipc>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <devfile_flush>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	b8 06 00 00 00       	mov    $0x6,%eax
  801b79:	e8 69 ff ff ff       	call   801ae7 <fsipc>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <devfile_stat>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b90:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b95:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9a:	b8 05 00 00 00       	mov    $0x5,%eax
  801b9f:	e8 43 ff ff ff       	call   801ae7 <fsipc>
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 2c                	js     801bd4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	68 00 60 80 00       	push   $0x806000
  801bb0:	53                   	push   %ebx
  801bb1:	e8 dd ed ff ff       	call   800993 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bb6:	a1 80 60 80 00       	mov    0x806080,%eax
  801bbb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bc1:	a1 84 60 80 00       	mov    0x806084,%eax
  801bc6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <devfile_write>:
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	8b 40 0c             	mov    0xc(%eax),%eax
  801be9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bee:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bf4:	53                   	push   %ebx
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	68 08 60 80 00       	push   $0x806008
  801bfd:	e8 81 ef ff ff       	call   800b83 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	b8 04 00 00 00       	mov    $0x4,%eax
  801c0c:	e8 d6 fe ff ff       	call   801ae7 <fsipc>
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 0b                	js     801c23 <devfile_write+0x4a>
	assert(r <= n);
  801c18:	39 d8                	cmp    %ebx,%eax
  801c1a:	77 0c                	ja     801c28 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c1c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c21:	7f 1e                	jg     801c41 <devfile_write+0x68>
}
  801c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    
	assert(r <= n);
  801c28:	68 98 30 80 00       	push   $0x803098
  801c2d:	68 9f 30 80 00       	push   $0x80309f
  801c32:	68 98 00 00 00       	push   $0x98
  801c37:	68 b4 30 80 00       	push   $0x8030b4
  801c3c:	e8 6a 0a 00 00       	call   8026ab <_panic>
	assert(r <= PGSIZE);
  801c41:	68 bf 30 80 00       	push   $0x8030bf
  801c46:	68 9f 30 80 00       	push   $0x80309f
  801c4b:	68 99 00 00 00       	push   $0x99
  801c50:	68 b4 30 80 00       	push   $0x8030b4
  801c55:	e8 51 0a 00 00       	call   8026ab <_panic>

00801c5a <devfile_read>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	56                   	push   %esi
  801c5e:	53                   	push   %ebx
  801c5f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8b 40 0c             	mov    0xc(%eax),%eax
  801c68:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c6d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c73:	ba 00 00 00 00       	mov    $0x0,%edx
  801c78:	b8 03 00 00 00       	mov    $0x3,%eax
  801c7d:	e8 65 fe ff ff       	call   801ae7 <fsipc>
  801c82:	89 c3                	mov    %eax,%ebx
  801c84:	85 c0                	test   %eax,%eax
  801c86:	78 1f                	js     801ca7 <devfile_read+0x4d>
	assert(r <= n);
  801c88:	39 f0                	cmp    %esi,%eax
  801c8a:	77 24                	ja     801cb0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c8c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c91:	7f 33                	jg     801cc6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	50                   	push   %eax
  801c97:	68 00 60 80 00       	push   $0x806000
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	e8 7d ee ff ff       	call   800b21 <memmove>
	return r;
  801ca4:	83 c4 10             	add    $0x10,%esp
}
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
	assert(r <= n);
  801cb0:	68 98 30 80 00       	push   $0x803098
  801cb5:	68 9f 30 80 00       	push   $0x80309f
  801cba:	6a 7c                	push   $0x7c
  801cbc:	68 b4 30 80 00       	push   $0x8030b4
  801cc1:	e8 e5 09 00 00       	call   8026ab <_panic>
	assert(r <= PGSIZE);
  801cc6:	68 bf 30 80 00       	push   $0x8030bf
  801ccb:	68 9f 30 80 00       	push   $0x80309f
  801cd0:	6a 7d                	push   $0x7d
  801cd2:	68 b4 30 80 00       	push   $0x8030b4
  801cd7:	e8 cf 09 00 00       	call   8026ab <_panic>

00801cdc <open>:
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 1c             	sub    $0x1c,%esp
  801ce4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ce7:	56                   	push   %esi
  801ce8:	e8 6d ec ff ff       	call   80095a <strlen>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf5:	7f 6c                	jg     801d63 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfd:	50                   	push   %eax
  801cfe:	e8 79 f8 ff ff       	call   80157c <fd_alloc>
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 3c                	js     801d48 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d0c:	83 ec 08             	sub    $0x8,%esp
  801d0f:	56                   	push   %esi
  801d10:	68 00 60 80 00       	push   $0x806000
  801d15:	e8 79 ec ff ff       	call   800993 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d25:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2a:	e8 b8 fd ff ff       	call   801ae7 <fsipc>
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	85 c0                	test   %eax,%eax
  801d36:	78 19                	js     801d51 <open+0x75>
	return fd2num(fd);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3e:	e8 12 f8 ff ff       	call   801555 <fd2num>
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	83 c4 10             	add    $0x10,%esp
}
  801d48:	89 d8                	mov    %ebx,%eax
  801d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    
		fd_close(fd, 0);
  801d51:	83 ec 08             	sub    $0x8,%esp
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 f4             	pushl  -0xc(%ebp)
  801d59:	e8 1b f9 ff ff       	call   801679 <fd_close>
		return r;
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	eb e5                	jmp    801d48 <open+0x6c>
		return -E_BAD_PATH;
  801d63:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d68:	eb de                	jmp    801d48 <open+0x6c>

00801d6a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	b8 08 00 00 00       	mov    $0x8,%eax
  801d7a:	e8 68 fd ff ff       	call   801ae7 <fsipc>
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d87:	68 cb 30 80 00       	push   $0x8030cb
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	e8 ff eb ff ff       	call   800993 <strcpy>
	return 0;
}
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <devsock_close>:
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	53                   	push   %ebx
  801d9f:	83 ec 10             	sub    $0x10,%esp
  801da2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801da5:	53                   	push   %ebx
  801da6:	e8 f2 0a 00 00       	call   80289d <pageref>
  801dab:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dae:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801db3:	83 f8 01             	cmp    $0x1,%eax
  801db6:	74 07                	je     801dbf <devsock_close+0x24>
}
  801db8:	89 d0                	mov    %edx,%eax
  801dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	ff 73 0c             	pushl  0xc(%ebx)
  801dc5:	e8 b9 02 00 00       	call   802083 <nsipc_close>
  801dca:	89 c2                	mov    %eax,%edx
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	eb e7                	jmp    801db8 <devsock_close+0x1d>

00801dd1 <devsock_write>:
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	ff 75 10             	pushl  0x10(%ebp)
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	ff 70 0c             	pushl  0xc(%eax)
  801de5:	e8 76 03 00 00       	call   802160 <nsipc_send>
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <devsock_read>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	ff 70 0c             	pushl  0xc(%eax)
  801e00:	e8 ef 02 00 00       	call   8020f4 <nsipc_recv>
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <fd2sockid>:
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e0d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	e8 b7 f7 ff ff       	call   8015ce <fd_lookup>
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 10                	js     801e2e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e27:	39 08                	cmp    %ecx,(%eax)
  801e29:	75 05                	jne    801e30 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e2b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    
		return -E_NOT_SUPP;
  801e30:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e35:	eb f7                	jmp    801e2e <fd2sockid+0x27>

00801e37 <alloc_sockfd>:
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	56                   	push   %esi
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 1c             	sub    $0x1c,%esp
  801e3f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e44:	50                   	push   %eax
  801e45:	e8 32 f7 ff ff       	call   80157c <fd_alloc>
  801e4a:	89 c3                	mov    %eax,%ebx
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 43                	js     801e96 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	68 07 04 00 00       	push   $0x407
  801e5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5e:	6a 00                	push   $0x0
  801e60:	e8 20 ef ff ff       	call   800d85 <sys_page_alloc>
  801e65:	89 c3                	mov    %eax,%ebx
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	78 28                	js     801e96 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e77:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e83:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	50                   	push   %eax
  801e8a:	e8 c6 f6 ff ff       	call   801555 <fd2num>
  801e8f:	89 c3                	mov    %eax,%ebx
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	eb 0c                	jmp    801ea2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	56                   	push   %esi
  801e9a:	e8 e4 01 00 00       	call   802083 <nsipc_close>
		return r;
  801e9f:	83 c4 10             	add    $0x10,%esp
}
  801ea2:	89 d8                	mov    %ebx,%eax
  801ea4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <accept>:
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	e8 4e ff ff ff       	call   801e07 <fd2sockid>
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	78 1b                	js     801ed8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	ff 75 10             	pushl  0x10(%ebp)
  801ec3:	ff 75 0c             	pushl  0xc(%ebp)
  801ec6:	50                   	push   %eax
  801ec7:	e8 0e 01 00 00       	call   801fda <nsipc_accept>
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 05                	js     801ed8 <accept+0x2d>
	return alloc_sockfd(r);
  801ed3:	e8 5f ff ff ff       	call   801e37 <alloc_sockfd>
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <bind>:
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	e8 1f ff ff ff       	call   801e07 <fd2sockid>
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 12                	js     801efe <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	50                   	push   %eax
  801ef6:	e8 31 01 00 00       	call   80202c <nsipc_bind>
  801efb:	83 c4 10             	add    $0x10,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <shutdown>:
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	e8 f9 fe ff ff       	call   801e07 <fd2sockid>
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 0f                	js     801f21 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f12:	83 ec 08             	sub    $0x8,%esp
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	50                   	push   %eax
  801f19:	e8 43 01 00 00       	call   802061 <nsipc_shutdown>
  801f1e:	83 c4 10             	add    $0x10,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <connect>:
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	e8 d6 fe ff ff       	call   801e07 <fd2sockid>
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 12                	js     801f47 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f35:	83 ec 04             	sub    $0x4,%esp
  801f38:	ff 75 10             	pushl  0x10(%ebp)
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	50                   	push   %eax
  801f3f:	e8 59 01 00 00       	call   80209d <nsipc_connect>
  801f44:	83 c4 10             	add    $0x10,%esp
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <listen>:
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	e8 b0 fe ff ff       	call   801e07 <fd2sockid>
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 0f                	js     801f6a <listen+0x21>
	return nsipc_listen(r, backlog);
  801f5b:	83 ec 08             	sub    $0x8,%esp
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	50                   	push   %eax
  801f62:	e8 6b 01 00 00       	call   8020d2 <nsipc_listen>
  801f67:	83 c4 10             	add    $0x10,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <socket>:

int
socket(int domain, int type, int protocol)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f72:	ff 75 10             	pushl  0x10(%ebp)
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	ff 75 08             	pushl  0x8(%ebp)
  801f7b:	e8 3e 02 00 00       	call   8021be <nsipc_socket>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 05                	js     801f8c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f87:	e8 ab fe ff ff       	call   801e37 <alloc_sockfd>
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	53                   	push   %ebx
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f97:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f9e:	74 26                	je     801fc6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fa0:	6a 07                	push   $0x7
  801fa2:	68 00 70 80 00       	push   $0x807000
  801fa7:	53                   	push   %ebx
  801fa8:	ff 35 04 50 80 00    	pushl  0x805004
  801fae:	e8 57 08 00 00       	call   80280a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fb3:	83 c4 0c             	add    $0xc,%esp
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 e0 07 00 00       	call   8027a1 <ipc_recv>
}
  801fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	6a 02                	push   $0x2
  801fcb:	e8 92 08 00 00       	call   802862 <ipc_find_env>
  801fd0:	a3 04 50 80 00       	mov    %eax,0x805004
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	eb c6                	jmp    801fa0 <nsipc+0x12>

00801fda <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	56                   	push   %esi
  801fde:	53                   	push   %ebx
  801fdf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fea:	8b 06                	mov    (%esi),%eax
  801fec:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ff1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff6:	e8 93 ff ff ff       	call   801f8e <nsipc>
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	79 09                	jns    80200a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802001:	89 d8                	mov    %ebx,%eax
  802003:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	ff 35 10 70 80 00    	pushl  0x807010
  802013:	68 00 70 80 00       	push   $0x807000
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	e8 01 eb ff ff       	call   800b21 <memmove>
		*addrlen = ret->ret_addrlen;
  802020:	a1 10 70 80 00       	mov    0x807010,%eax
  802025:	89 06                	mov    %eax,(%esi)
  802027:	83 c4 10             	add    $0x10,%esp
	return r;
  80202a:	eb d5                	jmp    802001 <nsipc_accept+0x27>

0080202c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	53                   	push   %ebx
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80203e:	53                   	push   %ebx
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	68 04 70 80 00       	push   $0x807004
  802047:	e8 d5 ea ff ff       	call   800b21 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80204c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802052:	b8 02 00 00 00       	mov    $0x2,%eax
  802057:	e8 32 ff ff ff       	call   801f8e <nsipc>
}
  80205c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802077:	b8 03 00 00 00       	mov    $0x3,%eax
  80207c:	e8 0d ff ff ff       	call   801f8e <nsipc>
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <nsipc_close>:

int
nsipc_close(int s)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802091:	b8 04 00 00 00       	mov    $0x4,%eax
  802096:	e8 f3 fe ff ff       	call   801f8e <nsipc>
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 08             	sub    $0x8,%esp
  8020a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020af:	53                   	push   %ebx
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	68 04 70 80 00       	push   $0x807004
  8020b8:	e8 64 ea ff ff       	call   800b21 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020bd:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020c3:	b8 05 00 00 00       	mov    $0x5,%eax
  8020c8:	e8 c1 fe ff ff       	call   801f8e <nsipc>
}
  8020cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8020ed:	e8 9c fe ff ff       	call   801f8e <nsipc>
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802104:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80210a:	8b 45 14             	mov    0x14(%ebp),%eax
  80210d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802112:	b8 07 00 00 00       	mov    $0x7,%eax
  802117:	e8 72 fe ff ff       	call   801f8e <nsipc>
  80211c:	89 c3                	mov    %eax,%ebx
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 1f                	js     802141 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802122:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802127:	7f 21                	jg     80214a <nsipc_recv+0x56>
  802129:	39 c6                	cmp    %eax,%esi
  80212b:	7c 1d                	jl     80214a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	50                   	push   %eax
  802131:	68 00 70 80 00       	push   $0x807000
  802136:	ff 75 0c             	pushl  0xc(%ebp)
  802139:	e8 e3 e9 ff ff       	call   800b21 <memmove>
  80213e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802141:	89 d8                	mov    %ebx,%eax
  802143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802146:	5b                   	pop    %ebx
  802147:	5e                   	pop    %esi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80214a:	68 d7 30 80 00       	push   $0x8030d7
  80214f:	68 9f 30 80 00       	push   $0x80309f
  802154:	6a 62                	push   $0x62
  802156:	68 ec 30 80 00       	push   $0x8030ec
  80215b:	e8 4b 05 00 00       	call   8026ab <_panic>

00802160 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	53                   	push   %ebx
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802172:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802178:	7f 2e                	jg     8021a8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	53                   	push   %ebx
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	68 0c 70 80 00       	push   $0x80700c
  802186:	e8 96 e9 ff ff       	call   800b21 <memmove>
	nsipcbuf.send.req_size = size;
  80218b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802191:	8b 45 14             	mov    0x14(%ebp),%eax
  802194:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802199:	b8 08 00 00 00       	mov    $0x8,%eax
  80219e:	e8 eb fd ff ff       	call   801f8e <nsipc>
}
  8021a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    
	assert(size < 1600);
  8021a8:	68 f8 30 80 00       	push   $0x8030f8
  8021ad:	68 9f 30 80 00       	push   $0x80309f
  8021b2:	6a 6d                	push   $0x6d
  8021b4:	68 ec 30 80 00       	push   $0x8030ec
  8021b9:	e8 ed 04 00 00       	call   8026ab <_panic>

008021be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021e1:	e8 a8 fd ff ff       	call   801f8e <nsipc>
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	56                   	push   %esi
  8021ec:	53                   	push   %ebx
  8021ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	ff 75 08             	pushl  0x8(%ebp)
  8021f6:	e8 6a f3 ff ff       	call   801565 <fd2data>
  8021fb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021fd:	83 c4 08             	add    $0x8,%esp
  802200:	68 04 31 80 00       	push   $0x803104
  802205:	53                   	push   %ebx
  802206:	e8 88 e7 ff ff       	call   800993 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80220b:	8b 46 04             	mov    0x4(%esi),%eax
  80220e:	2b 06                	sub    (%esi),%eax
  802210:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802216:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80221d:	00 00 00 
	stat->st_dev = &devpipe;
  802220:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802227:	40 80 00 
	return 0;
}
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802232:	5b                   	pop    %ebx
  802233:	5e                   	pop    %esi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	53                   	push   %ebx
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802240:	53                   	push   %ebx
  802241:	6a 00                	push   $0x0
  802243:	e8 c2 eb ff ff       	call   800e0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802248:	89 1c 24             	mov    %ebx,(%esp)
  80224b:	e8 15 f3 ff ff       	call   801565 <fd2data>
  802250:	83 c4 08             	add    $0x8,%esp
  802253:	50                   	push   %eax
  802254:	6a 00                	push   $0x0
  802256:	e8 af eb ff ff       	call   800e0a <sys_page_unmap>
}
  80225b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <_pipeisclosed>:
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	57                   	push   %edi
  802264:	56                   	push   %esi
  802265:	53                   	push   %ebx
  802266:	83 ec 1c             	sub    $0x1c,%esp
  802269:	89 c7                	mov    %eax,%edi
  80226b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80226d:	a1 08 50 80 00       	mov    0x805008,%eax
  802272:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	57                   	push   %edi
  802279:	e8 1f 06 00 00       	call   80289d <pageref>
  80227e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802281:	89 34 24             	mov    %esi,(%esp)
  802284:	e8 14 06 00 00       	call   80289d <pageref>
		nn = thisenv->env_runs;
  802289:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80228f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	39 cb                	cmp    %ecx,%ebx
  802297:	74 1b                	je     8022b4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802299:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80229c:	75 cf                	jne    80226d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80229e:	8b 42 58             	mov    0x58(%edx),%eax
  8022a1:	6a 01                	push   $0x1
  8022a3:	50                   	push   %eax
  8022a4:	53                   	push   %ebx
  8022a5:	68 0b 31 80 00       	push   $0x80310b
  8022aa:	e8 85 df ff ff       	call   800234 <cprintf>
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	eb b9                	jmp    80226d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022b7:	0f 94 c0             	sete   %al
  8022ba:	0f b6 c0             	movzbl %al,%eax
}
  8022bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <devpipe_write>:
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	57                   	push   %edi
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 28             	sub    $0x28,%esp
  8022ce:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022d1:	56                   	push   %esi
  8022d2:	e8 8e f2 ff ff       	call   801565 <fd2data>
  8022d7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022e4:	74 4f                	je     802335 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e6:	8b 43 04             	mov    0x4(%ebx),%eax
  8022e9:	8b 0b                	mov    (%ebx),%ecx
  8022eb:	8d 51 20             	lea    0x20(%ecx),%edx
  8022ee:	39 d0                	cmp    %edx,%eax
  8022f0:	72 14                	jb     802306 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022f2:	89 da                	mov    %ebx,%edx
  8022f4:	89 f0                	mov    %esi,%eax
  8022f6:	e8 65 ff ff ff       	call   802260 <_pipeisclosed>
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 3b                	jne    80233a <devpipe_write+0x75>
			sys_yield();
  8022ff:	e8 62 ea ff ff       	call   800d66 <sys_yield>
  802304:	eb e0                	jmp    8022e6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802309:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80230d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802310:	89 c2                	mov    %eax,%edx
  802312:	c1 fa 1f             	sar    $0x1f,%edx
  802315:	89 d1                	mov    %edx,%ecx
  802317:	c1 e9 1b             	shr    $0x1b,%ecx
  80231a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80231d:	83 e2 1f             	and    $0x1f,%edx
  802320:	29 ca                	sub    %ecx,%edx
  802322:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802326:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80232a:	83 c0 01             	add    $0x1,%eax
  80232d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802330:	83 c7 01             	add    $0x1,%edi
  802333:	eb ac                	jmp    8022e1 <devpipe_write+0x1c>
	return i;
  802335:	8b 45 10             	mov    0x10(%ebp),%eax
  802338:	eb 05                	jmp    80233f <devpipe_write+0x7a>
				return 0;
  80233a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802342:	5b                   	pop    %ebx
  802343:	5e                   	pop    %esi
  802344:	5f                   	pop    %edi
  802345:	5d                   	pop    %ebp
  802346:	c3                   	ret    

00802347 <devpipe_read>:
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	57                   	push   %edi
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 18             	sub    $0x18,%esp
  802350:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802353:	57                   	push   %edi
  802354:	e8 0c f2 ff ff       	call   801565 <fd2data>
  802359:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	be 00 00 00 00       	mov    $0x0,%esi
  802363:	3b 75 10             	cmp    0x10(%ebp),%esi
  802366:	75 14                	jne    80237c <devpipe_read+0x35>
	return i;
  802368:	8b 45 10             	mov    0x10(%ebp),%eax
  80236b:	eb 02                	jmp    80236f <devpipe_read+0x28>
				return i;
  80236d:	89 f0                	mov    %esi,%eax
}
  80236f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802372:	5b                   	pop    %ebx
  802373:	5e                   	pop    %esi
  802374:	5f                   	pop    %edi
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    
			sys_yield();
  802377:	e8 ea e9 ff ff       	call   800d66 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80237c:	8b 03                	mov    (%ebx),%eax
  80237e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802381:	75 18                	jne    80239b <devpipe_read+0x54>
			if (i > 0)
  802383:	85 f6                	test   %esi,%esi
  802385:	75 e6                	jne    80236d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802387:	89 da                	mov    %ebx,%edx
  802389:	89 f8                	mov    %edi,%eax
  80238b:	e8 d0 fe ff ff       	call   802260 <_pipeisclosed>
  802390:	85 c0                	test   %eax,%eax
  802392:	74 e3                	je     802377 <devpipe_read+0x30>
				return 0;
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	eb d4                	jmp    80236f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80239b:	99                   	cltd   
  80239c:	c1 ea 1b             	shr    $0x1b,%edx
  80239f:	01 d0                	add    %edx,%eax
  8023a1:	83 e0 1f             	and    $0x1f,%eax
  8023a4:	29 d0                	sub    %edx,%eax
  8023a6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ae:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023b1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023b4:	83 c6 01             	add    $0x1,%esi
  8023b7:	eb aa                	jmp    802363 <devpipe_read+0x1c>

008023b9 <pipe>:
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	56                   	push   %esi
  8023bd:	53                   	push   %ebx
  8023be:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c4:	50                   	push   %eax
  8023c5:	e8 b2 f1 ff ff       	call   80157c <fd_alloc>
  8023ca:	89 c3                	mov    %eax,%ebx
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	0f 88 23 01 00 00    	js     8024fa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 07 04 00 00       	push   $0x407
  8023df:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e2:	6a 00                	push   $0x0
  8023e4:	e8 9c e9 ff ff       	call   800d85 <sys_page_alloc>
  8023e9:	89 c3                	mov    %eax,%ebx
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	0f 88 04 01 00 00    	js     8024fa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023f6:	83 ec 0c             	sub    $0xc,%esp
  8023f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023fc:	50                   	push   %eax
  8023fd:	e8 7a f1 ff ff       	call   80157c <fd_alloc>
  802402:	89 c3                	mov    %eax,%ebx
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	85 c0                	test   %eax,%eax
  802409:	0f 88 db 00 00 00    	js     8024ea <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 07 04 00 00       	push   $0x407
  802417:	ff 75 f0             	pushl  -0x10(%ebp)
  80241a:	6a 00                	push   $0x0
  80241c:	e8 64 e9 ff ff       	call   800d85 <sys_page_alloc>
  802421:	89 c3                	mov    %eax,%ebx
  802423:	83 c4 10             	add    $0x10,%esp
  802426:	85 c0                	test   %eax,%eax
  802428:	0f 88 bc 00 00 00    	js     8024ea <pipe+0x131>
	va = fd2data(fd0);
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	ff 75 f4             	pushl  -0xc(%ebp)
  802434:	e8 2c f1 ff ff       	call   801565 <fd2data>
  802439:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243b:	83 c4 0c             	add    $0xc,%esp
  80243e:	68 07 04 00 00       	push   $0x407
  802443:	50                   	push   %eax
  802444:	6a 00                	push   $0x0
  802446:	e8 3a e9 ff ff       	call   800d85 <sys_page_alloc>
  80244b:	89 c3                	mov    %eax,%ebx
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	85 c0                	test   %eax,%eax
  802452:	0f 88 82 00 00 00    	js     8024da <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	ff 75 f0             	pushl  -0x10(%ebp)
  80245e:	e8 02 f1 ff ff       	call   801565 <fd2data>
  802463:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80246a:	50                   	push   %eax
  80246b:	6a 00                	push   $0x0
  80246d:	56                   	push   %esi
  80246e:	6a 00                	push   $0x0
  802470:	e8 53 e9 ff ff       	call   800dc8 <sys_page_map>
  802475:	89 c3                	mov    %eax,%ebx
  802477:	83 c4 20             	add    $0x20,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 4e                	js     8024cc <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80247e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802495:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024a1:	83 ec 0c             	sub    $0xc,%esp
  8024a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a7:	e8 a9 f0 ff ff       	call   801555 <fd2num>
  8024ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024af:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024b1:	83 c4 04             	add    $0x4,%esp
  8024b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8024b7:	e8 99 f0 ff ff       	call   801555 <fd2num>
  8024bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024c2:	83 c4 10             	add    $0x10,%esp
  8024c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024ca:	eb 2e                	jmp    8024fa <pipe+0x141>
	sys_page_unmap(0, va);
  8024cc:	83 ec 08             	sub    $0x8,%esp
  8024cf:	56                   	push   %esi
  8024d0:	6a 00                	push   $0x0
  8024d2:	e8 33 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024d7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024da:	83 ec 08             	sub    $0x8,%esp
  8024dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e0:	6a 00                	push   $0x0
  8024e2:	e8 23 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024e7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024ea:	83 ec 08             	sub    $0x8,%esp
  8024ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f0:	6a 00                	push   $0x0
  8024f2:	e8 13 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024f7:	83 c4 10             	add    $0x10,%esp
}
  8024fa:	89 d8                	mov    %ebx,%eax
  8024fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5d                   	pop    %ebp
  802502:	c3                   	ret    

00802503 <pipeisclosed>:
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802509:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80250c:	50                   	push   %eax
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	e8 b9 f0 ff ff       	call   8015ce <fd_lookup>
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	85 c0                	test   %eax,%eax
  80251a:	78 18                	js     802534 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80251c:	83 ec 0c             	sub    $0xc,%esp
  80251f:	ff 75 f4             	pushl  -0xc(%ebp)
  802522:	e8 3e f0 ff ff       	call   801565 <fd2data>
	return _pipeisclosed(fd, p);
  802527:	89 c2                	mov    %eax,%edx
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	e8 2f fd ff ff       	call   802260 <_pipeisclosed>
  802531:	83 c4 10             	add    $0x10,%esp
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
  80253b:	c3                   	ret    

0080253c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802542:	68 23 31 80 00       	push   $0x803123
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	e8 44 e4 ff ff       	call   800993 <strcpy>
	return 0;
}
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <devcons_write>:
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	57                   	push   %edi
  80255a:	56                   	push   %esi
  80255b:	53                   	push   %ebx
  80255c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802562:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802567:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80256d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802570:	73 31                	jae    8025a3 <devcons_write+0x4d>
		m = n - tot;
  802572:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802575:	29 f3                	sub    %esi,%ebx
  802577:	83 fb 7f             	cmp    $0x7f,%ebx
  80257a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80257f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	53                   	push   %ebx
  802586:	89 f0                	mov    %esi,%eax
  802588:	03 45 0c             	add    0xc(%ebp),%eax
  80258b:	50                   	push   %eax
  80258c:	57                   	push   %edi
  80258d:	e8 8f e5 ff ff       	call   800b21 <memmove>
		sys_cputs(buf, m);
  802592:	83 c4 08             	add    $0x8,%esp
  802595:	53                   	push   %ebx
  802596:	57                   	push   %edi
  802597:	e8 2d e7 ff ff       	call   800cc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80259c:	01 de                	add    %ebx,%esi
  80259e:	83 c4 10             	add    $0x10,%esp
  8025a1:	eb ca                	jmp    80256d <devcons_write+0x17>
}
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a8:	5b                   	pop    %ebx
  8025a9:	5e                   	pop    %esi
  8025aa:	5f                   	pop    %edi
  8025ab:	5d                   	pop    %ebp
  8025ac:	c3                   	ret    

008025ad <devcons_read>:
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 08             	sub    $0x8,%esp
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025bc:	74 21                	je     8025df <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025be:	e8 24 e7 ff ff       	call   800ce7 <sys_cgetc>
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	75 07                	jne    8025ce <devcons_read+0x21>
		sys_yield();
  8025c7:	e8 9a e7 ff ff       	call   800d66 <sys_yield>
  8025cc:	eb f0                	jmp    8025be <devcons_read+0x11>
	if (c < 0)
  8025ce:	78 0f                	js     8025df <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025d0:	83 f8 04             	cmp    $0x4,%eax
  8025d3:	74 0c                	je     8025e1 <devcons_read+0x34>
	*(char*)vbuf = c;
  8025d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d8:	88 02                	mov    %al,(%edx)
	return 1;
  8025da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    
		return 0;
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	eb f7                	jmp    8025df <devcons_read+0x32>

008025e8 <cputchar>:
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025f4:	6a 01                	push   $0x1
  8025f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025f9:	50                   	push   %eax
  8025fa:	e8 ca e6 ff ff       	call   800cc9 <sys_cputs>
}
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <getchar>:
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80260a:	6a 01                	push   $0x1
  80260c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80260f:	50                   	push   %eax
  802610:	6a 00                	push   $0x0
  802612:	e8 27 f2 ff ff       	call   80183e <read>
	if (r < 0)
  802617:	83 c4 10             	add    $0x10,%esp
  80261a:	85 c0                	test   %eax,%eax
  80261c:	78 06                	js     802624 <getchar+0x20>
	if (r < 1)
  80261e:	74 06                	je     802626 <getchar+0x22>
	return c;
  802620:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    
		return -E_EOF;
  802626:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80262b:	eb f7                	jmp    802624 <getchar+0x20>

0080262d <iscons>:
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802633:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802636:	50                   	push   %eax
  802637:	ff 75 08             	pushl  0x8(%ebp)
  80263a:	e8 8f ef ff ff       	call   8015ce <fd_lookup>
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	85 c0                	test   %eax,%eax
  802644:	78 11                	js     802657 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80264f:	39 10                	cmp    %edx,(%eax)
  802651:	0f 94 c0             	sete   %al
  802654:	0f b6 c0             	movzbl %al,%eax
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <opencons>:
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80265f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802662:	50                   	push   %eax
  802663:	e8 14 ef ff ff       	call   80157c <fd_alloc>
  802668:	83 c4 10             	add    $0x10,%esp
  80266b:	85 c0                	test   %eax,%eax
  80266d:	78 3a                	js     8026a9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 07 04 00 00       	push   $0x407
  802677:	ff 75 f4             	pushl  -0xc(%ebp)
  80267a:	6a 00                	push   $0x0
  80267c:	e8 04 e7 ff ff       	call   800d85 <sys_page_alloc>
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	85 c0                	test   %eax,%eax
  802686:	78 21                	js     8026a9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802691:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	50                   	push   %eax
  8026a1:	e8 af ee ff ff       	call   801555 <fd2num>
  8026a6:	83 c4 10             	add    $0x10,%esp
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8026b0:	a1 08 50 80 00       	mov    0x805008,%eax
  8026b5:	8b 40 48             	mov    0x48(%eax),%eax
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 60 31 80 00       	push   $0x803160
  8026c0:	50                   	push   %eax
  8026c1:	68 2f 31 80 00       	push   $0x80312f
  8026c6:	e8 69 db ff ff       	call   800234 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8026cb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026ce:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026d4:	e8 6e e6 ff ff       	call   800d47 <sys_getenvid>
  8026d9:	83 c4 04             	add    $0x4,%esp
  8026dc:	ff 75 0c             	pushl  0xc(%ebp)
  8026df:	ff 75 08             	pushl  0x8(%ebp)
  8026e2:	56                   	push   %esi
  8026e3:	50                   	push   %eax
  8026e4:	68 3c 31 80 00       	push   $0x80313c
  8026e9:	e8 46 db ff ff       	call   800234 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026ee:	83 c4 18             	add    $0x18,%esp
  8026f1:	53                   	push   %ebx
  8026f2:	ff 75 10             	pushl  0x10(%ebp)
  8026f5:	e8 e9 da ff ff       	call   8001e3 <vcprintf>
	cprintf("\n");
  8026fa:	c7 04 24 61 2b 80 00 	movl   $0x802b61,(%esp)
  802701:	e8 2e db ff ff       	call   800234 <cprintf>
  802706:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802709:	cc                   	int3   
  80270a:	eb fd                	jmp    802709 <_panic+0x5e>

0080270c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802712:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802719:	74 0a                	je     802725 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	6a 07                	push   $0x7
  80272a:	68 00 f0 bf ee       	push   $0xeebff000
  80272f:	6a 00                	push   $0x0
  802731:	e8 4f e6 ff ff       	call   800d85 <sys_page_alloc>
		if(r < 0)
  802736:	83 c4 10             	add    $0x10,%esp
  802739:	85 c0                	test   %eax,%eax
  80273b:	78 2a                	js     802767 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80273d:	83 ec 08             	sub    $0x8,%esp
  802740:	68 7b 27 80 00       	push   $0x80277b
  802745:	6a 00                	push   $0x0
  802747:	e8 84 e7 ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80274c:	83 c4 10             	add    $0x10,%esp
  80274f:	85 c0                	test   %eax,%eax
  802751:	79 c8                	jns    80271b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	68 98 31 80 00       	push   $0x803198
  80275b:	6a 25                	push   $0x25
  80275d:	68 d4 31 80 00       	push   $0x8031d4
  802762:	e8 44 ff ff ff       	call   8026ab <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 68 31 80 00       	push   $0x803168
  80276f:	6a 22                	push   $0x22
  802771:	68 d4 31 80 00       	push   $0x8031d4
  802776:	e8 30 ff ff ff       	call   8026ab <_panic>

0080277b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80277b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80277c:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802781:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802783:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802786:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80278a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80278e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802791:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802793:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802797:	83 c4 08             	add    $0x8,%esp
	popal
  80279a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80279b:	83 c4 04             	add    $0x4,%esp
	popfl
  80279e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80279f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027a0:	c3                   	ret    

008027a1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	56                   	push   %esi
  8027a5:	53                   	push   %ebx
  8027a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8027a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027af:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027b1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027b6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	50                   	push   %eax
  8027bd:	e8 73 e7 ff ff       	call   800f35 <sys_ipc_recv>
	if(ret < 0){
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	78 2b                	js     8027f4 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027c9:	85 f6                	test   %esi,%esi
  8027cb:	74 0a                	je     8027d7 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8027d2:	8b 40 74             	mov    0x74(%eax),%eax
  8027d5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027d7:	85 db                	test   %ebx,%ebx
  8027d9:	74 0a                	je     8027e5 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027db:	a1 08 50 80 00       	mov    0x805008,%eax
  8027e0:	8b 40 78             	mov    0x78(%eax),%eax
  8027e3:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027e5:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ea:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f0:	5b                   	pop    %ebx
  8027f1:	5e                   	pop    %esi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    
		if(from_env_store)
  8027f4:	85 f6                	test   %esi,%esi
  8027f6:	74 06                	je     8027fe <ipc_recv+0x5d>
			*from_env_store = 0;
  8027f8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027fe:	85 db                	test   %ebx,%ebx
  802800:	74 eb                	je     8027ed <ipc_recv+0x4c>
			*perm_store = 0;
  802802:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802808:	eb e3                	jmp    8027ed <ipc_recv+0x4c>

0080280a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	57                   	push   %edi
  80280e:	56                   	push   %esi
  80280f:	53                   	push   %ebx
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	8b 7d 08             	mov    0x8(%ebp),%edi
  802816:	8b 75 0c             	mov    0xc(%ebp),%esi
  802819:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80281c:	85 db                	test   %ebx,%ebx
  80281e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802823:	0f 44 d8             	cmove  %eax,%ebx
  802826:	eb 05                	jmp    80282d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802828:	e8 39 e5 ff ff       	call   800d66 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80282d:	ff 75 14             	pushl  0x14(%ebp)
  802830:	53                   	push   %ebx
  802831:	56                   	push   %esi
  802832:	57                   	push   %edi
  802833:	e8 da e6 ff ff       	call   800f12 <sys_ipc_try_send>
  802838:	83 c4 10             	add    $0x10,%esp
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 1b                	je     80285a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80283f:	79 e7                	jns    802828 <ipc_send+0x1e>
  802841:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802844:	74 e2                	je     802828 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 e2 31 80 00       	push   $0x8031e2
  80284e:	6a 48                	push   $0x48
  802850:	68 f7 31 80 00       	push   $0x8031f7
  802855:	e8 51 fe ff ff       	call   8026ab <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80285a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5e                   	pop    %esi
  80285f:	5f                   	pop    %edi
  802860:	5d                   	pop    %ebp
  802861:	c3                   	ret    

00802862 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	c1 e2 07             	shl    $0x7,%edx
  802872:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802878:	8b 52 50             	mov    0x50(%edx),%edx
  80287b:	39 ca                	cmp    %ecx,%edx
  80287d:	74 11                	je     802890 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80287f:	83 c0 01             	add    $0x1,%eax
  802882:	3d 00 04 00 00       	cmp    $0x400,%eax
  802887:	75 e4                	jne    80286d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
  80288e:	eb 0b                	jmp    80289b <ipc_find_env+0x39>
			return envs[i].env_id;
  802890:	c1 e0 07             	shl    $0x7,%eax
  802893:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802898:	8b 40 48             	mov    0x48(%eax),%eax
}
  80289b:	5d                   	pop    %ebp
  80289c:	c3                   	ret    

0080289d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
  8028a0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	c1 e8 16             	shr    $0x16,%eax
  8028a8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b4:	f6 c1 01             	test   $0x1,%cl
  8028b7:	74 1d                	je     8028d6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028b9:	c1 ea 0c             	shr    $0xc,%edx
  8028bc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c3:	f6 c2 01             	test   $0x1,%dl
  8028c6:	74 0e                	je     8028d6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028c8:	c1 ea 0c             	shr    $0xc,%edx
  8028cb:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d2:	ef 
  8028d3:	0f b7 c0             	movzwl %ax,%eax
}
  8028d6:	5d                   	pop    %ebp
  8028d7:	c3                   	ret    
  8028d8:	66 90                	xchg   %ax,%ax
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 1c             	sub    $0x1c,%esp
  8028e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028f7:	85 d2                	test   %edx,%edx
  8028f9:	75 4d                	jne    802948 <__udivdi3+0x68>
  8028fb:	39 f3                	cmp    %esi,%ebx
  8028fd:	76 19                	jbe    802918 <__udivdi3+0x38>
  8028ff:	31 ff                	xor    %edi,%edi
  802901:	89 e8                	mov    %ebp,%eax
  802903:	89 f2                	mov    %esi,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 fa                	mov    %edi,%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	89 d9                	mov    %ebx,%ecx
  80291a:	85 db                	test   %ebx,%ebx
  80291c:	75 0b                	jne    802929 <__udivdi3+0x49>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	31 d2                	xor    %edx,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 c1                	mov    %eax,%ecx
  802929:	31 d2                	xor    %edx,%edx
  80292b:	89 f0                	mov    %esi,%eax
  80292d:	f7 f1                	div    %ecx
  80292f:	89 c6                	mov    %eax,%esi
  802931:	89 e8                	mov    %ebp,%eax
  802933:	89 f7                	mov    %esi,%edi
  802935:	f7 f1                	div    %ecx
  802937:	89 fa                	mov    %edi,%edx
  802939:	83 c4 1c             	add    $0x1c,%esp
  80293c:	5b                   	pop    %ebx
  80293d:	5e                   	pop    %esi
  80293e:	5f                   	pop    %edi
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	39 f2                	cmp    %esi,%edx
  80294a:	77 1c                	ja     802968 <__udivdi3+0x88>
  80294c:	0f bd fa             	bsr    %edx,%edi
  80294f:	83 f7 1f             	xor    $0x1f,%edi
  802952:	75 2c                	jne    802980 <__udivdi3+0xa0>
  802954:	39 f2                	cmp    %esi,%edx
  802956:	72 06                	jb     80295e <__udivdi3+0x7e>
  802958:	31 c0                	xor    %eax,%eax
  80295a:	39 eb                	cmp    %ebp,%ebx
  80295c:	77 a9                	ja     802907 <__udivdi3+0x27>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	eb a2                	jmp    802907 <__udivdi3+0x27>
  802965:	8d 76 00             	lea    0x0(%esi),%esi
  802968:	31 ff                	xor    %edi,%edi
  80296a:	31 c0                	xor    %eax,%eax
  80296c:	89 fa                	mov    %edi,%edx
  80296e:	83 c4 1c             	add    $0x1c,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	89 f9                	mov    %edi,%ecx
  802982:	b8 20 00 00 00       	mov    $0x20,%eax
  802987:	29 f8                	sub    %edi,%eax
  802989:	d3 e2                	shl    %cl,%edx
  80298b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80298f:	89 c1                	mov    %eax,%ecx
  802991:	89 da                	mov    %ebx,%edx
  802993:	d3 ea                	shr    %cl,%edx
  802995:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802999:	09 d1                	or     %edx,%ecx
  80299b:	89 f2                	mov    %esi,%edx
  80299d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029a1:	89 f9                	mov    %edi,%ecx
  8029a3:	d3 e3                	shl    %cl,%ebx
  8029a5:	89 c1                	mov    %eax,%ecx
  8029a7:	d3 ea                	shr    %cl,%edx
  8029a9:	89 f9                	mov    %edi,%ecx
  8029ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029af:	89 eb                	mov    %ebp,%ebx
  8029b1:	d3 e6                	shl    %cl,%esi
  8029b3:	89 c1                	mov    %eax,%ecx
  8029b5:	d3 eb                	shr    %cl,%ebx
  8029b7:	09 de                	or     %ebx,%esi
  8029b9:	89 f0                	mov    %esi,%eax
  8029bb:	f7 74 24 08          	divl   0x8(%esp)
  8029bf:	89 d6                	mov    %edx,%esi
  8029c1:	89 c3                	mov    %eax,%ebx
  8029c3:	f7 64 24 0c          	mull   0xc(%esp)
  8029c7:	39 d6                	cmp    %edx,%esi
  8029c9:	72 15                	jb     8029e0 <__udivdi3+0x100>
  8029cb:	89 f9                	mov    %edi,%ecx
  8029cd:	d3 e5                	shl    %cl,%ebp
  8029cf:	39 c5                	cmp    %eax,%ebp
  8029d1:	73 04                	jae    8029d7 <__udivdi3+0xf7>
  8029d3:	39 d6                	cmp    %edx,%esi
  8029d5:	74 09                	je     8029e0 <__udivdi3+0x100>
  8029d7:	89 d8                	mov    %ebx,%eax
  8029d9:	31 ff                	xor    %edi,%edi
  8029db:	e9 27 ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029e3:	31 ff                	xor    %edi,%edi
  8029e5:	e9 1d ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029ea:	66 90                	xchg   %ax,%ax
  8029ec:	66 90                	xchg   %ax,%ax
  8029ee:	66 90                	xchg   %ax,%ax

008029f0 <__umoddi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	57                   	push   %edi
  8029f2:	56                   	push   %esi
  8029f3:	53                   	push   %ebx
  8029f4:	83 ec 1c             	sub    $0x1c,%esp
  8029f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a07:	89 da                	mov    %ebx,%edx
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	75 43                	jne    802a50 <__umoddi3+0x60>
  802a0d:	39 df                	cmp    %ebx,%edi
  802a0f:	76 17                	jbe    802a28 <__umoddi3+0x38>
  802a11:	89 f0                	mov    %esi,%eax
  802a13:	f7 f7                	div    %edi
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	31 d2                	xor    %edx,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	89 fd                	mov    %edi,%ebp
  802a2a:	85 ff                	test   %edi,%edi
  802a2c:	75 0b                	jne    802a39 <__umoddi3+0x49>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	31 d2                	xor    %edx,%edx
  802a35:	f7 f7                	div    %edi
  802a37:	89 c5                	mov    %eax,%ebp
  802a39:	89 d8                	mov    %ebx,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	f7 f5                	div    %ebp
  802a3f:	89 f0                	mov    %esi,%eax
  802a41:	f7 f5                	div    %ebp
  802a43:	89 d0                	mov    %edx,%eax
  802a45:	eb d0                	jmp    802a17 <__umoddi3+0x27>
  802a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4e:	66 90                	xchg   %ax,%ax
  802a50:	89 f1                	mov    %esi,%ecx
  802a52:	39 d8                	cmp    %ebx,%eax
  802a54:	76 0a                	jbe    802a60 <__umoddi3+0x70>
  802a56:	89 f0                	mov    %esi,%eax
  802a58:	83 c4 1c             	add    $0x1c,%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	0f bd e8             	bsr    %eax,%ebp
  802a63:	83 f5 1f             	xor    $0x1f,%ebp
  802a66:	75 20                	jne    802a88 <__umoddi3+0x98>
  802a68:	39 d8                	cmp    %ebx,%eax
  802a6a:	0f 82 b0 00 00 00    	jb     802b20 <__umoddi3+0x130>
  802a70:	39 f7                	cmp    %esi,%edi
  802a72:	0f 86 a8 00 00 00    	jbe    802b20 <__umoddi3+0x130>
  802a78:	89 c8                	mov    %ecx,%eax
  802a7a:	83 c4 1c             	add    $0x1c,%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    
  802a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a8f:	29 ea                	sub    %ebp,%edx
  802a91:	d3 e0                	shl    %cl,%eax
  802a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a97:	89 d1                	mov    %edx,%ecx
  802a99:	89 f8                	mov    %edi,%eax
  802a9b:	d3 e8                	shr    %cl,%eax
  802a9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aa5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aa9:	09 c1                	or     %eax,%ecx
  802aab:	89 d8                	mov    %ebx,%eax
  802aad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab1:	89 e9                	mov    %ebp,%ecx
  802ab3:	d3 e7                	shl    %cl,%edi
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802abf:	d3 e3                	shl    %cl,%ebx
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	89 d1                	mov    %edx,%ecx
  802ac5:	89 f0                	mov    %esi,%eax
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 fa                	mov    %edi,%edx
  802acd:	d3 e6                	shl    %cl,%esi
  802acf:	09 d8                	or     %ebx,%eax
  802ad1:	f7 74 24 08          	divl   0x8(%esp)
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	89 f3                	mov    %esi,%ebx
  802ad9:	f7 64 24 0c          	mull   0xc(%esp)
  802add:	89 c6                	mov    %eax,%esi
  802adf:	89 d7                	mov    %edx,%edi
  802ae1:	39 d1                	cmp    %edx,%ecx
  802ae3:	72 06                	jb     802aeb <__umoddi3+0xfb>
  802ae5:	75 10                	jne    802af7 <__umoddi3+0x107>
  802ae7:	39 c3                	cmp    %eax,%ebx
  802ae9:	73 0c                	jae    802af7 <__umoddi3+0x107>
  802aeb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802af3:	89 d7                	mov    %edx,%edi
  802af5:	89 c6                	mov    %eax,%esi
  802af7:	89 ca                	mov    %ecx,%edx
  802af9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802afe:	29 f3                	sub    %esi,%ebx
  802b00:	19 fa                	sbb    %edi,%edx
  802b02:	89 d0                	mov    %edx,%eax
  802b04:	d3 e0                	shl    %cl,%eax
  802b06:	89 e9                	mov    %ebp,%ecx
  802b08:	d3 eb                	shr    %cl,%ebx
  802b0a:	d3 ea                	shr    %cl,%edx
  802b0c:	09 d8                	or     %ebx,%eax
  802b0e:	83 c4 1c             	add    $0x1c,%esp
  802b11:	5b                   	pop    %ebx
  802b12:	5e                   	pop    %esi
  802b13:	5f                   	pop    %edi
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	89 da                	mov    %ebx,%edx
  802b22:	29 fe                	sub    %edi,%esi
  802b24:	19 c2                	sbb    %eax,%edx
  802b26:	89 f1                	mov    %esi,%ecx
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	e9 4b ff ff ff       	jmp    802a7a <__umoddi3+0x8a>
