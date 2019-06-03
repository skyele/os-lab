
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
  800039:	e8 46 13 00 00       	call   801384 <fork>
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
  800092:	e8 e8 15 00 00       	call   80167f <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 6c 15 00 00       	call   801616 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 00 2c 80 00       	push   $0x802c00
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
  8000fc:	e8 15 15 00 00       	call   801616 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 00 2c 80 00       	push   $0x802c00
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
  800170:	e8 0a 15 00 00       	call   80167f <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 14 2c 80 00       	push   $0x802c14
  800185:	e8 6b 01 00 00       	call   8002f5 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 34 2c 80 00       	push   $0x802c34
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

	cprintf("call umain!\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 a2 2c 80 00       	push   $0x802ca2
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
  80024c:	e8 99 16 00 00       	call   8018ea <close_all>
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
  8003a2:	e8 f9 25 00 00       	call   8029a0 <__udivdi3>
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
  8003cb:	e8 e0 26 00 00       	call   802ab0 <__umoddi3>
  8003d0:	83 c4 14             	add    $0x14,%esp
  8003d3:	0f be 80 b9 2c 80 00 	movsbl 0x802cb9(%eax),%eax
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
  80047c:	ff 24 85 a0 2e 80 00 	jmp    *0x802ea0(,%eax,4)
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
  800547:	8b 14 85 00 30 80 00 	mov    0x803000(,%eax,4),%edx
  80054e:	85 d2                	test   %edx,%edx
  800550:	74 18                	je     80056a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800552:	52                   	push   %edx
  800553:	68 31 32 80 00       	push   $0x803231
  800558:	53                   	push   %ebx
  800559:	56                   	push   %esi
  80055a:	e8 a6 fe ff ff       	call   800405 <printfmt>
  80055f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800562:	89 7d 14             	mov    %edi,0x14(%ebp)
  800565:	e9 fe 02 00 00       	jmp    800868 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056a:	50                   	push   %eax
  80056b:	68 d1 2c 80 00       	push   $0x802cd1
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
  800592:	b8 ca 2c 80 00       	mov    $0x802cca,%eax
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
  80092a:	bf ed 2d 80 00       	mov    $0x802ded,%edi
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
  800956:	bf 25 2e 80 00       	mov    $0x802e25,%edi
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
  800df7:	68 44 30 80 00       	push   $0x803044
  800dfc:	6a 43                	push   $0x43
  800dfe:	68 61 30 80 00       	push   $0x803061
  800e03:	e8 60 1a 00 00       	call   802868 <_panic>

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
  800e78:	68 44 30 80 00       	push   $0x803044
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 61 30 80 00       	push   $0x803061
  800e84:	e8 df 19 00 00       	call   802868 <_panic>

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
  800eba:	68 44 30 80 00       	push   $0x803044
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 61 30 80 00       	push   $0x803061
  800ec6:	e8 9d 19 00 00       	call   802868 <_panic>

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
  800efc:	68 44 30 80 00       	push   $0x803044
  800f01:	6a 43                	push   $0x43
  800f03:	68 61 30 80 00       	push   $0x803061
  800f08:	e8 5b 19 00 00       	call   802868 <_panic>

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
  800f3e:	68 44 30 80 00       	push   $0x803044
  800f43:	6a 43                	push   $0x43
  800f45:	68 61 30 80 00       	push   $0x803061
  800f4a:	e8 19 19 00 00       	call   802868 <_panic>

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
  800f80:	68 44 30 80 00       	push   $0x803044
  800f85:	6a 43                	push   $0x43
  800f87:	68 61 30 80 00       	push   $0x803061
  800f8c:	e8 d7 18 00 00       	call   802868 <_panic>

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
  800fc2:	68 44 30 80 00       	push   $0x803044
  800fc7:	6a 43                	push   $0x43
  800fc9:	68 61 30 80 00       	push   $0x803061
  800fce:	e8 95 18 00 00       	call   802868 <_panic>

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
  801026:	68 44 30 80 00       	push   $0x803044
  80102b:	6a 43                	push   $0x43
  80102d:	68 61 30 80 00       	push   $0x803061
  801032:	e8 31 18 00 00       	call   802868 <_panic>

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
  80110a:	68 44 30 80 00       	push   $0x803044
  80110f:	6a 43                	push   $0x43
  801111:	68 61 30 80 00       	push   $0x803061
  801116:	e8 4d 17 00 00       	call   802868 <_panic>

0080111b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	53                   	push   %ebx
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801125:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801127:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80112b:	0f 84 99 00 00 00    	je     8011ca <pgfault+0xaf>
  801131:	89 c2                	mov    %eax,%edx
  801133:	c1 ea 16             	shr    $0x16,%edx
  801136:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80113d:	f6 c2 01             	test   $0x1,%dl
  801140:	0f 84 84 00 00 00    	je     8011ca <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801146:	89 c2                	mov    %eax,%edx
  801148:	c1 ea 0c             	shr    $0xc,%edx
  80114b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801152:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801158:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80115e:	75 6a                	jne    8011ca <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801165:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	6a 07                	push   $0x7
  80116c:	68 00 f0 7f 00       	push   $0x7ff000
  801171:	6a 00                	push   $0x0
  801173:	e8 ce fc ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	78 5f                	js     8011de <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	68 00 10 00 00       	push   $0x1000
  801187:	53                   	push   %ebx
  801188:	68 00 f0 7f 00       	push   $0x7ff000
  80118d:	e8 b2 fa ff ff       	call   800c44 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801192:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801199:	53                   	push   %ebx
  80119a:	6a 00                	push   $0x0
  80119c:	68 00 f0 7f 00       	push   $0x7ff000
  8011a1:	6a 00                	push   $0x0
  8011a3:	e8 e1 fc ff ff       	call   800e89 <sys_page_map>
	if(ret < 0)
  8011a8:	83 c4 20             	add    $0x20,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	78 43                	js     8011f2 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011af:	83 ec 08             	sub    $0x8,%esp
  8011b2:	68 00 f0 7f 00       	push   $0x7ff000
  8011b7:	6a 00                	push   $0x0
  8011b9:	e8 0d fd ff ff       	call   800ecb <sys_page_unmap>
	if(ret < 0)
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	78 41                	js     801206 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  8011c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    
		panic("panic at pgfault()\n");
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	68 6f 30 80 00       	push   $0x80306f
  8011d2:	6a 26                	push   $0x26
  8011d4:	68 83 30 80 00       	push   $0x803083
  8011d9:	e8 8a 16 00 00       	call   802868 <_panic>
		panic("panic in sys_page_alloc()\n");
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	68 8e 30 80 00       	push   $0x80308e
  8011e6:	6a 31                	push   $0x31
  8011e8:	68 83 30 80 00       	push   $0x803083
  8011ed:	e8 76 16 00 00       	call   802868 <_panic>
		panic("panic in sys_page_map()\n");
  8011f2:	83 ec 04             	sub    $0x4,%esp
  8011f5:	68 a9 30 80 00       	push   $0x8030a9
  8011fa:	6a 36                	push   $0x36
  8011fc:	68 83 30 80 00       	push   $0x803083
  801201:	e8 62 16 00 00       	call   802868 <_panic>
		panic("panic in sys_page_unmap()\n");
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 c2 30 80 00       	push   $0x8030c2
  80120e:	6a 39                	push   $0x39
  801210:	68 83 30 80 00       	push   $0x803083
  801215:	e8 4e 16 00 00       	call   802868 <_panic>

0080121a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	56                   	push   %esi
  80121e:	53                   	push   %ebx
  80121f:	89 c6                	mov    %eax,%esi
  801221:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801223:	83 ec 08             	sub    $0x8,%esp
  801226:	68 60 31 80 00       	push   $0x803160
  80122b:	68 b3 32 80 00       	push   $0x8032b3
  801230:	e8 c0 f0 ff ff       	call   8002f5 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801235:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	f6 c4 04             	test   $0x4,%ah
  801242:	75 45                	jne    801289 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801244:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80124b:	83 e0 07             	and    $0x7,%eax
  80124e:	83 f8 07             	cmp    $0x7,%eax
  801251:	74 6e                	je     8012c1 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801253:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80125a:	25 05 08 00 00       	and    $0x805,%eax
  80125f:	3d 05 08 00 00       	cmp    $0x805,%eax
  801264:	0f 84 b5 00 00 00    	je     80131f <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80126a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801271:	83 e0 05             	and    $0x5,%eax
  801274:	83 f8 05             	cmp    $0x5,%eax
  801277:	0f 84 d6 00 00 00    	je     801353 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
  801282:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801289:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801290:	c1 e3 0c             	shl    $0xc,%ebx
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	25 07 0e 00 00       	and    $0xe07,%eax
  80129b:	50                   	push   %eax
  80129c:	53                   	push   %ebx
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	6a 00                	push   $0x0
  8012a1:	e8 e3 fb ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  8012a6:	83 c4 20             	add    $0x20,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	79 d0                	jns    80127d <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	68 dd 30 80 00       	push   $0x8030dd
  8012b5:	6a 55                	push   $0x55
  8012b7:	68 83 30 80 00       	push   $0x803083
  8012bc:	e8 a7 15 00 00       	call   802868 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c1:	c1 e3 0c             	shl    $0xc,%ebx
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	68 05 08 00 00       	push   $0x805
  8012cc:	53                   	push   %ebx
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 b3 fb ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  8012d6:	83 c4 20             	add    $0x20,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 2e                	js     80130b <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	68 05 08 00 00       	push   $0x805
  8012e5:	53                   	push   %ebx
  8012e6:	6a 00                	push   $0x0
  8012e8:	53                   	push   %ebx
  8012e9:	6a 00                	push   $0x0
  8012eb:	e8 99 fb ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  8012f0:	83 c4 20             	add    $0x20,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 86                	jns    80127d <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 dd 30 80 00       	push   $0x8030dd
  8012ff:	6a 60                	push   $0x60
  801301:	68 83 30 80 00       	push   $0x803083
  801306:	e8 5d 15 00 00       	call   802868 <_panic>
			panic("sys_page_map() panic\n");
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	68 dd 30 80 00       	push   $0x8030dd
  801313:	6a 5c                	push   $0x5c
  801315:	68 83 30 80 00       	push   $0x803083
  80131a:	e8 49 15 00 00       	call   802868 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80131f:	c1 e3 0c             	shl    $0xc,%ebx
  801322:	83 ec 0c             	sub    $0xc,%esp
  801325:	68 05 08 00 00       	push   $0x805
  80132a:	53                   	push   %ebx
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	6a 00                	push   $0x0
  80132f:	e8 55 fb ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  801334:	83 c4 20             	add    $0x20,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	0f 89 3e ff ff ff    	jns    80127d <duppage+0x63>
			panic("sys_page_map() panic\n");
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	68 dd 30 80 00       	push   $0x8030dd
  801347:	6a 67                	push   $0x67
  801349:	68 83 30 80 00       	push   $0x803083
  80134e:	e8 15 15 00 00       	call   802868 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801353:	c1 e3 0c             	shl    $0xc,%ebx
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	6a 05                	push   $0x5
  80135b:	53                   	push   %ebx
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	6a 00                	push   $0x0
  801360:	e8 24 fb ff ff       	call   800e89 <sys_page_map>
		if(r < 0)
  801365:	83 c4 20             	add    $0x20,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	0f 89 0d ff ff ff    	jns    80127d <duppage+0x63>
			panic("sys_page_map() panic\n");
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	68 dd 30 80 00       	push   $0x8030dd
  801378:	6a 6e                	push   $0x6e
  80137a:	68 83 30 80 00       	push   $0x803083
  80137f:	e8 e4 14 00 00       	call   802868 <_panic>

00801384 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	57                   	push   %edi
  801388:	56                   	push   %esi
  801389:	53                   	push   %ebx
  80138a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80138d:	68 1b 11 80 00       	push   $0x80111b
  801392:	e8 32 15 00 00       	call   8028c9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801397:	b8 07 00 00 00       	mov    $0x7,%eax
  80139c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 27                	js     8013cc <fork+0x48>
  8013a5:	89 c6                	mov    %eax,%esi
  8013a7:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013a9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013ae:	75 48                	jne    8013f8 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013b0:	e8 53 fa ff ff       	call   800e08 <sys_getenvid>
  8013b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013ba:	c1 e0 07             	shl    $0x7,%eax
  8013bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013c7:	e9 90 00 00 00       	jmp    80145c <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	68 f4 30 80 00       	push   $0x8030f4
  8013d4:	68 8d 00 00 00       	push   $0x8d
  8013d9:	68 83 30 80 00       	push   $0x803083
  8013de:	e8 85 14 00 00       	call   802868 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013e3:	89 f8                	mov    %edi,%eax
  8013e5:	e8 30 fe ff ff       	call   80121a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013f0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013f6:	74 26                	je     80141e <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013f8:	89 d8                	mov    %ebx,%eax
  8013fa:	c1 e8 16             	shr    $0x16,%eax
  8013fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801404:	a8 01                	test   $0x1,%al
  801406:	74 e2                	je     8013ea <fork+0x66>
  801408:	89 da                	mov    %ebx,%edx
  80140a:	c1 ea 0c             	shr    $0xc,%edx
  80140d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801414:	83 e0 05             	and    $0x5,%eax
  801417:	83 f8 05             	cmp    $0x5,%eax
  80141a:	75 ce                	jne    8013ea <fork+0x66>
  80141c:	eb c5                	jmp    8013e3 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	6a 07                	push   $0x7
  801423:	68 00 f0 bf ee       	push   $0xeebff000
  801428:	56                   	push   %esi
  801429:	e8 18 fa ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 31                	js     801466 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	68 38 29 80 00       	push   $0x802938
  80143d:	56                   	push   %esi
  80143e:	e8 4e fb ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 33                	js     80147d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80144a:	83 ec 08             	sub    $0x8,%esp
  80144d:	6a 02                	push   $0x2
  80144f:	56                   	push   %esi
  801450:	e8 b8 fa ff ff       	call   800f0d <sys_env_set_status>
	if(ret < 0)
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 38                	js     801494 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80145c:	89 f0                	mov    %esi,%eax
  80145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	68 8e 30 80 00       	push   $0x80308e
  80146e:	68 99 00 00 00       	push   $0x99
  801473:	68 83 30 80 00       	push   $0x803083
  801478:	e8 eb 13 00 00       	call   802868 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	68 18 31 80 00       	push   $0x803118
  801485:	68 9c 00 00 00       	push   $0x9c
  80148a:	68 83 30 80 00       	push   $0x803083
  80148f:	e8 d4 13 00 00       	call   802868 <_panic>
		panic("panic in sys_env_set_status()\n");
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	68 40 31 80 00       	push   $0x803140
  80149c:	68 9f 00 00 00       	push   $0x9f
  8014a1:	68 83 30 80 00       	push   $0x803083
  8014a6:	e8 bd 13 00 00       	call   802868 <_panic>

008014ab <sfork>:

// Challenge!
int
sfork(void)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	57                   	push   %edi
  8014af:	56                   	push   %esi
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014b4:	68 1b 11 80 00       	push   $0x80111b
  8014b9:	e8 0b 14 00 00       	call   8028c9 <set_pgfault_handler>
  8014be:	b8 07 00 00 00       	mov    $0x7,%eax
  8014c3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 27                	js     8014f3 <sfork+0x48>
  8014cc:	89 c7                	mov    %eax,%edi
  8014ce:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014d0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014d5:	75 55                	jne    80152c <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014d7:	e8 2c f9 ff ff       	call   800e08 <sys_getenvid>
  8014dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014e1:	c1 e0 07             	shl    $0x7,%eax
  8014e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014e9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014ee:	e9 d4 00 00 00       	jmp    8015c7 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 f4 30 80 00       	push   $0x8030f4
  8014fb:	68 b0 00 00 00       	push   $0xb0
  801500:	68 83 30 80 00       	push   $0x803083
  801505:	e8 5e 13 00 00       	call   802868 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80150a:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80150f:	89 f0                	mov    %esi,%eax
  801511:	e8 04 fd ff ff       	call   80121a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80151c:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801522:	77 65                	ja     801589 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801524:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80152a:	74 de                	je     80150a <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	c1 e8 16             	shr    $0x16,%eax
  801531:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801538:	a8 01                	test   $0x1,%al
  80153a:	74 da                	je     801516 <sfork+0x6b>
  80153c:	89 da                	mov    %ebx,%edx
  80153e:	c1 ea 0c             	shr    $0xc,%edx
  801541:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801548:	83 e0 05             	and    $0x5,%eax
  80154b:	83 f8 05             	cmp    $0x5,%eax
  80154e:	75 c6                	jne    801516 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801550:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801557:	c1 e2 0c             	shl    $0xc,%edx
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	83 e0 07             	and    $0x7,%eax
  801560:	50                   	push   %eax
  801561:	52                   	push   %edx
  801562:	56                   	push   %esi
  801563:	52                   	push   %edx
  801564:	6a 00                	push   $0x0
  801566:	e8 1e f9 ff ff       	call   800e89 <sys_page_map>
  80156b:	83 c4 20             	add    $0x20,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	74 a4                	je     801516 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	68 dd 30 80 00       	push   $0x8030dd
  80157a:	68 bb 00 00 00       	push   $0xbb
  80157f:	68 83 30 80 00       	push   $0x803083
  801584:	e8 df 12 00 00       	call   802868 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	6a 07                	push   $0x7
  80158e:	68 00 f0 bf ee       	push   $0xeebff000
  801593:	57                   	push   %edi
  801594:	e8 ad f8 ff ff       	call   800e46 <sys_page_alloc>
	if(ret < 0)
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 31                	js     8015d1 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	68 38 29 80 00       	push   $0x802938
  8015a8:	57                   	push   %edi
  8015a9:	e8 e3 f9 ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 33                	js     8015e8 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	6a 02                	push   $0x2
  8015ba:	57                   	push   %edi
  8015bb:	e8 4d f9 ff ff       	call   800f0d <sys_env_set_status>
	if(ret < 0)
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 38                	js     8015ff <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015c7:	89 f8                	mov    %edi,%eax
  8015c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cc:	5b                   	pop    %ebx
  8015cd:	5e                   	pop    %esi
  8015ce:	5f                   	pop    %edi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	68 8e 30 80 00       	push   $0x80308e
  8015d9:	68 c1 00 00 00       	push   $0xc1
  8015de:	68 83 30 80 00       	push   $0x803083
  8015e3:	e8 80 12 00 00       	call   802868 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 18 31 80 00       	push   $0x803118
  8015f0:	68 c4 00 00 00       	push   $0xc4
  8015f5:	68 83 30 80 00       	push   $0x803083
  8015fa:	e8 69 12 00 00       	call   802868 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	68 40 31 80 00       	push   $0x803140
  801607:	68 c7 00 00 00       	push   $0xc7
  80160c:	68 83 30 80 00       	push   $0x803083
  801611:	e8 52 12 00 00       	call   802868 <_panic>

00801616 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	8b 75 08             	mov    0x8(%ebp),%esi
  80161e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801621:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801624:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801626:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80162b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	50                   	push   %eax
  801632:	e8 bf f9 ff ff       	call   800ff6 <sys_ipc_recv>
	if(ret < 0){
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 2b                	js     801669 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80163e:	85 f6                	test   %esi,%esi
  801640:	74 0a                	je     80164c <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801642:	a1 08 50 80 00       	mov    0x805008,%eax
  801647:	8b 40 74             	mov    0x74(%eax),%eax
  80164a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80164c:	85 db                	test   %ebx,%ebx
  80164e:	74 0a                	je     80165a <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801650:	a1 08 50 80 00       	mov    0x805008,%eax
  801655:	8b 40 78             	mov    0x78(%eax),%eax
  801658:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80165a:	a1 08 50 80 00       	mov    0x805008,%eax
  80165f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801662:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
		if(from_env_store)
  801669:	85 f6                	test   %esi,%esi
  80166b:	74 06                	je     801673 <ipc_recv+0x5d>
			*from_env_store = 0;
  80166d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801673:	85 db                	test   %ebx,%ebx
  801675:	74 eb                	je     801662 <ipc_recv+0x4c>
			*perm_store = 0;
  801677:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80167d:	eb e3                	jmp    801662 <ipc_recv+0x4c>

0080167f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	57                   	push   %edi
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	8b 7d 08             	mov    0x8(%ebp),%edi
  80168b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80168e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801691:	85 db                	test   %ebx,%ebx
  801693:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801698:	0f 44 d8             	cmove  %eax,%ebx
  80169b:	eb 05                	jmp    8016a2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80169d:	e8 85 f7 ff ff       	call   800e27 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016a2:	ff 75 14             	pushl  0x14(%ebp)
  8016a5:	53                   	push   %ebx
  8016a6:	56                   	push   %esi
  8016a7:	57                   	push   %edi
  8016a8:	e8 26 f9 ff ff       	call   800fd3 <sys_ipc_try_send>
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	74 1b                	je     8016cf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016b4:	79 e7                	jns    80169d <ipc_send+0x1e>
  8016b6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016b9:	74 e2                	je     80169d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	68 68 31 80 00       	push   $0x803168
  8016c3:	6a 48                	push   $0x48
  8016c5:	68 7d 31 80 00       	push   $0x80317d
  8016ca:	e8 99 11 00 00       	call   802868 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016e2:	89 c2                	mov    %eax,%edx
  8016e4:	c1 e2 07             	shl    $0x7,%edx
  8016e7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016ed:	8b 52 50             	mov    0x50(%edx),%edx
  8016f0:	39 ca                	cmp    %ecx,%edx
  8016f2:	74 11                	je     801705 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8016f4:	83 c0 01             	add    $0x1,%eax
  8016f7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016fc:	75 e4                	jne    8016e2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	eb 0b                	jmp    801710 <ipc_find_env+0x39>
			return envs[i].env_id;
  801705:	c1 e0 07             	shl    $0x7,%eax
  801708:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80170d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    

00801712 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	05 00 00 00 30       	add    $0x30000000,%eax
  80171d:	c1 e8 0c             	shr    $0xc,%eax
}
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80172d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801732:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    

00801739 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801741:	89 c2                	mov    %eax,%edx
  801743:	c1 ea 16             	shr    $0x16,%edx
  801746:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80174d:	f6 c2 01             	test   $0x1,%dl
  801750:	74 2d                	je     80177f <fd_alloc+0x46>
  801752:	89 c2                	mov    %eax,%edx
  801754:	c1 ea 0c             	shr    $0xc,%edx
  801757:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80175e:	f6 c2 01             	test   $0x1,%dl
  801761:	74 1c                	je     80177f <fd_alloc+0x46>
  801763:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801768:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80176d:	75 d2                	jne    801741 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801778:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80177d:	eb 0a                	jmp    801789 <fd_alloc+0x50>
			*fd_store = fd;
  80177f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801782:	89 01                	mov    %eax,(%ecx)
			return 0;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    

0080178b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801791:	83 f8 1f             	cmp    $0x1f,%eax
  801794:	77 30                	ja     8017c6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801796:	c1 e0 0c             	shl    $0xc,%eax
  801799:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80179e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017a4:	f6 c2 01             	test   $0x1,%dl
  8017a7:	74 24                	je     8017cd <fd_lookup+0x42>
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	c1 ea 0c             	shr    $0xc,%edx
  8017ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017b5:	f6 c2 01             	test   $0x1,%dl
  8017b8:	74 1a                	je     8017d4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	89 02                	mov    %eax,(%edx)
	return 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    
		return -E_INVAL;
  8017c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cb:	eb f7                	jmp    8017c4 <fd_lookup+0x39>
		return -E_INVAL;
  8017cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d2:	eb f0                	jmp    8017c4 <fd_lookup+0x39>
  8017d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d9:	eb e9                	jmp    8017c4 <fd_lookup+0x39>

008017db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017ee:	39 08                	cmp    %ecx,(%eax)
  8017f0:	74 38                	je     80182a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017f2:	83 c2 01             	add    $0x1,%edx
  8017f5:	8b 04 95 04 32 80 00 	mov    0x803204(,%edx,4),%eax
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	75 ee                	jne    8017ee <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801800:	a1 08 50 80 00       	mov    0x805008,%eax
  801805:	8b 40 48             	mov    0x48(%eax),%eax
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	51                   	push   %ecx
  80180c:	50                   	push   %eax
  80180d:	68 88 31 80 00       	push   $0x803188
  801812:	e8 de ea ff ff       	call   8002f5 <cprintf>
	*dev = 0;
  801817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    
			*dev = devtab[i];
  80182a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb f2                	jmp    801828 <dev_lookup+0x4d>

00801836 <fd_close>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	57                   	push   %edi
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	83 ec 24             	sub    $0x24,%esp
  80183f:	8b 75 08             	mov    0x8(%ebp),%esi
  801842:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801845:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801848:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801849:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80184f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801852:	50                   	push   %eax
  801853:	e8 33 ff ff ff       	call   80178b <fd_lookup>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 05                	js     801866 <fd_close+0x30>
	    || fd != fd2)
  801861:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801864:	74 16                	je     80187c <fd_close+0x46>
		return (must_exist ? r : 0);
  801866:	89 f8                	mov    %edi,%eax
  801868:	84 c0                	test   %al,%al
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
  80186f:	0f 44 d8             	cmove  %eax,%ebx
}
  801872:	89 d8                	mov    %ebx,%eax
  801874:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5f                   	pop    %edi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801882:	50                   	push   %eax
  801883:	ff 36                	pushl  (%esi)
  801885:	e8 51 ff ff ff       	call   8017db <dev_lookup>
  80188a:	89 c3                	mov    %eax,%ebx
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 1a                	js     8018ad <fd_close+0x77>
		if (dev->dev_close)
  801893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801896:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801899:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	74 0b                	je     8018ad <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	56                   	push   %esi
  8018a6:	ff d0                	call   *%eax
  8018a8:	89 c3                	mov    %eax,%ebx
  8018aa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	56                   	push   %esi
  8018b1:	6a 00                	push   $0x0
  8018b3:	e8 13 f6 ff ff       	call   800ecb <sys_page_unmap>
	return r;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	eb b5                	jmp    801872 <fd_close+0x3c>

008018bd <close>:

int
close(int fdnum)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c6:	50                   	push   %eax
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	e8 bc fe ff ff       	call   80178b <fd_lookup>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	79 02                	jns    8018d8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    
		return fd_close(fd, 1);
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	6a 01                	push   $0x1
  8018dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e0:	e8 51 ff ff ff       	call   801836 <fd_close>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	eb ec                	jmp    8018d6 <close+0x19>

008018ea <close_all>:

void
close_all(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	53                   	push   %ebx
  8018ee:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	53                   	push   %ebx
  8018fa:	e8 be ff ff ff       	call   8018bd <close>
	for (i = 0; i < MAXFD; i++)
  8018ff:	83 c3 01             	add    $0x1,%ebx
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	83 fb 20             	cmp    $0x20,%ebx
  801908:	75 ec                	jne    8018f6 <close_all+0xc>
}
  80190a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	57                   	push   %edi
  801913:	56                   	push   %esi
  801914:	53                   	push   %ebx
  801915:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801918:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80191b:	50                   	push   %eax
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 67 fe ff ff       	call   80178b <fd_lookup>
  801924:	89 c3                	mov    %eax,%ebx
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	0f 88 81 00 00 00    	js     8019b2 <dup+0xa3>
		return r;
	close(newfdnum);
  801931:	83 ec 0c             	sub    $0xc,%esp
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	e8 81 ff ff ff       	call   8018bd <close>

	newfd = INDEX2FD(newfdnum);
  80193c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80193f:	c1 e6 0c             	shl    $0xc,%esi
  801942:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801948:	83 c4 04             	add    $0x4,%esp
  80194b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80194e:	e8 cf fd ff ff       	call   801722 <fd2data>
  801953:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801955:	89 34 24             	mov    %esi,(%esp)
  801958:	e8 c5 fd ff ff       	call   801722 <fd2data>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801962:	89 d8                	mov    %ebx,%eax
  801964:	c1 e8 16             	shr    $0x16,%eax
  801967:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80196e:	a8 01                	test   $0x1,%al
  801970:	74 11                	je     801983 <dup+0x74>
  801972:	89 d8                	mov    %ebx,%eax
  801974:	c1 e8 0c             	shr    $0xc,%eax
  801977:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80197e:	f6 c2 01             	test   $0x1,%dl
  801981:	75 39                	jne    8019bc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801983:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801986:	89 d0                	mov    %edx,%eax
  801988:	c1 e8 0c             	shr    $0xc,%eax
  80198b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	25 07 0e 00 00       	and    $0xe07,%eax
  80199a:	50                   	push   %eax
  80199b:	56                   	push   %esi
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	6a 00                	push   $0x0
  8019a1:	e8 e3 f4 ff ff       	call   800e89 <sys_page_map>
  8019a6:	89 c3                	mov    %eax,%ebx
  8019a8:	83 c4 20             	add    $0x20,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 31                	js     8019e0 <dup+0xd1>
		goto err;

	return newfdnum;
  8019af:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019b2:	89 d8                	mov    %ebx,%eax
  8019b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	25 07 0e 00 00       	and    $0xe07,%eax
  8019cb:	50                   	push   %eax
  8019cc:	57                   	push   %edi
  8019cd:	6a 00                	push   $0x0
  8019cf:	53                   	push   %ebx
  8019d0:	6a 00                	push   $0x0
  8019d2:	e8 b2 f4 ff ff       	call   800e89 <sys_page_map>
  8019d7:	89 c3                	mov    %eax,%ebx
  8019d9:	83 c4 20             	add    $0x20,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	79 a3                	jns    801983 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019e0:	83 ec 08             	sub    $0x8,%esp
  8019e3:	56                   	push   %esi
  8019e4:	6a 00                	push   $0x0
  8019e6:	e8 e0 f4 ff ff       	call   800ecb <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019eb:	83 c4 08             	add    $0x8,%esp
  8019ee:	57                   	push   %edi
  8019ef:	6a 00                	push   $0x0
  8019f1:	e8 d5 f4 ff ff       	call   800ecb <sys_page_unmap>
	return r;
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	eb b7                	jmp    8019b2 <dup+0xa3>

008019fb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 1c             	sub    $0x1c,%esp
  801a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	53                   	push   %ebx
  801a0a:	e8 7c fd ff ff       	call   80178b <fd_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 3f                	js     801a55 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1c:	50                   	push   %eax
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	ff 30                	pushl  (%eax)
  801a22:	e8 b4 fd ff ff       	call   8017db <dev_lookup>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 27                	js     801a55 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a31:	8b 42 08             	mov    0x8(%edx),%eax
  801a34:	83 e0 03             	and    $0x3,%eax
  801a37:	83 f8 01             	cmp    $0x1,%eax
  801a3a:	74 1e                	je     801a5a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3f:	8b 40 08             	mov    0x8(%eax),%eax
  801a42:	85 c0                	test   %eax,%eax
  801a44:	74 35                	je     801a7b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	ff 75 10             	pushl  0x10(%ebp)
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	52                   	push   %edx
  801a50:	ff d0                	call   *%eax
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a5a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a5f:	8b 40 48             	mov    0x48(%eax),%eax
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	53                   	push   %ebx
  801a66:	50                   	push   %eax
  801a67:	68 c9 31 80 00       	push   $0x8031c9
  801a6c:	e8 84 e8 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a79:	eb da                	jmp    801a55 <read+0x5a>
		return -E_NOT_SUPP;
  801a7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a80:	eb d3                	jmp    801a55 <read+0x5a>

00801a82 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	57                   	push   %edi
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a8e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a91:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a96:	39 f3                	cmp    %esi,%ebx
  801a98:	73 23                	jae    801abd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	89 f0                	mov    %esi,%eax
  801a9f:	29 d8                	sub    %ebx,%eax
  801aa1:	50                   	push   %eax
  801aa2:	89 d8                	mov    %ebx,%eax
  801aa4:	03 45 0c             	add    0xc(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	57                   	push   %edi
  801aa9:	e8 4d ff ff ff       	call   8019fb <read>
		if (m < 0)
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 06                	js     801abb <readn+0x39>
			return m;
		if (m == 0)
  801ab5:	74 06                	je     801abd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ab7:	01 c3                	add    %eax,%ebx
  801ab9:	eb db                	jmp    801a96 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801abb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801abd:	89 d8                	mov    %ebx,%eax
  801abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5f                   	pop    %edi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 1c             	sub    $0x1c,%esp
  801ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	53                   	push   %ebx
  801ad6:	e8 b0 fc ff ff       	call   80178b <fd_lookup>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 3a                	js     801b1c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae8:	50                   	push   %eax
  801ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aec:	ff 30                	pushl  (%eax)
  801aee:	e8 e8 fc ff ff       	call   8017db <dev_lookup>
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 22                	js     801b1c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b01:	74 1e                	je     801b21 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b06:	8b 52 0c             	mov    0xc(%edx),%edx
  801b09:	85 d2                	test   %edx,%edx
  801b0b:	74 35                	je     801b42 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	ff 75 10             	pushl  0x10(%ebp)
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff d2                	call   *%edx
  801b19:	83 c4 10             	add    $0x10,%esp
}
  801b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b21:	a1 08 50 80 00       	mov    0x805008,%eax
  801b26:	8b 40 48             	mov    0x48(%eax),%eax
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	50                   	push   %eax
  801b2e:	68 e5 31 80 00       	push   $0x8031e5
  801b33:	e8 bd e7 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b40:	eb da                	jmp    801b1c <write+0x55>
		return -E_NOT_SUPP;
  801b42:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b47:	eb d3                	jmp    801b1c <write+0x55>

00801b49 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b52:	50                   	push   %eax
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 30 fc ff ff       	call   80178b <fd_lookup>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 0e                	js     801b70 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	53                   	push   %ebx
  801b76:	83 ec 1c             	sub    $0x1c,%esp
  801b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7f:	50                   	push   %eax
  801b80:	53                   	push   %ebx
  801b81:	e8 05 fc ff ff       	call   80178b <fd_lookup>
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 37                	js     801bc4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b93:	50                   	push   %eax
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	ff 30                	pushl  (%eax)
  801b99:	e8 3d fc ff ff       	call   8017db <dev_lookup>
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 1f                	js     801bc4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bac:	74 1b                	je     801bc9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb1:	8b 52 18             	mov    0x18(%edx),%edx
  801bb4:	85 d2                	test   %edx,%edx
  801bb6:	74 32                	je     801bea <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	ff d2                	call   *%edx
  801bc1:	83 c4 10             	add    $0x10,%esp
}
  801bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bc9:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bce:	8b 40 48             	mov    0x48(%eax),%eax
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	53                   	push   %ebx
  801bd5:	50                   	push   %eax
  801bd6:	68 a8 31 80 00       	push   $0x8031a8
  801bdb:	e8 15 e7 ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be8:	eb da                	jmp    801bc4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bef:	eb d3                	jmp    801bc4 <ftruncate+0x52>

00801bf1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	53                   	push   %ebx
  801bf5:	83 ec 1c             	sub    $0x1c,%esp
  801bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	e8 84 fb ff ff       	call   80178b <fd_lookup>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 4b                	js     801c59 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c14:	50                   	push   %eax
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c18:	ff 30                	pushl  (%eax)
  801c1a:	e8 bc fb ff ff       	call   8017db <dev_lookup>
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 33                	js     801c59 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c2d:	74 2f                	je     801c5e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c2f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c32:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c39:	00 00 00 
	stat->st_isdir = 0;
  801c3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c43:	00 00 00 
	stat->st_dev = dev;
  801c46:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c4c:	83 ec 08             	sub    $0x8,%esp
  801c4f:	53                   	push   %ebx
  801c50:	ff 75 f0             	pushl  -0x10(%ebp)
  801c53:	ff 50 14             	call   *0x14(%eax)
  801c56:	83 c4 10             	add    $0x10,%esp
}
  801c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c5e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c63:	eb f4                	jmp    801c59 <fstat+0x68>

00801c65 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	56                   	push   %esi
  801c69:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c6a:	83 ec 08             	sub    $0x8,%esp
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	e8 22 02 00 00       	call   801e99 <open>
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 1b                	js     801c9b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c80:	83 ec 08             	sub    $0x8,%esp
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	50                   	push   %eax
  801c87:	e8 65 ff ff ff       	call   801bf1 <fstat>
  801c8c:	89 c6                	mov    %eax,%esi
	close(fd);
  801c8e:	89 1c 24             	mov    %ebx,(%esp)
  801c91:	e8 27 fc ff ff       	call   8018bd <close>
	return r;
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	89 f3                	mov    %esi,%ebx
}
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	56                   	push   %esi
  801ca8:	53                   	push   %ebx
  801ca9:	89 c6                	mov    %eax,%esi
  801cab:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cad:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cb4:	74 27                	je     801cdd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cb6:	6a 07                	push   $0x7
  801cb8:	68 00 60 80 00       	push   $0x806000
  801cbd:	56                   	push   %esi
  801cbe:	ff 35 00 50 80 00    	pushl  0x805000
  801cc4:	e8 b6 f9 ff ff       	call   80167f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cc9:	83 c4 0c             	add    $0xc,%esp
  801ccc:	6a 00                	push   $0x0
  801cce:	53                   	push   %ebx
  801ccf:	6a 00                	push   $0x0
  801cd1:	e8 40 f9 ff ff       	call   801616 <ipc_recv>
}
  801cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	6a 01                	push   $0x1
  801ce2:	e8 f0 f9 ff ff       	call   8016d7 <ipc_find_env>
  801ce7:	a3 00 50 80 00       	mov    %eax,0x805000
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	eb c5                	jmp    801cb6 <fsipc+0x12>

00801cf1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d05:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0f:	b8 02 00 00 00       	mov    $0x2,%eax
  801d14:	e8 8b ff ff ff       	call   801ca4 <fsipc>
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <devfile_flush>:
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8b 40 0c             	mov    0xc(%eax),%eax
  801d27:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d31:	b8 06 00 00 00       	mov    $0x6,%eax
  801d36:	e8 69 ff ff ff       	call   801ca4 <fsipc>
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <devfile_stat>:
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
  801d57:	b8 05 00 00 00       	mov    $0x5,%eax
  801d5c:	e8 43 ff ff ff       	call   801ca4 <fsipc>
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 2c                	js     801d91 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	68 00 60 80 00       	push   $0x806000
  801d6d:	53                   	push   %ebx
  801d6e:	e8 e1 ec ff ff       	call   800a54 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d73:	a1 80 60 80 00       	mov    0x806080,%eax
  801d78:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d7e:	a1 84 60 80 00       	mov    0x806084,%eax
  801d83:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <devfile_write>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
  801da6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dab:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801db1:	53                   	push   %ebx
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	68 08 60 80 00       	push   $0x806008
  801dba:	e8 85 ee ff ff       	call   800c44 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc4:	b8 04 00 00 00       	mov    $0x4,%eax
  801dc9:	e8 d6 fe ff ff       	call   801ca4 <fsipc>
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	78 0b                	js     801de0 <devfile_write+0x4a>
	assert(r <= n);
  801dd5:	39 d8                	cmp    %ebx,%eax
  801dd7:	77 0c                	ja     801de5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dd9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dde:	7f 1e                	jg     801dfe <devfile_write+0x68>
}
  801de0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    
	assert(r <= n);
  801de5:	68 18 32 80 00       	push   $0x803218
  801dea:	68 1f 32 80 00       	push   $0x80321f
  801def:	68 98 00 00 00       	push   $0x98
  801df4:	68 34 32 80 00       	push   $0x803234
  801df9:	e8 6a 0a 00 00       	call   802868 <_panic>
	assert(r <= PGSIZE);
  801dfe:	68 3f 32 80 00       	push   $0x80323f
  801e03:	68 1f 32 80 00       	push   $0x80321f
  801e08:	68 99 00 00 00       	push   $0x99
  801e0d:	68 34 32 80 00       	push   $0x803234
  801e12:	e8 51 0a 00 00       	call   802868 <_panic>

00801e17 <devfile_read>:
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	56                   	push   %esi
  801e1b:	53                   	push   %ebx
  801e1c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	8b 40 0c             	mov    0xc(%eax),%eax
  801e25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e2a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	b8 03 00 00 00       	mov    $0x3,%eax
  801e3a:	e8 65 fe ff ff       	call   801ca4 <fsipc>
  801e3f:	89 c3                	mov    %eax,%ebx
  801e41:	85 c0                	test   %eax,%eax
  801e43:	78 1f                	js     801e64 <devfile_read+0x4d>
	assert(r <= n);
  801e45:	39 f0                	cmp    %esi,%eax
  801e47:	77 24                	ja     801e6d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e49:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e4e:	7f 33                	jg     801e83 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	50                   	push   %eax
  801e54:	68 00 60 80 00       	push   $0x806000
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	e8 81 ed ff ff       	call   800be2 <memmove>
	return r;
  801e61:	83 c4 10             	add    $0x10,%esp
}
  801e64:	89 d8                	mov    %ebx,%eax
  801e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5d                   	pop    %ebp
  801e6c:	c3                   	ret    
	assert(r <= n);
  801e6d:	68 18 32 80 00       	push   $0x803218
  801e72:	68 1f 32 80 00       	push   $0x80321f
  801e77:	6a 7c                	push   $0x7c
  801e79:	68 34 32 80 00       	push   $0x803234
  801e7e:	e8 e5 09 00 00       	call   802868 <_panic>
	assert(r <= PGSIZE);
  801e83:	68 3f 32 80 00       	push   $0x80323f
  801e88:	68 1f 32 80 00       	push   $0x80321f
  801e8d:	6a 7d                	push   $0x7d
  801e8f:	68 34 32 80 00       	push   $0x803234
  801e94:	e8 cf 09 00 00       	call   802868 <_panic>

00801e99 <open>:
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
  801ea1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ea4:	56                   	push   %esi
  801ea5:	e8 71 eb ff ff       	call   800a1b <strlen>
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801eb2:	7f 6c                	jg     801f20 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eba:	50                   	push   %eax
  801ebb:	e8 79 f8 ff ff       	call   801739 <fd_alloc>
  801ec0:	89 c3                	mov    %eax,%ebx
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	78 3c                	js     801f05 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	56                   	push   %esi
  801ecd:	68 00 60 80 00       	push   $0x806000
  801ed2:	e8 7d eb ff ff       	call   800a54 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eda:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee7:	e8 b8 fd ff ff       	call   801ca4 <fsipc>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 19                	js     801f0e <open+0x75>
	return fd2num(fd);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 f4             	pushl  -0xc(%ebp)
  801efb:	e8 12 f8 ff ff       	call   801712 <fd2num>
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	83 c4 10             	add    $0x10,%esp
}
  801f05:	89 d8                	mov    %ebx,%eax
  801f07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    
		fd_close(fd, 0);
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 f4             	pushl  -0xc(%ebp)
  801f16:	e8 1b f9 ff ff       	call   801836 <fd_close>
		return r;
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	eb e5                	jmp    801f05 <open+0x6c>
		return -E_BAD_PATH;
  801f20:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f25:	eb de                	jmp    801f05 <open+0x6c>

00801f27 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f32:	b8 08 00 00 00       	mov    $0x8,%eax
  801f37:	e8 68 fd ff ff       	call   801ca4 <fsipc>
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f44:	68 4b 32 80 00       	push   $0x80324b
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	e8 03 eb ff ff       	call   800a54 <strcpy>
	return 0;
}
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <devsock_close>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	53                   	push   %ebx
  801f5c:	83 ec 10             	sub    $0x10,%esp
  801f5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f62:	53                   	push   %ebx
  801f63:	e8 f6 09 00 00       	call   80295e <pageref>
  801f68:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f70:	83 f8 01             	cmp    $0x1,%eax
  801f73:	74 07                	je     801f7c <devsock_close+0x24>
}
  801f75:	89 d0                	mov    %edx,%eax
  801f77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	ff 73 0c             	pushl  0xc(%ebx)
  801f82:	e8 b9 02 00 00       	call   802240 <nsipc_close>
  801f87:	89 c2                	mov    %eax,%edx
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	eb e7                	jmp    801f75 <devsock_close+0x1d>

00801f8e <devsock_write>:
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	ff 75 10             	pushl  0x10(%ebp)
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	ff 70 0c             	pushl  0xc(%eax)
  801fa2:	e8 76 03 00 00       	call   80231d <nsipc_send>
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <devsock_read>:
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	ff 75 10             	pushl  0x10(%ebp)
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	ff 70 0c             	pushl  0xc(%eax)
  801fbd:	e8 ef 02 00 00       	call   8022b1 <nsipc_recv>
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <fd2sockid>:
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fca:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	e8 b7 f7 ff ff       	call   80178b <fd_lookup>
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	78 10                	js     801feb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801fe4:	39 08                	cmp    %ecx,(%eax)
  801fe6:	75 05                	jne    801fed <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fe8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    
		return -E_NOT_SUPP;
  801fed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ff2:	eb f7                	jmp    801feb <fd2sockid+0x27>

00801ff4 <alloc_sockfd>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 1c             	sub    $0x1c,%esp
  801ffc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	e8 32 f7 ff ff       	call   801739 <fd_alloc>
  802007:	89 c3                	mov    %eax,%ebx
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 43                	js     802053 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	68 07 04 00 00       	push   $0x407
  802018:	ff 75 f4             	pushl  -0xc(%ebp)
  80201b:	6a 00                	push   $0x0
  80201d:	e8 24 ee ff ff       	call   800e46 <sys_page_alloc>
  802022:	89 c3                	mov    %eax,%ebx
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	78 28                	js     802053 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802034:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802040:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	50                   	push   %eax
  802047:	e8 c6 f6 ff ff       	call   801712 <fd2num>
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	eb 0c                	jmp    80205f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	56                   	push   %esi
  802057:	e8 e4 01 00 00       	call   802240 <nsipc_close>
		return r;
  80205c:	83 c4 10             	add    $0x10,%esp
}
  80205f:	89 d8                	mov    %ebx,%eax
  802061:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    

00802068 <accept>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	e8 4e ff ff ff       	call   801fc4 <fd2sockid>
  802076:	85 c0                	test   %eax,%eax
  802078:	78 1b                	js     802095 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	ff 75 10             	pushl  0x10(%ebp)
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	50                   	push   %eax
  802084:	e8 0e 01 00 00       	call   802197 <nsipc_accept>
  802089:	83 c4 10             	add    $0x10,%esp
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 05                	js     802095 <accept+0x2d>
	return alloc_sockfd(r);
  802090:	e8 5f ff ff ff       	call   801ff4 <alloc_sockfd>
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <bind>:
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	e8 1f ff ff ff       	call   801fc4 <fd2sockid>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 12                	js     8020bb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	50                   	push   %eax
  8020b3:	e8 31 01 00 00       	call   8021e9 <nsipc_bind>
  8020b8:	83 c4 10             	add    $0x10,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <shutdown>:
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	e8 f9 fe ff ff       	call   801fc4 <fd2sockid>
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 0f                	js     8020de <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020cf:	83 ec 08             	sub    $0x8,%esp
  8020d2:	ff 75 0c             	pushl  0xc(%ebp)
  8020d5:	50                   	push   %eax
  8020d6:	e8 43 01 00 00       	call   80221e <nsipc_shutdown>
  8020db:	83 c4 10             	add    $0x10,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <connect>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	e8 d6 fe ff ff       	call   801fc4 <fd2sockid>
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 12                	js     802104 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	ff 75 10             	pushl  0x10(%ebp)
  8020f8:	ff 75 0c             	pushl  0xc(%ebp)
  8020fb:	50                   	push   %eax
  8020fc:	e8 59 01 00 00       	call   80225a <nsipc_connect>
  802101:	83 c4 10             	add    $0x10,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <listen>:
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	e8 b0 fe ff ff       	call   801fc4 <fd2sockid>
  802114:	85 c0                	test   %eax,%eax
  802116:	78 0f                	js     802127 <listen+0x21>
	return nsipc_listen(r, backlog);
  802118:	83 ec 08             	sub    $0x8,%esp
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	50                   	push   %eax
  80211f:	e8 6b 01 00 00       	call   80228f <nsipc_listen>
  802124:	83 c4 10             	add    $0x10,%esp
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <socket>:

int
socket(int domain, int type, int protocol)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80212f:	ff 75 10             	pushl  0x10(%ebp)
  802132:	ff 75 0c             	pushl  0xc(%ebp)
  802135:	ff 75 08             	pushl  0x8(%ebp)
  802138:	e8 3e 02 00 00       	call   80237b <nsipc_socket>
  80213d:	83 c4 10             	add    $0x10,%esp
  802140:	85 c0                	test   %eax,%eax
  802142:	78 05                	js     802149 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802144:	e8 ab fe ff ff       	call   801ff4 <alloc_sockfd>
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	53                   	push   %ebx
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802154:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80215b:	74 26                	je     802183 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80215d:	6a 07                	push   $0x7
  80215f:	68 00 70 80 00       	push   $0x807000
  802164:	53                   	push   %ebx
  802165:	ff 35 04 50 80 00    	pushl  0x805004
  80216b:	e8 0f f5 ff ff       	call   80167f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802170:	83 c4 0c             	add    $0xc,%esp
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	e8 98 f4 ff ff       	call   801616 <ipc_recv>
}
  80217e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802181:	c9                   	leave  
  802182:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	6a 02                	push   $0x2
  802188:	e8 4a f5 ff ff       	call   8016d7 <ipc_find_env>
  80218d:	a3 04 50 80 00       	mov    %eax,0x805004
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	eb c6                	jmp    80215d <nsipc+0x12>

00802197 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	56                   	push   %esi
  80219b:	53                   	push   %ebx
  80219c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021a7:	8b 06                	mov    (%esi),%eax
  8021a9:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b3:	e8 93 ff ff ff       	call   80214b <nsipc>
  8021b8:	89 c3                	mov    %eax,%ebx
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	79 09                	jns    8021c7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021be:	89 d8                	mov    %ebx,%eax
  8021c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5d                   	pop    %ebp
  8021c6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	ff 35 10 70 80 00    	pushl  0x807010
  8021d0:	68 00 70 80 00       	push   $0x807000
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	e8 05 ea ff ff       	call   800be2 <memmove>
		*addrlen = ret->ret_addrlen;
  8021dd:	a1 10 70 80 00       	mov    0x807010,%eax
  8021e2:	89 06                	mov    %eax,(%esi)
  8021e4:	83 c4 10             	add    $0x10,%esp
	return r;
  8021e7:	eb d5                	jmp    8021be <nsipc_accept+0x27>

008021e9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	53                   	push   %ebx
  8021ed:	83 ec 08             	sub    $0x8,%esp
  8021f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021fb:	53                   	push   %ebx
  8021fc:	ff 75 0c             	pushl  0xc(%ebp)
  8021ff:	68 04 70 80 00       	push   $0x807004
  802204:	e8 d9 e9 ff ff       	call   800be2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802209:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80220f:	b8 02 00 00 00       	mov    $0x2,%eax
  802214:	e8 32 ff ff ff       	call   80214b <nsipc>
}
  802219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802234:	b8 03 00 00 00       	mov    $0x3,%eax
  802239:	e8 0d ff ff ff       	call   80214b <nsipc>
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <nsipc_close>:

int
nsipc_close(int s)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80224e:	b8 04 00 00 00       	mov    $0x4,%eax
  802253:	e8 f3 fe ff ff       	call   80214b <nsipc>
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	53                   	push   %ebx
  80225e:	83 ec 08             	sub    $0x8,%esp
  802261:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80226c:	53                   	push   %ebx
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	68 04 70 80 00       	push   $0x807004
  802275:	e8 68 e9 ff ff       	call   800be2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80227a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802280:	b8 05 00 00 00       	mov    $0x5,%eax
  802285:	e8 c1 fe ff ff       	call   80214b <nsipc>
}
  80228a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80229d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8022aa:	e8 9c fe ff ff       	call   80214b <nsipc>
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	56                   	push   %esi
  8022b5:	53                   	push   %ebx
  8022b6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022c1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ca:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022cf:	b8 07 00 00 00       	mov    $0x7,%eax
  8022d4:	e8 72 fe ff ff       	call   80214b <nsipc>
  8022d9:	89 c3                	mov    %eax,%ebx
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	78 1f                	js     8022fe <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022df:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022e4:	7f 21                	jg     802307 <nsipc_recv+0x56>
  8022e6:	39 c6                	cmp    %eax,%esi
  8022e8:	7c 1d                	jl     802307 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	50                   	push   %eax
  8022ee:	68 00 70 80 00       	push   $0x807000
  8022f3:	ff 75 0c             	pushl  0xc(%ebp)
  8022f6:	e8 e7 e8 ff ff       	call   800be2 <memmove>
  8022fb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022fe:	89 d8                	mov    %ebx,%eax
  802300:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802303:	5b                   	pop    %ebx
  802304:	5e                   	pop    %esi
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802307:	68 57 32 80 00       	push   $0x803257
  80230c:	68 1f 32 80 00       	push   $0x80321f
  802311:	6a 62                	push   $0x62
  802313:	68 6c 32 80 00       	push   $0x80326c
  802318:	e8 4b 05 00 00       	call   802868 <_panic>

0080231d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	53                   	push   %ebx
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80232f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802335:	7f 2e                	jg     802365 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	53                   	push   %ebx
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	68 0c 70 80 00       	push   $0x80700c
  802343:	e8 9a e8 ff ff       	call   800be2 <memmove>
	nsipcbuf.send.req_size = size;
  802348:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80234e:	8b 45 14             	mov    0x14(%ebp),%eax
  802351:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802356:	b8 08 00 00 00       	mov    $0x8,%eax
  80235b:	e8 eb fd ff ff       	call   80214b <nsipc>
}
  802360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802363:	c9                   	leave  
  802364:	c3                   	ret    
	assert(size < 1600);
  802365:	68 78 32 80 00       	push   $0x803278
  80236a:	68 1f 32 80 00       	push   $0x80321f
  80236f:	6a 6d                	push   $0x6d
  802371:	68 6c 32 80 00       	push   $0x80326c
  802376:	e8 ed 04 00 00       	call   802868 <_panic>

0080237b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802391:	8b 45 10             	mov    0x10(%ebp),%eax
  802394:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802399:	b8 09 00 00 00       	mov    $0x9,%eax
  80239e:	e8 a8 fd ff ff       	call   80214b <nsipc>
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	56                   	push   %esi
  8023a9:	53                   	push   %ebx
  8023aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023ad:	83 ec 0c             	sub    $0xc,%esp
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	e8 6a f3 ff ff       	call   801722 <fd2data>
  8023b8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023ba:	83 c4 08             	add    $0x8,%esp
  8023bd:	68 84 32 80 00       	push   $0x803284
  8023c2:	53                   	push   %ebx
  8023c3:	e8 8c e6 ff ff       	call   800a54 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c8:	8b 46 04             	mov    0x4(%esi),%eax
  8023cb:	2b 06                	sub    (%esi),%eax
  8023cd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023d3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023da:	00 00 00 
	stat->st_dev = &devpipe;
  8023dd:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8023e4:	40 80 00 
	return 0;
}
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ef:	5b                   	pop    %ebx
  8023f0:	5e                   	pop    %esi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    

008023f3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	53                   	push   %ebx
  8023f7:	83 ec 0c             	sub    $0xc,%esp
  8023fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023fd:	53                   	push   %ebx
  8023fe:	6a 00                	push   $0x0
  802400:	e8 c6 ea ff ff       	call   800ecb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802405:	89 1c 24             	mov    %ebx,(%esp)
  802408:	e8 15 f3 ff ff       	call   801722 <fd2data>
  80240d:	83 c4 08             	add    $0x8,%esp
  802410:	50                   	push   %eax
  802411:	6a 00                	push   $0x0
  802413:	e8 b3 ea ff ff       	call   800ecb <sys_page_unmap>
}
  802418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <_pipeisclosed>:
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	57                   	push   %edi
  802421:	56                   	push   %esi
  802422:	53                   	push   %ebx
  802423:	83 ec 1c             	sub    $0x1c,%esp
  802426:	89 c7                	mov    %eax,%edi
  802428:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80242a:	a1 08 50 80 00       	mov    0x805008,%eax
  80242f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	57                   	push   %edi
  802436:	e8 23 05 00 00       	call   80295e <pageref>
  80243b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80243e:	89 34 24             	mov    %esi,(%esp)
  802441:	e8 18 05 00 00       	call   80295e <pageref>
		nn = thisenv->env_runs;
  802446:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80244c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80244f:	83 c4 10             	add    $0x10,%esp
  802452:	39 cb                	cmp    %ecx,%ebx
  802454:	74 1b                	je     802471 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802456:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802459:	75 cf                	jne    80242a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80245b:	8b 42 58             	mov    0x58(%edx),%eax
  80245e:	6a 01                	push   $0x1
  802460:	50                   	push   %eax
  802461:	53                   	push   %ebx
  802462:	68 8b 32 80 00       	push   $0x80328b
  802467:	e8 89 de ff ff       	call   8002f5 <cprintf>
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	eb b9                	jmp    80242a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802471:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802474:	0f 94 c0             	sete   %al
  802477:	0f b6 c0             	movzbl %al,%eax
}
  80247a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5f                   	pop    %edi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <devpipe_write>:
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	83 ec 28             	sub    $0x28,%esp
  80248b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80248e:	56                   	push   %esi
  80248f:	e8 8e f2 ff ff       	call   801722 <fd2data>
  802494:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802496:	83 c4 10             	add    $0x10,%esp
  802499:	bf 00 00 00 00       	mov    $0x0,%edi
  80249e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024a1:	74 4f                	je     8024f2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024a3:	8b 43 04             	mov    0x4(%ebx),%eax
  8024a6:	8b 0b                	mov    (%ebx),%ecx
  8024a8:	8d 51 20             	lea    0x20(%ecx),%edx
  8024ab:	39 d0                	cmp    %edx,%eax
  8024ad:	72 14                	jb     8024c3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024af:	89 da                	mov    %ebx,%edx
  8024b1:	89 f0                	mov    %esi,%eax
  8024b3:	e8 65 ff ff ff       	call   80241d <_pipeisclosed>
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	75 3b                	jne    8024f7 <devpipe_write+0x75>
			sys_yield();
  8024bc:	e8 66 e9 ff ff       	call   800e27 <sys_yield>
  8024c1:	eb e0                	jmp    8024a3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024c6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ca:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	c1 fa 1f             	sar    $0x1f,%edx
  8024d2:	89 d1                	mov    %edx,%ecx
  8024d4:	c1 e9 1b             	shr    $0x1b,%ecx
  8024d7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024da:	83 e2 1f             	and    $0x1f,%edx
  8024dd:	29 ca                	sub    %ecx,%edx
  8024df:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024e7:	83 c0 01             	add    $0x1,%eax
  8024ea:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024ed:	83 c7 01             	add    $0x1,%edi
  8024f0:	eb ac                	jmp    80249e <devpipe_write+0x1c>
	return i;
  8024f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f5:	eb 05                	jmp    8024fc <devpipe_write+0x7a>
				return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <devpipe_read>:
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	57                   	push   %edi
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
  80250a:	83 ec 18             	sub    $0x18,%esp
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802510:	57                   	push   %edi
  802511:	e8 0c f2 ff ff       	call   801722 <fd2data>
  802516:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	be 00 00 00 00       	mov    $0x0,%esi
  802520:	3b 75 10             	cmp    0x10(%ebp),%esi
  802523:	75 14                	jne    802539 <devpipe_read+0x35>
	return i;
  802525:	8b 45 10             	mov    0x10(%ebp),%eax
  802528:	eb 02                	jmp    80252c <devpipe_read+0x28>
				return i;
  80252a:	89 f0                	mov    %esi,%eax
}
  80252c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
			sys_yield();
  802534:	e8 ee e8 ff ff       	call   800e27 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802539:	8b 03                	mov    (%ebx),%eax
  80253b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80253e:	75 18                	jne    802558 <devpipe_read+0x54>
			if (i > 0)
  802540:	85 f6                	test   %esi,%esi
  802542:	75 e6                	jne    80252a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802544:	89 da                	mov    %ebx,%edx
  802546:	89 f8                	mov    %edi,%eax
  802548:	e8 d0 fe ff ff       	call   80241d <_pipeisclosed>
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 e3                	je     802534 <devpipe_read+0x30>
				return 0;
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
  802556:	eb d4                	jmp    80252c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802558:	99                   	cltd   
  802559:	c1 ea 1b             	shr    $0x1b,%edx
  80255c:	01 d0                	add    %edx,%eax
  80255e:	83 e0 1f             	and    $0x1f,%eax
  802561:	29 d0                	sub    %edx,%eax
  802563:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802568:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80256b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80256e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802571:	83 c6 01             	add    $0x1,%esi
  802574:	eb aa                	jmp    802520 <devpipe_read+0x1c>

00802576 <pipe>:
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	56                   	push   %esi
  80257a:	53                   	push   %ebx
  80257b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80257e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802581:	50                   	push   %eax
  802582:	e8 b2 f1 ff ff       	call   801739 <fd_alloc>
  802587:	89 c3                	mov    %eax,%ebx
  802589:	83 c4 10             	add    $0x10,%esp
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 88 23 01 00 00    	js     8026b7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 07 04 00 00       	push   $0x407
  80259c:	ff 75 f4             	pushl  -0xc(%ebp)
  80259f:	6a 00                	push   $0x0
  8025a1:	e8 a0 e8 ff ff       	call   800e46 <sys_page_alloc>
  8025a6:	89 c3                	mov    %eax,%ebx
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 88 04 01 00 00    	js     8026b7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b9:	50                   	push   %eax
  8025ba:	e8 7a f1 ff ff       	call   801739 <fd_alloc>
  8025bf:	89 c3                	mov    %eax,%ebx
  8025c1:	83 c4 10             	add    $0x10,%esp
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	0f 88 db 00 00 00    	js     8026a7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	68 07 04 00 00       	push   $0x407
  8025d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d7:	6a 00                	push   $0x0
  8025d9:	e8 68 e8 ff ff       	call   800e46 <sys_page_alloc>
  8025de:	89 c3                	mov    %eax,%ebx
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	0f 88 bc 00 00 00    	js     8026a7 <pipe+0x131>
	va = fd2data(fd0);
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f1:	e8 2c f1 ff ff       	call   801722 <fd2data>
  8025f6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f8:	83 c4 0c             	add    $0xc,%esp
  8025fb:	68 07 04 00 00       	push   $0x407
  802600:	50                   	push   %eax
  802601:	6a 00                	push   $0x0
  802603:	e8 3e e8 ff ff       	call   800e46 <sys_page_alloc>
  802608:	89 c3                	mov    %eax,%ebx
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 88 82 00 00 00    	js     802697 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802615:	83 ec 0c             	sub    $0xc,%esp
  802618:	ff 75 f0             	pushl  -0x10(%ebp)
  80261b:	e8 02 f1 ff ff       	call   801722 <fd2data>
  802620:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802627:	50                   	push   %eax
  802628:	6a 00                	push   $0x0
  80262a:	56                   	push   %esi
  80262b:	6a 00                	push   $0x0
  80262d:	e8 57 e8 ff ff       	call   800e89 <sys_page_map>
  802632:	89 c3                	mov    %eax,%ebx
  802634:	83 c4 20             	add    $0x20,%esp
  802637:	85 c0                	test   %eax,%eax
  802639:	78 4e                	js     802689 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80263b:	a1 44 40 80 00       	mov    0x804044,%eax
  802640:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802643:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802648:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80264f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802652:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	ff 75 f4             	pushl  -0xc(%ebp)
  802664:	e8 a9 f0 ff ff       	call   801712 <fd2num>
  802669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80266c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80266e:	83 c4 04             	add    $0x4,%esp
  802671:	ff 75 f0             	pushl  -0x10(%ebp)
  802674:	e8 99 f0 ff ff       	call   801712 <fd2num>
  802679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	bb 00 00 00 00       	mov    $0x0,%ebx
  802687:	eb 2e                	jmp    8026b7 <pipe+0x141>
	sys_page_unmap(0, va);
  802689:	83 ec 08             	sub    $0x8,%esp
  80268c:	56                   	push   %esi
  80268d:	6a 00                	push   $0x0
  80268f:	e8 37 e8 ff ff       	call   800ecb <sys_page_unmap>
  802694:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802697:	83 ec 08             	sub    $0x8,%esp
  80269a:	ff 75 f0             	pushl  -0x10(%ebp)
  80269d:	6a 00                	push   $0x0
  80269f:	e8 27 e8 ff ff       	call   800ecb <sys_page_unmap>
  8026a4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026a7:	83 ec 08             	sub    $0x8,%esp
  8026aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ad:	6a 00                	push   $0x0
  8026af:	e8 17 e8 ff ff       	call   800ecb <sys_page_unmap>
  8026b4:	83 c4 10             	add    $0x10,%esp
}
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026bc:	5b                   	pop    %ebx
  8026bd:	5e                   	pop    %esi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    

008026c0 <pipeisclosed>:
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c9:	50                   	push   %eax
  8026ca:	ff 75 08             	pushl  0x8(%ebp)
  8026cd:	e8 b9 f0 ff ff       	call   80178b <fd_lookup>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	78 18                	js     8026f1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026d9:	83 ec 0c             	sub    $0xc,%esp
  8026dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026df:	e8 3e f0 ff ff       	call   801722 <fd2data>
	return _pipeisclosed(fd, p);
  8026e4:	89 c2                	mov    %eax,%edx
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	e8 2f fd ff ff       	call   80241d <_pipeisclosed>
  8026ee:	83 c4 10             	add    $0x10,%esp
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	c3                   	ret    

008026f9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ff:	68 a3 32 80 00       	push   $0x8032a3
  802704:	ff 75 0c             	pushl  0xc(%ebp)
  802707:	e8 48 e3 ff ff       	call   800a54 <strcpy>
	return 0;
}
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <devcons_write>:
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
  802716:	57                   	push   %edi
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80271f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802724:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80272a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80272d:	73 31                	jae    802760 <devcons_write+0x4d>
		m = n - tot;
  80272f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802732:	29 f3                	sub    %esi,%ebx
  802734:	83 fb 7f             	cmp    $0x7f,%ebx
  802737:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80273c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	53                   	push   %ebx
  802743:	89 f0                	mov    %esi,%eax
  802745:	03 45 0c             	add    0xc(%ebp),%eax
  802748:	50                   	push   %eax
  802749:	57                   	push   %edi
  80274a:	e8 93 e4 ff ff       	call   800be2 <memmove>
		sys_cputs(buf, m);
  80274f:	83 c4 08             	add    $0x8,%esp
  802752:	53                   	push   %ebx
  802753:	57                   	push   %edi
  802754:	e8 31 e6 ff ff       	call   800d8a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802759:	01 de                	add    %ebx,%esi
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	eb ca                	jmp    80272a <devcons_write+0x17>
}
  802760:	89 f0                	mov    %esi,%eax
  802762:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <devcons_read>:
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 08             	sub    $0x8,%esp
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802775:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802779:	74 21                	je     80279c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80277b:	e8 28 e6 ff ff       	call   800da8 <sys_cgetc>
  802780:	85 c0                	test   %eax,%eax
  802782:	75 07                	jne    80278b <devcons_read+0x21>
		sys_yield();
  802784:	e8 9e e6 ff ff       	call   800e27 <sys_yield>
  802789:	eb f0                	jmp    80277b <devcons_read+0x11>
	if (c < 0)
  80278b:	78 0f                	js     80279c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80278d:	83 f8 04             	cmp    $0x4,%eax
  802790:	74 0c                	je     80279e <devcons_read+0x34>
	*(char*)vbuf = c;
  802792:	8b 55 0c             	mov    0xc(%ebp),%edx
  802795:	88 02                	mov    %al,(%edx)
	return 1;
  802797:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    
		return 0;
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	eb f7                	jmp    80279c <devcons_read+0x32>

008027a5 <cputchar>:
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027b1:	6a 01                	push   $0x1
  8027b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027b6:	50                   	push   %eax
  8027b7:	e8 ce e5 ff ff       	call   800d8a <sys_cputs>
}
  8027bc:	83 c4 10             	add    $0x10,%esp
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <getchar>:
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027c7:	6a 01                	push   $0x1
  8027c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027cc:	50                   	push   %eax
  8027cd:	6a 00                	push   $0x0
  8027cf:	e8 27 f2 ff ff       	call   8019fb <read>
	if (r < 0)
  8027d4:	83 c4 10             	add    $0x10,%esp
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	78 06                	js     8027e1 <getchar+0x20>
	if (r < 1)
  8027db:	74 06                	je     8027e3 <getchar+0x22>
	return c;
  8027dd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    
		return -E_EOF;
  8027e3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027e8:	eb f7                	jmp    8027e1 <getchar+0x20>

008027ea <iscons>:
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f3:	50                   	push   %eax
  8027f4:	ff 75 08             	pushl  0x8(%ebp)
  8027f7:	e8 8f ef ff ff       	call   80178b <fd_lookup>
  8027fc:	83 c4 10             	add    $0x10,%esp
  8027ff:	85 c0                	test   %eax,%eax
  802801:	78 11                	js     802814 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 15 60 40 80 00    	mov    0x804060,%edx
  80280c:	39 10                	cmp    %edx,(%eax)
  80280e:	0f 94 c0             	sete   %al
  802811:	0f b6 c0             	movzbl %al,%eax
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <opencons>:
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80281c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80281f:	50                   	push   %eax
  802820:	e8 14 ef ff ff       	call   801739 <fd_alloc>
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	85 c0                	test   %eax,%eax
  80282a:	78 3a                	js     802866 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 07 04 00 00       	push   $0x407
  802834:	ff 75 f4             	pushl  -0xc(%ebp)
  802837:	6a 00                	push   $0x0
  802839:	e8 08 e6 ff ff       	call   800e46 <sys_page_alloc>
  80283e:	83 c4 10             	add    $0x10,%esp
  802841:	85 c0                	test   %eax,%eax
  802843:	78 21                	js     802866 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 15 60 40 80 00    	mov    0x804060,%edx
  80284e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	50                   	push   %eax
  80285e:	e8 af ee ff ff       	call   801712 <fd2num>
  802863:	83 c4 10             	add    $0x10,%esp
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	56                   	push   %esi
  80286c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80286d:	a1 08 50 80 00       	mov    0x805008,%eax
  802872:	8b 40 48             	mov    0x48(%eax),%eax
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 e0 32 80 00       	push   $0x8032e0
  80287d:	50                   	push   %eax
  80287e:	68 af 32 80 00       	push   $0x8032af
  802883:	e8 6d da ff ff       	call   8002f5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802888:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80288b:	8b 35 08 40 80 00    	mov    0x804008,%esi
  802891:	e8 72 e5 ff ff       	call   800e08 <sys_getenvid>
  802896:	83 c4 04             	add    $0x4,%esp
  802899:	ff 75 0c             	pushl  0xc(%ebp)
  80289c:	ff 75 08             	pushl  0x8(%ebp)
  80289f:	56                   	push   %esi
  8028a0:	50                   	push   %eax
  8028a1:	68 bc 32 80 00       	push   $0x8032bc
  8028a6:	e8 4a da ff ff       	call   8002f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8028ab:	83 c4 18             	add    $0x18,%esp
  8028ae:	53                   	push   %ebx
  8028af:	ff 75 10             	pushl  0x10(%ebp)
  8028b2:	e8 ed d9 ff ff       	call   8002a4 <vcprintf>
	cprintf("\n");
  8028b7:	c7 04 24 ad 2c 80 00 	movl   $0x802cad,(%esp)
  8028be:	e8 32 da ff ff       	call   8002f5 <cprintf>
  8028c3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8028c6:	cc                   	int3   
  8028c7:	eb fd                	jmp    8028c6 <_panic+0x5e>

008028c9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028cf:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028d6:	74 0a                	je     8028e2 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028e0:	c9                   	leave  
  8028e1:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	6a 07                	push   $0x7
  8028e7:	68 00 f0 bf ee       	push   $0xeebff000
  8028ec:	6a 00                	push   $0x0
  8028ee:	e8 53 e5 ff ff       	call   800e46 <sys_page_alloc>
		if(r < 0)
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	78 2a                	js     802924 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028fa:	83 ec 08             	sub    $0x8,%esp
  8028fd:	68 38 29 80 00       	push   $0x802938
  802902:	6a 00                	push   $0x0
  802904:	e8 88 e6 ff ff       	call   800f91 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802909:	83 c4 10             	add    $0x10,%esp
  80290c:	85 c0                	test   %eax,%eax
  80290e:	79 c8                	jns    8028d8 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	68 18 33 80 00       	push   $0x803318
  802918:	6a 25                	push   $0x25
  80291a:	68 54 33 80 00       	push   $0x803354
  80291f:	e8 44 ff ff ff       	call   802868 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 e8 32 80 00       	push   $0x8032e8
  80292c:	6a 22                	push   $0x22
  80292e:	68 54 33 80 00       	push   $0x803354
  802933:	e8 30 ff ff ff       	call   802868 <_panic>

00802938 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802938:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802939:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80293e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802940:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802943:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802947:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80294b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80294e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802950:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802954:	83 c4 08             	add    $0x8,%esp
	popal
  802957:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802958:	83 c4 04             	add    $0x4,%esp
	popfl
  80295b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80295c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80295d:	c3                   	ret    

0080295e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
  802961:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802964:	89 d0                	mov    %edx,%eax
  802966:	c1 e8 16             	shr    $0x16,%eax
  802969:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802970:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802975:	f6 c1 01             	test   $0x1,%cl
  802978:	74 1d                	je     802997 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80297a:	c1 ea 0c             	shr    $0xc,%edx
  80297d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802984:	f6 c2 01             	test   $0x1,%dl
  802987:	74 0e                	je     802997 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802989:	c1 ea 0c             	shr    $0xc,%edx
  80298c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802993:	ef 
  802994:	0f b7 c0             	movzwl %ax,%eax
}
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    
  802999:	66 90                	xchg   %ax,%ax
  80299b:	66 90                	xchg   %ax,%ax
  80299d:	66 90                	xchg   %ax,%ax
  80299f:	90                   	nop

008029a0 <__udivdi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	57                   	push   %edi
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 1c             	sub    $0x1c,%esp
  8029a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029b7:	85 d2                	test   %edx,%edx
  8029b9:	75 4d                	jne    802a08 <__udivdi3+0x68>
  8029bb:	39 f3                	cmp    %esi,%ebx
  8029bd:	76 19                	jbe    8029d8 <__udivdi3+0x38>
  8029bf:	31 ff                	xor    %edi,%edi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	f7 f3                	div    %ebx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 d9                	mov    %ebx,%ecx
  8029da:	85 db                	test   %ebx,%ebx
  8029dc:	75 0b                	jne    8029e9 <__udivdi3+0x49>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 c1                	mov    %eax,%ecx
  8029e9:	31 d2                	xor    %edx,%edx
  8029eb:	89 f0                	mov    %esi,%eax
  8029ed:	f7 f1                	div    %ecx
  8029ef:	89 c6                	mov    %eax,%esi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f7                	mov    %esi,%edi
  8029f5:	f7 f1                	div    %ecx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	39 f2                	cmp    %esi,%edx
  802a0a:	77 1c                	ja     802a28 <__udivdi3+0x88>
  802a0c:	0f bd fa             	bsr    %edx,%edi
  802a0f:	83 f7 1f             	xor    $0x1f,%edi
  802a12:	75 2c                	jne    802a40 <__udivdi3+0xa0>
  802a14:	39 f2                	cmp    %esi,%edx
  802a16:	72 06                	jb     802a1e <__udivdi3+0x7e>
  802a18:	31 c0                	xor    %eax,%eax
  802a1a:	39 eb                	cmp    %ebp,%ebx
  802a1c:	77 a9                	ja     8029c7 <__udivdi3+0x27>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	eb a2                	jmp    8029c7 <__udivdi3+0x27>
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	31 ff                	xor    %edi,%edi
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	89 fa                	mov    %edi,%edx
  802a2e:	83 c4 1c             	add    $0x1c,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
  802a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	89 f9                	mov    %edi,%ecx
  802a42:	b8 20 00 00 00       	mov    $0x20,%eax
  802a47:	29 f8                	sub    %edi,%eax
  802a49:	d3 e2                	shl    %cl,%edx
  802a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	89 da                	mov    %ebx,%edx
  802a53:	d3 ea                	shr    %cl,%edx
  802a55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a59:	09 d1                	or     %edx,%ecx
  802a5b:	89 f2                	mov    %esi,%edx
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 f9                	mov    %edi,%ecx
  802a63:	d3 e3                	shl    %cl,%ebx
  802a65:	89 c1                	mov    %eax,%ecx
  802a67:	d3 ea                	shr    %cl,%edx
  802a69:	89 f9                	mov    %edi,%ecx
  802a6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a6f:	89 eb                	mov    %ebp,%ebx
  802a71:	d3 e6                	shl    %cl,%esi
  802a73:	89 c1                	mov    %eax,%ecx
  802a75:	d3 eb                	shr    %cl,%ebx
  802a77:	09 de                	or     %ebx,%esi
  802a79:	89 f0                	mov    %esi,%eax
  802a7b:	f7 74 24 08          	divl   0x8(%esp)
  802a7f:	89 d6                	mov    %edx,%esi
  802a81:	89 c3                	mov    %eax,%ebx
  802a83:	f7 64 24 0c          	mull   0xc(%esp)
  802a87:	39 d6                	cmp    %edx,%esi
  802a89:	72 15                	jb     802aa0 <__udivdi3+0x100>
  802a8b:	89 f9                	mov    %edi,%ecx
  802a8d:	d3 e5                	shl    %cl,%ebp
  802a8f:	39 c5                	cmp    %eax,%ebp
  802a91:	73 04                	jae    802a97 <__udivdi3+0xf7>
  802a93:	39 d6                	cmp    %edx,%esi
  802a95:	74 09                	je     802aa0 <__udivdi3+0x100>
  802a97:	89 d8                	mov    %ebx,%eax
  802a99:	31 ff                	xor    %edi,%edi
  802a9b:	e9 27 ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802aa3:	31 ff                	xor    %edi,%edi
  802aa5:	e9 1d ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	66 90                	xchg   %ax,%ax
  802aae:	66 90                	xchg   %ax,%ax

00802ab0 <__umoddi3>:
  802ab0:	55                   	push   %ebp
  802ab1:	57                   	push   %edi
  802ab2:	56                   	push   %esi
  802ab3:	53                   	push   %ebx
  802ab4:	83 ec 1c             	sub    $0x1c,%esp
  802ab7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802abf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ac7:	89 da                	mov    %ebx,%edx
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	75 43                	jne    802b10 <__umoddi3+0x60>
  802acd:	39 df                	cmp    %ebx,%edi
  802acf:	76 17                	jbe    802ae8 <__umoddi3+0x38>
  802ad1:	89 f0                	mov    %esi,%eax
  802ad3:	f7 f7                	div    %edi
  802ad5:	89 d0                	mov    %edx,%eax
  802ad7:	31 d2                	xor    %edx,%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	89 fd                	mov    %edi,%ebp
  802aea:	85 ff                	test   %edi,%edi
  802aec:	75 0b                	jne    802af9 <__umoddi3+0x49>
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	31 d2                	xor    %edx,%edx
  802af5:	f7 f7                	div    %edi
  802af7:	89 c5                	mov    %eax,%ebp
  802af9:	89 d8                	mov    %ebx,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f5                	div    %ebp
  802aff:	89 f0                	mov    %esi,%eax
  802b01:	f7 f5                	div    %ebp
  802b03:	89 d0                	mov    %edx,%eax
  802b05:	eb d0                	jmp    802ad7 <__umoddi3+0x27>
  802b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0e:	66 90                	xchg   %ax,%ax
  802b10:	89 f1                	mov    %esi,%ecx
  802b12:	39 d8                	cmp    %ebx,%eax
  802b14:	76 0a                	jbe    802b20 <__umoddi3+0x70>
  802b16:	89 f0                	mov    %esi,%eax
  802b18:	83 c4 1c             	add    $0x1c,%esp
  802b1b:	5b                   	pop    %ebx
  802b1c:	5e                   	pop    %esi
  802b1d:	5f                   	pop    %edi
  802b1e:	5d                   	pop    %ebp
  802b1f:	c3                   	ret    
  802b20:	0f bd e8             	bsr    %eax,%ebp
  802b23:	83 f5 1f             	xor    $0x1f,%ebp
  802b26:	75 20                	jne    802b48 <__umoddi3+0x98>
  802b28:	39 d8                	cmp    %ebx,%eax
  802b2a:	0f 82 b0 00 00 00    	jb     802be0 <__umoddi3+0x130>
  802b30:	39 f7                	cmp    %esi,%edi
  802b32:	0f 86 a8 00 00 00    	jbe    802be0 <__umoddi3+0x130>
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	83 c4 1c             	add    $0x1c,%esp
  802b3d:	5b                   	pop    %ebx
  802b3e:	5e                   	pop    %esi
  802b3f:	5f                   	pop    %edi
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    
  802b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b4f:	29 ea                	sub    %ebp,%edx
  802b51:	d3 e0                	shl    %cl,%eax
  802b53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b57:	89 d1                	mov    %edx,%ecx
  802b59:	89 f8                	mov    %edi,%eax
  802b5b:	d3 e8                	shr    %cl,%eax
  802b5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b69:	09 c1                	or     %eax,%ecx
  802b6b:	89 d8                	mov    %ebx,%eax
  802b6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b71:	89 e9                	mov    %ebp,%ecx
  802b73:	d3 e7                	shl    %cl,%edi
  802b75:	89 d1                	mov    %edx,%ecx
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b7f:	d3 e3                	shl    %cl,%ebx
  802b81:	89 c7                	mov    %eax,%edi
  802b83:	89 d1                	mov    %edx,%ecx
  802b85:	89 f0                	mov    %esi,%eax
  802b87:	d3 e8                	shr    %cl,%eax
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	89 fa                	mov    %edi,%edx
  802b8d:	d3 e6                	shl    %cl,%esi
  802b8f:	09 d8                	or     %ebx,%eax
  802b91:	f7 74 24 08          	divl   0x8(%esp)
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	89 f3                	mov    %esi,%ebx
  802b99:	f7 64 24 0c          	mull   0xc(%esp)
  802b9d:	89 c6                	mov    %eax,%esi
  802b9f:	89 d7                	mov    %edx,%edi
  802ba1:	39 d1                	cmp    %edx,%ecx
  802ba3:	72 06                	jb     802bab <__umoddi3+0xfb>
  802ba5:	75 10                	jne    802bb7 <__umoddi3+0x107>
  802ba7:	39 c3                	cmp    %eax,%ebx
  802ba9:	73 0c                	jae    802bb7 <__umoddi3+0x107>
  802bab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802baf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bb3:	89 d7                	mov    %edx,%edi
  802bb5:	89 c6                	mov    %eax,%esi
  802bb7:	89 ca                	mov    %ecx,%edx
  802bb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bbe:	29 f3                	sub    %esi,%ebx
  802bc0:	19 fa                	sbb    %edi,%edx
  802bc2:	89 d0                	mov    %edx,%eax
  802bc4:	d3 e0                	shl    %cl,%eax
  802bc6:	89 e9                	mov    %ebp,%ecx
  802bc8:	d3 eb                	shr    %cl,%ebx
  802bca:	d3 ea                	shr    %cl,%edx
  802bcc:	09 d8                	or     %ebx,%eax
  802bce:	83 c4 1c             	add    $0x1c,%esp
  802bd1:	5b                   	pop    %ebx
  802bd2:	5e                   	pop    %esi
  802bd3:	5f                   	pop    %edi
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    
  802bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	89 da                	mov    %ebx,%edx
  802be2:	29 fe                	sub    %edi,%esi
  802be4:	19 c2                	sbb    %eax,%edx
  802be6:	89 f1                	mov    %esi,%ecx
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	e9 4b ff ff ff       	jmp    802b3a <__umoddi3+0x8a>
