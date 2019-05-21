
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
  800039:	e8 31 12 00 00       	call   80126f <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 d0 0d 00 00       	call   800e31 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 20 80 00    	pushl  0x802004
  80006a:	e8 97 09 00 00       	call   800a06 <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 20 80 00    	pushl  0x802004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 a9 0b 00 00       	call   800c2f <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 ed 14 00 00       	call   801584 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 71 14 00 00       	call   80151b <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 60 19 80 00       	push   $0x801960
  8000ba:	e8 21 02 00 00       	call   8002e0 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 20 80 00    	pushl  0x802000
  8000c8:	e8 39 09 00 00       	call   800a06 <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 20 80 00    	pushl  0x802000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 2f 0a 00 00       	call   800b10 <strncmp>
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
  8000fc:	e8 1a 14 00 00       	call   80151b <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 60 19 80 00       	push   $0x801960
  800111:	e8 ca 01 00 00       	call   8002e0 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 20 80 00    	pushl  0x802004
  80011f:	e8 e2 08 00 00       	call   800a06 <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 20 80 00    	pushl  0x802004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 d8 09 00 00       	call   800b10 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 20 80 00    	pushl  0x802000
  800148:	e8 b9 08 00 00       	call   800a06 <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 20 80 00    	pushl  0x802000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 cb 0a 00 00       	call   800c2f <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 0f 14 00 00       	call   801584 <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 74 19 80 00       	push   $0x801974
  800185:	e8 56 01 00 00       	call   8002e0 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 94 19 80 00       	push   $0x801994
  800197:	e8 44 01 00 00       	call   8002e0 <cprintf>
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
  8001ad:	c7 05 0c 20 80 00 00 	movl   $0x0,0x80200c
  8001b4:	00 00 00 
	envid_t find = sys_getenvid();
  8001b7:	e8 37 0c 00 00       	call   800df3 <sys_getenvid>
  8001bc:	8b 1d 0c 20 80 00    	mov    0x80200c,%ebx
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
  800205:	89 1d 0c 20 80 00    	mov    %ebx,0x80200c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020f:	7e 0a                	jle    80021b <libmain+0x77>
		binaryname = argv[0];
  800211:	8b 45 0c             	mov    0xc(%ebp),%eax
  800214:	8b 00                	mov    (%eax),%eax
  800216:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	ff 75 0c             	pushl  0xc(%ebp)
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 0a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800229:	e8 0b 00 00 00       	call   800239 <exit>
}
  80022e:	83 c4 10             	add    $0x10,%esp
  800231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800234:	5b                   	pop    %ebx
  800235:	5e                   	pop    %esi
  800236:	5f                   	pop    %edi
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80023f:	6a 00                	push   $0x0
  800241:	e8 6c 0b 00 00       	call   800db2 <sys_env_destroy>
}
  800246:	83 c4 10             	add    $0x10,%esp
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	53                   	push   %ebx
  80024f:	83 ec 04             	sub    $0x4,%esp
  800252:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800255:	8b 13                	mov    (%ebx),%edx
  800257:	8d 42 01             	lea    0x1(%edx),%eax
  80025a:	89 03                	mov    %eax,(%ebx)
  80025c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800263:	3d ff 00 00 00       	cmp    $0xff,%eax
  800268:	74 09                	je     800273 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80026a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800271:	c9                   	leave  
  800272:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	68 ff 00 00 00       	push   $0xff
  80027b:	8d 43 08             	lea    0x8(%ebx),%eax
  80027e:	50                   	push   %eax
  80027f:	e8 f1 0a 00 00       	call   800d75 <sys_cputs>
		b->idx = 0;
  800284:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80028a:	83 c4 10             	add    $0x10,%esp
  80028d:	eb db                	jmp    80026a <putch+0x1f>

0080028f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800298:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029f:	00 00 00 
	b.cnt = 0;
  8002a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ac:	ff 75 0c             	pushl  0xc(%ebp)
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	68 4b 02 80 00       	push   $0x80024b
  8002be:	e8 4a 01 00 00       	call   80040d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c3:	83 c4 08             	add    $0x8,%esp
  8002c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d2:	50                   	push   %eax
  8002d3:	e8 9d 0a 00 00       	call   800d75 <sys_cputs>

	return b.cnt;
}
  8002d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002e9:	50                   	push   %eax
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 9d ff ff ff       	call   80028f <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
  8002fd:	89 c6                	mov    %eax,%esi
  8002ff:	89 d7                	mov    %edx,%edi
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80030d:	8b 45 10             	mov    0x10(%ebp),%eax
  800310:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800313:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800317:	74 2c                	je     800345 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800319:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800323:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800326:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800329:	39 c2                	cmp    %eax,%edx
  80032b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80032e:	73 43                	jae    800373 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800330:	83 eb 01             	sub    $0x1,%ebx
  800333:	85 db                	test   %ebx,%ebx
  800335:	7e 6c                	jle    8003a3 <printnum+0xaf>
				putch(padc, putdat);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	57                   	push   %edi
  80033b:	ff 75 18             	pushl  0x18(%ebp)
  80033e:	ff d6                	call   *%esi
  800340:	83 c4 10             	add    $0x10,%esp
  800343:	eb eb                	jmp    800330 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	6a 20                	push   $0x20
  80034a:	6a 00                	push   $0x0
  80034c:	50                   	push   %eax
  80034d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800350:	ff 75 e0             	pushl  -0x20(%ebp)
  800353:	89 fa                	mov    %edi,%edx
  800355:	89 f0                	mov    %esi,%eax
  800357:	e8 98 ff ff ff       	call   8002f4 <printnum>
		while (--width > 0)
  80035c:	83 c4 20             	add    $0x20,%esp
  80035f:	83 eb 01             	sub    $0x1,%ebx
  800362:	85 db                	test   %ebx,%ebx
  800364:	7e 65                	jle    8003cb <printnum+0xd7>
			putch(padc, putdat);
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	57                   	push   %edi
  80036a:	6a 20                	push   $0x20
  80036c:	ff d6                	call   *%esi
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	eb ec                	jmp    80035f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	ff 75 18             	pushl  0x18(%ebp)
  800379:	83 eb 01             	sub    $0x1,%ebx
  80037c:	53                   	push   %ebx
  80037d:	50                   	push   %eax
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	ff 75 dc             	pushl  -0x24(%ebp)
  800384:	ff 75 d8             	pushl  -0x28(%ebp)
  800387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038a:	ff 75 e0             	pushl  -0x20(%ebp)
  80038d:	e8 7e 13 00 00       	call   801710 <__udivdi3>
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	89 fa                	mov    %edi,%edx
  800399:	89 f0                	mov    %esi,%eax
  80039b:	e8 54 ff ff ff       	call   8002f4 <printnum>
  8003a0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	57                   	push   %edi
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b6:	e8 65 14 00 00       	call   801820 <__umoddi3>
  8003bb:	83 c4 14             	add    $0x14,%esp
  8003be:	0f be 80 0c 1a 80 00 	movsbl 0x801a0c(%eax),%eax
  8003c5:	50                   	push   %eax
  8003c6:	ff d6                	call   *%esi
  8003c8:	83 c4 10             	add    $0x10,%esp
	}
}
  8003cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ce:	5b                   	pop    %ebx
  8003cf:	5e                   	pop    %esi
  8003d0:	5f                   	pop    %edi
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    

008003d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dd:	8b 10                	mov    (%eax),%edx
  8003df:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e2:	73 0a                	jae    8003ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e7:	89 08                	mov    %ecx,(%eax)
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	88 02                	mov    %al,(%edx)
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <printfmt>:
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f9:	50                   	push   %eax
  8003fa:	ff 75 10             	pushl  0x10(%ebp)
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 05 00 00 00       	call   80040d <vprintfmt>
}
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <vprintfmt>:
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 3c             	sub    $0x3c,%esp
  800416:	8b 75 08             	mov    0x8(%ebp),%esi
  800419:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041f:	e9 32 04 00 00       	jmp    800856 <vprintfmt+0x449>
		padc = ' ';
  800424:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800428:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80042f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800436:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80043d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800444:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80044b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8d 47 01             	lea    0x1(%edi),%eax
  800453:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800456:	0f b6 17             	movzbl (%edi),%edx
  800459:	8d 42 dd             	lea    -0x23(%edx),%eax
  80045c:	3c 55                	cmp    $0x55,%al
  80045e:	0f 87 12 05 00 00    	ja     800976 <vprintfmt+0x569>
  800464:	0f b6 c0             	movzbl %al,%eax
  800467:	ff 24 85 e0 1b 80 00 	jmp    *0x801be0(,%eax,4)
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800471:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800475:	eb d9                	jmp    800450 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80047a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80047e:	eb d0                	jmp    800450 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800480:	0f b6 d2             	movzbl %dl,%edx
  800483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	89 75 08             	mov    %esi,0x8(%ebp)
  80048e:	eb 03                	jmp    800493 <vprintfmt+0x86>
  800490:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800493:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800496:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049d:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004a0:	83 fe 09             	cmp    $0x9,%esi
  8004a3:	76 eb                	jbe    800490 <vprintfmt+0x83>
  8004a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ab:	eb 14                	jmp    8004c1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8d 40 04             	lea    0x4(%eax),%eax
  8004bb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c5:	79 89                	jns    800450 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d4:	e9 77 ff ff ff       	jmp    800450 <vprintfmt+0x43>
  8004d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dc:	85 c0                	test   %eax,%eax
  8004de:	0f 48 c1             	cmovs  %ecx,%eax
  8004e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e7:	e9 64 ff ff ff       	jmp    800450 <vprintfmt+0x43>
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ef:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004f6:	e9 55 ff ff ff       	jmp    800450 <vprintfmt+0x43>
			lflag++;
  8004fb:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800502:	e9 49 ff ff ff       	jmp    800450 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 78 04             	lea    0x4(%eax),%edi
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	ff 30                	pushl  (%eax)
  800513:	ff d6                	call   *%esi
			break;
  800515:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800518:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80051b:	e9 33 03 00 00       	jmp    800853 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 78 04             	lea    0x4(%eax),%edi
  800526:	8b 00                	mov    (%eax),%eax
  800528:	99                   	cltd   
  800529:	31 d0                	xor    %edx,%eax
  80052b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052d:	83 f8 0f             	cmp    $0xf,%eax
  800530:	7f 23                	jg     800555 <vprintfmt+0x148>
  800532:	8b 14 85 40 1d 80 00 	mov    0x801d40(,%eax,4),%edx
  800539:	85 d2                	test   %edx,%edx
  80053b:	74 18                	je     800555 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80053d:	52                   	push   %edx
  80053e:	68 2d 1a 80 00       	push   $0x801a2d
  800543:	53                   	push   %ebx
  800544:	56                   	push   %esi
  800545:	e8 a6 fe ff ff       	call   8003f0 <printfmt>
  80054a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800550:	e9 fe 02 00 00       	jmp    800853 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800555:	50                   	push   %eax
  800556:	68 24 1a 80 00       	push   $0x801a24
  80055b:	53                   	push   %ebx
  80055c:	56                   	push   %esi
  80055d:	e8 8e fe ff ff       	call   8003f0 <printfmt>
  800562:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800565:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800568:	e9 e6 02 00 00       	jmp    800853 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	83 c0 04             	add    $0x4,%eax
  800573:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80057b:	85 c9                	test   %ecx,%ecx
  80057d:	b8 1d 1a 80 00       	mov    $0x801a1d,%eax
  800582:	0f 45 c1             	cmovne %ecx,%eax
  800585:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800588:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058c:	7e 06                	jle    800594 <vprintfmt+0x187>
  80058e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800592:	75 0d                	jne    8005a1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800594:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800597:	89 c7                	mov    %eax,%edi
  800599:	03 45 e0             	add    -0x20(%ebp),%eax
  80059c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059f:	eb 53                	jmp    8005f4 <vprintfmt+0x1e7>
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a7:	50                   	push   %eax
  8005a8:	e8 71 04 00 00       	call   800a1e <strnlen>
  8005ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b0:	29 c1                	sub    %eax,%ecx
  8005b2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005ba:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	eb 0f                	jmp    8005d2 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	53                   	push   %ebx
  8005c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ca:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cc:	83 ef 01             	sub    $0x1,%edi
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	85 ff                	test   %edi,%edi
  8005d4:	7f ed                	jg     8005c3 <vprintfmt+0x1b6>
  8005d6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005d9:	85 c9                	test   %ecx,%ecx
  8005db:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e0:	0f 49 c1             	cmovns %ecx,%eax
  8005e3:	29 c1                	sub    %eax,%ecx
  8005e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e8:	eb aa                	jmp    800594 <vprintfmt+0x187>
					putch(ch, putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	53                   	push   %ebx
  8005ee:	52                   	push   %edx
  8005ef:	ff d6                	call   *%esi
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f9:	83 c7 01             	add    $0x1,%edi
  8005fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800600:	0f be d0             	movsbl %al,%edx
  800603:	85 d2                	test   %edx,%edx
  800605:	74 4b                	je     800652 <vprintfmt+0x245>
  800607:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060b:	78 06                	js     800613 <vprintfmt+0x206>
  80060d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800611:	78 1e                	js     800631 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800613:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800617:	74 d1                	je     8005ea <vprintfmt+0x1dd>
  800619:	0f be c0             	movsbl %al,%eax
  80061c:	83 e8 20             	sub    $0x20,%eax
  80061f:	83 f8 5e             	cmp    $0x5e,%eax
  800622:	76 c6                	jbe    8005ea <vprintfmt+0x1dd>
					putch('?', putdat);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	6a 3f                	push   $0x3f
  80062a:	ff d6                	call   *%esi
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	eb c3                	jmp    8005f4 <vprintfmt+0x1e7>
  800631:	89 cf                	mov    %ecx,%edi
  800633:	eb 0e                	jmp    800643 <vprintfmt+0x236>
				putch(' ', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 20                	push   $0x20
  80063b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063d:	83 ef 01             	sub    $0x1,%edi
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	85 ff                	test   %edi,%edi
  800645:	7f ee                	jg     800635 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800647:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
  80064d:	e9 01 02 00 00       	jmp    800853 <vprintfmt+0x446>
  800652:	89 cf                	mov    %ecx,%edi
  800654:	eb ed                	jmp    800643 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800659:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800660:	e9 eb fd ff ff       	jmp    800450 <vprintfmt+0x43>
	if (lflag >= 2)
  800665:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800669:	7f 21                	jg     80068c <vprintfmt+0x27f>
	else if (lflag)
  80066b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80066f:	74 68                	je     8006d9 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800679:	89 c1                	mov    %eax,%ecx
  80067b:	c1 f9 1f             	sar    $0x1f,%ecx
  80067e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
  80068a:	eb 17                	jmp    8006a3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 50 04             	mov    0x4(%eax),%edx
  800692:	8b 00                	mov    (%eax),%eax
  800694:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800697:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 08             	lea    0x8(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b3:	78 3f                	js     8006f4 <vprintfmt+0x2e7>
			base = 10;
  8006b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006ba:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006be:	0f 84 71 01 00 00    	je     800835 <vprintfmt+0x428>
				putch('+', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 2b                	push   $0x2b
  8006ca:	ff d6                	call   *%esi
  8006cc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d4:	e9 5c 01 00 00       	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e1:	89 c1                	mov    %eax,%ecx
  8006e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 04             	lea    0x4(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	eb af                	jmp    8006a3 <vprintfmt+0x296>
				putch('-', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	6a 2d                	push   $0x2d
  8006fa:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800702:	f7 d8                	neg    %eax
  800704:	83 d2 00             	adc    $0x0,%edx
  800707:	f7 da                	neg    %edx
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	e9 19 01 00 00       	jmp    800835 <vprintfmt+0x428>
	if (lflag >= 2)
  80071c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800720:	7f 29                	jg     80074b <vprintfmt+0x33e>
	else if (lflag)
  800722:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800726:	74 44                	je     80076c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800735:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800741:	b8 0a 00 00 00       	mov    $0xa,%eax
  800746:	e9 ea 00 00 00       	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800756:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8d 40 08             	lea    0x8(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800762:	b8 0a 00 00 00       	mov    $0xa,%eax
  800767:	e9 c9 00 00 00       	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
  800776:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800779:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800785:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078a:	e9 a6 00 00 00       	jmp    800835 <vprintfmt+0x428>
			putch('0', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	6a 30                	push   $0x30
  800795:	ff d6                	call   *%esi
	if (lflag >= 2)
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80079e:	7f 26                	jg     8007c6 <vprintfmt+0x3b9>
	else if (lflag)
  8007a0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a4:	74 3e                	je     8007e4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c4:	eb 6f                	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 50 04             	mov    0x4(%eax),%edx
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 08             	lea    0x8(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e2:	eb 51                	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8d 40 04             	lea    0x4(%eax),%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007fd:	b8 08 00 00 00       	mov    $0x8,%eax
  800802:	eb 31                	jmp    800835 <vprintfmt+0x428>
			putch('0', putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	53                   	push   %ebx
  800808:	6a 30                	push   $0x30
  80080a:	ff d6                	call   *%esi
			putch('x', putdat);
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	6a 78                	push   $0x78
  800812:	ff d6                	call   *%esi
			num = (unsigned long long)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800824:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800830:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80083c:	52                   	push   %edx
  80083d:	ff 75 e0             	pushl  -0x20(%ebp)
  800840:	50                   	push   %eax
  800841:	ff 75 dc             	pushl  -0x24(%ebp)
  800844:	ff 75 d8             	pushl  -0x28(%ebp)
  800847:	89 da                	mov    %ebx,%edx
  800849:	89 f0                	mov    %esi,%eax
  80084b:	e8 a4 fa ff ff       	call   8002f4 <printnum>
			break;
  800850:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800853:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800856:	83 c7 01             	add    $0x1,%edi
  800859:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80085d:	83 f8 25             	cmp    $0x25,%eax
  800860:	0f 84 be fb ff ff    	je     800424 <vprintfmt+0x17>
			if (ch == '\0')
  800866:	85 c0                	test   %eax,%eax
  800868:	0f 84 28 01 00 00    	je     800996 <vprintfmt+0x589>
			putch(ch, putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	50                   	push   %eax
  800873:	ff d6                	call   *%esi
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	eb dc                	jmp    800856 <vprintfmt+0x449>
	if (lflag >= 2)
  80087a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80087e:	7f 26                	jg     8008a6 <vprintfmt+0x499>
	else if (lflag)
  800880:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800884:	74 41                	je     8008c7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	ba 00 00 00 00       	mov    $0x0,%edx
  800890:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800893:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8d 40 04             	lea    0x4(%eax),%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089f:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a4:	eb 8f                	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 50 04             	mov    0x4(%eax),%edx
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8d 40 08             	lea    0x8(%eax),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bd:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c2:	e9 6e ff ff ff       	jmp    800835 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 40 04             	lea    0x4(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e0:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e5:	e9 4b ff ff ff       	jmp    800835 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	83 c0 04             	add    $0x4,%eax
  8008f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	74 14                	je     800910 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008fc:	8b 13                	mov    (%ebx),%edx
  8008fe:	83 fa 7f             	cmp    $0x7f,%edx
  800901:	7f 37                	jg     80093a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800903:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800905:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
  80090b:	e9 43 ff ff ff       	jmp    800853 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800910:	b8 0a 00 00 00       	mov    $0xa,%eax
  800915:	bf 45 1b 80 00       	mov    $0x801b45,%edi
							putch(ch, putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	53                   	push   %ebx
  80091e:	50                   	push   %eax
  80091f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800921:	83 c7 01             	add    $0x1,%edi
  800924:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	85 c0                	test   %eax,%eax
  80092d:	75 eb                	jne    80091a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80092f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	e9 19 ff ff ff       	jmp    800853 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80093a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80093c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800941:	bf 7d 1b 80 00       	mov    $0x801b7d,%edi
							putch(ch, putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	53                   	push   %ebx
  80094a:	50                   	push   %eax
  80094b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80094d:	83 c7 01             	add    $0x1,%edi
  800950:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	85 c0                	test   %eax,%eax
  800959:	75 eb                	jne    800946 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80095b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	e9 ed fe ff ff       	jmp    800853 <vprintfmt+0x446>
			putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	53                   	push   %ebx
  80096a:	6a 25                	push   $0x25
  80096c:	ff d6                	call   *%esi
			break;
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	e9 dd fe ff ff       	jmp    800853 <vprintfmt+0x446>
			putch('%', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 25                	push   $0x25
  80097c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	89 f8                	mov    %edi,%eax
  800983:	eb 03                	jmp    800988 <vprintfmt+0x57b>
  800985:	83 e8 01             	sub    $0x1,%eax
  800988:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098c:	75 f7                	jne    800985 <vprintfmt+0x578>
  80098e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800991:	e9 bd fe ff ff       	jmp    800853 <vprintfmt+0x446>
}
  800996:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5f                   	pop    %edi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bb:	85 c0                	test   %eax,%eax
  8009bd:	74 26                	je     8009e5 <vsnprintf+0x47>
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	7e 22                	jle    8009e5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c3:	ff 75 14             	pushl  0x14(%ebp)
  8009c6:	ff 75 10             	pushl  0x10(%ebp)
  8009c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cc:	50                   	push   %eax
  8009cd:	68 d3 03 80 00       	push   $0x8003d3
  8009d2:	e8 36 fa ff ff       	call   80040d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    
		return -E_INVAL;
  8009e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ea:	eb f7                	jmp    8009e3 <vsnprintf+0x45>

008009ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 10             	pushl  0x10(%ebp)
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 9a ff ff ff       	call   80099e <vsnprintf>
	va_end(ap);

	return rc;
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a15:	74 05                	je     800a1c <strlen+0x16>
		n++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	eb f5                	jmp    800a11 <strlen+0xb>
	return n;
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	74 0d                	je     800a3d <strnlen+0x1f>
  800a30:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a34:	74 05                	je     800a3b <strnlen+0x1d>
		n++;
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	eb f1                	jmp    800a2c <strnlen+0xe>
  800a3b:	89 d0                	mov    %edx,%eax
	return n;
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	53                   	push   %ebx
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a52:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a55:	83 c2 01             	add    $0x1,%edx
  800a58:	84 c9                	test   %cl,%cl
  800a5a:	75 f2                	jne    800a4e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a5c:	5b                   	pop    %ebx
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	53                   	push   %ebx
  800a63:	83 ec 10             	sub    $0x10,%esp
  800a66:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a69:	53                   	push   %ebx
  800a6a:	e8 97 ff ff ff       	call   800a06 <strlen>
  800a6f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	01 d8                	add    %ebx,%eax
  800a77:	50                   	push   %eax
  800a78:	e8 c2 ff ff ff       	call   800a3f <strcpy>
	return dst;
}
  800a7d:	89 d8                	mov    %ebx,%eax
  800a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8f:	89 c6                	mov    %eax,%esi
  800a91:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a94:	89 c2                	mov    %eax,%edx
  800a96:	39 f2                	cmp    %esi,%edx
  800a98:	74 11                	je     800aab <strncpy+0x27>
		*dst++ = *src;
  800a9a:	83 c2 01             	add    $0x1,%edx
  800a9d:	0f b6 19             	movzbl (%ecx),%ebx
  800aa0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa3:	80 fb 01             	cmp    $0x1,%bl
  800aa6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aa9:	eb eb                	jmp    800a96 <strncpy+0x12>
	}
	return ret;
}
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aba:	8b 55 10             	mov    0x10(%ebp),%edx
  800abd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800abf:	85 d2                	test   %edx,%edx
  800ac1:	74 21                	je     800ae4 <strlcpy+0x35>
  800ac3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	74 14                	je     800ae1 <strlcpy+0x32>
  800acd:	0f b6 19             	movzbl (%ecx),%ebx
  800ad0:	84 db                	test   %bl,%bl
  800ad2:	74 0b                	je     800adf <strlcpy+0x30>
			*dst++ = *src++;
  800ad4:	83 c1 01             	add    $0x1,%ecx
  800ad7:	83 c2 01             	add    $0x1,%edx
  800ada:	88 5a ff             	mov    %bl,-0x1(%edx)
  800add:	eb ea                	jmp    800ac9 <strlcpy+0x1a>
  800adf:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae4:	29 f0                	sub    %esi,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af3:	0f b6 01             	movzbl (%ecx),%eax
  800af6:	84 c0                	test   %al,%al
  800af8:	74 0c                	je     800b06 <strcmp+0x1c>
  800afa:	3a 02                	cmp    (%edx),%al
  800afc:	75 08                	jne    800b06 <strcmp+0x1c>
		p++, q++;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	83 c2 01             	add    $0x1,%edx
  800b04:	eb ed                	jmp    800af3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b06:	0f b6 c0             	movzbl %al,%eax
  800b09:	0f b6 12             	movzbl (%edx),%edx
  800b0c:	29 d0                	sub    %edx,%eax
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	53                   	push   %ebx
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	89 c3                	mov    %eax,%ebx
  800b1c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b1f:	eb 06                	jmp    800b27 <strncmp+0x17>
		n--, p++, q++;
  800b21:	83 c0 01             	add    $0x1,%eax
  800b24:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b27:	39 d8                	cmp    %ebx,%eax
  800b29:	74 16                	je     800b41 <strncmp+0x31>
  800b2b:	0f b6 08             	movzbl (%eax),%ecx
  800b2e:	84 c9                	test   %cl,%cl
  800b30:	74 04                	je     800b36 <strncmp+0x26>
  800b32:	3a 0a                	cmp    (%edx),%cl
  800b34:	74 eb                	je     800b21 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b36:	0f b6 00             	movzbl (%eax),%eax
  800b39:	0f b6 12             	movzbl (%edx),%edx
  800b3c:	29 d0                	sub    %edx,%eax
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    
		return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	eb f6                	jmp    800b3e <strncmp+0x2e>

00800b48 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b52:	0f b6 10             	movzbl (%eax),%edx
  800b55:	84 d2                	test   %dl,%dl
  800b57:	74 09                	je     800b62 <strchr+0x1a>
		if (*s == c)
  800b59:	38 ca                	cmp    %cl,%dl
  800b5b:	74 0a                	je     800b67 <strchr+0x1f>
	for (; *s; s++)
  800b5d:	83 c0 01             	add    $0x1,%eax
  800b60:	eb f0                	jmp    800b52 <strchr+0xa>
			return (char *) s;
	return 0;
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b73:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b76:	38 ca                	cmp    %cl,%dl
  800b78:	74 09                	je     800b83 <strfind+0x1a>
  800b7a:	84 d2                	test   %dl,%dl
  800b7c:	74 05                	je     800b83 <strfind+0x1a>
	for (; *s; s++)
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	eb f0                	jmp    800b73 <strfind+0xa>
			break;
	return (char *) s;
}
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b91:	85 c9                	test   %ecx,%ecx
  800b93:	74 31                	je     800bc6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b95:	89 f8                	mov    %edi,%eax
  800b97:	09 c8                	or     %ecx,%eax
  800b99:	a8 03                	test   $0x3,%al
  800b9b:	75 23                	jne    800bc0 <memset+0x3b>
		c &= 0xFF;
  800b9d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba1:	89 d3                	mov    %edx,%ebx
  800ba3:	c1 e3 08             	shl    $0x8,%ebx
  800ba6:	89 d0                	mov    %edx,%eax
  800ba8:	c1 e0 18             	shl    $0x18,%eax
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	c1 e6 10             	shl    $0x10,%esi
  800bb0:	09 f0                	or     %esi,%eax
  800bb2:	09 c2                	or     %eax,%edx
  800bb4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb9:	89 d0                	mov    %edx,%eax
  800bbb:	fc                   	cld    
  800bbc:	f3 ab                	rep stos %eax,%es:(%edi)
  800bbe:	eb 06                	jmp    800bc6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	fc                   	cld    
  800bc4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bc6:	89 f8                	mov    %edi,%eax
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdb:	39 c6                	cmp    %eax,%esi
  800bdd:	73 32                	jae    800c11 <memmove+0x44>
  800bdf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be2:	39 c2                	cmp    %eax,%edx
  800be4:	76 2b                	jbe    800c11 <memmove+0x44>
		s += n;
		d += n;
  800be6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be9:	89 fe                	mov    %edi,%esi
  800beb:	09 ce                	or     %ecx,%esi
  800bed:	09 d6                	or     %edx,%esi
  800bef:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf5:	75 0e                	jne    800c05 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf7:	83 ef 04             	sub    $0x4,%edi
  800bfa:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c00:	fd                   	std    
  800c01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c03:	eb 09                	jmp    800c0e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c05:	83 ef 01             	sub    $0x1,%edi
  800c08:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c0b:	fd                   	std    
  800c0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0e:	fc                   	cld    
  800c0f:	eb 1a                	jmp    800c2b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c11:	89 c2                	mov    %eax,%edx
  800c13:	09 ca                	or     %ecx,%edx
  800c15:	09 f2                	or     %esi,%edx
  800c17:	f6 c2 03             	test   $0x3,%dl
  800c1a:	75 0a                	jne    800c26 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	fc                   	cld    
  800c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c24:	eb 05                	jmp    800c2b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c26:	89 c7                	mov    %eax,%edi
  800c28:	fc                   	cld    
  800c29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c35:	ff 75 10             	pushl  0x10(%ebp)
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	ff 75 08             	pushl  0x8(%ebp)
  800c3e:	e8 8a ff ff ff       	call   800bcd <memmove>
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	89 c6                	mov    %eax,%esi
  800c52:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c55:	39 f0                	cmp    %esi,%eax
  800c57:	74 1c                	je     800c75 <memcmp+0x30>
		if (*s1 != *s2)
  800c59:	0f b6 08             	movzbl (%eax),%ecx
  800c5c:	0f b6 1a             	movzbl (%edx),%ebx
  800c5f:	38 d9                	cmp    %bl,%cl
  800c61:	75 08                	jne    800c6b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c63:	83 c0 01             	add    $0x1,%eax
  800c66:	83 c2 01             	add    $0x1,%edx
  800c69:	eb ea                	jmp    800c55 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c6b:	0f b6 c1             	movzbl %cl,%eax
  800c6e:	0f b6 db             	movzbl %bl,%ebx
  800c71:	29 d8                	sub    %ebx,%eax
  800c73:	eb 05                	jmp    800c7a <memcmp+0x35>
	}

	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c87:	89 c2                	mov    %eax,%edx
  800c89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8c:	39 d0                	cmp    %edx,%eax
  800c8e:	73 09                	jae    800c99 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c90:	38 08                	cmp    %cl,(%eax)
  800c92:	74 05                	je     800c99 <memfind+0x1b>
	for (; s < ends; s++)
  800c94:	83 c0 01             	add    $0x1,%eax
  800c97:	eb f3                	jmp    800c8c <memfind+0xe>
			break;
	return (void *) s;
}
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca7:	eb 03                	jmp    800cac <strtol+0x11>
		s++;
  800ca9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cac:	0f b6 01             	movzbl (%ecx),%eax
  800caf:	3c 20                	cmp    $0x20,%al
  800cb1:	74 f6                	je     800ca9 <strtol+0xe>
  800cb3:	3c 09                	cmp    $0x9,%al
  800cb5:	74 f2                	je     800ca9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb7:	3c 2b                	cmp    $0x2b,%al
  800cb9:	74 2a                	je     800ce5 <strtol+0x4a>
	int neg = 0;
  800cbb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc0:	3c 2d                	cmp    $0x2d,%al
  800cc2:	74 2b                	je     800cef <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cca:	75 0f                	jne    800cdb <strtol+0x40>
  800ccc:	80 39 30             	cmpb   $0x30,(%ecx)
  800ccf:	74 28                	je     800cf9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd1:	85 db                	test   %ebx,%ebx
  800cd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd8:	0f 44 d8             	cmove  %eax,%ebx
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce3:	eb 50                	jmp    800d35 <strtol+0x9a>
		s++;
  800ce5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce8:	bf 00 00 00 00       	mov    $0x0,%edi
  800ced:	eb d5                	jmp    800cc4 <strtol+0x29>
		s++, neg = 1;
  800cef:	83 c1 01             	add    $0x1,%ecx
  800cf2:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf7:	eb cb                	jmp    800cc4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cfd:	74 0e                	je     800d0d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cff:	85 db                	test   %ebx,%ebx
  800d01:	75 d8                	jne    800cdb <strtol+0x40>
		s++, base = 8;
  800d03:	83 c1 01             	add    $0x1,%ecx
  800d06:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d0b:	eb ce                	jmp    800cdb <strtol+0x40>
		s += 2, base = 16;
  800d0d:	83 c1 02             	add    $0x2,%ecx
  800d10:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d15:	eb c4                	jmp    800cdb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d17:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d1a:	89 f3                	mov    %esi,%ebx
  800d1c:	80 fb 19             	cmp    $0x19,%bl
  800d1f:	77 29                	ja     800d4a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d21:	0f be d2             	movsbl %dl,%edx
  800d24:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d27:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d2a:	7d 30                	jge    800d5c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d2c:	83 c1 01             	add    $0x1,%ecx
  800d2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d33:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d35:	0f b6 11             	movzbl (%ecx),%edx
  800d38:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d3b:	89 f3                	mov    %esi,%ebx
  800d3d:	80 fb 09             	cmp    $0x9,%bl
  800d40:	77 d5                	ja     800d17 <strtol+0x7c>
			dig = *s - '0';
  800d42:	0f be d2             	movsbl %dl,%edx
  800d45:	83 ea 30             	sub    $0x30,%edx
  800d48:	eb dd                	jmp    800d27 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d4a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4d:	89 f3                	mov    %esi,%ebx
  800d4f:	80 fb 19             	cmp    $0x19,%bl
  800d52:	77 08                	ja     800d5c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d54:	0f be d2             	movsbl %dl,%edx
  800d57:	83 ea 37             	sub    $0x37,%edx
  800d5a:	eb cb                	jmp    800d27 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d60:	74 05                	je     800d67 <strtol+0xcc>
		*endptr = (char *) s;
  800d62:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d65:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	f7 da                	neg    %edx
  800d6b:	85 ff                	test   %edi,%edi
  800d6d:	0f 45 c2             	cmovne %edx,%eax
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d86:	89 c3                	mov    %eax,%ebx
  800d88:	89 c7                	mov    %eax,%edi
  800d8a:	89 c6                	mov    %eax,%esi
  800d8c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800da3:	89 d1                	mov    %edx,%ecx
  800da5:	89 d3                	mov    %edx,%ebx
  800da7:	89 d7                	mov    %edx,%edi
  800da9:	89 d6                	mov    %edx,%esi
  800dab:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc8:	89 cb                	mov    %ecx,%ebx
  800dca:	89 cf                	mov    %ecx,%edi
  800dcc:	89 ce                	mov    %ecx,%esi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 03                	push   $0x3
  800de2:	68 80 1d 80 00       	push   $0x801d80
  800de7:	6a 43                	push   $0x43
  800de9:	68 9d 1d 80 00       	push   $0x801d9d
  800dee:	e8 24 08 00 00       	call   801617 <_panic>

00800df3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	b8 02 00 00 00       	mov    $0x2,%eax
  800e03:	89 d1                	mov    %edx,%ecx
  800e05:	89 d3                	mov    %edx,%ebx
  800e07:	89 d7                	mov    %edx,%edi
  800e09:	89 d6                	mov    %edx,%esi
  800e0b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <sys_yield>:

void
sys_yield(void)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e18:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e22:	89 d1                	mov    %edx,%ecx
  800e24:	89 d3                	mov    %edx,%ebx
  800e26:	89 d7                	mov    %edx,%edi
  800e28:	89 d6                	mov    %edx,%esi
  800e2a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5f                   	pop    %edi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	be 00 00 00 00       	mov    $0x0,%esi
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 04 00 00 00       	mov    $0x4,%eax
  800e4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4d:	89 f7                	mov    %esi,%edi
  800e4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	7f 08                	jg     800e5d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	83 ec 0c             	sub    $0xc,%esp
  800e60:	50                   	push   %eax
  800e61:	6a 04                	push   $0x4
  800e63:	68 80 1d 80 00       	push   $0x801d80
  800e68:	6a 43                	push   $0x43
  800e6a:	68 9d 1d 80 00       	push   $0x801d9d
  800e6f:	e8 a3 07 00 00       	call   801617 <_panic>

00800e74 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	b8 05 00 00 00       	mov    $0x5,%eax
  800e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 05                	push   $0x5
  800ea5:	68 80 1d 80 00       	push   $0x801d80
  800eaa:	6a 43                	push   $0x43
  800eac:	68 9d 1d 80 00       	push   $0x801d9d
  800eb1:	e8 61 07 00 00       	call   801617 <_panic>

00800eb6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	b8 06 00 00 00       	mov    $0x6,%eax
  800ecf:	89 df                	mov    %ebx,%edi
  800ed1:	89 de                	mov    %ebx,%esi
  800ed3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	7f 08                	jg     800ee1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	50                   	push   %eax
  800ee5:	6a 06                	push   $0x6
  800ee7:	68 80 1d 80 00       	push   $0x801d80
  800eec:	6a 43                	push   $0x43
  800eee:	68 9d 1d 80 00       	push   $0x801d9d
  800ef3:	e8 1f 07 00 00       	call   801617 <_panic>

00800ef8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f11:	89 df                	mov    %ebx,%edi
  800f13:	89 de                	mov    %ebx,%esi
  800f15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7f 08                	jg     800f23 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	50                   	push   %eax
  800f27:	6a 08                	push   $0x8
  800f29:	68 80 1d 80 00       	push   $0x801d80
  800f2e:	6a 43                	push   $0x43
  800f30:	68 9d 1d 80 00       	push   $0x801d9d
  800f35:	e8 dd 06 00 00       	call   801617 <_panic>

00800f3a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7f 08                	jg     800f65 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	50                   	push   %eax
  800f69:	6a 09                	push   $0x9
  800f6b:	68 80 1d 80 00       	push   $0x801d80
  800f70:	6a 43                	push   $0x43
  800f72:	68 9d 1d 80 00       	push   $0x801d9d
  800f77:	e8 9b 06 00 00       	call   801617 <_panic>

00800f7c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f95:	89 df                	mov    %ebx,%edi
  800f97:	89 de                	mov    %ebx,%esi
  800f99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	7f 08                	jg     800fa7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	50                   	push   %eax
  800fab:	6a 0a                	push   $0xa
  800fad:	68 80 1d 80 00       	push   $0x801d80
  800fb2:	6a 43                	push   $0x43
  800fb4:	68 9d 1d 80 00       	push   $0x801d9d
  800fb9:	e8 59 06 00 00       	call   801617 <_panic>

00800fbe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fcf:	be 00 00 00 00       	mov    $0x0,%esi
  800fd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fda:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
  800fe7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ff7:	89 cb                	mov    %ecx,%ebx
  800ff9:	89 cf                	mov    %ecx,%edi
  800ffb:	89 ce                	mov    %ecx,%esi
  800ffd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fff:	85 c0                	test   %eax,%eax
  801001:	7f 08                	jg     80100b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	50                   	push   %eax
  80100f:	6a 0d                	push   $0xd
  801011:	68 80 1d 80 00       	push   $0x801d80
  801016:	6a 43                	push   $0x43
  801018:	68 9d 1d 80 00       	push   $0x801d9d
  80101d:	e8 f5 05 00 00       	call   801617 <_panic>

00801022 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
	asm volatile("int %1\n"
  801028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	b8 0e 00 00 00       	mov    $0xe,%eax
  801038:	89 df                	mov    %ebx,%edi
  80103a:	89 de                	mov    %ebx,%esi
  80103c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
	asm volatile("int %1\n"
  801049:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	b8 0f 00 00 00       	mov    $0xf,%eax
  801056:	89 cb                	mov    %ecx,%ebx
  801058:	89 cf                	mov    %ecx,%edi
  80105a:	89 ce                	mov    %ecx,%esi
  80105c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	53                   	push   %ebx
  801067:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80106a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801071:	83 e1 07             	and    $0x7,%ecx
  801074:	83 f9 07             	cmp    $0x7,%ecx
  801077:	74 32                	je     8010ab <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801079:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801080:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801086:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80108c:	74 7d                	je     80110b <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80108e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801095:	83 e1 05             	and    $0x5,%ecx
  801098:	83 f9 05             	cmp    $0x5,%ecx
  80109b:	0f 84 9e 00 00 00    	je     80113f <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010ab:	89 d3                	mov    %edx,%ebx
  8010ad:	c1 e3 0c             	shl    $0xc,%ebx
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 05 08 00 00       	push   $0x805
  8010b8:	53                   	push   %ebx
  8010b9:	50                   	push   %eax
  8010ba:	53                   	push   %ebx
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 b2 fd ff ff       	call   800e74 <sys_page_map>
		if(r < 0)
  8010c2:	83 c4 20             	add    $0x20,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 2e                	js     8010f7 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010c9:	83 ec 0c             	sub    $0xc,%esp
  8010cc:	68 05 08 00 00       	push   $0x805
  8010d1:	53                   	push   %ebx
  8010d2:	6a 00                	push   $0x0
  8010d4:	53                   	push   %ebx
  8010d5:	6a 00                	push   $0x0
  8010d7:	e8 98 fd ff ff       	call   800e74 <sys_page_map>
		if(r < 0)
  8010dc:	83 c4 20             	add    $0x20,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	79 be                	jns    8010a1 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 ab 1d 80 00       	push   $0x801dab
  8010eb:	6a 57                	push   $0x57
  8010ed:	68 c1 1d 80 00       	push   $0x801dc1
  8010f2:	e8 20 05 00 00       	call   801617 <_panic>
			panic("sys_page_map() panic\n");
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	68 ab 1d 80 00       	push   $0x801dab
  8010ff:	6a 53                	push   $0x53
  801101:	68 c1 1d 80 00       	push   $0x801dc1
  801106:	e8 0c 05 00 00       	call   801617 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80110b:	c1 e2 0c             	shl    $0xc,%edx
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	68 05 08 00 00       	push   $0x805
  801116:	52                   	push   %edx
  801117:	50                   	push   %eax
  801118:	52                   	push   %edx
  801119:	6a 00                	push   $0x0
  80111b:	e8 54 fd ff ff       	call   800e74 <sys_page_map>
		if(r < 0)
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	0f 89 76 ff ff ff    	jns    8010a1 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	68 ab 1d 80 00       	push   $0x801dab
  801133:	6a 5e                	push   $0x5e
  801135:	68 c1 1d 80 00       	push   $0x801dc1
  80113a:	e8 d8 04 00 00       	call   801617 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80113f:	c1 e2 0c             	shl    $0xc,%edx
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	6a 05                	push   $0x5
  801147:	52                   	push   %edx
  801148:	50                   	push   %eax
  801149:	52                   	push   %edx
  80114a:	6a 00                	push   $0x0
  80114c:	e8 23 fd ff ff       	call   800e74 <sys_page_map>
		if(r < 0)
  801151:	83 c4 20             	add    $0x20,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	0f 89 45 ff ff ff    	jns    8010a1 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80115c:	83 ec 04             	sub    $0x4,%esp
  80115f:	68 ab 1d 80 00       	push   $0x801dab
  801164:	6a 65                	push   $0x65
  801166:	68 c1 1d 80 00       	push   $0x801dc1
  80116b:	e8 a7 04 00 00       	call   801617 <_panic>

00801170 <pgfault>:
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	53                   	push   %ebx
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80117a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80117c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801180:	0f 84 99 00 00 00    	je     80121f <pgfault+0xaf>
  801186:	89 c2                	mov    %eax,%edx
  801188:	c1 ea 16             	shr    $0x16,%edx
  80118b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801192:	f6 c2 01             	test   $0x1,%dl
  801195:	0f 84 84 00 00 00    	je     80121f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	c1 ea 0c             	shr    $0xc,%edx
  8011a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a7:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ad:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011b3:	75 6a                	jne    80121f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ba:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	6a 07                	push   $0x7
  8011c1:	68 00 f0 7f 00       	push   $0x7ff000
  8011c6:	6a 00                	push   $0x0
  8011c8:	e8 64 fc ff ff       	call   800e31 <sys_page_alloc>
	if(ret < 0)
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	78 5f                	js     801233 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011d4:	83 ec 04             	sub    $0x4,%esp
  8011d7:	68 00 10 00 00       	push   $0x1000
  8011dc:	53                   	push   %ebx
  8011dd:	68 00 f0 7f 00       	push   $0x7ff000
  8011e2:	e8 48 fa ff ff       	call   800c2f <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011e7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011ee:	53                   	push   %ebx
  8011ef:	6a 00                	push   $0x0
  8011f1:	68 00 f0 7f 00       	push   $0x7ff000
  8011f6:	6a 00                	push   $0x0
  8011f8:	e8 77 fc ff ff       	call   800e74 <sys_page_map>
	if(ret < 0)
  8011fd:	83 c4 20             	add    $0x20,%esp
  801200:	85 c0                	test   %eax,%eax
  801202:	78 43                	js     801247 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	68 00 f0 7f 00       	push   $0x7ff000
  80120c:	6a 00                	push   $0x0
  80120e:	e8 a3 fc ff ff       	call   800eb6 <sys_page_unmap>
	if(ret < 0)
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	85 c0                	test   %eax,%eax
  801218:	78 41                	js     80125b <pgfault+0xeb>
}
  80121a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 cc 1d 80 00       	push   $0x801dcc
  801227:	6a 26                	push   $0x26
  801229:	68 c1 1d 80 00       	push   $0x801dc1
  80122e:	e8 e4 03 00 00       	call   801617 <_panic>
		panic("panic in sys_page_alloc()\n");
  801233:	83 ec 04             	sub    $0x4,%esp
  801236:	68 e0 1d 80 00       	push   $0x801de0
  80123b:	6a 31                	push   $0x31
  80123d:	68 c1 1d 80 00       	push   $0x801dc1
  801242:	e8 d0 03 00 00       	call   801617 <_panic>
		panic("panic in sys_page_map()\n");
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	68 fb 1d 80 00       	push   $0x801dfb
  80124f:	6a 36                	push   $0x36
  801251:	68 c1 1d 80 00       	push   $0x801dc1
  801256:	e8 bc 03 00 00       	call   801617 <_panic>
		panic("panic in sys_page_unmap()\n");
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	68 14 1e 80 00       	push   $0x801e14
  801263:	6a 39                	push   $0x39
  801265:	68 c1 1d 80 00       	push   $0x801dc1
  80126a:	e8 a8 03 00 00       	call   801617 <_panic>

0080126f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	57                   	push   %edi
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801278:	68 70 11 80 00       	push   $0x801170
  80127d:	e8 f6 03 00 00       	call   801678 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801282:	b8 07 00 00 00       	mov    $0x7,%eax
  801287:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 27                	js     8012b7 <fork+0x48>
  801290:	89 c6                	mov    %eax,%esi
  801292:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801294:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801299:	75 48                	jne    8012e3 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80129b:	e8 53 fb ff ff       	call   800df3 <sys_getenvid>
  8012a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012a5:	c1 e0 07             	shl    $0x7,%eax
  8012a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ad:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  8012b2:	e9 90 00 00 00       	jmp    801347 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	68 3c 1e 80 00       	push   $0x801e3c
  8012bf:	68 85 00 00 00       	push   $0x85
  8012c4:	68 c1 1d 80 00       	push   $0x801dc1
  8012c9:	e8 49 03 00 00       	call   801617 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012ce:	89 f8                	mov    %edi,%eax
  8012d0:	e8 8e fd ff ff       	call   801063 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012db:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012e1:	74 26                	je     801309 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012e3:	89 d8                	mov    %ebx,%eax
  8012e5:	c1 e8 16             	shr    $0x16,%eax
  8012e8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ef:	a8 01                	test   $0x1,%al
  8012f1:	74 e2                	je     8012d5 <fork+0x66>
  8012f3:	89 da                	mov    %ebx,%edx
  8012f5:	c1 ea 0c             	shr    $0xc,%edx
  8012f8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012ff:	83 e0 05             	and    $0x5,%eax
  801302:	83 f8 05             	cmp    $0x5,%eax
  801305:	75 ce                	jne    8012d5 <fork+0x66>
  801307:	eb c5                	jmp    8012ce <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	6a 07                	push   $0x7
  80130e:	68 00 f0 bf ee       	push   $0xeebff000
  801313:	56                   	push   %esi
  801314:	e8 18 fb ff ff       	call   800e31 <sys_page_alloc>
	if(ret < 0)
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 31                	js     801351 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	68 e7 16 80 00       	push   $0x8016e7
  801328:	56                   	push   %esi
  801329:	e8 4e fc ff ff       	call   800f7c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 33                	js     801368 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	6a 02                	push   $0x2
  80133a:	56                   	push   %esi
  80133b:	e8 b8 fb ff ff       	call   800ef8 <sys_env_set_status>
	if(ret < 0)
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 38                	js     80137f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801347:	89 f0                	mov    %esi,%eax
  801349:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134c:	5b                   	pop    %ebx
  80134d:	5e                   	pop    %esi
  80134e:	5f                   	pop    %edi
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	68 e0 1d 80 00       	push   $0x801de0
  801359:	68 91 00 00 00       	push   $0x91
  80135e:	68 c1 1d 80 00       	push   $0x801dc1
  801363:	e8 af 02 00 00       	call   801617 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	68 60 1e 80 00       	push   $0x801e60
  801370:	68 94 00 00 00       	push   $0x94
  801375:	68 c1 1d 80 00       	push   $0x801dc1
  80137a:	e8 98 02 00 00       	call   801617 <_panic>
		panic("panic in sys_env_set_status()\n");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 88 1e 80 00       	push   $0x801e88
  801387:	68 97 00 00 00       	push   $0x97
  80138c:	68 c1 1d 80 00       	push   $0x801dc1
  801391:	e8 81 02 00 00       	call   801617 <_panic>

00801396 <sfork>:

// Challenge!
int
sfork(void)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	57                   	push   %edi
  80139a:	56                   	push   %esi
  80139b:	53                   	push   %ebx
  80139c:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80139f:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
  8013a7:	68 a8 1e 80 00       	push   $0x801ea8
  8013ac:	50                   	push   %eax
  8013ad:	68 2f 1e 80 00       	push   $0x801e2f
  8013b2:	e8 29 ef ff ff       	call   8002e0 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013b7:	c7 04 24 70 11 80 00 	movl   $0x801170,(%esp)
  8013be:	e8 b5 02 00 00       	call   801678 <set_pgfault_handler>
  8013c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8013c8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 27                	js     8013f8 <sfork+0x62>
  8013d1:	89 c7                	mov    %eax,%edi
  8013d3:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013d5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013da:	75 55                	jne    801431 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013dc:	e8 12 fa ff ff       	call   800df3 <sys_getenvid>
  8013e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013e6:	c1 e0 07             	shl    $0x7,%eax
  8013e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ee:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  8013f3:	e9 d4 00 00 00       	jmp    8014cc <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 3c 1e 80 00       	push   $0x801e3c
  801400:	68 a9 00 00 00       	push   $0xa9
  801405:	68 c1 1d 80 00       	push   $0x801dc1
  80140a:	e8 08 02 00 00       	call   801617 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80140f:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801414:	89 f0                	mov    %esi,%eax
  801416:	e8 48 fc ff ff       	call   801063 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801421:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801427:	77 65                	ja     80148e <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  801429:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80142f:	74 de                	je     80140f <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801431:	89 d8                	mov    %ebx,%eax
  801433:	c1 e8 16             	shr    $0x16,%eax
  801436:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80143d:	a8 01                	test   $0x1,%al
  80143f:	74 da                	je     80141b <sfork+0x85>
  801441:	89 da                	mov    %ebx,%edx
  801443:	c1 ea 0c             	shr    $0xc,%edx
  801446:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80144d:	83 e0 05             	and    $0x5,%eax
  801450:	83 f8 05             	cmp    $0x5,%eax
  801453:	75 c6                	jne    80141b <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801455:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80145c:	c1 e2 0c             	shl    $0xc,%edx
  80145f:	83 ec 0c             	sub    $0xc,%esp
  801462:	83 e0 07             	and    $0x7,%eax
  801465:	50                   	push   %eax
  801466:	52                   	push   %edx
  801467:	56                   	push   %esi
  801468:	52                   	push   %edx
  801469:	6a 00                	push   $0x0
  80146b:	e8 04 fa ff ff       	call   800e74 <sys_page_map>
  801470:	83 c4 20             	add    $0x20,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	74 a4                	je     80141b <sfork+0x85>
				panic("sys_page_map() panic\n");
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	68 ab 1d 80 00       	push   $0x801dab
  80147f:	68 b4 00 00 00       	push   $0xb4
  801484:	68 c1 1d 80 00       	push   $0x801dc1
  801489:	e8 89 01 00 00       	call   801617 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	6a 07                	push   $0x7
  801493:	68 00 f0 bf ee       	push   $0xeebff000
  801498:	57                   	push   %edi
  801499:	e8 93 f9 ff ff       	call   800e31 <sys_page_alloc>
	if(ret < 0)
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 31                	js     8014d6 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	68 e7 16 80 00       	push   $0x8016e7
  8014ad:	57                   	push   %edi
  8014ae:	e8 c9 fa ff ff       	call   800f7c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 33                	js     8014ed <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	6a 02                	push   $0x2
  8014bf:	57                   	push   %edi
  8014c0:	e8 33 fa ff ff       	call   800ef8 <sys_env_set_status>
	if(ret < 0)
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 38                	js     801504 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014cc:	89 f8                	mov    %edi,%eax
  8014ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 e0 1d 80 00       	push   $0x801de0
  8014de:	68 ba 00 00 00       	push   $0xba
  8014e3:	68 c1 1d 80 00       	push   $0x801dc1
  8014e8:	e8 2a 01 00 00       	call   801617 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 60 1e 80 00       	push   $0x801e60
  8014f5:	68 bd 00 00 00       	push   $0xbd
  8014fa:	68 c1 1d 80 00       	push   $0x801dc1
  8014ff:	e8 13 01 00 00       	call   801617 <_panic>
		panic("panic in sys_env_set_status()\n");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 88 1e 80 00       	push   $0x801e88
  80150c:	68 c0 00 00 00       	push   $0xc0
  801511:	68 c1 1d 80 00       	push   $0x801dc1
  801516:	e8 fc 00 00 00       	call   801617 <_panic>

0080151b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	8b 75 08             	mov    0x8(%ebp),%esi
  801523:	8b 45 0c             	mov    0xc(%ebp),%eax
  801526:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801529:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80152b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801530:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	50                   	push   %eax
  801537:	e8 a5 fa ff ff       	call   800fe1 <sys_ipc_recv>
	if(ret < 0){
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 2b                	js     80156e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801543:	85 f6                	test   %esi,%esi
  801545:	74 0a                	je     801551 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801547:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80154c:	8b 40 74             	mov    0x74(%eax),%eax
  80154f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801551:	85 db                	test   %ebx,%ebx
  801553:	74 0a                	je     80155f <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801555:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80155a:	8b 40 78             	mov    0x78(%eax),%eax
  80155d:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80155f:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801564:	8b 40 70             	mov    0x70(%eax),%eax
}
  801567:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
		if(from_env_store)
  80156e:	85 f6                	test   %esi,%esi
  801570:	74 06                	je     801578 <ipc_recv+0x5d>
			*from_env_store = 0;
  801572:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801578:	85 db                	test   %ebx,%ebx
  80157a:	74 eb                	je     801567 <ipc_recv+0x4c>
			*perm_store = 0;
  80157c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801582:	eb e3                	jmp    801567 <ipc_recv+0x4c>

00801584 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	83 ec 0c             	sub    $0xc,%esp
  80158d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801590:	8b 75 0c             	mov    0xc(%ebp),%esi
  801593:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801596:	85 db                	test   %ebx,%ebx
  801598:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80159d:	0f 44 d8             	cmove  %eax,%ebx
  8015a0:	eb 05                	jmp    8015a7 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015a2:	e8 6b f8 ff ff       	call   800e12 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015a7:	ff 75 14             	pushl  0x14(%ebp)
  8015aa:	53                   	push   %ebx
  8015ab:	56                   	push   %esi
  8015ac:	57                   	push   %edi
  8015ad:	e8 0c fa ff ff       	call   800fbe <sys_ipc_try_send>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	74 1b                	je     8015d4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015b9:	79 e7                	jns    8015a2 <ipc_send+0x1e>
  8015bb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015be:	74 e2                	je     8015a2 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	68 ae 1e 80 00       	push   $0x801eae
  8015c8:	6a 49                	push   $0x49
  8015ca:	68 c3 1e 80 00       	push   $0x801ec3
  8015cf:	e8 43 00 00 00       	call   801617 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d7:	5b                   	pop    %ebx
  8015d8:	5e                   	pop    %esi
  8015d9:	5f                   	pop    %edi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015e7:	89 c2                	mov    %eax,%edx
  8015e9:	c1 e2 07             	shl    $0x7,%edx
  8015ec:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015f2:	8b 52 50             	mov    0x50(%edx),%edx
  8015f5:	39 ca                	cmp    %ecx,%edx
  8015f7:	74 11                	je     80160a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8015f9:	83 c0 01             	add    $0x1,%eax
  8015fc:	3d 00 04 00 00       	cmp    $0x400,%eax
  801601:	75 e4                	jne    8015e7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	eb 0b                	jmp    801615 <ipc_find_env+0x39>
			return envs[i].env_id;
  80160a:	c1 e0 07             	shl    $0x7,%eax
  80160d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801612:	8b 40 48             	mov    0x48(%eax),%eax
}
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    

00801617 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80161c:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801621:	8b 40 48             	mov    0x48(%eax),%eax
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	68 f4 1e 80 00       	push   $0x801ef4
  80162c:	50                   	push   %eax
  80162d:	68 2f 1e 80 00       	push   $0x801e2f
  801632:	e8 a9 ec ff ff       	call   8002e0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801637:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80163a:	8b 35 08 20 80 00    	mov    0x802008,%esi
  801640:	e8 ae f7 ff ff       	call   800df3 <sys_getenvid>
  801645:	83 c4 04             	add    $0x4,%esp
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	56                   	push   %esi
  80164f:	50                   	push   %eax
  801650:	68 d0 1e 80 00       	push   $0x801ed0
  801655:	e8 86 ec ff ff       	call   8002e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80165a:	83 c4 18             	add    $0x18,%esp
  80165d:	53                   	push   %ebx
  80165e:	ff 75 10             	pushl  0x10(%ebp)
  801661:	e8 29 ec ff ff       	call   80028f <vcprintf>
	cprintf("\n");
  801666:	c7 04 24 f9 1d 80 00 	movl   $0x801df9,(%esp)
  80166d:	e8 6e ec ff ff       	call   8002e0 <cprintf>
  801672:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801675:	cc                   	int3   
  801676:	eb fd                	jmp    801675 <_panic+0x5e>

00801678 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80167e:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  801685:	74 0a                	je     801691 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	a3 10 20 80 00       	mov    %eax,0x802010
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	6a 07                	push   $0x7
  801696:	68 00 f0 bf ee       	push   $0xeebff000
  80169b:	6a 00                	push   $0x0
  80169d:	e8 8f f7 ff ff       	call   800e31 <sys_page_alloc>
		if(r < 0)
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 2a                	js     8016d3 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	68 e7 16 80 00       	push   $0x8016e7
  8016b1:	6a 00                	push   $0x0
  8016b3:	e8 c4 f8 ff ff       	call   800f7c <sys_env_set_pgfault_upcall>
		if(r < 0)
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	79 c8                	jns    801687 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	68 2c 1f 80 00       	push   $0x801f2c
  8016c7:	6a 25                	push   $0x25
  8016c9:	68 68 1f 80 00       	push   $0x801f68
  8016ce:	e8 44 ff ff ff       	call   801617 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 fc 1e 80 00       	push   $0x801efc
  8016db:	6a 22                	push   $0x22
  8016dd:	68 68 1f 80 00       	push   $0x801f68
  8016e2:	e8 30 ff ff ff       	call   801617 <_panic>

008016e7 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8016e7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8016e8:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  8016ed:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8016ef:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8016f2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8016f6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8016fa:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8016fd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8016ff:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801703:	83 c4 08             	add    $0x8,%esp
	popal
  801706:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801707:	83 c4 04             	add    $0x4,%esp
	popfl
  80170a:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80170b:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80170c:	c3                   	ret    
  80170d:	66 90                	xchg   %ax,%ax
  80170f:	90                   	nop

00801710 <__udivdi3>:
  801710:	55                   	push   %ebp
  801711:	57                   	push   %edi
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	83 ec 1c             	sub    $0x1c,%esp
  801717:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80171b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80171f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801723:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801727:	85 d2                	test   %edx,%edx
  801729:	75 4d                	jne    801778 <__udivdi3+0x68>
  80172b:	39 f3                	cmp    %esi,%ebx
  80172d:	76 19                	jbe    801748 <__udivdi3+0x38>
  80172f:	31 ff                	xor    %edi,%edi
  801731:	89 e8                	mov    %ebp,%eax
  801733:	89 f2                	mov    %esi,%edx
  801735:	f7 f3                	div    %ebx
  801737:	89 fa                	mov    %edi,%edx
  801739:	83 c4 1c             	add    $0x1c,%esp
  80173c:	5b                   	pop    %ebx
  80173d:	5e                   	pop    %esi
  80173e:	5f                   	pop    %edi
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    
  801741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801748:	89 d9                	mov    %ebx,%ecx
  80174a:	85 db                	test   %ebx,%ebx
  80174c:	75 0b                	jne    801759 <__udivdi3+0x49>
  80174e:	b8 01 00 00 00       	mov    $0x1,%eax
  801753:	31 d2                	xor    %edx,%edx
  801755:	f7 f3                	div    %ebx
  801757:	89 c1                	mov    %eax,%ecx
  801759:	31 d2                	xor    %edx,%edx
  80175b:	89 f0                	mov    %esi,%eax
  80175d:	f7 f1                	div    %ecx
  80175f:	89 c6                	mov    %eax,%esi
  801761:	89 e8                	mov    %ebp,%eax
  801763:	89 f7                	mov    %esi,%edi
  801765:	f7 f1                	div    %ecx
  801767:	89 fa                	mov    %edi,%edx
  801769:	83 c4 1c             	add    $0x1c,%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5f                   	pop    %edi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    
  801771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801778:	39 f2                	cmp    %esi,%edx
  80177a:	77 1c                	ja     801798 <__udivdi3+0x88>
  80177c:	0f bd fa             	bsr    %edx,%edi
  80177f:	83 f7 1f             	xor    $0x1f,%edi
  801782:	75 2c                	jne    8017b0 <__udivdi3+0xa0>
  801784:	39 f2                	cmp    %esi,%edx
  801786:	72 06                	jb     80178e <__udivdi3+0x7e>
  801788:	31 c0                	xor    %eax,%eax
  80178a:	39 eb                	cmp    %ebp,%ebx
  80178c:	77 a9                	ja     801737 <__udivdi3+0x27>
  80178e:	b8 01 00 00 00       	mov    $0x1,%eax
  801793:	eb a2                	jmp    801737 <__udivdi3+0x27>
  801795:	8d 76 00             	lea    0x0(%esi),%esi
  801798:	31 ff                	xor    %edi,%edi
  80179a:	31 c0                	xor    %eax,%eax
  80179c:	89 fa                	mov    %edi,%edx
  80179e:	83 c4 1c             	add    $0x1c,%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    
  8017a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8017ad:	8d 76 00             	lea    0x0(%esi),%esi
  8017b0:	89 f9                	mov    %edi,%ecx
  8017b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8017b7:	29 f8                	sub    %edi,%eax
  8017b9:	d3 e2                	shl    %cl,%edx
  8017bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017bf:	89 c1                	mov    %eax,%ecx
  8017c1:	89 da                	mov    %ebx,%edx
  8017c3:	d3 ea                	shr    %cl,%edx
  8017c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8017c9:	09 d1                	or     %edx,%ecx
  8017cb:	89 f2                	mov    %esi,%edx
  8017cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d1:	89 f9                	mov    %edi,%ecx
  8017d3:	d3 e3                	shl    %cl,%ebx
  8017d5:	89 c1                	mov    %eax,%ecx
  8017d7:	d3 ea                	shr    %cl,%edx
  8017d9:	89 f9                	mov    %edi,%ecx
  8017db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017df:	89 eb                	mov    %ebp,%ebx
  8017e1:	d3 e6                	shl    %cl,%esi
  8017e3:	89 c1                	mov    %eax,%ecx
  8017e5:	d3 eb                	shr    %cl,%ebx
  8017e7:	09 de                	or     %ebx,%esi
  8017e9:	89 f0                	mov    %esi,%eax
  8017eb:	f7 74 24 08          	divl   0x8(%esp)
  8017ef:	89 d6                	mov    %edx,%esi
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	f7 64 24 0c          	mull   0xc(%esp)
  8017f7:	39 d6                	cmp    %edx,%esi
  8017f9:	72 15                	jb     801810 <__udivdi3+0x100>
  8017fb:	89 f9                	mov    %edi,%ecx
  8017fd:	d3 e5                	shl    %cl,%ebp
  8017ff:	39 c5                	cmp    %eax,%ebp
  801801:	73 04                	jae    801807 <__udivdi3+0xf7>
  801803:	39 d6                	cmp    %edx,%esi
  801805:	74 09                	je     801810 <__udivdi3+0x100>
  801807:	89 d8                	mov    %ebx,%eax
  801809:	31 ff                	xor    %edi,%edi
  80180b:	e9 27 ff ff ff       	jmp    801737 <__udivdi3+0x27>
  801810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801813:	31 ff                	xor    %edi,%edi
  801815:	e9 1d ff ff ff       	jmp    801737 <__udivdi3+0x27>
  80181a:	66 90                	xchg   %ax,%ax
  80181c:	66 90                	xchg   %ax,%ax
  80181e:	66 90                	xchg   %ax,%ax

00801820 <__umoddi3>:
  801820:	55                   	push   %ebp
  801821:	57                   	push   %edi
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
  801824:	83 ec 1c             	sub    $0x1c,%esp
  801827:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80182b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80182f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801837:	89 da                	mov    %ebx,%edx
  801839:	85 c0                	test   %eax,%eax
  80183b:	75 43                	jne    801880 <__umoddi3+0x60>
  80183d:	39 df                	cmp    %ebx,%edi
  80183f:	76 17                	jbe    801858 <__umoddi3+0x38>
  801841:	89 f0                	mov    %esi,%eax
  801843:	f7 f7                	div    %edi
  801845:	89 d0                	mov    %edx,%eax
  801847:	31 d2                	xor    %edx,%edx
  801849:	83 c4 1c             	add    $0x1c,%esp
  80184c:	5b                   	pop    %ebx
  80184d:	5e                   	pop    %esi
  80184e:	5f                   	pop    %edi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    
  801851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801858:	89 fd                	mov    %edi,%ebp
  80185a:	85 ff                	test   %edi,%edi
  80185c:	75 0b                	jne    801869 <__umoddi3+0x49>
  80185e:	b8 01 00 00 00       	mov    $0x1,%eax
  801863:	31 d2                	xor    %edx,%edx
  801865:	f7 f7                	div    %edi
  801867:	89 c5                	mov    %eax,%ebp
  801869:	89 d8                	mov    %ebx,%eax
  80186b:	31 d2                	xor    %edx,%edx
  80186d:	f7 f5                	div    %ebp
  80186f:	89 f0                	mov    %esi,%eax
  801871:	f7 f5                	div    %ebp
  801873:	89 d0                	mov    %edx,%eax
  801875:	eb d0                	jmp    801847 <__umoddi3+0x27>
  801877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80187e:	66 90                	xchg   %ax,%ax
  801880:	89 f1                	mov    %esi,%ecx
  801882:	39 d8                	cmp    %ebx,%eax
  801884:	76 0a                	jbe    801890 <__umoddi3+0x70>
  801886:	89 f0                	mov    %esi,%eax
  801888:	83 c4 1c             	add    $0x1c,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    
  801890:	0f bd e8             	bsr    %eax,%ebp
  801893:	83 f5 1f             	xor    $0x1f,%ebp
  801896:	75 20                	jne    8018b8 <__umoddi3+0x98>
  801898:	39 d8                	cmp    %ebx,%eax
  80189a:	0f 82 b0 00 00 00    	jb     801950 <__umoddi3+0x130>
  8018a0:	39 f7                	cmp    %esi,%edi
  8018a2:	0f 86 a8 00 00 00    	jbe    801950 <__umoddi3+0x130>
  8018a8:	89 c8                	mov    %ecx,%eax
  8018aa:	83 c4 1c             	add    $0x1c,%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    
  8018b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8018b8:	89 e9                	mov    %ebp,%ecx
  8018ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8018bf:	29 ea                	sub    %ebp,%edx
  8018c1:	d3 e0                	shl    %cl,%eax
  8018c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c7:	89 d1                	mov    %edx,%ecx
  8018c9:	89 f8                	mov    %edi,%eax
  8018cb:	d3 e8                	shr    %cl,%eax
  8018cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8018d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018d9:	09 c1                	or     %eax,%ecx
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e1:	89 e9                	mov    %ebp,%ecx
  8018e3:	d3 e7                	shl    %cl,%edi
  8018e5:	89 d1                	mov    %edx,%ecx
  8018e7:	d3 e8                	shr    %cl,%eax
  8018e9:	89 e9                	mov    %ebp,%ecx
  8018eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018ef:	d3 e3                	shl    %cl,%ebx
  8018f1:	89 c7                	mov    %eax,%edi
  8018f3:	89 d1                	mov    %edx,%ecx
  8018f5:	89 f0                	mov    %esi,%eax
  8018f7:	d3 e8                	shr    %cl,%eax
  8018f9:	89 e9                	mov    %ebp,%ecx
  8018fb:	89 fa                	mov    %edi,%edx
  8018fd:	d3 e6                	shl    %cl,%esi
  8018ff:	09 d8                	or     %ebx,%eax
  801901:	f7 74 24 08          	divl   0x8(%esp)
  801905:	89 d1                	mov    %edx,%ecx
  801907:	89 f3                	mov    %esi,%ebx
  801909:	f7 64 24 0c          	mull   0xc(%esp)
  80190d:	89 c6                	mov    %eax,%esi
  80190f:	89 d7                	mov    %edx,%edi
  801911:	39 d1                	cmp    %edx,%ecx
  801913:	72 06                	jb     80191b <__umoddi3+0xfb>
  801915:	75 10                	jne    801927 <__umoddi3+0x107>
  801917:	39 c3                	cmp    %eax,%ebx
  801919:	73 0c                	jae    801927 <__umoddi3+0x107>
  80191b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80191f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801923:	89 d7                	mov    %edx,%edi
  801925:	89 c6                	mov    %eax,%esi
  801927:	89 ca                	mov    %ecx,%edx
  801929:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80192e:	29 f3                	sub    %esi,%ebx
  801930:	19 fa                	sbb    %edi,%edx
  801932:	89 d0                	mov    %edx,%eax
  801934:	d3 e0                	shl    %cl,%eax
  801936:	89 e9                	mov    %ebp,%ecx
  801938:	d3 eb                	shr    %cl,%ebx
  80193a:	d3 ea                	shr    %cl,%edx
  80193c:	09 d8                	or     %ebx,%eax
  80193e:	83 c4 1c             	add    $0x1c,%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5f                   	pop    %edi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    
  801946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80194d:	8d 76 00             	lea    0x0(%esi),%esi
  801950:	89 da                	mov    %ebx,%edx
  801952:	29 fe                	sub    %edi,%esi
  801954:	19 c2                	sbb    %eax,%edx
  801956:	89 f1                	mov    %esi,%ecx
  801958:	89 c8                	mov    %ecx,%eax
  80195a:	e9 4b ff ff ff       	jmp    8018aa <__umoddi3+0x8a>
