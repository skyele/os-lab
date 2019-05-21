
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
  80003e:	68 a0 26 80 00       	push   $0x8026a0
  800043:	e8 75 1c 00 00       	call   801cbd <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 74 19 00 00       	call   8019d4 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 9a 18 00 00       	call   80190d <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 71 12 00 00       	call   8012f6 <fork>
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
  800097:	e8 38 19 00 00       	call   8019d4 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 10 27 80 00 	movl   $0x802710,(%esp)
  8000a3:	e8 bf 02 00 00       	call   800367 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 40 80 00       	push   $0x804020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 52 18 00 00       	call   80190d <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 40 80 00       	push   $0x804020
  8000cf:	68 20 42 80 00       	push   $0x804220
  8000d4:	e8 f3 0b 00 00       	call   800ccc <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 db 26 80 00       	push   $0x8026db
  8000ec:	e8 76 02 00 00       	call   800367 <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 d8 18 00 00       	call   8019d4 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 44 16 00 00       	call   801748 <close>
		exit();
  800104:	e8 56 01 00 00       	call   80025f <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 9b 1f 00 00       	call   8020b0 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 40 80 00       	push   $0x804020
  800122:	53                   	push   %ebx
  800123:	e8 e5 17 00 00       	call   80190d <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 f4 26 80 00       	push   $0x8026f4
  80013b:	e8 27 02 00 00       	call   800367 <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 00 16 00 00       	call   801748 <close>
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
  800155:	68 a5 26 80 00       	push   $0x8026a5
  80015a:	6a 0c                	push   $0xc
  80015c:	68 b3 26 80 00       	push   $0x8026b3
  800161:	e8 0b 01 00 00       	call   800271 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 c8 26 80 00       	push   $0x8026c8
  80016c:	6a 0f                	push   $0xf
  80016e:	68 b3 26 80 00       	push   $0x8026b3
  800173:	e8 f9 00 00 00       	call   800271 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 d2 26 80 00       	push   $0x8026d2
  80017e:	6a 12                	push   $0x12
  800180:	68 b3 26 80 00       	push   $0x8026b3
  800185:	e8 e7 00 00 00       	call   800271 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 54 27 80 00       	push   $0x802754
  800194:	6a 17                	push   $0x17
  800196:	68 b3 26 80 00       	push   $0x8026b3
  80019b:	e8 d1 00 00 00       	call   800271 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 80 27 80 00       	push   $0x802780
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 b3 26 80 00       	push   $0x8026b3
  8001af:	e8 bd 00 00 00       	call   800271 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 b8 27 80 00       	push   $0x8027b8
  8001be:	6a 21                	push   $0x21
  8001c0:	68 b3 26 80 00       	push   $0x8026b3
  8001c5:	e8 a7 00 00 00       	call   800271 <_panic>

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
  8001d3:	c7 05 20 44 80 00 00 	movl   $0x0,0x804420
  8001da:	00 00 00 
	envid_t find = sys_getenvid();
  8001dd:	e8 98 0c 00 00       	call   800e7a <sys_getenvid>
  8001e2:	8b 1d 20 44 80 00    	mov    0x804420,%ebx
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
  80022b:	89 1d 20 44 80 00    	mov    %ebx,0x804420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800231:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800235:	7e 0a                	jle    800241 <libmain+0x77>
		binaryname = argv[0];
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800241:	83 ec 08             	sub    $0x8,%esp
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 e4 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80024f:	e8 0b 00 00 00       	call   80025f <exit>
}
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5f                   	pop    %edi
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800265:	6a 00                	push   $0x0
  800267:	e8 cd 0b 00 00       	call   800e39 <sys_env_destroy>
}
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800276:	a1 20 44 80 00       	mov    0x804420,%eax
  80027b:	8b 40 48             	mov    0x48(%eax),%eax
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	68 14 28 80 00       	push   $0x802814
  800286:	50                   	push   %eax
  800287:	68 e5 27 80 00       	push   $0x8027e5
  80028c:	e8 d6 00 00 00       	call   800367 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800291:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800294:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029a:	e8 db 0b 00 00       	call   800e7a <sys_getenvid>
  80029f:	83 c4 04             	add    $0x4,%esp
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	56                   	push   %esi
  8002a9:	50                   	push   %eax
  8002aa:	68 f0 27 80 00       	push   $0x8027f0
  8002af:	e8 b3 00 00 00       	call   800367 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b4:	83 c4 18             	add    $0x18,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	ff 75 10             	pushl  0x10(%ebp)
  8002bb:	e8 56 00 00 00       	call   800316 <vcprintf>
	cprintf("\n");
  8002c0:	c7 04 24 19 2c 80 00 	movl   $0x802c19,(%esp)
  8002c7:	e8 9b 00 00 00       	call   800367 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cf:	cc                   	int3   
  8002d0:	eb fd                	jmp    8002cf <_panic+0x5e>

008002d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002dc:	8b 13                	mov    (%ebx),%edx
  8002de:	8d 42 01             	lea    0x1(%edx),%eax
  8002e1:	89 03                	mov    %eax,(%ebx)
  8002e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ef:	74 09                	je     8002fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	68 ff 00 00 00       	push   $0xff
  800302:	8d 43 08             	lea    0x8(%ebx),%eax
  800305:	50                   	push   %eax
  800306:	e8 f1 0a 00 00       	call   800dfc <sys_cputs>
		b->idx = 0;
  80030b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	eb db                	jmp    8002f1 <putch+0x1f>

00800316 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033f:	50                   	push   %eax
  800340:	68 d2 02 80 00       	push   $0x8002d2
  800345:	e8 4a 01 00 00       	call   800494 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034a:	83 c4 08             	add    $0x8,%esp
  80034d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800353:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	e8 9d 0a 00 00       	call   800dfc <sys_cputs>

	return b.cnt;
}
  80035f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 9d ff ff ff       	call   800316 <vcprintf>
	va_end(ap);

	return cnt;
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 1c             	sub    $0x1c,%esp
  800384:	89 c6                	mov    %eax,%esi
  800386:	89 d7                	mov    %edx,%edi
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800391:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800394:	8b 45 10             	mov    0x10(%ebp),%eax
  800397:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80039a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80039e:	74 2c                	je     8003cc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b0:	39 c2                	cmp    %eax,%edx
  8003b2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003b5:	73 43                	jae    8003fa <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	85 db                	test   %ebx,%ebx
  8003bc:	7e 6c                	jle    80042a <printnum+0xaf>
				putch(padc, putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	57                   	push   %edi
  8003c2:	ff 75 18             	pushl  0x18(%ebp)
  8003c5:	ff d6                	call   *%esi
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	eb eb                	jmp    8003b7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	6a 20                	push   $0x20
  8003d1:	6a 00                	push   $0x0
  8003d3:	50                   	push   %eax
  8003d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003da:	89 fa                	mov    %edi,%edx
  8003dc:	89 f0                	mov    %esi,%eax
  8003de:	e8 98 ff ff ff       	call   80037b <printnum>
		while (--width > 0)
  8003e3:	83 c4 20             	add    $0x20,%esp
  8003e6:	83 eb 01             	sub    $0x1,%ebx
  8003e9:	85 db                	test   %ebx,%ebx
  8003eb:	7e 65                	jle    800452 <printnum+0xd7>
			putch(padc, putdat);
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	57                   	push   %edi
  8003f1:	6a 20                	push   $0x20
  8003f3:	ff d6                	call   *%esi
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	eb ec                	jmp    8003e6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	83 eb 01             	sub    $0x1,%ebx
  800403:	53                   	push   %ebx
  800404:	50                   	push   %eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 dc             	pushl  -0x24(%ebp)
  80040b:	ff 75 d8             	pushl  -0x28(%ebp)
  80040e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800411:	ff 75 e0             	pushl  -0x20(%ebp)
  800414:	e8 27 20 00 00       	call   802440 <__udivdi3>
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	89 fa                	mov    %edi,%edx
  800420:	89 f0                	mov    %esi,%eax
  800422:	e8 54 ff ff ff       	call   80037b <printnum>
  800427:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	57                   	push   %edi
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	ff 75 dc             	pushl  -0x24(%ebp)
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	e8 0e 21 00 00       	call   802550 <__umoddi3>
  800442:	83 c4 14             	add    $0x14,%esp
  800445:	0f be 80 1b 28 80 00 	movsbl 0x80281b(%eax),%eax
  80044c:	50                   	push   %eax
  80044d:	ff d6                	call   *%esi
  80044f:	83 c4 10             	add    $0x10,%esp
	}
}
  800452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800455:	5b                   	pop    %ebx
  800456:	5e                   	pop    %esi
  800457:	5f                   	pop    %edi
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800460:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800464:	8b 10                	mov    (%eax),%edx
  800466:	3b 50 04             	cmp    0x4(%eax),%edx
  800469:	73 0a                	jae    800475 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	88 02                	mov    %al,(%edx)
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <printfmt>:
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80047d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800480:	50                   	push   %eax
  800481:	ff 75 10             	pushl  0x10(%ebp)
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 08             	pushl  0x8(%ebp)
  80048a:	e8 05 00 00 00       	call   800494 <vprintfmt>
}
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <vprintfmt>:
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 3c             	sub    $0x3c,%esp
  80049d:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a6:	e9 32 04 00 00       	jmp    8008dd <vprintfmt+0x449>
		padc = ' ';
  8004ab:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004af:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004b6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8d 47 01             	lea    0x1(%edi),%eax
  8004da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004dd:	0f b6 17             	movzbl (%edi),%edx
  8004e0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004e3:	3c 55                	cmp    $0x55,%al
  8004e5:	0f 87 12 05 00 00    	ja     8009fd <vprintfmt+0x569>
  8004eb:	0f b6 c0             	movzbl %al,%eax
  8004ee:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004f8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004fc:	eb d9                	jmp    8004d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800501:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800505:	eb d0                	jmp    8004d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800507:	0f b6 d2             	movzbl %dl,%edx
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	89 75 08             	mov    %esi,0x8(%ebp)
  800515:	eb 03                	jmp    80051a <vprintfmt+0x86>
  800517:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80051a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80051d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800521:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800524:	8d 72 d0             	lea    -0x30(%edx),%esi
  800527:	83 fe 09             	cmp    $0x9,%esi
  80052a:	76 eb                	jbe    800517 <vprintfmt+0x83>
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	8b 75 08             	mov    0x8(%ebp),%esi
  800532:	eb 14                	jmp    800548 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 40 04             	lea    0x4(%eax),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800548:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054c:	79 89                	jns    8004d7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80054e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800554:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80055b:	e9 77 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
  800560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800563:	85 c0                	test   %eax,%eax
  800565:	0f 48 c1             	cmovs  %ecx,%eax
  800568:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80056e:	e9 64 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800576:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80057d:	e9 55 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
			lflag++;
  800582:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800586:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800589:	e9 49 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 78 04             	lea    0x4(%eax),%edi
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	53                   	push   %ebx
  800598:	ff 30                	pushl  (%eax)
  80059a:	ff d6                	call   *%esi
			break;
  80059c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80059f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005a2:	e9 33 03 00 00       	jmp    8008da <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 78 04             	lea    0x4(%eax),%edi
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	99                   	cltd   
  8005b0:	31 d0                	xor    %edx,%eax
  8005b2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005b4:	83 f8 0f             	cmp    $0xf,%eax
  8005b7:	7f 23                	jg     8005dc <vprintfmt+0x148>
  8005b9:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8005c0:	85 d2                	test   %edx,%edx
  8005c2:	74 18                	je     8005dc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005c4:	52                   	push   %edx
  8005c5:	68 92 2d 80 00       	push   $0x802d92
  8005ca:	53                   	push   %ebx
  8005cb:	56                   	push   %esi
  8005cc:	e8 a6 fe ff ff       	call   800477 <printfmt>
  8005d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005d4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005d7:	e9 fe 02 00 00       	jmp    8008da <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005dc:	50                   	push   %eax
  8005dd:	68 33 28 80 00       	push   $0x802833
  8005e2:	53                   	push   %ebx
  8005e3:	56                   	push   %esi
  8005e4:	e8 8e fe ff ff       	call   800477 <printfmt>
  8005e9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ec:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ef:	e9 e6 02 00 00       	jmp    8008da <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	83 c0 04             	add    $0x4,%eax
  8005fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800602:	85 c9                	test   %ecx,%ecx
  800604:	b8 2c 28 80 00       	mov    $0x80282c,%eax
  800609:	0f 45 c1             	cmovne %ecx,%eax
  80060c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80060f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800613:	7e 06                	jle    80061b <vprintfmt+0x187>
  800615:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800619:	75 0d                	jne    800628 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80061e:	89 c7                	mov    %eax,%edi
  800620:	03 45 e0             	add    -0x20(%ebp),%eax
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	eb 53                	jmp    80067b <vprintfmt+0x1e7>
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 d8             	pushl  -0x28(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 71 04 00 00       	call   800aa5 <strnlen>
  800634:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800637:	29 c1                	sub    %eax,%ecx
  800639:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800641:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800645:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	eb 0f                	jmp    800659 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	ff 75 e0             	pushl  -0x20(%ebp)
  800651:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	83 ef 01             	sub    $0x1,%edi
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	85 ff                	test   %edi,%edi
  80065b:	7f ed                	jg     80064a <vprintfmt+0x1b6>
  80065d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800660:	85 c9                	test   %ecx,%ecx
  800662:	b8 00 00 00 00       	mov    $0x0,%eax
  800667:	0f 49 c1             	cmovns %ecx,%eax
  80066a:	29 c1                	sub    %eax,%ecx
  80066c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80066f:	eb aa                	jmp    80061b <vprintfmt+0x187>
					putch(ch, putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	52                   	push   %edx
  800676:	ff d6                	call   *%esi
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80067e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800680:	83 c7 01             	add    $0x1,%edi
  800683:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800687:	0f be d0             	movsbl %al,%edx
  80068a:	85 d2                	test   %edx,%edx
  80068c:	74 4b                	je     8006d9 <vprintfmt+0x245>
  80068e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800692:	78 06                	js     80069a <vprintfmt+0x206>
  800694:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800698:	78 1e                	js     8006b8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80069a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80069e:	74 d1                	je     800671 <vprintfmt+0x1dd>
  8006a0:	0f be c0             	movsbl %al,%eax
  8006a3:	83 e8 20             	sub    $0x20,%eax
  8006a6:	83 f8 5e             	cmp    $0x5e,%eax
  8006a9:	76 c6                	jbe    800671 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 3f                	push   $0x3f
  8006b1:	ff d6                	call   *%esi
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	eb c3                	jmp    80067b <vprintfmt+0x1e7>
  8006b8:	89 cf                	mov    %ecx,%edi
  8006ba:	eb 0e                	jmp    8006ca <vprintfmt+0x236>
				putch(' ', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 20                	push   $0x20
  8006c2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006c4:	83 ef 01             	sub    $0x1,%edi
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	85 ff                	test   %edi,%edi
  8006cc:	7f ee                	jg     8006bc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d4:	e9 01 02 00 00       	jmp    8008da <vprintfmt+0x446>
  8006d9:	89 cf                	mov    %ecx,%edi
  8006db:	eb ed                	jmp    8006ca <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006e0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006e7:	e9 eb fd ff ff       	jmp    8004d7 <vprintfmt+0x43>
	if (lflag >= 2)
  8006ec:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f0:	7f 21                	jg     800713 <vprintfmt+0x27f>
	else if (lflag)
  8006f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f6:	74 68                	je     800760 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800700:	89 c1                	mov    %eax,%ecx
  800702:	c1 f9 1f             	sar    $0x1f,%ecx
  800705:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
  800711:	eb 17                	jmp    80072a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80072a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800736:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80073a:	78 3f                	js     80077b <vprintfmt+0x2e7>
			base = 10;
  80073c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800741:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800745:	0f 84 71 01 00 00    	je     8008bc <vprintfmt+0x428>
				putch('+', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 2b                	push   $0x2b
  800751:	ff d6                	call   *%esi
  800753:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800756:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075b:	e9 5c 01 00 00       	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800768:	89 c1                	mov    %eax,%ecx
  80076a:	c1 f9 1f             	sar    $0x1f,%ecx
  80076d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	eb af                	jmp    80072a <vprintfmt+0x296>
				putch('-', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 2d                	push   $0x2d
  800781:	ff d6                	call   *%esi
				num = -(long long) num;
  800783:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800786:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800789:	f7 d8                	neg    %eax
  80078b:	83 d2 00             	adc    $0x0,%edx
  80078e:	f7 da                	neg    %edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800799:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079e:	e9 19 01 00 00       	jmp    8008bc <vprintfmt+0x428>
	if (lflag >= 2)
  8007a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a7:	7f 29                	jg     8007d2 <vprintfmt+0x33e>
	else if (lflag)
  8007a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ad:	74 44                	je     8007f3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 ea 00 00 00       	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 50 04             	mov    0x4(%eax),%edx
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ee:	e9 c9 00 00 00       	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800811:	e9 a6 00 00 00       	jmp    8008bc <vprintfmt+0x428>
			putch('0', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 30                	push   $0x30
  80081c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800825:	7f 26                	jg     80084d <vprintfmt+0x3b9>
	else if (lflag)
  800827:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082b:	74 3e                	je     80086b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800846:	b8 08 00 00 00       	mov    $0x8,%eax
  80084b:	eb 6f                	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 50 04             	mov    0x4(%eax),%edx
  800853:	8b 00                	mov    (%eax),%eax
  800855:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800858:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8d 40 08             	lea    0x8(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800864:	b8 08 00 00 00       	mov    $0x8,%eax
  800869:	eb 51                	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
  800875:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800878:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8d 40 04             	lea    0x4(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800884:	b8 08 00 00 00       	mov    $0x8,%eax
  800889:	eb 31                	jmp    8008bc <vprintfmt+0x428>
			putch('0', putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	6a 30                	push   $0x30
  800891:	ff d6                	call   *%esi
			putch('x', putdat);
  800893:	83 c4 08             	add    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	6a 78                	push   $0x78
  800899:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008ab:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8008cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ce:	89 da                	mov    %ebx,%edx
  8008d0:	89 f0                	mov    %esi,%eax
  8008d2:	e8 a4 fa ff ff       	call   80037b <printnum>
			break;
  8008d7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008dd:	83 c7 01             	add    $0x1,%edi
  8008e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e4:	83 f8 25             	cmp    $0x25,%eax
  8008e7:	0f 84 be fb ff ff    	je     8004ab <vprintfmt+0x17>
			if (ch == '\0')
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	0f 84 28 01 00 00    	je     800a1d <vprintfmt+0x589>
			putch(ch, putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	53                   	push   %ebx
  8008f9:	50                   	push   %eax
  8008fa:	ff d6                	call   *%esi
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	eb dc                	jmp    8008dd <vprintfmt+0x449>
	if (lflag >= 2)
  800901:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800905:	7f 26                	jg     80092d <vprintfmt+0x499>
	else if (lflag)
  800907:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090b:	74 41                	je     80094e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	ba 00 00 00 00       	mov    $0x0,%edx
  800917:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 40 04             	lea    0x4(%eax),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800926:	b8 10 00 00 00       	mov    $0x10,%eax
  80092b:	eb 8f                	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800938:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8d 40 08             	lea    0x8(%eax),%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800944:	b8 10 00 00 00       	mov    $0x10,%eax
  800949:	e9 6e ff ff ff       	jmp    8008bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 40 04             	lea    0x4(%eax),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800967:	b8 10 00 00 00       	mov    $0x10,%eax
  80096c:	e9 4b ff ff ff       	jmp    8008bc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 c0 04             	add    $0x4,%eax
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	85 c0                	test   %eax,%eax
  800981:	74 14                	je     800997 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800983:	8b 13                	mov    (%ebx),%edx
  800985:	83 fa 7f             	cmp    $0x7f,%edx
  800988:	7f 37                	jg     8009c1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80098a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80098c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80098f:	89 45 14             	mov    %eax,0x14(%ebp)
  800992:	e9 43 ff ff ff       	jmp    8008da <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800997:	b8 0a 00 00 00       	mov    $0xa,%eax
  80099c:	bf 51 29 80 00       	mov    $0x802951,%edi
							putch(ch, putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	53                   	push   %ebx
  8009a5:	50                   	push   %eax
  8009a6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009a8:	83 c7 01             	add    $0x1,%edi
  8009ab:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 eb                	jne    8009a1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bc:	e9 19 ff ff ff       	jmp    8008da <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009c1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009c8:	bf 89 29 80 00       	mov    $0x802989,%edi
							putch(ch, putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	53                   	push   %ebx
  8009d1:	50                   	push   %eax
  8009d2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009d4:	83 c7 01             	add    $0x1,%edi
  8009d7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	75 eb                	jne    8009cd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e8:	e9 ed fe ff ff       	jmp    8008da <vprintfmt+0x446>
			putch(ch, putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 25                	push   $0x25
  8009f3:	ff d6                	call   *%esi
			break;
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	e9 dd fe ff ff       	jmp    8008da <vprintfmt+0x446>
			putch('%', putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	6a 25                	push   $0x25
  800a03:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	89 f8                	mov    %edi,%eax
  800a0a:	eb 03                	jmp    800a0f <vprintfmt+0x57b>
  800a0c:	83 e8 01             	sub    $0x1,%eax
  800a0f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a13:	75 f7                	jne    800a0c <vprintfmt+0x578>
  800a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a18:	e9 bd fe ff ff       	jmp    8008da <vprintfmt+0x446>
}
  800a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a20:	5b                   	pop    %ebx
  800a21:	5e                   	pop    %esi
  800a22:	5f                   	pop    %edi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	83 ec 18             	sub    $0x18,%esp
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a34:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a38:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a42:	85 c0                	test   %eax,%eax
  800a44:	74 26                	je     800a6c <vsnprintf+0x47>
  800a46:	85 d2                	test   %edx,%edx
  800a48:	7e 22                	jle    800a6c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a4a:	ff 75 14             	pushl  0x14(%ebp)
  800a4d:	ff 75 10             	pushl  0x10(%ebp)
  800a50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	68 5a 04 80 00       	push   $0x80045a
  800a59:	e8 36 fa ff ff       	call   800494 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a67:	83 c4 10             	add    $0x10,%esp
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    
		return -E_INVAL;
  800a6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a71:	eb f7                	jmp    800a6a <vsnprintf+0x45>

00800a73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a7c:	50                   	push   %eax
  800a7d:	ff 75 10             	pushl  0x10(%ebp)
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 9a ff ff ff       	call   800a25 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a9c:	74 05                	je     800aa3 <strlen+0x16>
		n++;
  800a9e:	83 c0 01             	add    $0x1,%eax
  800aa1:	eb f5                	jmp    800a98 <strlen+0xb>
	return n;
}
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aae:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab3:	39 c2                	cmp    %eax,%edx
  800ab5:	74 0d                	je     800ac4 <strnlen+0x1f>
  800ab7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800abb:	74 05                	je     800ac2 <strnlen+0x1d>
		n++;
  800abd:	83 c2 01             	add    $0x1,%edx
  800ac0:	eb f1                	jmp    800ab3 <strnlen+0xe>
  800ac2:	89 d0                	mov    %edx,%eax
	return n;
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	53                   	push   %ebx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ad9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	84 c9                	test   %cl,%cl
  800ae1:	75 f2                	jne    800ad5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ae3:	5b                   	pop    %ebx
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	53                   	push   %ebx
  800aea:	83 ec 10             	sub    $0x10,%esp
  800aed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800af0:	53                   	push   %ebx
  800af1:	e8 97 ff ff ff       	call   800a8d <strlen>
  800af6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	01 d8                	add    %ebx,%eax
  800afe:	50                   	push   %eax
  800aff:	e8 c2 ff ff ff       	call   800ac6 <strcpy>
	return dst;
}
  800b04:	89 d8                	mov    %ebx,%eax
  800b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	56                   	push   %esi
  800b0f:	53                   	push   %ebx
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b16:	89 c6                	mov    %eax,%esi
  800b18:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b1b:	89 c2                	mov    %eax,%edx
  800b1d:	39 f2                	cmp    %esi,%edx
  800b1f:	74 11                	je     800b32 <strncpy+0x27>
		*dst++ = *src;
  800b21:	83 c2 01             	add    $0x1,%edx
  800b24:	0f b6 19             	movzbl (%ecx),%ebx
  800b27:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b2a:	80 fb 01             	cmp    $0x1,%bl
  800b2d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b30:	eb eb                	jmp    800b1d <strncpy+0x12>
	}
	return ret;
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	56                   	push   %esi
  800b3a:	53                   	push   %ebx
  800b3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b41:	8b 55 10             	mov    0x10(%ebp),%edx
  800b44:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b46:	85 d2                	test   %edx,%edx
  800b48:	74 21                	je     800b6b <strlcpy+0x35>
  800b4a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b4e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b50:	39 c2                	cmp    %eax,%edx
  800b52:	74 14                	je     800b68 <strlcpy+0x32>
  800b54:	0f b6 19             	movzbl (%ecx),%ebx
  800b57:	84 db                	test   %bl,%bl
  800b59:	74 0b                	je     800b66 <strlcpy+0x30>
			*dst++ = *src++;
  800b5b:	83 c1 01             	add    $0x1,%ecx
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b64:	eb ea                	jmp    800b50 <strlcpy+0x1a>
  800b66:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b6b:	29 f0                	sub    %esi,%eax
}
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b7a:	0f b6 01             	movzbl (%ecx),%eax
  800b7d:	84 c0                	test   %al,%al
  800b7f:	74 0c                	je     800b8d <strcmp+0x1c>
  800b81:	3a 02                	cmp    (%edx),%al
  800b83:	75 08                	jne    800b8d <strcmp+0x1c>
		p++, q++;
  800b85:	83 c1 01             	add    $0x1,%ecx
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb ed                	jmp    800b7a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b8d:	0f b6 c0             	movzbl %al,%eax
  800b90:	0f b6 12             	movzbl (%edx),%edx
  800b93:	29 d0                	sub    %edx,%eax
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba1:	89 c3                	mov    %eax,%ebx
  800ba3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba6:	eb 06                	jmp    800bae <strncmp+0x17>
		n--, p++, q++;
  800ba8:	83 c0 01             	add    $0x1,%eax
  800bab:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bae:	39 d8                	cmp    %ebx,%eax
  800bb0:	74 16                	je     800bc8 <strncmp+0x31>
  800bb2:	0f b6 08             	movzbl (%eax),%ecx
  800bb5:	84 c9                	test   %cl,%cl
  800bb7:	74 04                	je     800bbd <strncmp+0x26>
  800bb9:	3a 0a                	cmp    (%edx),%cl
  800bbb:	74 eb                	je     800ba8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbd:	0f b6 00             	movzbl (%eax),%eax
  800bc0:	0f b6 12             	movzbl (%edx),%edx
  800bc3:	29 d0                	sub    %edx,%eax
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    
		return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcd:	eb f6                	jmp    800bc5 <strncmp+0x2e>

00800bcf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd9:	0f b6 10             	movzbl (%eax),%edx
  800bdc:	84 d2                	test   %dl,%dl
  800bde:	74 09                	je     800be9 <strchr+0x1a>
		if (*s == c)
  800be0:	38 ca                	cmp    %cl,%dl
  800be2:	74 0a                	je     800bee <strchr+0x1f>
	for (; *s; s++)
  800be4:	83 c0 01             	add    $0x1,%eax
  800be7:	eb f0                	jmp    800bd9 <strchr+0xa>
			return (char *) s;
	return 0;
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfa:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bfd:	38 ca                	cmp    %cl,%dl
  800bff:	74 09                	je     800c0a <strfind+0x1a>
  800c01:	84 d2                	test   %dl,%dl
  800c03:	74 05                	je     800c0a <strfind+0x1a>
	for (; *s; s++)
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	eb f0                	jmp    800bfa <strfind+0xa>
			break;
	return (char *) s;
}
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c15:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c18:	85 c9                	test   %ecx,%ecx
  800c1a:	74 31                	je     800c4d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c1c:	89 f8                	mov    %edi,%eax
  800c1e:	09 c8                	or     %ecx,%eax
  800c20:	a8 03                	test   $0x3,%al
  800c22:	75 23                	jne    800c47 <memset+0x3b>
		c &= 0xFF;
  800c24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	c1 e3 08             	shl    $0x8,%ebx
  800c2d:	89 d0                	mov    %edx,%eax
  800c2f:	c1 e0 18             	shl    $0x18,%eax
  800c32:	89 d6                	mov    %edx,%esi
  800c34:	c1 e6 10             	shl    $0x10,%esi
  800c37:	09 f0                	or     %esi,%eax
  800c39:	09 c2                	or     %eax,%edx
  800c3b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c3d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c40:	89 d0                	mov    %edx,%eax
  800c42:	fc                   	cld    
  800c43:	f3 ab                	rep stos %eax,%es:(%edi)
  800c45:	eb 06                	jmp    800c4d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4d:	89 f8                	mov    %edi,%eax
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c62:	39 c6                	cmp    %eax,%esi
  800c64:	73 32                	jae    800c98 <memmove+0x44>
  800c66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c69:	39 c2                	cmp    %eax,%edx
  800c6b:	76 2b                	jbe    800c98 <memmove+0x44>
		s += n;
		d += n;
  800c6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c70:	89 fe                	mov    %edi,%esi
  800c72:	09 ce                	or     %ecx,%esi
  800c74:	09 d6                	or     %edx,%esi
  800c76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7c:	75 0e                	jne    800c8c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c7e:	83 ef 04             	sub    $0x4,%edi
  800c81:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c87:	fd                   	std    
  800c88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8a:	eb 09                	jmp    800c95 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c8c:	83 ef 01             	sub    $0x1,%edi
  800c8f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c92:	fd                   	std    
  800c93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c95:	fc                   	cld    
  800c96:	eb 1a                	jmp    800cb2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c98:	89 c2                	mov    %eax,%edx
  800c9a:	09 ca                	or     %ecx,%edx
  800c9c:	09 f2                	or     %esi,%edx
  800c9e:	f6 c2 03             	test   $0x3,%dl
  800ca1:	75 0a                	jne    800cad <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ca6:	89 c7                	mov    %eax,%edi
  800ca8:	fc                   	cld    
  800ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cab:	eb 05                	jmp    800cb2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cad:	89 c7                	mov    %eax,%edi
  800caf:	fc                   	cld    
  800cb0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cbc:	ff 75 10             	pushl  0x10(%ebp)
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	ff 75 08             	pushl  0x8(%ebp)
  800cc5:	e8 8a ff ff ff       	call   800c54 <memmove>
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd7:	89 c6                	mov    %eax,%esi
  800cd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cdc:	39 f0                	cmp    %esi,%eax
  800cde:	74 1c                	je     800cfc <memcmp+0x30>
		if (*s1 != *s2)
  800ce0:	0f b6 08             	movzbl (%eax),%ecx
  800ce3:	0f b6 1a             	movzbl (%edx),%ebx
  800ce6:	38 d9                	cmp    %bl,%cl
  800ce8:	75 08                	jne    800cf2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cea:	83 c0 01             	add    $0x1,%eax
  800ced:	83 c2 01             	add    $0x1,%edx
  800cf0:	eb ea                	jmp    800cdc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cf2:	0f b6 c1             	movzbl %cl,%eax
  800cf5:	0f b6 db             	movzbl %bl,%ebx
  800cf8:	29 d8                	sub    %ebx,%eax
  800cfa:	eb 05                	jmp    800d01 <memcmp+0x35>
	}

	return 0;
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d13:	39 d0                	cmp    %edx,%eax
  800d15:	73 09                	jae    800d20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d17:	38 08                	cmp    %cl,(%eax)
  800d19:	74 05                	je     800d20 <memfind+0x1b>
	for (; s < ends; s++)
  800d1b:	83 c0 01             	add    $0x1,%eax
  800d1e:	eb f3                	jmp    800d13 <memfind+0xe>
			break;
	return (void *) s;
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2e:	eb 03                	jmp    800d33 <strtol+0x11>
		s++;
  800d30:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d33:	0f b6 01             	movzbl (%ecx),%eax
  800d36:	3c 20                	cmp    $0x20,%al
  800d38:	74 f6                	je     800d30 <strtol+0xe>
  800d3a:	3c 09                	cmp    $0x9,%al
  800d3c:	74 f2                	je     800d30 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d3e:	3c 2b                	cmp    $0x2b,%al
  800d40:	74 2a                	je     800d6c <strtol+0x4a>
	int neg = 0;
  800d42:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d47:	3c 2d                	cmp    $0x2d,%al
  800d49:	74 2b                	je     800d76 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d51:	75 0f                	jne    800d62 <strtol+0x40>
  800d53:	80 39 30             	cmpb   $0x30,(%ecx)
  800d56:	74 28                	je     800d80 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d58:	85 db                	test   %ebx,%ebx
  800d5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d5f:	0f 44 d8             	cmove  %eax,%ebx
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
  800d67:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d6a:	eb 50                	jmp    800dbc <strtol+0x9a>
		s++;
  800d6c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d74:	eb d5                	jmp    800d4b <strtol+0x29>
		s++, neg = 1;
  800d76:	83 c1 01             	add    $0x1,%ecx
  800d79:	bf 01 00 00 00       	mov    $0x1,%edi
  800d7e:	eb cb                	jmp    800d4b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d80:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d84:	74 0e                	je     800d94 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d86:	85 db                	test   %ebx,%ebx
  800d88:	75 d8                	jne    800d62 <strtol+0x40>
		s++, base = 8;
  800d8a:	83 c1 01             	add    $0x1,%ecx
  800d8d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d92:	eb ce                	jmp    800d62 <strtol+0x40>
		s += 2, base = 16;
  800d94:	83 c1 02             	add    $0x2,%ecx
  800d97:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d9c:	eb c4                	jmp    800d62 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d9e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800da1:	89 f3                	mov    %esi,%ebx
  800da3:	80 fb 19             	cmp    $0x19,%bl
  800da6:	77 29                	ja     800dd1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800da8:	0f be d2             	movsbl %dl,%edx
  800dab:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dae:	3b 55 10             	cmp    0x10(%ebp),%edx
  800db1:	7d 30                	jge    800de3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800db3:	83 c1 01             	add    $0x1,%ecx
  800db6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dbc:	0f b6 11             	movzbl (%ecx),%edx
  800dbf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dc2:	89 f3                	mov    %esi,%ebx
  800dc4:	80 fb 09             	cmp    $0x9,%bl
  800dc7:	77 d5                	ja     800d9e <strtol+0x7c>
			dig = *s - '0';
  800dc9:	0f be d2             	movsbl %dl,%edx
  800dcc:	83 ea 30             	sub    $0x30,%edx
  800dcf:	eb dd                	jmp    800dae <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dd1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dd4:	89 f3                	mov    %esi,%ebx
  800dd6:	80 fb 19             	cmp    $0x19,%bl
  800dd9:	77 08                	ja     800de3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ddb:	0f be d2             	movsbl %dl,%edx
  800dde:	83 ea 37             	sub    $0x37,%edx
  800de1:	eb cb                	jmp    800dae <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	74 05                	je     800dee <strtol+0xcc>
		*endptr = (char *) s;
  800de9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dec:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dee:	89 c2                	mov    %eax,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	85 ff                	test   %edi,%edi
  800df4:	0f 45 c2             	cmovne %edx,%eax
}
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e02:	b8 00 00 00 00       	mov    $0x0,%eax
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	89 c3                	mov    %eax,%ebx
  800e0f:	89 c7                	mov    %eax,%edi
  800e11:	89 c6                	mov    %eax,%esi
  800e13:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_cgetc>:

int
sys_cgetc(void)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e20:	ba 00 00 00 00       	mov    $0x0,%edx
  800e25:	b8 01 00 00 00       	mov    $0x1,%eax
  800e2a:	89 d1                	mov    %edx,%ecx
  800e2c:	89 d3                	mov    %edx,%ebx
  800e2e:	89 d7                	mov    %edx,%edi
  800e30:	89 d6                	mov    %edx,%esi
  800e32:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e4f:	89 cb                	mov    %ecx,%ebx
  800e51:	89 cf                	mov    %ecx,%edi
  800e53:	89 ce                	mov    %ecx,%esi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 03                	push   $0x3
  800e69:	68 a0 2b 80 00       	push   $0x802ba0
  800e6e:	6a 43                	push   $0x43
  800e70:	68 bd 2b 80 00       	push   $0x802bbd
  800e75:	e8 f7 f3 ff ff       	call   800271 <_panic>

00800e7a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	ba 00 00 00 00       	mov    $0x0,%edx
  800e85:	b8 02 00 00 00       	mov    $0x2,%eax
  800e8a:	89 d1                	mov    %edx,%ecx
  800e8c:	89 d3                	mov    %edx,%ebx
  800e8e:	89 d7                	mov    %edx,%edi
  800e90:	89 d6                	mov    %edx,%esi
  800e92:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_yield>:

void
sys_yield(void)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ea9:	89 d1                	mov    %edx,%ecx
  800eab:	89 d3                	mov    %edx,%ebx
  800ead:	89 d7                	mov    %edx,%edi
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec1:	be 00 00 00 00       	mov    $0x0,%esi
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed4:	89 f7                	mov    %esi,%edi
  800ed6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	7f 08                	jg     800ee4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	50                   	push   %eax
  800ee8:	6a 04                	push   $0x4
  800eea:	68 a0 2b 80 00       	push   $0x802ba0
  800eef:	6a 43                	push   $0x43
  800ef1:	68 bd 2b 80 00       	push   $0x802bbd
  800ef6:	e8 76 f3 ff ff       	call   800271 <_panic>

00800efb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f15:	8b 75 18             	mov    0x18(%ebp),%esi
  800f18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	7f 08                	jg     800f26 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	50                   	push   %eax
  800f2a:	6a 05                	push   $0x5
  800f2c:	68 a0 2b 80 00       	push   $0x802ba0
  800f31:	6a 43                	push   $0x43
  800f33:	68 bd 2b 80 00       	push   $0x802bbd
  800f38:	e8 34 f3 ff ff       	call   800271 <_panic>

00800f3d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	b8 06 00 00 00       	mov    $0x6,%eax
  800f56:	89 df                	mov    %ebx,%edi
  800f58:	89 de                	mov    %ebx,%esi
  800f5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	7f 08                	jg     800f68 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	50                   	push   %eax
  800f6c:	6a 06                	push   $0x6
  800f6e:	68 a0 2b 80 00       	push   $0x802ba0
  800f73:	6a 43                	push   $0x43
  800f75:	68 bd 2b 80 00       	push   $0x802bbd
  800f7a:	e8 f2 f2 ff ff       	call   800271 <_panic>

00800f7f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	b8 08 00 00 00       	mov    $0x8,%eax
  800f98:	89 df                	mov    %ebx,%edi
  800f9a:	89 de                	mov    %ebx,%esi
  800f9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	7f 08                	jg     800faa <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	50                   	push   %eax
  800fae:	6a 08                	push   $0x8
  800fb0:	68 a0 2b 80 00       	push   $0x802ba0
  800fb5:	6a 43                	push   $0x43
  800fb7:	68 bd 2b 80 00       	push   $0x802bbd
  800fbc:	e8 b0 f2 ff ff       	call   800271 <_panic>

00800fc1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd5:	b8 09 00 00 00       	mov    $0x9,%eax
  800fda:	89 df                	mov    %ebx,%edi
  800fdc:	89 de                	mov    %ebx,%esi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 09                	push   $0x9
  800ff2:	68 a0 2b 80 00       	push   $0x802ba0
  800ff7:	6a 43                	push   $0x43
  800ff9:	68 bd 2b 80 00       	push   $0x802bbd
  800ffe:	e8 6e f2 ff ff       	call   800271 <_panic>

00801003 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801017:	b8 0a 00 00 00       	mov    $0xa,%eax
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7f 08                	jg     80102e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	50                   	push   %eax
  801032:	6a 0a                	push   $0xa
  801034:	68 a0 2b 80 00       	push   $0x802ba0
  801039:	6a 43                	push   $0x43
  80103b:	68 bd 2b 80 00       	push   $0x802bbd
  801040:	e8 2c f2 ff ff       	call   800271 <_panic>

00801045 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	b8 0c 00 00 00       	mov    $0xc,%eax
  801056:	be 00 00 00 00       	mov    $0x0,%esi
  80105b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80105e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801061:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	53                   	push   %ebx
  80106e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801071:	b9 00 00 00 00       	mov    $0x0,%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	b8 0d 00 00 00       	mov    $0xd,%eax
  80107e:	89 cb                	mov    %ecx,%ebx
  801080:	89 cf                	mov    %ecx,%edi
  801082:	89 ce                	mov    %ecx,%esi
  801084:	cd 30                	int    $0x30
	if(check && ret > 0)
  801086:	85 c0                	test   %eax,%eax
  801088:	7f 08                	jg     801092 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80108a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801092:	83 ec 0c             	sub    $0xc,%esp
  801095:	50                   	push   %eax
  801096:	6a 0d                	push   $0xd
  801098:	68 a0 2b 80 00       	push   $0x802ba0
  80109d:	6a 43                	push   $0x43
  80109f:	68 bd 2b 80 00       	push   $0x802bbd
  8010a4:	e8 c8 f1 ff ff       	call   800271 <_panic>

008010a9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ba:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010bf:	89 df                	mov    %ebx,%edi
  8010c1:	89 de                	mov    %ebx,%esi
  8010c3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010dd:	89 cb                	mov    %ecx,%ebx
  8010df:	89 cf                	mov    %ecx,%edi
  8010e1:	89 ce                	mov    %ecx,%esi
  8010e3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010f1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010f8:	83 e1 07             	and    $0x7,%ecx
  8010fb:	83 f9 07             	cmp    $0x7,%ecx
  8010fe:	74 32                	je     801132 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801100:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801107:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80110d:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801113:	74 7d                	je     801192 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801115:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80111c:	83 e1 05             	and    $0x5,%ecx
  80111f:	83 f9 05             	cmp    $0x5,%ecx
  801122:	0f 84 9e 00 00 00    	je     8011c6 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801130:	c9                   	leave  
  801131:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801132:	89 d3                	mov    %edx,%ebx
  801134:	c1 e3 0c             	shl    $0xc,%ebx
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	68 05 08 00 00       	push   $0x805
  80113f:	53                   	push   %ebx
  801140:	50                   	push   %eax
  801141:	53                   	push   %ebx
  801142:	6a 00                	push   $0x0
  801144:	e8 b2 fd ff ff       	call   800efb <sys_page_map>
		if(r < 0)
  801149:	83 c4 20             	add    $0x20,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 2e                	js     80117e <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	68 05 08 00 00       	push   $0x805
  801158:	53                   	push   %ebx
  801159:	6a 00                	push   $0x0
  80115b:	53                   	push   %ebx
  80115c:	6a 00                	push   $0x0
  80115e:	e8 98 fd ff ff       	call   800efb <sys_page_map>
		if(r < 0)
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	79 be                	jns    801128 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80116a:	83 ec 04             	sub    $0x4,%esp
  80116d:	68 cb 2b 80 00       	push   $0x802bcb
  801172:	6a 57                	push   $0x57
  801174:	68 e1 2b 80 00       	push   $0x802be1
  801179:	e8 f3 f0 ff ff       	call   800271 <_panic>
			panic("sys_page_map() panic\n");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 cb 2b 80 00       	push   $0x802bcb
  801186:	6a 53                	push   $0x53
  801188:	68 e1 2b 80 00       	push   $0x802be1
  80118d:	e8 df f0 ff ff       	call   800271 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801192:	c1 e2 0c             	shl    $0xc,%edx
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	68 05 08 00 00       	push   $0x805
  80119d:	52                   	push   %edx
  80119e:	50                   	push   %eax
  80119f:	52                   	push   %edx
  8011a0:	6a 00                	push   $0x0
  8011a2:	e8 54 fd ff ff       	call   800efb <sys_page_map>
		if(r < 0)
  8011a7:	83 c4 20             	add    $0x20,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	0f 89 76 ff ff ff    	jns    801128 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	68 cb 2b 80 00       	push   $0x802bcb
  8011ba:	6a 5e                	push   $0x5e
  8011bc:	68 e1 2b 80 00       	push   $0x802be1
  8011c1:	e8 ab f0 ff ff       	call   800271 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011c6:	c1 e2 0c             	shl    $0xc,%edx
  8011c9:	83 ec 0c             	sub    $0xc,%esp
  8011cc:	6a 05                	push   $0x5
  8011ce:	52                   	push   %edx
  8011cf:	50                   	push   %eax
  8011d0:	52                   	push   %edx
  8011d1:	6a 00                	push   $0x0
  8011d3:	e8 23 fd ff ff       	call   800efb <sys_page_map>
		if(r < 0)
  8011d8:	83 c4 20             	add    $0x20,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	0f 89 45 ff ff ff    	jns    801128 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	68 cb 2b 80 00       	push   $0x802bcb
  8011eb:	6a 65                	push   $0x65
  8011ed:	68 e1 2b 80 00       	push   $0x802be1
  8011f2:	e8 7a f0 ff ff       	call   800271 <_panic>

008011f7 <pgfault>:
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801201:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801203:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801207:	0f 84 99 00 00 00    	je     8012a6 <pgfault+0xaf>
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	c1 ea 16             	shr    $0x16,%edx
  801212:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801219:	f6 c2 01             	test   $0x1,%dl
  80121c:	0f 84 84 00 00 00    	je     8012a6 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801222:	89 c2                	mov    %eax,%edx
  801224:	c1 ea 0c             	shr    $0xc,%edx
  801227:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122e:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801234:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80123a:	75 6a                	jne    8012a6 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80123c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801241:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	6a 07                	push   $0x7
  801248:	68 00 f0 7f 00       	push   $0x7ff000
  80124d:	6a 00                	push   $0x0
  80124f:	e8 64 fc ff ff       	call   800eb8 <sys_page_alloc>
	if(ret < 0)
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 5f                	js     8012ba <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	68 00 10 00 00       	push   $0x1000
  801263:	53                   	push   %ebx
  801264:	68 00 f0 7f 00       	push   $0x7ff000
  801269:	e8 48 fa ff ff       	call   800cb6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80126e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801275:	53                   	push   %ebx
  801276:	6a 00                	push   $0x0
  801278:	68 00 f0 7f 00       	push   $0x7ff000
  80127d:	6a 00                	push   $0x0
  80127f:	e8 77 fc ff ff       	call   800efb <sys_page_map>
	if(ret < 0)
  801284:	83 c4 20             	add    $0x20,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 43                	js     8012ce <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	68 00 f0 7f 00       	push   $0x7ff000
  801293:	6a 00                	push   $0x0
  801295:	e8 a3 fc ff ff       	call   800f3d <sys_page_unmap>
	if(ret < 0)
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	85 c0                	test   %eax,%eax
  80129f:	78 41                	js     8012e2 <pgfault+0xeb>
}
  8012a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 ec 2b 80 00       	push   $0x802bec
  8012ae:	6a 26                	push   $0x26
  8012b0:	68 e1 2b 80 00       	push   $0x802be1
  8012b5:	e8 b7 ef ff ff       	call   800271 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	68 00 2c 80 00       	push   $0x802c00
  8012c2:	6a 31                	push   $0x31
  8012c4:	68 e1 2b 80 00       	push   $0x802be1
  8012c9:	e8 a3 ef ff ff       	call   800271 <_panic>
		panic("panic in sys_page_map()\n");
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	68 1b 2c 80 00       	push   $0x802c1b
  8012d6:	6a 36                	push   $0x36
  8012d8:	68 e1 2b 80 00       	push   $0x802be1
  8012dd:	e8 8f ef ff ff       	call   800271 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	68 34 2c 80 00       	push   $0x802c34
  8012ea:	6a 39                	push   $0x39
  8012ec:	68 e1 2b 80 00       	push   $0x802be1
  8012f1:	e8 7b ef ff ff       	call   800271 <_panic>

008012f6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  8012ff:	68 f7 11 80 00       	push   $0x8011f7
  801304:	e8 6b 0f 00 00       	call   802274 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801309:	b8 07 00 00 00       	mov    $0x7,%eax
  80130e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	78 27                	js     80133e <fork+0x48>
  801317:	89 c6                	mov    %eax,%esi
  801319:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80131b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801320:	75 48                	jne    80136a <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801322:	e8 53 fb ff ff       	call   800e7a <sys_getenvid>
  801327:	25 ff 03 00 00       	and    $0x3ff,%eax
  80132c:	c1 e0 07             	shl    $0x7,%eax
  80132f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801334:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801339:	e9 90 00 00 00       	jmp    8013ce <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	68 50 2c 80 00       	push   $0x802c50
  801346:	68 85 00 00 00       	push   $0x85
  80134b:	68 e1 2b 80 00       	push   $0x802be1
  801350:	e8 1c ef ff ff       	call   800271 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801355:	89 f8                	mov    %edi,%eax
  801357:	e8 8e fd ff ff       	call   8010ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80135c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801362:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801368:	74 26                	je     801390 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80136a:	89 d8                	mov    %ebx,%eax
  80136c:	c1 e8 16             	shr    $0x16,%eax
  80136f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801376:	a8 01                	test   $0x1,%al
  801378:	74 e2                	je     80135c <fork+0x66>
  80137a:	89 da                	mov    %ebx,%edx
  80137c:	c1 ea 0c             	shr    $0xc,%edx
  80137f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801386:	83 e0 05             	and    $0x5,%eax
  801389:	83 f8 05             	cmp    $0x5,%eax
  80138c:	75 ce                	jne    80135c <fork+0x66>
  80138e:	eb c5                	jmp    801355 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801390:	83 ec 04             	sub    $0x4,%esp
  801393:	6a 07                	push   $0x7
  801395:	68 00 f0 bf ee       	push   $0xeebff000
  80139a:	56                   	push   %esi
  80139b:	e8 18 fb ff ff       	call   800eb8 <sys_page_alloc>
	if(ret < 0)
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 31                	js     8013d8 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	68 e3 22 80 00       	push   $0x8022e3
  8013af:	56                   	push   %esi
  8013b0:	e8 4e fc ff ff       	call   801003 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	78 33                	js     8013ef <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	6a 02                	push   $0x2
  8013c1:	56                   	push   %esi
  8013c2:	e8 b8 fb ff ff       	call   800f7f <sys_env_set_status>
	if(ret < 0)
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 38                	js     801406 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013ce:	89 f0                	mov    %esi,%eax
  8013d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d3:	5b                   	pop    %ebx
  8013d4:	5e                   	pop    %esi
  8013d5:	5f                   	pop    %edi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	68 00 2c 80 00       	push   $0x802c00
  8013e0:	68 91 00 00 00       	push   $0x91
  8013e5:	68 e1 2b 80 00       	push   $0x802be1
  8013ea:	e8 82 ee ff ff       	call   800271 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	68 74 2c 80 00       	push   $0x802c74
  8013f7:	68 94 00 00 00       	push   $0x94
  8013fc:	68 e1 2b 80 00       	push   $0x802be1
  801401:	e8 6b ee ff ff       	call   800271 <_panic>
		panic("panic in sys_env_set_status()\n");
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	68 9c 2c 80 00       	push   $0x802c9c
  80140e:	68 97 00 00 00       	push   $0x97
  801413:	68 e1 2b 80 00       	push   $0x802be1
  801418:	e8 54 ee ff ff       	call   800271 <_panic>

0080141d <sfork>:

// Challenge!
int
sfork(void)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801426:	a1 20 44 80 00       	mov    0x804420,%eax
  80142b:	8b 40 48             	mov    0x48(%eax),%eax
  80142e:	68 bc 2c 80 00       	push   $0x802cbc
  801433:	50                   	push   %eax
  801434:	68 e5 27 80 00       	push   $0x8027e5
  801439:	e8 29 ef ff ff       	call   800367 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80143e:	c7 04 24 f7 11 80 00 	movl   $0x8011f7,(%esp)
  801445:	e8 2a 0e 00 00       	call   802274 <set_pgfault_handler>
  80144a:	b8 07 00 00 00       	mov    $0x7,%eax
  80144f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 27                	js     80147f <sfork+0x62>
  801458:	89 c7                	mov    %eax,%edi
  80145a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80145c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801461:	75 55                	jne    8014b8 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  801463:	e8 12 fa ff ff       	call   800e7a <sys_getenvid>
  801468:	25 ff 03 00 00       	and    $0x3ff,%eax
  80146d:	c1 e0 07             	shl    $0x7,%eax
  801470:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801475:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  80147a:	e9 d4 00 00 00       	jmp    801553 <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 50 2c 80 00       	push   $0x802c50
  801487:	68 a9 00 00 00       	push   $0xa9
  80148c:	68 e1 2b 80 00       	push   $0x802be1
  801491:	e8 db ed ff ff       	call   800271 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801496:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80149b:	89 f0                	mov    %esi,%eax
  80149d:	e8 48 fc ff ff       	call   8010ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014a8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014ae:	77 65                	ja     801515 <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8014b0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014b6:	74 de                	je     801496 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014b8:	89 d8                	mov    %ebx,%eax
  8014ba:	c1 e8 16             	shr    $0x16,%eax
  8014bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c4:	a8 01                	test   $0x1,%al
  8014c6:	74 da                	je     8014a2 <sfork+0x85>
  8014c8:	89 da                	mov    %ebx,%edx
  8014ca:	c1 ea 0c             	shr    $0xc,%edx
  8014cd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014d4:	83 e0 05             	and    $0x5,%eax
  8014d7:	83 f8 05             	cmp    $0x5,%eax
  8014da:	75 c6                	jne    8014a2 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014dc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014e3:	c1 e2 0c             	shl    $0xc,%edx
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	83 e0 07             	and    $0x7,%eax
  8014ec:	50                   	push   %eax
  8014ed:	52                   	push   %edx
  8014ee:	56                   	push   %esi
  8014ef:	52                   	push   %edx
  8014f0:	6a 00                	push   $0x0
  8014f2:	e8 04 fa ff ff       	call   800efb <sys_page_map>
  8014f7:	83 c4 20             	add    $0x20,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 a4                	je     8014a2 <sfork+0x85>
				panic("sys_page_map() panic\n");
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	68 cb 2b 80 00       	push   $0x802bcb
  801506:	68 b4 00 00 00       	push   $0xb4
  80150b:	68 e1 2b 80 00       	push   $0x802be1
  801510:	e8 5c ed ff ff       	call   800271 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	6a 07                	push   $0x7
  80151a:	68 00 f0 bf ee       	push   $0xeebff000
  80151f:	57                   	push   %edi
  801520:	e8 93 f9 ff ff       	call   800eb8 <sys_page_alloc>
	if(ret < 0)
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	78 31                	js     80155d <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	68 e3 22 80 00       	push   $0x8022e3
  801534:	57                   	push   %edi
  801535:	e8 c9 fa ff ff       	call   801003 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 33                	js     801574 <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	6a 02                	push   $0x2
  801546:	57                   	push   %edi
  801547:	e8 33 fa ff ff       	call   800f7f <sys_env_set_status>
	if(ret < 0)
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 38                	js     80158b <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801553:	89 f8                	mov    %edi,%eax
  801555:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801558:	5b                   	pop    %ebx
  801559:	5e                   	pop    %esi
  80155a:	5f                   	pop    %edi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	68 00 2c 80 00       	push   $0x802c00
  801565:	68 ba 00 00 00       	push   $0xba
  80156a:	68 e1 2b 80 00       	push   $0x802be1
  80156f:	e8 fd ec ff ff       	call   800271 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 74 2c 80 00       	push   $0x802c74
  80157c:	68 bd 00 00 00       	push   $0xbd
  801581:	68 e1 2b 80 00       	push   $0x802be1
  801586:	e8 e6 ec ff ff       	call   800271 <_panic>
		panic("panic in sys_env_set_status()\n");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 9c 2c 80 00       	push   $0x802c9c
  801593:	68 c0 00 00 00       	push   $0xc0
  801598:	68 e1 2b 80 00       	push   $0x802be1
  80159d:	e8 cf ec ff ff       	call   800271 <_panic>

008015a2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	05 00 00 00 30       	add    $0x30000000,%eax
  8015ad:	c1 e8 0c             	shr    $0xc,%eax
}
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    

008015b2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	c1 ea 16             	shr    $0x16,%edx
  8015d6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015dd:	f6 c2 01             	test   $0x1,%dl
  8015e0:	74 2d                	je     80160f <fd_alloc+0x46>
  8015e2:	89 c2                	mov    %eax,%edx
  8015e4:	c1 ea 0c             	shr    $0xc,%edx
  8015e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ee:	f6 c2 01             	test   $0x1,%dl
  8015f1:	74 1c                	je     80160f <fd_alloc+0x46>
  8015f3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015f8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015fd:	75 d2                	jne    8015d1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801608:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80160d:	eb 0a                	jmp    801619 <fd_alloc+0x50>
			*fd_store = fd;
  80160f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801612:	89 01                	mov    %eax,(%ecx)
			return 0;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801621:	83 f8 1f             	cmp    $0x1f,%eax
  801624:	77 30                	ja     801656 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801626:	c1 e0 0c             	shl    $0xc,%eax
  801629:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80162e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801634:	f6 c2 01             	test   $0x1,%dl
  801637:	74 24                	je     80165d <fd_lookup+0x42>
  801639:	89 c2                	mov    %eax,%edx
  80163b:	c1 ea 0c             	shr    $0xc,%edx
  80163e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801645:	f6 c2 01             	test   $0x1,%dl
  801648:	74 1a                	je     801664 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	89 02                	mov    %eax,(%edx)
	return 0;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    
		return -E_INVAL;
  801656:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165b:	eb f7                	jmp    801654 <fd_lookup+0x39>
		return -E_INVAL;
  80165d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801662:	eb f0                	jmp    801654 <fd_lookup+0x39>
  801664:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801669:	eb e9                	jmp    801654 <fd_lookup+0x39>

0080166b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801674:	ba 40 2d 80 00       	mov    $0x802d40,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801679:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80167e:	39 08                	cmp    %ecx,(%eax)
  801680:	74 33                	je     8016b5 <dev_lookup+0x4a>
  801682:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801685:	8b 02                	mov    (%edx),%eax
  801687:	85 c0                	test   %eax,%eax
  801689:	75 f3                	jne    80167e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80168b:	a1 20 44 80 00       	mov    0x804420,%eax
  801690:	8b 40 48             	mov    0x48(%eax),%eax
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	51                   	push   %ecx
  801697:	50                   	push   %eax
  801698:	68 c4 2c 80 00       	push   $0x802cc4
  80169d:	e8 c5 ec ff ff       	call   800367 <cprintf>
	*dev = 0;
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    
			*dev = devtab[i];
  8016b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	eb f2                	jmp    8016b3 <dev_lookup+0x48>

008016c1 <fd_close>:
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	57                   	push   %edi
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 24             	sub    $0x24,%esp
  8016ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8016cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016da:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016dd:	50                   	push   %eax
  8016de:	e8 38 ff ff ff       	call   80161b <fd_lookup>
  8016e3:	89 c3                	mov    %eax,%ebx
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	78 05                	js     8016f1 <fd_close+0x30>
	    || fd != fd2)
  8016ec:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016ef:	74 16                	je     801707 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016f1:	89 f8                	mov    %edi,%eax
  8016f3:	84 c0                	test   %al,%al
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	0f 44 d8             	cmove  %eax,%ebx
}
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80170d:	50                   	push   %eax
  80170e:	ff 36                	pushl  (%esi)
  801710:	e8 56 ff ff ff       	call   80166b <dev_lookup>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 1a                	js     801738 <fd_close+0x77>
		if (dev->dev_close)
  80171e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801721:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801724:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801729:	85 c0                	test   %eax,%eax
  80172b:	74 0b                	je     801738 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	56                   	push   %esi
  801731:	ff d0                	call   *%eax
  801733:	89 c3                	mov    %eax,%ebx
  801735:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	56                   	push   %esi
  80173c:	6a 00                	push   $0x0
  80173e:	e8 fa f7 ff ff       	call   800f3d <sys_page_unmap>
	return r;
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	eb b5                	jmp    8016fd <fd_close+0x3c>

00801748 <close>:

int
close(int fdnum)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 c1 fe ff ff       	call   80161b <fd_lookup>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	79 02                	jns    801763 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    
		return fd_close(fd, 1);
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	6a 01                	push   $0x1
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	e8 51 ff ff ff       	call   8016c1 <fd_close>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	eb ec                	jmp    801761 <close+0x19>

00801775 <close_all>:

void
close_all(void)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	53                   	push   %ebx
  801779:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80177c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	53                   	push   %ebx
  801785:	e8 be ff ff ff       	call   801748 <close>
	for (i = 0; i < MAXFD; i++)
  80178a:	83 c3 01             	add    $0x1,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	83 fb 20             	cmp    $0x20,%ebx
  801793:	75 ec                	jne    801781 <close_all+0xc>
}
  801795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a6:	50                   	push   %eax
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	e8 6c fe ff ff       	call   80161b <fd_lookup>
  8017af:	89 c3                	mov    %eax,%ebx
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	0f 88 81 00 00 00    	js     80183d <dup+0xa3>
		return r;
	close(newfdnum);
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	e8 81 ff ff ff       	call   801748 <close>

	newfd = INDEX2FD(newfdnum);
  8017c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017ca:	c1 e6 0c             	shl    $0xc,%esi
  8017cd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017d3:	83 c4 04             	add    $0x4,%esp
  8017d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017d9:	e8 d4 fd ff ff       	call   8015b2 <fd2data>
  8017de:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017e0:	89 34 24             	mov    %esi,(%esp)
  8017e3:	e8 ca fd ff ff       	call   8015b2 <fd2data>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	c1 e8 16             	shr    $0x16,%eax
  8017f2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017f9:	a8 01                	test   $0x1,%al
  8017fb:	74 11                	je     80180e <dup+0x74>
  8017fd:	89 d8                	mov    %ebx,%eax
  8017ff:	c1 e8 0c             	shr    $0xc,%eax
  801802:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801809:	f6 c2 01             	test   $0x1,%dl
  80180c:	75 39                	jne    801847 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80180e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801811:	89 d0                	mov    %edx,%eax
  801813:	c1 e8 0c             	shr    $0xc,%eax
  801816:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	25 07 0e 00 00       	and    $0xe07,%eax
  801825:	50                   	push   %eax
  801826:	56                   	push   %esi
  801827:	6a 00                	push   $0x0
  801829:	52                   	push   %edx
  80182a:	6a 00                	push   $0x0
  80182c:	e8 ca f6 ff ff       	call   800efb <sys_page_map>
  801831:	89 c3                	mov    %eax,%ebx
  801833:	83 c4 20             	add    $0x20,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 31                	js     80186b <dup+0xd1>
		goto err;

	return newfdnum;
  80183a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80183d:	89 d8                	mov    %ebx,%eax
  80183f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5f                   	pop    %edi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801847:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	25 07 0e 00 00       	and    $0xe07,%eax
  801856:	50                   	push   %eax
  801857:	57                   	push   %edi
  801858:	6a 00                	push   $0x0
  80185a:	53                   	push   %ebx
  80185b:	6a 00                	push   $0x0
  80185d:	e8 99 f6 ff ff       	call   800efb <sys_page_map>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 20             	add    $0x20,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	79 a3                	jns    80180e <dup+0x74>
	sys_page_unmap(0, newfd);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	56                   	push   %esi
  80186f:	6a 00                	push   $0x0
  801871:	e8 c7 f6 ff ff       	call   800f3d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801876:	83 c4 08             	add    $0x8,%esp
  801879:	57                   	push   %edi
  80187a:	6a 00                	push   $0x0
  80187c:	e8 bc f6 ff ff       	call   800f3d <sys_page_unmap>
	return r;
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	eb b7                	jmp    80183d <dup+0xa3>

00801886 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 1c             	sub    $0x1c,%esp
  80188d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	53                   	push   %ebx
  801895:	e8 81 fd ff ff       	call   80161b <fd_lookup>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 3f                	js     8018e0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a7:	50                   	push   %eax
  8018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ab:	ff 30                	pushl  (%eax)
  8018ad:	e8 b9 fd ff ff       	call   80166b <dev_lookup>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 27                	js     8018e0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018bc:	8b 42 08             	mov    0x8(%edx),%eax
  8018bf:	83 e0 03             	and    $0x3,%eax
  8018c2:	83 f8 01             	cmp    $0x1,%eax
  8018c5:	74 1e                	je     8018e5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	8b 40 08             	mov    0x8(%eax),%eax
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	74 35                	je     801906 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	ff 75 10             	pushl  0x10(%ebp)
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	52                   	push   %edx
  8018db:	ff d0                	call   *%eax
  8018dd:	83 c4 10             	add    $0x10,%esp
}
  8018e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018e5:	a1 20 44 80 00       	mov    0x804420,%eax
  8018ea:	8b 40 48             	mov    0x48(%eax),%eax
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	53                   	push   %ebx
  8018f1:	50                   	push   %eax
  8018f2:	68 05 2d 80 00       	push   $0x802d05
  8018f7:	e8 6b ea ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801904:	eb da                	jmp    8018e0 <read+0x5a>
		return -E_NOT_SUPP;
  801906:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190b:	eb d3                	jmp    8018e0 <read+0x5a>

0080190d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	57                   	push   %edi
  801911:	56                   	push   %esi
  801912:	53                   	push   %ebx
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	8b 7d 08             	mov    0x8(%ebp),%edi
  801919:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80191c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801921:	39 f3                	cmp    %esi,%ebx
  801923:	73 23                	jae    801948 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	89 f0                	mov    %esi,%eax
  80192a:	29 d8                	sub    %ebx,%eax
  80192c:	50                   	push   %eax
  80192d:	89 d8                	mov    %ebx,%eax
  80192f:	03 45 0c             	add    0xc(%ebp),%eax
  801932:	50                   	push   %eax
  801933:	57                   	push   %edi
  801934:	e8 4d ff ff ff       	call   801886 <read>
		if (m < 0)
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 06                	js     801946 <readn+0x39>
			return m;
		if (m == 0)
  801940:	74 06                	je     801948 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801942:	01 c3                	add    %eax,%ebx
  801944:	eb db                	jmp    801921 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801946:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5f                   	pop    %edi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 1c             	sub    $0x1c,%esp
  801959:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195f:	50                   	push   %eax
  801960:	53                   	push   %ebx
  801961:	e8 b5 fc ff ff       	call   80161b <fd_lookup>
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 3a                	js     8019a7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801977:	ff 30                	pushl  (%eax)
  801979:	e8 ed fc ff ff       	call   80166b <dev_lookup>
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	85 c0                	test   %eax,%eax
  801983:	78 22                	js     8019a7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801988:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198c:	74 1e                	je     8019ac <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80198e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801991:	8b 52 0c             	mov    0xc(%edx),%edx
  801994:	85 d2                	test   %edx,%edx
  801996:	74 35                	je     8019cd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	50                   	push   %eax
  8019a2:	ff d2                	call   *%edx
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ac:	a1 20 44 80 00       	mov    0x804420,%eax
  8019b1:	8b 40 48             	mov    0x48(%eax),%eax
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	53                   	push   %ebx
  8019b8:	50                   	push   %eax
  8019b9:	68 21 2d 80 00       	push   $0x802d21
  8019be:	e8 a4 e9 ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cb:	eb da                	jmp    8019a7 <write+0x55>
		return -E_NOT_SUPP;
  8019cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d2:	eb d3                	jmp    8019a7 <write+0x55>

008019d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019dd:	50                   	push   %eax
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	e8 35 fc ff ff       	call   80161b <fd_lookup>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 0e                	js     8019fb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	53                   	push   %ebx
  801a01:	83 ec 1c             	sub    $0x1c,%esp
  801a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a07:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0a:	50                   	push   %eax
  801a0b:	53                   	push   %ebx
  801a0c:	e8 0a fc ff ff       	call   80161b <fd_lookup>
  801a11:	83 c4 10             	add    $0x10,%esp
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 37                	js     801a4f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	ff 30                	pushl  (%eax)
  801a24:	e8 42 fc ff ff       	call   80166b <dev_lookup>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 1f                	js     801a4f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a33:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a37:	74 1b                	je     801a54 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3c:	8b 52 18             	mov    0x18(%edx),%edx
  801a3f:	85 d2                	test   %edx,%edx
  801a41:	74 32                	je     801a75 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	ff d2                	call   *%edx
  801a4c:	83 c4 10             	add    $0x10,%esp
}
  801a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a54:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a59:	8b 40 48             	mov    0x48(%eax),%eax
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	53                   	push   %ebx
  801a60:	50                   	push   %eax
  801a61:	68 e4 2c 80 00       	push   $0x802ce4
  801a66:	e8 fc e8 ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a73:	eb da                	jmp    801a4f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a7a:	eb d3                	jmp    801a4f <ftruncate+0x52>

00801a7c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	e8 89 fb ff ff       	call   80161b <fd_lookup>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 4b                	js     801ae4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9f:	50                   	push   %eax
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	ff 30                	pushl  (%eax)
  801aa5:	e8 c1 fb ff ff       	call   80166b <dev_lookup>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 33                	js     801ae4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ab8:	74 2f                	je     801ae9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aba:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac4:	00 00 00 
	stat->st_isdir = 0;
  801ac7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ace:	00 00 00 
	stat->st_dev = dev;
  801ad1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	53                   	push   %ebx
  801adb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ade:	ff 50 14             	call   *0x14(%eax)
  801ae1:	83 c4 10             	add    $0x10,%esp
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ae9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aee:	eb f4                	jmp    801ae4 <fstat+0x68>

00801af0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	e8 bb 01 00 00       	call   801cbd <open>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 1b                	js     801b26 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	e8 65 ff ff ff       	call   801a7c <fstat>
  801b17:	89 c6                	mov    %eax,%esi
	close(fd);
  801b19:	89 1c 24             	mov    %ebx,(%esp)
  801b1c:	e8 27 fc ff ff       	call   801748 <close>
	return r;
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	89 f3                	mov    %esi,%ebx
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	89 c6                	mov    %eax,%esi
  801b36:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b38:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b3f:	74 27                	je     801b68 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b41:	6a 07                	push   $0x7
  801b43:	68 00 50 80 00       	push   $0x805000
  801b48:	56                   	push   %esi
  801b49:	ff 35 00 40 80 00    	pushl  0x804000
  801b4f:	e8 1e 08 00 00       	call   802372 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b54:	83 c4 0c             	add    $0xc,%esp
  801b57:	6a 00                	push   $0x0
  801b59:	53                   	push   %ebx
  801b5a:	6a 00                	push   $0x0
  801b5c:	e8 a8 07 00 00       	call   802309 <ipc_recv>
}
  801b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b68:	83 ec 0c             	sub    $0xc,%esp
  801b6b:	6a 01                	push   $0x1
  801b6d:	e8 58 08 00 00       	call   8023ca <ipc_find_env>
  801b72:	a3 00 40 80 00       	mov    %eax,0x804000
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	eb c5                	jmp    801b41 <fsipc+0x12>

00801b7c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	8b 40 0c             	mov    0xc(%eax),%eax
  801b88:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b95:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b9f:	e8 8b ff ff ff       	call   801b2f <fsipc>
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <devfile_flush>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbc:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc1:	e8 69 ff ff ff       	call   801b2f <fsipc>
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <devfile_stat>:
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801be2:	b8 05 00 00 00       	mov    $0x5,%eax
  801be7:	e8 43 ff ff ff       	call   801b2f <fsipc>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 2c                	js     801c1c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	68 00 50 80 00       	push   $0x805000
  801bf8:	53                   	push   %ebx
  801bf9:	e8 c8 ee ff ff       	call   800ac6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bfe:	a1 80 50 80 00       	mov    0x805080,%eax
  801c03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c09:	a1 84 50 80 00       	mov    0x805084,%eax
  801c0e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <devfile_write>:
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801c27:	68 50 2d 80 00       	push   $0x802d50
  801c2c:	68 90 00 00 00       	push   $0x90
  801c31:	68 6e 2d 80 00       	push   $0x802d6e
  801c36:	e8 36 e6 ff ff       	call   800271 <_panic>

00801c3b <devfile_read>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8b 40 0c             	mov    0xc(%eax),%eax
  801c49:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c4e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c54:	ba 00 00 00 00       	mov    $0x0,%edx
  801c59:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5e:	e8 cc fe ff ff       	call   801b2f <fsipc>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 1f                	js     801c88 <devfile_read+0x4d>
	assert(r <= n);
  801c69:	39 f0                	cmp    %esi,%eax
  801c6b:	77 24                	ja     801c91 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c6d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c72:	7f 33                	jg     801ca7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	50                   	push   %eax
  801c78:	68 00 50 80 00       	push   $0x805000
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	e8 cf ef ff ff       	call   800c54 <memmove>
	return r;
  801c85:	83 c4 10             	add    $0x10,%esp
}
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5e                   	pop    %esi
  801c8f:	5d                   	pop    %ebp
  801c90:	c3                   	ret    
	assert(r <= n);
  801c91:	68 79 2d 80 00       	push   $0x802d79
  801c96:	68 80 2d 80 00       	push   $0x802d80
  801c9b:	6a 7c                	push   $0x7c
  801c9d:	68 6e 2d 80 00       	push   $0x802d6e
  801ca2:	e8 ca e5 ff ff       	call   800271 <_panic>
	assert(r <= PGSIZE);
  801ca7:	68 95 2d 80 00       	push   $0x802d95
  801cac:	68 80 2d 80 00       	push   $0x802d80
  801cb1:	6a 7d                	push   $0x7d
  801cb3:	68 6e 2d 80 00       	push   $0x802d6e
  801cb8:	e8 b4 e5 ff ff       	call   800271 <_panic>

00801cbd <open>:
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 1c             	sub    $0x1c,%esp
  801cc5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cc8:	56                   	push   %esi
  801cc9:	e8 bf ed ff ff       	call   800a8d <strlen>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cd6:	7f 6c                	jg     801d44 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cde:	50                   	push   %eax
  801cdf:	e8 e5 f8 ff ff       	call   8015c9 <fd_alloc>
  801ce4:	89 c3                	mov    %eax,%ebx
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	78 3c                	js     801d29 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ced:	83 ec 08             	sub    $0x8,%esp
  801cf0:	56                   	push   %esi
  801cf1:	68 00 50 80 00       	push   $0x805000
  801cf6:	e8 cb ed ff ff       	call   800ac6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	e8 1f fe ff ff       	call   801b2f <fsipc>
  801d10:	89 c3                	mov    %eax,%ebx
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 19                	js     801d32 <open+0x75>
	return fd2num(fd);
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1f:	e8 7e f8 ff ff       	call   8015a2 <fd2num>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
}
  801d29:	89 d8                	mov    %ebx,%eax
  801d2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2e:	5b                   	pop    %ebx
  801d2f:	5e                   	pop    %esi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    
		fd_close(fd, 0);
  801d32:	83 ec 08             	sub    $0x8,%esp
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3a:	e8 82 f9 ff ff       	call   8016c1 <fd_close>
		return r;
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	eb e5                	jmp    801d29 <open+0x6c>
		return -E_BAD_PATH;
  801d44:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d49:	eb de                	jmp    801d29 <open+0x6c>

00801d4b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d51:	ba 00 00 00 00       	mov    $0x0,%edx
  801d56:	b8 08 00 00 00       	mov    $0x8,%eax
  801d5b:	e8 cf fd ff ff       	call   801b2f <fsipc>
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	e8 3d f8 ff ff       	call   8015b2 <fd2data>
  801d75:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d77:	83 c4 08             	add    $0x8,%esp
  801d7a:	68 a1 2d 80 00       	push   $0x802da1
  801d7f:	53                   	push   %ebx
  801d80:	e8 41 ed ff ff       	call   800ac6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d85:	8b 46 04             	mov    0x4(%esi),%eax
  801d88:	2b 06                	sub    (%esi),%eax
  801d8a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d90:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d97:	00 00 00 
	stat->st_dev = &devpipe;
  801d9a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801da1:	30 80 00 
	return 0;
}
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
  801da9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    

00801db0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	53                   	push   %ebx
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dba:	53                   	push   %ebx
  801dbb:	6a 00                	push   $0x0
  801dbd:	e8 7b f1 ff ff       	call   800f3d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dc2:	89 1c 24             	mov    %ebx,(%esp)
  801dc5:	e8 e8 f7 ff ff       	call   8015b2 <fd2data>
  801dca:	83 c4 08             	add    $0x8,%esp
  801dcd:	50                   	push   %eax
  801dce:	6a 00                	push   $0x0
  801dd0:	e8 68 f1 ff ff       	call   800f3d <sys_page_unmap>
}
  801dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <_pipeisclosed>:
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	57                   	push   %edi
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 1c             	sub    $0x1c,%esp
  801de3:	89 c7                	mov    %eax,%edi
  801de5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801de7:	a1 20 44 80 00       	mov    0x804420,%eax
  801dec:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	57                   	push   %edi
  801df3:	e8 0d 06 00 00       	call   802405 <pageref>
  801df8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dfb:	89 34 24             	mov    %esi,(%esp)
  801dfe:	e8 02 06 00 00       	call   802405 <pageref>
		nn = thisenv->env_runs;
  801e03:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801e09:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	39 cb                	cmp    %ecx,%ebx
  801e11:	74 1b                	je     801e2e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e13:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e16:	75 cf                	jne    801de7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e18:	8b 42 58             	mov    0x58(%edx),%eax
  801e1b:	6a 01                	push   $0x1
  801e1d:	50                   	push   %eax
  801e1e:	53                   	push   %ebx
  801e1f:	68 a8 2d 80 00       	push   $0x802da8
  801e24:	e8 3e e5 ff ff       	call   800367 <cprintf>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	eb b9                	jmp    801de7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e2e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e31:	0f 94 c0             	sete   %al
  801e34:	0f b6 c0             	movzbl %al,%eax
}
  801e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <devpipe_write>:
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	57                   	push   %edi
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
  801e45:	83 ec 28             	sub    $0x28,%esp
  801e48:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e4b:	56                   	push   %esi
  801e4c:	e8 61 f7 ff ff       	call   8015b2 <fd2data>
  801e51:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e5e:	74 4f                	je     801eaf <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e60:	8b 43 04             	mov    0x4(%ebx),%eax
  801e63:	8b 0b                	mov    (%ebx),%ecx
  801e65:	8d 51 20             	lea    0x20(%ecx),%edx
  801e68:	39 d0                	cmp    %edx,%eax
  801e6a:	72 14                	jb     801e80 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e6c:	89 da                	mov    %ebx,%edx
  801e6e:	89 f0                	mov    %esi,%eax
  801e70:	e8 65 ff ff ff       	call   801dda <_pipeisclosed>
  801e75:	85 c0                	test   %eax,%eax
  801e77:	75 3b                	jne    801eb4 <devpipe_write+0x75>
			sys_yield();
  801e79:	e8 1b f0 ff ff       	call   800e99 <sys_yield>
  801e7e:	eb e0                	jmp    801e60 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e83:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e87:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e8a:	89 c2                	mov    %eax,%edx
  801e8c:	c1 fa 1f             	sar    $0x1f,%edx
  801e8f:	89 d1                	mov    %edx,%ecx
  801e91:	c1 e9 1b             	shr    $0x1b,%ecx
  801e94:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e97:	83 e2 1f             	and    $0x1f,%edx
  801e9a:	29 ca                	sub    %ecx,%edx
  801e9c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ea0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ea4:	83 c0 01             	add    $0x1,%eax
  801ea7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801eaa:	83 c7 01             	add    $0x1,%edi
  801ead:	eb ac                	jmp    801e5b <devpipe_write+0x1c>
	return i;
  801eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb2:	eb 05                	jmp    801eb9 <devpipe_write+0x7a>
				return 0;
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5f                   	pop    %edi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devpipe_read>:
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	57                   	push   %edi
  801ec5:	56                   	push   %esi
  801ec6:	53                   	push   %ebx
  801ec7:	83 ec 18             	sub    $0x18,%esp
  801eca:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ecd:	57                   	push   %edi
  801ece:	e8 df f6 ff ff       	call   8015b2 <fd2data>
  801ed3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	be 00 00 00 00       	mov    $0x0,%esi
  801edd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ee0:	75 14                	jne    801ef6 <devpipe_read+0x35>
	return i;
  801ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee5:	eb 02                	jmp    801ee9 <devpipe_read+0x28>
				return i;
  801ee7:	89 f0                	mov    %esi,%eax
}
  801ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eec:	5b                   	pop    %ebx
  801eed:	5e                   	pop    %esi
  801eee:	5f                   	pop    %edi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    
			sys_yield();
  801ef1:	e8 a3 ef ff ff       	call   800e99 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ef6:	8b 03                	mov    (%ebx),%eax
  801ef8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801efb:	75 18                	jne    801f15 <devpipe_read+0x54>
			if (i > 0)
  801efd:	85 f6                	test   %esi,%esi
  801eff:	75 e6                	jne    801ee7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f01:	89 da                	mov    %ebx,%edx
  801f03:	89 f8                	mov    %edi,%eax
  801f05:	e8 d0 fe ff ff       	call   801dda <_pipeisclosed>
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 e3                	je     801ef1 <devpipe_read+0x30>
				return 0;
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	eb d4                	jmp    801ee9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f15:	99                   	cltd   
  801f16:	c1 ea 1b             	shr    $0x1b,%edx
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	83 e0 1f             	and    $0x1f,%eax
  801f1e:	29 d0                	sub    %edx,%eax
  801f20:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f28:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f2b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f2e:	83 c6 01             	add    $0x1,%esi
  801f31:	eb aa                	jmp    801edd <devpipe_read+0x1c>

00801f33 <pipe>:
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	56                   	push   %esi
  801f37:	53                   	push   %ebx
  801f38:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3e:	50                   	push   %eax
  801f3f:	e8 85 f6 ff ff       	call   8015c9 <fd_alloc>
  801f44:	89 c3                	mov    %eax,%ebx
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 23 01 00 00    	js     802074 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	68 07 04 00 00       	push   $0x407
  801f59:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 55 ef ff ff       	call   800eb8 <sys_page_alloc>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 88 04 01 00 00    	js     802074 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f76:	50                   	push   %eax
  801f77:	e8 4d f6 ff ff       	call   8015c9 <fd_alloc>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	0f 88 db 00 00 00    	js     802064 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	68 07 04 00 00       	push   $0x407
  801f91:	ff 75 f0             	pushl  -0x10(%ebp)
  801f94:	6a 00                	push   $0x0
  801f96:	e8 1d ef ff ff       	call   800eb8 <sys_page_alloc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	0f 88 bc 00 00 00    	js     802064 <pipe+0x131>
	va = fd2data(fd0);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 f4             	pushl  -0xc(%ebp)
  801fae:	e8 ff f5 ff ff       	call   8015b2 <fd2data>
  801fb3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb5:	83 c4 0c             	add    $0xc,%esp
  801fb8:	68 07 04 00 00       	push   $0x407
  801fbd:	50                   	push   %eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 f3 ee ff ff       	call   800eb8 <sys_page_alloc>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	0f 88 82 00 00 00    	js     802054 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd8:	e8 d5 f5 ff ff       	call   8015b2 <fd2data>
  801fdd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fe4:	50                   	push   %eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	56                   	push   %esi
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 0c ef ff ff       	call   800efb <sys_page_map>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	83 c4 20             	add    $0x20,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 4e                	js     802046 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ff8:	a1 20 30 80 00       	mov    0x803020,%eax
  801ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802000:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802005:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80200c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	ff 75 f4             	pushl  -0xc(%ebp)
  802021:	e8 7c f5 ff ff       	call   8015a2 <fd2num>
  802026:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802029:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80202b:	83 c4 04             	add    $0x4,%esp
  80202e:	ff 75 f0             	pushl  -0x10(%ebp)
  802031:	e8 6c f5 ff ff       	call   8015a2 <fd2num>
  802036:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802039:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802044:	eb 2e                	jmp    802074 <pipe+0x141>
	sys_page_unmap(0, va);
  802046:	83 ec 08             	sub    $0x8,%esp
  802049:	56                   	push   %esi
  80204a:	6a 00                	push   $0x0
  80204c:	e8 ec ee ff ff       	call   800f3d <sys_page_unmap>
  802051:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	ff 75 f0             	pushl  -0x10(%ebp)
  80205a:	6a 00                	push   $0x0
  80205c:	e8 dc ee ff ff       	call   800f3d <sys_page_unmap>
  802061:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802064:	83 ec 08             	sub    $0x8,%esp
  802067:	ff 75 f4             	pushl  -0xc(%ebp)
  80206a:	6a 00                	push   $0x0
  80206c:	e8 cc ee ff ff       	call   800f3d <sys_page_unmap>
  802071:	83 c4 10             	add    $0x10,%esp
}
  802074:	89 d8                	mov    %ebx,%eax
  802076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    

0080207d <pipeisclosed>:
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802083:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802086:	50                   	push   %eax
  802087:	ff 75 08             	pushl  0x8(%ebp)
  80208a:	e8 8c f5 ff ff       	call   80161b <fd_lookup>
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	85 c0                	test   %eax,%eax
  802094:	78 18                	js     8020ae <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802096:	83 ec 0c             	sub    $0xc,%esp
  802099:	ff 75 f4             	pushl  -0xc(%ebp)
  80209c:	e8 11 f5 ff ff       	call   8015b2 <fd2data>
	return _pipeisclosed(fd, p);
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	e8 2f fd ff ff       	call   801dda <_pipeisclosed>
  8020ab:	83 c4 10             	add    $0x10,%esp
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	56                   	push   %esi
  8020b4:	53                   	push   %ebx
  8020b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8020b8:	85 f6                	test   %esi,%esi
  8020ba:	74 13                	je     8020cf <wait+0x1f>
	e = &envs[ENVX(envid)];
  8020bc:	89 f3                	mov    %esi,%ebx
  8020be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8020c4:	c1 e3 07             	shl    $0x7,%ebx
  8020c7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8020cd:	eb 1b                	jmp    8020ea <wait+0x3a>
	assert(envid != 0);
  8020cf:	68 c0 2d 80 00       	push   $0x802dc0
  8020d4:	68 80 2d 80 00       	push   $0x802d80
  8020d9:	6a 09                	push   $0x9
  8020db:	68 cb 2d 80 00       	push   $0x802dcb
  8020e0:	e8 8c e1 ff ff       	call   800271 <_panic>
		sys_yield();
  8020e5:	e8 af ed ff ff       	call   800e99 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8020ea:	8b 43 48             	mov    0x48(%ebx),%eax
  8020ed:	39 f0                	cmp    %esi,%eax
  8020ef:	75 07                	jne    8020f8 <wait+0x48>
  8020f1:	8b 43 54             	mov    0x54(%ebx),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	75 ed                	jne    8020e5 <wait+0x35>
}
  8020f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	c3                   	ret    

00802105 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80210b:	68 d6 2d 80 00       	push   $0x802dd6
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	e8 ae e9 ff ff       	call   800ac6 <strcpy>
	return 0;
}
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <devcons_write>:
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	57                   	push   %edi
  802123:	56                   	push   %esi
  802124:	53                   	push   %ebx
  802125:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80212b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802130:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802136:	3b 75 10             	cmp    0x10(%ebp),%esi
  802139:	73 31                	jae    80216c <devcons_write+0x4d>
		m = n - tot;
  80213b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80213e:	29 f3                	sub    %esi,%ebx
  802140:	83 fb 7f             	cmp    $0x7f,%ebx
  802143:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802148:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	53                   	push   %ebx
  80214f:	89 f0                	mov    %esi,%eax
  802151:	03 45 0c             	add    0xc(%ebp),%eax
  802154:	50                   	push   %eax
  802155:	57                   	push   %edi
  802156:	e8 f9 ea ff ff       	call   800c54 <memmove>
		sys_cputs(buf, m);
  80215b:	83 c4 08             	add    $0x8,%esp
  80215e:	53                   	push   %ebx
  80215f:	57                   	push   %edi
  802160:	e8 97 ec ff ff       	call   800dfc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802165:	01 de                	add    %ebx,%esi
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	eb ca                	jmp    802136 <devcons_write+0x17>
}
  80216c:	89 f0                	mov    %esi,%eax
  80216e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    

00802176 <devcons_read>:
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802185:	74 21                	je     8021a8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802187:	e8 8e ec ff ff       	call   800e1a <sys_cgetc>
  80218c:	85 c0                	test   %eax,%eax
  80218e:	75 07                	jne    802197 <devcons_read+0x21>
		sys_yield();
  802190:	e8 04 ed ff ff       	call   800e99 <sys_yield>
  802195:	eb f0                	jmp    802187 <devcons_read+0x11>
	if (c < 0)
  802197:	78 0f                	js     8021a8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802199:	83 f8 04             	cmp    $0x4,%eax
  80219c:	74 0c                	je     8021aa <devcons_read+0x34>
	*(char*)vbuf = c;
  80219e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a1:	88 02                	mov    %al,(%edx)
	return 1;
  8021a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    
		return 0;
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	eb f7                	jmp    8021a8 <devcons_read+0x32>

008021b1 <cputchar>:
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021bd:	6a 01                	push   $0x1
  8021bf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c2:	50                   	push   %eax
  8021c3:	e8 34 ec ff ff       	call   800dfc <sys_cputs>
}
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <getchar>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021d3:	6a 01                	push   $0x1
  8021d5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d8:	50                   	push   %eax
  8021d9:	6a 00                	push   $0x0
  8021db:	e8 a6 f6 ff ff       	call   801886 <read>
	if (r < 0)
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 06                	js     8021ed <getchar+0x20>
	if (r < 1)
  8021e7:	74 06                	je     8021ef <getchar+0x22>
	return c;
  8021e9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    
		return -E_EOF;
  8021ef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021f4:	eb f7                	jmp    8021ed <getchar+0x20>

008021f6 <iscons>:
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ff:	50                   	push   %eax
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	e8 13 f4 ff ff       	call   80161b <fd_lookup>
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	85 c0                	test   %eax,%eax
  80220d:	78 11                	js     802220 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802218:	39 10                	cmp    %edx,(%eax)
  80221a:	0f 94 c0             	sete   %al
  80221d:	0f b6 c0             	movzbl %al,%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <opencons>:
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802228:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80222b:	50                   	push   %eax
  80222c:	e8 98 f3 ff ff       	call   8015c9 <fd_alloc>
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	78 3a                	js     802272 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802238:	83 ec 04             	sub    $0x4,%esp
  80223b:	68 07 04 00 00       	push   $0x407
  802240:	ff 75 f4             	pushl  -0xc(%ebp)
  802243:	6a 00                	push   $0x0
  802245:	e8 6e ec ff ff       	call   800eb8 <sys_page_alloc>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 21                	js     802272 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80225a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802266:	83 ec 0c             	sub    $0xc,%esp
  802269:	50                   	push   %eax
  80226a:	e8 33 f3 ff ff       	call   8015a2 <fd2num>
  80226f:	83 c4 10             	add    $0x10,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80227a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802281:	74 0a                	je     80228d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	6a 07                	push   $0x7
  802292:	68 00 f0 bf ee       	push   $0xeebff000
  802297:	6a 00                	push   $0x0
  802299:	e8 1a ec ff ff       	call   800eb8 <sys_page_alloc>
		if(r < 0)
  80229e:	83 c4 10             	add    $0x10,%esp
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 2a                	js     8022cf <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8022a5:	83 ec 08             	sub    $0x8,%esp
  8022a8:	68 e3 22 80 00       	push   $0x8022e3
  8022ad:	6a 00                	push   $0x0
  8022af:	e8 4f ed ff ff       	call   801003 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	79 c8                	jns    802283 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	68 14 2e 80 00       	push   $0x802e14
  8022c3:	6a 25                	push   $0x25
  8022c5:	68 50 2e 80 00       	push   $0x802e50
  8022ca:	e8 a2 df ff ff       	call   800271 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 e4 2d 80 00       	push   $0x802de4
  8022d7:	6a 22                	push   $0x22
  8022d9:	68 50 2e 80 00       	push   $0x802e50
  8022de:	e8 8e df ff ff       	call   800271 <_panic>

008022e3 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022e3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022e4:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022e9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022eb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8022ee:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8022f2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8022f6:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8022f9:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8022fb:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8022ff:	83 c4 08             	add    $0x8,%esp
	popal
  802302:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802303:	83 c4 04             	add    $0x4,%esp
	popfl
  802306:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802307:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802308:	c3                   	ret    

00802309 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	8b 75 08             	mov    0x8(%ebp),%esi
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802317:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802319:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80231e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	50                   	push   %eax
  802325:	e8 3e ed ff ff       	call   801068 <sys_ipc_recv>
	if(ret < 0){
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	85 c0                	test   %eax,%eax
  80232f:	78 2b                	js     80235c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802331:	85 f6                	test   %esi,%esi
  802333:	74 0a                	je     80233f <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802335:	a1 20 44 80 00       	mov    0x804420,%eax
  80233a:	8b 40 74             	mov    0x74(%eax),%eax
  80233d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80233f:	85 db                	test   %ebx,%ebx
  802341:	74 0a                	je     80234d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802343:	a1 20 44 80 00       	mov    0x804420,%eax
  802348:	8b 40 78             	mov    0x78(%eax),%eax
  80234b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80234d:	a1 20 44 80 00       	mov    0x804420,%eax
  802352:	8b 40 70             	mov    0x70(%eax),%eax
}
  802355:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802358:	5b                   	pop    %ebx
  802359:	5e                   	pop    %esi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    
		if(from_env_store)
  80235c:	85 f6                	test   %esi,%esi
  80235e:	74 06                	je     802366 <ipc_recv+0x5d>
			*from_env_store = 0;
  802360:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802366:	85 db                	test   %ebx,%ebx
  802368:	74 eb                	je     802355 <ipc_recv+0x4c>
			*perm_store = 0;
  80236a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802370:	eb e3                	jmp    802355 <ipc_recv+0x4c>

00802372 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 0c             	sub    $0xc,%esp
  80237b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80237e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802381:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802384:	85 db                	test   %ebx,%ebx
  802386:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80238b:	0f 44 d8             	cmove  %eax,%ebx
  80238e:	eb 05                	jmp    802395 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802390:	e8 04 eb ff ff       	call   800e99 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802395:	ff 75 14             	pushl  0x14(%ebp)
  802398:	53                   	push   %ebx
  802399:	56                   	push   %esi
  80239a:	57                   	push   %edi
  80239b:	e8 a5 ec ff ff       	call   801045 <sys_ipc_try_send>
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	74 1b                	je     8023c2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023a7:	79 e7                	jns    802390 <ipc_send+0x1e>
  8023a9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023ac:	74 e2                	je     802390 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023ae:	83 ec 04             	sub    $0x4,%esp
  8023b1:	68 5e 2e 80 00       	push   $0x802e5e
  8023b6:	6a 49                	push   $0x49
  8023b8:	68 73 2e 80 00       	push   $0x802e73
  8023bd:	e8 af de ff ff       	call   800271 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023c5:	5b                   	pop    %ebx
  8023c6:	5e                   	pop    %esi
  8023c7:	5f                   	pop    %edi
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023d5:	89 c2                	mov    %eax,%edx
  8023d7:	c1 e2 07             	shl    $0x7,%edx
  8023da:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023e0:	8b 52 50             	mov    0x50(%edx),%edx
  8023e3:	39 ca                	cmp    %ecx,%edx
  8023e5:	74 11                	je     8023f8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023e7:	83 c0 01             	add    $0x1,%eax
  8023ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ef:	75 e4                	jne    8023d5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	eb 0b                	jmp    802403 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023f8:	c1 e0 07             	shl    $0x7,%eax
  8023fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802400:	8b 40 48             	mov    0x48(%eax),%eax
}
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    

00802405 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240b:	89 d0                	mov    %edx,%eax
  80240d:	c1 e8 16             	shr    $0x16,%eax
  802410:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80241c:	f6 c1 01             	test   $0x1,%cl
  80241f:	74 1d                	je     80243e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802421:	c1 ea 0c             	shr    $0xc,%edx
  802424:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80242b:	f6 c2 01             	test   $0x1,%dl
  80242e:	74 0e                	je     80243e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802430:	c1 ea 0c             	shr    $0xc,%edx
  802433:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80243a:	ef 
  80243b:	0f b7 c0             	movzwl %ax,%eax
}
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    

00802440 <__udivdi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80244b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80244f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802453:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802457:	85 d2                	test   %edx,%edx
  802459:	75 4d                	jne    8024a8 <__udivdi3+0x68>
  80245b:	39 f3                	cmp    %esi,%ebx
  80245d:	76 19                	jbe    802478 <__udivdi3+0x38>
  80245f:	31 ff                	xor    %edi,%edi
  802461:	89 e8                	mov    %ebp,%eax
  802463:	89 f2                	mov    %esi,%edx
  802465:	f7 f3                	div    %ebx
  802467:	89 fa                	mov    %edi,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 d9                	mov    %ebx,%ecx
  80247a:	85 db                	test   %ebx,%ebx
  80247c:	75 0b                	jne    802489 <__udivdi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f3                	div    %ebx
  802487:	89 c1                	mov    %eax,%ecx
  802489:	31 d2                	xor    %edx,%edx
  80248b:	89 f0                	mov    %esi,%eax
  80248d:	f7 f1                	div    %ecx
  80248f:	89 c6                	mov    %eax,%esi
  802491:	89 e8                	mov    %ebp,%eax
  802493:	89 f7                	mov    %esi,%edi
  802495:	f7 f1                	div    %ecx
  802497:	89 fa                	mov    %edi,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	39 f2                	cmp    %esi,%edx
  8024aa:	77 1c                	ja     8024c8 <__udivdi3+0x88>
  8024ac:	0f bd fa             	bsr    %edx,%edi
  8024af:	83 f7 1f             	xor    $0x1f,%edi
  8024b2:	75 2c                	jne    8024e0 <__udivdi3+0xa0>
  8024b4:	39 f2                	cmp    %esi,%edx
  8024b6:	72 06                	jb     8024be <__udivdi3+0x7e>
  8024b8:	31 c0                	xor    %eax,%eax
  8024ba:	39 eb                	cmp    %ebp,%ebx
  8024bc:	77 a9                	ja     802467 <__udivdi3+0x27>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	eb a2                	jmp    802467 <__udivdi3+0x27>
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	31 ff                	xor    %edi,%edi
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	89 fa                	mov    %edi,%edx
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	89 f9                	mov    %edi,%ecx
  8024e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e7:	29 f8                	sub    %edi,%eax
  8024e9:	d3 e2                	shl    %cl,%edx
  8024eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024ef:	89 c1                	mov    %eax,%ecx
  8024f1:	89 da                	mov    %ebx,%edx
  8024f3:	d3 ea                	shr    %cl,%edx
  8024f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f9:	09 d1                	or     %edx,%ecx
  8024fb:	89 f2                	mov    %esi,%edx
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 f9                	mov    %edi,%ecx
  802503:	d3 e3                	shl    %cl,%ebx
  802505:	89 c1                	mov    %eax,%ecx
  802507:	d3 ea                	shr    %cl,%edx
  802509:	89 f9                	mov    %edi,%ecx
  80250b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80250f:	89 eb                	mov    %ebp,%ebx
  802511:	d3 e6                	shl    %cl,%esi
  802513:	89 c1                	mov    %eax,%ecx
  802515:	d3 eb                	shr    %cl,%ebx
  802517:	09 de                	or     %ebx,%esi
  802519:	89 f0                	mov    %esi,%eax
  80251b:	f7 74 24 08          	divl   0x8(%esp)
  80251f:	89 d6                	mov    %edx,%esi
  802521:	89 c3                	mov    %eax,%ebx
  802523:	f7 64 24 0c          	mull   0xc(%esp)
  802527:	39 d6                	cmp    %edx,%esi
  802529:	72 15                	jb     802540 <__udivdi3+0x100>
  80252b:	89 f9                	mov    %edi,%ecx
  80252d:	d3 e5                	shl    %cl,%ebp
  80252f:	39 c5                	cmp    %eax,%ebp
  802531:	73 04                	jae    802537 <__udivdi3+0xf7>
  802533:	39 d6                	cmp    %edx,%esi
  802535:	74 09                	je     802540 <__udivdi3+0x100>
  802537:	89 d8                	mov    %ebx,%eax
  802539:	31 ff                	xor    %edi,%edi
  80253b:	e9 27 ff ff ff       	jmp    802467 <__udivdi3+0x27>
  802540:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802543:	31 ff                	xor    %edi,%edi
  802545:	e9 1d ff ff ff       	jmp    802467 <__udivdi3+0x27>
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80255b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80255f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802563:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802567:	89 da                	mov    %ebx,%edx
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 43                	jne    8025b0 <__umoddi3+0x60>
  80256d:	39 df                	cmp    %ebx,%edi
  80256f:	76 17                	jbe    802588 <__umoddi3+0x38>
  802571:	89 f0                	mov    %esi,%eax
  802573:	f7 f7                	div    %edi
  802575:	89 d0                	mov    %edx,%eax
  802577:	31 d2                	xor    %edx,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 fd                	mov    %edi,%ebp
  80258a:	85 ff                	test   %edi,%edi
  80258c:	75 0b                	jne    802599 <__umoddi3+0x49>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f7                	div    %edi
  802597:	89 c5                	mov    %eax,%ebp
  802599:	89 d8                	mov    %ebx,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	f7 f5                	div    %ebp
  80259f:	89 f0                	mov    %esi,%eax
  8025a1:	f7 f5                	div    %ebp
  8025a3:	89 d0                	mov    %edx,%eax
  8025a5:	eb d0                	jmp    802577 <__umoddi3+0x27>
  8025a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	89 f1                	mov    %esi,%ecx
  8025b2:	39 d8                	cmp    %ebx,%eax
  8025b4:	76 0a                	jbe    8025c0 <__umoddi3+0x70>
  8025b6:	89 f0                	mov    %esi,%eax
  8025b8:	83 c4 1c             	add    $0x1c,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	0f bd e8             	bsr    %eax,%ebp
  8025c3:	83 f5 1f             	xor    $0x1f,%ebp
  8025c6:	75 20                	jne    8025e8 <__umoddi3+0x98>
  8025c8:	39 d8                	cmp    %ebx,%eax
  8025ca:	0f 82 b0 00 00 00    	jb     802680 <__umoddi3+0x130>
  8025d0:	39 f7                	cmp    %esi,%edi
  8025d2:	0f 86 a8 00 00 00    	jbe    802680 <__umoddi3+0x130>
  8025d8:	89 c8                	mov    %ecx,%eax
  8025da:	83 c4 1c             	add    $0x1c,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5f                   	pop    %edi
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    
  8025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8025ef:	29 ea                	sub    %ebp,%edx
  8025f1:	d3 e0                	shl    %cl,%eax
  8025f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f7:	89 d1                	mov    %edx,%ecx
  8025f9:	89 f8                	mov    %edi,%eax
  8025fb:	d3 e8                	shr    %cl,%eax
  8025fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802601:	89 54 24 04          	mov    %edx,0x4(%esp)
  802605:	8b 54 24 04          	mov    0x4(%esp),%edx
  802609:	09 c1                	or     %eax,%ecx
  80260b:	89 d8                	mov    %ebx,%eax
  80260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802611:	89 e9                	mov    %ebp,%ecx
  802613:	d3 e7                	shl    %cl,%edi
  802615:	89 d1                	mov    %edx,%ecx
  802617:	d3 e8                	shr    %cl,%eax
  802619:	89 e9                	mov    %ebp,%ecx
  80261b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80261f:	d3 e3                	shl    %cl,%ebx
  802621:	89 c7                	mov    %eax,%edi
  802623:	89 d1                	mov    %edx,%ecx
  802625:	89 f0                	mov    %esi,%eax
  802627:	d3 e8                	shr    %cl,%eax
  802629:	89 e9                	mov    %ebp,%ecx
  80262b:	89 fa                	mov    %edi,%edx
  80262d:	d3 e6                	shl    %cl,%esi
  80262f:	09 d8                	or     %ebx,%eax
  802631:	f7 74 24 08          	divl   0x8(%esp)
  802635:	89 d1                	mov    %edx,%ecx
  802637:	89 f3                	mov    %esi,%ebx
  802639:	f7 64 24 0c          	mull   0xc(%esp)
  80263d:	89 c6                	mov    %eax,%esi
  80263f:	89 d7                	mov    %edx,%edi
  802641:	39 d1                	cmp    %edx,%ecx
  802643:	72 06                	jb     80264b <__umoddi3+0xfb>
  802645:	75 10                	jne    802657 <__umoddi3+0x107>
  802647:	39 c3                	cmp    %eax,%ebx
  802649:	73 0c                	jae    802657 <__umoddi3+0x107>
  80264b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80264f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802653:	89 d7                	mov    %edx,%edi
  802655:	89 c6                	mov    %eax,%esi
  802657:	89 ca                	mov    %ecx,%edx
  802659:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265e:	29 f3                	sub    %esi,%ebx
  802660:	19 fa                	sbb    %edi,%edx
  802662:	89 d0                	mov    %edx,%eax
  802664:	d3 e0                	shl    %cl,%eax
  802666:	89 e9                	mov    %ebp,%ecx
  802668:	d3 eb                	shr    %cl,%ebx
  80266a:	d3 ea                	shr    %cl,%edx
  80266c:	09 d8                	or     %ebx,%eax
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80267d:	8d 76 00             	lea    0x0(%esi),%esi
  802680:	89 da                	mov    %ebx,%edx
  802682:	29 fe                	sub    %edi,%esi
  802684:	19 c2                	sbb    %eax,%edx
  802686:	89 f1                	mov    %esi,%ecx
  802688:	89 c8                	mov    %ecx,%eax
  80268a:	e9 4b ff ff ff       	jmp    8025da <__umoddi3+0x8a>
