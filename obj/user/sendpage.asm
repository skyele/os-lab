
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
  800039:	e8 a3 13 00 00       	call   8013e1 <fork>
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
  800092:	e8 45 16 00 00       	call   8016dc <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 c9 15 00 00       	call   801673 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 60 2c 80 00       	push   $0x802c60
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
  8000fc:	e8 72 15 00 00       	call   801673 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 60 2c 80 00       	push   $0x802c60
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
  800170:	e8 67 15 00 00       	call   8016dc <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 74 2c 80 00       	push   $0x802c74
  800185:	e8 bc 01 00 00       	call   800346 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 94 2c 80 00       	push   $0x802c94
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
  800227:	68 02 2d 80 00       	push   $0x802d02
  80022c:	e8 15 01 00 00       	call   800346 <cprintf>
	cprintf("before umain\n");
  800231:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  800238:	e8 09 01 00 00       	call   800346 <cprintf>
	// call user main routine
	umain(argc, argv);
  80023d:	83 c4 08             	add    $0x8,%esp
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 e8 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80024b:	c7 04 24 2e 2d 80 00 	movl   $0x802d2e,(%esp)
  800252:	e8 ef 00 00 00       	call   800346 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800257:	a1 08 50 80 00       	mov    0x805008,%eax
  80025c:	8b 40 48             	mov    0x48(%eax),%eax
  80025f:	83 c4 08             	add    $0x8,%esp
  800262:	50                   	push   %eax
  800263:	68 3b 2d 80 00       	push   $0x802d3b
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
  80028b:	68 68 2d 80 00       	push   $0x802d68
  800290:	50                   	push   %eax
  800291:	68 5a 2d 80 00       	push   $0x802d5a
  800296:	e8 ab 00 00 00       	call   800346 <cprintf>
	close_all();
  80029b:	e8 a7 16 00 00       	call   801947 <close_all>
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
  8003f3:	e8 08 26 00 00       	call   802a00 <__udivdi3>
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
  80041c:	e8 ef 26 00 00       	call   802b10 <__umoddi3>
  800421:	83 c4 14             	add    $0x14,%esp
  800424:	0f be 80 6d 2d 80 00 	movsbl 0x802d6d(%eax),%eax
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
  8004cd:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
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
  800598:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	74 18                	je     8005bb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a3:	52                   	push   %edx
  8005a4:	68 cd 32 80 00       	push   $0x8032cd
  8005a9:	53                   	push   %ebx
  8005aa:	56                   	push   %esi
  8005ab:	e8 a6 fe ff ff       	call   800456 <printfmt>
  8005b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b6:	e9 fe 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bb:	50                   	push   %eax
  8005bc:	68 85 2d 80 00       	push   $0x802d85
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
  8005e3:	b8 7e 2d 80 00       	mov    $0x802d7e,%eax
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
  80097b:	bf a1 2e 80 00       	mov    $0x802ea1,%edi
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
  8009a7:	bf d9 2e 80 00       	mov    $0x802ed9,%edi
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
  800e48:	68 e8 30 80 00       	push   $0x8030e8
  800e4d:	6a 43                	push   $0x43
  800e4f:	68 05 31 80 00       	push   $0x803105
  800e54:	e8 6c 1a 00 00       	call   8028c5 <_panic>

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
  800ec9:	68 e8 30 80 00       	push   $0x8030e8
  800ece:	6a 43                	push   $0x43
  800ed0:	68 05 31 80 00       	push   $0x803105
  800ed5:	e8 eb 19 00 00       	call   8028c5 <_panic>

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
  800f0b:	68 e8 30 80 00       	push   $0x8030e8
  800f10:	6a 43                	push   $0x43
  800f12:	68 05 31 80 00       	push   $0x803105
  800f17:	e8 a9 19 00 00       	call   8028c5 <_panic>

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
  800f4d:	68 e8 30 80 00       	push   $0x8030e8
  800f52:	6a 43                	push   $0x43
  800f54:	68 05 31 80 00       	push   $0x803105
  800f59:	e8 67 19 00 00       	call   8028c5 <_panic>

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
  800f8f:	68 e8 30 80 00       	push   $0x8030e8
  800f94:	6a 43                	push   $0x43
  800f96:	68 05 31 80 00       	push   $0x803105
  800f9b:	e8 25 19 00 00       	call   8028c5 <_panic>

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
  800fd1:	68 e8 30 80 00       	push   $0x8030e8
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 05 31 80 00       	push   $0x803105
  800fdd:	e8 e3 18 00 00       	call   8028c5 <_panic>

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
  801013:	68 e8 30 80 00       	push   $0x8030e8
  801018:	6a 43                	push   $0x43
  80101a:	68 05 31 80 00       	push   $0x803105
  80101f:	e8 a1 18 00 00       	call   8028c5 <_panic>

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
  801077:	68 e8 30 80 00       	push   $0x8030e8
  80107c:	6a 43                	push   $0x43
  80107e:	68 05 31 80 00       	push   $0x803105
  801083:	e8 3d 18 00 00       	call   8028c5 <_panic>

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
  80115b:	68 e8 30 80 00       	push   $0x8030e8
  801160:	6a 43                	push   $0x43
  801162:	68 05 31 80 00       	push   $0x803105
  801167:	e8 59 17 00 00       	call   8028c5 <_panic>

0080116c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
	asm volatile("int %1\n"
  801172:	b9 00 00 00 00       	mov    $0x0,%ecx
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
  80117a:	b8 14 00 00 00       	mov    $0x14,%eax
  80117f:	89 cb                	mov    %ecx,%ebx
  801181:	89 cf                	mov    %ecx,%edi
  801183:	89 ce                	mov    %ecx,%esi
  801185:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	53                   	push   %ebx
  801190:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801193:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80119a:	f6 c5 04             	test   $0x4,%ch
  80119d:	75 45                	jne    8011e4 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80119f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011a6:	83 e1 07             	and    $0x7,%ecx
  8011a9:	83 f9 07             	cmp    $0x7,%ecx
  8011ac:	74 6f                	je     80121d <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011ae:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b5:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011bb:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011c1:	0f 84 b6 00 00 00    	je     80127d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011c7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ce:	83 e1 05             	and    $0x5,%ecx
  8011d1:	83 f9 05             	cmp    $0x5,%ecx
  8011d4:	0f 84 d7 00 00 00    	je     8012b1 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
  8011df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011e4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011eb:	c1 e2 0c             	shl    $0xc,%edx
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011f7:	51                   	push   %ecx
  8011f8:	52                   	push   %edx
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 d8 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801202:	83 c4 20             	add    $0x20,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	79 d1                	jns    8011da <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	68 13 31 80 00       	push   $0x803113
  801211:	6a 54                	push   $0x54
  801213:	68 29 31 80 00       	push   $0x803129
  801218:	e8 a8 16 00 00       	call   8028c5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80121d:	89 d3                	mov    %edx,%ebx
  80121f:	c1 e3 0c             	shl    $0xc,%ebx
  801222:	83 ec 0c             	sub    $0xc,%esp
  801225:	68 05 08 00 00       	push   $0x805
  80122a:	53                   	push   %ebx
  80122b:	50                   	push   %eax
  80122c:	53                   	push   %ebx
  80122d:	6a 00                	push   $0x0
  80122f:	e8 a6 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801234:	83 c4 20             	add    $0x20,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 2e                	js     801269 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	68 05 08 00 00       	push   $0x805
  801243:	53                   	push   %ebx
  801244:	6a 00                	push   $0x0
  801246:	53                   	push   %ebx
  801247:	6a 00                	push   $0x0
  801249:	e8 8c fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  80124e:	83 c4 20             	add    $0x20,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	79 85                	jns    8011da <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 13 31 80 00       	push   $0x803113
  80125d:	6a 5f                	push   $0x5f
  80125f:	68 29 31 80 00       	push   $0x803129
  801264:	e8 5c 16 00 00       	call   8028c5 <_panic>
			panic("sys_page_map() panic\n");
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	68 13 31 80 00       	push   $0x803113
  801271:	6a 5b                	push   $0x5b
  801273:	68 29 31 80 00       	push   $0x803129
  801278:	e8 48 16 00 00       	call   8028c5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80127d:	c1 e2 0c             	shl    $0xc,%edx
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	68 05 08 00 00       	push   $0x805
  801288:	52                   	push   %edx
  801289:	50                   	push   %eax
  80128a:	52                   	push   %edx
  80128b:	6a 00                	push   $0x0
  80128d:	e8 48 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801292:	83 c4 20             	add    $0x20,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	0f 89 3d ff ff ff    	jns    8011da <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	68 13 31 80 00       	push   $0x803113
  8012a5:	6a 66                	push   $0x66
  8012a7:	68 29 31 80 00       	push   $0x803129
  8012ac:	e8 14 16 00 00       	call   8028c5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012b1:	c1 e2 0c             	shl    $0xc,%edx
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	6a 05                	push   $0x5
  8012b9:	52                   	push   %edx
  8012ba:	50                   	push   %eax
  8012bb:	52                   	push   %edx
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 17 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8012c3:	83 c4 20             	add    $0x20,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	0f 89 0c ff ff ff    	jns    8011da <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	68 13 31 80 00       	push   $0x803113
  8012d6:	6a 6d                	push   $0x6d
  8012d8:	68 29 31 80 00       	push   $0x803129
  8012dd:	e8 e3 15 00 00       	call   8028c5 <_panic>

008012e2 <pgfault>:
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012ec:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ee:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012f2:	0f 84 99 00 00 00    	je     801391 <pgfault+0xaf>
  8012f8:	89 c2                	mov    %eax,%edx
  8012fa:	c1 ea 16             	shr    $0x16,%edx
  8012fd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801304:	f6 c2 01             	test   $0x1,%dl
  801307:	0f 84 84 00 00 00    	je     801391 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	c1 ea 0c             	shr    $0xc,%edx
  801312:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801319:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80131f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801325:	75 6a                	jne    801391 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801327:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80132e:	83 ec 04             	sub    $0x4,%esp
  801331:	6a 07                	push   $0x7
  801333:	68 00 f0 7f 00       	push   $0x7ff000
  801338:	6a 00                	push   $0x0
  80133a:	e8 58 fb ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80133f:	83 c4 10             	add    $0x10,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	78 5f                	js     8013a5 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	68 00 10 00 00       	push   $0x1000
  80134e:	53                   	push   %ebx
  80134f:	68 00 f0 7f 00       	push   $0x7ff000
  801354:	e8 3c f9 ff ff       	call   800c95 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801359:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801360:	53                   	push   %ebx
  801361:	6a 00                	push   $0x0
  801363:	68 00 f0 7f 00       	push   $0x7ff000
  801368:	6a 00                	push   $0x0
  80136a:	e8 6b fb ff ff       	call   800eda <sys_page_map>
	if(ret < 0)
  80136f:	83 c4 20             	add    $0x20,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 43                	js     8013b9 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	68 00 f0 7f 00       	push   $0x7ff000
  80137e:	6a 00                	push   $0x0
  801380:	e8 97 fb ff ff       	call   800f1c <sys_page_unmap>
	if(ret < 0)
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 41                	js     8013cd <pgfault+0xeb>
}
  80138c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138f:	c9                   	leave  
  801390:	c3                   	ret    
		panic("panic at pgfault()\n");
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	68 34 31 80 00       	push   $0x803134
  801399:	6a 26                	push   $0x26
  80139b:	68 29 31 80 00       	push   $0x803129
  8013a0:	e8 20 15 00 00       	call   8028c5 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	68 48 31 80 00       	push   $0x803148
  8013ad:	6a 31                	push   $0x31
  8013af:	68 29 31 80 00       	push   $0x803129
  8013b4:	e8 0c 15 00 00       	call   8028c5 <_panic>
		panic("panic in sys_page_map()\n");
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	68 63 31 80 00       	push   $0x803163
  8013c1:	6a 36                	push   $0x36
  8013c3:	68 29 31 80 00       	push   $0x803129
  8013c8:	e8 f8 14 00 00       	call   8028c5 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	68 7c 31 80 00       	push   $0x80317c
  8013d5:	6a 39                	push   $0x39
  8013d7:	68 29 31 80 00       	push   $0x803129
  8013dc:	e8 e4 14 00 00       	call   8028c5 <_panic>

008013e1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	57                   	push   %edi
  8013e5:	56                   	push   %esi
  8013e6:	53                   	push   %ebx
  8013e7:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013ea:	68 e2 12 80 00       	push   $0x8012e2
  8013ef:	e8 32 15 00 00       	call   802926 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013f4:	b8 07 00 00 00       	mov    $0x7,%eax
  8013f9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 27                	js     801429 <fork+0x48>
  801402:	89 c6                	mov    %eax,%esi
  801404:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801406:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80140b:	75 48                	jne    801455 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80140d:	e8 47 fa ff ff       	call   800e59 <sys_getenvid>
  801412:	25 ff 03 00 00       	and    $0x3ff,%eax
  801417:	c1 e0 07             	shl    $0x7,%eax
  80141a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80141f:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801424:	e9 90 00 00 00       	jmp    8014b9 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	68 98 31 80 00       	push   $0x803198
  801431:	68 8c 00 00 00       	push   $0x8c
  801436:	68 29 31 80 00       	push   $0x803129
  80143b:	e8 85 14 00 00       	call   8028c5 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801440:	89 f8                	mov    %edi,%eax
  801442:	e8 45 fd ff ff       	call   80118c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80144d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801453:	74 26                	je     80147b <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801455:	89 d8                	mov    %ebx,%eax
  801457:	c1 e8 16             	shr    $0x16,%eax
  80145a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801461:	a8 01                	test   $0x1,%al
  801463:	74 e2                	je     801447 <fork+0x66>
  801465:	89 da                	mov    %ebx,%edx
  801467:	c1 ea 0c             	shr    $0xc,%edx
  80146a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801471:	83 e0 05             	and    $0x5,%eax
  801474:	83 f8 05             	cmp    $0x5,%eax
  801477:	75 ce                	jne    801447 <fork+0x66>
  801479:	eb c5                	jmp    801440 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	6a 07                	push   $0x7
  801480:	68 00 f0 bf ee       	push   $0xeebff000
  801485:	56                   	push   %esi
  801486:	e8 0c fa ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 31                	js     8014c3 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	68 95 29 80 00       	push   $0x802995
  80149a:	56                   	push   %esi
  80149b:	e8 42 fb ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	78 33                	js     8014da <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	6a 02                	push   $0x2
  8014ac:	56                   	push   %esi
  8014ad:	e8 ac fa ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 38                	js     8014f1 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014b9:	89 f0                	mov    %esi,%eax
  8014bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 48 31 80 00       	push   $0x803148
  8014cb:	68 98 00 00 00       	push   $0x98
  8014d0:	68 29 31 80 00       	push   $0x803129
  8014d5:	e8 eb 13 00 00       	call   8028c5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	68 bc 31 80 00       	push   $0x8031bc
  8014e2:	68 9b 00 00 00       	push   $0x9b
  8014e7:	68 29 31 80 00       	push   $0x803129
  8014ec:	e8 d4 13 00 00       	call   8028c5 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	68 e4 31 80 00       	push   $0x8031e4
  8014f9:	68 9e 00 00 00       	push   $0x9e
  8014fe:	68 29 31 80 00       	push   $0x803129
  801503:	e8 bd 13 00 00       	call   8028c5 <_panic>

00801508 <sfork>:

// Challenge!
int
sfork(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	57                   	push   %edi
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801511:	68 e2 12 80 00       	push   $0x8012e2
  801516:	e8 0b 14 00 00       	call   802926 <set_pgfault_handler>
  80151b:	b8 07 00 00 00       	mov    $0x7,%eax
  801520:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 27                	js     801550 <sfork+0x48>
  801529:	89 c7                	mov    %eax,%edi
  80152b:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80152d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801532:	75 55                	jne    801589 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801534:	e8 20 f9 ff ff       	call   800e59 <sys_getenvid>
  801539:	25 ff 03 00 00       	and    $0x3ff,%eax
  80153e:	c1 e0 07             	shl    $0x7,%eax
  801541:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801546:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80154b:	e9 d4 00 00 00       	jmp    801624 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	68 98 31 80 00       	push   $0x803198
  801558:	68 af 00 00 00       	push   $0xaf
  80155d:	68 29 31 80 00       	push   $0x803129
  801562:	e8 5e 13 00 00       	call   8028c5 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801567:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80156c:	89 f0                	mov    %esi,%eax
  80156e:	e8 19 fc ff ff       	call   80118c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801573:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801579:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80157f:	77 65                	ja     8015e6 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801581:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801587:	74 de                	je     801567 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801589:	89 d8                	mov    %ebx,%eax
  80158b:	c1 e8 16             	shr    $0x16,%eax
  80158e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801595:	a8 01                	test   $0x1,%al
  801597:	74 da                	je     801573 <sfork+0x6b>
  801599:	89 da                	mov    %ebx,%edx
  80159b:	c1 ea 0c             	shr    $0xc,%edx
  80159e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015a5:	83 e0 05             	and    $0x5,%eax
  8015a8:	83 f8 05             	cmp    $0x5,%eax
  8015ab:	75 c6                	jne    801573 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015ad:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015b4:	c1 e2 0c             	shl    $0xc,%edx
  8015b7:	83 ec 0c             	sub    $0xc,%esp
  8015ba:	83 e0 07             	and    $0x7,%eax
  8015bd:	50                   	push   %eax
  8015be:	52                   	push   %edx
  8015bf:	56                   	push   %esi
  8015c0:	52                   	push   %edx
  8015c1:	6a 00                	push   $0x0
  8015c3:	e8 12 f9 ff ff       	call   800eda <sys_page_map>
  8015c8:	83 c4 20             	add    $0x20,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	74 a4                	je     801573 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 13 31 80 00       	push   $0x803113
  8015d7:	68 ba 00 00 00       	push   $0xba
  8015dc:	68 29 31 80 00       	push   $0x803129
  8015e1:	e8 df 12 00 00       	call   8028c5 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	6a 07                	push   $0x7
  8015eb:	68 00 f0 bf ee       	push   $0xeebff000
  8015f0:	57                   	push   %edi
  8015f1:	e8 a1 f8 ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 31                	js     80162e <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	68 95 29 80 00       	push   $0x802995
  801605:	57                   	push   %edi
  801606:	e8 d7 f9 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 33                	js     801645 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	6a 02                	push   $0x2
  801617:	57                   	push   %edi
  801618:	e8 41 f9 ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	85 c0                	test   %eax,%eax
  801622:	78 38                	js     80165c <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801624:	89 f8                	mov    %edi,%eax
  801626:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5f                   	pop    %edi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	68 48 31 80 00       	push   $0x803148
  801636:	68 c0 00 00 00       	push   $0xc0
  80163b:	68 29 31 80 00       	push   $0x803129
  801640:	e8 80 12 00 00       	call   8028c5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 bc 31 80 00       	push   $0x8031bc
  80164d:	68 c3 00 00 00       	push   $0xc3
  801652:	68 29 31 80 00       	push   $0x803129
  801657:	e8 69 12 00 00       	call   8028c5 <_panic>
		panic("panic in sys_env_set_status()\n");
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	68 e4 31 80 00       	push   $0x8031e4
  801664:	68 c6 00 00 00       	push   $0xc6
  801669:	68 29 31 80 00       	push   $0x803129
  80166e:	e8 52 12 00 00       	call   8028c5 <_panic>

00801673 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
  801678:	8b 75 08             	mov    0x8(%ebp),%esi
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801681:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801683:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801688:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80168b:	83 ec 0c             	sub    $0xc,%esp
  80168e:	50                   	push   %eax
  80168f:	e8 b3 f9 ff ff       	call   801047 <sys_ipc_recv>
	if(ret < 0){
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	78 2b                	js     8016c6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80169b:	85 f6                	test   %esi,%esi
  80169d:	74 0a                	je     8016a9 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80169f:	a1 08 50 80 00       	mov    0x805008,%eax
  8016a4:	8b 40 74             	mov    0x74(%eax),%eax
  8016a7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016a9:	85 db                	test   %ebx,%ebx
  8016ab:	74 0a                	je     8016b7 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8016ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8016b2:	8b 40 78             	mov    0x78(%eax),%eax
  8016b5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8016b7:	a1 08 50 80 00       	mov    0x805008,%eax
  8016bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    
		if(from_env_store)
  8016c6:	85 f6                	test   %esi,%esi
  8016c8:	74 06                	je     8016d0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016ca:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016d0:	85 db                	test   %ebx,%ebx
  8016d2:	74 eb                	je     8016bf <ipc_recv+0x4c>
			*perm_store = 0;
  8016d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016da:	eb e3                	jmp    8016bf <ipc_recv+0x4c>

008016dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 0c             	sub    $0xc,%esp
  8016e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016ee:	85 db                	test   %ebx,%ebx
  8016f0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016f5:	0f 44 d8             	cmove  %eax,%ebx
  8016f8:	eb 05                	jmp    8016ff <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8016fa:	e8 79 f7 ff ff       	call   800e78 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016ff:	ff 75 14             	pushl  0x14(%ebp)
  801702:	53                   	push   %ebx
  801703:	56                   	push   %esi
  801704:	57                   	push   %edi
  801705:	e8 1a f9 ff ff       	call   801024 <sys_ipc_try_send>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	74 1b                	je     80172c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801711:	79 e7                	jns    8016fa <ipc_send+0x1e>
  801713:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801716:	74 e2                	je     8016fa <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 03 32 80 00       	push   $0x803203
  801720:	6a 46                	push   $0x46
  801722:	68 18 32 80 00       	push   $0x803218
  801727:	e8 99 11 00 00       	call   8028c5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80172c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5f                   	pop    %edi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80173f:	89 c2                	mov    %eax,%edx
  801741:	c1 e2 07             	shl    $0x7,%edx
  801744:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80174a:	8b 52 50             	mov    0x50(%edx),%edx
  80174d:	39 ca                	cmp    %ecx,%edx
  80174f:	74 11                	je     801762 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801751:	83 c0 01             	add    $0x1,%eax
  801754:	3d 00 04 00 00       	cmp    $0x400,%eax
  801759:	75 e4                	jne    80173f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
  801760:	eb 0b                	jmp    80176d <ipc_find_env+0x39>
			return envs[i].env_id;
  801762:	c1 e0 07             	shl    $0x7,%eax
  801765:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80176a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    

0080176f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	05 00 00 00 30       	add    $0x30000000,%eax
  80177a:	c1 e8 0c             	shr    $0xc,%eax
}
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80178a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80178f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80179e:	89 c2                	mov    %eax,%edx
  8017a0:	c1 ea 16             	shr    $0x16,%edx
  8017a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017aa:	f6 c2 01             	test   $0x1,%dl
  8017ad:	74 2d                	je     8017dc <fd_alloc+0x46>
  8017af:	89 c2                	mov    %eax,%edx
  8017b1:	c1 ea 0c             	shr    $0xc,%edx
  8017b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017bb:	f6 c2 01             	test   $0x1,%dl
  8017be:	74 1c                	je     8017dc <fd_alloc+0x46>
  8017c0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017c5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017ca:	75 d2                	jne    80179e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017d5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017da:	eb 0a                	jmp    8017e6 <fd_alloc+0x50>
			*fd_store = fd;
  8017dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017ee:	83 f8 1f             	cmp    $0x1f,%eax
  8017f1:	77 30                	ja     801823 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017f3:	c1 e0 0c             	shl    $0xc,%eax
  8017f6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017fb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801801:	f6 c2 01             	test   $0x1,%dl
  801804:	74 24                	je     80182a <fd_lookup+0x42>
  801806:	89 c2                	mov    %eax,%edx
  801808:	c1 ea 0c             	shr    $0xc,%edx
  80180b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801812:	f6 c2 01             	test   $0x1,%dl
  801815:	74 1a                	je     801831 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	89 02                	mov    %eax,(%edx)
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    
		return -E_INVAL;
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801828:	eb f7                	jmp    801821 <fd_lookup+0x39>
		return -E_INVAL;
  80182a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182f:	eb f0                	jmp    801821 <fd_lookup+0x39>
  801831:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801836:	eb e9                	jmp    801821 <fd_lookup+0x39>

00801838 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80184b:	39 08                	cmp    %ecx,(%eax)
  80184d:	74 38                	je     801887 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80184f:	83 c2 01             	add    $0x1,%edx
  801852:	8b 04 95 a0 32 80 00 	mov    0x8032a0(,%edx,4),%eax
  801859:	85 c0                	test   %eax,%eax
  80185b:	75 ee                	jne    80184b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80185d:	a1 08 50 80 00       	mov    0x805008,%eax
  801862:	8b 40 48             	mov    0x48(%eax),%eax
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	51                   	push   %ecx
  801869:	50                   	push   %eax
  80186a:	68 24 32 80 00       	push   $0x803224
  80186f:	e8 d2 ea ff ff       	call   800346 <cprintf>
	*dev = 0;
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    
			*dev = devtab[i];
  801887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	eb f2                	jmp    801885 <dev_lookup+0x4d>

00801893 <fd_close>:
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	57                   	push   %edi
  801897:	56                   	push   %esi
  801898:	53                   	push   %ebx
  801899:	83 ec 24             	sub    $0x24,%esp
  80189c:	8b 75 08             	mov    0x8(%ebp),%esi
  80189f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018a6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018ac:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018af:	50                   	push   %eax
  8018b0:	e8 33 ff ff ff       	call   8017e8 <fd_lookup>
  8018b5:	89 c3                	mov    %eax,%ebx
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 05                	js     8018c3 <fd_close+0x30>
	    || fd != fd2)
  8018be:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018c1:	74 16                	je     8018d9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018c3:	89 f8                	mov    %edi,%eax
  8018c5:	84 c0                	test   %al,%al
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	0f 44 d8             	cmove  %eax,%ebx
}
  8018cf:	89 d8                	mov    %ebx,%eax
  8018d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5f                   	pop    %edi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018df:	50                   	push   %eax
  8018e0:	ff 36                	pushl  (%esi)
  8018e2:	e8 51 ff ff ff       	call   801838 <dev_lookup>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 1a                	js     80190a <fd_close+0x77>
		if (dev->dev_close)
  8018f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	74 0b                	je     80190a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	56                   	push   %esi
  801903:	ff d0                	call   *%eax
  801905:	89 c3                	mov    %eax,%ebx
  801907:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	56                   	push   %esi
  80190e:	6a 00                	push   $0x0
  801910:	e8 07 f6 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	eb b5                	jmp    8018cf <fd_close+0x3c>

0080191a <close>:

int
close(int fdnum)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801920:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801923:	50                   	push   %eax
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 bc fe ff ff       	call   8017e8 <fd_lookup>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	79 02                	jns    801935 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    
		return fd_close(fd, 1);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	6a 01                	push   $0x1
  80193a:	ff 75 f4             	pushl  -0xc(%ebp)
  80193d:	e8 51 ff ff ff       	call   801893 <fd_close>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	eb ec                	jmp    801933 <close+0x19>

00801947 <close_all>:

void
close_all(void)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80194e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	53                   	push   %ebx
  801957:	e8 be ff ff ff       	call   80191a <close>
	for (i = 0; i < MAXFD; i++)
  80195c:	83 c3 01             	add    $0x1,%ebx
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	83 fb 20             	cmp    $0x20,%ebx
  801965:	75 ec                	jne    801953 <close_all+0xc>
}
  801967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	57                   	push   %edi
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801975:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801978:	50                   	push   %eax
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	e8 67 fe ff ff       	call   8017e8 <fd_lookup>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	85 c0                	test   %eax,%eax
  801988:	0f 88 81 00 00 00    	js     801a0f <dup+0xa3>
		return r;
	close(newfdnum);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 81 ff ff ff       	call   80191a <close>

	newfd = INDEX2FD(newfdnum);
  801999:	8b 75 0c             	mov    0xc(%ebp),%esi
  80199c:	c1 e6 0c             	shl    $0xc,%esi
  80199f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ab:	e8 cf fd ff ff       	call   80177f <fd2data>
  8019b0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019b2:	89 34 24             	mov    %esi,(%esp)
  8019b5:	e8 c5 fd ff ff       	call   80177f <fd2data>
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019bf:	89 d8                	mov    %ebx,%eax
  8019c1:	c1 e8 16             	shr    $0x16,%eax
  8019c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019cb:	a8 01                	test   $0x1,%al
  8019cd:	74 11                	je     8019e0 <dup+0x74>
  8019cf:	89 d8                	mov    %ebx,%eax
  8019d1:	c1 e8 0c             	shr    $0xc,%eax
  8019d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019db:	f6 c2 01             	test   $0x1,%dl
  8019de:	75 39                	jne    801a19 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e3:	89 d0                	mov    %edx,%eax
  8019e5:	c1 e8 0c             	shr    $0xc,%eax
  8019e8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f7:	50                   	push   %eax
  8019f8:	56                   	push   %esi
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	6a 00                	push   $0x0
  8019fe:	e8 d7 f4 ff ff       	call   800eda <sys_page_map>
  801a03:	89 c3                	mov    %eax,%ebx
  801a05:	83 c4 20             	add    $0x20,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 31                	js     801a3d <dup+0xd1>
		goto err;

	return newfdnum;
  801a0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a0f:	89 d8                	mov    %ebx,%eax
  801a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a19:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	25 07 0e 00 00       	and    $0xe07,%eax
  801a28:	50                   	push   %eax
  801a29:	57                   	push   %edi
  801a2a:	6a 00                	push   $0x0
  801a2c:	53                   	push   %ebx
  801a2d:	6a 00                	push   $0x0
  801a2f:	e8 a6 f4 ff ff       	call   800eda <sys_page_map>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	83 c4 20             	add    $0x20,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	79 a3                	jns    8019e0 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	56                   	push   %esi
  801a41:	6a 00                	push   $0x0
  801a43:	e8 d4 f4 ff ff       	call   800f1c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a48:	83 c4 08             	add    $0x8,%esp
  801a4b:	57                   	push   %edi
  801a4c:	6a 00                	push   $0x0
  801a4e:	e8 c9 f4 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	eb b7                	jmp    801a0f <dup+0xa3>

00801a58 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 1c             	sub    $0x1c,%esp
  801a5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a62:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a65:	50                   	push   %eax
  801a66:	53                   	push   %ebx
  801a67:	e8 7c fd ff ff       	call   8017e8 <fd_lookup>
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 3f                	js     801ab2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a79:	50                   	push   %eax
  801a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7d:	ff 30                	pushl  (%eax)
  801a7f:	e8 b4 fd ff ff       	call   801838 <dev_lookup>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 27                	js     801ab2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8e:	8b 42 08             	mov    0x8(%edx),%eax
  801a91:	83 e0 03             	and    $0x3,%eax
  801a94:	83 f8 01             	cmp    $0x1,%eax
  801a97:	74 1e                	je     801ab7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	8b 40 08             	mov    0x8(%eax),%eax
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	74 35                	je     801ad8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	ff 75 10             	pushl  0x10(%ebp)
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	52                   	push   %edx
  801aad:	ff d0                	call   *%eax
  801aaf:	83 c4 10             	add    $0x10,%esp
}
  801ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab7:	a1 08 50 80 00       	mov    0x805008,%eax
  801abc:	8b 40 48             	mov    0x48(%eax),%eax
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	53                   	push   %ebx
  801ac3:	50                   	push   %eax
  801ac4:	68 65 32 80 00       	push   $0x803265
  801ac9:	e8 78 e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad6:	eb da                	jmp    801ab2 <read+0x5a>
		return -E_NOT_SUPP;
  801ad8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801add:	eb d3                	jmp    801ab2 <read+0x5a>

00801adf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	57                   	push   %edi
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 0c             	sub    $0xc,%esp
  801ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aeb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aee:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af3:	39 f3                	cmp    %esi,%ebx
  801af5:	73 23                	jae    801b1a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	89 f0                	mov    %esi,%eax
  801afc:	29 d8                	sub    %ebx,%eax
  801afe:	50                   	push   %eax
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	03 45 0c             	add    0xc(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	57                   	push   %edi
  801b06:	e8 4d ff ff ff       	call   801a58 <read>
		if (m < 0)
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	78 06                	js     801b18 <readn+0x39>
			return m;
		if (m == 0)
  801b12:	74 06                	je     801b1a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b14:	01 c3                	add    %eax,%ebx
  801b16:	eb db                	jmp    801af3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b18:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b1a:	89 d8                	mov    %ebx,%eax
  801b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    

00801b24 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	53                   	push   %ebx
  801b28:	83 ec 1c             	sub    $0x1c,%esp
  801b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b31:	50                   	push   %eax
  801b32:	53                   	push   %ebx
  801b33:	e8 b0 fc ff ff       	call   8017e8 <fd_lookup>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 3a                	js     801b79 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b45:	50                   	push   %eax
  801b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b49:	ff 30                	pushl  (%eax)
  801b4b:	e8 e8 fc ff ff       	call   801838 <dev_lookup>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 22                	js     801b79 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b5e:	74 1e                	je     801b7e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b63:	8b 52 0c             	mov    0xc(%edx),%edx
  801b66:	85 d2                	test   %edx,%edx
  801b68:	74 35                	je     801b9f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	ff 75 10             	pushl  0x10(%ebp)
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	50                   	push   %eax
  801b74:	ff d2                	call   *%edx
  801b76:	83 c4 10             	add    $0x10,%esp
}
  801b79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7e:	a1 08 50 80 00       	mov    0x805008,%eax
  801b83:	8b 40 48             	mov    0x48(%eax),%eax
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	53                   	push   %ebx
  801b8a:	50                   	push   %eax
  801b8b:	68 81 32 80 00       	push   $0x803281
  801b90:	e8 b1 e7 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b9d:	eb da                	jmp    801b79 <write+0x55>
		return -E_NOT_SUPP;
  801b9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba4:	eb d3                	jmp    801b79 <write+0x55>

00801ba6 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801baf:	50                   	push   %eax
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	e8 30 fc ff ff       	call   8017e8 <fd_lookup>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 0e                	js     801bcd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 1c             	sub    $0x1c,%esp
  801bd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bdc:	50                   	push   %eax
  801bdd:	53                   	push   %ebx
  801bde:	e8 05 fc ff ff       	call   8017e8 <fd_lookup>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 37                	js     801c21 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bea:	83 ec 08             	sub    $0x8,%esp
  801bed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf0:	50                   	push   %eax
  801bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf4:	ff 30                	pushl  (%eax)
  801bf6:	e8 3d fc ff ff       	call   801838 <dev_lookup>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 1f                	js     801c21 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c05:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c09:	74 1b                	je     801c26 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0e:	8b 52 18             	mov    0x18(%edx),%edx
  801c11:	85 d2                	test   %edx,%edx
  801c13:	74 32                	je     801c47 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	50                   	push   %eax
  801c1c:	ff d2                	call   *%edx
  801c1e:	83 c4 10             	add    $0x10,%esp
}
  801c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c26:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c2b:	8b 40 48             	mov    0x48(%eax),%eax
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	53                   	push   %ebx
  801c32:	50                   	push   %eax
  801c33:	68 44 32 80 00       	push   $0x803244
  801c38:	e8 09 e7 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c45:	eb da                	jmp    801c21 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c47:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c4c:	eb d3                	jmp    801c21 <ftruncate+0x52>

00801c4e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	53                   	push   %ebx
  801c52:	83 ec 1c             	sub    $0x1c,%esp
  801c55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c5b:	50                   	push   %eax
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 84 fb ff ff       	call   8017e8 <fd_lookup>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 4b                	js     801cb6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c71:	50                   	push   %eax
  801c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c75:	ff 30                	pushl  (%eax)
  801c77:	e8 bc fb ff ff       	call   801838 <dev_lookup>
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	78 33                	js     801cb6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c86:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c8a:	74 2f                	je     801cbb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c8c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c8f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c96:	00 00 00 
	stat->st_isdir = 0;
  801c99:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ca0:	00 00 00 
	stat->st_dev = dev;
  801ca3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	53                   	push   %ebx
  801cad:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb0:	ff 50 14             	call   *0x14(%eax)
  801cb3:	83 c4 10             	add    $0x10,%esp
}
  801cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    
		return -E_NOT_SUPP;
  801cbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cc0:	eb f4                	jmp    801cb6 <fstat+0x68>

00801cc2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cc7:	83 ec 08             	sub    $0x8,%esp
  801cca:	6a 00                	push   $0x0
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	e8 22 02 00 00       	call   801ef6 <open>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 1b                	js     801cf8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	e8 65 ff ff ff       	call   801c4e <fstat>
  801ce9:	89 c6                	mov    %eax,%esi
	close(fd);
  801ceb:	89 1c 24             	mov    %ebx,(%esp)
  801cee:	e8 27 fc ff ff       	call   80191a <close>
	return r;
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	89 f3                	mov    %esi,%ebx
}
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	56                   	push   %esi
  801d05:	53                   	push   %ebx
  801d06:	89 c6                	mov    %eax,%esi
  801d08:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d0a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d11:	74 27                	je     801d3a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d13:	6a 07                	push   $0x7
  801d15:	68 00 60 80 00       	push   $0x806000
  801d1a:	56                   	push   %esi
  801d1b:	ff 35 00 50 80 00    	pushl  0x805000
  801d21:	e8 b6 f9 ff ff       	call   8016dc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d26:	83 c4 0c             	add    $0xc,%esp
  801d29:	6a 00                	push   $0x0
  801d2b:	53                   	push   %ebx
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 40 f9 ff ff       	call   801673 <ipc_recv>
}
  801d33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d36:	5b                   	pop    %ebx
  801d37:	5e                   	pop    %esi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d3a:	83 ec 0c             	sub    $0xc,%esp
  801d3d:	6a 01                	push   $0x1
  801d3f:	e8 f0 f9 ff ff       	call   801734 <ipc_find_env>
  801d44:	a3 00 50 80 00       	mov    %eax,0x805000
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	eb c5                	jmp    801d13 <fsipc+0x12>

00801d4e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d62:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	b8 02 00 00 00       	mov    $0x2,%eax
  801d71:	e8 8b ff ff ff       	call   801d01 <fsipc>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <devfile_flush>:
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8b 40 0c             	mov    0xc(%eax),%eax
  801d84:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d89:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8e:	b8 06 00 00 00       	mov    $0x6,%eax
  801d93:	e8 69 ff ff ff       	call   801d01 <fsipc>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <devfile_stat>:
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801daf:	ba 00 00 00 00       	mov    $0x0,%edx
  801db4:	b8 05 00 00 00       	mov    $0x5,%eax
  801db9:	e8 43 ff ff ff       	call   801d01 <fsipc>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 2c                	js     801dee <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	68 00 60 80 00       	push   $0x806000
  801dca:	53                   	push   %ebx
  801dcb:	e8 d5 ec ff ff       	call   800aa5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dd0:	a1 80 60 80 00       	mov    0x806080,%eax
  801dd5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ddb:	a1 84 60 80 00       	mov    0x806084,%eax
  801de0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <devfile_write>:
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	53                   	push   %ebx
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	8b 40 0c             	mov    0xc(%eax),%eax
  801e03:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e08:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e0e:	53                   	push   %ebx
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	68 08 60 80 00       	push   $0x806008
  801e17:	e8 79 ee ff ff       	call   800c95 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	b8 04 00 00 00       	mov    $0x4,%eax
  801e26:	e8 d6 fe ff ff       	call   801d01 <fsipc>
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 0b                	js     801e3d <devfile_write+0x4a>
	assert(r <= n);
  801e32:	39 d8                	cmp    %ebx,%eax
  801e34:	77 0c                	ja     801e42 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e36:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e3b:	7f 1e                	jg     801e5b <devfile_write+0x68>
}
  801e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    
	assert(r <= n);
  801e42:	68 b4 32 80 00       	push   $0x8032b4
  801e47:	68 bb 32 80 00       	push   $0x8032bb
  801e4c:	68 98 00 00 00       	push   $0x98
  801e51:	68 d0 32 80 00       	push   $0x8032d0
  801e56:	e8 6a 0a 00 00       	call   8028c5 <_panic>
	assert(r <= PGSIZE);
  801e5b:	68 db 32 80 00       	push   $0x8032db
  801e60:	68 bb 32 80 00       	push   $0x8032bb
  801e65:	68 99 00 00 00       	push   $0x99
  801e6a:	68 d0 32 80 00       	push   $0x8032d0
  801e6f:	e8 51 0a 00 00       	call   8028c5 <_panic>

00801e74 <devfile_read>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e82:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e87:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e92:	b8 03 00 00 00       	mov    $0x3,%eax
  801e97:	e8 65 fe ff ff       	call   801d01 <fsipc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 1f                	js     801ec1 <devfile_read+0x4d>
	assert(r <= n);
  801ea2:	39 f0                	cmp    %esi,%eax
  801ea4:	77 24                	ja     801eca <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ea6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eab:	7f 33                	jg     801ee0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	50                   	push   %eax
  801eb1:	68 00 60 80 00       	push   $0x806000
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	e8 75 ed ff ff       	call   800c33 <memmove>
	return r;
  801ebe:	83 c4 10             	add    $0x10,%esp
}
  801ec1:	89 d8                	mov    %ebx,%eax
  801ec3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5e                   	pop    %esi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    
	assert(r <= n);
  801eca:	68 b4 32 80 00       	push   $0x8032b4
  801ecf:	68 bb 32 80 00       	push   $0x8032bb
  801ed4:	6a 7c                	push   $0x7c
  801ed6:	68 d0 32 80 00       	push   $0x8032d0
  801edb:	e8 e5 09 00 00       	call   8028c5 <_panic>
	assert(r <= PGSIZE);
  801ee0:	68 db 32 80 00       	push   $0x8032db
  801ee5:	68 bb 32 80 00       	push   $0x8032bb
  801eea:	6a 7d                	push   $0x7d
  801eec:	68 d0 32 80 00       	push   $0x8032d0
  801ef1:	e8 cf 09 00 00       	call   8028c5 <_panic>

00801ef6 <open>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	56                   	push   %esi
  801efa:	53                   	push   %ebx
  801efb:	83 ec 1c             	sub    $0x1c,%esp
  801efe:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f01:	56                   	push   %esi
  801f02:	e8 65 eb ff ff       	call   800a6c <strlen>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f0f:	7f 6c                	jg     801f7d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f17:	50                   	push   %eax
  801f18:	e8 79 f8 ff ff       	call   801796 <fd_alloc>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 3c                	js     801f62 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f26:	83 ec 08             	sub    $0x8,%esp
  801f29:	56                   	push   %esi
  801f2a:	68 00 60 80 00       	push   $0x806000
  801f2f:	e8 71 eb ff ff       	call   800aa5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f44:	e8 b8 fd ff ff       	call   801d01 <fsipc>
  801f49:	89 c3                	mov    %eax,%ebx
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 19                	js     801f6b <open+0x75>
	return fd2num(fd);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 f4             	pushl  -0xc(%ebp)
  801f58:	e8 12 f8 ff ff       	call   80176f <fd2num>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	83 c4 10             	add    $0x10,%esp
}
  801f62:	89 d8                	mov    %ebx,%eax
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    
		fd_close(fd, 0);
  801f6b:	83 ec 08             	sub    $0x8,%esp
  801f6e:	6a 00                	push   $0x0
  801f70:	ff 75 f4             	pushl  -0xc(%ebp)
  801f73:	e8 1b f9 ff ff       	call   801893 <fd_close>
		return r;
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	eb e5                	jmp    801f62 <open+0x6c>
		return -E_BAD_PATH;
  801f7d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f82:	eb de                	jmp    801f62 <open+0x6c>

00801f84 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8f:	b8 08 00 00 00       	mov    $0x8,%eax
  801f94:	e8 68 fd ff ff       	call   801d01 <fsipc>
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fa1:	68 e7 32 80 00       	push   $0x8032e7
  801fa6:	ff 75 0c             	pushl  0xc(%ebp)
  801fa9:	e8 f7 ea ff ff       	call   800aa5 <strcpy>
	return 0;
}
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <devsock_close>:
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 10             	sub    $0x10,%esp
  801fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fbf:	53                   	push   %ebx
  801fc0:	e8 f6 09 00 00       	call   8029bb <pageref>
  801fc5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fc8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fcd:	83 f8 01             	cmp    $0x1,%eax
  801fd0:	74 07                	je     801fd9 <devsock_close+0x24>
}
  801fd2:	89 d0                	mov    %edx,%eax
  801fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 73 0c             	pushl  0xc(%ebx)
  801fdf:	e8 b9 02 00 00       	call   80229d <nsipc_close>
  801fe4:	89 c2                	mov    %eax,%edx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	eb e7                	jmp    801fd2 <devsock_close+0x1d>

00801feb <devsock_write>:
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	ff 75 10             	pushl  0x10(%ebp)
  801ff6:	ff 75 0c             	pushl  0xc(%ebp)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	ff 70 0c             	pushl  0xc(%eax)
  801fff:	e8 76 03 00 00       	call   80237a <nsipc_send>
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <devsock_read>:
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 10             	pushl  0x10(%ebp)
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	ff 70 0c             	pushl  0xc(%eax)
  80201a:	e8 ef 02 00 00       	call   80230e <nsipc_recv>
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <fd2sockid>:
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802027:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80202a:	52                   	push   %edx
  80202b:	50                   	push   %eax
  80202c:	e8 b7 f7 ff ff       	call   8017e8 <fd_lookup>
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 10                	js     802048 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802041:	39 08                	cmp    %ecx,(%eax)
  802043:	75 05                	jne    80204a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802045:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    
		return -E_NOT_SUPP;
  80204a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80204f:	eb f7                	jmp    802048 <fd2sockid+0x27>

00802051 <alloc_sockfd>:
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	56                   	push   %esi
  802055:	53                   	push   %ebx
  802056:	83 ec 1c             	sub    $0x1c,%esp
  802059:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80205b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205e:	50                   	push   %eax
  80205f:	e8 32 f7 ff ff       	call   801796 <fd_alloc>
  802064:	89 c3                	mov    %eax,%ebx
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	78 43                	js     8020b0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 07 04 00 00       	push   $0x407
  802075:	ff 75 f4             	pushl  -0xc(%ebp)
  802078:	6a 00                	push   $0x0
  80207a:	e8 18 ee ff ff       	call   800e97 <sys_page_alloc>
  80207f:	89 c3                	mov    %eax,%ebx
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	85 c0                	test   %eax,%eax
  802086:	78 28                	js     8020b0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802091:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80209d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	50                   	push   %eax
  8020a4:	e8 c6 f6 ff ff       	call   80176f <fd2num>
  8020a9:	89 c3                	mov    %eax,%ebx
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	eb 0c                	jmp    8020bc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	56                   	push   %esi
  8020b4:	e8 e4 01 00 00       	call   80229d <nsipc_close>
		return r;
  8020b9:	83 c4 10             	add    $0x10,%esp
}
  8020bc:	89 d8                	mov    %ebx,%eax
  8020be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <accept>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	e8 4e ff ff ff       	call   802021 <fd2sockid>
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 1b                	js     8020f2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	ff 75 10             	pushl  0x10(%ebp)
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	50                   	push   %eax
  8020e1:	e8 0e 01 00 00       	call   8021f4 <nsipc_accept>
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	78 05                	js     8020f2 <accept+0x2d>
	return alloc_sockfd(r);
  8020ed:	e8 5f ff ff ff       	call   802051 <alloc_sockfd>
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <bind>:
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	e8 1f ff ff ff       	call   802021 <fd2sockid>
  802102:	85 c0                	test   %eax,%eax
  802104:	78 12                	js     802118 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	ff 75 10             	pushl  0x10(%ebp)
  80210c:	ff 75 0c             	pushl  0xc(%ebp)
  80210f:	50                   	push   %eax
  802110:	e8 31 01 00 00       	call   802246 <nsipc_bind>
  802115:	83 c4 10             	add    $0x10,%esp
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <shutdown>:
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	e8 f9 fe ff ff       	call   802021 <fd2sockid>
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 0f                	js     80213b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80212c:	83 ec 08             	sub    $0x8,%esp
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	50                   	push   %eax
  802133:	e8 43 01 00 00       	call   80227b <nsipc_shutdown>
  802138:	83 c4 10             	add    $0x10,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <connect>:
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	e8 d6 fe ff ff       	call   802021 <fd2sockid>
  80214b:	85 c0                	test   %eax,%eax
  80214d:	78 12                	js     802161 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	ff 75 10             	pushl  0x10(%ebp)
  802155:	ff 75 0c             	pushl  0xc(%ebp)
  802158:	50                   	push   %eax
  802159:	e8 59 01 00 00       	call   8022b7 <nsipc_connect>
  80215e:	83 c4 10             	add    $0x10,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <listen>:
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	e8 b0 fe ff ff       	call   802021 <fd2sockid>
  802171:	85 c0                	test   %eax,%eax
  802173:	78 0f                	js     802184 <listen+0x21>
	return nsipc_listen(r, backlog);
  802175:	83 ec 08             	sub    $0x8,%esp
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	50                   	push   %eax
  80217c:	e8 6b 01 00 00       	call   8022ec <nsipc_listen>
  802181:	83 c4 10             	add    $0x10,%esp
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <socket>:

int
socket(int domain, int type, int protocol)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80218c:	ff 75 10             	pushl  0x10(%ebp)
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	e8 3e 02 00 00       	call   8023d8 <nsipc_socket>
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	85 c0                	test   %eax,%eax
  80219f:	78 05                	js     8021a6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021a1:	e8 ab fe ff ff       	call   802051 <alloc_sockfd>
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	53                   	push   %ebx
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021b1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021b8:	74 26                	je     8021e0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021ba:	6a 07                	push   $0x7
  8021bc:	68 00 70 80 00       	push   $0x807000
  8021c1:	53                   	push   %ebx
  8021c2:	ff 35 04 50 80 00    	pushl  0x805004
  8021c8:	e8 0f f5 ff ff       	call   8016dc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021cd:	83 c4 0c             	add    $0xc,%esp
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	e8 98 f4 ff ff       	call   801673 <ipc_recv>
}
  8021db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	6a 02                	push   $0x2
  8021e5:	e8 4a f5 ff ff       	call   801734 <ipc_find_env>
  8021ea:	a3 04 50 80 00       	mov    %eax,0x805004
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	eb c6                	jmp    8021ba <nsipc+0x12>

008021f4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	56                   	push   %esi
  8021f8:	53                   	push   %ebx
  8021f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802204:	8b 06                	mov    (%esi),%eax
  802206:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80220b:	b8 01 00 00 00       	mov    $0x1,%eax
  802210:	e8 93 ff ff ff       	call   8021a8 <nsipc>
  802215:	89 c3                	mov    %eax,%ebx
  802217:	85 c0                	test   %eax,%eax
  802219:	79 09                	jns    802224 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80221b:	89 d8                	mov    %ebx,%eax
  80221d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	ff 35 10 70 80 00    	pushl  0x807010
  80222d:	68 00 70 80 00       	push   $0x807000
  802232:	ff 75 0c             	pushl  0xc(%ebp)
  802235:	e8 f9 e9 ff ff       	call   800c33 <memmove>
		*addrlen = ret->ret_addrlen;
  80223a:	a1 10 70 80 00       	mov    0x807010,%eax
  80223f:	89 06                	mov    %eax,(%esi)
  802241:	83 c4 10             	add    $0x10,%esp
	return r;
  802244:	eb d5                	jmp    80221b <nsipc_accept+0x27>

00802246 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	53                   	push   %ebx
  80224a:	83 ec 08             	sub    $0x8,%esp
  80224d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802258:	53                   	push   %ebx
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	68 04 70 80 00       	push   $0x807004
  802261:	e8 cd e9 ff ff       	call   800c33 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802266:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80226c:	b8 02 00 00 00       	mov    $0x2,%eax
  802271:	e8 32 ff ff ff       	call   8021a8 <nsipc>
}
  802276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802291:	b8 03 00 00 00       	mov    $0x3,%eax
  802296:	e8 0d ff ff ff       	call   8021a8 <nsipc>
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <nsipc_close>:

int
nsipc_close(int s)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8022b0:	e8 f3 fe ff ff       	call   8021a8 <nsipc>
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	53                   	push   %ebx
  8022bb:	83 ec 08             	sub    $0x8,%esp
  8022be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022c9:	53                   	push   %ebx
  8022ca:	ff 75 0c             	pushl  0xc(%ebp)
  8022cd:	68 04 70 80 00       	push   $0x807004
  8022d2:	e8 5c e9 ff ff       	call   800c33 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8022e2:	e8 c1 fe ff ff       	call   8021a8 <nsipc>
}
  8022e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802302:	b8 06 00 00 00       	mov    $0x6,%eax
  802307:	e8 9c fe ff ff       	call   8021a8 <nsipc>
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	56                   	push   %esi
  802312:	53                   	push   %ebx
  802313:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80231e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802324:	8b 45 14             	mov    0x14(%ebp),%eax
  802327:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80232c:	b8 07 00 00 00       	mov    $0x7,%eax
  802331:	e8 72 fe ff ff       	call   8021a8 <nsipc>
  802336:	89 c3                	mov    %eax,%ebx
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 1f                	js     80235b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80233c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802341:	7f 21                	jg     802364 <nsipc_recv+0x56>
  802343:	39 c6                	cmp    %eax,%esi
  802345:	7c 1d                	jl     802364 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	50                   	push   %eax
  80234b:	68 00 70 80 00       	push   $0x807000
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	e8 db e8 ff ff       	call   800c33 <memmove>
  802358:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802364:	68 f3 32 80 00       	push   $0x8032f3
  802369:	68 bb 32 80 00       	push   $0x8032bb
  80236e:	6a 62                	push   $0x62
  802370:	68 08 33 80 00       	push   $0x803308
  802375:	e8 4b 05 00 00       	call   8028c5 <_panic>

0080237a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	53                   	push   %ebx
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80238c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802392:	7f 2e                	jg     8023c2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802394:	83 ec 04             	sub    $0x4,%esp
  802397:	53                   	push   %ebx
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	68 0c 70 80 00       	push   $0x80700c
  8023a0:	e8 8e e8 ff ff       	call   800c33 <memmove>
	nsipcbuf.send.req_size = size;
  8023a5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ae:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8023b8:	e8 eb fd ff ff       	call   8021a8 <nsipc>
}
  8023bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    
	assert(size < 1600);
  8023c2:	68 14 33 80 00       	push   $0x803314
  8023c7:	68 bb 32 80 00       	push   $0x8032bb
  8023cc:	6a 6d                	push   $0x6d
  8023ce:	68 08 33 80 00       	push   $0x803308
  8023d3:	e8 ed 04 00 00       	call   8028c5 <_panic>

008023d8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8023fb:	e8 a8 fd ff ff       	call   8021a8 <nsipc>
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	56                   	push   %esi
  802406:	53                   	push   %ebx
  802407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80240a:	83 ec 0c             	sub    $0xc,%esp
  80240d:	ff 75 08             	pushl  0x8(%ebp)
  802410:	e8 6a f3 ff ff       	call   80177f <fd2data>
  802415:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802417:	83 c4 08             	add    $0x8,%esp
  80241a:	68 20 33 80 00       	push   $0x803320
  80241f:	53                   	push   %ebx
  802420:	e8 80 e6 ff ff       	call   800aa5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802425:	8b 46 04             	mov    0x4(%esi),%eax
  802428:	2b 06                	sub    (%esi),%eax
  80242a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802430:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802437:	00 00 00 
	stat->st_dev = &devpipe;
  80243a:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802441:	40 80 00 
	return 0;
}
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
  802449:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    

00802450 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	53                   	push   %ebx
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80245a:	53                   	push   %ebx
  80245b:	6a 00                	push   $0x0
  80245d:	e8 ba ea ff ff       	call   800f1c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802462:	89 1c 24             	mov    %ebx,(%esp)
  802465:	e8 15 f3 ff ff       	call   80177f <fd2data>
  80246a:	83 c4 08             	add    $0x8,%esp
  80246d:	50                   	push   %eax
  80246e:	6a 00                	push   $0x0
  802470:	e8 a7 ea ff ff       	call   800f1c <sys_page_unmap>
}
  802475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <_pipeisclosed>:
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	83 ec 1c             	sub    $0x1c,%esp
  802483:	89 c7                	mov    %eax,%edi
  802485:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802487:	a1 08 50 80 00       	mov    0x805008,%eax
  80248c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80248f:	83 ec 0c             	sub    $0xc,%esp
  802492:	57                   	push   %edi
  802493:	e8 23 05 00 00       	call   8029bb <pageref>
  802498:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80249b:	89 34 24             	mov    %esi,(%esp)
  80249e:	e8 18 05 00 00       	call   8029bb <pageref>
		nn = thisenv->env_runs;
  8024a3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024a9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	39 cb                	cmp    %ecx,%ebx
  8024b1:	74 1b                	je     8024ce <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b6:	75 cf                	jne    802487 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024b8:	8b 42 58             	mov    0x58(%edx),%eax
  8024bb:	6a 01                	push   $0x1
  8024bd:	50                   	push   %eax
  8024be:	53                   	push   %ebx
  8024bf:	68 27 33 80 00       	push   $0x803327
  8024c4:	e8 7d de ff ff       	call   800346 <cprintf>
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	eb b9                	jmp    802487 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024d1:	0f 94 c0             	sete   %al
  8024d4:	0f b6 c0             	movzbl %al,%eax
}
  8024d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024da:	5b                   	pop    %ebx
  8024db:	5e                   	pop    %esi
  8024dc:	5f                   	pop    %edi
  8024dd:	5d                   	pop    %ebp
  8024de:	c3                   	ret    

008024df <devpipe_write>:
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	57                   	push   %edi
  8024e3:	56                   	push   %esi
  8024e4:	53                   	push   %ebx
  8024e5:	83 ec 28             	sub    $0x28,%esp
  8024e8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024eb:	56                   	push   %esi
  8024ec:	e8 8e f2 ff ff       	call   80177f <fd2data>
  8024f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024f3:	83 c4 10             	add    $0x10,%esp
  8024f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024fe:	74 4f                	je     80254f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802500:	8b 43 04             	mov    0x4(%ebx),%eax
  802503:	8b 0b                	mov    (%ebx),%ecx
  802505:	8d 51 20             	lea    0x20(%ecx),%edx
  802508:	39 d0                	cmp    %edx,%eax
  80250a:	72 14                	jb     802520 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80250c:	89 da                	mov    %ebx,%edx
  80250e:	89 f0                	mov    %esi,%eax
  802510:	e8 65 ff ff ff       	call   80247a <_pipeisclosed>
  802515:	85 c0                	test   %eax,%eax
  802517:	75 3b                	jne    802554 <devpipe_write+0x75>
			sys_yield();
  802519:	e8 5a e9 ff ff       	call   800e78 <sys_yield>
  80251e:	eb e0                	jmp    802500 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802520:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802523:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802527:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80252a:	89 c2                	mov    %eax,%edx
  80252c:	c1 fa 1f             	sar    $0x1f,%edx
  80252f:	89 d1                	mov    %edx,%ecx
  802531:	c1 e9 1b             	shr    $0x1b,%ecx
  802534:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802537:	83 e2 1f             	and    $0x1f,%edx
  80253a:	29 ca                	sub    %ecx,%edx
  80253c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802540:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802544:	83 c0 01             	add    $0x1,%eax
  802547:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80254a:	83 c7 01             	add    $0x1,%edi
  80254d:	eb ac                	jmp    8024fb <devpipe_write+0x1c>
	return i;
  80254f:	8b 45 10             	mov    0x10(%ebp),%eax
  802552:	eb 05                	jmp    802559 <devpipe_write+0x7a>
				return 0;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    

00802561 <devpipe_read>:
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	57                   	push   %edi
  802565:	56                   	push   %esi
  802566:	53                   	push   %ebx
  802567:	83 ec 18             	sub    $0x18,%esp
  80256a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80256d:	57                   	push   %edi
  80256e:	e8 0c f2 ff ff       	call   80177f <fd2data>
  802573:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	be 00 00 00 00       	mov    $0x0,%esi
  80257d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802580:	75 14                	jne    802596 <devpipe_read+0x35>
	return i;
  802582:	8b 45 10             	mov    0x10(%ebp),%eax
  802585:	eb 02                	jmp    802589 <devpipe_read+0x28>
				return i;
  802587:	89 f0                	mov    %esi,%eax
}
  802589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80258c:	5b                   	pop    %ebx
  80258d:	5e                   	pop    %esi
  80258e:	5f                   	pop    %edi
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    
			sys_yield();
  802591:	e8 e2 e8 ff ff       	call   800e78 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802596:	8b 03                	mov    (%ebx),%eax
  802598:	3b 43 04             	cmp    0x4(%ebx),%eax
  80259b:	75 18                	jne    8025b5 <devpipe_read+0x54>
			if (i > 0)
  80259d:	85 f6                	test   %esi,%esi
  80259f:	75 e6                	jne    802587 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025a1:	89 da                	mov    %ebx,%edx
  8025a3:	89 f8                	mov    %edi,%eax
  8025a5:	e8 d0 fe ff ff       	call   80247a <_pipeisclosed>
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	74 e3                	je     802591 <devpipe_read+0x30>
				return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	eb d4                	jmp    802589 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025b5:	99                   	cltd   
  8025b6:	c1 ea 1b             	shr    $0x1b,%edx
  8025b9:	01 d0                	add    %edx,%eax
  8025bb:	83 e0 1f             	and    $0x1f,%eax
  8025be:	29 d0                	sub    %edx,%eax
  8025c0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025c8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025cb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025ce:	83 c6 01             	add    $0x1,%esi
  8025d1:	eb aa                	jmp    80257d <devpipe_read+0x1c>

008025d3 <pipe>:
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
  8025d6:	56                   	push   %esi
  8025d7:	53                   	push   %ebx
  8025d8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025de:	50                   	push   %eax
  8025df:	e8 b2 f1 ff ff       	call   801796 <fd_alloc>
  8025e4:	89 c3                	mov    %eax,%ebx
  8025e6:	83 c4 10             	add    $0x10,%esp
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	0f 88 23 01 00 00    	js     802714 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f1:	83 ec 04             	sub    $0x4,%esp
  8025f4:	68 07 04 00 00       	push   $0x407
  8025f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fc:	6a 00                	push   $0x0
  8025fe:	e8 94 e8 ff ff       	call   800e97 <sys_page_alloc>
  802603:	89 c3                	mov    %eax,%ebx
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	85 c0                	test   %eax,%eax
  80260a:	0f 88 04 01 00 00    	js     802714 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802616:	50                   	push   %eax
  802617:	e8 7a f1 ff ff       	call   801796 <fd_alloc>
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	83 c4 10             	add    $0x10,%esp
  802621:	85 c0                	test   %eax,%eax
  802623:	0f 88 db 00 00 00    	js     802704 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 07 04 00 00       	push   $0x407
  802631:	ff 75 f0             	pushl  -0x10(%ebp)
  802634:	6a 00                	push   $0x0
  802636:	e8 5c e8 ff ff       	call   800e97 <sys_page_alloc>
  80263b:	89 c3                	mov    %eax,%ebx
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 88 bc 00 00 00    	js     802704 <pipe+0x131>
	va = fd2data(fd0);
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	ff 75 f4             	pushl  -0xc(%ebp)
  80264e:	e8 2c f1 ff ff       	call   80177f <fd2data>
  802653:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802655:	83 c4 0c             	add    $0xc,%esp
  802658:	68 07 04 00 00       	push   $0x407
  80265d:	50                   	push   %eax
  80265e:	6a 00                	push   $0x0
  802660:	e8 32 e8 ff ff       	call   800e97 <sys_page_alloc>
  802665:	89 c3                	mov    %eax,%ebx
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	85 c0                	test   %eax,%eax
  80266c:	0f 88 82 00 00 00    	js     8026f4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	ff 75 f0             	pushl  -0x10(%ebp)
  802678:	e8 02 f1 ff ff       	call   80177f <fd2data>
  80267d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802684:	50                   	push   %eax
  802685:	6a 00                	push   $0x0
  802687:	56                   	push   %esi
  802688:	6a 00                	push   $0x0
  80268a:	e8 4b e8 ff ff       	call   800eda <sys_page_map>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	83 c4 20             	add    $0x20,%esp
  802694:	85 c0                	test   %eax,%eax
  802696:	78 4e                	js     8026e6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802698:	a1 44 40 80 00       	mov    0x804044,%eax
  80269d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026af:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c1:	e8 a9 f0 ff ff       	call   80176f <fd2num>
  8026c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026cb:	83 c4 04             	add    $0x4,%esp
  8026ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8026d1:	e8 99 f0 ff ff       	call   80176f <fd2num>
  8026d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e4:	eb 2e                	jmp    802714 <pipe+0x141>
	sys_page_unmap(0, va);
  8026e6:	83 ec 08             	sub    $0x8,%esp
  8026e9:	56                   	push   %esi
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 2b e8 ff ff       	call   800f1c <sys_page_unmap>
  8026f1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026f4:	83 ec 08             	sub    $0x8,%esp
  8026f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fa:	6a 00                	push   $0x0
  8026fc:	e8 1b e8 ff ff       	call   800f1c <sys_page_unmap>
  802701:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802704:	83 ec 08             	sub    $0x8,%esp
  802707:	ff 75 f4             	pushl  -0xc(%ebp)
  80270a:	6a 00                	push   $0x0
  80270c:	e8 0b e8 ff ff       	call   800f1c <sys_page_unmap>
  802711:	83 c4 10             	add    $0x10,%esp
}
  802714:	89 d8                	mov    %ebx,%eax
  802716:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802719:	5b                   	pop    %ebx
  80271a:	5e                   	pop    %esi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    

0080271d <pipeisclosed>:
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802723:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802726:	50                   	push   %eax
  802727:	ff 75 08             	pushl  0x8(%ebp)
  80272a:	e8 b9 f0 ff ff       	call   8017e8 <fd_lookup>
  80272f:	83 c4 10             	add    $0x10,%esp
  802732:	85 c0                	test   %eax,%eax
  802734:	78 18                	js     80274e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802736:	83 ec 0c             	sub    $0xc,%esp
  802739:	ff 75 f4             	pushl  -0xc(%ebp)
  80273c:	e8 3e f0 ff ff       	call   80177f <fd2data>
	return _pipeisclosed(fd, p);
  802741:	89 c2                	mov    %eax,%edx
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	e8 2f fd ff ff       	call   80247a <_pipeisclosed>
  80274b:	83 c4 10             	add    $0x10,%esp
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802750:	b8 00 00 00 00       	mov    $0x0,%eax
  802755:	c3                   	ret    

00802756 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80275c:	68 3f 33 80 00       	push   $0x80333f
  802761:	ff 75 0c             	pushl  0xc(%ebp)
  802764:	e8 3c e3 ff ff       	call   800aa5 <strcpy>
	return 0;
}
  802769:	b8 00 00 00 00       	mov    $0x0,%eax
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <devcons_write>:
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	57                   	push   %edi
  802774:	56                   	push   %esi
  802775:	53                   	push   %ebx
  802776:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80277c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802781:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802787:	3b 75 10             	cmp    0x10(%ebp),%esi
  80278a:	73 31                	jae    8027bd <devcons_write+0x4d>
		m = n - tot;
  80278c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80278f:	29 f3                	sub    %esi,%ebx
  802791:	83 fb 7f             	cmp    $0x7f,%ebx
  802794:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802799:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	53                   	push   %ebx
  8027a0:	89 f0                	mov    %esi,%eax
  8027a2:	03 45 0c             	add    0xc(%ebp),%eax
  8027a5:	50                   	push   %eax
  8027a6:	57                   	push   %edi
  8027a7:	e8 87 e4 ff ff       	call   800c33 <memmove>
		sys_cputs(buf, m);
  8027ac:	83 c4 08             	add    $0x8,%esp
  8027af:	53                   	push   %ebx
  8027b0:	57                   	push   %edi
  8027b1:	e8 25 e6 ff ff       	call   800ddb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027b6:	01 de                	add    %ebx,%esi
  8027b8:	83 c4 10             	add    $0x10,%esp
  8027bb:	eb ca                	jmp    802787 <devcons_write+0x17>
}
  8027bd:	89 f0                	mov    %esi,%eax
  8027bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c2:	5b                   	pop    %ebx
  8027c3:	5e                   	pop    %esi
  8027c4:	5f                   	pop    %edi
  8027c5:	5d                   	pop    %ebp
  8027c6:	c3                   	ret    

008027c7 <devcons_read>:
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 08             	sub    $0x8,%esp
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027d6:	74 21                	je     8027f9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027d8:	e8 1c e6 ff ff       	call   800df9 <sys_cgetc>
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	75 07                	jne    8027e8 <devcons_read+0x21>
		sys_yield();
  8027e1:	e8 92 e6 ff ff       	call   800e78 <sys_yield>
  8027e6:	eb f0                	jmp    8027d8 <devcons_read+0x11>
	if (c < 0)
  8027e8:	78 0f                	js     8027f9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027ea:	83 f8 04             	cmp    $0x4,%eax
  8027ed:	74 0c                	je     8027fb <devcons_read+0x34>
	*(char*)vbuf = c;
  8027ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f2:	88 02                	mov    %al,(%edx)
	return 1;
  8027f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    
		return 0;
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	eb f7                	jmp    8027f9 <devcons_read+0x32>

00802802 <cputchar>:
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80280e:	6a 01                	push   $0x1
  802810:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802813:	50                   	push   %eax
  802814:	e8 c2 e5 ff ff       	call   800ddb <sys_cputs>
}
  802819:	83 c4 10             	add    $0x10,%esp
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <getchar>:
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802824:	6a 01                	push   $0x1
  802826:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802829:	50                   	push   %eax
  80282a:	6a 00                	push   $0x0
  80282c:	e8 27 f2 ff ff       	call   801a58 <read>
	if (r < 0)
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	85 c0                	test   %eax,%eax
  802836:	78 06                	js     80283e <getchar+0x20>
	if (r < 1)
  802838:	74 06                	je     802840 <getchar+0x22>
	return c;
  80283a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    
		return -E_EOF;
  802840:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802845:	eb f7                	jmp    80283e <getchar+0x20>

00802847 <iscons>:
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802850:	50                   	push   %eax
  802851:	ff 75 08             	pushl  0x8(%ebp)
  802854:	e8 8f ef ff ff       	call   8017e8 <fd_lookup>
  802859:	83 c4 10             	add    $0x10,%esp
  80285c:	85 c0                	test   %eax,%eax
  80285e:	78 11                	js     802871 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802869:	39 10                	cmp    %edx,(%eax)
  80286b:	0f 94 c0             	sete   %al
  80286e:	0f b6 c0             	movzbl %al,%eax
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <opencons>:
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287c:	50                   	push   %eax
  80287d:	e8 14 ef ff ff       	call   801796 <fd_alloc>
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	78 3a                	js     8028c3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 07 04 00 00       	push   $0x407
  802891:	ff 75 f4             	pushl  -0xc(%ebp)
  802894:	6a 00                	push   $0x0
  802896:	e8 fc e5 ff ff       	call   800e97 <sys_page_alloc>
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 21                	js     8028c3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028ab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b7:	83 ec 0c             	sub    $0xc,%esp
  8028ba:	50                   	push   %eax
  8028bb:	e8 af ee ff ff       	call   80176f <fd2num>
  8028c0:	83 c4 10             	add    $0x10,%esp
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	56                   	push   %esi
  8028c9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8028ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8028cf:	8b 40 48             	mov    0x48(%eax),%eax
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 70 33 80 00       	push   $0x803370
  8028da:	50                   	push   %eax
  8028db:	68 5a 2d 80 00       	push   $0x802d5a
  8028e0:	e8 61 da ff ff       	call   800346 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8028e5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028e8:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8028ee:	e8 66 e5 ff ff       	call   800e59 <sys_getenvid>
  8028f3:	83 c4 04             	add    $0x4,%esp
  8028f6:	ff 75 0c             	pushl  0xc(%ebp)
  8028f9:	ff 75 08             	pushl  0x8(%ebp)
  8028fc:	56                   	push   %esi
  8028fd:	50                   	push   %eax
  8028fe:	68 4c 33 80 00       	push   $0x80334c
  802903:	e8 3e da ff ff       	call   800346 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802908:	83 c4 18             	add    $0x18,%esp
  80290b:	53                   	push   %ebx
  80290c:	ff 75 10             	pushl  0x10(%ebp)
  80290f:	e8 e1 d9 ff ff       	call   8002f5 <vcprintf>
	cprintf("\n");
  802914:	c7 04 24 1e 2d 80 00 	movl   $0x802d1e,(%esp)
  80291b:	e8 26 da ff ff       	call   800346 <cprintf>
  802920:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802923:	cc                   	int3   
  802924:	eb fd                	jmp    802923 <_panic+0x5e>

00802926 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80292c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802933:	74 0a                	je     80293f <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	6a 07                	push   $0x7
  802944:	68 00 f0 bf ee       	push   $0xeebff000
  802949:	6a 00                	push   $0x0
  80294b:	e8 47 e5 ff ff       	call   800e97 <sys_page_alloc>
		if(r < 0)
  802950:	83 c4 10             	add    $0x10,%esp
  802953:	85 c0                	test   %eax,%eax
  802955:	78 2a                	js     802981 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802957:	83 ec 08             	sub    $0x8,%esp
  80295a:	68 95 29 80 00       	push   $0x802995
  80295f:	6a 00                	push   $0x0
  802961:	e8 7c e6 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802966:	83 c4 10             	add    $0x10,%esp
  802969:	85 c0                	test   %eax,%eax
  80296b:	79 c8                	jns    802935 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 a8 33 80 00       	push   $0x8033a8
  802975:	6a 25                	push   $0x25
  802977:	68 e4 33 80 00       	push   $0x8033e4
  80297c:	e8 44 ff ff ff       	call   8028c5 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 78 33 80 00       	push   $0x803378
  802989:	6a 22                	push   $0x22
  80298b:	68 e4 33 80 00       	push   $0x8033e4
  802990:	e8 30 ff ff ff       	call   8028c5 <_panic>

00802995 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802995:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802996:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80299b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80299d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029a0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029a4:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029a8:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029ab:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029ad:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029b1:	83 c4 08             	add    $0x8,%esp
	popal
  8029b4:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029b5:	83 c4 04             	add    $0x4,%esp
	popfl
  8029b8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029b9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029ba:	c3                   	ret    

008029bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c1:	89 d0                	mov    %edx,%eax
  8029c3:	c1 e8 16             	shr    $0x16,%eax
  8029c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029d2:	f6 c1 01             	test   $0x1,%cl
  8029d5:	74 1d                	je     8029f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029d7:	c1 ea 0c             	shr    $0xc,%edx
  8029da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029e1:	f6 c2 01             	test   $0x1,%dl
  8029e4:	74 0e                	je     8029f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029e6:	c1 ea 0c             	shr    $0xc,%edx
  8029e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029f0:	ef 
  8029f1:	0f b7 c0             	movzwl %ax,%eax
}
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	66 90                	xchg   %ax,%ax
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__udivdi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a17:	85 d2                	test   %edx,%edx
  802a19:	75 4d                	jne    802a68 <__udivdi3+0x68>
  802a1b:	39 f3                	cmp    %esi,%ebx
  802a1d:	76 19                	jbe    802a38 <__udivdi3+0x38>
  802a1f:	31 ff                	xor    %edi,%edi
  802a21:	89 e8                	mov    %ebp,%eax
  802a23:	89 f2                	mov    %esi,%edx
  802a25:	f7 f3                	div    %ebx
  802a27:	89 fa                	mov    %edi,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 d9                	mov    %ebx,%ecx
  802a3a:	85 db                	test   %ebx,%ebx
  802a3c:	75 0b                	jne    802a49 <__udivdi3+0x49>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	31 d2                	xor    %edx,%edx
  802a45:	f7 f3                	div    %ebx
  802a47:	89 c1                	mov    %eax,%ecx
  802a49:	31 d2                	xor    %edx,%edx
  802a4b:	89 f0                	mov    %esi,%eax
  802a4d:	f7 f1                	div    %ecx
  802a4f:	89 c6                	mov    %eax,%esi
  802a51:	89 e8                	mov    %ebp,%eax
  802a53:	89 f7                	mov    %esi,%edi
  802a55:	f7 f1                	div    %ecx
  802a57:	89 fa                	mov    %edi,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	39 f2                	cmp    %esi,%edx
  802a6a:	77 1c                	ja     802a88 <__udivdi3+0x88>
  802a6c:	0f bd fa             	bsr    %edx,%edi
  802a6f:	83 f7 1f             	xor    $0x1f,%edi
  802a72:	75 2c                	jne    802aa0 <__udivdi3+0xa0>
  802a74:	39 f2                	cmp    %esi,%edx
  802a76:	72 06                	jb     802a7e <__udivdi3+0x7e>
  802a78:	31 c0                	xor    %eax,%eax
  802a7a:	39 eb                	cmp    %ebp,%ebx
  802a7c:	77 a9                	ja     802a27 <__udivdi3+0x27>
  802a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a83:	eb a2                	jmp    802a27 <__udivdi3+0x27>
  802a85:	8d 76 00             	lea    0x0(%esi),%esi
  802a88:	31 ff                	xor    %edi,%edi
  802a8a:	31 c0                	xor    %eax,%eax
  802a8c:	89 fa                	mov    %edi,%edx
  802a8e:	83 c4 1c             	add    $0x1c,%esp
  802a91:	5b                   	pop    %ebx
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    
  802a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a9d:	8d 76 00             	lea    0x0(%esi),%esi
  802aa0:	89 f9                	mov    %edi,%ecx
  802aa2:	b8 20 00 00 00       	mov    $0x20,%eax
  802aa7:	29 f8                	sub    %edi,%eax
  802aa9:	d3 e2                	shl    %cl,%edx
  802aab:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aaf:	89 c1                	mov    %eax,%ecx
  802ab1:	89 da                	mov    %ebx,%edx
  802ab3:	d3 ea                	shr    %cl,%edx
  802ab5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ab9:	09 d1                	or     %edx,%ecx
  802abb:	89 f2                	mov    %esi,%edx
  802abd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac1:	89 f9                	mov    %edi,%ecx
  802ac3:	d3 e3                	shl    %cl,%ebx
  802ac5:	89 c1                	mov    %eax,%ecx
  802ac7:	d3 ea                	shr    %cl,%edx
  802ac9:	89 f9                	mov    %edi,%ecx
  802acb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802acf:	89 eb                	mov    %ebp,%ebx
  802ad1:	d3 e6                	shl    %cl,%esi
  802ad3:	89 c1                	mov    %eax,%ecx
  802ad5:	d3 eb                	shr    %cl,%ebx
  802ad7:	09 de                	or     %ebx,%esi
  802ad9:	89 f0                	mov    %esi,%eax
  802adb:	f7 74 24 08          	divl   0x8(%esp)
  802adf:	89 d6                	mov    %edx,%esi
  802ae1:	89 c3                	mov    %eax,%ebx
  802ae3:	f7 64 24 0c          	mull   0xc(%esp)
  802ae7:	39 d6                	cmp    %edx,%esi
  802ae9:	72 15                	jb     802b00 <__udivdi3+0x100>
  802aeb:	89 f9                	mov    %edi,%ecx
  802aed:	d3 e5                	shl    %cl,%ebp
  802aef:	39 c5                	cmp    %eax,%ebp
  802af1:	73 04                	jae    802af7 <__udivdi3+0xf7>
  802af3:	39 d6                	cmp    %edx,%esi
  802af5:	74 09                	je     802b00 <__udivdi3+0x100>
  802af7:	89 d8                	mov    %ebx,%eax
  802af9:	31 ff                	xor    %edi,%edi
  802afb:	e9 27 ff ff ff       	jmp    802a27 <__udivdi3+0x27>
  802b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b03:	31 ff                	xor    %edi,%edi
  802b05:	e9 1d ff ff ff       	jmp    802a27 <__udivdi3+0x27>
  802b0a:	66 90                	xchg   %ax,%ax
  802b0c:	66 90                	xchg   %ax,%ax
  802b0e:	66 90                	xchg   %ax,%ax

00802b10 <__umoddi3>:
  802b10:	55                   	push   %ebp
  802b11:	57                   	push   %edi
  802b12:	56                   	push   %esi
  802b13:	53                   	push   %ebx
  802b14:	83 ec 1c             	sub    $0x1c,%esp
  802b17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b27:	89 da                	mov    %ebx,%edx
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	75 43                	jne    802b70 <__umoddi3+0x60>
  802b2d:	39 df                	cmp    %ebx,%edi
  802b2f:	76 17                	jbe    802b48 <__umoddi3+0x38>
  802b31:	89 f0                	mov    %esi,%eax
  802b33:	f7 f7                	div    %edi
  802b35:	89 d0                	mov    %edx,%eax
  802b37:	31 d2                	xor    %edx,%edx
  802b39:	83 c4 1c             	add    $0x1c,%esp
  802b3c:	5b                   	pop    %ebx
  802b3d:	5e                   	pop    %esi
  802b3e:	5f                   	pop    %edi
  802b3f:	5d                   	pop    %ebp
  802b40:	c3                   	ret    
  802b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b48:	89 fd                	mov    %edi,%ebp
  802b4a:	85 ff                	test   %edi,%edi
  802b4c:	75 0b                	jne    802b59 <__umoddi3+0x49>
  802b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b53:	31 d2                	xor    %edx,%edx
  802b55:	f7 f7                	div    %edi
  802b57:	89 c5                	mov    %eax,%ebp
  802b59:	89 d8                	mov    %ebx,%eax
  802b5b:	31 d2                	xor    %edx,%edx
  802b5d:	f7 f5                	div    %ebp
  802b5f:	89 f0                	mov    %esi,%eax
  802b61:	f7 f5                	div    %ebp
  802b63:	89 d0                	mov    %edx,%eax
  802b65:	eb d0                	jmp    802b37 <__umoddi3+0x27>
  802b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b6e:	66 90                	xchg   %ax,%ax
  802b70:	89 f1                	mov    %esi,%ecx
  802b72:	39 d8                	cmp    %ebx,%eax
  802b74:	76 0a                	jbe    802b80 <__umoddi3+0x70>
  802b76:	89 f0                	mov    %esi,%eax
  802b78:	83 c4 1c             	add    $0x1c,%esp
  802b7b:	5b                   	pop    %ebx
  802b7c:	5e                   	pop    %esi
  802b7d:	5f                   	pop    %edi
  802b7e:	5d                   	pop    %ebp
  802b7f:	c3                   	ret    
  802b80:	0f bd e8             	bsr    %eax,%ebp
  802b83:	83 f5 1f             	xor    $0x1f,%ebp
  802b86:	75 20                	jne    802ba8 <__umoddi3+0x98>
  802b88:	39 d8                	cmp    %ebx,%eax
  802b8a:	0f 82 b0 00 00 00    	jb     802c40 <__umoddi3+0x130>
  802b90:	39 f7                	cmp    %esi,%edi
  802b92:	0f 86 a8 00 00 00    	jbe    802c40 <__umoddi3+0x130>
  802b98:	89 c8                	mov    %ecx,%eax
  802b9a:	83 c4 1c             	add    $0x1c,%esp
  802b9d:	5b                   	pop    %ebx
  802b9e:	5e                   	pop    %esi
  802b9f:	5f                   	pop    %edi
  802ba0:	5d                   	pop    %ebp
  802ba1:	c3                   	ret    
  802ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ba8:	89 e9                	mov    %ebp,%ecx
  802baa:	ba 20 00 00 00       	mov    $0x20,%edx
  802baf:	29 ea                	sub    %ebp,%edx
  802bb1:	d3 e0                	shl    %cl,%eax
  802bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bb7:	89 d1                	mov    %edx,%ecx
  802bb9:	89 f8                	mov    %edi,%eax
  802bbb:	d3 e8                	shr    %cl,%eax
  802bbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bc5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bc9:	09 c1                	or     %eax,%ecx
  802bcb:	89 d8                	mov    %ebx,%eax
  802bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bd1:	89 e9                	mov    %ebp,%ecx
  802bd3:	d3 e7                	shl    %cl,%edi
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	d3 e8                	shr    %cl,%eax
  802bd9:	89 e9                	mov    %ebp,%ecx
  802bdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bdf:	d3 e3                	shl    %cl,%ebx
  802be1:	89 c7                	mov    %eax,%edi
  802be3:	89 d1                	mov    %edx,%ecx
  802be5:	89 f0                	mov    %esi,%eax
  802be7:	d3 e8                	shr    %cl,%eax
  802be9:	89 e9                	mov    %ebp,%ecx
  802beb:	89 fa                	mov    %edi,%edx
  802bed:	d3 e6                	shl    %cl,%esi
  802bef:	09 d8                	or     %ebx,%eax
  802bf1:	f7 74 24 08          	divl   0x8(%esp)
  802bf5:	89 d1                	mov    %edx,%ecx
  802bf7:	89 f3                	mov    %esi,%ebx
  802bf9:	f7 64 24 0c          	mull   0xc(%esp)
  802bfd:	89 c6                	mov    %eax,%esi
  802bff:	89 d7                	mov    %edx,%edi
  802c01:	39 d1                	cmp    %edx,%ecx
  802c03:	72 06                	jb     802c0b <__umoddi3+0xfb>
  802c05:	75 10                	jne    802c17 <__umoddi3+0x107>
  802c07:	39 c3                	cmp    %eax,%ebx
  802c09:	73 0c                	jae    802c17 <__umoddi3+0x107>
  802c0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c13:	89 d7                	mov    %edx,%edi
  802c15:	89 c6                	mov    %eax,%esi
  802c17:	89 ca                	mov    %ecx,%edx
  802c19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c1e:	29 f3                	sub    %esi,%ebx
  802c20:	19 fa                	sbb    %edi,%edx
  802c22:	89 d0                	mov    %edx,%eax
  802c24:	d3 e0                	shl    %cl,%eax
  802c26:	89 e9                	mov    %ebp,%ecx
  802c28:	d3 eb                	shr    %cl,%ebx
  802c2a:	d3 ea                	shr    %cl,%edx
  802c2c:	09 d8                	or     %ebx,%eax
  802c2e:	83 c4 1c             	add    $0x1c,%esp
  802c31:	5b                   	pop    %ebx
  802c32:	5e                   	pop    %esi
  802c33:	5f                   	pop    %edi
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    
  802c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c3d:	8d 76 00             	lea    0x0(%esi),%esi
  802c40:	89 da                	mov    %ebx,%edx
  802c42:	29 fe                	sub    %edi,%esi
  802c44:	19 c2                	sbb    %eax,%edx
  802c46:	89 f1                	mov    %esi,%ecx
  802c48:	89 c8                	mov    %ecx,%eax
  802c4a:	e9 4b ff ff ff       	jmp    802b9a <__umoddi3+0x8a>
