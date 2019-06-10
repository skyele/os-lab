
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
  800047:	68 a0 2b 80 00       	push   $0x802ba0
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
  80009c:	68 b1 2b 80 00       	push   $0x802bb1
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 e5 08 00 00       	call   800991 <snprintf>
	if (sfork() == 0) {	//lab4 challenge!
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 93 13 00 00       	call   801447 <sfork>
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
  800166:	68 b6 2b 80 00       	push   $0x802bb6
  80016b:	e8 15 01 00 00       	call   800285 <cprintf>
	cprintf("before umain\n");
  800170:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  800177:	e8 09 01 00 00       	call   800285 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017c:	83 c4 08             	add    $0x8,%esp
  80017f:	ff 75 0c             	pushl  0xc(%ebp)
  800182:	ff 75 08             	pushl  0x8(%ebp)
  800185:	e8 44 ff ff ff       	call   8000ce <umain>
	cprintf("after umain\n");
  80018a:	c7 04 24 e2 2b 80 00 	movl   $0x802be2,(%esp)
  800191:	e8 ef 00 00 00       	call   800285 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800196:	a1 08 50 80 00       	mov    0x805008,%eax
  80019b:	8b 40 48             	mov    0x48(%eax),%eax
  80019e:	83 c4 08             	add    $0x8,%esp
  8001a1:	50                   	push   %eax
  8001a2:	68 ef 2b 80 00       	push   $0x802bef
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
  8001ca:	68 1c 2c 80 00       	push   $0x802c1c
  8001cf:	50                   	push   %eax
  8001d0:	68 0e 2c 80 00       	push   $0x802c0e
  8001d5:	e8 ab 00 00 00       	call   800285 <cprintf>
	close_all();
  8001da:	e8 ab 15 00 00       	call   80178a <close_all>
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
  800332:	e8 09 26 00 00       	call   802940 <__udivdi3>
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
  80035b:	e8 f0 26 00 00       	call   802a50 <__umoddi3>
  800360:	83 c4 14             	add    $0x14,%esp
  800363:	0f be 80 21 2c 80 00 	movsbl 0x802c21(%eax),%eax
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
  80040c:	ff 24 85 00 2e 80 00 	jmp    *0x802e00(,%eax,4)
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
  8004d7:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  8004de:	85 d2                	test   %edx,%edx
  8004e0:	74 18                	je     8004fa <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e2:	52                   	push   %edx
  8004e3:	68 6d 31 80 00       	push   $0x80316d
  8004e8:	53                   	push   %ebx
  8004e9:	56                   	push   %esi
  8004ea:	e8 a6 fe ff ff       	call   800395 <printfmt>
  8004ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f5:	e9 fe 02 00 00       	jmp    8007f8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fa:	50                   	push   %eax
  8004fb:	68 39 2c 80 00       	push   $0x802c39
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
  800522:	b8 32 2c 80 00       	mov    $0x802c32,%eax
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
  8008ba:	bf 55 2d 80 00       	mov    $0x802d55,%edi
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
  8008e6:	bf 8d 2d 80 00       	mov    $0x802d8d,%edi
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
  800d87:	68 a8 2f 80 00       	push   $0x802fa8
  800d8c:	6a 43                	push   $0x43
  800d8e:	68 c5 2f 80 00       	push   $0x802fc5
  800d93:	e8 70 19 00 00       	call   802708 <_panic>

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
  800e08:	68 a8 2f 80 00       	push   $0x802fa8
  800e0d:	6a 43                	push   $0x43
  800e0f:	68 c5 2f 80 00       	push   $0x802fc5
  800e14:	e8 ef 18 00 00       	call   802708 <_panic>

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
  800e4a:	68 a8 2f 80 00       	push   $0x802fa8
  800e4f:	6a 43                	push   $0x43
  800e51:	68 c5 2f 80 00       	push   $0x802fc5
  800e56:	e8 ad 18 00 00       	call   802708 <_panic>

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
  800e8c:	68 a8 2f 80 00       	push   $0x802fa8
  800e91:	6a 43                	push   $0x43
  800e93:	68 c5 2f 80 00       	push   $0x802fc5
  800e98:	e8 6b 18 00 00       	call   802708 <_panic>

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
  800ece:	68 a8 2f 80 00       	push   $0x802fa8
  800ed3:	6a 43                	push   $0x43
  800ed5:	68 c5 2f 80 00       	push   $0x802fc5
  800eda:	e8 29 18 00 00       	call   802708 <_panic>

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
  800f10:	68 a8 2f 80 00       	push   $0x802fa8
  800f15:	6a 43                	push   $0x43
  800f17:	68 c5 2f 80 00       	push   $0x802fc5
  800f1c:	e8 e7 17 00 00       	call   802708 <_panic>

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
  800f52:	68 a8 2f 80 00       	push   $0x802fa8
  800f57:	6a 43                	push   $0x43
  800f59:	68 c5 2f 80 00       	push   $0x802fc5
  800f5e:	e8 a5 17 00 00       	call   802708 <_panic>

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
  800fb6:	68 a8 2f 80 00       	push   $0x802fa8
  800fbb:	6a 43                	push   $0x43
  800fbd:	68 c5 2f 80 00       	push   $0x802fc5
  800fc2:	e8 41 17 00 00       	call   802708 <_panic>

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
  80109a:	68 a8 2f 80 00       	push   $0x802fa8
  80109f:	6a 43                	push   $0x43
  8010a1:	68 c5 2f 80 00       	push   $0x802fc5
  8010a6:	e8 5d 16 00 00       	call   802708 <_panic>

008010ab <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	b8 14 00 00 00       	mov    $0x14,%eax
  8010be:	89 cb                	mov    %ecx,%ebx
  8010c0:	89 cf                	mov    %ecx,%edi
  8010c2:	89 ce                	mov    %ecx,%esi
  8010c4:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010d2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d9:	f6 c5 04             	test   $0x4,%ch
  8010dc:	75 45                	jne    801123 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010de:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e5:	83 e1 07             	and    $0x7,%ecx
  8010e8:	83 f9 07             	cmp    $0x7,%ecx
  8010eb:	74 6f                	je     80115c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010ed:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010f4:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010fa:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801100:	0f 84 b6 00 00 00    	je     8011bc <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801106:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80110d:	83 e1 05             	and    $0x5,%ecx
  801110:	83 f9 05             	cmp    $0x5,%ecx
  801113:	0f 84 d7 00 00 00    	je     8011f0 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801119:	b8 00 00 00 00       	mov    $0x0,%eax
  80111e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801121:	c9                   	leave  
  801122:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801123:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80112a:	c1 e2 0c             	shl    $0xc,%edx
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801136:	51                   	push   %ecx
  801137:	52                   	push   %edx
  801138:	50                   	push   %eax
  801139:	52                   	push   %edx
  80113a:	6a 00                	push   $0x0
  80113c:	e8 d8 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	79 d1                	jns    801119 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801148:	83 ec 04             	sub    $0x4,%esp
  80114b:	68 d3 2f 80 00       	push   $0x802fd3
  801150:	6a 54                	push   $0x54
  801152:	68 e9 2f 80 00       	push   $0x802fe9
  801157:	e8 ac 15 00 00       	call   802708 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115c:	89 d3                	mov    %edx,%ebx
  80115e:	c1 e3 0c             	shl    $0xc,%ebx
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	68 05 08 00 00       	push   $0x805
  801169:	53                   	push   %ebx
  80116a:	50                   	push   %eax
  80116b:	53                   	push   %ebx
  80116c:	6a 00                	push   $0x0
  80116e:	e8 a6 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  801173:	83 c4 20             	add    $0x20,%esp
  801176:	85 c0                	test   %eax,%eax
  801178:	78 2e                	js     8011a8 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	68 05 08 00 00       	push   $0x805
  801182:	53                   	push   %ebx
  801183:	6a 00                	push   $0x0
  801185:	53                   	push   %ebx
  801186:	6a 00                	push   $0x0
  801188:	e8 8c fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  80118d:	83 c4 20             	add    $0x20,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	79 85                	jns    801119 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 d3 2f 80 00       	push   $0x802fd3
  80119c:	6a 5f                	push   $0x5f
  80119e:	68 e9 2f 80 00       	push   $0x802fe9
  8011a3:	e8 60 15 00 00       	call   802708 <_panic>
			panic("sys_page_map() panic\n");
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	68 d3 2f 80 00       	push   $0x802fd3
  8011b0:	6a 5b                	push   $0x5b
  8011b2:	68 e9 2f 80 00       	push   $0x802fe9
  8011b7:	e8 4c 15 00 00       	call   802708 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011bc:	c1 e2 0c             	shl    $0xc,%edx
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	68 05 08 00 00       	push   $0x805
  8011c7:	52                   	push   %edx
  8011c8:	50                   	push   %eax
  8011c9:	52                   	push   %edx
  8011ca:	6a 00                	push   $0x0
  8011cc:	e8 48 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  8011d1:	83 c4 20             	add    $0x20,%esp
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	0f 89 3d ff ff ff    	jns    801119 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	68 d3 2f 80 00       	push   $0x802fd3
  8011e4:	6a 66                	push   $0x66
  8011e6:	68 e9 2f 80 00       	push   $0x802fe9
  8011eb:	e8 18 15 00 00       	call   802708 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011f0:	c1 e2 0c             	shl    $0xc,%edx
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	6a 05                	push   $0x5
  8011f8:	52                   	push   %edx
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 17 fc ff ff       	call   800e19 <sys_page_map>
		if(r < 0)
  801202:	83 c4 20             	add    $0x20,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	0f 89 0c ff ff ff    	jns    801119 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	68 d3 2f 80 00       	push   $0x802fd3
  801215:	6a 6d                	push   $0x6d
  801217:	68 e9 2f 80 00       	push   $0x802fe9
  80121c:	e8 e7 14 00 00       	call   802708 <_panic>

00801221 <pgfault>:
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	53                   	push   %ebx
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80122b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80122d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801231:	0f 84 99 00 00 00    	je     8012d0 <pgfault+0xaf>
  801237:	89 c2                	mov    %eax,%edx
  801239:	c1 ea 16             	shr    $0x16,%edx
  80123c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801243:	f6 c2 01             	test   $0x1,%dl
  801246:	0f 84 84 00 00 00    	je     8012d0 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	c1 ea 0c             	shr    $0xc,%edx
  801251:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801258:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80125e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801264:	75 6a                	jne    8012d0 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80126d:	83 ec 04             	sub    $0x4,%esp
  801270:	6a 07                	push   $0x7
  801272:	68 00 f0 7f 00       	push   $0x7ff000
  801277:	6a 00                	push   $0x0
  801279:	e8 58 fb ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 5f                	js     8012e4 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	68 00 10 00 00       	push   $0x1000
  80128d:	53                   	push   %ebx
  80128e:	68 00 f0 7f 00       	push   $0x7ff000
  801293:	e8 3c f9 ff ff       	call   800bd4 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801298:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80129f:	53                   	push   %ebx
  8012a0:	6a 00                	push   $0x0
  8012a2:	68 00 f0 7f 00       	push   $0x7ff000
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 6b fb ff ff       	call   800e19 <sys_page_map>
	if(ret < 0)
  8012ae:	83 c4 20             	add    $0x20,%esp
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	78 43                	js     8012f8 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	68 00 f0 7f 00       	push   $0x7ff000
  8012bd:	6a 00                	push   $0x0
  8012bf:	e8 97 fb ff ff       	call   800e5b <sys_page_unmap>
	if(ret < 0)
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 41                	js     80130c <pgfault+0xeb>
}
  8012cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 f4 2f 80 00       	push   $0x802ff4
  8012d8:	6a 26                	push   $0x26
  8012da:	68 e9 2f 80 00       	push   $0x802fe9
  8012df:	e8 24 14 00 00       	call   802708 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 08 30 80 00       	push   $0x803008
  8012ec:	6a 31                	push   $0x31
  8012ee:	68 e9 2f 80 00       	push   $0x802fe9
  8012f3:	e8 10 14 00 00       	call   802708 <_panic>
		panic("panic in sys_page_map()\n");
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	68 23 30 80 00       	push   $0x803023
  801300:	6a 36                	push   $0x36
  801302:	68 e9 2f 80 00       	push   $0x802fe9
  801307:	e8 fc 13 00 00       	call   802708 <_panic>
		panic("panic in sys_page_unmap()\n");
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	68 3c 30 80 00       	push   $0x80303c
  801314:	6a 39                	push   $0x39
  801316:	68 e9 2f 80 00       	push   $0x802fe9
  80131b:	e8 e8 13 00 00       	call   802708 <_panic>

00801320 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	57                   	push   %edi
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801329:	68 21 12 80 00       	push   $0x801221
  80132e:	e8 36 14 00 00       	call   802769 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801333:	b8 07 00 00 00       	mov    $0x7,%eax
  801338:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 27                	js     801368 <fork+0x48>
  801341:	89 c6                	mov    %eax,%esi
  801343:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801345:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80134a:	75 48                	jne    801394 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80134c:	e8 47 fa ff ff       	call   800d98 <sys_getenvid>
  801351:	25 ff 03 00 00       	and    $0x3ff,%eax
  801356:	c1 e0 07             	shl    $0x7,%eax
  801359:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80135e:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801363:	e9 90 00 00 00       	jmp    8013f8 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	68 58 30 80 00       	push   $0x803058
  801370:	68 8c 00 00 00       	push   $0x8c
  801375:	68 e9 2f 80 00       	push   $0x802fe9
  80137a:	e8 89 13 00 00       	call   802708 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80137f:	89 f8                	mov    %edi,%eax
  801381:	e8 45 fd ff ff       	call   8010cb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801386:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80138c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801392:	74 26                	je     8013ba <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801394:	89 d8                	mov    %ebx,%eax
  801396:	c1 e8 16             	shr    $0x16,%eax
  801399:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a0:	a8 01                	test   $0x1,%al
  8013a2:	74 e2                	je     801386 <fork+0x66>
  8013a4:	89 da                	mov    %ebx,%edx
  8013a6:	c1 ea 0c             	shr    $0xc,%edx
  8013a9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013b0:	83 e0 05             	and    $0x5,%eax
  8013b3:	83 f8 05             	cmp    $0x5,%eax
  8013b6:	75 ce                	jne    801386 <fork+0x66>
  8013b8:	eb c5                	jmp    80137f <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	6a 07                	push   $0x7
  8013bf:	68 00 f0 bf ee       	push   $0xeebff000
  8013c4:	56                   	push   %esi
  8013c5:	e8 0c fa ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 31                	js     801402 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013d1:	83 ec 08             	sub    $0x8,%esp
  8013d4:	68 d8 27 80 00       	push   $0x8027d8
  8013d9:	56                   	push   %esi
  8013da:	e8 42 fb ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 33                	js     801419 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	6a 02                	push   $0x2
  8013eb:	56                   	push   %esi
  8013ec:	e8 ac fa ff ff       	call   800e9d <sys_env_set_status>
	if(ret < 0)
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 38                	js     801430 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013f8:	89 f0                	mov    %esi,%eax
  8013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fd:	5b                   	pop    %ebx
  8013fe:	5e                   	pop    %esi
  8013ff:	5f                   	pop    %edi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	68 08 30 80 00       	push   $0x803008
  80140a:	68 98 00 00 00       	push   $0x98
  80140f:	68 e9 2f 80 00       	push   $0x802fe9
  801414:	e8 ef 12 00 00       	call   802708 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	68 7c 30 80 00       	push   $0x80307c
  801421:	68 9b 00 00 00       	push   $0x9b
  801426:	68 e9 2f 80 00       	push   $0x802fe9
  80142b:	e8 d8 12 00 00       	call   802708 <_panic>
		panic("panic in sys_env_set_status()\n");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 a4 30 80 00       	push   $0x8030a4
  801438:	68 9e 00 00 00       	push   $0x9e
  80143d:	68 e9 2f 80 00       	push   $0x802fe9
  801442:	e8 c1 12 00 00       	call   802708 <_panic>

00801447 <sfork>:

// Challenge!
int
sfork(void)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
  80144d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801450:	68 21 12 80 00       	push   $0x801221
  801455:	e8 0f 13 00 00       	call   802769 <set_pgfault_handler>
  80145a:	b8 07 00 00 00       	mov    $0x7,%eax
  80145f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	78 27                	js     80148f <sfork+0x48>
  801468:	89 c7                	mov    %eax,%edi
  80146a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80146c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801471:	75 55                	jne    8014c8 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801473:	e8 20 f9 ff ff       	call   800d98 <sys_getenvid>
  801478:	25 ff 03 00 00       	and    $0x3ff,%eax
  80147d:	c1 e0 07             	shl    $0x7,%eax
  801480:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801485:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80148a:	e9 d4 00 00 00       	jmp    801563 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 58 30 80 00       	push   $0x803058
  801497:	68 af 00 00 00       	push   $0xaf
  80149c:	68 e9 2f 80 00       	push   $0x802fe9
  8014a1:	e8 62 12 00 00       	call   802708 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014a6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014ab:	89 f0                	mov    %esi,%eax
  8014ad:	e8 19 fc ff ff       	call   8010cb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014b8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014be:	77 65                	ja     801525 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014c0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014c6:	74 de                	je     8014a6 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	c1 e8 16             	shr    $0x16,%eax
  8014cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014d4:	a8 01                	test   $0x1,%al
  8014d6:	74 da                	je     8014b2 <sfork+0x6b>
  8014d8:	89 da                	mov    %ebx,%edx
  8014da:	c1 ea 0c             	shr    $0xc,%edx
  8014dd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014e4:	83 e0 05             	and    $0x5,%eax
  8014e7:	83 f8 05             	cmp    $0x5,%eax
  8014ea:	75 c6                	jne    8014b2 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014ec:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014f3:	c1 e2 0c             	shl    $0xc,%edx
  8014f6:	83 ec 0c             	sub    $0xc,%esp
  8014f9:	83 e0 07             	and    $0x7,%eax
  8014fc:	50                   	push   %eax
  8014fd:	52                   	push   %edx
  8014fe:	56                   	push   %esi
  8014ff:	52                   	push   %edx
  801500:	6a 00                	push   $0x0
  801502:	e8 12 f9 ff ff       	call   800e19 <sys_page_map>
  801507:	83 c4 20             	add    $0x20,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	74 a4                	je     8014b2 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	68 d3 2f 80 00       	push   $0x802fd3
  801516:	68 ba 00 00 00       	push   $0xba
  80151b:	68 e9 2f 80 00       	push   $0x802fe9
  801520:	e8 e3 11 00 00       	call   802708 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	6a 07                	push   $0x7
  80152a:	68 00 f0 bf ee       	push   $0xeebff000
  80152f:	57                   	push   %edi
  801530:	e8 a1 f8 ff ff       	call   800dd6 <sys_page_alloc>
	if(ret < 0)
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 31                	js     80156d <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	68 d8 27 80 00       	push   $0x8027d8
  801544:	57                   	push   %edi
  801545:	e8 d7 f9 ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 33                	js     801584 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801551:	83 ec 08             	sub    $0x8,%esp
  801554:	6a 02                	push   $0x2
  801556:	57                   	push   %edi
  801557:	e8 41 f9 ff ff       	call   800e9d <sys_env_set_status>
	if(ret < 0)
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 38                	js     80159b <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801563:	89 f8                	mov    %edi,%eax
  801565:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 08 30 80 00       	push   $0x803008
  801575:	68 c0 00 00 00       	push   $0xc0
  80157a:	68 e9 2f 80 00       	push   $0x802fe9
  80157f:	e8 84 11 00 00       	call   802708 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 7c 30 80 00       	push   $0x80307c
  80158c:	68 c3 00 00 00       	push   $0xc3
  801591:	68 e9 2f 80 00       	push   $0x802fe9
  801596:	e8 6d 11 00 00       	call   802708 <_panic>
		panic("panic in sys_env_set_status()\n");
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	68 a4 30 80 00       	push   $0x8030a4
  8015a3:	68 c6 00 00 00       	push   $0xc6
  8015a8:	68 e9 2f 80 00       	push   $0x802fe9
  8015ad:	e8 56 11 00 00       	call   802708 <_panic>

008015b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	05 00 00 00 30       	add    $0x30000000,%eax
  8015bd:	c1 e8 0c             	shr    $0xc,%eax
}
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    

008015c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    

008015d9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015e1:	89 c2                	mov    %eax,%edx
  8015e3:	c1 ea 16             	shr    $0x16,%edx
  8015e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015ed:	f6 c2 01             	test   $0x1,%dl
  8015f0:	74 2d                	je     80161f <fd_alloc+0x46>
  8015f2:	89 c2                	mov    %eax,%edx
  8015f4:	c1 ea 0c             	shr    $0xc,%edx
  8015f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015fe:	f6 c2 01             	test   $0x1,%dl
  801601:	74 1c                	je     80161f <fd_alloc+0x46>
  801603:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801608:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80160d:	75 d2                	jne    8015e1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801618:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80161d:	eb 0a                	jmp    801629 <fd_alloc+0x50>
			*fd_store = fd;
  80161f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801622:	89 01                	mov    %eax,(%ecx)
			return 0;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801631:	83 f8 1f             	cmp    $0x1f,%eax
  801634:	77 30                	ja     801666 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801636:	c1 e0 0c             	shl    $0xc,%eax
  801639:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80163e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801644:	f6 c2 01             	test   $0x1,%dl
  801647:	74 24                	je     80166d <fd_lookup+0x42>
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 ea 0c             	shr    $0xc,%edx
  80164e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 1a                	je     801674 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	89 02                	mov    %eax,(%edx)
	return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    
		return -E_INVAL;
  801666:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166b:	eb f7                	jmp    801664 <fd_lookup+0x39>
		return -E_INVAL;
  80166d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801672:	eb f0                	jmp    801664 <fd_lookup+0x39>
  801674:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801679:	eb e9                	jmp    801664 <fd_lookup+0x39>

0080167b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 08             	sub    $0x8,%esp
  801681:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801684:	ba 00 00 00 00       	mov    $0x0,%edx
  801689:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80168e:	39 08                	cmp    %ecx,(%eax)
  801690:	74 38                	je     8016ca <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801692:	83 c2 01             	add    $0x1,%edx
  801695:	8b 04 95 40 31 80 00 	mov    0x803140(,%edx,4),%eax
  80169c:	85 c0                	test   %eax,%eax
  80169e:	75 ee                	jne    80168e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8016a5:	8b 40 48             	mov    0x48(%eax),%eax
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	51                   	push   %ecx
  8016ac:	50                   	push   %eax
  8016ad:	68 c4 30 80 00       	push   $0x8030c4
  8016b2:	e8 ce eb ff ff       	call   800285 <cprintf>
	*dev = 0;
  8016b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    
			*dev = devtab[i];
  8016ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016cd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d4:	eb f2                	jmp    8016c8 <dev_lookup+0x4d>

008016d6 <fd_close>:
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	57                   	push   %edi
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 24             	sub    $0x24,%esp
  8016df:	8b 75 08             	mov    0x8(%ebp),%esi
  8016e2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016e8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016e9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016ef:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f2:	50                   	push   %eax
  8016f3:	e8 33 ff ff ff       	call   80162b <fd_lookup>
  8016f8:	89 c3                	mov    %eax,%ebx
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 05                	js     801706 <fd_close+0x30>
	    || fd != fd2)
  801701:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801704:	74 16                	je     80171c <fd_close+0x46>
		return (must_exist ? r : 0);
  801706:	89 f8                	mov    %edi,%eax
  801708:	84 c0                	test   %al,%al
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
  80170f:	0f 44 d8             	cmove  %eax,%ebx
}
  801712:	89 d8                	mov    %ebx,%eax
  801714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801717:	5b                   	pop    %ebx
  801718:	5e                   	pop    %esi
  801719:	5f                   	pop    %edi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801722:	50                   	push   %eax
  801723:	ff 36                	pushl  (%esi)
  801725:	e8 51 ff ff ff       	call   80167b <dev_lookup>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 1a                	js     80174d <fd_close+0x77>
		if (dev->dev_close)
  801733:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801736:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801739:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 0b                	je     80174d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801742:	83 ec 0c             	sub    $0xc,%esp
  801745:	56                   	push   %esi
  801746:	ff d0                	call   *%eax
  801748:	89 c3                	mov    %eax,%ebx
  80174a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	56                   	push   %esi
  801751:	6a 00                	push   $0x0
  801753:	e8 03 f7 ff ff       	call   800e5b <sys_page_unmap>
	return r;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	eb b5                	jmp    801712 <fd_close+0x3c>

0080175d <close>:

int
close(int fdnum)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	e8 bc fe ff ff       	call   80162b <fd_lookup>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	79 02                	jns    801778 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    
		return fd_close(fd, 1);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	6a 01                	push   $0x1
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	e8 51 ff ff ff       	call   8016d6 <fd_close>
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	eb ec                	jmp    801776 <close+0x19>

0080178a <close_all>:

void
close_all(void)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801791:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	53                   	push   %ebx
  80179a:	e8 be ff ff ff       	call   80175d <close>
	for (i = 0; i < MAXFD; i++)
  80179f:	83 c3 01             	add    $0x1,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	83 fb 20             	cmp    $0x20,%ebx
  8017a8:	75 ec                	jne    801796 <close_all+0xc>
}
  8017aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	57                   	push   %edi
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	e8 67 fe ff ff       	call   80162b <fd_lookup>
  8017c4:	89 c3                	mov    %eax,%ebx
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	0f 88 81 00 00 00    	js     801852 <dup+0xa3>
		return r;
	close(newfdnum);
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	e8 81 ff ff ff       	call   80175d <close>

	newfd = INDEX2FD(newfdnum);
  8017dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017df:	c1 e6 0c             	shl    $0xc,%esi
  8017e2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017e8:	83 c4 04             	add    $0x4,%esp
  8017eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ee:	e8 cf fd ff ff       	call   8015c2 <fd2data>
  8017f3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017f5:	89 34 24             	mov    %esi,(%esp)
  8017f8:	e8 c5 fd ff ff       	call   8015c2 <fd2data>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801802:	89 d8                	mov    %ebx,%eax
  801804:	c1 e8 16             	shr    $0x16,%eax
  801807:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80180e:	a8 01                	test   $0x1,%al
  801810:	74 11                	je     801823 <dup+0x74>
  801812:	89 d8                	mov    %ebx,%eax
  801814:	c1 e8 0c             	shr    $0xc,%eax
  801817:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80181e:	f6 c2 01             	test   $0x1,%dl
  801821:	75 39                	jne    80185c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801823:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801826:	89 d0                	mov    %edx,%eax
  801828:	c1 e8 0c             	shr    $0xc,%eax
  80182b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	25 07 0e 00 00       	and    $0xe07,%eax
  80183a:	50                   	push   %eax
  80183b:	56                   	push   %esi
  80183c:	6a 00                	push   $0x0
  80183e:	52                   	push   %edx
  80183f:	6a 00                	push   $0x0
  801841:	e8 d3 f5 ff ff       	call   800e19 <sys_page_map>
  801846:	89 c3                	mov    %eax,%ebx
  801848:	83 c4 20             	add    $0x20,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 31                	js     801880 <dup+0xd1>
		goto err;

	return newfdnum;
  80184f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801852:	89 d8                	mov    %ebx,%eax
  801854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80185c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	25 07 0e 00 00       	and    $0xe07,%eax
  80186b:	50                   	push   %eax
  80186c:	57                   	push   %edi
  80186d:	6a 00                	push   $0x0
  80186f:	53                   	push   %ebx
  801870:	6a 00                	push   $0x0
  801872:	e8 a2 f5 ff ff       	call   800e19 <sys_page_map>
  801877:	89 c3                	mov    %eax,%ebx
  801879:	83 c4 20             	add    $0x20,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	79 a3                	jns    801823 <dup+0x74>
	sys_page_unmap(0, newfd);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	56                   	push   %esi
  801884:	6a 00                	push   $0x0
  801886:	e8 d0 f5 ff ff       	call   800e5b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80188b:	83 c4 08             	add    $0x8,%esp
  80188e:	57                   	push   %edi
  80188f:	6a 00                	push   $0x0
  801891:	e8 c5 f5 ff ff       	call   800e5b <sys_page_unmap>
	return r;
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	eb b7                	jmp    801852 <dup+0xa3>

0080189b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	53                   	push   %ebx
  80189f:	83 ec 1c             	sub    $0x1c,%esp
  8018a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a8:	50                   	push   %eax
  8018a9:	53                   	push   %ebx
  8018aa:	e8 7c fd ff ff       	call   80162b <fd_lookup>
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 3f                	js     8018f5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bc:	50                   	push   %eax
  8018bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c0:	ff 30                	pushl  (%eax)
  8018c2:	e8 b4 fd ff ff       	call   80167b <dev_lookup>
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 27                	js     8018f5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d1:	8b 42 08             	mov    0x8(%edx),%eax
  8018d4:	83 e0 03             	and    $0x3,%eax
  8018d7:	83 f8 01             	cmp    $0x1,%eax
  8018da:	74 1e                	je     8018fa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	8b 40 08             	mov    0x8(%eax),%eax
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	74 35                	je     80191b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	ff 75 10             	pushl  0x10(%ebp)
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	52                   	push   %edx
  8018f0:	ff d0                	call   *%eax
  8018f2:	83 c4 10             	add    $0x10,%esp
}
  8018f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8018ff:	8b 40 48             	mov    0x48(%eax),%eax
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	53                   	push   %ebx
  801906:	50                   	push   %eax
  801907:	68 05 31 80 00       	push   $0x803105
  80190c:	e8 74 e9 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801919:	eb da                	jmp    8018f5 <read+0x5a>
		return -E_NOT_SUPP;
  80191b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801920:	eb d3                	jmp    8018f5 <read+0x5a>

00801922 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80192e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801931:	bb 00 00 00 00       	mov    $0x0,%ebx
  801936:	39 f3                	cmp    %esi,%ebx
  801938:	73 23                	jae    80195d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	89 f0                	mov    %esi,%eax
  80193f:	29 d8                	sub    %ebx,%eax
  801941:	50                   	push   %eax
  801942:	89 d8                	mov    %ebx,%eax
  801944:	03 45 0c             	add    0xc(%ebp),%eax
  801947:	50                   	push   %eax
  801948:	57                   	push   %edi
  801949:	e8 4d ff ff ff       	call   80189b <read>
		if (m < 0)
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 06                	js     80195b <readn+0x39>
			return m;
		if (m == 0)
  801955:	74 06                	je     80195d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801957:	01 c3                	add    %eax,%ebx
  801959:	eb db                	jmp    801936 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80195b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80195d:	89 d8                	mov    %ebx,%eax
  80195f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5f                   	pop    %edi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	53                   	push   %ebx
  80196b:	83 ec 1c             	sub    $0x1c,%esp
  80196e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	53                   	push   %ebx
  801976:	e8 b0 fc ff ff       	call   80162b <fd_lookup>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 3a                	js     8019bc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801988:	50                   	push   %eax
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198c:	ff 30                	pushl  (%eax)
  80198e:	e8 e8 fc ff ff       	call   80167b <dev_lookup>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	78 22                	js     8019bc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a1:	74 1e                	je     8019c1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	74 35                	je     8019e2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	ff 75 10             	pushl  0x10(%ebp)
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	ff d2                	call   *%edx
  8019b9:	83 c4 10             	add    $0x10,%esp
}
  8019bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c1:	a1 08 50 80 00       	mov    0x805008,%eax
  8019c6:	8b 40 48             	mov    0x48(%eax),%eax
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	53                   	push   %ebx
  8019cd:	50                   	push   %eax
  8019ce:	68 21 31 80 00       	push   $0x803121
  8019d3:	e8 ad e8 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e0:	eb da                	jmp    8019bc <write+0x55>
		return -E_NOT_SUPP;
  8019e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e7:	eb d3                	jmp    8019bc <write+0x55>

008019e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	e8 30 fc ff ff       	call   80162b <fd_lookup>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 0e                	js     801a10 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a08:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	53                   	push   %ebx
  801a16:	83 ec 1c             	sub    $0x1c,%esp
  801a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1f:	50                   	push   %eax
  801a20:	53                   	push   %ebx
  801a21:	e8 05 fc ff ff       	call   80162b <fd_lookup>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 37                	js     801a64 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a33:	50                   	push   %eax
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a37:	ff 30                	pushl  (%eax)
  801a39:	e8 3d fc ff ff       	call   80167b <dev_lookup>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 1f                	js     801a64 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a48:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a4c:	74 1b                	je     801a69 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a51:	8b 52 18             	mov    0x18(%edx),%edx
  801a54:	85 d2                	test   %edx,%edx
  801a56:	74 32                	je     801a8a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	50                   	push   %eax
  801a5f:	ff d2                	call   *%edx
  801a61:	83 c4 10             	add    $0x10,%esp
}
  801a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a69:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a6e:	8b 40 48             	mov    0x48(%eax),%eax
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	53                   	push   %ebx
  801a75:	50                   	push   %eax
  801a76:	68 e4 30 80 00       	push   $0x8030e4
  801a7b:	e8 05 e8 ff ff       	call   800285 <cprintf>
		return -E_INVAL;
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a88:	eb da                	jmp    801a64 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a8a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8f:	eb d3                	jmp    801a64 <ftruncate+0x52>

00801a91 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	53                   	push   %ebx
  801a95:	83 ec 1c             	sub    $0x1c,%esp
  801a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9e:	50                   	push   %eax
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	e8 84 fb ff ff       	call   80162b <fd_lookup>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 4b                	js     801af9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab4:	50                   	push   %eax
  801ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab8:	ff 30                	pushl  (%eax)
  801aba:	e8 bc fb ff ff       	call   80167b <dev_lookup>
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 33                	js     801af9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801acd:	74 2f                	je     801afe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801acf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ad2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ad9:	00 00 00 
	stat->st_isdir = 0;
  801adc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ae3:	00 00 00 
	stat->st_dev = dev;
  801ae6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	53                   	push   %ebx
  801af0:	ff 75 f0             	pushl  -0x10(%ebp)
  801af3:	ff 50 14             	call   *0x14(%eax)
  801af6:	83 c4 10             	add    $0x10,%esp
}
  801af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    
		return -E_NOT_SUPP;
  801afe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b03:	eb f4                	jmp    801af9 <fstat+0x68>

00801b05 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	56                   	push   %esi
  801b09:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 08             	pushl  0x8(%ebp)
  801b12:	e8 22 02 00 00       	call   801d39 <open>
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 1b                	js     801b3b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	e8 65 ff ff ff       	call   801a91 <fstat>
  801b2c:	89 c6                	mov    %eax,%esi
	close(fd);
  801b2e:	89 1c 24             	mov    %ebx,(%esp)
  801b31:	e8 27 fc ff ff       	call   80175d <close>
	return r;
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	89 f3                	mov    %esi,%ebx
}
  801b3b:	89 d8                	mov    %ebx,%eax
  801b3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	89 c6                	mov    %eax,%esi
  801b4b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b4d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b54:	74 27                	je     801b7d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b56:	6a 07                	push   $0x7
  801b58:	68 00 60 80 00       	push   $0x806000
  801b5d:	56                   	push   %esi
  801b5e:	ff 35 00 50 80 00    	pushl  0x805000
  801b64:	e8 fe 0c 00 00       	call   802867 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b69:	83 c4 0c             	add    $0xc,%esp
  801b6c:	6a 00                	push   $0x0
  801b6e:	53                   	push   %ebx
  801b6f:	6a 00                	push   $0x0
  801b71:	e8 88 0c 00 00       	call   8027fe <ipc_recv>
}
  801b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5e                   	pop    %esi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b7d:	83 ec 0c             	sub    $0xc,%esp
  801b80:	6a 01                	push   $0x1
  801b82:	e8 38 0d 00 00       	call   8028bf <ipc_find_env>
  801b87:	a3 00 50 80 00       	mov    %eax,0x805000
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	eb c5                	jmp    801b56 <fsipc+0x12>

00801b91 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801baa:	ba 00 00 00 00       	mov    $0x0,%edx
  801baf:	b8 02 00 00 00       	mov    $0x2,%eax
  801bb4:	e8 8b ff ff ff       	call   801b44 <fsipc>
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <devfile_flush>:
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd1:	b8 06 00 00 00       	mov    $0x6,%eax
  801bd6:	e8 69 ff ff ff       	call   801b44 <fsipc>
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <devfile_stat>:
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	8b 40 0c             	mov    0xc(%eax),%eax
  801bed:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf7:	b8 05 00 00 00       	mov    $0x5,%eax
  801bfc:	e8 43 ff ff ff       	call   801b44 <fsipc>
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 2c                	js     801c31 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	68 00 60 80 00       	push   $0x806000
  801c0d:	53                   	push   %ebx
  801c0e:	e8 d1 ed ff ff       	call   8009e4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c13:	a1 80 60 80 00       	mov    0x806080,%eax
  801c18:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c1e:	a1 84 60 80 00       	mov    0x806084,%eax
  801c23:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <devfile_write>:
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8b 40 0c             	mov    0xc(%eax),%eax
  801c46:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c4b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c51:	53                   	push   %ebx
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	68 08 60 80 00       	push   $0x806008
  801c5a:	e8 75 ef ff ff       	call   800bd4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c64:	b8 04 00 00 00       	mov    $0x4,%eax
  801c69:	e8 d6 fe ff ff       	call   801b44 <fsipc>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 0b                	js     801c80 <devfile_write+0x4a>
	assert(r <= n);
  801c75:	39 d8                	cmp    %ebx,%eax
  801c77:	77 0c                	ja     801c85 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c79:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c7e:	7f 1e                	jg     801c9e <devfile_write+0x68>
}
  801c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    
	assert(r <= n);
  801c85:	68 54 31 80 00       	push   $0x803154
  801c8a:	68 5b 31 80 00       	push   $0x80315b
  801c8f:	68 98 00 00 00       	push   $0x98
  801c94:	68 70 31 80 00       	push   $0x803170
  801c99:	e8 6a 0a 00 00       	call   802708 <_panic>
	assert(r <= PGSIZE);
  801c9e:	68 7b 31 80 00       	push   $0x80317b
  801ca3:	68 5b 31 80 00       	push   $0x80315b
  801ca8:	68 99 00 00 00       	push   $0x99
  801cad:	68 70 31 80 00       	push   $0x803170
  801cb2:	e8 51 0a 00 00       	call   802708 <_panic>

00801cb7 <devfile_read>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cca:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  801cda:	e8 65 fe ff ff       	call   801b44 <fsipc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 1f                	js     801d04 <devfile_read+0x4d>
	assert(r <= n);
  801ce5:	39 f0                	cmp    %esi,%eax
  801ce7:	77 24                	ja     801d0d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ce9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cee:	7f 33                	jg     801d23 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	50                   	push   %eax
  801cf4:	68 00 60 80 00       	push   $0x806000
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	e8 71 ee ff ff       	call   800b72 <memmove>
	return r;
  801d01:	83 c4 10             	add    $0x10,%esp
}
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5d                   	pop    %ebp
  801d0c:	c3                   	ret    
	assert(r <= n);
  801d0d:	68 54 31 80 00       	push   $0x803154
  801d12:	68 5b 31 80 00       	push   $0x80315b
  801d17:	6a 7c                	push   $0x7c
  801d19:	68 70 31 80 00       	push   $0x803170
  801d1e:	e8 e5 09 00 00       	call   802708 <_panic>
	assert(r <= PGSIZE);
  801d23:	68 7b 31 80 00       	push   $0x80317b
  801d28:	68 5b 31 80 00       	push   $0x80315b
  801d2d:	6a 7d                	push   $0x7d
  801d2f:	68 70 31 80 00       	push   $0x803170
  801d34:	e8 cf 09 00 00       	call   802708 <_panic>

00801d39 <open>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 1c             	sub    $0x1c,%esp
  801d41:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d44:	56                   	push   %esi
  801d45:	e8 61 ec ff ff       	call   8009ab <strlen>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d52:	7f 6c                	jg     801dc0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5a:	50                   	push   %eax
  801d5b:	e8 79 f8 ff ff       	call   8015d9 <fd_alloc>
  801d60:	89 c3                	mov    %eax,%ebx
  801d62:	83 c4 10             	add    $0x10,%esp
  801d65:	85 c0                	test   %eax,%eax
  801d67:	78 3c                	js     801da5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	56                   	push   %esi
  801d6d:	68 00 60 80 00       	push   $0x806000
  801d72:	e8 6d ec ff ff       	call   8009e4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	e8 b8 fd ff ff       	call   801b44 <fsipc>
  801d8c:	89 c3                	mov    %eax,%ebx
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 19                	js     801dae <open+0x75>
	return fd2num(fd);
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9b:	e8 12 f8 ff ff       	call   8015b2 <fd2num>
  801da0:	89 c3                	mov    %eax,%ebx
  801da2:	83 c4 10             	add    $0x10,%esp
}
  801da5:	89 d8                	mov    %ebx,%eax
  801da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    
		fd_close(fd, 0);
  801dae:	83 ec 08             	sub    $0x8,%esp
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 f4             	pushl  -0xc(%ebp)
  801db6:	e8 1b f9 ff ff       	call   8016d6 <fd_close>
		return r;
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	eb e5                	jmp    801da5 <open+0x6c>
		return -E_BAD_PATH;
  801dc0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801dc5:	eb de                	jmp    801da5 <open+0x6c>

00801dc7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd7:	e8 68 fd ff ff       	call   801b44 <fsipc>
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801de4:	68 87 31 80 00       	push   $0x803187
  801de9:	ff 75 0c             	pushl  0xc(%ebp)
  801dec:	e8 f3 eb ff ff       	call   8009e4 <strcpy>
	return 0;
}
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <devsock_close>:
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	53                   	push   %ebx
  801dfc:	83 ec 10             	sub    $0x10,%esp
  801dff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e02:	53                   	push   %ebx
  801e03:	e8 f2 0a 00 00       	call   8028fa <pageref>
  801e08:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e0b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e10:	83 f8 01             	cmp    $0x1,%eax
  801e13:	74 07                	je     801e1c <devsock_close+0x24>
}
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	ff 73 0c             	pushl  0xc(%ebx)
  801e22:	e8 b9 02 00 00       	call   8020e0 <nsipc_close>
  801e27:	89 c2                	mov    %eax,%edx
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	eb e7                	jmp    801e15 <devsock_close+0x1d>

00801e2e <devsock_write>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	ff 70 0c             	pushl  0xc(%eax)
  801e42:	e8 76 03 00 00       	call   8021bd <nsipc_send>
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <devsock_read>:
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	ff 75 10             	pushl  0x10(%ebp)
  801e54:	ff 75 0c             	pushl  0xc(%ebp)
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	ff 70 0c             	pushl  0xc(%eax)
  801e5d:	e8 ef 02 00 00       	call   802151 <nsipc_recv>
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <fd2sockid>:
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e6a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e6d:	52                   	push   %edx
  801e6e:	50                   	push   %eax
  801e6f:	e8 b7 f7 ff ff       	call   80162b <fd_lookup>
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	85 c0                	test   %eax,%eax
  801e79:	78 10                	js     801e8b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7e:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e84:	39 08                	cmp    %ecx,(%eax)
  801e86:	75 05                	jne    801e8d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e88:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    
		return -E_NOT_SUPP;
  801e8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e92:	eb f7                	jmp    801e8b <fd2sockid+0x27>

00801e94 <alloc_sockfd>:
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	83 ec 1c             	sub    $0x1c,%esp
  801e9c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea1:	50                   	push   %eax
  801ea2:	e8 32 f7 ff ff       	call   8015d9 <fd_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	78 43                	js     801ef3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	68 07 04 00 00       	push   $0x407
  801eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebb:	6a 00                	push   $0x0
  801ebd:	e8 14 ef ff ff       	call   800dd6 <sys_page_alloc>
  801ec2:	89 c3                	mov    %eax,%ebx
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 28                	js     801ef3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ed4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ee0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	50                   	push   %eax
  801ee7:	e8 c6 f6 ff ff       	call   8015b2 <fd2num>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	eb 0c                	jmp    801eff <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	56                   	push   %esi
  801ef7:	e8 e4 01 00 00       	call   8020e0 <nsipc_close>
		return r;
  801efc:	83 c4 10             	add    $0x10,%esp
}
  801eff:	89 d8                	mov    %ebx,%eax
  801f01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <accept>:
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	e8 4e ff ff ff       	call   801e64 <fd2sockid>
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 1b                	js     801f35 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	ff 75 10             	pushl  0x10(%ebp)
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	e8 0e 01 00 00       	call   802037 <nsipc_accept>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 05                	js     801f35 <accept+0x2d>
	return alloc_sockfd(r);
  801f30:	e8 5f ff ff ff       	call   801e94 <alloc_sockfd>
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <bind>:
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	e8 1f ff ff ff       	call   801e64 <fd2sockid>
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 12                	js     801f5b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	ff 75 10             	pushl  0x10(%ebp)
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	50                   	push   %eax
  801f53:	e8 31 01 00 00       	call   802089 <nsipc_bind>
  801f58:	83 c4 10             	add    $0x10,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <shutdown>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	e8 f9 fe ff ff       	call   801e64 <fd2sockid>
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	78 0f                	js     801f7e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f6f:	83 ec 08             	sub    $0x8,%esp
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	50                   	push   %eax
  801f76:	e8 43 01 00 00       	call   8020be <nsipc_shutdown>
  801f7b:	83 c4 10             	add    $0x10,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <connect>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	e8 d6 fe ff ff       	call   801e64 <fd2sockid>
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 12                	js     801fa4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	ff 75 10             	pushl  0x10(%ebp)
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	50                   	push   %eax
  801f9c:	e8 59 01 00 00       	call   8020fa <nsipc_connect>
  801fa1:	83 c4 10             	add    $0x10,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <listen>:
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	e8 b0 fe ff ff       	call   801e64 <fd2sockid>
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 0f                	js     801fc7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fb8:	83 ec 08             	sub    $0x8,%esp
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	50                   	push   %eax
  801fbf:	e8 6b 01 00 00       	call   80212f <nsipc_listen>
  801fc4:	83 c4 10             	add    $0x10,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fcf:	ff 75 10             	pushl  0x10(%ebp)
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	e8 3e 02 00 00       	call   80221b <nsipc_socket>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 05                	js     801fe9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fe4:	e8 ab fe ff ff       	call   801e94 <alloc_sockfd>
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	53                   	push   %ebx
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ff4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ffb:	74 26                	je     802023 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ffd:	6a 07                	push   $0x7
  801fff:	68 00 70 80 00       	push   $0x807000
  802004:	53                   	push   %ebx
  802005:	ff 35 04 50 80 00    	pushl  0x805004
  80200b:	e8 57 08 00 00       	call   802867 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802010:	83 c4 0c             	add    $0xc,%esp
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	e8 e0 07 00 00       	call   8027fe <ipc_recv>
}
  80201e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802021:	c9                   	leave  
  802022:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	6a 02                	push   $0x2
  802028:	e8 92 08 00 00       	call   8028bf <ipc_find_env>
  80202d:	a3 04 50 80 00       	mov    %eax,0x805004
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	eb c6                	jmp    801ffd <nsipc+0x12>

00802037 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802047:	8b 06                	mov    (%esi),%eax
  802049:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	e8 93 ff ff ff       	call   801feb <nsipc>
  802058:	89 c3                	mov    %eax,%ebx
  80205a:	85 c0                	test   %eax,%eax
  80205c:	79 09                	jns    802067 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80205e:	89 d8                	mov    %ebx,%eax
  802060:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5d                   	pop    %ebp
  802066:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	ff 35 10 70 80 00    	pushl  0x807010
  802070:	68 00 70 80 00       	push   $0x807000
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	e8 f5 ea ff ff       	call   800b72 <memmove>
		*addrlen = ret->ret_addrlen;
  80207d:	a1 10 70 80 00       	mov    0x807010,%eax
  802082:	89 06                	mov    %eax,(%esi)
  802084:	83 c4 10             	add    $0x10,%esp
	return r;
  802087:	eb d5                	jmp    80205e <nsipc_accept+0x27>

00802089 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	53                   	push   %ebx
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80209b:	53                   	push   %ebx
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	68 04 70 80 00       	push   $0x807004
  8020a4:	e8 c9 ea ff ff       	call   800b72 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020a9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020af:	b8 02 00 00 00       	mov    $0x2,%eax
  8020b4:	e8 32 ff ff ff       	call   801feb <nsipc>
}
  8020b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020d9:	e8 0d ff ff ff       	call   801feb <nsipc>
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8020f3:	e8 f3 fe ff ff       	call   801feb <nsipc>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	53                   	push   %ebx
  8020fe:	83 ec 08             	sub    $0x8,%esp
  802101:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80210c:	53                   	push   %ebx
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	68 04 70 80 00       	push   $0x807004
  802115:	e8 58 ea ff ff       	call   800b72 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80211a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802120:	b8 05 00 00 00       	mov    $0x5,%eax
  802125:	e8 c1 fe ff ff       	call   801feb <nsipc>
}
  80212a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802145:	b8 06 00 00 00       	mov    $0x6,%eax
  80214a:	e8 9c fe ff ff       	call   801feb <nsipc>
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	56                   	push   %esi
  802155:	53                   	push   %ebx
  802156:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802161:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802167:	8b 45 14             	mov    0x14(%ebp),%eax
  80216a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80216f:	b8 07 00 00 00       	mov    $0x7,%eax
  802174:	e8 72 fe ff ff       	call   801feb <nsipc>
  802179:	89 c3                	mov    %eax,%ebx
  80217b:	85 c0                	test   %eax,%eax
  80217d:	78 1f                	js     80219e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80217f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802184:	7f 21                	jg     8021a7 <nsipc_recv+0x56>
  802186:	39 c6                	cmp    %eax,%esi
  802188:	7c 1d                	jl     8021a7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80218a:	83 ec 04             	sub    $0x4,%esp
  80218d:	50                   	push   %eax
  80218e:	68 00 70 80 00       	push   $0x807000
  802193:	ff 75 0c             	pushl  0xc(%ebp)
  802196:	e8 d7 e9 ff ff       	call   800b72 <memmove>
  80219b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80219e:	89 d8                	mov    %ebx,%eax
  8021a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a3:	5b                   	pop    %ebx
  8021a4:	5e                   	pop    %esi
  8021a5:	5d                   	pop    %ebp
  8021a6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021a7:	68 93 31 80 00       	push   $0x803193
  8021ac:	68 5b 31 80 00       	push   $0x80315b
  8021b1:	6a 62                	push   $0x62
  8021b3:	68 a8 31 80 00       	push   $0x8031a8
  8021b8:	e8 4b 05 00 00       	call   802708 <_panic>

008021bd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	53                   	push   %ebx
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021cf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021d5:	7f 2e                	jg     802205 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	53                   	push   %ebx
  8021db:	ff 75 0c             	pushl  0xc(%ebp)
  8021de:	68 0c 70 80 00       	push   $0x80700c
  8021e3:	e8 8a e9 ff ff       	call   800b72 <memmove>
	nsipcbuf.send.req_size = size;
  8021e8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021fb:	e8 eb fd ff ff       	call   801feb <nsipc>
}
  802200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802203:	c9                   	leave  
  802204:	c3                   	ret    
	assert(size < 1600);
  802205:	68 b4 31 80 00       	push   $0x8031b4
  80220a:	68 5b 31 80 00       	push   $0x80315b
  80220f:	6a 6d                	push   $0x6d
  802211:	68 a8 31 80 00       	push   $0x8031a8
  802216:	e8 ed 04 00 00       	call   802708 <_panic>

0080221b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802231:	8b 45 10             	mov    0x10(%ebp),%eax
  802234:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802239:	b8 09 00 00 00       	mov    $0x9,%eax
  80223e:	e8 a8 fd ff ff       	call   801feb <nsipc>
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	56                   	push   %esi
  802249:	53                   	push   %ebx
  80224a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	ff 75 08             	pushl  0x8(%ebp)
  802253:	e8 6a f3 ff ff       	call   8015c2 <fd2data>
  802258:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80225a:	83 c4 08             	add    $0x8,%esp
  80225d:	68 c0 31 80 00       	push   $0x8031c0
  802262:	53                   	push   %ebx
  802263:	e8 7c e7 ff ff       	call   8009e4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802268:	8b 46 04             	mov    0x4(%esi),%eax
  80226b:	2b 06                	sub    (%esi),%eax
  80226d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802273:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80227a:	00 00 00 
	stat->st_dev = &devpipe;
  80227d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802284:	40 80 00 
	return 0;
}
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228f:	5b                   	pop    %ebx
  802290:	5e                   	pop    %esi
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    

00802293 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	53                   	push   %ebx
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80229d:	53                   	push   %ebx
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 b6 eb ff ff       	call   800e5b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022a5:	89 1c 24             	mov    %ebx,(%esp)
  8022a8:	e8 15 f3 ff ff       	call   8015c2 <fd2data>
  8022ad:	83 c4 08             	add    $0x8,%esp
  8022b0:	50                   	push   %eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	e8 a3 eb ff ff       	call   800e5b <sys_page_unmap>
}
  8022b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <_pipeisclosed>:
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
  8022c0:	57                   	push   %edi
  8022c1:	56                   	push   %esi
  8022c2:	53                   	push   %ebx
  8022c3:	83 ec 1c             	sub    $0x1c,%esp
  8022c6:	89 c7                	mov    %eax,%edi
  8022c8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8022cf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	57                   	push   %edi
  8022d6:	e8 1f 06 00 00       	call   8028fa <pageref>
  8022db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022de:	89 34 24             	mov    %esi,(%esp)
  8022e1:	e8 14 06 00 00       	call   8028fa <pageref>
		nn = thisenv->env_runs;
  8022e6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8022ec:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	39 cb                	cmp    %ecx,%ebx
  8022f4:	74 1b                	je     802311 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022f9:	75 cf                	jne    8022ca <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022fb:	8b 42 58             	mov    0x58(%edx),%eax
  8022fe:	6a 01                	push   $0x1
  802300:	50                   	push   %eax
  802301:	53                   	push   %ebx
  802302:	68 c7 31 80 00       	push   $0x8031c7
  802307:	e8 79 df ff ff       	call   800285 <cprintf>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	eb b9                	jmp    8022ca <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802311:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802314:	0f 94 c0             	sete   %al
  802317:	0f b6 c0             	movzbl %al,%eax
}
  80231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <devpipe_write>:
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 28             	sub    $0x28,%esp
  80232b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80232e:	56                   	push   %esi
  80232f:	e8 8e f2 ff ff       	call   8015c2 <fd2data>
  802334:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	bf 00 00 00 00       	mov    $0x0,%edi
  80233e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802341:	74 4f                	je     802392 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802343:	8b 43 04             	mov    0x4(%ebx),%eax
  802346:	8b 0b                	mov    (%ebx),%ecx
  802348:	8d 51 20             	lea    0x20(%ecx),%edx
  80234b:	39 d0                	cmp    %edx,%eax
  80234d:	72 14                	jb     802363 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80234f:	89 da                	mov    %ebx,%edx
  802351:	89 f0                	mov    %esi,%eax
  802353:	e8 65 ff ff ff       	call   8022bd <_pipeisclosed>
  802358:	85 c0                	test   %eax,%eax
  80235a:	75 3b                	jne    802397 <devpipe_write+0x75>
			sys_yield();
  80235c:	e8 56 ea ff ff       	call   800db7 <sys_yield>
  802361:	eb e0                	jmp    802343 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802366:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80236a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80236d:	89 c2                	mov    %eax,%edx
  80236f:	c1 fa 1f             	sar    $0x1f,%edx
  802372:	89 d1                	mov    %edx,%ecx
  802374:	c1 e9 1b             	shr    $0x1b,%ecx
  802377:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80237a:	83 e2 1f             	and    $0x1f,%edx
  80237d:	29 ca                	sub    %ecx,%edx
  80237f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802383:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802387:	83 c0 01             	add    $0x1,%eax
  80238a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80238d:	83 c7 01             	add    $0x1,%edi
  802390:	eb ac                	jmp    80233e <devpipe_write+0x1c>
	return i;
  802392:	8b 45 10             	mov    0x10(%ebp),%eax
  802395:	eb 05                	jmp    80239c <devpipe_write+0x7a>
				return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <devpipe_read>:
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	57                   	push   %edi
  8023a8:	56                   	push   %esi
  8023a9:	53                   	push   %ebx
  8023aa:	83 ec 18             	sub    $0x18,%esp
  8023ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023b0:	57                   	push   %edi
  8023b1:	e8 0c f2 ff ff       	call   8015c2 <fd2data>
  8023b6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	be 00 00 00 00       	mov    $0x0,%esi
  8023c0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c3:	75 14                	jne    8023d9 <devpipe_read+0x35>
	return i;
  8023c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c8:	eb 02                	jmp    8023cc <devpipe_read+0x28>
				return i;
  8023ca:	89 f0                	mov    %esi,%eax
}
  8023cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023cf:	5b                   	pop    %ebx
  8023d0:	5e                   	pop    %esi
  8023d1:	5f                   	pop    %edi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    
			sys_yield();
  8023d4:	e8 de e9 ff ff       	call   800db7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023d9:	8b 03                	mov    (%ebx),%eax
  8023db:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023de:	75 18                	jne    8023f8 <devpipe_read+0x54>
			if (i > 0)
  8023e0:	85 f6                	test   %esi,%esi
  8023e2:	75 e6                	jne    8023ca <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023e4:	89 da                	mov    %ebx,%edx
  8023e6:	89 f8                	mov    %edi,%eax
  8023e8:	e8 d0 fe ff ff       	call   8022bd <_pipeisclosed>
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	74 e3                	je     8023d4 <devpipe_read+0x30>
				return 0;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	eb d4                	jmp    8023cc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023f8:	99                   	cltd   
  8023f9:	c1 ea 1b             	shr    $0x1b,%edx
  8023fc:	01 d0                	add    %edx,%eax
  8023fe:	83 e0 1f             	and    $0x1f,%eax
  802401:	29 d0                	sub    %edx,%eax
  802403:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802408:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80240b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80240e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802411:	83 c6 01             	add    $0x1,%esi
  802414:	eb aa                	jmp    8023c0 <devpipe_read+0x1c>

00802416 <pipe>:
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	56                   	push   %esi
  80241a:	53                   	push   %ebx
  80241b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80241e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802421:	50                   	push   %eax
  802422:	e8 b2 f1 ff ff       	call   8015d9 <fd_alloc>
  802427:	89 c3                	mov    %eax,%ebx
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	85 c0                	test   %eax,%eax
  80242e:	0f 88 23 01 00 00    	js     802557 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	68 07 04 00 00       	push   $0x407
  80243c:	ff 75 f4             	pushl  -0xc(%ebp)
  80243f:	6a 00                	push   $0x0
  802441:	e8 90 e9 ff ff       	call   800dd6 <sys_page_alloc>
  802446:	89 c3                	mov    %eax,%ebx
  802448:	83 c4 10             	add    $0x10,%esp
  80244b:	85 c0                	test   %eax,%eax
  80244d:	0f 88 04 01 00 00    	js     802557 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802459:	50                   	push   %eax
  80245a:	e8 7a f1 ff ff       	call   8015d9 <fd_alloc>
  80245f:	89 c3                	mov    %eax,%ebx
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	85 c0                	test   %eax,%eax
  802466:	0f 88 db 00 00 00    	js     802547 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 07 04 00 00       	push   $0x407
  802474:	ff 75 f0             	pushl  -0x10(%ebp)
  802477:	6a 00                	push   $0x0
  802479:	e8 58 e9 ff ff       	call   800dd6 <sys_page_alloc>
  80247e:	89 c3                	mov    %eax,%ebx
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	85 c0                	test   %eax,%eax
  802485:	0f 88 bc 00 00 00    	js     802547 <pipe+0x131>
	va = fd2data(fd0);
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	ff 75 f4             	pushl  -0xc(%ebp)
  802491:	e8 2c f1 ff ff       	call   8015c2 <fd2data>
  802496:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802498:	83 c4 0c             	add    $0xc,%esp
  80249b:	68 07 04 00 00       	push   $0x407
  8024a0:	50                   	push   %eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	e8 2e e9 ff ff       	call   800dd6 <sys_page_alloc>
  8024a8:	89 c3                	mov    %eax,%ebx
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	0f 88 82 00 00 00    	js     802537 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024b5:	83 ec 0c             	sub    $0xc,%esp
  8024b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8024bb:	e8 02 f1 ff ff       	call   8015c2 <fd2data>
  8024c0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024c7:	50                   	push   %eax
  8024c8:	6a 00                	push   $0x0
  8024ca:	56                   	push   %esi
  8024cb:	6a 00                	push   $0x0
  8024cd:	e8 47 e9 ff ff       	call   800e19 <sys_page_map>
  8024d2:	89 c3                	mov    %eax,%ebx
  8024d4:	83 c4 20             	add    $0x20,%esp
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	78 4e                	js     802529 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024db:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	ff 75 f4             	pushl  -0xc(%ebp)
  802504:	e8 a9 f0 ff ff       	call   8015b2 <fd2num>
  802509:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80250e:	83 c4 04             	add    $0x4,%esp
  802511:	ff 75 f0             	pushl  -0x10(%ebp)
  802514:	e8 99 f0 ff ff       	call   8015b2 <fd2num>
  802519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	bb 00 00 00 00       	mov    $0x0,%ebx
  802527:	eb 2e                	jmp    802557 <pipe+0x141>
	sys_page_unmap(0, va);
  802529:	83 ec 08             	sub    $0x8,%esp
  80252c:	56                   	push   %esi
  80252d:	6a 00                	push   $0x0
  80252f:	e8 27 e9 ff ff       	call   800e5b <sys_page_unmap>
  802534:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802537:	83 ec 08             	sub    $0x8,%esp
  80253a:	ff 75 f0             	pushl  -0x10(%ebp)
  80253d:	6a 00                	push   $0x0
  80253f:	e8 17 e9 ff ff       	call   800e5b <sys_page_unmap>
  802544:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802547:	83 ec 08             	sub    $0x8,%esp
  80254a:	ff 75 f4             	pushl  -0xc(%ebp)
  80254d:	6a 00                	push   $0x0
  80254f:	e8 07 e9 ff ff       	call   800e5b <sys_page_unmap>
  802554:	83 c4 10             	add    $0x10,%esp
}
  802557:	89 d8                	mov    %ebx,%eax
  802559:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    

00802560 <pipeisclosed>:
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802569:	50                   	push   %eax
  80256a:	ff 75 08             	pushl  0x8(%ebp)
  80256d:	e8 b9 f0 ff ff       	call   80162b <fd_lookup>
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	85 c0                	test   %eax,%eax
  802577:	78 18                	js     802591 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802579:	83 ec 0c             	sub    $0xc,%esp
  80257c:	ff 75 f4             	pushl  -0xc(%ebp)
  80257f:	e8 3e f0 ff ff       	call   8015c2 <fd2data>
	return _pipeisclosed(fd, p);
  802584:	89 c2                	mov    %eax,%edx
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	e8 2f fd ff ff       	call   8022bd <_pipeisclosed>
  80258e:	83 c4 10             	add    $0x10,%esp
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	c3                   	ret    

00802599 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80259f:	68 df 31 80 00       	push   $0x8031df
  8025a4:	ff 75 0c             	pushl  0xc(%ebp)
  8025a7:	e8 38 e4 ff ff       	call   8009e4 <strcpy>
	return 0;
}
  8025ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <devcons_write>:
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	57                   	push   %edi
  8025b7:	56                   	push   %esi
  8025b8:	53                   	push   %ebx
  8025b9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025bf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025c4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025ca:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025cd:	73 31                	jae    802600 <devcons_write+0x4d>
		m = n - tot;
  8025cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025d2:	29 f3                	sub    %esi,%ebx
  8025d4:	83 fb 7f             	cmp    $0x7f,%ebx
  8025d7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025dc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	53                   	push   %ebx
  8025e3:	89 f0                	mov    %esi,%eax
  8025e5:	03 45 0c             	add    0xc(%ebp),%eax
  8025e8:	50                   	push   %eax
  8025e9:	57                   	push   %edi
  8025ea:	e8 83 e5 ff ff       	call   800b72 <memmove>
		sys_cputs(buf, m);
  8025ef:	83 c4 08             	add    $0x8,%esp
  8025f2:	53                   	push   %ebx
  8025f3:	57                   	push   %edi
  8025f4:	e8 21 e7 ff ff       	call   800d1a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025f9:	01 de                	add    %ebx,%esi
  8025fb:	83 c4 10             	add    $0x10,%esp
  8025fe:	eb ca                	jmp    8025ca <devcons_write+0x17>
}
  802600:	89 f0                	mov    %esi,%eax
  802602:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802605:	5b                   	pop    %ebx
  802606:	5e                   	pop    %esi
  802607:	5f                   	pop    %edi
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    

0080260a <devcons_read>:
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 08             	sub    $0x8,%esp
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802615:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802619:	74 21                	je     80263c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80261b:	e8 18 e7 ff ff       	call   800d38 <sys_cgetc>
  802620:	85 c0                	test   %eax,%eax
  802622:	75 07                	jne    80262b <devcons_read+0x21>
		sys_yield();
  802624:	e8 8e e7 ff ff       	call   800db7 <sys_yield>
  802629:	eb f0                	jmp    80261b <devcons_read+0x11>
	if (c < 0)
  80262b:	78 0f                	js     80263c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80262d:	83 f8 04             	cmp    $0x4,%eax
  802630:	74 0c                	je     80263e <devcons_read+0x34>
	*(char*)vbuf = c;
  802632:	8b 55 0c             	mov    0xc(%ebp),%edx
  802635:	88 02                	mov    %al,(%edx)
	return 1;
  802637:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    
		return 0;
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
  802643:	eb f7                	jmp    80263c <devcons_read+0x32>

00802645 <cputchar>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802651:	6a 01                	push   $0x1
  802653:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802656:	50                   	push   %eax
  802657:	e8 be e6 ff ff       	call   800d1a <sys_cputs>
}
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <getchar>:
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802667:	6a 01                	push   $0x1
  802669:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80266c:	50                   	push   %eax
  80266d:	6a 00                	push   $0x0
  80266f:	e8 27 f2 ff ff       	call   80189b <read>
	if (r < 0)
  802674:	83 c4 10             	add    $0x10,%esp
  802677:	85 c0                	test   %eax,%eax
  802679:	78 06                	js     802681 <getchar+0x20>
	if (r < 1)
  80267b:	74 06                	je     802683 <getchar+0x22>
	return c;
  80267d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    
		return -E_EOF;
  802683:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802688:	eb f7                	jmp    802681 <getchar+0x20>

0080268a <iscons>:
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802690:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802693:	50                   	push   %eax
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	e8 8f ef ff ff       	call   80162b <fd_lookup>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	78 11                	js     8026b4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ac:	39 10                	cmp    %edx,(%eax)
  8026ae:	0f 94 c0             	sete   %al
  8026b1:	0f b6 c0             	movzbl %al,%eax
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <opencons>:
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026bf:	50                   	push   %eax
  8026c0:	e8 14 ef ff ff       	call   8015d9 <fd_alloc>
  8026c5:	83 c4 10             	add    $0x10,%esp
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	78 3a                	js     802706 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 07 04 00 00       	push   $0x407
  8026d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d7:	6a 00                	push   $0x0
  8026d9:	e8 f8 e6 ff ff       	call   800dd6 <sys_page_alloc>
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	78 21                	js     802706 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ee:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026fa:	83 ec 0c             	sub    $0xc,%esp
  8026fd:	50                   	push   %eax
  8026fe:	e8 af ee ff ff       	call   8015b2 <fd2num>
  802703:	83 c4 10             	add    $0x10,%esp
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	56                   	push   %esi
  80270c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80270d:	a1 08 50 80 00       	mov    0x805008,%eax
  802712:	8b 40 48             	mov    0x48(%eax),%eax
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 10 32 80 00       	push   $0x803210
  80271d:	50                   	push   %eax
  80271e:	68 0e 2c 80 00       	push   $0x802c0e
  802723:	e8 5d db ff ff       	call   800285 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802728:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80272b:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802731:	e8 62 e6 ff ff       	call   800d98 <sys_getenvid>
  802736:	83 c4 04             	add    $0x4,%esp
  802739:	ff 75 0c             	pushl  0xc(%ebp)
  80273c:	ff 75 08             	pushl  0x8(%ebp)
  80273f:	56                   	push   %esi
  802740:	50                   	push   %eax
  802741:	68 ec 31 80 00       	push   $0x8031ec
  802746:	e8 3a db ff ff       	call   800285 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80274b:	83 c4 18             	add    $0x18,%esp
  80274e:	53                   	push   %ebx
  80274f:	ff 75 10             	pushl  0x10(%ebp)
  802752:	e8 dd da ff ff       	call   800234 <vcprintf>
	cprintf("\n");
  802757:	c7 04 24 d2 2b 80 00 	movl   $0x802bd2,(%esp)
  80275e:	e8 22 db ff ff       	call   800285 <cprintf>
  802763:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802766:	cc                   	int3   
  802767:	eb fd                	jmp    802766 <_panic+0x5e>

00802769 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
  80276c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80276f:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802776:	74 0a                	je     802782 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	6a 07                	push   $0x7
  802787:	68 00 f0 bf ee       	push   $0xeebff000
  80278c:	6a 00                	push   $0x0
  80278e:	e8 43 e6 ff ff       	call   800dd6 <sys_page_alloc>
		if(r < 0)
  802793:	83 c4 10             	add    $0x10,%esp
  802796:	85 c0                	test   %eax,%eax
  802798:	78 2a                	js     8027c4 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80279a:	83 ec 08             	sub    $0x8,%esp
  80279d:	68 d8 27 80 00       	push   $0x8027d8
  8027a2:	6a 00                	push   $0x0
  8027a4:	e8 78 e7 ff ff       	call   800f21 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	79 c8                	jns    802778 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	68 48 32 80 00       	push   $0x803248
  8027b8:	6a 25                	push   $0x25
  8027ba:	68 84 32 80 00       	push   $0x803284
  8027bf:	e8 44 ff ff ff       	call   802708 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 18 32 80 00       	push   $0x803218
  8027cc:	6a 22                	push   $0x22
  8027ce:	68 84 32 80 00       	push   $0x803284
  8027d3:	e8 30 ff ff ff       	call   802708 <_panic>

008027d8 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027d9:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027e0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027e3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027e7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027eb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027ee:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027f0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027f4:	83 c4 08             	add    $0x8,%esp
	popal
  8027f7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027f8:	83 c4 04             	add    $0x4,%esp
	popfl
  8027fb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027fc:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027fd:	c3                   	ret    

008027fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	56                   	push   %esi
  802802:	53                   	push   %ebx
  802803:	8b 75 08             	mov    0x8(%ebp),%esi
  802806:	8b 45 0c             	mov    0xc(%ebp),%eax
  802809:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80280c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80280e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802813:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802816:	83 ec 0c             	sub    $0xc,%esp
  802819:	50                   	push   %eax
  80281a:	e8 67 e7 ff ff       	call   800f86 <sys_ipc_recv>
	if(ret < 0){
  80281f:	83 c4 10             	add    $0x10,%esp
  802822:	85 c0                	test   %eax,%eax
  802824:	78 2b                	js     802851 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802826:	85 f6                	test   %esi,%esi
  802828:	74 0a                	je     802834 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80282a:	a1 08 50 80 00       	mov    0x805008,%eax
  80282f:	8b 40 74             	mov    0x74(%eax),%eax
  802832:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802834:	85 db                	test   %ebx,%ebx
  802836:	74 0a                	je     802842 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802838:	a1 08 50 80 00       	mov    0x805008,%eax
  80283d:	8b 40 78             	mov    0x78(%eax),%eax
  802840:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802842:	a1 08 50 80 00       	mov    0x805008,%eax
  802847:	8b 40 70             	mov    0x70(%eax),%eax
}
  80284a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80284d:	5b                   	pop    %ebx
  80284e:	5e                   	pop    %esi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    
		if(from_env_store)
  802851:	85 f6                	test   %esi,%esi
  802853:	74 06                	je     80285b <ipc_recv+0x5d>
			*from_env_store = 0;
  802855:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80285b:	85 db                	test   %ebx,%ebx
  80285d:	74 eb                	je     80284a <ipc_recv+0x4c>
			*perm_store = 0;
  80285f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802865:	eb e3                	jmp    80284a <ipc_recv+0x4c>

00802867 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	57                   	push   %edi
  80286b:	56                   	push   %esi
  80286c:	53                   	push   %ebx
  80286d:	83 ec 0c             	sub    $0xc,%esp
  802870:	8b 7d 08             	mov    0x8(%ebp),%edi
  802873:	8b 75 0c             	mov    0xc(%ebp),%esi
  802876:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802879:	85 db                	test   %ebx,%ebx
  80287b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802880:	0f 44 d8             	cmove  %eax,%ebx
  802883:	eb 05                	jmp    80288a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802885:	e8 2d e5 ff ff       	call   800db7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80288a:	ff 75 14             	pushl  0x14(%ebp)
  80288d:	53                   	push   %ebx
  80288e:	56                   	push   %esi
  80288f:	57                   	push   %edi
  802890:	e8 ce e6 ff ff       	call   800f63 <sys_ipc_try_send>
  802895:	83 c4 10             	add    $0x10,%esp
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 1b                	je     8028b7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80289c:	79 e7                	jns    802885 <ipc_send+0x1e>
  80289e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028a1:	74 e2                	je     802885 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	68 92 32 80 00       	push   $0x803292
  8028ab:	6a 46                	push   $0x46
  8028ad:	68 a7 32 80 00       	push   $0x8032a7
  8028b2:	e8 51 fe ff ff       	call   802708 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ba:	5b                   	pop    %ebx
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    

008028bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028ca:	89 c2                	mov    %eax,%edx
  8028cc:	c1 e2 07             	shl    $0x7,%edx
  8028cf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028d5:	8b 52 50             	mov    0x50(%edx),%edx
  8028d8:	39 ca                	cmp    %ecx,%edx
  8028da:	74 11                	je     8028ed <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028dc:	83 c0 01             	add    $0x1,%eax
  8028df:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028e4:	75 e4                	jne    8028ca <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028eb:	eb 0b                	jmp    8028f8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8028ed:	c1 e0 07             	shl    $0x7,%eax
  8028f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028f5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028f8:	5d                   	pop    %ebp
  8028f9:	c3                   	ret    

008028fa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802900:	89 d0                	mov    %edx,%eax
  802902:	c1 e8 16             	shr    $0x16,%eax
  802905:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802911:	f6 c1 01             	test   $0x1,%cl
  802914:	74 1d                	je     802933 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802916:	c1 ea 0c             	shr    $0xc,%edx
  802919:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802920:	f6 c2 01             	test   $0x1,%dl
  802923:	74 0e                	je     802933 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802925:	c1 ea 0c             	shr    $0xc,%edx
  802928:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80292f:	ef 
  802930:	0f b7 c0             	movzwl %ax,%eax
}
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    
  802935:	66 90                	xchg   %ax,%ax
  802937:	66 90                	xchg   %ax,%ax
  802939:	66 90                	xchg   %ax,%ax
  80293b:	66 90                	xchg   %ax,%ax
  80293d:	66 90                	xchg   %ax,%ax
  80293f:	90                   	nop

00802940 <__udivdi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	53                   	push   %ebx
  802944:	83 ec 1c             	sub    $0x1c,%esp
  802947:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80294b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80294f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802953:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802957:	85 d2                	test   %edx,%edx
  802959:	75 4d                	jne    8029a8 <__udivdi3+0x68>
  80295b:	39 f3                	cmp    %esi,%ebx
  80295d:	76 19                	jbe    802978 <__udivdi3+0x38>
  80295f:	31 ff                	xor    %edi,%edi
  802961:	89 e8                	mov    %ebp,%eax
  802963:	89 f2                	mov    %esi,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 fa                	mov    %edi,%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802978:	89 d9                	mov    %ebx,%ecx
  80297a:	85 db                	test   %ebx,%ebx
  80297c:	75 0b                	jne    802989 <__udivdi3+0x49>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	31 d2                	xor    %edx,%edx
  802985:	f7 f3                	div    %ebx
  802987:	89 c1                	mov    %eax,%ecx
  802989:	31 d2                	xor    %edx,%edx
  80298b:	89 f0                	mov    %esi,%eax
  80298d:	f7 f1                	div    %ecx
  80298f:	89 c6                	mov    %eax,%esi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f7                	mov    %esi,%edi
  802995:	f7 f1                	div    %ecx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	39 f2                	cmp    %esi,%edx
  8029aa:	77 1c                	ja     8029c8 <__udivdi3+0x88>
  8029ac:	0f bd fa             	bsr    %edx,%edi
  8029af:	83 f7 1f             	xor    $0x1f,%edi
  8029b2:	75 2c                	jne    8029e0 <__udivdi3+0xa0>
  8029b4:	39 f2                	cmp    %esi,%edx
  8029b6:	72 06                	jb     8029be <__udivdi3+0x7e>
  8029b8:	31 c0                	xor    %eax,%eax
  8029ba:	39 eb                	cmp    %ebp,%ebx
  8029bc:	77 a9                	ja     802967 <__udivdi3+0x27>
  8029be:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c3:	eb a2                	jmp    802967 <__udivdi3+0x27>
  8029c5:	8d 76 00             	lea    0x0(%esi),%esi
  8029c8:	31 ff                	xor    %edi,%edi
  8029ca:	31 c0                	xor    %eax,%eax
  8029cc:	89 fa                	mov    %edi,%edx
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	89 f9                	mov    %edi,%ecx
  8029e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029e7:	29 f8                	sub    %edi,%eax
  8029e9:	d3 e2                	shl    %cl,%edx
  8029eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ef:	89 c1                	mov    %eax,%ecx
  8029f1:	89 da                	mov    %ebx,%edx
  8029f3:	d3 ea                	shr    %cl,%edx
  8029f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029f9:	09 d1                	or     %edx,%ecx
  8029fb:	89 f2                	mov    %esi,%edx
  8029fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a01:	89 f9                	mov    %edi,%ecx
  802a03:	d3 e3                	shl    %cl,%ebx
  802a05:	89 c1                	mov    %eax,%ecx
  802a07:	d3 ea                	shr    %cl,%edx
  802a09:	89 f9                	mov    %edi,%ecx
  802a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a0f:	89 eb                	mov    %ebp,%ebx
  802a11:	d3 e6                	shl    %cl,%esi
  802a13:	89 c1                	mov    %eax,%ecx
  802a15:	d3 eb                	shr    %cl,%ebx
  802a17:	09 de                	or     %ebx,%esi
  802a19:	89 f0                	mov    %esi,%eax
  802a1b:	f7 74 24 08          	divl   0x8(%esp)
  802a1f:	89 d6                	mov    %edx,%esi
  802a21:	89 c3                	mov    %eax,%ebx
  802a23:	f7 64 24 0c          	mull   0xc(%esp)
  802a27:	39 d6                	cmp    %edx,%esi
  802a29:	72 15                	jb     802a40 <__udivdi3+0x100>
  802a2b:	89 f9                	mov    %edi,%ecx
  802a2d:	d3 e5                	shl    %cl,%ebp
  802a2f:	39 c5                	cmp    %eax,%ebp
  802a31:	73 04                	jae    802a37 <__udivdi3+0xf7>
  802a33:	39 d6                	cmp    %edx,%esi
  802a35:	74 09                	je     802a40 <__udivdi3+0x100>
  802a37:	89 d8                	mov    %ebx,%eax
  802a39:	31 ff                	xor    %edi,%edi
  802a3b:	e9 27 ff ff ff       	jmp    802967 <__udivdi3+0x27>
  802a40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a43:	31 ff                	xor    %edi,%edi
  802a45:	e9 1d ff ff ff       	jmp    802967 <__udivdi3+0x27>
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	66 90                	xchg   %ax,%ax
  802a4e:	66 90                	xchg   %ax,%ax

00802a50 <__umoddi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	83 ec 1c             	sub    $0x1c,%esp
  802a57:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a67:	89 da                	mov    %ebx,%edx
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	75 43                	jne    802ab0 <__umoddi3+0x60>
  802a6d:	39 df                	cmp    %ebx,%edi
  802a6f:	76 17                	jbe    802a88 <__umoddi3+0x38>
  802a71:	89 f0                	mov    %esi,%eax
  802a73:	f7 f7                	div    %edi
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	31 d2                	xor    %edx,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 fd                	mov    %edi,%ebp
  802a8a:	85 ff                	test   %edi,%edi
  802a8c:	75 0b                	jne    802a99 <__umoddi3+0x49>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f7                	div    %edi
  802a97:	89 c5                	mov    %eax,%ebp
  802a99:	89 d8                	mov    %ebx,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f5                	div    %ebp
  802a9f:	89 f0                	mov    %esi,%eax
  802aa1:	f7 f5                	div    %ebp
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	eb d0                	jmp    802a77 <__umoddi3+0x27>
  802aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aae:	66 90                	xchg   %ax,%ax
  802ab0:	89 f1                	mov    %esi,%ecx
  802ab2:	39 d8                	cmp    %ebx,%eax
  802ab4:	76 0a                	jbe    802ac0 <__umoddi3+0x70>
  802ab6:	89 f0                	mov    %esi,%eax
  802ab8:	83 c4 1c             	add    $0x1c,%esp
  802abb:	5b                   	pop    %ebx
  802abc:	5e                   	pop    %esi
  802abd:	5f                   	pop    %edi
  802abe:	5d                   	pop    %ebp
  802abf:	c3                   	ret    
  802ac0:	0f bd e8             	bsr    %eax,%ebp
  802ac3:	83 f5 1f             	xor    $0x1f,%ebp
  802ac6:	75 20                	jne    802ae8 <__umoddi3+0x98>
  802ac8:	39 d8                	cmp    %ebx,%eax
  802aca:	0f 82 b0 00 00 00    	jb     802b80 <__umoddi3+0x130>
  802ad0:	39 f7                	cmp    %esi,%edi
  802ad2:	0f 86 a8 00 00 00    	jbe    802b80 <__umoddi3+0x130>
  802ad8:	89 c8                	mov    %ecx,%eax
  802ada:	83 c4 1c             	add    $0x1c,%esp
  802add:	5b                   	pop    %ebx
  802ade:	5e                   	pop    %esi
  802adf:	5f                   	pop    %edi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    
  802ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	ba 20 00 00 00       	mov    $0x20,%edx
  802aef:	29 ea                	sub    %ebp,%edx
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af7:	89 d1                	mov    %edx,%ecx
  802af9:	89 f8                	mov    %edi,%eax
  802afb:	d3 e8                	shr    %cl,%eax
  802afd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b01:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b05:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b09:	09 c1                	or     %eax,%ecx
  802b0b:	89 d8                	mov    %ebx,%eax
  802b0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b11:	89 e9                	mov    %ebp,%ecx
  802b13:	d3 e7                	shl    %cl,%edi
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	d3 e8                	shr    %cl,%eax
  802b19:	89 e9                	mov    %ebp,%ecx
  802b1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b1f:	d3 e3                	shl    %cl,%ebx
  802b21:	89 c7                	mov    %eax,%edi
  802b23:	89 d1                	mov    %edx,%ecx
  802b25:	89 f0                	mov    %esi,%eax
  802b27:	d3 e8                	shr    %cl,%eax
  802b29:	89 e9                	mov    %ebp,%ecx
  802b2b:	89 fa                	mov    %edi,%edx
  802b2d:	d3 e6                	shl    %cl,%esi
  802b2f:	09 d8                	or     %ebx,%eax
  802b31:	f7 74 24 08          	divl   0x8(%esp)
  802b35:	89 d1                	mov    %edx,%ecx
  802b37:	89 f3                	mov    %esi,%ebx
  802b39:	f7 64 24 0c          	mull   0xc(%esp)
  802b3d:	89 c6                	mov    %eax,%esi
  802b3f:	89 d7                	mov    %edx,%edi
  802b41:	39 d1                	cmp    %edx,%ecx
  802b43:	72 06                	jb     802b4b <__umoddi3+0xfb>
  802b45:	75 10                	jne    802b57 <__umoddi3+0x107>
  802b47:	39 c3                	cmp    %eax,%ebx
  802b49:	73 0c                	jae    802b57 <__umoddi3+0x107>
  802b4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b53:	89 d7                	mov    %edx,%edi
  802b55:	89 c6                	mov    %eax,%esi
  802b57:	89 ca                	mov    %ecx,%edx
  802b59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b5e:	29 f3                	sub    %esi,%ebx
  802b60:	19 fa                	sbb    %edi,%edx
  802b62:	89 d0                	mov    %edx,%eax
  802b64:	d3 e0                	shl    %cl,%eax
  802b66:	89 e9                	mov    %ebp,%ecx
  802b68:	d3 eb                	shr    %cl,%ebx
  802b6a:	d3 ea                	shr    %cl,%edx
  802b6c:	09 d8                	or     %ebx,%eax
  802b6e:	83 c4 1c             	add    $0x1c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    
  802b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b7d:	8d 76 00             	lea    0x0(%esi),%esi
  802b80:	89 da                	mov    %ebx,%edx
  802b82:	29 fe                	sub    %edi,%esi
  802b84:	19 c2                	sbb    %eax,%edx
  802b86:	89 f1                	mov    %esi,%ecx
  802b88:	89 c8                	mov    %ecx,%eax
  802b8a:	e9 4b ff ff ff       	jmp    802ada <__umoddi3+0x8a>
