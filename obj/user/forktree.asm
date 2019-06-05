
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
  800047:	68 20 2b 80 00       	push   $0x802b20
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
  80009c:	68 31 2b 80 00       	push   $0x802b31
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 94 08 00 00       	call   800940 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 22 13 00 00       	call   8013d6 <sfork>
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
  8000d4:	68 4f 2b 80 00       	push   $0x802b4f
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

	cprintf("in libmain.c call umain!\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 36 2b 80 00       	push   $0x802b36
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
  80018b:	e8 89 15 00 00       	call   801719 <close_all>
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
  8002e1:	e8 ea 25 00 00       	call   8028d0 <__udivdi3>
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
  80030a:	e8 d1 26 00 00       	call   8029e0 <__umoddi3>
  80030f:	83 c4 14             	add    $0x14,%esp
  800312:	0f be 80 5a 2b 80 00 	movsbl 0x802b5a(%eax),%eax
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
  800492:	68 a9 30 80 00       	push   $0x8030a9
  800497:	53                   	push   %ebx
  800498:	56                   	push   %esi
  800499:	e8 a6 fe ff ff       	call   800344 <printfmt>
  80049e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a4:	e9 fe 02 00 00       	jmp    8007a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a9:	50                   	push   %eax
  8004aa:	68 72 2b 80 00       	push   $0x802b72
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
  8004d1:	b8 6b 2b 80 00       	mov    $0x802b6b,%eax
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
  800869:	bf 91 2c 80 00       	mov    $0x802c91,%edi
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
  800895:	bf c9 2c 80 00       	mov    $0x802cc9,%edi
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
  800d42:	e8 50 19 00 00       	call   802697 <_panic>

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
  800dc3:	e8 cf 18 00 00       	call   802697 <_panic>

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
  800e05:	e8 8d 18 00 00       	call   802697 <_panic>

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
  800e47:	e8 4b 18 00 00       	call   802697 <_panic>

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
  800e89:	e8 09 18 00 00       	call   802697 <_panic>

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
  800ecb:	e8 c7 17 00 00       	call   802697 <_panic>

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
  800f0d:	e8 85 17 00 00       	call   802697 <_panic>

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
  800f71:	e8 21 17 00 00       	call   802697 <_panic>

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
  801055:	e8 3d 16 00 00       	call   802697 <_panic>

0080105a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	53                   	push   %ebx
  80105e:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801061:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801068:	f6 c5 04             	test   $0x4,%ch
  80106b:	75 45                	jne    8010b2 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80106d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801074:	83 e1 07             	and    $0x7,%ecx
  801077:	83 f9 07             	cmp    $0x7,%ecx
  80107a:	74 6f                	je     8010eb <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80107c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801083:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801089:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80108f:	0f 84 b6 00 00 00    	je     80114b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801095:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80109c:	83 e1 05             	and    $0x5,%ecx
  80109f:	83 f9 05             	cmp    $0x5,%ecx
  8010a2:	0f 84 d7 00 00 00    	je     80117f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010b2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010b9:	c1 e2 0c             	shl    $0xc,%edx
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010c5:	51                   	push   %ecx
  8010c6:	52                   	push   %edx
  8010c7:	50                   	push   %eax
  8010c8:	52                   	push   %edx
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 f8 fc ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	79 d1                	jns    8010a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010d7:	83 ec 04             	sub    $0x4,%esp
  8010da:	68 0f 2f 80 00       	push   $0x802f0f
  8010df:	6a 54                	push   $0x54
  8010e1:	68 25 2f 80 00       	push   $0x802f25
  8010e6:	e8 ac 15 00 00       	call   802697 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010eb:	89 d3                	mov    %edx,%ebx
  8010ed:	c1 e3 0c             	shl    $0xc,%ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	68 05 08 00 00       	push   $0x805
  8010f8:	53                   	push   %ebx
  8010f9:	50                   	push   %eax
  8010fa:	53                   	push   %ebx
  8010fb:	6a 00                	push   $0x0
  8010fd:	e8 c6 fc ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  801102:	83 c4 20             	add    $0x20,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	78 2e                	js     801137 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	68 05 08 00 00       	push   $0x805
  801111:	53                   	push   %ebx
  801112:	6a 00                	push   $0x0
  801114:	53                   	push   %ebx
  801115:	6a 00                	push   $0x0
  801117:	e8 ac fc ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  80111c:	83 c4 20             	add    $0x20,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	79 85                	jns    8010a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	68 0f 2f 80 00       	push   $0x802f0f
  80112b:	6a 5f                	push   $0x5f
  80112d:	68 25 2f 80 00       	push   $0x802f25
  801132:	e8 60 15 00 00       	call   802697 <_panic>
			panic("sys_page_map() panic\n");
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	68 0f 2f 80 00       	push   $0x802f0f
  80113f:	6a 5b                	push   $0x5b
  801141:	68 25 2f 80 00       	push   $0x802f25
  801146:	e8 4c 15 00 00       	call   802697 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80114b:	c1 e2 0c             	shl    $0xc,%edx
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	68 05 08 00 00       	push   $0x805
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	52                   	push   %edx
  801159:	6a 00                	push   $0x0
  80115b:	e8 68 fc ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	0f 89 3d ff ff ff    	jns    8010a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80116b:	83 ec 04             	sub    $0x4,%esp
  80116e:	68 0f 2f 80 00       	push   $0x802f0f
  801173:	6a 66                	push   $0x66
  801175:	68 25 2f 80 00       	push   $0x802f25
  80117a:	e8 18 15 00 00       	call   802697 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80117f:	c1 e2 0c             	shl    $0xc,%edx
  801182:	83 ec 0c             	sub    $0xc,%esp
  801185:	6a 05                	push   $0x5
  801187:	52                   	push   %edx
  801188:	50                   	push   %eax
  801189:	52                   	push   %edx
  80118a:	6a 00                	push   $0x0
  80118c:	e8 37 fc ff ff       	call   800dc8 <sys_page_map>
		if(r < 0)
  801191:	83 c4 20             	add    $0x20,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	0f 89 0c ff ff ff    	jns    8010a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80119c:	83 ec 04             	sub    $0x4,%esp
  80119f:	68 0f 2f 80 00       	push   $0x802f0f
  8011a4:	6a 6d                	push   $0x6d
  8011a6:	68 25 2f 80 00       	push   $0x802f25
  8011ab:	e8 e7 14 00 00       	call   802697 <_panic>

008011b0 <pgfault>:
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011ba:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011bc:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011c0:	0f 84 99 00 00 00    	je     80125f <pgfault+0xaf>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	c1 ea 16             	shr    $0x16,%edx
  8011cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d2:	f6 c2 01             	test   $0x1,%dl
  8011d5:	0f 84 84 00 00 00    	je     80125f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	c1 ea 0c             	shr    $0xc,%edx
  8011e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e7:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ed:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011f3:	75 6a                	jne    80125f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011fa:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	6a 07                	push   $0x7
  801201:	68 00 f0 7f 00       	push   $0x7ff000
  801206:	6a 00                	push   $0x0
  801208:	e8 78 fb ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	78 5f                	js     801273 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	68 00 10 00 00       	push   $0x1000
  80121c:	53                   	push   %ebx
  80121d:	68 00 f0 7f 00       	push   $0x7ff000
  801222:	e8 5c f9 ff ff       	call   800b83 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801227:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80122e:	53                   	push   %ebx
  80122f:	6a 00                	push   $0x0
  801231:	68 00 f0 7f 00       	push   $0x7ff000
  801236:	6a 00                	push   $0x0
  801238:	e8 8b fb ff ff       	call   800dc8 <sys_page_map>
	if(ret < 0)
  80123d:	83 c4 20             	add    $0x20,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 43                	js     801287 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	68 00 f0 7f 00       	push   $0x7ff000
  80124c:	6a 00                	push   $0x0
  80124e:	e8 b7 fb ff ff       	call   800e0a <sys_page_unmap>
	if(ret < 0)
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	78 41                	js     80129b <pgfault+0xeb>
}
  80125a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80125f:	83 ec 04             	sub    $0x4,%esp
  801262:	68 30 2f 80 00       	push   $0x802f30
  801267:	6a 26                	push   $0x26
  801269:	68 25 2f 80 00       	push   $0x802f25
  80126e:	e8 24 14 00 00       	call   802697 <_panic>
		panic("panic in sys_page_alloc()\n");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 44 2f 80 00       	push   $0x802f44
  80127b:	6a 31                	push   $0x31
  80127d:	68 25 2f 80 00       	push   $0x802f25
  801282:	e8 10 14 00 00       	call   802697 <_panic>
		panic("panic in sys_page_map()\n");
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	68 5f 2f 80 00       	push   $0x802f5f
  80128f:	6a 36                	push   $0x36
  801291:	68 25 2f 80 00       	push   $0x802f25
  801296:	e8 fc 13 00 00       	call   802697 <_panic>
		panic("panic in sys_page_unmap()\n");
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	68 78 2f 80 00       	push   $0x802f78
  8012a3:	6a 39                	push   $0x39
  8012a5:	68 25 2f 80 00       	push   $0x802f25
  8012aa:	e8 e8 13 00 00       	call   802697 <_panic>

008012af <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	57                   	push   %edi
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012b8:	68 b0 11 80 00       	push   $0x8011b0
  8012bd:	e8 36 14 00 00       	call   8026f8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8012c7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 27                	js     8012f7 <fork+0x48>
  8012d0:	89 c6                	mov    %eax,%esi
  8012d2:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012d4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012d9:	75 48                	jne    801323 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012db:	e8 67 fa ff ff       	call   800d47 <sys_getenvid>
  8012e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012e5:	c1 e0 07             	shl    $0x7,%eax
  8012e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ed:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012f2:	e9 90 00 00 00       	jmp    801387 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 94 2f 80 00       	push   $0x802f94
  8012ff:	68 8c 00 00 00       	push   $0x8c
  801304:	68 25 2f 80 00       	push   $0x802f25
  801309:	e8 89 13 00 00       	call   802697 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80130e:	89 f8                	mov    %edi,%eax
  801310:	e8 45 fd ff ff       	call   80105a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801315:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80131b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801321:	74 26                	je     801349 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801323:	89 d8                	mov    %ebx,%eax
  801325:	c1 e8 16             	shr    $0x16,%eax
  801328:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132f:	a8 01                	test   $0x1,%al
  801331:	74 e2                	je     801315 <fork+0x66>
  801333:	89 da                	mov    %ebx,%edx
  801335:	c1 ea 0c             	shr    $0xc,%edx
  801338:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80133f:	83 e0 05             	and    $0x5,%eax
  801342:	83 f8 05             	cmp    $0x5,%eax
  801345:	75 ce                	jne    801315 <fork+0x66>
  801347:	eb c5                	jmp    80130e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	6a 07                	push   $0x7
  80134e:	68 00 f0 bf ee       	push   $0xeebff000
  801353:	56                   	push   %esi
  801354:	e8 2c fa ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 31                	js     801391 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	68 67 27 80 00       	push   $0x802767
  801368:	56                   	push   %esi
  801369:	e8 62 fb ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 33                	js     8013a8 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801375:	83 ec 08             	sub    $0x8,%esp
  801378:	6a 02                	push   $0x2
  80137a:	56                   	push   %esi
  80137b:	e8 cc fa ff ff       	call   800e4c <sys_env_set_status>
	if(ret < 0)
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 38                	js     8013bf <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801387:	89 f0                	mov    %esi,%eax
  801389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	68 44 2f 80 00       	push   $0x802f44
  801399:	68 98 00 00 00       	push   $0x98
  80139e:	68 25 2f 80 00       	push   $0x802f25
  8013a3:	e8 ef 12 00 00       	call   802697 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	68 b8 2f 80 00       	push   $0x802fb8
  8013b0:	68 9b 00 00 00       	push   $0x9b
  8013b5:	68 25 2f 80 00       	push   $0x802f25
  8013ba:	e8 d8 12 00 00       	call   802697 <_panic>
		panic("panic in sys_env_set_status()\n");
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 e0 2f 80 00       	push   $0x802fe0
  8013c7:	68 9e 00 00 00       	push   $0x9e
  8013cc:	68 25 2f 80 00       	push   $0x802f25
  8013d1:	e8 c1 12 00 00       	call   802697 <_panic>

008013d6 <sfork>:

// Challenge!
int
sfork(void)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	57                   	push   %edi
  8013da:	56                   	push   %esi
  8013db:	53                   	push   %ebx
  8013dc:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013df:	68 b0 11 80 00       	push   $0x8011b0
  8013e4:	e8 0f 13 00 00       	call   8026f8 <set_pgfault_handler>
  8013e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8013ee:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 27                	js     80141e <sfork+0x48>
  8013f7:	89 c7                	mov    %eax,%edi
  8013f9:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013fb:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801400:	75 55                	jne    801457 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801402:	e8 40 f9 ff ff       	call   800d47 <sys_getenvid>
  801407:	25 ff 03 00 00       	and    $0x3ff,%eax
  80140c:	c1 e0 07             	shl    $0x7,%eax
  80140f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801414:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801419:	e9 d4 00 00 00       	jmp    8014f2 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	68 94 2f 80 00       	push   $0x802f94
  801426:	68 af 00 00 00       	push   $0xaf
  80142b:	68 25 2f 80 00       	push   $0x802f25
  801430:	e8 62 12 00 00       	call   802697 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801435:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80143a:	89 f0                	mov    %esi,%eax
  80143c:	e8 19 fc ff ff       	call   80105a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801447:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80144d:	77 65                	ja     8014b4 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80144f:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801455:	74 de                	je     801435 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801457:	89 d8                	mov    %ebx,%eax
  801459:	c1 e8 16             	shr    $0x16,%eax
  80145c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801463:	a8 01                	test   $0x1,%al
  801465:	74 da                	je     801441 <sfork+0x6b>
  801467:	89 da                	mov    %ebx,%edx
  801469:	c1 ea 0c             	shr    $0xc,%edx
  80146c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801473:	83 e0 05             	and    $0x5,%eax
  801476:	83 f8 05             	cmp    $0x5,%eax
  801479:	75 c6                	jne    801441 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80147b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801482:	c1 e2 0c             	shl    $0xc,%edx
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	83 e0 07             	and    $0x7,%eax
  80148b:	50                   	push   %eax
  80148c:	52                   	push   %edx
  80148d:	56                   	push   %esi
  80148e:	52                   	push   %edx
  80148f:	6a 00                	push   $0x0
  801491:	e8 32 f9 ff ff       	call   800dc8 <sys_page_map>
  801496:	83 c4 20             	add    $0x20,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	74 a4                	je     801441 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	68 0f 2f 80 00       	push   $0x802f0f
  8014a5:	68 ba 00 00 00       	push   $0xba
  8014aa:	68 25 2f 80 00       	push   $0x802f25
  8014af:	e8 e3 11 00 00       	call   802697 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	6a 07                	push   $0x7
  8014b9:	68 00 f0 bf ee       	push   $0xeebff000
  8014be:	57                   	push   %edi
  8014bf:	e8 c1 f8 ff ff       	call   800d85 <sys_page_alloc>
	if(ret < 0)
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 31                	js     8014fc <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	68 67 27 80 00       	push   $0x802767
  8014d3:	57                   	push   %edi
  8014d4:	e8 f7 f9 ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 33                	js     801513 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	6a 02                	push   $0x2
  8014e5:	57                   	push   %edi
  8014e6:	e8 61 f9 ff ff       	call   800e4c <sys_env_set_status>
	if(ret < 0)
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 38                	js     80152a <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014f2:	89 f8                	mov    %edi,%eax
  8014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014fc:	83 ec 04             	sub    $0x4,%esp
  8014ff:	68 44 2f 80 00       	push   $0x802f44
  801504:	68 c0 00 00 00       	push   $0xc0
  801509:	68 25 2f 80 00       	push   $0x802f25
  80150e:	e8 84 11 00 00       	call   802697 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	68 b8 2f 80 00       	push   $0x802fb8
  80151b:	68 c3 00 00 00       	push   $0xc3
  801520:	68 25 2f 80 00       	push   $0x802f25
  801525:	e8 6d 11 00 00       	call   802697 <_panic>
		panic("panic in sys_env_set_status()\n");
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	68 e0 2f 80 00       	push   $0x802fe0
  801532:	68 c6 00 00 00       	push   $0xc6
  801537:	68 25 2f 80 00       	push   $0x802f25
  80153c:	e8 56 11 00 00       	call   802697 <_panic>

00801541 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	05 00 00 00 30       	add    $0x30000000,%eax
  80154c:	c1 e8 0c             	shr    $0xc,%eax
}
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    

00801551 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80155c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801561:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    

00801568 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801570:	89 c2                	mov    %eax,%edx
  801572:	c1 ea 16             	shr    $0x16,%edx
  801575:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80157c:	f6 c2 01             	test   $0x1,%dl
  80157f:	74 2d                	je     8015ae <fd_alloc+0x46>
  801581:	89 c2                	mov    %eax,%edx
  801583:	c1 ea 0c             	shr    $0xc,%edx
  801586:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80158d:	f6 c2 01             	test   $0x1,%dl
  801590:	74 1c                	je     8015ae <fd_alloc+0x46>
  801592:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801597:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80159c:	75 d2                	jne    801570 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015a7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015ac:	eb 0a                	jmp    8015b8 <fd_alloc+0x50>
			*fd_store = fd;
  8015ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015c0:	83 f8 1f             	cmp    $0x1f,%eax
  8015c3:	77 30                	ja     8015f5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015c5:	c1 e0 0c             	shl    $0xc,%eax
  8015c8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015cd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015d3:	f6 c2 01             	test   $0x1,%dl
  8015d6:	74 24                	je     8015fc <fd_lookup+0x42>
  8015d8:	89 c2                	mov    %eax,%edx
  8015da:	c1 ea 0c             	shr    $0xc,%edx
  8015dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015e4:	f6 c2 01             	test   $0x1,%dl
  8015e7:	74 1a                	je     801603 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ec:	89 02                	mov    %eax,(%edx)
	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    
		return -E_INVAL;
  8015f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fa:	eb f7                	jmp    8015f3 <fd_lookup+0x39>
		return -E_INVAL;
  8015fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801601:	eb f0                	jmp    8015f3 <fd_lookup+0x39>
  801603:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801608:	eb e9                	jmp    8015f3 <fd_lookup+0x39>

0080160a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
  801618:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80161d:	39 08                	cmp    %ecx,(%eax)
  80161f:	74 38                	je     801659 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801621:	83 c2 01             	add    $0x1,%edx
  801624:	8b 04 95 7c 30 80 00 	mov    0x80307c(,%edx,4),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	75 ee                	jne    80161d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80162f:	a1 08 50 80 00       	mov    0x805008,%eax
  801634:	8b 40 48             	mov    0x48(%eax),%eax
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	51                   	push   %ecx
  80163b:	50                   	push   %eax
  80163c:	68 00 30 80 00       	push   $0x803000
  801641:	e8 ee eb ff ff       	call   800234 <cprintf>
	*dev = 0;
  801646:	8b 45 0c             	mov    0xc(%ebp),%eax
  801649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    
			*dev = devtab[i];
  801659:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80165c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	eb f2                	jmp    801657 <dev_lookup+0x4d>

00801665 <fd_close>:
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	57                   	push   %edi
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	83 ec 24             	sub    $0x24,%esp
  80166e:	8b 75 08             	mov    0x8(%ebp),%esi
  801671:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801674:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801677:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801678:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80167e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801681:	50                   	push   %eax
  801682:	e8 33 ff ff ff       	call   8015ba <fd_lookup>
  801687:	89 c3                	mov    %eax,%ebx
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 05                	js     801695 <fd_close+0x30>
	    || fd != fd2)
  801690:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801693:	74 16                	je     8016ab <fd_close+0x46>
		return (must_exist ? r : 0);
  801695:	89 f8                	mov    %edi,%eax
  801697:	84 c0                	test   %al,%al
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	0f 44 d8             	cmove  %eax,%ebx
}
  8016a1:	89 d8                	mov    %ebx,%eax
  8016a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5f                   	pop    %edi
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	ff 36                	pushl  (%esi)
  8016b4:	e8 51 ff ff ff       	call   80160a <dev_lookup>
  8016b9:	89 c3                	mov    %eax,%ebx
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 1a                	js     8016dc <fd_close+0x77>
		if (dev->dev_close)
  8016c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	74 0b                	je     8016dc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	56                   	push   %esi
  8016d5:	ff d0                	call   *%eax
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	56                   	push   %esi
  8016e0:	6a 00                	push   $0x0
  8016e2:	e8 23 f7 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	eb b5                	jmp    8016a1 <fd_close+0x3c>

008016ec <close>:

int
close(int fdnum)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f5:	50                   	push   %eax
  8016f6:	ff 75 08             	pushl  0x8(%ebp)
  8016f9:	e8 bc fe ff ff       	call   8015ba <fd_lookup>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	79 02                	jns    801707 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    
		return fd_close(fd, 1);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	6a 01                	push   $0x1
  80170c:	ff 75 f4             	pushl  -0xc(%ebp)
  80170f:	e8 51 ff ff ff       	call   801665 <fd_close>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	eb ec                	jmp    801705 <close+0x19>

00801719 <close_all>:

void
close_all(void)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
  80171d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801720:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	53                   	push   %ebx
  801729:	e8 be ff ff ff       	call   8016ec <close>
	for (i = 0; i < MAXFD; i++)
  80172e:	83 c3 01             	add    $0x1,%ebx
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	83 fb 20             	cmp    $0x20,%ebx
  801737:	75 ec                	jne    801725 <close_all+0xc>
}
  801739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801747:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80174a:	50                   	push   %eax
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 67 fe ff ff       	call   8015ba <fd_lookup>
  801753:	89 c3                	mov    %eax,%ebx
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	0f 88 81 00 00 00    	js     8017e1 <dup+0xa3>
		return r;
	close(newfdnum);
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	e8 81 ff ff ff       	call   8016ec <close>

	newfd = INDEX2FD(newfdnum);
  80176b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80176e:	c1 e6 0c             	shl    $0xc,%esi
  801771:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801777:	83 c4 04             	add    $0x4,%esp
  80177a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80177d:	e8 cf fd ff ff       	call   801551 <fd2data>
  801782:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801784:	89 34 24             	mov    %esi,(%esp)
  801787:	e8 c5 fd ff ff       	call   801551 <fd2data>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801791:	89 d8                	mov    %ebx,%eax
  801793:	c1 e8 16             	shr    $0x16,%eax
  801796:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80179d:	a8 01                	test   $0x1,%al
  80179f:	74 11                	je     8017b2 <dup+0x74>
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	c1 e8 0c             	shr    $0xc,%eax
  8017a6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017ad:	f6 c2 01             	test   $0x1,%dl
  8017b0:	75 39                	jne    8017eb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	c1 e8 0c             	shr    $0xc,%eax
  8017ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c1:	83 ec 0c             	sub    $0xc,%esp
  8017c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8017c9:	50                   	push   %eax
  8017ca:	56                   	push   %esi
  8017cb:	6a 00                	push   $0x0
  8017cd:	52                   	push   %edx
  8017ce:	6a 00                	push   $0x0
  8017d0:	e8 f3 f5 ff ff       	call   800dc8 <sys_page_map>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 20             	add    $0x20,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 31                	js     80180f <dup+0xd1>
		goto err;

	return newfdnum;
  8017de:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017e1:	89 d8                	mov    %ebx,%eax
  8017e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5f                   	pop    %edi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fa:	50                   	push   %eax
  8017fb:	57                   	push   %edi
  8017fc:	6a 00                	push   $0x0
  8017fe:	53                   	push   %ebx
  8017ff:	6a 00                	push   $0x0
  801801:	e8 c2 f5 ff ff       	call   800dc8 <sys_page_map>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	83 c4 20             	add    $0x20,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	79 a3                	jns    8017b2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	56                   	push   %esi
  801813:	6a 00                	push   $0x0
  801815:	e8 f0 f5 ff ff       	call   800e0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80181a:	83 c4 08             	add    $0x8,%esp
  80181d:	57                   	push   %edi
  80181e:	6a 00                	push   $0x0
  801820:	e8 e5 f5 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	eb b7                	jmp    8017e1 <dup+0xa3>

0080182a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 1c             	sub    $0x1c,%esp
  801831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	53                   	push   %ebx
  801839:	e8 7c fd ff ff       	call   8015ba <fd_lookup>
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 3f                	js     801884 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184f:	ff 30                	pushl  (%eax)
  801851:	e8 b4 fd ff ff       	call   80160a <dev_lookup>
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 27                	js     801884 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80185d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801860:	8b 42 08             	mov    0x8(%edx),%eax
  801863:	83 e0 03             	and    $0x3,%eax
  801866:	83 f8 01             	cmp    $0x1,%eax
  801869:	74 1e                	je     801889 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	8b 40 08             	mov    0x8(%eax),%eax
  801871:	85 c0                	test   %eax,%eax
  801873:	74 35                	je     8018aa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	ff 75 10             	pushl  0x10(%ebp)
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	52                   	push   %edx
  80187f:	ff d0                	call   *%eax
  801881:	83 c4 10             	add    $0x10,%esp
}
  801884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801887:	c9                   	leave  
  801888:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801889:	a1 08 50 80 00       	mov    0x805008,%eax
  80188e:	8b 40 48             	mov    0x48(%eax),%eax
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	53                   	push   %ebx
  801895:	50                   	push   %eax
  801896:	68 41 30 80 00       	push   $0x803041
  80189b:	e8 94 e9 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a8:	eb da                	jmp    801884 <read+0x5a>
		return -E_NOT_SUPP;
  8018aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018af:	eb d3                	jmp    801884 <read+0x5a>

008018b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	57                   	push   %edi
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018bd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c5:	39 f3                	cmp    %esi,%ebx
  8018c7:	73 23                	jae    8018ec <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	89 f0                	mov    %esi,%eax
  8018ce:	29 d8                	sub    %ebx,%eax
  8018d0:	50                   	push   %eax
  8018d1:	89 d8                	mov    %ebx,%eax
  8018d3:	03 45 0c             	add    0xc(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	57                   	push   %edi
  8018d8:	e8 4d ff ff ff       	call   80182a <read>
		if (m < 0)
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 06                	js     8018ea <readn+0x39>
			return m;
		if (m == 0)
  8018e4:	74 06                	je     8018ec <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018e6:	01 c3                	add    %eax,%ebx
  8018e8:	eb db                	jmp    8018c5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018ea:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5f                   	pop    %edi
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 1c             	sub    $0x1c,%esp
  8018fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801900:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801903:	50                   	push   %eax
  801904:	53                   	push   %ebx
  801905:	e8 b0 fc ff ff       	call   8015ba <fd_lookup>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 3a                	js     80194b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801911:	83 ec 08             	sub    $0x8,%esp
  801914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191b:	ff 30                	pushl  (%eax)
  80191d:	e8 e8 fc ff ff       	call   80160a <dev_lookup>
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	85 c0                	test   %eax,%eax
  801927:	78 22                	js     80194b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801930:	74 1e                	je     801950 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801932:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801935:	8b 52 0c             	mov    0xc(%edx),%edx
  801938:	85 d2                	test   %edx,%edx
  80193a:	74 35                	je     801971 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	ff 75 10             	pushl  0x10(%ebp)
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	50                   	push   %eax
  801946:	ff d2                	call   *%edx
  801948:	83 c4 10             	add    $0x10,%esp
}
  80194b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801950:	a1 08 50 80 00       	mov    0x805008,%eax
  801955:	8b 40 48             	mov    0x48(%eax),%eax
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	53                   	push   %ebx
  80195c:	50                   	push   %eax
  80195d:	68 5d 30 80 00       	push   $0x80305d
  801962:	e8 cd e8 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80196f:	eb da                	jmp    80194b <write+0x55>
		return -E_NOT_SUPP;
  801971:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801976:	eb d3                	jmp    80194b <write+0x55>

00801978 <seek>:

int
seek(int fdnum, off_t offset)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80197e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801981:	50                   	push   %eax
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	e8 30 fc ff ff       	call   8015ba <fd_lookup>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 0e                	js     80199f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801991:	8b 55 0c             	mov    0xc(%ebp),%edx
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 1c             	sub    $0x1c,%esp
  8019a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ae:	50                   	push   %eax
  8019af:	53                   	push   %ebx
  8019b0:	e8 05 fc ff ff       	call   8015ba <fd_lookup>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 37                	js     8019f3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bc:	83 ec 08             	sub    $0x8,%esp
  8019bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c6:	ff 30                	pushl  (%eax)
  8019c8:	e8 3d fc ff ff       	call   80160a <dev_lookup>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 1f                	js     8019f3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019db:	74 1b                	je     8019f8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e0:	8b 52 18             	mov    0x18(%edx),%edx
  8019e3:	85 d2                	test   %edx,%edx
  8019e5:	74 32                	je     801a19 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	ff d2                	call   *%edx
  8019f0:	83 c4 10             	add    $0x10,%esp
}
  8019f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019f8:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019fd:	8b 40 48             	mov    0x48(%eax),%eax
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	53                   	push   %ebx
  801a04:	50                   	push   %eax
  801a05:	68 20 30 80 00       	push   $0x803020
  801a0a:	e8 25 e8 ff ff       	call   800234 <cprintf>
		return -E_INVAL;
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a17:	eb da                	jmp    8019f3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1e:	eb d3                	jmp    8019f3 <ftruncate+0x52>

00801a20 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	53                   	push   %ebx
  801a24:	83 ec 1c             	sub    $0x1c,%esp
  801a27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2d:	50                   	push   %eax
  801a2e:	ff 75 08             	pushl  0x8(%ebp)
  801a31:	e8 84 fb ff ff       	call   8015ba <fd_lookup>
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 4b                	js     801a88 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a43:	50                   	push   %eax
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	ff 30                	pushl  (%eax)
  801a49:	e8 bc fb ff ff       	call   80160a <dev_lookup>
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 33                	js     801a88 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a58:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a5c:	74 2f                	je     801a8d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a5e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a61:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a68:	00 00 00 
	stat->st_isdir = 0;
  801a6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a72:	00 00 00 
	stat->st_dev = dev;
  801a75:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a7b:	83 ec 08             	sub    $0x8,%esp
  801a7e:	53                   	push   %ebx
  801a7f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a82:	ff 50 14             	call   *0x14(%eax)
  801a85:	83 c4 10             	add    $0x10,%esp
}
  801a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    
		return -E_NOT_SUPP;
  801a8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a92:	eb f4                	jmp    801a88 <fstat+0x68>

00801a94 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	e8 22 02 00 00       	call   801cc8 <open>
  801aa6:	89 c3                	mov    %eax,%ebx
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 1b                	js     801aca <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	e8 65 ff ff ff       	call   801a20 <fstat>
  801abb:	89 c6                	mov    %eax,%esi
	close(fd);
  801abd:	89 1c 24             	mov    %ebx,(%esp)
  801ac0:	e8 27 fc ff ff       	call   8016ec <close>
	return r;
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 f3                	mov    %esi,%ebx
}
  801aca:	89 d8                	mov    %ebx,%eax
  801acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    

00801ad3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	56                   	push   %esi
  801ad7:	53                   	push   %ebx
  801ad8:	89 c6                	mov    %eax,%esi
  801ada:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801adc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ae3:	74 27                	je     801b0c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ae5:	6a 07                	push   $0x7
  801ae7:	68 00 60 80 00       	push   $0x806000
  801aec:	56                   	push   %esi
  801aed:	ff 35 00 50 80 00    	pushl  0x805000
  801af3:	e8 fe 0c 00 00       	call   8027f6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801af8:	83 c4 0c             	add    $0xc,%esp
  801afb:	6a 00                	push   $0x0
  801afd:	53                   	push   %ebx
  801afe:	6a 00                	push   $0x0
  801b00:	e8 88 0c 00 00       	call   80278d <ipc_recv>
}
  801b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	6a 01                	push   $0x1
  801b11:	e8 38 0d 00 00       	call   80284e <ipc_find_env>
  801b16:	a3 00 50 80 00       	mov    %eax,0x805000
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	eb c5                	jmp    801ae5 <fsipc+0x12>

00801b20 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b39:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b43:	e8 8b ff ff ff       	call   801ad3 <fsipc>
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <devfile_flush>:
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	8b 40 0c             	mov    0xc(%eax),%eax
  801b56:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	b8 06 00 00 00       	mov    $0x6,%eax
  801b65:	e8 69 ff ff ff       	call   801ad3 <fsipc>
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <devfile_stat>:
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b81:	ba 00 00 00 00       	mov    $0x0,%edx
  801b86:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8b:	e8 43 ff ff ff       	call   801ad3 <fsipc>
  801b90:	85 c0                	test   %eax,%eax
  801b92:	78 2c                	js     801bc0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b94:	83 ec 08             	sub    $0x8,%esp
  801b97:	68 00 60 80 00       	push   $0x806000
  801b9c:	53                   	push   %ebx
  801b9d:	e8 f1 ed ff ff       	call   800993 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ba2:	a1 80 60 80 00       	mov    0x806080,%eax
  801ba7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bad:	a1 84 60 80 00       	mov    0x806084,%eax
  801bb2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <devfile_write>:
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bda:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801be0:	53                   	push   %ebx
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	68 08 60 80 00       	push   $0x806008
  801be9:	e8 95 ef ff ff       	call   800b83 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bee:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf3:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf8:	e8 d6 fe ff ff       	call   801ad3 <fsipc>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 0b                	js     801c0f <devfile_write+0x4a>
	assert(r <= n);
  801c04:	39 d8                	cmp    %ebx,%eax
  801c06:	77 0c                	ja     801c14 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c08:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c0d:	7f 1e                	jg     801c2d <devfile_write+0x68>
}
  801c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    
	assert(r <= n);
  801c14:	68 90 30 80 00       	push   $0x803090
  801c19:	68 97 30 80 00       	push   $0x803097
  801c1e:	68 98 00 00 00       	push   $0x98
  801c23:	68 ac 30 80 00       	push   $0x8030ac
  801c28:	e8 6a 0a 00 00       	call   802697 <_panic>
	assert(r <= PGSIZE);
  801c2d:	68 b7 30 80 00       	push   $0x8030b7
  801c32:	68 97 30 80 00       	push   $0x803097
  801c37:	68 99 00 00 00       	push   $0x99
  801c3c:	68 ac 30 80 00       	push   $0x8030ac
  801c41:	e8 51 0a 00 00       	call   802697 <_panic>

00801c46 <devfile_read>:
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8b 40 0c             	mov    0xc(%eax),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c59:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c64:	b8 03 00 00 00       	mov    $0x3,%eax
  801c69:	e8 65 fe ff ff       	call   801ad3 <fsipc>
  801c6e:	89 c3                	mov    %eax,%ebx
  801c70:	85 c0                	test   %eax,%eax
  801c72:	78 1f                	js     801c93 <devfile_read+0x4d>
	assert(r <= n);
  801c74:	39 f0                	cmp    %esi,%eax
  801c76:	77 24                	ja     801c9c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c7d:	7f 33                	jg     801cb2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c7f:	83 ec 04             	sub    $0x4,%esp
  801c82:	50                   	push   %eax
  801c83:	68 00 60 80 00       	push   $0x806000
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	e8 91 ee ff ff       	call   800b21 <memmove>
	return r;
  801c90:	83 c4 10             	add    $0x10,%esp
}
  801c93:	89 d8                	mov    %ebx,%eax
  801c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
	assert(r <= n);
  801c9c:	68 90 30 80 00       	push   $0x803090
  801ca1:	68 97 30 80 00       	push   $0x803097
  801ca6:	6a 7c                	push   $0x7c
  801ca8:	68 ac 30 80 00       	push   $0x8030ac
  801cad:	e8 e5 09 00 00       	call   802697 <_panic>
	assert(r <= PGSIZE);
  801cb2:	68 b7 30 80 00       	push   $0x8030b7
  801cb7:	68 97 30 80 00       	push   $0x803097
  801cbc:	6a 7d                	push   $0x7d
  801cbe:	68 ac 30 80 00       	push   $0x8030ac
  801cc3:	e8 cf 09 00 00       	call   802697 <_panic>

00801cc8 <open>:
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	56                   	push   %esi
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 1c             	sub    $0x1c,%esp
  801cd0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cd3:	56                   	push   %esi
  801cd4:	e8 81 ec ff ff       	call   80095a <strlen>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ce1:	7f 6c                	jg     801d4f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce9:	50                   	push   %eax
  801cea:	e8 79 f8 ff ff       	call   801568 <fd_alloc>
  801cef:	89 c3                	mov    %eax,%ebx
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 3c                	js     801d34 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	56                   	push   %esi
  801cfc:	68 00 60 80 00       	push   $0x806000
  801d01:	e8 8d ec ff ff       	call   800993 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d09:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d11:	b8 01 00 00 00       	mov    $0x1,%eax
  801d16:	e8 b8 fd ff ff       	call   801ad3 <fsipc>
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 19                	js     801d3d <open+0x75>
	return fd2num(fd);
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2a:	e8 12 f8 ff ff       	call   801541 <fd2num>
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	83 c4 10             	add    $0x10,%esp
}
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    
		fd_close(fd, 0);
  801d3d:	83 ec 08             	sub    $0x8,%esp
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 f4             	pushl  -0xc(%ebp)
  801d45:	e8 1b f9 ff ff       	call   801665 <fd_close>
		return r;
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	eb e5                	jmp    801d34 <open+0x6c>
		return -E_BAD_PATH;
  801d4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d54:	eb de                	jmp    801d34 <open+0x6c>

00801d56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d61:	b8 08 00 00 00       	mov    $0x8,%eax
  801d66:	e8 68 fd ff ff       	call   801ad3 <fsipc>
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d73:	68 c3 30 80 00       	push   $0x8030c3
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	e8 13 ec ff ff       	call   800993 <strcpy>
	return 0;
}
  801d80:	b8 00 00 00 00       	mov    $0x0,%eax
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <devsock_close>:
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	53                   	push   %ebx
  801d8b:	83 ec 10             	sub    $0x10,%esp
  801d8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d91:	53                   	push   %ebx
  801d92:	e8 f2 0a 00 00       	call   802889 <pageref>
  801d97:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d9a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d9f:	83 f8 01             	cmp    $0x1,%eax
  801da2:	74 07                	je     801dab <devsock_close+0x24>
}
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	ff 73 0c             	pushl  0xc(%ebx)
  801db1:	e8 b9 02 00 00       	call   80206f <nsipc_close>
  801db6:	89 c2                	mov    %eax,%edx
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	eb e7                	jmp    801da4 <devsock_close+0x1d>

00801dbd <devsock_write>:
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	ff 75 10             	pushl  0x10(%ebp)
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	ff 70 0c             	pushl  0xc(%eax)
  801dd1:	e8 76 03 00 00       	call   80214c <nsipc_send>
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <devsock_read>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 10             	pushl  0x10(%ebp)
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	ff 70 0c             	pushl  0xc(%eax)
  801dec:	e8 ef 02 00 00       	call   8020e0 <nsipc_recv>
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <fd2sockid>:
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801df9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dfc:	52                   	push   %edx
  801dfd:	50                   	push   %eax
  801dfe:	e8 b7 f7 ff ff       	call   8015ba <fd_lookup>
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 10                	js     801e1a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e13:	39 08                	cmp    %ecx,(%eax)
  801e15:	75 05                	jne    801e1c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e17:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    
		return -E_NOT_SUPP;
  801e1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e21:	eb f7                	jmp    801e1a <fd2sockid+0x27>

00801e23 <alloc_sockfd>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	56                   	push   %esi
  801e27:	53                   	push   %ebx
  801e28:	83 ec 1c             	sub    $0x1c,%esp
  801e2b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e30:	50                   	push   %eax
  801e31:	e8 32 f7 ff ff       	call   801568 <fd_alloc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	78 43                	js     801e82 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	68 07 04 00 00       	push   $0x407
  801e47:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4a:	6a 00                	push   $0x0
  801e4c:	e8 34 ef ff ff       	call   800d85 <sys_page_alloc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 28                	js     801e82 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e63:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e6f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	50                   	push   %eax
  801e76:	e8 c6 f6 ff ff       	call   801541 <fd2num>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	eb 0c                	jmp    801e8e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	56                   	push   %esi
  801e86:	e8 e4 01 00 00       	call   80206f <nsipc_close>
		return r;
  801e8b:	83 c4 10             	add    $0x10,%esp
}
  801e8e:	89 d8                	mov    %ebx,%eax
  801e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <accept>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	e8 4e ff ff ff       	call   801df3 <fd2sockid>
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 1b                	js     801ec4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	ff 75 10             	pushl  0x10(%ebp)
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	50                   	push   %eax
  801eb3:	e8 0e 01 00 00       	call   801fc6 <nsipc_accept>
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	78 05                	js     801ec4 <accept+0x2d>
	return alloc_sockfd(r);
  801ebf:	e8 5f ff ff ff       	call   801e23 <alloc_sockfd>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <bind>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	e8 1f ff ff ff       	call   801df3 <fd2sockid>
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 12                	js     801eea <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	ff 75 10             	pushl  0x10(%ebp)
  801ede:	ff 75 0c             	pushl  0xc(%ebp)
  801ee1:	50                   	push   %eax
  801ee2:	e8 31 01 00 00       	call   802018 <nsipc_bind>
  801ee7:	83 c4 10             	add    $0x10,%esp
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <shutdown>:
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	e8 f9 fe ff ff       	call   801df3 <fd2sockid>
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 0f                	js     801f0d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	50                   	push   %eax
  801f05:	e8 43 01 00 00       	call   80204d <nsipc_shutdown>
  801f0a:	83 c4 10             	add    $0x10,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <connect>:
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	e8 d6 fe ff ff       	call   801df3 <fd2sockid>
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 12                	js     801f33 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f21:	83 ec 04             	sub    $0x4,%esp
  801f24:	ff 75 10             	pushl  0x10(%ebp)
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	50                   	push   %eax
  801f2b:	e8 59 01 00 00       	call   802089 <nsipc_connect>
  801f30:	83 c4 10             	add    $0x10,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <listen>:
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	e8 b0 fe ff ff       	call   801df3 <fd2sockid>
  801f43:	85 c0                	test   %eax,%eax
  801f45:	78 0f                	js     801f56 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f47:	83 ec 08             	sub    $0x8,%esp
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	50                   	push   %eax
  801f4e:	e8 6b 01 00 00       	call   8020be <nsipc_listen>
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f5e:	ff 75 10             	pushl  0x10(%ebp)
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 3e 02 00 00       	call   8021aa <nsipc_socket>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 05                	js     801f78 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f73:	e8 ab fe ff ff       	call   801e23 <alloc_sockfd>
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f83:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f8a:	74 26                	je     801fb2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f8c:	6a 07                	push   $0x7
  801f8e:	68 00 70 80 00       	push   $0x807000
  801f93:	53                   	push   %ebx
  801f94:	ff 35 04 50 80 00    	pushl  0x805004
  801f9a:	e8 57 08 00 00       	call   8027f6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f9f:	83 c4 0c             	add    $0xc,%esp
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	e8 e0 07 00 00       	call   80278d <ipc_recv>
}
  801fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fb2:	83 ec 0c             	sub    $0xc,%esp
  801fb5:	6a 02                	push   $0x2
  801fb7:	e8 92 08 00 00       	call   80284e <ipc_find_env>
  801fbc:	a3 04 50 80 00       	mov    %eax,0x805004
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	eb c6                	jmp    801f8c <nsipc+0x12>

00801fc6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	56                   	push   %esi
  801fca:	53                   	push   %ebx
  801fcb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fd6:	8b 06                	mov    (%esi),%eax
  801fd8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe2:	e8 93 ff ff ff       	call   801f7a <nsipc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	79 09                	jns    801ff6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fed:	89 d8                	mov    %ebx,%eax
  801fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff2:	5b                   	pop    %ebx
  801ff3:	5e                   	pop    %esi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	ff 35 10 70 80 00    	pushl  0x807010
  801fff:	68 00 70 80 00       	push   $0x807000
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	e8 15 eb ff ff       	call   800b21 <memmove>
		*addrlen = ret->ret_addrlen;
  80200c:	a1 10 70 80 00       	mov    0x807010,%eax
  802011:	89 06                	mov    %eax,(%esi)
  802013:	83 c4 10             	add    $0x10,%esp
	return r;
  802016:	eb d5                	jmp    801fed <nsipc_accept+0x27>

00802018 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	53                   	push   %ebx
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80202a:	53                   	push   %ebx
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	68 04 70 80 00       	push   $0x807004
  802033:	e8 e9 ea ff ff       	call   800b21 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802038:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80203e:	b8 02 00 00 00       	mov    $0x2,%eax
  802043:	e8 32 ff ff ff       	call   801f7a <nsipc>
}
  802048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80205b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802063:	b8 03 00 00 00       	mov    $0x3,%eax
  802068:	e8 0d ff ff ff       	call   801f7a <nsipc>
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <nsipc_close>:

int
nsipc_close(int s)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80207d:	b8 04 00 00 00       	mov    $0x4,%eax
  802082:	e8 f3 fe ff ff       	call   801f7a <nsipc>
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	53                   	push   %ebx
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80209b:	53                   	push   %ebx
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	68 04 70 80 00       	push   $0x807004
  8020a4:	e8 78 ea ff ff       	call   800b21 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020a9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020af:	b8 05 00 00 00       	mov    $0x5,%eax
  8020b4:	e8 c1 fe ff ff       	call   801f7a <nsipc>
}
  8020b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8020d9:	e8 9c fe ff ff       	call   801f7a <nsipc>
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020f0:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f9:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020fe:	b8 07 00 00 00       	mov    $0x7,%eax
  802103:	e8 72 fe ff ff       	call   801f7a <nsipc>
  802108:	89 c3                	mov    %eax,%ebx
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 1f                	js     80212d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80210e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802113:	7f 21                	jg     802136 <nsipc_recv+0x56>
  802115:	39 c6                	cmp    %eax,%esi
  802117:	7c 1d                	jl     802136 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802119:	83 ec 04             	sub    $0x4,%esp
  80211c:	50                   	push   %eax
  80211d:	68 00 70 80 00       	push   $0x807000
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	e8 f7 e9 ff ff       	call   800b21 <memmove>
  80212a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80212d:	89 d8                	mov    %ebx,%eax
  80212f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802132:	5b                   	pop    %ebx
  802133:	5e                   	pop    %esi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802136:	68 cf 30 80 00       	push   $0x8030cf
  80213b:	68 97 30 80 00       	push   $0x803097
  802140:	6a 62                	push   $0x62
  802142:	68 e4 30 80 00       	push   $0x8030e4
  802147:	e8 4b 05 00 00       	call   802697 <_panic>

0080214c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	53                   	push   %ebx
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80215e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802164:	7f 2e                	jg     802194 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	53                   	push   %ebx
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	68 0c 70 80 00       	push   $0x80700c
  802172:	e8 aa e9 ff ff       	call   800b21 <memmove>
	nsipcbuf.send.req_size = size;
  802177:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80217d:	8b 45 14             	mov    0x14(%ebp),%eax
  802180:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802185:	b8 08 00 00 00       	mov    $0x8,%eax
  80218a:	e8 eb fd ff ff       	call   801f7a <nsipc>
}
  80218f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802192:	c9                   	leave  
  802193:	c3                   	ret    
	assert(size < 1600);
  802194:	68 f0 30 80 00       	push   $0x8030f0
  802199:	68 97 30 80 00       	push   $0x803097
  80219e:	6a 6d                	push   $0x6d
  8021a0:	68 e4 30 80 00       	push   $0x8030e4
  8021a5:	e8 ed 04 00 00       	call   802697 <_panic>

008021aa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021c8:	b8 09 00 00 00       	mov    $0x9,%eax
  8021cd:	e8 a8 fd ff ff       	call   801f7a <nsipc>
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021dc:	83 ec 0c             	sub    $0xc,%esp
  8021df:	ff 75 08             	pushl  0x8(%ebp)
  8021e2:	e8 6a f3 ff ff       	call   801551 <fd2data>
  8021e7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021e9:	83 c4 08             	add    $0x8,%esp
  8021ec:	68 fc 30 80 00       	push   $0x8030fc
  8021f1:	53                   	push   %ebx
  8021f2:	e8 9c e7 ff ff       	call   800993 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021f7:	8b 46 04             	mov    0x4(%esi),%eax
  8021fa:	2b 06                	sub    (%esi),%eax
  8021fc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802202:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802209:	00 00 00 
	stat->st_dev = &devpipe;
  80220c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802213:	40 80 00 
	return 0;
}
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
  80221b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221e:	5b                   	pop    %ebx
  80221f:	5e                   	pop    %esi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    

00802222 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	53                   	push   %ebx
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80222c:	53                   	push   %ebx
  80222d:	6a 00                	push   $0x0
  80222f:	e8 d6 eb ff ff       	call   800e0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802234:	89 1c 24             	mov    %ebx,(%esp)
  802237:	e8 15 f3 ff ff       	call   801551 <fd2data>
  80223c:	83 c4 08             	add    $0x8,%esp
  80223f:	50                   	push   %eax
  802240:	6a 00                	push   $0x0
  802242:	e8 c3 eb ff ff       	call   800e0a <sys_page_unmap>
}
  802247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <_pipeisclosed>:
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	57                   	push   %edi
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	83 ec 1c             	sub    $0x1c,%esp
  802255:	89 c7                	mov    %eax,%edi
  802257:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802259:	a1 08 50 80 00       	mov    0x805008,%eax
  80225e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802261:	83 ec 0c             	sub    $0xc,%esp
  802264:	57                   	push   %edi
  802265:	e8 1f 06 00 00       	call   802889 <pageref>
  80226a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80226d:	89 34 24             	mov    %esi,(%esp)
  802270:	e8 14 06 00 00       	call   802889 <pageref>
		nn = thisenv->env_runs;
  802275:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80227b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	39 cb                	cmp    %ecx,%ebx
  802283:	74 1b                	je     8022a0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802285:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802288:	75 cf                	jne    802259 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80228a:	8b 42 58             	mov    0x58(%edx),%eax
  80228d:	6a 01                	push   $0x1
  80228f:	50                   	push   %eax
  802290:	53                   	push   %ebx
  802291:	68 03 31 80 00       	push   $0x803103
  802296:	e8 99 df ff ff       	call   800234 <cprintf>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	eb b9                	jmp    802259 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022a0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022a3:	0f 94 c0             	sete   %al
  8022a6:	0f b6 c0             	movzbl %al,%eax
}
  8022a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5f                   	pop    %edi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <devpipe_write>:
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	57                   	push   %edi
  8022b5:	56                   	push   %esi
  8022b6:	53                   	push   %ebx
  8022b7:	83 ec 28             	sub    $0x28,%esp
  8022ba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022bd:	56                   	push   %esi
  8022be:	e8 8e f2 ff ff       	call   801551 <fd2data>
  8022c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022d0:	74 4f                	je     802321 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8022d5:	8b 0b                	mov    (%ebx),%ecx
  8022d7:	8d 51 20             	lea    0x20(%ecx),%edx
  8022da:	39 d0                	cmp    %edx,%eax
  8022dc:	72 14                	jb     8022f2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022de:	89 da                	mov    %ebx,%edx
  8022e0:	89 f0                	mov    %esi,%eax
  8022e2:	e8 65 ff ff ff       	call   80224c <_pipeisclosed>
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	75 3b                	jne    802326 <devpipe_write+0x75>
			sys_yield();
  8022eb:	e8 76 ea ff ff       	call   800d66 <sys_yield>
  8022f0:	eb e0                	jmp    8022d2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022f9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022fc:	89 c2                	mov    %eax,%edx
  8022fe:	c1 fa 1f             	sar    $0x1f,%edx
  802301:	89 d1                	mov    %edx,%ecx
  802303:	c1 e9 1b             	shr    $0x1b,%ecx
  802306:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802309:	83 e2 1f             	and    $0x1f,%edx
  80230c:	29 ca                	sub    %ecx,%edx
  80230e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802312:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802316:	83 c0 01             	add    $0x1,%eax
  802319:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80231c:	83 c7 01             	add    $0x1,%edi
  80231f:	eb ac                	jmp    8022cd <devpipe_write+0x1c>
	return i;
  802321:	8b 45 10             	mov    0x10(%ebp),%eax
  802324:	eb 05                	jmp    80232b <devpipe_write+0x7a>
				return 0;
  802326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80232e:	5b                   	pop    %ebx
  80232f:	5e                   	pop    %esi
  802330:	5f                   	pop    %edi
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <devpipe_read>:
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	57                   	push   %edi
  802337:	56                   	push   %esi
  802338:	53                   	push   %ebx
  802339:	83 ec 18             	sub    $0x18,%esp
  80233c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80233f:	57                   	push   %edi
  802340:	e8 0c f2 ff ff       	call   801551 <fd2data>
  802345:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	be 00 00 00 00       	mov    $0x0,%esi
  80234f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802352:	75 14                	jne    802368 <devpipe_read+0x35>
	return i;
  802354:	8b 45 10             	mov    0x10(%ebp),%eax
  802357:	eb 02                	jmp    80235b <devpipe_read+0x28>
				return i;
  802359:	89 f0                	mov    %esi,%eax
}
  80235b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5f                   	pop    %edi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    
			sys_yield();
  802363:	e8 fe e9 ff ff       	call   800d66 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802368:	8b 03                	mov    (%ebx),%eax
  80236a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80236d:	75 18                	jne    802387 <devpipe_read+0x54>
			if (i > 0)
  80236f:	85 f6                	test   %esi,%esi
  802371:	75 e6                	jne    802359 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802373:	89 da                	mov    %ebx,%edx
  802375:	89 f8                	mov    %edi,%eax
  802377:	e8 d0 fe ff ff       	call   80224c <_pipeisclosed>
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 e3                	je     802363 <devpipe_read+0x30>
				return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	eb d4                	jmp    80235b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802387:	99                   	cltd   
  802388:	c1 ea 1b             	shr    $0x1b,%edx
  80238b:	01 d0                	add    %edx,%eax
  80238d:	83 e0 1f             	and    $0x1f,%eax
  802390:	29 d0                	sub    %edx,%eax
  802392:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80239d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023a0:	83 c6 01             	add    $0x1,%esi
  8023a3:	eb aa                	jmp    80234f <devpipe_read+0x1c>

008023a5 <pipe>:
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	56                   	push   %esi
  8023a9:	53                   	push   %ebx
  8023aa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b0:	50                   	push   %eax
  8023b1:	e8 b2 f1 ff ff       	call   801568 <fd_alloc>
  8023b6:	89 c3                	mov    %eax,%ebx
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	0f 88 23 01 00 00    	js     8024e6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 07 04 00 00       	push   $0x407
  8023cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ce:	6a 00                	push   $0x0
  8023d0:	e8 b0 e9 ff ff       	call   800d85 <sys_page_alloc>
  8023d5:	89 c3                	mov    %eax,%ebx
  8023d7:	83 c4 10             	add    $0x10,%esp
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	0f 88 04 01 00 00    	js     8024e6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023e2:	83 ec 0c             	sub    $0xc,%esp
  8023e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023e8:	50                   	push   %eax
  8023e9:	e8 7a f1 ff ff       	call   801568 <fd_alloc>
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	83 c4 10             	add    $0x10,%esp
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 88 db 00 00 00    	js     8024d6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023fb:	83 ec 04             	sub    $0x4,%esp
  8023fe:	68 07 04 00 00       	push   $0x407
  802403:	ff 75 f0             	pushl  -0x10(%ebp)
  802406:	6a 00                	push   $0x0
  802408:	e8 78 e9 ff ff       	call   800d85 <sys_page_alloc>
  80240d:	89 c3                	mov    %eax,%ebx
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	85 c0                	test   %eax,%eax
  802414:	0f 88 bc 00 00 00    	js     8024d6 <pipe+0x131>
	va = fd2data(fd0);
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	ff 75 f4             	pushl  -0xc(%ebp)
  802420:	e8 2c f1 ff ff       	call   801551 <fd2data>
  802425:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802427:	83 c4 0c             	add    $0xc,%esp
  80242a:	68 07 04 00 00       	push   $0x407
  80242f:	50                   	push   %eax
  802430:	6a 00                	push   $0x0
  802432:	e8 4e e9 ff ff       	call   800d85 <sys_page_alloc>
  802437:	89 c3                	mov    %eax,%ebx
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	85 c0                	test   %eax,%eax
  80243e:	0f 88 82 00 00 00    	js     8024c6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	ff 75 f0             	pushl  -0x10(%ebp)
  80244a:	e8 02 f1 ff ff       	call   801551 <fd2data>
  80244f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802456:	50                   	push   %eax
  802457:	6a 00                	push   $0x0
  802459:	56                   	push   %esi
  80245a:	6a 00                	push   $0x0
  80245c:	e8 67 e9 ff ff       	call   800dc8 <sys_page_map>
  802461:	89 c3                	mov    %eax,%ebx
  802463:	83 c4 20             	add    $0x20,%esp
  802466:	85 c0                	test   %eax,%eax
  802468:	78 4e                	js     8024b8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80246a:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80246f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802472:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802477:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80247e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802481:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80248d:	83 ec 0c             	sub    $0xc,%esp
  802490:	ff 75 f4             	pushl  -0xc(%ebp)
  802493:	e8 a9 f0 ff ff       	call   801541 <fd2num>
  802498:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80249b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80249d:	83 c4 04             	add    $0x4,%esp
  8024a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024a3:	e8 99 f0 ff ff       	call   801541 <fd2num>
  8024a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024b6:	eb 2e                	jmp    8024e6 <pipe+0x141>
	sys_page_unmap(0, va);
  8024b8:	83 ec 08             	sub    $0x8,%esp
  8024bb:	56                   	push   %esi
  8024bc:	6a 00                	push   $0x0
  8024be:	e8 47 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024c3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024c6:	83 ec 08             	sub    $0x8,%esp
  8024c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8024cc:	6a 00                	push   $0x0
  8024ce:	e8 37 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024d3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024dc:	6a 00                	push   $0x0
  8024de:	e8 27 e9 ff ff       	call   800e0a <sys_page_unmap>
  8024e3:	83 c4 10             	add    $0x10,%esp
}
  8024e6:	89 d8                	mov    %ebx,%eax
  8024e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    

008024ef <pipeisclosed>:
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f8:	50                   	push   %eax
  8024f9:	ff 75 08             	pushl  0x8(%ebp)
  8024fc:	e8 b9 f0 ff ff       	call   8015ba <fd_lookup>
  802501:	83 c4 10             	add    $0x10,%esp
  802504:	85 c0                	test   %eax,%eax
  802506:	78 18                	js     802520 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	ff 75 f4             	pushl  -0xc(%ebp)
  80250e:	e8 3e f0 ff ff       	call   801551 <fd2data>
	return _pipeisclosed(fd, p);
  802513:	89 c2                	mov    %eax,%edx
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	e8 2f fd ff ff       	call   80224c <_pipeisclosed>
  80251d:	83 c4 10             	add    $0x10,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
  802527:	c3                   	ret    

00802528 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80252e:	68 1b 31 80 00       	push   $0x80311b
  802533:	ff 75 0c             	pushl  0xc(%ebp)
  802536:	e8 58 e4 ff ff       	call   800993 <strcpy>
	return 0;
}
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <devcons_write>:
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	57                   	push   %edi
  802546:	56                   	push   %esi
  802547:	53                   	push   %ebx
  802548:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80254e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802553:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802559:	3b 75 10             	cmp    0x10(%ebp),%esi
  80255c:	73 31                	jae    80258f <devcons_write+0x4d>
		m = n - tot;
  80255e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802561:	29 f3                	sub    %esi,%ebx
  802563:	83 fb 7f             	cmp    $0x7f,%ebx
  802566:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80256b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	53                   	push   %ebx
  802572:	89 f0                	mov    %esi,%eax
  802574:	03 45 0c             	add    0xc(%ebp),%eax
  802577:	50                   	push   %eax
  802578:	57                   	push   %edi
  802579:	e8 a3 e5 ff ff       	call   800b21 <memmove>
		sys_cputs(buf, m);
  80257e:	83 c4 08             	add    $0x8,%esp
  802581:	53                   	push   %ebx
  802582:	57                   	push   %edi
  802583:	e8 41 e7 ff ff       	call   800cc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802588:	01 de                	add    %ebx,%esi
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	eb ca                	jmp    802559 <devcons_write+0x17>
}
  80258f:	89 f0                	mov    %esi,%eax
  802591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802594:	5b                   	pop    %ebx
  802595:	5e                   	pop    %esi
  802596:	5f                   	pop    %edi
  802597:	5d                   	pop    %ebp
  802598:	c3                   	ret    

00802599 <devcons_read>:
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 08             	sub    $0x8,%esp
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a8:	74 21                	je     8025cb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025aa:	e8 38 e7 ff ff       	call   800ce7 <sys_cgetc>
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	75 07                	jne    8025ba <devcons_read+0x21>
		sys_yield();
  8025b3:	e8 ae e7 ff ff       	call   800d66 <sys_yield>
  8025b8:	eb f0                	jmp    8025aa <devcons_read+0x11>
	if (c < 0)
  8025ba:	78 0f                	js     8025cb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025bc:	83 f8 04             	cmp    $0x4,%eax
  8025bf:	74 0c                	je     8025cd <devcons_read+0x34>
	*(char*)vbuf = c;
  8025c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c4:	88 02                	mov    %al,(%edx)
	return 1;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    
		return 0;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	eb f7                	jmp    8025cb <devcons_read+0x32>

008025d4 <cputchar>:
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025e0:	6a 01                	push   $0x1
  8025e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e5:	50                   	push   %eax
  8025e6:	e8 de e6 ff ff       	call   800cc9 <sys_cputs>
}
  8025eb:	83 c4 10             	add    $0x10,%esp
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <getchar>:
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025f6:	6a 01                	push   $0x1
  8025f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025fb:	50                   	push   %eax
  8025fc:	6a 00                	push   $0x0
  8025fe:	e8 27 f2 ff ff       	call   80182a <read>
	if (r < 0)
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	85 c0                	test   %eax,%eax
  802608:	78 06                	js     802610 <getchar+0x20>
	if (r < 1)
  80260a:	74 06                	je     802612 <getchar+0x22>
	return c;
  80260c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    
		return -E_EOF;
  802612:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802617:	eb f7                	jmp    802610 <getchar+0x20>

00802619 <iscons>:
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80261f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802622:	50                   	push   %eax
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	e8 8f ef ff ff       	call   8015ba <fd_lookup>
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	85 c0                	test   %eax,%eax
  802630:	78 11                	js     802643 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80263b:	39 10                	cmp    %edx,(%eax)
  80263d:	0f 94 c0             	sete   %al
  802640:	0f b6 c0             	movzbl %al,%eax
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <opencons>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80264b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264e:	50                   	push   %eax
  80264f:	e8 14 ef ff ff       	call   801568 <fd_alloc>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 3a                	js     802695 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 07 04 00 00       	push   $0x407
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	6a 00                	push   $0x0
  802668:	e8 18 e7 ff ff       	call   800d85 <sys_page_alloc>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	85 c0                	test   %eax,%eax
  802672:	78 21                	js     802695 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80267d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	50                   	push   %eax
  80268d:	e8 af ee ff ff       	call   801541 <fd2num>
  802692:	83 c4 10             	add    $0x10,%esp
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	56                   	push   %esi
  80269b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80269c:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a1:	8b 40 48             	mov    0x48(%eax),%eax
  8026a4:	83 ec 04             	sub    $0x4,%esp
  8026a7:	68 58 31 80 00       	push   $0x803158
  8026ac:	50                   	push   %eax
  8026ad:	68 27 31 80 00       	push   $0x803127
  8026b2:	e8 7d db ff ff       	call   800234 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8026b7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026ba:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026c0:	e8 82 e6 ff ff       	call   800d47 <sys_getenvid>
  8026c5:	83 c4 04             	add    $0x4,%esp
  8026c8:	ff 75 0c             	pushl  0xc(%ebp)
  8026cb:	ff 75 08             	pushl  0x8(%ebp)
  8026ce:	56                   	push   %esi
  8026cf:	50                   	push   %eax
  8026d0:	68 34 31 80 00       	push   $0x803134
  8026d5:	e8 5a db ff ff       	call   800234 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026da:	83 c4 18             	add    $0x18,%esp
  8026dd:	53                   	push   %ebx
  8026de:	ff 75 10             	pushl  0x10(%ebp)
  8026e1:	e8 fd da ff ff       	call   8001e3 <vcprintf>
	cprintf("\n");
  8026e6:	c7 04 24 4e 2b 80 00 	movl   $0x802b4e,(%esp)
  8026ed:	e8 42 db ff ff       	call   800234 <cprintf>
  8026f2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026f5:	cc                   	int3   
  8026f6:	eb fd                	jmp    8026f5 <_panic+0x5e>

008026f8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026fe:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802705:	74 0a                	je     802711 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	6a 07                	push   $0x7
  802716:	68 00 f0 bf ee       	push   $0xeebff000
  80271b:	6a 00                	push   $0x0
  80271d:	e8 63 e6 ff ff       	call   800d85 <sys_page_alloc>
		if(r < 0)
  802722:	83 c4 10             	add    $0x10,%esp
  802725:	85 c0                	test   %eax,%eax
  802727:	78 2a                	js     802753 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802729:	83 ec 08             	sub    $0x8,%esp
  80272c:	68 67 27 80 00       	push   $0x802767
  802731:	6a 00                	push   $0x0
  802733:	e8 98 e7 ff ff       	call   800ed0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	79 c8                	jns    802707 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	68 90 31 80 00       	push   $0x803190
  802747:	6a 25                	push   $0x25
  802749:	68 cc 31 80 00       	push   $0x8031cc
  80274e:	e8 44 ff ff ff       	call   802697 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	68 60 31 80 00       	push   $0x803160
  80275b:	6a 22                	push   $0x22
  80275d:	68 cc 31 80 00       	push   $0x8031cc
  802762:	e8 30 ff ff ff       	call   802697 <_panic>

00802767 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802767:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802768:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80276d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80276f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802772:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802776:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80277a:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80277d:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80277f:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802783:	83 c4 08             	add    $0x8,%esp
	popal
  802786:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802787:	83 c4 04             	add    $0x4,%esp
	popfl
  80278a:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80278b:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80278c:	c3                   	ret    

0080278d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	56                   	push   %esi
  802791:	53                   	push   %ebx
  802792:	8b 75 08             	mov    0x8(%ebp),%esi
  802795:	8b 45 0c             	mov    0xc(%ebp),%eax
  802798:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80279b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80279d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027a2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027a5:	83 ec 0c             	sub    $0xc,%esp
  8027a8:	50                   	push   %eax
  8027a9:	e8 87 e7 ff ff       	call   800f35 <sys_ipc_recv>
	if(ret < 0){
  8027ae:	83 c4 10             	add    $0x10,%esp
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	78 2b                	js     8027e0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027b5:	85 f6                	test   %esi,%esi
  8027b7:	74 0a                	je     8027c3 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027b9:	a1 08 50 80 00       	mov    0x805008,%eax
  8027be:	8b 40 74             	mov    0x74(%eax),%eax
  8027c1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027c3:	85 db                	test   %ebx,%ebx
  8027c5:	74 0a                	je     8027d1 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8027cc:	8b 40 78             	mov    0x78(%eax),%eax
  8027cf:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8027d6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    
		if(from_env_store)
  8027e0:	85 f6                	test   %esi,%esi
  8027e2:	74 06                	je     8027ea <ipc_recv+0x5d>
			*from_env_store = 0;
  8027e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027ea:	85 db                	test   %ebx,%ebx
  8027ec:	74 eb                	je     8027d9 <ipc_recv+0x4c>
			*perm_store = 0;
  8027ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027f4:	eb e3                	jmp    8027d9 <ipc_recv+0x4c>

008027f6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	57                   	push   %edi
  8027fa:	56                   	push   %esi
  8027fb:	53                   	push   %ebx
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802802:	8b 75 0c             	mov    0xc(%ebp),%esi
  802805:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802808:	85 db                	test   %ebx,%ebx
  80280a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80280f:	0f 44 d8             	cmove  %eax,%ebx
  802812:	eb 05                	jmp    802819 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802814:	e8 4d e5 ff ff       	call   800d66 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802819:	ff 75 14             	pushl  0x14(%ebp)
  80281c:	53                   	push   %ebx
  80281d:	56                   	push   %esi
  80281e:	57                   	push   %edi
  80281f:	e8 ee e6 ff ff       	call   800f12 <sys_ipc_try_send>
  802824:	83 c4 10             	add    $0x10,%esp
  802827:	85 c0                	test   %eax,%eax
  802829:	74 1b                	je     802846 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80282b:	79 e7                	jns    802814 <ipc_send+0x1e>
  80282d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802830:	74 e2                	je     802814 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	68 da 31 80 00       	push   $0x8031da
  80283a:	6a 48                	push   $0x48
  80283c:	68 ef 31 80 00       	push   $0x8031ef
  802841:	e8 51 fe ff ff       	call   802697 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802846:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802849:	5b                   	pop    %ebx
  80284a:	5e                   	pop    %esi
  80284b:	5f                   	pop    %edi
  80284c:	5d                   	pop    %ebp
  80284d:	c3                   	ret    

0080284e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802859:	89 c2                	mov    %eax,%edx
  80285b:	c1 e2 07             	shl    $0x7,%edx
  80285e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802864:	8b 52 50             	mov    0x50(%edx),%edx
  802867:	39 ca                	cmp    %ecx,%edx
  802869:	74 11                	je     80287c <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80286b:	83 c0 01             	add    $0x1,%eax
  80286e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802873:	75 e4                	jne    802859 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802875:	b8 00 00 00 00       	mov    $0x0,%eax
  80287a:	eb 0b                	jmp    802887 <ipc_find_env+0x39>
			return envs[i].env_id;
  80287c:	c1 e0 07             	shl    $0x7,%eax
  80287f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802884:	8b 40 48             	mov    0x48(%eax),%eax
}
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    

00802889 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80288f:	89 d0                	mov    %edx,%eax
  802891:	c1 e8 16             	shr    $0x16,%eax
  802894:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80289b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028a0:	f6 c1 01             	test   $0x1,%cl
  8028a3:	74 1d                	je     8028c2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028a5:	c1 ea 0c             	shr    $0xc,%edx
  8028a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028af:	f6 c2 01             	test   $0x1,%dl
  8028b2:	74 0e                	je     8028c2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028b4:	c1 ea 0c             	shr    $0xc,%edx
  8028b7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028be:	ef 
  8028bf:	0f b7 c0             	movzwl %ax,%eax
}
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    
  8028c4:	66 90                	xchg   %ax,%ax
  8028c6:	66 90                	xchg   %ax,%ax
  8028c8:	66 90                	xchg   %ax,%ax
  8028ca:	66 90                	xchg   %ax,%ax
  8028cc:	66 90                	xchg   %ax,%ax
  8028ce:	66 90                	xchg   %ax,%ax

008028d0 <__udivdi3>:
  8028d0:	55                   	push   %ebp
  8028d1:	57                   	push   %edi
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	83 ec 1c             	sub    $0x1c,%esp
  8028d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028e7:	85 d2                	test   %edx,%edx
  8028e9:	75 4d                	jne    802938 <__udivdi3+0x68>
  8028eb:	39 f3                	cmp    %esi,%ebx
  8028ed:	76 19                	jbe    802908 <__udivdi3+0x38>
  8028ef:	31 ff                	xor    %edi,%edi
  8028f1:	89 e8                	mov    %ebp,%eax
  8028f3:	89 f2                	mov    %esi,%edx
  8028f5:	f7 f3                	div    %ebx
  8028f7:	89 fa                	mov    %edi,%edx
  8028f9:	83 c4 1c             	add    $0x1c,%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5f                   	pop    %edi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
  802901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802908:	89 d9                	mov    %ebx,%ecx
  80290a:	85 db                	test   %ebx,%ebx
  80290c:	75 0b                	jne    802919 <__udivdi3+0x49>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 c1                	mov    %eax,%ecx
  802919:	31 d2                	xor    %edx,%edx
  80291b:	89 f0                	mov    %esi,%eax
  80291d:	f7 f1                	div    %ecx
  80291f:	89 c6                	mov    %eax,%esi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f7                	mov    %esi,%edi
  802925:	f7 f1                	div    %ecx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	39 f2                	cmp    %esi,%edx
  80293a:	77 1c                	ja     802958 <__udivdi3+0x88>
  80293c:	0f bd fa             	bsr    %edx,%edi
  80293f:	83 f7 1f             	xor    $0x1f,%edi
  802942:	75 2c                	jne    802970 <__udivdi3+0xa0>
  802944:	39 f2                	cmp    %esi,%edx
  802946:	72 06                	jb     80294e <__udivdi3+0x7e>
  802948:	31 c0                	xor    %eax,%eax
  80294a:	39 eb                	cmp    %ebp,%ebx
  80294c:	77 a9                	ja     8028f7 <__udivdi3+0x27>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	eb a2                	jmp    8028f7 <__udivdi3+0x27>
  802955:	8d 76 00             	lea    0x0(%esi),%esi
  802958:	31 ff                	xor    %edi,%edi
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	89 fa                	mov    %edi,%edx
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	89 f9                	mov    %edi,%ecx
  802972:	b8 20 00 00 00       	mov    $0x20,%eax
  802977:	29 f8                	sub    %edi,%eax
  802979:	d3 e2                	shl    %cl,%edx
  80297b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80297f:	89 c1                	mov    %eax,%ecx
  802981:	89 da                	mov    %ebx,%edx
  802983:	d3 ea                	shr    %cl,%edx
  802985:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802989:	09 d1                	or     %edx,%ecx
  80298b:	89 f2                	mov    %esi,%edx
  80298d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802991:	89 f9                	mov    %edi,%ecx
  802993:	d3 e3                	shl    %cl,%ebx
  802995:	89 c1                	mov    %eax,%ecx
  802997:	d3 ea                	shr    %cl,%edx
  802999:	89 f9                	mov    %edi,%ecx
  80299b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80299f:	89 eb                	mov    %ebp,%ebx
  8029a1:	d3 e6                	shl    %cl,%esi
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	d3 eb                	shr    %cl,%ebx
  8029a7:	09 de                	or     %ebx,%esi
  8029a9:	89 f0                	mov    %esi,%eax
  8029ab:	f7 74 24 08          	divl   0x8(%esp)
  8029af:	89 d6                	mov    %edx,%esi
  8029b1:	89 c3                	mov    %eax,%ebx
  8029b3:	f7 64 24 0c          	mull   0xc(%esp)
  8029b7:	39 d6                	cmp    %edx,%esi
  8029b9:	72 15                	jb     8029d0 <__udivdi3+0x100>
  8029bb:	89 f9                	mov    %edi,%ecx
  8029bd:	d3 e5                	shl    %cl,%ebp
  8029bf:	39 c5                	cmp    %eax,%ebp
  8029c1:	73 04                	jae    8029c7 <__udivdi3+0xf7>
  8029c3:	39 d6                	cmp    %edx,%esi
  8029c5:	74 09                	je     8029d0 <__udivdi3+0x100>
  8029c7:	89 d8                	mov    %ebx,%eax
  8029c9:	31 ff                	xor    %edi,%edi
  8029cb:	e9 27 ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029d3:	31 ff                	xor    %edi,%edi
  8029d5:	e9 1d ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__umoddi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	83 ec 1c             	sub    $0x1c,%esp
  8029e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029f7:	89 da                	mov    %ebx,%edx
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	75 43                	jne    802a40 <__umoddi3+0x60>
  8029fd:	39 df                	cmp    %ebx,%edi
  8029ff:	76 17                	jbe    802a18 <__umoddi3+0x38>
  802a01:	89 f0                	mov    %esi,%eax
  802a03:	f7 f7                	div    %edi
  802a05:	89 d0                	mov    %edx,%eax
  802a07:	31 d2                	xor    %edx,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 fd                	mov    %edi,%ebp
  802a1a:	85 ff                	test   %edi,%edi
  802a1c:	75 0b                	jne    802a29 <__umoddi3+0x49>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f7                	div    %edi
  802a27:	89 c5                	mov    %eax,%ebp
  802a29:	89 d8                	mov    %ebx,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	f7 f5                	div    %ebp
  802a2f:	89 f0                	mov    %esi,%eax
  802a31:	f7 f5                	div    %ebp
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	eb d0                	jmp    802a07 <__umoddi3+0x27>
  802a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3e:	66 90                	xchg   %ax,%ax
  802a40:	89 f1                	mov    %esi,%ecx
  802a42:	39 d8                	cmp    %ebx,%eax
  802a44:	76 0a                	jbe    802a50 <__umoddi3+0x70>
  802a46:	89 f0                	mov    %esi,%eax
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	0f bd e8             	bsr    %eax,%ebp
  802a53:	83 f5 1f             	xor    $0x1f,%ebp
  802a56:	75 20                	jne    802a78 <__umoddi3+0x98>
  802a58:	39 d8                	cmp    %ebx,%eax
  802a5a:	0f 82 b0 00 00 00    	jb     802b10 <__umoddi3+0x130>
  802a60:	39 f7                	cmp    %esi,%edi
  802a62:	0f 86 a8 00 00 00    	jbe    802b10 <__umoddi3+0x130>
  802a68:	89 c8                	mov    %ecx,%eax
  802a6a:	83 c4 1c             	add    $0x1c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    
  802a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a7f:	29 ea                	sub    %ebp,%edx
  802a81:	d3 e0                	shl    %cl,%eax
  802a83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a87:	89 d1                	mov    %edx,%ecx
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	d3 e8                	shr    %cl,%eax
  802a8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a99:	09 c1                	or     %eax,%ecx
  802a9b:	89 d8                	mov    %ebx,%eax
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 e9                	mov    %ebp,%ecx
  802aa3:	d3 e7                	shl    %cl,%edi
  802aa5:	89 d1                	mov    %edx,%ecx
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aaf:	d3 e3                	shl    %cl,%ebx
  802ab1:	89 c7                	mov    %eax,%edi
  802ab3:	89 d1                	mov    %edx,%ecx
  802ab5:	89 f0                	mov    %esi,%eax
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 fa                	mov    %edi,%edx
  802abd:	d3 e6                	shl    %cl,%esi
  802abf:	09 d8                	or     %ebx,%eax
  802ac1:	f7 74 24 08          	divl   0x8(%esp)
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	89 f3                	mov    %esi,%ebx
  802ac9:	f7 64 24 0c          	mull   0xc(%esp)
  802acd:	89 c6                	mov    %eax,%esi
  802acf:	89 d7                	mov    %edx,%edi
  802ad1:	39 d1                	cmp    %edx,%ecx
  802ad3:	72 06                	jb     802adb <__umoddi3+0xfb>
  802ad5:	75 10                	jne    802ae7 <__umoddi3+0x107>
  802ad7:	39 c3                	cmp    %eax,%ebx
  802ad9:	73 0c                	jae    802ae7 <__umoddi3+0x107>
  802adb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802adf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ae3:	89 d7                	mov    %edx,%edi
  802ae5:	89 c6                	mov    %eax,%esi
  802ae7:	89 ca                	mov    %ecx,%edx
  802ae9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aee:	29 f3                	sub    %esi,%ebx
  802af0:	19 fa                	sbb    %edi,%edx
  802af2:	89 d0                	mov    %edx,%eax
  802af4:	d3 e0                	shl    %cl,%eax
  802af6:	89 e9                	mov    %ebp,%ecx
  802af8:	d3 eb                	shr    %cl,%ebx
  802afa:	d3 ea                	shr    %cl,%edx
  802afc:	09 d8                	or     %ebx,%eax
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 da                	mov    %ebx,%edx
  802b12:	29 fe                	sub    %edi,%esi
  802b14:	19 c2                	sbb    %eax,%edx
  802b16:	89 f1                	mov    %esi,%ecx
  802b18:	89 c8                	mov    %ecx,%eax
  802b1a:	e9 4b ff ff ff       	jmp    802a6a <__umoddi3+0x8a>
