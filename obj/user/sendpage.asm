
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
  800039:	e8 83 13 00 00       	call   8013c1 <fork>
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
  80005c:	e8 36 0e 00 00       	call   800e97 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 40 80 00    	pushl  0x804004
  80006a:	e8 fd 09 00 00       	call   800a6c <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 40 80 00    	pushl  0x804004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 0f 0c 00 00       	call   800c95 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 25 16 00 00       	call   8016bc <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 a9 15 00 00       	call   801653 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 40 2c 80 00       	push   $0x802c40
  8000ba:	e8 87 02 00 00       	call   800346 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 40 80 00    	pushl  0x804000
  8000c8:	e8 9f 09 00 00       	call   800a6c <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 40 80 00    	pushl  0x804000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 95 0a 00 00       	call   800b76 <strncmp>
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
  8000fc:	e8 52 15 00 00       	call   801653 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 40 2c 80 00       	push   $0x802c40
  800111:	e8 30 02 00 00       	call   800346 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 40 80 00    	pushl  0x804004
  80011f:	e8 48 09 00 00       	call   800a6c <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 40 80 00    	pushl  0x804004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 3e 0a 00 00       	call   800b76 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 40 80 00    	pushl  0x804000
  800148:	e8 1f 09 00 00       	call   800a6c <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 40 80 00    	pushl  0x804000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 31 0b 00 00       	call   800c95 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 47 15 00 00       	call   8016bc <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 54 2c 80 00       	push   $0x802c54
  800185:	e8 bc 01 00 00       	call   800346 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 74 2c 80 00       	push   $0x802c74
  800197:	e8 aa 01 00 00       	call   800346 <cprintf>
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
  8001b7:	e8 9d 0c 00 00       	call   800e59 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80021b:	a1 08 50 80 00       	mov    0x805008,%eax
  800220:	8b 40 48             	mov    0x48(%eax),%eax
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	50                   	push   %eax
  800227:	68 e2 2c 80 00       	push   $0x802ce2
  80022c:	e8 15 01 00 00       	call   800346 <cprintf>
	cprintf("before umain\n");
  800231:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  800238:	e8 09 01 00 00       	call   800346 <cprintf>
	// call user main routine
	umain(argc, argv);
  80023d:	83 c4 08             	add    $0x8,%esp
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 e8 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80024b:	c7 04 24 0e 2d 80 00 	movl   $0x802d0e,(%esp)
  800252:	e8 ef 00 00 00       	call   800346 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800257:	a1 08 50 80 00       	mov    0x805008,%eax
  80025c:	8b 40 48             	mov    0x48(%eax),%eax
  80025f:	83 c4 08             	add    $0x8,%esp
  800262:	50                   	push   %eax
  800263:	68 1b 2d 80 00       	push   $0x802d1b
  800268:	e8 d9 00 00 00       	call   800346 <cprintf>
	// exit gracefully
	exit();
  80026d:	e8 0b 00 00 00       	call   80027d <exit>
}
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800283:	a1 08 50 80 00       	mov    0x805008,%eax
  800288:	8b 40 48             	mov    0x48(%eax),%eax
  80028b:	68 48 2d 80 00       	push   $0x802d48
  800290:	50                   	push   %eax
  800291:	68 3a 2d 80 00       	push   $0x802d3a
  800296:	e8 ab 00 00 00       	call   800346 <cprintf>
	close_all();
  80029b:	e8 87 16 00 00       	call   801927 <close_all>
	sys_env_destroy(0);
  8002a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a7:	e8 6c 0b 00 00       	call   800e18 <sys_env_destroy>
}
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bb:	8b 13                	mov    (%ebx),%edx
  8002bd:	8d 42 01             	lea    0x1(%edx),%eax
  8002c0:	89 03                	mov    %eax,(%ebx)
  8002c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ce:	74 09                	je     8002d9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	68 ff 00 00 00       	push   $0xff
  8002e1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 f1 0a 00 00       	call   800ddb <sys_cputs>
		b->idx = 0;
  8002ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	eb db                	jmp    8002d0 <putch+0x1f>

008002f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800305:	00 00 00 
	b.cnt = 0;
  800308:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800312:	ff 75 0c             	pushl  0xc(%ebp)
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031e:	50                   	push   %eax
  80031f:	68 b1 02 80 00       	push   $0x8002b1
  800324:	e8 4a 01 00 00       	call   800473 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800329:	83 c4 08             	add    $0x8,%esp
  80032c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800332:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800338:	50                   	push   %eax
  800339:	e8 9d 0a 00 00       	call   800ddb <sys_cputs>

	return b.cnt;
}
  80033e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034f:	50                   	push   %eax
  800350:	ff 75 08             	pushl  0x8(%ebp)
  800353:	e8 9d ff ff ff       	call   8002f5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 1c             	sub    $0x1c,%esp
  800363:	89 c6                	mov    %eax,%esi
  800365:	89 d7                	mov    %edx,%edi
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800370:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800379:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80037d:	74 2c                	je     8003ab <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80037f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800382:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800389:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800394:	73 43                	jae    8003d9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800396:	83 eb 01             	sub    $0x1,%ebx
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7e 6c                	jle    800409 <printnum+0xaf>
				putch(padc, putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	57                   	push   %edi
  8003a1:	ff 75 18             	pushl  0x18(%ebp)
  8003a4:	ff d6                	call   *%esi
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	eb eb                	jmp    800396 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003ab:	83 ec 0c             	sub    $0xc,%esp
  8003ae:	6a 20                	push   $0x20
  8003b0:	6a 00                	push   $0x0
  8003b2:	50                   	push   %eax
  8003b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b9:	89 fa                	mov    %edi,%edx
  8003bb:	89 f0                	mov    %esi,%eax
  8003bd:	e8 98 ff ff ff       	call   80035a <printnum>
		while (--width > 0)
  8003c2:	83 c4 20             	add    $0x20,%esp
  8003c5:	83 eb 01             	sub    $0x1,%ebx
  8003c8:	85 db                	test   %ebx,%ebx
  8003ca:	7e 65                	jle    800431 <printnum+0xd7>
			putch(padc, putdat);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	57                   	push   %edi
  8003d0:	6a 20                	push   $0x20
  8003d2:	ff d6                	call   *%esi
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb ec                	jmp    8003c5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	ff 75 18             	pushl  0x18(%ebp)
  8003df:	83 eb 01             	sub    $0x1,%ebx
  8003e2:	53                   	push   %ebx
  8003e3:	50                   	push   %eax
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f3:	e8 e8 25 00 00       	call   8029e0 <__udivdi3>
  8003f8:	83 c4 18             	add    $0x18,%esp
  8003fb:	52                   	push   %edx
  8003fc:	50                   	push   %eax
  8003fd:	89 fa                	mov    %edi,%edx
  8003ff:	89 f0                	mov    %esi,%eax
  800401:	e8 54 ff ff ff       	call   80035a <printnum>
  800406:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	57                   	push   %edi
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	ff 75 dc             	pushl  -0x24(%ebp)
  800413:	ff 75 d8             	pushl  -0x28(%ebp)
  800416:	ff 75 e4             	pushl  -0x1c(%ebp)
  800419:	ff 75 e0             	pushl  -0x20(%ebp)
  80041c:	e8 cf 26 00 00       	call   802af0 <__umoddi3>
  800421:	83 c4 14             	add    $0x14,%esp
  800424:	0f be 80 4d 2d 80 00 	movsbl 0x802d4d(%eax),%eax
  80042b:	50                   	push   %eax
  80042c:	ff d6                	call   *%esi
  80042e:	83 c4 10             	add    $0x10,%esp
	}
}
  800431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800434:	5b                   	pop    %ebx
  800435:	5e                   	pop    %esi
  800436:	5f                   	pop    %edi
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80043f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800443:	8b 10                	mov    (%eax),%edx
  800445:	3b 50 04             	cmp    0x4(%eax),%edx
  800448:	73 0a                	jae    800454 <sprintputch+0x1b>
		*b->buf++ = ch;
  80044a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80044d:	89 08                	mov    %ecx,(%eax)
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	88 02                	mov    %al,(%edx)
}
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <printfmt>:
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80045c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80045f:	50                   	push   %eax
  800460:	ff 75 10             	pushl  0x10(%ebp)
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	ff 75 08             	pushl  0x8(%ebp)
  800469:	e8 05 00 00 00       	call   800473 <vprintfmt>
}
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <vprintfmt>:
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	57                   	push   %edi
  800477:	56                   	push   %esi
  800478:	53                   	push   %ebx
  800479:	83 ec 3c             	sub    $0x3c,%esp
  80047c:	8b 75 08             	mov    0x8(%ebp),%esi
  80047f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800482:	8b 7d 10             	mov    0x10(%ebp),%edi
  800485:	e9 32 04 00 00       	jmp    8008bc <vprintfmt+0x449>
		padc = ' ';
  80048a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80048e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800495:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80049c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004aa:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8d 47 01             	lea    0x1(%edi),%eax
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	0f b6 17             	movzbl (%edi),%edx
  8004bf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c2:	3c 55                	cmp    $0x55,%al
  8004c4:	0f 87 12 05 00 00    	ja     8009dc <vprintfmt+0x569>
  8004ca:	0f b6 c0             	movzbl %al,%eax
  8004cd:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004d7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004db:	eb d9                	jmp    8004b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004e4:	eb d0                	jmp    8004b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	0f b6 d2             	movzbl %dl,%edx
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f4:	eb 03                	jmp    8004f9 <vprintfmt+0x86>
  8004f6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800500:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800503:	8d 72 d0             	lea    -0x30(%edx),%esi
  800506:	83 fe 09             	cmp    $0x9,%esi
  800509:	76 eb                	jbe    8004f6 <vprintfmt+0x83>
  80050b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050e:	8b 75 08             	mov    0x8(%ebp),%esi
  800511:	eb 14                	jmp    800527 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8d 40 04             	lea    0x4(%eax),%eax
  800521:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800524:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800527:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052b:	79 89                	jns    8004b6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80052d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800533:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053a:	e9 77 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
  80053f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800542:	85 c0                	test   %eax,%eax
  800544:	0f 48 c1             	cmovs  %ecx,%eax
  800547:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054d:	e9 64 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800555:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80055c:	e9 55 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
			lflag++;
  800561:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800568:	e9 49 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8d 78 04             	lea    0x4(%eax),%edi
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	ff 30                	pushl  (%eax)
  800579:	ff d6                	call   *%esi
			break;
  80057b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80057e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800581:	e9 33 03 00 00       	jmp    8008b9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8d 78 04             	lea    0x4(%eax),%edi
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	99                   	cltd   
  80058f:	31 d0                	xor    %edx,%eax
  800591:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800593:	83 f8 11             	cmp    $0x11,%eax
  800596:	7f 23                	jg     8005bb <vprintfmt+0x148>
  800598:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	74 18                	je     8005bb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a3:	52                   	push   %edx
  8005a4:	68 ad 32 80 00       	push   $0x8032ad
  8005a9:	53                   	push   %ebx
  8005aa:	56                   	push   %esi
  8005ab:	e8 a6 fe ff ff       	call   800456 <printfmt>
  8005b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b6:	e9 fe 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bb:	50                   	push   %eax
  8005bc:	68 65 2d 80 00       	push   $0x802d65
  8005c1:	53                   	push   %ebx
  8005c2:	56                   	push   %esi
  8005c3:	e8 8e fe ff ff       	call   800456 <printfmt>
  8005c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ce:	e9 e6 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	b8 5e 2d 80 00       	mov    $0x802d5e,%eax
  8005e8:	0f 45 c1             	cmovne %ecx,%eax
  8005eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f2:	7e 06                	jle    8005fa <vprintfmt+0x187>
  8005f4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005f8:	75 0d                	jne    800607 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005fd:	89 c7                	mov    %eax,%edi
  8005ff:	03 45 e0             	add    -0x20(%ebp),%eax
  800602:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800605:	eb 53                	jmp    80065a <vprintfmt+0x1e7>
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 d8             	pushl  -0x28(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 71 04 00 00       	call   800a84 <strnlen>
  800613:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800616:	29 c1                	sub    %eax,%ecx
  800618:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800620:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800627:	eb 0f                	jmp    800638 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	ff 75 e0             	pushl  -0x20(%ebp)
  800630:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800632:	83 ef 01             	sub    $0x1,%edi
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	85 ff                	test   %edi,%edi
  80063a:	7f ed                	jg     800629 <vprintfmt+0x1b6>
  80063c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	b8 00 00 00 00       	mov    $0x0,%eax
  800646:	0f 49 c1             	cmovns %ecx,%eax
  800649:	29 c1                	sub    %eax,%ecx
  80064b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80064e:	eb aa                	jmp    8005fa <vprintfmt+0x187>
					putch(ch, putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	52                   	push   %edx
  800655:	ff d6                	call   *%esi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065f:	83 c7 01             	add    $0x1,%edi
  800662:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800666:	0f be d0             	movsbl %al,%edx
  800669:	85 d2                	test   %edx,%edx
  80066b:	74 4b                	je     8006b8 <vprintfmt+0x245>
  80066d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800671:	78 06                	js     800679 <vprintfmt+0x206>
  800673:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800677:	78 1e                	js     800697 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800679:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80067d:	74 d1                	je     800650 <vprintfmt+0x1dd>
  80067f:	0f be c0             	movsbl %al,%eax
  800682:	83 e8 20             	sub    $0x20,%eax
  800685:	83 f8 5e             	cmp    $0x5e,%eax
  800688:	76 c6                	jbe    800650 <vprintfmt+0x1dd>
					putch('?', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 3f                	push   $0x3f
  800690:	ff d6                	call   *%esi
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	eb c3                	jmp    80065a <vprintfmt+0x1e7>
  800697:	89 cf                	mov    %ecx,%edi
  800699:	eb 0e                	jmp    8006a9 <vprintfmt+0x236>
				putch(' ', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 20                	push   $0x20
  8006a1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a3:	83 ef 01             	sub    $0x1,%edi
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	85 ff                	test   %edi,%edi
  8006ab:	7f ee                	jg     80069b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b3:	e9 01 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
  8006b8:	89 cf                	mov    %ecx,%edi
  8006ba:	eb ed                	jmp    8006a9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006bf:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006c6:	e9 eb fd ff ff       	jmp    8004b6 <vprintfmt+0x43>
	if (lflag >= 2)
  8006cb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006cf:	7f 21                	jg     8006f2 <vprintfmt+0x27f>
	else if (lflag)
  8006d1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d5:	74 68                	je     80073f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006df:	89 c1                	mov    %eax,%ecx
  8006e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb 17                	jmp    800709 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800715:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800719:	78 3f                	js     80075a <vprintfmt+0x2e7>
			base = 10;
  80071b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800720:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800724:	0f 84 71 01 00 00    	je     80089b <vprintfmt+0x428>
				putch('+', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 2b                	push   $0x2b
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	e9 5c 01 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800747:	89 c1                	mov    %eax,%ecx
  800749:	c1 f9 1f             	sar    $0x1f,%ecx
  80074c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	eb af                	jmp    800709 <vprintfmt+0x296>
				putch('-', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 2d                	push   $0x2d
  800760:	ff d6                	call   *%esi
				num = -(long long) num;
  800762:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800768:	f7 d8                	neg    %eax
  80076a:	83 d2 00             	adc    $0x0,%edx
  80076d:	f7 da                	neg    %edx
  80076f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800772:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800778:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077d:	e9 19 01 00 00       	jmp    80089b <vprintfmt+0x428>
	if (lflag >= 2)
  800782:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800786:	7f 29                	jg     8007b1 <vprintfmt+0x33e>
	else if (lflag)
  800788:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078c:	74 44                	je     8007d2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	ba 00 00 00 00       	mov    $0x0,%edx
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ac:	e9 ea 00 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 08             	lea    0x8(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 c9 00 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 a6 00 00 00       	jmp    80089b <vprintfmt+0x428>
			putch('0', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 30                	push   $0x30
  8007fb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800804:	7f 26                	jg     80082c <vprintfmt+0x3b9>
	else if (lflag)
  800806:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080a:	74 3e                	je     80084a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800825:	b8 08 00 00 00       	mov    $0x8,%eax
  80082a:	eb 6f                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 50 04             	mov    0x4(%eax),%edx
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800837:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8d 40 08             	lea    0x8(%eax),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800843:	b8 08 00 00 00       	mov    $0x8,%eax
  800848:	eb 51                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	ba 00 00 00 00       	mov    $0x0,%edx
  800854:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800857:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8d 40 04             	lea    0x4(%eax),%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800863:	b8 08 00 00 00       	mov    $0x8,%eax
  800868:	eb 31                	jmp    80089b <vprintfmt+0x428>
			putch('0', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	53                   	push   %ebx
  80086e:	6a 30                	push   $0x30
  800870:	ff d6                	call   *%esi
			putch('x', putdat);
  800872:	83 c4 08             	add    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 78                	push   $0x78
  800878:	ff d6                	call   *%esi
			num = (unsigned long long)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80088a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800896:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80089b:	83 ec 0c             	sub    $0xc,%esp
  80089e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008a2:	52                   	push   %edx
  8008a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ad:	89 da                	mov    %ebx,%edx
  8008af:	89 f0                	mov    %esi,%eax
  8008b1:	e8 a4 fa ff ff       	call   80035a <printnum>
			break;
  8008b6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008bc:	83 c7 01             	add    $0x1,%edi
  8008bf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008c3:	83 f8 25             	cmp    $0x25,%eax
  8008c6:	0f 84 be fb ff ff    	je     80048a <vprintfmt+0x17>
			if (ch == '\0')
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	0f 84 28 01 00 00    	je     8009fc <vprintfmt+0x589>
			putch(ch, putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	50                   	push   %eax
  8008d9:	ff d6                	call   *%esi
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	eb dc                	jmp    8008bc <vprintfmt+0x449>
	if (lflag >= 2)
  8008e0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008e4:	7f 26                	jg     80090c <vprintfmt+0x499>
	else if (lflag)
  8008e6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ea:	74 41                	je     80092d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8d 40 04             	lea    0x4(%eax),%eax
  800902:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800905:	b8 10 00 00 00       	mov    $0x10,%eax
  80090a:	eb 8f                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 50 04             	mov    0x4(%eax),%edx
  800912:	8b 00                	mov    (%eax),%eax
  800914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
  800928:	e9 6e ff ff ff       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	ba 00 00 00 00       	mov    $0x0,%edx
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 04             	lea    0x4(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800946:	b8 10 00 00 00       	mov    $0x10,%eax
  80094b:	e9 4b ff ff ff       	jmp    80089b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	83 c0 04             	add    $0x4,%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	85 c0                	test   %eax,%eax
  800960:	74 14                	je     800976 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800962:	8b 13                	mov    (%ebx),%edx
  800964:	83 fa 7f             	cmp    $0x7f,%edx
  800967:	7f 37                	jg     8009a0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800969:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80096b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
  800971:	e9 43 ff ff ff       	jmp    8008b9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800976:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097b:	bf 81 2e 80 00       	mov    $0x802e81,%edi
							putch(ch, putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	53                   	push   %ebx
  800984:	50                   	push   %eax
  800985:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800987:	83 c7 01             	add    $0x1,%edi
  80098a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	85 c0                	test   %eax,%eax
  800993:	75 eb                	jne    800980 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800995:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800998:	89 45 14             	mov    %eax,0x14(%ebp)
  80099b:	e9 19 ff ff ff       	jmp    8008b9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009a0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a7:	bf b9 2e 80 00       	mov    $0x802eb9,%edi
							putch(ch, putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	53                   	push   %ebx
  8009b0:	50                   	push   %eax
  8009b1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b3:	83 c7 01             	add    $0x1,%edi
  8009b6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	75 eb                	jne    8009ac <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c7:	e9 ed fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
			putch(ch, putdat);
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	53                   	push   %ebx
  8009d0:	6a 25                	push   $0x25
  8009d2:	ff d6                	call   *%esi
			break;
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	e9 dd fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
			putch('%', putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	53                   	push   %ebx
  8009e0:	6a 25                	push   $0x25
  8009e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e4:	83 c4 10             	add    $0x10,%esp
  8009e7:	89 f8                	mov    %edi,%eax
  8009e9:	eb 03                	jmp    8009ee <vprintfmt+0x57b>
  8009eb:	83 e8 01             	sub    $0x1,%eax
  8009ee:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f2:	75 f7                	jne    8009eb <vprintfmt+0x578>
  8009f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f7:	e9 bd fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
}
  8009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a13:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a17:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a21:	85 c0                	test   %eax,%eax
  800a23:	74 26                	je     800a4b <vsnprintf+0x47>
  800a25:	85 d2                	test   %edx,%edx
  800a27:	7e 22                	jle    800a4b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a29:	ff 75 14             	pushl  0x14(%ebp)
  800a2c:	ff 75 10             	pushl  0x10(%ebp)
  800a2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a32:	50                   	push   %eax
  800a33:	68 39 04 80 00       	push   $0x800439
  800a38:	e8 36 fa ff ff       	call   800473 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a40:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a46:	83 c4 10             	add    $0x10,%esp
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    
		return -E_INVAL;
  800a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a50:	eb f7                	jmp    800a49 <vsnprintf+0x45>

00800a52 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a5b:	50                   	push   %eax
  800a5c:	ff 75 10             	pushl  0x10(%ebp)
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	ff 75 08             	pushl  0x8(%ebp)
  800a65:	e8 9a ff ff ff       	call   800a04 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a7b:	74 05                	je     800a82 <strlen+0x16>
		n++;
  800a7d:	83 c0 01             	add    $0x1,%eax
  800a80:	eb f5                	jmp    800a77 <strlen+0xb>
	return n;
}
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	39 c2                	cmp    %eax,%edx
  800a94:	74 0d                	je     800aa3 <strnlen+0x1f>
  800a96:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a9a:	74 05                	je     800aa1 <strnlen+0x1d>
		n++;
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	eb f1                	jmp    800a92 <strnlen+0xe>
  800aa1:	89 d0                	mov    %edx,%eax
	return n;
}
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	53                   	push   %ebx
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ab8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800abb:	83 c2 01             	add    $0x1,%edx
  800abe:	84 c9                	test   %cl,%cl
  800ac0:	75 f2                	jne    800ab4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	53                   	push   %ebx
  800ac9:	83 ec 10             	sub    $0x10,%esp
  800acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800acf:	53                   	push   %ebx
  800ad0:	e8 97 ff ff ff       	call   800a6c <strlen>
  800ad5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	01 d8                	add    %ebx,%eax
  800add:	50                   	push   %eax
  800ade:	e8 c2 ff ff ff       	call   800aa5 <strcpy>
	return dst;
}
  800ae3:	89 d8                	mov    %ebx,%eax
  800ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af5:	89 c6                	mov    %eax,%esi
  800af7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	39 f2                	cmp    %esi,%edx
  800afe:	74 11                	je     800b11 <strncpy+0x27>
		*dst++ = *src;
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	0f b6 19             	movzbl (%ecx),%ebx
  800b06:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b09:	80 fb 01             	cmp    $0x1,%bl
  800b0c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b0f:	eb eb                	jmp    800afc <strncpy+0x12>
	}
	return ret;
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b20:	8b 55 10             	mov    0x10(%ebp),%edx
  800b23:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b25:	85 d2                	test   %edx,%edx
  800b27:	74 21                	je     800b4a <strlcpy+0x35>
  800b29:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b2d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	74 14                	je     800b47 <strlcpy+0x32>
  800b33:	0f b6 19             	movzbl (%ecx),%ebx
  800b36:	84 db                	test   %bl,%bl
  800b38:	74 0b                	je     800b45 <strlcpy+0x30>
			*dst++ = *src++;
  800b3a:	83 c1 01             	add    $0x1,%ecx
  800b3d:	83 c2 01             	add    $0x1,%edx
  800b40:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b43:	eb ea                	jmp    800b2f <strlcpy+0x1a>
  800b45:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4a:	29 f0                	sub    %esi,%eax
}
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	84 c0                	test   %al,%al
  800b5e:	74 0c                	je     800b6c <strcmp+0x1c>
  800b60:	3a 02                	cmp    (%edx),%al
  800b62:	75 08                	jne    800b6c <strcmp+0x1c>
		p++, q++;
  800b64:	83 c1 01             	add    $0x1,%ecx
  800b67:	83 c2 01             	add    $0x1,%edx
  800b6a:	eb ed                	jmp    800b59 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6c:	0f b6 c0             	movzbl %al,%eax
  800b6f:	0f b6 12             	movzbl (%edx),%edx
  800b72:	29 d0                	sub    %edx,%eax
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	53                   	push   %ebx
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	89 c3                	mov    %eax,%ebx
  800b82:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b85:	eb 06                	jmp    800b8d <strncmp+0x17>
		n--, p++, q++;
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b8d:	39 d8                	cmp    %ebx,%eax
  800b8f:	74 16                	je     800ba7 <strncmp+0x31>
  800b91:	0f b6 08             	movzbl (%eax),%ecx
  800b94:	84 c9                	test   %cl,%cl
  800b96:	74 04                	je     800b9c <strncmp+0x26>
  800b98:	3a 0a                	cmp    (%edx),%cl
  800b9a:	74 eb                	je     800b87 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9c:	0f b6 00             	movzbl (%eax),%eax
  800b9f:	0f b6 12             	movzbl (%edx),%edx
  800ba2:	29 d0                	sub    %edx,%eax
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    
		return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	eb f6                	jmp    800ba4 <strncmp+0x2e>

00800bae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb8:	0f b6 10             	movzbl (%eax),%edx
  800bbb:	84 d2                	test   %dl,%dl
  800bbd:	74 09                	je     800bc8 <strchr+0x1a>
		if (*s == c)
  800bbf:	38 ca                	cmp    %cl,%dl
  800bc1:	74 0a                	je     800bcd <strchr+0x1f>
	for (; *s; s++)
  800bc3:	83 c0 01             	add    $0x1,%eax
  800bc6:	eb f0                	jmp    800bb8 <strchr+0xa>
			return (char *) s;
	return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bdc:	38 ca                	cmp    %cl,%dl
  800bde:	74 09                	je     800be9 <strfind+0x1a>
  800be0:	84 d2                	test   %dl,%dl
  800be2:	74 05                	je     800be9 <strfind+0x1a>
	for (; *s; s++)
  800be4:	83 c0 01             	add    $0x1,%eax
  800be7:	eb f0                	jmp    800bd9 <strfind+0xa>
			break;
	return (char *) s;
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf7:	85 c9                	test   %ecx,%ecx
  800bf9:	74 31                	je     800c2c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfb:	89 f8                	mov    %edi,%eax
  800bfd:	09 c8                	or     %ecx,%eax
  800bff:	a8 03                	test   $0x3,%al
  800c01:	75 23                	jne    800c26 <memset+0x3b>
		c &= 0xFF;
  800c03:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c07:	89 d3                	mov    %edx,%ebx
  800c09:	c1 e3 08             	shl    $0x8,%ebx
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	c1 e0 18             	shl    $0x18,%eax
  800c11:	89 d6                	mov    %edx,%esi
  800c13:	c1 e6 10             	shl    $0x10,%esi
  800c16:	09 f0                	or     %esi,%eax
  800c18:	09 c2                	or     %eax,%edx
  800c1a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c1f:	89 d0                	mov    %edx,%eax
  800c21:	fc                   	cld    
  800c22:	f3 ab                	rep stos %eax,%es:(%edi)
  800c24:	eb 06                	jmp    800c2c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	fc                   	cld    
  800c2a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2c:	89 f8                	mov    %edi,%eax
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c41:	39 c6                	cmp    %eax,%esi
  800c43:	73 32                	jae    800c77 <memmove+0x44>
  800c45:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c48:	39 c2                	cmp    %eax,%edx
  800c4a:	76 2b                	jbe    800c77 <memmove+0x44>
		s += n;
		d += n;
  800c4c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4f:	89 fe                	mov    %edi,%esi
  800c51:	09 ce                	or     %ecx,%esi
  800c53:	09 d6                	or     %edx,%esi
  800c55:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5b:	75 0e                	jne    800c6b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c5d:	83 ef 04             	sub    $0x4,%edi
  800c60:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c63:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c66:	fd                   	std    
  800c67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c69:	eb 09                	jmp    800c74 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6b:	83 ef 01             	sub    $0x1,%edi
  800c6e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c71:	fd                   	std    
  800c72:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c74:	fc                   	cld    
  800c75:	eb 1a                	jmp    800c91 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c77:	89 c2                	mov    %eax,%edx
  800c79:	09 ca                	or     %ecx,%edx
  800c7b:	09 f2                	or     %esi,%edx
  800c7d:	f6 c2 03             	test   $0x3,%dl
  800c80:	75 0a                	jne    800c8c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c82:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c85:	89 c7                	mov    %eax,%edi
  800c87:	fc                   	cld    
  800c88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8a:	eb 05                	jmp    800c91 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c9b:	ff 75 10             	pushl  0x10(%ebp)
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 8a ff ff ff       	call   800c33 <memmove>
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb6:	89 c6                	mov    %eax,%esi
  800cb8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbb:	39 f0                	cmp    %esi,%eax
  800cbd:	74 1c                	je     800cdb <memcmp+0x30>
		if (*s1 != *s2)
  800cbf:	0f b6 08             	movzbl (%eax),%ecx
  800cc2:	0f b6 1a             	movzbl (%edx),%ebx
  800cc5:	38 d9                	cmp    %bl,%cl
  800cc7:	75 08                	jne    800cd1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cc9:	83 c0 01             	add    $0x1,%eax
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	eb ea                	jmp    800cbb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd1:	0f b6 c1             	movzbl %cl,%eax
  800cd4:	0f b6 db             	movzbl %bl,%ebx
  800cd7:	29 d8                	sub    %ebx,%eax
  800cd9:	eb 05                	jmp    800ce0 <memcmp+0x35>
	}

	return 0;
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ced:	89 c2                	mov    %eax,%edx
  800cef:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf2:	39 d0                	cmp    %edx,%eax
  800cf4:	73 09                	jae    800cff <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf6:	38 08                	cmp    %cl,(%eax)
  800cf8:	74 05                	je     800cff <memfind+0x1b>
	for (; s < ends; s++)
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	eb f3                	jmp    800cf2 <memfind+0xe>
			break;
	return (void *) s;
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0d:	eb 03                	jmp    800d12 <strtol+0x11>
		s++;
  800d0f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d12:	0f b6 01             	movzbl (%ecx),%eax
  800d15:	3c 20                	cmp    $0x20,%al
  800d17:	74 f6                	je     800d0f <strtol+0xe>
  800d19:	3c 09                	cmp    $0x9,%al
  800d1b:	74 f2                	je     800d0f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d1d:	3c 2b                	cmp    $0x2b,%al
  800d1f:	74 2a                	je     800d4b <strtol+0x4a>
	int neg = 0;
  800d21:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d26:	3c 2d                	cmp    $0x2d,%al
  800d28:	74 2b                	je     800d55 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d30:	75 0f                	jne    800d41 <strtol+0x40>
  800d32:	80 39 30             	cmpb   $0x30,(%ecx)
  800d35:	74 28                	je     800d5f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d37:	85 db                	test   %ebx,%ebx
  800d39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3e:	0f 44 d8             	cmove  %eax,%ebx
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
  800d46:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d49:	eb 50                	jmp    800d9b <strtol+0x9a>
		s++;
  800d4b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d53:	eb d5                	jmp    800d2a <strtol+0x29>
		s++, neg = 1;
  800d55:	83 c1 01             	add    $0x1,%ecx
  800d58:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5d:	eb cb                	jmp    800d2a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d5f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d63:	74 0e                	je     800d73 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d65:	85 db                	test   %ebx,%ebx
  800d67:	75 d8                	jne    800d41 <strtol+0x40>
		s++, base = 8;
  800d69:	83 c1 01             	add    $0x1,%ecx
  800d6c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d71:	eb ce                	jmp    800d41 <strtol+0x40>
		s += 2, base = 16;
  800d73:	83 c1 02             	add    $0x2,%ecx
  800d76:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7b:	eb c4                	jmp    800d41 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d7d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d80:	89 f3                	mov    %esi,%ebx
  800d82:	80 fb 19             	cmp    $0x19,%bl
  800d85:	77 29                	ja     800db0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d87:	0f be d2             	movsbl %dl,%edx
  800d8a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d90:	7d 30                	jge    800dc2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d92:	83 c1 01             	add    $0x1,%ecx
  800d95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d99:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d9b:	0f b6 11             	movzbl (%ecx),%edx
  800d9e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da1:	89 f3                	mov    %esi,%ebx
  800da3:	80 fb 09             	cmp    $0x9,%bl
  800da6:	77 d5                	ja     800d7d <strtol+0x7c>
			dig = *s - '0';
  800da8:	0f be d2             	movsbl %dl,%edx
  800dab:	83 ea 30             	sub    $0x30,%edx
  800dae:	eb dd                	jmp    800d8d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db3:	89 f3                	mov    %esi,%ebx
  800db5:	80 fb 19             	cmp    $0x19,%bl
  800db8:	77 08                	ja     800dc2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dba:	0f be d2             	movsbl %dl,%edx
  800dbd:	83 ea 37             	sub    $0x37,%edx
  800dc0:	eb cb                	jmp    800d8d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc6:	74 05                	je     800dcd <strtol+0xcc>
		*endptr = (char *) s;
  800dc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	f7 da                	neg    %edx
  800dd1:	85 ff                	test   %edi,%edi
  800dd3:	0f 45 c2             	cmovne %edx,%eax
}
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	89 c3                	mov    %eax,%ebx
  800dee:	89 c7                	mov    %eax,%edi
  800df0:	89 c6                	mov    %eax,%esi
  800df2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	b8 01 00 00 00       	mov    $0x1,%eax
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 d3                	mov    %edx,%ebx
  800e0d:	89 d7                	mov    %edx,%edi
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	b8 03 00 00 00       	mov    $0x3,%eax
  800e2e:	89 cb                	mov    %ecx,%ebx
  800e30:	89 cf                	mov    %ecx,%edi
  800e32:	89 ce                	mov    %ecx,%esi
  800e34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7f 08                	jg     800e42 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	50                   	push   %eax
  800e46:	6a 03                	push   $0x3
  800e48:	68 c8 30 80 00       	push   $0x8030c8
  800e4d:	6a 43                	push   $0x43
  800e4f:	68 e5 30 80 00       	push   $0x8030e5
  800e54:	e8 4c 1a 00 00       	call   8028a5 <_panic>

00800e59 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e64:	b8 02 00 00 00       	mov    $0x2,%eax
  800e69:	89 d1                	mov    %edx,%ecx
  800e6b:	89 d3                	mov    %edx,%ebx
  800e6d:	89 d7                	mov    %edx,%edi
  800e6f:	89 d6                	mov    %edx,%esi
  800e71:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_yield>:

void
sys_yield(void)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e88:	89 d1                	mov    %edx,%ecx
  800e8a:	89 d3                	mov    %edx,%ebx
  800e8c:	89 d7                	mov    %edx,%edi
  800e8e:	89 d6                	mov    %edx,%esi
  800e90:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea0:	be 00 00 00 00       	mov    $0x0,%esi
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb3:	89 f7                	mov    %esi,%edi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 04                	push   $0x4
  800ec9:	68 c8 30 80 00       	push   $0x8030c8
  800ece:	6a 43                	push   $0x43
  800ed0:	68 e5 30 80 00       	push   $0x8030e5
  800ed5:	e8 cb 19 00 00       	call   8028a5 <_panic>

00800eda <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	b8 05 00 00 00       	mov    $0x5,%eax
  800eee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 05                	push   $0x5
  800f0b:	68 c8 30 80 00       	push   $0x8030c8
  800f10:	6a 43                	push   $0x43
  800f12:	68 e5 30 80 00       	push   $0x8030e5
  800f17:	e8 89 19 00 00       	call   8028a5 <_panic>

00800f1c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 06 00 00 00       	mov    $0x6,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7f 08                	jg     800f47 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	6a 06                	push   $0x6
  800f4d:	68 c8 30 80 00       	push   $0x8030c8
  800f52:	6a 43                	push   $0x43
  800f54:	68 e5 30 80 00       	push   $0x8030e5
  800f59:	e8 47 19 00 00       	call   8028a5 <_panic>

00800f5e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 08 00 00 00       	mov    $0x8,%eax
  800f77:	89 df                	mov    %ebx,%edi
  800f79:	89 de                	mov    %ebx,%esi
  800f7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	7f 08                	jg     800f89 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	50                   	push   %eax
  800f8d:	6a 08                	push   $0x8
  800f8f:	68 c8 30 80 00       	push   $0x8030c8
  800f94:	6a 43                	push   $0x43
  800f96:	68 e5 30 80 00       	push   $0x8030e5
  800f9b:	e8 05 19 00 00       	call   8028a5 <_panic>

00800fa0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb9:	89 df                	mov    %ebx,%edi
  800fbb:	89 de                	mov    %ebx,%esi
  800fbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	7f 08                	jg     800fcb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	50                   	push   %eax
  800fcf:	6a 09                	push   $0x9
  800fd1:	68 c8 30 80 00       	push   $0x8030c8
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 e5 30 80 00       	push   $0x8030e5
  800fdd:	e8 c3 18 00 00       	call   8028a5 <_panic>

00800fe2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800feb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffb:	89 df                	mov    %ebx,%edi
  800ffd:	89 de                	mov    %ebx,%esi
  800fff:	cd 30                	int    $0x30
	if(check && ret > 0)
  801001:	85 c0                	test   %eax,%eax
  801003:	7f 08                	jg     80100d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801005:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	50                   	push   %eax
  801011:	6a 0a                	push   $0xa
  801013:	68 c8 30 80 00       	push   $0x8030c8
  801018:	6a 43                	push   $0x43
  80101a:	68 e5 30 80 00       	push   $0x8030e5
  80101f:	e8 81 18 00 00       	call   8028a5 <_panic>

00801024 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	57                   	push   %edi
  801028:	56                   	push   %esi
  801029:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	b8 0c 00 00 00       	mov    $0xc,%eax
  801035:	be 00 00 00 00       	mov    $0x0,%esi
  80103a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801040:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801042:	5b                   	pop    %ebx
  801043:	5e                   	pop    %esi
  801044:	5f                   	pop    %edi
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801050:	b9 00 00 00 00       	mov    $0x0,%ecx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105d:	89 cb                	mov    %ecx,%ebx
  80105f:	89 cf                	mov    %ecx,%edi
  801061:	89 ce                	mov    %ecx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 0d                	push   $0xd
  801077:	68 c8 30 80 00       	push   $0x8030c8
  80107c:	6a 43                	push   $0x43
  80107e:	68 e5 30 80 00       	push   $0x8030e5
  801083:	e8 1d 18 00 00       	call   8028a5 <_panic>

00801088 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	57                   	push   %edi
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010bc:	89 cb                	mov    %ecx,%ebx
  8010be:	89 cf                	mov    %ecx,%edi
  8010c0:	89 ce                	mov    %ecx,%esi
  8010c2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8010d9:	89 d1                	mov    %edx,%ecx
  8010db:	89 d3                	mov    %edx,%ebx
  8010dd:	89 d7                	mov    %edx,%edi
  8010df:	89 d6                	mov    %edx,%esi
  8010e1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5f                   	pop    %edi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	57                   	push   %edi
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f9:	b8 11 00 00 00       	mov    $0x11,%eax
  8010fe:	89 df                	mov    %ebx,%edi
  801100:	89 de                	mov    %ebx,%esi
  801102:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801114:	8b 55 08             	mov    0x8(%ebp),%edx
  801117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111a:	b8 12 00 00 00       	mov    $0x12,%eax
  80111f:	89 df                	mov    %ebx,%edi
  801121:	89 de                	mov    %ebx,%esi
  801123:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113e:	b8 13 00 00 00       	mov    $0x13,%eax
  801143:	89 df                	mov    %ebx,%edi
  801145:	89 de                	mov    %ebx,%esi
  801147:	cd 30                	int    $0x30
	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7f 08                	jg     801155 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	50                   	push   %eax
  801159:	6a 13                	push   $0x13
  80115b:	68 c8 30 80 00       	push   $0x8030c8
  801160:	6a 43                	push   $0x43
  801162:	68 e5 30 80 00       	push   $0x8030e5
  801167:	e8 39 17 00 00       	call   8028a5 <_panic>

0080116c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	53                   	push   %ebx
  801170:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801173:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80117a:	f6 c5 04             	test   $0x4,%ch
  80117d:	75 45                	jne    8011c4 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80117f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801186:	83 e1 07             	and    $0x7,%ecx
  801189:	83 f9 07             	cmp    $0x7,%ecx
  80118c:	74 6f                	je     8011fd <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80118e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801195:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80119b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011a1:	0f 84 b6 00 00 00    	je     80125d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011a7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ae:	83 e1 05             	and    $0x5,%ecx
  8011b1:	83 f9 05             	cmp    $0x5,%ecx
  8011b4:	0f 84 d7 00 00 00    	je     801291 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cb:	c1 e2 0c             	shl    $0xc,%edx
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011d7:	51                   	push   %ecx
  8011d8:	52                   	push   %edx
  8011d9:	50                   	push   %eax
  8011da:	52                   	push   %edx
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 f8 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8011e2:	83 c4 20             	add    $0x20,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 d1                	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	68 f3 30 80 00       	push   $0x8030f3
  8011f1:	6a 54                	push   $0x54
  8011f3:	68 09 31 80 00       	push   $0x803109
  8011f8:	e8 a8 16 00 00       	call   8028a5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011fd:	89 d3                	mov    %edx,%ebx
  8011ff:	c1 e3 0c             	shl    $0xc,%ebx
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	68 05 08 00 00       	push   $0x805
  80120a:	53                   	push   %ebx
  80120b:	50                   	push   %eax
  80120c:	53                   	push   %ebx
  80120d:	6a 00                	push   $0x0
  80120f:	e8 c6 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801214:	83 c4 20             	add    $0x20,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 2e                	js     801249 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	68 05 08 00 00       	push   $0x805
  801223:	53                   	push   %ebx
  801224:	6a 00                	push   $0x0
  801226:	53                   	push   %ebx
  801227:	6a 00                	push   $0x0
  801229:	e8 ac fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  80122e:	83 c4 20             	add    $0x20,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	79 85                	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	68 f3 30 80 00       	push   $0x8030f3
  80123d:	6a 5f                	push   $0x5f
  80123f:	68 09 31 80 00       	push   $0x803109
  801244:	e8 5c 16 00 00       	call   8028a5 <_panic>
			panic("sys_page_map() panic\n");
  801249:	83 ec 04             	sub    $0x4,%esp
  80124c:	68 f3 30 80 00       	push   $0x8030f3
  801251:	6a 5b                	push   $0x5b
  801253:	68 09 31 80 00       	push   $0x803109
  801258:	e8 48 16 00 00       	call   8028a5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80125d:	c1 e2 0c             	shl    $0xc,%edx
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	68 05 08 00 00       	push   $0x805
  801268:	52                   	push   %edx
  801269:	50                   	push   %eax
  80126a:	52                   	push   %edx
  80126b:	6a 00                	push   $0x0
  80126d:	e8 68 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801272:	83 c4 20             	add    $0x20,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	0f 89 3d ff ff ff    	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80127d:	83 ec 04             	sub    $0x4,%esp
  801280:	68 f3 30 80 00       	push   $0x8030f3
  801285:	6a 66                	push   $0x66
  801287:	68 09 31 80 00       	push   $0x803109
  80128c:	e8 14 16 00 00       	call   8028a5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801291:	c1 e2 0c             	shl    $0xc,%edx
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	6a 05                	push   $0x5
  801299:	52                   	push   %edx
  80129a:	50                   	push   %eax
  80129b:	52                   	push   %edx
  80129c:	6a 00                	push   $0x0
  80129e:	e8 37 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8012a3:	83 c4 20             	add    $0x20,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	0f 89 0c ff ff ff    	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	68 f3 30 80 00       	push   $0x8030f3
  8012b6:	6a 6d                	push   $0x6d
  8012b8:	68 09 31 80 00       	push   $0x803109
  8012bd:	e8 e3 15 00 00       	call   8028a5 <_panic>

008012c2 <pgfault>:
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012cc:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ce:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012d2:	0f 84 99 00 00 00    	je     801371 <pgfault+0xaf>
  8012d8:	89 c2                	mov    %eax,%edx
  8012da:	c1 ea 16             	shr    $0x16,%edx
  8012dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e4:	f6 c2 01             	test   $0x1,%dl
  8012e7:	0f 84 84 00 00 00    	je     801371 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	c1 ea 0c             	shr    $0xc,%edx
  8012f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ff:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801305:	75 6a                	jne    801371 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801307:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80130c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	6a 07                	push   $0x7
  801313:	68 00 f0 7f 00       	push   $0x7ff000
  801318:	6a 00                	push   $0x0
  80131a:	e8 78 fb ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	78 5f                	js     801385 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	68 00 10 00 00       	push   $0x1000
  80132e:	53                   	push   %ebx
  80132f:	68 00 f0 7f 00       	push   $0x7ff000
  801334:	e8 5c f9 ff ff       	call   800c95 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801339:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801340:	53                   	push   %ebx
  801341:	6a 00                	push   $0x0
  801343:	68 00 f0 7f 00       	push   $0x7ff000
  801348:	6a 00                	push   $0x0
  80134a:	e8 8b fb ff ff       	call   800eda <sys_page_map>
	if(ret < 0)
  80134f:	83 c4 20             	add    $0x20,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 43                	js     801399 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801356:	83 ec 08             	sub    $0x8,%esp
  801359:	68 00 f0 7f 00       	push   $0x7ff000
  80135e:	6a 00                	push   $0x0
  801360:	e8 b7 fb ff ff       	call   800f1c <sys_page_unmap>
	if(ret < 0)
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	78 41                	js     8013ad <pgfault+0xeb>
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
		panic("panic at pgfault()\n");
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	68 14 31 80 00       	push   $0x803114
  801379:	6a 26                	push   $0x26
  80137b:	68 09 31 80 00       	push   $0x803109
  801380:	e8 20 15 00 00       	call   8028a5 <_panic>
		panic("panic in sys_page_alloc()\n");
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 28 31 80 00       	push   $0x803128
  80138d:	6a 31                	push   $0x31
  80138f:	68 09 31 80 00       	push   $0x803109
  801394:	e8 0c 15 00 00       	call   8028a5 <_panic>
		panic("panic in sys_page_map()\n");
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	68 43 31 80 00       	push   $0x803143
  8013a1:	6a 36                	push   $0x36
  8013a3:	68 09 31 80 00       	push   $0x803109
  8013a8:	e8 f8 14 00 00       	call   8028a5 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 5c 31 80 00       	push   $0x80315c
  8013b5:	6a 39                	push   $0x39
  8013b7:	68 09 31 80 00       	push   $0x803109
  8013bc:	e8 e4 14 00 00       	call   8028a5 <_panic>

008013c1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	57                   	push   %edi
  8013c5:	56                   	push   %esi
  8013c6:	53                   	push   %ebx
  8013c7:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013ca:	68 c2 12 80 00       	push   $0x8012c2
  8013cf:	e8 32 15 00 00       	call   802906 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013d4:	b8 07 00 00 00       	mov    $0x7,%eax
  8013d9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 27                	js     801409 <fork+0x48>
  8013e2:	89 c6                	mov    %eax,%esi
  8013e4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013e6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013eb:	75 48                	jne    801435 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013ed:	e8 67 fa ff ff       	call   800e59 <sys_getenvid>
  8013f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013f7:	c1 e0 07             	shl    $0x7,%eax
  8013fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ff:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801404:	e9 90 00 00 00       	jmp    801499 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	68 78 31 80 00       	push   $0x803178
  801411:	68 8c 00 00 00       	push   $0x8c
  801416:	68 09 31 80 00       	push   $0x803109
  80141b:	e8 85 14 00 00       	call   8028a5 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801420:	89 f8                	mov    %edi,%eax
  801422:	e8 45 fd ff ff       	call   80116c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80142d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801433:	74 26                	je     80145b <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801435:	89 d8                	mov    %ebx,%eax
  801437:	c1 e8 16             	shr    $0x16,%eax
  80143a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801441:	a8 01                	test   $0x1,%al
  801443:	74 e2                	je     801427 <fork+0x66>
  801445:	89 da                	mov    %ebx,%edx
  801447:	c1 ea 0c             	shr    $0xc,%edx
  80144a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801451:	83 e0 05             	and    $0x5,%eax
  801454:	83 f8 05             	cmp    $0x5,%eax
  801457:	75 ce                	jne    801427 <fork+0x66>
  801459:	eb c5                	jmp    801420 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	6a 07                	push   $0x7
  801460:	68 00 f0 bf ee       	push   $0xeebff000
  801465:	56                   	push   %esi
  801466:	e8 2c fa ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 31                	js     8014a3 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	68 75 29 80 00       	push   $0x802975
  80147a:	56                   	push   %esi
  80147b:	e8 62 fb ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	85 c0                	test   %eax,%eax
  801485:	78 33                	js     8014ba <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801487:	83 ec 08             	sub    $0x8,%esp
  80148a:	6a 02                	push   $0x2
  80148c:	56                   	push   %esi
  80148d:	e8 cc fa ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 38                	js     8014d1 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801499:	89 f0                	mov    %esi,%eax
  80149b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5f                   	pop    %edi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 28 31 80 00       	push   $0x803128
  8014ab:	68 98 00 00 00       	push   $0x98
  8014b0:	68 09 31 80 00       	push   $0x803109
  8014b5:	e8 eb 13 00 00       	call   8028a5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	68 9c 31 80 00       	push   $0x80319c
  8014c2:	68 9b 00 00 00       	push   $0x9b
  8014c7:	68 09 31 80 00       	push   $0x803109
  8014cc:	e8 d4 13 00 00       	call   8028a5 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 c4 31 80 00       	push   $0x8031c4
  8014d9:	68 9e 00 00 00       	push   $0x9e
  8014de:	68 09 31 80 00       	push   $0x803109
  8014e3:	e8 bd 13 00 00       	call   8028a5 <_panic>

008014e8 <sfork>:

// Challenge!
int
sfork(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014f1:	68 c2 12 80 00       	push   $0x8012c2
  8014f6:	e8 0b 14 00 00       	call   802906 <set_pgfault_handler>
  8014fb:	b8 07 00 00 00       	mov    $0x7,%eax
  801500:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	78 27                	js     801530 <sfork+0x48>
  801509:	89 c7                	mov    %eax,%edi
  80150b:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80150d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801512:	75 55                	jne    801569 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801514:	e8 40 f9 ff ff       	call   800e59 <sys_getenvid>
  801519:	25 ff 03 00 00       	and    $0x3ff,%eax
  80151e:	c1 e0 07             	shl    $0x7,%eax
  801521:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801526:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80152b:	e9 d4 00 00 00       	jmp    801604 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	68 78 31 80 00       	push   $0x803178
  801538:	68 af 00 00 00       	push   $0xaf
  80153d:	68 09 31 80 00       	push   $0x803109
  801542:	e8 5e 13 00 00       	call   8028a5 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801547:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80154c:	89 f0                	mov    %esi,%eax
  80154e:	e8 19 fc ff ff       	call   80116c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801553:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801559:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80155f:	77 65                	ja     8015c6 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801561:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801567:	74 de                	je     801547 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801569:	89 d8                	mov    %ebx,%eax
  80156b:	c1 e8 16             	shr    $0x16,%eax
  80156e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801575:	a8 01                	test   $0x1,%al
  801577:	74 da                	je     801553 <sfork+0x6b>
  801579:	89 da                	mov    %ebx,%edx
  80157b:	c1 ea 0c             	shr    $0xc,%edx
  80157e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801585:	83 e0 05             	and    $0x5,%eax
  801588:	83 f8 05             	cmp    $0x5,%eax
  80158b:	75 c6                	jne    801553 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80158d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801594:	c1 e2 0c             	shl    $0xc,%edx
  801597:	83 ec 0c             	sub    $0xc,%esp
  80159a:	83 e0 07             	and    $0x7,%eax
  80159d:	50                   	push   %eax
  80159e:	52                   	push   %edx
  80159f:	56                   	push   %esi
  8015a0:	52                   	push   %edx
  8015a1:	6a 00                	push   $0x0
  8015a3:	e8 32 f9 ff ff       	call   800eda <sys_page_map>
  8015a8:	83 c4 20             	add    $0x20,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	74 a4                	je     801553 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	68 f3 30 80 00       	push   $0x8030f3
  8015b7:	68 ba 00 00 00       	push   $0xba
  8015bc:	68 09 31 80 00       	push   $0x803109
  8015c1:	e8 df 12 00 00       	call   8028a5 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	6a 07                	push   $0x7
  8015cb:	68 00 f0 bf ee       	push   $0xeebff000
  8015d0:	57                   	push   %edi
  8015d1:	e8 c1 f8 ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 31                	js     80160e <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	68 75 29 80 00       	push   $0x802975
  8015e5:	57                   	push   %edi
  8015e6:	e8 f7 f9 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 33                	js     801625 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	6a 02                	push   $0x2
  8015f7:	57                   	push   %edi
  8015f8:	e8 61 f9 ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	78 38                	js     80163c <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801604:	89 f8                	mov    %edi,%eax
  801606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5f                   	pop    %edi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	68 28 31 80 00       	push   $0x803128
  801616:	68 c0 00 00 00       	push   $0xc0
  80161b:	68 09 31 80 00       	push   $0x803109
  801620:	e8 80 12 00 00       	call   8028a5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 9c 31 80 00       	push   $0x80319c
  80162d:	68 c3 00 00 00       	push   $0xc3
  801632:	68 09 31 80 00       	push   $0x803109
  801637:	e8 69 12 00 00       	call   8028a5 <_panic>
		panic("panic in sys_env_set_status()\n");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 c4 31 80 00       	push   $0x8031c4
  801644:	68 c6 00 00 00       	push   $0xc6
  801649:	68 09 31 80 00       	push   $0x803109
  80164e:	e8 52 12 00 00       	call   8028a5 <_panic>

00801653 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	8b 75 08             	mov    0x8(%ebp),%esi
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801661:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801663:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801668:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	50                   	push   %eax
  80166f:	e8 d3 f9 ff ff       	call   801047 <sys_ipc_recv>
	if(ret < 0){
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 2b                	js     8016a6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80167b:	85 f6                	test   %esi,%esi
  80167d:	74 0a                	je     801689 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80167f:	a1 08 50 80 00       	mov    0x805008,%eax
  801684:	8b 40 74             	mov    0x74(%eax),%eax
  801687:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801689:	85 db                	test   %ebx,%ebx
  80168b:	74 0a                	je     801697 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80168d:	a1 08 50 80 00       	mov    0x805008,%eax
  801692:	8b 40 78             	mov    0x78(%eax),%eax
  801695:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801697:	a1 08 50 80 00       	mov    0x805008,%eax
  80169c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80169f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    
		if(from_env_store)
  8016a6:	85 f6                	test   %esi,%esi
  8016a8:	74 06                	je     8016b0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016b0:	85 db                	test   %ebx,%ebx
  8016b2:	74 eb                	je     80169f <ipc_recv+0x4c>
			*perm_store = 0;
  8016b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016ba:	eb e3                	jmp    80169f <ipc_recv+0x4c>

008016bc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	57                   	push   %edi
  8016c0:	56                   	push   %esi
  8016c1:	53                   	push   %ebx
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016ce:	85 db                	test   %ebx,%ebx
  8016d0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016d5:	0f 44 d8             	cmove  %eax,%ebx
  8016d8:	eb 05                	jmp    8016df <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8016da:	e8 99 f7 ff ff       	call   800e78 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016df:	ff 75 14             	pushl  0x14(%ebp)
  8016e2:	53                   	push   %ebx
  8016e3:	56                   	push   %esi
  8016e4:	57                   	push   %edi
  8016e5:	e8 3a f9 ff ff       	call   801024 <sys_ipc_try_send>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	74 1b                	je     80170c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016f1:	79 e7                	jns    8016da <ipc_send+0x1e>
  8016f3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016f6:	74 e2                	je     8016da <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	68 e3 31 80 00       	push   $0x8031e3
  801700:	6a 4a                	push   $0x4a
  801702:	68 f8 31 80 00       	push   $0x8031f8
  801707:	e8 99 11 00 00       	call   8028a5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80170c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80171f:	89 c2                	mov    %eax,%edx
  801721:	c1 e2 07             	shl    $0x7,%edx
  801724:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80172a:	8b 52 50             	mov    0x50(%edx),%edx
  80172d:	39 ca                	cmp    %ecx,%edx
  80172f:	74 11                	je     801742 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801731:	83 c0 01             	add    $0x1,%eax
  801734:	3d 00 04 00 00       	cmp    $0x400,%eax
  801739:	75 e4                	jne    80171f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	eb 0b                	jmp    80174d <ipc_find_env+0x39>
			return envs[i].env_id;
  801742:	c1 e0 07             	shl    $0x7,%eax
  801745:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80174a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	05 00 00 00 30       	add    $0x30000000,%eax
  80175a:	c1 e8 0c             	shr    $0xc,%eax
}
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    

0080175f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80176a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80176f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80177e:	89 c2                	mov    %eax,%edx
  801780:	c1 ea 16             	shr    $0x16,%edx
  801783:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80178a:	f6 c2 01             	test   $0x1,%dl
  80178d:	74 2d                	je     8017bc <fd_alloc+0x46>
  80178f:	89 c2                	mov    %eax,%edx
  801791:	c1 ea 0c             	shr    $0xc,%edx
  801794:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179b:	f6 c2 01             	test   $0x1,%dl
  80179e:	74 1c                	je     8017bc <fd_alloc+0x46>
  8017a0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017a5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017aa:	75 d2                	jne    80177e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017b5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017ba:	eb 0a                	jmp    8017c6 <fd_alloc+0x50>
			*fd_store = fd;
  8017bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    

008017c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017ce:	83 f8 1f             	cmp    $0x1f,%eax
  8017d1:	77 30                	ja     801803 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017d3:	c1 e0 0c             	shl    $0xc,%eax
  8017d6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017db:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017e1:	f6 c2 01             	test   $0x1,%dl
  8017e4:	74 24                	je     80180a <fd_lookup+0x42>
  8017e6:	89 c2                	mov    %eax,%edx
  8017e8:	c1 ea 0c             	shr    $0xc,%edx
  8017eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017f2:	f6 c2 01             	test   $0x1,%dl
  8017f5:	74 1a                	je     801811 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fa:	89 02                	mov    %eax,(%edx)
	return 0;
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    
		return -E_INVAL;
  801803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801808:	eb f7                	jmp    801801 <fd_lookup+0x39>
		return -E_INVAL;
  80180a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180f:	eb f0                	jmp    801801 <fd_lookup+0x39>
  801811:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801816:	eb e9                	jmp    801801 <fd_lookup+0x39>

00801818 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801821:	ba 00 00 00 00       	mov    $0x0,%edx
  801826:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80182b:	39 08                	cmp    %ecx,(%eax)
  80182d:	74 38                	je     801867 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80182f:	83 c2 01             	add    $0x1,%edx
  801832:	8b 04 95 80 32 80 00 	mov    0x803280(,%edx,4),%eax
  801839:	85 c0                	test   %eax,%eax
  80183b:	75 ee                	jne    80182b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80183d:	a1 08 50 80 00       	mov    0x805008,%eax
  801842:	8b 40 48             	mov    0x48(%eax),%eax
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	51                   	push   %ecx
  801849:	50                   	push   %eax
  80184a:	68 04 32 80 00       	push   $0x803204
  80184f:	e8 f2 ea ff ff       	call   800346 <cprintf>
	*dev = 0;
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    
			*dev = devtab[i];
  801867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80186a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	eb f2                	jmp    801865 <dev_lookup+0x4d>

00801873 <fd_close>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	57                   	push   %edi
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
  801879:	83 ec 24             	sub    $0x24,%esp
  80187c:	8b 75 08             	mov    0x8(%ebp),%esi
  80187f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801882:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801885:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801886:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80188c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80188f:	50                   	push   %eax
  801890:	e8 33 ff ff ff       	call   8017c8 <fd_lookup>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 05                	js     8018a3 <fd_close+0x30>
	    || fd != fd2)
  80189e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018a1:	74 16                	je     8018b9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018a3:	89 f8                	mov    %edi,%eax
  8018a5:	84 c0                	test   %al,%al
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	0f 44 d8             	cmove  %eax,%ebx
}
  8018af:	89 d8                	mov    %ebx,%eax
  8018b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5f                   	pop    %edi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018bf:	50                   	push   %eax
  8018c0:	ff 36                	pushl  (%esi)
  8018c2:	e8 51 ff ff ff       	call   801818 <dev_lookup>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 1a                	js     8018ea <fd_close+0x77>
		if (dev->dev_close)
  8018d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	74 0b                	je     8018ea <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	56                   	push   %esi
  8018e3:	ff d0                	call   *%eax
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	56                   	push   %esi
  8018ee:	6a 00                	push   $0x0
  8018f0:	e8 27 f6 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	eb b5                	jmp    8018af <fd_close+0x3c>

008018fa <close>:

int
close(int fdnum)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801900:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801903:	50                   	push   %eax
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	e8 bc fe ff ff       	call   8017c8 <fd_lookup>
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	85 c0                	test   %eax,%eax
  801911:	79 02                	jns    801915 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    
		return fd_close(fd, 1);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	6a 01                	push   $0x1
  80191a:	ff 75 f4             	pushl  -0xc(%ebp)
  80191d:	e8 51 ff ff ff       	call   801873 <fd_close>
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	eb ec                	jmp    801913 <close+0x19>

00801927 <close_all>:

void
close_all(void)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	53                   	push   %ebx
  80192b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80192e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	53                   	push   %ebx
  801937:	e8 be ff ff ff       	call   8018fa <close>
	for (i = 0; i < MAXFD; i++)
  80193c:	83 c3 01             	add    $0x1,%ebx
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	83 fb 20             	cmp    $0x20,%ebx
  801945:	75 ec                	jne    801933 <close_all+0xc>
}
  801947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801955:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	e8 67 fe ff ff       	call   8017c8 <fd_lookup>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	0f 88 81 00 00 00    	js     8019ef <dup+0xa3>
		return r;
	close(newfdnum);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	e8 81 ff ff ff       	call   8018fa <close>

	newfd = INDEX2FD(newfdnum);
  801979:	8b 75 0c             	mov    0xc(%ebp),%esi
  80197c:	c1 e6 0c             	shl    $0xc,%esi
  80197f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	ff 75 e4             	pushl  -0x1c(%ebp)
  80198b:	e8 cf fd ff ff       	call   80175f <fd2data>
  801990:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801992:	89 34 24             	mov    %esi,(%esp)
  801995:	e8 c5 fd ff ff       	call   80175f <fd2data>
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80199f:	89 d8                	mov    %ebx,%eax
  8019a1:	c1 e8 16             	shr    $0x16,%eax
  8019a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ab:	a8 01                	test   $0x1,%al
  8019ad:	74 11                	je     8019c0 <dup+0x74>
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	c1 e8 0c             	shr    $0xc,%eax
  8019b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019bb:	f6 c2 01             	test   $0x1,%dl
  8019be:	75 39                	jne    8019f9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c3:	89 d0                	mov    %edx,%eax
  8019c5:	c1 e8 0c             	shr    $0xc,%eax
  8019c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8019d7:	50                   	push   %eax
  8019d8:	56                   	push   %esi
  8019d9:	6a 00                	push   $0x0
  8019db:	52                   	push   %edx
  8019dc:	6a 00                	push   $0x0
  8019de:	e8 f7 f4 ff ff       	call   800eda <sys_page_map>
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	83 c4 20             	add    $0x20,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 31                	js     801a1d <dup+0xd1>
		goto err;

	return newfdnum;
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019ef:	89 d8                	mov    %ebx,%eax
  8019f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	25 07 0e 00 00       	and    $0xe07,%eax
  801a08:	50                   	push   %eax
  801a09:	57                   	push   %edi
  801a0a:	6a 00                	push   $0x0
  801a0c:	53                   	push   %ebx
  801a0d:	6a 00                	push   $0x0
  801a0f:	e8 c6 f4 ff ff       	call   800eda <sys_page_map>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 20             	add    $0x20,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	79 a3                	jns    8019c0 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a1d:	83 ec 08             	sub    $0x8,%esp
  801a20:	56                   	push   %esi
  801a21:	6a 00                	push   $0x0
  801a23:	e8 f4 f4 ff ff       	call   800f1c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a28:	83 c4 08             	add    $0x8,%esp
  801a2b:	57                   	push   %edi
  801a2c:	6a 00                	push   $0x0
  801a2e:	e8 e9 f4 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	eb b7                	jmp    8019ef <dup+0xa3>

00801a38 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 1c             	sub    $0x1c,%esp
  801a3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a45:	50                   	push   %eax
  801a46:	53                   	push   %ebx
  801a47:	e8 7c fd ff ff       	call   8017c8 <fd_lookup>
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 3f                	js     801a92 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a53:	83 ec 08             	sub    $0x8,%esp
  801a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a59:	50                   	push   %eax
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5d:	ff 30                	pushl  (%eax)
  801a5f:	e8 b4 fd ff ff       	call   801818 <dev_lookup>
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 27                	js     801a92 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a6e:	8b 42 08             	mov    0x8(%edx),%eax
  801a71:	83 e0 03             	and    $0x3,%eax
  801a74:	83 f8 01             	cmp    $0x1,%eax
  801a77:	74 1e                	je     801a97 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	8b 40 08             	mov    0x8(%eax),%eax
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	74 35                	je     801ab8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	52                   	push   %edx
  801a8d:	ff d0                	call   *%eax
  801a8f:	83 c4 10             	add    $0x10,%esp
}
  801a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a97:	a1 08 50 80 00       	mov    0x805008,%eax
  801a9c:	8b 40 48             	mov    0x48(%eax),%eax
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	53                   	push   %ebx
  801aa3:	50                   	push   %eax
  801aa4:	68 45 32 80 00       	push   $0x803245
  801aa9:	e8 98 e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab6:	eb da                	jmp    801a92 <read+0x5a>
		return -E_NOT_SUPP;
  801ab8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abd:	eb d3                	jmp    801a92 <read+0x5a>

00801abf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	57                   	push   %edi
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801acb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ace:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad3:	39 f3                	cmp    %esi,%ebx
  801ad5:	73 23                	jae    801afa <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	89 f0                	mov    %esi,%eax
  801adc:	29 d8                	sub    %ebx,%eax
  801ade:	50                   	push   %eax
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	03 45 0c             	add    0xc(%ebp),%eax
  801ae4:	50                   	push   %eax
  801ae5:	57                   	push   %edi
  801ae6:	e8 4d ff ff ff       	call   801a38 <read>
		if (m < 0)
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 06                	js     801af8 <readn+0x39>
			return m;
		if (m == 0)
  801af2:	74 06                	je     801afa <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801af4:	01 c3                	add    %eax,%ebx
  801af6:	eb db                	jmp    801ad3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801af8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    

00801b04 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	53                   	push   %ebx
  801b13:	e8 b0 fc ff ff       	call   8017c8 <fd_lookup>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 3a                	js     801b59 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b25:	50                   	push   %eax
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b29:	ff 30                	pushl  (%eax)
  801b2b:	e8 e8 fc ff ff       	call   801818 <dev_lookup>
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 22                	js     801b59 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b3e:	74 1e                	je     801b5e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b43:	8b 52 0c             	mov    0xc(%edx),%edx
  801b46:	85 d2                	test   %edx,%edx
  801b48:	74 35                	je     801b7f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	ff d2                	call   *%edx
  801b56:	83 c4 10             	add    $0x10,%esp
}
  801b59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b5e:	a1 08 50 80 00       	mov    0x805008,%eax
  801b63:	8b 40 48             	mov    0x48(%eax),%eax
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	53                   	push   %ebx
  801b6a:	50                   	push   %eax
  801b6b:	68 61 32 80 00       	push   $0x803261
  801b70:	e8 d1 e7 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b7d:	eb da                	jmp    801b59 <write+0x55>
		return -E_NOT_SUPP;
  801b7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b84:	eb d3                	jmp    801b59 <write+0x55>

00801b86 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8f:	50                   	push   %eax
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	e8 30 fc ff ff       	call   8017c8 <fd_lookup>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 0e                	js     801bad <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	53                   	push   %ebx
  801bb3:	83 ec 1c             	sub    $0x1c,%esp
  801bb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bbc:	50                   	push   %eax
  801bbd:	53                   	push   %ebx
  801bbe:	e8 05 fc ff ff       	call   8017c8 <fd_lookup>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 37                	js     801c01 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd0:	50                   	push   %eax
  801bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd4:	ff 30                	pushl  (%eax)
  801bd6:	e8 3d fc ff ff       	call   801818 <dev_lookup>
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 1f                	js     801c01 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801be9:	74 1b                	je     801c06 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bee:	8b 52 18             	mov    0x18(%edx),%edx
  801bf1:	85 d2                	test   %edx,%edx
  801bf3:	74 32                	je     801c27 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bf5:	83 ec 08             	sub    $0x8,%esp
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	ff d2                	call   *%edx
  801bfe:	83 c4 10             	add    $0x10,%esp
}
  801c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c06:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c0b:	8b 40 48             	mov    0x48(%eax),%eax
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	53                   	push   %ebx
  801c12:	50                   	push   %eax
  801c13:	68 24 32 80 00       	push   $0x803224
  801c18:	e8 29 e7 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c25:	eb da                	jmp    801c01 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c27:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c2c:	eb d3                	jmp    801c01 <ftruncate+0x52>

00801c2e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	53                   	push   %ebx
  801c32:	83 ec 1c             	sub    $0x1c,%esp
  801c35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3b:	50                   	push   %eax
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	e8 84 fb ff ff       	call   8017c8 <fd_lookup>
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 4b                	js     801c96 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c51:	50                   	push   %eax
  801c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c55:	ff 30                	pushl  (%eax)
  801c57:	e8 bc fb ff ff       	call   801818 <dev_lookup>
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 33                	js     801c96 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c6a:	74 2f                	je     801c9b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c6c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c6f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c76:	00 00 00 
	stat->st_isdir = 0;
  801c79:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c80:	00 00 00 
	stat->st_dev = dev;
  801c83:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c89:	83 ec 08             	sub    $0x8,%esp
  801c8c:	53                   	push   %ebx
  801c8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c90:	ff 50 14             	call   *0x14(%eax)
  801c93:	83 c4 10             	add    $0x10,%esp
}
  801c96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    
		return -E_NOT_SUPP;
  801c9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ca0:	eb f4                	jmp    801c96 <fstat+0x68>

00801ca2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ca7:	83 ec 08             	sub    $0x8,%esp
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	e8 22 02 00 00       	call   801ed6 <open>
  801cb4:	89 c3                	mov    %eax,%ebx
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	78 1b                	js     801cd8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cbd:	83 ec 08             	sub    $0x8,%esp
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	50                   	push   %eax
  801cc4:	e8 65 ff ff ff       	call   801c2e <fstat>
  801cc9:	89 c6                	mov    %eax,%esi
	close(fd);
  801ccb:	89 1c 24             	mov    %ebx,(%esp)
  801cce:	e8 27 fc ff ff       	call   8018fa <close>
	return r;
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 f3                	mov    %esi,%ebx
}
  801cd8:	89 d8                	mov    %ebx,%eax
  801cda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdd:	5b                   	pop    %ebx
  801cde:	5e                   	pop    %esi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    

00801ce1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	56                   	push   %esi
  801ce5:	53                   	push   %ebx
  801ce6:	89 c6                	mov    %eax,%esi
  801ce8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cea:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cf1:	74 27                	je     801d1a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cf3:	6a 07                	push   $0x7
  801cf5:	68 00 60 80 00       	push   $0x806000
  801cfa:	56                   	push   %esi
  801cfb:	ff 35 00 50 80 00    	pushl  0x805000
  801d01:	e8 b6 f9 ff ff       	call   8016bc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d06:	83 c4 0c             	add    $0xc,%esp
  801d09:	6a 00                	push   $0x0
  801d0b:	53                   	push   %ebx
  801d0c:	6a 00                	push   $0x0
  801d0e:	e8 40 f9 ff ff       	call   801653 <ipc_recv>
}
  801d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	6a 01                	push   $0x1
  801d1f:	e8 f0 f9 ff ff       	call   801714 <ipc_find_env>
  801d24:	a3 00 50 80 00       	mov    %eax,0x805000
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	eb c5                	jmp    801cf3 <fsipc+0x12>

00801d2e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d42:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d47:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4c:	b8 02 00 00 00       	mov    $0x2,%eax
  801d51:	e8 8b ff ff ff       	call   801ce1 <fsipc>
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <devfile_flush>:
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	8b 40 0c             	mov    0xc(%eax),%eax
  801d64:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d69:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6e:	b8 06 00 00 00       	mov    $0x6,%eax
  801d73:	e8 69 ff ff ff       	call   801ce1 <fsipc>
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <devfile_stat>:
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d94:	b8 05 00 00 00       	mov    $0x5,%eax
  801d99:	e8 43 ff ff ff       	call   801ce1 <fsipc>
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 2c                	js     801dce <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	68 00 60 80 00       	push   $0x806000
  801daa:	53                   	push   %ebx
  801dab:	e8 f5 ec ff ff       	call   800aa5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801db0:	a1 80 60 80 00       	mov    0x806080,%eax
  801db5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dbb:	a1 84 60 80 00       	mov    0x806084,%eax
  801dc0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <devfile_write>:
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	53                   	push   %ebx
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	8b 40 0c             	mov    0xc(%eax),%eax
  801de3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801de8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801dee:	53                   	push   %ebx
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	68 08 60 80 00       	push   $0x806008
  801df7:	e8 99 ee ff ff       	call   800c95 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801e01:	b8 04 00 00 00       	mov    $0x4,%eax
  801e06:	e8 d6 fe ff ff       	call   801ce1 <fsipc>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 0b                	js     801e1d <devfile_write+0x4a>
	assert(r <= n);
  801e12:	39 d8                	cmp    %ebx,%eax
  801e14:	77 0c                	ja     801e22 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e16:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e1b:	7f 1e                	jg     801e3b <devfile_write+0x68>
}
  801e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    
	assert(r <= n);
  801e22:	68 94 32 80 00       	push   $0x803294
  801e27:	68 9b 32 80 00       	push   $0x80329b
  801e2c:	68 98 00 00 00       	push   $0x98
  801e31:	68 b0 32 80 00       	push   $0x8032b0
  801e36:	e8 6a 0a 00 00       	call   8028a5 <_panic>
	assert(r <= PGSIZE);
  801e3b:	68 bb 32 80 00       	push   $0x8032bb
  801e40:	68 9b 32 80 00       	push   $0x80329b
  801e45:	68 99 00 00 00       	push   $0x99
  801e4a:	68 b0 32 80 00       	push   $0x8032b0
  801e4f:	e8 51 0a 00 00       	call   8028a5 <_panic>

00801e54 <devfile_read>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	56                   	push   %esi
  801e58:	53                   	push   %ebx
  801e59:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e62:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e67:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e72:	b8 03 00 00 00       	mov    $0x3,%eax
  801e77:	e8 65 fe ff ff       	call   801ce1 <fsipc>
  801e7c:	89 c3                	mov    %eax,%ebx
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 1f                	js     801ea1 <devfile_read+0x4d>
	assert(r <= n);
  801e82:	39 f0                	cmp    %esi,%eax
  801e84:	77 24                	ja     801eaa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e86:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e8b:	7f 33                	jg     801ec0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	50                   	push   %eax
  801e91:	68 00 60 80 00       	push   $0x806000
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	e8 95 ed ff ff       	call   800c33 <memmove>
	return r;
  801e9e:	83 c4 10             	add    $0x10,%esp
}
  801ea1:	89 d8                	mov    %ebx,%eax
  801ea3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    
	assert(r <= n);
  801eaa:	68 94 32 80 00       	push   $0x803294
  801eaf:	68 9b 32 80 00       	push   $0x80329b
  801eb4:	6a 7c                	push   $0x7c
  801eb6:	68 b0 32 80 00       	push   $0x8032b0
  801ebb:	e8 e5 09 00 00       	call   8028a5 <_panic>
	assert(r <= PGSIZE);
  801ec0:	68 bb 32 80 00       	push   $0x8032bb
  801ec5:	68 9b 32 80 00       	push   $0x80329b
  801eca:	6a 7d                	push   $0x7d
  801ecc:	68 b0 32 80 00       	push   $0x8032b0
  801ed1:	e8 cf 09 00 00       	call   8028a5 <_panic>

00801ed6 <open>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	56                   	push   %esi
  801eda:	53                   	push   %ebx
  801edb:	83 ec 1c             	sub    $0x1c,%esp
  801ede:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ee1:	56                   	push   %esi
  801ee2:	e8 85 eb ff ff       	call   800a6c <strlen>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801eef:	7f 6c                	jg     801f5d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef7:	50                   	push   %eax
  801ef8:	e8 79 f8 ff ff       	call   801776 <fd_alloc>
  801efd:	89 c3                	mov    %eax,%ebx
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 3c                	js     801f42 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	56                   	push   %esi
  801f0a:	68 00 60 80 00       	push   $0x806000
  801f0f:	e8 91 eb ff ff       	call   800aa5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f17:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f24:	e8 b8 fd ff ff       	call   801ce1 <fsipc>
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 19                	js     801f4b <open+0x75>
	return fd2num(fd);
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	e8 12 f8 ff ff       	call   80174f <fd2num>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	89 d8                	mov    %ebx,%eax
  801f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    
		fd_close(fd, 0);
  801f4b:	83 ec 08             	sub    $0x8,%esp
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	e8 1b f9 ff ff       	call   801873 <fd_close>
		return r;
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	eb e5                	jmp    801f42 <open+0x6c>
		return -E_BAD_PATH;
  801f5d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f62:	eb de                	jmp    801f42 <open+0x6c>

00801f64 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6f:	b8 08 00 00 00       	mov    $0x8,%eax
  801f74:	e8 68 fd ff ff       	call   801ce1 <fsipc>
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f81:	68 c7 32 80 00       	push   $0x8032c7
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	e8 17 eb ff ff       	call   800aa5 <strcpy>
	return 0;
}
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <devsock_close>:
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	53                   	push   %ebx
  801f99:	83 ec 10             	sub    $0x10,%esp
  801f9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f9f:	53                   	push   %ebx
  801fa0:	e8 f6 09 00 00       	call   80299b <pageref>
  801fa5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fa8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fad:	83 f8 01             	cmp    $0x1,%eax
  801fb0:	74 07                	je     801fb9 <devsock_close+0x24>
}
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 73 0c             	pushl  0xc(%ebx)
  801fbf:	e8 b9 02 00 00       	call   80227d <nsipc_close>
  801fc4:	89 c2                	mov    %eax,%edx
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	eb e7                	jmp    801fb2 <devsock_close+0x1d>

00801fcb <devsock_write>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	ff 75 10             	pushl  0x10(%ebp)
  801fd6:	ff 75 0c             	pushl  0xc(%ebp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	ff 70 0c             	pushl  0xc(%eax)
  801fdf:	e8 76 03 00 00       	call   80235a <nsipc_send>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <devsock_read>:
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	ff 75 10             	pushl  0x10(%ebp)
  801ff1:	ff 75 0c             	pushl  0xc(%ebp)
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	ff 70 0c             	pushl  0xc(%eax)
  801ffa:	e8 ef 02 00 00       	call   8022ee <nsipc_recv>
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <fd2sockid>:
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802007:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80200a:	52                   	push   %edx
  80200b:	50                   	push   %eax
  80200c:	e8 b7 f7 ff ff       	call   8017c8 <fd_lookup>
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	85 c0                	test   %eax,%eax
  802016:	78 10                	js     802028 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802021:	39 08                	cmp    %ecx,(%eax)
  802023:	75 05                	jne    80202a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802025:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    
		return -E_NOT_SUPP;
  80202a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80202f:	eb f7                	jmp    802028 <fd2sockid+0x27>

00802031 <alloc_sockfd>:
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	56                   	push   %esi
  802035:	53                   	push   %ebx
  802036:	83 ec 1c             	sub    $0x1c,%esp
  802039:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80203b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203e:	50                   	push   %eax
  80203f:	e8 32 f7 ff ff       	call   801776 <fd_alloc>
  802044:	89 c3                	mov    %eax,%ebx
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	85 c0                	test   %eax,%eax
  80204b:	78 43                	js     802090 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 07 04 00 00       	push   $0x407
  802055:	ff 75 f4             	pushl  -0xc(%ebp)
  802058:	6a 00                	push   $0x0
  80205a:	e8 38 ee ff ff       	call   800e97 <sys_page_alloc>
  80205f:	89 c3                	mov    %eax,%ebx
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	78 28                	js     802090 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802071:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80207d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	50                   	push   %eax
  802084:	e8 c6 f6 ff ff       	call   80174f <fd2num>
  802089:	89 c3                	mov    %eax,%ebx
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	eb 0c                	jmp    80209c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	56                   	push   %esi
  802094:	e8 e4 01 00 00       	call   80227d <nsipc_close>
		return r;
  802099:	83 c4 10             	add    $0x10,%esp
}
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    

008020a5 <accept>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	e8 4e ff ff ff       	call   802001 <fd2sockid>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 1b                	js     8020d2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	50                   	push   %eax
  8020c1:	e8 0e 01 00 00       	call   8021d4 <nsipc_accept>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 05                	js     8020d2 <accept+0x2d>
	return alloc_sockfd(r);
  8020cd:	e8 5f ff ff ff       	call   802031 <alloc_sockfd>
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <bind>:
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	e8 1f ff ff ff       	call   802001 <fd2sockid>
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	78 12                	js     8020f8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020e6:	83 ec 04             	sub    $0x4,%esp
  8020e9:	ff 75 10             	pushl  0x10(%ebp)
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	50                   	push   %eax
  8020f0:	e8 31 01 00 00       	call   802226 <nsipc_bind>
  8020f5:	83 c4 10             	add    $0x10,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <shutdown>:
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	e8 f9 fe ff ff       	call   802001 <fd2sockid>
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 0f                	js     80211b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80210c:	83 ec 08             	sub    $0x8,%esp
  80210f:	ff 75 0c             	pushl  0xc(%ebp)
  802112:	50                   	push   %eax
  802113:	e8 43 01 00 00       	call   80225b <nsipc_shutdown>
  802118:	83 c4 10             	add    $0x10,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <connect>:
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	e8 d6 fe ff ff       	call   802001 <fd2sockid>
  80212b:	85 c0                	test   %eax,%eax
  80212d:	78 12                	js     802141 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	ff 75 10             	pushl  0x10(%ebp)
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	50                   	push   %eax
  802139:	e8 59 01 00 00       	call   802297 <nsipc_connect>
  80213e:	83 c4 10             	add    $0x10,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <listen>:
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	e8 b0 fe ff ff       	call   802001 <fd2sockid>
  802151:	85 c0                	test   %eax,%eax
  802153:	78 0f                	js     802164 <listen+0x21>
	return nsipc_listen(r, backlog);
  802155:	83 ec 08             	sub    $0x8,%esp
  802158:	ff 75 0c             	pushl  0xc(%ebp)
  80215b:	50                   	push   %eax
  80215c:	e8 6b 01 00 00       	call   8022cc <nsipc_listen>
  802161:	83 c4 10             	add    $0x10,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <socket>:

int
socket(int domain, int type, int protocol)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80216c:	ff 75 10             	pushl  0x10(%ebp)
  80216f:	ff 75 0c             	pushl  0xc(%ebp)
  802172:	ff 75 08             	pushl  0x8(%ebp)
  802175:	e8 3e 02 00 00       	call   8023b8 <nsipc_socket>
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 05                	js     802186 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802181:	e8 ab fe ff ff       	call   802031 <alloc_sockfd>
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	53                   	push   %ebx
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802191:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802198:	74 26                	je     8021c0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80219a:	6a 07                	push   $0x7
  80219c:	68 00 70 80 00       	push   $0x807000
  8021a1:	53                   	push   %ebx
  8021a2:	ff 35 04 50 80 00    	pushl  0x805004
  8021a8:	e8 0f f5 ff ff       	call   8016bc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021ad:	83 c4 0c             	add    $0xc,%esp
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	e8 98 f4 ff ff       	call   801653 <ipc_recv>
}
  8021bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	6a 02                	push   $0x2
  8021c5:	e8 4a f5 ff ff       	call   801714 <ipc_find_env>
  8021ca:	a3 04 50 80 00       	mov    %eax,0x805004
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	eb c6                	jmp    80219a <nsipc+0x12>

008021d4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021e4:	8b 06                	mov    (%esi),%eax
  8021e6:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f0:	e8 93 ff ff ff       	call   802188 <nsipc>
  8021f5:	89 c3                	mov    %eax,%ebx
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	79 09                	jns    802204 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021fb:	89 d8                	mov    %ebx,%eax
  8021fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	ff 35 10 70 80 00    	pushl  0x807010
  80220d:	68 00 70 80 00       	push   $0x807000
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	e8 19 ea ff ff       	call   800c33 <memmove>
		*addrlen = ret->ret_addrlen;
  80221a:	a1 10 70 80 00       	mov    0x807010,%eax
  80221f:	89 06                	mov    %eax,(%esi)
  802221:	83 c4 10             	add    $0x10,%esp
	return r;
  802224:	eb d5                	jmp    8021fb <nsipc_accept+0x27>

00802226 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	53                   	push   %ebx
  80222a:	83 ec 08             	sub    $0x8,%esp
  80222d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802238:	53                   	push   %ebx
  802239:	ff 75 0c             	pushl  0xc(%ebp)
  80223c:	68 04 70 80 00       	push   $0x807004
  802241:	e8 ed e9 ff ff       	call   800c33 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802246:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80224c:	b8 02 00 00 00       	mov    $0x2,%eax
  802251:	e8 32 ff ff ff       	call   802188 <nsipc>
}
  802256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802271:	b8 03 00 00 00       	mov    $0x3,%eax
  802276:	e8 0d ff ff ff       	call   802188 <nsipc>
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <nsipc_close>:

int
nsipc_close(int s)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80228b:	b8 04 00 00 00       	mov    $0x4,%eax
  802290:	e8 f3 fe ff ff       	call   802188 <nsipc>
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	53                   	push   %ebx
  80229b:	83 ec 08             	sub    $0x8,%esp
  80229e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022a9:	53                   	push   %ebx
  8022aa:	ff 75 0c             	pushl  0xc(%ebp)
  8022ad:	68 04 70 80 00       	push   $0x807004
  8022b2:	e8 7c e9 ff ff       	call   800c33 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022b7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8022c2:	e8 c1 fe ff ff       	call   802188 <nsipc>
}
  8022c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022dd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8022e7:	e8 9c fe ff ff       	call   802188 <nsipc>
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802304:	8b 45 14             	mov    0x14(%ebp),%eax
  802307:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80230c:	b8 07 00 00 00       	mov    $0x7,%eax
  802311:	e8 72 fe ff ff       	call   802188 <nsipc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	85 c0                	test   %eax,%eax
  80231a:	78 1f                	js     80233b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80231c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802321:	7f 21                	jg     802344 <nsipc_recv+0x56>
  802323:	39 c6                	cmp    %eax,%esi
  802325:	7c 1d                	jl     802344 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	50                   	push   %eax
  80232b:	68 00 70 80 00       	push   $0x807000
  802330:	ff 75 0c             	pushl  0xc(%ebp)
  802333:	e8 fb e8 ff ff       	call   800c33 <memmove>
  802338:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80233b:	89 d8                	mov    %ebx,%eax
  80233d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802344:	68 d3 32 80 00       	push   $0x8032d3
  802349:	68 9b 32 80 00       	push   $0x80329b
  80234e:	6a 62                	push   $0x62
  802350:	68 e8 32 80 00       	push   $0x8032e8
  802355:	e8 4b 05 00 00       	call   8028a5 <_panic>

0080235a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	53                   	push   %ebx
  80235e:	83 ec 04             	sub    $0x4,%esp
  802361:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80236c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802372:	7f 2e                	jg     8023a2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802374:	83 ec 04             	sub    $0x4,%esp
  802377:	53                   	push   %ebx
  802378:	ff 75 0c             	pushl  0xc(%ebp)
  80237b:	68 0c 70 80 00       	push   $0x80700c
  802380:	e8 ae e8 ff ff       	call   800c33 <memmove>
	nsipcbuf.send.req_size = size;
  802385:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80238b:	8b 45 14             	mov    0x14(%ebp),%eax
  80238e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802393:	b8 08 00 00 00       	mov    $0x8,%eax
  802398:	e8 eb fd ff ff       	call   802188 <nsipc>
}
  80239d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    
	assert(size < 1600);
  8023a2:	68 f4 32 80 00       	push   $0x8032f4
  8023a7:	68 9b 32 80 00       	push   $0x80329b
  8023ac:	6a 6d                	push   $0x6d
  8023ae:	68 e8 32 80 00       	push   $0x8032e8
  8023b3:	e8 ed 04 00 00       	call   8028a5 <_panic>

008023b8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023d6:	b8 09 00 00 00       	mov    $0x9,%eax
  8023db:	e8 a8 fd ff ff       	call   802188 <nsipc>
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	56                   	push   %esi
  8023e6:	53                   	push   %ebx
  8023e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023ea:	83 ec 0c             	sub    $0xc,%esp
  8023ed:	ff 75 08             	pushl  0x8(%ebp)
  8023f0:	e8 6a f3 ff ff       	call   80175f <fd2data>
  8023f5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023f7:	83 c4 08             	add    $0x8,%esp
  8023fa:	68 00 33 80 00       	push   $0x803300
  8023ff:	53                   	push   %ebx
  802400:	e8 a0 e6 ff ff       	call   800aa5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802405:	8b 46 04             	mov    0x4(%esi),%eax
  802408:	2b 06                	sub    (%esi),%eax
  80240a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802410:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802417:	00 00 00 
	stat->st_dev = &devpipe;
  80241a:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802421:	40 80 00 
	return 0;
}
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    

00802430 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	53                   	push   %ebx
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80243a:	53                   	push   %ebx
  80243b:	6a 00                	push   $0x0
  80243d:	e8 da ea ff ff       	call   800f1c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802442:	89 1c 24             	mov    %ebx,(%esp)
  802445:	e8 15 f3 ff ff       	call   80175f <fd2data>
  80244a:	83 c4 08             	add    $0x8,%esp
  80244d:	50                   	push   %eax
  80244e:	6a 00                	push   $0x0
  802450:	e8 c7 ea ff ff       	call   800f1c <sys_page_unmap>
}
  802455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <_pipeisclosed>:
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	57                   	push   %edi
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	83 ec 1c             	sub    $0x1c,%esp
  802463:	89 c7                	mov    %eax,%edi
  802465:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802467:	a1 08 50 80 00       	mov    0x805008,%eax
  80246c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80246f:	83 ec 0c             	sub    $0xc,%esp
  802472:	57                   	push   %edi
  802473:	e8 23 05 00 00       	call   80299b <pageref>
  802478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80247b:	89 34 24             	mov    %esi,(%esp)
  80247e:	e8 18 05 00 00       	call   80299b <pageref>
		nn = thisenv->env_runs;
  802483:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802489:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80248c:	83 c4 10             	add    $0x10,%esp
  80248f:	39 cb                	cmp    %ecx,%ebx
  802491:	74 1b                	je     8024ae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802493:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802496:	75 cf                	jne    802467 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802498:	8b 42 58             	mov    0x58(%edx),%eax
  80249b:	6a 01                	push   $0x1
  80249d:	50                   	push   %eax
  80249e:	53                   	push   %ebx
  80249f:	68 07 33 80 00       	push   $0x803307
  8024a4:	e8 9d de ff ff       	call   800346 <cprintf>
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	eb b9                	jmp    802467 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024ae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b1:	0f 94 c0             	sete   %al
  8024b4:	0f b6 c0             	movzbl %al,%eax
}
  8024b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ba:	5b                   	pop    %ebx
  8024bb:	5e                   	pop    %esi
  8024bc:	5f                   	pop    %edi
  8024bd:	5d                   	pop    %ebp
  8024be:	c3                   	ret    

008024bf <devpipe_write>:
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	57                   	push   %edi
  8024c3:	56                   	push   %esi
  8024c4:	53                   	push   %ebx
  8024c5:	83 ec 28             	sub    $0x28,%esp
  8024c8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024cb:	56                   	push   %esi
  8024cc:	e8 8e f2 ff ff       	call   80175f <fd2data>
  8024d1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024db:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024de:	74 4f                	je     80252f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024e0:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e3:	8b 0b                	mov    (%ebx),%ecx
  8024e5:	8d 51 20             	lea    0x20(%ecx),%edx
  8024e8:	39 d0                	cmp    %edx,%eax
  8024ea:	72 14                	jb     802500 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024ec:	89 da                	mov    %ebx,%edx
  8024ee:	89 f0                	mov    %esi,%eax
  8024f0:	e8 65 ff ff ff       	call   80245a <_pipeisclosed>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	75 3b                	jne    802534 <devpipe_write+0x75>
			sys_yield();
  8024f9:	e8 7a e9 ff ff       	call   800e78 <sys_yield>
  8024fe:	eb e0                	jmp    8024e0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802503:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802507:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80250a:	89 c2                	mov    %eax,%edx
  80250c:	c1 fa 1f             	sar    $0x1f,%edx
  80250f:	89 d1                	mov    %edx,%ecx
  802511:	c1 e9 1b             	shr    $0x1b,%ecx
  802514:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802517:	83 e2 1f             	and    $0x1f,%edx
  80251a:	29 ca                	sub    %ecx,%edx
  80251c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802520:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802524:	83 c0 01             	add    $0x1,%eax
  802527:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80252a:	83 c7 01             	add    $0x1,%edi
  80252d:	eb ac                	jmp    8024db <devpipe_write+0x1c>
	return i;
  80252f:	8b 45 10             	mov    0x10(%ebp),%eax
  802532:	eb 05                	jmp    802539 <devpipe_write+0x7a>
				return 0;
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802539:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    

00802541 <devpipe_read>:
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	57                   	push   %edi
  802545:	56                   	push   %esi
  802546:	53                   	push   %ebx
  802547:	83 ec 18             	sub    $0x18,%esp
  80254a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80254d:	57                   	push   %edi
  80254e:	e8 0c f2 ff ff       	call   80175f <fd2data>
  802553:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	be 00 00 00 00       	mov    $0x0,%esi
  80255d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802560:	75 14                	jne    802576 <devpipe_read+0x35>
	return i;
  802562:	8b 45 10             	mov    0x10(%ebp),%eax
  802565:	eb 02                	jmp    802569 <devpipe_read+0x28>
				return i;
  802567:	89 f0                	mov    %esi,%eax
}
  802569:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
			sys_yield();
  802571:	e8 02 e9 ff ff       	call   800e78 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802576:	8b 03                	mov    (%ebx),%eax
  802578:	3b 43 04             	cmp    0x4(%ebx),%eax
  80257b:	75 18                	jne    802595 <devpipe_read+0x54>
			if (i > 0)
  80257d:	85 f6                	test   %esi,%esi
  80257f:	75 e6                	jne    802567 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802581:	89 da                	mov    %ebx,%edx
  802583:	89 f8                	mov    %edi,%eax
  802585:	e8 d0 fe ff ff       	call   80245a <_pipeisclosed>
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 e3                	je     802571 <devpipe_read+0x30>
				return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	eb d4                	jmp    802569 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802595:	99                   	cltd   
  802596:	c1 ea 1b             	shr    $0x1b,%edx
  802599:	01 d0                	add    %edx,%eax
  80259b:	83 e0 1f             	and    $0x1f,%eax
  80259e:	29 d0                	sub    %edx,%eax
  8025a0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025ab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025ae:	83 c6 01             	add    $0x1,%esi
  8025b1:	eb aa                	jmp    80255d <devpipe_read+0x1c>

008025b3 <pipe>:
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	56                   	push   %esi
  8025b7:	53                   	push   %ebx
  8025b8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025be:	50                   	push   %eax
  8025bf:	e8 b2 f1 ff ff       	call   801776 <fd_alloc>
  8025c4:	89 c3                	mov    %eax,%ebx
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	0f 88 23 01 00 00    	js     8026f4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	68 07 04 00 00       	push   $0x407
  8025d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8025dc:	6a 00                	push   $0x0
  8025de:	e8 b4 e8 ff ff       	call   800e97 <sys_page_alloc>
  8025e3:	89 c3                	mov    %eax,%ebx
  8025e5:	83 c4 10             	add    $0x10,%esp
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 04 01 00 00    	js     8026f4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025f0:	83 ec 0c             	sub    $0xc,%esp
  8025f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025f6:	50                   	push   %eax
  8025f7:	e8 7a f1 ff ff       	call   801776 <fd_alloc>
  8025fc:	89 c3                	mov    %eax,%ebx
  8025fe:	83 c4 10             	add    $0x10,%esp
  802601:	85 c0                	test   %eax,%eax
  802603:	0f 88 db 00 00 00    	js     8026e4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802609:	83 ec 04             	sub    $0x4,%esp
  80260c:	68 07 04 00 00       	push   $0x407
  802611:	ff 75 f0             	pushl  -0x10(%ebp)
  802614:	6a 00                	push   $0x0
  802616:	e8 7c e8 ff ff       	call   800e97 <sys_page_alloc>
  80261b:	89 c3                	mov    %eax,%ebx
  80261d:	83 c4 10             	add    $0x10,%esp
  802620:	85 c0                	test   %eax,%eax
  802622:	0f 88 bc 00 00 00    	js     8026e4 <pipe+0x131>
	va = fd2data(fd0);
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	ff 75 f4             	pushl  -0xc(%ebp)
  80262e:	e8 2c f1 ff ff       	call   80175f <fd2data>
  802633:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802635:	83 c4 0c             	add    $0xc,%esp
  802638:	68 07 04 00 00       	push   $0x407
  80263d:	50                   	push   %eax
  80263e:	6a 00                	push   $0x0
  802640:	e8 52 e8 ff ff       	call   800e97 <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	85 c0                	test   %eax,%eax
  80264c:	0f 88 82 00 00 00    	js     8026d4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	ff 75 f0             	pushl  -0x10(%ebp)
  802658:	e8 02 f1 ff ff       	call   80175f <fd2data>
  80265d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802664:	50                   	push   %eax
  802665:	6a 00                	push   $0x0
  802667:	56                   	push   %esi
  802668:	6a 00                	push   $0x0
  80266a:	e8 6b e8 ff ff       	call   800eda <sys_page_map>
  80266f:	89 c3                	mov    %eax,%ebx
  802671:	83 c4 20             	add    $0x20,%esp
  802674:	85 c0                	test   %eax,%eax
  802676:	78 4e                	js     8026c6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802678:	a1 44 40 80 00       	mov    0x804044,%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802685:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80268c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a1:	e8 a9 f0 ff ff       	call   80174f <fd2num>
  8026a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026a9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026ab:	83 c4 04             	add    $0x4,%esp
  8026ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b1:	e8 99 f0 ff ff       	call   80174f <fd2num>
  8026b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026bc:	83 c4 10             	add    $0x10,%esp
  8026bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026c4:	eb 2e                	jmp    8026f4 <pipe+0x141>
	sys_page_unmap(0, va);
  8026c6:	83 ec 08             	sub    $0x8,%esp
  8026c9:	56                   	push   %esi
  8026ca:	6a 00                	push   $0x0
  8026cc:	e8 4b e8 ff ff       	call   800f1c <sys_page_unmap>
  8026d1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026d4:	83 ec 08             	sub    $0x8,%esp
  8026d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026da:	6a 00                	push   $0x0
  8026dc:	e8 3b e8 ff ff       	call   800f1c <sys_page_unmap>
  8026e1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026e4:	83 ec 08             	sub    $0x8,%esp
  8026e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 2b e8 ff ff       	call   800f1c <sys_page_unmap>
  8026f1:	83 c4 10             	add    $0x10,%esp
}
  8026f4:	89 d8                	mov    %ebx,%eax
  8026f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5d                   	pop    %ebp
  8026fc:	c3                   	ret    

008026fd <pipeisclosed>:
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802706:	50                   	push   %eax
  802707:	ff 75 08             	pushl  0x8(%ebp)
  80270a:	e8 b9 f0 ff ff       	call   8017c8 <fd_lookup>
  80270f:	83 c4 10             	add    $0x10,%esp
  802712:	85 c0                	test   %eax,%eax
  802714:	78 18                	js     80272e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802716:	83 ec 0c             	sub    $0xc,%esp
  802719:	ff 75 f4             	pushl  -0xc(%ebp)
  80271c:	e8 3e f0 ff ff       	call   80175f <fd2data>
	return _pipeisclosed(fd, p);
  802721:	89 c2                	mov    %eax,%edx
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	e8 2f fd ff ff       	call   80245a <_pipeisclosed>
  80272b:	83 c4 10             	add    $0x10,%esp
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
  802735:	c3                   	ret    

00802736 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80273c:	68 1f 33 80 00       	push   $0x80331f
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	e8 5c e3 ff ff       	call   800aa5 <strcpy>
	return 0;
}
  802749:	b8 00 00 00 00       	mov    $0x0,%eax
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <devcons_write>:
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	57                   	push   %edi
  802754:	56                   	push   %esi
  802755:	53                   	push   %ebx
  802756:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80275c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802761:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802767:	3b 75 10             	cmp    0x10(%ebp),%esi
  80276a:	73 31                	jae    80279d <devcons_write+0x4d>
		m = n - tot;
  80276c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80276f:	29 f3                	sub    %esi,%ebx
  802771:	83 fb 7f             	cmp    $0x7f,%ebx
  802774:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802779:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	53                   	push   %ebx
  802780:	89 f0                	mov    %esi,%eax
  802782:	03 45 0c             	add    0xc(%ebp),%eax
  802785:	50                   	push   %eax
  802786:	57                   	push   %edi
  802787:	e8 a7 e4 ff ff       	call   800c33 <memmove>
		sys_cputs(buf, m);
  80278c:	83 c4 08             	add    $0x8,%esp
  80278f:	53                   	push   %ebx
  802790:	57                   	push   %edi
  802791:	e8 45 e6 ff ff       	call   800ddb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802796:	01 de                	add    %ebx,%esi
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	eb ca                	jmp    802767 <devcons_write+0x17>
}
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a2:	5b                   	pop    %ebx
  8027a3:	5e                   	pop    %esi
  8027a4:	5f                   	pop    %edi
  8027a5:	5d                   	pop    %ebp
  8027a6:	c3                   	ret    

008027a7 <devcons_read>:
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 08             	sub    $0x8,%esp
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b6:	74 21                	je     8027d9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027b8:	e8 3c e6 ff ff       	call   800df9 <sys_cgetc>
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	75 07                	jne    8027c8 <devcons_read+0x21>
		sys_yield();
  8027c1:	e8 b2 e6 ff ff       	call   800e78 <sys_yield>
  8027c6:	eb f0                	jmp    8027b8 <devcons_read+0x11>
	if (c < 0)
  8027c8:	78 0f                	js     8027d9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027ca:	83 f8 04             	cmp    $0x4,%eax
  8027cd:	74 0c                	je     8027db <devcons_read+0x34>
	*(char*)vbuf = c;
  8027cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d2:	88 02                	mov    %al,(%edx)
	return 1;
  8027d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    
		return 0;
  8027db:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e0:	eb f7                	jmp    8027d9 <devcons_read+0x32>

008027e2 <cputchar>:
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027ee:	6a 01                	push   $0x1
  8027f0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027f3:	50                   	push   %eax
  8027f4:	e8 e2 e5 ff ff       	call   800ddb <sys_cputs>
}
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <getchar>:
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802804:	6a 01                	push   $0x1
  802806:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802809:	50                   	push   %eax
  80280a:	6a 00                	push   $0x0
  80280c:	e8 27 f2 ff ff       	call   801a38 <read>
	if (r < 0)
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	85 c0                	test   %eax,%eax
  802816:	78 06                	js     80281e <getchar+0x20>
	if (r < 1)
  802818:	74 06                	je     802820 <getchar+0x22>
	return c;
  80281a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    
		return -E_EOF;
  802820:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802825:	eb f7                	jmp    80281e <getchar+0x20>

00802827 <iscons>:
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80282d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802830:	50                   	push   %eax
  802831:	ff 75 08             	pushl  0x8(%ebp)
  802834:	e8 8f ef ff ff       	call   8017c8 <fd_lookup>
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	85 c0                	test   %eax,%eax
  80283e:	78 11                	js     802851 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802849:	39 10                	cmp    %edx,(%eax)
  80284b:	0f 94 c0             	sete   %al
  80284e:	0f b6 c0             	movzbl %al,%eax
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <opencons>:
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802859:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285c:	50                   	push   %eax
  80285d:	e8 14 ef ff ff       	call   801776 <fd_alloc>
  802862:	83 c4 10             	add    $0x10,%esp
  802865:	85 c0                	test   %eax,%eax
  802867:	78 3a                	js     8028a3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802869:	83 ec 04             	sub    $0x4,%esp
  80286c:	68 07 04 00 00       	push   $0x407
  802871:	ff 75 f4             	pushl  -0xc(%ebp)
  802874:	6a 00                	push   $0x0
  802876:	e8 1c e6 ff ff       	call   800e97 <sys_page_alloc>
  80287b:	83 c4 10             	add    $0x10,%esp
  80287e:	85 c0                	test   %eax,%eax
  802880:	78 21                	js     8028a3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 15 60 40 80 00    	mov    0x804060,%edx
  80288b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802897:	83 ec 0c             	sub    $0xc,%esp
  80289a:	50                   	push   %eax
  80289b:	e8 af ee ff ff       	call   80174f <fd2num>
  8028a0:	83 c4 10             	add    $0x10,%esp
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	56                   	push   %esi
  8028a9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8028aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8028af:	8b 40 48             	mov    0x48(%eax),%eax
  8028b2:	83 ec 04             	sub    $0x4,%esp
  8028b5:	68 50 33 80 00       	push   $0x803350
  8028ba:	50                   	push   %eax
  8028bb:	68 3a 2d 80 00       	push   $0x802d3a
  8028c0:	e8 81 da ff ff       	call   800346 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8028c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028c8:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8028ce:	e8 86 e5 ff ff       	call   800e59 <sys_getenvid>
  8028d3:	83 c4 04             	add    $0x4,%esp
  8028d6:	ff 75 0c             	pushl  0xc(%ebp)
  8028d9:	ff 75 08             	pushl  0x8(%ebp)
  8028dc:	56                   	push   %esi
  8028dd:	50                   	push   %eax
  8028de:	68 2c 33 80 00       	push   $0x80332c
  8028e3:	e8 5e da ff ff       	call   800346 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8028e8:	83 c4 18             	add    $0x18,%esp
  8028eb:	53                   	push   %ebx
  8028ec:	ff 75 10             	pushl  0x10(%ebp)
  8028ef:	e8 01 da ff ff       	call   8002f5 <vcprintf>
	cprintf("\n");
  8028f4:	c7 04 24 fe 2c 80 00 	movl   $0x802cfe,(%esp)
  8028fb:	e8 46 da ff ff       	call   800346 <cprintf>
  802900:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802903:	cc                   	int3   
  802904:	eb fd                	jmp    802903 <_panic+0x5e>

00802906 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80290c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802913:	74 0a                	je     80291f <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	6a 07                	push   $0x7
  802924:	68 00 f0 bf ee       	push   $0xeebff000
  802929:	6a 00                	push   $0x0
  80292b:	e8 67 e5 ff ff       	call   800e97 <sys_page_alloc>
		if(r < 0)
  802930:	83 c4 10             	add    $0x10,%esp
  802933:	85 c0                	test   %eax,%eax
  802935:	78 2a                	js     802961 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802937:	83 ec 08             	sub    $0x8,%esp
  80293a:	68 75 29 80 00       	push   $0x802975
  80293f:	6a 00                	push   $0x0
  802941:	e8 9c e6 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	85 c0                	test   %eax,%eax
  80294b:	79 c8                	jns    802915 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80294d:	83 ec 04             	sub    $0x4,%esp
  802950:	68 88 33 80 00       	push   $0x803388
  802955:	6a 25                	push   $0x25
  802957:	68 c4 33 80 00       	push   $0x8033c4
  80295c:	e8 44 ff ff ff       	call   8028a5 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 58 33 80 00       	push   $0x803358
  802969:	6a 22                	push   $0x22
  80296b:	68 c4 33 80 00       	push   $0x8033c4
  802970:	e8 30 ff ff ff       	call   8028a5 <_panic>

00802975 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802975:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802976:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80297b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80297d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802980:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802984:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802988:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80298b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80298d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802991:	83 c4 08             	add    $0x8,%esp
	popal
  802994:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802995:	83 c4 04             	add    $0x4,%esp
	popfl
  802998:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802999:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80299a:	c3                   	ret    

0080299b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029a1:	89 d0                	mov    %edx,%eax
  8029a3:	c1 e8 16             	shr    $0x16,%eax
  8029a6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029b2:	f6 c1 01             	test   $0x1,%cl
  8029b5:	74 1d                	je     8029d4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029b7:	c1 ea 0c             	shr    $0xc,%edx
  8029ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029c1:	f6 c2 01             	test   $0x1,%dl
  8029c4:	74 0e                	je     8029d4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029c6:	c1 ea 0c             	shr    $0xc,%edx
  8029c9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029d0:	ef 
  8029d1:	0f b7 c0             	movzwl %ax,%eax
}
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	66 90                	xchg   %ax,%ax
  8029d8:	66 90                	xchg   %ax,%ax
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__udivdi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	83 ec 1c             	sub    $0x1c,%esp
  8029e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029f7:	85 d2                	test   %edx,%edx
  8029f9:	75 4d                	jne    802a48 <__udivdi3+0x68>
  8029fb:	39 f3                	cmp    %esi,%ebx
  8029fd:	76 19                	jbe    802a18 <__udivdi3+0x38>
  8029ff:	31 ff                	xor    %edi,%edi
  802a01:	89 e8                	mov    %ebp,%eax
  802a03:	89 f2                	mov    %esi,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 d9                	mov    %ebx,%ecx
  802a1a:	85 db                	test   %ebx,%ebx
  802a1c:	75 0b                	jne    802a29 <__udivdi3+0x49>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f3                	div    %ebx
  802a27:	89 c1                	mov    %eax,%ecx
  802a29:	31 d2                	xor    %edx,%edx
  802a2b:	89 f0                	mov    %esi,%eax
  802a2d:	f7 f1                	div    %ecx
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	89 e8                	mov    %ebp,%eax
  802a33:	89 f7                	mov    %esi,%edi
  802a35:	f7 f1                	div    %ecx
  802a37:	89 fa                	mov    %edi,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	39 f2                	cmp    %esi,%edx
  802a4a:	77 1c                	ja     802a68 <__udivdi3+0x88>
  802a4c:	0f bd fa             	bsr    %edx,%edi
  802a4f:	83 f7 1f             	xor    $0x1f,%edi
  802a52:	75 2c                	jne    802a80 <__udivdi3+0xa0>
  802a54:	39 f2                	cmp    %esi,%edx
  802a56:	72 06                	jb     802a5e <__udivdi3+0x7e>
  802a58:	31 c0                	xor    %eax,%eax
  802a5a:	39 eb                	cmp    %ebp,%ebx
  802a5c:	77 a9                	ja     802a07 <__udivdi3+0x27>
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	eb a2                	jmp    802a07 <__udivdi3+0x27>
  802a65:	8d 76 00             	lea    0x0(%esi),%esi
  802a68:	31 ff                	xor    %edi,%edi
  802a6a:	31 c0                	xor    %eax,%eax
  802a6c:	89 fa                	mov    %edi,%edx
  802a6e:	83 c4 1c             	add    $0x1c,%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
  802a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a7d:	8d 76 00             	lea    0x0(%esi),%esi
  802a80:	89 f9                	mov    %edi,%ecx
  802a82:	b8 20 00 00 00       	mov    $0x20,%eax
  802a87:	29 f8                	sub    %edi,%eax
  802a89:	d3 e2                	shl    %cl,%edx
  802a8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a8f:	89 c1                	mov    %eax,%ecx
  802a91:	89 da                	mov    %ebx,%edx
  802a93:	d3 ea                	shr    %cl,%edx
  802a95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a99:	09 d1                	or     %edx,%ecx
  802a9b:	89 f2                	mov    %esi,%edx
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 f9                	mov    %edi,%ecx
  802aa3:	d3 e3                	shl    %cl,%ebx
  802aa5:	89 c1                	mov    %eax,%ecx
  802aa7:	d3 ea                	shr    %cl,%edx
  802aa9:	89 f9                	mov    %edi,%ecx
  802aab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802aaf:	89 eb                	mov    %ebp,%ebx
  802ab1:	d3 e6                	shl    %cl,%esi
  802ab3:	89 c1                	mov    %eax,%ecx
  802ab5:	d3 eb                	shr    %cl,%ebx
  802ab7:	09 de                	or     %ebx,%esi
  802ab9:	89 f0                	mov    %esi,%eax
  802abb:	f7 74 24 08          	divl   0x8(%esp)
  802abf:	89 d6                	mov    %edx,%esi
  802ac1:	89 c3                	mov    %eax,%ebx
  802ac3:	f7 64 24 0c          	mull   0xc(%esp)
  802ac7:	39 d6                	cmp    %edx,%esi
  802ac9:	72 15                	jb     802ae0 <__udivdi3+0x100>
  802acb:	89 f9                	mov    %edi,%ecx
  802acd:	d3 e5                	shl    %cl,%ebp
  802acf:	39 c5                	cmp    %eax,%ebp
  802ad1:	73 04                	jae    802ad7 <__udivdi3+0xf7>
  802ad3:	39 d6                	cmp    %edx,%esi
  802ad5:	74 09                	je     802ae0 <__udivdi3+0x100>
  802ad7:	89 d8                	mov    %ebx,%eax
  802ad9:	31 ff                	xor    %edi,%edi
  802adb:	e9 27 ff ff ff       	jmp    802a07 <__udivdi3+0x27>
  802ae0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ae3:	31 ff                	xor    %edi,%edi
  802ae5:	e9 1d ff ff ff       	jmp    802a07 <__udivdi3+0x27>
  802aea:	66 90                	xchg   %ax,%ax
  802aec:	66 90                	xchg   %ax,%ax
  802aee:	66 90                	xchg   %ax,%ax

00802af0 <__umoddi3>:
  802af0:	55                   	push   %ebp
  802af1:	57                   	push   %edi
  802af2:	56                   	push   %esi
  802af3:	53                   	push   %ebx
  802af4:	83 ec 1c             	sub    $0x1c,%esp
  802af7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b07:	89 da                	mov    %ebx,%edx
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	75 43                	jne    802b50 <__umoddi3+0x60>
  802b0d:	39 df                	cmp    %ebx,%edi
  802b0f:	76 17                	jbe    802b28 <__umoddi3+0x38>
  802b11:	89 f0                	mov    %esi,%eax
  802b13:	f7 f7                	div    %edi
  802b15:	89 d0                	mov    %edx,%eax
  802b17:	31 d2                	xor    %edx,%edx
  802b19:	83 c4 1c             	add    $0x1c,%esp
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 fd                	mov    %edi,%ebp
  802b2a:	85 ff                	test   %edi,%edi
  802b2c:	75 0b                	jne    802b39 <__umoddi3+0x49>
  802b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f7                	div    %edi
  802b37:	89 c5                	mov    %eax,%ebp
  802b39:	89 d8                	mov    %ebx,%eax
  802b3b:	31 d2                	xor    %edx,%edx
  802b3d:	f7 f5                	div    %ebp
  802b3f:	89 f0                	mov    %esi,%eax
  802b41:	f7 f5                	div    %ebp
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	eb d0                	jmp    802b17 <__umoddi3+0x27>
  802b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b4e:	66 90                	xchg   %ax,%ax
  802b50:	89 f1                	mov    %esi,%ecx
  802b52:	39 d8                	cmp    %ebx,%eax
  802b54:	76 0a                	jbe    802b60 <__umoddi3+0x70>
  802b56:	89 f0                	mov    %esi,%eax
  802b58:	83 c4 1c             	add    $0x1c,%esp
  802b5b:	5b                   	pop    %ebx
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	0f bd e8             	bsr    %eax,%ebp
  802b63:	83 f5 1f             	xor    $0x1f,%ebp
  802b66:	75 20                	jne    802b88 <__umoddi3+0x98>
  802b68:	39 d8                	cmp    %ebx,%eax
  802b6a:	0f 82 b0 00 00 00    	jb     802c20 <__umoddi3+0x130>
  802b70:	39 f7                	cmp    %esi,%edi
  802b72:	0f 86 a8 00 00 00    	jbe    802c20 <__umoddi3+0x130>
  802b78:	89 c8                	mov    %ecx,%eax
  802b7a:	83 c4 1c             	add    $0x1c,%esp
  802b7d:	5b                   	pop    %ebx
  802b7e:	5e                   	pop    %esi
  802b7f:	5f                   	pop    %edi
  802b80:	5d                   	pop    %ebp
  802b81:	c3                   	ret    
  802b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b88:	89 e9                	mov    %ebp,%ecx
  802b8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b8f:	29 ea                	sub    %ebp,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b97:	89 d1                	mov    %edx,%ecx
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	d3 e8                	shr    %cl,%eax
  802b9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ba5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ba9:	09 c1                	or     %eax,%ecx
  802bab:	89 d8                	mov    %ebx,%eax
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bbf:	d3 e3                	shl    %cl,%ebx
  802bc1:	89 c7                	mov    %eax,%edi
  802bc3:	89 d1                	mov    %edx,%ecx
  802bc5:	89 f0                	mov    %esi,%eax
  802bc7:	d3 e8                	shr    %cl,%eax
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	89 fa                	mov    %edi,%edx
  802bcd:	d3 e6                	shl    %cl,%esi
  802bcf:	09 d8                	or     %ebx,%eax
  802bd1:	f7 74 24 08          	divl   0x8(%esp)
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	89 f3                	mov    %esi,%ebx
  802bd9:	f7 64 24 0c          	mull   0xc(%esp)
  802bdd:	89 c6                	mov    %eax,%esi
  802bdf:	89 d7                	mov    %edx,%edi
  802be1:	39 d1                	cmp    %edx,%ecx
  802be3:	72 06                	jb     802beb <__umoddi3+0xfb>
  802be5:	75 10                	jne    802bf7 <__umoddi3+0x107>
  802be7:	39 c3                	cmp    %eax,%ebx
  802be9:	73 0c                	jae    802bf7 <__umoddi3+0x107>
  802beb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bf3:	89 d7                	mov    %edx,%edi
  802bf5:	89 c6                	mov    %eax,%esi
  802bf7:	89 ca                	mov    %ecx,%edx
  802bf9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bfe:	29 f3                	sub    %esi,%ebx
  802c00:	19 fa                	sbb    %edi,%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	d3 e0                	shl    %cl,%eax
  802c06:	89 e9                	mov    %ebp,%ecx
  802c08:	d3 eb                	shr    %cl,%ebx
  802c0a:	d3 ea                	shr    %cl,%edx
  802c0c:	09 d8                	or     %ebx,%eax
  802c0e:	83 c4 1c             	add    $0x1c,%esp
  802c11:	5b                   	pop    %ebx
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	89 da                	mov    %ebx,%edx
  802c22:	29 fe                	sub    %edi,%esi
  802c24:	19 c2                	sbb    %eax,%edx
  802c26:	89 f1                	mov    %esi,%ecx
  802c28:	89 c8                	mov    %ecx,%eax
  802c2a:	e9 4b ff ff ff       	jmp    802b7a <__umoddi3+0x8a>
