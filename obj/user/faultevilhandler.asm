
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 c0 0c 00 00       	call   800d07 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 fc 0d 00 00       	call   800e52 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80006e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800075:	00 00 00 
	envid_t find = sys_getenvid();
  800078:	e8 4c 0c 00 00       	call   800cc9 <sys_getenvid>
  80007d:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800083:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800088:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80008d:	bf 01 00 00 00       	mov    $0x1,%edi
  800092:	eb 0b                	jmp    80009f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800094:	83 c2 01             	add    $0x1,%edx
  800097:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80009d:	74 21                	je     8000c0 <libmain+0x5b>
		if(envs[i].env_id == find)
  80009f:	89 d1                	mov    %edx,%ecx
  8000a1:	c1 e1 07             	shl    $0x7,%ecx
  8000a4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000aa:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000ad:	39 c1                	cmp    %eax,%ecx
  8000af:	75 e3                	jne    800094 <libmain+0x2f>
  8000b1:	89 d3                	mov    %edx,%ebx
  8000b3:	c1 e3 07             	shl    $0x7,%ebx
  8000b6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bc:	89 fe                	mov    %edi,%esi
  8000be:	eb d4                	jmp    800094 <libmain+0x2f>
  8000c0:	89 f0                	mov    %esi,%eax
  8000c2:	84 c0                	test   %al,%al
  8000c4:	74 06                	je     8000cc <libmain+0x67>
  8000c6:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d0:	7e 0a                	jle    8000dc <libmain+0x77>
		binaryname = argv[0];
  8000d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d5:	8b 00                	mov    (%eax),%eax
  8000d7:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 20 25 80 00       	push   $0x802520
  8000e4:	e8 cd 00 00 00       	call   8001b6 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e9:	83 c4 08             	add    $0x8,%esp
  8000ec:	ff 75 0c             	pushl  0xc(%ebp)
  8000ef:	ff 75 08             	pushl  0x8(%ebp)
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0b 00 00 00       	call   800107 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5f                   	pop    %edi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010d:	e8 a2 10 00 00       	call   8011b4 <close_all>
	sys_env_destroy(0);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	6a 00                	push   $0x0
  800117:	e8 6c 0b 00 00       	call   800c88 <sys_env_destroy>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	53                   	push   %ebx
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012b:	8b 13                	mov    (%ebx),%edx
  80012d:	8d 42 01             	lea    0x1(%edx),%eax
  800130:	89 03                	mov    %eax,(%ebx)
  800132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800135:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	74 09                	je     800149 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800147:	c9                   	leave  
  800148:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 ff 00 00 00       	push   $0xff
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	e8 f1 0a 00 00       	call   800c4b <sys_cputs>
		b->idx = 0;
  80015a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb db                	jmp    800140 <putch+0x1f>

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 21 01 80 00       	push   $0x800121
  800194:	e8 4a 01 00 00       	call   8002e3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 9d 0a 00 00       	call   800c4b <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bf:	50                   	push   %eax
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	e8 9d ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	89 c6                	mov    %eax,%esi
  8001d5:	89 d7                	mov    %edx,%edi
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001ed:	74 2c                	je     80021b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001ff:	39 c2                	cmp    %eax,%edx
  800201:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800204:	73 43                	jae    800249 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800206:	83 eb 01             	sub    $0x1,%ebx
  800209:	85 db                	test   %ebx,%ebx
  80020b:	7e 6c                	jle    800279 <printnum+0xaf>
				putch(padc, putdat);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	57                   	push   %edi
  800211:	ff 75 18             	pushl  0x18(%ebp)
  800214:	ff d6                	call   *%esi
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	eb eb                	jmp    800206 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	6a 20                	push   $0x20
  800220:	6a 00                	push   $0x0
  800222:	50                   	push   %eax
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	89 fa                	mov    %edi,%edx
  80022b:	89 f0                	mov    %esi,%eax
  80022d:	e8 98 ff ff ff       	call   8001ca <printnum>
		while (--width > 0)
  800232:	83 c4 20             	add    $0x20,%esp
  800235:	83 eb 01             	sub    $0x1,%ebx
  800238:	85 db                	test   %ebx,%ebx
  80023a:	7e 65                	jle    8002a1 <printnum+0xd7>
			putch(padc, putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	57                   	push   %edi
  800240:	6a 20                	push   $0x20
  800242:	ff d6                	call   *%esi
  800244:	83 c4 10             	add    $0x10,%esp
  800247:	eb ec                	jmp    800235 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	ff 75 18             	pushl  0x18(%ebp)
  80024f:	83 eb 01             	sub    $0x1,%ebx
  800252:	53                   	push   %ebx
  800253:	50                   	push   %eax
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	ff 75 dc             	pushl  -0x24(%ebp)
  80025a:	ff 75 d8             	pushl  -0x28(%ebp)
  80025d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800260:	ff 75 e0             	pushl  -0x20(%ebp)
  800263:	e8 68 20 00 00       	call   8022d0 <__udivdi3>
  800268:	83 c4 18             	add    $0x18,%esp
  80026b:	52                   	push   %edx
  80026c:	50                   	push   %eax
  80026d:	89 fa                	mov    %edi,%edx
  80026f:	89 f0                	mov    %esi,%eax
  800271:	e8 54 ff ff ff       	call   8001ca <printnum>
  800276:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	57                   	push   %edi
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	ff 75 dc             	pushl  -0x24(%ebp)
  800283:	ff 75 d8             	pushl  -0x28(%ebp)
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	ff 75 e0             	pushl  -0x20(%ebp)
  80028c:	e8 4f 21 00 00       	call   8023e0 <__umoddi3>
  800291:	83 c4 14             	add    $0x14,%esp
  800294:	0f be 80 37 25 80 00 	movsbl 0x802537(%eax),%eax
  80029b:	50                   	push   %eax
  80029c:	ff d6                	call   *%esi
  80029e:	83 c4 10             	add    $0x10,%esp
	}
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b8:	73 0a                	jae    8002c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002bd:	89 08                	mov    %ecx,(%eax)
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	88 02                	mov    %al,(%edx)
}
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <printfmt>:
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 10             	pushl  0x10(%ebp)
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	e8 05 00 00 00       	call   8002e3 <vprintfmt>
}
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <vprintfmt>:
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 3c             	sub    $0x3c,%esp
  8002ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f5:	e9 32 04 00 00       	jmp    80072c <vprintfmt+0x449>
		padc = ' ';
  8002fa:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800305:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80030c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800313:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800321:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8d 47 01             	lea    0x1(%edi),%eax
  800329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032c:	0f b6 17             	movzbl (%edi),%edx
  80032f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800332:	3c 55                	cmp    $0x55,%al
  800334:	0f 87 12 05 00 00    	ja     80084c <vprintfmt+0x569>
  80033a:	0f b6 c0             	movzbl %al,%eax
  80033d:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800347:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80034b:	eb d9                	jmp    800326 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800350:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800354:	eb d0                	jmp    800326 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800356:	0f b6 d2             	movzbl %dl,%edx
  800359:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80035c:	b8 00 00 00 00       	mov    $0x0,%eax
  800361:	89 75 08             	mov    %esi,0x8(%ebp)
  800364:	eb 03                	jmp    800369 <vprintfmt+0x86>
  800366:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800369:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800370:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800373:	8d 72 d0             	lea    -0x30(%edx),%esi
  800376:	83 fe 09             	cmp    $0x9,%esi
  800379:	76 eb                	jbe    800366 <vprintfmt+0x83>
  80037b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037e:	8b 75 08             	mov    0x8(%ebp),%esi
  800381:	eb 14                	jmp    800397 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800383:	8b 45 14             	mov    0x14(%ebp),%eax
  800386:	8b 00                	mov    (%eax),%eax
  800388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	8d 40 04             	lea    0x4(%eax),%eax
  800391:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039b:	79 89                	jns    800326 <vprintfmt+0x43>
				width = precision, precision = -1;
  80039d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003aa:	e9 77 ff ff ff       	jmp    800326 <vprintfmt+0x43>
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	0f 48 c1             	cmovs  %ecx,%eax
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bd:	e9 64 ff ff ff       	jmp    800326 <vprintfmt+0x43>
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003cc:	e9 55 ff ff ff       	jmp    800326 <vprintfmt+0x43>
			lflag++;
  8003d1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d8:	e9 49 ff ff ff       	jmp    800326 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8d 78 04             	lea    0x4(%eax),%edi
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	53                   	push   %ebx
  8003e7:	ff 30                	pushl  (%eax)
  8003e9:	ff d6                	call   *%esi
			break;
  8003eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ee:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f1:	e9 33 03 00 00       	jmp    800729 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8d 78 04             	lea    0x4(%eax),%edi
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	99                   	cltd   
  8003ff:	31 d0                	xor    %edx,%eax
  800401:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800403:	83 f8 10             	cmp    $0x10,%eax
  800406:	7f 23                	jg     80042b <vprintfmt+0x148>
  800408:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  80040f:	85 d2                	test   %edx,%edx
  800411:	74 18                	je     80042b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800413:	52                   	push   %edx
  800414:	68 99 29 80 00       	push   $0x802999
  800419:	53                   	push   %ebx
  80041a:	56                   	push   %esi
  80041b:	e8 a6 fe ff ff       	call   8002c6 <printfmt>
  800420:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800423:	89 7d 14             	mov    %edi,0x14(%ebp)
  800426:	e9 fe 02 00 00       	jmp    800729 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80042b:	50                   	push   %eax
  80042c:	68 4f 25 80 00       	push   $0x80254f
  800431:	53                   	push   %ebx
  800432:	56                   	push   %esi
  800433:	e8 8e fe ff ff       	call   8002c6 <printfmt>
  800438:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043e:	e9 e6 02 00 00       	jmp    800729 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	83 c0 04             	add    $0x4,%eax
  800449:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80044c:	8b 45 14             	mov    0x14(%ebp),%eax
  80044f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800451:	85 c9                	test   %ecx,%ecx
  800453:	b8 48 25 80 00       	mov    $0x802548,%eax
  800458:	0f 45 c1             	cmovne %ecx,%eax
  80045b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80045e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800462:	7e 06                	jle    80046a <vprintfmt+0x187>
  800464:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800468:	75 0d                	jne    800477 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046d:	89 c7                	mov    %eax,%edi
  80046f:	03 45 e0             	add    -0x20(%ebp),%eax
  800472:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800475:	eb 53                	jmp    8004ca <vprintfmt+0x1e7>
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	ff 75 d8             	pushl  -0x28(%ebp)
  80047d:	50                   	push   %eax
  80047e:	e8 71 04 00 00       	call   8008f4 <strnlen>
  800483:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800486:	29 c1                	sub    %eax,%ecx
  800488:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800490:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800494:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800497:	eb 0f                	jmp    8004a8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	53                   	push   %ebx
  80049d:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	83 ef 01             	sub    $0x1,%edi
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	85 ff                	test   %edi,%edi
  8004aa:	7f ed                	jg     800499 <vprintfmt+0x1b6>
  8004ac:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004af:	85 c9                	test   %ecx,%ecx
  8004b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b6:	0f 49 c1             	cmovns %ecx,%eax
  8004b9:	29 c1                	sub    %eax,%ecx
  8004bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004be:	eb aa                	jmp    80046a <vprintfmt+0x187>
					putch(ch, putdat);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	53                   	push   %ebx
  8004c4:	52                   	push   %edx
  8004c5:	ff d6                	call   *%esi
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004cf:	83 c7 01             	add    $0x1,%edi
  8004d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d6:	0f be d0             	movsbl %al,%edx
  8004d9:	85 d2                	test   %edx,%edx
  8004db:	74 4b                	je     800528 <vprintfmt+0x245>
  8004dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e1:	78 06                	js     8004e9 <vprintfmt+0x206>
  8004e3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e7:	78 1e                	js     800507 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004ed:	74 d1                	je     8004c0 <vprintfmt+0x1dd>
  8004ef:	0f be c0             	movsbl %al,%eax
  8004f2:	83 e8 20             	sub    $0x20,%eax
  8004f5:	83 f8 5e             	cmp    $0x5e,%eax
  8004f8:	76 c6                	jbe    8004c0 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	6a 3f                	push   $0x3f
  800500:	ff d6                	call   *%esi
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	eb c3                	jmp    8004ca <vprintfmt+0x1e7>
  800507:	89 cf                	mov    %ecx,%edi
  800509:	eb 0e                	jmp    800519 <vprintfmt+0x236>
				putch(' ', putdat);
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	53                   	push   %ebx
  80050f:	6a 20                	push   $0x20
  800511:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800513:	83 ef 01             	sub    $0x1,%edi
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	85 ff                	test   %edi,%edi
  80051b:	7f ee                	jg     80050b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80051d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800520:	89 45 14             	mov    %eax,0x14(%ebp)
  800523:	e9 01 02 00 00       	jmp    800729 <vprintfmt+0x446>
  800528:	89 cf                	mov    %ecx,%edi
  80052a:	eb ed                	jmp    800519 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80052f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800536:	e9 eb fd ff ff       	jmp    800326 <vprintfmt+0x43>
	if (lflag >= 2)
  80053b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80053f:	7f 21                	jg     800562 <vprintfmt+0x27f>
	else if (lflag)
  800541:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800545:	74 68                	je     8005af <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054f:	89 c1                	mov    %eax,%ecx
  800551:	c1 f9 1f             	sar    $0x1f,%ecx
  800554:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
  800560:	eb 17                	jmp    800579 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 50 04             	mov    0x4(%eax),%edx
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 40 08             	lea    0x8(%eax),%eax
  800576:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800579:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800585:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800589:	78 3f                	js     8005ca <vprintfmt+0x2e7>
			base = 10;
  80058b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800590:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800594:	0f 84 71 01 00 00    	je     80070b <vprintfmt+0x428>
				putch('+', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 2b                	push   $0x2b
  8005a0:	ff d6                	call   *%esi
  8005a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005aa:	e9 5c 01 00 00       	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b7:	89 c1                	mov    %eax,%ecx
  8005b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 04             	lea    0x4(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c8:	eb af                	jmp    800579 <vprintfmt+0x296>
				putch('-', putdat);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	53                   	push   %ebx
  8005ce:	6a 2d                	push   $0x2d
  8005d0:	ff d6                	call   *%esi
				num = -(long long) num;
  8005d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d8:	f7 d8                	neg    %eax
  8005da:	83 d2 00             	adc    $0x0,%edx
  8005dd:	f7 da                	neg    %edx
  8005df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ed:	e9 19 01 00 00       	jmp    80070b <vprintfmt+0x428>
	if (lflag >= 2)
  8005f2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005f6:	7f 29                	jg     800621 <vprintfmt+0x33e>
	else if (lflag)
  8005f8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005fc:	74 44                	je     800642 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	ba 00 00 00 00       	mov    $0x0,%edx
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800617:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061c:	e9 ea 00 00 00       	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 50 04             	mov    0x4(%eax),%edx
  800627:	8b 00                	mov    (%eax),%eax
  800629:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 40 08             	lea    0x8(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 c9 00 00 00       	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 40 04             	lea    0x4(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800660:	e9 a6 00 00 00       	jmp    80070b <vprintfmt+0x428>
			putch('0', putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 30                	push   $0x30
  80066b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800674:	7f 26                	jg     80069c <vprintfmt+0x3b9>
	else if (lflag)
  800676:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80067a:	74 3e                	je     8006ba <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800695:	b8 08 00 00 00       	mov    $0x8,%eax
  80069a:	eb 6f                	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 50 04             	mov    0x4(%eax),%edx
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 40 08             	lea    0x8(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b8:	eb 51                	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d8:	eb 31                	jmp    80070b <vprintfmt+0x428>
			putch('0', putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	6a 30                	push   $0x30
  8006e0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e2:	83 c4 08             	add    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	6a 78                	push   $0x78
  8006e8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006fa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800706:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800712:	52                   	push   %edx
  800713:	ff 75 e0             	pushl  -0x20(%ebp)
  800716:	50                   	push   %eax
  800717:	ff 75 dc             	pushl  -0x24(%ebp)
  80071a:	ff 75 d8             	pushl  -0x28(%ebp)
  80071d:	89 da                	mov    %ebx,%edx
  80071f:	89 f0                	mov    %esi,%eax
  800721:	e8 a4 fa ff ff       	call   8001ca <printnum>
			break;
  800726:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800729:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	83 c7 01             	add    $0x1,%edi
  80072f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800733:	83 f8 25             	cmp    $0x25,%eax
  800736:	0f 84 be fb ff ff    	je     8002fa <vprintfmt+0x17>
			if (ch == '\0')
  80073c:	85 c0                	test   %eax,%eax
  80073e:	0f 84 28 01 00 00    	je     80086c <vprintfmt+0x589>
			putch(ch, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	50                   	push   %eax
  800749:	ff d6                	call   *%esi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	eb dc                	jmp    80072c <vprintfmt+0x449>
	if (lflag >= 2)
  800750:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800754:	7f 26                	jg     80077c <vprintfmt+0x499>
	else if (lflag)
  800756:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075a:	74 41                	je     80079d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800769:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
  80077a:	eb 8f                	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 50 04             	mov    0x4(%eax),%edx
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 08             	lea    0x8(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800793:	b8 10 00 00 00       	mov    $0x10,%eax
  800798:	e9 6e ff ff ff       	jmp    80070b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 04             	lea    0x4(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bb:	e9 4b ff ff ff       	jmp    80070b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	85 c0                	test   %eax,%eax
  8007d0:	74 14                	je     8007e6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007d2:	8b 13                	mov    (%ebx),%edx
  8007d4:	83 fa 7f             	cmp    $0x7f,%edx
  8007d7:	7f 37                	jg     800810 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007d9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e1:	e9 43 ff ff ff       	jmp    800729 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007eb:	bf 6d 26 80 00       	mov    $0x80266d,%edi
							putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	50                   	push   %eax
  8007f5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f7:	83 c7 01             	add    $0x1,%edi
  8007fa:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	85 c0                	test   %eax,%eax
  800803:	75 eb                	jne    8007f0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	e9 19 ff ff ff       	jmp    800729 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800810:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
  800817:	bf a5 26 80 00       	mov    $0x8026a5,%edi
							putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	50                   	push   %eax
  800821:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800823:	83 c7 01             	add    $0x1,%edi
  800826:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	85 c0                	test   %eax,%eax
  80082f:	75 eb                	jne    80081c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
  800837:	e9 ed fe ff ff       	jmp    800729 <vprintfmt+0x446>
			putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 25                	push   $0x25
  800842:	ff d6                	call   *%esi
			break;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	e9 dd fe ff ff       	jmp    800729 <vprintfmt+0x446>
			putch('%', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	89 f8                	mov    %edi,%eax
  800859:	eb 03                	jmp    80085e <vprintfmt+0x57b>
  80085b:	83 e8 01             	sub    $0x1,%eax
  80085e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800862:	75 f7                	jne    80085b <vprintfmt+0x578>
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	e9 bd fe ff ff       	jmp    800729 <vprintfmt+0x446>
}
  80086c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800880:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800883:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800887:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800891:	85 c0                	test   %eax,%eax
  800893:	74 26                	je     8008bb <vsnprintf+0x47>
  800895:	85 d2                	test   %edx,%edx
  800897:	7e 22                	jle    8008bb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800899:	ff 75 14             	pushl  0x14(%ebp)
  80089c:	ff 75 10             	pushl  0x10(%ebp)
  80089f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	68 a9 02 80 00       	push   $0x8002a9
  8008a8:	e8 36 fa ff ff       	call   8002e3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
}
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    
		return -E_INVAL;
  8008bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c0:	eb f7                	jmp    8008b9 <vsnprintf+0x45>

008008c2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008cb:	50                   	push   %eax
  8008cc:	ff 75 10             	pushl  0x10(%ebp)
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	ff 75 08             	pushl  0x8(%ebp)
  8008d5:	e8 9a ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008eb:	74 05                	je     8008f2 <strlen+0x16>
		n++;
  8008ed:	83 c0 01             	add    $0x1,%eax
  8008f0:	eb f5                	jmp    8008e7 <strlen+0xb>
	return n;
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800902:	39 c2                	cmp    %eax,%edx
  800904:	74 0d                	je     800913 <strnlen+0x1f>
  800906:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80090a:	74 05                	je     800911 <strnlen+0x1d>
		n++;
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	eb f1                	jmp    800902 <strnlen+0xe>
  800911:	89 d0                	mov    %edx,%eax
	return n;
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800928:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80092b:	83 c2 01             	add    $0x1,%edx
  80092e:	84 c9                	test   %cl,%cl
  800930:	75 f2                	jne    800924 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800932:	5b                   	pop    %ebx
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	83 ec 10             	sub    $0x10,%esp
  80093c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093f:	53                   	push   %ebx
  800940:	e8 97 ff ff ff       	call   8008dc <strlen>
  800945:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	01 d8                	add    %ebx,%eax
  80094d:	50                   	push   %eax
  80094e:	e8 c2 ff ff ff       	call   800915 <strcpy>
	return dst;
}
  800953:	89 d8                	mov    %ebx,%eax
  800955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800965:	89 c6                	mov    %eax,%esi
  800967:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80096a:	89 c2                	mov    %eax,%edx
  80096c:	39 f2                	cmp    %esi,%edx
  80096e:	74 11                	je     800981 <strncpy+0x27>
		*dst++ = *src;
  800970:	83 c2 01             	add    $0x1,%edx
  800973:	0f b6 19             	movzbl (%ecx),%ebx
  800976:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800979:	80 fb 01             	cmp    $0x1,%bl
  80097c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80097f:	eb eb                	jmp    80096c <strncpy+0x12>
	}
	return ret;
}
  800981:	5b                   	pop    %ebx
  800982:	5e                   	pop    %esi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 75 08             	mov    0x8(%ebp),%esi
  80098d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800990:	8b 55 10             	mov    0x10(%ebp),%edx
  800993:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800995:	85 d2                	test   %edx,%edx
  800997:	74 21                	je     8009ba <strlcpy+0x35>
  800999:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80099d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80099f:	39 c2                	cmp    %eax,%edx
  8009a1:	74 14                	je     8009b7 <strlcpy+0x32>
  8009a3:	0f b6 19             	movzbl (%ecx),%ebx
  8009a6:	84 db                	test   %bl,%bl
  8009a8:	74 0b                	je     8009b5 <strlcpy+0x30>
			*dst++ = *src++;
  8009aa:	83 c1 01             	add    $0x1,%ecx
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b3:	eb ea                	jmp    80099f <strlcpy+0x1a>
  8009b5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ba:	29 f0                	sub    %esi,%eax
}
  8009bc:	5b                   	pop    %ebx
  8009bd:	5e                   	pop    %esi
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c9:	0f b6 01             	movzbl (%ecx),%eax
  8009cc:	84 c0                	test   %al,%al
  8009ce:	74 0c                	je     8009dc <strcmp+0x1c>
  8009d0:	3a 02                	cmp    (%edx),%al
  8009d2:	75 08                	jne    8009dc <strcmp+0x1c>
		p++, q++;
  8009d4:	83 c1 01             	add    $0x1,%ecx
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	eb ed                	jmp    8009c9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dc:	0f b6 c0             	movzbl %al,%eax
  8009df:	0f b6 12             	movzbl (%edx),%edx
  8009e2:	29 d0                	sub    %edx,%eax
}
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	89 c3                	mov    %eax,%ebx
  8009f2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f5:	eb 06                	jmp    8009fd <strncmp+0x17>
		n--, p++, q++;
  8009f7:	83 c0 01             	add    $0x1,%eax
  8009fa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009fd:	39 d8                	cmp    %ebx,%eax
  8009ff:	74 16                	je     800a17 <strncmp+0x31>
  800a01:	0f b6 08             	movzbl (%eax),%ecx
  800a04:	84 c9                	test   %cl,%cl
  800a06:	74 04                	je     800a0c <strncmp+0x26>
  800a08:	3a 0a                	cmp    (%edx),%cl
  800a0a:	74 eb                	je     8009f7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 00             	movzbl (%eax),%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5b                   	pop    %ebx
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    
		return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1c:	eb f6                	jmp    800a14 <strncmp+0x2e>

00800a1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	0f b6 10             	movzbl (%eax),%edx
  800a2b:	84 d2                	test   %dl,%dl
  800a2d:	74 09                	je     800a38 <strchr+0x1a>
		if (*s == c)
  800a2f:	38 ca                	cmp    %cl,%dl
  800a31:	74 0a                	je     800a3d <strchr+0x1f>
	for (; *s; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f0                	jmp    800a28 <strchr+0xa>
			return (char *) s;
	return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a49:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a4c:	38 ca                	cmp    %cl,%dl
  800a4e:	74 09                	je     800a59 <strfind+0x1a>
  800a50:	84 d2                	test   %dl,%dl
  800a52:	74 05                	je     800a59 <strfind+0x1a>
	for (; *s; s++)
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	eb f0                	jmp    800a49 <strfind+0xa>
			break;
	return (char *) s;
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	57                   	push   %edi
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a67:	85 c9                	test   %ecx,%ecx
  800a69:	74 31                	je     800a9c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a6b:	89 f8                	mov    %edi,%eax
  800a6d:	09 c8                	or     %ecx,%eax
  800a6f:	a8 03                	test   $0x3,%al
  800a71:	75 23                	jne    800a96 <memset+0x3b>
		c &= 0xFF;
  800a73:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a77:	89 d3                	mov    %edx,%ebx
  800a79:	c1 e3 08             	shl    $0x8,%ebx
  800a7c:	89 d0                	mov    %edx,%eax
  800a7e:	c1 e0 18             	shl    $0x18,%eax
  800a81:	89 d6                	mov    %edx,%esi
  800a83:	c1 e6 10             	shl    $0x10,%esi
  800a86:	09 f0                	or     %esi,%eax
  800a88:	09 c2                	or     %eax,%edx
  800a8a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a8c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8f:	89 d0                	mov    %edx,%eax
  800a91:	fc                   	cld    
  800a92:	f3 ab                	rep stos %eax,%es:(%edi)
  800a94:	eb 06                	jmp    800a9c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a99:	fc                   	cld    
  800a9a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a9c:	89 f8                	mov    %edi,%eax
  800a9e:	5b                   	pop    %ebx
  800a9f:	5e                   	pop    %esi
  800aa0:	5f                   	pop    %edi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab1:	39 c6                	cmp    %eax,%esi
  800ab3:	73 32                	jae    800ae7 <memmove+0x44>
  800ab5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab8:	39 c2                	cmp    %eax,%edx
  800aba:	76 2b                	jbe    800ae7 <memmove+0x44>
		s += n;
		d += n;
  800abc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	89 fe                	mov    %edi,%esi
  800ac1:	09 ce                	or     %ecx,%esi
  800ac3:	09 d6                	or     %edx,%esi
  800ac5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800acb:	75 0e                	jne    800adb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800acd:	83 ef 04             	sub    $0x4,%edi
  800ad0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad6:	fd                   	std    
  800ad7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad9:	eb 09                	jmp    800ae4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adb:	83 ef 01             	sub    $0x1,%edi
  800ade:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ae1:	fd                   	std    
  800ae2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae4:	fc                   	cld    
  800ae5:	eb 1a                	jmp    800b01 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae7:	89 c2                	mov    %eax,%edx
  800ae9:	09 ca                	or     %ecx,%edx
  800aeb:	09 f2                	or     %esi,%edx
  800aed:	f6 c2 03             	test   $0x3,%dl
  800af0:	75 0a                	jne    800afc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af5:	89 c7                	mov    %eax,%edi
  800af7:	fc                   	cld    
  800af8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afa:	eb 05                	jmp    800b01 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800afc:	89 c7                	mov    %eax,%edi
  800afe:	fc                   	cld    
  800aff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b0b:	ff 75 10             	pushl  0x10(%ebp)
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 8a ff ff ff       	call   800aa3 <memmove>
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	89 c6                	mov    %eax,%esi
  800b28:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2b:	39 f0                	cmp    %esi,%eax
  800b2d:	74 1c                	je     800b4b <memcmp+0x30>
		if (*s1 != *s2)
  800b2f:	0f b6 08             	movzbl (%eax),%ecx
  800b32:	0f b6 1a             	movzbl (%edx),%ebx
  800b35:	38 d9                	cmp    %bl,%cl
  800b37:	75 08                	jne    800b41 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b39:	83 c0 01             	add    $0x1,%eax
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	eb ea                	jmp    800b2b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b41:	0f b6 c1             	movzbl %cl,%eax
  800b44:	0f b6 db             	movzbl %bl,%ebx
  800b47:	29 d8                	sub    %ebx,%eax
  800b49:	eb 05                	jmp    800b50 <memcmp+0x35>
	}

	return 0;
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b5d:	89 c2                	mov    %eax,%edx
  800b5f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b62:	39 d0                	cmp    %edx,%eax
  800b64:	73 09                	jae    800b6f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b66:	38 08                	cmp    %cl,(%eax)
  800b68:	74 05                	je     800b6f <memfind+0x1b>
	for (; s < ends; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	eb f3                	jmp    800b62 <memfind+0xe>
			break;
	return (void *) s;
}
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
  800b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b7d:	eb 03                	jmp    800b82 <strtol+0x11>
		s++;
  800b7f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b82:	0f b6 01             	movzbl (%ecx),%eax
  800b85:	3c 20                	cmp    $0x20,%al
  800b87:	74 f6                	je     800b7f <strtol+0xe>
  800b89:	3c 09                	cmp    $0x9,%al
  800b8b:	74 f2                	je     800b7f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b8d:	3c 2b                	cmp    $0x2b,%al
  800b8f:	74 2a                	je     800bbb <strtol+0x4a>
	int neg = 0;
  800b91:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b96:	3c 2d                	cmp    $0x2d,%al
  800b98:	74 2b                	je     800bc5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba0:	75 0f                	jne    800bb1 <strtol+0x40>
  800ba2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba5:	74 28                	je     800bcf <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bae:	0f 44 d8             	cmove  %eax,%ebx
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb9:	eb 50                	jmp    800c0b <strtol+0x9a>
		s++;
  800bbb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bbe:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc3:	eb d5                	jmp    800b9a <strtol+0x29>
		s++, neg = 1;
  800bc5:	83 c1 01             	add    $0x1,%ecx
  800bc8:	bf 01 00 00 00       	mov    $0x1,%edi
  800bcd:	eb cb                	jmp    800b9a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bd3:	74 0e                	je     800be3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bd5:	85 db                	test   %ebx,%ebx
  800bd7:	75 d8                	jne    800bb1 <strtol+0x40>
		s++, base = 8;
  800bd9:	83 c1 01             	add    $0x1,%ecx
  800bdc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800be1:	eb ce                	jmp    800bb1 <strtol+0x40>
		s += 2, base = 16;
  800be3:	83 c1 02             	add    $0x2,%ecx
  800be6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800beb:	eb c4                	jmp    800bb1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bed:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bf0:	89 f3                	mov    %esi,%ebx
  800bf2:	80 fb 19             	cmp    $0x19,%bl
  800bf5:	77 29                	ja     800c20 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf7:	0f be d2             	movsbl %dl,%edx
  800bfa:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bfd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c00:	7d 30                	jge    800c32 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c02:	83 c1 01             	add    $0x1,%ecx
  800c05:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c09:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c0b:	0f b6 11             	movzbl (%ecx),%edx
  800c0e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c11:	89 f3                	mov    %esi,%ebx
  800c13:	80 fb 09             	cmp    $0x9,%bl
  800c16:	77 d5                	ja     800bed <strtol+0x7c>
			dig = *s - '0';
  800c18:	0f be d2             	movsbl %dl,%edx
  800c1b:	83 ea 30             	sub    $0x30,%edx
  800c1e:	eb dd                	jmp    800bfd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c20:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 19             	cmp    $0x19,%bl
  800c28:	77 08                	ja     800c32 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c2a:	0f be d2             	movsbl %dl,%edx
  800c2d:	83 ea 37             	sub    $0x37,%edx
  800c30:	eb cb                	jmp    800bfd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c36:	74 05                	je     800c3d <strtol+0xcc>
		*endptr = (char *) s;
  800c38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	f7 da                	neg    %edx
  800c41:	85 ff                	test   %edi,%edi
  800c43:	0f 45 c2             	cmovne %edx,%eax
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5c:	89 c3                	mov    %eax,%ebx
  800c5e:	89 c7                	mov    %eax,%edi
  800c60:	89 c6                	mov    %eax,%esi
  800c62:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	b8 01 00 00 00       	mov    $0x1,%eax
  800c79:	89 d1                	mov    %edx,%ecx
  800c7b:	89 d3                	mov    %edx,%ebx
  800c7d:	89 d7                	mov    %edx,%edi
  800c7f:	89 d6                	mov    %edx,%esi
  800c81:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	53                   	push   %ebx
  800c8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9e:	89 cb                	mov    %ecx,%ebx
  800ca0:	89 cf                	mov    %ecx,%edi
  800ca2:	89 ce                	mov    %ecx,%esi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 03                	push   $0x3
  800cb8:	68 c4 28 80 00       	push   $0x8028c4
  800cbd:	6a 43                	push   $0x43
  800cbf:	68 e1 28 80 00       	push   $0x8028e1
  800cc4:	e8 69 14 00 00       	call   802132 <_panic>

00800cc9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd9:	89 d1                	mov    %edx,%ecx
  800cdb:	89 d3                	mov    %edx,%ebx
  800cdd:	89 d7                	mov    %edx,%edi
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_yield>:

void
sys_yield(void)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cee:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf8:	89 d1                	mov    %edx,%ecx
  800cfa:	89 d3                	mov    %edx,%ebx
  800cfc:	89 d7                	mov    %edx,%edi
  800cfe:	89 d6                	mov    %edx,%esi
  800d00:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d20:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d23:	89 f7                	mov    %esi,%edi
  800d25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7f 08                	jg     800d33 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	50                   	push   %eax
  800d37:	6a 04                	push   $0x4
  800d39:	68 c4 28 80 00       	push   $0x8028c4
  800d3e:	6a 43                	push   $0x43
  800d40:	68 e1 28 80 00       	push   $0x8028e1
  800d45:	e8 e8 13 00 00       	call   802132 <_panic>

00800d4a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d64:	8b 75 18             	mov    0x18(%ebp),%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 05                	push   $0x5
  800d7b:	68 c4 28 80 00       	push   $0x8028c4
  800d80:	6a 43                	push   $0x43
  800d82:	68 e1 28 80 00       	push   $0x8028e1
  800d87:	e8 a6 13 00 00       	call   802132 <_panic>

00800d8c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da0:	b8 06 00 00 00       	mov    $0x6,%eax
  800da5:	89 df                	mov    %ebx,%edi
  800da7:	89 de                	mov    %ebx,%esi
  800da9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7f 08                	jg     800db7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	50                   	push   %eax
  800dbb:	6a 06                	push   $0x6
  800dbd:	68 c4 28 80 00       	push   $0x8028c4
  800dc2:	6a 43                	push   $0x43
  800dc4:	68 e1 28 80 00       	push   $0x8028e1
  800dc9:	e8 64 13 00 00       	call   802132 <_panic>

00800dce <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	b8 08 00 00 00       	mov    $0x8,%eax
  800de7:	89 df                	mov    %ebx,%edi
  800de9:	89 de                	mov    %ebx,%esi
  800deb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ded:	85 c0                	test   %eax,%eax
  800def:	7f 08                	jg     800df9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	50                   	push   %eax
  800dfd:	6a 08                	push   $0x8
  800dff:	68 c4 28 80 00       	push   $0x8028c4
  800e04:	6a 43                	push   $0x43
  800e06:	68 e1 28 80 00       	push   $0x8028e1
  800e0b:	e8 22 13 00 00       	call   802132 <_panic>

00800e10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	b8 09 00 00 00       	mov    $0x9,%eax
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 de                	mov    %ebx,%esi
  800e2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7f 08                	jg     800e3b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	6a 09                	push   $0x9
  800e41:	68 c4 28 80 00       	push   $0x8028c4
  800e46:	6a 43                	push   $0x43
  800e48:	68 e1 28 80 00       	push   $0x8028e1
  800e4d:	e8 e0 12 00 00       	call   802132 <_panic>

00800e52 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7f 08                	jg     800e7d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	50                   	push   %eax
  800e81:	6a 0a                	push   $0xa
  800e83:	68 c4 28 80 00       	push   $0x8028c4
  800e88:	6a 43                	push   $0x43
  800e8a:	68 e1 28 80 00       	push   $0x8028e1
  800e8f:	e8 9e 12 00 00       	call   802132 <_panic>

00800e94 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea5:	be 00 00 00 00       	mov    $0x0,%esi
  800eaa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ead:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ecd:	89 cb                	mov    %ecx,%ebx
  800ecf:	89 cf                	mov    %ecx,%edi
  800ed1:	89 ce                	mov    %ecx,%esi
  800ed3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	7f 08                	jg     800ee1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800ee5:	6a 0d                	push   $0xd
  800ee7:	68 c4 28 80 00       	push   $0x8028c4
  800eec:	6a 43                	push   $0x43
  800eee:	68 e1 28 80 00       	push   $0x8028e1
  800ef3:	e8 3a 12 00 00       	call   802132 <_panic>

00800ef8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0e:	89 df                	mov    %ebx,%edi
  800f10:	89 de                	mov    %ebx,%esi
  800f12:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f2c:	89 cb                	mov    %ecx,%ebx
  800f2e:	89 cf                	mov    %ecx,%edi
  800f30:	89 ce                	mov    %ecx,%esi
  800f32:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f44:	b8 10 00 00 00       	mov    $0x10,%eax
  800f49:	89 d1                	mov    %edx,%ecx
  800f4b:	89 d3                	mov    %edx,%ebx
  800f4d:	89 d7                	mov    %edx,%edi
  800f4f:	89 d6                	mov    %edx,%esi
  800f51:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	b8 11 00 00 00       	mov    $0x11,%eax
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f84:	8b 55 08             	mov    0x8(%ebp),%edx
  800f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8f:	89 df                	mov    %ebx,%edi
  800f91:	89 de                	mov    %ebx,%esi
  800f93:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
  800fa0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	b8 13 00 00 00       	mov    $0x13,%eax
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7f 08                	jg     800fc5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	50                   	push   %eax
  800fc9:	6a 13                	push   $0x13
  800fcb:	68 c4 28 80 00       	push   $0x8028c4
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 e1 28 80 00       	push   $0x8028e1
  800fd7:	e8 56 11 00 00       	call   802132 <_panic>

00800fdc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe7:	c1 e8 0c             	shr    $0xc,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ffc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	c1 ea 16             	shr    $0x16,%edx
  801010:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801017:	f6 c2 01             	test   $0x1,%dl
  80101a:	74 2d                	je     801049 <fd_alloc+0x46>
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	c1 ea 0c             	shr    $0xc,%edx
  801021:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801028:	f6 c2 01             	test   $0x1,%dl
  80102b:	74 1c                	je     801049 <fd_alloc+0x46>
  80102d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801032:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801037:	75 d2                	jne    80100b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801042:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801047:	eb 0a                	jmp    801053 <fd_alloc+0x50>
			*fd_store = fd;
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105b:	83 f8 1f             	cmp    $0x1f,%eax
  80105e:	77 30                	ja     801090 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801060:	c1 e0 0c             	shl    $0xc,%eax
  801063:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801068:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80106e:	f6 c2 01             	test   $0x1,%dl
  801071:	74 24                	je     801097 <fd_lookup+0x42>
  801073:	89 c2                	mov    %eax,%edx
  801075:	c1 ea 0c             	shr    $0xc,%edx
  801078:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107f:	f6 c2 01             	test   $0x1,%dl
  801082:	74 1a                	je     80109e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	89 02                	mov    %eax,(%edx)
	return 0;
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    
		return -E_INVAL;
  801090:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801095:	eb f7                	jmp    80108e <fd_lookup+0x39>
		return -E_INVAL;
  801097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109c:	eb f0                	jmp    80108e <fd_lookup+0x39>
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a3:	eb e9                	jmp    80108e <fd_lookup+0x39>

008010a5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b8:	39 08                	cmp    %ecx,(%eax)
  8010ba:	74 38                	je     8010f4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010bc:	83 c2 01             	add    $0x1,%edx
  8010bf:	8b 04 95 6c 29 80 00 	mov    0x80296c(,%edx,4),%eax
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	75 ee                	jne    8010b8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8010cf:	8b 40 48             	mov    0x48(%eax),%eax
  8010d2:	83 ec 04             	sub    $0x4,%esp
  8010d5:	51                   	push   %ecx
  8010d6:	50                   	push   %eax
  8010d7:	68 f0 28 80 00       	push   $0x8028f0
  8010dc:	e8 d5 f0 ff ff       	call   8001b6 <cprintf>
	*dev = 0;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    
			*dev = devtab[i];
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	eb f2                	jmp    8010f2 <dev_lookup+0x4d>

00801100 <fd_close>:
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 24             	sub    $0x24,%esp
  801109:	8b 75 08             	mov    0x8(%ebp),%esi
  80110c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80110f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801112:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801113:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801119:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80111c:	50                   	push   %eax
  80111d:	e8 33 ff ff ff       	call   801055 <fd_lookup>
  801122:	89 c3                	mov    %eax,%ebx
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 05                	js     801130 <fd_close+0x30>
	    || fd != fd2)
  80112b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80112e:	74 16                	je     801146 <fd_close+0x46>
		return (must_exist ? r : 0);
  801130:	89 f8                	mov    %edi,%eax
  801132:	84 c0                	test   %al,%al
  801134:	b8 00 00 00 00       	mov    $0x0,%eax
  801139:	0f 44 d8             	cmove  %eax,%ebx
}
  80113c:	89 d8                	mov    %ebx,%eax
  80113e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80114c:	50                   	push   %eax
  80114d:	ff 36                	pushl  (%esi)
  80114f:	e8 51 ff ff ff       	call   8010a5 <dev_lookup>
  801154:	89 c3                	mov    %eax,%ebx
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	78 1a                	js     801177 <fd_close+0x77>
		if (dev->dev_close)
  80115d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801160:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801163:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801168:	85 c0                	test   %eax,%eax
  80116a:	74 0b                	je     801177 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	56                   	push   %esi
  801170:	ff d0                	call   *%eax
  801172:	89 c3                	mov    %eax,%ebx
  801174:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	56                   	push   %esi
  80117b:	6a 00                	push   $0x0
  80117d:	e8 0a fc ff ff       	call   800d8c <sys_page_unmap>
	return r;
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	eb b5                	jmp    80113c <fd_close+0x3c>

00801187 <close>:

int
close(int fdnum)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80118d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	ff 75 08             	pushl  0x8(%ebp)
  801194:	e8 bc fe ff ff       	call   801055 <fd_lookup>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	79 02                	jns    8011a2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    
		return fd_close(fd, 1);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	6a 01                	push   $0x1
  8011a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011aa:	e8 51 ff ff ff       	call   801100 <fd_close>
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	eb ec                	jmp    8011a0 <close+0x19>

008011b4 <close_all>:

void
close_all(void)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	53                   	push   %ebx
  8011c4:	e8 be ff ff ff       	call   801187 <close>
	for (i = 0; i < MAXFD; i++)
  8011c9:	83 c3 01             	add    $0x1,%ebx
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	83 fb 20             	cmp    $0x20,%ebx
  8011d2:	75 ec                	jne    8011c0 <close_all+0xc>
}
  8011d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 08             	pushl  0x8(%ebp)
  8011e9:	e8 67 fe ff ff       	call   801055 <fd_lookup>
  8011ee:	89 c3                	mov    %eax,%ebx
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	0f 88 81 00 00 00    	js     80127c <dup+0xa3>
		return r;
	close(newfdnum);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	ff 75 0c             	pushl  0xc(%ebp)
  801201:	e8 81 ff ff ff       	call   801187 <close>

	newfd = INDEX2FD(newfdnum);
  801206:	8b 75 0c             	mov    0xc(%ebp),%esi
  801209:	c1 e6 0c             	shl    $0xc,%esi
  80120c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801212:	83 c4 04             	add    $0x4,%esp
  801215:	ff 75 e4             	pushl  -0x1c(%ebp)
  801218:	e8 cf fd ff ff       	call   800fec <fd2data>
  80121d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80121f:	89 34 24             	mov    %esi,(%esp)
  801222:	e8 c5 fd ff ff       	call   800fec <fd2data>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80122c:	89 d8                	mov    %ebx,%eax
  80122e:	c1 e8 16             	shr    $0x16,%eax
  801231:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801238:	a8 01                	test   $0x1,%al
  80123a:	74 11                	je     80124d <dup+0x74>
  80123c:	89 d8                	mov    %ebx,%eax
  80123e:	c1 e8 0c             	shr    $0xc,%eax
  801241:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801248:	f6 c2 01             	test   $0x1,%dl
  80124b:	75 39                	jne    801286 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80124d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e8 0c             	shr    $0xc,%eax
  801255:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	25 07 0e 00 00       	and    $0xe07,%eax
  801264:	50                   	push   %eax
  801265:	56                   	push   %esi
  801266:	6a 00                	push   $0x0
  801268:	52                   	push   %edx
  801269:	6a 00                	push   $0x0
  80126b:	e8 da fa ff ff       	call   800d4a <sys_page_map>
  801270:	89 c3                	mov    %eax,%ebx
  801272:	83 c4 20             	add    $0x20,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	78 31                	js     8012aa <dup+0xd1>
		goto err;

	return newfdnum;
  801279:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80127c:	89 d8                	mov    %ebx,%eax
  80127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801286:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	25 07 0e 00 00       	and    $0xe07,%eax
  801295:	50                   	push   %eax
  801296:	57                   	push   %edi
  801297:	6a 00                	push   $0x0
  801299:	53                   	push   %ebx
  80129a:	6a 00                	push   $0x0
  80129c:	e8 a9 fa ff ff       	call   800d4a <sys_page_map>
  8012a1:	89 c3                	mov    %eax,%ebx
  8012a3:	83 c4 20             	add    $0x20,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	79 a3                	jns    80124d <dup+0x74>
	sys_page_unmap(0, newfd);
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	56                   	push   %esi
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 d7 fa ff ff       	call   800d8c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012b5:	83 c4 08             	add    $0x8,%esp
  8012b8:	57                   	push   %edi
  8012b9:	6a 00                	push   $0x0
  8012bb:	e8 cc fa ff ff       	call   800d8c <sys_page_unmap>
	return r;
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	eb b7                	jmp    80127c <dup+0xa3>

008012c5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 1c             	sub    $0x1c,%esp
  8012cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d2:	50                   	push   %eax
  8012d3:	53                   	push   %ebx
  8012d4:	e8 7c fd ff ff       	call   801055 <fd_lookup>
  8012d9:	83 c4 10             	add    $0x10,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 3f                	js     80131f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	ff 30                	pushl  (%eax)
  8012ec:	e8 b4 fd ff ff       	call   8010a5 <dev_lookup>
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 27                	js     80131f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012fb:	8b 42 08             	mov    0x8(%edx),%eax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	83 f8 01             	cmp    $0x1,%eax
  801304:	74 1e                	je     801324 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801309:	8b 40 08             	mov    0x8(%eax),%eax
  80130c:	85 c0                	test   %eax,%eax
  80130e:	74 35                	je     801345 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801310:	83 ec 04             	sub    $0x4,%esp
  801313:	ff 75 10             	pushl  0x10(%ebp)
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	52                   	push   %edx
  80131a:	ff d0                	call   *%eax
  80131c:	83 c4 10             	add    $0x10,%esp
}
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801324:	a1 08 40 80 00       	mov    0x804008,%eax
  801329:	8b 40 48             	mov    0x48(%eax),%eax
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	53                   	push   %ebx
  801330:	50                   	push   %eax
  801331:	68 31 29 80 00       	push   $0x802931
  801336:	e8 7b ee ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801343:	eb da                	jmp    80131f <read+0x5a>
		return -E_NOT_SUPP;
  801345:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134a:	eb d3                	jmp    80131f <read+0x5a>

0080134c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	8b 7d 08             	mov    0x8(%ebp),%edi
  801358:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80135b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801360:	39 f3                	cmp    %esi,%ebx
  801362:	73 23                	jae    801387 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801364:	83 ec 04             	sub    $0x4,%esp
  801367:	89 f0                	mov    %esi,%eax
  801369:	29 d8                	sub    %ebx,%eax
  80136b:	50                   	push   %eax
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	03 45 0c             	add    0xc(%ebp),%eax
  801371:	50                   	push   %eax
  801372:	57                   	push   %edi
  801373:	e8 4d ff ff ff       	call   8012c5 <read>
		if (m < 0)
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 06                	js     801385 <readn+0x39>
			return m;
		if (m == 0)
  80137f:	74 06                	je     801387 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801381:	01 c3                	add    %eax,%ebx
  801383:	eb db                	jmp    801360 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801385:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801387:	89 d8                	mov    %ebx,%eax
  801389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	53                   	push   %ebx
  801395:	83 ec 1c             	sub    $0x1c,%esp
  801398:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139e:	50                   	push   %eax
  80139f:	53                   	push   %ebx
  8013a0:	e8 b0 fc ff ff       	call   801055 <fd_lookup>
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 3a                	js     8013e6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b2:	50                   	push   %eax
  8013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b6:	ff 30                	pushl  (%eax)
  8013b8:	e8 e8 fc ff ff       	call   8010a5 <dev_lookup>
  8013bd:	83 c4 10             	add    $0x10,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	78 22                	js     8013e6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013cb:	74 1e                	je     8013eb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d0:	8b 52 0c             	mov    0xc(%edx),%edx
  8013d3:	85 d2                	test   %edx,%edx
  8013d5:	74 35                	je     80140c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	ff 75 10             	pushl  0x10(%ebp)
  8013dd:	ff 75 0c             	pushl  0xc(%ebp)
  8013e0:	50                   	push   %eax
  8013e1:	ff d2                	call   *%edx
  8013e3:	83 c4 10             	add    $0x10,%esp
}
  8013e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f0:	8b 40 48             	mov    0x48(%eax),%eax
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	53                   	push   %ebx
  8013f7:	50                   	push   %eax
  8013f8:	68 4d 29 80 00       	push   $0x80294d
  8013fd:	e8 b4 ed ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140a:	eb da                	jmp    8013e6 <write+0x55>
		return -E_NOT_SUPP;
  80140c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801411:	eb d3                	jmp    8013e6 <write+0x55>

00801413 <seek>:

int
seek(int fdnum, off_t offset)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801419:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	e8 30 fc ff ff       	call   801055 <fd_lookup>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 0e                	js     80143a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801432:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	53                   	push   %ebx
  801440:	83 ec 1c             	sub    $0x1c,%esp
  801443:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801449:	50                   	push   %eax
  80144a:	53                   	push   %ebx
  80144b:	e8 05 fc ff ff       	call   801055 <fd_lookup>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 37                	js     80148e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145d:	50                   	push   %eax
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	ff 30                	pushl  (%eax)
  801463:	e8 3d fc ff ff       	call   8010a5 <dev_lookup>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 1f                	js     80148e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801472:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801476:	74 1b                	je     801493 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801478:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147b:	8b 52 18             	mov    0x18(%edx),%edx
  80147e:	85 d2                	test   %edx,%edx
  801480:	74 32                	je     8014b4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	50                   	push   %eax
  801489:	ff d2                	call   *%edx
  80148b:	83 c4 10             	add    $0x10,%esp
}
  80148e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801491:	c9                   	leave  
  801492:	c3                   	ret    
			thisenv->env_id, fdnum);
  801493:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801498:	8b 40 48             	mov    0x48(%eax),%eax
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	53                   	push   %ebx
  80149f:	50                   	push   %eax
  8014a0:	68 10 29 80 00       	push   $0x802910
  8014a5:	e8 0c ed ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b2:	eb da                	jmp    80148e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b9:	eb d3                	jmp    80148e <ftruncate+0x52>

008014bb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 1c             	sub    $0x1c,%esp
  8014c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	ff 75 08             	pushl  0x8(%ebp)
  8014cc:	e8 84 fb ff ff       	call   801055 <fd_lookup>
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 4b                	js     801523 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	ff 30                	pushl  (%eax)
  8014e4:	e8 bc fb ff ff       	call   8010a5 <dev_lookup>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 33                	js     801523 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f7:	74 2f                	je     801528 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801503:	00 00 00 
	stat->st_isdir = 0;
  801506:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80150d:	00 00 00 
	stat->st_dev = dev;
  801510:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	53                   	push   %ebx
  80151a:	ff 75 f0             	pushl  -0x10(%ebp)
  80151d:	ff 50 14             	call   *0x14(%eax)
  801520:	83 c4 10             	add    $0x10,%esp
}
  801523:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801526:	c9                   	leave  
  801527:	c3                   	ret    
		return -E_NOT_SUPP;
  801528:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152d:	eb f4                	jmp    801523 <fstat+0x68>

0080152f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	6a 00                	push   $0x0
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 22 02 00 00       	call   801763 <open>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 1b                	js     801565 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	50                   	push   %eax
  801551:	e8 65 ff ff ff       	call   8014bb <fstat>
  801556:	89 c6                	mov    %eax,%esi
	close(fd);
  801558:	89 1c 24             	mov    %ebx,(%esp)
  80155b:	e8 27 fc ff ff       	call   801187 <close>
	return r;
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	89 f3                	mov    %esi,%ebx
}
  801565:	89 d8                	mov    %ebx,%eax
  801567:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
  801573:	89 c6                	mov    %eax,%esi
  801575:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801577:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80157e:	74 27                	je     8015a7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801580:	6a 07                	push   $0x7
  801582:	68 00 50 80 00       	push   $0x805000
  801587:	56                   	push   %esi
  801588:	ff 35 00 40 80 00    	pushl  0x804000
  80158e:	e8 69 0c 00 00       	call   8021fc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801593:	83 c4 0c             	add    $0xc,%esp
  801596:	6a 00                	push   $0x0
  801598:	53                   	push   %ebx
  801599:	6a 00                	push   $0x0
  80159b:	e8 f3 0b 00 00       	call   802193 <ipc_recv>
}
  8015a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	6a 01                	push   $0x1
  8015ac:	e8 a3 0c 00 00       	call   802254 <ipc_find_env>
  8015b1:	a3 00 40 80 00       	mov    %eax,0x804000
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	eb c5                	jmp    801580 <fsipc+0x12>

008015bb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d9:	b8 02 00 00 00       	mov    $0x2,%eax
  8015de:	e8 8b ff ff ff       	call   80156e <fsipc>
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <devfile_flush>:
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fb:	b8 06 00 00 00       	mov    $0x6,%eax
  801600:	e8 69 ff ff ff       	call   80156e <fsipc>
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <devfile_stat>:
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	53                   	push   %ebx
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8b 40 0c             	mov    0xc(%eax),%eax
  801617:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80161c:	ba 00 00 00 00       	mov    $0x0,%edx
  801621:	b8 05 00 00 00       	mov    $0x5,%eax
  801626:	e8 43 ff ff ff       	call   80156e <fsipc>
  80162b:	85 c0                	test   %eax,%eax
  80162d:	78 2c                	js     80165b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	68 00 50 80 00       	push   $0x805000
  801637:	53                   	push   %ebx
  801638:	e8 d8 f2 ff ff       	call   800915 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80163d:	a1 80 50 80 00       	mov    0x805080,%eax
  801642:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801648:	a1 84 50 80 00       	mov    0x805084,%eax
  80164d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <devfile_write>:
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	53                   	push   %ebx
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8b 40 0c             	mov    0xc(%eax),%eax
  801670:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801675:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80167b:	53                   	push   %ebx
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	68 08 50 80 00       	push   $0x805008
  801684:	e8 7c f4 ff ff       	call   800b05 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801689:	ba 00 00 00 00       	mov    $0x0,%edx
  80168e:	b8 04 00 00 00       	mov    $0x4,%eax
  801693:	e8 d6 fe ff ff       	call   80156e <fsipc>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 0b                	js     8016aa <devfile_write+0x4a>
	assert(r <= n);
  80169f:	39 d8                	cmp    %ebx,%eax
  8016a1:	77 0c                	ja     8016af <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a8:	7f 1e                	jg     8016c8 <devfile_write+0x68>
}
  8016aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    
	assert(r <= n);
  8016af:	68 80 29 80 00       	push   $0x802980
  8016b4:	68 87 29 80 00       	push   $0x802987
  8016b9:	68 98 00 00 00       	push   $0x98
  8016be:	68 9c 29 80 00       	push   $0x80299c
  8016c3:	e8 6a 0a 00 00       	call   802132 <_panic>
	assert(r <= PGSIZE);
  8016c8:	68 a7 29 80 00       	push   $0x8029a7
  8016cd:	68 87 29 80 00       	push   $0x802987
  8016d2:	68 99 00 00 00       	push   $0x99
  8016d7:	68 9c 29 80 00       	push   $0x80299c
  8016dc:	e8 51 0a 00 00       	call   802132 <_panic>

008016e1 <devfile_read>:
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
  8016e6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016f4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	b8 03 00 00 00       	mov    $0x3,%eax
  801704:	e8 65 fe ff ff       	call   80156e <fsipc>
  801709:	89 c3                	mov    %eax,%ebx
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 1f                	js     80172e <devfile_read+0x4d>
	assert(r <= n);
  80170f:	39 f0                	cmp    %esi,%eax
  801711:	77 24                	ja     801737 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801713:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801718:	7f 33                	jg     80174d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	50                   	push   %eax
  80171e:	68 00 50 80 00       	push   $0x805000
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	e8 78 f3 ff ff       	call   800aa3 <memmove>
	return r;
  80172b:	83 c4 10             	add    $0x10,%esp
}
  80172e:	89 d8                	mov    %ebx,%eax
  801730:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    
	assert(r <= n);
  801737:	68 80 29 80 00       	push   $0x802980
  80173c:	68 87 29 80 00       	push   $0x802987
  801741:	6a 7c                	push   $0x7c
  801743:	68 9c 29 80 00       	push   $0x80299c
  801748:	e8 e5 09 00 00       	call   802132 <_panic>
	assert(r <= PGSIZE);
  80174d:	68 a7 29 80 00       	push   $0x8029a7
  801752:	68 87 29 80 00       	push   $0x802987
  801757:	6a 7d                	push   $0x7d
  801759:	68 9c 29 80 00       	push   $0x80299c
  80175e:	e8 cf 09 00 00       	call   802132 <_panic>

00801763 <open>:
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 1c             	sub    $0x1c,%esp
  80176b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80176e:	56                   	push   %esi
  80176f:	e8 68 f1 ff ff       	call   8008dc <strlen>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80177c:	7f 6c                	jg     8017ea <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80177e:	83 ec 0c             	sub    $0xc,%esp
  801781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801784:	50                   	push   %eax
  801785:	e8 79 f8 ff ff       	call   801003 <fd_alloc>
  80178a:	89 c3                	mov    %eax,%ebx
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 3c                	js     8017cf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	56                   	push   %esi
  801797:	68 00 50 80 00       	push   $0x805000
  80179c:	e8 74 f1 ff ff       	call   800915 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b1:	e8 b8 fd ff ff       	call   80156e <fsipc>
  8017b6:	89 c3                	mov    %eax,%ebx
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 19                	js     8017d8 <open+0x75>
	return fd2num(fd);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c5:	e8 12 f8 ff ff       	call   800fdc <fd2num>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 10             	add    $0x10,%esp
}
  8017cf:	89 d8                	mov    %ebx,%eax
  8017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    
		fd_close(fd, 0);
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	6a 00                	push   $0x0
  8017dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e0:	e8 1b f9 ff ff       	call   801100 <fd_close>
		return r;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	eb e5                	jmp    8017cf <open+0x6c>
		return -E_BAD_PATH;
  8017ea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017ef:	eb de                	jmp    8017cf <open+0x6c>

008017f1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 08 00 00 00       	mov    $0x8,%eax
  801801:	e8 68 fd ff ff       	call   80156e <fsipc>
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80180e:	68 b3 29 80 00       	push   $0x8029b3
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	e8 fa f0 ff ff       	call   800915 <strcpy>
	return 0;
}
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <devsock_close>:
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	53                   	push   %ebx
  801826:	83 ec 10             	sub    $0x10,%esp
  801829:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80182c:	53                   	push   %ebx
  80182d:	e8 5d 0a 00 00       	call   80228f <pageref>
  801832:	83 c4 10             	add    $0x10,%esp
		return 0;
  801835:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80183a:	83 f8 01             	cmp    $0x1,%eax
  80183d:	74 07                	je     801846 <devsock_close+0x24>
}
  80183f:	89 d0                	mov    %edx,%eax
  801841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801844:	c9                   	leave  
  801845:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	ff 73 0c             	pushl  0xc(%ebx)
  80184c:	e8 b9 02 00 00       	call   801b0a <nsipc_close>
  801851:	89 c2                	mov    %eax,%edx
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	eb e7                	jmp    80183f <devsock_close+0x1d>

00801858 <devsock_write>:
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80185e:	6a 00                	push   $0x0
  801860:	ff 75 10             	pushl  0x10(%ebp)
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	ff 70 0c             	pushl  0xc(%eax)
  80186c:	e8 76 03 00 00       	call   801be7 <nsipc_send>
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <devsock_read>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801879:	6a 00                	push   $0x0
  80187b:	ff 75 10             	pushl  0x10(%ebp)
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	ff 70 0c             	pushl  0xc(%eax)
  801887:	e8 ef 02 00 00       	call   801b7b <nsipc_recv>
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <fd2sockid>:
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801894:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	e8 b7 f7 ff ff       	call   801055 <fd_lookup>
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 10                	js     8018b5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a8:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018ae:	39 08                	cmp    %ecx,(%eax)
  8018b0:	75 05                	jne    8018b7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018b2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018bc:	eb f7                	jmp    8018b5 <fd2sockid+0x27>

008018be <alloc_sockfd>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 1c             	sub    $0x1c,%esp
  8018c6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	e8 32 f7 ff ff       	call   801003 <fd_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 43                	js     80191d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 07 04 00 00       	push   $0x407
  8018e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e5:	6a 00                	push   $0x0
  8018e7:	e8 1b f4 ff ff       	call   800d07 <sys_page_alloc>
  8018ec:	89 c3                	mov    %eax,%ebx
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 28                	js     80191d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018fe:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80190a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	50                   	push   %eax
  801911:	e8 c6 f6 ff ff       	call   800fdc <fd2num>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	eb 0c                	jmp    801929 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	56                   	push   %esi
  801921:	e8 e4 01 00 00       	call   801b0a <nsipc_close>
		return r;
  801926:	83 c4 10             	add    $0x10,%esp
}
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    

00801932 <accept>:
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	e8 4e ff ff ff       	call   80188e <fd2sockid>
  801940:	85 c0                	test   %eax,%eax
  801942:	78 1b                	js     80195f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	ff 75 10             	pushl  0x10(%ebp)
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	50                   	push   %eax
  80194e:	e8 0e 01 00 00       	call   801a61 <nsipc_accept>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 05                	js     80195f <accept+0x2d>
	return alloc_sockfd(r);
  80195a:	e8 5f ff ff ff       	call   8018be <alloc_sockfd>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <bind>:
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	e8 1f ff ff ff       	call   80188e <fd2sockid>
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 12                	js     801985 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	ff 75 10             	pushl  0x10(%ebp)
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	50                   	push   %eax
  80197d:	e8 31 01 00 00       	call   801ab3 <nsipc_bind>
  801982:	83 c4 10             	add    $0x10,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <shutdown>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	e8 f9 fe ff ff       	call   80188e <fd2sockid>
  801995:	85 c0                	test   %eax,%eax
  801997:	78 0f                	js     8019a8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	50                   	push   %eax
  8019a0:	e8 43 01 00 00       	call   801ae8 <nsipc_shutdown>
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <connect>:
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	e8 d6 fe ff ff       	call   80188e <fd2sockid>
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 12                	js     8019ce <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	ff 75 10             	pushl  0x10(%ebp)
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	e8 59 01 00 00       	call   801b24 <nsipc_connect>
  8019cb:	83 c4 10             	add    $0x10,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <listen>:
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	e8 b0 fe ff ff       	call   80188e <fd2sockid>
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 0f                	js     8019f1 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019e2:	83 ec 08             	sub    $0x8,%esp
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	50                   	push   %eax
  8019e9:	e8 6b 01 00 00       	call   801b59 <nsipc_listen>
  8019ee:	83 c4 10             	add    $0x10,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019f9:	ff 75 10             	pushl  0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	e8 3e 02 00 00       	call   801c45 <nsipc_socket>
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 05                	js     801a13 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a0e:	e8 ab fe ff ff       	call   8018be <alloc_sockfd>
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	53                   	push   %ebx
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a1e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a25:	74 26                	je     801a4d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a27:	6a 07                	push   $0x7
  801a29:	68 00 60 80 00       	push   $0x806000
  801a2e:	53                   	push   %ebx
  801a2f:	ff 35 04 40 80 00    	pushl  0x804004
  801a35:	e8 c2 07 00 00       	call   8021fc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a3a:	83 c4 0c             	add    $0xc,%esp
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	e8 4b 07 00 00       	call   802193 <ipc_recv>
}
  801a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	6a 02                	push   $0x2
  801a52:	e8 fd 07 00 00       	call   802254 <ipc_find_env>
  801a57:	a3 04 40 80 00       	mov    %eax,0x804004
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	eb c6                	jmp    801a27 <nsipc+0x12>

00801a61 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	56                   	push   %esi
  801a65:	53                   	push   %ebx
  801a66:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a71:	8b 06                	mov    (%esi),%eax
  801a73:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a78:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7d:	e8 93 ff ff ff       	call   801a15 <nsipc>
  801a82:	89 c3                	mov    %eax,%ebx
  801a84:	85 c0                	test   %eax,%eax
  801a86:	79 09                	jns    801a91 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	ff 35 10 60 80 00    	pushl  0x806010
  801a9a:	68 00 60 80 00       	push   $0x806000
  801a9f:	ff 75 0c             	pushl  0xc(%ebp)
  801aa2:	e8 fc ef ff ff       	call   800aa3 <memmove>
		*addrlen = ret->ret_addrlen;
  801aa7:	a1 10 60 80 00       	mov    0x806010,%eax
  801aac:	89 06                	mov    %eax,(%esi)
  801aae:	83 c4 10             	add    $0x10,%esp
	return r;
  801ab1:	eb d5                	jmp    801a88 <nsipc_accept+0x27>

00801ab3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ac5:	53                   	push   %ebx
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	68 04 60 80 00       	push   $0x806004
  801ace:	e8 d0 ef ff ff       	call   800aa3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ad3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ad9:	b8 02 00 00 00       	mov    $0x2,%eax
  801ade:	e8 32 ff ff ff       	call   801a15 <nsipc>
}
  801ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801afe:	b8 03 00 00 00       	mov    $0x3,%eax
  801b03:	e8 0d ff ff ff       	call   801a15 <nsipc>
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <nsipc_close>:

int
nsipc_close(int s)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b18:	b8 04 00 00 00       	mov    $0x4,%eax
  801b1d:	e8 f3 fe ff ff       	call   801a15 <nsipc>
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	53                   	push   %ebx
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b36:	53                   	push   %ebx
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	68 04 60 80 00       	push   $0x806004
  801b3f:	e8 5f ef ff ff       	call   800aa3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b44:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b4a:	b8 05 00 00 00       	mov    $0x5,%eax
  801b4f:	e8 c1 fe ff ff       	call   801a15 <nsipc>
}
  801b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b6f:	b8 06 00 00 00       	mov    $0x6,%eax
  801b74:	e8 9c fe ff ff       	call   801a15 <nsipc>
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	56                   	push   %esi
  801b7f:	53                   	push   %ebx
  801b80:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b8b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b99:	b8 07 00 00 00       	mov    $0x7,%eax
  801b9e:	e8 72 fe ff ff       	call   801a15 <nsipc>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 1f                	js     801bc8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ba9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bae:	7f 21                	jg     801bd1 <nsipc_recv+0x56>
  801bb0:	39 c6                	cmp    %eax,%esi
  801bb2:	7c 1d                	jl     801bd1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	50                   	push   %eax
  801bb8:	68 00 60 80 00       	push   $0x806000
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	e8 de ee ff ff       	call   800aa3 <memmove>
  801bc5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5e                   	pop    %esi
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bd1:	68 bf 29 80 00       	push   $0x8029bf
  801bd6:	68 87 29 80 00       	push   $0x802987
  801bdb:	6a 62                	push   $0x62
  801bdd:	68 d4 29 80 00       	push   $0x8029d4
  801be2:	e8 4b 05 00 00       	call   802132 <_panic>

00801be7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	53                   	push   %ebx
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bf9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bff:	7f 2e                	jg     801c2f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	53                   	push   %ebx
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	68 0c 60 80 00       	push   $0x80600c
  801c0d:	e8 91 ee ff ff       	call   800aa3 <memmove>
	nsipcbuf.send.req_size = size;
  801c12:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c18:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c20:	b8 08 00 00 00       	mov    $0x8,%eax
  801c25:	e8 eb fd ff ff       	call   801a15 <nsipc>
}
  801c2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    
	assert(size < 1600);
  801c2f:	68 e0 29 80 00       	push   $0x8029e0
  801c34:	68 87 29 80 00       	push   $0x802987
  801c39:	6a 6d                	push   $0x6d
  801c3b:	68 d4 29 80 00       	push   $0x8029d4
  801c40:	e8 ed 04 00 00       	call   802132 <_panic>

00801c45 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c56:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c63:	b8 09 00 00 00       	mov    $0x9,%eax
  801c68:	e8 a8 fd ff ff       	call   801a15 <nsipc>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c77:	83 ec 0c             	sub    $0xc,%esp
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 6a f3 ff ff       	call   800fec <fd2data>
  801c82:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c84:	83 c4 08             	add    $0x8,%esp
  801c87:	68 ec 29 80 00       	push   $0x8029ec
  801c8c:	53                   	push   %ebx
  801c8d:	e8 83 ec ff ff       	call   800915 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c92:	8b 46 04             	mov    0x4(%esi),%eax
  801c95:	2b 06                	sub    (%esi),%eax
  801c97:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c9d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ca4:	00 00 00 
	stat->st_dev = &devpipe;
  801ca7:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cae:	30 80 00 
	return 0;
}
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb9:	5b                   	pop    %ebx
  801cba:	5e                   	pop    %esi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    

00801cbd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cc7:	53                   	push   %ebx
  801cc8:	6a 00                	push   $0x0
  801cca:	e8 bd f0 ff ff       	call   800d8c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ccf:	89 1c 24             	mov    %ebx,(%esp)
  801cd2:	e8 15 f3 ff ff       	call   800fec <fd2data>
  801cd7:	83 c4 08             	add    $0x8,%esp
  801cda:	50                   	push   %eax
  801cdb:	6a 00                	push   $0x0
  801cdd:	e8 aa f0 ff ff       	call   800d8c <sys_page_unmap>
}
  801ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <_pipeisclosed>:
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	57                   	push   %edi
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 1c             	sub    $0x1c,%esp
  801cf0:	89 c7                	mov    %eax,%edi
  801cf2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cf4:	a1 08 40 80 00       	mov    0x804008,%eax
  801cf9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	57                   	push   %edi
  801d00:	e8 8a 05 00 00       	call   80228f <pageref>
  801d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d08:	89 34 24             	mov    %esi,(%esp)
  801d0b:	e8 7f 05 00 00       	call   80228f <pageref>
		nn = thisenv->env_runs;
  801d10:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d16:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	39 cb                	cmp    %ecx,%ebx
  801d1e:	74 1b                	je     801d3b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d23:	75 cf                	jne    801cf4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d25:	8b 42 58             	mov    0x58(%edx),%eax
  801d28:	6a 01                	push   $0x1
  801d2a:	50                   	push   %eax
  801d2b:	53                   	push   %ebx
  801d2c:	68 f3 29 80 00       	push   $0x8029f3
  801d31:	e8 80 e4 ff ff       	call   8001b6 <cprintf>
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	eb b9                	jmp    801cf4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d3e:	0f 94 c0             	sete   %al
  801d41:	0f b6 c0             	movzbl %al,%eax
}
  801d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <devpipe_write>:
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	57                   	push   %edi
  801d50:	56                   	push   %esi
  801d51:	53                   	push   %ebx
  801d52:	83 ec 28             	sub    $0x28,%esp
  801d55:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d58:	56                   	push   %esi
  801d59:	e8 8e f2 ff ff       	call   800fec <fd2data>
  801d5e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	bf 00 00 00 00       	mov    $0x0,%edi
  801d68:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d6b:	74 4f                	je     801dbc <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d6d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d70:	8b 0b                	mov    (%ebx),%ecx
  801d72:	8d 51 20             	lea    0x20(%ecx),%edx
  801d75:	39 d0                	cmp    %edx,%eax
  801d77:	72 14                	jb     801d8d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d79:	89 da                	mov    %ebx,%edx
  801d7b:	89 f0                	mov    %esi,%eax
  801d7d:	e8 65 ff ff ff       	call   801ce7 <_pipeisclosed>
  801d82:	85 c0                	test   %eax,%eax
  801d84:	75 3b                	jne    801dc1 <devpipe_write+0x75>
			sys_yield();
  801d86:	e8 5d ef ff ff       	call   800ce8 <sys_yield>
  801d8b:	eb e0                	jmp    801d6d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d90:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d94:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d97:	89 c2                	mov    %eax,%edx
  801d99:	c1 fa 1f             	sar    $0x1f,%edx
  801d9c:	89 d1                	mov    %edx,%ecx
  801d9e:	c1 e9 1b             	shr    $0x1b,%ecx
  801da1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801da4:	83 e2 1f             	and    $0x1f,%edx
  801da7:	29 ca                	sub    %ecx,%edx
  801da9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801db1:	83 c0 01             	add    $0x1,%eax
  801db4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801db7:	83 c7 01             	add    $0x1,%edi
  801dba:	eb ac                	jmp    801d68 <devpipe_write+0x1c>
	return i;
  801dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbf:	eb 05                	jmp    801dc6 <devpipe_write+0x7a>
				return 0;
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <devpipe_read>:
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 18             	sub    $0x18,%esp
  801dd7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dda:	57                   	push   %edi
  801ddb:	e8 0c f2 ff ff       	call   800fec <fd2data>
  801de0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	be 00 00 00 00       	mov    $0x0,%esi
  801dea:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ded:	75 14                	jne    801e03 <devpipe_read+0x35>
	return i;
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	eb 02                	jmp    801df6 <devpipe_read+0x28>
				return i;
  801df4:	89 f0                	mov    %esi,%eax
}
  801df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df9:	5b                   	pop    %ebx
  801dfa:	5e                   	pop    %esi
  801dfb:	5f                   	pop    %edi
  801dfc:	5d                   	pop    %ebp
  801dfd:	c3                   	ret    
			sys_yield();
  801dfe:	e8 e5 ee ff ff       	call   800ce8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e03:	8b 03                	mov    (%ebx),%eax
  801e05:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e08:	75 18                	jne    801e22 <devpipe_read+0x54>
			if (i > 0)
  801e0a:	85 f6                	test   %esi,%esi
  801e0c:	75 e6                	jne    801df4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e0e:	89 da                	mov    %ebx,%edx
  801e10:	89 f8                	mov    %edi,%eax
  801e12:	e8 d0 fe ff ff       	call   801ce7 <_pipeisclosed>
  801e17:	85 c0                	test   %eax,%eax
  801e19:	74 e3                	je     801dfe <devpipe_read+0x30>
				return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	eb d4                	jmp    801df6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e22:	99                   	cltd   
  801e23:	c1 ea 1b             	shr    $0x1b,%edx
  801e26:	01 d0                	add    %edx,%eax
  801e28:	83 e0 1f             	and    $0x1f,%eax
  801e2b:	29 d0                	sub    %edx,%eax
  801e2d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e35:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e38:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e3b:	83 c6 01             	add    $0x1,%esi
  801e3e:	eb aa                	jmp    801dea <devpipe_read+0x1c>

00801e40 <pipe>:
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
  801e45:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4b:	50                   	push   %eax
  801e4c:	e8 b2 f1 ff ff       	call   801003 <fd_alloc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	0f 88 23 01 00 00    	js     801f81 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	68 07 04 00 00       	push   $0x407
  801e66:	ff 75 f4             	pushl  -0xc(%ebp)
  801e69:	6a 00                	push   $0x0
  801e6b:	e8 97 ee ff ff       	call   800d07 <sys_page_alloc>
  801e70:	89 c3                	mov    %eax,%ebx
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	85 c0                	test   %eax,%eax
  801e77:	0f 88 04 01 00 00    	js     801f81 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e83:	50                   	push   %eax
  801e84:	e8 7a f1 ff ff       	call   801003 <fd_alloc>
  801e89:	89 c3                	mov    %eax,%ebx
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	0f 88 db 00 00 00    	js     801f71 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 07 04 00 00       	push   $0x407
  801e9e:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea1:	6a 00                	push   $0x0
  801ea3:	e8 5f ee ff ff       	call   800d07 <sys_page_alloc>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	0f 88 bc 00 00 00    	js     801f71 <pipe+0x131>
	va = fd2data(fd0);
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebb:	e8 2c f1 ff ff       	call   800fec <fd2data>
  801ec0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec2:	83 c4 0c             	add    $0xc,%esp
  801ec5:	68 07 04 00 00       	push   $0x407
  801eca:	50                   	push   %eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	e8 35 ee ff ff       	call   800d07 <sys_page_alloc>
  801ed2:	89 c3                	mov    %eax,%ebx
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	0f 88 82 00 00 00    	js     801f61 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee5:	e8 02 f1 ff ff       	call   800fec <fd2data>
  801eea:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ef1:	50                   	push   %eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	56                   	push   %esi
  801ef5:	6a 00                	push   $0x0
  801ef7:	e8 4e ee ff ff       	call   800d4a <sys_page_map>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	83 c4 20             	add    $0x20,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 4e                	js     801f53 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f05:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f12:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f21:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2e:	e8 a9 f0 ff ff       	call   800fdc <fd2num>
  801f33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f36:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f38:	83 c4 04             	add    $0x4,%esp
  801f3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3e:	e8 99 f0 ff ff       	call   800fdc <fd2num>
  801f43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f46:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f51:	eb 2e                	jmp    801f81 <pipe+0x141>
	sys_page_unmap(0, va);
  801f53:	83 ec 08             	sub    $0x8,%esp
  801f56:	56                   	push   %esi
  801f57:	6a 00                	push   $0x0
  801f59:	e8 2e ee ff ff       	call   800d8c <sys_page_unmap>
  801f5e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f61:	83 ec 08             	sub    $0x8,%esp
  801f64:	ff 75 f0             	pushl  -0x10(%ebp)
  801f67:	6a 00                	push   $0x0
  801f69:	e8 1e ee ff ff       	call   800d8c <sys_page_unmap>
  801f6e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	ff 75 f4             	pushl  -0xc(%ebp)
  801f77:	6a 00                	push   $0x0
  801f79:	e8 0e ee ff ff       	call   800d8c <sys_page_unmap>
  801f7e:	83 c4 10             	add    $0x10,%esp
}
  801f81:	89 d8                	mov    %ebx,%eax
  801f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5e                   	pop    %esi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    

00801f8a <pipeisclosed>:
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f93:	50                   	push   %eax
  801f94:	ff 75 08             	pushl  0x8(%ebp)
  801f97:	e8 b9 f0 ff ff       	call   801055 <fd_lookup>
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	78 18                	js     801fbb <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa9:	e8 3e f0 ff ff       	call   800fec <fd2data>
	return _pipeisclosed(fd, p);
  801fae:	89 c2                	mov    %eax,%edx
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	e8 2f fd ff ff       	call   801ce7 <_pipeisclosed>
  801fb8:	83 c4 10             	add    $0x10,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	c3                   	ret    

00801fc3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc9:	68 0b 2a 80 00       	push   $0x802a0b
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	e8 3f e9 ff ff       	call   800915 <strcpy>
	return 0;
}
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <devcons_write>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	57                   	push   %edi
  801fe1:	56                   	push   %esi
  801fe2:	53                   	push   %ebx
  801fe3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fee:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ff4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff7:	73 31                	jae    80202a <devcons_write+0x4d>
		m = n - tot;
  801ff9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ffc:	29 f3                	sub    %esi,%ebx
  801ffe:	83 fb 7f             	cmp    $0x7f,%ebx
  802001:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802006:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	53                   	push   %ebx
  80200d:	89 f0                	mov    %esi,%eax
  80200f:	03 45 0c             	add    0xc(%ebp),%eax
  802012:	50                   	push   %eax
  802013:	57                   	push   %edi
  802014:	e8 8a ea ff ff       	call   800aa3 <memmove>
		sys_cputs(buf, m);
  802019:	83 c4 08             	add    $0x8,%esp
  80201c:	53                   	push   %ebx
  80201d:	57                   	push   %edi
  80201e:	e8 28 ec ff ff       	call   800c4b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802023:	01 de                	add    %ebx,%esi
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	eb ca                	jmp    801ff4 <devcons_write+0x17>
}
  80202a:	89 f0                	mov    %esi,%eax
  80202c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <devcons_read>:
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80203f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802043:	74 21                	je     802066 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802045:	e8 1f ec ff ff       	call   800c69 <sys_cgetc>
  80204a:	85 c0                	test   %eax,%eax
  80204c:	75 07                	jne    802055 <devcons_read+0x21>
		sys_yield();
  80204e:	e8 95 ec ff ff       	call   800ce8 <sys_yield>
  802053:	eb f0                	jmp    802045 <devcons_read+0x11>
	if (c < 0)
  802055:	78 0f                	js     802066 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802057:	83 f8 04             	cmp    $0x4,%eax
  80205a:	74 0c                	je     802068 <devcons_read+0x34>
	*(char*)vbuf = c;
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	88 02                	mov    %al,(%edx)
	return 1;
  802061:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    
		return 0;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	eb f7                	jmp    802066 <devcons_read+0x32>

0080206f <cputchar>:
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80207b:	6a 01                	push   $0x1
  80207d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802080:	50                   	push   %eax
  802081:	e8 c5 eb ff ff       	call   800c4b <sys_cputs>
}
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <getchar>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802091:	6a 01                	push   $0x1
  802093:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 27 f2 ff ff       	call   8012c5 <read>
	if (r < 0)
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 06                	js     8020ab <getchar+0x20>
	if (r < 1)
  8020a5:	74 06                	je     8020ad <getchar+0x22>
	return c;
  8020a7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    
		return -E_EOF;
  8020ad:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020b2:	eb f7                	jmp    8020ab <getchar+0x20>

008020b4 <iscons>:
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bd:	50                   	push   %eax
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	e8 8f ef ff ff       	call   801055 <fd_lookup>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 11                	js     8020de <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d6:	39 10                	cmp    %edx,(%eax)
  8020d8:	0f 94 c0             	sete   %al
  8020db:	0f b6 c0             	movzbl %al,%eax
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <opencons>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e9:	50                   	push   %eax
  8020ea:	e8 14 ef ff ff       	call   801003 <fd_alloc>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 3a                	js     802130 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	68 07 04 00 00       	push   $0x407
  8020fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802101:	6a 00                	push   $0x0
  802103:	e8 ff eb ff ff       	call   800d07 <sys_page_alloc>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 21                	js     802130 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802118:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	50                   	push   %eax
  802128:	e8 af ee ff ff       	call   800fdc <fd2num>
  80212d:	83 c4 10             	add    $0x10,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	56                   	push   %esi
  802136:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802137:	a1 08 40 80 00       	mov    0x804008,%eax
  80213c:	8b 40 48             	mov    0x48(%eax),%eax
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	68 48 2a 80 00       	push   $0x802a48
  802147:	50                   	push   %eax
  802148:	68 17 2a 80 00       	push   $0x802a17
  80214d:	e8 64 e0 ff ff       	call   8001b6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802152:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802155:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80215b:	e8 69 eb ff ff       	call   800cc9 <sys_getenvid>
  802160:	83 c4 04             	add    $0x4,%esp
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	56                   	push   %esi
  80216a:	50                   	push   %eax
  80216b:	68 24 2a 80 00       	push   $0x802a24
  802170:	e8 41 e0 ff ff       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802175:	83 c4 18             	add    $0x18,%esp
  802178:	53                   	push   %ebx
  802179:	ff 75 10             	pushl  0x10(%ebp)
  80217c:	e8 e4 df ff ff       	call   800165 <vcprintf>
	cprintf("\n");
  802181:	c7 04 24 2b 25 80 00 	movl   $0x80252b,(%esp)
  802188:	e8 29 e0 ff ff       	call   8001b6 <cprintf>
  80218d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802190:	cc                   	int3   
  802191:	eb fd                	jmp    802190 <_panic+0x5e>

00802193 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	8b 75 08             	mov    0x8(%ebp),%esi
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021a1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021a3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021a8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021ab:	83 ec 0c             	sub    $0xc,%esp
  8021ae:	50                   	push   %eax
  8021af:	e8 03 ed ff ff       	call   800eb7 <sys_ipc_recv>
	if(ret < 0){
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	78 2b                	js     8021e6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021bb:	85 f6                	test   %esi,%esi
  8021bd:	74 0a                	je     8021c9 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c4:	8b 40 74             	mov    0x74(%eax),%eax
  8021c7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021c9:	85 db                	test   %ebx,%ebx
  8021cb:	74 0a                	je     8021d7 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8021d2:	8b 40 78             	mov    0x78(%eax),%eax
  8021d5:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8021dc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e2:	5b                   	pop    %ebx
  8021e3:	5e                   	pop    %esi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    
		if(from_env_store)
  8021e6:	85 f6                	test   %esi,%esi
  8021e8:	74 06                	je     8021f0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021f0:	85 db                	test   %ebx,%ebx
  8021f2:	74 eb                	je     8021df <ipc_recv+0x4c>
			*perm_store = 0;
  8021f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021fa:	eb e3                	jmp    8021df <ipc_recv+0x4c>

008021fc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	83 ec 0c             	sub    $0xc,%esp
  802205:	8b 7d 08             	mov    0x8(%ebp),%edi
  802208:	8b 75 0c             	mov    0xc(%ebp),%esi
  80220b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80220e:	85 db                	test   %ebx,%ebx
  802210:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802215:	0f 44 d8             	cmove  %eax,%ebx
  802218:	eb 05                	jmp    80221f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80221a:	e8 c9 ea ff ff       	call   800ce8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80221f:	ff 75 14             	pushl  0x14(%ebp)
  802222:	53                   	push   %ebx
  802223:	56                   	push   %esi
  802224:	57                   	push   %edi
  802225:	e8 6a ec ff ff       	call   800e94 <sys_ipc_try_send>
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 1b                	je     80224c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802231:	79 e7                	jns    80221a <ipc_send+0x1e>
  802233:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802236:	74 e2                	je     80221a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802238:	83 ec 04             	sub    $0x4,%esp
  80223b:	68 4f 2a 80 00       	push   $0x802a4f
  802240:	6a 48                	push   $0x48
  802242:	68 64 2a 80 00       	push   $0x802a64
  802247:	e8 e6 fe ff ff       	call   802132 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80224c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    

00802254 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80225f:	89 c2                	mov    %eax,%edx
  802261:	c1 e2 07             	shl    $0x7,%edx
  802264:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80226a:	8b 52 50             	mov    0x50(%edx),%edx
  80226d:	39 ca                	cmp    %ecx,%edx
  80226f:	74 11                	je     802282 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802271:	83 c0 01             	add    $0x1,%eax
  802274:	3d 00 04 00 00       	cmp    $0x400,%eax
  802279:	75 e4                	jne    80225f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	eb 0b                	jmp    80228d <ipc_find_env+0x39>
			return envs[i].env_id;
  802282:	c1 e0 07             	shl    $0x7,%eax
  802285:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80228a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80228d:	5d                   	pop    %ebp
  80228e:	c3                   	ret    

0080228f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802295:	89 d0                	mov    %edx,%eax
  802297:	c1 e8 16             	shr    $0x16,%eax
  80229a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022a6:	f6 c1 01             	test   $0x1,%cl
  8022a9:	74 1d                	je     8022c8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022ab:	c1 ea 0c             	shr    $0xc,%edx
  8022ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022b5:	f6 c2 01             	test   $0x1,%dl
  8022b8:	74 0e                	je     8022c8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022ba:	c1 ea 0c             	shr    $0xc,%edx
  8022bd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022c4:	ef 
  8022c5:	0f b7 c0             	movzwl %ax,%eax
}
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	66 90                	xchg   %ax,%ax
  8022ce:	66 90                	xchg   %ax,%ax

008022d0 <__udivdi3>:
  8022d0:	55                   	push   %ebp
  8022d1:	57                   	push   %edi
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 1c             	sub    $0x1c,%esp
  8022d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022e7:	85 d2                	test   %edx,%edx
  8022e9:	75 4d                	jne    802338 <__udivdi3+0x68>
  8022eb:	39 f3                	cmp    %esi,%ebx
  8022ed:	76 19                	jbe    802308 <__udivdi3+0x38>
  8022ef:	31 ff                	xor    %edi,%edi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	89 d9                	mov    %ebx,%ecx
  80230a:	85 db                	test   %ebx,%ebx
  80230c:	75 0b                	jne    802319 <__udivdi3+0x49>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 c1                	mov    %eax,%ecx
  802319:	31 d2                	xor    %edx,%edx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	f7 f1                	div    %ecx
  80231f:	89 c6                	mov    %eax,%esi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f7                	mov    %esi,%edi
  802325:	f7 f1                	div    %ecx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	77 1c                	ja     802358 <__udivdi3+0x88>
  80233c:	0f bd fa             	bsr    %edx,%edi
  80233f:	83 f7 1f             	xor    $0x1f,%edi
  802342:	75 2c                	jne    802370 <__udivdi3+0xa0>
  802344:	39 f2                	cmp    %esi,%edx
  802346:	72 06                	jb     80234e <__udivdi3+0x7e>
  802348:	31 c0                	xor    %eax,%eax
  80234a:	39 eb                	cmp    %ebp,%ebx
  80234c:	77 a9                	ja     8022f7 <__udivdi3+0x27>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	eb a2                	jmp    8022f7 <__udivdi3+0x27>
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	31 ff                	xor    %edi,%edi
  80235a:	31 c0                	xor    %eax,%eax
  80235c:	89 fa                	mov    %edi,%edx
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	89 eb                	mov    %ebp,%ebx
  8023a1:	d3 e6                	shl    %cl,%esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 15                	jb     8023d0 <__udivdi3+0x100>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 04                	jae    8023c7 <__udivdi3+0xf7>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	74 09                	je     8023d0 <__udivdi3+0x100>
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	e9 27 ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023d3:	31 ff                	xor    %edi,%edi
  8023d5:	e9 1d ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	89 da                	mov    %ebx,%edx
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	75 43                	jne    802440 <__umoddi3+0x60>
  8023fd:	39 df                	cmp    %ebx,%edi
  8023ff:	76 17                	jbe    802418 <__umoddi3+0x38>
  802401:	89 f0                	mov    %esi,%eax
  802403:	f7 f7                	div    %edi
  802405:	89 d0                	mov    %edx,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 fd                	mov    %edi,%ebp
  80241a:	85 ff                	test   %edi,%edi
  80241c:	75 0b                	jne    802429 <__umoddi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f7                	div    %edi
  802427:	89 c5                	mov    %eax,%ebp
  802429:	89 d8                	mov    %ebx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	f7 f5                	div    %ebp
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 f5                	div    %ebp
  802433:	89 d0                	mov    %edx,%eax
  802435:	eb d0                	jmp    802407 <__umoddi3+0x27>
  802437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243e:	66 90                	xchg   %ax,%ax
  802440:	89 f1                	mov    %esi,%ecx
  802442:	39 d8                	cmp    %ebx,%eax
  802444:	76 0a                	jbe    802450 <__umoddi3+0x70>
  802446:	89 f0                	mov    %esi,%eax
  802448:	83 c4 1c             	add    $0x1c,%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    
  802450:	0f bd e8             	bsr    %eax,%ebp
  802453:	83 f5 1f             	xor    $0x1f,%ebp
  802456:	75 20                	jne    802478 <__umoddi3+0x98>
  802458:	39 d8                	cmp    %ebx,%eax
  80245a:	0f 82 b0 00 00 00    	jb     802510 <__umoddi3+0x130>
  802460:	39 f7                	cmp    %esi,%edi
  802462:	0f 86 a8 00 00 00    	jbe    802510 <__umoddi3+0x130>
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	83 c4 1c             	add    $0x1c,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    
  802472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	ba 20 00 00 00       	mov    $0x20,%edx
  80247f:	29 ea                	sub    %ebp,%edx
  802481:	d3 e0                	shl    %cl,%eax
  802483:	89 44 24 08          	mov    %eax,0x8(%esp)
  802487:	89 d1                	mov    %edx,%ecx
  802489:	89 f8                	mov    %edi,%eax
  80248b:	d3 e8                	shr    %cl,%eax
  80248d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802491:	89 54 24 04          	mov    %edx,0x4(%esp)
  802495:	8b 54 24 04          	mov    0x4(%esp),%edx
  802499:	09 c1                	or     %eax,%ecx
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 e9                	mov    %ebp,%ecx
  8024a3:	d3 e7                	shl    %cl,%edi
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	89 d1                	mov    %edx,%ecx
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	d3 e6                	shl    %cl,%esi
  8024bf:	09 d8                	or     %ebx,%eax
  8024c1:	f7 74 24 08          	divl   0x8(%esp)
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	89 f3                	mov    %esi,%ebx
  8024c9:	f7 64 24 0c          	mull   0xc(%esp)
  8024cd:	89 c6                	mov    %eax,%esi
  8024cf:	89 d7                	mov    %edx,%edi
  8024d1:	39 d1                	cmp    %edx,%ecx
  8024d3:	72 06                	jb     8024db <__umoddi3+0xfb>
  8024d5:	75 10                	jne    8024e7 <__umoddi3+0x107>
  8024d7:	39 c3                	cmp    %eax,%ebx
  8024d9:	73 0c                	jae    8024e7 <__umoddi3+0x107>
  8024db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	89 ca                	mov    %ecx,%edx
  8024e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	19 fa                	sbb    %edi,%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	d3 e0                	shl    %cl,%eax
  8024f6:	89 e9                	mov    %ebp,%ecx
  8024f8:	d3 eb                	shr    %cl,%ebx
  8024fa:	d3 ea                	shr    %cl,%edx
  8024fc:	09 d8                	or     %ebx,%eax
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 da                	mov    %ebx,%edx
  802512:	29 fe                	sub    %edi,%esi
  802514:	19 c2                	sbb    %eax,%edx
  802516:	89 f1                	mov    %esi,%ecx
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	e9 4b ff ff ff       	jmp    80246a <__umoddi3+0x8a>
