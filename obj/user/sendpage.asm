
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 73 01 00 00       	call   8001a4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 13 13 00 00       	call   801351 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 08 50 80 00       	mov    0x805008,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 a6 0d 00 00       	call   800e07 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 40 80 00    	pushl  0x804004
  80006a:	e8 6d 09 00 00       	call   8009dc <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 40 80 00    	pushl  0x804004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 7f 0b 00 00       	call   800c05 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 bb 15 00 00       	call   801652 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 3f 15 00 00       	call   8015e9 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 c0 2b 80 00       	push   $0x802bc0
  8000ba:	e8 f7 01 00 00       	call   8002b6 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 40 80 00    	pushl  0x804000
  8000c8:	e8 0f 09 00 00       	call   8009dc <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 40 80 00    	pushl  0x804000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 05 0a 00 00       	call   800ae6 <strncmp>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 84 a3 00 00 00    	je     80018f <umain+0x15c>
		cprintf("parent received correct message\n");
	return;
}
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	68 00 00 b0 00       	push   $0xb00000
  8000f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 e8 14 00 00       	call   8015e9 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 c0 2b 80 00       	push   $0x802bc0
  800111:	e8 a0 01 00 00       	call   8002b6 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 40 80 00    	pushl  0x804004
  80011f:	e8 b8 08 00 00       	call   8009dc <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 40 80 00    	pushl  0x804004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 ae 09 00 00       	call   800ae6 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 40 80 00    	pushl  0x804000
  800148:	e8 8f 08 00 00       	call   8009dc <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 40 80 00    	pushl  0x804000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 a1 0a 00 00       	call   800c05 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 dd 14 00 00       	call   801652 <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 d4 2b 80 00       	push   $0x802bd4
  800185:	e8 2c 01 00 00       	call   8002b6 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 f4 2b 80 00       	push   $0x802bf4
  800197:	e8 1a 01 00 00       	call   8002b6 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8001af:	e8 15 0c 00 00       	call   800dc9 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8001b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c4:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	85 db                	test   %ebx,%ebx
  8001cb:	7e 07                	jle    8001d4 <libmain+0x30>
		binaryname = argv[0];
  8001cd:	8b 06                	mov    (%esi),%eax
  8001cf:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	e8 55 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001de:	e8 0a 00 00 00       	call   8001ed <exit>
}
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f3:	a1 08 50 80 00       	mov    0x805008,%eax
  8001f8:	8b 40 48             	mov    0x48(%eax),%eax
  8001fb:	68 78 2c 80 00       	push   $0x802c78
  800200:	50                   	push   %eax
  800201:	68 6c 2c 80 00       	push   $0x802c6c
  800206:	e8 ab 00 00 00       	call   8002b6 <cprintf>
	close_all();
  80020b:	e8 b1 16 00 00       	call   8018c1 <close_all>
	sys_env_destroy(0);
  800210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800217:	e8 6c 0b 00 00       	call   800d88 <sys_env_destroy>
}
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	53                   	push   %ebx
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022b:	8b 13                	mov    (%ebx),%edx
  80022d:	8d 42 01             	lea    0x1(%edx),%eax
  800230:	89 03                	mov    %eax,(%ebx)
  800232:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800235:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800239:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023e:	74 09                	je     800249 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800240:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800247:	c9                   	leave  
  800248:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	68 ff 00 00 00       	push   $0xff
  800251:	8d 43 08             	lea    0x8(%ebx),%eax
  800254:	50                   	push   %eax
  800255:	e8 f1 0a 00 00       	call   800d4b <sys_cputs>
		b->idx = 0;
  80025a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	eb db                	jmp    800240 <putch+0x1f>

00800265 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800275:	00 00 00 
	b.cnt = 0;
  800278:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	68 21 02 80 00       	push   $0x800221
  800294:	e8 4a 01 00 00       	call   8003e3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800299:	83 c4 08             	add    $0x8,%esp
  80029c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a8:	50                   	push   %eax
  8002a9:	e8 9d 0a 00 00       	call   800d4b <sys_cputs>

	return b.cnt;
}
  8002ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bf:	50                   	push   %eax
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	e8 9d ff ff ff       	call   800265 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	57                   	push   %edi
  8002ce:	56                   	push   %esi
  8002cf:	53                   	push   %ebx
  8002d0:	83 ec 1c             	sub    $0x1c,%esp
  8002d3:	89 c6                	mov    %eax,%esi
  8002d5:	89 d7                	mov    %edx,%edi
  8002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002e9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ed:	74 2c                	je     80031b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ff:	39 c2                	cmp    %eax,%edx
  800301:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800304:	73 43                	jae    800349 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800306:	83 eb 01             	sub    $0x1,%ebx
  800309:	85 db                	test   %ebx,%ebx
  80030b:	7e 6c                	jle    800379 <printnum+0xaf>
				putch(padc, putdat);
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	57                   	push   %edi
  800311:	ff 75 18             	pushl  0x18(%ebp)
  800314:	ff d6                	call   *%esi
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb eb                	jmp    800306 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	6a 20                	push   $0x20
  800320:	6a 00                	push   $0x0
  800322:	50                   	push   %eax
  800323:	ff 75 e4             	pushl  -0x1c(%ebp)
  800326:	ff 75 e0             	pushl  -0x20(%ebp)
  800329:	89 fa                	mov    %edi,%edx
  80032b:	89 f0                	mov    %esi,%eax
  80032d:	e8 98 ff ff ff       	call   8002ca <printnum>
		while (--width > 0)
  800332:	83 c4 20             	add    $0x20,%esp
  800335:	83 eb 01             	sub    $0x1,%ebx
  800338:	85 db                	test   %ebx,%ebx
  80033a:	7e 65                	jle    8003a1 <printnum+0xd7>
			putch(padc, putdat);
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	57                   	push   %edi
  800340:	6a 20                	push   $0x20
  800342:	ff d6                	call   *%esi
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	eb ec                	jmp    800335 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 18             	pushl  0x18(%ebp)
  80034f:	83 eb 01             	sub    $0x1,%ebx
  800352:	53                   	push   %ebx
  800353:	50                   	push   %eax
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	ff 75 dc             	pushl  -0x24(%ebp)
  80035a:	ff 75 d8             	pushl  -0x28(%ebp)
  80035d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800360:	ff 75 e0             	pushl  -0x20(%ebp)
  800363:	e8 08 26 00 00       	call   802970 <__udivdi3>
  800368:	83 c4 18             	add    $0x18,%esp
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	89 fa                	mov    %edi,%edx
  80036f:	89 f0                	mov    %esi,%eax
  800371:	e8 54 ff ff ff       	call   8002ca <printnum>
  800376:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	57                   	push   %edi
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 dc             	pushl  -0x24(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 e4             	pushl  -0x1c(%ebp)
  800389:	ff 75 e0             	pushl  -0x20(%ebp)
  80038c:	e8 ef 26 00 00       	call   802a80 <__umoddi3>
  800391:	83 c4 14             	add    $0x14,%esp
  800394:	0f be 80 7d 2c 80 00 	movsbl 0x802c7d(%eax),%eax
  80039b:	50                   	push   %eax
  80039c:	ff d6                	call   *%esi
  80039e:	83 c4 10             	add    $0x10,%esp
	}
}
  8003a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a4:	5b                   	pop    %ebx
  8003a5:	5e                   	pop    %esi
  8003a6:	5f                   	pop    %edi
  8003a7:	5d                   	pop    %ebp
  8003a8:	c3                   	ret    

008003a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b3:	8b 10                	mov    (%eax),%edx
  8003b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b8:	73 0a                	jae    8003c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003bd:	89 08                	mov    %ecx,(%eax)
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	88 02                	mov    %al,(%edx)
}
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <printfmt>:
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003cf:	50                   	push   %eax
  8003d0:	ff 75 10             	pushl  0x10(%ebp)
  8003d3:	ff 75 0c             	pushl  0xc(%ebp)
  8003d6:	ff 75 08             	pushl  0x8(%ebp)
  8003d9:	e8 05 00 00 00       	call   8003e3 <vprintfmt>
}
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <vprintfmt>:
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	57                   	push   %edi
  8003e7:	56                   	push   %esi
  8003e8:	53                   	push   %ebx
  8003e9:	83 ec 3c             	sub    $0x3c,%esp
  8003ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003f2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f5:	e9 32 04 00 00       	jmp    80082c <vprintfmt+0x449>
		padc = ' ';
  8003fa:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800405:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80040c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800413:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80041a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800421:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8d 47 01             	lea    0x1(%edi),%eax
  800429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042c:	0f b6 17             	movzbl (%edi),%edx
  80042f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800432:	3c 55                	cmp    $0x55,%al
  800434:	0f 87 12 05 00 00    	ja     80094c <vprintfmt+0x569>
  80043a:	0f b6 c0             	movzbl %al,%eax
  80043d:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
  800444:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800447:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80044b:	eb d9                	jmp    800426 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800450:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800454:	eb d0                	jmp    800426 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800456:	0f b6 d2             	movzbl %dl,%edx
  800459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	89 75 08             	mov    %esi,0x8(%ebp)
  800464:	eb 03                	jmp    800469 <vprintfmt+0x86>
  800466:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800469:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800470:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800473:	8d 72 d0             	lea    -0x30(%edx),%esi
  800476:	83 fe 09             	cmp    $0x9,%esi
  800479:	76 eb                	jbe    800466 <vprintfmt+0x83>
  80047b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047e:	8b 75 08             	mov    0x8(%ebp),%esi
  800481:	eb 14                	jmp    800497 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8d 40 04             	lea    0x4(%eax),%eax
  800491:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	79 89                	jns    800426 <vprintfmt+0x43>
				width = precision, precision = -1;
  80049d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004aa:	e9 77 ff ff ff       	jmp    800426 <vprintfmt+0x43>
  8004af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	0f 48 c1             	cmovs  %ecx,%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004bd:	e9 64 ff ff ff       	jmp    800426 <vprintfmt+0x43>
  8004c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004cc:	e9 55 ff ff ff       	jmp    800426 <vprintfmt+0x43>
			lflag++;
  8004d1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004d8:	e9 49 ff ff ff       	jmp    800426 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 78 04             	lea    0x4(%eax),%edi
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	ff 30                	pushl  (%eax)
  8004e9:	ff d6                	call   *%esi
			break;
  8004eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ee:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f1:	e9 33 03 00 00       	jmp    800829 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 78 04             	lea    0x4(%eax),%edi
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	99                   	cltd   
  8004ff:	31 d0                	xor    %edx,%eax
  800501:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800503:	83 f8 11             	cmp    $0x11,%eax
  800506:	7f 23                	jg     80052b <vprintfmt+0x148>
  800508:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  80050f:	85 d2                	test   %edx,%edx
  800511:	74 18                	je     80052b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800513:	52                   	push   %edx
  800514:	68 ed 31 80 00       	push   $0x8031ed
  800519:	53                   	push   %ebx
  80051a:	56                   	push   %esi
  80051b:	e8 a6 fe ff ff       	call   8003c6 <printfmt>
  800520:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
  800526:	e9 fe 02 00 00       	jmp    800829 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80052b:	50                   	push   %eax
  80052c:	68 95 2c 80 00       	push   $0x802c95
  800531:	53                   	push   %ebx
  800532:	56                   	push   %esi
  800533:	e8 8e fe ff ff       	call   8003c6 <printfmt>
  800538:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80053e:	e9 e6 02 00 00       	jmp    800829 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	83 c0 04             	add    $0x4,%eax
  800549:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800551:	85 c9                	test   %ecx,%ecx
  800553:	b8 8e 2c 80 00       	mov    $0x802c8e,%eax
  800558:	0f 45 c1             	cmovne %ecx,%eax
  80055b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80055e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800562:	7e 06                	jle    80056a <vprintfmt+0x187>
  800564:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800568:	75 0d                	jne    800577 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056d:	89 c7                	mov    %eax,%edi
  80056f:	03 45 e0             	add    -0x20(%ebp),%eax
  800572:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800575:	eb 53                	jmp    8005ca <vprintfmt+0x1e7>
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 d8             	pushl  -0x28(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 71 04 00 00       	call   8009f4 <strnlen>
  800583:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800586:	29 c1                	sub    %eax,%ecx
  800588:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800590:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800594:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800597:	eb 0f                	jmp    8005a8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	53                   	push   %ebx
  80059d:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a2:	83 ef 01             	sub    $0x1,%edi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	85 ff                	test   %edi,%edi
  8005aa:	7f ed                	jg     800599 <vprintfmt+0x1b6>
  8005ac:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005af:	85 c9                	test   %ecx,%ecx
  8005b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b6:	0f 49 c1             	cmovns %ecx,%eax
  8005b9:	29 c1                	sub    %eax,%ecx
  8005bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005be:	eb aa                	jmp    80056a <vprintfmt+0x187>
					putch(ch, putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	52                   	push   %edx
  8005c5:	ff d6                	call   *%esi
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005cd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005cf:	83 c7 01             	add    $0x1,%edi
  8005d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d6:	0f be d0             	movsbl %al,%edx
  8005d9:	85 d2                	test   %edx,%edx
  8005db:	74 4b                	je     800628 <vprintfmt+0x245>
  8005dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e1:	78 06                	js     8005e9 <vprintfmt+0x206>
  8005e3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e7:	78 1e                	js     800607 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ed:	74 d1                	je     8005c0 <vprintfmt+0x1dd>
  8005ef:	0f be c0             	movsbl %al,%eax
  8005f2:	83 e8 20             	sub    $0x20,%eax
  8005f5:	83 f8 5e             	cmp    $0x5e,%eax
  8005f8:	76 c6                	jbe    8005c0 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	6a 3f                	push   $0x3f
  800600:	ff d6                	call   *%esi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb c3                	jmp    8005ca <vprintfmt+0x1e7>
  800607:	89 cf                	mov    %ecx,%edi
  800609:	eb 0e                	jmp    800619 <vprintfmt+0x236>
				putch(' ', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 20                	push   $0x20
  800611:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800613:	83 ef 01             	sub    $0x1,%edi
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	85 ff                	test   %edi,%edi
  80061b:	7f ee                	jg     80060b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80061d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	e9 01 02 00 00       	jmp    800829 <vprintfmt+0x446>
  800628:	89 cf                	mov    %ecx,%edi
  80062a:	eb ed                	jmp    800619 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80062f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800636:	e9 eb fd ff ff       	jmp    800426 <vprintfmt+0x43>
	if (lflag >= 2)
  80063b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80063f:	7f 21                	jg     800662 <vprintfmt+0x27f>
	else if (lflag)
  800641:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800645:	74 68                	je     8006af <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064f:	89 c1                	mov    %eax,%ecx
  800651:	c1 f9 1f             	sar    $0x1f,%ecx
  800654:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 04             	lea    0x4(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	eb 17                	jmp    800679 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 08             	lea    0x8(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800679:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800685:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800689:	78 3f                	js     8006ca <vprintfmt+0x2e7>
			base = 10;
  80068b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800690:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800694:	0f 84 71 01 00 00    	je     80080b <vprintfmt+0x428>
				putch('+', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 2b                	push   $0x2b
  8006a0:	ff d6                	call   *%esi
  8006a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006aa:	e9 5c 01 00 00       	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b7:	89 c1                	mov    %eax,%ecx
  8006b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c8:	eb af                	jmp    800679 <vprintfmt+0x296>
				putch('-', putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	6a 2d                	push   $0x2d
  8006d0:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d8:	f7 d8                	neg    %eax
  8006da:	83 d2 00             	adc    $0x0,%edx
  8006dd:	f7 da                	neg    %edx
  8006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ed:	e9 19 01 00 00       	jmp    80080b <vprintfmt+0x428>
	if (lflag >= 2)
  8006f2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f6:	7f 29                	jg     800721 <vprintfmt+0x33e>
	else if (lflag)
  8006f8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fc:	74 44                	je     800742 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	ba 00 00 00 00       	mov    $0x0,%edx
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071c:	e9 ea 00 00 00       	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 50 04             	mov    0x4(%eax),%edx
  800727:	8b 00                	mov    (%eax),%eax
  800729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 40 08             	lea    0x8(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800738:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073d:	e9 c9 00 00 00       	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800760:	e9 a6 00 00 00       	jmp    80080b <vprintfmt+0x428>
			putch('0', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 30                	push   $0x30
  80076b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800774:	7f 26                	jg     80079c <vprintfmt+0x3b9>
	else if (lflag)
  800776:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077a:	74 3e                	je     8007ba <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	ba 00 00 00 00       	mov    $0x0,%edx
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800795:	b8 08 00 00 00       	mov    $0x8,%eax
  80079a:	eb 6f                	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 50 04             	mov    0x4(%eax),%edx
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 08             	lea    0x8(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b8:	eb 51                	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d8:	eb 31                	jmp    80080b <vprintfmt+0x428>
			putch('0', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	53                   	push   %ebx
  8007de:	6a 30                	push   $0x30
  8007e0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007e2:	83 c4 08             	add    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 78                	push   $0x78
  8007e8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007fa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80080b:	83 ec 0c             	sub    $0xc,%esp
  80080e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800812:	52                   	push   %edx
  800813:	ff 75 e0             	pushl  -0x20(%ebp)
  800816:	50                   	push   %eax
  800817:	ff 75 dc             	pushl  -0x24(%ebp)
  80081a:	ff 75 d8             	pushl  -0x28(%ebp)
  80081d:	89 da                	mov    %ebx,%edx
  80081f:	89 f0                	mov    %esi,%eax
  800821:	e8 a4 fa ff ff       	call   8002ca <printnum>
			break;
  800826:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800829:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082c:	83 c7 01             	add    $0x1,%edi
  80082f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800833:	83 f8 25             	cmp    $0x25,%eax
  800836:	0f 84 be fb ff ff    	je     8003fa <vprintfmt+0x17>
			if (ch == '\0')
  80083c:	85 c0                	test   %eax,%eax
  80083e:	0f 84 28 01 00 00    	je     80096c <vprintfmt+0x589>
			putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	53                   	push   %ebx
  800848:	50                   	push   %eax
  800849:	ff d6                	call   *%esi
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	eb dc                	jmp    80082c <vprintfmt+0x449>
	if (lflag >= 2)
  800850:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800854:	7f 26                	jg     80087c <vprintfmt+0x499>
	else if (lflag)
  800856:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80085a:	74 41                	je     80089d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800869:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800875:	b8 10 00 00 00       	mov    $0x10,%eax
  80087a:	eb 8f                	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8d 40 08             	lea    0x8(%eax),%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800893:	b8 10 00 00 00       	mov    $0x10,%eax
  800898:	e9 6e ff ff ff       	jmp    80080b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008bb:	e9 4b ff ff ff       	jmp    80080b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	83 c0 04             	add    $0x4,%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	74 14                	je     8008e6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008d2:	8b 13                	mov    (%ebx),%edx
  8008d4:	83 fa 7f             	cmp    $0x7f,%edx
  8008d7:	7f 37                	jg     800910 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008d9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e1:	e9 43 ff ff ff       	jmp    800829 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008eb:	bf b1 2d 80 00       	mov    $0x802db1,%edi
							putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	53                   	push   %ebx
  8008f4:	50                   	push   %eax
  8008f5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f7:	83 c7 01             	add    $0x1,%edi
  8008fa:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	85 c0                	test   %eax,%eax
  800903:	75 eb                	jne    8008f0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800905:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
  80090b:	e9 19 ff ff ff       	jmp    800829 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800910:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800912:	b8 0a 00 00 00       	mov    $0xa,%eax
  800917:	bf e9 2d 80 00       	mov    $0x802de9,%edi
							putch(ch, putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	53                   	push   %ebx
  800920:	50                   	push   %eax
  800921:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800923:	83 c7 01             	add    $0x1,%edi
  800926:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	85 c0                	test   %eax,%eax
  80092f:	75 eb                	jne    80091c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800931:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800934:	89 45 14             	mov    %eax,0x14(%ebp)
  800937:	e9 ed fe ff ff       	jmp    800829 <vprintfmt+0x446>
			putch(ch, putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	53                   	push   %ebx
  800940:	6a 25                	push   $0x25
  800942:	ff d6                	call   *%esi
			break;
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	e9 dd fe ff ff       	jmp    800829 <vprintfmt+0x446>
			putch('%', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 25                	push   $0x25
  800952:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	89 f8                	mov    %edi,%eax
  800959:	eb 03                	jmp    80095e <vprintfmt+0x57b>
  80095b:	83 e8 01             	sub    $0x1,%eax
  80095e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800962:	75 f7                	jne    80095b <vprintfmt+0x578>
  800964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800967:	e9 bd fe ff ff       	jmp    800829 <vprintfmt+0x446>
}
  80096c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5f                   	pop    %edi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 18             	sub    $0x18,%esp
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800983:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800987:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800991:	85 c0                	test   %eax,%eax
  800993:	74 26                	je     8009bb <vsnprintf+0x47>
  800995:	85 d2                	test   %edx,%edx
  800997:	7e 22                	jle    8009bb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800999:	ff 75 14             	pushl  0x14(%ebp)
  80099c:	ff 75 10             	pushl  0x10(%ebp)
  80099f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	68 a9 03 80 00       	push   $0x8003a9
  8009a8:	e8 36 fa ff ff       	call   8003e3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
}
  8009b9:	c9                   	leave  
  8009ba:	c3                   	ret    
		return -E_INVAL;
  8009bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c0:	eb f7                	jmp    8009b9 <vsnprintf+0x45>

008009c2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009cb:	50                   	push   %eax
  8009cc:	ff 75 10             	pushl  0x10(%ebp)
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 9a ff ff ff       	call   800974 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009eb:	74 05                	je     8009f2 <strlen+0x16>
		n++;
  8009ed:	83 c0 01             	add    $0x1,%eax
  8009f0:	eb f5                	jmp    8009e7 <strlen+0xb>
	return n;
}
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800a02:	39 c2                	cmp    %eax,%edx
  800a04:	74 0d                	je     800a13 <strnlen+0x1f>
  800a06:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a0a:	74 05                	je     800a11 <strnlen+0x1d>
		n++;
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	eb f1                	jmp    800a02 <strnlen+0xe>
  800a11:	89 d0                	mov    %edx,%eax
	return n;
}
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	53                   	push   %ebx
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a24:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a28:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	84 c9                	test   %cl,%cl
  800a30:	75 f2                	jne    800a24 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a32:	5b                   	pop    %ebx
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	53                   	push   %ebx
  800a39:	83 ec 10             	sub    $0x10,%esp
  800a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a3f:	53                   	push   %ebx
  800a40:	e8 97 ff ff ff       	call   8009dc <strlen>
  800a45:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	01 d8                	add    %ebx,%eax
  800a4d:	50                   	push   %eax
  800a4e:	e8 c2 ff ff ff       	call   800a15 <strcpy>
	return dst;
}
  800a53:	89 d8                	mov    %ebx,%eax
  800a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	56                   	push   %esi
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a65:	89 c6                	mov    %eax,%esi
  800a67:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	39 f2                	cmp    %esi,%edx
  800a6e:	74 11                	je     800a81 <strncpy+0x27>
		*dst++ = *src;
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	0f b6 19             	movzbl (%ecx),%ebx
  800a76:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a79:	80 fb 01             	cmp    $0x1,%bl
  800a7c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a7f:	eb eb                	jmp    800a6c <strncpy+0x12>
	}
	return ret;
}
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a90:	8b 55 10             	mov    0x10(%ebp),%edx
  800a93:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a95:	85 d2                	test   %edx,%edx
  800a97:	74 21                	je     800aba <strlcpy+0x35>
  800a99:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a9d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a9f:	39 c2                	cmp    %eax,%edx
  800aa1:	74 14                	je     800ab7 <strlcpy+0x32>
  800aa3:	0f b6 19             	movzbl (%ecx),%ebx
  800aa6:	84 db                	test   %bl,%bl
  800aa8:	74 0b                	je     800ab5 <strlcpy+0x30>
			*dst++ = *src++;
  800aaa:	83 c1 01             	add    $0x1,%ecx
  800aad:	83 c2 01             	add    $0x1,%edx
  800ab0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab3:	eb ea                	jmp    800a9f <strlcpy+0x1a>
  800ab5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aba:	29 f0                	sub    %esi,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac9:	0f b6 01             	movzbl (%ecx),%eax
  800acc:	84 c0                	test   %al,%al
  800ace:	74 0c                	je     800adc <strcmp+0x1c>
  800ad0:	3a 02                	cmp    (%edx),%al
  800ad2:	75 08                	jne    800adc <strcmp+0x1c>
		p++, q++;
  800ad4:	83 c1 01             	add    $0x1,%ecx
  800ad7:	83 c2 01             	add    $0x1,%edx
  800ada:	eb ed                	jmp    800ac9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800adc:	0f b6 c0             	movzbl %al,%eax
  800adf:	0f b6 12             	movzbl (%edx),%edx
  800ae2:	29 d0                	sub    %edx,%eax
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	53                   	push   %ebx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af0:	89 c3                	mov    %eax,%ebx
  800af2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af5:	eb 06                	jmp    800afd <strncmp+0x17>
		n--, p++, q++;
  800af7:	83 c0 01             	add    $0x1,%eax
  800afa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afd:	39 d8                	cmp    %ebx,%eax
  800aff:	74 16                	je     800b17 <strncmp+0x31>
  800b01:	0f b6 08             	movzbl (%eax),%ecx
  800b04:	84 c9                	test   %cl,%cl
  800b06:	74 04                	je     800b0c <strncmp+0x26>
  800b08:	3a 0a                	cmp    (%edx),%cl
  800b0a:	74 eb                	je     800af7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	0f b6 00             	movzbl (%eax),%eax
  800b0f:	0f b6 12             	movzbl (%edx),%edx
  800b12:	29 d0                	sub    %edx,%eax
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    
		return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1c:	eb f6                	jmp    800b14 <strncmp+0x2e>

00800b1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b28:	0f b6 10             	movzbl (%eax),%edx
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	74 09                	je     800b38 <strchr+0x1a>
		if (*s == c)
  800b2f:	38 ca                	cmp    %cl,%dl
  800b31:	74 0a                	je     800b3d <strchr+0x1f>
	for (; *s; s++)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	eb f0                	jmp    800b28 <strchr+0xa>
			return (char *) s;
	return 0;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b49:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b4c:	38 ca                	cmp    %cl,%dl
  800b4e:	74 09                	je     800b59 <strfind+0x1a>
  800b50:	84 d2                	test   %dl,%dl
  800b52:	74 05                	je     800b59 <strfind+0x1a>
	for (; *s; s++)
  800b54:	83 c0 01             	add    $0x1,%eax
  800b57:	eb f0                	jmp    800b49 <strfind+0xa>
			break;
	return (char *) s;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b67:	85 c9                	test   %ecx,%ecx
  800b69:	74 31                	je     800b9c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6b:	89 f8                	mov    %edi,%eax
  800b6d:	09 c8                	or     %ecx,%eax
  800b6f:	a8 03                	test   $0x3,%al
  800b71:	75 23                	jne    800b96 <memset+0x3b>
		c &= 0xFF;
  800b73:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b77:	89 d3                	mov    %edx,%ebx
  800b79:	c1 e3 08             	shl    $0x8,%ebx
  800b7c:	89 d0                	mov    %edx,%eax
  800b7e:	c1 e0 18             	shl    $0x18,%eax
  800b81:	89 d6                	mov    %edx,%esi
  800b83:	c1 e6 10             	shl    $0x10,%esi
  800b86:	09 f0                	or     %esi,%eax
  800b88:	09 c2                	or     %eax,%edx
  800b8a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b8c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b8f:	89 d0                	mov    %edx,%eax
  800b91:	fc                   	cld    
  800b92:	f3 ab                	rep stos %eax,%es:(%edi)
  800b94:	eb 06                	jmp    800b9c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	fc                   	cld    
  800b9a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9c:	89 f8                	mov    %edi,%eax
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb1:	39 c6                	cmp    %eax,%esi
  800bb3:	73 32                	jae    800be7 <memmove+0x44>
  800bb5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	76 2b                	jbe    800be7 <memmove+0x44>
		s += n;
		d += n;
  800bbc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbf:	89 fe                	mov    %edi,%esi
  800bc1:	09 ce                	or     %ecx,%esi
  800bc3:	09 d6                	or     %edx,%esi
  800bc5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bcb:	75 0e                	jne    800bdb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bcd:	83 ef 04             	sub    $0x4,%edi
  800bd0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bd6:	fd                   	std    
  800bd7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd9:	eb 09                	jmp    800be4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdb:	83 ef 01             	sub    $0x1,%edi
  800bde:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be1:	fd                   	std    
  800be2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be4:	fc                   	cld    
  800be5:	eb 1a                	jmp    800c01 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be7:	89 c2                	mov    %eax,%edx
  800be9:	09 ca                	or     %ecx,%edx
  800beb:	09 f2                	or     %esi,%edx
  800bed:	f6 c2 03             	test   $0x3,%dl
  800bf0:	75 0a                	jne    800bfc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf5:	89 c7                	mov    %eax,%edi
  800bf7:	fc                   	cld    
  800bf8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfa:	eb 05                	jmp    800c01 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bfc:	89 c7                	mov    %eax,%edi
  800bfe:	fc                   	cld    
  800bff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0b:	ff 75 10             	pushl  0x10(%ebp)
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	ff 75 08             	pushl  0x8(%ebp)
  800c14:	e8 8a ff ff ff       	call   800ba3 <memmove>
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c26:	89 c6                	mov    %eax,%esi
  800c28:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2b:	39 f0                	cmp    %esi,%eax
  800c2d:	74 1c                	je     800c4b <memcmp+0x30>
		if (*s1 != *s2)
  800c2f:	0f b6 08             	movzbl (%eax),%ecx
  800c32:	0f b6 1a             	movzbl (%edx),%ebx
  800c35:	38 d9                	cmp    %bl,%cl
  800c37:	75 08                	jne    800c41 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c39:	83 c0 01             	add    $0x1,%eax
  800c3c:	83 c2 01             	add    $0x1,%edx
  800c3f:	eb ea                	jmp    800c2b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c41:	0f b6 c1             	movzbl %cl,%eax
  800c44:	0f b6 db             	movzbl %bl,%ebx
  800c47:	29 d8                	sub    %ebx,%eax
  800c49:	eb 05                	jmp    800c50 <memcmp+0x35>
	}

	return 0;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5d:	89 c2                	mov    %eax,%edx
  800c5f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c62:	39 d0                	cmp    %edx,%eax
  800c64:	73 09                	jae    800c6f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c66:	38 08                	cmp    %cl,(%eax)
  800c68:	74 05                	je     800c6f <memfind+0x1b>
	for (; s < ends; s++)
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	eb f3                	jmp    800c62 <memfind+0xe>
			break;
	return (void *) s;
}
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7d:	eb 03                	jmp    800c82 <strtol+0x11>
		s++;
  800c7f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c82:	0f b6 01             	movzbl (%ecx),%eax
  800c85:	3c 20                	cmp    $0x20,%al
  800c87:	74 f6                	je     800c7f <strtol+0xe>
  800c89:	3c 09                	cmp    $0x9,%al
  800c8b:	74 f2                	je     800c7f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c8d:	3c 2b                	cmp    $0x2b,%al
  800c8f:	74 2a                	je     800cbb <strtol+0x4a>
	int neg = 0;
  800c91:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c96:	3c 2d                	cmp    $0x2d,%al
  800c98:	74 2b                	je     800cc5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ca0:	75 0f                	jne    800cb1 <strtol+0x40>
  800ca2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca5:	74 28                	je     800ccf <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cae:	0f 44 d8             	cmove  %eax,%ebx
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb9:	eb 50                	jmp    800d0b <strtol+0x9a>
		s++;
  800cbb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbe:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc3:	eb d5                	jmp    800c9a <strtol+0x29>
		s++, neg = 1;
  800cc5:	83 c1 01             	add    $0x1,%ecx
  800cc8:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccd:	eb cb                	jmp    800c9a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd3:	74 0e                	je     800ce3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd5:	85 db                	test   %ebx,%ebx
  800cd7:	75 d8                	jne    800cb1 <strtol+0x40>
		s++, base = 8;
  800cd9:	83 c1 01             	add    $0x1,%ecx
  800cdc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce1:	eb ce                	jmp    800cb1 <strtol+0x40>
		s += 2, base = 16;
  800ce3:	83 c1 02             	add    $0x2,%ecx
  800ce6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ceb:	eb c4                	jmp    800cb1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ced:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cf0:	89 f3                	mov    %esi,%ebx
  800cf2:	80 fb 19             	cmp    $0x19,%bl
  800cf5:	77 29                	ja     800d20 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf7:	0f be d2             	movsbl %dl,%edx
  800cfa:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d00:	7d 30                	jge    800d32 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d02:	83 c1 01             	add    $0x1,%ecx
  800d05:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d09:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0b:	0f b6 11             	movzbl (%ecx),%edx
  800d0e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d11:	89 f3                	mov    %esi,%ebx
  800d13:	80 fb 09             	cmp    $0x9,%bl
  800d16:	77 d5                	ja     800ced <strtol+0x7c>
			dig = *s - '0';
  800d18:	0f be d2             	movsbl %dl,%edx
  800d1b:	83 ea 30             	sub    $0x30,%edx
  800d1e:	eb dd                	jmp    800cfd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d20:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d23:	89 f3                	mov    %esi,%ebx
  800d25:	80 fb 19             	cmp    $0x19,%bl
  800d28:	77 08                	ja     800d32 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d2a:	0f be d2             	movsbl %dl,%edx
  800d2d:	83 ea 37             	sub    $0x37,%edx
  800d30:	eb cb                	jmp    800cfd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d36:	74 05                	je     800d3d <strtol+0xcc>
		*endptr = (char *) s;
  800d38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3d:	89 c2                	mov    %eax,%edx
  800d3f:	f7 da                	neg    %edx
  800d41:	85 ff                	test   %edi,%edi
  800d43:	0f 45 c2             	cmovne %edx,%eax
}
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	89 c3                	mov    %eax,%ebx
  800d5e:	89 c7                	mov    %eax,%edi
  800d60:	89 c6                	mov    %eax,%esi
  800d62:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	b8 01 00 00 00       	mov    $0x1,%eax
  800d79:	89 d1                	mov    %edx,%ecx
  800d7b:	89 d3                	mov    %edx,%ebx
  800d7d:	89 d7                	mov    %edx,%edi
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9e:	89 cb                	mov    %ecx,%ebx
  800da0:	89 cf                	mov    %ecx,%edi
  800da2:	89 ce                	mov    %ecx,%esi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 03                	push   $0x3
  800db8:	68 08 30 80 00       	push   $0x803008
  800dbd:	6a 43                	push   $0x43
  800dbf:	68 25 30 80 00       	push   $0x803025
  800dc4:	e8 76 1a 00 00       	call   80283f <_panic>

00800dc9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd4:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd9:	89 d1                	mov    %edx,%ecx
  800ddb:	89 d3                	mov    %edx,%ebx
  800ddd:	89 d7                	mov    %edx,%edi
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_yield>:

void
sys_yield(void)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dee:	ba 00 00 00 00       	mov    $0x0,%edx
  800df3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df8:	89 d1                	mov    %edx,%ecx
  800dfa:	89 d3                	mov    %edx,%ebx
  800dfc:	89 d7                	mov    %edx,%edi
  800dfe:	89 d6                	mov    %edx,%esi
  800e00:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e10:	be 00 00 00 00       	mov    $0x0,%esi
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e20:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e23:	89 f7                	mov    %esi,%edi
  800e25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7f 08                	jg     800e33 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	50                   	push   %eax
  800e37:	6a 04                	push   $0x4
  800e39:	68 08 30 80 00       	push   $0x803008
  800e3e:	6a 43                	push   $0x43
  800e40:	68 25 30 80 00       	push   $0x803025
  800e45:	e8 f5 19 00 00       	call   80283f <_panic>

00800e4a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e64:	8b 75 18             	mov    0x18(%ebp),%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 05                	push   $0x5
  800e7b:	68 08 30 80 00       	push   $0x803008
  800e80:	6a 43                	push   $0x43
  800e82:	68 25 30 80 00       	push   $0x803025
  800e87:	e8 b3 19 00 00       	call   80283f <_panic>

00800e8c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 06                	push   $0x6
  800ebd:	68 08 30 80 00       	push   $0x803008
  800ec2:	6a 43                	push   $0x43
  800ec4:	68 25 30 80 00       	push   $0x803025
  800ec9:	e8 71 19 00 00       	call   80283f <_panic>

00800ece <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee7:	89 df                	mov    %ebx,%edi
  800ee9:	89 de                	mov    %ebx,%esi
  800eeb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	7f 08                	jg     800ef9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	83 ec 0c             	sub    $0xc,%esp
  800efc:	50                   	push   %eax
  800efd:	6a 08                	push   $0x8
  800eff:	68 08 30 80 00       	push   $0x803008
  800f04:	6a 43                	push   $0x43
  800f06:	68 25 30 80 00       	push   $0x803025
  800f0b:	e8 2f 19 00 00       	call   80283f <_panic>

00800f10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 09 00 00 00       	mov    $0x9,%eax
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7f 08                	jg     800f3b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	83 ec 0c             	sub    $0xc,%esp
  800f3e:	50                   	push   %eax
  800f3f:	6a 09                	push   $0x9
  800f41:	68 08 30 80 00       	push   $0x803008
  800f46:	6a 43                	push   $0x43
  800f48:	68 25 30 80 00       	push   $0x803025
  800f4d:	e8 ed 18 00 00       	call   80283f <_panic>

00800f52 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6b:	89 df                	mov    %ebx,%edi
  800f6d:	89 de                	mov    %ebx,%esi
  800f6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	7f 08                	jg     800f7d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	83 ec 0c             	sub    $0xc,%esp
  800f80:	50                   	push   %eax
  800f81:	6a 0a                	push   $0xa
  800f83:	68 08 30 80 00       	push   $0x803008
  800f88:	6a 43                	push   $0x43
  800f8a:	68 25 30 80 00       	push   $0x803025
  800f8f:	e8 ab 18 00 00       	call   80283f <_panic>

00800f94 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa5:	be 00 00 00 00       	mov    $0x0,%esi
  800faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fad:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fb0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fcd:	89 cb                	mov    %ecx,%ebx
  800fcf:	89 cf                	mov    %ecx,%edi
  800fd1:	89 ce                	mov    %ecx,%esi
  800fd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	7f 08                	jg     800fe1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	50                   	push   %eax
  800fe5:	6a 0d                	push   $0xd
  800fe7:	68 08 30 80 00       	push   $0x803008
  800fec:	6a 43                	push   $0x43
  800fee:	68 25 30 80 00       	push   $0x803025
  800ff3:	e8 47 18 00 00       	call   80283f <_panic>

00800ff8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100e:	89 df                	mov    %ebx,%edi
  801010:	89 de                	mov    %ebx,%esi
  801012:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102c:	89 cb                	mov    %ecx,%ebx
  80102e:	89 cf                	mov    %ecx,%edi
  801030:	89 ce                	mov    %ecx,%esi
  801032:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103f:	ba 00 00 00 00       	mov    $0x0,%edx
  801044:	b8 10 00 00 00       	mov    $0x10,%eax
  801049:	89 d1                	mov    %edx,%ecx
  80104b:	89 d3                	mov    %edx,%ebx
  80104d:	89 d7                	mov    %edx,%edi
  80104f:	89 d6                	mov    %edx,%esi
  801051:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801053:	5b                   	pop    %ebx
  801054:	5e                   	pop    %esi
  801055:	5f                   	pop    %edi
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	b8 11 00 00 00       	mov    $0x11,%eax
  80106e:	89 df                	mov    %ebx,%edi
  801070:	89 de                	mov    %ebx,%esi
  801072:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    

00801079 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108a:	b8 12 00 00 00       	mov    $0x12,%eax
  80108f:	89 df                	mov    %ebx,%edi
  801091:	89 de                	mov    %ebx,%esi
  801093:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	b8 13 00 00 00       	mov    $0x13,%eax
  8010b3:	89 df                	mov    %ebx,%edi
  8010b5:	89 de                	mov    %ebx,%esi
  8010b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7f 08                	jg     8010c5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	50                   	push   %eax
  8010c9:	6a 13                	push   $0x13
  8010cb:	68 08 30 80 00       	push   $0x803008
  8010d0:	6a 43                	push   $0x43
  8010d2:	68 25 30 80 00       	push   $0x803025
  8010d7:	e8 63 17 00 00       	call   80283f <_panic>

008010dc <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	b8 14 00 00 00       	mov    $0x14,%eax
  8010ef:	89 cb                	mov    %ecx,%ebx
  8010f1:	89 cf                	mov    %ecx,%edi
  8010f3:	89 ce                	mov    %ecx,%esi
  8010f5:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	53                   	push   %ebx
  801100:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801103:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80110a:	f6 c5 04             	test   $0x4,%ch
  80110d:	75 45                	jne    801154 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80110f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801116:	83 e1 07             	and    $0x7,%ecx
  801119:	83 f9 07             	cmp    $0x7,%ecx
  80111c:	74 6f                	je     80118d <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80111e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801125:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80112b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801131:	0f 84 b6 00 00 00    	je     8011ed <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801137:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80113e:	83 e1 05             	and    $0x5,%ecx
  801141:	83 f9 05             	cmp    $0x5,%ecx
  801144:	0f 84 d7 00 00 00    	je     801221 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80114a:	b8 00 00 00 00       	mov    $0x0,%eax
  80114f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801152:	c9                   	leave  
  801153:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801154:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115b:	c1 e2 0c             	shl    $0xc,%edx
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801167:	51                   	push   %ecx
  801168:	52                   	push   %edx
  801169:	50                   	push   %eax
  80116a:	52                   	push   %edx
  80116b:	6a 00                	push   $0x0
  80116d:	e8 d8 fc ff ff       	call   800e4a <sys_page_map>
		if(r < 0)
  801172:	83 c4 20             	add    $0x20,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	79 d1                	jns    80114a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	68 33 30 80 00       	push   $0x803033
  801181:	6a 54                	push   $0x54
  801183:	68 49 30 80 00       	push   $0x803049
  801188:	e8 b2 16 00 00       	call   80283f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80118d:	89 d3                	mov    %edx,%ebx
  80118f:	c1 e3 0c             	shl    $0xc,%ebx
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	68 05 08 00 00       	push   $0x805
  80119a:	53                   	push   %ebx
  80119b:	50                   	push   %eax
  80119c:	53                   	push   %ebx
  80119d:	6a 00                	push   $0x0
  80119f:	e8 a6 fc ff ff       	call   800e4a <sys_page_map>
		if(r < 0)
  8011a4:	83 c4 20             	add    $0x20,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 2e                	js     8011d9 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	68 05 08 00 00       	push   $0x805
  8011b3:	53                   	push   %ebx
  8011b4:	6a 00                	push   $0x0
  8011b6:	53                   	push   %ebx
  8011b7:	6a 00                	push   $0x0
  8011b9:	e8 8c fc ff ff       	call   800e4a <sys_page_map>
		if(r < 0)
  8011be:	83 c4 20             	add    $0x20,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	79 85                	jns    80114a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	68 33 30 80 00       	push   $0x803033
  8011cd:	6a 5f                	push   $0x5f
  8011cf:	68 49 30 80 00       	push   $0x803049
  8011d4:	e8 66 16 00 00       	call   80283f <_panic>
			panic("sys_page_map() panic\n");
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	68 33 30 80 00       	push   $0x803033
  8011e1:	6a 5b                	push   $0x5b
  8011e3:	68 49 30 80 00       	push   $0x803049
  8011e8:	e8 52 16 00 00       	call   80283f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ed:	c1 e2 0c             	shl    $0xc,%edx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	68 05 08 00 00       	push   $0x805
  8011f8:	52                   	push   %edx
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 48 fc ff ff       	call   800e4a <sys_page_map>
		if(r < 0)
  801202:	83 c4 20             	add    $0x20,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	0f 89 3d ff ff ff    	jns    80114a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	68 33 30 80 00       	push   $0x803033
  801215:	6a 66                	push   $0x66
  801217:	68 49 30 80 00       	push   $0x803049
  80121c:	e8 1e 16 00 00       	call   80283f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801221:	c1 e2 0c             	shl    $0xc,%edx
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	6a 05                	push   $0x5
  801229:	52                   	push   %edx
  80122a:	50                   	push   %eax
  80122b:	52                   	push   %edx
  80122c:	6a 00                	push   $0x0
  80122e:	e8 17 fc ff ff       	call   800e4a <sys_page_map>
		if(r < 0)
  801233:	83 c4 20             	add    $0x20,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	0f 89 0c ff ff ff    	jns    80114a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	68 33 30 80 00       	push   $0x803033
  801246:	6a 6d                	push   $0x6d
  801248:	68 49 30 80 00       	push   $0x803049
  80124d:	e8 ed 15 00 00       	call   80283f <_panic>

00801252 <pgfault>:
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	53                   	push   %ebx
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80125c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80125e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801262:	0f 84 99 00 00 00    	je     801301 <pgfault+0xaf>
  801268:	89 c2                	mov    %eax,%edx
  80126a:	c1 ea 16             	shr    $0x16,%edx
  80126d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801274:	f6 c2 01             	test   $0x1,%dl
  801277:	0f 84 84 00 00 00    	je     801301 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80127d:	89 c2                	mov    %eax,%edx
  80127f:	c1 ea 0c             	shr    $0xc,%edx
  801282:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801289:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80128f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801295:	75 6a                	jne    801301 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801297:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80129c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80129e:	83 ec 04             	sub    $0x4,%esp
  8012a1:	6a 07                	push   $0x7
  8012a3:	68 00 f0 7f 00       	push   $0x7ff000
  8012a8:	6a 00                	push   $0x0
  8012aa:	e8 58 fb ff ff       	call   800e07 <sys_page_alloc>
	if(ret < 0)
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 5f                	js     801315 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	68 00 10 00 00       	push   $0x1000
  8012be:	53                   	push   %ebx
  8012bf:	68 00 f0 7f 00       	push   $0x7ff000
  8012c4:	e8 3c f9 ff ff       	call   800c05 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012c9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012d0:	53                   	push   %ebx
  8012d1:	6a 00                	push   $0x0
  8012d3:	68 00 f0 7f 00       	push   $0x7ff000
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 6b fb ff ff       	call   800e4a <sys_page_map>
	if(ret < 0)
  8012df:	83 c4 20             	add    $0x20,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	78 43                	js     801329 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012e6:	83 ec 08             	sub    $0x8,%esp
  8012e9:	68 00 f0 7f 00       	push   $0x7ff000
  8012ee:	6a 00                	push   $0x0
  8012f0:	e8 97 fb ff ff       	call   800e8c <sys_page_unmap>
	if(ret < 0)
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 41                	js     80133d <pgfault+0xeb>
}
  8012fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    
		panic("panic at pgfault()\n");
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	68 54 30 80 00       	push   $0x803054
  801309:	6a 26                	push   $0x26
  80130b:	68 49 30 80 00       	push   $0x803049
  801310:	e8 2a 15 00 00       	call   80283f <_panic>
		panic("panic in sys_page_alloc()\n");
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 68 30 80 00       	push   $0x803068
  80131d:	6a 31                	push   $0x31
  80131f:	68 49 30 80 00       	push   $0x803049
  801324:	e8 16 15 00 00       	call   80283f <_panic>
		panic("panic in sys_page_map()\n");
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	68 83 30 80 00       	push   $0x803083
  801331:	6a 36                	push   $0x36
  801333:	68 49 30 80 00       	push   $0x803049
  801338:	e8 02 15 00 00       	call   80283f <_panic>
		panic("panic in sys_page_unmap()\n");
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	68 9c 30 80 00       	push   $0x80309c
  801345:	6a 39                	push   $0x39
  801347:	68 49 30 80 00       	push   $0x803049
  80134c:	e8 ee 14 00 00       	call   80283f <_panic>

00801351 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	57                   	push   %edi
  801355:	56                   	push   %esi
  801356:	53                   	push   %ebx
  801357:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80135a:	68 52 12 80 00       	push   $0x801252
  80135f:	e8 3c 15 00 00       	call   8028a0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801364:	b8 07 00 00 00       	mov    $0x7,%eax
  801369:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 2a                	js     80139c <fork+0x4b>
  801372:	89 c6                	mov    %eax,%esi
  801374:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801376:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80137b:	75 4b                	jne    8013c8 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80137d:	e8 47 fa ff ff       	call   800dc9 <sys_getenvid>
  801382:	25 ff 03 00 00       	and    $0x3ff,%eax
  801387:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80138d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801392:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801397:	e9 90 00 00 00       	jmp    80142c <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 b8 30 80 00       	push   $0x8030b8
  8013a4:	68 8c 00 00 00       	push   $0x8c
  8013a9:	68 49 30 80 00       	push   $0x803049
  8013ae:	e8 8c 14 00 00       	call   80283f <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013b3:	89 f8                	mov    %edi,%eax
  8013b5:	e8 42 fd ff ff       	call   8010fc <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013c0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013c6:	74 26                	je     8013ee <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013c8:	89 d8                	mov    %ebx,%eax
  8013ca:	c1 e8 16             	shr    $0x16,%eax
  8013cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d4:	a8 01                	test   $0x1,%al
  8013d6:	74 e2                	je     8013ba <fork+0x69>
  8013d8:	89 da                	mov    %ebx,%edx
  8013da:	c1 ea 0c             	shr    $0xc,%edx
  8013dd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013e4:	83 e0 05             	and    $0x5,%eax
  8013e7:	83 f8 05             	cmp    $0x5,%eax
  8013ea:	75 ce                	jne    8013ba <fork+0x69>
  8013ec:	eb c5                	jmp    8013b3 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	6a 07                	push   $0x7
  8013f3:	68 00 f0 bf ee       	push   $0xeebff000
  8013f8:	56                   	push   %esi
  8013f9:	e8 09 fa ff ff       	call   800e07 <sys_page_alloc>
	if(ret < 0)
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 31                	js     801436 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	68 0f 29 80 00       	push   $0x80290f
  80140d:	56                   	push   %esi
  80140e:	e8 3f fb ff ff       	call   800f52 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 33                	js     80144d <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80141a:	83 ec 08             	sub    $0x8,%esp
  80141d:	6a 02                	push   $0x2
  80141f:	56                   	push   %esi
  801420:	e8 a9 fa ff ff       	call   800ece <sys_env_set_status>
	if(ret < 0)
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 38                	js     801464 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80142c:	89 f0                	mov    %esi,%eax
  80142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	68 68 30 80 00       	push   $0x803068
  80143e:	68 98 00 00 00       	push   $0x98
  801443:	68 49 30 80 00       	push   $0x803049
  801448:	e8 f2 13 00 00       	call   80283f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 dc 30 80 00       	push   $0x8030dc
  801455:	68 9b 00 00 00       	push   $0x9b
  80145a:	68 49 30 80 00       	push   $0x803049
  80145f:	e8 db 13 00 00       	call   80283f <_panic>
		panic("panic in sys_env_set_status()\n");
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	68 04 31 80 00       	push   $0x803104
  80146c:	68 9e 00 00 00       	push   $0x9e
  801471:	68 49 30 80 00       	push   $0x803049
  801476:	e8 c4 13 00 00       	call   80283f <_panic>

0080147b <sfork>:

// Challenge!
int
sfork(void)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	57                   	push   %edi
  80147f:	56                   	push   %esi
  801480:	53                   	push   %ebx
  801481:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801484:	68 52 12 80 00       	push   $0x801252
  801489:	e8 12 14 00 00       	call   8028a0 <set_pgfault_handler>
  80148e:	b8 07 00 00 00       	mov    $0x7,%eax
  801493:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 2a                	js     8014c6 <sfork+0x4b>
  80149c:	89 c7                	mov    %eax,%edi
  80149e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014a5:	75 58                	jne    8014ff <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014a7:	e8 1d f9 ff ff       	call   800dc9 <sys_getenvid>
  8014ac:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014b1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014bc:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014c1:	e9 d4 00 00 00       	jmp    80159a <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	68 b8 30 80 00       	push   $0x8030b8
  8014ce:	68 af 00 00 00       	push   $0xaf
  8014d3:	68 49 30 80 00       	push   $0x803049
  8014d8:	e8 62 13 00 00       	call   80283f <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014dd:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014e2:	89 f0                	mov    %esi,%eax
  8014e4:	e8 13 fc ff ff       	call   8010fc <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ef:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014f5:	77 65                	ja     80155c <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8014f7:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014fd:	74 de                	je     8014dd <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014ff:	89 d8                	mov    %ebx,%eax
  801501:	c1 e8 16             	shr    $0x16,%eax
  801504:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80150b:	a8 01                	test   $0x1,%al
  80150d:	74 da                	je     8014e9 <sfork+0x6e>
  80150f:	89 da                	mov    %ebx,%edx
  801511:	c1 ea 0c             	shr    $0xc,%edx
  801514:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80151b:	83 e0 05             	and    $0x5,%eax
  80151e:	83 f8 05             	cmp    $0x5,%eax
  801521:	75 c6                	jne    8014e9 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801523:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80152a:	c1 e2 0c             	shl    $0xc,%edx
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	83 e0 07             	and    $0x7,%eax
  801533:	50                   	push   %eax
  801534:	52                   	push   %edx
  801535:	56                   	push   %esi
  801536:	52                   	push   %edx
  801537:	6a 00                	push   $0x0
  801539:	e8 0c f9 ff ff       	call   800e4a <sys_page_map>
  80153e:	83 c4 20             	add    $0x20,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	74 a4                	je     8014e9 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	68 33 30 80 00       	push   $0x803033
  80154d:	68 ba 00 00 00       	push   $0xba
  801552:	68 49 30 80 00       	push   $0x803049
  801557:	e8 e3 12 00 00       	call   80283f <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	6a 07                	push   $0x7
  801561:	68 00 f0 bf ee       	push   $0xeebff000
  801566:	57                   	push   %edi
  801567:	e8 9b f8 ff ff       	call   800e07 <sys_page_alloc>
	if(ret < 0)
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	85 c0                	test   %eax,%eax
  801571:	78 31                	js     8015a4 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	68 0f 29 80 00       	push   $0x80290f
  80157b:	57                   	push   %edi
  80157c:	e8 d1 f9 ff ff       	call   800f52 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	85 c0                	test   %eax,%eax
  801586:	78 33                	js     8015bb <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	6a 02                	push   $0x2
  80158d:	57                   	push   %edi
  80158e:	e8 3b f9 ff ff       	call   800ece <sys_env_set_status>
	if(ret < 0)
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 38                	js     8015d2 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80159a:	89 f8                	mov    %edi,%eax
  80159c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5f                   	pop    %edi
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	68 68 30 80 00       	push   $0x803068
  8015ac:	68 c0 00 00 00       	push   $0xc0
  8015b1:	68 49 30 80 00       	push   $0x803049
  8015b6:	e8 84 12 00 00       	call   80283f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	68 dc 30 80 00       	push   $0x8030dc
  8015c3:	68 c3 00 00 00       	push   $0xc3
  8015c8:	68 49 30 80 00       	push   $0x803049
  8015cd:	e8 6d 12 00 00       	call   80283f <_panic>
		panic("panic in sys_env_set_status()\n");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 04 31 80 00       	push   $0x803104
  8015da:	68 c6 00 00 00       	push   $0xc6
  8015df:	68 49 30 80 00       	push   $0x803049
  8015e4:	e8 56 12 00 00       	call   80283f <_panic>

008015e9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	56                   	push   %esi
  8015ed:	53                   	push   %ebx
  8015ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8015f7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015f9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015fe:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	50                   	push   %eax
  801605:	e8 ad f9 ff ff       	call   800fb7 <sys_ipc_recv>
	if(ret < 0){
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 2b                	js     80163c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801611:	85 f6                	test   %esi,%esi
  801613:	74 0a                	je     80161f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801615:	a1 08 50 80 00       	mov    0x805008,%eax
  80161a:	8b 40 78             	mov    0x78(%eax),%eax
  80161d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80161f:	85 db                	test   %ebx,%ebx
  801621:	74 0a                	je     80162d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801623:	a1 08 50 80 00       	mov    0x805008,%eax
  801628:	8b 40 7c             	mov    0x7c(%eax),%eax
  80162b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80162d:	a1 08 50 80 00       	mov    0x805008,%eax
  801632:	8b 40 74             	mov    0x74(%eax),%eax
}
  801635:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    
		if(from_env_store)
  80163c:	85 f6                	test   %esi,%esi
  80163e:	74 06                	je     801646 <ipc_recv+0x5d>
			*from_env_store = 0;
  801640:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801646:	85 db                	test   %ebx,%ebx
  801648:	74 eb                	je     801635 <ipc_recv+0x4c>
			*perm_store = 0;
  80164a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801650:	eb e3                	jmp    801635 <ipc_recv+0x4c>

00801652 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80165e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801661:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801664:	85 db                	test   %ebx,%ebx
  801666:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80166b:	0f 44 d8             	cmove  %eax,%ebx
  80166e:	eb 05                	jmp    801675 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801670:	e8 73 f7 ff ff       	call   800de8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801675:	ff 75 14             	pushl  0x14(%ebp)
  801678:	53                   	push   %ebx
  801679:	56                   	push   %esi
  80167a:	57                   	push   %edi
  80167b:	e8 14 f9 ff ff       	call   800f94 <sys_ipc_try_send>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	85 c0                	test   %eax,%eax
  801685:	74 1b                	je     8016a2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801687:	79 e7                	jns    801670 <ipc_send+0x1e>
  801689:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80168c:	74 e2                	je     801670 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	68 23 31 80 00       	push   $0x803123
  801696:	6a 46                	push   $0x46
  801698:	68 38 31 80 00       	push   $0x803138
  80169d:	e8 9d 11 00 00       	call   80283f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016b5:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8016bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016c1:	8b 52 50             	mov    0x50(%edx),%edx
  8016c4:	39 ca                	cmp    %ecx,%edx
  8016c6:	74 11                	je     8016d9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8016c8:	83 c0 01             	add    $0x1,%eax
  8016cb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016d0:	75 e3                	jne    8016b5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 0e                	jmp    8016e7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8016d9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8016df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	05 00 00 00 30       	add    $0x30000000,%eax
  8016f4:	c1 e8 0c             	shr    $0xc,%eax
}
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801704:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801709:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    

00801710 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801718:	89 c2                	mov    %eax,%edx
  80171a:	c1 ea 16             	shr    $0x16,%edx
  80171d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801724:	f6 c2 01             	test   $0x1,%dl
  801727:	74 2d                	je     801756 <fd_alloc+0x46>
  801729:	89 c2                	mov    %eax,%edx
  80172b:	c1 ea 0c             	shr    $0xc,%edx
  80172e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801735:	f6 c2 01             	test   $0x1,%dl
  801738:	74 1c                	je     801756 <fd_alloc+0x46>
  80173a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80173f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801744:	75 d2                	jne    801718 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80174f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801754:	eb 0a                	jmp    801760 <fd_alloc+0x50>
			*fd_store = fd;
  801756:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801759:	89 01                	mov    %eax,(%ecx)
			return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    

00801762 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801768:	83 f8 1f             	cmp    $0x1f,%eax
  80176b:	77 30                	ja     80179d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80176d:	c1 e0 0c             	shl    $0xc,%eax
  801770:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801775:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80177b:	f6 c2 01             	test   $0x1,%dl
  80177e:	74 24                	je     8017a4 <fd_lookup+0x42>
  801780:	89 c2                	mov    %eax,%edx
  801782:	c1 ea 0c             	shr    $0xc,%edx
  801785:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80178c:	f6 c2 01             	test   $0x1,%dl
  80178f:	74 1a                	je     8017ab <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	89 02                	mov    %eax,(%edx)
	return 0;
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
		return -E_INVAL;
  80179d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a2:	eb f7                	jmp    80179b <fd_lookup+0x39>
		return -E_INVAL;
  8017a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a9:	eb f0                	jmp    80179b <fd_lookup+0x39>
  8017ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b0:	eb e9                	jmp    80179b <fd_lookup+0x39>

008017b2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c0:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017c5:	39 08                	cmp    %ecx,(%eax)
  8017c7:	74 38                	je     801801 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017c9:	83 c2 01             	add    $0x1,%edx
  8017cc:	8b 04 95 c0 31 80 00 	mov    0x8031c0(,%edx,4),%eax
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	75 ee                	jne    8017c5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8017dc:	8b 40 48             	mov    0x48(%eax),%eax
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	51                   	push   %ecx
  8017e3:	50                   	push   %eax
  8017e4:	68 44 31 80 00       	push   $0x803144
  8017e9:	e8 c8 ea ff ff       	call   8002b6 <cprintf>
	*dev = 0;
  8017ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    
			*dev = devtab[i];
  801801:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801804:	89 01                	mov    %eax,(%ecx)
			return 0;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb f2                	jmp    8017ff <dev_lookup+0x4d>

0080180d <fd_close>:
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	57                   	push   %edi
  801811:	56                   	push   %esi
  801812:	53                   	push   %ebx
  801813:	83 ec 24             	sub    $0x24,%esp
  801816:	8b 75 08             	mov    0x8(%ebp),%esi
  801819:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80181c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80181f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801820:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801826:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801829:	50                   	push   %eax
  80182a:	e8 33 ff ff ff       	call   801762 <fd_lookup>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 05                	js     80183d <fd_close+0x30>
	    || fd != fd2)
  801838:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80183b:	74 16                	je     801853 <fd_close+0x46>
		return (must_exist ? r : 0);
  80183d:	89 f8                	mov    %edi,%eax
  80183f:	84 c0                	test   %al,%al
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	0f 44 d8             	cmove  %eax,%ebx
}
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5f                   	pop    %edi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	ff 36                	pushl  (%esi)
  80185c:	e8 51 ff ff ff       	call   8017b2 <dev_lookup>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 1a                	js     801884 <fd_close+0x77>
		if (dev->dev_close)
  80186a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801870:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801875:	85 c0                	test   %eax,%eax
  801877:	74 0b                	je     801884 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801879:	83 ec 0c             	sub    $0xc,%esp
  80187c:	56                   	push   %esi
  80187d:	ff d0                	call   *%eax
  80187f:	89 c3                	mov    %eax,%ebx
  801881:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	56                   	push   %esi
  801888:	6a 00                	push   $0x0
  80188a:	e8 fd f5 ff ff       	call   800e8c <sys_page_unmap>
	return r;
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	eb b5                	jmp    801849 <fd_close+0x3c>

00801894 <close>:

int
close(int fdnum)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189d:	50                   	push   %eax
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	e8 bc fe ff ff       	call   801762 <fd_lookup>
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	79 02                	jns    8018af <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    
		return fd_close(fd, 1);
  8018af:	83 ec 08             	sub    $0x8,%esp
  8018b2:	6a 01                	push   $0x1
  8018b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b7:	e8 51 ff ff ff       	call   80180d <fd_close>
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	eb ec                	jmp    8018ad <close+0x19>

008018c1 <close_all>:

void
close_all(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	53                   	push   %ebx
  8018d1:	e8 be ff ff ff       	call   801894 <close>
	for (i = 0; i < MAXFD; i++)
  8018d6:	83 c3 01             	add    $0x1,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	83 fb 20             	cmp    $0x20,%ebx
  8018df:	75 ec                	jne    8018cd <close_all+0xc>
}
  8018e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018f2:	50                   	push   %eax
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	e8 67 fe ff ff       	call   801762 <fd_lookup>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	0f 88 81 00 00 00    	js     801989 <dup+0xa3>
		return r;
	close(newfdnum);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 0c             	pushl  0xc(%ebp)
  80190e:	e8 81 ff ff ff       	call   801894 <close>

	newfd = INDEX2FD(newfdnum);
  801913:	8b 75 0c             	mov    0xc(%ebp),%esi
  801916:	c1 e6 0c             	shl    $0xc,%esi
  801919:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80191f:	83 c4 04             	add    $0x4,%esp
  801922:	ff 75 e4             	pushl  -0x1c(%ebp)
  801925:	e8 cf fd ff ff       	call   8016f9 <fd2data>
  80192a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80192c:	89 34 24             	mov    %esi,(%esp)
  80192f:	e8 c5 fd ff ff       	call   8016f9 <fd2data>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801939:	89 d8                	mov    %ebx,%eax
  80193b:	c1 e8 16             	shr    $0x16,%eax
  80193e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801945:	a8 01                	test   $0x1,%al
  801947:	74 11                	je     80195a <dup+0x74>
  801949:	89 d8                	mov    %ebx,%eax
  80194b:	c1 e8 0c             	shr    $0xc,%eax
  80194e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801955:	f6 c2 01             	test   $0x1,%dl
  801958:	75 39                	jne    801993 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80195a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80195d:	89 d0                	mov    %edx,%eax
  80195f:	c1 e8 0c             	shr    $0xc,%eax
  801962:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	25 07 0e 00 00       	and    $0xe07,%eax
  801971:	50                   	push   %eax
  801972:	56                   	push   %esi
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	6a 00                	push   $0x0
  801978:	e8 cd f4 ff ff       	call   800e4a <sys_page_map>
  80197d:	89 c3                	mov    %eax,%ebx
  80197f:	83 c4 20             	add    $0x20,%esp
  801982:	85 c0                	test   %eax,%eax
  801984:	78 31                	js     8019b7 <dup+0xd1>
		goto err;

	return newfdnum;
  801986:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801989:	89 d8                	mov    %ebx,%eax
  80198b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80198e:	5b                   	pop    %ebx
  80198f:	5e                   	pop    %esi
  801990:	5f                   	pop    %edi
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801993:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	25 07 0e 00 00       	and    $0xe07,%eax
  8019a2:	50                   	push   %eax
  8019a3:	57                   	push   %edi
  8019a4:	6a 00                	push   $0x0
  8019a6:	53                   	push   %ebx
  8019a7:	6a 00                	push   $0x0
  8019a9:	e8 9c f4 ff ff       	call   800e4a <sys_page_map>
  8019ae:	89 c3                	mov    %eax,%ebx
  8019b0:	83 c4 20             	add    $0x20,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	79 a3                	jns    80195a <dup+0x74>
	sys_page_unmap(0, newfd);
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	56                   	push   %esi
  8019bb:	6a 00                	push   $0x0
  8019bd:	e8 ca f4 ff ff       	call   800e8c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019c2:	83 c4 08             	add    $0x8,%esp
  8019c5:	57                   	push   %edi
  8019c6:	6a 00                	push   $0x0
  8019c8:	e8 bf f4 ff ff       	call   800e8c <sys_page_unmap>
	return r;
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	eb b7                	jmp    801989 <dup+0xa3>

008019d2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 1c             	sub    $0x1c,%esp
  8019d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019df:	50                   	push   %eax
  8019e0:	53                   	push   %ebx
  8019e1:	e8 7c fd ff ff       	call   801762 <fd_lookup>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 3f                	js     801a2c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ed:	83 ec 08             	sub    $0x8,%esp
  8019f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f3:	50                   	push   %eax
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f7:	ff 30                	pushl  (%eax)
  8019f9:	e8 b4 fd ff ff       	call   8017b2 <dev_lookup>
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 27                	js     801a2c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a08:	8b 42 08             	mov    0x8(%edx),%eax
  801a0b:	83 e0 03             	and    $0x3,%eax
  801a0e:	83 f8 01             	cmp    $0x1,%eax
  801a11:	74 1e                	je     801a31 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a16:	8b 40 08             	mov    0x8(%eax),%eax
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	74 35                	je     801a52 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	ff 75 10             	pushl  0x10(%ebp)
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	52                   	push   %edx
  801a27:	ff d0                	call   *%eax
  801a29:	83 c4 10             	add    $0x10,%esp
}
  801a2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a31:	a1 08 50 80 00       	mov    0x805008,%eax
  801a36:	8b 40 48             	mov    0x48(%eax),%eax
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	53                   	push   %ebx
  801a3d:	50                   	push   %eax
  801a3e:	68 85 31 80 00       	push   $0x803185
  801a43:	e8 6e e8 ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a50:	eb da                	jmp    801a2c <read+0x5a>
		return -E_NOT_SUPP;
  801a52:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a57:	eb d3                	jmp    801a2c <read+0x5a>

00801a59 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	57                   	push   %edi
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a65:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a68:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a6d:	39 f3                	cmp    %esi,%ebx
  801a6f:	73 23                	jae    801a94 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	89 f0                	mov    %esi,%eax
  801a76:	29 d8                	sub    %ebx,%eax
  801a78:	50                   	push   %eax
  801a79:	89 d8                	mov    %ebx,%eax
  801a7b:	03 45 0c             	add    0xc(%ebp),%eax
  801a7e:	50                   	push   %eax
  801a7f:	57                   	push   %edi
  801a80:	e8 4d ff ff ff       	call   8019d2 <read>
		if (m < 0)
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 06                	js     801a92 <readn+0x39>
			return m;
		if (m == 0)
  801a8c:	74 06                	je     801a94 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a8e:	01 c3                	add    %eax,%ebx
  801a90:	eb db                	jmp    801a6d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a92:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5e                   	pop    %esi
  801a9b:	5f                   	pop    %edi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 1c             	sub    $0x1c,%esp
  801aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aab:	50                   	push   %eax
  801aac:	53                   	push   %ebx
  801aad:	e8 b0 fc ff ff       	call   801762 <fd_lookup>
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 3a                	js     801af3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abf:	50                   	push   %eax
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	ff 30                	pushl  (%eax)
  801ac5:	e8 e8 fc ff ff       	call   8017b2 <dev_lookup>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 22                	js     801af3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad8:	74 1e                	je     801af8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801add:	8b 52 0c             	mov    0xc(%edx),%edx
  801ae0:	85 d2                	test   %edx,%edx
  801ae2:	74 35                	je     801b19 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	ff 75 10             	pushl  0x10(%ebp)
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	50                   	push   %eax
  801aee:	ff d2                	call   *%edx
  801af0:	83 c4 10             	add    $0x10,%esp
}
  801af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801af8:	a1 08 50 80 00       	mov    0x805008,%eax
  801afd:	8b 40 48             	mov    0x48(%eax),%eax
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	53                   	push   %ebx
  801b04:	50                   	push   %eax
  801b05:	68 a1 31 80 00       	push   $0x8031a1
  801b0a:	e8 a7 e7 ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b17:	eb da                	jmp    801af3 <write+0x55>
		return -E_NOT_SUPP;
  801b19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b1e:	eb d3                	jmp    801af3 <write+0x55>

00801b20 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b29:	50                   	push   %eax
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	e8 30 fc ff ff       	call   801762 <fd_lookup>
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 0e                	js     801b47 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	53                   	push   %ebx
  801b4d:	83 ec 1c             	sub    $0x1c,%esp
  801b50:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b53:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	53                   	push   %ebx
  801b58:	e8 05 fc ff ff       	call   801762 <fd_lookup>
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 37                	js     801b9b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b64:	83 ec 08             	sub    $0x8,%esp
  801b67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b6a:	50                   	push   %eax
  801b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6e:	ff 30                	pushl  (%eax)
  801b70:	e8 3d fc ff ff       	call   8017b2 <dev_lookup>
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	78 1f                	js     801b9b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b83:	74 1b                	je     801ba0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b88:	8b 52 18             	mov    0x18(%edx),%edx
  801b8b:	85 d2                	test   %edx,%edx
  801b8d:	74 32                	je     801bc1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	50                   	push   %eax
  801b96:	ff d2                	call   *%edx
  801b98:	83 c4 10             	add    $0x10,%esp
}
  801b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ba0:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ba5:	8b 40 48             	mov    0x48(%eax),%eax
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	53                   	push   %ebx
  801bac:	50                   	push   %eax
  801bad:	68 64 31 80 00       	push   $0x803164
  801bb2:	e8 ff e6 ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bbf:	eb da                	jmp    801b9b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc6:	eb d3                	jmp    801b9b <ftruncate+0x52>

00801bc8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
  801bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd5:	50                   	push   %eax
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	e8 84 fb ff ff       	call   801762 <fd_lookup>
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 4b                	js     801c30 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801beb:	50                   	push   %eax
  801bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bef:	ff 30                	pushl  (%eax)
  801bf1:	e8 bc fb ff ff       	call   8017b2 <dev_lookup>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 33                	js     801c30 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c00:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c04:	74 2f                	je     801c35 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c06:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c09:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c10:	00 00 00 
	stat->st_isdir = 0;
  801c13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c1a:	00 00 00 
	stat->st_dev = dev;
  801c1d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	53                   	push   %ebx
  801c27:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2a:	ff 50 14             	call   *0x14(%eax)
  801c2d:	83 c4 10             	add    $0x10,%esp
}
  801c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    
		return -E_NOT_SUPP;
  801c35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3a:	eb f4                	jmp    801c30 <fstat+0x68>

00801c3c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	e8 22 02 00 00       	call   801e70 <open>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 1b                	js     801c72 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c57:	83 ec 08             	sub    $0x8,%esp
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	e8 65 ff ff ff       	call   801bc8 <fstat>
  801c63:	89 c6                	mov    %eax,%esi
	close(fd);
  801c65:	89 1c 24             	mov    %ebx,(%esp)
  801c68:	e8 27 fc ff ff       	call   801894 <close>
	return r;
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	89 f3                	mov    %esi,%ebx
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
  801c80:	89 c6                	mov    %eax,%esi
  801c82:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c84:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c8b:	74 27                	je     801cb4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c8d:	6a 07                	push   $0x7
  801c8f:	68 00 60 80 00       	push   $0x806000
  801c94:	56                   	push   %esi
  801c95:	ff 35 00 50 80 00    	pushl  0x805000
  801c9b:	e8 b2 f9 ff ff       	call   801652 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ca0:	83 c4 0c             	add    $0xc,%esp
  801ca3:	6a 00                	push   $0x0
  801ca5:	53                   	push   %ebx
  801ca6:	6a 00                	push   $0x0
  801ca8:	e8 3c f9 ff ff       	call   8015e9 <ipc_recv>
}
  801cad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	6a 01                	push   $0x1
  801cb9:	e8 ec f9 ff ff       	call   8016aa <ipc_find_env>
  801cbe:	a3 00 50 80 00       	mov    %eax,0x805000
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	eb c5                	jmp    801c8d <fsipc+0x12>

00801cc8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce6:	b8 02 00 00 00       	mov    $0x2,%eax
  801ceb:	e8 8b ff ff ff       	call   801c7b <fsipc>
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <devfile_flush>:
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfe:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d03:	ba 00 00 00 00       	mov    $0x0,%edx
  801d08:	b8 06 00 00 00       	mov    $0x6,%eax
  801d0d:	e8 69 ff ff ff       	call   801c7b <fsipc>
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <devfile_stat>:
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	53                   	push   %ebx
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	8b 40 0c             	mov    0xc(%eax),%eax
  801d24:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	b8 05 00 00 00       	mov    $0x5,%eax
  801d33:	e8 43 ff ff ff       	call   801c7b <fsipc>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 2c                	js     801d68 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d3c:	83 ec 08             	sub    $0x8,%esp
  801d3f:	68 00 60 80 00       	push   $0x806000
  801d44:	53                   	push   %ebx
  801d45:	e8 cb ec ff ff       	call   800a15 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d4a:	a1 80 60 80 00       	mov    0x806080,%eax
  801d4f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d55:	a1 84 60 80 00       	mov    0x806084,%eax
  801d5a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <devfile_write>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	53                   	push   %ebx
  801d71:	83 ec 08             	sub    $0x8,%esp
  801d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d82:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d88:	53                   	push   %ebx
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	68 08 60 80 00       	push   $0x806008
  801d91:	e8 6f ee ff ff       	call   800c05 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d96:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9b:	b8 04 00 00 00       	mov    $0x4,%eax
  801da0:	e8 d6 fe ff ff       	call   801c7b <fsipc>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 0b                	js     801db7 <devfile_write+0x4a>
	assert(r <= n);
  801dac:	39 d8                	cmp    %ebx,%eax
  801dae:	77 0c                	ja     801dbc <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801db0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801db5:	7f 1e                	jg     801dd5 <devfile_write+0x68>
}
  801db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    
	assert(r <= n);
  801dbc:	68 d4 31 80 00       	push   $0x8031d4
  801dc1:	68 db 31 80 00       	push   $0x8031db
  801dc6:	68 98 00 00 00       	push   $0x98
  801dcb:	68 f0 31 80 00       	push   $0x8031f0
  801dd0:	e8 6a 0a 00 00       	call   80283f <_panic>
	assert(r <= PGSIZE);
  801dd5:	68 fb 31 80 00       	push   $0x8031fb
  801dda:	68 db 31 80 00       	push   $0x8031db
  801ddf:	68 99 00 00 00       	push   $0x99
  801de4:	68 f0 31 80 00       	push   $0x8031f0
  801de9:	e8 51 0a 00 00       	call   80283f <_panic>

00801dee <devfile_read>:
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e01:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e07:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0c:	b8 03 00 00 00       	mov    $0x3,%eax
  801e11:	e8 65 fe ff ff       	call   801c7b <fsipc>
  801e16:	89 c3                	mov    %eax,%ebx
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	78 1f                	js     801e3b <devfile_read+0x4d>
	assert(r <= n);
  801e1c:	39 f0                	cmp    %esi,%eax
  801e1e:	77 24                	ja     801e44 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e20:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e25:	7f 33                	jg     801e5a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	50                   	push   %eax
  801e2b:	68 00 60 80 00       	push   $0x806000
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	e8 6b ed ff ff       	call   800ba3 <memmove>
	return r;
  801e38:	83 c4 10             	add    $0x10,%esp
}
  801e3b:	89 d8                	mov    %ebx,%eax
  801e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5d                   	pop    %ebp
  801e43:	c3                   	ret    
	assert(r <= n);
  801e44:	68 d4 31 80 00       	push   $0x8031d4
  801e49:	68 db 31 80 00       	push   $0x8031db
  801e4e:	6a 7c                	push   $0x7c
  801e50:	68 f0 31 80 00       	push   $0x8031f0
  801e55:	e8 e5 09 00 00       	call   80283f <_panic>
	assert(r <= PGSIZE);
  801e5a:	68 fb 31 80 00       	push   $0x8031fb
  801e5f:	68 db 31 80 00       	push   $0x8031db
  801e64:	6a 7d                	push   $0x7d
  801e66:	68 f0 31 80 00       	push   $0x8031f0
  801e6b:	e8 cf 09 00 00       	call   80283f <_panic>

00801e70 <open>:
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	56                   	push   %esi
  801e74:	53                   	push   %ebx
  801e75:	83 ec 1c             	sub    $0x1c,%esp
  801e78:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e7b:	56                   	push   %esi
  801e7c:	e8 5b eb ff ff       	call   8009dc <strlen>
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e89:	7f 6c                	jg     801ef7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e91:	50                   	push   %eax
  801e92:	e8 79 f8 ff ff       	call   801710 <fd_alloc>
  801e97:	89 c3                	mov    %eax,%ebx
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	78 3c                	js     801edc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	56                   	push   %esi
  801ea4:	68 00 60 80 00       	push   $0x806000
  801ea9:	e8 67 eb ff ff       	call   800a15 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebe:	e8 b8 fd ff ff       	call   801c7b <fsipc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 19                	js     801ee5 <open+0x75>
	return fd2num(fd);
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	e8 12 f8 ff ff       	call   8016e9 <fd2num>
  801ed7:	89 c3                	mov    %eax,%ebx
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
		fd_close(fd, 0);
  801ee5:	83 ec 08             	sub    $0x8,%esp
  801ee8:	6a 00                	push   $0x0
  801eea:	ff 75 f4             	pushl  -0xc(%ebp)
  801eed:	e8 1b f9 ff ff       	call   80180d <fd_close>
		return r;
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	eb e5                	jmp    801edc <open+0x6c>
		return -E_BAD_PATH;
  801ef7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801efc:	eb de                	jmp    801edc <open+0x6c>

00801efe <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f04:	ba 00 00 00 00       	mov    $0x0,%edx
  801f09:	b8 08 00 00 00       	mov    $0x8,%eax
  801f0e:	e8 68 fd ff ff       	call   801c7b <fsipc>
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f1b:	68 07 32 80 00       	push   $0x803207
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	e8 ed ea ff ff       	call   800a15 <strcpy>
	return 0;
}
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <devsock_close>:
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	53                   	push   %ebx
  801f33:	83 ec 10             	sub    $0x10,%esp
  801f36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f39:	53                   	push   %ebx
  801f3a:	e8 f6 09 00 00       	call   802935 <pageref>
  801f3f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f42:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f47:	83 f8 01             	cmp    $0x1,%eax
  801f4a:	74 07                	je     801f53 <devsock_close+0x24>
}
  801f4c:	89 d0                	mov    %edx,%eax
  801f4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	ff 73 0c             	pushl  0xc(%ebx)
  801f59:	e8 b9 02 00 00       	call   802217 <nsipc_close>
  801f5e:	89 c2                	mov    %eax,%edx
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb e7                	jmp    801f4c <devsock_close+0x1d>

00801f65 <devsock_write>:
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	ff 75 10             	pushl  0x10(%ebp)
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	ff 70 0c             	pushl  0xc(%eax)
  801f79:	e8 76 03 00 00       	call   8022f4 <nsipc_send>
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <devsock_read>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	ff 75 10             	pushl  0x10(%ebp)
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	ff 70 0c             	pushl  0xc(%eax)
  801f94:	e8 ef 02 00 00       	call   802288 <nsipc_recv>
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <fd2sockid>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fa1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fa4:	52                   	push   %edx
  801fa5:	50                   	push   %eax
  801fa6:	e8 b7 f7 ff ff       	call   801762 <fd_lookup>
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 10                	js     801fc2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801fbb:	39 08                	cmp    %ecx,(%eax)
  801fbd:	75 05                	jne    801fc4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fbf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    
		return -E_NOT_SUPP;
  801fc4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fc9:	eb f7                	jmp    801fc2 <fd2sockid+0x27>

00801fcb <alloc_sockfd>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 1c             	sub    $0x1c,%esp
  801fd3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd8:	50                   	push   %eax
  801fd9:	e8 32 f7 ff ff       	call   801710 <fd_alloc>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 43                	js     80202a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	68 07 04 00 00       	push   $0x407
  801fef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff2:	6a 00                	push   $0x0
  801ff4:	e8 0e ee ff ff       	call   800e07 <sys_page_alloc>
  801ff9:	89 c3                	mov    %eax,%ebx
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 28                	js     80202a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80200b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802017:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	50                   	push   %eax
  80201e:	e8 c6 f6 ff ff       	call   8016e9 <fd2num>
  802023:	89 c3                	mov    %eax,%ebx
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	eb 0c                	jmp    802036 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	56                   	push   %esi
  80202e:	e8 e4 01 00 00       	call   802217 <nsipc_close>
		return r;
  802033:	83 c4 10             	add    $0x10,%esp
}
  802036:	89 d8                	mov    %ebx,%eax
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <accept>:
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	e8 4e ff ff ff       	call   801f9b <fd2sockid>
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 1b                	js     80206c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	ff 75 10             	pushl  0x10(%ebp)
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	50                   	push   %eax
  80205b:	e8 0e 01 00 00       	call   80216e <nsipc_accept>
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	85 c0                	test   %eax,%eax
  802065:	78 05                	js     80206c <accept+0x2d>
	return alloc_sockfd(r);
  802067:	e8 5f ff ff ff       	call   801fcb <alloc_sockfd>
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <bind>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	e8 1f ff ff ff       	call   801f9b <fd2sockid>
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 12                	js     802092 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	ff 75 10             	pushl  0x10(%ebp)
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	50                   	push   %eax
  80208a:	e8 31 01 00 00       	call   8021c0 <nsipc_bind>
  80208f:	83 c4 10             	add    $0x10,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <shutdown>:
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	e8 f9 fe ff ff       	call   801f9b <fd2sockid>
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	78 0f                	js     8020b5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020a6:	83 ec 08             	sub    $0x8,%esp
  8020a9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ac:	50                   	push   %eax
  8020ad:	e8 43 01 00 00       	call   8021f5 <nsipc_shutdown>
  8020b2:	83 c4 10             	add    $0x10,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <connect>:
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	e8 d6 fe ff ff       	call   801f9b <fd2sockid>
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 12                	js     8020db <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	ff 75 10             	pushl  0x10(%ebp)
  8020cf:	ff 75 0c             	pushl  0xc(%ebp)
  8020d2:	50                   	push   %eax
  8020d3:	e8 59 01 00 00       	call   802231 <nsipc_connect>
  8020d8:	83 c4 10             	add    $0x10,%esp
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <listen>:
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	e8 b0 fe ff ff       	call   801f9b <fd2sockid>
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 0f                	js     8020fe <listen+0x21>
	return nsipc_listen(r, backlog);
  8020ef:	83 ec 08             	sub    $0x8,%esp
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	50                   	push   %eax
  8020f6:	e8 6b 01 00 00       	call   802266 <nsipc_listen>
  8020fb:	83 c4 10             	add    $0x10,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <socket>:

int
socket(int domain, int type, int protocol)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802106:	ff 75 10             	pushl  0x10(%ebp)
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	ff 75 08             	pushl  0x8(%ebp)
  80210f:	e8 3e 02 00 00       	call   802352 <nsipc_socket>
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	85 c0                	test   %eax,%eax
  802119:	78 05                	js     802120 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80211b:	e8 ab fe ff ff       	call   801fcb <alloc_sockfd>
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	53                   	push   %ebx
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80212b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802132:	74 26                	je     80215a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802134:	6a 07                	push   $0x7
  802136:	68 00 70 80 00       	push   $0x807000
  80213b:	53                   	push   %ebx
  80213c:	ff 35 04 50 80 00    	pushl  0x805004
  802142:	e8 0b f5 ff ff       	call   801652 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802147:	83 c4 0c             	add    $0xc,%esp
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	e8 94 f4 ff ff       	call   8015e9 <ipc_recv>
}
  802155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802158:	c9                   	leave  
  802159:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	6a 02                	push   $0x2
  80215f:	e8 46 f5 ff ff       	call   8016aa <ipc_find_env>
  802164:	a3 04 50 80 00       	mov    %eax,0x805004
  802169:	83 c4 10             	add    $0x10,%esp
  80216c:	eb c6                	jmp    802134 <nsipc+0x12>

0080216e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	56                   	push   %esi
  802172:	53                   	push   %ebx
  802173:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80217e:	8b 06                	mov    (%esi),%eax
  802180:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802185:	b8 01 00 00 00       	mov    $0x1,%eax
  80218a:	e8 93 ff ff ff       	call   802122 <nsipc>
  80218f:	89 c3                	mov    %eax,%ebx
  802191:	85 c0                	test   %eax,%eax
  802193:	79 09                	jns    80219e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802195:	89 d8                	mov    %ebx,%eax
  802197:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5e                   	pop    %esi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	ff 35 10 70 80 00    	pushl  0x807010
  8021a7:	68 00 70 80 00       	push   $0x807000
  8021ac:	ff 75 0c             	pushl  0xc(%ebp)
  8021af:	e8 ef e9 ff ff       	call   800ba3 <memmove>
		*addrlen = ret->ret_addrlen;
  8021b4:	a1 10 70 80 00       	mov    0x807010,%eax
  8021b9:	89 06                	mov    %eax,(%esi)
  8021bb:	83 c4 10             	add    $0x10,%esp
	return r;
  8021be:	eb d5                	jmp    802195 <nsipc_accept+0x27>

008021c0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 08             	sub    $0x8,%esp
  8021c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021d2:	53                   	push   %ebx
  8021d3:	ff 75 0c             	pushl  0xc(%ebp)
  8021d6:	68 04 70 80 00       	push   $0x807004
  8021db:	e8 c3 e9 ff ff       	call   800ba3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021e0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8021eb:	e8 32 ff ff ff       	call   802122 <nsipc>
}
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802203:	8b 45 0c             	mov    0xc(%ebp),%eax
  802206:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80220b:	b8 03 00 00 00       	mov    $0x3,%eax
  802210:	e8 0d ff ff ff       	call   802122 <nsipc>
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <nsipc_close>:

int
nsipc_close(int s)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802225:	b8 04 00 00 00       	mov    $0x4,%eax
  80222a:	e8 f3 fe ff ff       	call   802122 <nsipc>
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	53                   	push   %ebx
  802235:	83 ec 08             	sub    $0x8,%esp
  802238:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802243:	53                   	push   %ebx
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	68 04 70 80 00       	push   $0x807004
  80224c:	e8 52 e9 ff ff       	call   800ba3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802251:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802257:	b8 05 00 00 00       	mov    $0x5,%eax
  80225c:	e8 c1 fe ff ff       	call   802122 <nsipc>
}
  802261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802274:	8b 45 0c             	mov    0xc(%ebp),%eax
  802277:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80227c:	b8 06 00 00 00       	mov    $0x6,%eax
  802281:	e8 9c fe ff ff       	call   802122 <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802298:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80229e:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a1:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022a6:	b8 07 00 00 00       	mov    $0x7,%eax
  8022ab:	e8 72 fe ff ff       	call   802122 <nsipc>
  8022b0:	89 c3                	mov    %eax,%ebx
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	78 1f                	js     8022d5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022b6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022bb:	7f 21                	jg     8022de <nsipc_recv+0x56>
  8022bd:	39 c6                	cmp    %eax,%esi
  8022bf:	7c 1d                	jl     8022de <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	50                   	push   %eax
  8022c5:	68 00 70 80 00       	push   $0x807000
  8022ca:	ff 75 0c             	pushl  0xc(%ebp)
  8022cd:	e8 d1 e8 ff ff       	call   800ba3 <memmove>
  8022d2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022d5:	89 d8                	mov    %ebx,%eax
  8022d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022de:	68 13 32 80 00       	push   $0x803213
  8022e3:	68 db 31 80 00       	push   $0x8031db
  8022e8:	6a 62                	push   $0x62
  8022ea:	68 28 32 80 00       	push   $0x803228
  8022ef:	e8 4b 05 00 00       	call   80283f <_panic>

008022f4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802306:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80230c:	7f 2e                	jg     80233c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	53                   	push   %ebx
  802312:	ff 75 0c             	pushl  0xc(%ebp)
  802315:	68 0c 70 80 00       	push   $0x80700c
  80231a:	e8 84 e8 ff ff       	call   800ba3 <memmove>
	nsipcbuf.send.req_size = size;
  80231f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802325:	8b 45 14             	mov    0x14(%ebp),%eax
  802328:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80232d:	b8 08 00 00 00       	mov    $0x8,%eax
  802332:	e8 eb fd ff ff       	call   802122 <nsipc>
}
  802337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    
	assert(size < 1600);
  80233c:	68 34 32 80 00       	push   $0x803234
  802341:	68 db 31 80 00       	push   $0x8031db
  802346:	6a 6d                	push   $0x6d
  802348:	68 28 32 80 00       	push   $0x803228
  80234d:	e8 ed 04 00 00       	call   80283f <_panic>

00802352 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802360:	8b 45 0c             	mov    0xc(%ebp),%eax
  802363:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802368:	8b 45 10             	mov    0x10(%ebp),%eax
  80236b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802370:	b8 09 00 00 00       	mov    $0x9,%eax
  802375:	e8 a8 fd ff ff       	call   802122 <nsipc>
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	e8 6a f3 ff ff       	call   8016f9 <fd2data>
  80238f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802391:	83 c4 08             	add    $0x8,%esp
  802394:	68 40 32 80 00       	push   $0x803240
  802399:	53                   	push   %ebx
  80239a:	e8 76 e6 ff ff       	call   800a15 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80239f:	8b 46 04             	mov    0x4(%esi),%eax
  8023a2:	2b 06                	sub    (%esi),%eax
  8023a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023aa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023b1:	00 00 00 
	stat->st_dev = &devpipe;
  8023b4:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8023bb:	40 80 00 
	return 0;
}
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c6:	5b                   	pop    %ebx
  8023c7:	5e                   	pop    %esi
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023d4:	53                   	push   %ebx
  8023d5:	6a 00                	push   $0x0
  8023d7:	e8 b0 ea ff ff       	call   800e8c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023dc:	89 1c 24             	mov    %ebx,(%esp)
  8023df:	e8 15 f3 ff ff       	call   8016f9 <fd2data>
  8023e4:	83 c4 08             	add    $0x8,%esp
  8023e7:	50                   	push   %eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	e8 9d ea ff ff       	call   800e8c <sys_page_unmap>
}
  8023ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <_pipeisclosed>:
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	57                   	push   %edi
  8023f8:	56                   	push   %esi
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 1c             	sub    $0x1c,%esp
  8023fd:	89 c7                	mov    %eax,%edi
  8023ff:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802401:	a1 08 50 80 00       	mov    0x805008,%eax
  802406:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	57                   	push   %edi
  80240d:	e8 23 05 00 00       	call   802935 <pageref>
  802412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802415:	89 34 24             	mov    %esi,(%esp)
  802418:	e8 18 05 00 00       	call   802935 <pageref>
		nn = thisenv->env_runs;
  80241d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802423:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	39 cb                	cmp    %ecx,%ebx
  80242b:	74 1b                	je     802448 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80242d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802430:	75 cf                	jne    802401 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802432:	8b 42 58             	mov    0x58(%edx),%eax
  802435:	6a 01                	push   $0x1
  802437:	50                   	push   %eax
  802438:	53                   	push   %ebx
  802439:	68 47 32 80 00       	push   $0x803247
  80243e:	e8 73 de ff ff       	call   8002b6 <cprintf>
  802443:	83 c4 10             	add    $0x10,%esp
  802446:	eb b9                	jmp    802401 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802448:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80244b:	0f 94 c0             	sete   %al
  80244e:	0f b6 c0             	movzbl %al,%eax
}
  802451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5f                   	pop    %edi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    

00802459 <devpipe_write>:
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	57                   	push   %edi
  80245d:	56                   	push   %esi
  80245e:	53                   	push   %ebx
  80245f:	83 ec 28             	sub    $0x28,%esp
  802462:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802465:	56                   	push   %esi
  802466:	e8 8e f2 ff ff       	call   8016f9 <fd2data>
  80246b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	bf 00 00 00 00       	mov    $0x0,%edi
  802475:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802478:	74 4f                	je     8024c9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80247a:	8b 43 04             	mov    0x4(%ebx),%eax
  80247d:	8b 0b                	mov    (%ebx),%ecx
  80247f:	8d 51 20             	lea    0x20(%ecx),%edx
  802482:	39 d0                	cmp    %edx,%eax
  802484:	72 14                	jb     80249a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802486:	89 da                	mov    %ebx,%edx
  802488:	89 f0                	mov    %esi,%eax
  80248a:	e8 65 ff ff ff       	call   8023f4 <_pipeisclosed>
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 3b                	jne    8024ce <devpipe_write+0x75>
			sys_yield();
  802493:	e8 50 e9 ff ff       	call   800de8 <sys_yield>
  802498:	eb e0                	jmp    80247a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80249a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80249d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024a1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024a4:	89 c2                	mov    %eax,%edx
  8024a6:	c1 fa 1f             	sar    $0x1f,%edx
  8024a9:	89 d1                	mov    %edx,%ecx
  8024ab:	c1 e9 1b             	shr    $0x1b,%ecx
  8024ae:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024b1:	83 e2 1f             	and    $0x1f,%edx
  8024b4:	29 ca                	sub    %ecx,%edx
  8024b6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024ba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024be:	83 c0 01             	add    $0x1,%eax
  8024c1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024c4:	83 c7 01             	add    $0x1,%edi
  8024c7:	eb ac                	jmp    802475 <devpipe_write+0x1c>
	return i;
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	eb 05                	jmp    8024d3 <devpipe_write+0x7a>
				return 0;
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5f                   	pop    %edi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    

008024db <devpipe_read>:
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	57                   	push   %edi
  8024df:	56                   	push   %esi
  8024e0:	53                   	push   %ebx
  8024e1:	83 ec 18             	sub    $0x18,%esp
  8024e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024e7:	57                   	push   %edi
  8024e8:	e8 0c f2 ff ff       	call   8016f9 <fd2data>
  8024ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024ef:	83 c4 10             	add    $0x10,%esp
  8024f2:	be 00 00 00 00       	mov    $0x0,%esi
  8024f7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024fa:	75 14                	jne    802510 <devpipe_read+0x35>
	return i;
  8024fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ff:	eb 02                	jmp    802503 <devpipe_read+0x28>
				return i;
  802501:	89 f0                	mov    %esi,%eax
}
  802503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802506:	5b                   	pop    %ebx
  802507:	5e                   	pop    %esi
  802508:	5f                   	pop    %edi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    
			sys_yield();
  80250b:	e8 d8 e8 ff ff       	call   800de8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802510:	8b 03                	mov    (%ebx),%eax
  802512:	3b 43 04             	cmp    0x4(%ebx),%eax
  802515:	75 18                	jne    80252f <devpipe_read+0x54>
			if (i > 0)
  802517:	85 f6                	test   %esi,%esi
  802519:	75 e6                	jne    802501 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80251b:	89 da                	mov    %ebx,%edx
  80251d:	89 f8                	mov    %edi,%eax
  80251f:	e8 d0 fe ff ff       	call   8023f4 <_pipeisclosed>
  802524:	85 c0                	test   %eax,%eax
  802526:	74 e3                	je     80250b <devpipe_read+0x30>
				return 0;
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	eb d4                	jmp    802503 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80252f:	99                   	cltd   
  802530:	c1 ea 1b             	shr    $0x1b,%edx
  802533:	01 d0                	add    %edx,%eax
  802535:	83 e0 1f             	and    $0x1f,%eax
  802538:	29 d0                	sub    %edx,%eax
  80253a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80253f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802542:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802545:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802548:	83 c6 01             	add    $0x1,%esi
  80254b:	eb aa                	jmp    8024f7 <devpipe_read+0x1c>

0080254d <pipe>:
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	56                   	push   %esi
  802551:	53                   	push   %ebx
  802552:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802558:	50                   	push   %eax
  802559:	e8 b2 f1 ff ff       	call   801710 <fd_alloc>
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 88 23 01 00 00    	js     80268e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 07 04 00 00       	push   $0x407
  802573:	ff 75 f4             	pushl  -0xc(%ebp)
  802576:	6a 00                	push   $0x0
  802578:	e8 8a e8 ff ff       	call   800e07 <sys_page_alloc>
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	85 c0                	test   %eax,%eax
  802584:	0f 88 04 01 00 00    	js     80268e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802590:	50                   	push   %eax
  802591:	e8 7a f1 ff ff       	call   801710 <fd_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 88 db 00 00 00    	js     80267e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 07 04 00 00       	push   $0x407
  8025ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ae:	6a 00                	push   $0x0
  8025b0:	e8 52 e8 ff ff       	call   800e07 <sys_page_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 88 bc 00 00 00    	js     80267e <pipe+0x131>
	va = fd2data(fd0);
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c8:	e8 2c f1 ff ff       	call   8016f9 <fd2data>
  8025cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cf:	83 c4 0c             	add    $0xc,%esp
  8025d2:	68 07 04 00 00       	push   $0x407
  8025d7:	50                   	push   %eax
  8025d8:	6a 00                	push   $0x0
  8025da:	e8 28 e8 ff ff       	call   800e07 <sys_page_alloc>
  8025df:	89 c3                	mov    %eax,%ebx
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	0f 88 82 00 00 00    	js     80266e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ec:	83 ec 0c             	sub    $0xc,%esp
  8025ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f2:	e8 02 f1 ff ff       	call   8016f9 <fd2data>
  8025f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025fe:	50                   	push   %eax
  8025ff:	6a 00                	push   $0x0
  802601:	56                   	push   %esi
  802602:	6a 00                	push   $0x0
  802604:	e8 41 e8 ff ff       	call   800e4a <sys_page_map>
  802609:	89 c3                	mov    %eax,%ebx
  80260b:	83 c4 20             	add    $0x20,%esp
  80260e:	85 c0                	test   %eax,%eax
  802610:	78 4e                	js     802660 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802612:	a1 44 40 80 00       	mov    0x804044,%eax
  802617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80261c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802626:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802629:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 f4             	pushl  -0xc(%ebp)
  80263b:	e8 a9 f0 ff ff       	call   8016e9 <fd2num>
  802640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802643:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802645:	83 c4 04             	add    $0x4,%esp
  802648:	ff 75 f0             	pushl  -0x10(%ebp)
  80264b:	e8 99 f0 ff ff       	call   8016e9 <fd2num>
  802650:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802653:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802656:	83 c4 10             	add    $0x10,%esp
  802659:	bb 00 00 00 00       	mov    $0x0,%ebx
  80265e:	eb 2e                	jmp    80268e <pipe+0x141>
	sys_page_unmap(0, va);
  802660:	83 ec 08             	sub    $0x8,%esp
  802663:	56                   	push   %esi
  802664:	6a 00                	push   $0x0
  802666:	e8 21 e8 ff ff       	call   800e8c <sys_page_unmap>
  80266b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80266e:	83 ec 08             	sub    $0x8,%esp
  802671:	ff 75 f0             	pushl  -0x10(%ebp)
  802674:	6a 00                	push   $0x0
  802676:	e8 11 e8 ff ff       	call   800e8c <sys_page_unmap>
  80267b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80267e:	83 ec 08             	sub    $0x8,%esp
  802681:	ff 75 f4             	pushl  -0xc(%ebp)
  802684:	6a 00                	push   $0x0
  802686:	e8 01 e8 ff ff       	call   800e8c <sys_page_unmap>
  80268b:	83 c4 10             	add    $0x10,%esp
}
  80268e:	89 d8                	mov    %ebx,%eax
  802690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802693:	5b                   	pop    %ebx
  802694:	5e                   	pop    %esi
  802695:	5d                   	pop    %ebp
  802696:	c3                   	ret    

00802697 <pipeisclosed>:
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a0:	50                   	push   %eax
  8026a1:	ff 75 08             	pushl  0x8(%ebp)
  8026a4:	e8 b9 f0 ff ff       	call   801762 <fd_lookup>
  8026a9:	83 c4 10             	add    $0x10,%esp
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 18                	js     8026c8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b6:	e8 3e f0 ff ff       	call   8016f9 <fd2data>
	return _pipeisclosed(fd, p);
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e8 2f fd ff ff       	call   8023f4 <_pipeisclosed>
  8026c5:	83 c4 10             	add    $0x10,%esp
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	c3                   	ret    

008026d0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026d6:	68 5f 32 80 00       	push   $0x80325f
  8026db:	ff 75 0c             	pushl  0xc(%ebp)
  8026de:	e8 32 e3 ff ff       	call   800a15 <strcpy>
	return 0;
}
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <devcons_write>:
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	57                   	push   %edi
  8026ee:	56                   	push   %esi
  8026ef:	53                   	push   %ebx
  8026f0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026f6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802701:	3b 75 10             	cmp    0x10(%ebp),%esi
  802704:	73 31                	jae    802737 <devcons_write+0x4d>
		m = n - tot;
  802706:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802709:	29 f3                	sub    %esi,%ebx
  80270b:	83 fb 7f             	cmp    $0x7f,%ebx
  80270e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802713:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802716:	83 ec 04             	sub    $0x4,%esp
  802719:	53                   	push   %ebx
  80271a:	89 f0                	mov    %esi,%eax
  80271c:	03 45 0c             	add    0xc(%ebp),%eax
  80271f:	50                   	push   %eax
  802720:	57                   	push   %edi
  802721:	e8 7d e4 ff ff       	call   800ba3 <memmove>
		sys_cputs(buf, m);
  802726:	83 c4 08             	add    $0x8,%esp
  802729:	53                   	push   %ebx
  80272a:	57                   	push   %edi
  80272b:	e8 1b e6 ff ff       	call   800d4b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802730:	01 de                	add    %ebx,%esi
  802732:	83 c4 10             	add    $0x10,%esp
  802735:	eb ca                	jmp    802701 <devcons_write+0x17>
}
  802737:	89 f0                	mov    %esi,%eax
  802739:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80273c:	5b                   	pop    %ebx
  80273d:	5e                   	pop    %esi
  80273e:	5f                   	pop    %edi
  80273f:	5d                   	pop    %ebp
  802740:	c3                   	ret    

00802741 <devcons_read>:
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 08             	sub    $0x8,%esp
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80274c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802750:	74 21                	je     802773 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802752:	e8 12 e6 ff ff       	call   800d69 <sys_cgetc>
  802757:	85 c0                	test   %eax,%eax
  802759:	75 07                	jne    802762 <devcons_read+0x21>
		sys_yield();
  80275b:	e8 88 e6 ff ff       	call   800de8 <sys_yield>
  802760:	eb f0                	jmp    802752 <devcons_read+0x11>
	if (c < 0)
  802762:	78 0f                	js     802773 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802764:	83 f8 04             	cmp    $0x4,%eax
  802767:	74 0c                	je     802775 <devcons_read+0x34>
	*(char*)vbuf = c;
  802769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276c:	88 02                	mov    %al,(%edx)
	return 1;
  80276e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    
		return 0;
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	eb f7                	jmp    802773 <devcons_read+0x32>

0080277c <cputchar>:
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802788:	6a 01                	push   $0x1
  80278a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80278d:	50                   	push   %eax
  80278e:	e8 b8 e5 ff ff       	call   800d4b <sys_cputs>
}
  802793:	83 c4 10             	add    $0x10,%esp
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <getchar>:
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80279e:	6a 01                	push   $0x1
  8027a0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a3:	50                   	push   %eax
  8027a4:	6a 00                	push   $0x0
  8027a6:	e8 27 f2 ff ff       	call   8019d2 <read>
	if (r < 0)
  8027ab:	83 c4 10             	add    $0x10,%esp
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	78 06                	js     8027b8 <getchar+0x20>
	if (r < 1)
  8027b2:	74 06                	je     8027ba <getchar+0x22>
	return c;
  8027b4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    
		return -E_EOF;
  8027ba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027bf:	eb f7                	jmp    8027b8 <getchar+0x20>

008027c1 <iscons>:
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ca:	50                   	push   %eax
  8027cb:	ff 75 08             	pushl  0x8(%ebp)
  8027ce:	e8 8f ef ff ff       	call   801762 <fd_lookup>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	78 11                	js     8027eb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8027e3:	39 10                	cmp    %edx,(%eax)
  8027e5:	0f 94 c0             	sete   %al
  8027e8:	0f b6 c0             	movzbl %al,%eax
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <opencons>:
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f6:	50                   	push   %eax
  8027f7:	e8 14 ef ff ff       	call   801710 <fd_alloc>
  8027fc:	83 c4 10             	add    $0x10,%esp
  8027ff:	85 c0                	test   %eax,%eax
  802801:	78 3a                	js     80283d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 07 04 00 00       	push   $0x407
  80280b:	ff 75 f4             	pushl  -0xc(%ebp)
  80280e:	6a 00                	push   $0x0
  802810:	e8 f2 e5 ff ff       	call   800e07 <sys_page_alloc>
  802815:	83 c4 10             	add    $0x10,%esp
  802818:	85 c0                	test   %eax,%eax
  80281a:	78 21                	js     80283d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802825:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802831:	83 ec 0c             	sub    $0xc,%esp
  802834:	50                   	push   %eax
  802835:	e8 af ee ff ff       	call   8016e9 <fd2num>
  80283a:	83 c4 10             	add    $0x10,%esp
}
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	56                   	push   %esi
  802843:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802844:	a1 08 50 80 00       	mov    0x805008,%eax
  802849:	8b 40 48             	mov    0x48(%eax),%eax
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	68 90 32 80 00       	push   $0x803290
  802854:	50                   	push   %eax
  802855:	68 6c 2c 80 00       	push   $0x802c6c
  80285a:	e8 57 da ff ff       	call   8002b6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80285f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802862:	8b 35 08 40 80 00    	mov    0x804008,%esi
  802868:	e8 5c e5 ff ff       	call   800dc9 <sys_getenvid>
  80286d:	83 c4 04             	add    $0x4,%esp
  802870:	ff 75 0c             	pushl  0xc(%ebp)
  802873:	ff 75 08             	pushl  0x8(%ebp)
  802876:	56                   	push   %esi
  802877:	50                   	push   %eax
  802878:	68 6c 32 80 00       	push   $0x80326c
  80287d:	e8 34 da ff ff       	call   8002b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802882:	83 c4 18             	add    $0x18,%esp
  802885:	53                   	push   %ebx
  802886:	ff 75 10             	pushl  0x10(%ebp)
  802889:	e8 d7 d9 ff ff       	call   800265 <vcprintf>
	cprintf("\n");
  80288e:	c7 04 24 81 30 80 00 	movl   $0x803081,(%esp)
  802895:	e8 1c da ff ff       	call   8002b6 <cprintf>
  80289a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80289d:	cc                   	int3   
  80289e:	eb fd                	jmp    80289d <_panic+0x5e>

008028a0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028a6:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028ad:	74 0a                	je     8028b9 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	6a 07                	push   $0x7
  8028be:	68 00 f0 bf ee       	push   $0xeebff000
  8028c3:	6a 00                	push   $0x0
  8028c5:	e8 3d e5 ff ff       	call   800e07 <sys_page_alloc>
		if(r < 0)
  8028ca:	83 c4 10             	add    $0x10,%esp
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	78 2a                	js     8028fb <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028d1:	83 ec 08             	sub    $0x8,%esp
  8028d4:	68 0f 29 80 00       	push   $0x80290f
  8028d9:	6a 00                	push   $0x0
  8028db:	e8 72 e6 ff ff       	call   800f52 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028e0:	83 c4 10             	add    $0x10,%esp
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	79 c8                	jns    8028af <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	68 c8 32 80 00       	push   $0x8032c8
  8028ef:	6a 25                	push   $0x25
  8028f1:	68 04 33 80 00       	push   $0x803304
  8028f6:	e8 44 ff ff ff       	call   80283f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	68 98 32 80 00       	push   $0x803298
  802903:	6a 22                	push   $0x22
  802905:	68 04 33 80 00       	push   $0x803304
  80290a:	e8 30 ff ff ff       	call   80283f <_panic>

0080290f <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80290f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802910:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802915:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802917:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80291a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80291e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802922:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802925:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802927:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80292b:	83 c4 08             	add    $0x8,%esp
	popal
  80292e:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80292f:	83 c4 04             	add    $0x4,%esp
	popfl
  802932:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802933:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802934:	c3                   	ret    

00802935 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80293b:	89 d0                	mov    %edx,%eax
  80293d:	c1 e8 16             	shr    $0x16,%eax
  802940:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80294c:	f6 c1 01             	test   $0x1,%cl
  80294f:	74 1d                	je     80296e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802951:	c1 ea 0c             	shr    $0xc,%edx
  802954:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80295b:	f6 c2 01             	test   $0x1,%dl
  80295e:	74 0e                	je     80296e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802960:	c1 ea 0c             	shr    $0xc,%edx
  802963:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80296a:	ef 
  80296b:	0f b7 c0             	movzwl %ax,%eax
}
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    

00802970 <__udivdi3>:
  802970:	55                   	push   %ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	83 ec 1c             	sub    $0x1c,%esp
  802977:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80297b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80297f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802983:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802987:	85 d2                	test   %edx,%edx
  802989:	75 4d                	jne    8029d8 <__udivdi3+0x68>
  80298b:	39 f3                	cmp    %esi,%ebx
  80298d:	76 19                	jbe    8029a8 <__udivdi3+0x38>
  80298f:	31 ff                	xor    %edi,%edi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f2                	mov    %esi,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 d9                	mov    %ebx,%ecx
  8029aa:	85 db                	test   %ebx,%ebx
  8029ac:	75 0b                	jne    8029b9 <__udivdi3+0x49>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	31 d2                	xor    %edx,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 c1                	mov    %eax,%ecx
  8029b9:	31 d2                	xor    %edx,%edx
  8029bb:	89 f0                	mov    %esi,%eax
  8029bd:	f7 f1                	div    %ecx
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f7                	mov    %esi,%edi
  8029c5:	f7 f1                	div    %ecx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	77 1c                	ja     8029f8 <__udivdi3+0x88>
  8029dc:	0f bd fa             	bsr    %edx,%edi
  8029df:	83 f7 1f             	xor    $0x1f,%edi
  8029e2:	75 2c                	jne    802a10 <__udivdi3+0xa0>
  8029e4:	39 f2                	cmp    %esi,%edx
  8029e6:	72 06                	jb     8029ee <__udivdi3+0x7e>
  8029e8:	31 c0                	xor    %eax,%eax
  8029ea:	39 eb                	cmp    %ebp,%ebx
  8029ec:	77 a9                	ja     802997 <__udivdi3+0x27>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	eb a2                	jmp    802997 <__udivdi3+0x27>
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	31 ff                	xor    %edi,%edi
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	89 fa                	mov    %edi,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 f9                	mov    %edi,%ecx
  802a12:	b8 20 00 00 00       	mov    $0x20,%eax
  802a17:	29 f8                	sub    %edi,%eax
  802a19:	d3 e2                	shl    %cl,%edx
  802a1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	89 da                	mov    %ebx,%edx
  802a23:	d3 ea                	shr    %cl,%edx
  802a25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a29:	09 d1                	or     %edx,%ecx
  802a2b:	89 f2                	mov    %esi,%edx
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 f9                	mov    %edi,%ecx
  802a33:	d3 e3                	shl    %cl,%ebx
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	d3 ea                	shr    %cl,%edx
  802a39:	89 f9                	mov    %edi,%ecx
  802a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a3f:	89 eb                	mov    %ebp,%ebx
  802a41:	d3 e6                	shl    %cl,%esi
  802a43:	89 c1                	mov    %eax,%ecx
  802a45:	d3 eb                	shr    %cl,%ebx
  802a47:	09 de                	or     %ebx,%esi
  802a49:	89 f0                	mov    %esi,%eax
  802a4b:	f7 74 24 08          	divl   0x8(%esp)
  802a4f:	89 d6                	mov    %edx,%esi
  802a51:	89 c3                	mov    %eax,%ebx
  802a53:	f7 64 24 0c          	mull   0xc(%esp)
  802a57:	39 d6                	cmp    %edx,%esi
  802a59:	72 15                	jb     802a70 <__udivdi3+0x100>
  802a5b:	89 f9                	mov    %edi,%ecx
  802a5d:	d3 e5                	shl    %cl,%ebp
  802a5f:	39 c5                	cmp    %eax,%ebp
  802a61:	73 04                	jae    802a67 <__udivdi3+0xf7>
  802a63:	39 d6                	cmp    %edx,%esi
  802a65:	74 09                	je     802a70 <__udivdi3+0x100>
  802a67:	89 d8                	mov    %ebx,%eax
  802a69:	31 ff                	xor    %edi,%edi
  802a6b:	e9 27 ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	e9 1d ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	66 90                	xchg   %ax,%ax
  802a7e:	66 90                	xchg   %ax,%ax

00802a80 <__umoddi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a97:	89 da                	mov    %ebx,%edx
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	75 43                	jne    802ae0 <__umoddi3+0x60>
  802a9d:	39 df                	cmp    %ebx,%edi
  802a9f:	76 17                	jbe    802ab8 <__umoddi3+0x38>
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	f7 f7                	div    %edi
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	31 d2                	xor    %edx,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 fd                	mov    %edi,%ebp
  802aba:	85 ff                	test   %edi,%edi
  802abc:	75 0b                	jne    802ac9 <__umoddi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f7                	div    %edi
  802ac7:	89 c5                	mov    %eax,%ebp
  802ac9:	89 d8                	mov    %ebx,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f5                	div    %ebp
  802acf:	89 f0                	mov    %esi,%eax
  802ad1:	f7 f5                	div    %ebp
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	eb d0                	jmp    802aa7 <__umoddi3+0x27>
  802ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ade:	66 90                	xchg   %ax,%ax
  802ae0:	89 f1                	mov    %esi,%ecx
  802ae2:	39 d8                	cmp    %ebx,%eax
  802ae4:	76 0a                	jbe    802af0 <__umoddi3+0x70>
  802ae6:	89 f0                	mov    %esi,%eax
  802ae8:	83 c4 1c             	add    $0x1c,%esp
  802aeb:	5b                   	pop    %ebx
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	0f bd e8             	bsr    %eax,%ebp
  802af3:	83 f5 1f             	xor    $0x1f,%ebp
  802af6:	75 20                	jne    802b18 <__umoddi3+0x98>
  802af8:	39 d8                	cmp    %ebx,%eax
  802afa:	0f 82 b0 00 00 00    	jb     802bb0 <__umoddi3+0x130>
  802b00:	39 f7                	cmp    %esi,%edi
  802b02:	0f 86 a8 00 00 00    	jbe    802bb0 <__umoddi3+0x130>
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	83 c4 1c             	add    $0x1c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b1f:	29 ea                	sub    %ebp,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	d3 e8                	shr    %cl,%eax
  802b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b39:	09 c1                	or     %eax,%ecx
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	d3 e3                	shl    %cl,%ebx
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	89 d1                	mov    %edx,%ecx
  802b55:	89 f0                	mov    %esi,%eax
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 fa                	mov    %edi,%edx
  802b5d:	d3 e6                	shl    %cl,%esi
  802b5f:	09 d8                	or     %ebx,%eax
  802b61:	f7 74 24 08          	divl   0x8(%esp)
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	f7 64 24 0c          	mull   0xc(%esp)
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	89 d7                	mov    %edx,%edi
  802b71:	39 d1                	cmp    %edx,%ecx
  802b73:	72 06                	jb     802b7b <__umoddi3+0xfb>
  802b75:	75 10                	jne    802b87 <__umoddi3+0x107>
  802b77:	39 c3                	cmp    %eax,%ebx
  802b79:	73 0c                	jae    802b87 <__umoddi3+0x107>
  802b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b83:	89 d7                	mov    %edx,%edi
  802b85:	89 c6                	mov    %eax,%esi
  802b87:	89 ca                	mov    %ecx,%edx
  802b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b8e:	29 f3                	sub    %esi,%ebx
  802b90:	19 fa                	sbb    %edi,%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	d3 e0                	shl    %cl,%eax
  802b96:	89 e9                	mov    %ebp,%ecx
  802b98:	d3 eb                	shr    %cl,%ebx
  802b9a:	d3 ea                	shr    %cl,%edx
  802b9c:	09 d8                	or     %ebx,%eax
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	89 da                	mov    %ebx,%edx
  802bb2:	29 fe                	sub    %edi,%esi
  802bb4:	19 c2                	sbb    %eax,%edx
  802bb6:	89 f1                	mov    %esi,%ecx
  802bb8:	89 c8                	mov    %ecx,%eax
  802bba:	e9 4b ff ff ff       	jmp    802b0a <__umoddi3+0x8a>
