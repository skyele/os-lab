
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 60 2c 80 00       	push   $0x802c60
  800043:	e8 c8 1d 00 00       	call   801e10 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 60 1a 00 00       	call   801ac0 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 86 19 00 00       	call   8019f9 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 72 13 00 00       	call   8013f7 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 24 1a 00 00       	call   801ac0 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  8000a3:	e8 d4 02 00 00       	call   80037c <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 3e 19 00 00       	call   8019f9 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 50 80 00       	push   $0x805020
  8000cf:	68 20 52 80 00       	push   $0x805220
  8000d4:	e8 08 0c 00 00       	call   800ce1 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 9b 2c 80 00       	push   $0x802c9b
  8000ec:	e8 8b 02 00 00       	call   80037c <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 c4 19 00 00       	call   801ac0 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 30 17 00 00       	call   801834 <close>
		exit();
  800104:	e8 63 01 00 00       	call   80026c <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 55 25 00 00       	call   80266a <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 d1 18 00 00       	call   8019f9 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 b4 2c 80 00       	push   $0x802cb4
  80013b:	e8 3c 02 00 00       	call   80037c <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 ec 16 00 00       	call   801834 <close>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 65 2c 80 00       	push   $0x802c65
  80015a:	6a 0c                	push   $0xc
  80015c:	68 73 2c 80 00       	push   $0x802c73
  800161:	e8 20 01 00 00       	call   800286 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 88 2c 80 00       	push   $0x802c88
  80016c:	6a 0f                	push   $0xf
  80016e:	68 73 2c 80 00       	push   $0x802c73
  800173:	e8 0e 01 00 00       	call   800286 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 92 2c 80 00       	push   $0x802c92
  80017e:	6a 12                	push   $0x12
  800180:	68 73 2c 80 00       	push   $0x802c73
  800185:	e8 fc 00 00 00       	call   800286 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 14 2d 80 00       	push   $0x802d14
  800194:	6a 17                	push   $0x17
  800196:	68 73 2c 80 00       	push   $0x802c73
  80019b:	e8 e6 00 00 00       	call   800286 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 40 2d 80 00       	push   $0x802d40
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 73 2c 80 00       	push   $0x802c73
  8001af:	e8 d2 00 00 00       	call   800286 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 78 2d 80 00       	push   $0x802d78
  8001be:	6a 21                	push   $0x21
  8001c0:	68 73 2c 80 00       	push   $0x802c73
  8001c5:	e8 bc 00 00 00       	call   800286 <_panic>

008001ca <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001d3:	c7 05 20 54 80 00 00 	movl   $0x0,0x805420
  8001da:	00 00 00 
	envid_t find = sys_getenvid();
  8001dd:	e8 ad 0c 00 00       	call   800e8f <sys_getenvid>
  8001e2:	8b 1d 20 54 80 00    	mov    0x805420,%ebx
  8001e8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001ed:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001f2:	bf 01 00 00 00       	mov    $0x1,%edi
  8001f7:	eb 0b                	jmp    800204 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001f9:	83 c2 01             	add    $0x1,%edx
  8001fc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800202:	74 21                	je     800225 <libmain+0x5b>
		if(envs[i].env_id == find)
  800204:	89 d1                	mov    %edx,%ecx
  800206:	c1 e1 07             	shl    $0x7,%ecx
  800209:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80020f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800212:	39 c1                	cmp    %eax,%ecx
  800214:	75 e3                	jne    8001f9 <libmain+0x2f>
  800216:	89 d3                	mov    %edx,%ebx
  800218:	c1 e3 07             	shl    $0x7,%ebx
  80021b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800221:	89 fe                	mov    %edi,%esi
  800223:	eb d4                	jmp    8001f9 <libmain+0x2f>
  800225:	89 f0                	mov    %esi,%eax
  800227:	84 c0                	test   %al,%al
  800229:	74 06                	je     800231 <libmain+0x67>
  80022b:	89 1d 20 54 80 00    	mov    %ebx,0x805420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800231:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800235:	7e 0a                	jle    800241 <libmain+0x77>
		binaryname = argv[0];
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 9b 2d 80 00       	push   $0x802d9b
  800249:	e8 2e 01 00 00       	call   80037c <cprintf>
	// call user main routine
	umain(argc, argv);
  80024e:	83 c4 08             	add    $0x8,%esp
  800251:	ff 75 0c             	pushl  0xc(%ebp)
  800254:	ff 75 08             	pushl  0x8(%ebp)
  800257:	e8 d7 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80025c:	e8 0b 00 00 00       	call   80026c <exit>
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800272:	e8 ea 15 00 00       	call   801861 <close_all>
	sys_env_destroy(0);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 00                	push   $0x0
  80027c:	e8 cd 0b 00 00       	call   800e4e <sys_env_destroy>
}
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80028b:	a1 20 54 80 00       	mov    0x805420,%eax
  800290:	8b 40 48             	mov    0x48(%eax),%eax
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	68 f0 2d 80 00       	push   $0x802df0
  80029b:	50                   	push   %eax
  80029c:	68 bf 2d 80 00       	push   $0x802dbf
  8002a1:	e8 d6 00 00 00       	call   80037c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002a6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002a9:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002af:	e8 db 0b 00 00       	call   800e8f <sys_getenvid>
  8002b4:	83 c4 04             	add    $0x4,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	56                   	push   %esi
  8002be:	50                   	push   %eax
  8002bf:	68 cc 2d 80 00       	push   $0x802dcc
  8002c4:	e8 b3 00 00 00       	call   80037c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c9:	83 c4 18             	add    $0x18,%esp
  8002cc:	53                   	push   %ebx
  8002cd:	ff 75 10             	pushl  0x10(%ebp)
  8002d0:	e8 56 00 00 00       	call   80032b <vcprintf>
	cprintf("\n");
  8002d5:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  8002dc:	e8 9b 00 00 00       	call   80037c <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e4:	cc                   	int3   
  8002e5:	eb fd                	jmp    8002e4 <_panic+0x5e>

008002e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f1:	8b 13                	mov    (%ebx),%edx
  8002f3:	8d 42 01             	lea    0x1(%edx),%eax
  8002f6:	89 03                	mov    %eax,(%ebx)
  8002f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800304:	74 09                	je     80030f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800306:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	68 ff 00 00 00       	push   $0xff
  800317:	8d 43 08             	lea    0x8(%ebx),%eax
  80031a:	50                   	push   %eax
  80031b:	e8 f1 0a 00 00       	call   800e11 <sys_cputs>
		b->idx = 0;
  800320:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	eb db                	jmp    800306 <putch+0x1f>

0080032b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800334:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033b:	00 00 00 
	b.cnt = 0;
  80033e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800345:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	68 e7 02 80 00       	push   $0x8002e7
  80035a:	e8 4a 01 00 00       	call   8004a9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80035f:	83 c4 08             	add    $0x8,%esp
  800362:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800368:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80036e:	50                   	push   %eax
  80036f:	e8 9d 0a 00 00       	call   800e11 <sys_cputs>

	return b.cnt;
}
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800382:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800385:	50                   	push   %eax
  800386:	ff 75 08             	pushl  0x8(%ebp)
  800389:	e8 9d ff ff ff       	call   80032b <vcprintf>
	va_end(ap);

	return cnt;
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 1c             	sub    $0x1c,%esp
  800399:	89 c6                	mov    %eax,%esi
  80039b:	89 d7                	mov    %edx,%edi
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003af:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003b3:	74 2c                	je     8003e1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c5:	39 c2                	cmp    %eax,%edx
  8003c7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003ca:	73 43                	jae    80040f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003cc:	83 eb 01             	sub    $0x1,%ebx
  8003cf:	85 db                	test   %ebx,%ebx
  8003d1:	7e 6c                	jle    80043f <printnum+0xaf>
				putch(padc, putdat);
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	57                   	push   %edi
  8003d7:	ff 75 18             	pushl  0x18(%ebp)
  8003da:	ff d6                	call   *%esi
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb eb                	jmp    8003cc <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	6a 20                	push   $0x20
  8003e6:	6a 00                	push   $0x0
  8003e8:	50                   	push   %eax
  8003e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ef:	89 fa                	mov    %edi,%edx
  8003f1:	89 f0                	mov    %esi,%eax
  8003f3:	e8 98 ff ff ff       	call   800390 <printnum>
		while (--width > 0)
  8003f8:	83 c4 20             	add    $0x20,%esp
  8003fb:	83 eb 01             	sub    $0x1,%ebx
  8003fe:	85 db                	test   %ebx,%ebx
  800400:	7e 65                	jle    800467 <printnum+0xd7>
			putch(padc, putdat);
  800402:	83 ec 08             	sub    $0x8,%esp
  800405:	57                   	push   %edi
  800406:	6a 20                	push   $0x20
  800408:	ff d6                	call   *%esi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	eb ec                	jmp    8003fb <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	ff 75 18             	pushl  0x18(%ebp)
  800415:	83 eb 01             	sub    $0x1,%ebx
  800418:	53                   	push   %ebx
  800419:	50                   	push   %eax
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	ff 75 dc             	pushl  -0x24(%ebp)
  800420:	ff 75 d8             	pushl  -0x28(%ebp)
  800423:	ff 75 e4             	pushl  -0x1c(%ebp)
  800426:	ff 75 e0             	pushl  -0x20(%ebp)
  800429:	e8 d2 25 00 00       	call   802a00 <__udivdi3>
  80042e:	83 c4 18             	add    $0x18,%esp
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	89 fa                	mov    %edi,%edx
  800435:	89 f0                	mov    %esi,%eax
  800437:	e8 54 ff ff ff       	call   800390 <printnum>
  80043c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	57                   	push   %edi
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	ff 75 dc             	pushl  -0x24(%ebp)
  800449:	ff 75 d8             	pushl  -0x28(%ebp)
  80044c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80044f:	ff 75 e0             	pushl  -0x20(%ebp)
  800452:	e8 b9 26 00 00       	call   802b10 <__umoddi3>
  800457:	83 c4 14             	add    $0x14,%esp
  80045a:	0f be 80 f7 2d 80 00 	movsbl 0x802df7(%eax),%eax
  800461:	50                   	push   %eax
  800462:	ff d6                	call   *%esi
  800464:	83 c4 10             	add    $0x10,%esp
	}
}
  800467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046a:	5b                   	pop    %ebx
  80046b:	5e                   	pop    %esi
  80046c:	5f                   	pop    %edi
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800475:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	3b 50 04             	cmp    0x4(%eax),%edx
  80047e:	73 0a                	jae    80048a <sprintputch+0x1b>
		*b->buf++ = ch;
  800480:	8d 4a 01             	lea    0x1(%edx),%ecx
  800483:	89 08                	mov    %ecx,(%eax)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	88 02                	mov    %al,(%edx)
}
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    

0080048c <printfmt>:
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800492:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800495:	50                   	push   %eax
  800496:	ff 75 10             	pushl  0x10(%ebp)
  800499:	ff 75 0c             	pushl  0xc(%ebp)
  80049c:	ff 75 08             	pushl  0x8(%ebp)
  80049f:	e8 05 00 00 00       	call   8004a9 <vprintfmt>
}
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <vprintfmt>:
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	57                   	push   %edi
  8004ad:	56                   	push   %esi
  8004ae:	53                   	push   %ebx
  8004af:	83 ec 3c             	sub    $0x3c,%esp
  8004b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004bb:	e9 32 04 00 00       	jmp    8008f2 <vprintfmt+0x449>
		padc = ' ';
  8004c0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004c4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004cb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004e7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8d 47 01             	lea    0x1(%edi),%eax
  8004ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f2:	0f b6 17             	movzbl (%edi),%edx
  8004f5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004f8:	3c 55                	cmp    $0x55,%al
  8004fa:	0f 87 12 05 00 00    	ja     800a12 <vprintfmt+0x569>
  800500:	0f b6 c0             	movzbl %al,%eax
  800503:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80050d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800511:	eb d9                	jmp    8004ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800516:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80051a:	eb d0                	jmp    8004ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	0f b6 d2             	movzbl %dl,%edx
  80051f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800522:	b8 00 00 00 00       	mov    $0x0,%eax
  800527:	89 75 08             	mov    %esi,0x8(%ebp)
  80052a:	eb 03                	jmp    80052f <vprintfmt+0x86>
  80052c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80052f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800532:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800536:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800539:	8d 72 d0             	lea    -0x30(%edx),%esi
  80053c:	83 fe 09             	cmp    $0x9,%esi
  80053f:	76 eb                	jbe    80052c <vprintfmt+0x83>
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	8b 75 08             	mov    0x8(%ebp),%esi
  800547:	eb 14                	jmp    80055d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80055d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800561:	79 89                	jns    8004ec <vprintfmt+0x43>
				width = precision, precision = -1;
  800563:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800566:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800569:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800570:	e9 77 ff ff ff       	jmp    8004ec <vprintfmt+0x43>
  800575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800578:	85 c0                	test   %eax,%eax
  80057a:	0f 48 c1             	cmovs  %ecx,%eax
  80057d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800583:	e9 64 ff ff ff       	jmp    8004ec <vprintfmt+0x43>
  800588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80058b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800592:	e9 55 ff ff ff       	jmp    8004ec <vprintfmt+0x43>
			lflag++;
  800597:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80059e:	e9 49 ff ff ff       	jmp    8004ec <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 78 04             	lea    0x4(%eax),%edi
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	ff 30                	pushl  (%eax)
  8005af:	ff d6                	call   *%esi
			break;
  8005b1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005b4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005b7:	e9 33 03 00 00       	jmp    8008ef <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 78 04             	lea    0x4(%eax),%edi
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	99                   	cltd   
  8005c5:	31 d0                	xor    %edx,%eax
  8005c7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c9:	83 f8 10             	cmp    $0x10,%eax
  8005cc:	7f 23                	jg     8005f1 <vprintfmt+0x148>
  8005ce:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  8005d5:	85 d2                	test   %edx,%edx
  8005d7:	74 18                	je     8005f1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005d9:	52                   	push   %edx
  8005da:	68 49 33 80 00       	push   $0x803349
  8005df:	53                   	push   %ebx
  8005e0:	56                   	push   %esi
  8005e1:	e8 a6 fe ff ff       	call   80048c <printfmt>
  8005e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ec:	e9 fe 02 00 00       	jmp    8008ef <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f1:	50                   	push   %eax
  8005f2:	68 0f 2e 80 00       	push   $0x802e0f
  8005f7:	53                   	push   %ebx
  8005f8:	56                   	push   %esi
  8005f9:	e8 8e fe ff ff       	call   80048c <printfmt>
  8005fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800601:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800604:	e9 e6 02 00 00       	jmp    8008ef <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	83 c0 04             	add    $0x4,%eax
  80060f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800617:	85 c9                	test   %ecx,%ecx
  800619:	b8 08 2e 80 00       	mov    $0x802e08,%eax
  80061e:	0f 45 c1             	cmovne %ecx,%eax
  800621:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800624:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800628:	7e 06                	jle    800630 <vprintfmt+0x187>
  80062a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80062e:	75 0d                	jne    80063d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800630:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800633:	89 c7                	mov    %eax,%edi
  800635:	03 45 e0             	add    -0x20(%ebp),%eax
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	eb 53                	jmp    800690 <vprintfmt+0x1e7>
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 d8             	pushl  -0x28(%ebp)
  800643:	50                   	push   %eax
  800644:	e8 71 04 00 00       	call   800aba <strnlen>
  800649:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064c:	29 c1                	sub    %eax,%ecx
  80064e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800656:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80065a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80065d:	eb 0f                	jmp    80066e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	53                   	push   %ebx
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800668:	83 ef 01             	sub    $0x1,%edi
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	85 ff                	test   %edi,%edi
  800670:	7f ed                	jg     80065f <vprintfmt+0x1b6>
  800672:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800675:	85 c9                	test   %ecx,%ecx
  800677:	b8 00 00 00 00       	mov    $0x0,%eax
  80067c:	0f 49 c1             	cmovns %ecx,%eax
  80067f:	29 c1                	sub    %eax,%ecx
  800681:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800684:	eb aa                	jmp    800630 <vprintfmt+0x187>
					putch(ch, putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	52                   	push   %edx
  80068b:	ff d6                	call   *%esi
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800693:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800695:	83 c7 01             	add    $0x1,%edi
  800698:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069c:	0f be d0             	movsbl %al,%edx
  80069f:	85 d2                	test   %edx,%edx
  8006a1:	74 4b                	je     8006ee <vprintfmt+0x245>
  8006a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a7:	78 06                	js     8006af <vprintfmt+0x206>
  8006a9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ad:	78 1e                	js     8006cd <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006af:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006b3:	74 d1                	je     800686 <vprintfmt+0x1dd>
  8006b5:	0f be c0             	movsbl %al,%eax
  8006b8:	83 e8 20             	sub    $0x20,%eax
  8006bb:	83 f8 5e             	cmp    $0x5e,%eax
  8006be:	76 c6                	jbe    800686 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	6a 3f                	push   $0x3f
  8006c6:	ff d6                	call   *%esi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb c3                	jmp    800690 <vprintfmt+0x1e7>
  8006cd:	89 cf                	mov    %ecx,%edi
  8006cf:	eb 0e                	jmp    8006df <vprintfmt+0x236>
				putch(' ', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 20                	push   $0x20
  8006d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006d9:	83 ef 01             	sub    $0x1,%edi
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	85 ff                	test   %edi,%edi
  8006e1:	7f ee                	jg     8006d1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e9:	e9 01 02 00 00       	jmp    8008ef <vprintfmt+0x446>
  8006ee:	89 cf                	mov    %ecx,%edi
  8006f0:	eb ed                	jmp    8006df <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006f5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006fc:	e9 eb fd ff ff       	jmp    8004ec <vprintfmt+0x43>
	if (lflag >= 2)
  800701:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800705:	7f 21                	jg     800728 <vprintfmt+0x27f>
	else if (lflag)
  800707:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80070b:	74 68                	je     800775 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800715:	89 c1                	mov    %eax,%ecx
  800717:	c1 f9 1f             	sar    $0x1f,%ecx
  80071a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
  800726:	eb 17                	jmp    80073f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 50 04             	mov    0x4(%eax),%edx
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800733:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8d 40 08             	lea    0x8(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80073f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800742:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80074b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80074f:	78 3f                	js     800790 <vprintfmt+0x2e7>
			base = 10;
  800751:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800756:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80075a:	0f 84 71 01 00 00    	je     8008d1 <vprintfmt+0x428>
				putch('+', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 2b                	push   $0x2b
  800766:	ff d6                	call   *%esi
  800768:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800770:	e9 5c 01 00 00       	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80077d:	89 c1                	mov    %eax,%ecx
  80077f:	c1 f9 1f             	sar    $0x1f,%ecx
  800782:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
  80078e:	eb af                	jmp    80073f <vprintfmt+0x296>
				putch('-', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	53                   	push   %ebx
  800794:	6a 2d                	push   $0x2d
  800796:	ff d6                	call   *%esi
				num = -(long long) num;
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079e:	f7 d8                	neg    %eax
  8007a0:	83 d2 00             	adc    $0x0,%edx
  8007a3:	f7 da                	neg    %edx
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b3:	e9 19 01 00 00       	jmp    8008d1 <vprintfmt+0x428>
	if (lflag >= 2)
  8007b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bc:	7f 29                	jg     8007e7 <vprintfmt+0x33e>
	else if (lflag)
  8007be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c2:	74 44                	je     800808 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e2:	e9 ea 00 00 00       	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8d 40 08             	lea    0x8(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800803:	e9 c9 00 00 00       	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8d 40 04             	lea    0x4(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800821:	b8 0a 00 00 00       	mov    $0xa,%eax
  800826:	e9 a6 00 00 00       	jmp    8008d1 <vprintfmt+0x428>
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 30                	push   $0x30
  800831:	ff d6                	call   *%esi
	if (lflag >= 2)
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80083a:	7f 26                	jg     800862 <vprintfmt+0x3b9>
	else if (lflag)
  80083c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800840:	74 3e                	je     800880 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	ba 00 00 00 00       	mov    $0x0,%edx
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 04             	lea    0x4(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085b:	b8 08 00 00 00       	mov    $0x8,%eax
  800860:	eb 6f                	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8b 50 04             	mov    0x4(%eax),%edx
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8d 40 08             	lea    0x8(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800879:	b8 08 00 00 00       	mov    $0x8,%eax
  80087e:	eb 51                	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	ba 00 00 00 00       	mov    $0x0,%edx
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8d 40 04             	lea    0x4(%eax),%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800899:	b8 08 00 00 00       	mov    $0x8,%eax
  80089e:	eb 31                	jmp    8008d1 <vprintfmt+0x428>
			putch('0', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	6a 30                	push   $0x30
  8008a6:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a8:	83 c4 08             	add    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	6a 78                	push   $0x78
  8008ae:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 04             	lea    0x4(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d1:	83 ec 0c             	sub    $0xc,%esp
  8008d4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008d8:	52                   	push   %edx
  8008d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e3:	89 da                	mov    %ebx,%edx
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	e8 a4 fa ff ff       	call   800390 <printnum>
			break;
  8008ec:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f2:	83 c7 01             	add    $0x1,%edi
  8008f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f9:	83 f8 25             	cmp    $0x25,%eax
  8008fc:	0f 84 be fb ff ff    	je     8004c0 <vprintfmt+0x17>
			if (ch == '\0')
  800902:	85 c0                	test   %eax,%eax
  800904:	0f 84 28 01 00 00    	je     800a32 <vprintfmt+0x589>
			putch(ch, putdat);
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	50                   	push   %eax
  80090f:	ff d6                	call   *%esi
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	eb dc                	jmp    8008f2 <vprintfmt+0x449>
	if (lflag >= 2)
  800916:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80091a:	7f 26                	jg     800942 <vprintfmt+0x499>
	else if (lflag)
  80091c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800920:	74 41                	je     800963 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	8d 40 04             	lea    0x4(%eax),%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093b:	b8 10 00 00 00       	mov    $0x10,%eax
  800940:	eb 8f                	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 50 04             	mov    0x4(%eax),%edx
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800959:	b8 10 00 00 00       	mov    $0x10,%eax
  80095e:	e9 6e ff ff ff       	jmp    8008d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800970:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8d 40 04             	lea    0x4(%eax),%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097c:	b8 10 00 00 00       	mov    $0x10,%eax
  800981:	e9 4b ff ff ff       	jmp    8008d1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	83 c0 04             	add    $0x4,%eax
  80098c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	85 c0                	test   %eax,%eax
  800996:	74 14                	je     8009ac <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800998:	8b 13                	mov    (%ebx),%edx
  80099a:	83 fa 7f             	cmp    $0x7f,%edx
  80099d:	7f 37                	jg     8009d6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80099f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a7:	e9 43 ff ff ff       	jmp    8008ef <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b1:	bf 2d 2f 80 00       	mov    $0x802f2d,%edi
							putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	53                   	push   %ebx
  8009ba:	50                   	push   %eax
  8009bb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009bd:	83 c7 01             	add    $0x1,%edi
  8009c0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	85 c0                	test   %eax,%eax
  8009c9:	75 eb                	jne    8009b6 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	e9 19 ff ff ff       	jmp    8008ef <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009d6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009dd:	bf 65 2f 80 00       	mov    $0x802f65,%edi
							putch(ch, putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	50                   	push   %eax
  8009e7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009e9:	83 c7 01             	add    $0x1,%edi
  8009ec:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	85 c0                	test   %eax,%eax
  8009f5:	75 eb                	jne    8009e2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fd:	e9 ed fe ff ff       	jmp    8008ef <vprintfmt+0x446>
			putch(ch, putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	53                   	push   %ebx
  800a06:	6a 25                	push   $0x25
  800a08:	ff d6                	call   *%esi
			break;
  800a0a:	83 c4 10             	add    $0x10,%esp
  800a0d:	e9 dd fe ff ff       	jmp    8008ef <vprintfmt+0x446>
			putch('%', putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	53                   	push   %ebx
  800a16:	6a 25                	push   $0x25
  800a18:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	89 f8                	mov    %edi,%eax
  800a1f:	eb 03                	jmp    800a24 <vprintfmt+0x57b>
  800a21:	83 e8 01             	sub    $0x1,%eax
  800a24:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a28:	75 f7                	jne    800a21 <vprintfmt+0x578>
  800a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2d:	e9 bd fe ff ff       	jmp    8008ef <vprintfmt+0x446>
}
  800a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5f                   	pop    %edi
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a49:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a57:	85 c0                	test   %eax,%eax
  800a59:	74 26                	je     800a81 <vsnprintf+0x47>
  800a5b:	85 d2                	test   %edx,%edx
  800a5d:	7e 22                	jle    800a81 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5f:	ff 75 14             	pushl  0x14(%ebp)
  800a62:	ff 75 10             	pushl  0x10(%ebp)
  800a65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a68:	50                   	push   %eax
  800a69:	68 6f 04 80 00       	push   $0x80046f
  800a6e:	e8 36 fa ff ff       	call   8004a9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    
		return -E_INVAL;
  800a81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a86:	eb f7                	jmp    800a7f <vsnprintf+0x45>

00800a88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a91:	50                   	push   %eax
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 9a ff ff ff       	call   800a3a <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aad:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab1:	74 05                	je     800ab8 <strlen+0x16>
		n++;
  800ab3:	83 c0 01             	add    $0x1,%eax
  800ab6:	eb f5                	jmp    800aad <strlen+0xb>
	return n;
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	39 c2                	cmp    %eax,%edx
  800aca:	74 0d                	je     800ad9 <strnlen+0x1f>
  800acc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ad0:	74 05                	je     800ad7 <strnlen+0x1d>
		n++;
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	eb f1                	jmp    800ac8 <strnlen+0xe>
  800ad7:	89 d0                	mov    %edx,%eax
	return n;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af1:	83 c2 01             	add    $0x1,%edx
  800af4:	84 c9                	test   %cl,%cl
  800af6:	75 f2                	jne    800aea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af8:	5b                   	pop    %ebx
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	53                   	push   %ebx
  800aff:	83 ec 10             	sub    $0x10,%esp
  800b02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b05:	53                   	push   %ebx
  800b06:	e8 97 ff ff ff       	call   800aa2 <strlen>
  800b0b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	01 d8                	add    %ebx,%eax
  800b13:	50                   	push   %eax
  800b14:	e8 c2 ff ff ff       	call   800adb <strcpy>
	return dst;
}
  800b19:	89 d8                	mov    %ebx,%eax
  800b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	56                   	push   %esi
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2b:	89 c6                	mov    %eax,%esi
  800b2d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	39 f2                	cmp    %esi,%edx
  800b34:	74 11                	je     800b47 <strncpy+0x27>
		*dst++ = *src;
  800b36:	83 c2 01             	add    $0x1,%edx
  800b39:	0f b6 19             	movzbl (%ecx),%ebx
  800b3c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b3f:	80 fb 01             	cmp    $0x1,%bl
  800b42:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b45:	eb eb                	jmp    800b32 <strncpy+0x12>
	}
	return ret;
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
  800b50:	8b 75 08             	mov    0x8(%ebp),%esi
  800b53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b56:	8b 55 10             	mov    0x10(%ebp),%edx
  800b59:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b5b:	85 d2                	test   %edx,%edx
  800b5d:	74 21                	je     800b80 <strlcpy+0x35>
  800b5f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b63:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b65:	39 c2                	cmp    %eax,%edx
  800b67:	74 14                	je     800b7d <strlcpy+0x32>
  800b69:	0f b6 19             	movzbl (%ecx),%ebx
  800b6c:	84 db                	test   %bl,%bl
  800b6e:	74 0b                	je     800b7b <strlcpy+0x30>
			*dst++ = *src++;
  800b70:	83 c1 01             	add    $0x1,%ecx
  800b73:	83 c2 01             	add    $0x1,%edx
  800b76:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b79:	eb ea                	jmp    800b65 <strlcpy+0x1a>
  800b7b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b80:	29 f0                	sub    %esi,%eax
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b8f:	0f b6 01             	movzbl (%ecx),%eax
  800b92:	84 c0                	test   %al,%al
  800b94:	74 0c                	je     800ba2 <strcmp+0x1c>
  800b96:	3a 02                	cmp    (%edx),%al
  800b98:	75 08                	jne    800ba2 <strcmp+0x1c>
		p++, q++;
  800b9a:	83 c1 01             	add    $0x1,%ecx
  800b9d:	83 c2 01             	add    $0x1,%edx
  800ba0:	eb ed                	jmp    800b8f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba2:	0f b6 c0             	movzbl %al,%eax
  800ba5:	0f b6 12             	movzbl (%edx),%edx
  800ba8:	29 d0                	sub    %edx,%eax
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	53                   	push   %ebx
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb6:	89 c3                	mov    %eax,%ebx
  800bb8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bbb:	eb 06                	jmp    800bc3 <strncmp+0x17>
		n--, p++, q++;
  800bbd:	83 c0 01             	add    $0x1,%eax
  800bc0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc3:	39 d8                	cmp    %ebx,%eax
  800bc5:	74 16                	je     800bdd <strncmp+0x31>
  800bc7:	0f b6 08             	movzbl (%eax),%ecx
  800bca:	84 c9                	test   %cl,%cl
  800bcc:	74 04                	je     800bd2 <strncmp+0x26>
  800bce:	3a 0a                	cmp    (%edx),%cl
  800bd0:	74 eb                	je     800bbd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd2:	0f b6 00             	movzbl (%eax),%eax
  800bd5:	0f b6 12             	movzbl (%edx),%edx
  800bd8:	29 d0                	sub    %edx,%eax
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    
		return 0;
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	eb f6                	jmp    800bda <strncmp+0x2e>

00800be4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bee:	0f b6 10             	movzbl (%eax),%edx
  800bf1:	84 d2                	test   %dl,%dl
  800bf3:	74 09                	je     800bfe <strchr+0x1a>
		if (*s == c)
  800bf5:	38 ca                	cmp    %cl,%dl
  800bf7:	74 0a                	je     800c03 <strchr+0x1f>
	for (; *s; s++)
  800bf9:	83 c0 01             	add    $0x1,%eax
  800bfc:	eb f0                	jmp    800bee <strchr+0xa>
			return (char *) s;
	return 0;
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c12:	38 ca                	cmp    %cl,%dl
  800c14:	74 09                	je     800c1f <strfind+0x1a>
  800c16:	84 d2                	test   %dl,%dl
  800c18:	74 05                	je     800c1f <strfind+0x1a>
	for (; *s; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	eb f0                	jmp    800c0f <strfind+0xa>
			break;
	return (char *) s;
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
  800c27:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c2d:	85 c9                	test   %ecx,%ecx
  800c2f:	74 31                	je     800c62 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c31:	89 f8                	mov    %edi,%eax
  800c33:	09 c8                	or     %ecx,%eax
  800c35:	a8 03                	test   $0x3,%al
  800c37:	75 23                	jne    800c5c <memset+0x3b>
		c &= 0xFF;
  800c39:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	c1 e3 08             	shl    $0x8,%ebx
  800c42:	89 d0                	mov    %edx,%eax
  800c44:	c1 e0 18             	shl    $0x18,%eax
  800c47:	89 d6                	mov    %edx,%esi
  800c49:	c1 e6 10             	shl    $0x10,%esi
  800c4c:	09 f0                	or     %esi,%eax
  800c4e:	09 c2                	or     %eax,%edx
  800c50:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c52:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c55:	89 d0                	mov    %edx,%eax
  800c57:	fc                   	cld    
  800c58:	f3 ab                	rep stos %eax,%es:(%edi)
  800c5a:	eb 06                	jmp    800c62 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	fc                   	cld    
  800c60:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c62:	89 f8                	mov    %edi,%eax
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c77:	39 c6                	cmp    %eax,%esi
  800c79:	73 32                	jae    800cad <memmove+0x44>
  800c7b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c7e:	39 c2                	cmp    %eax,%edx
  800c80:	76 2b                	jbe    800cad <memmove+0x44>
		s += n;
		d += n;
  800c82:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c85:	89 fe                	mov    %edi,%esi
  800c87:	09 ce                	or     %ecx,%esi
  800c89:	09 d6                	or     %edx,%esi
  800c8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c91:	75 0e                	jne    800ca1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c93:	83 ef 04             	sub    $0x4,%edi
  800c96:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c9c:	fd                   	std    
  800c9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c9f:	eb 09                	jmp    800caa <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca1:	83 ef 01             	sub    $0x1,%edi
  800ca4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ca7:	fd                   	std    
  800ca8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800caa:	fc                   	cld    
  800cab:	eb 1a                	jmp    800cc7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	09 ca                	or     %ecx,%edx
  800cb1:	09 f2                	or     %esi,%edx
  800cb3:	f6 c2 03             	test   $0x3,%dl
  800cb6:	75 0a                	jne    800cc2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cb8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cbb:	89 c7                	mov    %eax,%edi
  800cbd:	fc                   	cld    
  800cbe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc0:	eb 05                	jmp    800cc7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cc2:	89 c7                	mov    %eax,%edi
  800cc4:	fc                   	cld    
  800cc5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd1:	ff 75 10             	pushl  0x10(%ebp)
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	ff 75 08             	pushl  0x8(%ebp)
  800cda:	e8 8a ff ff ff       	call   800c69 <memmove>
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cec:	89 c6                	mov    %eax,%esi
  800cee:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf1:	39 f0                	cmp    %esi,%eax
  800cf3:	74 1c                	je     800d11 <memcmp+0x30>
		if (*s1 != *s2)
  800cf5:	0f b6 08             	movzbl (%eax),%ecx
  800cf8:	0f b6 1a             	movzbl (%edx),%ebx
  800cfb:	38 d9                	cmp    %bl,%cl
  800cfd:	75 08                	jne    800d07 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cff:	83 c0 01             	add    $0x1,%eax
  800d02:	83 c2 01             	add    $0x1,%edx
  800d05:	eb ea                	jmp    800cf1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d07:	0f b6 c1             	movzbl %cl,%eax
  800d0a:	0f b6 db             	movzbl %bl,%ebx
  800d0d:	29 d8                	sub    %ebx,%eax
  800d0f:	eb 05                	jmp    800d16 <memcmp+0x35>
	}

	return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d23:	89 c2                	mov    %eax,%edx
  800d25:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d28:	39 d0                	cmp    %edx,%eax
  800d2a:	73 09                	jae    800d35 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d2c:	38 08                	cmp    %cl,(%eax)
  800d2e:	74 05                	je     800d35 <memfind+0x1b>
	for (; s < ends; s++)
  800d30:	83 c0 01             	add    $0x1,%eax
  800d33:	eb f3                	jmp    800d28 <memfind+0xe>
			break;
	return (void *) s;
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	eb 03                	jmp    800d48 <strtol+0x11>
		s++;
  800d45:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d48:	0f b6 01             	movzbl (%ecx),%eax
  800d4b:	3c 20                	cmp    $0x20,%al
  800d4d:	74 f6                	je     800d45 <strtol+0xe>
  800d4f:	3c 09                	cmp    $0x9,%al
  800d51:	74 f2                	je     800d45 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d53:	3c 2b                	cmp    $0x2b,%al
  800d55:	74 2a                	je     800d81 <strtol+0x4a>
	int neg = 0;
  800d57:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d5c:	3c 2d                	cmp    $0x2d,%al
  800d5e:	74 2b                	je     800d8b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d60:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d66:	75 0f                	jne    800d77 <strtol+0x40>
  800d68:	80 39 30             	cmpb   $0x30,(%ecx)
  800d6b:	74 28                	je     800d95 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d74:	0f 44 d8             	cmove  %eax,%ebx
  800d77:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d7f:	eb 50                	jmp    800dd1 <strtol+0x9a>
		s++;
  800d81:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d84:	bf 00 00 00 00       	mov    $0x0,%edi
  800d89:	eb d5                	jmp    800d60 <strtol+0x29>
		s++, neg = 1;
  800d8b:	83 c1 01             	add    $0x1,%ecx
  800d8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d93:	eb cb                	jmp    800d60 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d99:	74 0e                	je     800da9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d9b:	85 db                	test   %ebx,%ebx
  800d9d:	75 d8                	jne    800d77 <strtol+0x40>
		s++, base = 8;
  800d9f:	83 c1 01             	add    $0x1,%ecx
  800da2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800da7:	eb ce                	jmp    800d77 <strtol+0x40>
		s += 2, base = 16;
  800da9:	83 c1 02             	add    $0x2,%ecx
  800dac:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db1:	eb c4                	jmp    800d77 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800db3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800db6:	89 f3                	mov    %esi,%ebx
  800db8:	80 fb 19             	cmp    $0x19,%bl
  800dbb:	77 29                	ja     800de6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dbd:	0f be d2             	movsbl %dl,%edx
  800dc0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dc6:	7d 30                	jge    800df8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dc8:	83 c1 01             	add    $0x1,%ecx
  800dcb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dd1:	0f b6 11             	movzbl (%ecx),%edx
  800dd4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dd7:	89 f3                	mov    %esi,%ebx
  800dd9:	80 fb 09             	cmp    $0x9,%bl
  800ddc:	77 d5                	ja     800db3 <strtol+0x7c>
			dig = *s - '0';
  800dde:	0f be d2             	movsbl %dl,%edx
  800de1:	83 ea 30             	sub    $0x30,%edx
  800de4:	eb dd                	jmp    800dc3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800de6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800de9:	89 f3                	mov    %esi,%ebx
  800deb:	80 fb 19             	cmp    $0x19,%bl
  800dee:	77 08                	ja     800df8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df0:	0f be d2             	movsbl %dl,%edx
  800df3:	83 ea 37             	sub    $0x37,%edx
  800df6:	eb cb                	jmp    800dc3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800df8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfc:	74 05                	je     800e03 <strtol+0xcc>
		*endptr = (char *) s;
  800dfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e01:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	f7 da                	neg    %edx
  800e07:	85 ff                	test   %edi,%edi
  800e09:	0f 45 c2             	cmovne %edx,%eax
}
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5f                   	pop    %edi
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    

00800e11 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	57                   	push   %edi
  800e15:	56                   	push   %esi
  800e16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	89 c3                	mov    %eax,%ebx
  800e24:	89 c7                	mov    %eax,%edi
  800e26:	89 c6                	mov    %eax,%esi
  800e28:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e64:	89 cb                	mov    %ecx,%ebx
  800e66:	89 cf                	mov    %ecx,%edi
  800e68:	89 ce                	mov    %ecx,%esi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 03                	push   $0x3
  800e7e:	68 84 31 80 00       	push   $0x803184
  800e83:	6a 43                	push   $0x43
  800e85:	68 a1 31 80 00       	push   $0x8031a1
  800e8a:	e8 f7 f3 ff ff       	call   800286 <_panic>

00800e8f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	89 d3                	mov    %edx,%ebx
  800ea3:	89 d7                	mov    %edx,%edi
  800ea5:	89 d6                	mov    %edx,%esi
  800ea7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    

00800eae <sys_yield>:

void
sys_yield(void)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ebe:	89 d1                	mov    %edx,%ecx
  800ec0:	89 d3                	mov    %edx,%ebx
  800ec2:	89 d7                	mov    %edx,%edi
  800ec4:	89 d6                	mov    %edx,%esi
  800ec6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	be 00 00 00 00       	mov    $0x0,%esi
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee9:	89 f7                	mov    %esi,%edi
  800eeb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	7f 08                	jg     800ef9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800efd:	6a 04                	push   $0x4
  800eff:	68 84 31 80 00       	push   $0x803184
  800f04:	6a 43                	push   $0x43
  800f06:	68 a1 31 80 00       	push   $0x8031a1
  800f0b:	e8 76 f3 ff ff       	call   800286 <_panic>

00800f10 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f27:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2a:	8b 75 18             	mov    0x18(%ebp),%esi
  800f2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7f 08                	jg     800f3b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800f3f:	6a 05                	push   $0x5
  800f41:	68 84 31 80 00       	push   $0x803184
  800f46:	6a 43                	push   $0x43
  800f48:	68 a1 31 80 00       	push   $0x8031a1
  800f4d:	e8 34 f3 ff ff       	call   800286 <_panic>

00800f52 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800f66:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6b:	89 df                	mov    %ebx,%edi
  800f6d:	89 de                	mov    %ebx,%esi
  800f6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	7f 08                	jg     800f7d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800f81:	6a 06                	push   $0x6
  800f83:	68 84 31 80 00       	push   $0x803184
  800f88:	6a 43                	push   $0x43
  800f8a:	68 a1 31 80 00       	push   $0x8031a1
  800f8f:	e8 f2 f2 ff ff       	call   800286 <_panic>

00800f94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
  800f9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa8:	b8 08 00 00 00       	mov    $0x8,%eax
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	7f 08                	jg     800fbf <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	50                   	push   %eax
  800fc3:	6a 08                	push   $0x8
  800fc5:	68 84 31 80 00       	push   $0x803184
  800fca:	6a 43                	push   $0x43
  800fcc:	68 a1 31 80 00       	push   $0x8031a1
  800fd1:	e8 b0 f2 ff ff       	call   800286 <_panic>

00800fd6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
  800fdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	b8 09 00 00 00       	mov    $0x9,%eax
  800fef:	89 df                	mov    %ebx,%edi
  800ff1:	89 de                	mov    %ebx,%esi
  800ff3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	7f 08                	jg     801001 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	50                   	push   %eax
  801005:	6a 09                	push   $0x9
  801007:	68 84 31 80 00       	push   $0x803184
  80100c:	6a 43                	push   $0x43
  80100e:	68 a1 31 80 00       	push   $0x8031a1
  801013:	e8 6e f2 ff ff       	call   800286 <_panic>

00801018 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801021:	bb 00 00 00 00       	mov    $0x0,%ebx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801031:	89 df                	mov    %ebx,%edi
  801033:	89 de                	mov    %ebx,%esi
  801035:	cd 30                	int    $0x30
	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7f 08                	jg     801043 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80103b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	50                   	push   %eax
  801047:	6a 0a                	push   $0xa
  801049:	68 84 31 80 00       	push   $0x803184
  80104e:	6a 43                	push   $0x43
  801050:	68 a1 31 80 00       	push   $0x8031a1
  801055:	e8 2c f2 ff ff       	call   800286 <_panic>

0080105a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	b8 0c 00 00 00       	mov    $0xc,%eax
  80106b:	be 00 00 00 00       	mov    $0x0,%esi
  801070:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801073:	8b 7d 14             	mov    0x14(%ebp),%edi
  801076:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
  801083:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801086:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108b:	8b 55 08             	mov    0x8(%ebp),%edx
  80108e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801093:	89 cb                	mov    %ecx,%ebx
  801095:	89 cf                	mov    %ecx,%edi
  801097:	89 ce                	mov    %ecx,%esi
  801099:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109b:	85 c0                	test   %eax,%eax
  80109d:	7f 08                	jg     8010a7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80109f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a2:	5b                   	pop    %ebx
  8010a3:	5e                   	pop    %esi
  8010a4:	5f                   	pop    %edi
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	50                   	push   %eax
  8010ab:	6a 0d                	push   $0xd
  8010ad:	68 84 31 80 00       	push   $0x803184
  8010b2:	6a 43                	push   $0x43
  8010b4:	68 a1 31 80 00       	push   $0x8031a1
  8010b9:	e8 c8 f1 ff ff       	call   800286 <_panic>

008010be <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cf:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010d4:	89 df                	mov    %ebx,%edi
  8010d6:	89 de                	mov    %ebx,%esi
  8010d8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010f2:	89 cb                	mov    %ecx,%ebx
  8010f4:	89 cf                	mov    %ecx,%edi
  8010f6:	89 ce                	mov    %ecx,%esi
  8010f8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
	asm volatile("int %1\n"
  801105:	ba 00 00 00 00       	mov    $0x0,%edx
  80110a:	b8 10 00 00 00       	mov    $0x10,%eax
  80110f:	89 d1                	mov    %edx,%ecx
  801111:	89 d3                	mov    %edx,%ebx
  801113:	89 d7                	mov    %edx,%edi
  801115:	89 d6                	mov    %edx,%esi
  801117:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
	asm volatile("int %1\n"
  801124:	bb 00 00 00 00       	mov    $0x0,%ebx
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112f:	b8 11 00 00 00       	mov    $0x11,%eax
  801134:	89 df                	mov    %ebx,%edi
  801136:	89 de                	mov    %ebx,%esi
  801138:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	57                   	push   %edi
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
	asm volatile("int %1\n"
  801145:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114a:	8b 55 08             	mov    0x8(%ebp),%edx
  80114d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801150:	b8 12 00 00 00       	mov    $0x12,%eax
  801155:	89 df                	mov    %ebx,%edi
  801157:	89 de                	mov    %ebx,%esi
  801159:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5f                   	pop    %edi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801169:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	b8 13 00 00 00       	mov    $0x13,%eax
  801179:	89 df                	mov    %ebx,%edi
  80117b:	89 de                	mov    %ebx,%esi
  80117d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	7f 08                	jg     80118b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	50                   	push   %eax
  80118f:	6a 13                	push   $0x13
  801191:	68 84 31 80 00       	push   $0x803184
  801196:	6a 43                	push   $0x43
  801198:	68 a1 31 80 00       	push   $0x8031a1
  80119d:	e8 e4 f0 ff ff       	call   800286 <_panic>

008011a2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011a9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b0:	f6 c5 04             	test   $0x4,%ch
  8011b3:	75 45                	jne    8011fa <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011b5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011bc:	83 e1 07             	and    $0x7,%ecx
  8011bf:	83 f9 07             	cmp    $0x7,%ecx
  8011c2:	74 6f                	je     801233 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011cb:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011d1:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011d7:	0f 84 b6 00 00 00    	je     801293 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011dd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e4:	83 e1 05             	and    $0x5,%ecx
  8011e7:	83 f9 05             	cmp    $0x5,%ecx
  8011ea:	0f 84 d7 00 00 00    	je     8012c7 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011fa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801201:	c1 e2 0c             	shl    $0xc,%edx
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80120d:	51                   	push   %ecx
  80120e:	52                   	push   %edx
  80120f:	50                   	push   %eax
  801210:	52                   	push   %edx
  801211:	6a 00                	push   $0x0
  801213:	e8 f8 fc ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  801218:	83 c4 20             	add    $0x20,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	79 d1                	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 af 31 80 00       	push   $0x8031af
  801227:	6a 54                	push   $0x54
  801229:	68 c5 31 80 00       	push   $0x8031c5
  80122e:	e8 53 f0 ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801233:	89 d3                	mov    %edx,%ebx
  801235:	c1 e3 0c             	shl    $0xc,%ebx
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	68 05 08 00 00       	push   $0x805
  801240:	53                   	push   %ebx
  801241:	50                   	push   %eax
  801242:	53                   	push   %ebx
  801243:	6a 00                	push   $0x0
  801245:	e8 c6 fc ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  80124a:	83 c4 20             	add    $0x20,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 2e                	js     80127f <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	68 05 08 00 00       	push   $0x805
  801259:	53                   	push   %ebx
  80125a:	6a 00                	push   $0x0
  80125c:	53                   	push   %ebx
  80125d:	6a 00                	push   $0x0
  80125f:	e8 ac fc ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  801264:	83 c4 20             	add    $0x20,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	79 85                	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 af 31 80 00       	push   $0x8031af
  801273:	6a 5f                	push   $0x5f
  801275:	68 c5 31 80 00       	push   $0x8031c5
  80127a:	e8 07 f0 ff ff       	call   800286 <_panic>
			panic("sys_page_map() panic\n");
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	68 af 31 80 00       	push   $0x8031af
  801287:	6a 5b                	push   $0x5b
  801289:	68 c5 31 80 00       	push   $0x8031c5
  80128e:	e8 f3 ef ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801293:	c1 e2 0c             	shl    $0xc,%edx
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	68 05 08 00 00       	push   $0x805
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	52                   	push   %edx
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 68 fc ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  8012a8:	83 c4 20             	add    $0x20,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	0f 89 3d ff ff ff    	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	68 af 31 80 00       	push   $0x8031af
  8012bb:	6a 66                	push   $0x66
  8012bd:	68 c5 31 80 00       	push   $0x8031c5
  8012c2:	e8 bf ef ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c7:	c1 e2 0c             	shl    $0xc,%edx
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	6a 05                	push   $0x5
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	52                   	push   %edx
  8012d2:	6a 00                	push   $0x0
  8012d4:	e8 37 fc ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  8012d9:	83 c4 20             	add    $0x20,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	0f 89 0c ff ff ff    	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 af 31 80 00       	push   $0x8031af
  8012ec:	6a 6d                	push   $0x6d
  8012ee:	68 c5 31 80 00       	push   $0x8031c5
  8012f3:	e8 8e ef ff ff       	call   800286 <_panic>

008012f8 <pgfault>:
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801302:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801304:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801308:	0f 84 99 00 00 00    	je     8013a7 <pgfault+0xaf>
  80130e:	89 c2                	mov    %eax,%edx
  801310:	c1 ea 16             	shr    $0x16,%edx
  801313:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131a:	f6 c2 01             	test   $0x1,%dl
  80131d:	0f 84 84 00 00 00    	je     8013a7 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 0c             	shr    $0xc,%edx
  801328:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132f:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801335:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80133b:	75 6a                	jne    8013a7 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80133d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801342:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	6a 07                	push   $0x7
  801349:	68 00 f0 7f 00       	push   $0x7ff000
  80134e:	6a 00                	push   $0x0
  801350:	e8 78 fb ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 5f                	js     8013bb <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	68 00 10 00 00       	push   $0x1000
  801364:	53                   	push   %ebx
  801365:	68 00 f0 7f 00       	push   $0x7ff000
  80136a:	e8 5c f9 ff ff       	call   800ccb <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80136f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801376:	53                   	push   %ebx
  801377:	6a 00                	push   $0x0
  801379:	68 00 f0 7f 00       	push   $0x7ff000
  80137e:	6a 00                	push   $0x0
  801380:	e8 8b fb ff ff       	call   800f10 <sys_page_map>
	if(ret < 0)
  801385:	83 c4 20             	add    $0x20,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 43                	js     8013cf <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	68 00 f0 7f 00       	push   $0x7ff000
  801394:	6a 00                	push   $0x0
  801396:	e8 b7 fb ff ff       	call   800f52 <sys_page_unmap>
	if(ret < 0)
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 41                	js     8013e3 <pgfault+0xeb>
}
  8013a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	68 d0 31 80 00       	push   $0x8031d0
  8013af:	6a 26                	push   $0x26
  8013b1:	68 c5 31 80 00       	push   $0x8031c5
  8013b6:	e8 cb ee ff ff       	call   800286 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 e4 31 80 00       	push   $0x8031e4
  8013c3:	6a 31                	push   $0x31
  8013c5:	68 c5 31 80 00       	push   $0x8031c5
  8013ca:	e8 b7 ee ff ff       	call   800286 <_panic>
		panic("panic in sys_page_map()\n");
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	68 ff 31 80 00       	push   $0x8031ff
  8013d7:	6a 36                	push   $0x36
  8013d9:	68 c5 31 80 00       	push   $0x8031c5
  8013de:	e8 a3 ee ff ff       	call   800286 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	68 18 32 80 00       	push   $0x803218
  8013eb:	6a 39                	push   $0x39
  8013ed:	68 c5 31 80 00       	push   $0x8031c5
  8013f2:	e8 8f ee ff ff       	call   800286 <_panic>

008013f7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	57                   	push   %edi
  8013fb:	56                   	push   %esi
  8013fc:	53                   	push   %ebx
  8013fd:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801400:	68 f8 12 80 00       	push   $0x8012f8
  801405:	e8 24 14 00 00       	call   80282e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80140a:	b8 07 00 00 00       	mov    $0x7,%eax
  80140f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 27                	js     80143f <fork+0x48>
  801418:	89 c6                	mov    %eax,%esi
  80141a:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801421:	75 48                	jne    80146b <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801423:	e8 67 fa ff ff       	call   800e8f <sys_getenvid>
  801428:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142d:	c1 e0 07             	shl    $0x7,%eax
  801430:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801435:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  80143a:	e9 90 00 00 00       	jmp    8014cf <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 34 32 80 00       	push   $0x803234
  801447:	68 8c 00 00 00       	push   $0x8c
  80144c:	68 c5 31 80 00       	push   $0x8031c5
  801451:	e8 30 ee ff ff       	call   800286 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801456:	89 f8                	mov    %edi,%eax
  801458:	e8 45 fd ff ff       	call   8011a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80145d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801463:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801469:	74 26                	je     801491 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80146b:	89 d8                	mov    %ebx,%eax
  80146d:	c1 e8 16             	shr    $0x16,%eax
  801470:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801477:	a8 01                	test   $0x1,%al
  801479:	74 e2                	je     80145d <fork+0x66>
  80147b:	89 da                	mov    %ebx,%edx
  80147d:	c1 ea 0c             	shr    $0xc,%edx
  801480:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801487:	83 e0 05             	and    $0x5,%eax
  80148a:	83 f8 05             	cmp    $0x5,%eax
  80148d:	75 ce                	jne    80145d <fork+0x66>
  80148f:	eb c5                	jmp    801456 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	6a 07                	push   $0x7
  801496:	68 00 f0 bf ee       	push   $0xeebff000
  80149b:	56                   	push   %esi
  80149c:	e8 2c fa ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 31                	js     8014d9 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	68 9d 28 80 00       	push   $0x80289d
  8014b0:	56                   	push   %esi
  8014b1:	e8 62 fb ff ff       	call   801018 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 33                	js     8014f0 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	6a 02                	push   $0x2
  8014c2:	56                   	push   %esi
  8014c3:	e8 cc fa ff ff       	call   800f94 <sys_env_set_status>
	if(ret < 0)
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 38                	js     801507 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014cf:	89 f0                	mov    %esi,%eax
  8014d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5f                   	pop    %edi
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	68 e4 31 80 00       	push   $0x8031e4
  8014e1:	68 98 00 00 00       	push   $0x98
  8014e6:	68 c5 31 80 00       	push   $0x8031c5
  8014eb:	e8 96 ed ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	68 58 32 80 00       	push   $0x803258
  8014f8:	68 9b 00 00 00       	push   $0x9b
  8014fd:	68 c5 31 80 00       	push   $0x8031c5
  801502:	e8 7f ed ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_status()\n");
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	68 80 32 80 00       	push   $0x803280
  80150f:	68 9e 00 00 00       	push   $0x9e
  801514:	68 c5 31 80 00       	push   $0x8031c5
  801519:	e8 68 ed ff ff       	call   800286 <_panic>

0080151e <sfork>:

// Challenge!
int
sfork(void)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	57                   	push   %edi
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801527:	68 f8 12 80 00       	push   $0x8012f8
  80152c:	e8 fd 12 00 00       	call   80282e <set_pgfault_handler>
  801531:	b8 07 00 00 00       	mov    $0x7,%eax
  801536:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 27                	js     801566 <sfork+0x48>
  80153f:	89 c7                	mov    %eax,%edi
  801541:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801543:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801548:	75 55                	jne    80159f <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80154a:	e8 40 f9 ff ff       	call   800e8f <sys_getenvid>
  80154f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801554:	c1 e0 07             	shl    $0x7,%eax
  801557:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80155c:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  801561:	e9 d4 00 00 00       	jmp    80163a <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	68 34 32 80 00       	push   $0x803234
  80156e:	68 af 00 00 00       	push   $0xaf
  801573:	68 c5 31 80 00       	push   $0x8031c5
  801578:	e8 09 ed ff ff       	call   800286 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80157d:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801582:	89 f0                	mov    %esi,%eax
  801584:	e8 19 fc ff ff       	call   8011a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801589:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80158f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801595:	77 65                	ja     8015fc <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801597:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80159d:	74 de                	je     80157d <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	c1 e8 16             	shr    $0x16,%eax
  8015a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ab:	a8 01                	test   $0x1,%al
  8015ad:	74 da                	je     801589 <sfork+0x6b>
  8015af:	89 da                	mov    %ebx,%edx
  8015b1:	c1 ea 0c             	shr    $0xc,%edx
  8015b4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015bb:	83 e0 05             	and    $0x5,%eax
  8015be:	83 f8 05             	cmp    $0x5,%eax
  8015c1:	75 c6                	jne    801589 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015c3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015ca:	c1 e2 0c             	shl    $0xc,%edx
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	83 e0 07             	and    $0x7,%eax
  8015d3:	50                   	push   %eax
  8015d4:	52                   	push   %edx
  8015d5:	56                   	push   %esi
  8015d6:	52                   	push   %edx
  8015d7:	6a 00                	push   $0x0
  8015d9:	e8 32 f9 ff ff       	call   800f10 <sys_page_map>
  8015de:	83 c4 20             	add    $0x20,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	74 a4                	je     801589 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	68 af 31 80 00       	push   $0x8031af
  8015ed:	68 ba 00 00 00       	push   $0xba
  8015f2:	68 c5 31 80 00       	push   $0x8031c5
  8015f7:	e8 8a ec ff ff       	call   800286 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	6a 07                	push   $0x7
  801601:	68 00 f0 bf ee       	push   $0xeebff000
  801606:	57                   	push   %edi
  801607:	e8 c1 f8 ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 31                	js     801644 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	68 9d 28 80 00       	push   $0x80289d
  80161b:	57                   	push   %edi
  80161c:	e8 f7 f9 ff ff       	call   801018 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 33                	js     80165b <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	6a 02                	push   $0x2
  80162d:	57                   	push   %edi
  80162e:	e8 61 f9 ff ff       	call   800f94 <sys_env_set_status>
	if(ret < 0)
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	78 38                	js     801672 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80163a:	89 f8                	mov    %edi,%eax
  80163c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5f                   	pop    %edi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	68 e4 31 80 00       	push   $0x8031e4
  80164c:	68 c0 00 00 00       	push   $0xc0
  801651:	68 c5 31 80 00       	push   $0x8031c5
  801656:	e8 2b ec ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	68 58 32 80 00       	push   $0x803258
  801663:	68 c3 00 00 00       	push   $0xc3
  801668:	68 c5 31 80 00       	push   $0x8031c5
  80166d:	e8 14 ec ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_status()\n");
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	68 80 32 80 00       	push   $0x803280
  80167a:	68 c6 00 00 00       	push   $0xc6
  80167f:	68 c5 31 80 00       	push   $0x8031c5
  801684:	e8 fd eb ff ff       	call   800286 <_panic>

00801689 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	05 00 00 00 30       	add    $0x30000000,%eax
  801694:	c1 e8 0c             	shr    $0xc,%eax
}
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	c1 ea 16             	shr    $0x16,%edx
  8016bd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016c4:	f6 c2 01             	test   $0x1,%dl
  8016c7:	74 2d                	je     8016f6 <fd_alloc+0x46>
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	c1 ea 0c             	shr    $0xc,%edx
  8016ce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d5:	f6 c2 01             	test   $0x1,%dl
  8016d8:	74 1c                	je     8016f6 <fd_alloc+0x46>
  8016da:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016df:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016e4:	75 d2                	jne    8016b8 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016f4:	eb 0a                	jmp    801700 <fd_alloc+0x50>
			*fd_store = fd;
  8016f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    

00801702 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801708:	83 f8 1f             	cmp    $0x1f,%eax
  80170b:	77 30                	ja     80173d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80170d:	c1 e0 0c             	shl    $0xc,%eax
  801710:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801715:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80171b:	f6 c2 01             	test   $0x1,%dl
  80171e:	74 24                	je     801744 <fd_lookup+0x42>
  801720:	89 c2                	mov    %eax,%edx
  801722:	c1 ea 0c             	shr    $0xc,%edx
  801725:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80172c:	f6 c2 01             	test   $0x1,%dl
  80172f:	74 1a                	je     80174b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	89 02                	mov    %eax,(%edx)
	return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
		return -E_INVAL;
  80173d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801742:	eb f7                	jmp    80173b <fd_lookup+0x39>
		return -E_INVAL;
  801744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801749:	eb f0                	jmp    80173b <fd_lookup+0x39>
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801750:	eb e9                	jmp    80173b <fd_lookup+0x39>

00801752 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80175b:	ba 00 00 00 00       	mov    $0x0,%edx
  801760:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801765:	39 08                	cmp    %ecx,(%eax)
  801767:	74 38                	je     8017a1 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801769:	83 c2 01             	add    $0x1,%edx
  80176c:	8b 04 95 1c 33 80 00 	mov    0x80331c(,%edx,4),%eax
  801773:	85 c0                	test   %eax,%eax
  801775:	75 ee                	jne    801765 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801777:	a1 20 54 80 00       	mov    0x805420,%eax
  80177c:	8b 40 48             	mov    0x48(%eax),%eax
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	51                   	push   %ecx
  801783:	50                   	push   %eax
  801784:	68 a0 32 80 00       	push   $0x8032a0
  801789:	e8 ee eb ff ff       	call   80037c <cprintf>
	*dev = 0;
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    
			*dev = devtab[i];
  8017a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	eb f2                	jmp    80179f <dev_lookup+0x4d>

008017ad <fd_close>:
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	57                   	push   %edi
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
  8017b3:	83 ec 24             	sub    $0x24,%esp
  8017b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8017b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017bf:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017c9:	50                   	push   %eax
  8017ca:	e8 33 ff ff ff       	call   801702 <fd_lookup>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 05                	js     8017dd <fd_close+0x30>
	    || fd != fd2)
  8017d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017db:	74 16                	je     8017f3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017dd:	89 f8                	mov    %edi,%eax
  8017df:	84 c0                	test   %al,%al
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	0f 44 d8             	cmove  %eax,%ebx
}
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017f9:	50                   	push   %eax
  8017fa:	ff 36                	pushl  (%esi)
  8017fc:	e8 51 ff ff ff       	call   801752 <dev_lookup>
  801801:	89 c3                	mov    %eax,%ebx
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	78 1a                	js     801824 <fd_close+0x77>
		if (dev->dev_close)
  80180a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80180d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801815:	85 c0                	test   %eax,%eax
  801817:	74 0b                	je     801824 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	56                   	push   %esi
  80181d:	ff d0                	call   *%eax
  80181f:	89 c3                	mov    %eax,%ebx
  801821:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	56                   	push   %esi
  801828:	6a 00                	push   $0x0
  80182a:	e8 23 f7 ff ff       	call   800f52 <sys_page_unmap>
	return r;
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	eb b5                	jmp    8017e9 <fd_close+0x3c>

00801834 <close>:

int
close(int fdnum)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183d:	50                   	push   %eax
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	e8 bc fe ff ff       	call   801702 <fd_lookup>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	79 02                	jns    80184f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    
		return fd_close(fd, 1);
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	6a 01                	push   $0x1
  801854:	ff 75 f4             	pushl  -0xc(%ebp)
  801857:	e8 51 ff ff ff       	call   8017ad <fd_close>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	eb ec                	jmp    80184d <close+0x19>

00801861 <close_all>:

void
close_all(void)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	53                   	push   %ebx
  801865:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801868:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80186d:	83 ec 0c             	sub    $0xc,%esp
  801870:	53                   	push   %ebx
  801871:	e8 be ff ff ff       	call   801834 <close>
	for (i = 0; i < MAXFD; i++)
  801876:	83 c3 01             	add    $0x1,%ebx
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	83 fb 20             	cmp    $0x20,%ebx
  80187f:	75 ec                	jne    80186d <close_all+0xc>
}
  801881:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80188f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	e8 67 fe ff ff       	call   801702 <fd_lookup>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	0f 88 81 00 00 00    	js     801929 <dup+0xa3>
		return r;
	close(newfdnum);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	e8 81 ff ff ff       	call   801834 <close>

	newfd = INDEX2FD(newfdnum);
  8018b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018b6:	c1 e6 0c             	shl    $0xc,%esi
  8018b9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018bf:	83 c4 04             	add    $0x4,%esp
  8018c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018c5:	e8 cf fd ff ff       	call   801699 <fd2data>
  8018ca:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018cc:	89 34 24             	mov    %esi,(%esp)
  8018cf:	e8 c5 fd ff ff       	call   801699 <fd2data>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018d9:	89 d8                	mov    %ebx,%eax
  8018db:	c1 e8 16             	shr    $0x16,%eax
  8018de:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018e5:	a8 01                	test   $0x1,%al
  8018e7:	74 11                	je     8018fa <dup+0x74>
  8018e9:	89 d8                	mov    %ebx,%eax
  8018eb:	c1 e8 0c             	shr    $0xc,%eax
  8018ee:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018f5:	f6 c2 01             	test   $0x1,%dl
  8018f8:	75 39                	jne    801933 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018fd:	89 d0                	mov    %edx,%eax
  8018ff:	c1 e8 0c             	shr    $0xc,%eax
  801902:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801909:	83 ec 0c             	sub    $0xc,%esp
  80190c:	25 07 0e 00 00       	and    $0xe07,%eax
  801911:	50                   	push   %eax
  801912:	56                   	push   %esi
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	6a 00                	push   $0x0
  801918:	e8 f3 f5 ff ff       	call   800f10 <sys_page_map>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 20             	add    $0x20,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 31                	js     801957 <dup+0xd1>
		goto err;

	return newfdnum;
  801926:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5f                   	pop    %edi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801933:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80193a:	83 ec 0c             	sub    $0xc,%esp
  80193d:	25 07 0e 00 00       	and    $0xe07,%eax
  801942:	50                   	push   %eax
  801943:	57                   	push   %edi
  801944:	6a 00                	push   $0x0
  801946:	53                   	push   %ebx
  801947:	6a 00                	push   $0x0
  801949:	e8 c2 f5 ff ff       	call   800f10 <sys_page_map>
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	83 c4 20             	add    $0x20,%esp
  801953:	85 c0                	test   %eax,%eax
  801955:	79 a3                	jns    8018fa <dup+0x74>
	sys_page_unmap(0, newfd);
  801957:	83 ec 08             	sub    $0x8,%esp
  80195a:	56                   	push   %esi
  80195b:	6a 00                	push   $0x0
  80195d:	e8 f0 f5 ff ff       	call   800f52 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801962:	83 c4 08             	add    $0x8,%esp
  801965:	57                   	push   %edi
  801966:	6a 00                	push   $0x0
  801968:	e8 e5 f5 ff ff       	call   800f52 <sys_page_unmap>
	return r;
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb b7                	jmp    801929 <dup+0xa3>

00801972 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	53                   	push   %ebx
  801976:	83 ec 1c             	sub    $0x1c,%esp
  801979:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197f:	50                   	push   %eax
  801980:	53                   	push   %ebx
  801981:	e8 7c fd ff ff       	call   801702 <fd_lookup>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 3f                	js     8019cc <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801997:	ff 30                	pushl  (%eax)
  801999:	e8 b4 fd ff ff       	call   801752 <dev_lookup>
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 27                	js     8019cc <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019a8:	8b 42 08             	mov    0x8(%edx),%eax
  8019ab:	83 e0 03             	and    $0x3,%eax
  8019ae:	83 f8 01             	cmp    $0x1,%eax
  8019b1:	74 1e                	je     8019d1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b6:	8b 40 08             	mov    0x8(%eax),%eax
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	74 35                	je     8019f2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	ff 75 10             	pushl  0x10(%ebp)
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	52                   	push   %edx
  8019c7:	ff d0                	call   *%eax
  8019c9:	83 c4 10             	add    $0x10,%esp
}
  8019cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019d1:	a1 20 54 80 00       	mov    0x805420,%eax
  8019d6:	8b 40 48             	mov    0x48(%eax),%eax
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	53                   	push   %ebx
  8019dd:	50                   	push   %eax
  8019de:	68 e1 32 80 00       	push   $0x8032e1
  8019e3:	e8 94 e9 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f0:	eb da                	jmp    8019cc <read+0x5a>
		return -E_NOT_SUPP;
  8019f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f7:	eb d3                	jmp    8019cc <read+0x5a>

008019f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	57                   	push   %edi
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a05:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a08:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a0d:	39 f3                	cmp    %esi,%ebx
  801a0f:	73 23                	jae    801a34 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	89 f0                	mov    %esi,%eax
  801a16:	29 d8                	sub    %ebx,%eax
  801a18:	50                   	push   %eax
  801a19:	89 d8                	mov    %ebx,%eax
  801a1b:	03 45 0c             	add    0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	57                   	push   %edi
  801a20:	e8 4d ff ff ff       	call   801972 <read>
		if (m < 0)
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 06                	js     801a32 <readn+0x39>
			return m;
		if (m == 0)
  801a2c:	74 06                	je     801a34 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a2e:	01 c3                	add    %eax,%ebx
  801a30:	eb db                	jmp    801a0d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a32:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5f                   	pop    %edi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	53                   	push   %ebx
  801a42:	83 ec 1c             	sub    $0x1c,%esp
  801a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4b:	50                   	push   %eax
  801a4c:	53                   	push   %ebx
  801a4d:	e8 b0 fc ff ff       	call   801702 <fd_lookup>
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 3a                	js     801a93 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5f:	50                   	push   %eax
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a63:	ff 30                	pushl  (%eax)
  801a65:	e8 e8 fc ff ff       	call   801752 <dev_lookup>
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 22                	js     801a93 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a74:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a78:	74 1e                	je     801a98 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a80:	85 d2                	test   %edx,%edx
  801a82:	74 35                	je     801ab9 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	ff 75 10             	pushl  0x10(%ebp)
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	50                   	push   %eax
  801a8e:	ff d2                	call   *%edx
  801a90:	83 c4 10             	add    $0x10,%esp
}
  801a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a98:	a1 20 54 80 00       	mov    0x805420,%eax
  801a9d:	8b 40 48             	mov    0x48(%eax),%eax
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	53                   	push   %ebx
  801aa4:	50                   	push   %eax
  801aa5:	68 fd 32 80 00       	push   $0x8032fd
  801aaa:	e8 cd e8 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab7:	eb da                	jmp    801a93 <write+0x55>
		return -E_NOT_SUPP;
  801ab9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abe:	eb d3                	jmp    801a93 <write+0x55>

00801ac0 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac9:	50                   	push   %eax
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 30 fc ff ff       	call   801702 <fd_lookup>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 0e                	js     801ae7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	53                   	push   %ebx
  801aed:	83 ec 1c             	sub    $0x1c,%esp
  801af0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af6:	50                   	push   %eax
  801af7:	53                   	push   %ebx
  801af8:	e8 05 fc ff ff       	call   801702 <fd_lookup>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 37                	js     801b3b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0e:	ff 30                	pushl  (%eax)
  801b10:	e8 3d fc ff ff       	call   801752 <dev_lookup>
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 1f                	js     801b3b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b23:	74 1b                	je     801b40 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b28:	8b 52 18             	mov    0x18(%edx),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	74 32                	je     801b61 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	ff d2                	call   *%edx
  801b38:	83 c4 10             	add    $0x10,%esp
}
  801b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b40:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b45:	8b 40 48             	mov    0x48(%eax),%eax
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	53                   	push   %ebx
  801b4c:	50                   	push   %eax
  801b4d:	68 c0 32 80 00       	push   $0x8032c0
  801b52:	e8 25 e8 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b5f:	eb da                	jmp    801b3b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b61:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b66:	eb d3                	jmp    801b3b <ftruncate+0x52>

00801b68 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 1c             	sub    $0x1c,%esp
  801b6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b75:	50                   	push   %eax
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 84 fb ff ff       	call   801702 <fd_lookup>
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 4b                	js     801bd0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b85:	83 ec 08             	sub    $0x8,%esp
  801b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8b:	50                   	push   %eax
  801b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8f:	ff 30                	pushl  (%eax)
  801b91:	e8 bc fb ff ff       	call   801752 <dev_lookup>
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 33                	js     801bd0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ba4:	74 2f                	je     801bd5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ba6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ba9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bb0:	00 00 00 
	stat->st_isdir = 0;
  801bb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bba:	00 00 00 
	stat->st_dev = dev;
  801bbd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bc3:	83 ec 08             	sub    $0x8,%esp
  801bc6:	53                   	push   %ebx
  801bc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801bca:	ff 50 14             	call   *0x14(%eax)
  801bcd:	83 c4 10             	add    $0x10,%esp
}
  801bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    
		return -E_NOT_SUPP;
  801bd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bda:	eb f4                	jmp    801bd0 <fstat+0x68>

00801bdc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	56                   	push   %esi
  801be0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	6a 00                	push   $0x0
  801be6:	ff 75 08             	pushl  0x8(%ebp)
  801be9:	e8 22 02 00 00       	call   801e10 <open>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 1b                	js     801c12 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	50                   	push   %eax
  801bfe:	e8 65 ff ff ff       	call   801b68 <fstat>
  801c03:	89 c6                	mov    %eax,%esi
	close(fd);
  801c05:	89 1c 24             	mov    %ebx,(%esp)
  801c08:	e8 27 fc ff ff       	call   801834 <close>
	return r;
  801c0d:	83 c4 10             	add    $0x10,%esp
  801c10:	89 f3                	mov    %esi,%ebx
}
  801c12:	89 d8                	mov    %ebx,%eax
  801c14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    

00801c1b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	89 c6                	mov    %eax,%esi
  801c22:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c24:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c2b:	74 27                	je     801c54 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c2d:	6a 07                	push   $0x7
  801c2f:	68 00 60 80 00       	push   $0x806000
  801c34:	56                   	push   %esi
  801c35:	ff 35 00 50 80 00    	pushl  0x805000
  801c3b:	e8 ec 0c 00 00       	call   80292c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c40:	83 c4 0c             	add    $0xc,%esp
  801c43:	6a 00                	push   $0x0
  801c45:	53                   	push   %ebx
  801c46:	6a 00                	push   $0x0
  801c48:	e8 76 0c 00 00       	call   8028c3 <ipc_recv>
}
  801c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c54:	83 ec 0c             	sub    $0xc,%esp
  801c57:	6a 01                	push   $0x1
  801c59:	e8 26 0d 00 00       	call   802984 <ipc_find_env>
  801c5e:	a3 00 50 80 00       	mov    %eax,0x805000
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	eb c5                	jmp    801c2d <fsipc+0x12>

00801c68 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8b 40 0c             	mov    0xc(%eax),%eax
  801c74:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c81:	ba 00 00 00 00       	mov    $0x0,%edx
  801c86:	b8 02 00 00 00       	mov    $0x2,%eax
  801c8b:	e8 8b ff ff ff       	call   801c1b <fsipc>
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <devfile_flush>:
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	b8 06 00 00 00       	mov    $0x6,%eax
  801cad:	e8 69 ff ff ff       	call   801c1b <fsipc>
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <devfile_stat>:
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd3:	e8 43 ff ff ff       	call   801c1b <fsipc>
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	78 2c                	js     801d08 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	68 00 60 80 00       	push   $0x806000
  801ce4:	53                   	push   %ebx
  801ce5:	e8 f1 ed ff ff       	call   800adb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cea:	a1 80 60 80 00       	mov    0x806080,%eax
  801cef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cf5:	a1 84 60 80 00       	mov    0x806084,%eax
  801cfa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <devfile_write>:
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	53                   	push   %ebx
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d22:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d28:	53                   	push   %ebx
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	68 08 60 80 00       	push   $0x806008
  801d31:	e8 95 ef ff ff       	call   800ccb <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d36:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3b:	b8 04 00 00 00       	mov    $0x4,%eax
  801d40:	e8 d6 fe ff ff       	call   801c1b <fsipc>
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 0b                	js     801d57 <devfile_write+0x4a>
	assert(r <= n);
  801d4c:	39 d8                	cmp    %ebx,%eax
  801d4e:	77 0c                	ja     801d5c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d50:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d55:	7f 1e                	jg     801d75 <devfile_write+0x68>
}
  801d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    
	assert(r <= n);
  801d5c:	68 30 33 80 00       	push   $0x803330
  801d61:	68 37 33 80 00       	push   $0x803337
  801d66:	68 98 00 00 00       	push   $0x98
  801d6b:	68 4c 33 80 00       	push   $0x80334c
  801d70:	e8 11 e5 ff ff       	call   800286 <_panic>
	assert(r <= PGSIZE);
  801d75:	68 57 33 80 00       	push   $0x803357
  801d7a:	68 37 33 80 00       	push   $0x803337
  801d7f:	68 99 00 00 00       	push   $0x99
  801d84:	68 4c 33 80 00       	push   $0x80334c
  801d89:	e8 f8 e4 ff ff       	call   800286 <_panic>

00801d8e <devfile_read>:
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	56                   	push   %esi
  801d92:	53                   	push   %ebx
  801d93:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801da1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801da7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dac:	b8 03 00 00 00       	mov    $0x3,%eax
  801db1:	e8 65 fe ff ff       	call   801c1b <fsipc>
  801db6:	89 c3                	mov    %eax,%ebx
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 1f                	js     801ddb <devfile_read+0x4d>
	assert(r <= n);
  801dbc:	39 f0                	cmp    %esi,%eax
  801dbe:	77 24                	ja     801de4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dc0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc5:	7f 33                	jg     801dfa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	50                   	push   %eax
  801dcb:	68 00 60 80 00       	push   $0x806000
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	e8 91 ee ff ff       	call   800c69 <memmove>
	return r;
  801dd8:	83 c4 10             	add    $0x10,%esp
}
  801ddb:	89 d8                	mov    %ebx,%eax
  801ddd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    
	assert(r <= n);
  801de4:	68 30 33 80 00       	push   $0x803330
  801de9:	68 37 33 80 00       	push   $0x803337
  801dee:	6a 7c                	push   $0x7c
  801df0:	68 4c 33 80 00       	push   $0x80334c
  801df5:	e8 8c e4 ff ff       	call   800286 <_panic>
	assert(r <= PGSIZE);
  801dfa:	68 57 33 80 00       	push   $0x803357
  801dff:	68 37 33 80 00       	push   $0x803337
  801e04:	6a 7d                	push   $0x7d
  801e06:	68 4c 33 80 00       	push   $0x80334c
  801e0b:	e8 76 e4 ff ff       	call   800286 <_panic>

00801e10 <open>:
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	83 ec 1c             	sub    $0x1c,%esp
  801e18:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e1b:	56                   	push   %esi
  801e1c:	e8 81 ec ff ff       	call   800aa2 <strlen>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e29:	7f 6c                	jg     801e97 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e31:	50                   	push   %eax
  801e32:	e8 79 f8 ff ff       	call   8016b0 <fd_alloc>
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 3c                	js     801e7c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	56                   	push   %esi
  801e44:	68 00 60 80 00       	push   $0x806000
  801e49:	e8 8d ec ff ff       	call   800adb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e51:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5e:	e8 b8 fd ff ff       	call   801c1b <fsipc>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 19                	js     801e85 <open+0x75>
	return fd2num(fd);
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e72:	e8 12 f8 ff ff       	call   801689 <fd2num>
  801e77:	89 c3                	mov    %eax,%ebx
  801e79:	83 c4 10             	add    $0x10,%esp
}
  801e7c:	89 d8                	mov    %ebx,%eax
  801e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e81:	5b                   	pop    %ebx
  801e82:	5e                   	pop    %esi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
		fd_close(fd, 0);
  801e85:	83 ec 08             	sub    $0x8,%esp
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8d:	e8 1b f9 ff ff       	call   8017ad <fd_close>
		return r;
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	eb e5                	jmp    801e7c <open+0x6c>
		return -E_BAD_PATH;
  801e97:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e9c:	eb de                	jmp    801e7c <open+0x6c>

00801e9e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea9:	b8 08 00 00 00       	mov    $0x8,%eax
  801eae:	e8 68 fd ff ff       	call   801c1b <fsipc>
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ebb:	68 63 33 80 00       	push   $0x803363
  801ec0:	ff 75 0c             	pushl  0xc(%ebp)
  801ec3:	e8 13 ec ff ff       	call   800adb <strcpy>
	return 0;
}
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <devsock_close>:
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 10             	sub    $0x10,%esp
  801ed6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ed9:	53                   	push   %ebx
  801eda:	e8 e0 0a 00 00       	call   8029bf <pageref>
  801edf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ee7:	83 f8 01             	cmp    $0x1,%eax
  801eea:	74 07                	je     801ef3 <devsock_close+0x24>
}
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	ff 73 0c             	pushl  0xc(%ebx)
  801ef9:	e8 b9 02 00 00       	call   8021b7 <nsipc_close>
  801efe:	89 c2                	mov    %eax,%edx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	eb e7                	jmp    801eec <devsock_close+0x1d>

00801f05 <devsock_write>:
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 10             	pushl  0x10(%ebp)
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	ff 70 0c             	pushl  0xc(%eax)
  801f19:	e8 76 03 00 00       	call   802294 <nsipc_send>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <devsock_read>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	ff 75 10             	pushl  0x10(%ebp)
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	ff 70 0c             	pushl  0xc(%eax)
  801f34:	e8 ef 02 00 00       	call   802228 <nsipc_recv>
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <fd2sockid>:
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f41:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f44:	52                   	push   %edx
  801f45:	50                   	push   %eax
  801f46:	e8 b7 f7 ff ff       	call   801702 <fd_lookup>
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 10                	js     801f62 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f5b:	39 08                	cmp    %ecx,(%eax)
  801f5d:	75 05                	jne    801f64 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    
		return -E_NOT_SUPP;
  801f64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f69:	eb f7                	jmp    801f62 <fd2sockid+0x27>

00801f6b <alloc_sockfd>:
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	83 ec 1c             	sub    $0x1c,%esp
  801f73:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	50                   	push   %eax
  801f79:	e8 32 f7 ff ff       	call   8016b0 <fd_alloc>
  801f7e:	89 c3                	mov    %eax,%ebx
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 43                	js     801fca <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 07 04 00 00       	push   $0x407
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	6a 00                	push   $0x0
  801f94:	e8 34 ef ff ff       	call   800ecd <sys_page_alloc>
  801f99:	89 c3                	mov    %eax,%ebx
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 28                	js     801fca <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fab:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fb7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	50                   	push   %eax
  801fbe:	e8 c6 f6 ff ff       	call   801689 <fd2num>
  801fc3:	89 c3                	mov    %eax,%ebx
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	eb 0c                	jmp    801fd6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	56                   	push   %esi
  801fce:	e8 e4 01 00 00       	call   8021b7 <nsipc_close>
		return r;
  801fd3:	83 c4 10             	add    $0x10,%esp
}
  801fd6:	89 d8                	mov    %ebx,%eax
  801fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <accept>:
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	e8 4e ff ff ff       	call   801f3b <fd2sockid>
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 1b                	js     80200c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	ff 75 10             	pushl  0x10(%ebp)
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	50                   	push   %eax
  801ffb:	e8 0e 01 00 00       	call   80210e <nsipc_accept>
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	78 05                	js     80200c <accept+0x2d>
	return alloc_sockfd(r);
  802007:	e8 5f ff ff ff       	call   801f6b <alloc_sockfd>
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <bind>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	e8 1f ff ff ff       	call   801f3b <fd2sockid>
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 12                	js     802032 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	ff 75 10             	pushl  0x10(%ebp)
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	50                   	push   %eax
  80202a:	e8 31 01 00 00       	call   802160 <nsipc_bind>
  80202f:	83 c4 10             	add    $0x10,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <shutdown>:
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	e8 f9 fe ff ff       	call   801f3b <fd2sockid>
  802042:	85 c0                	test   %eax,%eax
  802044:	78 0f                	js     802055 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802046:	83 ec 08             	sub    $0x8,%esp
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	50                   	push   %eax
  80204d:	e8 43 01 00 00       	call   802195 <nsipc_shutdown>
  802052:	83 c4 10             	add    $0x10,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <connect>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	e8 d6 fe ff ff       	call   801f3b <fd2sockid>
  802065:	85 c0                	test   %eax,%eax
  802067:	78 12                	js     80207b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	ff 75 10             	pushl  0x10(%ebp)
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	50                   	push   %eax
  802073:	e8 59 01 00 00       	call   8021d1 <nsipc_connect>
  802078:	83 c4 10             	add    $0x10,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <listen>:
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	e8 b0 fe ff ff       	call   801f3b <fd2sockid>
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 0f                	js     80209e <listen+0x21>
	return nsipc_listen(r, backlog);
  80208f:	83 ec 08             	sub    $0x8,%esp
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	50                   	push   %eax
  802096:	e8 6b 01 00 00       	call   802206 <nsipc_listen>
  80209b:	83 c4 10             	add    $0x10,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020a6:	ff 75 10             	pushl  0x10(%ebp)
  8020a9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ac:	ff 75 08             	pushl  0x8(%ebp)
  8020af:	e8 3e 02 00 00       	call   8022f2 <nsipc_socket>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 05                	js     8020c0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020bb:	e8 ab fe ff ff       	call   801f6b <alloc_sockfd>
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	53                   	push   %ebx
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020cb:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020d2:	74 26                	je     8020fa <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020d4:	6a 07                	push   $0x7
  8020d6:	68 00 70 80 00       	push   $0x807000
  8020db:	53                   	push   %ebx
  8020dc:	ff 35 04 50 80 00    	pushl  0x805004
  8020e2:	e8 45 08 00 00       	call   80292c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020e7:	83 c4 0c             	add    $0xc,%esp
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	e8 ce 07 00 00       	call   8028c3 <ipc_recv>
}
  8020f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  8020fd:	6a 02                	push   $0x2
  8020ff:	e8 80 08 00 00       	call   802984 <ipc_find_env>
  802104:	a3 04 50 80 00       	mov    %eax,0x805004
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	eb c6                	jmp    8020d4 <nsipc+0x12>

0080210e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	56                   	push   %esi
  802112:	53                   	push   %ebx
  802113:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80211e:	8b 06                	mov    (%esi),%eax
  802120:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802125:	b8 01 00 00 00       	mov    $0x1,%eax
  80212a:	e8 93 ff ff ff       	call   8020c2 <nsipc>
  80212f:	89 c3                	mov    %eax,%ebx
  802131:	85 c0                	test   %eax,%eax
  802133:	79 09                	jns    80213e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802135:	89 d8                	mov    %ebx,%eax
  802137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213a:	5b                   	pop    %ebx
  80213b:	5e                   	pop    %esi
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	ff 35 10 70 80 00    	pushl  0x807010
  802147:	68 00 70 80 00       	push   $0x807000
  80214c:	ff 75 0c             	pushl  0xc(%ebp)
  80214f:	e8 15 eb ff ff       	call   800c69 <memmove>
		*addrlen = ret->ret_addrlen;
  802154:	a1 10 70 80 00       	mov    0x807010,%eax
  802159:	89 06                	mov    %eax,(%esi)
  80215b:	83 c4 10             	add    $0x10,%esp
	return r;
  80215e:	eb d5                	jmp    802135 <nsipc_accept+0x27>

00802160 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	53                   	push   %ebx
  802164:	83 ec 08             	sub    $0x8,%esp
  802167:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802172:	53                   	push   %ebx
  802173:	ff 75 0c             	pushl  0xc(%ebp)
  802176:	68 04 70 80 00       	push   $0x807004
  80217b:	e8 e9 ea ff ff       	call   800c69 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802180:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802186:	b8 02 00 00 00       	mov    $0x2,%eax
  80218b:	e8 32 ff ff ff       	call   8020c2 <nsipc>
}
  802190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021ab:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b0:	e8 0d ff ff ff       	call   8020c2 <nsipc>
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <nsipc_close>:

int
nsipc_close(int s)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021c5:	b8 04 00 00 00       	mov    $0x4,%eax
  8021ca:	e8 f3 fe ff ff       	call   8020c2 <nsipc>
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 08             	sub    $0x8,%esp
  8021d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021e3:	53                   	push   %ebx
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	68 04 70 80 00       	push   $0x807004
  8021ec:	e8 78 ea ff ff       	call   800c69 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8021fc:	e8 c1 fe ff ff       	call   8020c2 <nsipc>
}
  802201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802214:	8b 45 0c             	mov    0xc(%ebp),%eax
  802217:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80221c:	b8 06 00 00 00       	mov    $0x6,%eax
  802221:	e8 9c fe ff ff       	call   8020c2 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802238:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80223e:	8b 45 14             	mov    0x14(%ebp),%eax
  802241:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802246:	b8 07 00 00 00       	mov    $0x7,%eax
  80224b:	e8 72 fe ff ff       	call   8020c2 <nsipc>
  802250:	89 c3                	mov    %eax,%ebx
  802252:	85 c0                	test   %eax,%eax
  802254:	78 1f                	js     802275 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802256:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80225b:	7f 21                	jg     80227e <nsipc_recv+0x56>
  80225d:	39 c6                	cmp    %eax,%esi
  80225f:	7c 1d                	jl     80227e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	50                   	push   %eax
  802265:	68 00 70 80 00       	push   $0x807000
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	e8 f7 e9 ff ff       	call   800c69 <memmove>
  802272:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802275:	89 d8                	mov    %ebx,%eax
  802277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227a:	5b                   	pop    %ebx
  80227b:	5e                   	pop    %esi
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80227e:	68 6f 33 80 00       	push   $0x80336f
  802283:	68 37 33 80 00       	push   $0x803337
  802288:	6a 62                	push   $0x62
  80228a:	68 84 33 80 00       	push   $0x803384
  80228f:	e8 f2 df ff ff       	call   800286 <_panic>

00802294 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	53                   	push   %ebx
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022a6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022ac:	7f 2e                	jg     8022dc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022ae:	83 ec 04             	sub    $0x4,%esp
  8022b1:	53                   	push   %ebx
  8022b2:	ff 75 0c             	pushl  0xc(%ebp)
  8022b5:	68 0c 70 80 00       	push   $0x80700c
  8022ba:	e8 aa e9 ff ff       	call   800c69 <memmove>
	nsipcbuf.send.req_size = size;
  8022bf:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d2:	e8 eb fd ff ff       	call   8020c2 <nsipc>
}
  8022d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    
	assert(size < 1600);
  8022dc:	68 90 33 80 00       	push   $0x803390
  8022e1:	68 37 33 80 00       	push   $0x803337
  8022e6:	6a 6d                	push   $0x6d
  8022e8:	68 84 33 80 00       	push   $0x803384
  8022ed:	e8 94 df ff ff       	call   800286 <_panic>

008022f2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802300:	8b 45 0c             	mov    0xc(%ebp),%eax
  802303:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802308:	8b 45 10             	mov    0x10(%ebp),%eax
  80230b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802310:	b8 09 00 00 00       	mov    $0x9,%eax
  802315:	e8 a8 fd ff ff       	call   8020c2 <nsipc>
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	56                   	push   %esi
  802320:	53                   	push   %ebx
  802321:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802324:	83 ec 0c             	sub    $0xc,%esp
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	e8 6a f3 ff ff       	call   801699 <fd2data>
  80232f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802331:	83 c4 08             	add    $0x8,%esp
  802334:	68 9c 33 80 00       	push   $0x80339c
  802339:	53                   	push   %ebx
  80233a:	e8 9c e7 ff ff       	call   800adb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80233f:	8b 46 04             	mov    0x4(%esi),%eax
  802342:	2b 06                	sub    (%esi),%eax
  802344:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80234a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802351:	00 00 00 
	stat->st_dev = &devpipe;
  802354:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80235b:	40 80 00 
	return 0;
}
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
  802363:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802366:	5b                   	pop    %ebx
  802367:	5e                   	pop    %esi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    

0080236a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	53                   	push   %ebx
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802374:	53                   	push   %ebx
  802375:	6a 00                	push   $0x0
  802377:	e8 d6 eb ff ff       	call   800f52 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80237c:	89 1c 24             	mov    %ebx,(%esp)
  80237f:	e8 15 f3 ff ff       	call   801699 <fd2data>
  802384:	83 c4 08             	add    $0x8,%esp
  802387:	50                   	push   %eax
  802388:	6a 00                	push   $0x0
  80238a:	e8 c3 eb ff ff       	call   800f52 <sys_page_unmap>
}
  80238f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <_pipeisclosed>:
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	57                   	push   %edi
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	83 ec 1c             	sub    $0x1c,%esp
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023a1:	a1 20 54 80 00       	mov    0x805420,%eax
  8023a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023a9:	83 ec 0c             	sub    $0xc,%esp
  8023ac:	57                   	push   %edi
  8023ad:	e8 0d 06 00 00       	call   8029bf <pageref>
  8023b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023b5:	89 34 24             	mov    %esi,(%esp)
  8023b8:	e8 02 06 00 00       	call   8029bf <pageref>
		nn = thisenv->env_runs;
  8023bd:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8023c3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023c6:	83 c4 10             	add    $0x10,%esp
  8023c9:	39 cb                	cmp    %ecx,%ebx
  8023cb:	74 1b                	je     8023e8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023cd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d0:	75 cf                	jne    8023a1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023d2:	8b 42 58             	mov    0x58(%edx),%eax
  8023d5:	6a 01                	push   $0x1
  8023d7:	50                   	push   %eax
  8023d8:	53                   	push   %ebx
  8023d9:	68 a3 33 80 00       	push   $0x8033a3
  8023de:	e8 99 df ff ff       	call   80037c <cprintf>
  8023e3:	83 c4 10             	add    $0x10,%esp
  8023e6:	eb b9                	jmp    8023a1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023e8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023eb:	0f 94 c0             	sete   %al
  8023ee:	0f b6 c0             	movzbl %al,%eax
}
  8023f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5f                   	pop    %edi
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    

008023f9 <devpipe_write>:
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	57                   	push   %edi
  8023fd:	56                   	push   %esi
  8023fe:	53                   	push   %ebx
  8023ff:	83 ec 28             	sub    $0x28,%esp
  802402:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802405:	56                   	push   %esi
  802406:	e8 8e f2 ff ff       	call   801699 <fd2data>
  80240b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	bf 00 00 00 00       	mov    $0x0,%edi
  802415:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802418:	74 4f                	je     802469 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80241a:	8b 43 04             	mov    0x4(%ebx),%eax
  80241d:	8b 0b                	mov    (%ebx),%ecx
  80241f:	8d 51 20             	lea    0x20(%ecx),%edx
  802422:	39 d0                	cmp    %edx,%eax
  802424:	72 14                	jb     80243a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802426:	89 da                	mov    %ebx,%edx
  802428:	89 f0                	mov    %esi,%eax
  80242a:	e8 65 ff ff ff       	call   802394 <_pipeisclosed>
  80242f:	85 c0                	test   %eax,%eax
  802431:	75 3b                	jne    80246e <devpipe_write+0x75>
			sys_yield();
  802433:	e8 76 ea ff ff       	call   800eae <sys_yield>
  802438:	eb e0                	jmp    80241a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80243a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802441:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802444:	89 c2                	mov    %eax,%edx
  802446:	c1 fa 1f             	sar    $0x1f,%edx
  802449:	89 d1                	mov    %edx,%ecx
  80244b:	c1 e9 1b             	shr    $0x1b,%ecx
  80244e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802451:	83 e2 1f             	and    $0x1f,%edx
  802454:	29 ca                	sub    %ecx,%edx
  802456:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80245a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80245e:	83 c0 01             	add    $0x1,%eax
  802461:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802464:	83 c7 01             	add    $0x1,%edi
  802467:	eb ac                	jmp    802415 <devpipe_write+0x1c>
	return i;
  802469:	8b 45 10             	mov    0x10(%ebp),%eax
  80246c:	eb 05                	jmp    802473 <devpipe_write+0x7a>
				return 0;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802473:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802476:	5b                   	pop    %ebx
  802477:	5e                   	pop    %esi
  802478:	5f                   	pop    %edi
  802479:	5d                   	pop    %ebp
  80247a:	c3                   	ret    

0080247b <devpipe_read>:
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	57                   	push   %edi
  80247f:	56                   	push   %esi
  802480:	53                   	push   %ebx
  802481:	83 ec 18             	sub    $0x18,%esp
  802484:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802487:	57                   	push   %edi
  802488:	e8 0c f2 ff ff       	call   801699 <fd2data>
  80248d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	be 00 00 00 00       	mov    $0x0,%esi
  802497:	3b 75 10             	cmp    0x10(%ebp),%esi
  80249a:	75 14                	jne    8024b0 <devpipe_read+0x35>
	return i;
  80249c:	8b 45 10             	mov    0x10(%ebp),%eax
  80249f:	eb 02                	jmp    8024a3 <devpipe_read+0x28>
				return i;
  8024a1:	89 f0                	mov    %esi,%eax
}
  8024a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a6:	5b                   	pop    %ebx
  8024a7:	5e                   	pop    %esi
  8024a8:	5f                   	pop    %edi
  8024a9:	5d                   	pop    %ebp
  8024aa:	c3                   	ret    
			sys_yield();
  8024ab:	e8 fe e9 ff ff       	call   800eae <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024b0:	8b 03                	mov    (%ebx),%eax
  8024b2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024b5:	75 18                	jne    8024cf <devpipe_read+0x54>
			if (i > 0)
  8024b7:	85 f6                	test   %esi,%esi
  8024b9:	75 e6                	jne    8024a1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024bb:	89 da                	mov    %ebx,%edx
  8024bd:	89 f8                	mov    %edi,%eax
  8024bf:	e8 d0 fe ff ff       	call   802394 <_pipeisclosed>
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 e3                	je     8024ab <devpipe_read+0x30>
				return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	eb d4                	jmp    8024a3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024cf:	99                   	cltd   
  8024d0:	c1 ea 1b             	shr    $0x1b,%edx
  8024d3:	01 d0                	add    %edx,%eax
  8024d5:	83 e0 1f             	and    $0x1f,%eax
  8024d8:	29 d0                	sub    %edx,%eax
  8024da:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024e5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024e8:	83 c6 01             	add    $0x1,%esi
  8024eb:	eb aa                	jmp    802497 <devpipe_read+0x1c>

008024ed <pipe>:
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	56                   	push   %esi
  8024f1:	53                   	push   %ebx
  8024f2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f8:	50                   	push   %eax
  8024f9:	e8 b2 f1 ff ff       	call   8016b0 <fd_alloc>
  8024fe:	89 c3                	mov    %eax,%ebx
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	85 c0                	test   %eax,%eax
  802505:	0f 88 23 01 00 00    	js     80262e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	68 07 04 00 00       	push   $0x407
  802513:	ff 75 f4             	pushl  -0xc(%ebp)
  802516:	6a 00                	push   $0x0
  802518:	e8 b0 e9 ff ff       	call   800ecd <sys_page_alloc>
  80251d:	89 c3                	mov    %eax,%ebx
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	85 c0                	test   %eax,%eax
  802524:	0f 88 04 01 00 00    	js     80262e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	e8 7a f1 ff ff       	call   8016b0 <fd_alloc>
  802536:	89 c3                	mov    %eax,%ebx
  802538:	83 c4 10             	add    $0x10,%esp
  80253b:	85 c0                	test   %eax,%eax
  80253d:	0f 88 db 00 00 00    	js     80261e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 07 04 00 00       	push   $0x407
  80254b:	ff 75 f0             	pushl  -0x10(%ebp)
  80254e:	6a 00                	push   $0x0
  802550:	e8 78 e9 ff ff       	call   800ecd <sys_page_alloc>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 88 bc 00 00 00    	js     80261e <pipe+0x131>
	va = fd2data(fd0);
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	ff 75 f4             	pushl  -0xc(%ebp)
  802568:	e8 2c f1 ff ff       	call   801699 <fd2data>
  80256d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256f:	83 c4 0c             	add    $0xc,%esp
  802572:	68 07 04 00 00       	push   $0x407
  802577:	50                   	push   %eax
  802578:	6a 00                	push   $0x0
  80257a:	e8 4e e9 ff ff       	call   800ecd <sys_page_alloc>
  80257f:	89 c3                	mov    %eax,%ebx
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	85 c0                	test   %eax,%eax
  802586:	0f 88 82 00 00 00    	js     80260e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80258c:	83 ec 0c             	sub    $0xc,%esp
  80258f:	ff 75 f0             	pushl  -0x10(%ebp)
  802592:	e8 02 f1 ff ff       	call   801699 <fd2data>
  802597:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80259e:	50                   	push   %eax
  80259f:	6a 00                	push   $0x0
  8025a1:	56                   	push   %esi
  8025a2:	6a 00                	push   $0x0
  8025a4:	e8 67 e9 ff ff       	call   800f10 <sys_page_map>
  8025a9:	89 c3                	mov    %eax,%ebx
  8025ab:	83 c4 20             	add    $0x20,%esp
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 4e                	js     802600 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025b2:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ba:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025d5:	83 ec 0c             	sub    $0xc,%esp
  8025d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025db:	e8 a9 f0 ff ff       	call   801689 <fd2num>
  8025e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025e5:	83 c4 04             	add    $0x4,%esp
  8025e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8025eb:	e8 99 f0 ff ff       	call   801689 <fd2num>
  8025f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025fe:	eb 2e                	jmp    80262e <pipe+0x141>
	sys_page_unmap(0, va);
  802600:	83 ec 08             	sub    $0x8,%esp
  802603:	56                   	push   %esi
  802604:	6a 00                	push   $0x0
  802606:	e8 47 e9 ff ff       	call   800f52 <sys_page_unmap>
  80260b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80260e:	83 ec 08             	sub    $0x8,%esp
  802611:	ff 75 f0             	pushl  -0x10(%ebp)
  802614:	6a 00                	push   $0x0
  802616:	e8 37 e9 ff ff       	call   800f52 <sys_page_unmap>
  80261b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80261e:	83 ec 08             	sub    $0x8,%esp
  802621:	ff 75 f4             	pushl  -0xc(%ebp)
  802624:	6a 00                	push   $0x0
  802626:	e8 27 e9 ff ff       	call   800f52 <sys_page_unmap>
  80262b:	83 c4 10             	add    $0x10,%esp
}
  80262e:	89 d8                	mov    %ebx,%eax
  802630:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802633:	5b                   	pop    %ebx
  802634:	5e                   	pop    %esi
  802635:	5d                   	pop    %ebp
  802636:	c3                   	ret    

00802637 <pipeisclosed>:
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802640:	50                   	push   %eax
  802641:	ff 75 08             	pushl  0x8(%ebp)
  802644:	e8 b9 f0 ff ff       	call   801702 <fd_lookup>
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	85 c0                	test   %eax,%eax
  80264e:	78 18                	js     802668 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802650:	83 ec 0c             	sub    $0xc,%esp
  802653:	ff 75 f4             	pushl  -0xc(%ebp)
  802656:	e8 3e f0 ff ff       	call   801699 <fd2data>
	return _pipeisclosed(fd, p);
  80265b:	89 c2                	mov    %eax,%edx
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	e8 2f fd ff ff       	call   802394 <_pipeisclosed>
  802665:	83 c4 10             	add    $0x10,%esp
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	56                   	push   %esi
  80266e:	53                   	push   %ebx
  80266f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802672:	85 f6                	test   %esi,%esi
  802674:	74 13                	je     802689 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802676:	89 f3                	mov    %esi,%ebx
  802678:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80267e:	c1 e3 07             	shl    $0x7,%ebx
  802681:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802687:	eb 1b                	jmp    8026a4 <wait+0x3a>
	assert(envid != 0);
  802689:	68 bb 33 80 00       	push   $0x8033bb
  80268e:	68 37 33 80 00       	push   $0x803337
  802693:	6a 09                	push   $0x9
  802695:	68 c6 33 80 00       	push   $0x8033c6
  80269a:	e8 e7 db ff ff       	call   800286 <_panic>
		sys_yield();
  80269f:	e8 0a e8 ff ff       	call   800eae <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026a4:	8b 43 48             	mov    0x48(%ebx),%eax
  8026a7:	39 f0                	cmp    %esi,%eax
  8026a9:	75 07                	jne    8026b2 <wait+0x48>
  8026ab:	8b 43 54             	mov    0x54(%ebx),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	75 ed                	jne    80269f <wait+0x35>
}
  8026b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b5:	5b                   	pop    %ebx
  8026b6:	5e                   	pop    %esi
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    

008026b9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	c3                   	ret    

008026bf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026c5:	68 d1 33 80 00       	push   $0x8033d1
  8026ca:	ff 75 0c             	pushl  0xc(%ebp)
  8026cd:	e8 09 e4 ff ff       	call   800adb <strcpy>
	return 0;
}
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <devcons_write>:
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	57                   	push   %edi
  8026dd:	56                   	push   %esi
  8026de:	53                   	push   %ebx
  8026df:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026e5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026ea:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026f3:	73 31                	jae    802726 <devcons_write+0x4d>
		m = n - tot;
  8026f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026f8:	29 f3                	sub    %esi,%ebx
  8026fa:	83 fb 7f             	cmp    $0x7f,%ebx
  8026fd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802702:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802705:	83 ec 04             	sub    $0x4,%esp
  802708:	53                   	push   %ebx
  802709:	89 f0                	mov    %esi,%eax
  80270b:	03 45 0c             	add    0xc(%ebp),%eax
  80270e:	50                   	push   %eax
  80270f:	57                   	push   %edi
  802710:	e8 54 e5 ff ff       	call   800c69 <memmove>
		sys_cputs(buf, m);
  802715:	83 c4 08             	add    $0x8,%esp
  802718:	53                   	push   %ebx
  802719:	57                   	push   %edi
  80271a:	e8 f2 e6 ff ff       	call   800e11 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80271f:	01 de                	add    %ebx,%esi
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	eb ca                	jmp    8026f0 <devcons_write+0x17>
}
  802726:	89 f0                	mov    %esi,%eax
  802728:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80272b:	5b                   	pop    %ebx
  80272c:	5e                   	pop    %esi
  80272d:	5f                   	pop    %edi
  80272e:	5d                   	pop    %ebp
  80272f:	c3                   	ret    

00802730 <devcons_read>:
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 08             	sub    $0x8,%esp
  802736:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80273b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80273f:	74 21                	je     802762 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802741:	e8 e9 e6 ff ff       	call   800e2f <sys_cgetc>
  802746:	85 c0                	test   %eax,%eax
  802748:	75 07                	jne    802751 <devcons_read+0x21>
		sys_yield();
  80274a:	e8 5f e7 ff ff       	call   800eae <sys_yield>
  80274f:	eb f0                	jmp    802741 <devcons_read+0x11>
	if (c < 0)
  802751:	78 0f                	js     802762 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802753:	83 f8 04             	cmp    $0x4,%eax
  802756:	74 0c                	je     802764 <devcons_read+0x34>
	*(char*)vbuf = c;
  802758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275b:	88 02                	mov    %al,(%edx)
	return 1;
  80275d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802762:	c9                   	leave  
  802763:	c3                   	ret    
		return 0;
  802764:	b8 00 00 00 00       	mov    $0x0,%eax
  802769:	eb f7                	jmp    802762 <devcons_read+0x32>

0080276b <cputchar>:
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802777:	6a 01                	push   $0x1
  802779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277c:	50                   	push   %eax
  80277d:	e8 8f e6 ff ff       	call   800e11 <sys_cputs>
}
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <getchar>:
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80278d:	6a 01                	push   $0x1
  80278f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802792:	50                   	push   %eax
  802793:	6a 00                	push   $0x0
  802795:	e8 d8 f1 ff ff       	call   801972 <read>
	if (r < 0)
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	85 c0                	test   %eax,%eax
  80279f:	78 06                	js     8027a7 <getchar+0x20>
	if (r < 1)
  8027a1:	74 06                	je     8027a9 <getchar+0x22>
	return c;
  8027a3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    
		return -E_EOF;
  8027a9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027ae:	eb f7                	jmp    8027a7 <getchar+0x20>

008027b0 <iscons>:
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b9:	50                   	push   %eax
  8027ba:	ff 75 08             	pushl  0x8(%ebp)
  8027bd:	e8 40 ef ff ff       	call   801702 <fd_lookup>
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	78 11                	js     8027da <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027d2:	39 10                	cmp    %edx,(%eax)
  8027d4:	0f 94 c0             	sete   %al
  8027d7:	0f b6 c0             	movzbl %al,%eax
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <opencons>:
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e5:	50                   	push   %eax
  8027e6:	e8 c5 ee ff ff       	call   8016b0 <fd_alloc>
  8027eb:	83 c4 10             	add    $0x10,%esp
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 3a                	js     80282c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 07 04 00 00       	push   $0x407
  8027fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8027fd:	6a 00                	push   $0x0
  8027ff:	e8 c9 e6 ff ff       	call   800ecd <sys_page_alloc>
  802804:	83 c4 10             	add    $0x10,%esp
  802807:	85 c0                	test   %eax,%eax
  802809:	78 21                	js     80282c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802814:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802820:	83 ec 0c             	sub    $0xc,%esp
  802823:	50                   	push   %eax
  802824:	e8 60 ee ff ff       	call   801689 <fd2num>
  802829:	83 c4 10             	add    $0x10,%esp
}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802834:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80283b:	74 0a                	je     802847 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	6a 07                	push   $0x7
  80284c:	68 00 f0 bf ee       	push   $0xeebff000
  802851:	6a 00                	push   $0x0
  802853:	e8 75 e6 ff ff       	call   800ecd <sys_page_alloc>
		if(r < 0)
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	85 c0                	test   %eax,%eax
  80285d:	78 2a                	js     802889 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80285f:	83 ec 08             	sub    $0x8,%esp
  802862:	68 9d 28 80 00       	push   $0x80289d
  802867:	6a 00                	push   $0x0
  802869:	e8 aa e7 ff ff       	call   801018 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	85 c0                	test   %eax,%eax
  802873:	79 c8                	jns    80283d <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 10 34 80 00       	push   $0x803410
  80287d:	6a 25                	push   $0x25
  80287f:	68 4c 34 80 00       	push   $0x80344c
  802884:	e8 fd d9 ff ff       	call   800286 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 e0 33 80 00       	push   $0x8033e0
  802891:	6a 22                	push   $0x22
  802893:	68 4c 34 80 00       	push   $0x80344c
  802898:	e8 e9 d9 ff ff       	call   800286 <_panic>

0080289d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80289d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80289e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028a3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028a5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028a8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028ac:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028b0:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028b3:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028b5:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028b9:	83 c4 08             	add    $0x8,%esp
	popal
  8028bc:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028bd:	83 c4 04             	add    $0x4,%esp
	popfl
  8028c0:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028c1:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028c2:	c3                   	ret    

008028c3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	56                   	push   %esi
  8028c7:	53                   	push   %ebx
  8028c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8028cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028d1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028d3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028d8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	50                   	push   %eax
  8028df:	e8 99 e7 ff ff       	call   80107d <sys_ipc_recv>
	if(ret < 0){
  8028e4:	83 c4 10             	add    $0x10,%esp
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	78 2b                	js     802916 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028eb:	85 f6                	test   %esi,%esi
  8028ed:	74 0a                	je     8028f9 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8028ef:	a1 20 54 80 00       	mov    0x805420,%eax
  8028f4:	8b 40 74             	mov    0x74(%eax),%eax
  8028f7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028f9:	85 db                	test   %ebx,%ebx
  8028fb:	74 0a                	je     802907 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8028fd:	a1 20 54 80 00       	mov    0x805420,%eax
  802902:	8b 40 78             	mov    0x78(%eax),%eax
  802905:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802907:	a1 20 54 80 00       	mov    0x805420,%eax
  80290c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80290f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802912:	5b                   	pop    %ebx
  802913:	5e                   	pop    %esi
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    
		if(from_env_store)
  802916:	85 f6                	test   %esi,%esi
  802918:	74 06                	je     802920 <ipc_recv+0x5d>
			*from_env_store = 0;
  80291a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802920:	85 db                	test   %ebx,%ebx
  802922:	74 eb                	je     80290f <ipc_recv+0x4c>
			*perm_store = 0;
  802924:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80292a:	eb e3                	jmp    80290f <ipc_recv+0x4c>

0080292c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	57                   	push   %edi
  802930:	56                   	push   %esi
  802931:	53                   	push   %ebx
  802932:	83 ec 0c             	sub    $0xc,%esp
  802935:	8b 7d 08             	mov    0x8(%ebp),%edi
  802938:	8b 75 0c             	mov    0xc(%ebp),%esi
  80293b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80293e:	85 db                	test   %ebx,%ebx
  802940:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802945:	0f 44 d8             	cmove  %eax,%ebx
  802948:	eb 05                	jmp    80294f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80294a:	e8 5f e5 ff ff       	call   800eae <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80294f:	ff 75 14             	pushl  0x14(%ebp)
  802952:	53                   	push   %ebx
  802953:	56                   	push   %esi
  802954:	57                   	push   %edi
  802955:	e8 00 e7 ff ff       	call   80105a <sys_ipc_try_send>
  80295a:	83 c4 10             	add    $0x10,%esp
  80295d:	85 c0                	test   %eax,%eax
  80295f:	74 1b                	je     80297c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802961:	79 e7                	jns    80294a <ipc_send+0x1e>
  802963:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802966:	74 e2                	je     80294a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 5a 34 80 00       	push   $0x80345a
  802970:	6a 48                	push   $0x48
  802972:	68 6f 34 80 00       	push   $0x80346f
  802977:	e8 0a d9 ff ff       	call   800286 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80297c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80297f:	5b                   	pop    %ebx
  802980:	5e                   	pop    %esi
  802981:	5f                   	pop    %edi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    

00802984 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80298f:	89 c2                	mov    %eax,%edx
  802991:	c1 e2 07             	shl    $0x7,%edx
  802994:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80299a:	8b 52 50             	mov    0x50(%edx),%edx
  80299d:	39 ca                	cmp    %ecx,%edx
  80299f:	74 11                	je     8029b2 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029a1:	83 c0 01             	add    $0x1,%eax
  8029a4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029a9:	75 e4                	jne    80298f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	eb 0b                	jmp    8029bd <ipc_find_env+0x39>
			return envs[i].env_id;
  8029b2:	c1 e0 07             	shl    $0x7,%eax
  8029b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029ba:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029bd:	5d                   	pop    %ebp
  8029be:	c3                   	ret    

008029bf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
  8029c2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	c1 e8 16             	shr    $0x16,%eax
  8029ca:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029d6:	f6 c1 01             	test   $0x1,%cl
  8029d9:	74 1d                	je     8029f8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029db:	c1 ea 0c             	shr    $0xc,%edx
  8029de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029e5:	f6 c2 01             	test   $0x1,%dl
  8029e8:	74 0e                	je     8029f8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029ea:	c1 ea 0c             	shr    $0xc,%edx
  8029ed:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029f4:	ef 
  8029f5:	0f b7 c0             	movzwl %ax,%eax
}
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    
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
