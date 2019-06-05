
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
  80003d:	e8 56 0d 00 00       	call   800d98 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 80 2b 80 00       	push   $0x802b80
  80004c:	e8 34 02 00 00       	call   800285 <cprintf>

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
  80007e:	e8 28 09 00 00       	call   8009ab <strlen>
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
  80009c:	68 91 2b 80 00       	push   $0x802b91
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 e5 08 00 00       	call   800991 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 73 13 00 00       	call   801427 <sfork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 f3 00 00 00       	call   8001bc <exit>
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
  8000d4:	68 b3 2b 80 00       	push   $0x802bb3
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
  8000f6:	e8 9d 0c 00 00       	call   800d98 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015a:	a1 08 50 80 00       	mov    0x805008,%eax
  80015f:	8b 40 48             	mov    0x48(%eax),%eax
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	50                   	push   %eax
  800166:	68 96 2b 80 00       	push   $0x802b96
  80016b:	e8 15 01 00 00       	call   800285 <cprintf>
	cprintf("before umain\n");
  800170:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800177:	e8 09 01 00 00       	call   800285 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017c:	83 c4 08             	add    $0x8,%esp
  80017f:	ff 75 0c             	pushl  0xc(%ebp)
  800182:	ff 75 08             	pushl  0x8(%ebp)
  800185:	e8 44 ff ff ff       	call   8000ce <umain>
	cprintf("after umain\n");
  80018a:	c7 04 24 c2 2b 80 00 	movl   $0x802bc2,(%esp)
  800191:	e8 ef 00 00 00       	call   800285 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800196:	a1 08 50 80 00       	mov    0x805008,%eax
  80019b:	8b 40 48             	mov    0x48(%eax),%eax
  80019e:	83 c4 08             	add    $0x8,%esp
  8001a1:	50                   	push   %eax
  8001a2:	68 cf 2b 80 00       	push   $0x802bcf
  8001a7:	e8 d9 00 00 00       	call   800285 <cprintf>
	// exit gracefully
	exit();
  8001ac:	e8 0b 00 00 00       	call   8001bc <exit>
}
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c7:	8b 40 48             	mov    0x48(%eax),%eax
  8001ca:	68 fc 2b 80 00       	push   $0x802bfc
  8001cf:	50                   	push   %eax
  8001d0:	68 ee 2b 80 00       	push   $0x802bee
  8001d5:	e8 ab 00 00 00       	call   800285 <cprintf>
	close_all();
  8001da:	e8 8b 15 00 00       	call   80176a <close_all>
	sys_env_destroy(0);
  8001df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e6:	e8 6c 0b 00 00       	call   800d57 <sys_env_destroy>
}
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	53                   	push   %ebx
  8001f4:	83 ec 04             	sub    $0x4,%esp
  8001f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001fa:	8b 13                	mov    (%ebx),%edx
  8001fc:	8d 42 01             	lea    0x1(%edx),%eax
  8001ff:	89 03                	mov    %eax,(%ebx)
  800201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800204:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800208:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020d:	74 09                	je     800218 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800216:	c9                   	leave  
  800217:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	68 ff 00 00 00       	push   $0xff
  800220:	8d 43 08             	lea    0x8(%ebx),%eax
  800223:	50                   	push   %eax
  800224:	e8 f1 0a 00 00       	call   800d1a <sys_cputs>
		b->idx = 0;
  800229:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	eb db                	jmp    80020f <putch+0x1f>

00800234 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800244:	00 00 00 
	b.cnt = 0;
  800247:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800251:	ff 75 0c             	pushl  0xc(%ebp)
  800254:	ff 75 08             	pushl  0x8(%ebp)
  800257:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025d:	50                   	push   %eax
  80025e:	68 f0 01 80 00       	push   $0x8001f0
  800263:	e8 4a 01 00 00       	call   8003b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800268:	83 c4 08             	add    $0x8,%esp
  80026b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800271:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800277:	50                   	push   %eax
  800278:	e8 9d 0a 00 00       	call   800d1a <sys_cputs>

	return b.cnt;
}
  80027d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80028e:	50                   	push   %eax
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 9d ff ff ff       	call   800234 <vcprintf>
	va_end(ap);

	return cnt;
}
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 1c             	sub    $0x1c,%esp
  8002a2:	89 c6                	mov    %eax,%esi
  8002a4:	89 d7                	mov    %edx,%edi
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002b8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002bc:	74 2c                	je     8002ea <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002cb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d3:	73 43                	jae    800318 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d5:	83 eb 01             	sub    $0x1,%ebx
  8002d8:	85 db                	test   %ebx,%ebx
  8002da:	7e 6c                	jle    800348 <printnum+0xaf>
				putch(padc, putdat);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	57                   	push   %edi
  8002e0:	ff 75 18             	pushl  0x18(%ebp)
  8002e3:	ff d6                	call   *%esi
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	eb eb                	jmp    8002d5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 20                	push   $0x20
  8002ef:	6a 00                	push   $0x0
  8002f1:	50                   	push   %eax
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f8:	89 fa                	mov    %edi,%edx
  8002fa:	89 f0                	mov    %esi,%eax
  8002fc:	e8 98 ff ff ff       	call   800299 <printnum>
		while (--width > 0)
  800301:	83 c4 20             	add    $0x20,%esp
  800304:	83 eb 01             	sub    $0x1,%ebx
  800307:	85 db                	test   %ebx,%ebx
  800309:	7e 65                	jle    800370 <printnum+0xd7>
			putch(padc, putdat);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	57                   	push   %edi
  80030f:	6a 20                	push   $0x20
  800311:	ff d6                	call   *%esi
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	eb ec                	jmp    800304 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	ff 75 18             	pushl  0x18(%ebp)
  80031e:	83 eb 01             	sub    $0x1,%ebx
  800321:	53                   	push   %ebx
  800322:	50                   	push   %eax
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	ff 75 dc             	pushl  -0x24(%ebp)
  800329:	ff 75 d8             	pushl  -0x28(%ebp)
  80032c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032f:	ff 75 e0             	pushl  -0x20(%ebp)
  800332:	e8 e9 25 00 00       	call   802920 <__udivdi3>
  800337:	83 c4 18             	add    $0x18,%esp
  80033a:	52                   	push   %edx
  80033b:	50                   	push   %eax
  80033c:	89 fa                	mov    %edi,%edx
  80033e:	89 f0                	mov    %esi,%eax
  800340:	e8 54 ff ff ff       	call   800299 <printnum>
  800345:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	57                   	push   %edi
  80034c:	83 ec 04             	sub    $0x4,%esp
  80034f:	ff 75 dc             	pushl  -0x24(%ebp)
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	ff 75 e4             	pushl  -0x1c(%ebp)
  800358:	ff 75 e0             	pushl  -0x20(%ebp)
  80035b:	e8 d0 26 00 00       	call   802a30 <__umoddi3>
  800360:	83 c4 14             	add    $0x14,%esp
  800363:	0f be 80 01 2c 80 00 	movsbl 0x802c01(%eax),%eax
  80036a:	50                   	push   %eax
  80036b:	ff d6                	call   *%esi
  80036d:	83 c4 10             	add    $0x10,%esp
	}
}
  800370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5f                   	pop    %edi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800382:	8b 10                	mov    (%eax),%edx
  800384:	3b 50 04             	cmp    0x4(%eax),%edx
  800387:	73 0a                	jae    800393 <sprintputch+0x1b>
		*b->buf++ = ch;
  800389:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	88 02                	mov    %al,(%edx)
}
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <printfmt>:
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039e:	50                   	push   %eax
  80039f:	ff 75 10             	pushl  0x10(%ebp)
  8003a2:	ff 75 0c             	pushl  0xc(%ebp)
  8003a5:	ff 75 08             	pushl  0x8(%ebp)
  8003a8:	e8 05 00 00 00       	call   8003b2 <vprintfmt>
}
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <vprintfmt>:
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	57                   	push   %edi
  8003b6:	56                   	push   %esi
  8003b7:	53                   	push   %ebx
  8003b8:	83 ec 3c             	sub    $0x3c,%esp
  8003bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c4:	e9 32 04 00 00       	jmp    8007fb <vprintfmt+0x449>
		padc = ' ';
  8003c9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003cd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8d 47 01             	lea    0x1(%edi),%eax
  8003f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fb:	0f b6 17             	movzbl (%edi),%edx
  8003fe:	8d 42 dd             	lea    -0x23(%edx),%eax
  800401:	3c 55                	cmp    $0x55,%al
  800403:	0f 87 12 05 00 00    	ja     80091b <vprintfmt+0x569>
  800409:	0f b6 c0             	movzbl %al,%eax
  80040c:	ff 24 85 e0 2d 80 00 	jmp    *0x802de0(,%eax,4)
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800416:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041a:	eb d9                	jmp    8003f5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800423:	eb d0                	jmp    8003f5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800425:	0f b6 d2             	movzbl %dl,%edx
  800428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80042b:	b8 00 00 00 00       	mov    $0x0,%eax
  800430:	89 75 08             	mov    %esi,0x8(%ebp)
  800433:	eb 03                	jmp    800438 <vprintfmt+0x86>
  800435:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800438:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80043f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800442:	8d 72 d0             	lea    -0x30(%edx),%esi
  800445:	83 fe 09             	cmp    $0x9,%esi
  800448:	76 eb                	jbe    800435 <vprintfmt+0x83>
  80044a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044d:	8b 75 08             	mov    0x8(%ebp),%esi
  800450:	eb 14                	jmp    800466 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800452:	8b 45 14             	mov    0x14(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045a:	8b 45 14             	mov    0x14(%ebp),%eax
  80045d:	8d 40 04             	lea    0x4(%eax),%eax
  800460:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800466:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046a:	79 89                	jns    8003f5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80046c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800472:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800479:	e9 77 ff ff ff       	jmp    8003f5 <vprintfmt+0x43>
  80047e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 48 c1             	cmovs  %ecx,%eax
  800486:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800489:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048c:	e9 64 ff ff ff       	jmp    8003f5 <vprintfmt+0x43>
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800494:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049b:	e9 55 ff ff ff       	jmp    8003f5 <vprintfmt+0x43>
			lflag++;
  8004a0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a7:	e9 49 ff ff ff       	jmp    8003f5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8d 78 04             	lea    0x4(%eax),%edi
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	ff 30                	pushl  (%eax)
  8004b8:	ff d6                	call   *%esi
			break;
  8004ba:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004bd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c0:	e9 33 03 00 00       	jmp    8007f8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8d 78 04             	lea    0x4(%eax),%edi
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	99                   	cltd   
  8004ce:	31 d0                	xor    %edx,%eax
  8004d0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d2:	83 f8 11             	cmp    $0x11,%eax
  8004d5:	7f 23                	jg     8004fa <vprintfmt+0x148>
  8004d7:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  8004de:	85 d2                	test   %edx,%edx
  8004e0:	74 18                	je     8004fa <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e2:	52                   	push   %edx
  8004e3:	68 4d 31 80 00       	push   $0x80314d
  8004e8:	53                   	push   %ebx
  8004e9:	56                   	push   %esi
  8004ea:	e8 a6 fe ff ff       	call   800395 <printfmt>
  8004ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f5:	e9 fe 02 00 00       	jmp    8007f8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fa:	50                   	push   %eax
  8004fb:	68 19 2c 80 00       	push   $0x802c19
  800500:	53                   	push   %ebx
  800501:	56                   	push   %esi
  800502:	e8 8e fe ff ff       	call   800395 <printfmt>
  800507:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80050d:	e9 e6 02 00 00       	jmp    8007f8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	83 c0 04             	add    $0x4,%eax
  800518:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800520:	85 c9                	test   %ecx,%ecx
  800522:	b8 12 2c 80 00       	mov    $0x802c12,%eax
  800527:	0f 45 c1             	cmovne %ecx,%eax
  80052a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80052d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800531:	7e 06                	jle    800539 <vprintfmt+0x187>
  800533:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800537:	75 0d                	jne    800546 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053c:	89 c7                	mov    %eax,%edi
  80053e:	03 45 e0             	add    -0x20(%ebp),%eax
  800541:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800544:	eb 53                	jmp    800599 <vprintfmt+0x1e7>
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	ff 75 d8             	pushl  -0x28(%ebp)
  80054c:	50                   	push   %eax
  80054d:	e8 71 04 00 00       	call   8009c3 <strnlen>
  800552:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800555:	29 c1                	sub    %eax,%ecx
  800557:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80055f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800566:	eb 0f                	jmp    800577 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	53                   	push   %ebx
  80056c:	ff 75 e0             	pushl  -0x20(%ebp)
  80056f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800571:	83 ef 01             	sub    $0x1,%edi
  800574:	83 c4 10             	add    $0x10,%esp
  800577:	85 ff                	test   %edi,%edi
  800579:	7f ed                	jg     800568 <vprintfmt+0x1b6>
  80057b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80057e:	85 c9                	test   %ecx,%ecx
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	0f 49 c1             	cmovns %ecx,%eax
  800588:	29 c1                	sub    %eax,%ecx
  80058a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80058d:	eb aa                	jmp    800539 <vprintfmt+0x187>
					putch(ch, putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	53                   	push   %ebx
  800593:	52                   	push   %edx
  800594:	ff d6                	call   *%esi
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059e:	83 c7 01             	add    $0x1,%edi
  8005a1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a5:	0f be d0             	movsbl %al,%edx
  8005a8:	85 d2                	test   %edx,%edx
  8005aa:	74 4b                	je     8005f7 <vprintfmt+0x245>
  8005ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b0:	78 06                	js     8005b8 <vprintfmt+0x206>
  8005b2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b6:	78 1e                	js     8005d6 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005bc:	74 d1                	je     80058f <vprintfmt+0x1dd>
  8005be:	0f be c0             	movsbl %al,%eax
  8005c1:	83 e8 20             	sub    $0x20,%eax
  8005c4:	83 f8 5e             	cmp    $0x5e,%eax
  8005c7:	76 c6                	jbe    80058f <vprintfmt+0x1dd>
					putch('?', putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	53                   	push   %ebx
  8005cd:	6a 3f                	push   $0x3f
  8005cf:	ff d6                	call   *%esi
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	eb c3                	jmp    800599 <vprintfmt+0x1e7>
  8005d6:	89 cf                	mov    %ecx,%edi
  8005d8:	eb 0e                	jmp    8005e8 <vprintfmt+0x236>
				putch(' ', putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	53                   	push   %ebx
  8005de:	6a 20                	push   $0x20
  8005e0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e2:	83 ef 01             	sub    $0x1,%edi
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	85 ff                	test   %edi,%edi
  8005ea:	7f ee                	jg     8005da <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f2:	e9 01 02 00 00       	jmp    8007f8 <vprintfmt+0x446>
  8005f7:	89 cf                	mov    %ecx,%edi
  8005f9:	eb ed                	jmp    8005e8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005fe:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800605:	e9 eb fd ff ff       	jmp    8003f5 <vprintfmt+0x43>
	if (lflag >= 2)
  80060a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060e:	7f 21                	jg     800631 <vprintfmt+0x27f>
	else if (lflag)
  800610:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800614:	74 68                	je     80067e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80061e:	89 c1                	mov    %eax,%ecx
  800620:	c1 f9 1f             	sar    $0x1f,%ecx
  800623:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	eb 17                	jmp    800648 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 50 04             	mov    0x4(%eax),%edx
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 08             	lea    0x8(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800648:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800654:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800658:	78 3f                	js     800699 <vprintfmt+0x2e7>
			base = 10;
  80065a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80065f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800663:	0f 84 71 01 00 00    	je     8007da <vprintfmt+0x428>
				putch('+', putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	6a 2b                	push   $0x2b
  80066f:	ff d6                	call   *%esi
  800671:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	e9 5c 01 00 00       	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, int);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800686:	89 c1                	mov    %eax,%ecx
  800688:	c1 f9 1f             	sar    $0x1f,%ecx
  80068b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
  800697:	eb af                	jmp    800648 <vprintfmt+0x296>
				putch('-', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 2d                	push   $0x2d
  80069f:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a7:	f7 d8                	neg    %eax
  8006a9:	83 d2 00             	adc    $0x0,%edx
  8006ac:	f7 da                	neg    %edx
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bc:	e9 19 01 00 00       	jmp    8007da <vprintfmt+0x428>
	if (lflag >= 2)
  8006c1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c5:	7f 29                	jg     8006f0 <vprintfmt+0x33e>
	else if (lflag)
  8006c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cb:	74 44                	je     800711 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006eb:	e9 ea 00 00 00       	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 50 04             	mov    0x4(%eax),%edx
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 08             	lea    0x8(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800707:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070c:	e9 c9 00 00 00       	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	ba 00 00 00 00       	mov    $0x0,%edx
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072f:	e9 a6 00 00 00       	jmp    8007da <vprintfmt+0x428>
			putch('0', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 30                	push   $0x30
  80073a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800743:	7f 26                	jg     80076b <vprintfmt+0x3b9>
	else if (lflag)
  800745:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800749:	74 3e                	je     800789 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 04             	lea    0x4(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800764:	b8 08 00 00 00       	mov    $0x8,%eax
  800769:	eb 6f                	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800776:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800782:	b8 08 00 00 00       	mov    $0x8,%eax
  800787:	eb 51                	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	ba 00 00 00 00       	mov    $0x0,%edx
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 04             	lea    0x4(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a7:	eb 31                	jmp    8007da <vprintfmt+0x428>
			putch('0', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	6a 30                	push   $0x30
  8007af:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b1:	83 c4 08             	add    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	6a 78                	push   $0x78
  8007b7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 40 04             	lea    0x4(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007da:	83 ec 0c             	sub    $0xc,%esp
  8007dd:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007e1:	52                   	push   %edx
  8007e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ec:	89 da                	mov    %ebx,%edx
  8007ee:	89 f0                	mov    %esi,%eax
  8007f0:	e8 a4 fa ff ff       	call   800299 <printnum>
			break;
  8007f5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fb:	83 c7 01             	add    $0x1,%edi
  8007fe:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800802:	83 f8 25             	cmp    $0x25,%eax
  800805:	0f 84 be fb ff ff    	je     8003c9 <vprintfmt+0x17>
			if (ch == '\0')
  80080b:	85 c0                	test   %eax,%eax
  80080d:	0f 84 28 01 00 00    	je     80093b <vprintfmt+0x589>
			putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	50                   	push   %eax
  800818:	ff d6                	call   *%esi
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	eb dc                	jmp    8007fb <vprintfmt+0x449>
	if (lflag >= 2)
  80081f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800823:	7f 26                	jg     80084b <vprintfmt+0x499>
	else if (lflag)
  800825:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800829:	74 41                	je     80086c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800844:	b8 10 00 00 00       	mov    $0x10,%eax
  800849:	eb 8f                	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 08             	lea    0x8(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	b8 10 00 00 00       	mov    $0x10,%eax
  800867:	e9 6e ff ff ff       	jmp    8007da <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800885:	b8 10 00 00 00       	mov    $0x10,%eax
  80088a:	e9 4b ff ff ff       	jmp    8007da <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	85 c0                	test   %eax,%eax
  80089f:	74 14                	je     8008b5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008a1:	8b 13                	mov    (%ebx),%edx
  8008a3:	83 fa 7f             	cmp    $0x7f,%edx
  8008a6:	7f 37                	jg     8008df <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008a8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b0:	e9 43 ff ff ff       	jmp    8007f8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ba:	bf 35 2d 80 00       	mov    $0x802d35,%edi
							putch(ch, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	50                   	push   %eax
  8008c4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c6:	83 c7 01             	add    $0x1,%edi
  8008c9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	75 eb                	jne    8008bf <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	e9 19 ff ff ff       	jmp    8007f8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008df:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e6:	bf 6d 2d 80 00       	mov    $0x802d6d,%edi
							putch(ch, putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	53                   	push   %ebx
  8008ef:	50                   	push   %eax
  8008f0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f2:	83 c7 01             	add    $0x1,%edi
  8008f5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	85 c0                	test   %eax,%eax
  8008fe:	75 eb                	jne    8008eb <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800900:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
  800906:	e9 ed fe ff ff       	jmp    8007f8 <vprintfmt+0x446>
			putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	53                   	push   %ebx
  80090f:	6a 25                	push   $0x25
  800911:	ff d6                	call   *%esi
			break;
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	e9 dd fe ff ff       	jmp    8007f8 <vprintfmt+0x446>
			putch('%', putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	6a 25                	push   $0x25
  800921:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	89 f8                	mov    %edi,%eax
  800928:	eb 03                	jmp    80092d <vprintfmt+0x57b>
  80092a:	83 e8 01             	sub    $0x1,%eax
  80092d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800931:	75 f7                	jne    80092a <vprintfmt+0x578>
  800933:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800936:	e9 bd fe ff ff       	jmp    8007f8 <vprintfmt+0x446>
}
  80093b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093e:	5b                   	pop    %ebx
  80093f:	5e                   	pop    %esi
  800940:	5f                   	pop    %edi
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800952:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800956:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800959:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800960:	85 c0                	test   %eax,%eax
  800962:	74 26                	je     80098a <vsnprintf+0x47>
  800964:	85 d2                	test   %edx,%edx
  800966:	7e 22                	jle    80098a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800968:	ff 75 14             	pushl  0x14(%ebp)
  80096b:	ff 75 10             	pushl  0x10(%ebp)
  80096e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800971:	50                   	push   %eax
  800972:	68 78 03 80 00       	push   $0x800378
  800977:	e8 36 fa ff ff       	call   8003b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80097f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800985:	83 c4 10             	add    $0x10,%esp
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    
		return -E_INVAL;
  80098a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098f:	eb f7                	jmp    800988 <vsnprintf+0x45>

00800991 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099a:	50                   	push   %eax
  80099b:	ff 75 10             	pushl  0x10(%ebp)
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 9a ff ff ff       	call   800943 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ba:	74 05                	je     8009c1 <strlen+0x16>
		n++;
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	eb f5                	jmp    8009b6 <strlen+0xb>
	return n;
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	74 0d                	je     8009e2 <strnlen+0x1f>
  8009d5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d9:	74 05                	je     8009e0 <strnlen+0x1d>
		n++;
  8009db:	83 c2 01             	add    $0x1,%edx
  8009de:	eb f1                	jmp    8009d1 <strnlen+0xe>
  8009e0:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	53                   	push   %ebx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	84 c9                	test   %cl,%cl
  8009ff:	75 f2                	jne    8009f3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a01:	5b                   	pop    %ebx
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	53                   	push   %ebx
  800a08:	83 ec 10             	sub    $0x10,%esp
  800a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a0e:	53                   	push   %ebx
  800a0f:	e8 97 ff ff ff       	call   8009ab <strlen>
  800a14:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	01 d8                	add    %ebx,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 c2 ff ff ff       	call   8009e4 <strcpy>
	return dst;
}
  800a22:	89 d8                	mov    %ebx,%eax
  800a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a34:	89 c6                	mov    %eax,%esi
  800a36:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a39:	89 c2                	mov    %eax,%edx
  800a3b:	39 f2                	cmp    %esi,%edx
  800a3d:	74 11                	je     800a50 <strncpy+0x27>
		*dst++ = *src;
  800a3f:	83 c2 01             	add    $0x1,%edx
  800a42:	0f b6 19             	movzbl (%ecx),%ebx
  800a45:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a48:	80 fb 01             	cmp    $0x1,%bl
  800a4b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a4e:	eb eb                	jmp    800a3b <strncpy+0x12>
	}
	return ret;
}
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5f:	8b 55 10             	mov    0x10(%ebp),%edx
  800a62:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a64:	85 d2                	test   %edx,%edx
  800a66:	74 21                	je     800a89 <strlcpy+0x35>
  800a68:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a6c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a6e:	39 c2                	cmp    %eax,%edx
  800a70:	74 14                	je     800a86 <strlcpy+0x32>
  800a72:	0f b6 19             	movzbl (%ecx),%ebx
  800a75:	84 db                	test   %bl,%bl
  800a77:	74 0b                	je     800a84 <strlcpy+0x30>
			*dst++ = *src++;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a82:	eb ea                	jmp    800a6e <strlcpy+0x1a>
  800a84:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a86:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a89:	29 f0                	sub    %esi,%eax
}
  800a8b:	5b                   	pop    %ebx
  800a8c:	5e                   	pop    %esi
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a98:	0f b6 01             	movzbl (%ecx),%eax
  800a9b:	84 c0                	test   %al,%al
  800a9d:	74 0c                	je     800aab <strcmp+0x1c>
  800a9f:	3a 02                	cmp    (%edx),%al
  800aa1:	75 08                	jne    800aab <strcmp+0x1c>
		p++, q++;
  800aa3:	83 c1 01             	add    $0x1,%ecx
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	eb ed                	jmp    800a98 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aab:	0f b6 c0             	movzbl %al,%eax
  800aae:	0f b6 12             	movzbl (%edx),%edx
  800ab1:	29 d0                	sub    %edx,%eax
}
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	53                   	push   %ebx
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abf:	89 c3                	mov    %eax,%ebx
  800ac1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac4:	eb 06                	jmp    800acc <strncmp+0x17>
		n--, p++, q++;
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800acc:	39 d8                	cmp    %ebx,%eax
  800ace:	74 16                	je     800ae6 <strncmp+0x31>
  800ad0:	0f b6 08             	movzbl (%eax),%ecx
  800ad3:	84 c9                	test   %cl,%cl
  800ad5:	74 04                	je     800adb <strncmp+0x26>
  800ad7:	3a 0a                	cmp    (%edx),%cl
  800ad9:	74 eb                	je     800ac6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800adb:	0f b6 00             	movzbl (%eax),%eax
  800ade:	0f b6 12             	movzbl (%edx),%edx
  800ae1:	29 d0                	sub    %edx,%eax
}
  800ae3:	5b                   	pop    %ebx
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    
		return 0;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aeb:	eb f6                	jmp    800ae3 <strncmp+0x2e>

00800aed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af7:	0f b6 10             	movzbl (%eax),%edx
  800afa:	84 d2                	test   %dl,%dl
  800afc:	74 09                	je     800b07 <strchr+0x1a>
		if (*s == c)
  800afe:	38 ca                	cmp    %cl,%dl
  800b00:	74 0a                	je     800b0c <strchr+0x1f>
	for (; *s; s++)
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	eb f0                	jmp    800af7 <strchr+0xa>
			return (char *) s;
	return 0;
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b18:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b1b:	38 ca                	cmp    %cl,%dl
  800b1d:	74 09                	je     800b28 <strfind+0x1a>
  800b1f:	84 d2                	test   %dl,%dl
  800b21:	74 05                	je     800b28 <strfind+0x1a>
	for (; *s; s++)
  800b23:	83 c0 01             	add    $0x1,%eax
  800b26:	eb f0                	jmp    800b18 <strfind+0xa>
			break;
	return (char *) s;
}
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
  800b30:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b36:	85 c9                	test   %ecx,%ecx
  800b38:	74 31                	je     800b6b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3a:	89 f8                	mov    %edi,%eax
  800b3c:	09 c8                	or     %ecx,%eax
  800b3e:	a8 03                	test   $0x3,%al
  800b40:	75 23                	jne    800b65 <memset+0x3b>
		c &= 0xFF;
  800b42:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	c1 e3 08             	shl    $0x8,%ebx
  800b4b:	89 d0                	mov    %edx,%eax
  800b4d:	c1 e0 18             	shl    $0x18,%eax
  800b50:	89 d6                	mov    %edx,%esi
  800b52:	c1 e6 10             	shl    $0x10,%esi
  800b55:	09 f0                	or     %esi,%eax
  800b57:	09 c2                	or     %eax,%edx
  800b59:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b5e:	89 d0                	mov    %edx,%eax
  800b60:	fc                   	cld    
  800b61:	f3 ab                	rep stos %eax,%es:(%edi)
  800b63:	eb 06                	jmp    800b6b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	fc                   	cld    
  800b69:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6b:	89 f8                	mov    %edi,%eax
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b80:	39 c6                	cmp    %eax,%esi
  800b82:	73 32                	jae    800bb6 <memmove+0x44>
  800b84:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b87:	39 c2                	cmp    %eax,%edx
  800b89:	76 2b                	jbe    800bb6 <memmove+0x44>
		s += n;
		d += n;
  800b8b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8e:	89 fe                	mov    %edi,%esi
  800b90:	09 ce                	or     %ecx,%esi
  800b92:	09 d6                	or     %edx,%esi
  800b94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9a:	75 0e                	jne    800baa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b9c:	83 ef 04             	sub    $0x4,%edi
  800b9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba5:	fd                   	std    
  800ba6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba8:	eb 09                	jmp    800bb3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800baa:	83 ef 01             	sub    $0x1,%edi
  800bad:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb0:	fd                   	std    
  800bb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb3:	fc                   	cld    
  800bb4:	eb 1a                	jmp    800bd0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb6:	89 c2                	mov    %eax,%edx
  800bb8:	09 ca                	or     %ecx,%edx
  800bba:	09 f2                	or     %esi,%edx
  800bbc:	f6 c2 03             	test   $0x3,%dl
  800bbf:	75 0a                	jne    800bcb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc4:	89 c7                	mov    %eax,%edi
  800bc6:	fc                   	cld    
  800bc7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc9:	eb 05                	jmp    800bd0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bcb:	89 c7                	mov    %eax,%edi
  800bcd:	fc                   	cld    
  800bce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bda:	ff 75 10             	pushl  0x10(%ebp)
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 8a ff ff ff       	call   800b72 <memmove>
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf5:	89 c6                	mov    %eax,%esi
  800bf7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bfa:	39 f0                	cmp    %esi,%eax
  800bfc:	74 1c                	je     800c1a <memcmp+0x30>
		if (*s1 != *s2)
  800bfe:	0f b6 08             	movzbl (%eax),%ecx
  800c01:	0f b6 1a             	movzbl (%edx),%ebx
  800c04:	38 d9                	cmp    %bl,%cl
  800c06:	75 08                	jne    800c10 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c08:	83 c0 01             	add    $0x1,%eax
  800c0b:	83 c2 01             	add    $0x1,%edx
  800c0e:	eb ea                	jmp    800bfa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c10:	0f b6 c1             	movzbl %cl,%eax
  800c13:	0f b6 db             	movzbl %bl,%ebx
  800c16:	29 d8                	sub    %ebx,%eax
  800c18:	eb 05                	jmp    800c1f <memcmp+0x35>
	}

	return 0;
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c2c:	89 c2                	mov    %eax,%edx
  800c2e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c31:	39 d0                	cmp    %edx,%eax
  800c33:	73 09                	jae    800c3e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c35:	38 08                	cmp    %cl,(%eax)
  800c37:	74 05                	je     800c3e <memfind+0x1b>
	for (; s < ends; s++)
  800c39:	83 c0 01             	add    $0x1,%eax
  800c3c:	eb f3                	jmp    800c31 <memfind+0xe>
			break;
	return (void *) s;
}
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4c:	eb 03                	jmp    800c51 <strtol+0x11>
		s++;
  800c4e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c51:	0f b6 01             	movzbl (%ecx),%eax
  800c54:	3c 20                	cmp    $0x20,%al
  800c56:	74 f6                	je     800c4e <strtol+0xe>
  800c58:	3c 09                	cmp    $0x9,%al
  800c5a:	74 f2                	je     800c4e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c5c:	3c 2b                	cmp    $0x2b,%al
  800c5e:	74 2a                	je     800c8a <strtol+0x4a>
	int neg = 0;
  800c60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c65:	3c 2d                	cmp    $0x2d,%al
  800c67:	74 2b                	je     800c94 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c69:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c6f:	75 0f                	jne    800c80 <strtol+0x40>
  800c71:	80 39 30             	cmpb   $0x30,(%ecx)
  800c74:	74 28                	je     800c9e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c76:	85 db                	test   %ebx,%ebx
  800c78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7d:	0f 44 d8             	cmove  %eax,%ebx
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
  800c85:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c88:	eb 50                	jmp    800cda <strtol+0x9a>
		s++;
  800c8a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c8d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c92:	eb d5                	jmp    800c69 <strtol+0x29>
		s++, neg = 1;
  800c94:	83 c1 01             	add    $0x1,%ecx
  800c97:	bf 01 00 00 00       	mov    $0x1,%edi
  800c9c:	eb cb                	jmp    800c69 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca2:	74 0e                	je     800cb2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca4:	85 db                	test   %ebx,%ebx
  800ca6:	75 d8                	jne    800c80 <strtol+0x40>
		s++, base = 8;
  800ca8:	83 c1 01             	add    $0x1,%ecx
  800cab:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb0:	eb ce                	jmp    800c80 <strtol+0x40>
		s += 2, base = 16;
  800cb2:	83 c1 02             	add    $0x2,%ecx
  800cb5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cba:	eb c4                	jmp    800c80 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cbc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cbf:	89 f3                	mov    %esi,%ebx
  800cc1:	80 fb 19             	cmp    $0x19,%bl
  800cc4:	77 29                	ja     800cef <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc6:	0f be d2             	movsbl %dl,%edx
  800cc9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ccc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ccf:	7d 30                	jge    800d01 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd1:	83 c1 01             	add    $0x1,%ecx
  800cd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cda:	0f b6 11             	movzbl (%ecx),%edx
  800cdd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce0:	89 f3                	mov    %esi,%ebx
  800ce2:	80 fb 09             	cmp    $0x9,%bl
  800ce5:	77 d5                	ja     800cbc <strtol+0x7c>
			dig = *s - '0';
  800ce7:	0f be d2             	movsbl %dl,%edx
  800cea:	83 ea 30             	sub    $0x30,%edx
  800ced:	eb dd                	jmp    800ccc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cef:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf2:	89 f3                	mov    %esi,%ebx
  800cf4:	80 fb 19             	cmp    $0x19,%bl
  800cf7:	77 08                	ja     800d01 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf9:	0f be d2             	movsbl %dl,%edx
  800cfc:	83 ea 37             	sub    $0x37,%edx
  800cff:	eb cb                	jmp    800ccc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 05                	je     800d0c <strtol+0xcc>
		*endptr = (char *) s;
  800d07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d0c:	89 c2                	mov    %eax,%edx
  800d0e:	f7 da                	neg    %edx
  800d10:	85 ff                	test   %edi,%edi
  800d12:	0f 45 c2             	cmovne %edx,%eax
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d20:	b8 00 00 00 00       	mov    $0x0,%eax
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	89 c3                	mov    %eax,%ebx
  800d2d:	89 c7                	mov    %eax,%edi
  800d2f:	89 c6                	mov    %eax,%esi
  800d31:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d43:	b8 01 00 00 00       	mov    $0x1,%eax
  800d48:	89 d1                	mov    %edx,%ecx
  800d4a:	89 d3                	mov    %edx,%ebx
  800d4c:	89 d7                	mov    %edx,%edi
  800d4e:	89 d6                	mov    %edx,%esi
  800d50:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d60:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6d:	89 cb                	mov    %ecx,%ebx
  800d6f:	89 cf                	mov    %ecx,%edi
  800d71:	89 ce                	mov    %ecx,%esi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 03                	push   $0x3
  800d87:	68 88 2f 80 00       	push   $0x802f88
  800d8c:	6a 43                	push   $0x43
  800d8e:	68 a5 2f 80 00       	push   $0x802fa5
  800d93:	e8 50 19 00 00       	call   8026e8 <_panic>

00800d98 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	b8 02 00 00 00       	mov    $0x2,%eax
  800da8:	89 d1                	mov    %edx,%ecx
  800daa:	89 d3                	mov    %edx,%ebx
  800dac:	89 d7                	mov    %edx,%edi
  800dae:	89 d6                	mov    %edx,%esi
  800db0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_yield>:

void
sys_yield(void)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc7:	89 d1                	mov    %edx,%ecx
  800dc9:	89 d3                	mov    %edx,%ebx
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddf:	be 00 00 00 00       	mov    $0x0,%esi
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dea:	b8 04 00 00 00       	mov    $0x4,%eax
  800def:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df2:	89 f7                	mov    %esi,%edi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 04                	push   $0x4
  800e08:	68 88 2f 80 00       	push   $0x802f88
  800e0d:	6a 43                	push   $0x43
  800e0f:	68 a5 2f 80 00       	push   $0x802fa5
  800e14:	e8 cf 18 00 00       	call   8026e8 <_panic>

00800e19 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e30:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e33:	8b 75 18             	mov    0x18(%ebp),%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 05                	push   $0x5
  800e4a:	68 88 2f 80 00       	push   $0x802f88
  800e4f:	6a 43                	push   $0x43
  800e51:	68 a5 2f 80 00       	push   $0x802fa5
  800e56:	e8 8d 18 00 00       	call   8026e8 <_panic>

00800e5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e74:	89 df                	mov    %ebx,%edi
  800e76:	89 de                	mov    %ebx,%esi
  800e78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	7f 08                	jg     800e86 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 06                	push   $0x6
  800e8c:	68 88 2f 80 00       	push   $0x802f88
  800e91:	6a 43                	push   $0x43
  800e93:	68 a5 2f 80 00       	push   $0x802fa5
  800e98:	e8 4b 18 00 00       	call   8026e8 <_panic>

00800e9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7f 08                	jg     800ec8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 08                	push   $0x8
  800ece:	68 88 2f 80 00       	push   $0x802f88
  800ed3:	6a 43                	push   $0x43
  800ed5:	68 a5 2f 80 00       	push   $0x802fa5
  800eda:	e8 09 18 00 00       	call   8026e8 <_panic>

00800edf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef8:	89 df                	mov    %ebx,%edi
  800efa:	89 de                	mov    %ebx,%esi
  800efc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	7f 08                	jg     800f0a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	6a 09                	push   $0x9
  800f10:	68 88 2f 80 00       	push   $0x802f88
  800f15:	6a 43                	push   $0x43
  800f17:	68 a5 2f 80 00       	push   $0x802fa5
  800f1c:	e8 c7 17 00 00       	call   8026e8 <_panic>

00800f21 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	57                   	push   %edi
  800f25:	56                   	push   %esi
  800f26:	53                   	push   %ebx
  800f27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3a:	89 df                	mov    %ebx,%edi
  800f3c:	89 de                	mov    %ebx,%esi
  800f3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	7f 08                	jg     800f4c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 0a                	push   $0xa
  800f52:	68 88 2f 80 00       	push   $0x802f88
  800f57:	6a 43                	push   $0x43
  800f59:	68 a5 2f 80 00       	push   $0x802fa5
  800f5e:	e8 85 17 00 00       	call   8026e8 <_panic>

00800f63 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f74:	be 00 00 00 00       	mov    $0x0,%esi
  800f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
  800f8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9c:	89 cb                	mov    %ecx,%ebx
  800f9e:	89 cf                	mov    %ecx,%edi
  800fa0:	89 ce                	mov    %ecx,%esi
  800fa2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	7f 08                	jg     800fb0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	50                   	push   %eax
  800fb4:	6a 0d                	push   $0xd
  800fb6:	68 88 2f 80 00       	push   $0x802f88
  800fbb:	6a 43                	push   $0x43
  800fbd:	68 a5 2f 80 00       	push   $0x802fa5
  800fc2:	e8 21 17 00 00       	call   8026e8 <_panic>

00800fc7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	57                   	push   %edi
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffb:	89 cb                	mov    %ecx,%ebx
  800ffd:	89 cf                	mov    %ecx,%edi
  800fff:	89 ce                	mov    %ecx,%esi
  801001:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100e:	ba 00 00 00 00       	mov    $0x0,%edx
  801013:	b8 10 00 00 00       	mov    $0x10,%eax
  801018:	89 d1                	mov    %edx,%ecx
  80101a:	89 d3                	mov    %edx,%ebx
  80101c:	89 d7                	mov    %edx,%edi
  80101e:	89 d6                	mov    %edx,%esi
  801020:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	b8 11 00 00 00       	mov    $0x11,%eax
  80103d:	89 df                	mov    %ebx,%edi
  80103f:	89 de                	mov    %ebx,%esi
  801041:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5f                   	pop    %edi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    

00801048 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801059:	b8 12 00 00 00       	mov    $0x12,%eax
  80105e:	89 df                	mov    %ebx,%edi
  801060:	89 de                	mov    %ebx,%esi
  801062:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	b8 13 00 00 00       	mov    $0x13,%eax
  801082:	89 df                	mov    %ebx,%edi
  801084:	89 de                	mov    %ebx,%esi
  801086:	cd 30                	int    $0x30
	if(check && ret > 0)
  801088:	85 c0                	test   %eax,%eax
  80108a:	7f 08                	jg     801094 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 13                	push   $0x13
  80109a:	68 88 2f 80 00       	push   $0x802f88
  80109f:	6a 43                	push   $0x43
  8010a1:	68 a5 2f 80 00       	push   $0x802fa5
  8010a6:	e8 3d 16 00 00       	call   8026e8 <_panic>

008010ab <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010b2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b9:	f6 c5 04             	test   $0x4,%ch
  8010bc:	75 45                	jne    801103 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010be:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c5:	83 e1 07             	and    $0x7,%ecx
  8010c8:	83 f9 07             	cmp    $0x7,%ecx
  8010cb:	74 6f                	je     80113c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010cd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d4:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010da:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010e0:	0f 84 b6 00 00 00    	je     80119c <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010e6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ed:	83 e1 05             	and    $0x5,%ecx
  8010f0:	83 f9 05             	cmp    $0x5,%ecx
  8010f3:	0f 84 d7 00 00 00    	je     8011d0 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801101:	c9                   	leave  
  801102:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801103:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80110a:	c1 e2 0c             	shl    $0xc,%edx
  80110d:	83 ec 0c             	sub    $0xc,%esp
  801110:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801116:	51                   	push   %ecx
  801117:	52                   	push   %edx
  801118:	50                   	push   %eax
  801119:	52                   	push   %edx
  80111a:	6a 00                	push   $0x0
  80111c:	e8 f8 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  801121:	83 c4 20             	add    $0x20,%esp
  801124:	85 c0                	test   %eax,%eax
  801126:	79 d1                	jns    8010f9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801128:	83 ec 04             	sub    $0x4,%esp
  80112b:	68 b3 2f 80 00       	push   $0x802fb3
  801130:	6a 54                	push   $0x54
  801132:	68 c9 2f 80 00       	push   $0x802fc9
  801137:	e8 ac 15 00 00       	call   8026e8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80113c:	89 d3                	mov    %edx,%ebx
  80113e:	c1 e3 0c             	shl    $0xc,%ebx
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	68 05 08 00 00       	push   $0x805
  801149:	53                   	push   %ebx
  80114a:	50                   	push   %eax
  80114b:	53                   	push   %ebx
  80114c:	6a 00                	push   $0x0
  80114e:	e8 c6 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  801153:	83 c4 20             	add    $0x20,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 2e                	js     801188 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	68 05 08 00 00       	push   $0x805
  801162:	53                   	push   %ebx
  801163:	6a 00                	push   $0x0
  801165:	53                   	push   %ebx
  801166:	6a 00                	push   $0x0
  801168:	e8 ac fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  80116d:	83 c4 20             	add    $0x20,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	79 85                	jns    8010f9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	68 b3 2f 80 00       	push   $0x802fb3
  80117c:	6a 5f                	push   $0x5f
  80117e:	68 c9 2f 80 00       	push   $0x802fc9
  801183:	e8 60 15 00 00       	call   8026e8 <_panic>
			panic("sys_page_map() panic\n");
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	68 b3 2f 80 00       	push   $0x802fb3
  801190:	6a 5b                	push   $0x5b
  801192:	68 c9 2f 80 00       	push   $0x802fc9
  801197:	e8 4c 15 00 00       	call   8026e8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80119c:	c1 e2 0c             	shl    $0xc,%edx
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	68 05 08 00 00       	push   $0x805
  8011a7:	52                   	push   %edx
  8011a8:	50                   	push   %eax
  8011a9:	52                   	push   %edx
  8011aa:	6a 00                	push   $0x0
  8011ac:	e8 68 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  8011b1:	83 c4 20             	add    $0x20,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	0f 89 3d ff ff ff    	jns    8010f9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	68 b3 2f 80 00       	push   $0x802fb3
  8011c4:	6a 66                	push   $0x66
  8011c6:	68 c9 2f 80 00       	push   $0x802fc9
  8011cb:	e8 18 15 00 00       	call   8026e8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011d0:	c1 e2 0c             	shl    $0xc,%edx
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	6a 05                	push   $0x5
  8011d8:	52                   	push   %edx
  8011d9:	50                   	push   %eax
  8011da:	52                   	push   %edx
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 37 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  8011e2:	83 c4 20             	add    $0x20,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	0f 89 0c ff ff ff    	jns    8010f9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ed:	83 ec 04             	sub    $0x4,%esp
  8011f0:	68 b3 2f 80 00       	push   $0x802fb3
  8011f5:	6a 6d                	push   $0x6d
  8011f7:	68 c9 2f 80 00       	push   $0x802fc9
  8011fc:	e8 e7 14 00 00       	call   8026e8 <_panic>

00801201 <pgfault>:
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	53                   	push   %ebx
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80120b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80120d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801211:	0f 84 99 00 00 00    	je     8012b0 <pgfault+0xaf>
  801217:	89 c2                	mov    %eax,%edx
  801219:	c1 ea 16             	shr    $0x16,%edx
  80121c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801223:	f6 c2 01             	test   $0x1,%dl
  801226:	0f 84 84 00 00 00    	je     8012b0 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	c1 ea 0c             	shr    $0xc,%edx
  801231:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801238:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80123e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801244:	75 6a                	jne    8012b0 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	6a 07                	push   $0x7
  801252:	68 00 f0 7f 00       	push   $0x7ff000
  801257:	6a 00                	push   $0x0
  801259:	e8 78 fb ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 5f                	js     8012c4 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	68 00 10 00 00       	push   $0x1000
  80126d:	53                   	push   %ebx
  80126e:	68 00 f0 7f 00       	push   $0x7ff000
  801273:	e8 5c f9 ff ff       	call   800bd4 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801278:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80127f:	53                   	push   %ebx
  801280:	6a 00                	push   $0x0
  801282:	68 00 f0 7f 00       	push   $0x7ff000
  801287:	6a 00                	push   $0x0
  801289:	e8 8b fb ff ff       	call   800e19 <sys_page_map>
	if(ret < 0)
  80128e:	83 c4 20             	add    $0x20,%esp
  801291:	85 c0                	test   %eax,%eax
  801293:	78 43                	js     8012d8 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801295:	83 ec 08             	sub    $0x8,%esp
  801298:	68 00 f0 7f 00       	push   $0x7ff000
  80129d:	6a 00                	push   $0x0
  80129f:	e8 b7 fb ff ff       	call   800e5b <sys_page_unmap>
	if(ret < 0)
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	78 41                	js     8012ec <pgfault+0xeb>
}
  8012ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	68 d4 2f 80 00       	push   $0x802fd4
  8012b8:	6a 26                	push   $0x26
  8012ba:	68 c9 2f 80 00       	push   $0x802fc9
  8012bf:	e8 24 14 00 00       	call   8026e8 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	68 e8 2f 80 00       	push   $0x802fe8
  8012cc:	6a 31                	push   $0x31
  8012ce:	68 c9 2f 80 00       	push   $0x802fc9
  8012d3:	e8 10 14 00 00       	call   8026e8 <_panic>
		panic("panic in sys_page_map()\n");
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	68 03 30 80 00       	push   $0x803003
  8012e0:	6a 36                	push   $0x36
  8012e2:	68 c9 2f 80 00       	push   $0x802fc9
  8012e7:	e8 fc 13 00 00       	call   8026e8 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 1c 30 80 00       	push   $0x80301c
  8012f4:	6a 39                	push   $0x39
  8012f6:	68 c9 2f 80 00       	push   $0x802fc9
  8012fb:	e8 e8 13 00 00       	call   8026e8 <_panic>

00801300 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	57                   	push   %edi
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801309:	68 01 12 80 00       	push   $0x801201
  80130e:	e8 36 14 00 00       	call   802749 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801313:	b8 07 00 00 00       	mov    $0x7,%eax
  801318:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 27                	js     801348 <fork+0x48>
  801321:	89 c6                	mov    %eax,%esi
  801323:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801325:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80132a:	75 48                	jne    801374 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80132c:	e8 67 fa ff ff       	call   800d98 <sys_getenvid>
  801331:	25 ff 03 00 00       	and    $0x3ff,%eax
  801336:	c1 e0 07             	shl    $0x7,%eax
  801339:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133e:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801343:	e9 90 00 00 00       	jmp    8013d8 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	68 38 30 80 00       	push   $0x803038
  801350:	68 8c 00 00 00       	push   $0x8c
  801355:	68 c9 2f 80 00       	push   $0x802fc9
  80135a:	e8 89 13 00 00       	call   8026e8 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80135f:	89 f8                	mov    %edi,%eax
  801361:	e8 45 fd ff ff       	call   8010ab <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801366:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80136c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801372:	74 26                	je     80139a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801374:	89 d8                	mov    %ebx,%eax
  801376:	c1 e8 16             	shr    $0x16,%eax
  801379:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801380:	a8 01                	test   $0x1,%al
  801382:	74 e2                	je     801366 <fork+0x66>
  801384:	89 da                	mov    %ebx,%edx
  801386:	c1 ea 0c             	shr    $0xc,%edx
  801389:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801390:	83 e0 05             	and    $0x5,%eax
  801393:	83 f8 05             	cmp    $0x5,%eax
  801396:	75 ce                	jne    801366 <fork+0x66>
  801398:	eb c5                	jmp    80135f <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	6a 07                	push   $0x7
  80139f:	68 00 f0 bf ee       	push   $0xeebff000
  8013a4:	56                   	push   %esi
  8013a5:	e8 2c fa ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 31                	js     8013e2 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	68 b8 27 80 00       	push   $0x8027b8
  8013b9:	56                   	push   %esi
  8013ba:	e8 62 fb ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 33                	js     8013f9 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013c6:	83 ec 08             	sub    $0x8,%esp
  8013c9:	6a 02                	push   $0x2
  8013cb:	56                   	push   %esi
  8013cc:	e8 cc fa ff ff       	call   800e9d <sys_env_set_status>
	if(ret < 0)
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 38                	js     801410 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013d8:	89 f0                	mov    %esi,%eax
  8013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dd:	5b                   	pop    %ebx
  8013de:	5e                   	pop    %esi
  8013df:	5f                   	pop    %edi
  8013e0:	5d                   	pop    %ebp
  8013e1:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 e8 2f 80 00       	push   $0x802fe8
  8013ea:	68 98 00 00 00       	push   $0x98
  8013ef:	68 c9 2f 80 00       	push   $0x802fc9
  8013f4:	e8 ef 12 00 00       	call   8026e8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	68 5c 30 80 00       	push   $0x80305c
  801401:	68 9b 00 00 00       	push   $0x9b
  801406:	68 c9 2f 80 00       	push   $0x802fc9
  80140b:	e8 d8 12 00 00       	call   8026e8 <_panic>
		panic("panic in sys_env_set_status()\n");
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 84 30 80 00       	push   $0x803084
  801418:	68 9e 00 00 00       	push   $0x9e
  80141d:	68 c9 2f 80 00       	push   $0x802fc9
  801422:	e8 c1 12 00 00       	call   8026e8 <_panic>

00801427 <sfork>:

// Challenge!
int
sfork(void)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	57                   	push   %edi
  80142b:	56                   	push   %esi
  80142c:	53                   	push   %ebx
  80142d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801430:	68 01 12 80 00       	push   $0x801201
  801435:	e8 0f 13 00 00       	call   802749 <set_pgfault_handler>
  80143a:	b8 07 00 00 00       	mov    $0x7,%eax
  80143f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 27                	js     80146f <sfork+0x48>
  801448:	89 c7                	mov    %eax,%edi
  80144a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80144c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801451:	75 55                	jne    8014a8 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801453:	e8 40 f9 ff ff       	call   800d98 <sys_getenvid>
  801458:	25 ff 03 00 00       	and    $0x3ff,%eax
  80145d:	c1 e0 07             	shl    $0x7,%eax
  801460:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801465:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80146a:	e9 d4 00 00 00       	jmp    801543 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	68 38 30 80 00       	push   $0x803038
  801477:	68 af 00 00 00       	push   $0xaf
  80147c:	68 c9 2f 80 00       	push   $0x802fc9
  801481:	e8 62 12 00 00       	call   8026e8 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801486:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80148b:	89 f0                	mov    %esi,%eax
  80148d:	e8 19 fc ff ff       	call   8010ab <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801492:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801498:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80149e:	77 65                	ja     801505 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014a0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014a6:	74 de                	je     801486 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	c1 e8 16             	shr    $0x16,%eax
  8014ad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b4:	a8 01                	test   $0x1,%al
  8014b6:	74 da                	je     801492 <sfork+0x6b>
  8014b8:	89 da                	mov    %ebx,%edx
  8014ba:	c1 ea 0c             	shr    $0xc,%edx
  8014bd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014c4:	83 e0 05             	and    $0x5,%eax
  8014c7:	83 f8 05             	cmp    $0x5,%eax
  8014ca:	75 c6                	jne    801492 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014cc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014d3:	c1 e2 0c             	shl    $0xc,%edx
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	83 e0 07             	and    $0x7,%eax
  8014dc:	50                   	push   %eax
  8014dd:	52                   	push   %edx
  8014de:	56                   	push   %esi
  8014df:	52                   	push   %edx
  8014e0:	6a 00                	push   $0x0
  8014e2:	e8 32 f9 ff ff       	call   800e19 <sys_page_map>
  8014e7:	83 c4 20             	add    $0x20,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 a4                	je     801492 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	68 b3 2f 80 00       	push   $0x802fb3
  8014f6:	68 ba 00 00 00       	push   $0xba
  8014fb:	68 c9 2f 80 00       	push   $0x802fc9
  801500:	e8 e3 11 00 00       	call   8026e8 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	6a 07                	push   $0x7
  80150a:	68 00 f0 bf ee       	push   $0xeebff000
  80150f:	57                   	push   %edi
  801510:	e8 c1 f8 ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 31                	js     80154d <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80151c:	83 ec 08             	sub    $0x8,%esp
  80151f:	68 b8 27 80 00       	push   $0x8027b8
  801524:	57                   	push   %edi
  801525:	e8 f7 f9 ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 33                	js     801564 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801531:	83 ec 08             	sub    $0x8,%esp
  801534:	6a 02                	push   $0x2
  801536:	57                   	push   %edi
  801537:	e8 61 f9 ff ff       	call   800e9d <sys_env_set_status>
	if(ret < 0)
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 38                	js     80157b <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801543:	89 f8                	mov    %edi,%eax
  801545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5f                   	pop    %edi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 e8 2f 80 00       	push   $0x802fe8
  801555:	68 c0 00 00 00       	push   $0xc0
  80155a:	68 c9 2f 80 00       	push   $0x802fc9
  80155f:	e8 84 11 00 00       	call   8026e8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	68 5c 30 80 00       	push   $0x80305c
  80156c:	68 c3 00 00 00       	push   $0xc3
  801571:	68 c9 2f 80 00       	push   $0x802fc9
  801576:	e8 6d 11 00 00       	call   8026e8 <_panic>
		panic("panic in sys_env_set_status()\n");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 84 30 80 00       	push   $0x803084
  801583:	68 c6 00 00 00       	push   $0xc6
  801588:	68 c9 2f 80 00       	push   $0x802fc9
  80158d:	e8 56 11 00 00       	call   8026e8 <_panic>

00801592 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	05 00 00 00 30       	add    $0x30000000,%eax
  80159d:	c1 e8 0c             	shr    $0xc,%eax
}
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    

008015b9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015c1:	89 c2                	mov    %eax,%edx
  8015c3:	c1 ea 16             	shr    $0x16,%edx
  8015c6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015cd:	f6 c2 01             	test   $0x1,%dl
  8015d0:	74 2d                	je     8015ff <fd_alloc+0x46>
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	c1 ea 0c             	shr    $0xc,%edx
  8015d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015de:	f6 c2 01             	test   $0x1,%dl
  8015e1:	74 1c                	je     8015ff <fd_alloc+0x46>
  8015e3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015e8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015ed:	75 d2                	jne    8015c1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015f8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015fd:	eb 0a                	jmp    801609 <fd_alloc+0x50>
			*fd_store = fd;
  8015ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801602:	89 01                	mov    %eax,(%ecx)
			return 0;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801611:	83 f8 1f             	cmp    $0x1f,%eax
  801614:	77 30                	ja     801646 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801616:	c1 e0 0c             	shl    $0xc,%eax
  801619:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80161e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801624:	f6 c2 01             	test   $0x1,%dl
  801627:	74 24                	je     80164d <fd_lookup+0x42>
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 0c             	shr    $0xc,%edx
  80162e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 1a                	je     801654 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	89 02                	mov    %eax,(%edx)
	return 0;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    
		return -E_INVAL;
  801646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164b:	eb f7                	jmp    801644 <fd_lookup+0x39>
		return -E_INVAL;
  80164d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801652:	eb f0                	jmp    801644 <fd_lookup+0x39>
  801654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801659:	eb e9                	jmp    801644 <fd_lookup+0x39>

0080165b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80166e:	39 08                	cmp    %ecx,(%eax)
  801670:	74 38                	je     8016aa <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801672:	83 c2 01             	add    $0x1,%edx
  801675:	8b 04 95 20 31 80 00 	mov    0x803120(,%edx,4),%eax
  80167c:	85 c0                	test   %eax,%eax
  80167e:	75 ee                	jne    80166e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801680:	a1 08 50 80 00       	mov    0x805008,%eax
  801685:	8b 40 48             	mov    0x48(%eax),%eax
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	51                   	push   %ecx
  80168c:	50                   	push   %eax
  80168d:	68 a4 30 80 00       	push   $0x8030a4
  801692:	e8 ee eb ff ff       	call   800285 <cprintf>
	*dev = 0;
  801697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    
			*dev = devtab[i];
  8016aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ad:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	eb f2                	jmp    8016a8 <dev_lookup+0x4d>

008016b6 <fd_close>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	57                   	push   %edi
  8016ba:	56                   	push   %esi
  8016bb:	53                   	push   %ebx
  8016bc:	83 ec 24             	sub    $0x24,%esp
  8016bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8016c2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016cf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d2:	50                   	push   %eax
  8016d3:	e8 33 ff ff ff       	call   80160b <fd_lookup>
  8016d8:	89 c3                	mov    %eax,%ebx
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 05                	js     8016e6 <fd_close+0x30>
	    || fd != fd2)
  8016e1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016e4:	74 16                	je     8016fc <fd_close+0x46>
		return (must_exist ? r : 0);
  8016e6:	89 f8                	mov    %edi,%eax
  8016e8:	84 c0                	test   %al,%al
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	0f 44 d8             	cmove  %eax,%ebx
}
  8016f2:	89 d8                	mov    %ebx,%eax
  8016f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016fc:	83 ec 08             	sub    $0x8,%esp
  8016ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801702:	50                   	push   %eax
  801703:	ff 36                	pushl  (%esi)
  801705:	e8 51 ff ff ff       	call   80165b <dev_lookup>
  80170a:	89 c3                	mov    %eax,%ebx
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 1a                	js     80172d <fd_close+0x77>
		if (dev->dev_close)
  801713:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801716:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801719:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80171e:	85 c0                	test   %eax,%eax
  801720:	74 0b                	je     80172d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801722:	83 ec 0c             	sub    $0xc,%esp
  801725:	56                   	push   %esi
  801726:	ff d0                	call   *%eax
  801728:	89 c3                	mov    %eax,%ebx
  80172a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	56                   	push   %esi
  801731:	6a 00                	push   $0x0
  801733:	e8 23 f7 ff ff       	call   800e5b <sys_page_unmap>
	return r;
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	eb b5                	jmp    8016f2 <fd_close+0x3c>

0080173d <close>:

int
close(int fdnum)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	e8 bc fe ff ff       	call   80160b <fd_lookup>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	85 c0                	test   %eax,%eax
  801754:	79 02                	jns    801758 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    
		return fd_close(fd, 1);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	6a 01                	push   $0x1
  80175d:	ff 75 f4             	pushl  -0xc(%ebp)
  801760:	e8 51 ff ff ff       	call   8016b6 <fd_close>
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	eb ec                	jmp    801756 <close+0x19>

0080176a <close_all>:

void
close_all(void)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	53                   	push   %ebx
  80176e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801771:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	53                   	push   %ebx
  80177a:	e8 be ff ff ff       	call   80173d <close>
	for (i = 0; i < MAXFD; i++)
  80177f:	83 c3 01             	add    $0x1,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	83 fb 20             	cmp    $0x20,%ebx
  801788:	75 ec                	jne    801776 <close_all+0xc>
}
  80178a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	57                   	push   %edi
  801793:	56                   	push   %esi
  801794:	53                   	push   %ebx
  801795:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801798:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	e8 67 fe ff ff       	call   80160b <fd_lookup>
  8017a4:	89 c3                	mov    %eax,%ebx
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	0f 88 81 00 00 00    	js     801832 <dup+0xa3>
		return r;
	close(newfdnum);
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	e8 81 ff ff ff       	call   80173d <close>

	newfd = INDEX2FD(newfdnum);
  8017bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017bf:	c1 e6 0c             	shl    $0xc,%esi
  8017c2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017c8:	83 c4 04             	add    $0x4,%esp
  8017cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ce:	e8 cf fd ff ff       	call   8015a2 <fd2data>
  8017d3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017d5:	89 34 24             	mov    %esi,(%esp)
  8017d8:	e8 c5 fd ff ff       	call   8015a2 <fd2data>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017e2:	89 d8                	mov    %ebx,%eax
  8017e4:	c1 e8 16             	shr    $0x16,%eax
  8017e7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ee:	a8 01                	test   $0x1,%al
  8017f0:	74 11                	je     801803 <dup+0x74>
  8017f2:	89 d8                	mov    %ebx,%eax
  8017f4:	c1 e8 0c             	shr    $0xc,%eax
  8017f7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017fe:	f6 c2 01             	test   $0x1,%dl
  801801:	75 39                	jne    80183c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801806:	89 d0                	mov    %edx,%eax
  801808:	c1 e8 0c             	shr    $0xc,%eax
  80180b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	25 07 0e 00 00       	and    $0xe07,%eax
  80181a:	50                   	push   %eax
  80181b:	56                   	push   %esi
  80181c:	6a 00                	push   $0x0
  80181e:	52                   	push   %edx
  80181f:	6a 00                	push   $0x0
  801821:	e8 f3 f5 ff ff       	call   800e19 <sys_page_map>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 20             	add    $0x20,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 31                	js     801860 <dup+0xd1>
		goto err;

	return newfdnum;
  80182f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801832:	89 d8                	mov    %ebx,%eax
  801834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801837:	5b                   	pop    %ebx
  801838:	5e                   	pop    %esi
  801839:	5f                   	pop    %edi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80183c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801843:	83 ec 0c             	sub    $0xc,%esp
  801846:	25 07 0e 00 00       	and    $0xe07,%eax
  80184b:	50                   	push   %eax
  80184c:	57                   	push   %edi
  80184d:	6a 00                	push   $0x0
  80184f:	53                   	push   %ebx
  801850:	6a 00                	push   $0x0
  801852:	e8 c2 f5 ff ff       	call   800e19 <sys_page_map>
  801857:	89 c3                	mov    %eax,%ebx
  801859:	83 c4 20             	add    $0x20,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	79 a3                	jns    801803 <dup+0x74>
	sys_page_unmap(0, newfd);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	56                   	push   %esi
  801864:	6a 00                	push   $0x0
  801866:	e8 f0 f5 ff ff       	call   800e5b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80186b:	83 c4 08             	add    $0x8,%esp
  80186e:	57                   	push   %edi
  80186f:	6a 00                	push   $0x0
  801871:	e8 e5 f5 ff ff       	call   800e5b <sys_page_unmap>
	return r;
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	eb b7                	jmp    801832 <dup+0xa3>

0080187b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	53                   	push   %ebx
  80187f:	83 ec 1c             	sub    $0x1c,%esp
  801882:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801885:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801888:	50                   	push   %eax
  801889:	53                   	push   %ebx
  80188a:	e8 7c fd ff ff       	call   80160b <fd_lookup>
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	85 c0                	test   %eax,%eax
  801894:	78 3f                	js     8018d5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801896:	83 ec 08             	sub    $0x8,%esp
  801899:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189c:	50                   	push   %eax
  80189d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a0:	ff 30                	pushl  (%eax)
  8018a2:	e8 b4 fd ff ff       	call   80165b <dev_lookup>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	78 27                	js     8018d5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b1:	8b 42 08             	mov    0x8(%edx),%eax
  8018b4:	83 e0 03             	and    $0x3,%eax
  8018b7:	83 f8 01             	cmp    $0x1,%eax
  8018ba:	74 1e                	je     8018da <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bf:	8b 40 08             	mov    0x8(%eax),%eax
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	74 35                	je     8018fb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	ff 75 10             	pushl  0x10(%ebp)
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	52                   	push   %edx
  8018d0:	ff d0                	call   *%eax
  8018d2:	83 c4 10             	add    $0x10,%esp
}
  8018d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018da:	a1 08 50 80 00       	mov    0x805008,%eax
  8018df:	8b 40 48             	mov    0x48(%eax),%eax
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	53                   	push   %ebx
  8018e6:	50                   	push   %eax
  8018e7:	68 e5 30 80 00       	push   $0x8030e5
  8018ec:	e8 94 e9 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f9:	eb da                	jmp    8018d5 <read+0x5a>
		return -E_NOT_SUPP;
  8018fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801900:	eb d3                	jmp    8018d5 <read+0x5a>

00801902 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	57                   	push   %edi
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80190e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801911:	bb 00 00 00 00       	mov    $0x0,%ebx
  801916:	39 f3                	cmp    %esi,%ebx
  801918:	73 23                	jae    80193d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	89 f0                	mov    %esi,%eax
  80191f:	29 d8                	sub    %ebx,%eax
  801921:	50                   	push   %eax
  801922:	89 d8                	mov    %ebx,%eax
  801924:	03 45 0c             	add    0xc(%ebp),%eax
  801927:	50                   	push   %eax
  801928:	57                   	push   %edi
  801929:	e8 4d ff ff ff       	call   80187b <read>
		if (m < 0)
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	85 c0                	test   %eax,%eax
  801933:	78 06                	js     80193b <readn+0x39>
			return m;
		if (m == 0)
  801935:	74 06                	je     80193d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801937:	01 c3                	add    %eax,%ebx
  801939:	eb db                	jmp    801916 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80193b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80193d:	89 d8                	mov    %ebx,%eax
  80193f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5f                   	pop    %edi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 1c             	sub    $0x1c,%esp
  80194e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	50                   	push   %eax
  801955:	53                   	push   %ebx
  801956:	e8 b0 fc ff ff       	call   80160b <fd_lookup>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 3a                	js     80199c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801962:	83 ec 08             	sub    $0x8,%esp
  801965:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801968:	50                   	push   %eax
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196c:	ff 30                	pushl  (%eax)
  80196e:	e8 e8 fc ff ff       	call   80165b <dev_lookup>
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	85 c0                	test   %eax,%eax
  801978:	78 22                	js     80199c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801981:	74 1e                	je     8019a1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801986:	8b 52 0c             	mov    0xc(%edx),%edx
  801989:	85 d2                	test   %edx,%edx
  80198b:	74 35                	je     8019c2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	ff 75 10             	pushl  0x10(%ebp)
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	50                   	push   %eax
  801997:	ff d2                	call   *%edx
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8019a6:	8b 40 48             	mov    0x48(%eax),%eax
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	53                   	push   %ebx
  8019ad:	50                   	push   %eax
  8019ae:	68 01 31 80 00       	push   $0x803101
  8019b3:	e8 cd e8 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c0:	eb da                	jmp    80199c <write+0x55>
		return -E_NOT_SUPP;
  8019c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c7:	eb d3                	jmp    80199c <write+0x55>

008019c9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d2:	50                   	push   %eax
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	e8 30 fc ff ff       	call   80160b <fd_lookup>
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 0e                	js     8019f0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 1c             	sub    $0x1c,%esp
  8019f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ff:	50                   	push   %eax
  801a00:	53                   	push   %ebx
  801a01:	e8 05 fc ff ff       	call   80160b <fd_lookup>
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 37                	js     801a44 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a13:	50                   	push   %eax
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	ff 30                	pushl  (%eax)
  801a19:	e8 3d fc ff ff       	call   80165b <dev_lookup>
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 1f                	js     801a44 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a2c:	74 1b                	je     801a49 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a31:	8b 52 18             	mov    0x18(%edx),%edx
  801a34:	85 d2                	test   %edx,%edx
  801a36:	74 32                	je     801a6a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	50                   	push   %eax
  801a3f:	ff d2                	call   *%edx
  801a41:	83 c4 10             	add    $0x10,%esp
}
  801a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a49:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a4e:	8b 40 48             	mov    0x48(%eax),%eax
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	53                   	push   %ebx
  801a55:	50                   	push   %eax
  801a56:	68 c4 30 80 00       	push   $0x8030c4
  801a5b:	e8 25 e8 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a68:	eb da                	jmp    801a44 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6f:	eb d3                	jmp    801a44 <ftruncate+0x52>

00801a71 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	53                   	push   %ebx
  801a75:	83 ec 1c             	sub    $0x1c,%esp
  801a78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a7e:	50                   	push   %eax
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	e8 84 fb ff ff       	call   80160b <fd_lookup>
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 4b                	js     801ad9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a98:	ff 30                	pushl  (%eax)
  801a9a:	e8 bc fb ff ff       	call   80165b <dev_lookup>
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 33                	js     801ad9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aad:	74 2f                	je     801ade <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aaf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ab2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ab9:	00 00 00 
	stat->st_isdir = 0;
  801abc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ac3:	00 00 00 
	stat->st_dev = dev;
  801ac6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	53                   	push   %ebx
  801ad0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad3:	ff 50 14             	call   *0x14(%eax)
  801ad6:	83 c4 10             	add    $0x10,%esp
}
  801ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adc:	c9                   	leave  
  801add:	c3                   	ret    
		return -E_NOT_SUPP;
  801ade:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae3:	eb f4                	jmp    801ad9 <fstat+0x68>

00801ae5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	56                   	push   %esi
  801ae9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	6a 00                	push   $0x0
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	e8 22 02 00 00       	call   801d19 <open>
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 1b                	js     801b1b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	e8 65 ff ff ff       	call   801a71 <fstat>
  801b0c:	89 c6                	mov    %eax,%esi
	close(fd);
  801b0e:	89 1c 24             	mov    %ebx,(%esp)
  801b11:	e8 27 fc ff ff       	call   80173d <close>
	return r;
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	89 f3                	mov    %esi,%ebx
}
  801b1b:	89 d8                	mov    %ebx,%eax
  801b1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b20:	5b                   	pop    %ebx
  801b21:	5e                   	pop    %esi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    

00801b24 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
  801b29:	89 c6                	mov    %eax,%esi
  801b2b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b2d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b34:	74 27                	je     801b5d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b36:	6a 07                	push   $0x7
  801b38:	68 00 60 80 00       	push   $0x806000
  801b3d:	56                   	push   %esi
  801b3e:	ff 35 00 50 80 00    	pushl  0x805000
  801b44:	e8 fe 0c 00 00       	call   802847 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b49:	83 c4 0c             	add    $0xc,%esp
  801b4c:	6a 00                	push   $0x0
  801b4e:	53                   	push   %ebx
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 88 0c 00 00       	call   8027de <ipc_recv>
}
  801b56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5e                   	pop    %esi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	6a 01                	push   $0x1
  801b62:	e8 38 0d 00 00       	call   80289f <ipc_find_env>
  801b67:	a3 00 50 80 00       	mov    %eax,0x805000
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	eb c5                	jmp    801b36 <fsipc+0x12>

00801b71 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b85:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b94:	e8 8b ff ff ff       	call   801b24 <fsipc>
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <devfile_flush>:
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bac:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb1:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb6:	e8 69 ff ff ff       	call   801b24 <fsipc>
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <devfile_stat>:
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcd:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 05 00 00 00       	mov    $0x5,%eax
  801bdc:	e8 43 ff ff ff       	call   801b24 <fsipc>
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 2c                	js     801c11 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	68 00 60 80 00       	push   $0x806000
  801bed:	53                   	push   %ebx
  801bee:	e8 f1 ed ff ff       	call   8009e4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf3:	a1 80 60 80 00       	mov    0x806080,%eax
  801bf8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bfe:	a1 84 60 80 00       	mov    0x806084,%eax
  801c03:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <devfile_write>:
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 08             	sub    $0x8,%esp
  801c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8b 40 0c             	mov    0xc(%eax),%eax
  801c26:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c2b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c31:	53                   	push   %ebx
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	68 08 60 80 00       	push   $0x806008
  801c3a:	e8 95 ef ff ff       	call   800bd4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c44:	b8 04 00 00 00       	mov    $0x4,%eax
  801c49:	e8 d6 fe ff ff       	call   801b24 <fsipc>
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 0b                	js     801c60 <devfile_write+0x4a>
	assert(r <= n);
  801c55:	39 d8                	cmp    %ebx,%eax
  801c57:	77 0c                	ja     801c65 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c59:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c5e:	7f 1e                	jg     801c7e <devfile_write+0x68>
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    
	assert(r <= n);
  801c65:	68 34 31 80 00       	push   $0x803134
  801c6a:	68 3b 31 80 00       	push   $0x80313b
  801c6f:	68 98 00 00 00       	push   $0x98
  801c74:	68 50 31 80 00       	push   $0x803150
  801c79:	e8 6a 0a 00 00       	call   8026e8 <_panic>
	assert(r <= PGSIZE);
  801c7e:	68 5b 31 80 00       	push   $0x80315b
  801c83:	68 3b 31 80 00       	push   $0x80313b
  801c88:	68 99 00 00 00       	push   $0x99
  801c8d:	68 50 31 80 00       	push   $0x803150
  801c92:	e8 51 0a 00 00       	call   8026e8 <_panic>

00801c97 <devfile_read>:
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801caa:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb5:	b8 03 00 00 00       	mov    $0x3,%eax
  801cba:	e8 65 fe ff ff       	call   801b24 <fsipc>
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 1f                	js     801ce4 <devfile_read+0x4d>
	assert(r <= n);
  801cc5:	39 f0                	cmp    %esi,%eax
  801cc7:	77 24                	ja     801ced <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cc9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cce:	7f 33                	jg     801d03 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	50                   	push   %eax
  801cd4:	68 00 60 80 00       	push   $0x806000
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	e8 91 ee ff ff       	call   800b72 <memmove>
	return r;
  801ce1:	83 c4 10             	add    $0x10,%esp
}
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce9:	5b                   	pop    %ebx
  801cea:	5e                   	pop    %esi
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    
	assert(r <= n);
  801ced:	68 34 31 80 00       	push   $0x803134
  801cf2:	68 3b 31 80 00       	push   $0x80313b
  801cf7:	6a 7c                	push   $0x7c
  801cf9:	68 50 31 80 00       	push   $0x803150
  801cfe:	e8 e5 09 00 00       	call   8026e8 <_panic>
	assert(r <= PGSIZE);
  801d03:	68 5b 31 80 00       	push   $0x80315b
  801d08:	68 3b 31 80 00       	push   $0x80313b
  801d0d:	6a 7d                	push   $0x7d
  801d0f:	68 50 31 80 00       	push   $0x803150
  801d14:	e8 cf 09 00 00       	call   8026e8 <_panic>

00801d19 <open>:
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	56                   	push   %esi
  801d1d:	53                   	push   %ebx
  801d1e:	83 ec 1c             	sub    $0x1c,%esp
  801d21:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d24:	56                   	push   %esi
  801d25:	e8 81 ec ff ff       	call   8009ab <strlen>
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d32:	7f 6c                	jg     801da0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3a:	50                   	push   %eax
  801d3b:	e8 79 f8 ff ff       	call   8015b9 <fd_alloc>
  801d40:	89 c3                	mov    %eax,%ebx
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 3c                	js     801d85 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d49:	83 ec 08             	sub    $0x8,%esp
  801d4c:	56                   	push   %esi
  801d4d:	68 00 60 80 00       	push   $0x806000
  801d52:	e8 8d ec ff ff       	call   8009e4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	e8 b8 fd ff ff       	call   801b24 <fsipc>
  801d6c:	89 c3                	mov    %eax,%ebx
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 19                	js     801d8e <open+0x75>
	return fd2num(fd);
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7b:	e8 12 f8 ff ff       	call   801592 <fd2num>
  801d80:	89 c3                	mov    %eax,%ebx
  801d82:	83 c4 10             	add    $0x10,%esp
}
  801d85:	89 d8                	mov    %ebx,%eax
  801d87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8a:	5b                   	pop    %ebx
  801d8b:	5e                   	pop    %esi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    
		fd_close(fd, 0);
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	6a 00                	push   $0x0
  801d93:	ff 75 f4             	pushl  -0xc(%ebp)
  801d96:	e8 1b f9 ff ff       	call   8016b6 <fd_close>
		return r;
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	eb e5                	jmp    801d85 <open+0x6c>
		return -E_BAD_PATH;
  801da0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801da5:	eb de                	jmp    801d85 <open+0x6c>

00801da7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dad:	ba 00 00 00 00       	mov    $0x0,%edx
  801db2:	b8 08 00 00 00       	mov    $0x8,%eax
  801db7:	e8 68 fd ff ff       	call   801b24 <fsipc>
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dc4:	68 67 31 80 00       	push   $0x803167
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	e8 13 ec ff ff       	call   8009e4 <strcpy>
	return 0;
}
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <devsock_close>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	53                   	push   %ebx
  801ddc:	83 ec 10             	sub    $0x10,%esp
  801ddf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801de2:	53                   	push   %ebx
  801de3:	e8 f2 0a 00 00       	call   8028da <pageref>
  801de8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801deb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801df0:	83 f8 01             	cmp    $0x1,%eax
  801df3:	74 07                	je     801dfc <devsock_close+0x24>
}
  801df5:	89 d0                	mov    %edx,%eax
  801df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 73 0c             	pushl  0xc(%ebx)
  801e02:	e8 b9 02 00 00       	call   8020c0 <nsipc_close>
  801e07:	89 c2                	mov    %eax,%edx
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	eb e7                	jmp    801df5 <devsock_close+0x1d>

00801e0e <devsock_write>:
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 10             	pushl  0x10(%ebp)
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	ff 70 0c             	pushl  0xc(%eax)
  801e22:	e8 76 03 00 00       	call   80219d <nsipc_send>
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <devsock_read>:
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	ff 75 10             	pushl  0x10(%ebp)
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	ff 70 0c             	pushl  0xc(%eax)
  801e3d:	e8 ef 02 00 00       	call   802131 <nsipc_recv>
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <fd2sockid>:
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	e8 b7 f7 ff ff       	call   80160b <fd_lookup>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 10                	js     801e6b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e64:	39 08                	cmp    %ecx,(%eax)
  801e66:	75 05                	jne    801e6d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e68:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    
		return -E_NOT_SUPP;
  801e6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e72:	eb f7                	jmp    801e6b <fd2sockid+0x27>

00801e74 <alloc_sockfd>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	83 ec 1c             	sub    $0x1c,%esp
  801e7c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e81:	50                   	push   %eax
  801e82:	e8 32 f7 ff ff       	call   8015b9 <fd_alloc>
  801e87:	89 c3                	mov    %eax,%ebx
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 43                	js     801ed3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 07 04 00 00       	push   $0x407
  801e98:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9b:	6a 00                	push   $0x0
  801e9d:	e8 34 ef ff ff       	call   800dd6 <sys_page_alloc>
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 28                	js     801ed3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801eb4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ec0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	50                   	push   %eax
  801ec7:	e8 c6 f6 ff ff       	call   801592 <fd2num>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	eb 0c                	jmp    801edf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	56                   	push   %esi
  801ed7:	e8 e4 01 00 00       	call   8020c0 <nsipc_close>
		return r;
  801edc:	83 c4 10             	add    $0x10,%esp
}
  801edf:	89 d8                	mov    %ebx,%eax
  801ee1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee4:	5b                   	pop    %ebx
  801ee5:	5e                   	pop    %esi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <accept>:
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	e8 4e ff ff ff       	call   801e44 <fd2sockid>
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 1b                	js     801f15 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	ff 75 10             	pushl  0x10(%ebp)
  801f00:	ff 75 0c             	pushl  0xc(%ebp)
  801f03:	50                   	push   %eax
  801f04:	e8 0e 01 00 00       	call   802017 <nsipc_accept>
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	78 05                	js     801f15 <accept+0x2d>
	return alloc_sockfd(r);
  801f10:	e8 5f ff ff ff       	call   801e74 <alloc_sockfd>
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <bind>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	e8 1f ff ff ff       	call   801e44 <fd2sockid>
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 12                	js     801f3b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	ff 75 10             	pushl  0x10(%ebp)
  801f2f:	ff 75 0c             	pushl  0xc(%ebp)
  801f32:	50                   	push   %eax
  801f33:	e8 31 01 00 00       	call   802069 <nsipc_bind>
  801f38:	83 c4 10             	add    $0x10,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <shutdown>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	e8 f9 fe ff ff       	call   801e44 <fd2sockid>
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 0f                	js     801f5e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f4f:	83 ec 08             	sub    $0x8,%esp
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	50                   	push   %eax
  801f56:	e8 43 01 00 00       	call   80209e <nsipc_shutdown>
  801f5b:	83 c4 10             	add    $0x10,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <connect>:
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	e8 d6 fe ff ff       	call   801e44 <fd2sockid>
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 12                	js     801f84 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	ff 75 10             	pushl  0x10(%ebp)
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	50                   	push   %eax
  801f7c:	e8 59 01 00 00       	call   8020da <nsipc_connect>
  801f81:	83 c4 10             	add    $0x10,%esp
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <listen>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	e8 b0 fe ff ff       	call   801e44 <fd2sockid>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 0f                	js     801fa7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	50                   	push   %eax
  801f9f:	e8 6b 01 00 00       	call   80210f <nsipc_listen>
  801fa4:	83 c4 10             	add    $0x10,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801faf:	ff 75 10             	pushl  0x10(%ebp)
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	e8 3e 02 00 00       	call   8021fb <nsipc_socket>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 05                	js     801fc9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fc4:	e8 ab fe ff ff       	call   801e74 <alloc_sockfd>
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fd4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fdb:	74 26                	je     802003 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fdd:	6a 07                	push   $0x7
  801fdf:	68 00 70 80 00       	push   $0x807000
  801fe4:	53                   	push   %ebx
  801fe5:	ff 35 04 50 80 00    	pushl  0x805004
  801feb:	e8 57 08 00 00       	call   802847 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ff0:	83 c4 0c             	add    $0xc,%esp
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 e0 07 00 00       	call   8027de <ipc_recv>
}
  801ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802001:	c9                   	leave  
  802002:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	6a 02                	push   $0x2
  802008:	e8 92 08 00 00       	call   80289f <ipc_find_env>
  80200d:	a3 04 50 80 00       	mov    %eax,0x805004
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	eb c6                	jmp    801fdd <nsipc+0x12>

00802017 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	56                   	push   %esi
  80201b:	53                   	push   %ebx
  80201c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802027:	8b 06                	mov    (%esi),%eax
  802029:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	e8 93 ff ff ff       	call   801fcb <nsipc>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	85 c0                	test   %eax,%eax
  80203c:	79 09                	jns    802047 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80203e:	89 d8                	mov    %ebx,%eax
  802040:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	ff 35 10 70 80 00    	pushl  0x807010
  802050:	68 00 70 80 00       	push   $0x807000
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	e8 15 eb ff ff       	call   800b72 <memmove>
		*addrlen = ret->ret_addrlen;
  80205d:	a1 10 70 80 00       	mov    0x807010,%eax
  802062:	89 06                	mov    %eax,(%esi)
  802064:	83 c4 10             	add    $0x10,%esp
	return r;
  802067:	eb d5                	jmp    80203e <nsipc_accept+0x27>

00802069 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	53                   	push   %ebx
  80206d:	83 ec 08             	sub    $0x8,%esp
  802070:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80207b:	53                   	push   %ebx
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	68 04 70 80 00       	push   $0x807004
  802084:	e8 e9 ea ff ff       	call   800b72 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802089:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80208f:	b8 02 00 00 00       	mov    $0x2,%eax
  802094:	e8 32 ff ff ff       	call   801fcb <nsipc>
}
  802099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b9:	e8 0d ff ff ff       	call   801fcb <nsipc>
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8020d3:	e8 f3 fe ff ff       	call   801fcb <nsipc>
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 08             	sub    $0x8,%esp
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020ec:	53                   	push   %ebx
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	68 04 70 80 00       	push   $0x807004
  8020f5:	e8 78 ea ff ff       	call   800b72 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020fa:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802100:	b8 05 00 00 00       	mov    $0x5,%eax
  802105:	e8 c1 fe ff ff       	call   801fcb <nsipc>
}
  80210a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80211d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802120:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802125:	b8 06 00 00 00       	mov    $0x6,%eax
  80212a:	e8 9c fe ff ff       	call   801fcb <nsipc>
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	56                   	push   %esi
  802135:	53                   	push   %ebx
  802136:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802141:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802147:	8b 45 14             	mov    0x14(%ebp),%eax
  80214a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80214f:	b8 07 00 00 00       	mov    $0x7,%eax
  802154:	e8 72 fe ff ff       	call   801fcb <nsipc>
  802159:	89 c3                	mov    %eax,%ebx
  80215b:	85 c0                	test   %eax,%eax
  80215d:	78 1f                	js     80217e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80215f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802164:	7f 21                	jg     802187 <nsipc_recv+0x56>
  802166:	39 c6                	cmp    %eax,%esi
  802168:	7c 1d                	jl     802187 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	50                   	push   %eax
  80216e:	68 00 70 80 00       	push   $0x807000
  802173:	ff 75 0c             	pushl  0xc(%ebp)
  802176:	e8 f7 e9 ff ff       	call   800b72 <memmove>
  80217b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80217e:	89 d8                	mov    %ebx,%eax
  802180:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5d                   	pop    %ebp
  802186:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802187:	68 73 31 80 00       	push   $0x803173
  80218c:	68 3b 31 80 00       	push   $0x80313b
  802191:	6a 62                	push   $0x62
  802193:	68 88 31 80 00       	push   $0x803188
  802198:	e8 4b 05 00 00       	call   8026e8 <_panic>

0080219d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	53                   	push   %ebx
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021af:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021b5:	7f 2e                	jg     8021e5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	53                   	push   %ebx
  8021bb:	ff 75 0c             	pushl  0xc(%ebp)
  8021be:	68 0c 70 80 00       	push   $0x80700c
  8021c3:	e8 aa e9 ff ff       	call   800b72 <memmove>
	nsipcbuf.send.req_size = size;
  8021c8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021db:	e8 eb fd ff ff       	call   801fcb <nsipc>
}
  8021e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    
	assert(size < 1600);
  8021e5:	68 94 31 80 00       	push   $0x803194
  8021ea:	68 3b 31 80 00       	push   $0x80313b
  8021ef:	6a 6d                	push   $0x6d
  8021f1:	68 88 31 80 00       	push   $0x803188
  8021f6:	e8 ed 04 00 00       	call   8026e8 <_panic>

008021fb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802211:	8b 45 10             	mov    0x10(%ebp),%eax
  802214:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802219:	b8 09 00 00 00       	mov    $0x9,%eax
  80221e:	e8 a8 fd ff ff       	call   801fcb <nsipc>
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	56                   	push   %esi
  802229:	53                   	push   %ebx
  80222a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80222d:	83 ec 0c             	sub    $0xc,%esp
  802230:	ff 75 08             	pushl  0x8(%ebp)
  802233:	e8 6a f3 ff ff       	call   8015a2 <fd2data>
  802238:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80223a:	83 c4 08             	add    $0x8,%esp
  80223d:	68 a0 31 80 00       	push   $0x8031a0
  802242:	53                   	push   %ebx
  802243:	e8 9c e7 ff ff       	call   8009e4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802248:	8b 46 04             	mov    0x4(%esi),%eax
  80224b:	2b 06                	sub    (%esi),%eax
  80224d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802253:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80225a:	00 00 00 
	stat->st_dev = &devpipe;
  80225d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802264:	40 80 00 
	return 0;
}
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	53                   	push   %ebx
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80227d:	53                   	push   %ebx
  80227e:	6a 00                	push   $0x0
  802280:	e8 d6 eb ff ff       	call   800e5b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802285:	89 1c 24             	mov    %ebx,(%esp)
  802288:	e8 15 f3 ff ff       	call   8015a2 <fd2data>
  80228d:	83 c4 08             	add    $0x8,%esp
  802290:	50                   	push   %eax
  802291:	6a 00                	push   $0x0
  802293:	e8 c3 eb ff ff       	call   800e5b <sys_page_unmap>
}
  802298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <_pipeisclosed>:
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	57                   	push   %edi
  8022a1:	56                   	push   %esi
  8022a2:	53                   	push   %ebx
  8022a3:	83 ec 1c             	sub    $0x1c,%esp
  8022a6:	89 c7                	mov    %eax,%edi
  8022a8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8022af:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022b2:	83 ec 0c             	sub    $0xc,%esp
  8022b5:	57                   	push   %edi
  8022b6:	e8 1f 06 00 00       	call   8028da <pageref>
  8022bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022be:	89 34 24             	mov    %esi,(%esp)
  8022c1:	e8 14 06 00 00       	call   8028da <pageref>
		nn = thisenv->env_runs;
  8022c6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8022cc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022cf:	83 c4 10             	add    $0x10,%esp
  8022d2:	39 cb                	cmp    %ecx,%ebx
  8022d4:	74 1b                	je     8022f1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022d6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022d9:	75 cf                	jne    8022aa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022db:	8b 42 58             	mov    0x58(%edx),%eax
  8022de:	6a 01                	push   $0x1
  8022e0:	50                   	push   %eax
  8022e1:	53                   	push   %ebx
  8022e2:	68 a7 31 80 00       	push   $0x8031a7
  8022e7:	e8 99 df ff ff       	call   800285 <cprintf>
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	eb b9                	jmp    8022aa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022f1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022f4:	0f 94 c0             	sete   %al
  8022f7:	0f b6 c0             	movzbl %al,%eax
}
  8022fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022fd:	5b                   	pop    %ebx
  8022fe:	5e                   	pop    %esi
  8022ff:	5f                   	pop    %edi
  802300:	5d                   	pop    %ebp
  802301:	c3                   	ret    

00802302 <devpipe_write>:
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 28             	sub    $0x28,%esp
  80230b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80230e:	56                   	push   %esi
  80230f:	e8 8e f2 ff ff       	call   8015a2 <fd2data>
  802314:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802316:	83 c4 10             	add    $0x10,%esp
  802319:	bf 00 00 00 00       	mov    $0x0,%edi
  80231e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802321:	74 4f                	je     802372 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802323:	8b 43 04             	mov    0x4(%ebx),%eax
  802326:	8b 0b                	mov    (%ebx),%ecx
  802328:	8d 51 20             	lea    0x20(%ecx),%edx
  80232b:	39 d0                	cmp    %edx,%eax
  80232d:	72 14                	jb     802343 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80232f:	89 da                	mov    %ebx,%edx
  802331:	89 f0                	mov    %esi,%eax
  802333:	e8 65 ff ff ff       	call   80229d <_pipeisclosed>
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 3b                	jne    802377 <devpipe_write+0x75>
			sys_yield();
  80233c:	e8 76 ea ff ff       	call   800db7 <sys_yield>
  802341:	eb e0                	jmp    802323 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802343:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802346:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80234a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80234d:	89 c2                	mov    %eax,%edx
  80234f:	c1 fa 1f             	sar    $0x1f,%edx
  802352:	89 d1                	mov    %edx,%ecx
  802354:	c1 e9 1b             	shr    $0x1b,%ecx
  802357:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80235a:	83 e2 1f             	and    $0x1f,%edx
  80235d:	29 ca                	sub    %ecx,%edx
  80235f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802363:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802367:	83 c0 01             	add    $0x1,%eax
  80236a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80236d:	83 c7 01             	add    $0x1,%edi
  802370:	eb ac                	jmp    80231e <devpipe_write+0x1c>
	return i;
  802372:	8b 45 10             	mov    0x10(%ebp),%eax
  802375:	eb 05                	jmp    80237c <devpipe_write+0x7a>
				return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <devpipe_read>:
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	57                   	push   %edi
  802388:	56                   	push   %esi
  802389:	53                   	push   %ebx
  80238a:	83 ec 18             	sub    $0x18,%esp
  80238d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802390:	57                   	push   %edi
  802391:	e8 0c f2 ff ff       	call   8015a2 <fd2data>
  802396:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802398:	83 c4 10             	add    $0x10,%esp
  80239b:	be 00 00 00 00       	mov    $0x0,%esi
  8023a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023a3:	75 14                	jne    8023b9 <devpipe_read+0x35>
	return i;
  8023a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a8:	eb 02                	jmp    8023ac <devpipe_read+0x28>
				return i;
  8023aa:	89 f0                	mov    %esi,%eax
}
  8023ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    
			sys_yield();
  8023b4:	e8 fe e9 ff ff       	call   800db7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023b9:	8b 03                	mov    (%ebx),%eax
  8023bb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023be:	75 18                	jne    8023d8 <devpipe_read+0x54>
			if (i > 0)
  8023c0:	85 f6                	test   %esi,%esi
  8023c2:	75 e6                	jne    8023aa <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023c4:	89 da                	mov    %ebx,%edx
  8023c6:	89 f8                	mov    %edi,%eax
  8023c8:	e8 d0 fe ff ff       	call   80229d <_pipeisclosed>
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 e3                	je     8023b4 <devpipe_read+0x30>
				return 0;
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	eb d4                	jmp    8023ac <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d8:	99                   	cltd   
  8023d9:	c1 ea 1b             	shr    $0x1b,%edx
  8023dc:	01 d0                	add    %edx,%eax
  8023de:	83 e0 1f             	and    $0x1f,%eax
  8023e1:	29 d0                	sub    %edx,%eax
  8023e3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023eb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023ee:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023f1:	83 c6 01             	add    $0x1,%esi
  8023f4:	eb aa                	jmp    8023a0 <devpipe_read+0x1c>

008023f6 <pipe>:
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	56                   	push   %esi
  8023fa:	53                   	push   %ebx
  8023fb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802401:	50                   	push   %eax
  802402:	e8 b2 f1 ff ff       	call   8015b9 <fd_alloc>
  802407:	89 c3                	mov    %eax,%ebx
  802409:	83 c4 10             	add    $0x10,%esp
  80240c:	85 c0                	test   %eax,%eax
  80240e:	0f 88 23 01 00 00    	js     802537 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	68 07 04 00 00       	push   $0x407
  80241c:	ff 75 f4             	pushl  -0xc(%ebp)
  80241f:	6a 00                	push   $0x0
  802421:	e8 b0 e9 ff ff       	call   800dd6 <sys_page_alloc>
  802426:	89 c3                	mov    %eax,%ebx
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	85 c0                	test   %eax,%eax
  80242d:	0f 88 04 01 00 00    	js     802537 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802439:	50                   	push   %eax
  80243a:	e8 7a f1 ff ff       	call   8015b9 <fd_alloc>
  80243f:	89 c3                	mov    %eax,%ebx
  802441:	83 c4 10             	add    $0x10,%esp
  802444:	85 c0                	test   %eax,%eax
  802446:	0f 88 db 00 00 00    	js     802527 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 07 04 00 00       	push   $0x407
  802454:	ff 75 f0             	pushl  -0x10(%ebp)
  802457:	6a 00                	push   $0x0
  802459:	e8 78 e9 ff ff       	call   800dd6 <sys_page_alloc>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	85 c0                	test   %eax,%eax
  802465:	0f 88 bc 00 00 00    	js     802527 <pipe+0x131>
	va = fd2data(fd0);
  80246b:	83 ec 0c             	sub    $0xc,%esp
  80246e:	ff 75 f4             	pushl  -0xc(%ebp)
  802471:	e8 2c f1 ff ff       	call   8015a2 <fd2data>
  802476:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802478:	83 c4 0c             	add    $0xc,%esp
  80247b:	68 07 04 00 00       	push   $0x407
  802480:	50                   	push   %eax
  802481:	6a 00                	push   $0x0
  802483:	e8 4e e9 ff ff       	call   800dd6 <sys_page_alloc>
  802488:	89 c3                	mov    %eax,%ebx
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	85 c0                	test   %eax,%eax
  80248f:	0f 88 82 00 00 00    	js     802517 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	ff 75 f0             	pushl  -0x10(%ebp)
  80249b:	e8 02 f1 ff ff       	call   8015a2 <fd2data>
  8024a0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024a7:	50                   	push   %eax
  8024a8:	6a 00                	push   $0x0
  8024aa:	56                   	push   %esi
  8024ab:	6a 00                	push   $0x0
  8024ad:	e8 67 e9 ff ff       	call   800e19 <sys_page_map>
  8024b2:	89 c3                	mov    %eax,%ebx
  8024b4:	83 c4 20             	add    $0x20,%esp
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	78 4e                	js     802509 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024bb:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024de:	83 ec 0c             	sub    $0xc,%esp
  8024e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e4:	e8 a9 f0 ff ff       	call   801592 <fd2num>
  8024e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024ee:	83 c4 04             	add    $0x4,%esp
  8024f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f4:	e8 99 f0 ff ff       	call   801592 <fd2num>
  8024f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	bb 00 00 00 00       	mov    $0x0,%ebx
  802507:	eb 2e                	jmp    802537 <pipe+0x141>
	sys_page_unmap(0, va);
  802509:	83 ec 08             	sub    $0x8,%esp
  80250c:	56                   	push   %esi
  80250d:	6a 00                	push   $0x0
  80250f:	e8 47 e9 ff ff       	call   800e5b <sys_page_unmap>
  802514:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802517:	83 ec 08             	sub    $0x8,%esp
  80251a:	ff 75 f0             	pushl  -0x10(%ebp)
  80251d:	6a 00                	push   $0x0
  80251f:	e8 37 e9 ff ff       	call   800e5b <sys_page_unmap>
  802524:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802527:	83 ec 08             	sub    $0x8,%esp
  80252a:	ff 75 f4             	pushl  -0xc(%ebp)
  80252d:	6a 00                	push   $0x0
  80252f:	e8 27 e9 ff ff       	call   800e5b <sys_page_unmap>
  802534:	83 c4 10             	add    $0x10,%esp
}
  802537:	89 d8                	mov    %ebx,%eax
  802539:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5d                   	pop    %ebp
  80253f:	c3                   	ret    

00802540 <pipeisclosed>:
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 b9 f0 ff ff       	call   80160b <fd_lookup>
  802552:	83 c4 10             	add    $0x10,%esp
  802555:	85 c0                	test   %eax,%eax
  802557:	78 18                	js     802571 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	ff 75 f4             	pushl  -0xc(%ebp)
  80255f:	e8 3e f0 ff ff       	call   8015a2 <fd2data>
	return _pipeisclosed(fd, p);
  802564:	89 c2                	mov    %eax,%edx
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	e8 2f fd ff ff       	call   80229d <_pipeisclosed>
  80256e:	83 c4 10             	add    $0x10,%esp
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	c3                   	ret    

00802579 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80257f:	68 bf 31 80 00       	push   $0x8031bf
  802584:	ff 75 0c             	pushl  0xc(%ebp)
  802587:	e8 58 e4 ff ff       	call   8009e4 <strcpy>
	return 0;
}
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <devcons_write>:
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	57                   	push   %edi
  802597:	56                   	push   %esi
  802598:	53                   	push   %ebx
  802599:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80259f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025a4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ad:	73 31                	jae    8025e0 <devcons_write+0x4d>
		m = n - tot;
  8025af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025b2:	29 f3                	sub    %esi,%ebx
  8025b4:	83 fb 7f             	cmp    $0x7f,%ebx
  8025b7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025bc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	53                   	push   %ebx
  8025c3:	89 f0                	mov    %esi,%eax
  8025c5:	03 45 0c             	add    0xc(%ebp),%eax
  8025c8:	50                   	push   %eax
  8025c9:	57                   	push   %edi
  8025ca:	e8 a3 e5 ff ff       	call   800b72 <memmove>
		sys_cputs(buf, m);
  8025cf:	83 c4 08             	add    $0x8,%esp
  8025d2:	53                   	push   %ebx
  8025d3:	57                   	push   %edi
  8025d4:	e8 41 e7 ff ff       	call   800d1a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025d9:	01 de                	add    %ebx,%esi
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	eb ca                	jmp    8025aa <devcons_write+0x17>
}
  8025e0:	89 f0                	mov    %esi,%eax
  8025e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025e5:	5b                   	pop    %ebx
  8025e6:	5e                   	pop    %esi
  8025e7:	5f                   	pop    %edi
  8025e8:	5d                   	pop    %ebp
  8025e9:	c3                   	ret    

008025ea <devcons_read>:
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 08             	sub    $0x8,%esp
  8025f0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025f9:	74 21                	je     80261c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025fb:	e8 38 e7 ff ff       	call   800d38 <sys_cgetc>
  802600:	85 c0                	test   %eax,%eax
  802602:	75 07                	jne    80260b <devcons_read+0x21>
		sys_yield();
  802604:	e8 ae e7 ff ff       	call   800db7 <sys_yield>
  802609:	eb f0                	jmp    8025fb <devcons_read+0x11>
	if (c < 0)
  80260b:	78 0f                	js     80261c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80260d:	83 f8 04             	cmp    $0x4,%eax
  802610:	74 0c                	je     80261e <devcons_read+0x34>
	*(char*)vbuf = c;
  802612:	8b 55 0c             	mov    0xc(%ebp),%edx
  802615:	88 02                	mov    %al,(%edx)
	return 1;
  802617:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    
		return 0;
  80261e:	b8 00 00 00 00       	mov    $0x0,%eax
  802623:	eb f7                	jmp    80261c <devcons_read+0x32>

00802625 <cputchar>:
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802631:	6a 01                	push   $0x1
  802633:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802636:	50                   	push   %eax
  802637:	e8 de e6 ff ff       	call   800d1a <sys_cputs>
}
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <getchar>:
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802647:	6a 01                	push   $0x1
  802649:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80264c:	50                   	push   %eax
  80264d:	6a 00                	push   $0x0
  80264f:	e8 27 f2 ff ff       	call   80187b <read>
	if (r < 0)
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 06                	js     802661 <getchar+0x20>
	if (r < 1)
  80265b:	74 06                	je     802663 <getchar+0x22>
	return c;
  80265d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    
		return -E_EOF;
  802663:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802668:	eb f7                	jmp    802661 <getchar+0x20>

0080266a <iscons>:
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802670:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802673:	50                   	push   %eax
  802674:	ff 75 08             	pushl  0x8(%ebp)
  802677:	e8 8f ef ff ff       	call   80160b <fd_lookup>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 11                	js     802694 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80268c:	39 10                	cmp    %edx,(%eax)
  80268e:	0f 94 c0             	sete   %al
  802691:	0f b6 c0             	movzbl %al,%eax
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <opencons>:
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80269c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269f:	50                   	push   %eax
  8026a0:	e8 14 ef ff ff       	call   8015b9 <fd_alloc>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	78 3a                	js     8026e6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 07 04 00 00       	push   $0x407
  8026b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b7:	6a 00                	push   $0x0
  8026b9:	e8 18 e7 ff ff       	call   800dd6 <sys_page_alloc>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	78 21                	js     8026e6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ce:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	50                   	push   %eax
  8026de:	e8 af ee ff ff       	call   801592 <fd2num>
  8026e3:	83 c4 10             	add    $0x10,%esp
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	56                   	push   %esi
  8026ec:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8026ed:	a1 08 50 80 00       	mov    0x805008,%eax
  8026f2:	8b 40 48             	mov    0x48(%eax),%eax
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	68 f0 31 80 00       	push   $0x8031f0
  8026fd:	50                   	push   %eax
  8026fe:	68 ee 2b 80 00       	push   $0x802bee
  802703:	e8 7d db ff ff       	call   800285 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802708:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80270b:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802711:	e8 82 e6 ff ff       	call   800d98 <sys_getenvid>
  802716:	83 c4 04             	add    $0x4,%esp
  802719:	ff 75 0c             	pushl  0xc(%ebp)
  80271c:	ff 75 08             	pushl  0x8(%ebp)
  80271f:	56                   	push   %esi
  802720:	50                   	push   %eax
  802721:	68 cc 31 80 00       	push   $0x8031cc
  802726:	e8 5a db ff ff       	call   800285 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80272b:	83 c4 18             	add    $0x18,%esp
  80272e:	53                   	push   %ebx
  80272f:	ff 75 10             	pushl  0x10(%ebp)
  802732:	e8 fd da ff ff       	call   800234 <vcprintf>
	cprintf("\n");
  802737:	c7 04 24 b2 2b 80 00 	movl   $0x802bb2,(%esp)
  80273e:	e8 42 db ff ff       	call   800285 <cprintf>
  802743:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802746:	cc                   	int3   
  802747:	eb fd                	jmp    802746 <_panic+0x5e>

00802749 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80274f:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802756:	74 0a                	je     802762 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	6a 07                	push   $0x7
  802767:	68 00 f0 bf ee       	push   $0xeebff000
  80276c:	6a 00                	push   $0x0
  80276e:	e8 63 e6 ff ff       	call   800dd6 <sys_page_alloc>
		if(r < 0)
  802773:	83 c4 10             	add    $0x10,%esp
  802776:	85 c0                	test   %eax,%eax
  802778:	78 2a                	js     8027a4 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80277a:	83 ec 08             	sub    $0x8,%esp
  80277d:	68 b8 27 80 00       	push   $0x8027b8
  802782:	6a 00                	push   $0x0
  802784:	e8 98 e7 ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802789:	83 c4 10             	add    $0x10,%esp
  80278c:	85 c0                	test   %eax,%eax
  80278e:	79 c8                	jns    802758 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 28 32 80 00       	push   $0x803228
  802798:	6a 25                	push   $0x25
  80279a:	68 64 32 80 00       	push   $0x803264
  80279f:	e8 44 ff ff ff       	call   8026e8 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027a4:	83 ec 04             	sub    $0x4,%esp
  8027a7:	68 f8 31 80 00       	push   $0x8031f8
  8027ac:	6a 22                	push   $0x22
  8027ae:	68 64 32 80 00       	push   $0x803264
  8027b3:	e8 30 ff ff ff       	call   8026e8 <_panic>

008027b8 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027b8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027b9:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027be:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027c0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027c3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027c7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027cb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027ce:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027d0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027d4:	83 c4 08             	add    $0x8,%esp
	popal
  8027d7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027d8:	83 c4 04             	add    $0x4,%esp
	popfl
  8027db:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027dc:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027dd:	c3                   	ret    

008027de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	56                   	push   %esi
  8027e2:	53                   	push   %ebx
  8027e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8027ec:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027ee:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027f3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	50                   	push   %eax
  8027fa:	e8 87 e7 ff ff       	call   800f86 <sys_ipc_recv>
	if(ret < 0){
  8027ff:	83 c4 10             	add    $0x10,%esp
  802802:	85 c0                	test   %eax,%eax
  802804:	78 2b                	js     802831 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802806:	85 f6                	test   %esi,%esi
  802808:	74 0a                	je     802814 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80280a:	a1 08 50 80 00       	mov    0x805008,%eax
  80280f:	8b 40 74             	mov    0x74(%eax),%eax
  802812:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802814:	85 db                	test   %ebx,%ebx
  802816:	74 0a                	je     802822 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802818:	a1 08 50 80 00       	mov    0x805008,%eax
  80281d:	8b 40 78             	mov    0x78(%eax),%eax
  802820:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802822:	a1 08 50 80 00       	mov    0x805008,%eax
  802827:	8b 40 70             	mov    0x70(%eax),%eax
}
  80282a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80282d:	5b                   	pop    %ebx
  80282e:	5e                   	pop    %esi
  80282f:	5d                   	pop    %ebp
  802830:	c3                   	ret    
		if(from_env_store)
  802831:	85 f6                	test   %esi,%esi
  802833:	74 06                	je     80283b <ipc_recv+0x5d>
			*from_env_store = 0;
  802835:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80283b:	85 db                	test   %ebx,%ebx
  80283d:	74 eb                	je     80282a <ipc_recv+0x4c>
			*perm_store = 0;
  80283f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802845:	eb e3                	jmp    80282a <ipc_recv+0x4c>

00802847 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	57                   	push   %edi
  80284b:	56                   	push   %esi
  80284c:	53                   	push   %ebx
  80284d:	83 ec 0c             	sub    $0xc,%esp
  802850:	8b 7d 08             	mov    0x8(%ebp),%edi
  802853:	8b 75 0c             	mov    0xc(%ebp),%esi
  802856:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802859:	85 db                	test   %ebx,%ebx
  80285b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802860:	0f 44 d8             	cmove  %eax,%ebx
  802863:	eb 05                	jmp    80286a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802865:	e8 4d e5 ff ff       	call   800db7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80286a:	ff 75 14             	pushl  0x14(%ebp)
  80286d:	53                   	push   %ebx
  80286e:	56                   	push   %esi
  80286f:	57                   	push   %edi
  802870:	e8 ee e6 ff ff       	call   800f63 <sys_ipc_try_send>
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 1b                	je     802897 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80287c:	79 e7                	jns    802865 <ipc_send+0x1e>
  80287e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802881:	74 e2                	je     802865 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 72 32 80 00       	push   $0x803272
  80288b:	6a 4a                	push   $0x4a
  80288d:	68 87 32 80 00       	push   $0x803287
  802892:	e8 51 fe ff ff       	call   8026e8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802897:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80289a:	5b                   	pop    %ebx
  80289b:	5e                   	pop    %esi
  80289c:	5f                   	pop    %edi
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    

0080289f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028aa:	89 c2                	mov    %eax,%edx
  8028ac:	c1 e2 07             	shl    $0x7,%edx
  8028af:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028b5:	8b 52 50             	mov    0x50(%edx),%edx
  8028b8:	39 ca                	cmp    %ecx,%edx
  8028ba:	74 11                	je     8028cd <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028bc:	83 c0 01             	add    $0x1,%eax
  8028bf:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028c4:	75 e4                	jne    8028aa <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cb:	eb 0b                	jmp    8028d8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8028cd:	c1 e0 07             	shl    $0x7,%eax
  8028d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028d5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028e0:	89 d0                	mov    %edx,%eax
  8028e2:	c1 e8 16             	shr    $0x16,%eax
  8028e5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028ec:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028f1:	f6 c1 01             	test   $0x1,%cl
  8028f4:	74 1d                	je     802913 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028f6:	c1 ea 0c             	shr    $0xc,%edx
  8028f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802900:	f6 c2 01             	test   $0x1,%dl
  802903:	74 0e                	je     802913 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802905:	c1 ea 0c             	shr    $0xc,%edx
  802908:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80290f:	ef 
  802910:	0f b7 c0             	movzwl %ax,%eax
}
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    
  802915:	66 90                	xchg   %ax,%ax
  802917:	66 90                	xchg   %ax,%ax
  802919:	66 90                	xchg   %ax,%ax
  80291b:	66 90                	xchg   %ax,%ax
  80291d:	66 90                	xchg   %ax,%ax
  80291f:	90                   	nop

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80292b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80292f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802933:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802937:	85 d2                	test   %edx,%edx
  802939:	75 4d                	jne    802988 <__udivdi3+0x68>
  80293b:	39 f3                	cmp    %esi,%ebx
  80293d:	76 19                	jbe    802958 <__udivdi3+0x38>
  80293f:	31 ff                	xor    %edi,%edi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f2                	mov    %esi,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	89 d9                	mov    %ebx,%ecx
  80295a:	85 db                	test   %ebx,%ebx
  80295c:	75 0b                	jne    802969 <__udivdi3+0x49>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	31 d2                	xor    %edx,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 c1                	mov    %eax,%ecx
  802969:	31 d2                	xor    %edx,%edx
  80296b:	89 f0                	mov    %esi,%eax
  80296d:	f7 f1                	div    %ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f7                	mov    %esi,%edi
  802975:	f7 f1                	div    %ecx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	39 f2                	cmp    %esi,%edx
  80298a:	77 1c                	ja     8029a8 <__udivdi3+0x88>
  80298c:	0f bd fa             	bsr    %edx,%edi
  80298f:	83 f7 1f             	xor    $0x1f,%edi
  802992:	75 2c                	jne    8029c0 <__udivdi3+0xa0>
  802994:	39 f2                	cmp    %esi,%edx
  802996:	72 06                	jb     80299e <__udivdi3+0x7e>
  802998:	31 c0                	xor    %eax,%eax
  80299a:	39 eb                	cmp    %ebp,%ebx
  80299c:	77 a9                	ja     802947 <__udivdi3+0x27>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	eb a2                	jmp    802947 <__udivdi3+0x27>
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	89 fa                	mov    %edi,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 f9                	mov    %edi,%ecx
  8029c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c7:	29 f8                	sub    %edi,%eax
  8029c9:	d3 e2                	shl    %cl,%edx
  8029cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029cf:	89 c1                	mov    %eax,%ecx
  8029d1:	89 da                	mov    %ebx,%edx
  8029d3:	d3 ea                	shr    %cl,%edx
  8029d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d9:	09 d1                	or     %edx,%ecx
  8029db:	89 f2                	mov    %esi,%edx
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 f9                	mov    %edi,%ecx
  8029e3:	d3 e3                	shl    %cl,%ebx
  8029e5:	89 c1                	mov    %eax,%ecx
  8029e7:	d3 ea                	shr    %cl,%edx
  8029e9:	89 f9                	mov    %edi,%ecx
  8029eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ef:	89 eb                	mov    %ebp,%ebx
  8029f1:	d3 e6                	shl    %cl,%esi
  8029f3:	89 c1                	mov    %eax,%ecx
  8029f5:	d3 eb                	shr    %cl,%ebx
  8029f7:	09 de                	or     %ebx,%esi
  8029f9:	89 f0                	mov    %esi,%eax
  8029fb:	f7 74 24 08          	divl   0x8(%esp)
  8029ff:	89 d6                	mov    %edx,%esi
  802a01:	89 c3                	mov    %eax,%ebx
  802a03:	f7 64 24 0c          	mull   0xc(%esp)
  802a07:	39 d6                	cmp    %edx,%esi
  802a09:	72 15                	jb     802a20 <__udivdi3+0x100>
  802a0b:	89 f9                	mov    %edi,%ecx
  802a0d:	d3 e5                	shl    %cl,%ebp
  802a0f:	39 c5                	cmp    %eax,%ebp
  802a11:	73 04                	jae    802a17 <__udivdi3+0xf7>
  802a13:	39 d6                	cmp    %edx,%esi
  802a15:	74 09                	je     802a20 <__udivdi3+0x100>
  802a17:	89 d8                	mov    %ebx,%eax
  802a19:	31 ff                	xor    %edi,%edi
  802a1b:	e9 27 ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a23:	31 ff                	xor    %edi,%edi
  802a25:	e9 1d ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a47:	89 da                	mov    %ebx,%edx
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 43                	jne    802a90 <__umoddi3+0x60>
  802a4d:	39 df                	cmp    %ebx,%edi
  802a4f:	76 17                	jbe    802a68 <__umoddi3+0x38>
  802a51:	89 f0                	mov    %esi,%eax
  802a53:	f7 f7                	div    %edi
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	31 d2                	xor    %edx,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	89 fd                	mov    %edi,%ebp
  802a6a:	85 ff                	test   %edi,%edi
  802a6c:	75 0b                	jne    802a79 <__umoddi3+0x49>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f7                	div    %edi
  802a77:	89 c5                	mov    %eax,%ebp
  802a79:	89 d8                	mov    %ebx,%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	f7 f5                	div    %ebp
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	f7 f5                	div    %ebp
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	eb d0                	jmp    802a57 <__umoddi3+0x27>
  802a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8e:	66 90                	xchg   %ax,%ax
  802a90:	89 f1                	mov    %esi,%ecx
  802a92:	39 d8                	cmp    %ebx,%eax
  802a94:	76 0a                	jbe    802aa0 <__umoddi3+0x70>
  802a96:	89 f0                	mov    %esi,%eax
  802a98:	83 c4 1c             	add    $0x1c,%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	0f bd e8             	bsr    %eax,%ebp
  802aa3:	83 f5 1f             	xor    $0x1f,%ebp
  802aa6:	75 20                	jne    802ac8 <__umoddi3+0x98>
  802aa8:	39 d8                	cmp    %ebx,%eax
  802aaa:	0f 82 b0 00 00 00    	jb     802b60 <__umoddi3+0x130>
  802ab0:	39 f7                	cmp    %esi,%edi
  802ab2:	0f 86 a8 00 00 00    	jbe    802b60 <__umoddi3+0x130>
  802ab8:	89 c8                	mov    %ecx,%eax
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	ba 20 00 00 00       	mov    $0x20,%edx
  802acf:	29 ea                	sub    %ebp,%edx
  802ad1:	d3 e0                	shl    %cl,%eax
  802ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ad7:	89 d1                	mov    %edx,%ecx
  802ad9:	89 f8                	mov    %edi,%eax
  802adb:	d3 e8                	shr    %cl,%eax
  802add:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ae1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ae5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae9:	09 c1                	or     %eax,%ecx
  802aeb:	89 d8                	mov    %ebx,%eax
  802aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 e7                	shl    %cl,%edi
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aff:	d3 e3                	shl    %cl,%ebx
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	89 d1                	mov    %edx,%ecx
  802b05:	89 f0                	mov    %esi,%eax
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 fa                	mov    %edi,%edx
  802b0d:	d3 e6                	shl    %cl,%esi
  802b0f:	09 d8                	or     %ebx,%eax
  802b11:	f7 74 24 08          	divl   0x8(%esp)
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	89 f3                	mov    %esi,%ebx
  802b19:	f7 64 24 0c          	mull   0xc(%esp)
  802b1d:	89 c6                	mov    %eax,%esi
  802b1f:	89 d7                	mov    %edx,%edi
  802b21:	39 d1                	cmp    %edx,%ecx
  802b23:	72 06                	jb     802b2b <__umoddi3+0xfb>
  802b25:	75 10                	jne    802b37 <__umoddi3+0x107>
  802b27:	39 c3                	cmp    %eax,%ebx
  802b29:	73 0c                	jae    802b37 <__umoddi3+0x107>
  802b2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b33:	89 d7                	mov    %edx,%edi
  802b35:	89 c6                	mov    %eax,%esi
  802b37:	89 ca                	mov    %ecx,%edx
  802b39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b3e:	29 f3                	sub    %esi,%ebx
  802b40:	19 fa                	sbb    %edi,%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	d3 e0                	shl    %cl,%eax
  802b46:	89 e9                	mov    %ebp,%ecx
  802b48:	d3 eb                	shr    %cl,%ebx
  802b4a:	d3 ea                	shr    %cl,%edx
  802b4c:	09 d8                	or     %ebx,%eax
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 da                	mov    %ebx,%edx
  802b62:	29 fe                	sub    %edi,%esi
  802b64:	19 c2                	sbb    %eax,%edx
  802b66:	89 f1                	mov    %esi,%ecx
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	e9 4b ff ff ff       	jmp    802aba <__umoddi3+0x8a>
