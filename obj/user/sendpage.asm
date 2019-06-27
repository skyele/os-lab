
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
  800039:	e8 a5 13 00 00       	call   8013e3 <fork>
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
  80005c:	e8 38 0e 00 00       	call   800e99 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 40 80 00    	pushl  0x804004
  80006a:	e8 ff 09 00 00       	call   800a6e <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 40 80 00    	pushl  0x804004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 11 0c 00 00       	call   800c97 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 4d 16 00 00       	call   8016e4 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 d1 15 00 00       	call   80167b <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 60 2c 80 00       	push   $0x802c60
  8000ba:	e8 89 02 00 00       	call   800348 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 40 80 00    	pushl  0x804000
  8000c8:	e8 a1 09 00 00       	call   800a6e <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 40 80 00    	pushl  0x804000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 97 0a 00 00       	call   800b78 <strncmp>
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
  8000fc:	e8 7a 15 00 00       	call   80167b <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 60 2c 80 00       	push   $0x802c60
  800111:	e8 32 02 00 00       	call   800348 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 40 80 00    	pushl  0x804004
  80011f:	e8 4a 09 00 00       	call   800a6e <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 40 80 00    	pushl  0x804004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 40 0a 00 00       	call   800b78 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 40 80 00    	pushl  0x804000
  800148:	e8 21 09 00 00       	call   800a6e <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 40 80 00    	pushl  0x804000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 33 0b 00 00       	call   800c97 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 6f 15 00 00       	call   8016e4 <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 74 2c 80 00       	push   $0x802c74
  800185:	e8 be 01 00 00       	call   800348 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 94 2c 80 00       	push   $0x802c94
  800197:	e8 ac 01 00 00       	call   800348 <cprintf>
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
  8001b7:	e8 9f 0c 00 00       	call   800e5b <sys_getenvid>
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
  8001dc:	74 23                	je     800201 <libmain+0x5d>
		if(envs[i].env_id == find)
  8001de:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8001e4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001ea:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001ed:	39 c1                	cmp    %eax,%ecx
  8001ef:	75 e2                	jne    8001d3 <libmain+0x2f>
  8001f1:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8001f7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001fd:	89 fe                	mov    %edi,%esi
  8001ff:	eb d2                	jmp    8001d3 <libmain+0x2f>
  800201:	89 f0                	mov    %esi,%eax
  800203:	84 c0                	test   %al,%al
  800205:	74 06                	je     80020d <libmain+0x69>
  800207:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800211:	7e 0a                	jle    80021d <libmain+0x79>
		binaryname = argv[0];
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
  800216:	8b 00                	mov    (%eax),%eax
  800218:	a3 08 40 80 00       	mov    %eax,0x804008

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80021d:	a1 08 50 80 00       	mov    0x805008,%eax
  800222:	8b 40 48             	mov    0x48(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 02 2d 80 00       	push   $0x802d02
  80022e:	e8 15 01 00 00       	call   800348 <cprintf>
	cprintf("before umain\n");
  800233:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  80023a:	e8 09 01 00 00       	call   800348 <cprintf>
	// call user main routine
	umain(argc, argv);
  80023f:	83 c4 08             	add    $0x8,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 e6 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80024d:	c7 04 24 2e 2d 80 00 	movl   $0x802d2e,(%esp)
  800254:	e8 ef 00 00 00       	call   800348 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800259:	a1 08 50 80 00       	mov    0x805008,%eax
  80025e:	8b 40 48             	mov    0x48(%eax),%eax
  800261:	83 c4 08             	add    $0x8,%esp
  800264:	50                   	push   %eax
  800265:	68 3b 2d 80 00       	push   $0x802d3b
  80026a:	e8 d9 00 00 00       	call   800348 <cprintf>
	// exit gracefully
	exit();
  80026f:	e8 0b 00 00 00       	call   80027f <exit>
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800285:	a1 08 50 80 00       	mov    0x805008,%eax
  80028a:	8b 40 48             	mov    0x48(%eax),%eax
  80028d:	68 68 2d 80 00       	push   $0x802d68
  800292:	50                   	push   %eax
  800293:	68 5a 2d 80 00       	push   $0x802d5a
  800298:	e8 ab 00 00 00       	call   800348 <cprintf>
	close_all();
  80029d:	e8 b1 16 00 00       	call   801953 <close_all>
	sys_env_destroy(0);
  8002a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a9:	e8 6c 0b 00 00       	call   800e1a <sys_env_destroy>
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bd:	8b 13                	mov    (%ebx),%edx
  8002bf:	8d 42 01             	lea    0x1(%edx),%eax
  8002c2:	89 03                	mov    %eax,(%ebx)
  8002c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	74 09                	je     8002db <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002d2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	68 ff 00 00 00       	push   $0xff
  8002e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e6:	50                   	push   %eax
  8002e7:	e8 f1 0a 00 00       	call   800ddd <sys_cputs>
		b->idx = 0;
  8002ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	eb db                	jmp    8002d2 <putch+0x1f>

008002f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800300:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800307:	00 00 00 
	b.cnt = 0;
  80030a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800311:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800320:	50                   	push   %eax
  800321:	68 b3 02 80 00       	push   $0x8002b3
  800326:	e8 4a 01 00 00       	call   800475 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80032b:	83 c4 08             	add    $0x8,%esp
  80032e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800334:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	e8 9d 0a 00 00       	call   800ddd <sys_cputs>

	return b.cnt;
}
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800351:	50                   	push   %eax
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	e8 9d ff ff ff       	call   8002f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	53                   	push   %ebx
  800362:	83 ec 1c             	sub    $0x1c,%esp
  800365:	89 c6                	mov    %eax,%esi
  800367:	89 d7                	mov    %edx,%edi
  800369:	8b 45 08             	mov    0x8(%ebp),%eax
  80036c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800375:	8b 45 10             	mov    0x10(%ebp),%eax
  800378:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80037b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80037f:	74 2c                	je     8003ad <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800381:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800384:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80038b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80038e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800391:	39 c2                	cmp    %eax,%edx
  800393:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800396:	73 43                	jae    8003db <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	85 db                	test   %ebx,%ebx
  80039d:	7e 6c                	jle    80040b <printnum+0xaf>
				putch(padc, putdat);
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	57                   	push   %edi
  8003a3:	ff 75 18             	pushl  0x18(%ebp)
  8003a6:	ff d6                	call   *%esi
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	eb eb                	jmp    800398 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	6a 20                	push   $0x20
  8003b2:	6a 00                	push   $0x0
  8003b4:	50                   	push   %eax
  8003b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bb:	89 fa                	mov    %edi,%edx
  8003bd:	89 f0                	mov    %esi,%eax
  8003bf:	e8 98 ff ff ff       	call   80035c <printnum>
		while (--width > 0)
  8003c4:	83 c4 20             	add    $0x20,%esp
  8003c7:	83 eb 01             	sub    $0x1,%ebx
  8003ca:	85 db                	test   %ebx,%ebx
  8003cc:	7e 65                	jle    800433 <printnum+0xd7>
			putch(padc, putdat);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	57                   	push   %edi
  8003d2:	6a 20                	push   $0x20
  8003d4:	ff d6                	call   *%esi
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	eb ec                	jmp    8003c7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003db:	83 ec 0c             	sub    $0xc,%esp
  8003de:	ff 75 18             	pushl  0x18(%ebp)
  8003e1:	83 eb 01             	sub    $0x1,%ebx
  8003e4:	53                   	push   %ebx
  8003e5:	50                   	push   %eax
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	e8 16 26 00 00       	call   802a10 <__udivdi3>
  8003fa:	83 c4 18             	add    $0x18,%esp
  8003fd:	52                   	push   %edx
  8003fe:	50                   	push   %eax
  8003ff:	89 fa                	mov    %edi,%edx
  800401:	89 f0                	mov    %esi,%eax
  800403:	e8 54 ff ff ff       	call   80035c <printnum>
  800408:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	57                   	push   %edi
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	ff 75 dc             	pushl  -0x24(%ebp)
  800415:	ff 75 d8             	pushl  -0x28(%ebp)
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	ff 75 e0             	pushl  -0x20(%ebp)
  80041e:	e8 fd 26 00 00       	call   802b20 <__umoddi3>
  800423:	83 c4 14             	add    $0x14,%esp
  800426:	0f be 80 6d 2d 80 00 	movsbl 0x802d6d(%eax),%eax
  80042d:	50                   	push   %eax
  80042e:	ff d6                	call   *%esi
  800430:	83 c4 10             	add    $0x10,%esp
	}
}
  800433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800436:	5b                   	pop    %ebx
  800437:	5e                   	pop    %esi
  800438:	5f                   	pop    %edi
  800439:	5d                   	pop    %ebp
  80043a:	c3                   	ret    

0080043b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800441:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800445:	8b 10                	mov    (%eax),%edx
  800447:	3b 50 04             	cmp    0x4(%eax),%edx
  80044a:	73 0a                	jae    800456 <sprintputch+0x1b>
		*b->buf++ = ch;
  80044c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80044f:	89 08                	mov    %ecx,(%eax)
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	88 02                	mov    %al,(%edx)
}
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    

00800458 <printfmt>:
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80045e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800461:	50                   	push   %eax
  800462:	ff 75 10             	pushl  0x10(%ebp)
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	ff 75 08             	pushl  0x8(%ebp)
  80046b:	e8 05 00 00 00       	call   800475 <vprintfmt>
}
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <vprintfmt>:
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	57                   	push   %edi
  800479:	56                   	push   %esi
  80047a:	53                   	push   %ebx
  80047b:	83 ec 3c             	sub    $0x3c,%esp
  80047e:	8b 75 08             	mov    0x8(%ebp),%esi
  800481:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800484:	8b 7d 10             	mov    0x10(%ebp),%edi
  800487:	e9 32 04 00 00       	jmp    8008be <vprintfmt+0x449>
		padc = ' ';
  80048c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800490:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800497:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80049e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004ac:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8d 47 01             	lea    0x1(%edi),%eax
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004be:	0f b6 17             	movzbl (%edi),%edx
  8004c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c4:	3c 55                	cmp    $0x55,%al
  8004c6:	0f 87 12 05 00 00    	ja     8009de <vprintfmt+0x569>
  8004cc:	0f b6 c0             	movzbl %al,%eax
  8004cf:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  8004d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004d9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004dd:	eb d9                	jmp    8004b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004e6:	eb d0                	jmp    8004b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	0f b6 d2             	movzbl %dl,%edx
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	eb 03                	jmp    8004fb <vprintfmt+0x86>
  8004f8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800502:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800505:	8d 72 d0             	lea    -0x30(%edx),%esi
  800508:	83 fe 09             	cmp    $0x9,%esi
  80050b:	76 eb                	jbe    8004f8 <vprintfmt+0x83>
  80050d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800510:	8b 75 08             	mov    0x8(%ebp),%esi
  800513:	eb 14                	jmp    800529 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8d 40 04             	lea    0x4(%eax),%eax
  800523:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052d:	79 89                	jns    8004b8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80052f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800535:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053c:	e9 77 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
  800541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	0f 48 c1             	cmovs  %ecx,%eax
  800549:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054f:	e9 64 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
  800554:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800557:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80055e:	e9 55 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
			lflag++;
  800563:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80056a:	e9 49 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 78 04             	lea    0x4(%eax),%edi
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	53                   	push   %ebx
  800579:	ff 30                	pushl  (%eax)
  80057b:	ff d6                	call   *%esi
			break;
  80057d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800580:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800583:	e9 33 03 00 00       	jmp    8008bb <vprintfmt+0x446>
			err = va_arg(ap, int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 78 04             	lea    0x4(%eax),%edi
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	99                   	cltd   
  800591:	31 d0                	xor    %edx,%eax
  800593:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800595:	83 f8 11             	cmp    $0x11,%eax
  800598:	7f 23                	jg     8005bd <vprintfmt+0x148>
  80059a:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  8005a1:	85 d2                	test   %edx,%edx
  8005a3:	74 18                	je     8005bd <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a5:	52                   	push   %edx
  8005a6:	68 cd 32 80 00       	push   $0x8032cd
  8005ab:	53                   	push   %ebx
  8005ac:	56                   	push   %esi
  8005ad:	e8 a6 fe ff ff       	call   800458 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b8:	e9 fe 02 00 00       	jmp    8008bb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bd:	50                   	push   %eax
  8005be:	68 85 2d 80 00       	push   $0x802d85
  8005c3:	53                   	push   %ebx
  8005c4:	56                   	push   %esi
  8005c5:	e8 8e fe ff ff       	call   800458 <printfmt>
  8005ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005d0:	e9 e6 02 00 00       	jmp    8008bb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e3:	85 c9                	test   %ecx,%ecx
  8005e5:	b8 7e 2d 80 00       	mov    $0x802d7e,%eax
  8005ea:	0f 45 c1             	cmovne %ecx,%eax
  8005ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f4:	7e 06                	jle    8005fc <vprintfmt+0x187>
  8005f6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005fa:	75 0d                	jne    800609 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ff:	89 c7                	mov    %eax,%edi
  800601:	03 45 e0             	add    -0x20(%ebp),%eax
  800604:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800607:	eb 53                	jmp    80065c <vprintfmt+0x1e7>
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 d8             	pushl  -0x28(%ebp)
  80060f:	50                   	push   %eax
  800610:	e8 71 04 00 00       	call   800a86 <strnlen>
  800615:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800618:	29 c1                	sub    %eax,%ecx
  80061a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800622:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800626:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800629:	eb 0f                	jmp    80063a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	ff 75 e0             	pushl  -0x20(%ebp)
  800632:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	83 ef 01             	sub    $0x1,%edi
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	85 ff                	test   %edi,%edi
  80063c:	7f ed                	jg     80062b <vprintfmt+0x1b6>
  80063e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800641:	85 c9                	test   %ecx,%ecx
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	0f 49 c1             	cmovns %ecx,%eax
  80064b:	29 c1                	sub    %eax,%ecx
  80064d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800650:	eb aa                	jmp    8005fc <vprintfmt+0x187>
					putch(ch, putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	52                   	push   %edx
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800661:	83 c7 01             	add    $0x1,%edi
  800664:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800668:	0f be d0             	movsbl %al,%edx
  80066b:	85 d2                	test   %edx,%edx
  80066d:	74 4b                	je     8006ba <vprintfmt+0x245>
  80066f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800673:	78 06                	js     80067b <vprintfmt+0x206>
  800675:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800679:	78 1e                	js     800699 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80067b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80067f:	74 d1                	je     800652 <vprintfmt+0x1dd>
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 e8 20             	sub    $0x20,%eax
  800687:	83 f8 5e             	cmp    $0x5e,%eax
  80068a:	76 c6                	jbe    800652 <vprintfmt+0x1dd>
					putch('?', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 3f                	push   $0x3f
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb c3                	jmp    80065c <vprintfmt+0x1e7>
  800699:	89 cf                	mov    %ecx,%edi
  80069b:	eb 0e                	jmp    8006ab <vprintfmt+0x236>
				putch(' ', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 20                	push   $0x20
  8006a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a5:	83 ef 01             	sub    $0x1,%edi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	85 ff                	test   %edi,%edi
  8006ad:	7f ee                	jg     80069d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b5:	e9 01 02 00 00       	jmp    8008bb <vprintfmt+0x446>
  8006ba:	89 cf                	mov    %ecx,%edi
  8006bc:	eb ed                	jmp    8006ab <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006c1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006c8:	e9 eb fd ff ff       	jmp    8004b8 <vprintfmt+0x43>
	if (lflag >= 2)
  8006cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006d1:	7f 21                	jg     8006f4 <vprintfmt+0x27f>
	else if (lflag)
  8006d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d7:	74 68                	je     800741 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e1:	89 c1                	mov    %eax,%ecx
  8006e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 04             	lea    0x4(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	eb 17                	jmp    80070b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80070b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800717:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80071b:	78 3f                	js     80075c <vprintfmt+0x2e7>
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800722:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800726:	0f 84 71 01 00 00    	je     80089d <vprintfmt+0x428>
				putch('+', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	53                   	push   %ebx
  800730:	6a 2b                	push   $0x2b
  800732:	ff d6                	call   *%esi
  800734:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073c:	e9 5c 01 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800749:	89 c1                	mov    %eax,%ecx
  80074b:	c1 f9 1f             	sar    $0x1f,%ecx
  80074e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	eb af                	jmp    80070b <vprintfmt+0x296>
				putch('-', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	6a 2d                	push   $0x2d
  800762:	ff d6                	call   *%esi
				num = -(long long) num;
  800764:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800767:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80076a:	f7 d8                	neg    %eax
  80076c:	83 d2 00             	adc    $0x0,%edx
  80076f:	f7 da                	neg    %edx
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80077a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077f:	e9 19 01 00 00       	jmp    80089d <vprintfmt+0x428>
	if (lflag >= 2)
  800784:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800788:	7f 29                	jg     8007b3 <vprintfmt+0x33e>
	else if (lflag)
  80078a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078e:	74 44                	je     8007d4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ae:	e9 ea 00 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 50 04             	mov    0x4(%eax),%edx
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8d 40 08             	lea    0x8(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cf:	e9 c9 00 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f2:	e9 a6 00 00 00       	jmp    80089d <vprintfmt+0x428>
			putch('0', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 30                	push   $0x30
  8007fd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800806:	7f 26                	jg     80082e <vprintfmt+0x3b9>
	else if (lflag)
  800808:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080c:	74 3e                	je     80084c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
  800818:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800827:	b8 08 00 00 00       	mov    $0x8,%eax
  80082c:	eb 6f                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8b 50 04             	mov    0x4(%eax),%edx
  800834:	8b 00                	mov    (%eax),%eax
  800836:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800839:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 40 08             	lea    0x8(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800845:	b8 08 00 00 00       	mov    $0x8,%eax
  80084a:	eb 51                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 04             	lea    0x4(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800865:	b8 08 00 00 00       	mov    $0x8,%eax
  80086a:	eb 31                	jmp    80089d <vprintfmt+0x428>
			putch('0', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 30                	push   $0x30
  800872:	ff d6                	call   *%esi
			putch('x', putdat);
  800874:	83 c4 08             	add    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 78                	push   $0x78
  80087a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80088c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 04             	lea    0x4(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800898:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80089d:	83 ec 0c             	sub    $0xc,%esp
  8008a0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008a4:	52                   	push   %edx
  8008a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8008ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8008af:	89 da                	mov    %ebx,%edx
  8008b1:	89 f0                	mov    %esi,%eax
  8008b3:	e8 a4 fa ff ff       	call   80035c <printnum>
			break;
  8008b8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008be:	83 c7 01             	add    $0x1,%edi
  8008c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008c5:	83 f8 25             	cmp    $0x25,%eax
  8008c8:	0f 84 be fb ff ff    	je     80048c <vprintfmt+0x17>
			if (ch == '\0')
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	0f 84 28 01 00 00    	je     8009fe <vprintfmt+0x589>
			putch(ch, putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	53                   	push   %ebx
  8008da:	50                   	push   %eax
  8008db:	ff d6                	call   *%esi
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	eb dc                	jmp    8008be <vprintfmt+0x449>
	if (lflag >= 2)
  8008e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008e6:	7f 26                	jg     80090e <vprintfmt+0x499>
	else if (lflag)
  8008e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ec:	74 41                	je     80092f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 40 04             	lea    0x4(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800907:	b8 10 00 00 00       	mov    $0x10,%eax
  80090c:	eb 8f                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 50 04             	mov    0x4(%eax),%edx
  800914:	8b 00                	mov    (%eax),%eax
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8d 40 08             	lea    0x8(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800925:	b8 10 00 00 00       	mov    $0x10,%eax
  80092a:	e9 6e ff ff ff       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	ba 00 00 00 00       	mov    $0x0,%edx
  800939:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8d 40 04             	lea    0x4(%eax),%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800948:	b8 10 00 00 00       	mov    $0x10,%eax
  80094d:	e9 4b ff ff ff       	jmp    80089d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	83 c0 04             	add    $0x4,%eax
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	85 c0                	test   %eax,%eax
  800962:	74 14                	je     800978 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800964:	8b 13                	mov    (%ebx),%edx
  800966:	83 fa 7f             	cmp    $0x7f,%edx
  800969:	7f 37                	jg     8009a2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80096b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80096d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	e9 43 ff ff ff       	jmp    8008bb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800978:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097d:	bf a1 2e 80 00       	mov    $0x802ea1,%edi
							putch(ch, putdat);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	53                   	push   %ebx
  800986:	50                   	push   %eax
  800987:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800989:	83 c7 01             	add    $0x1,%edi
  80098c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	85 c0                	test   %eax,%eax
  800995:	75 eb                	jne    800982 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800997:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80099a:	89 45 14             	mov    %eax,0x14(%ebp)
  80099d:	e9 19 ff ff ff       	jmp    8008bb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009a2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a9:	bf d9 2e 80 00       	mov    $0x802ed9,%edi
							putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	53                   	push   %ebx
  8009b2:	50                   	push   %eax
  8009b3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b5:	83 c7 01             	add    $0x1,%edi
  8009b8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	75 eb                	jne    8009ae <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c9:	e9 ed fe ff ff       	jmp    8008bb <vprintfmt+0x446>
			putch(ch, putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	53                   	push   %ebx
  8009d2:	6a 25                	push   $0x25
  8009d4:	ff d6                	call   *%esi
			break;
  8009d6:	83 c4 10             	add    $0x10,%esp
  8009d9:	e9 dd fe ff ff       	jmp    8008bb <vprintfmt+0x446>
			putch('%', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	53                   	push   %ebx
  8009e2:	6a 25                	push   $0x25
  8009e4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e6:	83 c4 10             	add    $0x10,%esp
  8009e9:	89 f8                	mov    %edi,%eax
  8009eb:	eb 03                	jmp    8009f0 <vprintfmt+0x57b>
  8009ed:	83 e8 01             	sub    $0x1,%eax
  8009f0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f4:	75 f7                	jne    8009ed <vprintfmt+0x578>
  8009f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f9:	e9 bd fe ff ff       	jmp    8008bb <vprintfmt+0x446>
}
  8009fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a01:	5b                   	pop    %ebx
  800a02:	5e                   	pop    %esi
  800a03:	5f                   	pop    %edi
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 18             	sub    $0x18,%esp
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a15:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a19:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a23:	85 c0                	test   %eax,%eax
  800a25:	74 26                	je     800a4d <vsnprintf+0x47>
  800a27:	85 d2                	test   %edx,%edx
  800a29:	7e 22                	jle    800a4d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a2b:	ff 75 14             	pushl  0x14(%ebp)
  800a2e:	ff 75 10             	pushl  0x10(%ebp)
  800a31:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	68 3b 04 80 00       	push   $0x80043b
  800a3a:	e8 36 fa ff ff       	call   800475 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a48:	83 c4 10             	add    $0x10,%esp
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    
		return -E_INVAL;
  800a4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a52:	eb f7                	jmp    800a4b <vsnprintf+0x45>

00800a54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a5d:	50                   	push   %eax
  800a5e:	ff 75 10             	pushl  0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 9a ff ff ff       	call   800a06 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a7d:	74 05                	je     800a84 <strlen+0x16>
		n++;
  800a7f:	83 c0 01             	add    $0x1,%eax
  800a82:	eb f5                	jmp    800a79 <strlen+0xb>
	return n;
}
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	74 0d                	je     800aa5 <strnlen+0x1f>
  800a98:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a9c:	74 05                	je     800aa3 <strnlen+0x1d>
		n++;
  800a9e:	83 c2 01             	add    $0x1,%edx
  800aa1:	eb f1                	jmp    800a94 <strnlen+0xe>
  800aa3:	89 d0                	mov    %edx,%eax
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aba:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800abd:	83 c2 01             	add    $0x1,%edx
  800ac0:	84 c9                	test   %cl,%cl
  800ac2:	75 f2                	jne    800ab6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 10             	sub    $0x10,%esp
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad1:	53                   	push   %ebx
  800ad2:	e8 97 ff ff ff       	call   800a6e <strlen>
  800ad7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	01 d8                	add    %ebx,%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 c2 ff ff ff       	call   800aa7 <strcpy>
	return dst;
}
  800ae5:	89 d8                	mov    %ebx,%eax
  800ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af7:	89 c6                	mov    %eax,%esi
  800af9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	39 f2                	cmp    %esi,%edx
  800b00:	74 11                	je     800b13 <strncpy+0x27>
		*dst++ = *src;
  800b02:	83 c2 01             	add    $0x1,%edx
  800b05:	0f b6 19             	movzbl (%ecx),%ebx
  800b08:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0b:	80 fb 01             	cmp    $0x1,%bl
  800b0e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b11:	eb eb                	jmp    800afe <strncpy+0x12>
	}
	return ret;
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
  800b1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	8b 55 10             	mov    0x10(%ebp),%edx
  800b25:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b27:	85 d2                	test   %edx,%edx
  800b29:	74 21                	je     800b4c <strlcpy+0x35>
  800b2b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b2f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b31:	39 c2                	cmp    %eax,%edx
  800b33:	74 14                	je     800b49 <strlcpy+0x32>
  800b35:	0f b6 19             	movzbl (%ecx),%ebx
  800b38:	84 db                	test   %bl,%bl
  800b3a:	74 0b                	je     800b47 <strlcpy+0x30>
			*dst++ = *src++;
  800b3c:	83 c1 01             	add    $0x1,%ecx
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b45:	eb ea                	jmp    800b31 <strlcpy+0x1a>
  800b47:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4c:	29 f0                	sub    %esi,%eax
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b5b:	0f b6 01             	movzbl (%ecx),%eax
  800b5e:	84 c0                	test   %al,%al
  800b60:	74 0c                	je     800b6e <strcmp+0x1c>
  800b62:	3a 02                	cmp    (%edx),%al
  800b64:	75 08                	jne    800b6e <strcmp+0x1c>
		p++, q++;
  800b66:	83 c1 01             	add    $0x1,%ecx
  800b69:	83 c2 01             	add    $0x1,%edx
  800b6c:	eb ed                	jmp    800b5b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	0f b6 12             	movzbl (%edx),%edx
  800b74:	29 d0                	sub    %edx,%eax
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	89 c3                	mov    %eax,%ebx
  800b84:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b87:	eb 06                	jmp    800b8f <strncmp+0x17>
		n--, p++, q++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b8f:	39 d8                	cmp    %ebx,%eax
  800b91:	74 16                	je     800ba9 <strncmp+0x31>
  800b93:	0f b6 08             	movzbl (%eax),%ecx
  800b96:	84 c9                	test   %cl,%cl
  800b98:	74 04                	je     800b9e <strncmp+0x26>
  800b9a:	3a 0a                	cmp    (%edx),%cl
  800b9c:	74 eb                	je     800b89 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9e:	0f b6 00             	movzbl (%eax),%eax
  800ba1:	0f b6 12             	movzbl (%edx),%edx
  800ba4:	29 d0                	sub    %edx,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    
		return 0;
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	eb f6                	jmp    800ba6 <strncmp+0x2e>

00800bb0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bba:	0f b6 10             	movzbl (%eax),%edx
  800bbd:	84 d2                	test   %dl,%dl
  800bbf:	74 09                	je     800bca <strchr+0x1a>
		if (*s == c)
  800bc1:	38 ca                	cmp    %cl,%dl
  800bc3:	74 0a                	je     800bcf <strchr+0x1f>
	for (; *s; s++)
  800bc5:	83 c0 01             	add    $0x1,%eax
  800bc8:	eb f0                	jmp    800bba <strchr+0xa>
			return (char *) s;
	return 0;
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bde:	38 ca                	cmp    %cl,%dl
  800be0:	74 09                	je     800beb <strfind+0x1a>
  800be2:	84 d2                	test   %dl,%dl
  800be4:	74 05                	je     800beb <strfind+0x1a>
	for (; *s; s++)
  800be6:	83 c0 01             	add    $0x1,%eax
  800be9:	eb f0                	jmp    800bdb <strfind+0xa>
			break;
	return (char *) s;
}
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf9:	85 c9                	test   %ecx,%ecx
  800bfb:	74 31                	je     800c2e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfd:	89 f8                	mov    %edi,%eax
  800bff:	09 c8                	or     %ecx,%eax
  800c01:	a8 03                	test   $0x3,%al
  800c03:	75 23                	jne    800c28 <memset+0x3b>
		c &= 0xFF;
  800c05:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	c1 e3 08             	shl    $0x8,%ebx
  800c0e:	89 d0                	mov    %edx,%eax
  800c10:	c1 e0 18             	shl    $0x18,%eax
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	c1 e6 10             	shl    $0x10,%esi
  800c18:	09 f0                	or     %esi,%eax
  800c1a:	09 c2                	or     %eax,%edx
  800c1c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c21:	89 d0                	mov    %edx,%eax
  800c23:	fc                   	cld    
  800c24:	f3 ab                	rep stos %eax,%es:(%edi)
  800c26:	eb 06                	jmp    800c2e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	fc                   	cld    
  800c2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2e:	89 f8                	mov    %edi,%eax
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c43:	39 c6                	cmp    %eax,%esi
  800c45:	73 32                	jae    800c79 <memmove+0x44>
  800c47:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c4a:	39 c2                	cmp    %eax,%edx
  800c4c:	76 2b                	jbe    800c79 <memmove+0x44>
		s += n;
		d += n;
  800c4e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c51:	89 fe                	mov    %edi,%esi
  800c53:	09 ce                	or     %ecx,%esi
  800c55:	09 d6                	or     %edx,%esi
  800c57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5d:	75 0e                	jne    800c6d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c5f:	83 ef 04             	sub    $0x4,%edi
  800c62:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c68:	fd                   	std    
  800c69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6b:	eb 09                	jmp    800c76 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6d:	83 ef 01             	sub    $0x1,%edi
  800c70:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c73:	fd                   	std    
  800c74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c76:	fc                   	cld    
  800c77:	eb 1a                	jmp    800c93 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	09 ca                	or     %ecx,%edx
  800c7d:	09 f2                	or     %esi,%edx
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	75 0a                	jne    800c8e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c87:	89 c7                	mov    %eax,%edi
  800c89:	fc                   	cld    
  800c8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8c:	eb 05                	jmp    800c93 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c8e:	89 c7                	mov    %eax,%edi
  800c90:	fc                   	cld    
  800c91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c9d:	ff 75 10             	pushl  0x10(%ebp)
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	e8 8a ff ff ff       	call   800c35 <memmove>
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbd:	39 f0                	cmp    %esi,%eax
  800cbf:	74 1c                	je     800cdd <memcmp+0x30>
		if (*s1 != *s2)
  800cc1:	0f b6 08             	movzbl (%eax),%ecx
  800cc4:	0f b6 1a             	movzbl (%edx),%ebx
  800cc7:	38 d9                	cmp    %bl,%cl
  800cc9:	75 08                	jne    800cd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	eb ea                	jmp    800cbd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd3:	0f b6 c1             	movzbl %cl,%eax
  800cd6:	0f b6 db             	movzbl %bl,%ebx
  800cd9:	29 d8                	sub    %ebx,%eax
  800cdb:	eb 05                	jmp    800ce2 <memcmp+0x35>
	}

	return 0;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf4:	39 d0                	cmp    %edx,%eax
  800cf6:	73 09                	jae    800d01 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf8:	38 08                	cmp    %cl,(%eax)
  800cfa:	74 05                	je     800d01 <memfind+0x1b>
	for (; s < ends; s++)
  800cfc:	83 c0 01             	add    $0x1,%eax
  800cff:	eb f3                	jmp    800cf4 <memfind+0xe>
			break;
	return (void *) s;
}
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0f:	eb 03                	jmp    800d14 <strtol+0x11>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d14:	0f b6 01             	movzbl (%ecx),%eax
  800d17:	3c 20                	cmp    $0x20,%al
  800d19:	74 f6                	je     800d11 <strtol+0xe>
  800d1b:	3c 09                	cmp    $0x9,%al
  800d1d:	74 f2                	je     800d11 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d1f:	3c 2b                	cmp    $0x2b,%al
  800d21:	74 2a                	je     800d4d <strtol+0x4a>
	int neg = 0;
  800d23:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d28:	3c 2d                	cmp    $0x2d,%al
  800d2a:	74 2b                	je     800d57 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d32:	75 0f                	jne    800d43 <strtol+0x40>
  800d34:	80 39 30             	cmpb   $0x30,(%ecx)
  800d37:	74 28                	je     800d61 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d40:	0f 44 d8             	cmove  %eax,%ebx
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d4b:	eb 50                	jmp    800d9d <strtol+0x9a>
		s++;
  800d4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
  800d55:	eb d5                	jmp    800d2c <strtol+0x29>
		s++, neg = 1;
  800d57:	83 c1 01             	add    $0x1,%ecx
  800d5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5f:	eb cb                	jmp    800d2c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d65:	74 0e                	je     800d75 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d67:	85 db                	test   %ebx,%ebx
  800d69:	75 d8                	jne    800d43 <strtol+0x40>
		s++, base = 8;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d73:	eb ce                	jmp    800d43 <strtol+0x40>
		s += 2, base = 16;
  800d75:	83 c1 02             	add    $0x2,%ecx
  800d78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7d:	eb c4                	jmp    800d43 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d82:	89 f3                	mov    %esi,%ebx
  800d84:	80 fb 19             	cmp    $0x19,%bl
  800d87:	77 29                	ja     800db2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d89:	0f be d2             	movsbl %dl,%edx
  800d8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d92:	7d 30                	jge    800dc4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d94:	83 c1 01             	add    $0x1,%ecx
  800d97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d9d:	0f b6 11             	movzbl (%ecx),%edx
  800da0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da3:	89 f3                	mov    %esi,%ebx
  800da5:	80 fb 09             	cmp    $0x9,%bl
  800da8:	77 d5                	ja     800d7f <strtol+0x7c>
			dig = *s - '0';
  800daa:	0f be d2             	movsbl %dl,%edx
  800dad:	83 ea 30             	sub    $0x30,%edx
  800db0:	eb dd                	jmp    800d8f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db5:	89 f3                	mov    %esi,%ebx
  800db7:	80 fb 19             	cmp    $0x19,%bl
  800dba:	77 08                	ja     800dc4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dbc:	0f be d2             	movsbl %dl,%edx
  800dbf:	83 ea 37             	sub    $0x37,%edx
  800dc2:	eb cb                	jmp    800d8f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc8:	74 05                	je     800dcf <strtol+0xcc>
		*endptr = (char *) s;
  800dca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dcf:	89 c2                	mov    %eax,%edx
  800dd1:	f7 da                	neg    %edx
  800dd3:	85 ff                	test   %edi,%edi
  800dd5:	0f 45 c2             	cmovne %edx,%eax
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	89 c7                	mov    %eax,%edi
  800df2:	89 c6                	mov    %eax,%esi
  800df4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_cgetc>:

int
sys_cgetc(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0b:	89 d1                	mov    %edx,%ecx
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	89 d7                	mov    %edx,%edi
  800e11:	89 d6                	mov    %edx,%esi
  800e13:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	89 cb                	mov    %ecx,%ebx
  800e32:	89 cf                	mov    %ecx,%edi
  800e34:	89 ce                	mov    %ecx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800e48:	6a 03                	push   $0x3
  800e4a:	68 e8 30 80 00       	push   $0x8030e8
  800e4f:	6a 43                	push   $0x43
  800e51:	68 05 31 80 00       	push   $0x803105
  800e56:	e8 76 1a 00 00       	call   8028d1 <_panic>

00800e5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e61:	ba 00 00 00 00       	mov    $0x0,%edx
  800e66:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6b:	89 d1                	mov    %edx,%ecx
  800e6d:	89 d3                	mov    %edx,%ebx
  800e6f:	89 d7                	mov    %edx,%edi
  800e71:	89 d6                	mov    %edx,%esi
  800e73:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_yield>:

void
sys_yield(void)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	ba 00 00 00 00       	mov    $0x0,%edx
  800e85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8a:	89 d1                	mov    %edx,%ecx
  800e8c:	89 d3                	mov    %edx,%ebx
  800e8e:	89 d7                	mov    %edx,%edi
  800e90:	89 d6                	mov    %edx,%esi
  800e92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	be 00 00 00 00       	mov    $0x0,%esi
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb5:	89 f7                	mov    %esi,%edi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 04                	push   $0x4
  800ecb:	68 e8 30 80 00       	push   $0x8030e8
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 05 31 80 00       	push   $0x803105
  800ed7:	e8 f5 19 00 00       	call   8028d1 <_panic>

00800edc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 05                	push   $0x5
  800f0d:	68 e8 30 80 00       	push   $0x8030e8
  800f12:	6a 43                	push   $0x43
  800f14:	68 05 31 80 00       	push   $0x803105
  800f19:	e8 b3 19 00 00       	call   8028d1 <_panic>

00800f1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 06 00 00 00       	mov    $0x6,%eax
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	89 de                	mov    %ebx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 06                	push   $0x6
  800f4f:	68 e8 30 80 00       	push   $0x8030e8
  800f54:	6a 43                	push   $0x43
  800f56:	68 05 31 80 00       	push   $0x803105
  800f5b:	e8 71 19 00 00       	call   8028d1 <_panic>

00800f60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 08 00 00 00       	mov    $0x8,%eax
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 08                	push   $0x8
  800f91:	68 e8 30 80 00       	push   $0x8030e8
  800f96:	6a 43                	push   $0x43
  800f98:	68 05 31 80 00       	push   $0x803105
  800f9d:	e8 2f 19 00 00       	call   8028d1 <_panic>

00800fa2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 09                	push   $0x9
  800fd3:	68 e8 30 80 00       	push   $0x8030e8
  800fd8:	6a 43                	push   $0x43
  800fda:	68 05 31 80 00       	push   $0x803105
  800fdf:	e8 ed 18 00 00       	call   8028d1 <_panic>

00800fe4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 0a                	push   $0xa
  801015:	68 e8 30 80 00       	push   $0x8030e8
  80101a:	6a 43                	push   $0x43
  80101c:	68 05 31 80 00       	push   $0x803105
  801021:	e8 ab 18 00 00       	call   8028d1 <_panic>

00801026 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 0c 00 00 00       	mov    $0xc,%eax
  801037:	be 00 00 00 00       	mov    $0x0,%esi
  80103c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801042:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801052:	b9 00 00 00 00       	mov    $0x0,%ecx
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105f:	89 cb                	mov    %ecx,%ebx
  801061:	89 cf                	mov    %ecx,%edi
  801063:	89 ce                	mov    %ecx,%esi
  801065:	cd 30                	int    $0x30
	if(check && ret > 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	7f 08                	jg     801073 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	50                   	push   %eax
  801077:	6a 0d                	push   $0xd
  801079:	68 e8 30 80 00       	push   $0x8030e8
  80107e:	6a 43                	push   $0x43
  801080:	68 05 31 80 00       	push   $0x803105
  801085:	e8 47 18 00 00       	call   8028d1 <_panic>

0080108a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5f                   	pop    %edi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010be:	89 cb                	mov    %ecx,%ebx
  8010c0:	89 cf                	mov    %ecx,%edi
  8010c2:	89 ce                	mov    %ecx,%esi
  8010c4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fb:	b8 11 00 00 00       	mov    $0x11,%eax
  801100:	89 df                	mov    %ebx,%edi
  801102:	89 de                	mov    %ebx,%esi
  801104:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5f                   	pop    %edi
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
	asm volatile("int %1\n"
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
  801116:	8b 55 08             	mov    0x8(%ebp),%edx
  801119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111c:	b8 12 00 00 00       	mov    $0x12,%eax
  801121:	89 df                	mov    %ebx,%edi
  801123:	89 de                	mov    %ebx,%esi
  801125:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801135:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	b8 13 00 00 00       	mov    $0x13,%eax
  801145:	89 df                	mov    %ebx,%edi
  801147:	89 de                	mov    %ebx,%esi
  801149:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	7f 08                	jg     801157 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801152:	5b                   	pop    %ebx
  801153:	5e                   	pop    %esi
  801154:	5f                   	pop    %edi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	50                   	push   %eax
  80115b:	6a 13                	push   $0x13
  80115d:	68 e8 30 80 00       	push   $0x8030e8
  801162:	6a 43                	push   $0x43
  801164:	68 05 31 80 00       	push   $0x803105
  801169:	e8 63 17 00 00       	call   8028d1 <_panic>

0080116e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
	asm volatile("int %1\n"
  801174:	b9 00 00 00 00       	mov    $0x0,%ecx
  801179:	8b 55 08             	mov    0x8(%ebp),%edx
  80117c:	b8 14 00 00 00       	mov    $0x14,%eax
  801181:	89 cb                	mov    %ecx,%ebx
  801183:	89 cf                	mov    %ecx,%edi
  801185:	89 ce                	mov    %ecx,%esi
  801187:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	53                   	push   %ebx
  801192:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801195:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80119c:	f6 c5 04             	test   $0x4,%ch
  80119f:	75 45                	jne    8011e6 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011a1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011a8:	83 e1 07             	and    $0x7,%ecx
  8011ab:	83 f9 07             	cmp    $0x7,%ecx
  8011ae:	74 6f                	je     80121f <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011b0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b7:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011bd:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011c3:	0f 84 b6 00 00 00    	je     80127f <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011c9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011d0:	83 e1 05             	and    $0x5,%ecx
  8011d3:	83 f9 05             	cmp    $0x5,%ecx
  8011d6:	0f 84 d7 00 00 00    	je     8012b3 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011e6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ed:	c1 e2 0c             	shl    $0xc,%edx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011f9:	51                   	push   %ecx
  8011fa:	52                   	push   %edx
  8011fb:	50                   	push   %eax
  8011fc:	52                   	push   %edx
  8011fd:	6a 00                	push   $0x0
  8011ff:	e8 d8 fc ff ff       	call   800edc <sys_page_map>
		if(r < 0)
  801204:	83 c4 20             	add    $0x20,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	79 d1                	jns    8011dc <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 13 31 80 00       	push   $0x803113
  801213:	6a 54                	push   $0x54
  801215:	68 29 31 80 00       	push   $0x803129
  80121a:	e8 b2 16 00 00       	call   8028d1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80121f:	89 d3                	mov    %edx,%ebx
  801221:	c1 e3 0c             	shl    $0xc,%ebx
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	68 05 08 00 00       	push   $0x805
  80122c:	53                   	push   %ebx
  80122d:	50                   	push   %eax
  80122e:	53                   	push   %ebx
  80122f:	6a 00                	push   $0x0
  801231:	e8 a6 fc ff ff       	call   800edc <sys_page_map>
		if(r < 0)
  801236:	83 c4 20             	add    $0x20,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 2e                	js     80126b <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	68 05 08 00 00       	push   $0x805
  801245:	53                   	push   %ebx
  801246:	6a 00                	push   $0x0
  801248:	53                   	push   %ebx
  801249:	6a 00                	push   $0x0
  80124b:	e8 8c fc ff ff       	call   800edc <sys_page_map>
		if(r < 0)
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	79 85                	jns    8011dc <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 13 31 80 00       	push   $0x803113
  80125f:	6a 5f                	push   $0x5f
  801261:	68 29 31 80 00       	push   $0x803129
  801266:	e8 66 16 00 00       	call   8028d1 <_panic>
			panic("sys_page_map() panic\n");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 13 31 80 00       	push   $0x803113
  801273:	6a 5b                	push   $0x5b
  801275:	68 29 31 80 00       	push   $0x803129
  80127a:	e8 52 16 00 00       	call   8028d1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80127f:	c1 e2 0c             	shl    $0xc,%edx
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	68 05 08 00 00       	push   $0x805
  80128a:	52                   	push   %edx
  80128b:	50                   	push   %eax
  80128c:	52                   	push   %edx
  80128d:	6a 00                	push   $0x0
  80128f:	e8 48 fc ff ff       	call   800edc <sys_page_map>
		if(r < 0)
  801294:	83 c4 20             	add    $0x20,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	0f 89 3d ff ff ff    	jns    8011dc <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80129f:	83 ec 04             	sub    $0x4,%esp
  8012a2:	68 13 31 80 00       	push   $0x803113
  8012a7:	6a 66                	push   $0x66
  8012a9:	68 29 31 80 00       	push   $0x803129
  8012ae:	e8 1e 16 00 00       	call   8028d1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012b3:	c1 e2 0c             	shl    $0xc,%edx
  8012b6:	83 ec 0c             	sub    $0xc,%esp
  8012b9:	6a 05                	push   $0x5
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	52                   	push   %edx
  8012be:	6a 00                	push   $0x0
  8012c0:	e8 17 fc ff ff       	call   800edc <sys_page_map>
		if(r < 0)
  8012c5:	83 c4 20             	add    $0x20,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	0f 89 0c ff ff ff    	jns    8011dc <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 13 31 80 00       	push   $0x803113
  8012d8:	6a 6d                	push   $0x6d
  8012da:	68 29 31 80 00       	push   $0x803129
  8012df:	e8 ed 15 00 00       	call   8028d1 <_panic>

008012e4 <pgfault>:
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012ee:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012f0:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012f4:	0f 84 99 00 00 00    	je     801393 <pgfault+0xaf>
  8012fa:	89 c2                	mov    %eax,%edx
  8012fc:	c1 ea 16             	shr    $0x16,%edx
  8012ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801306:	f6 c2 01             	test   $0x1,%dl
  801309:	0f 84 84 00 00 00    	je     801393 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80130f:	89 c2                	mov    %eax,%edx
  801311:	c1 ea 0c             	shr    $0xc,%edx
  801314:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131b:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801321:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801327:	75 6a                	jne    801393 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801329:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132e:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	6a 07                	push   $0x7
  801335:	68 00 f0 7f 00       	push   $0x7ff000
  80133a:	6a 00                	push   $0x0
  80133c:	e8 58 fb ff ff       	call   800e99 <sys_page_alloc>
	if(ret < 0)
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 5f                	js     8013a7 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	68 00 10 00 00       	push   $0x1000
  801350:	53                   	push   %ebx
  801351:	68 00 f0 7f 00       	push   $0x7ff000
  801356:	e8 3c f9 ff ff       	call   800c97 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80135b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801362:	53                   	push   %ebx
  801363:	6a 00                	push   $0x0
  801365:	68 00 f0 7f 00       	push   $0x7ff000
  80136a:	6a 00                	push   $0x0
  80136c:	e8 6b fb ff ff       	call   800edc <sys_page_map>
	if(ret < 0)
  801371:	83 c4 20             	add    $0x20,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 43                	js     8013bb <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	68 00 f0 7f 00       	push   $0x7ff000
  801380:	6a 00                	push   $0x0
  801382:	e8 97 fb ff ff       	call   800f1e <sys_page_unmap>
	if(ret < 0)
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 41                	js     8013cf <pgfault+0xeb>
}
  80138e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801391:	c9                   	leave  
  801392:	c3                   	ret    
		panic("panic at pgfault()\n");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 34 31 80 00       	push   $0x803134
  80139b:	6a 26                	push   $0x26
  80139d:	68 29 31 80 00       	push   $0x803129
  8013a2:	e8 2a 15 00 00       	call   8028d1 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	68 48 31 80 00       	push   $0x803148
  8013af:	6a 31                	push   $0x31
  8013b1:	68 29 31 80 00       	push   $0x803129
  8013b6:	e8 16 15 00 00       	call   8028d1 <_panic>
		panic("panic in sys_page_map()\n");
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 63 31 80 00       	push   $0x803163
  8013c3:	6a 36                	push   $0x36
  8013c5:	68 29 31 80 00       	push   $0x803129
  8013ca:	e8 02 15 00 00       	call   8028d1 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	68 7c 31 80 00       	push   $0x80317c
  8013d7:	6a 39                	push   $0x39
  8013d9:	68 29 31 80 00       	push   $0x803129
  8013de:	e8 ee 14 00 00       	call   8028d1 <_panic>

008013e3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013ec:	68 e4 12 80 00       	push   $0x8012e4
  8013f1:	e8 3c 15 00 00       	call   802932 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013f6:	b8 07 00 00 00       	mov    $0x7,%eax
  8013fb:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 2a                	js     80142e <fork+0x4b>
  801404:	89 c6                	mov    %eax,%esi
  801406:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801408:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80140d:	75 4b                	jne    80145a <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80140f:	e8 47 fa ff ff       	call   800e5b <sys_getenvid>
  801414:	25 ff 03 00 00       	and    $0x3ff,%eax
  801419:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80141f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801424:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801429:	e9 90 00 00 00       	jmp    8014be <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 98 31 80 00       	push   $0x803198
  801436:	68 8c 00 00 00       	push   $0x8c
  80143b:	68 29 31 80 00       	push   $0x803129
  801440:	e8 8c 14 00 00       	call   8028d1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801445:	89 f8                	mov    %edi,%eax
  801447:	e8 42 fd ff ff       	call   80118e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80144c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801452:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801458:	74 26                	je     801480 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	c1 e8 16             	shr    $0x16,%eax
  80145f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801466:	a8 01                	test   $0x1,%al
  801468:	74 e2                	je     80144c <fork+0x69>
  80146a:	89 da                	mov    %ebx,%edx
  80146c:	c1 ea 0c             	shr    $0xc,%edx
  80146f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801476:	83 e0 05             	and    $0x5,%eax
  801479:	83 f8 05             	cmp    $0x5,%eax
  80147c:	75 ce                	jne    80144c <fork+0x69>
  80147e:	eb c5                	jmp    801445 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	6a 07                	push   $0x7
  801485:	68 00 f0 bf ee       	push   $0xeebff000
  80148a:	56                   	push   %esi
  80148b:	e8 09 fa ff ff       	call   800e99 <sys_page_alloc>
	if(ret < 0)
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 31                	js     8014c8 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	68 a1 29 80 00       	push   $0x8029a1
  80149f:	56                   	push   %esi
  8014a0:	e8 3f fb ff ff       	call   800fe4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 33                	js     8014df <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	6a 02                	push   $0x2
  8014b1:	56                   	push   %esi
  8014b2:	e8 a9 fa ff ff       	call   800f60 <sys_env_set_status>
	if(ret < 0)
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 38                	js     8014f6 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014be:	89 f0                	mov    %esi,%eax
  8014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c3:	5b                   	pop    %ebx
  8014c4:	5e                   	pop    %esi
  8014c5:	5f                   	pop    %edi
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	68 48 31 80 00       	push   $0x803148
  8014d0:	68 98 00 00 00       	push   $0x98
  8014d5:	68 29 31 80 00       	push   $0x803129
  8014da:	e8 f2 13 00 00       	call   8028d1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 bc 31 80 00       	push   $0x8031bc
  8014e7:	68 9b 00 00 00       	push   $0x9b
  8014ec:	68 29 31 80 00       	push   $0x803129
  8014f1:	e8 db 13 00 00       	call   8028d1 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 e4 31 80 00       	push   $0x8031e4
  8014fe:	68 9e 00 00 00       	push   $0x9e
  801503:	68 29 31 80 00       	push   $0x803129
  801508:	e8 c4 13 00 00       	call   8028d1 <_panic>

0080150d <sfork>:

// Challenge!
int
sfork(void)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	57                   	push   %edi
  801511:	56                   	push   %esi
  801512:	53                   	push   %ebx
  801513:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801516:	68 e4 12 80 00       	push   $0x8012e4
  80151b:	e8 12 14 00 00       	call   802932 <set_pgfault_handler>
  801520:	b8 07 00 00 00       	mov    $0x7,%eax
  801525:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 2a                	js     801558 <sfork+0x4b>
  80152e:	89 c7                	mov    %eax,%edi
  801530:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801532:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801537:	75 58                	jne    801591 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801539:	e8 1d f9 ff ff       	call   800e5b <sys_getenvid>
  80153e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801543:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801549:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80154e:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801553:	e9 d4 00 00 00       	jmp    80162c <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	68 98 31 80 00       	push   $0x803198
  801560:	68 af 00 00 00       	push   $0xaf
  801565:	68 29 31 80 00       	push   $0x803129
  80156a:	e8 62 13 00 00       	call   8028d1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80156f:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801574:	89 f0                	mov    %esi,%eax
  801576:	e8 13 fc ff ff       	call   80118e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80157b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801581:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801587:	77 65                	ja     8015ee <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801589:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80158f:	74 de                	je     80156f <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801591:	89 d8                	mov    %ebx,%eax
  801593:	c1 e8 16             	shr    $0x16,%eax
  801596:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80159d:	a8 01                	test   $0x1,%al
  80159f:	74 da                	je     80157b <sfork+0x6e>
  8015a1:	89 da                	mov    %ebx,%edx
  8015a3:	c1 ea 0c             	shr    $0xc,%edx
  8015a6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015ad:	83 e0 05             	and    $0x5,%eax
  8015b0:	83 f8 05             	cmp    $0x5,%eax
  8015b3:	75 c6                	jne    80157b <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015b5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015bc:	c1 e2 0c             	shl    $0xc,%edx
  8015bf:	83 ec 0c             	sub    $0xc,%esp
  8015c2:	83 e0 07             	and    $0x7,%eax
  8015c5:	50                   	push   %eax
  8015c6:	52                   	push   %edx
  8015c7:	56                   	push   %esi
  8015c8:	52                   	push   %edx
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 0c f9 ff ff       	call   800edc <sys_page_map>
  8015d0:	83 c4 20             	add    $0x20,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 a4                	je     80157b <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	68 13 31 80 00       	push   $0x803113
  8015df:	68 ba 00 00 00       	push   $0xba
  8015e4:	68 29 31 80 00       	push   $0x803129
  8015e9:	e8 e3 12 00 00       	call   8028d1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	6a 07                	push   $0x7
  8015f3:	68 00 f0 bf ee       	push   $0xeebff000
  8015f8:	57                   	push   %edi
  8015f9:	e8 9b f8 ff ff       	call   800e99 <sys_page_alloc>
	if(ret < 0)
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 31                	js     801636 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	68 a1 29 80 00       	push   $0x8029a1
  80160d:	57                   	push   %edi
  80160e:	e8 d1 f9 ff ff       	call   800fe4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 33                	js     80164d <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	6a 02                	push   $0x2
  80161f:	57                   	push   %edi
  801620:	e8 3b f9 ff ff       	call   800f60 <sys_env_set_status>
	if(ret < 0)
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 38                	js     801664 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80162c:	89 f8                	mov    %edi,%eax
  80162e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5f                   	pop    %edi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 48 31 80 00       	push   $0x803148
  80163e:	68 c0 00 00 00       	push   $0xc0
  801643:	68 29 31 80 00       	push   $0x803129
  801648:	e8 84 12 00 00       	call   8028d1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	68 bc 31 80 00       	push   $0x8031bc
  801655:	68 c3 00 00 00       	push   $0xc3
  80165a:	68 29 31 80 00       	push   $0x803129
  80165f:	e8 6d 12 00 00       	call   8028d1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	68 e4 31 80 00       	push   $0x8031e4
  80166c:	68 c6 00 00 00       	push   $0xc6
  801671:	68 29 31 80 00       	push   $0x803129
  801676:	e8 56 12 00 00       	call   8028d1 <_panic>

0080167b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
  801680:	8b 75 08             	mov    0x8(%ebp),%esi
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801689:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80168b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801690:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	50                   	push   %eax
  801697:	e8 ad f9 ff ff       	call   801049 <sys_ipc_recv>
	if(ret < 0){
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 2b                	js     8016ce <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016a3:	85 f6                	test   %esi,%esi
  8016a5:	74 0a                	je     8016b1 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8016a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ac:	8b 40 78             	mov    0x78(%eax),%eax
  8016af:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016b1:	85 db                	test   %ebx,%ebx
  8016b3:	74 0a                	je     8016bf <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8016b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ba:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016bd:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8016bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8016c4:	8b 40 74             	mov    0x74(%eax),%eax
}
  8016c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
		if(from_env_store)
  8016ce:	85 f6                	test   %esi,%esi
  8016d0:	74 06                	je     8016d8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016d8:	85 db                	test   %ebx,%ebx
  8016da:	74 eb                	je     8016c7 <ipc_recv+0x4c>
			*perm_store = 0;
  8016dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016e2:	eb e3                	jmp    8016c7 <ipc_recv+0x4c>

008016e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	57                   	push   %edi
  8016e8:	56                   	push   %esi
  8016e9:	53                   	push   %ebx
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016f6:	85 db                	test   %ebx,%ebx
  8016f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016fd:	0f 44 d8             	cmove  %eax,%ebx
  801700:	eb 05                	jmp    801707 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801702:	e8 73 f7 ff ff       	call   800e7a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801707:	ff 75 14             	pushl  0x14(%ebp)
  80170a:	53                   	push   %ebx
  80170b:	56                   	push   %esi
  80170c:	57                   	push   %edi
  80170d:	e8 14 f9 ff ff       	call   801026 <sys_ipc_try_send>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	85 c0                	test   %eax,%eax
  801717:	74 1b                	je     801734 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801719:	79 e7                	jns    801702 <ipc_send+0x1e>
  80171b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80171e:	74 e2                	je     801702 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	68 03 32 80 00       	push   $0x803203
  801728:	6a 46                	push   $0x46
  80172a:	68 18 32 80 00       	push   $0x803218
  80172f:	e8 9d 11 00 00       	call   8028d1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801734:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5f                   	pop    %edi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801747:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80174d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801753:	8b 52 50             	mov    0x50(%edx),%edx
  801756:	39 ca                	cmp    %ecx,%edx
  801758:	74 11                	je     80176b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80175a:	83 c0 01             	add    $0x1,%eax
  80175d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801762:	75 e3                	jne    801747 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	eb 0e                	jmp    801779 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80176b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801771:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801776:	8b 40 48             	mov    0x48(%eax),%eax
}
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	05 00 00 00 30       	add    $0x30000000,%eax
  801786:	c1 e8 0c             	shr    $0xc,%eax
}
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    

0080178b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801796:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80179b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017aa:	89 c2                	mov    %eax,%edx
  8017ac:	c1 ea 16             	shr    $0x16,%edx
  8017af:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017b6:	f6 c2 01             	test   $0x1,%dl
  8017b9:	74 2d                	je     8017e8 <fd_alloc+0x46>
  8017bb:	89 c2                	mov    %eax,%edx
  8017bd:	c1 ea 0c             	shr    $0xc,%edx
  8017c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c7:	f6 c2 01             	test   $0x1,%dl
  8017ca:	74 1c                	je     8017e8 <fd_alloc+0x46>
  8017cc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017d1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017d6:	75 d2                	jne    8017aa <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017e1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017e6:	eb 0a                	jmp    8017f2 <fd_alloc+0x50>
			*fd_store = fd;
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    

008017f4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017fa:	83 f8 1f             	cmp    $0x1f,%eax
  8017fd:	77 30                	ja     80182f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017ff:	c1 e0 0c             	shl    $0xc,%eax
  801802:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801807:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80180d:	f6 c2 01             	test   $0x1,%dl
  801810:	74 24                	je     801836 <fd_lookup+0x42>
  801812:	89 c2                	mov    %eax,%edx
  801814:	c1 ea 0c             	shr    $0xc,%edx
  801817:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80181e:	f6 c2 01             	test   $0x1,%dl
  801821:	74 1a                	je     80183d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	89 02                	mov    %eax,(%edx)
	return 0;
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    
		return -E_INVAL;
  80182f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801834:	eb f7                	jmp    80182d <fd_lookup+0x39>
		return -E_INVAL;
  801836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183b:	eb f0                	jmp    80182d <fd_lookup+0x39>
  80183d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801842:	eb e9                	jmp    80182d <fd_lookup+0x39>

00801844 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801857:	39 08                	cmp    %ecx,(%eax)
  801859:	74 38                	je     801893 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80185b:	83 c2 01             	add    $0x1,%edx
  80185e:	8b 04 95 a0 32 80 00 	mov    0x8032a0(,%edx,4),%eax
  801865:	85 c0                	test   %eax,%eax
  801867:	75 ee                	jne    801857 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801869:	a1 08 50 80 00       	mov    0x805008,%eax
  80186e:	8b 40 48             	mov    0x48(%eax),%eax
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	51                   	push   %ecx
  801875:	50                   	push   %eax
  801876:	68 24 32 80 00       	push   $0x803224
  80187b:	e8 c8 ea ff ff       	call   800348 <cprintf>
	*dev = 0;
  801880:	8b 45 0c             	mov    0xc(%ebp),%eax
  801883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    
			*dev = devtab[i];
  801893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801896:	89 01                	mov    %eax,(%ecx)
			return 0;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	eb f2                	jmp    801891 <dev_lookup+0x4d>

0080189f <fd_close>:
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	57                   	push   %edi
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 24             	sub    $0x24,%esp
  8018a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018b1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018b2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018b8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018bb:	50                   	push   %eax
  8018bc:	e8 33 ff ff ff       	call   8017f4 <fd_lookup>
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 05                	js     8018cf <fd_close+0x30>
	    || fd != fd2)
  8018ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018cd:	74 16                	je     8018e5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018cf:	89 f8                	mov    %edi,%eax
  8018d1:	84 c0                	test   %al,%al
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	0f 44 d8             	cmove  %eax,%ebx
}
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5f                   	pop    %edi
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	ff 36                	pushl  (%esi)
  8018ee:	e8 51 ff ff ff       	call   801844 <dev_lookup>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 1a                	js     801916 <fd_close+0x77>
		if (dev->dev_close)
  8018fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ff:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801902:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801907:	85 c0                	test   %eax,%eax
  801909:	74 0b                	je     801916 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	56                   	push   %esi
  80190f:	ff d0                	call   *%eax
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	56                   	push   %esi
  80191a:	6a 00                	push   $0x0
  80191c:	e8 fd f5 ff ff       	call   800f1e <sys_page_unmap>
	return r;
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	eb b5                	jmp    8018db <fd_close+0x3c>

00801926 <close>:

int
close(int fdnum)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80192c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192f:	50                   	push   %eax
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	e8 bc fe ff ff       	call   8017f4 <fd_lookup>
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	79 02                	jns    801941 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    
		return fd_close(fd, 1);
  801941:	83 ec 08             	sub    $0x8,%esp
  801944:	6a 01                	push   $0x1
  801946:	ff 75 f4             	pushl  -0xc(%ebp)
  801949:	e8 51 ff ff ff       	call   80189f <fd_close>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	eb ec                	jmp    80193f <close+0x19>

00801953 <close_all>:

void
close_all(void)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	53                   	push   %ebx
  801957:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80195a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	53                   	push   %ebx
  801963:	e8 be ff ff ff       	call   801926 <close>
	for (i = 0; i < MAXFD; i++)
  801968:	83 c3 01             	add    $0x1,%ebx
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	83 fb 20             	cmp    $0x20,%ebx
  801971:	75 ec                	jne    80195f <close_all+0xc>
}
  801973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	57                   	push   %edi
  80197c:	56                   	push   %esi
  80197d:	53                   	push   %ebx
  80197e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801981:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	e8 67 fe ff ff       	call   8017f4 <fd_lookup>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	0f 88 81 00 00 00    	js     801a1b <dup+0xa3>
		return r;
	close(newfdnum);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 81 ff ff ff       	call   801926 <close>

	newfd = INDEX2FD(newfdnum);
  8019a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019a8:	c1 e6 0c             	shl    $0xc,%esi
  8019ab:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019b1:	83 c4 04             	add    $0x4,%esp
  8019b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019b7:	e8 cf fd ff ff       	call   80178b <fd2data>
  8019bc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019be:	89 34 24             	mov    %esi,(%esp)
  8019c1:	e8 c5 fd ff ff       	call   80178b <fd2data>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019cb:	89 d8                	mov    %ebx,%eax
  8019cd:	c1 e8 16             	shr    $0x16,%eax
  8019d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019d7:	a8 01                	test   $0x1,%al
  8019d9:	74 11                	je     8019ec <dup+0x74>
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	c1 e8 0c             	shr    $0xc,%eax
  8019e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019e7:	f6 c2 01             	test   $0x1,%dl
  8019ea:	75 39                	jne    801a25 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ef:	89 d0                	mov    %edx,%eax
  8019f1:	c1 e8 0c             	shr    $0xc,%eax
  8019f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801a03:	50                   	push   %eax
  801a04:	56                   	push   %esi
  801a05:	6a 00                	push   $0x0
  801a07:	52                   	push   %edx
  801a08:	6a 00                	push   $0x0
  801a0a:	e8 cd f4 ff ff       	call   800edc <sys_page_map>
  801a0f:	89 c3                	mov    %eax,%ebx
  801a11:	83 c4 20             	add    $0x20,%esp
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 31                	js     801a49 <dup+0xd1>
		goto err;

	return newfdnum;
  801a18:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5f                   	pop    %edi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a25:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	25 07 0e 00 00       	and    $0xe07,%eax
  801a34:	50                   	push   %eax
  801a35:	57                   	push   %edi
  801a36:	6a 00                	push   $0x0
  801a38:	53                   	push   %ebx
  801a39:	6a 00                	push   $0x0
  801a3b:	e8 9c f4 ff ff       	call   800edc <sys_page_map>
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	83 c4 20             	add    $0x20,%esp
  801a45:	85 c0                	test   %eax,%eax
  801a47:	79 a3                	jns    8019ec <dup+0x74>
	sys_page_unmap(0, newfd);
  801a49:	83 ec 08             	sub    $0x8,%esp
  801a4c:	56                   	push   %esi
  801a4d:	6a 00                	push   $0x0
  801a4f:	e8 ca f4 ff ff       	call   800f1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a54:	83 c4 08             	add    $0x8,%esp
  801a57:	57                   	push   %edi
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 bf f4 ff ff       	call   800f1e <sys_page_unmap>
	return r;
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	eb b7                	jmp    801a1b <dup+0xa3>

00801a64 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	53                   	push   %ebx
  801a68:	83 ec 1c             	sub    $0x1c,%esp
  801a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a71:	50                   	push   %eax
  801a72:	53                   	push   %ebx
  801a73:	e8 7c fd ff ff       	call   8017f4 <fd_lookup>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 3f                	js     801abe <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a89:	ff 30                	pushl  (%eax)
  801a8b:	e8 b4 fd ff ff       	call   801844 <dev_lookup>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 27                	js     801abe <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9a:	8b 42 08             	mov    0x8(%edx),%eax
  801a9d:	83 e0 03             	and    $0x3,%eax
  801aa0:	83 f8 01             	cmp    $0x1,%eax
  801aa3:	74 1e                	je     801ac3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa8:	8b 40 08             	mov    0x8(%eax),%eax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	74 35                	je     801ae4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	52                   	push   %edx
  801ab9:	ff d0                	call   *%eax
  801abb:	83 c4 10             	add    $0x10,%esp
}
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ac3:	a1 08 50 80 00       	mov    0x805008,%eax
  801ac8:	8b 40 48             	mov    0x48(%eax),%eax
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	53                   	push   %ebx
  801acf:	50                   	push   %eax
  801ad0:	68 65 32 80 00       	push   $0x803265
  801ad5:	e8 6e e8 ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ae2:	eb da                	jmp    801abe <read+0x5a>
		return -E_NOT_SUPP;
  801ae4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae9:	eb d3                	jmp    801abe <read+0x5a>

00801aeb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	57                   	push   %edi
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801afa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aff:	39 f3                	cmp    %esi,%ebx
  801b01:	73 23                	jae    801b26 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	89 f0                	mov    %esi,%eax
  801b08:	29 d8                	sub    %ebx,%eax
  801b0a:	50                   	push   %eax
  801b0b:	89 d8                	mov    %ebx,%eax
  801b0d:	03 45 0c             	add    0xc(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	57                   	push   %edi
  801b12:	e8 4d ff ff ff       	call   801a64 <read>
		if (m < 0)
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 06                	js     801b24 <readn+0x39>
			return m;
		if (m == 0)
  801b1e:	74 06                	je     801b26 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b20:	01 c3                	add    %eax,%ebx
  801b22:	eb db                	jmp    801aff <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b24:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	53                   	push   %ebx
  801b34:	83 ec 1c             	sub    $0x1c,%esp
  801b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3d:	50                   	push   %eax
  801b3e:	53                   	push   %ebx
  801b3f:	e8 b0 fc ff ff       	call   8017f4 <fd_lookup>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 3a                	js     801b85 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b51:	50                   	push   %eax
  801b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b55:	ff 30                	pushl  (%eax)
  801b57:	e8 e8 fc ff ff       	call   801844 <dev_lookup>
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 22                	js     801b85 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b66:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b6a:	74 1e                	je     801b8a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6f:	8b 52 0c             	mov    0xc(%edx),%edx
  801b72:	85 d2                	test   %edx,%edx
  801b74:	74 35                	je     801bab <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	ff d2                	call   *%edx
  801b82:	83 c4 10             	add    $0x10,%esp
}
  801b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b8a:	a1 08 50 80 00       	mov    0x805008,%eax
  801b8f:	8b 40 48             	mov    0x48(%eax),%eax
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	53                   	push   %ebx
  801b96:	50                   	push   %eax
  801b97:	68 81 32 80 00       	push   $0x803281
  801b9c:	e8 a7 e7 ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba9:	eb da                	jmp    801b85 <write+0x55>
		return -E_NOT_SUPP;
  801bab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bb0:	eb d3                	jmp    801b85 <write+0x55>

00801bb2 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	50                   	push   %eax
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	e8 30 fc ff ff       	call   8017f4 <fd_lookup>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 0e                	js     801bd9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	53                   	push   %ebx
  801bdf:	83 ec 1c             	sub    $0x1c,%esp
  801be2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be8:	50                   	push   %eax
  801be9:	53                   	push   %ebx
  801bea:	e8 05 fc ff ff       	call   8017f4 <fd_lookup>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 37                	js     801c2d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf6:	83 ec 08             	sub    $0x8,%esp
  801bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c00:	ff 30                	pushl  (%eax)
  801c02:	e8 3d fc ff ff       	call   801844 <dev_lookup>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 1f                	js     801c2d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c11:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c15:	74 1b                	je     801c32 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1a:	8b 52 18             	mov    0x18(%edx),%edx
  801c1d:	85 d2                	test   %edx,%edx
  801c1f:	74 32                	je     801c53 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c21:	83 ec 08             	sub    $0x8,%esp
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	ff d2                	call   *%edx
  801c2a:	83 c4 10             	add    $0x10,%esp
}
  801c2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c32:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c37:	8b 40 48             	mov    0x48(%eax),%eax
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	53                   	push   %ebx
  801c3e:	50                   	push   %eax
  801c3f:	68 44 32 80 00       	push   $0x803244
  801c44:	e8 ff e6 ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c51:	eb da                	jmp    801c2d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c53:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c58:	eb d3                	jmp    801c2d <ftruncate+0x52>

00801c5a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 1c             	sub    $0x1c,%esp
  801c61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c67:	50                   	push   %eax
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	e8 84 fb ff ff       	call   8017f4 <fd_lookup>
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	85 c0                	test   %eax,%eax
  801c75:	78 4b                	js     801cc2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7d:	50                   	push   %eax
  801c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c81:	ff 30                	pushl  (%eax)
  801c83:	e8 bc fb ff ff       	call   801844 <dev_lookup>
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 33                	js     801cc2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c92:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c96:	74 2f                	je     801cc7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c98:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c9b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ca2:	00 00 00 
	stat->st_isdir = 0;
  801ca5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cac:	00 00 00 
	stat->st_dev = dev;
  801caf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cb5:	83 ec 08             	sub    $0x8,%esp
  801cb8:	53                   	push   %ebx
  801cb9:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbc:	ff 50 14             	call   *0x14(%eax)
  801cbf:	83 c4 10             	add    $0x10,%esp
}
  801cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    
		return -E_NOT_SUPP;
  801cc7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ccc:	eb f4                	jmp    801cc2 <fstat+0x68>

00801cce <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	56                   	push   %esi
  801cd2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cd3:	83 ec 08             	sub    $0x8,%esp
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	e8 22 02 00 00       	call   801f02 <open>
  801ce0:	89 c3                	mov    %eax,%ebx
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	78 1b                	js     801d04 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	50                   	push   %eax
  801cf0:	e8 65 ff ff ff       	call   801c5a <fstat>
  801cf5:	89 c6                	mov    %eax,%esi
	close(fd);
  801cf7:	89 1c 24             	mov    %ebx,(%esp)
  801cfa:	e8 27 fc ff ff       	call   801926 <close>
	return r;
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	89 f3                	mov    %esi,%ebx
}
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5d                   	pop    %ebp
  801d0c:	c3                   	ret    

00801d0d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	89 c6                	mov    %eax,%esi
  801d14:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d16:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d1d:	74 27                	je     801d46 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d1f:	6a 07                	push   $0x7
  801d21:	68 00 60 80 00       	push   $0x806000
  801d26:	56                   	push   %esi
  801d27:	ff 35 00 50 80 00    	pushl  0x805000
  801d2d:	e8 b2 f9 ff ff       	call   8016e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d32:	83 c4 0c             	add    $0xc,%esp
  801d35:	6a 00                	push   $0x0
  801d37:	53                   	push   %ebx
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 3c f9 ff ff       	call   80167b <ipc_recv>
}
  801d3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	6a 01                	push   $0x1
  801d4b:	e8 ec f9 ff ff       	call   80173c <ipc_find_env>
  801d50:	a3 00 50 80 00       	mov    %eax,0x805000
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	eb c5                	jmp    801d1f <fsipc+0x12>

00801d5a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	8b 40 0c             	mov    0xc(%eax),%eax
  801d66:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6e:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d73:	ba 00 00 00 00       	mov    $0x0,%edx
  801d78:	b8 02 00 00 00       	mov    $0x2,%eax
  801d7d:	e8 8b ff ff ff       	call   801d0d <fsipc>
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <devfile_flush>:
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d90:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	b8 06 00 00 00       	mov    $0x6,%eax
  801d9f:	e8 69 ff ff ff       	call   801d0d <fsipc>
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <devfile_stat>:
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	53                   	push   %ebx
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8b 40 0c             	mov    0xc(%eax),%eax
  801db6:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc0:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc5:	e8 43 ff ff ff       	call   801d0d <fsipc>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 2c                	js     801dfa <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	68 00 60 80 00       	push   $0x806000
  801dd6:	53                   	push   %ebx
  801dd7:	e8 cb ec ff ff       	call   800aa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ddc:	a1 80 60 80 00       	mov    0x806080,%eax
  801de1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801de7:	a1 84 60 80 00       	mov    0x806084,%eax
  801dec:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <devfile_write>:
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	53                   	push   %ebx
  801e03:	83 ec 08             	sub    $0x8,%esp
  801e06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e14:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e1a:	53                   	push   %ebx
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	68 08 60 80 00       	push   $0x806008
  801e23:	e8 6f ee ff ff       	call   800c97 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e28:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2d:	b8 04 00 00 00       	mov    $0x4,%eax
  801e32:	e8 d6 fe ff ff       	call   801d0d <fsipc>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 0b                	js     801e49 <devfile_write+0x4a>
	assert(r <= n);
  801e3e:	39 d8                	cmp    %ebx,%eax
  801e40:	77 0c                	ja     801e4e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e42:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e47:	7f 1e                	jg     801e67 <devfile_write+0x68>
}
  801e49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    
	assert(r <= n);
  801e4e:	68 b4 32 80 00       	push   $0x8032b4
  801e53:	68 bb 32 80 00       	push   $0x8032bb
  801e58:	68 98 00 00 00       	push   $0x98
  801e5d:	68 d0 32 80 00       	push   $0x8032d0
  801e62:	e8 6a 0a 00 00       	call   8028d1 <_panic>
	assert(r <= PGSIZE);
  801e67:	68 db 32 80 00       	push   $0x8032db
  801e6c:	68 bb 32 80 00       	push   $0x8032bb
  801e71:	68 99 00 00 00       	push   $0x99
  801e76:	68 d0 32 80 00       	push   $0x8032d0
  801e7b:	e8 51 0a 00 00       	call   8028d1 <_panic>

00801e80 <devfile_read>:
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	56                   	push   %esi
  801e84:	53                   	push   %ebx
  801e85:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e93:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea3:	e8 65 fe ff ff       	call   801d0d <fsipc>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 1f                	js     801ecd <devfile_read+0x4d>
	assert(r <= n);
  801eae:	39 f0                	cmp    %esi,%eax
  801eb0:	77 24                	ja     801ed6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801eb2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eb7:	7f 33                	jg     801eec <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801eb9:	83 ec 04             	sub    $0x4,%esp
  801ebc:	50                   	push   %eax
  801ebd:	68 00 60 80 00       	push   $0x806000
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	e8 6b ed ff ff       	call   800c35 <memmove>
	return r;
  801eca:	83 c4 10             	add    $0x10,%esp
}
  801ecd:	89 d8                	mov    %ebx,%eax
  801ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed2:	5b                   	pop    %ebx
  801ed3:	5e                   	pop    %esi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
	assert(r <= n);
  801ed6:	68 b4 32 80 00       	push   $0x8032b4
  801edb:	68 bb 32 80 00       	push   $0x8032bb
  801ee0:	6a 7c                	push   $0x7c
  801ee2:	68 d0 32 80 00       	push   $0x8032d0
  801ee7:	e8 e5 09 00 00       	call   8028d1 <_panic>
	assert(r <= PGSIZE);
  801eec:	68 db 32 80 00       	push   $0x8032db
  801ef1:	68 bb 32 80 00       	push   $0x8032bb
  801ef6:	6a 7d                	push   $0x7d
  801ef8:	68 d0 32 80 00       	push   $0x8032d0
  801efd:	e8 cf 09 00 00       	call   8028d1 <_panic>

00801f02 <open>:
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	56                   	push   %esi
  801f06:	53                   	push   %ebx
  801f07:	83 ec 1c             	sub    $0x1c,%esp
  801f0a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f0d:	56                   	push   %esi
  801f0e:	e8 5b eb ff ff       	call   800a6e <strlen>
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f1b:	7f 6c                	jg     801f89 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f23:	50                   	push   %eax
  801f24:	e8 79 f8 ff ff       	call   8017a2 <fd_alloc>
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 3c                	js     801f6e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	56                   	push   %esi
  801f36:	68 00 60 80 00       	push   $0x806000
  801f3b:	e8 67 eb ff ff       	call   800aa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f43:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f50:	e8 b8 fd ff ff       	call   801d0d <fsipc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 19                	js     801f77 <open+0x75>
	return fd2num(fd);
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	ff 75 f4             	pushl  -0xc(%ebp)
  801f64:	e8 12 f8 ff ff       	call   80177b <fd2num>
  801f69:	89 c3                	mov    %eax,%ebx
  801f6b:	83 c4 10             	add    $0x10,%esp
}
  801f6e:	89 d8                	mov    %ebx,%eax
  801f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    
		fd_close(fd, 0);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	6a 00                	push   $0x0
  801f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7f:	e8 1b f9 ff ff       	call   80189f <fd_close>
		return r;
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	eb e5                	jmp    801f6e <open+0x6c>
		return -E_BAD_PATH;
  801f89:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f8e:	eb de                	jmp    801f6e <open+0x6c>

00801f90 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f96:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9b:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa0:	e8 68 fd ff ff       	call   801d0d <fsipc>
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fad:	68 e7 32 80 00       	push   $0x8032e7
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	e8 ed ea ff ff       	call   800aa7 <strcpy>
	return 0;
}
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <devsock_close>:
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 10             	sub    $0x10,%esp
  801fc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fcb:	53                   	push   %ebx
  801fcc:	e8 f6 09 00 00       	call   8029c7 <pageref>
  801fd1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fd4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fd9:	83 f8 01             	cmp    $0x1,%eax
  801fdc:	74 07                	je     801fe5 <devsock_close+0x24>
}
  801fde:	89 d0                	mov    %edx,%eax
  801fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 73 0c             	pushl  0xc(%ebx)
  801feb:	e8 b9 02 00 00       	call   8022a9 <nsipc_close>
  801ff0:	89 c2                	mov    %eax,%edx
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	eb e7                	jmp    801fde <devsock_close+0x1d>

00801ff7 <devsock_write>:
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	ff 75 10             	pushl  0x10(%ebp)
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	ff 70 0c             	pushl  0xc(%eax)
  80200b:	e8 76 03 00 00       	call   802386 <nsipc_send>
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <devsock_read>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802018:	6a 00                	push   $0x0
  80201a:	ff 75 10             	pushl  0x10(%ebp)
  80201d:	ff 75 0c             	pushl  0xc(%ebp)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	ff 70 0c             	pushl  0xc(%eax)
  802026:	e8 ef 02 00 00       	call   80231a <nsipc_recv>
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <fd2sockid>:
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802033:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802036:	52                   	push   %edx
  802037:	50                   	push   %eax
  802038:	e8 b7 f7 ff ff       	call   8017f4 <fd_lookup>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	78 10                	js     802054 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80204d:	39 08                	cmp    %ecx,(%eax)
  80204f:	75 05                	jne    802056 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802051:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    
		return -E_NOT_SUPP;
  802056:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80205b:	eb f7                	jmp    802054 <fd2sockid+0x27>

0080205d <alloc_sockfd>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	83 ec 1c             	sub    $0x1c,%esp
  802065:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802067:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206a:	50                   	push   %eax
  80206b:	e8 32 f7 ff ff       	call   8017a2 <fd_alloc>
  802070:	89 c3                	mov    %eax,%ebx
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 43                	js     8020bc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802079:	83 ec 04             	sub    $0x4,%esp
  80207c:	68 07 04 00 00       	push   $0x407
  802081:	ff 75 f4             	pushl  -0xc(%ebp)
  802084:	6a 00                	push   $0x0
  802086:	e8 0e ee ff ff       	call   800e99 <sys_page_alloc>
  80208b:	89 c3                	mov    %eax,%ebx
  80208d:	83 c4 10             	add    $0x10,%esp
  802090:	85 c0                	test   %eax,%eax
  802092:	78 28                	js     8020bc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80209d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020a9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	50                   	push   %eax
  8020b0:	e8 c6 f6 ff ff       	call   80177b <fd2num>
  8020b5:	89 c3                	mov    %eax,%ebx
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	eb 0c                	jmp    8020c8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	56                   	push   %esi
  8020c0:	e8 e4 01 00 00       	call   8022a9 <nsipc_close>
		return r;
  8020c5:	83 c4 10             	add    $0x10,%esp
}
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <accept>:
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	e8 4e ff ff ff       	call   80202d <fd2sockid>
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 1b                	js     8020fe <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	ff 75 10             	pushl  0x10(%ebp)
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	50                   	push   %eax
  8020ed:	e8 0e 01 00 00       	call   802200 <nsipc_accept>
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	78 05                	js     8020fe <accept+0x2d>
	return alloc_sockfd(r);
  8020f9:	e8 5f ff ff ff       	call   80205d <alloc_sockfd>
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <bind>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	e8 1f ff ff ff       	call   80202d <fd2sockid>
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 12                	js     802124 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	ff 75 10             	pushl  0x10(%ebp)
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	50                   	push   %eax
  80211c:	e8 31 01 00 00       	call   802252 <nsipc_bind>
  802121:	83 c4 10             	add    $0x10,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <shutdown>:
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	e8 f9 fe ff ff       	call   80202d <fd2sockid>
  802134:	85 c0                	test   %eax,%eax
  802136:	78 0f                	js     802147 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802138:	83 ec 08             	sub    $0x8,%esp
  80213b:	ff 75 0c             	pushl  0xc(%ebp)
  80213e:	50                   	push   %eax
  80213f:	e8 43 01 00 00       	call   802287 <nsipc_shutdown>
  802144:	83 c4 10             	add    $0x10,%esp
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <connect>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	e8 d6 fe ff ff       	call   80202d <fd2sockid>
  802157:	85 c0                	test   %eax,%eax
  802159:	78 12                	js     80216d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	ff 75 10             	pushl  0x10(%ebp)
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	50                   	push   %eax
  802165:	e8 59 01 00 00       	call   8022c3 <nsipc_connect>
  80216a:	83 c4 10             	add    $0x10,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <listen>:
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	e8 b0 fe ff ff       	call   80202d <fd2sockid>
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 0f                	js     802190 <listen+0x21>
	return nsipc_listen(r, backlog);
  802181:	83 ec 08             	sub    $0x8,%esp
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	50                   	push   %eax
  802188:	e8 6b 01 00 00       	call   8022f8 <nsipc_listen>
  80218d:	83 c4 10             	add    $0x10,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <socket>:

int
socket(int domain, int type, int protocol)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802198:	ff 75 10             	pushl  0x10(%ebp)
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 3e 02 00 00       	call   8023e4 <nsipc_socket>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 05                	js     8021b2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021ad:	e8 ab fe ff ff       	call   80205d <alloc_sockfd>
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021bd:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021c4:	74 26                	je     8021ec <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021c6:	6a 07                	push   $0x7
  8021c8:	68 00 70 80 00       	push   $0x807000
  8021cd:	53                   	push   %ebx
  8021ce:	ff 35 04 50 80 00    	pushl  0x805004
  8021d4:	e8 0b f5 ff ff       	call   8016e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d9:	83 c4 0c             	add    $0xc,%esp
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	e8 94 f4 ff ff       	call   80167b <ipc_recv>
}
  8021e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021ec:	83 ec 0c             	sub    $0xc,%esp
  8021ef:	6a 02                	push   $0x2
  8021f1:	e8 46 f5 ff ff       	call   80173c <ipc_find_env>
  8021f6:	a3 04 50 80 00       	mov    %eax,0x805004
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	eb c6                	jmp    8021c6 <nsipc+0x12>

00802200 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	56                   	push   %esi
  802204:	53                   	push   %ebx
  802205:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802210:	8b 06                	mov    (%esi),%eax
  802212:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802217:	b8 01 00 00 00       	mov    $0x1,%eax
  80221c:	e8 93 ff ff ff       	call   8021b4 <nsipc>
  802221:	89 c3                	mov    %eax,%ebx
  802223:	85 c0                	test   %eax,%eax
  802225:	79 09                	jns    802230 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802227:	89 d8                	mov    %ebx,%eax
  802229:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5e                   	pop    %esi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	ff 35 10 70 80 00    	pushl  0x807010
  802239:	68 00 70 80 00       	push   $0x807000
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	e8 ef e9 ff ff       	call   800c35 <memmove>
		*addrlen = ret->ret_addrlen;
  802246:	a1 10 70 80 00       	mov    0x807010,%eax
  80224b:	89 06                	mov    %eax,(%esi)
  80224d:	83 c4 10             	add    $0x10,%esp
	return r;
  802250:	eb d5                	jmp    802227 <nsipc_accept+0x27>

00802252 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	53                   	push   %ebx
  802256:	83 ec 08             	sub    $0x8,%esp
  802259:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802264:	53                   	push   %ebx
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	68 04 70 80 00       	push   $0x807004
  80226d:	e8 c3 e9 ff ff       	call   800c35 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802272:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802278:	b8 02 00 00 00       	mov    $0x2,%eax
  80227d:	e8 32 ff ff ff       	call   8021b4 <nsipc>
}
  802282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80229d:	b8 03 00 00 00       	mov    $0x3,%eax
  8022a2:	e8 0d ff ff ff       	call   8021b4 <nsipc>
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <nsipc_close>:

int
nsipc_close(int s)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8022bc:	e8 f3 fe ff ff       	call   8021b4 <nsipc>
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	53                   	push   %ebx
  8022c7:	83 ec 08             	sub    $0x8,%esp
  8022ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022d5:	53                   	push   %ebx
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	68 04 70 80 00       	push   $0x807004
  8022de:	e8 52 e9 ff ff       	call   800c35 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022e3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ee:	e8 c1 fe ff ff       	call   8021b4 <nsipc>
}
  8022f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80230e:	b8 06 00 00 00       	mov    $0x6,%eax
  802313:	e8 9c fe ff ff       	call   8021b4 <nsipc>
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	56                   	push   %esi
  80231e:	53                   	push   %ebx
  80231f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80232a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802330:	8b 45 14             	mov    0x14(%ebp),%eax
  802333:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802338:	b8 07 00 00 00       	mov    $0x7,%eax
  80233d:	e8 72 fe ff ff       	call   8021b4 <nsipc>
  802342:	89 c3                	mov    %eax,%ebx
  802344:	85 c0                	test   %eax,%eax
  802346:	78 1f                	js     802367 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802348:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80234d:	7f 21                	jg     802370 <nsipc_recv+0x56>
  80234f:	39 c6                	cmp    %eax,%esi
  802351:	7c 1d                	jl     802370 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	50                   	push   %eax
  802357:	68 00 70 80 00       	push   $0x807000
  80235c:	ff 75 0c             	pushl  0xc(%ebp)
  80235f:	e8 d1 e8 ff ff       	call   800c35 <memmove>
  802364:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802367:	89 d8                	mov    %ebx,%eax
  802369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802370:	68 f3 32 80 00       	push   $0x8032f3
  802375:	68 bb 32 80 00       	push   $0x8032bb
  80237a:	6a 62                	push   $0x62
  80237c:	68 08 33 80 00       	push   $0x803308
  802381:	e8 4b 05 00 00       	call   8028d1 <_panic>

00802386 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	53                   	push   %ebx
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802398:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80239e:	7f 2e                	jg     8023ce <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	53                   	push   %ebx
  8023a4:	ff 75 0c             	pushl  0xc(%ebp)
  8023a7:	68 0c 70 80 00       	push   $0x80700c
  8023ac:	e8 84 e8 ff ff       	call   800c35 <memmove>
	nsipcbuf.send.req_size = size;
  8023b1:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ba:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8023c4:	e8 eb fd ff ff       	call   8021b4 <nsipc>
}
  8023c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    
	assert(size < 1600);
  8023ce:	68 14 33 80 00       	push   $0x803314
  8023d3:	68 bb 32 80 00       	push   $0x8032bb
  8023d8:	6a 6d                	push   $0x6d
  8023da:	68 08 33 80 00       	push   $0x803308
  8023df:	e8 ed 04 00 00       	call   8028d1 <_panic>

008023e4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f5:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fd:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802402:	b8 09 00 00 00       	mov    $0x9,%eax
  802407:	e8 a8 fd ff ff       	call   8021b4 <nsipc>
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802416:	83 ec 0c             	sub    $0xc,%esp
  802419:	ff 75 08             	pushl  0x8(%ebp)
  80241c:	e8 6a f3 ff ff       	call   80178b <fd2data>
  802421:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802423:	83 c4 08             	add    $0x8,%esp
  802426:	68 20 33 80 00       	push   $0x803320
  80242b:	53                   	push   %ebx
  80242c:	e8 76 e6 ff ff       	call   800aa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802431:	8b 46 04             	mov    0x4(%esi),%eax
  802434:	2b 06                	sub    (%esi),%eax
  802436:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80243c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802443:	00 00 00 
	stat->st_dev = &devpipe;
  802446:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  80244d:	40 80 00 
	return 0;
}
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
  802455:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802458:	5b                   	pop    %ebx
  802459:	5e                   	pop    %esi
  80245a:	5d                   	pop    %ebp
  80245b:	c3                   	ret    

0080245c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	53                   	push   %ebx
  802460:	83 ec 0c             	sub    $0xc,%esp
  802463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802466:	53                   	push   %ebx
  802467:	6a 00                	push   $0x0
  802469:	e8 b0 ea ff ff       	call   800f1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80246e:	89 1c 24             	mov    %ebx,(%esp)
  802471:	e8 15 f3 ff ff       	call   80178b <fd2data>
  802476:	83 c4 08             	add    $0x8,%esp
  802479:	50                   	push   %eax
  80247a:	6a 00                	push   $0x0
  80247c:	e8 9d ea ff ff       	call   800f1e <sys_page_unmap>
}
  802481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <_pipeisclosed>:
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	57                   	push   %edi
  80248a:	56                   	push   %esi
  80248b:	53                   	push   %ebx
  80248c:	83 ec 1c             	sub    $0x1c,%esp
  80248f:	89 c7                	mov    %eax,%edi
  802491:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802493:	a1 08 50 80 00       	mov    0x805008,%eax
  802498:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	57                   	push   %edi
  80249f:	e8 23 05 00 00       	call   8029c7 <pageref>
  8024a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024a7:	89 34 24             	mov    %esi,(%esp)
  8024aa:	e8 18 05 00 00       	call   8029c7 <pageref>
		nn = thisenv->env_runs;
  8024af:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024b5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	39 cb                	cmp    %ecx,%ebx
  8024bd:	74 1b                	je     8024da <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024bf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024c2:	75 cf                	jne    802493 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024c4:	8b 42 58             	mov    0x58(%edx),%eax
  8024c7:	6a 01                	push   $0x1
  8024c9:	50                   	push   %eax
  8024ca:	53                   	push   %ebx
  8024cb:	68 27 33 80 00       	push   $0x803327
  8024d0:	e8 73 de ff ff       	call   800348 <cprintf>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	eb b9                	jmp    802493 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024dd:	0f 94 c0             	sete   %al
  8024e0:	0f b6 c0             	movzbl %al,%eax
}
  8024e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e6:	5b                   	pop    %ebx
  8024e7:	5e                   	pop    %esi
  8024e8:	5f                   	pop    %edi
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <devpipe_write>:
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	57                   	push   %edi
  8024ef:	56                   	push   %esi
  8024f0:	53                   	push   %ebx
  8024f1:	83 ec 28             	sub    $0x28,%esp
  8024f4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024f7:	56                   	push   %esi
  8024f8:	e8 8e f2 ff ff       	call   80178b <fd2data>
  8024fd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	bf 00 00 00 00       	mov    $0x0,%edi
  802507:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80250a:	74 4f                	je     80255b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250c:	8b 43 04             	mov    0x4(%ebx),%eax
  80250f:	8b 0b                	mov    (%ebx),%ecx
  802511:	8d 51 20             	lea    0x20(%ecx),%edx
  802514:	39 d0                	cmp    %edx,%eax
  802516:	72 14                	jb     80252c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802518:	89 da                	mov    %ebx,%edx
  80251a:	89 f0                	mov    %esi,%eax
  80251c:	e8 65 ff ff ff       	call   802486 <_pipeisclosed>
  802521:	85 c0                	test   %eax,%eax
  802523:	75 3b                	jne    802560 <devpipe_write+0x75>
			sys_yield();
  802525:	e8 50 e9 ff ff       	call   800e7a <sys_yield>
  80252a:	eb e0                	jmp    80250c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80252c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802533:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802536:	89 c2                	mov    %eax,%edx
  802538:	c1 fa 1f             	sar    $0x1f,%edx
  80253b:	89 d1                	mov    %edx,%ecx
  80253d:	c1 e9 1b             	shr    $0x1b,%ecx
  802540:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802543:	83 e2 1f             	and    $0x1f,%edx
  802546:	29 ca                	sub    %ecx,%edx
  802548:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80254c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802550:	83 c0 01             	add    $0x1,%eax
  802553:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802556:	83 c7 01             	add    $0x1,%edi
  802559:	eb ac                	jmp    802507 <devpipe_write+0x1c>
	return i;
  80255b:	8b 45 10             	mov    0x10(%ebp),%eax
  80255e:	eb 05                	jmp    802565 <devpipe_write+0x7a>
				return 0;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802565:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802568:	5b                   	pop    %ebx
  802569:	5e                   	pop    %esi
  80256a:	5f                   	pop    %edi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    

0080256d <devpipe_read>:
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	57                   	push   %edi
  802571:	56                   	push   %esi
  802572:	53                   	push   %ebx
  802573:	83 ec 18             	sub    $0x18,%esp
  802576:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802579:	57                   	push   %edi
  80257a:	e8 0c f2 ff ff       	call   80178b <fd2data>
  80257f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	be 00 00 00 00       	mov    $0x0,%esi
  802589:	3b 75 10             	cmp    0x10(%ebp),%esi
  80258c:	75 14                	jne    8025a2 <devpipe_read+0x35>
	return i;
  80258e:	8b 45 10             	mov    0x10(%ebp),%eax
  802591:	eb 02                	jmp    802595 <devpipe_read+0x28>
				return i;
  802593:	89 f0                	mov    %esi,%eax
}
  802595:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802598:	5b                   	pop    %ebx
  802599:	5e                   	pop    %esi
  80259a:	5f                   	pop    %edi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    
			sys_yield();
  80259d:	e8 d8 e8 ff ff       	call   800e7a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025a2:	8b 03                	mov    (%ebx),%eax
  8025a4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a7:	75 18                	jne    8025c1 <devpipe_read+0x54>
			if (i > 0)
  8025a9:	85 f6                	test   %esi,%esi
  8025ab:	75 e6                	jne    802593 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025ad:	89 da                	mov    %ebx,%edx
  8025af:	89 f8                	mov    %edi,%eax
  8025b1:	e8 d0 fe ff ff       	call   802486 <_pipeisclosed>
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 e3                	je     80259d <devpipe_read+0x30>
				return 0;
  8025ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bf:	eb d4                	jmp    802595 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025c1:	99                   	cltd   
  8025c2:	c1 ea 1b             	shr    $0x1b,%edx
  8025c5:	01 d0                	add    %edx,%eax
  8025c7:	83 e0 1f             	and    $0x1f,%eax
  8025ca:	29 d0                	sub    %edx,%eax
  8025cc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025d4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025d7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025da:	83 c6 01             	add    $0x1,%esi
  8025dd:	eb aa                	jmp    802589 <devpipe_read+0x1c>

008025df <pipe>:
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ea:	50                   	push   %eax
  8025eb:	e8 b2 f1 ff ff       	call   8017a2 <fd_alloc>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	0f 88 23 01 00 00    	js     802720 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	83 ec 04             	sub    $0x4,%esp
  802600:	68 07 04 00 00       	push   $0x407
  802605:	ff 75 f4             	pushl  -0xc(%ebp)
  802608:	6a 00                	push   $0x0
  80260a:	e8 8a e8 ff ff       	call   800e99 <sys_page_alloc>
  80260f:	89 c3                	mov    %eax,%ebx
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 88 04 01 00 00    	js     802720 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80261c:	83 ec 0c             	sub    $0xc,%esp
  80261f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802622:	50                   	push   %eax
  802623:	e8 7a f1 ff ff       	call   8017a2 <fd_alloc>
  802628:	89 c3                	mov    %eax,%ebx
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 88 db 00 00 00    	js     802710 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802635:	83 ec 04             	sub    $0x4,%esp
  802638:	68 07 04 00 00       	push   $0x407
  80263d:	ff 75 f0             	pushl  -0x10(%ebp)
  802640:	6a 00                	push   $0x0
  802642:	e8 52 e8 ff ff       	call   800e99 <sys_page_alloc>
  802647:	89 c3                	mov    %eax,%ebx
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	85 c0                	test   %eax,%eax
  80264e:	0f 88 bc 00 00 00    	js     802710 <pipe+0x131>
	va = fd2data(fd0);
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	ff 75 f4             	pushl  -0xc(%ebp)
  80265a:	e8 2c f1 ff ff       	call   80178b <fd2data>
  80265f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802661:	83 c4 0c             	add    $0xc,%esp
  802664:	68 07 04 00 00       	push   $0x407
  802669:	50                   	push   %eax
  80266a:	6a 00                	push   $0x0
  80266c:	e8 28 e8 ff ff       	call   800e99 <sys_page_alloc>
  802671:	89 c3                	mov    %eax,%ebx
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 88 82 00 00 00    	js     802700 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	ff 75 f0             	pushl  -0x10(%ebp)
  802684:	e8 02 f1 ff ff       	call   80178b <fd2data>
  802689:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802690:	50                   	push   %eax
  802691:	6a 00                	push   $0x0
  802693:	56                   	push   %esi
  802694:	6a 00                	push   $0x0
  802696:	e8 41 e8 ff ff       	call   800edc <sys_page_map>
  80269b:	89 c3                	mov    %eax,%ebx
  80269d:	83 c4 20             	add    $0x20,%esp
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	78 4e                	js     8026f2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026a4:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ac:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cd:	e8 a9 f0 ff ff       	call   80177b <fd2num>
  8026d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026d7:	83 c4 04             	add    $0x4,%esp
  8026da:	ff 75 f0             	pushl  -0x10(%ebp)
  8026dd:	e8 99 f0 ff ff       	call   80177b <fd2num>
  8026e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f0:	eb 2e                	jmp    802720 <pipe+0x141>
	sys_page_unmap(0, va);
  8026f2:	83 ec 08             	sub    $0x8,%esp
  8026f5:	56                   	push   %esi
  8026f6:	6a 00                	push   $0x0
  8026f8:	e8 21 e8 ff ff       	call   800f1e <sys_page_unmap>
  8026fd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802700:	83 ec 08             	sub    $0x8,%esp
  802703:	ff 75 f0             	pushl  -0x10(%ebp)
  802706:	6a 00                	push   $0x0
  802708:	e8 11 e8 ff ff       	call   800f1e <sys_page_unmap>
  80270d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802710:	83 ec 08             	sub    $0x8,%esp
  802713:	ff 75 f4             	pushl  -0xc(%ebp)
  802716:	6a 00                	push   $0x0
  802718:	e8 01 e8 ff ff       	call   800f1e <sys_page_unmap>
  80271d:	83 c4 10             	add    $0x10,%esp
}
  802720:	89 d8                	mov    %ebx,%eax
  802722:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	5d                   	pop    %ebp
  802728:	c3                   	ret    

00802729 <pipeisclosed>:
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802732:	50                   	push   %eax
  802733:	ff 75 08             	pushl  0x8(%ebp)
  802736:	e8 b9 f0 ff ff       	call   8017f4 <fd_lookup>
  80273b:	83 c4 10             	add    $0x10,%esp
  80273e:	85 c0                	test   %eax,%eax
  802740:	78 18                	js     80275a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	ff 75 f4             	pushl  -0xc(%ebp)
  802748:	e8 3e f0 ff ff       	call   80178b <fd2data>
	return _pipeisclosed(fd, p);
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	e8 2f fd ff ff       	call   802486 <_pipeisclosed>
  802757:	83 c4 10             	add    $0x10,%esp
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	c3                   	ret    

00802762 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802768:	68 3f 33 80 00       	push   $0x80333f
  80276d:	ff 75 0c             	pushl  0xc(%ebp)
  802770:	e8 32 e3 ff ff       	call   800aa7 <strcpy>
	return 0;
}
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <devcons_write>:
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	57                   	push   %edi
  802780:	56                   	push   %esi
  802781:	53                   	push   %ebx
  802782:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802788:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80278d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802793:	3b 75 10             	cmp    0x10(%ebp),%esi
  802796:	73 31                	jae    8027c9 <devcons_write+0x4d>
		m = n - tot;
  802798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80279b:	29 f3                	sub    %esi,%ebx
  80279d:	83 fb 7f             	cmp    $0x7f,%ebx
  8027a0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027a5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	53                   	push   %ebx
  8027ac:	89 f0                	mov    %esi,%eax
  8027ae:	03 45 0c             	add    0xc(%ebp),%eax
  8027b1:	50                   	push   %eax
  8027b2:	57                   	push   %edi
  8027b3:	e8 7d e4 ff ff       	call   800c35 <memmove>
		sys_cputs(buf, m);
  8027b8:	83 c4 08             	add    $0x8,%esp
  8027bb:	53                   	push   %ebx
  8027bc:	57                   	push   %edi
  8027bd:	e8 1b e6 ff ff       	call   800ddd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027c2:	01 de                	add    %ebx,%esi
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	eb ca                	jmp    802793 <devcons_write+0x17>
}
  8027c9:	89 f0                	mov    %esi,%eax
  8027cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027ce:	5b                   	pop    %ebx
  8027cf:	5e                   	pop    %esi
  8027d0:	5f                   	pop    %edi
  8027d1:	5d                   	pop    %ebp
  8027d2:	c3                   	ret    

008027d3 <devcons_read>:
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 08             	sub    $0x8,%esp
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e2:	74 21                	je     802805 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027e4:	e8 12 e6 ff ff       	call   800dfb <sys_cgetc>
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	75 07                	jne    8027f4 <devcons_read+0x21>
		sys_yield();
  8027ed:	e8 88 e6 ff ff       	call   800e7a <sys_yield>
  8027f2:	eb f0                	jmp    8027e4 <devcons_read+0x11>
	if (c < 0)
  8027f4:	78 0f                	js     802805 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027f6:	83 f8 04             	cmp    $0x4,%eax
  8027f9:	74 0c                	je     802807 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fe:	88 02                	mov    %al,(%edx)
	return 1;
  802800:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    
		return 0;
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
  80280c:	eb f7                	jmp    802805 <devcons_read+0x32>

0080280e <cputchar>:
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80281a:	6a 01                	push   $0x1
  80281c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80281f:	50                   	push   %eax
  802820:	e8 b8 e5 ff ff       	call   800ddd <sys_cputs>
}
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <getchar>:
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802830:	6a 01                	push   $0x1
  802832:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802835:	50                   	push   %eax
  802836:	6a 00                	push   $0x0
  802838:	e8 27 f2 ff ff       	call   801a64 <read>
	if (r < 0)
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	85 c0                	test   %eax,%eax
  802842:	78 06                	js     80284a <getchar+0x20>
	if (r < 1)
  802844:	74 06                	je     80284c <getchar+0x22>
	return c;
  802846:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    
		return -E_EOF;
  80284c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802851:	eb f7                	jmp    80284a <getchar+0x20>

00802853 <iscons>:
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802859:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285c:	50                   	push   %eax
  80285d:	ff 75 08             	pushl  0x8(%ebp)
  802860:	e8 8f ef ff ff       	call   8017f4 <fd_lookup>
  802865:	83 c4 10             	add    $0x10,%esp
  802868:	85 c0                	test   %eax,%eax
  80286a:	78 11                	js     80287d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802875:	39 10                	cmp    %edx,(%eax)
  802877:	0f 94 c0             	sete   %al
  80287a:	0f b6 c0             	movzbl %al,%eax
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <opencons>:
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802885:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802888:	50                   	push   %eax
  802889:	e8 14 ef ff ff       	call   8017a2 <fd_alloc>
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	85 c0                	test   %eax,%eax
  802893:	78 3a                	js     8028cf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 07 04 00 00       	push   $0x407
  80289d:	ff 75 f4             	pushl  -0xc(%ebp)
  8028a0:	6a 00                	push   $0x0
  8028a2:	e8 f2 e5 ff ff       	call   800e99 <sys_page_alloc>
  8028a7:	83 c4 10             	add    $0x10,%esp
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	78 21                	js     8028cf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028b7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028c3:	83 ec 0c             	sub    $0xc,%esp
  8028c6:	50                   	push   %eax
  8028c7:	e8 af ee ff ff       	call   80177b <fd2num>
  8028cc:	83 c4 10             	add    $0x10,%esp
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	56                   	push   %esi
  8028d5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8028d6:	a1 08 50 80 00       	mov    0x805008,%eax
  8028db:	8b 40 48             	mov    0x48(%eax),%eax
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 70 33 80 00       	push   $0x803370
  8028e6:	50                   	push   %eax
  8028e7:	68 5a 2d 80 00       	push   $0x802d5a
  8028ec:	e8 57 da ff ff       	call   800348 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8028f1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028f4:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8028fa:	e8 5c e5 ff ff       	call   800e5b <sys_getenvid>
  8028ff:	83 c4 04             	add    $0x4,%esp
  802902:	ff 75 0c             	pushl  0xc(%ebp)
  802905:	ff 75 08             	pushl  0x8(%ebp)
  802908:	56                   	push   %esi
  802909:	50                   	push   %eax
  80290a:	68 4c 33 80 00       	push   $0x80334c
  80290f:	e8 34 da ff ff       	call   800348 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802914:	83 c4 18             	add    $0x18,%esp
  802917:	53                   	push   %ebx
  802918:	ff 75 10             	pushl  0x10(%ebp)
  80291b:	e8 d7 d9 ff ff       	call   8002f7 <vcprintf>
	cprintf("\n");
  802920:	c7 04 24 1e 2d 80 00 	movl   $0x802d1e,(%esp)
  802927:	e8 1c da ff ff       	call   800348 <cprintf>
  80292c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80292f:	cc                   	int3   
  802930:	eb fd                	jmp    80292f <_panic+0x5e>

00802932 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802938:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80293f:	74 0a                	je     80294b <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802949:	c9                   	leave  
  80294a:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	6a 07                	push   $0x7
  802950:	68 00 f0 bf ee       	push   $0xeebff000
  802955:	6a 00                	push   $0x0
  802957:	e8 3d e5 ff ff       	call   800e99 <sys_page_alloc>
		if(r < 0)
  80295c:	83 c4 10             	add    $0x10,%esp
  80295f:	85 c0                	test   %eax,%eax
  802961:	78 2a                	js     80298d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802963:	83 ec 08             	sub    $0x8,%esp
  802966:	68 a1 29 80 00       	push   $0x8029a1
  80296b:	6a 00                	push   $0x0
  80296d:	e8 72 e6 ff ff       	call   800fe4 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802972:	83 c4 10             	add    $0x10,%esp
  802975:	85 c0                	test   %eax,%eax
  802977:	79 c8                	jns    802941 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 a8 33 80 00       	push   $0x8033a8
  802981:	6a 25                	push   $0x25
  802983:	68 e4 33 80 00       	push   $0x8033e4
  802988:	e8 44 ff ff ff       	call   8028d1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	68 78 33 80 00       	push   $0x803378
  802995:	6a 22                	push   $0x22
  802997:	68 e4 33 80 00       	push   $0x8033e4
  80299c:	e8 30 ff ff ff       	call   8028d1 <_panic>

008029a1 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029a1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029a2:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029a7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029a9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029ac:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029b0:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029b4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029b7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029b9:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029bd:	83 c4 08             	add    $0x8,%esp
	popal
  8029c0:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029c1:	83 c4 04             	add    $0x4,%esp
	popfl
  8029c4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029c5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029c6:	c3                   	ret    

008029c7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029cd:	89 d0                	mov    %edx,%eax
  8029cf:	c1 e8 16             	shr    $0x16,%eax
  8029d2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029de:	f6 c1 01             	test   $0x1,%cl
  8029e1:	74 1d                	je     802a00 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029e3:	c1 ea 0c             	shr    $0xc,%edx
  8029e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029ed:	f6 c2 01             	test   $0x1,%dl
  8029f0:	74 0e                	je     802a00 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029f2:	c1 ea 0c             	shr    $0xc,%edx
  8029f5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029fc:	ef 
  8029fd:	0f b7 c0             	movzwl %ax,%eax
}
  802a00:	5d                   	pop    %ebp
  802a01:	c3                   	ret    
  802a02:	66 90                	xchg   %ax,%ax
  802a04:	66 90                	xchg   %ax,%ax
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	66 90                	xchg   %ax,%ax
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a27:	85 d2                	test   %edx,%edx
  802a29:	75 4d                	jne    802a78 <__udivdi3+0x68>
  802a2b:	39 f3                	cmp    %esi,%ebx
  802a2d:	76 19                	jbe    802a48 <__udivdi3+0x38>
  802a2f:	31 ff                	xor    %edi,%edi
  802a31:	89 e8                	mov    %ebp,%eax
  802a33:	89 f2                	mov    %esi,%edx
  802a35:	f7 f3                	div    %ebx
  802a37:	89 fa                	mov    %edi,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	89 d9                	mov    %ebx,%ecx
  802a4a:	85 db                	test   %ebx,%ebx
  802a4c:	75 0b                	jne    802a59 <__udivdi3+0x49>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	31 d2                	xor    %edx,%edx
  802a55:	f7 f3                	div    %ebx
  802a57:	89 c1                	mov    %eax,%ecx
  802a59:	31 d2                	xor    %edx,%edx
  802a5b:	89 f0                	mov    %esi,%eax
  802a5d:	f7 f1                	div    %ecx
  802a5f:	89 c6                	mov    %eax,%esi
  802a61:	89 e8                	mov    %ebp,%eax
  802a63:	89 f7                	mov    %esi,%edi
  802a65:	f7 f1                	div    %ecx
  802a67:	89 fa                	mov    %edi,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	39 f2                	cmp    %esi,%edx
  802a7a:	77 1c                	ja     802a98 <__udivdi3+0x88>
  802a7c:	0f bd fa             	bsr    %edx,%edi
  802a7f:	83 f7 1f             	xor    $0x1f,%edi
  802a82:	75 2c                	jne    802ab0 <__udivdi3+0xa0>
  802a84:	39 f2                	cmp    %esi,%edx
  802a86:	72 06                	jb     802a8e <__udivdi3+0x7e>
  802a88:	31 c0                	xor    %eax,%eax
  802a8a:	39 eb                	cmp    %ebp,%ebx
  802a8c:	77 a9                	ja     802a37 <__udivdi3+0x27>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	eb a2                	jmp    802a37 <__udivdi3+0x27>
  802a95:	8d 76 00             	lea    0x0(%esi),%esi
  802a98:	31 ff                	xor    %edi,%edi
  802a9a:	31 c0                	xor    %eax,%eax
  802a9c:	89 fa                	mov    %edi,%edx
  802a9e:	83 c4 1c             	add    $0x1c,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    
  802aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aad:	8d 76 00             	lea    0x0(%esi),%esi
  802ab0:	89 f9                	mov    %edi,%ecx
  802ab2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab7:	29 f8                	sub    %edi,%eax
  802ab9:	d3 e2                	shl    %cl,%edx
  802abb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802abf:	89 c1                	mov    %eax,%ecx
  802ac1:	89 da                	mov    %ebx,%edx
  802ac3:	d3 ea                	shr    %cl,%edx
  802ac5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ac9:	09 d1                	or     %edx,%ecx
  802acb:	89 f2                	mov    %esi,%edx
  802acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad1:	89 f9                	mov    %edi,%ecx
  802ad3:	d3 e3                	shl    %cl,%ebx
  802ad5:	89 c1                	mov    %eax,%ecx
  802ad7:	d3 ea                	shr    %cl,%edx
  802ad9:	89 f9                	mov    %edi,%ecx
  802adb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802adf:	89 eb                	mov    %ebp,%ebx
  802ae1:	d3 e6                	shl    %cl,%esi
  802ae3:	89 c1                	mov    %eax,%ecx
  802ae5:	d3 eb                	shr    %cl,%ebx
  802ae7:	09 de                	or     %ebx,%esi
  802ae9:	89 f0                	mov    %esi,%eax
  802aeb:	f7 74 24 08          	divl   0x8(%esp)
  802aef:	89 d6                	mov    %edx,%esi
  802af1:	89 c3                	mov    %eax,%ebx
  802af3:	f7 64 24 0c          	mull   0xc(%esp)
  802af7:	39 d6                	cmp    %edx,%esi
  802af9:	72 15                	jb     802b10 <__udivdi3+0x100>
  802afb:	89 f9                	mov    %edi,%ecx
  802afd:	d3 e5                	shl    %cl,%ebp
  802aff:	39 c5                	cmp    %eax,%ebp
  802b01:	73 04                	jae    802b07 <__udivdi3+0xf7>
  802b03:	39 d6                	cmp    %edx,%esi
  802b05:	74 09                	je     802b10 <__udivdi3+0x100>
  802b07:	89 d8                	mov    %ebx,%eax
  802b09:	31 ff                	xor    %edi,%edi
  802b0b:	e9 27 ff ff ff       	jmp    802a37 <__udivdi3+0x27>
  802b10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b13:	31 ff                	xor    %edi,%edi
  802b15:	e9 1d ff ff ff       	jmp    802a37 <__udivdi3+0x27>
  802b1a:	66 90                	xchg   %ax,%ax
  802b1c:	66 90                	xchg   %ax,%ax
  802b1e:	66 90                	xchg   %ax,%ax

00802b20 <__umoddi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	53                   	push   %ebx
  802b24:	83 ec 1c             	sub    $0x1c,%esp
  802b27:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b2f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b37:	89 da                	mov    %ebx,%edx
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	75 43                	jne    802b80 <__umoddi3+0x60>
  802b3d:	39 df                	cmp    %ebx,%edi
  802b3f:	76 17                	jbe    802b58 <__umoddi3+0x38>
  802b41:	89 f0                	mov    %esi,%eax
  802b43:	f7 f7                	div    %edi
  802b45:	89 d0                	mov    %edx,%eax
  802b47:	31 d2                	xor    %edx,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	89 fd                	mov    %edi,%ebp
  802b5a:	85 ff                	test   %edi,%edi
  802b5c:	75 0b                	jne    802b69 <__umoddi3+0x49>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	31 d2                	xor    %edx,%edx
  802b65:	f7 f7                	div    %edi
  802b67:	89 c5                	mov    %eax,%ebp
  802b69:	89 d8                	mov    %ebx,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f5                	div    %ebp
  802b6f:	89 f0                	mov    %esi,%eax
  802b71:	f7 f5                	div    %ebp
  802b73:	89 d0                	mov    %edx,%eax
  802b75:	eb d0                	jmp    802b47 <__umoddi3+0x27>
  802b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	89 f1                	mov    %esi,%ecx
  802b82:	39 d8                	cmp    %ebx,%eax
  802b84:	76 0a                	jbe    802b90 <__umoddi3+0x70>
  802b86:	89 f0                	mov    %esi,%eax
  802b88:	83 c4 1c             	add    $0x1c,%esp
  802b8b:	5b                   	pop    %ebx
  802b8c:	5e                   	pop    %esi
  802b8d:	5f                   	pop    %edi
  802b8e:	5d                   	pop    %ebp
  802b8f:	c3                   	ret    
  802b90:	0f bd e8             	bsr    %eax,%ebp
  802b93:	83 f5 1f             	xor    $0x1f,%ebp
  802b96:	75 20                	jne    802bb8 <__umoddi3+0x98>
  802b98:	39 d8                	cmp    %ebx,%eax
  802b9a:	0f 82 b0 00 00 00    	jb     802c50 <__umoddi3+0x130>
  802ba0:	39 f7                	cmp    %esi,%edi
  802ba2:	0f 86 a8 00 00 00    	jbe    802c50 <__umoddi3+0x130>
  802ba8:	89 c8                	mov    %ecx,%eax
  802baa:	83 c4 1c             	add    $0x1c,%esp
  802bad:	5b                   	pop    %ebx
  802bae:	5e                   	pop    %esi
  802baf:	5f                   	pop    %edi
  802bb0:	5d                   	pop    %ebp
  802bb1:	c3                   	ret    
  802bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb8:	89 e9                	mov    %ebp,%ecx
  802bba:	ba 20 00 00 00       	mov    $0x20,%edx
  802bbf:	29 ea                	sub    %ebp,%edx
  802bc1:	d3 e0                	shl    %cl,%eax
  802bc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bc7:	89 d1                	mov    %edx,%ecx
  802bc9:	89 f8                	mov    %edi,%eax
  802bcb:	d3 e8                	shr    %cl,%eax
  802bcd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bd9:	09 c1                	or     %eax,%ecx
  802bdb:	89 d8                	mov    %ebx,%eax
  802bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be1:	89 e9                	mov    %ebp,%ecx
  802be3:	d3 e7                	shl    %cl,%edi
  802be5:	89 d1                	mov    %edx,%ecx
  802be7:	d3 e8                	shr    %cl,%eax
  802be9:	89 e9                	mov    %ebp,%ecx
  802beb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bef:	d3 e3                	shl    %cl,%ebx
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	89 d1                	mov    %edx,%ecx
  802bf5:	89 f0                	mov    %esi,%eax
  802bf7:	d3 e8                	shr    %cl,%eax
  802bf9:	89 e9                	mov    %ebp,%ecx
  802bfb:	89 fa                	mov    %edi,%edx
  802bfd:	d3 e6                	shl    %cl,%esi
  802bff:	09 d8                	or     %ebx,%eax
  802c01:	f7 74 24 08          	divl   0x8(%esp)
  802c05:	89 d1                	mov    %edx,%ecx
  802c07:	89 f3                	mov    %esi,%ebx
  802c09:	f7 64 24 0c          	mull   0xc(%esp)
  802c0d:	89 c6                	mov    %eax,%esi
  802c0f:	89 d7                	mov    %edx,%edi
  802c11:	39 d1                	cmp    %edx,%ecx
  802c13:	72 06                	jb     802c1b <__umoddi3+0xfb>
  802c15:	75 10                	jne    802c27 <__umoddi3+0x107>
  802c17:	39 c3                	cmp    %eax,%ebx
  802c19:	73 0c                	jae    802c27 <__umoddi3+0x107>
  802c1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c23:	89 d7                	mov    %edx,%edi
  802c25:	89 c6                	mov    %eax,%esi
  802c27:	89 ca                	mov    %ecx,%edx
  802c29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c2e:	29 f3                	sub    %esi,%ebx
  802c30:	19 fa                	sbb    %edi,%edx
  802c32:	89 d0                	mov    %edx,%eax
  802c34:	d3 e0                	shl    %cl,%eax
  802c36:	89 e9                	mov    %ebp,%ecx
  802c38:	d3 eb                	shr    %cl,%ebx
  802c3a:	d3 ea                	shr    %cl,%edx
  802c3c:	09 d8                	or     %ebx,%eax
  802c3e:	83 c4 1c             	add    $0x1c,%esp
  802c41:	5b                   	pop    %ebx
  802c42:	5e                   	pop    %esi
  802c43:	5f                   	pop    %edi
  802c44:	5d                   	pop    %ebp
  802c45:	c3                   	ret    
  802c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c4d:	8d 76 00             	lea    0x0(%esi),%esi
  802c50:	89 da                	mov    %ebx,%edx
  802c52:	29 fe                	sub    %edi,%esi
  802c54:	19 c2                	sbb    %eax,%edx
  802c56:	89 f1                	mov    %esi,%ecx
  802c58:	89 c8                	mov    %ecx,%eax
  802c5a:	e9 4b ff ff ff       	jmp    802baa <__umoddi3+0x8a>
