
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
  80003d:	e8 58 0d 00 00       	call   800d9a <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 a0 2b 80 00       	push   $0x802ba0
  80004c:	e8 36 02 00 00       	call   800287 <cprintf>

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
  80007e:	e8 2a 09 00 00       	call   8009ad <strlen>
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
  80009c:	68 b1 2b 80 00       	push   $0x802bb1
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 e7 08 00 00       	call   800993 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 98 13 00 00       	call   80144c <sfork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 f5 00 00 00       	call   8001be <exit>
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
  8000d4:	68 d3 2b 80 00       	push   $0x802bd3
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
  8000f6:	e8 9f 0c 00 00       	call   800d9a <sys_getenvid>
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
  80011b:	74 23                	je     800140 <libmain+0x5d>
		if(envs[i].env_id == find)
  80011d:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800123:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800129:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012c:	39 c1                	cmp    %eax,%ecx
  80012e:	75 e2                	jne    800112 <libmain+0x2f>
  800130:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800136:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013c:	89 fe                	mov    %edi,%esi
  80013e:	eb d2                	jmp    800112 <libmain+0x2f>
  800140:	89 f0                	mov    %esi,%eax
  800142:	84 c0                	test   %al,%al
  800144:	74 06                	je     80014c <libmain+0x69>
  800146:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800150:	7e 0a                	jle    80015c <libmain+0x79>
		binaryname = argv[0];
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	8b 00                	mov    (%eax),%eax
  800157:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015c:	a1 08 50 80 00       	mov    0x805008,%eax
  800161:	8b 40 48             	mov    0x48(%eax),%eax
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	50                   	push   %eax
  800168:	68 b6 2b 80 00       	push   $0x802bb6
  80016d:	e8 15 01 00 00       	call   800287 <cprintf>
	cprintf("before umain\n");
  800172:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  800179:	e8 09 01 00 00       	call   800287 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	e8 42 ff ff ff       	call   8000ce <umain>
	cprintf("after umain\n");
  80018c:	c7 04 24 e2 2b 80 00 	movl   $0x802be2,(%esp)
  800193:	e8 ef 00 00 00       	call   800287 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800198:	a1 08 50 80 00       	mov    0x805008,%eax
  80019d:	8b 40 48             	mov    0x48(%eax),%eax
  8001a0:	83 c4 08             	add    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 ef 2b 80 00       	push   $0x802bef
  8001a9:	e8 d9 00 00 00       	call   800287 <cprintf>
	// exit gracefully
	exit();
  8001ae:	e8 0b 00 00 00       	call   8001be <exit>
}
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b9:	5b                   	pop    %ebx
  8001ba:	5e                   	pop    %esi
  8001bb:	5f                   	pop    %edi
  8001bc:	5d                   	pop    %ebp
  8001bd:	c3                   	ret    

008001be <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c4:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	68 1c 2c 80 00       	push   $0x802c1c
  8001d1:	50                   	push   %eax
  8001d2:	68 0e 2c 80 00       	push   $0x802c0e
  8001d7:	e8 ab 00 00 00       	call   800287 <cprintf>
	close_all();
  8001dc:	e8 b1 15 00 00       	call   801792 <close_all>
	sys_env_destroy(0);
  8001e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e8:	e8 6c 0b 00 00       	call   800d59 <sys_env_destroy>
}
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001fc:	8b 13                	mov    (%ebx),%edx
  8001fe:	8d 42 01             	lea    0x1(%edx),%eax
  800201:	89 03                	mov    %eax,(%ebx)
  800203:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800206:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80020a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020f:	74 09                	je     80021a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800211:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800218:	c9                   	leave  
  800219:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021a:	83 ec 08             	sub    $0x8,%esp
  80021d:	68 ff 00 00 00       	push   $0xff
  800222:	8d 43 08             	lea    0x8(%ebx),%eax
  800225:	50                   	push   %eax
  800226:	e8 f1 0a 00 00       	call   800d1c <sys_cputs>
		b->idx = 0;
  80022b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	eb db                	jmp    800211 <putch+0x1f>

00800236 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	68 f2 01 80 00       	push   $0x8001f2
  800265:	e8 4a 01 00 00       	call   8003b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026a:	83 c4 08             	add    $0x8,%esp
  80026d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800273:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	e8 9d 0a 00 00       	call   800d1c <sys_cputs>

	return b.cnt;
}
  80027f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800290:	50                   	push   %eax
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	e8 9d ff ff ff       	call   800236 <vcprintf>
	va_end(ap);

	return cnt;
}
  800299:	c9                   	leave  
  80029a:	c3                   	ret    

0080029b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	57                   	push   %edi
  80029f:	56                   	push   %esi
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 1c             	sub    $0x1c,%esp
  8002a4:	89 c6                	mov    %eax,%esi
  8002a6:	89 d7                	mov    %edx,%edi
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002ba:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002be:	74 2c                	je     8002ec <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002d0:	39 c2                	cmp    %eax,%edx
  8002d2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d5:	73 43                	jae    80031a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d7:	83 eb 01             	sub    $0x1,%ebx
  8002da:	85 db                	test   %ebx,%ebx
  8002dc:	7e 6c                	jle    80034a <printnum+0xaf>
				putch(padc, putdat);
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	57                   	push   %edi
  8002e2:	ff 75 18             	pushl  0x18(%ebp)
  8002e5:	ff d6                	call   *%esi
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb eb                	jmp    8002d7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002ec:	83 ec 0c             	sub    $0xc,%esp
  8002ef:	6a 20                	push   $0x20
  8002f1:	6a 00                	push   $0x0
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fa:	89 fa                	mov    %edi,%edx
  8002fc:	89 f0                	mov    %esi,%eax
  8002fe:	e8 98 ff ff ff       	call   80029b <printnum>
		while (--width > 0)
  800303:	83 c4 20             	add    $0x20,%esp
  800306:	83 eb 01             	sub    $0x1,%ebx
  800309:	85 db                	test   %ebx,%ebx
  80030b:	7e 65                	jle    800372 <printnum+0xd7>
			putch(padc, putdat);
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	57                   	push   %edi
  800311:	6a 20                	push   $0x20
  800313:	ff d6                	call   *%esi
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	eb ec                	jmp    800306 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80031a:	83 ec 0c             	sub    $0xc,%esp
  80031d:	ff 75 18             	pushl  0x18(%ebp)
  800320:	83 eb 01             	sub    $0x1,%ebx
  800323:	53                   	push   %ebx
  800324:	50                   	push   %eax
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 dc             	pushl  -0x24(%ebp)
  80032b:	ff 75 d8             	pushl  -0x28(%ebp)
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	ff 75 e0             	pushl  -0x20(%ebp)
  800334:	e8 17 26 00 00       	call   802950 <__udivdi3>
  800339:	83 c4 18             	add    $0x18,%esp
  80033c:	52                   	push   %edx
  80033d:	50                   	push   %eax
  80033e:	89 fa                	mov    %edi,%edx
  800340:	89 f0                	mov    %esi,%eax
  800342:	e8 54 ff ff ff       	call   80029b <printnum>
  800347:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	57                   	push   %edi
  80034e:	83 ec 04             	sub    $0x4,%esp
  800351:	ff 75 dc             	pushl  -0x24(%ebp)
  800354:	ff 75 d8             	pushl  -0x28(%ebp)
  800357:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035a:	ff 75 e0             	pushl  -0x20(%ebp)
  80035d:	e8 fe 26 00 00       	call   802a60 <__umoddi3>
  800362:	83 c4 14             	add    $0x14,%esp
  800365:	0f be 80 21 2c 80 00 	movsbl 0x802c21(%eax),%eax
  80036c:	50                   	push   %eax
  80036d:	ff d6                	call   *%esi
  80036f:	83 c4 10             	add    $0x10,%esp
	}
}
  800372:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800375:	5b                   	pop    %ebx
  800376:	5e                   	pop    %esi
  800377:	5f                   	pop    %edi
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800380:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800384:	8b 10                	mov    (%eax),%edx
  800386:	3b 50 04             	cmp    0x4(%eax),%edx
  800389:	73 0a                	jae    800395 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	88 02                	mov    %al,(%edx)
}
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    

00800397 <printfmt>:
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a0:	50                   	push   %eax
  8003a1:	ff 75 10             	pushl  0x10(%ebp)
  8003a4:	ff 75 0c             	pushl  0xc(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 05 00 00 00       	call   8003b4 <vprintfmt>
}
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <vprintfmt>:
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c6:	e9 32 04 00 00       	jmp    8007fd <vprintfmt+0x449>
		padc = ' ';
  8003cb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003cf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003eb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8d 47 01             	lea    0x1(%edi),%eax
  8003fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fd:	0f b6 17             	movzbl (%edi),%edx
  800400:	8d 42 dd             	lea    -0x23(%edx),%eax
  800403:	3c 55                	cmp    $0x55,%al
  800405:	0f 87 12 05 00 00    	ja     80091d <vprintfmt+0x569>
  80040b:	0f b6 c0             	movzbl %al,%eax
  80040e:	ff 24 85 00 2e 80 00 	jmp    *0x802e00(,%eax,4)
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800418:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041c:	eb d9                	jmp    8003f7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800421:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800425:	eb d0                	jmp    8003f7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800427:	0f b6 d2             	movzbl %dl,%edx
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80042d:	b8 00 00 00 00       	mov    $0x0,%eax
  800432:	89 75 08             	mov    %esi,0x8(%ebp)
  800435:	eb 03                	jmp    80043a <vprintfmt+0x86>
  800437:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800441:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800444:	8d 72 d0             	lea    -0x30(%edx),%esi
  800447:	83 fe 09             	cmp    $0x9,%esi
  80044a:	76 eb                	jbe    800437 <vprintfmt+0x83>
  80044c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044f:	8b 75 08             	mov    0x8(%ebp),%esi
  800452:	eb 14                	jmp    800468 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	8d 40 04             	lea    0x4(%eax),%eax
  800462:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800468:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046c:	79 89                	jns    8003f7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80046e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800471:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800474:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047b:	e9 77 ff ff ff       	jmp    8003f7 <vprintfmt+0x43>
  800480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800483:	85 c0                	test   %eax,%eax
  800485:	0f 48 c1             	cmovs  %ecx,%eax
  800488:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048e:	e9 64 ff ff ff       	jmp    8003f7 <vprintfmt+0x43>
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800496:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049d:	e9 55 ff ff ff       	jmp    8003f7 <vprintfmt+0x43>
			lflag++;
  8004a2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a9:	e9 49 ff ff ff       	jmp    8003f7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b1:	8d 78 04             	lea    0x4(%eax),%edi
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	53                   	push   %ebx
  8004b8:	ff 30                	pushl  (%eax)
  8004ba:	ff d6                	call   *%esi
			break;
  8004bc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004bf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c2:	e9 33 03 00 00       	jmp    8007fa <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 78 04             	lea    0x4(%eax),%edi
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	99                   	cltd   
  8004d0:	31 d0                	xor    %edx,%eax
  8004d2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d4:	83 f8 11             	cmp    $0x11,%eax
  8004d7:	7f 23                	jg     8004fc <vprintfmt+0x148>
  8004d9:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  8004e0:	85 d2                	test   %edx,%edx
  8004e2:	74 18                	je     8004fc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e4:	52                   	push   %edx
  8004e5:	68 6d 31 80 00       	push   $0x80316d
  8004ea:	53                   	push   %ebx
  8004eb:	56                   	push   %esi
  8004ec:	e8 a6 fe ff ff       	call   800397 <printfmt>
  8004f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f7:	e9 fe 02 00 00       	jmp    8007fa <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fc:	50                   	push   %eax
  8004fd:	68 39 2c 80 00       	push   $0x802c39
  800502:	53                   	push   %ebx
  800503:	56                   	push   %esi
  800504:	e8 8e fe ff ff       	call   800397 <printfmt>
  800509:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80050f:	e9 e6 02 00 00       	jmp    8007fa <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	83 c0 04             	add    $0x4,%eax
  80051a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800522:	85 c9                	test   %ecx,%ecx
  800524:	b8 32 2c 80 00       	mov    $0x802c32,%eax
  800529:	0f 45 c1             	cmovne %ecx,%eax
  80052c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80052f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800533:	7e 06                	jle    80053b <vprintfmt+0x187>
  800535:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800539:	75 0d                	jne    800548 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053e:	89 c7                	mov    %eax,%edi
  800540:	03 45 e0             	add    -0x20(%ebp),%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800546:	eb 53                	jmp    80059b <vprintfmt+0x1e7>
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	ff 75 d8             	pushl  -0x28(%ebp)
  80054e:	50                   	push   %eax
  80054f:	e8 71 04 00 00       	call   8009c5 <strnlen>
  800554:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800557:	29 c1                	sub    %eax,%ecx
  800559:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800561:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800565:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800568:	eb 0f                	jmp    800579 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	53                   	push   %ebx
  80056e:	ff 75 e0             	pushl  -0x20(%ebp)
  800571:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800573:	83 ef 01             	sub    $0x1,%edi
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	85 ff                	test   %edi,%edi
  80057b:	7f ed                	jg     80056a <vprintfmt+0x1b6>
  80057d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800580:	85 c9                	test   %ecx,%ecx
  800582:	b8 00 00 00 00       	mov    $0x0,%eax
  800587:	0f 49 c1             	cmovns %ecx,%eax
  80058a:	29 c1                	sub    %eax,%ecx
  80058c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80058f:	eb aa                	jmp    80053b <vprintfmt+0x187>
					putch(ch, putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	52                   	push   %edx
  800596:	ff d6                	call   *%esi
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a0:	83 c7 01             	add    $0x1,%edi
  8005a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a7:	0f be d0             	movsbl %al,%edx
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	74 4b                	je     8005f9 <vprintfmt+0x245>
  8005ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b2:	78 06                	js     8005ba <vprintfmt+0x206>
  8005b4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b8:	78 1e                	js     8005d8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005be:	74 d1                	je     800591 <vprintfmt+0x1dd>
  8005c0:	0f be c0             	movsbl %al,%eax
  8005c3:	83 e8 20             	sub    $0x20,%eax
  8005c6:	83 f8 5e             	cmp    $0x5e,%eax
  8005c9:	76 c6                	jbe    800591 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	53                   	push   %ebx
  8005cf:	6a 3f                	push   $0x3f
  8005d1:	ff d6                	call   *%esi
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	eb c3                	jmp    80059b <vprintfmt+0x1e7>
  8005d8:	89 cf                	mov    %ecx,%edi
  8005da:	eb 0e                	jmp    8005ea <vprintfmt+0x236>
				putch(' ', putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	6a 20                	push   $0x20
  8005e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e4:	83 ef 01             	sub    $0x1,%edi
  8005e7:	83 c4 10             	add    $0x10,%esp
  8005ea:	85 ff                	test   %edi,%edi
  8005ec:	7f ee                	jg     8005dc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f4:	e9 01 02 00 00       	jmp    8007fa <vprintfmt+0x446>
  8005f9:	89 cf                	mov    %ecx,%edi
  8005fb:	eb ed                	jmp    8005ea <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800600:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800607:	e9 eb fd ff ff       	jmp    8003f7 <vprintfmt+0x43>
	if (lflag >= 2)
  80060c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800610:	7f 21                	jg     800633 <vprintfmt+0x27f>
	else if (lflag)
  800612:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800616:	74 68                	je     800680 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800620:	89 c1                	mov    %eax,%ecx
  800622:	c1 f9 1f             	sar    $0x1f,%ecx
  800625:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	eb 17                	jmp    80064a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 50 04             	mov    0x4(%eax),%edx
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 08             	lea    0x8(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80064a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800656:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80065a:	78 3f                	js     80069b <vprintfmt+0x2e7>
			base = 10;
  80065c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800661:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800665:	0f 84 71 01 00 00    	je     8007dc <vprintfmt+0x428>
				putch('+', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 2b                	push   $0x2b
  800671:	ff d6                	call   *%esi
  800673:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800676:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067b:	e9 5c 01 00 00       	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800688:	89 c1                	mov    %eax,%ecx
  80068a:	c1 f9 1f             	sar    $0x1f,%ecx
  80068d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 40 04             	lea    0x4(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
  800699:	eb af                	jmp    80064a <vprintfmt+0x296>
				putch('-', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 2d                	push   $0x2d
  8006a1:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a9:	f7 d8                	neg    %eax
  8006ab:	83 d2 00             	adc    $0x0,%edx
  8006ae:	f7 da                	neg    %edx
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006be:	e9 19 01 00 00       	jmp    8007dc <vprintfmt+0x428>
	if (lflag >= 2)
  8006c3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c7:	7f 29                	jg     8006f2 <vprintfmt+0x33e>
	else if (lflag)
  8006c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cd:	74 44                	je     800713 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ed:	e9 ea 00 00 00       	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800709:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070e:	e9 c9 00 00 00       	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800731:	e9 a6 00 00 00       	jmp    8007dc <vprintfmt+0x428>
			putch('0', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	53                   	push   %ebx
  80073a:	6a 30                	push   $0x30
  80073c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800745:	7f 26                	jg     80076d <vprintfmt+0x3b9>
	else if (lflag)
  800747:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074b:	74 3e                	je     80078b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 04             	lea    0x4(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
  80076b:	eb 6f                	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 50 04             	mov    0x4(%eax),%edx
  800773:	8b 00                	mov    (%eax),%eax
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 08             	lea    0x8(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800784:	b8 08 00 00 00       	mov    $0x8,%eax
  800789:	eb 51                	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8d 40 04             	lea    0x4(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a9:	eb 31                	jmp    8007dc <vprintfmt+0x428>
			putch('0', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	6a 30                	push   $0x30
  8007b1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b3:	83 c4 08             	add    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 78                	push   $0x78
  8007b9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007cb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007dc:	83 ec 0c             	sub    $0xc,%esp
  8007df:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007e3:	52                   	push   %edx
  8007e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ee:	89 da                	mov    %ebx,%edx
  8007f0:	89 f0                	mov    %esi,%eax
  8007f2:	e8 a4 fa ff ff       	call   80029b <printnum>
			break;
  8007f7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fd:	83 c7 01             	add    $0x1,%edi
  800800:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800804:	83 f8 25             	cmp    $0x25,%eax
  800807:	0f 84 be fb ff ff    	je     8003cb <vprintfmt+0x17>
			if (ch == '\0')
  80080d:	85 c0                	test   %eax,%eax
  80080f:	0f 84 28 01 00 00    	je     80093d <vprintfmt+0x589>
			putch(ch, putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	50                   	push   %eax
  80081a:	ff d6                	call   *%esi
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	eb dc                	jmp    8007fd <vprintfmt+0x449>
	if (lflag >= 2)
  800821:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800825:	7f 26                	jg     80084d <vprintfmt+0x499>
	else if (lflag)
  800827:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082b:	74 41                	je     80086e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800846:	b8 10 00 00 00       	mov    $0x10,%eax
  80084b:	eb 8f                	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 50 04             	mov    0x4(%eax),%edx
  800853:	8b 00                	mov    (%eax),%eax
  800855:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800858:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8d 40 08             	lea    0x8(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800864:	b8 10 00 00 00       	mov    $0x10,%eax
  800869:	e9 6e ff ff ff       	jmp    8007dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	ba 00 00 00 00       	mov    $0x0,%edx
  800878:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 40 04             	lea    0x4(%eax),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800887:	b8 10 00 00 00       	mov    $0x10,%eax
  80088c:	e9 4b ff ff ff       	jmp    8007dc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 14                	je     8008b7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008a3:	8b 13                	mov    (%ebx),%edx
  8008a5:	83 fa 7f             	cmp    $0x7f,%edx
  8008a8:	7f 37                	jg     8008e1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008aa:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b2:	e9 43 ff ff ff       	jmp    8007fa <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bc:	bf 55 2d 80 00       	mov    $0x802d55,%edi
							putch(ch, putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	53                   	push   %ebx
  8008c5:	50                   	push   %eax
  8008c6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c8:	83 c7 01             	add    $0x1,%edi
  8008cb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	85 c0                	test   %eax,%eax
  8008d4:	75 eb                	jne    8008c1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	e9 19 ff ff ff       	jmp    8007fa <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008e1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e8:	bf 8d 2d 80 00       	mov    $0x802d8d,%edi
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
  800900:	75 eb                	jne    8008ed <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800902:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
  800908:	e9 ed fe ff ff       	jmp    8007fa <vprintfmt+0x446>
			putch(ch, putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	6a 25                	push   $0x25
  800913:	ff d6                	call   *%esi
			break;
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	e9 dd fe ff ff       	jmp    8007fa <vprintfmt+0x446>
			putch('%', putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	53                   	push   %ebx
  800921:	6a 25                	push   $0x25
  800923:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	89 f8                	mov    %edi,%eax
  80092a:	eb 03                	jmp    80092f <vprintfmt+0x57b>
  80092c:	83 e8 01             	sub    $0x1,%eax
  80092f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800933:	75 f7                	jne    80092c <vprintfmt+0x578>
  800935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800938:	e9 bd fe ff ff       	jmp    8007fa <vprintfmt+0x446>
}
  80093d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5f                   	pop    %edi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 18             	sub    $0x18,%esp
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800958:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80095b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800962:	85 c0                	test   %eax,%eax
  800964:	74 26                	je     80098c <vsnprintf+0x47>
  800966:	85 d2                	test   %edx,%edx
  800968:	7e 22                	jle    80098c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096a:	ff 75 14             	pushl  0x14(%ebp)
  80096d:	ff 75 10             	pushl  0x10(%ebp)
  800970:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	68 7a 03 80 00       	push   $0x80037a
  800979:	e8 36 fa ff ff       	call   8003b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800981:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	83 c4 10             	add    $0x10,%esp
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    
		return -E_INVAL;
  80098c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800991:	eb f7                	jmp    80098a <vsnprintf+0x45>

00800993 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800999:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099c:	50                   	push   %eax
  80099d:	ff 75 10             	pushl  0x10(%ebp)
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	ff 75 08             	pushl  0x8(%ebp)
  8009a6:	e8 9a ff ff ff       	call   800945 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009bc:	74 05                	je     8009c3 <strlen+0x16>
		n++;
  8009be:	83 c0 01             	add    $0x1,%eax
  8009c1:	eb f5                	jmp    8009b8 <strlen+0xb>
	return n;
}
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d3:	39 c2                	cmp    %eax,%edx
  8009d5:	74 0d                	je     8009e4 <strnlen+0x1f>
  8009d7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009db:	74 05                	je     8009e2 <strnlen+0x1d>
		n++;
  8009dd:	83 c2 01             	add    $0x1,%edx
  8009e0:	eb f1                	jmp    8009d3 <strnlen+0xe>
  8009e2:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009fc:	83 c2 01             	add    $0x1,%edx
  8009ff:	84 c9                	test   %cl,%cl
  800a01:	75 f2                	jne    8009f5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a03:	5b                   	pop    %ebx
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	53                   	push   %ebx
  800a0a:	83 ec 10             	sub    $0x10,%esp
  800a0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a10:	53                   	push   %ebx
  800a11:	e8 97 ff ff ff       	call   8009ad <strlen>
  800a16:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	01 d8                	add    %ebx,%eax
  800a1e:	50                   	push   %eax
  800a1f:	e8 c2 ff ff ff       	call   8009e6 <strcpy>
	return dst;
}
  800a24:	89 d8                	mov    %ebx,%eax
  800a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a29:	c9                   	leave  
  800a2a:	c3                   	ret    

00800a2b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	56                   	push   %esi
  800a2f:	53                   	push   %ebx
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a36:	89 c6                	mov    %eax,%esi
  800a38:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	39 f2                	cmp    %esi,%edx
  800a3f:	74 11                	je     800a52 <strncpy+0x27>
		*dst++ = *src;
  800a41:	83 c2 01             	add    $0x1,%edx
  800a44:	0f b6 19             	movzbl (%ecx),%ebx
  800a47:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4a:	80 fb 01             	cmp    $0x1,%bl
  800a4d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a50:	eb eb                	jmp    800a3d <strncpy+0x12>
	}
	return ret;
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
  800a5b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a61:	8b 55 10             	mov    0x10(%ebp),%edx
  800a64:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a66:	85 d2                	test   %edx,%edx
  800a68:	74 21                	je     800a8b <strlcpy+0x35>
  800a6a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a6e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a70:	39 c2                	cmp    %eax,%edx
  800a72:	74 14                	je     800a88 <strlcpy+0x32>
  800a74:	0f b6 19             	movzbl (%ecx),%ebx
  800a77:	84 db                	test   %bl,%bl
  800a79:	74 0b                	je     800a86 <strlcpy+0x30>
			*dst++ = *src++;
  800a7b:	83 c1 01             	add    $0x1,%ecx
  800a7e:	83 c2 01             	add    $0x1,%edx
  800a81:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a84:	eb ea                	jmp    800a70 <strlcpy+0x1a>
  800a86:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a88:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8b:	29 f0                	sub    %esi,%eax
}
  800a8d:	5b                   	pop    %ebx
  800a8e:	5e                   	pop    %esi
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9a:	0f b6 01             	movzbl (%ecx),%eax
  800a9d:	84 c0                	test   %al,%al
  800a9f:	74 0c                	je     800aad <strcmp+0x1c>
  800aa1:	3a 02                	cmp    (%edx),%al
  800aa3:	75 08                	jne    800aad <strcmp+0x1c>
		p++, q++;
  800aa5:	83 c1 01             	add    $0x1,%ecx
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	eb ed                	jmp    800a9a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	0f b6 12             	movzbl (%edx),%edx
  800ab3:	29 d0                	sub    %edx,%eax
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac1:	89 c3                	mov    %eax,%ebx
  800ac3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac6:	eb 06                	jmp    800ace <strncmp+0x17>
		n--, p++, q++;
  800ac8:	83 c0 01             	add    $0x1,%eax
  800acb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ace:	39 d8                	cmp    %ebx,%eax
  800ad0:	74 16                	je     800ae8 <strncmp+0x31>
  800ad2:	0f b6 08             	movzbl (%eax),%ecx
  800ad5:	84 c9                	test   %cl,%cl
  800ad7:	74 04                	je     800add <strncmp+0x26>
  800ad9:	3a 0a                	cmp    (%edx),%cl
  800adb:	74 eb                	je     800ac8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800add:	0f b6 00             	movzbl (%eax),%eax
  800ae0:	0f b6 12             	movzbl (%edx),%edx
  800ae3:	29 d0                	sub    %edx,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    
		return 0;
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aed:	eb f6                	jmp    800ae5 <strncmp+0x2e>

00800aef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af9:	0f b6 10             	movzbl (%eax),%edx
  800afc:	84 d2                	test   %dl,%dl
  800afe:	74 09                	je     800b09 <strchr+0x1a>
		if (*s == c)
  800b00:	38 ca                	cmp    %cl,%dl
  800b02:	74 0a                	je     800b0e <strchr+0x1f>
	for (; *s; s++)
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	eb f0                	jmp    800af9 <strchr+0xa>
			return (char *) s;
	return 0;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b1d:	38 ca                	cmp    %cl,%dl
  800b1f:	74 09                	je     800b2a <strfind+0x1a>
  800b21:	84 d2                	test   %dl,%dl
  800b23:	74 05                	je     800b2a <strfind+0x1a>
	for (; *s; s++)
  800b25:	83 c0 01             	add    $0x1,%eax
  800b28:	eb f0                	jmp    800b1a <strfind+0xa>
			break;
	return (char *) s;
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b38:	85 c9                	test   %ecx,%ecx
  800b3a:	74 31                	je     800b6d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3c:	89 f8                	mov    %edi,%eax
  800b3e:	09 c8                	or     %ecx,%eax
  800b40:	a8 03                	test   $0x3,%al
  800b42:	75 23                	jne    800b67 <memset+0x3b>
		c &= 0xFF;
  800b44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b48:	89 d3                	mov    %edx,%ebx
  800b4a:	c1 e3 08             	shl    $0x8,%ebx
  800b4d:	89 d0                	mov    %edx,%eax
  800b4f:	c1 e0 18             	shl    $0x18,%eax
  800b52:	89 d6                	mov    %edx,%esi
  800b54:	c1 e6 10             	shl    $0x10,%esi
  800b57:	09 f0                	or     %esi,%eax
  800b59:	09 c2                	or     %eax,%edx
  800b5b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b60:	89 d0                	mov    %edx,%eax
  800b62:	fc                   	cld    
  800b63:	f3 ab                	rep stos %eax,%es:(%edi)
  800b65:	eb 06                	jmp    800b6d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6a:	fc                   	cld    
  800b6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6d:	89 f8                	mov    %edi,%eax
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b82:	39 c6                	cmp    %eax,%esi
  800b84:	73 32                	jae    800bb8 <memmove+0x44>
  800b86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	76 2b                	jbe    800bb8 <memmove+0x44>
		s += n;
		d += n;
  800b8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	89 fe                	mov    %edi,%esi
  800b92:	09 ce                	or     %ecx,%esi
  800b94:	09 d6                	or     %edx,%esi
  800b96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9c:	75 0e                	jne    800bac <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b9e:	83 ef 04             	sub    $0x4,%edi
  800ba1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba7:	fd                   	std    
  800ba8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800baa:	eb 09                	jmp    800bb5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bac:	83 ef 01             	sub    $0x1,%edi
  800baf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb2:	fd                   	std    
  800bb3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb5:	fc                   	cld    
  800bb6:	eb 1a                	jmp    800bd2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb8:	89 c2                	mov    %eax,%edx
  800bba:	09 ca                	or     %ecx,%edx
  800bbc:	09 f2                	or     %esi,%edx
  800bbe:	f6 c2 03             	test   $0x3,%dl
  800bc1:	75 0a                	jne    800bcd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc6:	89 c7                	mov    %eax,%edi
  800bc8:	fc                   	cld    
  800bc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcb:	eb 05                	jmp    800bd2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bcd:	89 c7                	mov    %eax,%edi
  800bcf:	fc                   	cld    
  800bd0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bdc:	ff 75 10             	pushl  0x10(%ebp)
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	ff 75 08             	pushl  0x8(%ebp)
  800be5:	e8 8a ff ff ff       	call   800b74 <memmove>
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf7:	89 c6                	mov    %eax,%esi
  800bf9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bfc:	39 f0                	cmp    %esi,%eax
  800bfe:	74 1c                	je     800c1c <memcmp+0x30>
		if (*s1 != *s2)
  800c00:	0f b6 08             	movzbl (%eax),%ecx
  800c03:	0f b6 1a             	movzbl (%edx),%ebx
  800c06:	38 d9                	cmp    %bl,%cl
  800c08:	75 08                	jne    800c12 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c0a:	83 c0 01             	add    $0x1,%eax
  800c0d:	83 c2 01             	add    $0x1,%edx
  800c10:	eb ea                	jmp    800bfc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c12:	0f b6 c1             	movzbl %cl,%eax
  800c15:	0f b6 db             	movzbl %bl,%ebx
  800c18:	29 d8                	sub    %ebx,%eax
  800c1a:	eb 05                	jmp    800c21 <memcmp+0x35>
	}

	return 0;
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c2e:	89 c2                	mov    %eax,%edx
  800c30:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c33:	39 d0                	cmp    %edx,%eax
  800c35:	73 09                	jae    800c40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c37:	38 08                	cmp    %cl,(%eax)
  800c39:	74 05                	je     800c40 <memfind+0x1b>
	for (; s < ends; s++)
  800c3b:	83 c0 01             	add    $0x1,%eax
  800c3e:	eb f3                	jmp    800c33 <memfind+0xe>
			break;
	return (void *) s;
}
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4e:	eb 03                	jmp    800c53 <strtol+0x11>
		s++;
  800c50:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c53:	0f b6 01             	movzbl (%ecx),%eax
  800c56:	3c 20                	cmp    $0x20,%al
  800c58:	74 f6                	je     800c50 <strtol+0xe>
  800c5a:	3c 09                	cmp    $0x9,%al
  800c5c:	74 f2                	je     800c50 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c5e:	3c 2b                	cmp    $0x2b,%al
  800c60:	74 2a                	je     800c8c <strtol+0x4a>
	int neg = 0;
  800c62:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c67:	3c 2d                	cmp    $0x2d,%al
  800c69:	74 2b                	je     800c96 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c71:	75 0f                	jne    800c82 <strtol+0x40>
  800c73:	80 39 30             	cmpb   $0x30,(%ecx)
  800c76:	74 28                	je     800ca0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c78:	85 db                	test   %ebx,%ebx
  800c7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7f:	0f 44 d8             	cmove  %eax,%ebx
  800c82:	b8 00 00 00 00       	mov    $0x0,%eax
  800c87:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c8a:	eb 50                	jmp    800cdc <strtol+0x9a>
		s++;
  800c8c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c94:	eb d5                	jmp    800c6b <strtol+0x29>
		s++, neg = 1;
  800c96:	83 c1 01             	add    $0x1,%ecx
  800c99:	bf 01 00 00 00       	mov    $0x1,%edi
  800c9e:	eb cb                	jmp    800c6b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca4:	74 0e                	je     800cb4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca6:	85 db                	test   %ebx,%ebx
  800ca8:	75 d8                	jne    800c82 <strtol+0x40>
		s++, base = 8;
  800caa:	83 c1 01             	add    $0x1,%ecx
  800cad:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb2:	eb ce                	jmp    800c82 <strtol+0x40>
		s += 2, base = 16;
  800cb4:	83 c1 02             	add    $0x2,%ecx
  800cb7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cbc:	eb c4                	jmp    800c82 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cbe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc1:	89 f3                	mov    %esi,%ebx
  800cc3:	80 fb 19             	cmp    $0x19,%bl
  800cc6:	77 29                	ja     800cf1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc8:	0f be d2             	movsbl %dl,%edx
  800ccb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cce:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd1:	7d 30                	jge    800d03 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd3:	83 c1 01             	add    $0x1,%ecx
  800cd6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cda:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cdc:	0f b6 11             	movzbl (%ecx),%edx
  800cdf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce2:	89 f3                	mov    %esi,%ebx
  800ce4:	80 fb 09             	cmp    $0x9,%bl
  800ce7:	77 d5                	ja     800cbe <strtol+0x7c>
			dig = *s - '0';
  800ce9:	0f be d2             	movsbl %dl,%edx
  800cec:	83 ea 30             	sub    $0x30,%edx
  800cef:	eb dd                	jmp    800cce <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf4:	89 f3                	mov    %esi,%ebx
  800cf6:	80 fb 19             	cmp    $0x19,%bl
  800cf9:	77 08                	ja     800d03 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cfb:	0f be d2             	movsbl %dl,%edx
  800cfe:	83 ea 37             	sub    $0x37,%edx
  800d01:	eb cb                	jmp    800cce <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d07:	74 05                	je     800d0e <strtol+0xcc>
		*endptr = (char *) s;
  800d09:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	f7 da                	neg    %edx
  800d12:	85 ff                	test   %edi,%edi
  800d14:	0f 45 c2             	cmovne %edx,%eax
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	89 c3                	mov    %eax,%ebx
  800d2f:	89 c7                	mov    %eax,%edi
  800d31:	89 c6                	mov    %eax,%esi
  800d33:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
  800d45:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4a:	89 d1                	mov    %edx,%ecx
  800d4c:	89 d3                	mov    %edx,%ebx
  800d4e:	89 d7                	mov    %edx,%edi
  800d50:	89 d6                	mov    %edx,%esi
  800d52:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	89 cb                	mov    %ecx,%ebx
  800d71:	89 cf                	mov    %ecx,%edi
  800d73:	89 ce                	mov    %ecx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 03                	push   $0x3
  800d89:	68 a8 2f 80 00       	push   $0x802fa8
  800d8e:	6a 43                	push   $0x43
  800d90:	68 c5 2f 80 00       	push   $0x802fc5
  800d95:	e8 76 19 00 00       	call   802710 <_panic>

00800d9a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da0:	ba 00 00 00 00       	mov    $0x0,%edx
  800da5:	b8 02 00 00 00       	mov    $0x2,%eax
  800daa:	89 d1                	mov    %edx,%ecx
  800dac:	89 d3                	mov    %edx,%ebx
  800dae:	89 d7                	mov    %edx,%edi
  800db0:	89 d6                	mov    %edx,%esi
  800db2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_yield>:

void
sys_yield(void)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc9:	89 d1                	mov    %edx,%ecx
  800dcb:	89 d3                	mov    %edx,%ebx
  800dcd:	89 d7                	mov    %edx,%edi
  800dcf:	89 d6                	mov    %edx,%esi
  800dd1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 04 00 00 00       	mov    $0x4,%eax
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	89 f7                	mov    %esi,%edi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 04                	push   $0x4
  800e0a:	68 a8 2f 80 00       	push   $0x802fa8
  800e0f:	6a 43                	push   $0x43
  800e11:	68 c5 2f 80 00       	push   $0x802fc5
  800e16:	e8 f5 18 00 00       	call   802710 <_panic>

00800e1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e35:	8b 75 18             	mov    0x18(%ebp),%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	50                   	push   %eax
  800e4a:	6a 05                	push   $0x5
  800e4c:	68 a8 2f 80 00       	push   $0x802fa8
  800e51:	6a 43                	push   $0x43
  800e53:	68 c5 2f 80 00       	push   $0x802fc5
  800e58:	e8 b3 18 00 00       	call   802710 <_panic>

00800e5d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	b8 06 00 00 00       	mov    $0x6,%eax
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7f 08                	jg     800e88 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	83 ec 0c             	sub    $0xc,%esp
  800e8b:	50                   	push   %eax
  800e8c:	6a 06                	push   $0x6
  800e8e:	68 a8 2f 80 00       	push   $0x802fa8
  800e93:	6a 43                	push   $0x43
  800e95:	68 c5 2f 80 00       	push   $0x802fc5
  800e9a:	e8 71 18 00 00       	call   802710 <_panic>

00800e9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 08                	push   $0x8
  800ed0:	68 a8 2f 80 00       	push   $0x802fa8
  800ed5:	6a 43                	push   $0x43
  800ed7:	68 c5 2f 80 00       	push   $0x802fc5
  800edc:	e8 2f 18 00 00       	call   802710 <_panic>

00800ee1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef5:	b8 09 00 00 00       	mov    $0x9,%eax
  800efa:	89 df                	mov    %ebx,%edi
  800efc:	89 de                	mov    %ebx,%esi
  800efe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f00:	85 c0                	test   %eax,%eax
  800f02:	7f 08                	jg     800f0c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0c:	83 ec 0c             	sub    $0xc,%esp
  800f0f:	50                   	push   %eax
  800f10:	6a 09                	push   $0x9
  800f12:	68 a8 2f 80 00       	push   $0x802fa8
  800f17:	6a 43                	push   $0x43
  800f19:	68 c5 2f 80 00       	push   $0x802fc5
  800f1e:	e8 ed 17 00 00       	call   802710 <_panic>

00800f23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f37:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3c:	89 df                	mov    %ebx,%edi
  800f3e:	89 de                	mov    %ebx,%esi
  800f40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7f 08                	jg     800f4e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4e:	83 ec 0c             	sub    $0xc,%esp
  800f51:	50                   	push   %eax
  800f52:	6a 0a                	push   $0xa
  800f54:	68 a8 2f 80 00       	push   $0x802fa8
  800f59:	6a 43                	push   $0x43
  800f5b:	68 c5 2f 80 00       	push   $0x802fc5
  800f60:	e8 ab 17 00 00       	call   802710 <_panic>

00800f65 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f76:	be 00 00 00 00       	mov    $0x0,%esi
  800f7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f81:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f96:	8b 55 08             	mov    0x8(%ebp),%edx
  800f99:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9e:	89 cb                	mov    %ecx,%ebx
  800fa0:	89 cf                	mov    %ecx,%edi
  800fa2:	89 ce                	mov    %ecx,%esi
  800fa4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	7f 08                	jg     800fb2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	50                   	push   %eax
  800fb6:	6a 0d                	push   $0xd
  800fb8:	68 a8 2f 80 00       	push   $0x802fa8
  800fbd:	6a 43                	push   $0x43
  800fbf:	68 c5 2f 80 00       	push   $0x802fc5
  800fc4:	e8 47 17 00 00       	call   802710 <_panic>

00800fc9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	89 de                	mov    %ebx,%esi
  800fe3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffd:	89 cb                	mov    %ecx,%ebx
  800fff:	89 cf                	mov    %ecx,%edi
  801001:	89 ce                	mov    %ecx,%esi
  801003:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801010:	ba 00 00 00 00       	mov    $0x0,%edx
  801015:	b8 10 00 00 00       	mov    $0x10,%eax
  80101a:	89 d1                	mov    %edx,%ecx
  80101c:	89 d3                	mov    %edx,%ebx
  80101e:	89 d7                	mov    %edx,%edi
  801020:	89 d6                	mov    %edx,%esi
  801022:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	57                   	push   %edi
  80102d:	56                   	push   %esi
  80102e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103a:	b8 11 00 00 00       	mov    $0x11,%eax
  80103f:	89 df                	mov    %ebx,%edi
  801041:	89 de                	mov    %ebx,%esi
  801043:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801050:	bb 00 00 00 00       	mov    $0x0,%ebx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	b8 12 00 00 00       	mov    $0x12,%eax
  801060:	89 df                	mov    %ebx,%edi
  801062:	89 de                	mov    %ebx,%esi
  801064:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	b8 13 00 00 00       	mov    $0x13,%eax
  801084:	89 df                	mov    %ebx,%edi
  801086:	89 de                	mov    %ebx,%esi
  801088:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	7f 08                	jg     801096 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	50                   	push   %eax
  80109a:	6a 13                	push   $0x13
  80109c:	68 a8 2f 80 00       	push   $0x802fa8
  8010a1:	6a 43                	push   $0x43
  8010a3:	68 c5 2f 80 00       	push   $0x802fc5
  8010a8:	e8 63 16 00 00       	call   802710 <_panic>

008010ad <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bb:	b8 14 00 00 00       	mov    $0x14,%eax
  8010c0:	89 cb                	mov    %ecx,%ebx
  8010c2:	89 cf                	mov    %ecx,%edi
  8010c4:	89 ce                	mov    %ecx,%esi
  8010c6:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	53                   	push   %ebx
  8010d1:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010d4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010db:	f6 c5 04             	test   $0x4,%ch
  8010de:	75 45                	jne    801125 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010e0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e7:	83 e1 07             	and    $0x7,%ecx
  8010ea:	83 f9 07             	cmp    $0x7,%ecx
  8010ed:	74 6f                	je     80115e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010ef:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010f6:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010fc:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801102:	0f 84 b6 00 00 00    	je     8011be <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801108:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80110f:	83 e1 05             	and    $0x5,%ecx
  801112:	83 f9 05             	cmp    $0x5,%ecx
  801115:	0f 84 d7 00 00 00    	je     8011f2 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
  801120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801123:	c9                   	leave  
  801124:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801125:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80112c:	c1 e2 0c             	shl    $0xc,%edx
  80112f:	83 ec 0c             	sub    $0xc,%esp
  801132:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801138:	51                   	push   %ecx
  801139:	52                   	push   %edx
  80113a:	50                   	push   %eax
  80113b:	52                   	push   %edx
  80113c:	6a 00                	push   $0x0
  80113e:	e8 d8 fc ff ff       	call   800e1b <sys_page_map>
		if(r < 0)
  801143:	83 c4 20             	add    $0x20,%esp
  801146:	85 c0                	test   %eax,%eax
  801148:	79 d1                	jns    80111b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114a:	83 ec 04             	sub    $0x4,%esp
  80114d:	68 d3 2f 80 00       	push   $0x802fd3
  801152:	6a 54                	push   $0x54
  801154:	68 e9 2f 80 00       	push   $0x802fe9
  801159:	e8 b2 15 00 00       	call   802710 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115e:	89 d3                	mov    %edx,%ebx
  801160:	c1 e3 0c             	shl    $0xc,%ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	68 05 08 00 00       	push   $0x805
  80116b:	53                   	push   %ebx
  80116c:	50                   	push   %eax
  80116d:	53                   	push   %ebx
  80116e:	6a 00                	push   $0x0
  801170:	e8 a6 fc ff ff       	call   800e1b <sys_page_map>
		if(r < 0)
  801175:	83 c4 20             	add    $0x20,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 2e                	js     8011aa <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	68 05 08 00 00       	push   $0x805
  801184:	53                   	push   %ebx
  801185:	6a 00                	push   $0x0
  801187:	53                   	push   %ebx
  801188:	6a 00                	push   $0x0
  80118a:	e8 8c fc ff ff       	call   800e1b <sys_page_map>
		if(r < 0)
  80118f:	83 c4 20             	add    $0x20,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	79 85                	jns    80111b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	68 d3 2f 80 00       	push   $0x802fd3
  80119e:	6a 5f                	push   $0x5f
  8011a0:	68 e9 2f 80 00       	push   $0x802fe9
  8011a5:	e8 66 15 00 00       	call   802710 <_panic>
			panic("sys_page_map() panic\n");
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	68 d3 2f 80 00       	push   $0x802fd3
  8011b2:	6a 5b                	push   $0x5b
  8011b4:	68 e9 2f 80 00       	push   $0x802fe9
  8011b9:	e8 52 15 00 00       	call   802710 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011be:	c1 e2 0c             	shl    $0xc,%edx
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	68 05 08 00 00       	push   $0x805
  8011c9:	52                   	push   %edx
  8011ca:	50                   	push   %eax
  8011cb:	52                   	push   %edx
  8011cc:	6a 00                	push   $0x0
  8011ce:	e8 48 fc ff ff       	call   800e1b <sys_page_map>
		if(r < 0)
  8011d3:	83 c4 20             	add    $0x20,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 89 3d ff ff ff    	jns    80111b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	68 d3 2f 80 00       	push   $0x802fd3
  8011e6:	6a 66                	push   $0x66
  8011e8:	68 e9 2f 80 00       	push   $0x802fe9
  8011ed:	e8 1e 15 00 00       	call   802710 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011f2:	c1 e2 0c             	shl    $0xc,%edx
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	6a 05                	push   $0x5
  8011fa:	52                   	push   %edx
  8011fb:	50                   	push   %eax
  8011fc:	52                   	push   %edx
  8011fd:	6a 00                	push   $0x0
  8011ff:	e8 17 fc ff ff       	call   800e1b <sys_page_map>
		if(r < 0)
  801204:	83 c4 20             	add    $0x20,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	0f 89 0c ff ff ff    	jns    80111b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 d3 2f 80 00       	push   $0x802fd3
  801217:	6a 6d                	push   $0x6d
  801219:	68 e9 2f 80 00       	push   $0x802fe9
  80121e:	e8 ed 14 00 00       	call   802710 <_panic>

00801223 <pgfault>:
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	53                   	push   %ebx
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80122d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80122f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801233:	0f 84 99 00 00 00    	je     8012d2 <pgfault+0xaf>
  801239:	89 c2                	mov    %eax,%edx
  80123b:	c1 ea 16             	shr    $0x16,%edx
  80123e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801245:	f6 c2 01             	test   $0x1,%dl
  801248:	0f 84 84 00 00 00    	je     8012d2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80124e:	89 c2                	mov    %eax,%edx
  801250:	c1 ea 0c             	shr    $0xc,%edx
  801253:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80125a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801260:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801266:	75 6a                	jne    8012d2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80126f:	83 ec 04             	sub    $0x4,%esp
  801272:	6a 07                	push   $0x7
  801274:	68 00 f0 7f 00       	push   $0x7ff000
  801279:	6a 00                	push   $0x0
  80127b:	e8 58 fb ff ff       	call   800dd8 <sys_page_alloc>
	if(ret < 0)
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 5f                	js     8012e6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	68 00 10 00 00       	push   $0x1000
  80128f:	53                   	push   %ebx
  801290:	68 00 f0 7f 00       	push   $0x7ff000
  801295:	e8 3c f9 ff ff       	call   800bd6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80129a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012a1:	53                   	push   %ebx
  8012a2:	6a 00                	push   $0x0
  8012a4:	68 00 f0 7f 00       	push   $0x7ff000
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 6b fb ff ff       	call   800e1b <sys_page_map>
	if(ret < 0)
  8012b0:	83 c4 20             	add    $0x20,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	78 43                	js     8012fa <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	68 00 f0 7f 00       	push   $0x7ff000
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 97 fb ff ff       	call   800e5d <sys_page_unmap>
	if(ret < 0)
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 41                	js     80130e <pgfault+0xeb>
}
  8012cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012d2:	83 ec 04             	sub    $0x4,%esp
  8012d5:	68 f4 2f 80 00       	push   $0x802ff4
  8012da:	6a 26                	push   $0x26
  8012dc:	68 e9 2f 80 00       	push   $0x802fe9
  8012e1:	e8 2a 14 00 00       	call   802710 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	68 08 30 80 00       	push   $0x803008
  8012ee:	6a 31                	push   $0x31
  8012f0:	68 e9 2f 80 00       	push   $0x802fe9
  8012f5:	e8 16 14 00 00       	call   802710 <_panic>
		panic("panic in sys_page_map()\n");
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	68 23 30 80 00       	push   $0x803023
  801302:	6a 36                	push   $0x36
  801304:	68 e9 2f 80 00       	push   $0x802fe9
  801309:	e8 02 14 00 00       	call   802710 <_panic>
		panic("panic in sys_page_unmap()\n");
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	68 3c 30 80 00       	push   $0x80303c
  801316:	6a 39                	push   $0x39
  801318:	68 e9 2f 80 00       	push   $0x802fe9
  80131d:	e8 ee 13 00 00       	call   802710 <_panic>

00801322 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	57                   	push   %edi
  801326:	56                   	push   %esi
  801327:	53                   	push   %ebx
  801328:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80132b:	68 23 12 80 00       	push   $0x801223
  801330:	e8 3c 14 00 00       	call   802771 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801335:	b8 07 00 00 00       	mov    $0x7,%eax
  80133a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 2a                	js     80136d <fork+0x4b>
  801343:	89 c6                	mov    %eax,%esi
  801345:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801347:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80134c:	75 4b                	jne    801399 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80134e:	e8 47 fa ff ff       	call   800d9a <sys_getenvid>
  801353:	25 ff 03 00 00       	and    $0x3ff,%eax
  801358:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80135e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801363:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801368:	e9 90 00 00 00       	jmp    8013fd <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 58 30 80 00       	push   $0x803058
  801375:	68 8c 00 00 00       	push   $0x8c
  80137a:	68 e9 2f 80 00       	push   $0x802fe9
  80137f:	e8 8c 13 00 00       	call   802710 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801384:	89 f8                	mov    %edi,%eax
  801386:	e8 42 fd ff ff       	call   8010cd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80138b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801391:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801397:	74 26                	je     8013bf <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801399:	89 d8                	mov    %ebx,%eax
  80139b:	c1 e8 16             	shr    $0x16,%eax
  80139e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a5:	a8 01                	test   $0x1,%al
  8013a7:	74 e2                	je     80138b <fork+0x69>
  8013a9:	89 da                	mov    %ebx,%edx
  8013ab:	c1 ea 0c             	shr    $0xc,%edx
  8013ae:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013b5:	83 e0 05             	and    $0x5,%eax
  8013b8:	83 f8 05             	cmp    $0x5,%eax
  8013bb:	75 ce                	jne    80138b <fork+0x69>
  8013bd:	eb c5                	jmp    801384 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	6a 07                	push   $0x7
  8013c4:	68 00 f0 bf ee       	push   $0xeebff000
  8013c9:	56                   	push   %esi
  8013ca:	e8 09 fa ff ff       	call   800dd8 <sys_page_alloc>
	if(ret < 0)
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 31                	js     801407 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	68 e0 27 80 00       	push   $0x8027e0
  8013de:	56                   	push   %esi
  8013df:	e8 3f fb ff ff       	call   800f23 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 33                	js     80141e <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	6a 02                	push   $0x2
  8013f0:	56                   	push   %esi
  8013f1:	e8 a9 fa ff ff       	call   800e9f <sys_env_set_status>
	if(ret < 0)
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 38                	js     801435 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013fd:	89 f0                	mov    %esi,%eax
  8013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801402:	5b                   	pop    %ebx
  801403:	5e                   	pop    %esi
  801404:	5f                   	pop    %edi
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	68 08 30 80 00       	push   $0x803008
  80140f:	68 98 00 00 00       	push   $0x98
  801414:	68 e9 2f 80 00       	push   $0x802fe9
  801419:	e8 f2 12 00 00       	call   802710 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	68 7c 30 80 00       	push   $0x80307c
  801426:	68 9b 00 00 00       	push   $0x9b
  80142b:	68 e9 2f 80 00       	push   $0x802fe9
  801430:	e8 db 12 00 00       	call   802710 <_panic>
		panic("panic in sys_env_set_status()\n");
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	68 a4 30 80 00       	push   $0x8030a4
  80143d:	68 9e 00 00 00       	push   $0x9e
  801442:	68 e9 2f 80 00       	push   $0x802fe9
  801447:	e8 c4 12 00 00       	call   802710 <_panic>

0080144c <sfork>:

// Challenge!
int
sfork(void)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801455:	68 23 12 80 00       	push   $0x801223
  80145a:	e8 12 13 00 00       	call   802771 <set_pgfault_handler>
  80145f:	b8 07 00 00 00       	mov    $0x7,%eax
  801464:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 2a                	js     801497 <sfork+0x4b>
  80146d:	89 c7                	mov    %eax,%edi
  80146f:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801471:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801476:	75 58                	jne    8014d0 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801478:	e8 1d f9 ff ff       	call   800d9a <sys_getenvid>
  80147d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801482:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801488:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80148d:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801492:	e9 d4 00 00 00       	jmp    80156b <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	68 58 30 80 00       	push   $0x803058
  80149f:	68 af 00 00 00       	push   $0xaf
  8014a4:	68 e9 2f 80 00       	push   $0x802fe9
  8014a9:	e8 62 12 00 00       	call   802710 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014ae:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014b3:	89 f0                	mov    %esi,%eax
  8014b5:	e8 13 fc ff ff       	call   8010cd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014c0:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014c6:	77 65                	ja     80152d <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8014c8:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014ce:	74 de                	je     8014ae <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014d0:	89 d8                	mov    %ebx,%eax
  8014d2:	c1 e8 16             	shr    $0x16,%eax
  8014d5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014dc:	a8 01                	test   $0x1,%al
  8014de:	74 da                	je     8014ba <sfork+0x6e>
  8014e0:	89 da                	mov    %ebx,%edx
  8014e2:	c1 ea 0c             	shr    $0xc,%edx
  8014e5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014ec:	83 e0 05             	and    $0x5,%eax
  8014ef:	83 f8 05             	cmp    $0x5,%eax
  8014f2:	75 c6                	jne    8014ba <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014f4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014fb:	c1 e2 0c             	shl    $0xc,%edx
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	83 e0 07             	and    $0x7,%eax
  801504:	50                   	push   %eax
  801505:	52                   	push   %edx
  801506:	56                   	push   %esi
  801507:	52                   	push   %edx
  801508:	6a 00                	push   $0x0
  80150a:	e8 0c f9 ff ff       	call   800e1b <sys_page_map>
  80150f:	83 c4 20             	add    $0x20,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	74 a4                	je     8014ba <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	68 d3 2f 80 00       	push   $0x802fd3
  80151e:	68 ba 00 00 00       	push   $0xba
  801523:	68 e9 2f 80 00       	push   $0x802fe9
  801528:	e8 e3 11 00 00       	call   802710 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	6a 07                	push   $0x7
  801532:	68 00 f0 bf ee       	push   $0xeebff000
  801537:	57                   	push   %edi
  801538:	e8 9b f8 ff ff       	call   800dd8 <sys_page_alloc>
	if(ret < 0)
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	78 31                	js     801575 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	68 e0 27 80 00       	push   $0x8027e0
  80154c:	57                   	push   %edi
  80154d:	e8 d1 f9 ff ff       	call   800f23 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 33                	js     80158c <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	6a 02                	push   $0x2
  80155e:	57                   	push   %edi
  80155f:	e8 3b f9 ff ff       	call   800e9f <sys_env_set_status>
	if(ret < 0)
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 38                	js     8015a3 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80156b:	89 f8                	mov    %edi,%eax
  80156d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801570:	5b                   	pop    %ebx
  801571:	5e                   	pop    %esi
  801572:	5f                   	pop    %edi
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 08 30 80 00       	push   $0x803008
  80157d:	68 c0 00 00 00       	push   $0xc0
  801582:	68 e9 2f 80 00       	push   $0x802fe9
  801587:	e8 84 11 00 00       	call   802710 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 7c 30 80 00       	push   $0x80307c
  801594:	68 c3 00 00 00       	push   $0xc3
  801599:	68 e9 2f 80 00       	push   $0x802fe9
  80159e:	e8 6d 11 00 00       	call   802710 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	68 a4 30 80 00       	push   $0x8030a4
  8015ab:	68 c6 00 00 00       	push   $0xc6
  8015b0:	68 e9 2f 80 00       	push   $0x802fe9
  8015b5:	e8 56 11 00 00       	call   802710 <_panic>

008015ba <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	05 00 00 00 30       	add    $0x30000000,%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
}
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015da:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    

008015e1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	c1 ea 16             	shr    $0x16,%edx
  8015ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f5:	f6 c2 01             	test   $0x1,%dl
  8015f8:	74 2d                	je     801627 <fd_alloc+0x46>
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	c1 ea 0c             	shr    $0xc,%edx
  8015ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	74 1c                	je     801627 <fd_alloc+0x46>
  80160b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801610:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801615:	75 d2                	jne    8015e9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801620:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801625:	eb 0a                	jmp    801631 <fd_alloc+0x50>
			*fd_store = fd;
  801627:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801639:	83 f8 1f             	cmp    $0x1f,%eax
  80163c:	77 30                	ja     80166e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80163e:	c1 e0 0c             	shl    $0xc,%eax
  801641:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801646:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80164c:	f6 c2 01             	test   $0x1,%dl
  80164f:	74 24                	je     801675 <fd_lookup+0x42>
  801651:	89 c2                	mov    %eax,%edx
  801653:	c1 ea 0c             	shr    $0xc,%edx
  801656:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165d:	f6 c2 01             	test   $0x1,%dl
  801660:	74 1a                	je     80167c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	89 02                	mov    %eax,(%edx)
	return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    
		return -E_INVAL;
  80166e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801673:	eb f7                	jmp    80166c <fd_lookup+0x39>
		return -E_INVAL;
  801675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167a:	eb f0                	jmp    80166c <fd_lookup+0x39>
  80167c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801681:	eb e9                	jmp    80166c <fd_lookup+0x39>

00801683 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801696:	39 08                	cmp    %ecx,(%eax)
  801698:	74 38                	je     8016d2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80169a:	83 c2 01             	add    $0x1,%edx
  80169d:	8b 04 95 40 31 80 00 	mov    0x803140(,%edx,4),%eax
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	75 ee                	jne    801696 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ad:	8b 40 48             	mov    0x48(%eax),%eax
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	51                   	push   %ecx
  8016b4:	50                   	push   %eax
  8016b5:	68 c4 30 80 00       	push   $0x8030c4
  8016ba:	e8 c8 eb ff ff       	call   800287 <cprintf>
	*dev = 0;
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    
			*dev = devtab[i];
  8016d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	eb f2                	jmp    8016d0 <dev_lookup+0x4d>

008016de <fd_close>:
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	57                   	push   %edi
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 24             	sub    $0x24,%esp
  8016e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016f0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016f7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016fa:	50                   	push   %eax
  8016fb:	e8 33 ff ff ff       	call   801633 <fd_lookup>
  801700:	89 c3                	mov    %eax,%ebx
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 05                	js     80170e <fd_close+0x30>
	    || fd != fd2)
  801709:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80170c:	74 16                	je     801724 <fd_close+0x46>
		return (must_exist ? r : 0);
  80170e:	89 f8                	mov    %edi,%eax
  801710:	84 c0                	test   %al,%al
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	0f 44 d8             	cmove  %eax,%ebx
}
  80171a:	89 d8                	mov    %ebx,%eax
  80171c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5f                   	pop    %edi
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80172a:	50                   	push   %eax
  80172b:	ff 36                	pushl  (%esi)
  80172d:	e8 51 ff ff ff       	call   801683 <dev_lookup>
  801732:	89 c3                	mov    %eax,%ebx
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 1a                	js     801755 <fd_close+0x77>
		if (dev->dev_close)
  80173b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801746:	85 c0                	test   %eax,%eax
  801748:	74 0b                	je     801755 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	56                   	push   %esi
  80174e:	ff d0                	call   *%eax
  801750:	89 c3                	mov    %eax,%ebx
  801752:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	56                   	push   %esi
  801759:	6a 00                	push   $0x0
  80175b:	e8 fd f6 ff ff       	call   800e5d <sys_page_unmap>
	return r;
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	eb b5                	jmp    80171a <fd_close+0x3c>

00801765 <close>:

int
close(int fdnum)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 bc fe ff ff       	call   801633 <fd_lookup>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	79 02                	jns    801780 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    
		return fd_close(fd, 1);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	6a 01                	push   $0x1
  801785:	ff 75 f4             	pushl  -0xc(%ebp)
  801788:	e8 51 ff ff ff       	call   8016de <fd_close>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	eb ec                	jmp    80177e <close+0x19>

00801792 <close_all>:

void
close_all(void)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801799:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	53                   	push   %ebx
  8017a2:	e8 be ff ff ff       	call   801765 <close>
	for (i = 0; i < MAXFD; i++)
  8017a7:	83 c3 01             	add    $0x1,%ebx
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	83 fb 20             	cmp    $0x20,%ebx
  8017b0:	75 ec                	jne    80179e <close_all+0xc>
}
  8017b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	57                   	push   %edi
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	e8 67 fe ff ff       	call   801633 <fd_lookup>
  8017cc:	89 c3                	mov    %eax,%ebx
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	0f 88 81 00 00 00    	js     80185a <dup+0xa3>
		return r;
	close(newfdnum);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	e8 81 ff ff ff       	call   801765 <close>

	newfd = INDEX2FD(newfdnum);
  8017e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017e7:	c1 e6 0c             	shl    $0xc,%esi
  8017ea:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017f0:	83 c4 04             	add    $0x4,%esp
  8017f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017f6:	e8 cf fd ff ff       	call   8015ca <fd2data>
  8017fb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017fd:	89 34 24             	mov    %esi,(%esp)
  801800:	e8 c5 fd ff ff       	call   8015ca <fd2data>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	c1 e8 16             	shr    $0x16,%eax
  80180f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801816:	a8 01                	test   $0x1,%al
  801818:	74 11                	je     80182b <dup+0x74>
  80181a:	89 d8                	mov    %ebx,%eax
  80181c:	c1 e8 0c             	shr    $0xc,%eax
  80181f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801826:	f6 c2 01             	test   $0x1,%dl
  801829:	75 39                	jne    801864 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80182b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80182e:	89 d0                	mov    %edx,%eax
  801830:	c1 e8 0c             	shr    $0xc,%eax
  801833:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183a:	83 ec 0c             	sub    $0xc,%esp
  80183d:	25 07 0e 00 00       	and    $0xe07,%eax
  801842:	50                   	push   %eax
  801843:	56                   	push   %esi
  801844:	6a 00                	push   $0x0
  801846:	52                   	push   %edx
  801847:	6a 00                	push   $0x0
  801849:	e8 cd f5 ff ff       	call   800e1b <sys_page_map>
  80184e:	89 c3                	mov    %eax,%ebx
  801850:	83 c4 20             	add    $0x20,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	78 31                	js     801888 <dup+0xd1>
		goto err;

	return newfdnum;
  801857:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801864:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	25 07 0e 00 00       	and    $0xe07,%eax
  801873:	50                   	push   %eax
  801874:	57                   	push   %edi
  801875:	6a 00                	push   $0x0
  801877:	53                   	push   %ebx
  801878:	6a 00                	push   $0x0
  80187a:	e8 9c f5 ff ff       	call   800e1b <sys_page_map>
  80187f:	89 c3                	mov    %eax,%ebx
  801881:	83 c4 20             	add    $0x20,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	79 a3                	jns    80182b <dup+0x74>
	sys_page_unmap(0, newfd);
  801888:	83 ec 08             	sub    $0x8,%esp
  80188b:	56                   	push   %esi
  80188c:	6a 00                	push   $0x0
  80188e:	e8 ca f5 ff ff       	call   800e5d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801893:	83 c4 08             	add    $0x8,%esp
  801896:	57                   	push   %edi
  801897:	6a 00                	push   $0x0
  801899:	e8 bf f5 ff ff       	call   800e5d <sys_page_unmap>
	return r;
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	eb b7                	jmp    80185a <dup+0xa3>

008018a3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 1c             	sub    $0x1c,%esp
  8018aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	53                   	push   %ebx
  8018b2:	e8 7c fd ff ff       	call   801633 <fd_lookup>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 3f                	js     8018fd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018be:	83 ec 08             	sub    $0x8,%esp
  8018c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c4:	50                   	push   %eax
  8018c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c8:	ff 30                	pushl  (%eax)
  8018ca:	e8 b4 fd ff ff       	call   801683 <dev_lookup>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 27                	js     8018fd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d9:	8b 42 08             	mov    0x8(%edx),%eax
  8018dc:	83 e0 03             	and    $0x3,%eax
  8018df:	83 f8 01             	cmp    $0x1,%eax
  8018e2:	74 1e                	je     801902 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	8b 40 08             	mov    0x8(%eax),%eax
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	74 35                	je     801923 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	ff 75 10             	pushl  0x10(%ebp)
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	52                   	push   %edx
  8018f8:	ff d0                	call   *%eax
  8018fa:	83 c4 10             	add    $0x10,%esp
}
  8018fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801900:	c9                   	leave  
  801901:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801902:	a1 08 50 80 00       	mov    0x805008,%eax
  801907:	8b 40 48             	mov    0x48(%eax),%eax
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	53                   	push   %ebx
  80190e:	50                   	push   %eax
  80190f:	68 05 31 80 00       	push   $0x803105
  801914:	e8 6e e9 ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801921:	eb da                	jmp    8018fd <read+0x5a>
		return -E_NOT_SUPP;
  801923:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801928:	eb d3                	jmp    8018fd <read+0x5a>

0080192a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	8b 7d 08             	mov    0x8(%ebp),%edi
  801936:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801939:	bb 00 00 00 00       	mov    $0x0,%ebx
  80193e:	39 f3                	cmp    %esi,%ebx
  801940:	73 23                	jae    801965 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	89 f0                	mov    %esi,%eax
  801947:	29 d8                	sub    %ebx,%eax
  801949:	50                   	push   %eax
  80194a:	89 d8                	mov    %ebx,%eax
  80194c:	03 45 0c             	add    0xc(%ebp),%eax
  80194f:	50                   	push   %eax
  801950:	57                   	push   %edi
  801951:	e8 4d ff ff ff       	call   8018a3 <read>
		if (m < 0)
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 06                	js     801963 <readn+0x39>
			return m;
		if (m == 0)
  80195d:	74 06                	je     801965 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80195f:	01 c3                	add    %eax,%ebx
  801961:	eb db                	jmp    80193e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801963:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801965:	89 d8                	mov    %ebx,%eax
  801967:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5f                   	pop    %edi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	53                   	push   %ebx
  801973:	83 ec 1c             	sub    $0x1c,%esp
  801976:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801979:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197c:	50                   	push   %eax
  80197d:	53                   	push   %ebx
  80197e:	e8 b0 fc ff ff       	call   801633 <fd_lookup>
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	85 c0                	test   %eax,%eax
  801988:	78 3a                	js     8019c4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801990:	50                   	push   %eax
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	ff 30                	pushl  (%eax)
  801996:	e8 e8 fc ff ff       	call   801683 <dev_lookup>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 22                	js     8019c4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a9:	74 1e                	je     8019c9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b1:	85 d2                	test   %edx,%edx
  8019b3:	74 35                	je     8019ea <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	ff d2                	call   *%edx
  8019c1:	83 c4 10             	add    $0x10,%esp
}
  8019c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8019ce:	8b 40 48             	mov    0x48(%eax),%eax
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	53                   	push   %ebx
  8019d5:	50                   	push   %eax
  8019d6:	68 21 31 80 00       	push   $0x803121
  8019db:	e8 a7 e8 ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e8:	eb da                	jmp    8019c4 <write+0x55>
		return -E_NOT_SUPP;
  8019ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ef:	eb d3                	jmp    8019c4 <write+0x55>

008019f1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fa:	50                   	push   %eax
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	e8 30 fc ff ff       	call   801633 <fd_lookup>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 0e                	js     801a18 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a10:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	53                   	push   %ebx
  801a1e:	83 ec 1c             	sub    $0x1c,%esp
  801a21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a27:	50                   	push   %eax
  801a28:	53                   	push   %ebx
  801a29:	e8 05 fc ff ff       	call   801633 <fd_lookup>
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 37                	js     801a6c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3b:	50                   	push   %eax
  801a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3f:	ff 30                	pushl  (%eax)
  801a41:	e8 3d fc ff ff       	call   801683 <dev_lookup>
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 1f                	js     801a6c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a54:	74 1b                	je     801a71 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a59:	8b 52 18             	mov    0x18(%edx),%edx
  801a5c:	85 d2                	test   %edx,%edx
  801a5e:	74 32                	je     801a92 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	ff d2                	call   *%edx
  801a69:	83 c4 10             	add    $0x10,%esp
}
  801a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a71:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a76:	8b 40 48             	mov    0x48(%eax),%eax
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	53                   	push   %ebx
  801a7d:	50                   	push   %eax
  801a7e:	68 e4 30 80 00       	push   $0x8030e4
  801a83:	e8 ff e7 ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a90:	eb da                	jmp    801a6c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a92:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a97:	eb d3                	jmp    801a6c <ftruncate+0x52>

00801a99 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	53                   	push   %ebx
  801a9d:	83 ec 1c             	sub    $0x1c,%esp
  801aa0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa6:	50                   	push   %eax
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	e8 84 fb ff ff       	call   801633 <fd_lookup>
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 4b                	js     801b01 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abc:	50                   	push   %eax
  801abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac0:	ff 30                	pushl  (%eax)
  801ac2:	e8 bc fb ff ff       	call   801683 <dev_lookup>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 33                	js     801b01 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ad5:	74 2f                	je     801b06 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ad7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ada:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ae1:	00 00 00 
	stat->st_isdir = 0;
  801ae4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aeb:	00 00 00 
	stat->st_dev = dev;
  801aee:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	53                   	push   %ebx
  801af8:	ff 75 f0             	pushl  -0x10(%ebp)
  801afb:	ff 50 14             	call   *0x14(%eax)
  801afe:	83 c4 10             	add    $0x10,%esp
}
  801b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    
		return -E_NOT_SUPP;
  801b06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0b:	eb f4                	jmp    801b01 <fstat+0x68>

00801b0d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b12:	83 ec 08             	sub    $0x8,%esp
  801b15:	6a 00                	push   $0x0
  801b17:	ff 75 08             	pushl  0x8(%ebp)
  801b1a:	e8 22 02 00 00       	call   801d41 <open>
  801b1f:	89 c3                	mov    %eax,%ebx
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 1b                	js     801b43 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	e8 65 ff ff ff       	call   801a99 <fstat>
  801b34:	89 c6                	mov    %eax,%esi
	close(fd);
  801b36:	89 1c 24             	mov    %ebx,(%esp)
  801b39:	e8 27 fc ff ff       	call   801765 <close>
	return r;
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 f3                	mov    %esi,%ebx
}
  801b43:	89 d8                	mov    %ebx,%eax
  801b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b48:	5b                   	pop    %ebx
  801b49:	5e                   	pop    %esi
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    

00801b4c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	56                   	push   %esi
  801b50:	53                   	push   %ebx
  801b51:	89 c6                	mov    %eax,%esi
  801b53:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b55:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b5c:	74 27                	je     801b85 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b5e:	6a 07                	push   $0x7
  801b60:	68 00 60 80 00       	push   $0x806000
  801b65:	56                   	push   %esi
  801b66:	ff 35 00 50 80 00    	pushl  0x805000
  801b6c:	e8 fe 0c 00 00       	call   80286f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b71:	83 c4 0c             	add    $0xc,%esp
  801b74:	6a 00                	push   $0x0
  801b76:	53                   	push   %ebx
  801b77:	6a 00                	push   $0x0
  801b79:	e8 88 0c 00 00       	call   802806 <ipc_recv>
}
  801b7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b81:	5b                   	pop    %ebx
  801b82:	5e                   	pop    %esi
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	6a 01                	push   $0x1
  801b8a:	e8 38 0d 00 00       	call   8028c7 <ipc_find_env>
  801b8f:	a3 00 50 80 00       	mov    %eax,0x805000
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	eb c5                	jmp    801b5e <fsipc+0x12>

00801b99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bbc:	e8 8b ff ff ff       	call   801b4c <fsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <devfile_flush>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bde:	e8 69 ff ff ff       	call   801b4c <fsipc>
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <devfile_stat>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 05 00 00 00       	mov    $0x5,%eax
  801c04:	e8 43 ff ff ff       	call   801b4c <fsipc>
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 2c                	js     801c39 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	68 00 60 80 00       	push   $0x806000
  801c15:	53                   	push   %ebx
  801c16:	e8 cb ed ff ff       	call   8009e6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c1b:	a1 80 60 80 00       	mov    0x806080,%eax
  801c20:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c26:	a1 84 60 80 00       	mov    0x806084,%eax
  801c2b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <devfile_write>:
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
  801c42:	83 ec 08             	sub    $0x8,%esp
  801c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c53:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c59:	53                   	push   %ebx
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	68 08 60 80 00       	push   $0x806008
  801c62:	e8 6f ef ff ff       	call   800bd6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6c:	b8 04 00 00 00       	mov    $0x4,%eax
  801c71:	e8 d6 fe ff ff       	call   801b4c <fsipc>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 0b                	js     801c88 <devfile_write+0x4a>
	assert(r <= n);
  801c7d:	39 d8                	cmp    %ebx,%eax
  801c7f:	77 0c                	ja     801c8d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c81:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c86:	7f 1e                	jg     801ca6 <devfile_write+0x68>
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    
	assert(r <= n);
  801c8d:	68 54 31 80 00       	push   $0x803154
  801c92:	68 5b 31 80 00       	push   $0x80315b
  801c97:	68 98 00 00 00       	push   $0x98
  801c9c:	68 70 31 80 00       	push   $0x803170
  801ca1:	e8 6a 0a 00 00       	call   802710 <_panic>
	assert(r <= PGSIZE);
  801ca6:	68 7b 31 80 00       	push   $0x80317b
  801cab:	68 5b 31 80 00       	push   $0x80315b
  801cb0:	68 99 00 00 00       	push   $0x99
  801cb5:	68 70 31 80 00       	push   $0x803170
  801cba:	e8 51 0a 00 00       	call   802710 <_panic>

00801cbf <devfile_read>:
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cd2:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce2:	e8 65 fe ff ff       	call   801b4c <fsipc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	78 1f                	js     801d0c <devfile_read+0x4d>
	assert(r <= n);
  801ced:	39 f0                	cmp    %esi,%eax
  801cef:	77 24                	ja     801d15 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cf1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cf6:	7f 33                	jg     801d2b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	50                   	push   %eax
  801cfc:	68 00 60 80 00       	push   $0x806000
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	e8 6b ee ff ff       	call   800b74 <memmove>
	return r;
  801d09:	83 c4 10             	add    $0x10,%esp
}
  801d0c:	89 d8                	mov    %ebx,%eax
  801d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
	assert(r <= n);
  801d15:	68 54 31 80 00       	push   $0x803154
  801d1a:	68 5b 31 80 00       	push   $0x80315b
  801d1f:	6a 7c                	push   $0x7c
  801d21:	68 70 31 80 00       	push   $0x803170
  801d26:	e8 e5 09 00 00       	call   802710 <_panic>
	assert(r <= PGSIZE);
  801d2b:	68 7b 31 80 00       	push   $0x80317b
  801d30:	68 5b 31 80 00       	push   $0x80315b
  801d35:	6a 7d                	push   $0x7d
  801d37:	68 70 31 80 00       	push   $0x803170
  801d3c:	e8 cf 09 00 00       	call   802710 <_panic>

00801d41 <open>:
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	56                   	push   %esi
  801d45:	53                   	push   %ebx
  801d46:	83 ec 1c             	sub    $0x1c,%esp
  801d49:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d4c:	56                   	push   %esi
  801d4d:	e8 5b ec ff ff       	call   8009ad <strlen>
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d5a:	7f 6c                	jg     801dc8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d62:	50                   	push   %eax
  801d63:	e8 79 f8 ff ff       	call   8015e1 <fd_alloc>
  801d68:	89 c3                	mov    %eax,%ebx
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 3c                	js     801dad <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d71:	83 ec 08             	sub    $0x8,%esp
  801d74:	56                   	push   %esi
  801d75:	68 00 60 80 00       	push   $0x806000
  801d7a:	e8 67 ec ff ff       	call   8009e6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d82:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	e8 b8 fd ff ff       	call   801b4c <fsipc>
  801d94:	89 c3                	mov    %eax,%ebx
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 19                	js     801db6 <open+0x75>
	return fd2num(fd);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 f4             	pushl  -0xc(%ebp)
  801da3:	e8 12 f8 ff ff       	call   8015ba <fd2num>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	83 c4 10             	add    $0x10,%esp
}
  801dad:	89 d8                	mov    %ebx,%eax
  801daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
		fd_close(fd, 0);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	6a 00                	push   $0x0
  801dbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbe:	e8 1b f9 ff ff       	call   8016de <fd_close>
		return r;
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	eb e5                	jmp    801dad <open+0x6c>
		return -E_BAD_PATH;
  801dc8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801dcd:	eb de                	jmp    801dad <open+0x6c>

00801dcf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dda:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddf:	e8 68 fd ff ff       	call   801b4c <fsipc>
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dec:	68 87 31 80 00       	push   $0x803187
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	e8 ed eb ff ff       	call   8009e6 <strcpy>
	return 0;
}
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <devsock_close>:
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
  801e04:	83 ec 10             	sub    $0x10,%esp
  801e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e0a:	53                   	push   %ebx
  801e0b:	e8 f6 0a 00 00       	call   802906 <pageref>
  801e10:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e13:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e18:	83 f8 01             	cmp    $0x1,%eax
  801e1b:	74 07                	je     801e24 <devsock_close+0x24>
}
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	ff 73 0c             	pushl  0xc(%ebx)
  801e2a:	e8 b9 02 00 00       	call   8020e8 <nsipc_close>
  801e2f:	89 c2                	mov    %eax,%edx
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	eb e7                	jmp    801e1d <devsock_close+0x1d>

00801e36 <devsock_write>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 10             	pushl  0x10(%ebp)
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	ff 70 0c             	pushl  0xc(%eax)
  801e4a:	e8 76 03 00 00       	call   8021c5 <nsipc_send>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <devsock_read>:
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 10             	pushl  0x10(%ebp)
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	ff 70 0c             	pushl  0xc(%eax)
  801e65:	e8 ef 02 00 00       	call   802159 <nsipc_recv>
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <fd2sockid>:
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e72:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e75:	52                   	push   %edx
  801e76:	50                   	push   %eax
  801e77:	e8 b7 f7 ff ff       	call   801633 <fd_lookup>
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	78 10                	js     801e93 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e8c:	39 08                	cmp    %ecx,(%eax)
  801e8e:	75 05                	jne    801e95 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e90:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    
		return -E_NOT_SUPP;
  801e95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9a:	eb f7                	jmp    801e93 <fd2sockid+0x27>

00801e9c <alloc_sockfd>:
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 1c             	sub    $0x1c,%esp
  801ea4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea9:	50                   	push   %eax
  801eaa:	e8 32 f7 ff ff       	call   8015e1 <fd_alloc>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 43                	js     801efb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 07 04 00 00       	push   $0x407
  801ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 0e ef ff ff       	call   800dd8 <sys_page_alloc>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 28                	js     801efb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801edc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ee8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	50                   	push   %eax
  801eef:	e8 c6 f6 ff ff       	call   8015ba <fd2num>
  801ef4:	89 c3                	mov    %eax,%ebx
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	eb 0c                	jmp    801f07 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801efb:	83 ec 0c             	sub    $0xc,%esp
  801efe:	56                   	push   %esi
  801eff:	e8 e4 01 00 00       	call   8020e8 <nsipc_close>
		return r;
  801f04:	83 c4 10             	add    $0x10,%esp
}
  801f07:	89 d8                	mov    %ebx,%eax
  801f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <accept>:
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	e8 4e ff ff ff       	call   801e6c <fd2sockid>
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 1b                	js     801f3d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f22:	83 ec 04             	sub    $0x4,%esp
  801f25:	ff 75 10             	pushl  0x10(%ebp)
  801f28:	ff 75 0c             	pushl  0xc(%ebp)
  801f2b:	50                   	push   %eax
  801f2c:	e8 0e 01 00 00       	call   80203f <nsipc_accept>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	78 05                	js     801f3d <accept+0x2d>
	return alloc_sockfd(r);
  801f38:	e8 5f ff ff ff       	call   801e9c <alloc_sockfd>
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <bind>:
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	e8 1f ff ff ff       	call   801e6c <fd2sockid>
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 12                	js     801f63 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	ff 75 10             	pushl  0x10(%ebp)
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	e8 31 01 00 00       	call   802091 <nsipc_bind>
  801f60:	83 c4 10             	add    $0x10,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <shutdown>:
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	e8 f9 fe ff ff       	call   801e6c <fd2sockid>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 0f                	js     801f86 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	50                   	push   %eax
  801f7e:	e8 43 01 00 00       	call   8020c6 <nsipc_shutdown>
  801f83:	83 c4 10             	add    $0x10,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <connect>:
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	e8 d6 fe ff ff       	call   801e6c <fd2sockid>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 12                	js     801fac <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	ff 75 10             	pushl  0x10(%ebp)
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	50                   	push   %eax
  801fa4:	e8 59 01 00 00       	call   802102 <nsipc_connect>
  801fa9:	83 c4 10             	add    $0x10,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <listen>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	e8 b0 fe ff ff       	call   801e6c <fd2sockid>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 0f                	js     801fcf <listen+0x21>
	return nsipc_listen(r, backlog);
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	ff 75 0c             	pushl  0xc(%ebp)
  801fc6:	50                   	push   %eax
  801fc7:	e8 6b 01 00 00       	call   802137 <nsipc_listen>
  801fcc:	83 c4 10             	add    $0x10,%esp
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fd7:	ff 75 10             	pushl  0x10(%ebp)
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	ff 75 08             	pushl  0x8(%ebp)
  801fe0:	e8 3e 02 00 00       	call   802223 <nsipc_socket>
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 05                	js     801ff1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fec:	e8 ab fe ff ff       	call   801e9c <alloc_sockfd>
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	53                   	push   %ebx
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ffc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802003:	74 26                	je     80202b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802005:	6a 07                	push   $0x7
  802007:	68 00 70 80 00       	push   $0x807000
  80200c:	53                   	push   %ebx
  80200d:	ff 35 04 50 80 00    	pushl  0x805004
  802013:	e8 57 08 00 00       	call   80286f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802018:	83 c4 0c             	add    $0xc,%esp
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	e8 e0 07 00 00       	call   802806 <ipc_recv>
}
  802026:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802029:	c9                   	leave  
  80202a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	6a 02                	push   $0x2
  802030:	e8 92 08 00 00       	call   8028c7 <ipc_find_env>
  802035:	a3 04 50 80 00       	mov    %eax,0x805004
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	eb c6                	jmp    802005 <nsipc+0x12>

0080203f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	56                   	push   %esi
  802043:	53                   	push   %ebx
  802044:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80204f:	8b 06                	mov    (%esi),%eax
  802051:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802056:	b8 01 00 00 00       	mov    $0x1,%eax
  80205b:	e8 93 ff ff ff       	call   801ff3 <nsipc>
  802060:	89 c3                	mov    %eax,%ebx
  802062:	85 c0                	test   %eax,%eax
  802064:	79 09                	jns    80206f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802066:	89 d8                	mov    %ebx,%eax
  802068:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	ff 35 10 70 80 00    	pushl  0x807010
  802078:	68 00 70 80 00       	push   $0x807000
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	e8 ef ea ff ff       	call   800b74 <memmove>
		*addrlen = ret->ret_addrlen;
  802085:	a1 10 70 80 00       	mov    0x807010,%eax
  80208a:	89 06                	mov    %eax,(%esi)
  80208c:	83 c4 10             	add    $0x10,%esp
	return r;
  80208f:	eb d5                	jmp    802066 <nsipc_accept+0x27>

00802091 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	53                   	push   %ebx
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a3:	53                   	push   %ebx
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	68 04 70 80 00       	push   $0x807004
  8020ac:	e8 c3 ea ff ff       	call   800b74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020b1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8020bc:	e8 32 ff ff ff       	call   801ff3 <nsipc>
}
  8020c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e1:	e8 0d ff ff ff       	call   801ff3 <nsipc>
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fb:	e8 f3 fe ff ff       	call   801ff3 <nsipc>
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	53                   	push   %ebx
  802106:	83 ec 08             	sub    $0x8,%esp
  802109:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802114:	53                   	push   %ebx
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	68 04 70 80 00       	push   $0x807004
  80211d:	e8 52 ea ff ff       	call   800b74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802122:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802128:	b8 05 00 00 00       	mov    $0x5,%eax
  80212d:	e8 c1 fe ff ff       	call   801ff3 <nsipc>
}
  802132:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802145:	8b 45 0c             	mov    0xc(%ebp),%eax
  802148:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80214d:	b8 06 00 00 00       	mov    $0x6,%eax
  802152:	e8 9c fe ff ff       	call   801ff3 <nsipc>
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	56                   	push   %esi
  80215d:	53                   	push   %ebx
  80215e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802169:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80216f:	8b 45 14             	mov    0x14(%ebp),%eax
  802172:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802177:	b8 07 00 00 00       	mov    $0x7,%eax
  80217c:	e8 72 fe ff ff       	call   801ff3 <nsipc>
  802181:	89 c3                	mov    %eax,%ebx
  802183:	85 c0                	test   %eax,%eax
  802185:	78 1f                	js     8021a6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802187:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80218c:	7f 21                	jg     8021af <nsipc_recv+0x56>
  80218e:	39 c6                	cmp    %eax,%esi
  802190:	7c 1d                	jl     8021af <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	50                   	push   %eax
  802196:	68 00 70 80 00       	push   $0x807000
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	e8 d1 e9 ff ff       	call   800b74 <memmove>
  8021a3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021a6:	89 d8                	mov    %ebx,%eax
  8021a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5e                   	pop    %esi
  8021ad:	5d                   	pop    %ebp
  8021ae:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021af:	68 93 31 80 00       	push   $0x803193
  8021b4:	68 5b 31 80 00       	push   $0x80315b
  8021b9:	6a 62                	push   $0x62
  8021bb:	68 a8 31 80 00       	push   $0x8031a8
  8021c0:	e8 4b 05 00 00       	call   802710 <_panic>

008021c5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021d7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021dd:	7f 2e                	jg     80220d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	53                   	push   %ebx
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	68 0c 70 80 00       	push   $0x80700c
  8021eb:	e8 84 e9 ff ff       	call   800b74 <memmove>
	nsipcbuf.send.req_size = size;
  8021f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802203:	e8 eb fd ff ff       	call   801ff3 <nsipc>
}
  802208:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    
	assert(size < 1600);
  80220d:	68 b4 31 80 00       	push   $0x8031b4
  802212:	68 5b 31 80 00       	push   $0x80315b
  802217:	6a 6d                	push   $0x6d
  802219:	68 a8 31 80 00       	push   $0x8031a8
  80221e:	e8 ed 04 00 00       	call   802710 <_panic>

00802223 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802231:	8b 45 0c             	mov    0xc(%ebp),%eax
  802234:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802239:	8b 45 10             	mov    0x10(%ebp),%eax
  80223c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802241:	b8 09 00 00 00       	mov    $0x9,%eax
  802246:	e8 a8 fd ff ff       	call   801ff3 <nsipc>
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	e8 6a f3 ff ff       	call   8015ca <fd2data>
  802260:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802262:	83 c4 08             	add    $0x8,%esp
  802265:	68 c0 31 80 00       	push   $0x8031c0
  80226a:	53                   	push   %ebx
  80226b:	e8 76 e7 ff ff       	call   8009e6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802270:	8b 46 04             	mov    0x4(%esi),%eax
  802273:	2b 06                	sub    (%esi),%eax
  802275:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80227b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802282:	00 00 00 
	stat->st_dev = &devpipe;
  802285:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80228c:	40 80 00 
	return 0;
}
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	53                   	push   %ebx
  80229f:	83 ec 0c             	sub    $0xc,%esp
  8022a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022a5:	53                   	push   %ebx
  8022a6:	6a 00                	push   $0x0
  8022a8:	e8 b0 eb ff ff       	call   800e5d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022ad:	89 1c 24             	mov    %ebx,(%esp)
  8022b0:	e8 15 f3 ff ff       	call   8015ca <fd2data>
  8022b5:	83 c4 08             	add    $0x8,%esp
  8022b8:	50                   	push   %eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	e8 9d eb ff ff       	call   800e5d <sys_page_unmap>
}
  8022c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <_pipeisclosed>:
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	57                   	push   %edi
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 1c             	sub    $0x1c,%esp
  8022ce:	89 c7                	mov    %eax,%edi
  8022d0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022d2:	a1 08 50 80 00       	mov    0x805008,%eax
  8022d7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	57                   	push   %edi
  8022de:	e8 23 06 00 00       	call   802906 <pageref>
  8022e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022e6:	89 34 24             	mov    %esi,(%esp)
  8022e9:	e8 18 06 00 00       	call   802906 <pageref>
		nn = thisenv->env_runs;
  8022ee:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8022f4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	39 cb                	cmp    %ecx,%ebx
  8022fc:	74 1b                	je     802319 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802301:	75 cf                	jne    8022d2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802303:	8b 42 58             	mov    0x58(%edx),%eax
  802306:	6a 01                	push   $0x1
  802308:	50                   	push   %eax
  802309:	53                   	push   %ebx
  80230a:	68 c7 31 80 00       	push   $0x8031c7
  80230f:	e8 73 df ff ff       	call   800287 <cprintf>
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	eb b9                	jmp    8022d2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802319:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80231c:	0f 94 c0             	sete   %al
  80231f:	0f b6 c0             	movzbl %al,%eax
}
  802322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    

0080232a <devpipe_write>:
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	57                   	push   %edi
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	83 ec 28             	sub    $0x28,%esp
  802333:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802336:	56                   	push   %esi
  802337:	e8 8e f2 ff ff       	call   8015ca <fd2data>
  80233c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	bf 00 00 00 00       	mov    $0x0,%edi
  802346:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802349:	74 4f                	je     80239a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80234b:	8b 43 04             	mov    0x4(%ebx),%eax
  80234e:	8b 0b                	mov    (%ebx),%ecx
  802350:	8d 51 20             	lea    0x20(%ecx),%edx
  802353:	39 d0                	cmp    %edx,%eax
  802355:	72 14                	jb     80236b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802357:	89 da                	mov    %ebx,%edx
  802359:	89 f0                	mov    %esi,%eax
  80235b:	e8 65 ff ff ff       	call   8022c5 <_pipeisclosed>
  802360:	85 c0                	test   %eax,%eax
  802362:	75 3b                	jne    80239f <devpipe_write+0x75>
			sys_yield();
  802364:	e8 50 ea ff ff       	call   800db9 <sys_yield>
  802369:	eb e0                	jmp    80234b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80236b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80236e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802372:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802375:	89 c2                	mov    %eax,%edx
  802377:	c1 fa 1f             	sar    $0x1f,%edx
  80237a:	89 d1                	mov    %edx,%ecx
  80237c:	c1 e9 1b             	shr    $0x1b,%ecx
  80237f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802382:	83 e2 1f             	and    $0x1f,%edx
  802385:	29 ca                	sub    %ecx,%edx
  802387:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80238b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80238f:	83 c0 01             	add    $0x1,%eax
  802392:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802395:	83 c7 01             	add    $0x1,%edi
  802398:	eb ac                	jmp    802346 <devpipe_write+0x1c>
	return i;
  80239a:	8b 45 10             	mov    0x10(%ebp),%eax
  80239d:	eb 05                	jmp    8023a4 <devpipe_write+0x7a>
				return 0;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5f                   	pop    %edi
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    

008023ac <devpipe_read>:
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	57                   	push   %edi
  8023b0:	56                   	push   %esi
  8023b1:	53                   	push   %ebx
  8023b2:	83 ec 18             	sub    $0x18,%esp
  8023b5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023b8:	57                   	push   %edi
  8023b9:	e8 0c f2 ff ff       	call   8015ca <fd2data>
  8023be:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023c0:	83 c4 10             	add    $0x10,%esp
  8023c3:	be 00 00 00 00       	mov    $0x0,%esi
  8023c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023cb:	75 14                	jne    8023e1 <devpipe_read+0x35>
	return i;
  8023cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d0:	eb 02                	jmp    8023d4 <devpipe_read+0x28>
				return i;
  8023d2:	89 f0                	mov    %esi,%eax
}
  8023d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    
			sys_yield();
  8023dc:	e8 d8 e9 ff ff       	call   800db9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023e1:	8b 03                	mov    (%ebx),%eax
  8023e3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023e6:	75 18                	jne    802400 <devpipe_read+0x54>
			if (i > 0)
  8023e8:	85 f6                	test   %esi,%esi
  8023ea:	75 e6                	jne    8023d2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023ec:	89 da                	mov    %ebx,%edx
  8023ee:	89 f8                	mov    %edi,%eax
  8023f0:	e8 d0 fe ff ff       	call   8022c5 <_pipeisclosed>
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 e3                	je     8023dc <devpipe_read+0x30>
				return 0;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fe:	eb d4                	jmp    8023d4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802400:	99                   	cltd   
  802401:	c1 ea 1b             	shr    $0x1b,%edx
  802404:	01 d0                	add    %edx,%eax
  802406:	83 e0 1f             	and    $0x1f,%eax
  802409:	29 d0                	sub    %edx,%eax
  80240b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802413:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802416:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802419:	83 c6 01             	add    $0x1,%esi
  80241c:	eb aa                	jmp    8023c8 <devpipe_read+0x1c>

0080241e <pipe>:
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	56                   	push   %esi
  802422:	53                   	push   %ebx
  802423:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802426:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802429:	50                   	push   %eax
  80242a:	e8 b2 f1 ff ff       	call   8015e1 <fd_alloc>
  80242f:	89 c3                	mov    %eax,%ebx
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	85 c0                	test   %eax,%eax
  802436:	0f 88 23 01 00 00    	js     80255f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 07 04 00 00       	push   $0x407
  802444:	ff 75 f4             	pushl  -0xc(%ebp)
  802447:	6a 00                	push   $0x0
  802449:	e8 8a e9 ff ff       	call   800dd8 <sys_page_alloc>
  80244e:	89 c3                	mov    %eax,%ebx
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 88 04 01 00 00    	js     80255f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80245b:	83 ec 0c             	sub    $0xc,%esp
  80245e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802461:	50                   	push   %eax
  802462:	e8 7a f1 ff ff       	call   8015e1 <fd_alloc>
  802467:	89 c3                	mov    %eax,%ebx
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	85 c0                	test   %eax,%eax
  80246e:	0f 88 db 00 00 00    	js     80254f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802474:	83 ec 04             	sub    $0x4,%esp
  802477:	68 07 04 00 00       	push   $0x407
  80247c:	ff 75 f0             	pushl  -0x10(%ebp)
  80247f:	6a 00                	push   $0x0
  802481:	e8 52 e9 ff ff       	call   800dd8 <sys_page_alloc>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	85 c0                	test   %eax,%eax
  80248d:	0f 88 bc 00 00 00    	js     80254f <pipe+0x131>
	va = fd2data(fd0);
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	ff 75 f4             	pushl  -0xc(%ebp)
  802499:	e8 2c f1 ff ff       	call   8015ca <fd2data>
  80249e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a0:	83 c4 0c             	add    $0xc,%esp
  8024a3:	68 07 04 00 00       	push   $0x407
  8024a8:	50                   	push   %eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	e8 28 e9 ff ff       	call   800dd8 <sys_page_alloc>
  8024b0:	89 c3                	mov    %eax,%ebx
  8024b2:	83 c4 10             	add    $0x10,%esp
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	0f 88 82 00 00 00    	js     80253f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bd:	83 ec 0c             	sub    $0xc,%esp
  8024c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c3:	e8 02 f1 ff ff       	call   8015ca <fd2data>
  8024c8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024cf:	50                   	push   %eax
  8024d0:	6a 00                	push   $0x0
  8024d2:	56                   	push   %esi
  8024d3:	6a 00                	push   $0x0
  8024d5:	e8 41 e9 ff ff       	call   800e1b <sys_page_map>
  8024da:	89 c3                	mov    %eax,%ebx
  8024dc:	83 c4 20             	add    $0x20,%esp
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	78 4e                	js     802531 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024e3:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024eb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	ff 75 f4             	pushl  -0xc(%ebp)
  80250c:	e8 a9 f0 ff ff       	call   8015ba <fd2num>
  802511:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802514:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802516:	83 c4 04             	add    $0x4,%esp
  802519:	ff 75 f0             	pushl  -0x10(%ebp)
  80251c:	e8 99 f0 ff ff       	call   8015ba <fd2num>
  802521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802524:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802527:	83 c4 10             	add    $0x10,%esp
  80252a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80252f:	eb 2e                	jmp    80255f <pipe+0x141>
	sys_page_unmap(0, va);
  802531:	83 ec 08             	sub    $0x8,%esp
  802534:	56                   	push   %esi
  802535:	6a 00                	push   $0x0
  802537:	e8 21 e9 ff ff       	call   800e5d <sys_page_unmap>
  80253c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80253f:	83 ec 08             	sub    $0x8,%esp
  802542:	ff 75 f0             	pushl  -0x10(%ebp)
  802545:	6a 00                	push   $0x0
  802547:	e8 11 e9 ff ff       	call   800e5d <sys_page_unmap>
  80254c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80254f:	83 ec 08             	sub    $0x8,%esp
  802552:	ff 75 f4             	pushl  -0xc(%ebp)
  802555:	6a 00                	push   $0x0
  802557:	e8 01 e9 ff ff       	call   800e5d <sys_page_unmap>
  80255c:	83 c4 10             	add    $0x10,%esp
}
  80255f:	89 d8                	mov    %ebx,%eax
  802561:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802564:	5b                   	pop    %ebx
  802565:	5e                   	pop    %esi
  802566:	5d                   	pop    %ebp
  802567:	c3                   	ret    

00802568 <pipeisclosed>:
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802571:	50                   	push   %eax
  802572:	ff 75 08             	pushl  0x8(%ebp)
  802575:	e8 b9 f0 ff ff       	call   801633 <fd_lookup>
  80257a:	83 c4 10             	add    $0x10,%esp
  80257d:	85 c0                	test   %eax,%eax
  80257f:	78 18                	js     802599 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	ff 75 f4             	pushl  -0xc(%ebp)
  802587:	e8 3e f0 ff ff       	call   8015ca <fd2data>
	return _pipeisclosed(fd, p);
  80258c:	89 c2                	mov    %eax,%edx
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	e8 2f fd ff ff       	call   8022c5 <_pipeisclosed>
  802596:	83 c4 10             	add    $0x10,%esp
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	c3                   	ret    

008025a1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025a7:	68 df 31 80 00       	push   $0x8031df
  8025ac:	ff 75 0c             	pushl  0xc(%ebp)
  8025af:	e8 32 e4 ff ff       	call   8009e6 <strcpy>
	return 0;
}
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <devcons_write>:
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	57                   	push   %edi
  8025bf:	56                   	push   %esi
  8025c0:	53                   	push   %ebx
  8025c1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025c7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025cc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025d2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025d5:	73 31                	jae    802608 <devcons_write+0x4d>
		m = n - tot;
  8025d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025da:	29 f3                	sub    %esi,%ebx
  8025dc:	83 fb 7f             	cmp    $0x7f,%ebx
  8025df:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025e4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	53                   	push   %ebx
  8025eb:	89 f0                	mov    %esi,%eax
  8025ed:	03 45 0c             	add    0xc(%ebp),%eax
  8025f0:	50                   	push   %eax
  8025f1:	57                   	push   %edi
  8025f2:	e8 7d e5 ff ff       	call   800b74 <memmove>
		sys_cputs(buf, m);
  8025f7:	83 c4 08             	add    $0x8,%esp
  8025fa:	53                   	push   %ebx
  8025fb:	57                   	push   %edi
  8025fc:	e8 1b e7 ff ff       	call   800d1c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802601:	01 de                	add    %ebx,%esi
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	eb ca                	jmp    8025d2 <devcons_write+0x17>
}
  802608:	89 f0                	mov    %esi,%eax
  80260a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5e                   	pop    %esi
  80260f:	5f                   	pop    %edi
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    

00802612 <devcons_read>:
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 08             	sub    $0x8,%esp
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80261d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802621:	74 21                	je     802644 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802623:	e8 12 e7 ff ff       	call   800d3a <sys_cgetc>
  802628:	85 c0                	test   %eax,%eax
  80262a:	75 07                	jne    802633 <devcons_read+0x21>
		sys_yield();
  80262c:	e8 88 e7 ff ff       	call   800db9 <sys_yield>
  802631:	eb f0                	jmp    802623 <devcons_read+0x11>
	if (c < 0)
  802633:	78 0f                	js     802644 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802635:	83 f8 04             	cmp    $0x4,%eax
  802638:	74 0c                	je     802646 <devcons_read+0x34>
	*(char*)vbuf = c;
  80263a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263d:	88 02                	mov    %al,(%edx)
	return 1;
  80263f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    
		return 0;
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
  80264b:	eb f7                	jmp    802644 <devcons_read+0x32>

0080264d <cputchar>:
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802659:	6a 01                	push   $0x1
  80265b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80265e:	50                   	push   %eax
  80265f:	e8 b8 e6 ff ff       	call   800d1c <sys_cputs>
}
  802664:	83 c4 10             	add    $0x10,%esp
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <getchar>:
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80266f:	6a 01                	push   $0x1
  802671:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802674:	50                   	push   %eax
  802675:	6a 00                	push   $0x0
  802677:	e8 27 f2 ff ff       	call   8018a3 <read>
	if (r < 0)
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 06                	js     802689 <getchar+0x20>
	if (r < 1)
  802683:	74 06                	je     80268b <getchar+0x22>
	return c;
  802685:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    
		return -E_EOF;
  80268b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802690:	eb f7                	jmp    802689 <getchar+0x20>

00802692 <iscons>:
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269b:	50                   	push   %eax
  80269c:	ff 75 08             	pushl  0x8(%ebp)
  80269f:	e8 8f ef ff ff       	call   801633 <fd_lookup>
  8026a4:	83 c4 10             	add    $0x10,%esp
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	78 11                	js     8026bc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026b4:	39 10                	cmp    %edx,(%eax)
  8026b6:	0f 94 c0             	sete   %al
  8026b9:	0f b6 c0             	movzbl %al,%eax
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <opencons>:
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c7:	50                   	push   %eax
  8026c8:	e8 14 ef ff ff       	call   8015e1 <fd_alloc>
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	78 3a                	js     80270e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 07 04 00 00       	push   $0x407
  8026dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026df:	6a 00                	push   $0x0
  8026e1:	e8 f2 e6 ff ff       	call   800dd8 <sys_page_alloc>
  8026e6:	83 c4 10             	add    $0x10,%esp
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	78 21                	js     80270e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026f6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802702:	83 ec 0c             	sub    $0xc,%esp
  802705:	50                   	push   %eax
  802706:	e8 af ee ff ff       	call   8015ba <fd2num>
  80270b:	83 c4 10             	add    $0x10,%esp
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	56                   	push   %esi
  802714:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802715:	a1 08 50 80 00       	mov    0x805008,%eax
  80271a:	8b 40 48             	mov    0x48(%eax),%eax
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	68 10 32 80 00       	push   $0x803210
  802725:	50                   	push   %eax
  802726:	68 0e 2c 80 00       	push   $0x802c0e
  80272b:	e8 57 db ff ff       	call   800287 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802730:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802733:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802739:	e8 5c e6 ff ff       	call   800d9a <sys_getenvid>
  80273e:	83 c4 04             	add    $0x4,%esp
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	ff 75 08             	pushl  0x8(%ebp)
  802747:	56                   	push   %esi
  802748:	50                   	push   %eax
  802749:	68 ec 31 80 00       	push   $0x8031ec
  80274e:	e8 34 db ff ff       	call   800287 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802753:	83 c4 18             	add    $0x18,%esp
  802756:	53                   	push   %ebx
  802757:	ff 75 10             	pushl  0x10(%ebp)
  80275a:	e8 d7 da ff ff       	call   800236 <vcprintf>
	cprintf("\n");
  80275f:	c7 04 24 d2 2b 80 00 	movl   $0x802bd2,(%esp)
  802766:	e8 1c db ff ff       	call   800287 <cprintf>
  80276b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80276e:	cc                   	int3   
  80276f:	eb fd                	jmp    80276e <_panic+0x5e>

00802771 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802777:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80277e:	74 0a                	je     80278a <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	6a 07                	push   $0x7
  80278f:	68 00 f0 bf ee       	push   $0xeebff000
  802794:	6a 00                	push   $0x0
  802796:	e8 3d e6 ff ff       	call   800dd8 <sys_page_alloc>
		if(r < 0)
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	78 2a                	js     8027cc <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027a2:	83 ec 08             	sub    $0x8,%esp
  8027a5:	68 e0 27 80 00       	push   $0x8027e0
  8027aa:	6a 00                	push   $0x0
  8027ac:	e8 72 e7 ff ff       	call   800f23 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027b1:	83 c4 10             	add    $0x10,%esp
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	79 c8                	jns    802780 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 48 32 80 00       	push   $0x803248
  8027c0:	6a 25                	push   $0x25
  8027c2:	68 84 32 80 00       	push   $0x803284
  8027c7:	e8 44 ff ff ff       	call   802710 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027cc:	83 ec 04             	sub    $0x4,%esp
  8027cf:	68 18 32 80 00       	push   $0x803218
  8027d4:	6a 22                	push   $0x22
  8027d6:	68 84 32 80 00       	push   $0x803284
  8027db:	e8 30 ff ff ff       	call   802710 <_panic>

008027e0 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027e0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027e1:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027e6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027e8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027eb:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027ef:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027f3:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027f6:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027f8:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027fc:	83 c4 08             	add    $0x8,%esp
	popal
  8027ff:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802800:	83 c4 04             	add    $0x4,%esp
	popfl
  802803:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802804:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802805:	c3                   	ret    

00802806 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	56                   	push   %esi
  80280a:	53                   	push   %ebx
  80280b:	8b 75 08             	mov    0x8(%ebp),%esi
  80280e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802811:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802814:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802816:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80281b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80281e:	83 ec 0c             	sub    $0xc,%esp
  802821:	50                   	push   %eax
  802822:	e8 61 e7 ff ff       	call   800f88 <sys_ipc_recv>
	if(ret < 0){
  802827:	83 c4 10             	add    $0x10,%esp
  80282a:	85 c0                	test   %eax,%eax
  80282c:	78 2b                	js     802859 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80282e:	85 f6                	test   %esi,%esi
  802830:	74 0a                	je     80283c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802832:	a1 08 50 80 00       	mov    0x805008,%eax
  802837:	8b 40 78             	mov    0x78(%eax),%eax
  80283a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80283c:	85 db                	test   %ebx,%ebx
  80283e:	74 0a                	je     80284a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802840:	a1 08 50 80 00       	mov    0x805008,%eax
  802845:	8b 40 7c             	mov    0x7c(%eax),%eax
  802848:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80284a:	a1 08 50 80 00       	mov    0x805008,%eax
  80284f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802852:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802855:	5b                   	pop    %ebx
  802856:	5e                   	pop    %esi
  802857:	5d                   	pop    %ebp
  802858:	c3                   	ret    
		if(from_env_store)
  802859:	85 f6                	test   %esi,%esi
  80285b:	74 06                	je     802863 <ipc_recv+0x5d>
			*from_env_store = 0;
  80285d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802863:	85 db                	test   %ebx,%ebx
  802865:	74 eb                	je     802852 <ipc_recv+0x4c>
			*perm_store = 0;
  802867:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80286d:	eb e3                	jmp    802852 <ipc_recv+0x4c>

0080286f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	57                   	push   %edi
  802873:	56                   	push   %esi
  802874:	53                   	push   %ebx
  802875:	83 ec 0c             	sub    $0xc,%esp
  802878:	8b 7d 08             	mov    0x8(%ebp),%edi
  80287b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80287e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802881:	85 db                	test   %ebx,%ebx
  802883:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802888:	0f 44 d8             	cmove  %eax,%ebx
  80288b:	eb 05                	jmp    802892 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80288d:	e8 27 e5 ff ff       	call   800db9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802892:	ff 75 14             	pushl  0x14(%ebp)
  802895:	53                   	push   %ebx
  802896:	56                   	push   %esi
  802897:	57                   	push   %edi
  802898:	e8 c8 e6 ff ff       	call   800f65 <sys_ipc_try_send>
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 1b                	je     8028bf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028a4:	79 e7                	jns    80288d <ipc_send+0x1e>
  8028a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028a9:	74 e2                	je     80288d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 92 32 80 00       	push   $0x803292
  8028b3:	6a 46                	push   $0x46
  8028b5:	68 a7 32 80 00       	push   $0x8032a7
  8028ba:	e8 51 fe ff ff       	call   802710 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028c2:	5b                   	pop    %ebx
  8028c3:	5e                   	pop    %esi
  8028c4:	5f                   	pop    %edi
  8028c5:	5d                   	pop    %ebp
  8028c6:	c3                   	ret    

008028c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028c7:	55                   	push   %ebp
  8028c8:	89 e5                	mov    %esp,%ebp
  8028ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028d2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8028d8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028de:	8b 52 50             	mov    0x50(%edx),%edx
  8028e1:	39 ca                	cmp    %ecx,%edx
  8028e3:	74 11                	je     8028f6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8028e5:	83 c0 01             	add    $0x1,%eax
  8028e8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028ed:	75 e3                	jne    8028d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	eb 0e                	jmp    802904 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8028f6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8028fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802901:	8b 40 48             	mov    0x48(%eax),%eax
}
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    

00802906 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80290c:	89 d0                	mov    %edx,%eax
  80290e:	c1 e8 16             	shr    $0x16,%eax
  802911:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802918:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80291d:	f6 c1 01             	test   $0x1,%cl
  802920:	74 1d                	je     80293f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802922:	c1 ea 0c             	shr    $0xc,%edx
  802925:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80292c:	f6 c2 01             	test   $0x1,%dl
  80292f:	74 0e                	je     80293f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802931:	c1 ea 0c             	shr    $0xc,%edx
  802934:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80293b:	ef 
  80293c:	0f b7 c0             	movzwl %ax,%eax
}
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	66 90                	xchg   %ax,%ax
  802943:	66 90                	xchg   %ax,%ax
  802945:	66 90                	xchg   %ax,%ax
  802947:	66 90                	xchg   %ax,%ax
  802949:	66 90                	xchg   %ax,%ax
  80294b:	66 90                	xchg   %ax,%ax
  80294d:	66 90                	xchg   %ax,%ax
  80294f:	90                   	nop

00802950 <__udivdi3>:
  802950:	55                   	push   %ebp
  802951:	57                   	push   %edi
  802952:	56                   	push   %esi
  802953:	53                   	push   %ebx
  802954:	83 ec 1c             	sub    $0x1c,%esp
  802957:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80295b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80295f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802963:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802967:	85 d2                	test   %edx,%edx
  802969:	75 4d                	jne    8029b8 <__udivdi3+0x68>
  80296b:	39 f3                	cmp    %esi,%ebx
  80296d:	76 19                	jbe    802988 <__udivdi3+0x38>
  80296f:	31 ff                	xor    %edi,%edi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f2                	mov    %esi,%edx
  802975:	f7 f3                	div    %ebx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	89 d9                	mov    %ebx,%ecx
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	75 0b                	jne    802999 <__udivdi3+0x49>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	31 d2                	xor    %edx,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 c1                	mov    %eax,%ecx
  802999:	31 d2                	xor    %edx,%edx
  80299b:	89 f0                	mov    %esi,%eax
  80299d:	f7 f1                	div    %ecx
  80299f:	89 c6                	mov    %eax,%esi
  8029a1:	89 e8                	mov    %ebp,%eax
  8029a3:	89 f7                	mov    %esi,%edi
  8029a5:	f7 f1                	div    %ecx
  8029a7:	89 fa                	mov    %edi,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	77 1c                	ja     8029d8 <__udivdi3+0x88>
  8029bc:	0f bd fa             	bsr    %edx,%edi
  8029bf:	83 f7 1f             	xor    $0x1f,%edi
  8029c2:	75 2c                	jne    8029f0 <__udivdi3+0xa0>
  8029c4:	39 f2                	cmp    %esi,%edx
  8029c6:	72 06                	jb     8029ce <__udivdi3+0x7e>
  8029c8:	31 c0                	xor    %eax,%eax
  8029ca:	39 eb                	cmp    %ebp,%ebx
  8029cc:	77 a9                	ja     802977 <__udivdi3+0x27>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	eb a2                	jmp    802977 <__udivdi3+0x27>
  8029d5:	8d 76 00             	lea    0x0(%esi),%esi
  8029d8:	31 ff                	xor    %edi,%edi
  8029da:	31 c0                	xor    %eax,%eax
  8029dc:	89 fa                	mov    %edi,%edx
  8029de:	83 c4 1c             	add    $0x1c,%esp
  8029e1:	5b                   	pop    %ebx
  8029e2:	5e                   	pop    %esi
  8029e3:	5f                   	pop    %edi
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
  8029e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	89 f9                	mov    %edi,%ecx
  8029f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029f7:	29 f8                	sub    %edi,%eax
  8029f9:	d3 e2                	shl    %cl,%edx
  8029fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ff:	89 c1                	mov    %eax,%ecx
  802a01:	89 da                	mov    %ebx,%edx
  802a03:	d3 ea                	shr    %cl,%edx
  802a05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a09:	09 d1                	or     %edx,%ecx
  802a0b:	89 f2                	mov    %esi,%edx
  802a0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a11:	89 f9                	mov    %edi,%ecx
  802a13:	d3 e3                	shl    %cl,%ebx
  802a15:	89 c1                	mov    %eax,%ecx
  802a17:	d3 ea                	shr    %cl,%edx
  802a19:	89 f9                	mov    %edi,%ecx
  802a1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a1f:	89 eb                	mov    %ebp,%ebx
  802a21:	d3 e6                	shl    %cl,%esi
  802a23:	89 c1                	mov    %eax,%ecx
  802a25:	d3 eb                	shr    %cl,%ebx
  802a27:	09 de                	or     %ebx,%esi
  802a29:	89 f0                	mov    %esi,%eax
  802a2b:	f7 74 24 08          	divl   0x8(%esp)
  802a2f:	89 d6                	mov    %edx,%esi
  802a31:	89 c3                	mov    %eax,%ebx
  802a33:	f7 64 24 0c          	mull   0xc(%esp)
  802a37:	39 d6                	cmp    %edx,%esi
  802a39:	72 15                	jb     802a50 <__udivdi3+0x100>
  802a3b:	89 f9                	mov    %edi,%ecx
  802a3d:	d3 e5                	shl    %cl,%ebp
  802a3f:	39 c5                	cmp    %eax,%ebp
  802a41:	73 04                	jae    802a47 <__udivdi3+0xf7>
  802a43:	39 d6                	cmp    %edx,%esi
  802a45:	74 09                	je     802a50 <__udivdi3+0x100>
  802a47:	89 d8                	mov    %ebx,%eax
  802a49:	31 ff                	xor    %edi,%edi
  802a4b:	e9 27 ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a53:	31 ff                	xor    %edi,%edi
  802a55:	e9 1d ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	66 90                	xchg   %ax,%ax
  802a5e:	66 90                	xchg   %ax,%ax

00802a60 <__umoddi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	53                   	push   %ebx
  802a64:	83 ec 1c             	sub    $0x1c,%esp
  802a67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a77:	89 da                	mov    %ebx,%edx
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	75 43                	jne    802ac0 <__umoddi3+0x60>
  802a7d:	39 df                	cmp    %ebx,%edi
  802a7f:	76 17                	jbe    802a98 <__umoddi3+0x38>
  802a81:	89 f0                	mov    %esi,%eax
  802a83:	f7 f7                	div    %edi
  802a85:	89 d0                	mov    %edx,%eax
  802a87:	31 d2                	xor    %edx,%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	89 fd                	mov    %edi,%ebp
  802a9a:	85 ff                	test   %edi,%edi
  802a9c:	75 0b                	jne    802aa9 <__umoddi3+0x49>
  802a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f7                	div    %edi
  802aa7:	89 c5                	mov    %eax,%ebp
  802aa9:	89 d8                	mov    %ebx,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	f7 f5                	div    %ebp
  802aaf:	89 f0                	mov    %esi,%eax
  802ab1:	f7 f5                	div    %ebp
  802ab3:	89 d0                	mov    %edx,%eax
  802ab5:	eb d0                	jmp    802a87 <__umoddi3+0x27>
  802ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802abe:	66 90                	xchg   %ax,%ax
  802ac0:	89 f1                	mov    %esi,%ecx
  802ac2:	39 d8                	cmp    %ebx,%eax
  802ac4:	76 0a                	jbe    802ad0 <__umoddi3+0x70>
  802ac6:	89 f0                	mov    %esi,%eax
  802ac8:	83 c4 1c             	add    $0x1c,%esp
  802acb:	5b                   	pop    %ebx
  802acc:	5e                   	pop    %esi
  802acd:	5f                   	pop    %edi
  802ace:	5d                   	pop    %ebp
  802acf:	c3                   	ret    
  802ad0:	0f bd e8             	bsr    %eax,%ebp
  802ad3:	83 f5 1f             	xor    $0x1f,%ebp
  802ad6:	75 20                	jne    802af8 <__umoddi3+0x98>
  802ad8:	39 d8                	cmp    %ebx,%eax
  802ada:	0f 82 b0 00 00 00    	jb     802b90 <__umoddi3+0x130>
  802ae0:	39 f7                	cmp    %esi,%edi
  802ae2:	0f 86 a8 00 00 00    	jbe    802b90 <__umoddi3+0x130>
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	83 c4 1c             	add    $0x1c,%esp
  802aed:	5b                   	pop    %ebx
  802aee:	5e                   	pop    %esi
  802aef:	5f                   	pop    %edi
  802af0:	5d                   	pop    %ebp
  802af1:	c3                   	ret    
  802af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aff:	29 ea                	sub    %ebp,%edx
  802b01:	d3 e0                	shl    %cl,%eax
  802b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b07:	89 d1                	mov    %edx,%ecx
  802b09:	89 f8                	mov    %edi,%eax
  802b0b:	d3 e8                	shr    %cl,%eax
  802b0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b19:	09 c1                	or     %eax,%ecx
  802b1b:	89 d8                	mov    %ebx,%eax
  802b1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b21:	89 e9                	mov    %ebp,%ecx
  802b23:	d3 e7                	shl    %cl,%edi
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	d3 e8                	shr    %cl,%eax
  802b29:	89 e9                	mov    %ebp,%ecx
  802b2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b2f:	d3 e3                	shl    %cl,%ebx
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	89 d1                	mov    %edx,%ecx
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	d3 e8                	shr    %cl,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	89 fa                	mov    %edi,%edx
  802b3d:	d3 e6                	shl    %cl,%esi
  802b3f:	09 d8                	or     %ebx,%eax
  802b41:	f7 74 24 08          	divl   0x8(%esp)
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	89 f3                	mov    %esi,%ebx
  802b49:	f7 64 24 0c          	mull   0xc(%esp)
  802b4d:	89 c6                	mov    %eax,%esi
  802b4f:	89 d7                	mov    %edx,%edi
  802b51:	39 d1                	cmp    %edx,%ecx
  802b53:	72 06                	jb     802b5b <__umoddi3+0xfb>
  802b55:	75 10                	jne    802b67 <__umoddi3+0x107>
  802b57:	39 c3                	cmp    %eax,%ebx
  802b59:	73 0c                	jae    802b67 <__umoddi3+0x107>
  802b5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b63:	89 d7                	mov    %edx,%edi
  802b65:	89 c6                	mov    %eax,%esi
  802b67:	89 ca                	mov    %ecx,%edx
  802b69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b6e:	29 f3                	sub    %esi,%ebx
  802b70:	19 fa                	sbb    %edi,%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	d3 e0                	shl    %cl,%eax
  802b76:	89 e9                	mov    %ebp,%ecx
  802b78:	d3 eb                	shr    %cl,%ebx
  802b7a:	d3 ea                	shr    %cl,%edx
  802b7c:	09 d8                	or     %ebx,%eax
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 da                	mov    %ebx,%edx
  802b92:	29 fe                	sub    %edi,%esi
  802b94:	19 c2                	sbb    %eax,%edx
  802b96:	89 f1                	mov    %esi,%ecx
  802b98:	89 c8                	mov    %ecx,%eax
  802b9a:	e9 4b ff ff ff       	jmp    802aea <__umoddi3+0x8a>
