
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
  800043:	e8 dc 1d 00 00       	call   801e24 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 74 1a 00 00       	call   801ad4 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 9a 19 00 00       	call   801a0d <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 86 13 00 00       	call   80140b <fork>
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
  800097:	e8 38 1a 00 00       	call   801ad4 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  8000a3:	e8 d4 02 00 00       	call   80037c <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 52 19 00 00       	call   801a0d <readn>
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
  8000f7:	e8 d8 19 00 00       	call   801ad4 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 44 17 00 00       	call   801848 <close>
		exit();
  800104:	e8 63 01 00 00       	call   80026c <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 69 25 00 00       	call   80267e <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 e5 18 00 00       	call   801a0d <readn>
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
  800143:	e8 00 17 00 00       	call   801848 <close>
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

	cprintf("call umain!\n");
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
  800272:	e8 fe 15 00 00       	call   801875 <close_all>
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
  800296:	68 e4 2d 80 00       	push   $0x802de4
  80029b:	50                   	push   %eax
  80029c:	68 b2 2d 80 00       	push   $0x802db2
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
  8002bf:	68 c0 2d 80 00       	push   $0x802dc0
  8002c4:	e8 b3 00 00 00       	call   80037c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c9:	83 c4 18             	add    $0x18,%esp
  8002cc:	53                   	push   %ebx
  8002cd:	ff 75 10             	pushl  0x10(%ebp)
  8002d0:	e8 56 00 00 00       	call   80032b <vcprintf>
	cprintf("\n");
  8002d5:	c7 04 24 a6 2d 80 00 	movl   $0x802da6,(%esp)
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
  800429:	e8 e2 25 00 00       	call   802a10 <__udivdi3>
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
  800452:	e8 c9 26 00 00       	call   802b20 <__umoddi3>
  800457:	83 c4 14             	add    $0x14,%esp
  80045a:	0f be 80 eb 2d 80 00 	movsbl 0x802deb(%eax),%eax
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
  800503:	ff 24 85 c0 2f 80 00 	jmp    *0x802fc0(,%eax,4)
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
  8005ce:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  8005d5:	85 d2                	test   %edx,%edx
  8005d7:	74 18                	je     8005f1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005d9:	52                   	push   %edx
  8005da:	68 31 33 80 00       	push   $0x803331
  8005df:	53                   	push   %ebx
  8005e0:	56                   	push   %esi
  8005e1:	e8 a6 fe ff ff       	call   80048c <printfmt>
  8005e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ec:	e9 fe 02 00 00       	jmp    8008ef <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f1:	50                   	push   %eax
  8005f2:	68 03 2e 80 00       	push   $0x802e03
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
  800619:	b8 fc 2d 80 00       	mov    $0x802dfc,%eax
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
  8009b1:	bf 21 2f 80 00       	mov    $0x802f21,%edi
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
  8009dd:	bf 59 2f 80 00       	mov    $0x802f59,%edi
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
  800e7e:	68 64 31 80 00       	push   $0x803164
  800e83:	6a 43                	push   $0x43
  800e85:	68 81 31 80 00       	push   $0x803181
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
  800eff:	68 64 31 80 00       	push   $0x803164
  800f04:	6a 43                	push   $0x43
  800f06:	68 81 31 80 00       	push   $0x803181
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
  800f41:	68 64 31 80 00       	push   $0x803164
  800f46:	6a 43                	push   $0x43
  800f48:	68 81 31 80 00       	push   $0x803181
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
  800f83:	68 64 31 80 00       	push   $0x803164
  800f88:	6a 43                	push   $0x43
  800f8a:	68 81 31 80 00       	push   $0x803181
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
  800fc5:	68 64 31 80 00       	push   $0x803164
  800fca:	6a 43                	push   $0x43
  800fcc:	68 81 31 80 00       	push   $0x803181
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
  801007:	68 64 31 80 00       	push   $0x803164
  80100c:	6a 43                	push   $0x43
  80100e:	68 81 31 80 00       	push   $0x803181
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
  801049:	68 64 31 80 00       	push   $0x803164
  80104e:	6a 43                	push   $0x43
  801050:	68 81 31 80 00       	push   $0x803181
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
  8010ad:	68 64 31 80 00       	push   $0x803164
  8010b2:	6a 43                	push   $0x43
  8010b4:	68 81 31 80 00       	push   $0x803181
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
  801191:	68 64 31 80 00       	push   $0x803164
  801196:	6a 43                	push   $0x43
  801198:	68 81 31 80 00       	push   $0x803181
  80119d:	e8 e4 f0 ff ff       	call   800286 <_panic>

008011a2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011ac:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ae:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011b2:	0f 84 99 00 00 00    	je     801251 <pgfault+0xaf>
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	c1 ea 16             	shr    $0x16,%edx
  8011bd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c4:	f6 c2 01             	test   $0x1,%dl
  8011c7:	0f 84 84 00 00 00    	je     801251 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011cd:	89 c2                	mov    %eax,%edx
  8011cf:	c1 ea 0c             	shr    $0xc,%edx
  8011d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011df:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011e5:	75 6a                	jne    801251 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8011e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ec:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	6a 07                	push   $0x7
  8011f3:	68 00 f0 7f 00       	push   $0x7ff000
  8011f8:	6a 00                	push   $0x0
  8011fa:	e8 ce fc ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	78 5f                	js     801265 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 00 10 00 00       	push   $0x1000
  80120e:	53                   	push   %ebx
  80120f:	68 00 f0 7f 00       	push   $0x7ff000
  801214:	e8 b2 fa ff ff       	call   800ccb <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801219:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801220:	53                   	push   %ebx
  801221:	6a 00                	push   $0x0
  801223:	68 00 f0 7f 00       	push   $0x7ff000
  801228:	6a 00                	push   $0x0
  80122a:	e8 e1 fc ff ff       	call   800f10 <sys_page_map>
	if(ret < 0)
  80122f:	83 c4 20             	add    $0x20,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	78 43                	js     801279 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801236:	83 ec 08             	sub    $0x8,%esp
  801239:	68 00 f0 7f 00       	push   $0x7ff000
  80123e:	6a 00                	push   $0x0
  801240:	e8 0d fd ff ff       	call   800f52 <sys_page_unmap>
	if(ret < 0)
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 41                	js     80128d <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  80124c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124f:	c9                   	leave  
  801250:	c3                   	ret    
		panic("panic at pgfault()\n");
  801251:	83 ec 04             	sub    $0x4,%esp
  801254:	68 8f 31 80 00       	push   $0x80318f
  801259:	6a 26                	push   $0x26
  80125b:	68 a3 31 80 00       	push   $0x8031a3
  801260:	e8 21 f0 ff ff       	call   800286 <_panic>
		panic("panic in sys_page_alloc()\n");
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	68 ae 31 80 00       	push   $0x8031ae
  80126d:	6a 31                	push   $0x31
  80126f:	68 a3 31 80 00       	push   $0x8031a3
  801274:	e8 0d f0 ff ff       	call   800286 <_panic>
		panic("panic in sys_page_map()\n");
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	68 c9 31 80 00       	push   $0x8031c9
  801281:	6a 36                	push   $0x36
  801283:	68 a3 31 80 00       	push   $0x8031a3
  801288:	e8 f9 ef ff ff       	call   800286 <_panic>
		panic("panic in sys_page_unmap()\n");
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	68 e2 31 80 00       	push   $0x8031e2
  801295:	6a 39                	push   $0x39
  801297:	68 a3 31 80 00       	push   $0x8031a3
  80129c:	e8 e5 ef ff ff       	call   800286 <_panic>

008012a1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	89 c6                	mov    %eax,%esi
  8012a8:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	68 80 32 80 00       	push   $0x803280
  8012b2:	68 b6 2d 80 00       	push   $0x802db6
  8012b7:	e8 c0 f0 ff ff       	call   80037c <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012bc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	f6 c4 04             	test   $0x4,%ah
  8012c9:	75 45                	jne    801310 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012cb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012d2:	83 e0 07             	and    $0x7,%eax
  8012d5:	83 f8 07             	cmp    $0x7,%eax
  8012d8:	74 6e                	je     801348 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012da:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012e1:	25 05 08 00 00       	and    $0x805,%eax
  8012e6:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012eb:	0f 84 b5 00 00 00    	je     8013a6 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012f1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012f8:	83 e0 05             	and    $0x5,%eax
  8012fb:	83 f8 05             	cmp    $0x5,%eax
  8012fe:	0f 84 d6 00 00 00    	je     8013da <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130c:	5b                   	pop    %ebx
  80130d:	5e                   	pop    %esi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801310:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801317:	c1 e3 0c             	shl    $0xc,%ebx
  80131a:	83 ec 0c             	sub    $0xc,%esp
  80131d:	25 07 0e 00 00       	and    $0xe07,%eax
  801322:	50                   	push   %eax
  801323:	53                   	push   %ebx
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	6a 00                	push   $0x0
  801328:	e8 e3 fb ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  80132d:	83 c4 20             	add    $0x20,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	79 d0                	jns    801304 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 fd 31 80 00       	push   $0x8031fd
  80133c:	6a 55                	push   $0x55
  80133e:	68 a3 31 80 00       	push   $0x8031a3
  801343:	e8 3e ef ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801348:	c1 e3 0c             	shl    $0xc,%ebx
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	68 05 08 00 00       	push   $0x805
  801353:	53                   	push   %ebx
  801354:	56                   	push   %esi
  801355:	53                   	push   %ebx
  801356:	6a 00                	push   $0x0
  801358:	e8 b3 fb ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  80135d:	83 c4 20             	add    $0x20,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 2e                	js     801392 <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801364:	83 ec 0c             	sub    $0xc,%esp
  801367:	68 05 08 00 00       	push   $0x805
  80136c:	53                   	push   %ebx
  80136d:	6a 00                	push   $0x0
  80136f:	53                   	push   %ebx
  801370:	6a 00                	push   $0x0
  801372:	e8 99 fb ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  801377:	83 c4 20             	add    $0x20,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	79 86                	jns    801304 <duppage+0x63>
			panic("sys_page_map() panic\n");
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	68 fd 31 80 00       	push   $0x8031fd
  801386:	6a 60                	push   $0x60
  801388:	68 a3 31 80 00       	push   $0x8031a3
  80138d:	e8 f4 ee ff ff       	call   800286 <_panic>
			panic("sys_page_map() panic\n");
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	68 fd 31 80 00       	push   $0x8031fd
  80139a:	6a 5c                	push   $0x5c
  80139c:	68 a3 31 80 00       	push   $0x8031a3
  8013a1:	e8 e0 ee ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013a6:	c1 e3 0c             	shl    $0xc,%ebx
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	68 05 08 00 00       	push   $0x805
  8013b1:	53                   	push   %ebx
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
  8013b4:	6a 00                	push   $0x0
  8013b6:	e8 55 fb ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  8013bb:	83 c4 20             	add    $0x20,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	0f 89 3e ff ff ff    	jns    801304 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	68 fd 31 80 00       	push   $0x8031fd
  8013ce:	6a 67                	push   $0x67
  8013d0:	68 a3 31 80 00       	push   $0x8031a3
  8013d5:	e8 ac ee ff ff       	call   800286 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013da:	c1 e3 0c             	shl    $0xc,%ebx
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	6a 05                	push   $0x5
  8013e2:	53                   	push   %ebx
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 24 fb ff ff       	call   800f10 <sys_page_map>
		if(r < 0)
  8013ec:	83 c4 20             	add    $0x20,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	0f 89 0d ff ff ff    	jns    801304 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	68 fd 31 80 00       	push   $0x8031fd
  8013ff:	6a 6e                	push   $0x6e
  801401:	68 a3 31 80 00       	push   $0x8031a3
  801406:	e8 7b ee ff ff       	call   800286 <_panic>

0080140b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	57                   	push   %edi
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801414:	68 a2 11 80 00       	push   $0x8011a2
  801419:	e8 24 14 00 00       	call   802842 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80141e:	b8 07 00 00 00       	mov    $0x7,%eax
  801423:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 27                	js     801453 <fork+0x48>
  80142c:	89 c6                	mov    %eax,%esi
  80142e:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801430:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801435:	75 48                	jne    80147f <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801437:	e8 53 fa ff ff       	call   800e8f <sys_getenvid>
  80143c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801441:	c1 e0 07             	shl    $0x7,%eax
  801444:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801449:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  80144e:	e9 90 00 00 00       	jmp    8014e3 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	68 14 32 80 00       	push   $0x803214
  80145b:	68 8d 00 00 00       	push   $0x8d
  801460:	68 a3 31 80 00       	push   $0x8031a3
  801465:	e8 1c ee ff ff       	call   800286 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80146a:	89 f8                	mov    %edi,%eax
  80146c:	e8 30 fe ff ff       	call   8012a1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801477:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80147d:	74 26                	je     8014a5 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80147f:	89 d8                	mov    %ebx,%eax
  801481:	c1 e8 16             	shr    $0x16,%eax
  801484:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148b:	a8 01                	test   $0x1,%al
  80148d:	74 e2                	je     801471 <fork+0x66>
  80148f:	89 da                	mov    %ebx,%edx
  801491:	c1 ea 0c             	shr    $0xc,%edx
  801494:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80149b:	83 e0 05             	and    $0x5,%eax
  80149e:	83 f8 05             	cmp    $0x5,%eax
  8014a1:	75 ce                	jne    801471 <fork+0x66>
  8014a3:	eb c5                	jmp    80146a <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	6a 07                	push   $0x7
  8014aa:	68 00 f0 bf ee       	push   $0xeebff000
  8014af:	56                   	push   %esi
  8014b0:	e8 18 fa ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 31                	js     8014ed <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	68 b1 28 80 00       	push   $0x8028b1
  8014c4:	56                   	push   %esi
  8014c5:	e8 4e fb ff ff       	call   801018 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 33                	js     801504 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	6a 02                	push   $0x2
  8014d6:	56                   	push   %esi
  8014d7:	e8 b8 fa ff ff       	call   800f94 <sys_env_set_status>
	if(ret < 0)
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 38                	js     80151b <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014e3:	89 f0                	mov    %esi,%eax
  8014e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e8:	5b                   	pop    %ebx
  8014e9:	5e                   	pop    %esi
  8014ea:	5f                   	pop    %edi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 ae 31 80 00       	push   $0x8031ae
  8014f5:	68 99 00 00 00       	push   $0x99
  8014fa:	68 a3 31 80 00       	push   $0x8031a3
  8014ff:	e8 82 ed ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 38 32 80 00       	push   $0x803238
  80150c:	68 9c 00 00 00       	push   $0x9c
  801511:	68 a3 31 80 00       	push   $0x8031a3
  801516:	e8 6b ed ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_status()\n");
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	68 60 32 80 00       	push   $0x803260
  801523:	68 9f 00 00 00       	push   $0x9f
  801528:	68 a3 31 80 00       	push   $0x8031a3
  80152d:	e8 54 ed ff ff       	call   800286 <_panic>

00801532 <sfork>:

// Challenge!
int
sfork(void)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	57                   	push   %edi
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80153b:	68 a2 11 80 00       	push   $0x8011a2
  801540:	e8 fd 12 00 00       	call   802842 <set_pgfault_handler>
  801545:	b8 07 00 00 00       	mov    $0x7,%eax
  80154a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 27                	js     80157a <sfork+0x48>
  801553:	89 c7                	mov    %eax,%edi
  801555:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801557:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80155c:	75 55                	jne    8015b3 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80155e:	e8 2c f9 ff ff       	call   800e8f <sys_getenvid>
  801563:	25 ff 03 00 00       	and    $0x3ff,%eax
  801568:	c1 e0 07             	shl    $0x7,%eax
  80156b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801570:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  801575:	e9 d4 00 00 00       	jmp    80164e <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 14 32 80 00       	push   $0x803214
  801582:	68 b0 00 00 00       	push   $0xb0
  801587:	68 a3 31 80 00       	push   $0x8031a3
  80158c:	e8 f5 ec ff ff       	call   800286 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801591:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801596:	89 f0                	mov    %esi,%eax
  801598:	e8 04 fd ff ff       	call   8012a1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80159d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015a3:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015a9:	77 65                	ja     801610 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015ab:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015b1:	74 de                	je     801591 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015b3:	89 d8                	mov    %ebx,%eax
  8015b5:	c1 e8 16             	shr    $0x16,%eax
  8015b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015bf:	a8 01                	test   $0x1,%al
  8015c1:	74 da                	je     80159d <sfork+0x6b>
  8015c3:	89 da                	mov    %ebx,%edx
  8015c5:	c1 ea 0c             	shr    $0xc,%edx
  8015c8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015cf:	83 e0 05             	and    $0x5,%eax
  8015d2:	83 f8 05             	cmp    $0x5,%eax
  8015d5:	75 c6                	jne    80159d <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015d7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015de:	c1 e2 0c             	shl    $0xc,%edx
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	83 e0 07             	and    $0x7,%eax
  8015e7:	50                   	push   %eax
  8015e8:	52                   	push   %edx
  8015e9:	56                   	push   %esi
  8015ea:	52                   	push   %edx
  8015eb:	6a 00                	push   $0x0
  8015ed:	e8 1e f9 ff ff       	call   800f10 <sys_page_map>
  8015f2:	83 c4 20             	add    $0x20,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	74 a4                	je     80159d <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 fd 31 80 00       	push   $0x8031fd
  801601:	68 bb 00 00 00       	push   $0xbb
  801606:	68 a3 31 80 00       	push   $0x8031a3
  80160b:	e8 76 ec ff ff       	call   800286 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	6a 07                	push   $0x7
  801615:	68 00 f0 bf ee       	push   $0xeebff000
  80161a:	57                   	push   %edi
  80161b:	e8 ad f8 ff ff       	call   800ecd <sys_page_alloc>
	if(ret < 0)
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	85 c0                	test   %eax,%eax
  801625:	78 31                	js     801658 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	68 b1 28 80 00       	push   $0x8028b1
  80162f:	57                   	push   %edi
  801630:	e8 e3 f9 ff ff       	call   801018 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 33                	js     80166f <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	6a 02                	push   $0x2
  801641:	57                   	push   %edi
  801642:	e8 4d f9 ff ff       	call   800f94 <sys_env_set_status>
	if(ret < 0)
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 38                	js     801686 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80164e:	89 f8                	mov    %edi,%eax
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 ae 31 80 00       	push   $0x8031ae
  801660:	68 c1 00 00 00       	push   $0xc1
  801665:	68 a3 31 80 00       	push   $0x8031a3
  80166a:	e8 17 ec ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	68 38 32 80 00       	push   $0x803238
  801677:	68 c4 00 00 00       	push   $0xc4
  80167c:	68 a3 31 80 00       	push   $0x8031a3
  801681:	e8 00 ec ff ff       	call   800286 <_panic>
		panic("panic in sys_env_set_status()\n");
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 60 32 80 00       	push   $0x803260
  80168e:	68 c7 00 00 00       	push   $0xc7
  801693:	68 a3 31 80 00       	push   $0x8031a3
  801698:	e8 e9 eb ff ff       	call   800286 <_panic>

0080169d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	05 00 00 00 30       	add    $0x30000000,%eax
  8016a8:	c1 e8 0c             	shr    $0xc,%eax
}
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    

008016ad <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    

008016c4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016cc:	89 c2                	mov    %eax,%edx
  8016ce:	c1 ea 16             	shr    $0x16,%edx
  8016d1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016d8:	f6 c2 01             	test   $0x1,%dl
  8016db:	74 2d                	je     80170a <fd_alloc+0x46>
  8016dd:	89 c2                	mov    %eax,%edx
  8016df:	c1 ea 0c             	shr    $0xc,%edx
  8016e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016e9:	f6 c2 01             	test   $0x1,%dl
  8016ec:	74 1c                	je     80170a <fd_alloc+0x46>
  8016ee:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016f3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016f8:	75 d2                	jne    8016cc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801703:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801708:	eb 0a                	jmp    801714 <fd_alloc+0x50>
			*fd_store = fd;
  80170a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80171c:	83 f8 1f             	cmp    $0x1f,%eax
  80171f:	77 30                	ja     801751 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801721:	c1 e0 0c             	shl    $0xc,%eax
  801724:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801729:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80172f:	f6 c2 01             	test   $0x1,%dl
  801732:	74 24                	je     801758 <fd_lookup+0x42>
  801734:	89 c2                	mov    %eax,%edx
  801736:	c1 ea 0c             	shr    $0xc,%edx
  801739:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801740:	f6 c2 01             	test   $0x1,%dl
  801743:	74 1a                	je     80175f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	89 02                	mov    %eax,(%edx)
	return 0;
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    
		return -E_INVAL;
  801751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801756:	eb f7                	jmp    80174f <fd_lookup+0x39>
		return -E_INVAL;
  801758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175d:	eb f0                	jmp    80174f <fd_lookup+0x39>
  80175f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801764:	eb e9                	jmp    80174f <fd_lookup+0x39>

00801766 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80176f:	ba 00 00 00 00       	mov    $0x0,%edx
  801774:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801779:	39 08                	cmp    %ecx,(%eax)
  80177b:	74 38                	je     8017b5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80177d:	83 c2 01             	add    $0x1,%edx
  801780:	8b 04 95 04 33 80 00 	mov    0x803304(,%edx,4),%eax
  801787:	85 c0                	test   %eax,%eax
  801789:	75 ee                	jne    801779 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80178b:	a1 20 54 80 00       	mov    0x805420,%eax
  801790:	8b 40 48             	mov    0x48(%eax),%eax
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	51                   	push   %ecx
  801797:	50                   	push   %eax
  801798:	68 88 32 80 00       	push   $0x803288
  80179d:	e8 da eb ff ff       	call   80037c <cprintf>
	*dev = 0;
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    
			*dev = devtab[i];
  8017b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bf:	eb f2                	jmp    8017b3 <dev_lookup+0x4d>

008017c1 <fd_close>:
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	57                   	push   %edi
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 24             	sub    $0x24,%esp
  8017ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8017cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017d4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017da:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017dd:	50                   	push   %eax
  8017de:	e8 33 ff ff ff       	call   801716 <fd_lookup>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 05                	js     8017f1 <fd_close+0x30>
	    || fd != fd2)
  8017ec:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017ef:	74 16                	je     801807 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f1:	89 f8                	mov    %edi,%eax
  8017f3:	84 c0                	test   %al,%al
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	0f 44 d8             	cmove  %eax,%ebx
}
  8017fd:	89 d8                	mov    %ebx,%eax
  8017ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801807:	83 ec 08             	sub    $0x8,%esp
  80180a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	ff 36                	pushl  (%esi)
  801810:	e8 51 ff ff ff       	call   801766 <dev_lookup>
  801815:	89 c3                	mov    %eax,%ebx
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 1a                	js     801838 <fd_close+0x77>
		if (dev->dev_close)
  80181e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801821:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801824:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801829:	85 c0                	test   %eax,%eax
  80182b:	74 0b                	je     801838 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	56                   	push   %esi
  801831:	ff d0                	call   *%eax
  801833:	89 c3                	mov    %eax,%ebx
  801835:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	56                   	push   %esi
  80183c:	6a 00                	push   $0x0
  80183e:	e8 0f f7 ff ff       	call   800f52 <sys_page_unmap>
	return r;
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	eb b5                	jmp    8017fd <fd_close+0x3c>

00801848 <close>:

int
close(int fdnum)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	e8 bc fe ff ff       	call   801716 <fd_lookup>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	79 02                	jns    801863 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    
		return fd_close(fd, 1);
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	6a 01                	push   $0x1
  801868:	ff 75 f4             	pushl  -0xc(%ebp)
  80186b:	e8 51 ff ff ff       	call   8017c1 <fd_close>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	eb ec                	jmp    801861 <close+0x19>

00801875 <close_all>:

void
close_all(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	53                   	push   %ebx
  801879:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80187c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	53                   	push   %ebx
  801885:	e8 be ff ff ff       	call   801848 <close>
	for (i = 0; i < MAXFD; i++)
  80188a:	83 c3 01             	add    $0x1,%ebx
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	83 fb 20             	cmp    $0x20,%ebx
  801893:	75 ec                	jne    801881 <close_all+0xc>
}
  801895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	57                   	push   %edi
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a6:	50                   	push   %eax
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	e8 67 fe ff ff       	call   801716 <fd_lookup>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	0f 88 81 00 00 00    	js     80193d <dup+0xa3>
		return r;
	close(newfdnum);
  8018bc:	83 ec 0c             	sub    $0xc,%esp
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	e8 81 ff ff ff       	call   801848 <close>

	newfd = INDEX2FD(newfdnum);
  8018c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018ca:	c1 e6 0c             	shl    $0xc,%esi
  8018cd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018d3:	83 c4 04             	add    $0x4,%esp
  8018d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d9:	e8 cf fd ff ff       	call   8016ad <fd2data>
  8018de:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018e0:	89 34 24             	mov    %esi,(%esp)
  8018e3:	e8 c5 fd ff ff       	call   8016ad <fd2data>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018ed:	89 d8                	mov    %ebx,%eax
  8018ef:	c1 e8 16             	shr    $0x16,%eax
  8018f2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018f9:	a8 01                	test   $0x1,%al
  8018fb:	74 11                	je     80190e <dup+0x74>
  8018fd:	89 d8                	mov    %ebx,%eax
  8018ff:	c1 e8 0c             	shr    $0xc,%eax
  801902:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801909:	f6 c2 01             	test   $0x1,%dl
  80190c:	75 39                	jne    801947 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80190e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e8 0c             	shr    $0xc,%eax
  801916:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	25 07 0e 00 00       	and    $0xe07,%eax
  801925:	50                   	push   %eax
  801926:	56                   	push   %esi
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	6a 00                	push   $0x0
  80192c:	e8 df f5 ff ff       	call   800f10 <sys_page_map>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	83 c4 20             	add    $0x20,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 31                	js     80196b <dup+0xd1>
		goto err;

	return newfdnum;
  80193a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80193d:	89 d8                	mov    %ebx,%eax
  80193f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5f                   	pop    %edi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801947:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194e:	83 ec 0c             	sub    $0xc,%esp
  801951:	25 07 0e 00 00       	and    $0xe07,%eax
  801956:	50                   	push   %eax
  801957:	57                   	push   %edi
  801958:	6a 00                	push   $0x0
  80195a:	53                   	push   %ebx
  80195b:	6a 00                	push   $0x0
  80195d:	e8 ae f5 ff ff       	call   800f10 <sys_page_map>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 20             	add    $0x20,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	79 a3                	jns    80190e <dup+0x74>
	sys_page_unmap(0, newfd);
  80196b:	83 ec 08             	sub    $0x8,%esp
  80196e:	56                   	push   %esi
  80196f:	6a 00                	push   $0x0
  801971:	e8 dc f5 ff ff       	call   800f52 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801976:	83 c4 08             	add    $0x8,%esp
  801979:	57                   	push   %edi
  80197a:	6a 00                	push   $0x0
  80197c:	e8 d1 f5 ff ff       	call   800f52 <sys_page_unmap>
	return r;
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	eb b7                	jmp    80193d <dup+0xa3>

00801986 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	53                   	push   %ebx
  80198a:	83 ec 1c             	sub    $0x1c,%esp
  80198d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801990:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	53                   	push   %ebx
  801995:	e8 7c fd ff ff       	call   801716 <fd_lookup>
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 3f                	js     8019e0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ab:	ff 30                	pushl  (%eax)
  8019ad:	e8 b4 fd ff ff       	call   801766 <dev_lookup>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 27                	js     8019e0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bc:	8b 42 08             	mov    0x8(%edx),%eax
  8019bf:	83 e0 03             	and    $0x3,%eax
  8019c2:	83 f8 01             	cmp    $0x1,%eax
  8019c5:	74 1e                	je     8019e5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ca:	8b 40 08             	mov    0x8(%eax),%eax
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	74 35                	je     801a06 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	52                   	push   %edx
  8019db:	ff d0                	call   *%eax
  8019dd:	83 c4 10             	add    $0x10,%esp
}
  8019e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e5:	a1 20 54 80 00       	mov    0x805420,%eax
  8019ea:	8b 40 48             	mov    0x48(%eax),%eax
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	53                   	push   %ebx
  8019f1:	50                   	push   %eax
  8019f2:	68 c9 32 80 00       	push   $0x8032c9
  8019f7:	e8 80 e9 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a04:	eb da                	jmp    8019e0 <read+0x5a>
		return -E_NOT_SUPP;
  801a06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0b:	eb d3                	jmp    8019e0 <read+0x5a>

00801a0d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	57                   	push   %edi
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	83 ec 0c             	sub    $0xc,%esp
  801a16:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a19:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a21:	39 f3                	cmp    %esi,%ebx
  801a23:	73 23                	jae    801a48 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	89 f0                	mov    %esi,%eax
  801a2a:	29 d8                	sub    %ebx,%eax
  801a2c:	50                   	push   %eax
  801a2d:	89 d8                	mov    %ebx,%eax
  801a2f:	03 45 0c             	add    0xc(%ebp),%eax
  801a32:	50                   	push   %eax
  801a33:	57                   	push   %edi
  801a34:	e8 4d ff ff ff       	call   801986 <read>
		if (m < 0)
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 06                	js     801a46 <readn+0x39>
			return m;
		if (m == 0)
  801a40:	74 06                	je     801a48 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a42:	01 c3                	add    %eax,%ebx
  801a44:	eb db                	jmp    801a21 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a46:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5f                   	pop    %edi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 1c             	sub    $0x1c,%esp
  801a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5f:	50                   	push   %eax
  801a60:	53                   	push   %ebx
  801a61:	e8 b0 fc ff ff       	call   801716 <fd_lookup>
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 3a                	js     801aa7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a73:	50                   	push   %eax
  801a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a77:	ff 30                	pushl  (%eax)
  801a79:	e8 e8 fc ff ff       	call   801766 <dev_lookup>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 22                	js     801aa7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a88:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8c:	74 1e                	je     801aac <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a91:	8b 52 0c             	mov    0xc(%edx),%edx
  801a94:	85 d2                	test   %edx,%edx
  801a96:	74 35                	je     801acd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	ff 75 10             	pushl  0x10(%ebp)
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	ff d2                	call   *%edx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aac:	a1 20 54 80 00       	mov    0x805420,%eax
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	50                   	push   %eax
  801ab9:	68 e5 32 80 00       	push   $0x8032e5
  801abe:	e8 b9 e8 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acb:	eb da                	jmp    801aa7 <write+0x55>
		return -E_NOT_SUPP;
  801acd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad2:	eb d3                	jmp    801aa7 <write+0x55>

00801ad4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ada:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801add:	50                   	push   %eax
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	e8 30 fc ff ff       	call   801716 <fd_lookup>
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	78 0e                	js     801afb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	53                   	push   %ebx
  801b01:	83 ec 1c             	sub    $0x1c,%esp
  801b04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b07:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	53                   	push   %ebx
  801b0c:	e8 05 fc ff ff       	call   801716 <fd_lookup>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 37                	js     801b4f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1e:	50                   	push   %eax
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	ff 30                	pushl  (%eax)
  801b24:	e8 3d fc ff ff       	call   801766 <dev_lookup>
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	78 1f                	js     801b4f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b37:	74 1b                	je     801b54 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3c:	8b 52 18             	mov    0x18(%edx),%edx
  801b3f:	85 d2                	test   %edx,%edx
  801b41:	74 32                	je     801b75 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	50                   	push   %eax
  801b4a:	ff d2                	call   *%edx
  801b4c:	83 c4 10             	add    $0x10,%esp
}
  801b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b54:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b59:	8b 40 48             	mov    0x48(%eax),%eax
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	53                   	push   %ebx
  801b60:	50                   	push   %eax
  801b61:	68 a8 32 80 00       	push   $0x8032a8
  801b66:	e8 11 e8 ff ff       	call   80037c <cprintf>
		return -E_INVAL;
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b73:	eb da                	jmp    801b4f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7a:	eb d3                	jmp    801b4f <ftruncate+0x52>

00801b7c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 1c             	sub    $0x1c,%esp
  801b83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b89:	50                   	push   %eax
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	e8 84 fb ff ff       	call   801716 <fd_lookup>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 4b                	js     801be4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9f:	50                   	push   %eax
  801ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba3:	ff 30                	pushl  (%eax)
  801ba5:	e8 bc fb ff ff       	call   801766 <dev_lookup>
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 33                	js     801be4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bb8:	74 2f                	je     801be9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bba:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bbd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bc4:	00 00 00 
	stat->st_isdir = 0;
  801bc7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bce:	00 00 00 
	stat->st_dev = dev;
  801bd1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bd7:	83 ec 08             	sub    $0x8,%esp
  801bda:	53                   	push   %ebx
  801bdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801bde:	ff 50 14             	call   *0x14(%eax)
  801be1:	83 c4 10             	add    $0x10,%esp
}
  801be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    
		return -E_NOT_SUPP;
  801be9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bee:	eb f4                	jmp    801be4 <fstat+0x68>

00801bf0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bf5:	83 ec 08             	sub    $0x8,%esp
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	e8 22 02 00 00       	call   801e24 <open>
  801c02:	89 c3                	mov    %eax,%ebx
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 1b                	js     801c26 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c0b:	83 ec 08             	sub    $0x8,%esp
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	50                   	push   %eax
  801c12:	e8 65 ff ff ff       	call   801b7c <fstat>
  801c17:	89 c6                	mov    %eax,%esi
	close(fd);
  801c19:	89 1c 24             	mov    %ebx,(%esp)
  801c1c:	e8 27 fc ff ff       	call   801848 <close>
	return r;
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	89 f3                	mov    %esi,%ebx
}
  801c26:	89 d8                	mov    %ebx,%eax
  801c28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    

00801c2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	89 c6                	mov    %eax,%esi
  801c36:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c38:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c3f:	74 27                	je     801c68 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c41:	6a 07                	push   $0x7
  801c43:	68 00 60 80 00       	push   $0x806000
  801c48:	56                   	push   %esi
  801c49:	ff 35 00 50 80 00    	pushl  0x805000
  801c4f:	e8 ec 0c 00 00       	call   802940 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c54:	83 c4 0c             	add    $0xc,%esp
  801c57:	6a 00                	push   $0x0
  801c59:	53                   	push   %ebx
  801c5a:	6a 00                	push   $0x0
  801c5c:	e8 76 0c 00 00       	call   8028d7 <ipc_recv>
}
  801c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c68:	83 ec 0c             	sub    $0xc,%esp
  801c6b:	6a 01                	push   $0x1
  801c6d:	e8 26 0d 00 00       	call   802998 <ipc_find_env>
  801c72:	a3 00 50 80 00       	mov    %eax,0x805000
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	eb c5                	jmp    801c41 <fsipc+0x12>

00801c7c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	8b 40 0c             	mov    0xc(%eax),%eax
  801c88:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c95:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9a:	b8 02 00 00 00       	mov    $0x2,%eax
  801c9f:	e8 8b ff ff ff       	call   801c2f <fsipc>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <devfile_flush>:
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc1:	e8 69 ff ff ff       	call   801c2f <fsipc>
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <devfile_stat>:
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce2:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce7:	e8 43 ff ff ff       	call   801c2f <fsipc>
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 2c                	js     801d1c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cf0:	83 ec 08             	sub    $0x8,%esp
  801cf3:	68 00 60 80 00       	push   $0x806000
  801cf8:	53                   	push   %ebx
  801cf9:	e8 dd ed ff ff       	call   800adb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cfe:	a1 80 60 80 00       	mov    0x806080,%eax
  801d03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d09:	a1 84 60 80 00       	mov    0x806084,%eax
  801d0e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <devfile_write>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d36:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d3c:	53                   	push   %ebx
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	68 08 60 80 00       	push   $0x806008
  801d45:	e8 81 ef ff ff       	call   800ccb <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4f:	b8 04 00 00 00       	mov    $0x4,%eax
  801d54:	e8 d6 fe ff ff       	call   801c2f <fsipc>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 0b                	js     801d6b <devfile_write+0x4a>
	assert(r <= n);
  801d60:	39 d8                	cmp    %ebx,%eax
  801d62:	77 0c                	ja     801d70 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d64:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d69:	7f 1e                	jg     801d89 <devfile_write+0x68>
}
  801d6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    
	assert(r <= n);
  801d70:	68 18 33 80 00       	push   $0x803318
  801d75:	68 1f 33 80 00       	push   $0x80331f
  801d7a:	68 98 00 00 00       	push   $0x98
  801d7f:	68 34 33 80 00       	push   $0x803334
  801d84:	e8 fd e4 ff ff       	call   800286 <_panic>
	assert(r <= PGSIZE);
  801d89:	68 3f 33 80 00       	push   $0x80333f
  801d8e:	68 1f 33 80 00       	push   $0x80331f
  801d93:	68 99 00 00 00       	push   $0x99
  801d98:	68 34 33 80 00       	push   $0x803334
  801d9d:	e8 e4 e4 ff ff       	call   800286 <_panic>

00801da2 <devfile_read>:
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	8b 40 0c             	mov    0xc(%eax),%eax
  801db0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801db5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc0:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc5:	e8 65 fe ff ff       	call   801c2f <fsipc>
  801dca:	89 c3                	mov    %eax,%ebx
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 1f                	js     801def <devfile_read+0x4d>
	assert(r <= n);
  801dd0:	39 f0                	cmp    %esi,%eax
  801dd2:	77 24                	ja     801df8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dd4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dd9:	7f 33                	jg     801e0e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ddb:	83 ec 04             	sub    $0x4,%esp
  801dde:	50                   	push   %eax
  801ddf:	68 00 60 80 00       	push   $0x806000
  801de4:	ff 75 0c             	pushl  0xc(%ebp)
  801de7:	e8 7d ee ff ff       	call   800c69 <memmove>
	return r;
  801dec:	83 c4 10             	add    $0x10,%esp
}
  801def:	89 d8                	mov    %ebx,%eax
  801df1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
	assert(r <= n);
  801df8:	68 18 33 80 00       	push   $0x803318
  801dfd:	68 1f 33 80 00       	push   $0x80331f
  801e02:	6a 7c                	push   $0x7c
  801e04:	68 34 33 80 00       	push   $0x803334
  801e09:	e8 78 e4 ff ff       	call   800286 <_panic>
	assert(r <= PGSIZE);
  801e0e:	68 3f 33 80 00       	push   $0x80333f
  801e13:	68 1f 33 80 00       	push   $0x80331f
  801e18:	6a 7d                	push   $0x7d
  801e1a:	68 34 33 80 00       	push   $0x803334
  801e1f:	e8 62 e4 ff ff       	call   800286 <_panic>

00801e24 <open>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 1c             	sub    $0x1c,%esp
  801e2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e2f:	56                   	push   %esi
  801e30:	e8 6d ec ff ff       	call   800aa2 <strlen>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e3d:	7f 6c                	jg     801eab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e45:	50                   	push   %eax
  801e46:	e8 79 f8 ff ff       	call   8016c4 <fd_alloc>
  801e4b:	89 c3                	mov    %eax,%ebx
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 3c                	js     801e90 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e54:	83 ec 08             	sub    $0x8,%esp
  801e57:	56                   	push   %esi
  801e58:	68 00 60 80 00       	push   $0x806000
  801e5d:	e8 79 ec ff ff       	call   800adb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e65:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e72:	e8 b8 fd ff ff       	call   801c2f <fsipc>
  801e77:	89 c3                	mov    %eax,%ebx
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	78 19                	js     801e99 <open+0x75>
	return fd2num(fd);
  801e80:	83 ec 0c             	sub    $0xc,%esp
  801e83:	ff 75 f4             	pushl  -0xc(%ebp)
  801e86:	e8 12 f8 ff ff       	call   80169d <fd2num>
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	83 c4 10             	add    $0x10,%esp
}
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
		fd_close(fd, 0);
  801e99:	83 ec 08             	sub    $0x8,%esp
  801e9c:	6a 00                	push   $0x0
  801e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea1:	e8 1b f9 ff ff       	call   8017c1 <fd_close>
		return r;
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	eb e5                	jmp    801e90 <open+0x6c>
		return -E_BAD_PATH;
  801eab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eb0:	eb de                	jmp    801e90 <open+0x6c>

00801eb2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebd:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec2:	e8 68 fd ff ff       	call   801c2f <fsipc>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ecf:	68 4b 33 80 00       	push   $0x80334b
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	e8 ff eb ff ff       	call   800adb <strcpy>
	return 0;
}
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <devsock_close>:
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	53                   	push   %ebx
  801ee7:	83 ec 10             	sub    $0x10,%esp
  801eea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eed:	53                   	push   %ebx
  801eee:	e8 e0 0a 00 00       	call   8029d3 <pageref>
  801ef3:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ef6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801efb:	83 f8 01             	cmp    $0x1,%eax
  801efe:	74 07                	je     801f07 <devsock_close+0x24>
}
  801f00:	89 d0                	mov    %edx,%eax
  801f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	ff 73 0c             	pushl  0xc(%ebx)
  801f0d:	e8 b9 02 00 00       	call   8021cb <nsipc_close>
  801f12:	89 c2                	mov    %eax,%edx
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	eb e7                	jmp    801f00 <devsock_close+0x1d>

00801f19 <devsock_write>:
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	ff 75 10             	pushl  0x10(%ebp)
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	ff 70 0c             	pushl  0xc(%eax)
  801f2d:	e8 76 03 00 00       	call   8022a8 <nsipc_send>
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <devsock_read>:
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	ff 75 10             	pushl  0x10(%ebp)
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	ff 70 0c             	pushl  0xc(%eax)
  801f48:	e8 ef 02 00 00       	call   80223c <nsipc_recv>
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <fd2sockid>:
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f55:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	e8 b7 f7 ff ff       	call   801716 <fd_lookup>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	78 10                	js     801f76 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f6f:	39 08                	cmp    %ecx,(%eax)
  801f71:	75 05                	jne    801f78 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f73:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    
		return -E_NOT_SUPP;
  801f78:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f7d:	eb f7                	jmp    801f76 <fd2sockid+0x27>

00801f7f <alloc_sockfd>:
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 1c             	sub    $0x1c,%esp
  801f87:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	e8 32 f7 ff ff       	call   8016c4 <fd_alloc>
  801f92:	89 c3                	mov    %eax,%ebx
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 43                	js     801fde <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	68 07 04 00 00       	push   $0x407
  801fa3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa6:	6a 00                	push   $0x0
  801fa8:	e8 20 ef ff ff       	call   800ecd <sys_page_alloc>
  801fad:	89 c3                	mov    %eax,%ebx
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 28                	js     801fde <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fbf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fcb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	50                   	push   %eax
  801fd2:	e8 c6 f6 ff ff       	call   80169d <fd2num>
  801fd7:	89 c3                	mov    %eax,%ebx
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	eb 0c                	jmp    801fea <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	56                   	push   %esi
  801fe2:	e8 e4 01 00 00       	call   8021cb <nsipc_close>
		return r;
  801fe7:	83 c4 10             	add    $0x10,%esp
}
  801fea:	89 d8                	mov    %ebx,%eax
  801fec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    

00801ff3 <accept>:
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	e8 4e ff ff ff       	call   801f4f <fd2sockid>
  802001:	85 c0                	test   %eax,%eax
  802003:	78 1b                	js     802020 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	50                   	push   %eax
  80200f:	e8 0e 01 00 00       	call   802122 <nsipc_accept>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 05                	js     802020 <accept+0x2d>
	return alloc_sockfd(r);
  80201b:	e8 5f ff ff ff       	call   801f7f <alloc_sockfd>
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <bind>:
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	e8 1f ff ff ff       	call   801f4f <fd2sockid>
  802030:	85 c0                	test   %eax,%eax
  802032:	78 12                	js     802046 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	ff 75 10             	pushl  0x10(%ebp)
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	50                   	push   %eax
  80203e:	e8 31 01 00 00       	call   802174 <nsipc_bind>
  802043:	83 c4 10             	add    $0x10,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <shutdown>:
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	e8 f9 fe ff ff       	call   801f4f <fd2sockid>
  802056:	85 c0                	test   %eax,%eax
  802058:	78 0f                	js     802069 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80205a:	83 ec 08             	sub    $0x8,%esp
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	50                   	push   %eax
  802061:	e8 43 01 00 00       	call   8021a9 <nsipc_shutdown>
  802066:	83 c4 10             	add    $0x10,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <connect>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	e8 d6 fe ff ff       	call   801f4f <fd2sockid>
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 12                	js     80208f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	ff 75 10             	pushl  0x10(%ebp)
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	50                   	push   %eax
  802087:	e8 59 01 00 00       	call   8021e5 <nsipc_connect>
  80208c:	83 c4 10             	add    $0x10,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <listen>:
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	e8 b0 fe ff ff       	call   801f4f <fd2sockid>
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 0f                	js     8020b2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	50                   	push   %eax
  8020aa:	e8 6b 01 00 00       	call   80221a <nsipc_listen>
  8020af:	83 c4 10             	add    $0x10,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	e8 3e 02 00 00       	call   802306 <nsipc_socket>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 05                	js     8020d4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020cf:	e8 ab fe ff ff       	call   801f7f <alloc_sockfd>
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020df:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020e6:	74 26                	je     80210e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020e8:	6a 07                	push   $0x7
  8020ea:	68 00 70 80 00       	push   $0x807000
  8020ef:	53                   	push   %ebx
  8020f0:	ff 35 04 50 80 00    	pushl  0x805004
  8020f6:	e8 45 08 00 00       	call   802940 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020fb:	83 c4 0c             	add    $0xc,%esp
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	e8 ce 07 00 00       	call   8028d7 <ipc_recv>
}
  802109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	6a 02                	push   $0x2
  802113:	e8 80 08 00 00       	call   802998 <ipc_find_env>
  802118:	a3 04 50 80 00       	mov    %eax,0x805004
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	eb c6                	jmp    8020e8 <nsipc+0x12>

00802122 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	56                   	push   %esi
  802126:	53                   	push   %ebx
  802127:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802132:	8b 06                	mov    (%esi),%eax
  802134:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	e8 93 ff ff ff       	call   8020d6 <nsipc>
  802143:	89 c3                	mov    %eax,%ebx
  802145:	85 c0                	test   %eax,%eax
  802147:	79 09                	jns    802152 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802149:	89 d8                	mov    %ebx,%eax
  80214b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	ff 35 10 70 80 00    	pushl  0x807010
  80215b:	68 00 70 80 00       	push   $0x807000
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	e8 01 eb ff ff       	call   800c69 <memmove>
		*addrlen = ret->ret_addrlen;
  802168:	a1 10 70 80 00       	mov    0x807010,%eax
  80216d:	89 06                	mov    %eax,(%esi)
  80216f:	83 c4 10             	add    $0x10,%esp
	return r;
  802172:	eb d5                	jmp    802149 <nsipc_accept+0x27>

00802174 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	53                   	push   %ebx
  802178:	83 ec 08             	sub    $0x8,%esp
  80217b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802186:	53                   	push   %ebx
  802187:	ff 75 0c             	pushl  0xc(%ebp)
  80218a:	68 04 70 80 00       	push   $0x807004
  80218f:	e8 d5 ea ff ff       	call   800c69 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802194:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80219a:	b8 02 00 00 00       	mov    $0x2,%eax
  80219f:	e8 32 ff ff ff       	call   8020d6 <nsipc>
}
  8021a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8021c4:	e8 0d ff ff ff       	call   8020d6 <nsipc>
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <nsipc_close>:

int
nsipc_close(int s)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8021de:	e8 f3 fe ff ff       	call   8020d6 <nsipc>
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	53                   	push   %ebx
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021f7:	53                   	push   %ebx
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	68 04 70 80 00       	push   $0x807004
  802200:	e8 64 ea ff ff       	call   800c69 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802205:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80220b:	b8 05 00 00 00       	mov    $0x5,%eax
  802210:	e8 c1 fe ff ff       	call   8020d6 <nsipc>
}
  802215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802230:	b8 06 00 00 00       	mov    $0x6,%eax
  802235:	e8 9c fe ff ff       	call   8020d6 <nsipc>
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	56                   	push   %esi
  802240:	53                   	push   %ebx
  802241:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80224c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802252:	8b 45 14             	mov    0x14(%ebp),%eax
  802255:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80225a:	b8 07 00 00 00       	mov    $0x7,%eax
  80225f:	e8 72 fe ff ff       	call   8020d6 <nsipc>
  802264:	89 c3                	mov    %eax,%ebx
  802266:	85 c0                	test   %eax,%eax
  802268:	78 1f                	js     802289 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80226a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80226f:	7f 21                	jg     802292 <nsipc_recv+0x56>
  802271:	39 c6                	cmp    %eax,%esi
  802273:	7c 1d                	jl     802292 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	50                   	push   %eax
  802279:	68 00 70 80 00       	push   $0x807000
  80227e:	ff 75 0c             	pushl  0xc(%ebp)
  802281:	e8 e3 e9 ff ff       	call   800c69 <memmove>
  802286:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802289:	89 d8                	mov    %ebx,%eax
  80228b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802292:	68 57 33 80 00       	push   $0x803357
  802297:	68 1f 33 80 00       	push   $0x80331f
  80229c:	6a 62                	push   $0x62
  80229e:	68 6c 33 80 00       	push   $0x80336c
  8022a3:	e8 de df ff ff       	call   800286 <_panic>

008022a8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	53                   	push   %ebx
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022ba:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022c0:	7f 2e                	jg     8022f0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	53                   	push   %ebx
  8022c6:	ff 75 0c             	pushl  0xc(%ebp)
  8022c9:	68 0c 70 80 00       	push   $0x80700c
  8022ce:	e8 96 e9 ff ff       	call   800c69 <memmove>
	nsipcbuf.send.req_size = size;
  8022d3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022dc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e6:	e8 eb fd ff ff       	call   8020d6 <nsipc>
}
  8022eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    
	assert(size < 1600);
  8022f0:	68 78 33 80 00       	push   $0x803378
  8022f5:	68 1f 33 80 00       	push   $0x80331f
  8022fa:	6a 6d                	push   $0x6d
  8022fc:	68 6c 33 80 00       	push   $0x80336c
  802301:	e8 80 df ff ff       	call   800286 <_panic>

00802306 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80231c:	8b 45 10             	mov    0x10(%ebp),%eax
  80231f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802324:	b8 09 00 00 00       	mov    $0x9,%eax
  802329:	e8 a8 fd ff ff       	call   8020d6 <nsipc>
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	56                   	push   %esi
  802334:	53                   	push   %ebx
  802335:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	ff 75 08             	pushl  0x8(%ebp)
  80233e:	e8 6a f3 ff ff       	call   8016ad <fd2data>
  802343:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802345:	83 c4 08             	add    $0x8,%esp
  802348:	68 84 33 80 00       	push   $0x803384
  80234d:	53                   	push   %ebx
  80234e:	e8 88 e7 ff ff       	call   800adb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802353:	8b 46 04             	mov    0x4(%esi),%eax
  802356:	2b 06                	sub    (%esi),%eax
  802358:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80235e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802365:	00 00 00 
	stat->st_dev = &devpipe;
  802368:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80236f:	40 80 00 
	return 0;
}
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
  802377:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237a:	5b                   	pop    %ebx
  80237b:	5e                   	pop    %esi
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    

0080237e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	53                   	push   %ebx
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802388:	53                   	push   %ebx
  802389:	6a 00                	push   $0x0
  80238b:	e8 c2 eb ff ff       	call   800f52 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802390:	89 1c 24             	mov    %ebx,(%esp)
  802393:	e8 15 f3 ff ff       	call   8016ad <fd2data>
  802398:	83 c4 08             	add    $0x8,%esp
  80239b:	50                   	push   %eax
  80239c:	6a 00                	push   $0x0
  80239e:	e8 af eb ff ff       	call   800f52 <sys_page_unmap>
}
  8023a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <_pipeisclosed>:
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	57                   	push   %edi
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 1c             	sub    $0x1c,%esp
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023b5:	a1 20 54 80 00       	mov    0x805420,%eax
  8023ba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	57                   	push   %edi
  8023c1:	e8 0d 06 00 00       	call   8029d3 <pageref>
  8023c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023c9:	89 34 24             	mov    %esi,(%esp)
  8023cc:	e8 02 06 00 00       	call   8029d3 <pageref>
		nn = thisenv->env_runs;
  8023d1:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8023d7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	39 cb                	cmp    %ecx,%ebx
  8023df:	74 1b                	je     8023fc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023e1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023e4:	75 cf                	jne    8023b5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e6:	8b 42 58             	mov    0x58(%edx),%eax
  8023e9:	6a 01                	push   $0x1
  8023eb:	50                   	push   %eax
  8023ec:	53                   	push   %ebx
  8023ed:	68 8b 33 80 00       	push   $0x80338b
  8023f2:	e8 85 df ff ff       	call   80037c <cprintf>
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	eb b9                	jmp    8023b5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023ff:	0f 94 c0             	sete   %al
  802402:	0f b6 c0             	movzbl %al,%eax
}
  802405:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802408:	5b                   	pop    %ebx
  802409:	5e                   	pop    %esi
  80240a:	5f                   	pop    %edi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    

0080240d <devpipe_write>:
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	57                   	push   %edi
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	83 ec 28             	sub    $0x28,%esp
  802416:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802419:	56                   	push   %esi
  80241a:	e8 8e f2 ff ff       	call   8016ad <fd2data>
  80241f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	bf 00 00 00 00       	mov    $0x0,%edi
  802429:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80242c:	74 4f                	je     80247d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80242e:	8b 43 04             	mov    0x4(%ebx),%eax
  802431:	8b 0b                	mov    (%ebx),%ecx
  802433:	8d 51 20             	lea    0x20(%ecx),%edx
  802436:	39 d0                	cmp    %edx,%eax
  802438:	72 14                	jb     80244e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80243a:	89 da                	mov    %ebx,%edx
  80243c:	89 f0                	mov    %esi,%eax
  80243e:	e8 65 ff ff ff       	call   8023a8 <_pipeisclosed>
  802443:	85 c0                	test   %eax,%eax
  802445:	75 3b                	jne    802482 <devpipe_write+0x75>
			sys_yield();
  802447:	e8 62 ea ff ff       	call   800eae <sys_yield>
  80244c:	eb e0                	jmp    80242e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80244e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802451:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802455:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802458:	89 c2                	mov    %eax,%edx
  80245a:	c1 fa 1f             	sar    $0x1f,%edx
  80245d:	89 d1                	mov    %edx,%ecx
  80245f:	c1 e9 1b             	shr    $0x1b,%ecx
  802462:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802465:	83 e2 1f             	and    $0x1f,%edx
  802468:	29 ca                	sub    %ecx,%edx
  80246a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80246e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802472:	83 c0 01             	add    $0x1,%eax
  802475:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802478:	83 c7 01             	add    $0x1,%edi
  80247b:	eb ac                	jmp    802429 <devpipe_write+0x1c>
	return i;
  80247d:	8b 45 10             	mov    0x10(%ebp),%eax
  802480:	eb 05                	jmp    802487 <devpipe_write+0x7a>
				return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <devpipe_read>:
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	57                   	push   %edi
  802493:	56                   	push   %esi
  802494:	53                   	push   %ebx
  802495:	83 ec 18             	sub    $0x18,%esp
  802498:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80249b:	57                   	push   %edi
  80249c:	e8 0c f2 ff ff       	call   8016ad <fd2data>
  8024a1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a3:	83 c4 10             	add    $0x10,%esp
  8024a6:	be 00 00 00 00       	mov    $0x0,%esi
  8024ab:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024ae:	75 14                	jne    8024c4 <devpipe_read+0x35>
	return i;
  8024b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b3:	eb 02                	jmp    8024b7 <devpipe_read+0x28>
				return i;
  8024b5:	89 f0                	mov    %esi,%eax
}
  8024b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ba:	5b                   	pop    %ebx
  8024bb:	5e                   	pop    %esi
  8024bc:	5f                   	pop    %edi
  8024bd:	5d                   	pop    %ebp
  8024be:	c3                   	ret    
			sys_yield();
  8024bf:	e8 ea e9 ff ff       	call   800eae <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024c4:	8b 03                	mov    (%ebx),%eax
  8024c6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024c9:	75 18                	jne    8024e3 <devpipe_read+0x54>
			if (i > 0)
  8024cb:	85 f6                	test   %esi,%esi
  8024cd:	75 e6                	jne    8024b5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024cf:	89 da                	mov    %ebx,%edx
  8024d1:	89 f8                	mov    %edi,%eax
  8024d3:	e8 d0 fe ff ff       	call   8023a8 <_pipeisclosed>
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 e3                	je     8024bf <devpipe_read+0x30>
				return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	eb d4                	jmp    8024b7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024e3:	99                   	cltd   
  8024e4:	c1 ea 1b             	shr    $0x1b,%edx
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	83 e0 1f             	and    $0x1f,%eax
  8024ec:	29 d0                	sub    %edx,%eax
  8024ee:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024f6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024f9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024fc:	83 c6 01             	add    $0x1,%esi
  8024ff:	eb aa                	jmp    8024ab <devpipe_read+0x1c>

00802501 <pipe>:
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	56                   	push   %esi
  802505:	53                   	push   %ebx
  802506:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802509:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80250c:	50                   	push   %eax
  80250d:	e8 b2 f1 ff ff       	call   8016c4 <fd_alloc>
  802512:	89 c3                	mov    %eax,%ebx
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	85 c0                	test   %eax,%eax
  802519:	0f 88 23 01 00 00    	js     802642 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	68 07 04 00 00       	push   $0x407
  802527:	ff 75 f4             	pushl  -0xc(%ebp)
  80252a:	6a 00                	push   $0x0
  80252c:	e8 9c e9 ff ff       	call   800ecd <sys_page_alloc>
  802531:	89 c3                	mov    %eax,%ebx
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	85 c0                	test   %eax,%eax
  802538:	0f 88 04 01 00 00    	js     802642 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802544:	50                   	push   %eax
  802545:	e8 7a f1 ff ff       	call   8016c4 <fd_alloc>
  80254a:	89 c3                	mov    %eax,%ebx
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	0f 88 db 00 00 00    	js     802632 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 07 04 00 00       	push   $0x407
  80255f:	ff 75 f0             	pushl  -0x10(%ebp)
  802562:	6a 00                	push   $0x0
  802564:	e8 64 e9 ff ff       	call   800ecd <sys_page_alloc>
  802569:	89 c3                	mov    %eax,%ebx
  80256b:	83 c4 10             	add    $0x10,%esp
  80256e:	85 c0                	test   %eax,%eax
  802570:	0f 88 bc 00 00 00    	js     802632 <pipe+0x131>
	va = fd2data(fd0);
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	ff 75 f4             	pushl  -0xc(%ebp)
  80257c:	e8 2c f1 ff ff       	call   8016ad <fd2data>
  802581:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802583:	83 c4 0c             	add    $0xc,%esp
  802586:	68 07 04 00 00       	push   $0x407
  80258b:	50                   	push   %eax
  80258c:	6a 00                	push   $0x0
  80258e:	e8 3a e9 ff ff       	call   800ecd <sys_page_alloc>
  802593:	89 c3                	mov    %eax,%ebx
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 82 00 00 00    	js     802622 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a6:	e8 02 f1 ff ff       	call   8016ad <fd2data>
  8025ab:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025b2:	50                   	push   %eax
  8025b3:	6a 00                	push   $0x0
  8025b5:	56                   	push   %esi
  8025b6:	6a 00                	push   $0x0
  8025b8:	e8 53 e9 ff ff       	call   800f10 <sys_page_map>
  8025bd:	89 c3                	mov    %eax,%ebx
  8025bf:	83 c4 20             	add    $0x20,%esp
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	78 4e                	js     802614 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025c6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ce:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025dd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ef:	e8 a9 f0 ff ff       	call   80169d <fd2num>
  8025f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025f9:	83 c4 04             	add    $0x4,%esp
  8025fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ff:	e8 99 f0 ff ff       	call   80169d <fd2num>
  802604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802607:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802612:	eb 2e                	jmp    802642 <pipe+0x141>
	sys_page_unmap(0, va);
  802614:	83 ec 08             	sub    $0x8,%esp
  802617:	56                   	push   %esi
  802618:	6a 00                	push   $0x0
  80261a:	e8 33 e9 ff ff       	call   800f52 <sys_page_unmap>
  80261f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802622:	83 ec 08             	sub    $0x8,%esp
  802625:	ff 75 f0             	pushl  -0x10(%ebp)
  802628:	6a 00                	push   $0x0
  80262a:	e8 23 e9 ff ff       	call   800f52 <sys_page_unmap>
  80262f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802632:	83 ec 08             	sub    $0x8,%esp
  802635:	ff 75 f4             	pushl  -0xc(%ebp)
  802638:	6a 00                	push   $0x0
  80263a:	e8 13 e9 ff ff       	call   800f52 <sys_page_unmap>
  80263f:	83 c4 10             	add    $0x10,%esp
}
  802642:	89 d8                	mov    %ebx,%eax
  802644:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5d                   	pop    %ebp
  80264a:	c3                   	ret    

0080264b <pipeisclosed>:
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802654:	50                   	push   %eax
  802655:	ff 75 08             	pushl  0x8(%ebp)
  802658:	e8 b9 f0 ff ff       	call   801716 <fd_lookup>
  80265d:	83 c4 10             	add    $0x10,%esp
  802660:	85 c0                	test   %eax,%eax
  802662:	78 18                	js     80267c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	ff 75 f4             	pushl  -0xc(%ebp)
  80266a:	e8 3e f0 ff ff       	call   8016ad <fd2data>
	return _pipeisclosed(fd, p);
  80266f:	89 c2                	mov    %eax,%edx
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	e8 2f fd ff ff       	call   8023a8 <_pipeisclosed>
  802679:	83 c4 10             	add    $0x10,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	56                   	push   %esi
  802682:	53                   	push   %ebx
  802683:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802686:	85 f6                	test   %esi,%esi
  802688:	74 13                	je     80269d <wait+0x1f>
	e = &envs[ENVX(envid)];
  80268a:	89 f3                	mov    %esi,%ebx
  80268c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802692:	c1 e3 07             	shl    $0x7,%ebx
  802695:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80269b:	eb 1b                	jmp    8026b8 <wait+0x3a>
	assert(envid != 0);
  80269d:	68 a3 33 80 00       	push   $0x8033a3
  8026a2:	68 1f 33 80 00       	push   $0x80331f
  8026a7:	6a 09                	push   $0x9
  8026a9:	68 ae 33 80 00       	push   $0x8033ae
  8026ae:	e8 d3 db ff ff       	call   800286 <_panic>
		sys_yield();
  8026b3:	e8 f6 e7 ff ff       	call   800eae <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026b8:	8b 43 48             	mov    0x48(%ebx),%eax
  8026bb:	39 f0                	cmp    %esi,%eax
  8026bd:	75 07                	jne    8026c6 <wait+0x48>
  8026bf:	8b 43 54             	mov    0x54(%ebx),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 ed                	jne    8026b3 <wait+0x35>
}
  8026c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026c9:	5b                   	pop    %ebx
  8026ca:	5e                   	pop    %esi
  8026cb:	5d                   	pop    %ebp
  8026cc:	c3                   	ret    

008026cd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d2:	c3                   	ret    

008026d3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026d9:	68 b9 33 80 00       	push   $0x8033b9
  8026de:	ff 75 0c             	pushl  0xc(%ebp)
  8026e1:	e8 f5 e3 ff ff       	call   800adb <strcpy>
	return 0;
}
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <devcons_write>:
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	57                   	push   %edi
  8026f1:	56                   	push   %esi
  8026f2:	53                   	push   %ebx
  8026f3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026f9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026fe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802704:	3b 75 10             	cmp    0x10(%ebp),%esi
  802707:	73 31                	jae    80273a <devcons_write+0x4d>
		m = n - tot;
  802709:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80270c:	29 f3                	sub    %esi,%ebx
  80270e:	83 fb 7f             	cmp    $0x7f,%ebx
  802711:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802716:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	53                   	push   %ebx
  80271d:	89 f0                	mov    %esi,%eax
  80271f:	03 45 0c             	add    0xc(%ebp),%eax
  802722:	50                   	push   %eax
  802723:	57                   	push   %edi
  802724:	e8 40 e5 ff ff       	call   800c69 <memmove>
		sys_cputs(buf, m);
  802729:	83 c4 08             	add    $0x8,%esp
  80272c:	53                   	push   %ebx
  80272d:	57                   	push   %edi
  80272e:	e8 de e6 ff ff       	call   800e11 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802733:	01 de                	add    %ebx,%esi
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	eb ca                	jmp    802704 <devcons_write+0x17>
}
  80273a:	89 f0                	mov    %esi,%eax
  80273c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80273f:	5b                   	pop    %ebx
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    

00802744 <devcons_read>:
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	83 ec 08             	sub    $0x8,%esp
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80274f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802753:	74 21                	je     802776 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802755:	e8 d5 e6 ff ff       	call   800e2f <sys_cgetc>
  80275a:	85 c0                	test   %eax,%eax
  80275c:	75 07                	jne    802765 <devcons_read+0x21>
		sys_yield();
  80275e:	e8 4b e7 ff ff       	call   800eae <sys_yield>
  802763:	eb f0                	jmp    802755 <devcons_read+0x11>
	if (c < 0)
  802765:	78 0f                	js     802776 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802767:	83 f8 04             	cmp    $0x4,%eax
  80276a:	74 0c                	je     802778 <devcons_read+0x34>
	*(char*)vbuf = c;
  80276c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276f:	88 02                	mov    %al,(%edx)
	return 1;
  802771:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    
		return 0;
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	eb f7                	jmp    802776 <devcons_read+0x32>

0080277f <cputchar>:
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80278b:	6a 01                	push   $0x1
  80278d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802790:	50                   	push   %eax
  802791:	e8 7b e6 ff ff       	call   800e11 <sys_cputs>
}
  802796:	83 c4 10             	add    $0x10,%esp
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <getchar>:
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027a1:	6a 01                	push   $0x1
  8027a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a6:	50                   	push   %eax
  8027a7:	6a 00                	push   $0x0
  8027a9:	e8 d8 f1 ff ff       	call   801986 <read>
	if (r < 0)
  8027ae:	83 c4 10             	add    $0x10,%esp
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	78 06                	js     8027bb <getchar+0x20>
	if (r < 1)
  8027b5:	74 06                	je     8027bd <getchar+0x22>
	return c;
  8027b7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    
		return -E_EOF;
  8027bd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027c2:	eb f7                	jmp    8027bb <getchar+0x20>

008027c4 <iscons>:
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027cd:	50                   	push   %eax
  8027ce:	ff 75 08             	pushl  0x8(%ebp)
  8027d1:	e8 40 ef ff ff       	call   801716 <fd_lookup>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	78 11                	js     8027ee <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027e6:	39 10                	cmp    %edx,(%eax)
  8027e8:	0f 94 c0             	sete   %al
  8027eb:	0f b6 c0             	movzbl %al,%eax
}
  8027ee:	c9                   	leave  
  8027ef:	c3                   	ret    

008027f0 <opencons>:
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f9:	50                   	push   %eax
  8027fa:	e8 c5 ee ff ff       	call   8016c4 <fd_alloc>
  8027ff:	83 c4 10             	add    $0x10,%esp
  802802:	85 c0                	test   %eax,%eax
  802804:	78 3a                	js     802840 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 07 04 00 00       	push   $0x407
  80280e:	ff 75 f4             	pushl  -0xc(%ebp)
  802811:	6a 00                	push   $0x0
  802813:	e8 b5 e6 ff ff       	call   800ecd <sys_page_alloc>
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	85 c0                	test   %eax,%eax
  80281d:	78 21                	js     802840 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802828:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802834:	83 ec 0c             	sub    $0xc,%esp
  802837:	50                   	push   %eax
  802838:	e8 60 ee ff ff       	call   80169d <fd2num>
  80283d:	83 c4 10             	add    $0x10,%esp
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802848:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80284f:	74 0a                	je     80285b <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	6a 07                	push   $0x7
  802860:	68 00 f0 bf ee       	push   $0xeebff000
  802865:	6a 00                	push   $0x0
  802867:	e8 61 e6 ff ff       	call   800ecd <sys_page_alloc>
		if(r < 0)
  80286c:	83 c4 10             	add    $0x10,%esp
  80286f:	85 c0                	test   %eax,%eax
  802871:	78 2a                	js     80289d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802873:	83 ec 08             	sub    $0x8,%esp
  802876:	68 b1 28 80 00       	push   $0x8028b1
  80287b:	6a 00                	push   $0x0
  80287d:	e8 96 e7 ff ff       	call   801018 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	79 c8                	jns    802851 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 f8 33 80 00       	push   $0x8033f8
  802891:	6a 25                	push   $0x25
  802893:	68 34 34 80 00       	push   $0x803434
  802898:	e8 e9 d9 ff ff       	call   800286 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	68 c8 33 80 00       	push   $0x8033c8
  8028a5:	6a 22                	push   $0x22
  8028a7:	68 34 34 80 00       	push   $0x803434
  8028ac:	e8 d5 d9 ff ff       	call   800286 <_panic>

008028b1 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028b1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028b2:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028b7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028b9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028bc:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028c0:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028c4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028c7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028c9:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028cd:	83 c4 08             	add    $0x8,%esp
	popal
  8028d0:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028d1:	83 c4 04             	add    $0x4,%esp
	popfl
  8028d4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028d5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028d6:	c3                   	ret    

008028d7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	56                   	push   %esi
  8028db:	53                   	push   %ebx
  8028dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8028df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028e5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028e7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028ec:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028ef:	83 ec 0c             	sub    $0xc,%esp
  8028f2:	50                   	push   %eax
  8028f3:	e8 85 e7 ff ff       	call   80107d <sys_ipc_recv>
	if(ret < 0){
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	78 2b                	js     80292a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028ff:	85 f6                	test   %esi,%esi
  802901:	74 0a                	je     80290d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802903:	a1 20 54 80 00       	mov    0x805420,%eax
  802908:	8b 40 74             	mov    0x74(%eax),%eax
  80290b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80290d:	85 db                	test   %ebx,%ebx
  80290f:	74 0a                	je     80291b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802911:	a1 20 54 80 00       	mov    0x805420,%eax
  802916:	8b 40 78             	mov    0x78(%eax),%eax
  802919:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80291b:	a1 20 54 80 00       	mov    0x805420,%eax
  802920:	8b 40 70             	mov    0x70(%eax),%eax
}
  802923:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802926:	5b                   	pop    %ebx
  802927:	5e                   	pop    %esi
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    
		if(from_env_store)
  80292a:	85 f6                	test   %esi,%esi
  80292c:	74 06                	je     802934 <ipc_recv+0x5d>
			*from_env_store = 0;
  80292e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802934:	85 db                	test   %ebx,%ebx
  802936:	74 eb                	je     802923 <ipc_recv+0x4c>
			*perm_store = 0;
  802938:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80293e:	eb e3                	jmp    802923 <ipc_recv+0x4c>

00802940 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	57                   	push   %edi
  802944:	56                   	push   %esi
  802945:	53                   	push   %ebx
  802946:	83 ec 0c             	sub    $0xc,%esp
  802949:	8b 7d 08             	mov    0x8(%ebp),%edi
  80294c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80294f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802952:	85 db                	test   %ebx,%ebx
  802954:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802959:	0f 44 d8             	cmove  %eax,%ebx
  80295c:	eb 05                	jmp    802963 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80295e:	e8 4b e5 ff ff       	call   800eae <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802963:	ff 75 14             	pushl  0x14(%ebp)
  802966:	53                   	push   %ebx
  802967:	56                   	push   %esi
  802968:	57                   	push   %edi
  802969:	e8 ec e6 ff ff       	call   80105a <sys_ipc_try_send>
  80296e:	83 c4 10             	add    $0x10,%esp
  802971:	85 c0                	test   %eax,%eax
  802973:	74 1b                	je     802990 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802975:	79 e7                	jns    80295e <ipc_send+0x1e>
  802977:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80297a:	74 e2                	je     80295e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	68 42 34 80 00       	push   $0x803442
  802984:	6a 48                	push   $0x48
  802986:	68 57 34 80 00       	push   $0x803457
  80298b:	e8 f6 d8 ff ff       	call   800286 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802990:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802993:	5b                   	pop    %ebx
  802994:	5e                   	pop    %esi
  802995:	5f                   	pop    %edi
  802996:	5d                   	pop    %ebp
  802997:	c3                   	ret    

00802998 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
  80299b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029a3:	89 c2                	mov    %eax,%edx
  8029a5:	c1 e2 07             	shl    $0x7,%edx
  8029a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029ae:	8b 52 50             	mov    0x50(%edx),%edx
  8029b1:	39 ca                	cmp    %ecx,%edx
  8029b3:	74 11                	je     8029c6 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029b5:	83 c0 01             	add    $0x1,%eax
  8029b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029bd:	75 e4                	jne    8029a3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	eb 0b                	jmp    8029d1 <ipc_find_env+0x39>
			return envs[i].env_id;
  8029c6:	c1 e0 07             	shl    $0x7,%eax
  8029c9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029ce:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029d1:	5d                   	pop    %ebp
  8029d2:	c3                   	ret    

008029d3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
  8029d6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029d9:	89 d0                	mov    %edx,%eax
  8029db:	c1 e8 16             	shr    $0x16,%eax
  8029de:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029e5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029ea:	f6 c1 01             	test   $0x1,%cl
  8029ed:	74 1d                	je     802a0c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029ef:	c1 ea 0c             	shr    $0xc,%edx
  8029f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029f9:	f6 c2 01             	test   $0x1,%dl
  8029fc:	74 0e                	je     802a0c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029fe:	c1 ea 0c             	shr    $0xc,%edx
  802a01:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a08:	ef 
  802a09:	0f b7 c0             	movzwl %ax,%eax
}
  802a0c:	5d                   	pop    %ebp
  802a0d:	c3                   	ret    
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
