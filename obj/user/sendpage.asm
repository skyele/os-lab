
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
  800039:	e8 32 13 00 00       	call   801370 <fork>
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
  80005c:	e8 e5 0d 00 00       	call   800e46 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 40 80 00    	pushl  0x804004
  80006a:	e8 ac 09 00 00       	call   800a1b <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 40 80 00    	pushl  0x804004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 be 0b 00 00       	call   800c44 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 d4 15 00 00       	call   80166b <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 58 15 00 00       	call   801602 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 e0 2b 80 00       	push   $0x802be0
  8000ba:	e8 36 02 00 00       	call   8002f5 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 40 80 00    	pushl  0x804000
  8000c8:	e8 4e 09 00 00       	call   800a1b <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 40 80 00    	pushl  0x804000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 44 0a 00 00       	call   800b25 <strncmp>
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
  8000fc:	e8 01 15 00 00       	call   801602 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 e0 2b 80 00       	push   $0x802be0
  800111:	e8 df 01 00 00       	call   8002f5 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 40 80 00    	pushl  0x804004
  80011f:	e8 f7 08 00 00       	call   800a1b <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 40 80 00    	pushl  0x804004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 ed 09 00 00       	call   800b25 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 40 80 00    	pushl  0x804000
  800148:	e8 ce 08 00 00       	call   800a1b <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 40 80 00    	pushl  0x804000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 e0 0a 00 00       	call   800c44 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 f6 14 00 00       	call   80166b <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 f4 2b 80 00       	push   $0x802bf4
  800185:	e8 6b 01 00 00       	call   8002f5 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 14 2c 80 00       	push   $0x802c14
  800197:	e8 59 01 00 00       	call   8002f5 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	57                   	push   %edi
  8001a8:	56                   	push   %esi
  8001a9:	53                   	push   %ebx
  8001aa:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001ad:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001b4:	00 00 00 
	envid_t find = sys_getenvid();
  8001b7:	e8 4c 0c 00 00       	call   800e08 <sys_getenvid>
  8001bc:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8001c2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001c7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001cc:	bf 01 00 00 00       	mov    $0x1,%edi
  8001d1:	eb 0b                	jmp    8001de <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001d3:	83 c2 01             	add    $0x1,%edx
  8001d6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001dc:	74 21                	je     8001ff <libmain+0x5b>
		if(envs[i].env_id == find)
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	c1 e1 07             	shl    $0x7,%ecx
  8001e3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001e9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001ec:	39 c1                	cmp    %eax,%ecx
  8001ee:	75 e3                	jne    8001d3 <libmain+0x2f>
  8001f0:	89 d3                	mov    %edx,%ebx
  8001f2:	c1 e3 07             	shl    $0x7,%ebx
  8001f5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001fb:	89 fe                	mov    %edi,%esi
  8001fd:	eb d4                	jmp    8001d3 <libmain+0x2f>
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	84 c0                	test   %al,%al
  800203:	74 06                	je     80020b <libmain+0x67>
  800205:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020f:	7e 0a                	jle    80021b <libmain+0x77>
		binaryname = argv[0];
  800211:	8b 45 0c             	mov    0xc(%ebp),%eax
  800214:	8b 00                	mov    (%eax),%eax
  800216:	a3 08 40 80 00       	mov    %eax,0x804008

	cprintf("in libmain.c call umain!\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 82 2c 80 00       	push   $0x802c82
  800223:	e8 cd 00 00 00       	call   8002f5 <cprintf>
	// call user main routine
	umain(argc, argv);
  800228:	83 c4 08             	add    $0x8,%esp
  80022b:	ff 75 0c             	pushl  0xc(%ebp)
  80022e:	ff 75 08             	pushl  0x8(%ebp)
  800231:	e8 fd fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800236:	e8 0b 00 00 00       	call   800246 <exit>
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
  800245:	c3                   	ret    

00800246 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80024c:	e8 85 16 00 00       	call   8018d6 <close_all>
	sys_env_destroy(0);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 00                	push   $0x0
  800256:	e8 6c 0b 00 00       	call   800dc7 <sys_env_destroy>
}
  80025b:	83 c4 10             	add    $0x10,%esp
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	53                   	push   %ebx
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80026a:	8b 13                	mov    (%ebx),%edx
  80026c:	8d 42 01             	lea    0x1(%edx),%eax
  80026f:	89 03                	mov    %eax,(%ebx)
  800271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800274:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800278:	3d ff 00 00 00       	cmp    $0xff,%eax
  80027d:	74 09                	je     800288 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80027f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800286:	c9                   	leave  
  800287:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	68 ff 00 00 00       	push   $0xff
  800290:	8d 43 08             	lea    0x8(%ebx),%eax
  800293:	50                   	push   %eax
  800294:	e8 f1 0a 00 00       	call   800d8a <sys_cputs>
		b->idx = 0;
  800299:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb db                	jmp    80027f <putch+0x1f>

008002a4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b4:	00 00 00 
	b.cnt = 0;
  8002b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002be:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c1:	ff 75 0c             	pushl  0xc(%ebp)
  8002c4:	ff 75 08             	pushl  0x8(%ebp)
  8002c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	68 60 02 80 00       	push   $0x800260
  8002d3:	e8 4a 01 00 00       	call   800422 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d8:	83 c4 08             	add    $0x8,%esp
  8002db:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 9d 0a 00 00       	call   800d8a <sys_cputs>

	return b.cnt;
}
  8002ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002fe:	50                   	push   %eax
  8002ff:	ff 75 08             	pushl  0x8(%ebp)
  800302:	e8 9d ff ff ff       	call   8002a4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	57                   	push   %edi
  80030d:	56                   	push   %esi
  80030e:	53                   	push   %ebx
  80030f:	83 ec 1c             	sub    $0x1c,%esp
  800312:	89 c6                	mov    %eax,%esi
  800314:	89 d7                	mov    %edx,%edi
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800322:	8b 45 10             	mov    0x10(%ebp),%eax
  800325:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800328:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80032c:	74 2c                	je     80035a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800338:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800343:	73 43                	jae    800388 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800345:	83 eb 01             	sub    $0x1,%ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7e 6c                	jle    8003b8 <printnum+0xaf>
				putch(padc, putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	57                   	push   %edi
  800350:	ff 75 18             	pushl  0x18(%ebp)
  800353:	ff d6                	call   *%esi
  800355:	83 c4 10             	add    $0x10,%esp
  800358:	eb eb                	jmp    800345 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	6a 20                	push   $0x20
  80035f:	6a 00                	push   $0x0
  800361:	50                   	push   %eax
  800362:	ff 75 e4             	pushl  -0x1c(%ebp)
  800365:	ff 75 e0             	pushl  -0x20(%ebp)
  800368:	89 fa                	mov    %edi,%edx
  80036a:	89 f0                	mov    %esi,%eax
  80036c:	e8 98 ff ff ff       	call   800309 <printnum>
		while (--width > 0)
  800371:	83 c4 20             	add    $0x20,%esp
  800374:	83 eb 01             	sub    $0x1,%ebx
  800377:	85 db                	test   %ebx,%ebx
  800379:	7e 65                	jle    8003e0 <printnum+0xd7>
			putch(padc, putdat);
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	57                   	push   %edi
  80037f:	6a 20                	push   $0x20
  800381:	ff d6                	call   *%esi
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	eb ec                	jmp    800374 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 18             	pushl  0x18(%ebp)
  80038e:	83 eb 01             	sub    $0x1,%ebx
  800391:	53                   	push   %ebx
  800392:	50                   	push   %eax
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	ff 75 dc             	pushl  -0x24(%ebp)
  800399:	ff 75 d8             	pushl  -0x28(%ebp)
  80039c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039f:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a2:	e8 e9 25 00 00       	call   802990 <__udivdi3>
  8003a7:	83 c4 18             	add    $0x18,%esp
  8003aa:	52                   	push   %edx
  8003ab:	50                   	push   %eax
  8003ac:	89 fa                	mov    %edi,%edx
  8003ae:	89 f0                	mov    %esi,%eax
  8003b0:	e8 54 ff ff ff       	call   800309 <printnum>
  8003b5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	57                   	push   %edi
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cb:	e8 d0 26 00 00       	call   802aa0 <__umoddi3>
  8003d0:	83 c4 14             	add    $0x14,%esp
  8003d3:	0f be 80 a6 2c 80 00 	movsbl 0x802ca6(%eax),%eax
  8003da:	50                   	push   %eax
  8003db:	ff d6                	call   *%esi
  8003dd:	83 c4 10             	add    $0x10,%esp
	}
}
  8003e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f7:	73 0a                	jae    800403 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fc:	89 08                	mov    %ecx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	88 02                	mov    %al,(%edx)
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <printfmt>:
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040e:	50                   	push   %eax
  80040f:	ff 75 10             	pushl  0x10(%ebp)
  800412:	ff 75 0c             	pushl  0xc(%ebp)
  800415:	ff 75 08             	pushl  0x8(%ebp)
  800418:	e8 05 00 00 00       	call   800422 <vprintfmt>
}
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <vprintfmt>:
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	57                   	push   %edi
  800426:	56                   	push   %esi
  800427:	53                   	push   %ebx
  800428:	83 ec 3c             	sub    $0x3c,%esp
  80042b:	8b 75 08             	mov    0x8(%ebp),%esi
  80042e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800431:	8b 7d 10             	mov    0x10(%ebp),%edi
  800434:	e9 32 04 00 00       	jmp    80086b <vprintfmt+0x449>
		padc = ' ';
  800439:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80043d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800444:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80044b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800452:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800459:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800460:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8d 47 01             	lea    0x1(%edi),%eax
  800468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046b:	0f b6 17             	movzbl (%edi),%edx
  80046e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800471:	3c 55                	cmp    $0x55,%al
  800473:	0f 87 12 05 00 00    	ja     80098b <vprintfmt+0x569>
  800479:	0f b6 c0             	movzbl %al,%eax
  80047c:	ff 24 85 80 2e 80 00 	jmp    *0x802e80(,%eax,4)
  800483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800486:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80048a:	eb d9                	jmp    800465 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80048f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800493:	eb d0                	jmp    800465 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800495:	0f b6 d2             	movzbl %dl,%edx
  800498:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a3:	eb 03                	jmp    8004a8 <vprintfmt+0x86>
  8004a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004b5:	83 fe 09             	cmp    $0x9,%esi
  8004b8:	76 eb                	jbe    8004a5 <vprintfmt+0x83>
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c0:	eb 14                	jmp    8004d6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8d 40 04             	lea    0x4(%eax),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004da:	79 89                	jns    800465 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e9:	e9 77 ff ff ff       	jmp    800465 <vprintfmt+0x43>
  8004ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	0f 48 c1             	cmovs  %ecx,%eax
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004fc:	e9 64 ff ff ff       	jmp    800465 <vprintfmt+0x43>
  800501:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800504:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80050b:	e9 55 ff ff ff       	jmp    800465 <vprintfmt+0x43>
			lflag++;
  800510:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800517:	e9 49 ff ff ff       	jmp    800465 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8d 78 04             	lea    0x4(%eax),%edi
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	ff 30                	pushl  (%eax)
  800528:	ff d6                	call   *%esi
			break;
  80052a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80052d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800530:	e9 33 03 00 00       	jmp    800868 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	8d 78 04             	lea    0x4(%eax),%edi
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	99                   	cltd   
  80053e:	31 d0                	xor    %edx,%eax
  800540:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800542:	83 f8 10             	cmp    $0x10,%eax
  800545:	7f 23                	jg     80056a <vprintfmt+0x148>
  800547:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  80054e:	85 d2                	test   %edx,%edx
  800550:	74 18                	je     80056a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800552:	52                   	push   %edx
  800553:	68 09 32 80 00       	push   $0x803209
  800558:	53                   	push   %ebx
  800559:	56                   	push   %esi
  80055a:	e8 a6 fe ff ff       	call   800405 <printfmt>
  80055f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800562:	89 7d 14             	mov    %edi,0x14(%ebp)
  800565:	e9 fe 02 00 00       	jmp    800868 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056a:	50                   	push   %eax
  80056b:	68 be 2c 80 00       	push   $0x802cbe
  800570:	53                   	push   %ebx
  800571:	56                   	push   %esi
  800572:	e8 8e fe ff ff       	call   800405 <printfmt>
  800577:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80057d:	e9 e6 02 00 00       	jmp    800868 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	83 c0 04             	add    $0x4,%eax
  800588:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800590:	85 c9                	test   %ecx,%ecx
  800592:	b8 b7 2c 80 00       	mov    $0x802cb7,%eax
  800597:	0f 45 c1             	cmovne %ecx,%eax
  80059a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80059d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a1:	7e 06                	jle    8005a9 <vprintfmt+0x187>
  8005a3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005a7:	75 0d                	jne    8005b6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ac:	89 c7                	mov    %eax,%edi
  8005ae:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b4:	eb 53                	jmp    800609 <vprintfmt+0x1e7>
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8005bc:	50                   	push   %eax
  8005bd:	e8 71 04 00 00       	call   800a33 <strnlen>
  8005c2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c5:	29 c1                	sub    %eax,%ecx
  8005c7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005cf:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d6:	eb 0f                	jmp    8005e7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e1:	83 ef 01             	sub    $0x1,%edi
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	85 ff                	test   %edi,%edi
  8005e9:	7f ed                	jg     8005d8 <vprintfmt+0x1b6>
  8005eb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ee:	85 c9                	test   %ecx,%ecx
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	0f 49 c1             	cmovns %ecx,%eax
  8005f8:	29 c1                	sub    %eax,%ecx
  8005fa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005fd:	eb aa                	jmp    8005a9 <vprintfmt+0x187>
					putch(ch, putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	52                   	push   %edx
  800604:	ff d6                	call   *%esi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060e:	83 c7 01             	add    $0x1,%edi
  800611:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800615:	0f be d0             	movsbl %al,%edx
  800618:	85 d2                	test   %edx,%edx
  80061a:	74 4b                	je     800667 <vprintfmt+0x245>
  80061c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800620:	78 06                	js     800628 <vprintfmt+0x206>
  800622:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800626:	78 1e                	js     800646 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800628:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80062c:	74 d1                	je     8005ff <vprintfmt+0x1dd>
  80062e:	0f be c0             	movsbl %al,%eax
  800631:	83 e8 20             	sub    $0x20,%eax
  800634:	83 f8 5e             	cmp    $0x5e,%eax
  800637:	76 c6                	jbe    8005ff <vprintfmt+0x1dd>
					putch('?', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 3f                	push   $0x3f
  80063f:	ff d6                	call   *%esi
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	eb c3                	jmp    800609 <vprintfmt+0x1e7>
  800646:	89 cf                	mov    %ecx,%edi
  800648:	eb 0e                	jmp    800658 <vprintfmt+0x236>
				putch(' ', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 20                	push   $0x20
  800650:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800652:	83 ef 01             	sub    $0x1,%edi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	85 ff                	test   %edi,%edi
  80065a:	7f ee                	jg     80064a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	e9 01 02 00 00       	jmp    800868 <vprintfmt+0x446>
  800667:	89 cf                	mov    %ecx,%edi
  800669:	eb ed                	jmp    800658 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80066e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800675:	e9 eb fd ff ff       	jmp    800465 <vprintfmt+0x43>
	if (lflag >= 2)
  80067a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067e:	7f 21                	jg     8006a1 <vprintfmt+0x27f>
	else if (lflag)
  800680:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800684:	74 68                	je     8006ee <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80068e:	89 c1                	mov    %eax,%ecx
  800690:	c1 f9 1f             	sar    $0x1f,%ecx
  800693:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	eb 17                	jmp    8006b8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 50 04             	mov    0x4(%eax),%edx
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 40 08             	lea    0x8(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c8:	78 3f                	js     800709 <vprintfmt+0x2e7>
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006cf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006d3:	0f 84 71 01 00 00    	je     80084a <vprintfmt+0x428>
				putch('+', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 2b                	push   $0x2b
  8006df:	ff d6                	call   *%esi
  8006e1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	e9 5c 01 00 00       	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f6:	89 c1                	mov    %eax,%ecx
  8006f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
  800707:	eb af                	jmp    8006b8 <vprintfmt+0x296>
				putch('-', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 2d                	push   $0x2d
  80070f:	ff d6                	call   *%esi
				num = -(long long) num;
  800711:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800714:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800717:	f7 d8                	neg    %eax
  800719:	83 d2 00             	adc    $0x0,%edx
  80071c:	f7 da                	neg    %edx
  80071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800724:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072c:	e9 19 01 00 00       	jmp    80084a <vprintfmt+0x428>
	if (lflag >= 2)
  800731:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800735:	7f 29                	jg     800760 <vprintfmt+0x33e>
	else if (lflag)
  800737:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073b:	74 44                	je     800781 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800756:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075b:	e9 ea 00 00 00       	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 50 04             	mov    0x4(%eax),%edx
  800766:	8b 00                	mov    (%eax),%eax
  800768:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 08             	lea    0x8(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800777:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077c:	e9 c9 00 00 00       	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079f:	e9 a6 00 00 00       	jmp    80084a <vprintfmt+0x428>
			putch('0', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	6a 30                	push   $0x30
  8007aa:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b3:	7f 26                	jg     8007db <vprintfmt+0x3b9>
	else if (lflag)
  8007b5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b9:	74 3e                	je     8007f9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d9:	eb 6f                	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 50 04             	mov    0x4(%eax),%edx
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8d 40 08             	lea    0x8(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f7:	eb 51                	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800812:	b8 08 00 00 00       	mov    $0x8,%eax
  800817:	eb 31                	jmp    80084a <vprintfmt+0x428>
			putch('0', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 30                	push   $0x30
  80081f:	ff d6                	call   *%esi
			putch('x', putdat);
  800821:	83 c4 08             	add    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	6a 78                	push   $0x78
  800827:	ff d6                	call   *%esi
			num = (unsigned long long)
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	ba 00 00 00 00       	mov    $0x0,%edx
  800833:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800836:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800839:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 40 04             	lea    0x4(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800845:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80084a:	83 ec 0c             	sub    $0xc,%esp
  80084d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800851:	52                   	push   %edx
  800852:	ff 75 e0             	pushl  -0x20(%ebp)
  800855:	50                   	push   %eax
  800856:	ff 75 dc             	pushl  -0x24(%ebp)
  800859:	ff 75 d8             	pushl  -0x28(%ebp)
  80085c:	89 da                	mov    %ebx,%edx
  80085e:	89 f0                	mov    %esi,%eax
  800860:	e8 a4 fa ff ff       	call   800309 <printnum>
			break;
  800865:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800868:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086b:	83 c7 01             	add    $0x1,%edi
  80086e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800872:	83 f8 25             	cmp    $0x25,%eax
  800875:	0f 84 be fb ff ff    	je     800439 <vprintfmt+0x17>
			if (ch == '\0')
  80087b:	85 c0                	test   %eax,%eax
  80087d:	0f 84 28 01 00 00    	je     8009ab <vprintfmt+0x589>
			putch(ch, putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	50                   	push   %eax
  800888:	ff d6                	call   *%esi
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	eb dc                	jmp    80086b <vprintfmt+0x449>
	if (lflag >= 2)
  80088f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800893:	7f 26                	jg     8008bb <vprintfmt+0x499>
	else if (lflag)
  800895:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800899:	74 41                	je     8008dc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8d 40 04             	lea    0x4(%eax),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b4:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b9:	eb 8f                	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 08             	lea    0x8(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d2:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d7:	e9 6e ff ff ff       	jmp    80084a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8d 40 04             	lea    0x4(%eax),%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008fa:	e9 4b ff ff ff       	jmp    80084a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 c0 04             	add    $0x4,%eax
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	85 c0                	test   %eax,%eax
  80090f:	74 14                	je     800925 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800911:	8b 13                	mov    (%ebx),%edx
  800913:	83 fa 7f             	cmp    $0x7f,%edx
  800916:	7f 37                	jg     80094f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800918:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80091a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	e9 43 ff ff ff       	jmp    800868 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800925:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092a:	bf dd 2d 80 00       	mov    $0x802ddd,%edi
							putch(ch, putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	53                   	push   %ebx
  800933:	50                   	push   %eax
  800934:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800936:	83 c7 01             	add    $0x1,%edi
  800939:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80093d:	83 c4 10             	add    $0x10,%esp
  800940:	85 c0                	test   %eax,%eax
  800942:	75 eb                	jne    80092f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800944:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
  80094a:	e9 19 ff ff ff       	jmp    800868 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80094f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800951:	b8 0a 00 00 00       	mov    $0xa,%eax
  800956:	bf 15 2e 80 00       	mov    $0x802e15,%edi
							putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	53                   	push   %ebx
  80095f:	50                   	push   %eax
  800960:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800962:	83 c7 01             	add    $0x1,%edi
  800965:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	85 c0                	test   %eax,%eax
  80096e:	75 eb                	jne    80095b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800970:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
  800976:	e9 ed fe ff ff       	jmp    800868 <vprintfmt+0x446>
			putch(ch, putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	53                   	push   %ebx
  80097f:	6a 25                	push   $0x25
  800981:	ff d6                	call   *%esi
			break;
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	e9 dd fe ff ff       	jmp    800868 <vprintfmt+0x446>
			putch('%', putdat);
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	53                   	push   %ebx
  80098f:	6a 25                	push   $0x25
  800991:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800993:	83 c4 10             	add    $0x10,%esp
  800996:	89 f8                	mov    %edi,%eax
  800998:	eb 03                	jmp    80099d <vprintfmt+0x57b>
  80099a:	83 e8 01             	sub    $0x1,%eax
  80099d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a1:	75 f7                	jne    80099a <vprintfmt+0x578>
  8009a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a6:	e9 bd fe ff ff       	jmp    800868 <vprintfmt+0x446>
}
  8009ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ae:	5b                   	pop    %ebx
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	83 ec 18             	sub    $0x18,%esp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	74 26                	je     8009fa <vsnprintf+0x47>
  8009d4:	85 d2                	test   %edx,%edx
  8009d6:	7e 22                	jle    8009fa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d8:	ff 75 14             	pushl  0x14(%ebp)
  8009db:	ff 75 10             	pushl  0x10(%ebp)
  8009de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e1:	50                   	push   %eax
  8009e2:	68 e8 03 80 00       	push   $0x8003e8
  8009e7:	e8 36 fa ff ff       	call   800422 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
}
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    
		return -E_INVAL;
  8009fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ff:	eb f7                	jmp    8009f8 <vsnprintf+0x45>

00800a01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a07:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 10             	pushl  0x10(%ebp)
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 9a ff ff ff       	call   8009b3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
  800a26:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a2a:	74 05                	je     800a31 <strlen+0x16>
		n++;
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f5                	jmp    800a26 <strlen+0xb>
	return n;
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 0d                	je     800a52 <strnlen+0x1f>
  800a45:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a49:	74 05                	je     800a50 <strnlen+0x1d>
		n++;
  800a4b:	83 c2 01             	add    $0x1,%edx
  800a4e:	eb f1                	jmp    800a41 <strnlen+0xe>
  800a50:	89 d0                	mov    %edx,%eax
	return n;
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a63:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a67:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a6a:	83 c2 01             	add    $0x1,%edx
  800a6d:	84 c9                	test   %cl,%cl
  800a6f:	75 f2                	jne    800a63 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a71:	5b                   	pop    %ebx
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	53                   	push   %ebx
  800a78:	83 ec 10             	sub    $0x10,%esp
  800a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a7e:	53                   	push   %ebx
  800a7f:	e8 97 ff ff ff       	call   800a1b <strlen>
  800a84:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	01 d8                	add    %ebx,%eax
  800a8c:	50                   	push   %eax
  800a8d:	e8 c2 ff ff ff       	call   800a54 <strcpy>
	return dst;
}
  800a92:	89 d8                	mov    %ebx,%eax
  800a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa4:	89 c6                	mov    %eax,%esi
  800aa6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa9:	89 c2                	mov    %eax,%edx
  800aab:	39 f2                	cmp    %esi,%edx
  800aad:	74 11                	je     800ac0 <strncpy+0x27>
		*dst++ = *src;
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab8:	80 fb 01             	cmp    $0x1,%bl
  800abb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800abe:	eb eb                	jmp    800aab <strncpy+0x12>
	}
	return ret;
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 75 08             	mov    0x8(%ebp),%esi
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acf:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad4:	85 d2                	test   %edx,%edx
  800ad6:	74 21                	je     800af9 <strlcpy+0x35>
  800ad8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800adc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ade:	39 c2                	cmp    %eax,%edx
  800ae0:	74 14                	je     800af6 <strlcpy+0x32>
  800ae2:	0f b6 19             	movzbl (%ecx),%ebx
  800ae5:	84 db                	test   %bl,%bl
  800ae7:	74 0b                	je     800af4 <strlcpy+0x30>
			*dst++ = *src++;
  800ae9:	83 c1 01             	add    $0x1,%ecx
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	88 5a ff             	mov    %bl,-0x1(%edx)
  800af2:	eb ea                	jmp    800ade <strlcpy+0x1a>
  800af4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af9:	29 f0                	sub    %esi,%eax
}
  800afb:	5b                   	pop    %ebx
  800afc:	5e                   	pop    %esi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b05:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b08:	0f b6 01             	movzbl (%ecx),%eax
  800b0b:	84 c0                	test   %al,%al
  800b0d:	74 0c                	je     800b1b <strcmp+0x1c>
  800b0f:	3a 02                	cmp    (%edx),%al
  800b11:	75 08                	jne    800b1b <strcmp+0x1c>
		p++, q++;
  800b13:	83 c1 01             	add    $0x1,%ecx
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	eb ed                	jmp    800b08 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1b:	0f b6 c0             	movzbl %al,%eax
  800b1e:	0f b6 12             	movzbl (%edx),%edx
  800b21:	29 d0                	sub    %edx,%eax
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	53                   	push   %ebx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2f:	89 c3                	mov    %eax,%ebx
  800b31:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b34:	eb 06                	jmp    800b3c <strncmp+0x17>
		n--, p++, q++;
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b3c:	39 d8                	cmp    %ebx,%eax
  800b3e:	74 16                	je     800b56 <strncmp+0x31>
  800b40:	0f b6 08             	movzbl (%eax),%ecx
  800b43:	84 c9                	test   %cl,%cl
  800b45:	74 04                	je     800b4b <strncmp+0x26>
  800b47:	3a 0a                	cmp    (%edx),%cl
  800b49:	74 eb                	je     800b36 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4b:	0f b6 00             	movzbl (%eax),%eax
  800b4e:	0f b6 12             	movzbl (%edx),%edx
  800b51:	29 d0                	sub    %edx,%eax
}
  800b53:	5b                   	pop    %ebx
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    
		return 0;
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	eb f6                	jmp    800b53 <strncmp+0x2e>

00800b5d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b67:	0f b6 10             	movzbl (%eax),%edx
  800b6a:	84 d2                	test   %dl,%dl
  800b6c:	74 09                	je     800b77 <strchr+0x1a>
		if (*s == c)
  800b6e:	38 ca                	cmp    %cl,%dl
  800b70:	74 0a                	je     800b7c <strchr+0x1f>
	for (; *s; s++)
  800b72:	83 c0 01             	add    $0x1,%eax
  800b75:	eb f0                	jmp    800b67 <strchr+0xa>
			return (char *) s;
	return 0;
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b88:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8b:	38 ca                	cmp    %cl,%dl
  800b8d:	74 09                	je     800b98 <strfind+0x1a>
  800b8f:	84 d2                	test   %dl,%dl
  800b91:	74 05                	je     800b98 <strfind+0x1a>
	for (; *s; s++)
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	eb f0                	jmp    800b88 <strfind+0xa>
			break;
	return (char *) s;
}
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	57                   	push   %edi
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba6:	85 c9                	test   %ecx,%ecx
  800ba8:	74 31                	je     800bdb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800baa:	89 f8                	mov    %edi,%eax
  800bac:	09 c8                	or     %ecx,%eax
  800bae:	a8 03                	test   $0x3,%al
  800bb0:	75 23                	jne    800bd5 <memset+0x3b>
		c &= 0xFF;
  800bb2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb6:	89 d3                	mov    %edx,%ebx
  800bb8:	c1 e3 08             	shl    $0x8,%ebx
  800bbb:	89 d0                	mov    %edx,%eax
  800bbd:	c1 e0 18             	shl    $0x18,%eax
  800bc0:	89 d6                	mov    %edx,%esi
  800bc2:	c1 e6 10             	shl    $0x10,%esi
  800bc5:	09 f0                	or     %esi,%eax
  800bc7:	09 c2                	or     %eax,%edx
  800bc9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	fc                   	cld    
  800bd1:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd3:	eb 06                	jmp    800bdb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	fc                   	cld    
  800bd9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdb:	89 f8                	mov    %edi,%eax
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf0:	39 c6                	cmp    %eax,%esi
  800bf2:	73 32                	jae    800c26 <memmove+0x44>
  800bf4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf7:	39 c2                	cmp    %eax,%edx
  800bf9:	76 2b                	jbe    800c26 <memmove+0x44>
		s += n;
		d += n;
  800bfb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfe:	89 fe                	mov    %edi,%esi
  800c00:	09 ce                	or     %ecx,%esi
  800c02:	09 d6                	or     %edx,%esi
  800c04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0a:	75 0e                	jne    800c1a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0c:	83 ef 04             	sub    $0x4,%edi
  800c0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c15:	fd                   	std    
  800c16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c18:	eb 09                	jmp    800c23 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1a:	83 ef 01             	sub    $0x1,%edi
  800c1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c20:	fd                   	std    
  800c21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c23:	fc                   	cld    
  800c24:	eb 1a                	jmp    800c40 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c26:	89 c2                	mov    %eax,%edx
  800c28:	09 ca                	or     %ecx,%edx
  800c2a:	09 f2                	or     %esi,%edx
  800c2c:	f6 c2 03             	test   $0x3,%dl
  800c2f:	75 0a                	jne    800c3b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c34:	89 c7                	mov    %eax,%edi
  800c36:	fc                   	cld    
  800c37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c39:	eb 05                	jmp    800c40 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c3b:	89 c7                	mov    %eax,%edi
  800c3d:	fc                   	cld    
  800c3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c4a:	ff 75 10             	pushl  0x10(%ebp)
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	ff 75 08             	pushl  0x8(%ebp)
  800c53:	e8 8a ff ff ff       	call   800be2 <memmove>
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 c6                	mov    %eax,%esi
  800c67:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6a:	39 f0                	cmp    %esi,%eax
  800c6c:	74 1c                	je     800c8a <memcmp+0x30>
		if (*s1 != *s2)
  800c6e:	0f b6 08             	movzbl (%eax),%ecx
  800c71:	0f b6 1a             	movzbl (%edx),%ebx
  800c74:	38 d9                	cmp    %bl,%cl
  800c76:	75 08                	jne    800c80 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c78:	83 c0 01             	add    $0x1,%eax
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	eb ea                	jmp    800c6a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c80:	0f b6 c1             	movzbl %cl,%eax
  800c83:	0f b6 db             	movzbl %bl,%ebx
  800c86:	29 d8                	sub    %ebx,%eax
  800c88:	eb 05                	jmp    800c8f <memcmp+0x35>
	}

	return 0;
  800c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c9c:	89 c2                	mov    %eax,%edx
  800c9e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ca1:	39 d0                	cmp    %edx,%eax
  800ca3:	73 09                	jae    800cae <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca5:	38 08                	cmp    %cl,(%eax)
  800ca7:	74 05                	je     800cae <memfind+0x1b>
	for (; s < ends; s++)
  800ca9:	83 c0 01             	add    $0x1,%eax
  800cac:	eb f3                	jmp    800ca1 <memfind+0xe>
			break;
	return (void *) s;
}
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbc:	eb 03                	jmp    800cc1 <strtol+0x11>
		s++;
  800cbe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cc1:	0f b6 01             	movzbl (%ecx),%eax
  800cc4:	3c 20                	cmp    $0x20,%al
  800cc6:	74 f6                	je     800cbe <strtol+0xe>
  800cc8:	3c 09                	cmp    $0x9,%al
  800cca:	74 f2                	je     800cbe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ccc:	3c 2b                	cmp    $0x2b,%al
  800cce:	74 2a                	je     800cfa <strtol+0x4a>
	int neg = 0;
  800cd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd5:	3c 2d                	cmp    $0x2d,%al
  800cd7:	74 2b                	je     800d04 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cdf:	75 0f                	jne    800cf0 <strtol+0x40>
  800ce1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce4:	74 28                	je     800d0e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce6:	85 db                	test   %ebx,%ebx
  800ce8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ced:	0f 44 d8             	cmove  %eax,%ebx
  800cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf8:	eb 50                	jmp    800d4a <strtol+0x9a>
		s++;
  800cfa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  800d02:	eb d5                	jmp    800cd9 <strtol+0x29>
		s++, neg = 1;
  800d04:	83 c1 01             	add    $0x1,%ecx
  800d07:	bf 01 00 00 00       	mov    $0x1,%edi
  800d0c:	eb cb                	jmp    800cd9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d12:	74 0e                	je     800d22 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d14:	85 db                	test   %ebx,%ebx
  800d16:	75 d8                	jne    800cf0 <strtol+0x40>
		s++, base = 8;
  800d18:	83 c1 01             	add    $0x1,%ecx
  800d1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d20:	eb ce                	jmp    800cf0 <strtol+0x40>
		s += 2, base = 16;
  800d22:	83 c1 02             	add    $0x2,%ecx
  800d25:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d2a:	eb c4                	jmp    800cf0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d2c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2f:	89 f3                	mov    %esi,%ebx
  800d31:	80 fb 19             	cmp    $0x19,%bl
  800d34:	77 29                	ja     800d5f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d36:	0f be d2             	movsbl %dl,%edx
  800d39:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d3c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3f:	7d 30                	jge    800d71 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d48:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4a:	0f b6 11             	movzbl (%ecx),%edx
  800d4d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d50:	89 f3                	mov    %esi,%ebx
  800d52:	80 fb 09             	cmp    $0x9,%bl
  800d55:	77 d5                	ja     800d2c <strtol+0x7c>
			dig = *s - '0';
  800d57:	0f be d2             	movsbl %dl,%edx
  800d5a:	83 ea 30             	sub    $0x30,%edx
  800d5d:	eb dd                	jmp    800d3c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d5f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d62:	89 f3                	mov    %esi,%ebx
  800d64:	80 fb 19             	cmp    $0x19,%bl
  800d67:	77 08                	ja     800d71 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d69:	0f be d2             	movsbl %dl,%edx
  800d6c:	83 ea 37             	sub    $0x37,%edx
  800d6f:	eb cb                	jmp    800d3c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d75:	74 05                	je     800d7c <strtol+0xcc>
		*endptr = (char *) s;
  800d77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d7c:	89 c2                	mov    %eax,%edx
  800d7e:	f7 da                	neg    %edx
  800d80:	85 ff                	test   %edi,%edi
  800d82:	0f 45 c2             	cmovne %edx,%eax
}
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	89 c3                	mov    %eax,%ebx
  800d9d:	89 c7                	mov    %eax,%edi
  800d9f:	89 c6                	mov    %eax,%esi
  800da1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	b8 01 00 00 00       	mov    $0x1,%eax
  800db8:	89 d1                	mov    %edx,%ecx
  800dba:	89 d3                	mov    %edx,%ebx
  800dbc:	89 d7                	mov    %edx,%edi
  800dbe:	89 d6                	mov    %edx,%esi
  800dc0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddd:	89 cb                	mov    %ecx,%ebx
  800ddf:	89 cf                	mov    %ecx,%edi
  800de1:	89 ce                	mov    %ecx,%esi
  800de3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7f 08                	jg     800df1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df1:	83 ec 0c             	sub    $0xc,%esp
  800df4:	50                   	push   %eax
  800df5:	6a 03                	push   $0x3
  800df7:	68 24 30 80 00       	push   $0x803024
  800dfc:	6a 43                	push   $0x43
  800dfe:	68 41 30 80 00       	push   $0x803041
  800e03:	e8 4c 1a 00 00       	call   802854 <_panic>

00800e08 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e13:	b8 02 00 00 00       	mov    $0x2,%eax
  800e18:	89 d1                	mov    %edx,%ecx
  800e1a:	89 d3                	mov    %edx,%ebx
  800e1c:	89 d7                	mov    %edx,%edi
  800e1e:	89 d6                	mov    %edx,%esi
  800e20:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_yield>:

void
sys_yield(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e37:	89 d1                	mov    %edx,%ecx
  800e39:	89 d3                	mov    %edx,%ebx
  800e3b:	89 d7                	mov    %edx,%edi
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	be 00 00 00 00       	mov    $0x0,%esi
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e62:	89 f7                	mov    %esi,%edi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 04                	push   $0x4
  800e78:	68 24 30 80 00       	push   $0x803024
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 41 30 80 00       	push   $0x803041
  800e84:	e8 cb 19 00 00       	call   802854 <_panic>

00800e89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	b8 05 00 00 00       	mov    $0x5,%eax
  800e9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ea6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7f 08                	jg     800eb4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 05                	push   $0x5
  800eba:	68 24 30 80 00       	push   $0x803024
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 41 30 80 00       	push   $0x803041
  800ec6:	e8 89 19 00 00       	call   802854 <_panic>

00800ecb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	b8 06 00 00 00       	mov    $0x6,%eax
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7f 08                	jg     800ef6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 06                	push   $0x6
  800efc:	68 24 30 80 00       	push   $0x803024
  800f01:	6a 43                	push   $0x43
  800f03:	68 41 30 80 00       	push   $0x803041
  800f08:	e8 47 19 00 00       	call   802854 <_panic>

00800f0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	b8 08 00 00 00       	mov    $0x8,%eax
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7f 08                	jg     800f38 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	50                   	push   %eax
  800f3c:	6a 08                	push   $0x8
  800f3e:	68 24 30 80 00       	push   $0x803024
  800f43:	6a 43                	push   $0x43
  800f45:	68 41 30 80 00       	push   $0x803041
  800f4a:	e8 05 19 00 00       	call   802854 <_panic>

00800f4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	b8 09 00 00 00       	mov    $0x9,%eax
  800f68:	89 df                	mov    %ebx,%edi
  800f6a:	89 de                	mov    %ebx,%esi
  800f6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	7f 08                	jg     800f7a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	50                   	push   %eax
  800f7e:	6a 09                	push   $0x9
  800f80:	68 24 30 80 00       	push   $0x803024
  800f85:	6a 43                	push   $0x43
  800f87:	68 41 30 80 00       	push   $0x803041
  800f8c:	e8 c3 18 00 00       	call   802854 <_panic>

00800f91 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7f 08                	jg     800fbc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	6a 0a                	push   $0xa
  800fc2:	68 24 30 80 00       	push   $0x803024
  800fc7:	6a 43                	push   $0x43
  800fc9:	68 41 30 80 00       	push   $0x803041
  800fce:	e8 81 18 00 00       	call   802854 <_panic>

00800fd3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fe4:	be 00 00 00 00       	mov    $0x0,%esi
  800fe9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fec:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fef:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	b8 0d 00 00 00       	mov    $0xd,%eax
  80100c:	89 cb                	mov    %ecx,%ebx
  80100e:	89 cf                	mov    %ecx,%edi
  801010:	89 ce                	mov    %ecx,%esi
  801012:	cd 30                	int    $0x30
	if(check && ret > 0)
  801014:	85 c0                	test   %eax,%eax
  801016:	7f 08                	jg     801020 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  801024:	6a 0d                	push   $0xd
  801026:	68 24 30 80 00       	push   $0x803024
  80102b:	6a 43                	push   $0x43
  80102d:	68 41 30 80 00       	push   $0x803041
  801032:	e8 1d 18 00 00       	call   802854 <_panic>

00801037 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801042:	8b 55 08             	mov    0x8(%ebp),%edx
  801045:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801048:	b8 0e 00 00 00       	mov    $0xe,%eax
  80104d:	89 df                	mov    %ebx,%edi
  80104f:	89 de                	mov    %ebx,%esi
  801051:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801053:	5b                   	pop    %ebx
  801054:	5e                   	pop    %esi
  801055:	5f                   	pop    %edi
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	b8 0f 00 00 00       	mov    $0xf,%eax
  80106b:	89 cb                	mov    %ecx,%ebx
  80106d:	89 cf                	mov    %ecx,%edi
  80106f:	89 ce                	mov    %ecx,%esi
  801071:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107e:	ba 00 00 00 00       	mov    $0x0,%edx
  801083:	b8 10 00 00 00       	mov    $0x10,%eax
  801088:	89 d1                	mov    %edx,%ecx
  80108a:	89 d3                	mov    %edx,%ebx
  80108c:	89 d7                	mov    %edx,%edi
  80108e:	89 d6                	mov    %edx,%esi
  801090:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5f                   	pop    %edi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a8:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ad:	89 df                	mov    %ebx,%edi
  8010af:	89 de                	mov    %ebx,%esi
  8010b1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010b3:	5b                   	pop    %ebx
  8010b4:	5e                   	pop    %esi
  8010b5:	5f                   	pop    %edi
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	b8 12 00 00 00       	mov    $0x12,%eax
  8010ce:	89 df                	mov    %ebx,%edi
  8010d0:	89 de                	mov    %ebx,%esi
  8010d2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ed:	b8 13 00 00 00       	mov    $0x13,%eax
  8010f2:	89 df                	mov    %ebx,%edi
  8010f4:	89 de                	mov    %ebx,%esi
  8010f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	7f 08                	jg     801104 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5f                   	pop    %edi
  801102:	5d                   	pop    %ebp
  801103:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	50                   	push   %eax
  801108:	6a 13                	push   $0x13
  80110a:	68 24 30 80 00       	push   $0x803024
  80110f:	6a 43                	push   $0x43
  801111:	68 41 30 80 00       	push   $0x803041
  801116:	e8 39 17 00 00       	call   802854 <_panic>

0080111b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	53                   	push   %ebx
  80111f:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801122:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801129:	f6 c5 04             	test   $0x4,%ch
  80112c:	75 45                	jne    801173 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80112e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801135:	83 e1 07             	and    $0x7,%ecx
  801138:	83 f9 07             	cmp    $0x7,%ecx
  80113b:	74 6f                	je     8011ac <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80113d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801144:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80114a:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801150:	0f 84 b6 00 00 00    	je     80120c <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801156:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80115d:	83 e1 05             	and    $0x5,%ecx
  801160:	83 f9 05             	cmp    $0x5,%ecx
  801163:	0f 84 d7 00 00 00    	je     801240 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
  80116e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801171:	c9                   	leave  
  801172:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801173:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80117a:	c1 e2 0c             	shl    $0xc,%edx
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801186:	51                   	push   %ecx
  801187:	52                   	push   %edx
  801188:	50                   	push   %eax
  801189:	52                   	push   %edx
  80118a:	6a 00                	push   $0x0
  80118c:	e8 f8 fc ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  801191:	83 c4 20             	add    $0x20,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	79 d1                	jns    801169 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	68 4f 30 80 00       	push   $0x80304f
  8011a0:	6a 54                	push   $0x54
  8011a2:	68 65 30 80 00       	push   $0x803065
  8011a7:	e8 a8 16 00 00       	call   802854 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ac:	89 d3                	mov    %edx,%ebx
  8011ae:	c1 e3 0c             	shl    $0xc,%ebx
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 05 08 00 00       	push   $0x805
  8011b9:	53                   	push   %ebx
  8011ba:	50                   	push   %eax
  8011bb:	53                   	push   %ebx
  8011bc:	6a 00                	push   $0x0
  8011be:	e8 c6 fc ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  8011c3:	83 c4 20             	add    $0x20,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	78 2e                	js     8011f8 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	68 05 08 00 00       	push   $0x805
  8011d2:	53                   	push   %ebx
  8011d3:	6a 00                	push   $0x0
  8011d5:	53                   	push   %ebx
  8011d6:	6a 00                	push   $0x0
  8011d8:	e8 ac fc ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  8011dd:	83 c4 20             	add    $0x20,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 85                	jns    801169 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 4f 30 80 00       	push   $0x80304f
  8011ec:	6a 5f                	push   $0x5f
  8011ee:	68 65 30 80 00       	push   $0x803065
  8011f3:	e8 5c 16 00 00       	call   802854 <_panic>
			panic("sys_page_map() panic\n");
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	68 4f 30 80 00       	push   $0x80304f
  801200:	6a 5b                	push   $0x5b
  801202:	68 65 30 80 00       	push   $0x803065
  801207:	e8 48 16 00 00       	call   802854 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80120c:	c1 e2 0c             	shl    $0xc,%edx
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	68 05 08 00 00       	push   $0x805
  801217:	52                   	push   %edx
  801218:	50                   	push   %eax
  801219:	52                   	push   %edx
  80121a:	6a 00                	push   $0x0
  80121c:	e8 68 fc ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  801221:	83 c4 20             	add    $0x20,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	0f 89 3d ff ff ff    	jns    801169 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	68 4f 30 80 00       	push   $0x80304f
  801234:	6a 66                	push   $0x66
  801236:	68 65 30 80 00       	push   $0x803065
  80123b:	e8 14 16 00 00       	call   802854 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801240:	c1 e2 0c             	shl    $0xc,%edx
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	6a 05                	push   $0x5
  801248:	52                   	push   %edx
  801249:	50                   	push   %eax
  80124a:	52                   	push   %edx
  80124b:	6a 00                	push   $0x0
  80124d:	e8 37 fc ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  801252:	83 c4 20             	add    $0x20,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	0f 89 0c ff ff ff    	jns    801169 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	68 4f 30 80 00       	push   $0x80304f
  801265:	6a 6d                	push   $0x6d
  801267:	68 65 30 80 00       	push   $0x803065
  80126c:	e8 e3 15 00 00       	call   802854 <_panic>

00801271 <pgfault>:
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	53                   	push   %ebx
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80127b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80127d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801281:	0f 84 99 00 00 00    	je     801320 <pgfault+0xaf>
  801287:	89 c2                	mov    %eax,%edx
  801289:	c1 ea 16             	shr    $0x16,%edx
  80128c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801293:	f6 c2 01             	test   $0x1,%dl
  801296:	0f 84 84 00 00 00    	je     801320 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80129c:	89 c2                	mov    %eax,%edx
  80129e:	c1 ea 0c             	shr    $0xc,%edx
  8012a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012a8:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ae:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012b4:	75 6a                	jne    801320 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012bb:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	6a 07                	push   $0x7
  8012c2:	68 00 f0 7f 00       	push   $0x7ff000
  8012c7:	6a 00                	push   $0x0
  8012c9:	e8 78 fb ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 5f                	js     801334 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 00 10 00 00       	push   $0x1000
  8012dd:	53                   	push   %ebx
  8012de:	68 00 f0 7f 00       	push   $0x7ff000
  8012e3:	e8 5c f9 ff ff       	call   800c44 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012e8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012ef:	53                   	push   %ebx
  8012f0:	6a 00                	push   $0x0
  8012f2:	68 00 f0 7f 00       	push   $0x7ff000
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 8b fb ff ff       	call   800e89 <sys_page_map>
	if(ret < 0)
  8012fe:	83 c4 20             	add    $0x20,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 43                	js     801348 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	68 00 f0 7f 00       	push   $0x7ff000
  80130d:	6a 00                	push   $0x0
  80130f:	e8 b7 fb ff ff       	call   800ecb <sys_page_unmap>
	if(ret < 0)
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 41                	js     80135c <pgfault+0xeb>
}
  80131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	68 70 30 80 00       	push   $0x803070
  801328:	6a 26                	push   $0x26
  80132a:	68 65 30 80 00       	push   $0x803065
  80132f:	e8 20 15 00 00       	call   802854 <_panic>
		panic("panic in sys_page_alloc()\n");
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 84 30 80 00       	push   $0x803084
  80133c:	6a 31                	push   $0x31
  80133e:	68 65 30 80 00       	push   $0x803065
  801343:	e8 0c 15 00 00       	call   802854 <_panic>
		panic("panic in sys_page_map()\n");
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	68 9f 30 80 00       	push   $0x80309f
  801350:	6a 36                	push   $0x36
  801352:	68 65 30 80 00       	push   $0x803065
  801357:	e8 f8 14 00 00       	call   802854 <_panic>
		panic("panic in sys_page_unmap()\n");
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	68 b8 30 80 00       	push   $0x8030b8
  801364:	6a 39                	push   $0x39
  801366:	68 65 30 80 00       	push   $0x803065
  80136b:	e8 e4 14 00 00       	call   802854 <_panic>

00801370 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801379:	68 71 12 80 00       	push   $0x801271
  80137e:	e8 32 15 00 00       	call   8028b5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801383:	b8 07 00 00 00       	mov    $0x7,%eax
  801388:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 27                	js     8013b8 <fork+0x48>
  801391:	89 c6                	mov    %eax,%esi
  801393:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801395:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80139a:	75 48                	jne    8013e4 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80139c:	e8 67 fa ff ff       	call   800e08 <sys_getenvid>
  8013a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013a6:	c1 e0 07             	shl    $0x7,%eax
  8013a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ae:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013b3:	e9 90 00 00 00       	jmp    801448 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	68 d4 30 80 00       	push   $0x8030d4
  8013c0:	68 8c 00 00 00       	push   $0x8c
  8013c5:	68 65 30 80 00       	push   $0x803065
  8013ca:	e8 85 14 00 00       	call   802854 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013cf:	89 f8                	mov    %edi,%eax
  8013d1:	e8 45 fd ff ff       	call   80111b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013dc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013e2:	74 26                	je     80140a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013e4:	89 d8                	mov    %ebx,%eax
  8013e6:	c1 e8 16             	shr    $0x16,%eax
  8013e9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f0:	a8 01                	test   $0x1,%al
  8013f2:	74 e2                	je     8013d6 <fork+0x66>
  8013f4:	89 da                	mov    %ebx,%edx
  8013f6:	c1 ea 0c             	shr    $0xc,%edx
  8013f9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801400:	83 e0 05             	and    $0x5,%eax
  801403:	83 f8 05             	cmp    $0x5,%eax
  801406:	75 ce                	jne    8013d6 <fork+0x66>
  801408:	eb c5                	jmp    8013cf <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	6a 07                	push   $0x7
  80140f:	68 00 f0 bf ee       	push   $0xeebff000
  801414:	56                   	push   %esi
  801415:	e8 2c fa ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 31                	js     801452 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	68 24 29 80 00       	push   $0x802924
  801429:	56                   	push   %esi
  80142a:	e8 62 fb ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 33                	js     801469 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	6a 02                	push   $0x2
  80143b:	56                   	push   %esi
  80143c:	e8 cc fa ff ff       	call   800f0d <sys_env_set_status>
	if(ret < 0)
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 38                	js     801480 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801448:	89 f0                	mov    %esi,%eax
  80144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5f                   	pop    %edi
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	68 84 30 80 00       	push   $0x803084
  80145a:	68 98 00 00 00       	push   $0x98
  80145f:	68 65 30 80 00       	push   $0x803065
  801464:	e8 eb 13 00 00       	call   802854 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 f8 30 80 00       	push   $0x8030f8
  801471:	68 9b 00 00 00       	push   $0x9b
  801476:	68 65 30 80 00       	push   $0x803065
  80147b:	e8 d4 13 00 00       	call   802854 <_panic>
		panic("panic in sys_env_set_status()\n");
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	68 20 31 80 00       	push   $0x803120
  801488:	68 9e 00 00 00       	push   $0x9e
  80148d:	68 65 30 80 00       	push   $0x803065
  801492:	e8 bd 13 00 00       	call   802854 <_panic>

00801497 <sfork>:

// Challenge!
int
sfork(void)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	57                   	push   %edi
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014a0:	68 71 12 80 00       	push   $0x801271
  8014a5:	e8 0b 14 00 00       	call   8028b5 <set_pgfault_handler>
  8014aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8014af:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 27                	js     8014df <sfork+0x48>
  8014b8:	89 c7                	mov    %eax,%edi
  8014ba:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014bc:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014c1:	75 55                	jne    801518 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014c3:	e8 40 f9 ff ff       	call   800e08 <sys_getenvid>
  8014c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014cd:	c1 e0 07             	shl    $0x7,%eax
  8014d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014d5:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014da:	e9 d4 00 00 00       	jmp    8015b3 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 d4 30 80 00       	push   $0x8030d4
  8014e7:	68 af 00 00 00       	push   $0xaf
  8014ec:	68 65 30 80 00       	push   $0x803065
  8014f1:	e8 5e 13 00 00       	call   802854 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014f6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014fb:	89 f0                	mov    %esi,%eax
  8014fd:	e8 19 fc ff ff       	call   80111b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801502:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801508:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80150e:	77 65                	ja     801575 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801510:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801516:	74 de                	je     8014f6 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	c1 e8 16             	shr    $0x16,%eax
  80151d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801524:	a8 01                	test   $0x1,%al
  801526:	74 da                	je     801502 <sfork+0x6b>
  801528:	89 da                	mov    %ebx,%edx
  80152a:	c1 ea 0c             	shr    $0xc,%edx
  80152d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801534:	83 e0 05             	and    $0x5,%eax
  801537:	83 f8 05             	cmp    $0x5,%eax
  80153a:	75 c6                	jne    801502 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80153c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801543:	c1 e2 0c             	shl    $0xc,%edx
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	83 e0 07             	and    $0x7,%eax
  80154c:	50                   	push   %eax
  80154d:	52                   	push   %edx
  80154e:	56                   	push   %esi
  80154f:	52                   	push   %edx
  801550:	6a 00                	push   $0x0
  801552:	e8 32 f9 ff ff       	call   800e89 <sys_page_map>
  801557:	83 c4 20             	add    $0x20,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	74 a4                	je     801502 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	68 4f 30 80 00       	push   $0x80304f
  801566:	68 ba 00 00 00       	push   $0xba
  80156b:	68 65 30 80 00       	push   $0x803065
  801570:	e8 df 12 00 00       	call   802854 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	6a 07                	push   $0x7
  80157a:	68 00 f0 bf ee       	push   $0xeebff000
  80157f:	57                   	push   %edi
  801580:	e8 c1 f8 ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 31                	js     8015bd <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	68 24 29 80 00       	push   $0x802924
  801594:	57                   	push   %edi
  801595:	e8 f7 f9 ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 33                	js     8015d4 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	6a 02                	push   $0x2
  8015a6:	57                   	push   %edi
  8015a7:	e8 61 f9 ff ff       	call   800f0d <sys_env_set_status>
	if(ret < 0)
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 38                	js     8015eb <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015b3:	89 f8                	mov    %edi,%eax
  8015b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b8:	5b                   	pop    %ebx
  8015b9:	5e                   	pop    %esi
  8015ba:	5f                   	pop    %edi
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 84 30 80 00       	push   $0x803084
  8015c5:	68 c0 00 00 00       	push   $0xc0
  8015ca:	68 65 30 80 00       	push   $0x803065
  8015cf:	e8 80 12 00 00       	call   802854 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	68 f8 30 80 00       	push   $0x8030f8
  8015dc:	68 c3 00 00 00       	push   $0xc3
  8015e1:	68 65 30 80 00       	push   $0x803065
  8015e6:	e8 69 12 00 00       	call   802854 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 20 31 80 00       	push   $0x803120
  8015f3:	68 c6 00 00 00       	push   $0xc6
  8015f8:	68 65 30 80 00       	push   $0x803065
  8015fd:	e8 52 12 00 00       	call   802854 <_panic>

00801602 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
  801607:	8b 75 08             	mov    0x8(%ebp),%esi
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801610:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801612:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801617:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	50                   	push   %eax
  80161e:	e8 d3 f9 ff ff       	call   800ff6 <sys_ipc_recv>
	if(ret < 0){
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 2b                	js     801655 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80162a:	85 f6                	test   %esi,%esi
  80162c:	74 0a                	je     801638 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80162e:	a1 08 50 80 00       	mov    0x805008,%eax
  801633:	8b 40 74             	mov    0x74(%eax),%eax
  801636:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801638:	85 db                	test   %ebx,%ebx
  80163a:	74 0a                	je     801646 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80163c:	a1 08 50 80 00       	mov    0x805008,%eax
  801641:	8b 40 78             	mov    0x78(%eax),%eax
  801644:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801646:	a1 08 50 80 00       	mov    0x805008,%eax
  80164b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80164e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    
		if(from_env_store)
  801655:	85 f6                	test   %esi,%esi
  801657:	74 06                	je     80165f <ipc_recv+0x5d>
			*from_env_store = 0;
  801659:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80165f:	85 db                	test   %ebx,%ebx
  801661:	74 eb                	je     80164e <ipc_recv+0x4c>
			*perm_store = 0;
  801663:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801669:	eb e3                	jmp    80164e <ipc_recv+0x4c>

0080166b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	57                   	push   %edi
  80166f:	56                   	push   %esi
  801670:	53                   	push   %ebx
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	8b 7d 08             	mov    0x8(%ebp),%edi
  801677:	8b 75 0c             	mov    0xc(%ebp),%esi
  80167a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80167d:	85 db                	test   %ebx,%ebx
  80167f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801684:	0f 44 d8             	cmove  %eax,%ebx
  801687:	eb 05                	jmp    80168e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801689:	e8 99 f7 ff ff       	call   800e27 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80168e:	ff 75 14             	pushl  0x14(%ebp)
  801691:	53                   	push   %ebx
  801692:	56                   	push   %esi
  801693:	57                   	push   %edi
  801694:	e8 3a f9 ff ff       	call   800fd3 <sys_ipc_try_send>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	74 1b                	je     8016bb <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016a0:	79 e7                	jns    801689 <ipc_send+0x1e>
  8016a2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016a5:	74 e2                	je     801689 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	68 3f 31 80 00       	push   $0x80313f
  8016af:	6a 48                	push   $0x48
  8016b1:	68 54 31 80 00       	push   $0x803154
  8016b6:	e8 99 11 00 00       	call   802854 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016be:	5b                   	pop    %ebx
  8016bf:	5e                   	pop    %esi
  8016c0:	5f                   	pop    %edi
  8016c1:	5d                   	pop    %ebp
  8016c2:	c3                   	ret    

008016c3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016ce:	89 c2                	mov    %eax,%edx
  8016d0:	c1 e2 07             	shl    $0x7,%edx
  8016d3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016d9:	8b 52 50             	mov    0x50(%edx),%edx
  8016dc:	39 ca                	cmp    %ecx,%edx
  8016de:	74 11                	je     8016f1 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8016e0:	83 c0 01             	add    $0x1,%eax
  8016e3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016e8:	75 e4                	jne    8016ce <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	eb 0b                	jmp    8016fc <ipc_find_env+0x39>
			return envs[i].env_id;
  8016f1:	c1 e0 07             	shl    $0x7,%eax
  8016f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016f9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	05 00 00 00 30       	add    $0x30000000,%eax
  801709:	c1 e8 0c             	shr    $0xc,%eax
}
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801719:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80172d:	89 c2                	mov    %eax,%edx
  80172f:	c1 ea 16             	shr    $0x16,%edx
  801732:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801739:	f6 c2 01             	test   $0x1,%dl
  80173c:	74 2d                	je     80176b <fd_alloc+0x46>
  80173e:	89 c2                	mov    %eax,%edx
  801740:	c1 ea 0c             	shr    $0xc,%edx
  801743:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174a:	f6 c2 01             	test   $0x1,%dl
  80174d:	74 1c                	je     80176b <fd_alloc+0x46>
  80174f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801754:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801759:	75 d2                	jne    80172d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801764:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801769:	eb 0a                	jmp    801775 <fd_alloc+0x50>
			*fd_store = fd;
  80176b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80177d:	83 f8 1f             	cmp    $0x1f,%eax
  801780:	77 30                	ja     8017b2 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801782:	c1 e0 0c             	shl    $0xc,%eax
  801785:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80178a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801790:	f6 c2 01             	test   $0x1,%dl
  801793:	74 24                	je     8017b9 <fd_lookup+0x42>
  801795:	89 c2                	mov    %eax,%edx
  801797:	c1 ea 0c             	shr    $0xc,%edx
  80179a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a1:	f6 c2 01             	test   $0x1,%dl
  8017a4:	74 1a                	je     8017c0 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    
		return -E_INVAL;
  8017b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b7:	eb f7                	jmp    8017b0 <fd_lookup+0x39>
		return -E_INVAL;
  8017b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017be:	eb f0                	jmp    8017b0 <fd_lookup+0x39>
  8017c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c5:	eb e9                	jmp    8017b0 <fd_lookup+0x39>

008017c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017da:	39 08                	cmp    %ecx,(%eax)
  8017dc:	74 38                	je     801816 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017de:	83 c2 01             	add    $0x1,%edx
  8017e1:	8b 04 95 dc 31 80 00 	mov    0x8031dc(,%edx,4),%eax
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	75 ee                	jne    8017da <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017ec:	a1 08 50 80 00       	mov    0x805008,%eax
  8017f1:	8b 40 48             	mov    0x48(%eax),%eax
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	51                   	push   %ecx
  8017f8:	50                   	push   %eax
  8017f9:	68 60 31 80 00       	push   $0x803160
  8017fe:	e8 f2 ea ff ff       	call   8002f5 <cprintf>
	*dev = 0;
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    
			*dev = devtab[i];
  801816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801819:	89 01                	mov    %eax,(%ecx)
			return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb f2                	jmp    801814 <dev_lookup+0x4d>

00801822 <fd_close>:
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	83 ec 24             	sub    $0x24,%esp
  80182b:	8b 75 08             	mov    0x8(%ebp),%esi
  80182e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801831:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801834:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801835:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80183b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80183e:	50                   	push   %eax
  80183f:	e8 33 ff ff ff       	call   801777 <fd_lookup>
  801844:	89 c3                	mov    %eax,%ebx
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	78 05                	js     801852 <fd_close+0x30>
	    || fd != fd2)
  80184d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801850:	74 16                	je     801868 <fd_close+0x46>
		return (must_exist ? r : 0);
  801852:	89 f8                	mov    %edi,%eax
  801854:	84 c0                	test   %al,%al
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
  80185b:	0f 44 d8             	cmove  %eax,%ebx
}
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5f                   	pop    %edi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80186e:	50                   	push   %eax
  80186f:	ff 36                	pushl  (%esi)
  801871:	e8 51 ff ff ff       	call   8017c7 <dev_lookup>
  801876:	89 c3                	mov    %eax,%ebx
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 1a                	js     801899 <fd_close+0x77>
		if (dev->dev_close)
  80187f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801882:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801885:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	74 0b                	je     801899 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80188e:	83 ec 0c             	sub    $0xc,%esp
  801891:	56                   	push   %esi
  801892:	ff d0                	call   *%eax
  801894:	89 c3                	mov    %eax,%ebx
  801896:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	56                   	push   %esi
  80189d:	6a 00                	push   $0x0
  80189f:	e8 27 f6 ff ff       	call   800ecb <sys_page_unmap>
	return r;
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	eb b5                	jmp    80185e <fd_close+0x3c>

008018a9 <close>:

int
close(int fdnum)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b2:	50                   	push   %eax
  8018b3:	ff 75 08             	pushl  0x8(%ebp)
  8018b6:	e8 bc fe ff ff       	call   801777 <fd_lookup>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	79 02                	jns    8018c4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    
		return fd_close(fd, 1);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	6a 01                	push   $0x1
  8018c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cc:	e8 51 ff ff ff       	call   801822 <fd_close>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	eb ec                	jmp    8018c2 <close+0x19>

008018d6 <close_all>:

void
close_all(void)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	53                   	push   %ebx
  8018e6:	e8 be ff ff ff       	call   8018a9 <close>
	for (i = 0; i < MAXFD; i++)
  8018eb:	83 c3 01             	add    $0x1,%ebx
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	83 fb 20             	cmp    $0x20,%ebx
  8018f4:	75 ec                	jne    8018e2 <close_all+0xc>
}
  8018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	57                   	push   %edi
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801904:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801907:	50                   	push   %eax
  801908:	ff 75 08             	pushl  0x8(%ebp)
  80190b:	e8 67 fe ff ff       	call   801777 <fd_lookup>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	85 c0                	test   %eax,%eax
  801917:	0f 88 81 00 00 00    	js     80199e <dup+0xa3>
		return r;
	close(newfdnum);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	e8 81 ff ff ff       	call   8018a9 <close>

	newfd = INDEX2FD(newfdnum);
  801928:	8b 75 0c             	mov    0xc(%ebp),%esi
  80192b:	c1 e6 0c             	shl    $0xc,%esi
  80192e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801934:	83 c4 04             	add    $0x4,%esp
  801937:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193a:	e8 cf fd ff ff       	call   80170e <fd2data>
  80193f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801941:	89 34 24             	mov    %esi,(%esp)
  801944:	e8 c5 fd ff ff       	call   80170e <fd2data>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	c1 e8 16             	shr    $0x16,%eax
  801953:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80195a:	a8 01                	test   $0x1,%al
  80195c:	74 11                	je     80196f <dup+0x74>
  80195e:	89 d8                	mov    %ebx,%eax
  801960:	c1 e8 0c             	shr    $0xc,%eax
  801963:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80196a:	f6 c2 01             	test   $0x1,%dl
  80196d:	75 39                	jne    8019a8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80196f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801972:	89 d0                	mov    %edx,%eax
  801974:	c1 e8 0c             	shr    $0xc,%eax
  801977:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	25 07 0e 00 00       	and    $0xe07,%eax
  801986:	50                   	push   %eax
  801987:	56                   	push   %esi
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	6a 00                	push   $0x0
  80198d:	e8 f7 f4 ff ff       	call   800e89 <sys_page_map>
  801992:	89 c3                	mov    %eax,%ebx
  801994:	83 c4 20             	add    $0x20,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 31                	js     8019cc <dup+0xd1>
		goto err;

	return newfdnum;
  80199b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80199e:	89 d8                	mov    %ebx,%eax
  8019a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8019b7:	50                   	push   %eax
  8019b8:	57                   	push   %edi
  8019b9:	6a 00                	push   $0x0
  8019bb:	53                   	push   %ebx
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 c6 f4 ff ff       	call   800e89 <sys_page_map>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 20             	add    $0x20,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	79 a3                	jns    80196f <dup+0x74>
	sys_page_unmap(0, newfd);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	56                   	push   %esi
  8019d0:	6a 00                	push   $0x0
  8019d2:	e8 f4 f4 ff ff       	call   800ecb <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019d7:	83 c4 08             	add    $0x8,%esp
  8019da:	57                   	push   %edi
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 e9 f4 ff ff       	call   800ecb <sys_page_unmap>
	return r;
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	eb b7                	jmp    80199e <dup+0xa3>

008019e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 1c             	sub    $0x1c,%esp
  8019ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f4:	50                   	push   %eax
  8019f5:	53                   	push   %ebx
  8019f6:	e8 7c fd ff ff       	call   801777 <fd_lookup>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 3f                	js     801a41 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a02:	83 ec 08             	sub    $0x8,%esp
  801a05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0c:	ff 30                	pushl  (%eax)
  801a0e:	e8 b4 fd ff ff       	call   8017c7 <dev_lookup>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 27                	js     801a41 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1d:	8b 42 08             	mov    0x8(%edx),%eax
  801a20:	83 e0 03             	and    $0x3,%eax
  801a23:	83 f8 01             	cmp    $0x1,%eax
  801a26:	74 1e                	je     801a46 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2b:	8b 40 08             	mov    0x8(%eax),%eax
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	74 35                	je     801a67 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	52                   	push   %edx
  801a3c:	ff d0                	call   *%eax
  801a3e:	83 c4 10             	add    $0x10,%esp
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a46:	a1 08 50 80 00       	mov    0x805008,%eax
  801a4b:	8b 40 48             	mov    0x48(%eax),%eax
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	53                   	push   %ebx
  801a52:	50                   	push   %eax
  801a53:	68 a1 31 80 00       	push   $0x8031a1
  801a58:	e8 98 e8 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a65:	eb da                	jmp    801a41 <read+0x5a>
		return -E_NOT_SUPP;
  801a67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6c:	eb d3                	jmp    801a41 <read+0x5a>

00801a6e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 0c             	sub    $0xc,%esp
  801a77:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a7a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a82:	39 f3                	cmp    %esi,%ebx
  801a84:	73 23                	jae    801aa9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	89 f0                	mov    %esi,%eax
  801a8b:	29 d8                	sub    %ebx,%eax
  801a8d:	50                   	push   %eax
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	03 45 0c             	add    0xc(%ebp),%eax
  801a93:	50                   	push   %eax
  801a94:	57                   	push   %edi
  801a95:	e8 4d ff ff ff       	call   8019e7 <read>
		if (m < 0)
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 06                	js     801aa7 <readn+0x39>
			return m;
		if (m == 0)
  801aa1:	74 06                	je     801aa9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801aa3:	01 c3                	add    %eax,%ebx
  801aa5:	eb db                	jmp    801a82 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5f                   	pop    %edi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 1c             	sub    $0x1c,%esp
  801aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac0:	50                   	push   %eax
  801ac1:	53                   	push   %ebx
  801ac2:	e8 b0 fc ff ff       	call   801777 <fd_lookup>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 3a                	js     801b08 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad8:	ff 30                	pushl  (%eax)
  801ada:	e8 e8 fc ff ff       	call   8017c7 <dev_lookup>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 22                	js     801b08 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aed:	74 1e                	je     801b0d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	8b 52 0c             	mov    0xc(%edx),%edx
  801af5:	85 d2                	test   %edx,%edx
  801af7:	74 35                	je     801b2e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	ff 75 10             	pushl  0x10(%ebp)
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	ff d2                	call   *%edx
  801b05:	83 c4 10             	add    $0x10,%esp
}
  801b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b0d:	a1 08 50 80 00       	mov    0x805008,%eax
  801b12:	8b 40 48             	mov    0x48(%eax),%eax
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	53                   	push   %ebx
  801b19:	50                   	push   %eax
  801b1a:	68 bd 31 80 00       	push   $0x8031bd
  801b1f:	e8 d1 e7 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2c:	eb da                	jmp    801b08 <write+0x55>
		return -E_NOT_SUPP;
  801b2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b33:	eb d3                	jmp    801b08 <write+0x55>

00801b35 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3e:	50                   	push   %eax
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	e8 30 fc ff ff       	call   801777 <fd_lookup>
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 0e                	js     801b5c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b54:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	53                   	push   %ebx
  801b62:	83 ec 1c             	sub    $0x1c,%esp
  801b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b6b:	50                   	push   %eax
  801b6c:	53                   	push   %ebx
  801b6d:	e8 05 fc ff ff       	call   801777 <fd_lookup>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 37                	js     801bb0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7f:	50                   	push   %eax
  801b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b83:	ff 30                	pushl  (%eax)
  801b85:	e8 3d fc ff ff       	call   8017c7 <dev_lookup>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 1f                	js     801bb0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b94:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b98:	74 1b                	je     801bb5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9d:	8b 52 18             	mov    0x18(%edx),%edx
  801ba0:	85 d2                	test   %edx,%edx
  801ba2:	74 32                	je     801bd6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	50                   	push   %eax
  801bab:	ff d2                	call   *%edx
  801bad:	83 c4 10             	add    $0x10,%esp
}
  801bb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bb5:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bba:	8b 40 48             	mov    0x48(%eax),%eax
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	53                   	push   %ebx
  801bc1:	50                   	push   %eax
  801bc2:	68 80 31 80 00       	push   $0x803180
  801bc7:	e8 29 e7 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd4:	eb da                	jmp    801bb0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bd6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdb:	eb d3                	jmp    801bb0 <ftruncate+0x52>

00801bdd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
  801be1:	83 ec 1c             	sub    $0x1c,%esp
  801be4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bea:	50                   	push   %eax
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	e8 84 fb ff ff       	call   801777 <fd_lookup>
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 4b                	js     801c45 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bfa:	83 ec 08             	sub    $0x8,%esp
  801bfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c00:	50                   	push   %eax
  801c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c04:	ff 30                	pushl  (%eax)
  801c06:	e8 bc fb ff ff       	call   8017c7 <dev_lookup>
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 33                	js     801c45 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c19:	74 2f                	je     801c4a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c1b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c1e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c25:	00 00 00 
	stat->st_isdir = 0;
  801c28:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c2f:	00 00 00 
	stat->st_dev = dev;
  801c32:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	53                   	push   %ebx
  801c3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c3f:	ff 50 14             	call   *0x14(%eax)
  801c42:	83 c4 10             	add    $0x10,%esp
}
  801c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    
		return -E_NOT_SUPP;
  801c4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c4f:	eb f4                	jmp    801c45 <fstat+0x68>

00801c51 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c56:	83 ec 08             	sub    $0x8,%esp
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	e8 22 02 00 00       	call   801e85 <open>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 1b                	js     801c87 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c6c:	83 ec 08             	sub    $0x8,%esp
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	50                   	push   %eax
  801c73:	e8 65 ff ff ff       	call   801bdd <fstat>
  801c78:	89 c6                	mov    %eax,%esi
	close(fd);
  801c7a:	89 1c 24             	mov    %ebx,(%esp)
  801c7d:	e8 27 fc ff ff       	call   8018a9 <close>
	return r;
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	89 f3                	mov    %esi,%ebx
}
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	89 c6                	mov    %eax,%esi
  801c97:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c99:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ca0:	74 27                	je     801cc9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ca2:	6a 07                	push   $0x7
  801ca4:	68 00 60 80 00       	push   $0x806000
  801ca9:	56                   	push   %esi
  801caa:	ff 35 00 50 80 00    	pushl  0x805000
  801cb0:	e8 b6 f9 ff ff       	call   80166b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cb5:	83 c4 0c             	add    $0xc,%esp
  801cb8:	6a 00                	push   $0x0
  801cba:	53                   	push   %ebx
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 40 f9 ff ff       	call   801602 <ipc_recv>
}
  801cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cc9:	83 ec 0c             	sub    $0xc,%esp
  801ccc:	6a 01                	push   $0x1
  801cce:	e8 f0 f9 ff ff       	call   8016c3 <ipc_find_env>
  801cd3:	a3 00 50 80 00       	mov    %eax,0x805000
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	eb c5                	jmp    801ca2 <fsipc+0x12>

00801cdd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfb:	b8 02 00 00 00       	mov    $0x2,%eax
  801d00:	e8 8b ff ff ff       	call   801c90 <fsipc>
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <devfile_flush>:
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8b 40 0c             	mov    0xc(%eax),%eax
  801d13:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d18:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1d:	b8 06 00 00 00       	mov    $0x6,%eax
  801d22:	e8 69 ff ff ff       	call   801c90 <fsipc>
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <devfile_stat>:
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	53                   	push   %ebx
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	8b 40 0c             	mov    0xc(%eax),%eax
  801d39:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	b8 05 00 00 00       	mov    $0x5,%eax
  801d48:	e8 43 ff ff ff       	call   801c90 <fsipc>
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 2c                	js     801d7d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d51:	83 ec 08             	sub    $0x8,%esp
  801d54:	68 00 60 80 00       	push   $0x806000
  801d59:	53                   	push   %ebx
  801d5a:	e8 f5 ec ff ff       	call   800a54 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801d64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <devfile_write>:
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	53                   	push   %ebx
  801d86:	83 ec 08             	sub    $0x8,%esp
  801d89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d97:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d9d:	53                   	push   %ebx
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	68 08 60 80 00       	push   $0x806008
  801da6:	e8 99 ee ff ff       	call   800c44 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	b8 04 00 00 00       	mov    $0x4,%eax
  801db5:	e8 d6 fe ff ff       	call   801c90 <fsipc>
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 0b                	js     801dcc <devfile_write+0x4a>
	assert(r <= n);
  801dc1:	39 d8                	cmp    %ebx,%eax
  801dc3:	77 0c                	ja     801dd1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dc5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dca:	7f 1e                	jg     801dea <devfile_write+0x68>
}
  801dcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    
	assert(r <= n);
  801dd1:	68 f0 31 80 00       	push   $0x8031f0
  801dd6:	68 f7 31 80 00       	push   $0x8031f7
  801ddb:	68 98 00 00 00       	push   $0x98
  801de0:	68 0c 32 80 00       	push   $0x80320c
  801de5:	e8 6a 0a 00 00       	call   802854 <_panic>
	assert(r <= PGSIZE);
  801dea:	68 17 32 80 00       	push   $0x803217
  801def:	68 f7 31 80 00       	push   $0x8031f7
  801df4:	68 99 00 00 00       	push   $0x99
  801df9:	68 0c 32 80 00       	push   $0x80320c
  801dfe:	e8 51 0a 00 00       	call   802854 <_panic>

00801e03 <devfile_read>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e11:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e16:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	b8 03 00 00 00       	mov    $0x3,%eax
  801e26:	e8 65 fe ff ff       	call   801c90 <fsipc>
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 1f                	js     801e50 <devfile_read+0x4d>
	assert(r <= n);
  801e31:	39 f0                	cmp    %esi,%eax
  801e33:	77 24                	ja     801e59 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e35:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e3a:	7f 33                	jg     801e6f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	50                   	push   %eax
  801e40:	68 00 60 80 00       	push   $0x806000
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	e8 95 ed ff ff       	call   800be2 <memmove>
	return r;
  801e4d:	83 c4 10             	add    $0x10,%esp
}
  801e50:	89 d8                	mov    %ebx,%eax
  801e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
	assert(r <= n);
  801e59:	68 f0 31 80 00       	push   $0x8031f0
  801e5e:	68 f7 31 80 00       	push   $0x8031f7
  801e63:	6a 7c                	push   $0x7c
  801e65:	68 0c 32 80 00       	push   $0x80320c
  801e6a:	e8 e5 09 00 00       	call   802854 <_panic>
	assert(r <= PGSIZE);
  801e6f:	68 17 32 80 00       	push   $0x803217
  801e74:	68 f7 31 80 00       	push   $0x8031f7
  801e79:	6a 7d                	push   $0x7d
  801e7b:	68 0c 32 80 00       	push   $0x80320c
  801e80:	e8 cf 09 00 00       	call   802854 <_panic>

00801e85 <open>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 1c             	sub    $0x1c,%esp
  801e8d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e90:	56                   	push   %esi
  801e91:	e8 85 eb ff ff       	call   800a1b <strlen>
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e9e:	7f 6c                	jg     801f0c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea6:	50                   	push   %eax
  801ea7:	e8 79 f8 ff ff       	call   801725 <fd_alloc>
  801eac:	89 c3                	mov    %eax,%ebx
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	78 3c                	js     801ef1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801eb5:	83 ec 08             	sub    $0x8,%esp
  801eb8:	56                   	push   %esi
  801eb9:	68 00 60 80 00       	push   $0x806000
  801ebe:	e8 91 eb ff ff       	call   800a54 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec6:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	e8 b8 fd ff ff       	call   801c90 <fsipc>
  801ed8:	89 c3                	mov    %eax,%ebx
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 19                	js     801efa <open+0x75>
	return fd2num(fd);
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee7:	e8 12 f8 ff ff       	call   8016fe <fd2num>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	83 c4 10             	add    $0x10,%esp
}
  801ef1:	89 d8                	mov    %ebx,%eax
  801ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5e                   	pop    %esi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    
		fd_close(fd, 0);
  801efa:	83 ec 08             	sub    $0x8,%esp
  801efd:	6a 00                	push   $0x0
  801eff:	ff 75 f4             	pushl  -0xc(%ebp)
  801f02:	e8 1b f9 ff ff       	call   801822 <fd_close>
		return r;
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	eb e5                	jmp    801ef1 <open+0x6c>
		return -E_BAD_PATH;
  801f0c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f11:	eb de                	jmp    801ef1 <open+0x6c>

00801f13 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f19:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f23:	e8 68 fd ff ff       	call   801c90 <fsipc>
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f30:	68 23 32 80 00       	push   $0x803223
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	e8 17 eb ff ff       	call   800a54 <strcpy>
	return 0;
}
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <devsock_close>:
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	53                   	push   %ebx
  801f48:	83 ec 10             	sub    $0x10,%esp
  801f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f4e:	53                   	push   %ebx
  801f4f:	e8 f6 09 00 00       	call   80294a <pageref>
  801f54:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f5c:	83 f8 01             	cmp    $0x1,%eax
  801f5f:	74 07                	je     801f68 <devsock_close+0x24>
}
  801f61:	89 d0                	mov    %edx,%eax
  801f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	ff 73 0c             	pushl  0xc(%ebx)
  801f6e:	e8 b9 02 00 00       	call   80222c <nsipc_close>
  801f73:	89 c2                	mov    %eax,%edx
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	eb e7                	jmp    801f61 <devsock_close+0x1d>

00801f7a <devsock_write>:
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 10             	pushl  0x10(%ebp)
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	ff 70 0c             	pushl  0xc(%eax)
  801f8e:	e8 76 03 00 00       	call   802309 <nsipc_send>
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <devsock_read>:
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	ff 75 10             	pushl  0x10(%ebp)
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	ff 70 0c             	pushl  0xc(%eax)
  801fa9:	e8 ef 02 00 00       	call   80229d <nsipc_recv>
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <fd2sockid>:
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fb6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fb9:	52                   	push   %edx
  801fba:	50                   	push   %eax
  801fbb:	e8 b7 f7 ff ff       	call   801777 <fd_lookup>
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 10                	js     801fd7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801fd0:	39 08                	cmp    %ecx,(%eax)
  801fd2:	75 05                	jne    801fd9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fd4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    
		return -E_NOT_SUPP;
  801fd9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fde:	eb f7                	jmp    801fd7 <fd2sockid+0x27>

00801fe0 <alloc_sockfd>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 1c             	sub    $0x1c,%esp
  801fe8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fed:	50                   	push   %eax
  801fee:	e8 32 f7 ff ff       	call   801725 <fd_alloc>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	78 43                	js     80203f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	68 07 04 00 00       	push   $0x407
  802004:	ff 75 f4             	pushl  -0xc(%ebp)
  802007:	6a 00                	push   $0x0
  802009:	e8 38 ee ff ff       	call   800e46 <sys_page_alloc>
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	85 c0                	test   %eax,%eax
  802015:	78 28                	js     80203f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802020:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80202c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	50                   	push   %eax
  802033:	e8 c6 f6 ff ff       	call   8016fe <fd2num>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	eb 0c                	jmp    80204b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	56                   	push   %esi
  802043:	e8 e4 01 00 00       	call   80222c <nsipc_close>
		return r;
  802048:	83 c4 10             	add    $0x10,%esp
}
  80204b:	89 d8                	mov    %ebx,%eax
  80204d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <accept>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	e8 4e ff ff ff       	call   801fb0 <fd2sockid>
  802062:	85 c0                	test   %eax,%eax
  802064:	78 1b                	js     802081 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	ff 75 10             	pushl  0x10(%ebp)
  80206c:	ff 75 0c             	pushl  0xc(%ebp)
  80206f:	50                   	push   %eax
  802070:	e8 0e 01 00 00       	call   802183 <nsipc_accept>
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	85 c0                	test   %eax,%eax
  80207a:	78 05                	js     802081 <accept+0x2d>
	return alloc_sockfd(r);
  80207c:	e8 5f ff ff ff       	call   801fe0 <alloc_sockfd>
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <bind>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	e8 1f ff ff ff       	call   801fb0 <fd2sockid>
  802091:	85 c0                	test   %eax,%eax
  802093:	78 12                	js     8020a7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	ff 75 10             	pushl  0x10(%ebp)
  80209b:	ff 75 0c             	pushl  0xc(%ebp)
  80209e:	50                   	push   %eax
  80209f:	e8 31 01 00 00       	call   8021d5 <nsipc_bind>
  8020a4:	83 c4 10             	add    $0x10,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <shutdown>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	e8 f9 fe ff ff       	call   801fb0 <fd2sockid>
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 0f                	js     8020ca <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020bb:	83 ec 08             	sub    $0x8,%esp
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	50                   	push   %eax
  8020c2:	e8 43 01 00 00       	call   80220a <nsipc_shutdown>
  8020c7:	83 c4 10             	add    $0x10,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <connect>:
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	e8 d6 fe ff ff       	call   801fb0 <fd2sockid>
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 12                	js     8020f0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020de:	83 ec 04             	sub    $0x4,%esp
  8020e1:	ff 75 10             	pushl  0x10(%ebp)
  8020e4:	ff 75 0c             	pushl  0xc(%ebp)
  8020e7:	50                   	push   %eax
  8020e8:	e8 59 01 00 00       	call   802246 <nsipc_connect>
  8020ed:	83 c4 10             	add    $0x10,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <listen>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	e8 b0 fe ff ff       	call   801fb0 <fd2sockid>
  802100:	85 c0                	test   %eax,%eax
  802102:	78 0f                	js     802113 <listen+0x21>
	return nsipc_listen(r, backlog);
  802104:	83 ec 08             	sub    $0x8,%esp
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	50                   	push   %eax
  80210b:	e8 6b 01 00 00       	call   80227b <nsipc_listen>
  802110:	83 c4 10             	add    $0x10,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <socket>:

int
socket(int domain, int type, int protocol)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80211b:	ff 75 10             	pushl  0x10(%ebp)
  80211e:	ff 75 0c             	pushl  0xc(%ebp)
  802121:	ff 75 08             	pushl  0x8(%ebp)
  802124:	e8 3e 02 00 00       	call   802367 <nsipc_socket>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 05                	js     802135 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802130:	e8 ab fe ff ff       	call   801fe0 <alloc_sockfd>
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	53                   	push   %ebx
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802140:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802147:	74 26                	je     80216f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802149:	6a 07                	push   $0x7
  80214b:	68 00 70 80 00       	push   $0x807000
  802150:	53                   	push   %ebx
  802151:	ff 35 04 50 80 00    	pushl  0x805004
  802157:	e8 0f f5 ff ff       	call   80166b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80215c:	83 c4 0c             	add    $0xc,%esp
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	e8 98 f4 ff ff       	call   801602 <ipc_recv>
}
  80216a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	6a 02                	push   $0x2
  802174:	e8 4a f5 ff ff       	call   8016c3 <ipc_find_env>
  802179:	a3 04 50 80 00       	mov    %eax,0x805004
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	eb c6                	jmp    802149 <nsipc+0x12>

00802183 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802193:	8b 06                	mov    (%esi),%eax
  802195:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80219a:	b8 01 00 00 00       	mov    $0x1,%eax
  80219f:	e8 93 ff ff ff       	call   802137 <nsipc>
  8021a4:	89 c3                	mov    %eax,%ebx
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	79 09                	jns    8021b3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021aa:	89 d8                	mov    %ebx,%eax
  8021ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5d                   	pop    %ebp
  8021b2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021b3:	83 ec 04             	sub    $0x4,%esp
  8021b6:	ff 35 10 70 80 00    	pushl  0x807010
  8021bc:	68 00 70 80 00       	push   $0x807000
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	e8 19 ea ff ff       	call   800be2 <memmove>
		*addrlen = ret->ret_addrlen;
  8021c9:	a1 10 70 80 00       	mov    0x807010,%eax
  8021ce:	89 06                	mov    %eax,(%esi)
  8021d0:	83 c4 10             	add    $0x10,%esp
	return r;
  8021d3:	eb d5                	jmp    8021aa <nsipc_accept+0x27>

008021d5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
  8021d9:	83 ec 08             	sub    $0x8,%esp
  8021dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021e7:	53                   	push   %ebx
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	68 04 70 80 00       	push   $0x807004
  8021f0:	e8 ed e9 ff ff       	call   800be2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021fb:	b8 02 00 00 00       	mov    $0x2,%eax
  802200:	e8 32 ff ff ff       	call   802137 <nsipc>
}
  802205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802220:	b8 03 00 00 00       	mov    $0x3,%eax
  802225:	e8 0d ff ff ff       	call   802137 <nsipc>
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <nsipc_close>:

int
nsipc_close(int s)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80223a:	b8 04 00 00 00       	mov    $0x4,%eax
  80223f:	e8 f3 fe ff ff       	call   802137 <nsipc>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	53                   	push   %ebx
  80224a:	83 ec 08             	sub    $0x8,%esp
  80224d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802258:	53                   	push   %ebx
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	68 04 70 80 00       	push   $0x807004
  802261:	e8 7c e9 ff ff       	call   800be2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802266:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80226c:	b8 05 00 00 00       	mov    $0x5,%eax
  802271:	e8 c1 fe ff ff       	call   802137 <nsipc>
}
  802276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802291:	b8 06 00 00 00       	mov    $0x6,%eax
  802296:	e8 9c fe ff ff       	call   802137 <nsipc>
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022ad:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b6:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8022c0:	e8 72 fe ff ff       	call   802137 <nsipc>
  8022c5:	89 c3                	mov    %eax,%ebx
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	78 1f                	js     8022ea <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022cb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022d0:	7f 21                	jg     8022f3 <nsipc_recv+0x56>
  8022d2:	39 c6                	cmp    %eax,%esi
  8022d4:	7c 1d                	jl     8022f3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	50                   	push   %eax
  8022da:	68 00 70 80 00       	push   $0x807000
  8022df:	ff 75 0c             	pushl  0xc(%ebp)
  8022e2:	e8 fb e8 ff ff       	call   800be2 <memmove>
  8022e7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ea:	89 d8                	mov    %ebx,%eax
  8022ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022f3:	68 2f 32 80 00       	push   $0x80322f
  8022f8:	68 f7 31 80 00       	push   $0x8031f7
  8022fd:	6a 62                	push   $0x62
  8022ff:	68 44 32 80 00       	push   $0x803244
  802304:	e8 4b 05 00 00       	call   802854 <_panic>

00802309 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	53                   	push   %ebx
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80231b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802321:	7f 2e                	jg     802351 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	53                   	push   %ebx
  802327:	ff 75 0c             	pushl  0xc(%ebp)
  80232a:	68 0c 70 80 00       	push   $0x80700c
  80232f:	e8 ae e8 ff ff       	call   800be2 <memmove>
	nsipcbuf.send.req_size = size;
  802334:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80233a:	8b 45 14             	mov    0x14(%ebp),%eax
  80233d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802342:	b8 08 00 00 00       	mov    $0x8,%eax
  802347:	e8 eb fd ff ff       	call   802137 <nsipc>
}
  80234c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80234f:	c9                   	leave  
  802350:	c3                   	ret    
	assert(size < 1600);
  802351:	68 50 32 80 00       	push   $0x803250
  802356:	68 f7 31 80 00       	push   $0x8031f7
  80235b:	6a 6d                	push   $0x6d
  80235d:	68 44 32 80 00       	push   $0x803244
  802362:	e8 ed 04 00 00       	call   802854 <_panic>

00802367 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802375:	8b 45 0c             	mov    0xc(%ebp),%eax
  802378:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80237d:	8b 45 10             	mov    0x10(%ebp),%eax
  802380:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802385:	b8 09 00 00 00       	mov    $0x9,%eax
  80238a:	e8 a8 fd ff ff       	call   802137 <nsipc>
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	56                   	push   %esi
  802395:	53                   	push   %ebx
  802396:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	ff 75 08             	pushl  0x8(%ebp)
  80239f:	e8 6a f3 ff ff       	call   80170e <fd2data>
  8023a4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023a6:	83 c4 08             	add    $0x8,%esp
  8023a9:	68 5c 32 80 00       	push   $0x80325c
  8023ae:	53                   	push   %ebx
  8023af:	e8 a0 e6 ff ff       	call   800a54 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b4:	8b 46 04             	mov    0x4(%esi),%eax
  8023b7:	2b 06                	sub    (%esi),%eax
  8023b9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023c6:	00 00 00 
	stat->st_dev = &devpipe;
  8023c9:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8023d0:	40 80 00 
	return 0;
}
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023db:	5b                   	pop    %ebx
  8023dc:	5e                   	pop    %esi
  8023dd:	5d                   	pop    %ebp
  8023de:	c3                   	ret    

008023df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	53                   	push   %ebx
  8023e3:	83 ec 0c             	sub    $0xc,%esp
  8023e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023e9:	53                   	push   %ebx
  8023ea:	6a 00                	push   $0x0
  8023ec:	e8 da ea ff ff       	call   800ecb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f1:	89 1c 24             	mov    %ebx,(%esp)
  8023f4:	e8 15 f3 ff ff       	call   80170e <fd2data>
  8023f9:	83 c4 08             	add    $0x8,%esp
  8023fc:	50                   	push   %eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	e8 c7 ea ff ff       	call   800ecb <sys_page_unmap>
}
  802404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <_pipeisclosed>:
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	57                   	push   %edi
  80240d:	56                   	push   %esi
  80240e:	53                   	push   %ebx
  80240f:	83 ec 1c             	sub    $0x1c,%esp
  802412:	89 c7                	mov    %eax,%edi
  802414:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802416:	a1 08 50 80 00       	mov    0x805008,%eax
  80241b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80241e:	83 ec 0c             	sub    $0xc,%esp
  802421:	57                   	push   %edi
  802422:	e8 23 05 00 00       	call   80294a <pageref>
  802427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80242a:	89 34 24             	mov    %esi,(%esp)
  80242d:	e8 18 05 00 00       	call   80294a <pageref>
		nn = thisenv->env_runs;
  802432:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802438:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	39 cb                	cmp    %ecx,%ebx
  802440:	74 1b                	je     80245d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802442:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802445:	75 cf                	jne    802416 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802447:	8b 42 58             	mov    0x58(%edx),%eax
  80244a:	6a 01                	push   $0x1
  80244c:	50                   	push   %eax
  80244d:	53                   	push   %ebx
  80244e:	68 63 32 80 00       	push   $0x803263
  802453:	e8 9d de ff ff       	call   8002f5 <cprintf>
  802458:	83 c4 10             	add    $0x10,%esp
  80245b:	eb b9                	jmp    802416 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80245d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802460:	0f 94 c0             	sete   %al
  802463:	0f b6 c0             	movzbl %al,%eax
}
  802466:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802469:	5b                   	pop    %ebx
  80246a:	5e                   	pop    %esi
  80246b:	5f                   	pop    %edi
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <devpipe_write>:
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 28             	sub    $0x28,%esp
  802477:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80247a:	56                   	push   %esi
  80247b:	e8 8e f2 ff ff       	call   80170e <fd2data>
  802480:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802482:	83 c4 10             	add    $0x10,%esp
  802485:	bf 00 00 00 00       	mov    $0x0,%edi
  80248a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80248d:	74 4f                	je     8024de <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80248f:	8b 43 04             	mov    0x4(%ebx),%eax
  802492:	8b 0b                	mov    (%ebx),%ecx
  802494:	8d 51 20             	lea    0x20(%ecx),%edx
  802497:	39 d0                	cmp    %edx,%eax
  802499:	72 14                	jb     8024af <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80249b:	89 da                	mov    %ebx,%edx
  80249d:	89 f0                	mov    %esi,%eax
  80249f:	e8 65 ff ff ff       	call   802409 <_pipeisclosed>
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	75 3b                	jne    8024e3 <devpipe_write+0x75>
			sys_yield();
  8024a8:	e8 7a e9 ff ff       	call   800e27 <sys_yield>
  8024ad:	eb e0                	jmp    80248f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024b6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024b9:	89 c2                	mov    %eax,%edx
  8024bb:	c1 fa 1f             	sar    $0x1f,%edx
  8024be:	89 d1                	mov    %edx,%ecx
  8024c0:	c1 e9 1b             	shr    $0x1b,%ecx
  8024c3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024c6:	83 e2 1f             	and    $0x1f,%edx
  8024c9:	29 ca                	sub    %ecx,%edx
  8024cb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024d3:	83 c0 01             	add    $0x1,%eax
  8024d6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024d9:	83 c7 01             	add    $0x1,%edi
  8024dc:	eb ac                	jmp    80248a <devpipe_write+0x1c>
	return i;
  8024de:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e1:	eb 05                	jmp    8024e8 <devpipe_write+0x7a>
				return 0;
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    

008024f0 <devpipe_read>:
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	57                   	push   %edi
  8024f4:	56                   	push   %esi
  8024f5:	53                   	push   %ebx
  8024f6:	83 ec 18             	sub    $0x18,%esp
  8024f9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024fc:	57                   	push   %edi
  8024fd:	e8 0c f2 ff ff       	call   80170e <fd2data>
  802502:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	be 00 00 00 00       	mov    $0x0,%esi
  80250c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80250f:	75 14                	jne    802525 <devpipe_read+0x35>
	return i;
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	eb 02                	jmp    802518 <devpipe_read+0x28>
				return i;
  802516:	89 f0                	mov    %esi,%eax
}
  802518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    
			sys_yield();
  802520:	e8 02 e9 ff ff       	call   800e27 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802525:	8b 03                	mov    (%ebx),%eax
  802527:	3b 43 04             	cmp    0x4(%ebx),%eax
  80252a:	75 18                	jne    802544 <devpipe_read+0x54>
			if (i > 0)
  80252c:	85 f6                	test   %esi,%esi
  80252e:	75 e6                	jne    802516 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802530:	89 da                	mov    %ebx,%edx
  802532:	89 f8                	mov    %edi,%eax
  802534:	e8 d0 fe ff ff       	call   802409 <_pipeisclosed>
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 e3                	je     802520 <devpipe_read+0x30>
				return 0;
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	eb d4                	jmp    802518 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802544:	99                   	cltd   
  802545:	c1 ea 1b             	shr    $0x1b,%edx
  802548:	01 d0                	add    %edx,%eax
  80254a:	83 e0 1f             	and    $0x1f,%eax
  80254d:	29 d0                	sub    %edx,%eax
  80254f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802554:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802557:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80255a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80255d:	83 c6 01             	add    $0x1,%esi
  802560:	eb aa                	jmp    80250c <devpipe_read+0x1c>

00802562 <pipe>:
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	56                   	push   %esi
  802566:	53                   	push   %ebx
  802567:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80256a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256d:	50                   	push   %eax
  80256e:	e8 b2 f1 ff ff       	call   801725 <fd_alloc>
  802573:	89 c3                	mov    %eax,%ebx
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	85 c0                	test   %eax,%eax
  80257a:	0f 88 23 01 00 00    	js     8026a3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 07 04 00 00       	push   $0x407
  802588:	ff 75 f4             	pushl  -0xc(%ebp)
  80258b:	6a 00                	push   $0x0
  80258d:	e8 b4 e8 ff ff       	call   800e46 <sys_page_alloc>
  802592:	89 c3                	mov    %eax,%ebx
  802594:	83 c4 10             	add    $0x10,%esp
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 88 04 01 00 00    	js     8026a3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80259f:	83 ec 0c             	sub    $0xc,%esp
  8025a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a5:	50                   	push   %eax
  8025a6:	e8 7a f1 ff ff       	call   801725 <fd_alloc>
  8025ab:	89 c3                	mov    %eax,%ebx
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	0f 88 db 00 00 00    	js     802693 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	68 07 04 00 00       	push   $0x407
  8025c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c3:	6a 00                	push   $0x0
  8025c5:	e8 7c e8 ff ff       	call   800e46 <sys_page_alloc>
  8025ca:	89 c3                	mov    %eax,%ebx
  8025cc:	83 c4 10             	add    $0x10,%esp
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	0f 88 bc 00 00 00    	js     802693 <pipe+0x131>
	va = fd2data(fd0);
  8025d7:	83 ec 0c             	sub    $0xc,%esp
  8025da:	ff 75 f4             	pushl  -0xc(%ebp)
  8025dd:	e8 2c f1 ff ff       	call   80170e <fd2data>
  8025e2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e4:	83 c4 0c             	add    $0xc,%esp
  8025e7:	68 07 04 00 00       	push   $0x407
  8025ec:	50                   	push   %eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	e8 52 e8 ff ff       	call   800e46 <sys_page_alloc>
  8025f4:	89 c3                	mov    %eax,%ebx
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	0f 88 82 00 00 00    	js     802683 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802601:	83 ec 0c             	sub    $0xc,%esp
  802604:	ff 75 f0             	pushl  -0x10(%ebp)
  802607:	e8 02 f1 ff ff       	call   80170e <fd2data>
  80260c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802613:	50                   	push   %eax
  802614:	6a 00                	push   $0x0
  802616:	56                   	push   %esi
  802617:	6a 00                	push   $0x0
  802619:	e8 6b e8 ff ff       	call   800e89 <sys_page_map>
  80261e:	89 c3                	mov    %eax,%ebx
  802620:	83 c4 20             	add    $0x20,%esp
  802623:	85 c0                	test   %eax,%eax
  802625:	78 4e                	js     802675 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802627:	a1 44 40 80 00       	mov    0x804044,%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802634:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80263b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802643:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80264a:	83 ec 0c             	sub    $0xc,%esp
  80264d:	ff 75 f4             	pushl  -0xc(%ebp)
  802650:	e8 a9 f0 ff ff       	call   8016fe <fd2num>
  802655:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802658:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80265a:	83 c4 04             	add    $0x4,%esp
  80265d:	ff 75 f0             	pushl  -0x10(%ebp)
  802660:	e8 99 f0 ff ff       	call   8016fe <fd2num>
  802665:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802668:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802673:	eb 2e                	jmp    8026a3 <pipe+0x141>
	sys_page_unmap(0, va);
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	56                   	push   %esi
  802679:	6a 00                	push   $0x0
  80267b:	e8 4b e8 ff ff       	call   800ecb <sys_page_unmap>
  802680:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802683:	83 ec 08             	sub    $0x8,%esp
  802686:	ff 75 f0             	pushl  -0x10(%ebp)
  802689:	6a 00                	push   $0x0
  80268b:	e8 3b e8 ff ff       	call   800ecb <sys_page_unmap>
  802690:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802693:	83 ec 08             	sub    $0x8,%esp
  802696:	ff 75 f4             	pushl  -0xc(%ebp)
  802699:	6a 00                	push   $0x0
  80269b:	e8 2b e8 ff ff       	call   800ecb <sys_page_unmap>
  8026a0:	83 c4 10             	add    $0x10,%esp
}
  8026a3:	89 d8                	mov    %ebx,%eax
  8026a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a8:	5b                   	pop    %ebx
  8026a9:	5e                   	pop    %esi
  8026aa:	5d                   	pop    %ebp
  8026ab:	c3                   	ret    

008026ac <pipeisclosed>:
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b5:	50                   	push   %eax
  8026b6:	ff 75 08             	pushl  0x8(%ebp)
  8026b9:	e8 b9 f0 ff ff       	call   801777 <fd_lookup>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	78 18                	js     8026dd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026c5:	83 ec 0c             	sub    $0xc,%esp
  8026c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cb:	e8 3e f0 ff ff       	call   80170e <fd2data>
	return _pipeisclosed(fd, p);
  8026d0:	89 c2                	mov    %eax,%edx
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	e8 2f fd ff ff       	call   802409 <_pipeisclosed>
  8026da:	83 c4 10             	add    $0x10,%esp
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	c3                   	ret    

008026e5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026eb:	68 7b 32 80 00       	push   $0x80327b
  8026f0:	ff 75 0c             	pushl  0xc(%ebp)
  8026f3:	e8 5c e3 ff ff       	call   800a54 <strcpy>
	return 0;
}
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <devcons_write>:
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
  802702:	57                   	push   %edi
  802703:	56                   	push   %esi
  802704:	53                   	push   %ebx
  802705:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80270b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802710:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802716:	3b 75 10             	cmp    0x10(%ebp),%esi
  802719:	73 31                	jae    80274c <devcons_write+0x4d>
		m = n - tot;
  80271b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	83 fb 7f             	cmp    $0x7f,%ebx
  802723:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802728:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	53                   	push   %ebx
  80272f:	89 f0                	mov    %esi,%eax
  802731:	03 45 0c             	add    0xc(%ebp),%eax
  802734:	50                   	push   %eax
  802735:	57                   	push   %edi
  802736:	e8 a7 e4 ff ff       	call   800be2 <memmove>
		sys_cputs(buf, m);
  80273b:	83 c4 08             	add    $0x8,%esp
  80273e:	53                   	push   %ebx
  80273f:	57                   	push   %edi
  802740:	e8 45 e6 ff ff       	call   800d8a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802745:	01 de                	add    %ebx,%esi
  802747:	83 c4 10             	add    $0x10,%esp
  80274a:	eb ca                	jmp    802716 <devcons_write+0x17>
}
  80274c:	89 f0                	mov    %esi,%eax
  80274e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <devcons_read>:
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 08             	sub    $0x8,%esp
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802765:	74 21                	je     802788 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802767:	e8 3c e6 ff ff       	call   800da8 <sys_cgetc>
  80276c:	85 c0                	test   %eax,%eax
  80276e:	75 07                	jne    802777 <devcons_read+0x21>
		sys_yield();
  802770:	e8 b2 e6 ff ff       	call   800e27 <sys_yield>
  802775:	eb f0                	jmp    802767 <devcons_read+0x11>
	if (c < 0)
  802777:	78 0f                	js     802788 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802779:	83 f8 04             	cmp    $0x4,%eax
  80277c:	74 0c                	je     80278a <devcons_read+0x34>
	*(char*)vbuf = c;
  80277e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802781:	88 02                	mov    %al,(%edx)
	return 1;
  802783:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    
		return 0;
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
  80278f:	eb f7                	jmp    802788 <devcons_read+0x32>

00802791 <cputchar>:
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80279d:	6a 01                	push   $0x1
  80279f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a2:	50                   	push   %eax
  8027a3:	e8 e2 e5 ff ff       	call   800d8a <sys_cputs>
}
  8027a8:	83 c4 10             	add    $0x10,%esp
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    

008027ad <getchar>:
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027b3:	6a 01                	push   $0x1
  8027b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027b8:	50                   	push   %eax
  8027b9:	6a 00                	push   $0x0
  8027bb:	e8 27 f2 ff ff       	call   8019e7 <read>
	if (r < 0)
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	78 06                	js     8027cd <getchar+0x20>
	if (r < 1)
  8027c7:	74 06                	je     8027cf <getchar+0x22>
	return c;
  8027c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    
		return -E_EOF;
  8027cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027d4:	eb f7                	jmp    8027cd <getchar+0x20>

008027d6 <iscons>:
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027df:	50                   	push   %eax
  8027e0:	ff 75 08             	pushl  0x8(%ebp)
  8027e3:	e8 8f ef ff ff       	call   801777 <fd_lookup>
  8027e8:	83 c4 10             	add    $0x10,%esp
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	78 11                	js     802800 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8027f8:	39 10                	cmp    %edx,(%eax)
  8027fa:	0f 94 c0             	sete   %al
  8027fd:	0f b6 c0             	movzbl %al,%eax
}
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <opencons>:
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802808:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80280b:	50                   	push   %eax
  80280c:	e8 14 ef ff ff       	call   801725 <fd_alloc>
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	85 c0                	test   %eax,%eax
  802816:	78 3a                	js     802852 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 07 04 00 00       	push   $0x407
  802820:	ff 75 f4             	pushl  -0xc(%ebp)
  802823:	6a 00                	push   $0x0
  802825:	e8 1c e6 ff ff       	call   800e46 <sys_page_alloc>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	85 c0                	test   %eax,%eax
  80282f:	78 21                	js     802852 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 15 60 40 80 00    	mov    0x804060,%edx
  80283a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802846:	83 ec 0c             	sub    $0xc,%esp
  802849:	50                   	push   %eax
  80284a:	e8 af ee ff ff       	call   8016fe <fd2num>
  80284f:	83 c4 10             	add    $0x10,%esp
}
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	56                   	push   %esi
  802858:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802859:	a1 08 50 80 00       	mov    0x805008,%eax
  80285e:	8b 40 48             	mov    0x48(%eax),%eax
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 b8 32 80 00       	push   $0x8032b8
  802869:	50                   	push   %eax
  80286a:	68 87 32 80 00       	push   $0x803287
  80286f:	e8 81 da ff ff       	call   8002f5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802874:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802877:	8b 35 08 40 80 00    	mov    0x804008,%esi
  80287d:	e8 86 e5 ff ff       	call   800e08 <sys_getenvid>
  802882:	83 c4 04             	add    $0x4,%esp
  802885:	ff 75 0c             	pushl  0xc(%ebp)
  802888:	ff 75 08             	pushl  0x8(%ebp)
  80288b:	56                   	push   %esi
  80288c:	50                   	push   %eax
  80288d:	68 94 32 80 00       	push   $0x803294
  802892:	e8 5e da ff ff       	call   8002f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802897:	83 c4 18             	add    $0x18,%esp
  80289a:	53                   	push   %ebx
  80289b:	ff 75 10             	pushl  0x10(%ebp)
  80289e:	e8 01 da ff ff       	call   8002a4 <vcprintf>
	cprintf("\n");
  8028a3:	c7 04 24 9a 2c 80 00 	movl   $0x802c9a,(%esp)
  8028aa:	e8 46 da ff ff       	call   8002f5 <cprintf>
  8028af:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8028b2:	cc                   	int3   
  8028b3:	eb fd                	jmp    8028b2 <_panic+0x5e>

008028b5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028bb:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028c2:	74 0a                	je     8028ce <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	6a 07                	push   $0x7
  8028d3:	68 00 f0 bf ee       	push   $0xeebff000
  8028d8:	6a 00                	push   $0x0
  8028da:	e8 67 e5 ff ff       	call   800e46 <sys_page_alloc>
		if(r < 0)
  8028df:	83 c4 10             	add    $0x10,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	78 2a                	js     802910 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028e6:	83 ec 08             	sub    $0x8,%esp
  8028e9:	68 24 29 80 00       	push   $0x802924
  8028ee:	6a 00                	push   $0x0
  8028f0:	e8 9c e6 ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028f5:	83 c4 10             	add    $0x10,%esp
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	79 c8                	jns    8028c4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 f0 32 80 00       	push   $0x8032f0
  802904:	6a 25                	push   $0x25
  802906:	68 2c 33 80 00       	push   $0x80332c
  80290b:	e8 44 ff ff ff       	call   802854 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	68 c0 32 80 00       	push   $0x8032c0
  802918:	6a 22                	push   $0x22
  80291a:	68 2c 33 80 00       	push   $0x80332c
  80291f:	e8 30 ff ff ff       	call   802854 <_panic>

00802924 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802924:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802925:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80292a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80292c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80292f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802933:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802937:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80293a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80293c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802940:	83 c4 08             	add    $0x8,%esp
	popal
  802943:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802944:	83 c4 04             	add    $0x4,%esp
	popfl
  802947:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802948:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802949:	c3                   	ret    

0080294a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802950:	89 d0                	mov    %edx,%eax
  802952:	c1 e8 16             	shr    $0x16,%eax
  802955:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802961:	f6 c1 01             	test   $0x1,%cl
  802964:	74 1d                	je     802983 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802966:	c1 ea 0c             	shr    $0xc,%edx
  802969:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802970:	f6 c2 01             	test   $0x1,%dl
  802973:	74 0e                	je     802983 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802975:	c1 ea 0c             	shr    $0xc,%edx
  802978:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80297f:	ef 
  802980:	0f b7 c0             	movzwl %ax,%eax
}
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    
  802985:	66 90                	xchg   %ax,%ax
  802987:	66 90                	xchg   %ax,%ax
  802989:	66 90                	xchg   %ax,%ax
  80298b:	66 90                	xchg   %ax,%ax
  80298d:	66 90                	xchg   %ax,%ax
  80298f:	90                   	nop

00802990 <__udivdi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	53                   	push   %ebx
  802994:	83 ec 1c             	sub    $0x1c,%esp
  802997:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80299b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80299f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029a7:	85 d2                	test   %edx,%edx
  8029a9:	75 4d                	jne    8029f8 <__udivdi3+0x68>
  8029ab:	39 f3                	cmp    %esi,%ebx
  8029ad:	76 19                	jbe    8029c8 <__udivdi3+0x38>
  8029af:	31 ff                	xor    %edi,%edi
  8029b1:	89 e8                	mov    %ebp,%eax
  8029b3:	89 f2                	mov    %esi,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 fa                	mov    %edi,%edx
  8029b9:	83 c4 1c             	add    $0x1c,%esp
  8029bc:	5b                   	pop    %ebx
  8029bd:	5e                   	pop    %esi
  8029be:	5f                   	pop    %edi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    
  8029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	89 d9                	mov    %ebx,%ecx
  8029ca:	85 db                	test   %ebx,%ebx
  8029cc:	75 0b                	jne    8029d9 <__udivdi3+0x49>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	31 d2                	xor    %edx,%edx
  8029d5:	f7 f3                	div    %ebx
  8029d7:	89 c1                	mov    %eax,%ecx
  8029d9:	31 d2                	xor    %edx,%edx
  8029db:	89 f0                	mov    %esi,%eax
  8029dd:	f7 f1                	div    %ecx
  8029df:	89 c6                	mov    %eax,%esi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f7                	mov    %esi,%edi
  8029e5:	f7 f1                	div    %ecx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	39 f2                	cmp    %esi,%edx
  8029fa:	77 1c                	ja     802a18 <__udivdi3+0x88>
  8029fc:	0f bd fa             	bsr    %edx,%edi
  8029ff:	83 f7 1f             	xor    $0x1f,%edi
  802a02:	75 2c                	jne    802a30 <__udivdi3+0xa0>
  802a04:	39 f2                	cmp    %esi,%edx
  802a06:	72 06                	jb     802a0e <__udivdi3+0x7e>
  802a08:	31 c0                	xor    %eax,%eax
  802a0a:	39 eb                	cmp    %ebp,%ebx
  802a0c:	77 a9                	ja     8029b7 <__udivdi3+0x27>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	eb a2                	jmp    8029b7 <__udivdi3+0x27>
  802a15:	8d 76 00             	lea    0x0(%esi),%esi
  802a18:	31 ff                	xor    %edi,%edi
  802a1a:	31 c0                	xor    %eax,%eax
  802a1c:	89 fa                	mov    %edi,%edx
  802a1e:	83 c4 1c             	add    $0x1c,%esp
  802a21:	5b                   	pop    %ebx
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2d:	8d 76 00             	lea    0x0(%esi),%esi
  802a30:	89 f9                	mov    %edi,%ecx
  802a32:	b8 20 00 00 00       	mov    $0x20,%eax
  802a37:	29 f8                	sub    %edi,%eax
  802a39:	d3 e2                	shl    %cl,%edx
  802a3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a3f:	89 c1                	mov    %eax,%ecx
  802a41:	89 da                	mov    %ebx,%edx
  802a43:	d3 ea                	shr    %cl,%edx
  802a45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a49:	09 d1                	or     %edx,%ecx
  802a4b:	89 f2                	mov    %esi,%edx
  802a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a51:	89 f9                	mov    %edi,%ecx
  802a53:	d3 e3                	shl    %cl,%ebx
  802a55:	89 c1                	mov    %eax,%ecx
  802a57:	d3 ea                	shr    %cl,%edx
  802a59:	89 f9                	mov    %edi,%ecx
  802a5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a5f:	89 eb                	mov    %ebp,%ebx
  802a61:	d3 e6                	shl    %cl,%esi
  802a63:	89 c1                	mov    %eax,%ecx
  802a65:	d3 eb                	shr    %cl,%ebx
  802a67:	09 de                	or     %ebx,%esi
  802a69:	89 f0                	mov    %esi,%eax
  802a6b:	f7 74 24 08          	divl   0x8(%esp)
  802a6f:	89 d6                	mov    %edx,%esi
  802a71:	89 c3                	mov    %eax,%ebx
  802a73:	f7 64 24 0c          	mull   0xc(%esp)
  802a77:	39 d6                	cmp    %edx,%esi
  802a79:	72 15                	jb     802a90 <__udivdi3+0x100>
  802a7b:	89 f9                	mov    %edi,%ecx
  802a7d:	d3 e5                	shl    %cl,%ebp
  802a7f:	39 c5                	cmp    %eax,%ebp
  802a81:	73 04                	jae    802a87 <__udivdi3+0xf7>
  802a83:	39 d6                	cmp    %edx,%esi
  802a85:	74 09                	je     802a90 <__udivdi3+0x100>
  802a87:	89 d8                	mov    %ebx,%eax
  802a89:	31 ff                	xor    %edi,%edi
  802a8b:	e9 27 ff ff ff       	jmp    8029b7 <__udivdi3+0x27>
  802a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a93:	31 ff                	xor    %edi,%edi
  802a95:	e9 1d ff ff ff       	jmp    8029b7 <__udivdi3+0x27>
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	66 90                	xchg   %ax,%ax
  802a9e:	66 90                	xchg   %ax,%ax

00802aa0 <__umoddi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	57                   	push   %edi
  802aa2:	56                   	push   %esi
  802aa3:	53                   	push   %ebx
  802aa4:	83 ec 1c             	sub    $0x1c,%esp
  802aa7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aaf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ab7:	89 da                	mov    %ebx,%edx
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	75 43                	jne    802b00 <__umoddi3+0x60>
  802abd:	39 df                	cmp    %ebx,%edi
  802abf:	76 17                	jbe    802ad8 <__umoddi3+0x38>
  802ac1:	89 f0                	mov    %esi,%eax
  802ac3:	f7 f7                	div    %edi
  802ac5:	89 d0                	mov    %edx,%eax
  802ac7:	31 d2                	xor    %edx,%edx
  802ac9:	83 c4 1c             	add    $0x1c,%esp
  802acc:	5b                   	pop    %ebx
  802acd:	5e                   	pop    %esi
  802ace:	5f                   	pop    %edi
  802acf:	5d                   	pop    %ebp
  802ad0:	c3                   	ret    
  802ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	89 fd                	mov    %edi,%ebp
  802ada:	85 ff                	test   %edi,%edi
  802adc:	75 0b                	jne    802ae9 <__umoddi3+0x49>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	31 d2                	xor    %edx,%edx
  802ae5:	f7 f7                	div    %edi
  802ae7:	89 c5                	mov    %eax,%ebp
  802ae9:	89 d8                	mov    %ebx,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f5                	div    %ebp
  802aef:	89 f0                	mov    %esi,%eax
  802af1:	f7 f5                	div    %ebp
  802af3:	89 d0                	mov    %edx,%eax
  802af5:	eb d0                	jmp    802ac7 <__umoddi3+0x27>
  802af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afe:	66 90                	xchg   %ax,%ax
  802b00:	89 f1                	mov    %esi,%ecx
  802b02:	39 d8                	cmp    %ebx,%eax
  802b04:	76 0a                	jbe    802b10 <__umoddi3+0x70>
  802b06:	89 f0                	mov    %esi,%eax
  802b08:	83 c4 1c             	add    $0x1c,%esp
  802b0b:	5b                   	pop    %ebx
  802b0c:	5e                   	pop    %esi
  802b0d:	5f                   	pop    %edi
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    
  802b10:	0f bd e8             	bsr    %eax,%ebp
  802b13:	83 f5 1f             	xor    $0x1f,%ebp
  802b16:	75 20                	jne    802b38 <__umoddi3+0x98>
  802b18:	39 d8                	cmp    %ebx,%eax
  802b1a:	0f 82 b0 00 00 00    	jb     802bd0 <__umoddi3+0x130>
  802b20:	39 f7                	cmp    %esi,%edi
  802b22:	0f 86 a8 00 00 00    	jbe    802bd0 <__umoddi3+0x130>
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	83 c4 1c             	add    $0x1c,%esp
  802b2d:	5b                   	pop    %ebx
  802b2e:	5e                   	pop    %esi
  802b2f:	5f                   	pop    %edi
  802b30:	5d                   	pop    %ebp
  802b31:	c3                   	ret    
  802b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b3f:	29 ea                	sub    %ebp,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b47:	89 d1                	mov    %edx,%ecx
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	d3 e8                	shr    %cl,%eax
  802b4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b59:	09 c1                	or     %eax,%ecx
  802b5b:	89 d8                	mov    %ebx,%eax
  802b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	d3 e8                	shr    %cl,%eax
  802b69:	89 e9                	mov    %ebp,%ecx
  802b6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b6f:	d3 e3                	shl    %cl,%ebx
  802b71:	89 c7                	mov    %eax,%edi
  802b73:	89 d1                	mov    %edx,%ecx
  802b75:	89 f0                	mov    %esi,%eax
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 fa                	mov    %edi,%edx
  802b7d:	d3 e6                	shl    %cl,%esi
  802b7f:	09 d8                	or     %ebx,%eax
  802b81:	f7 74 24 08          	divl   0x8(%esp)
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	89 f3                	mov    %esi,%ebx
  802b89:	f7 64 24 0c          	mull   0xc(%esp)
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	89 d7                	mov    %edx,%edi
  802b91:	39 d1                	cmp    %edx,%ecx
  802b93:	72 06                	jb     802b9b <__umoddi3+0xfb>
  802b95:	75 10                	jne    802ba7 <__umoddi3+0x107>
  802b97:	39 c3                	cmp    %eax,%ebx
  802b99:	73 0c                	jae    802ba7 <__umoddi3+0x107>
  802b9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ba3:	89 d7                	mov    %edx,%edi
  802ba5:	89 c6                	mov    %eax,%esi
  802ba7:	89 ca                	mov    %ecx,%edx
  802ba9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bae:	29 f3                	sub    %esi,%ebx
  802bb0:	19 fa                	sbb    %edi,%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	d3 e0                	shl    %cl,%eax
  802bb6:	89 e9                	mov    %ebp,%ecx
  802bb8:	d3 eb                	shr    %cl,%ebx
  802bba:	d3 ea                	shr    %cl,%edx
  802bbc:	09 d8                	or     %ebx,%eax
  802bbe:	83 c4 1c             	add    $0x1c,%esp
  802bc1:	5b                   	pop    %ebx
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	89 da                	mov    %ebx,%edx
  802bd2:	29 fe                	sub    %edi,%esi
  802bd4:	19 c2                	sbb    %eax,%edx
  802bd6:	89 f1                	mov    %esi,%ecx
  802bd8:	89 c8                	mov    %ecx,%eax
  802bda:	e9 4b ff ff ff       	jmp    802b2a <__umoddi3+0x8a>
