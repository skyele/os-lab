
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
  80003e:	68 c0 2c 80 00       	push   $0x802cc0
  800043:	e8 39 1e 00 00       	call   801e81 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 d1 1a 00 00       	call   801b31 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 f7 19 00 00       	call   801a6a <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 e3 13 00 00       	call   801468 <fork>
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
  800097:	e8 95 1a 00 00       	call   801b31 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  8000a3:	e8 25 03 00 00       	call   8003cd <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 af 19 00 00       	call   801a6a <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 50 80 00       	push   $0x805020
  8000cf:	68 20 52 80 00       	push   $0x805220
  8000d4:	e8 59 0c 00 00       	call   800d32 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 fb 2c 80 00       	push   $0x802cfb
  8000ec:	e8 dc 02 00 00       	call   8003cd <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 35 1a 00 00       	call   801b31 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 a1 17 00 00       	call   8018a5 <close>
		exit();
  800104:	e8 9a 01 00 00       	call   8002a3 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 c6 25 00 00       	call   8026db <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 42 19 00 00       	call   801a6a <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 14 2d 80 00       	push   $0x802d14
  80013b:	e8 8d 02 00 00       	call   8003cd <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 5d 17 00 00       	call   8018a5 <close>
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
  800155:	68 c5 2c 80 00       	push   $0x802cc5
  80015a:	6a 0c                	push   $0xc
  80015c:	68 d3 2c 80 00       	push   $0x802cd3
  800161:	e8 71 01 00 00       	call   8002d7 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 e8 2c 80 00       	push   $0x802ce8
  80016c:	6a 0f                	push   $0xf
  80016e:	68 d3 2c 80 00       	push   $0x802cd3
  800173:	e8 5f 01 00 00       	call   8002d7 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 f2 2c 80 00       	push   $0x802cf2
  80017e:	6a 12                	push   $0x12
  800180:	68 d3 2c 80 00       	push   $0x802cd3
  800185:	e8 4d 01 00 00       	call   8002d7 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 74 2d 80 00       	push   $0x802d74
  800194:	6a 17                	push   $0x17
  800196:	68 d3 2c 80 00       	push   $0x802cd3
  80019b:	e8 37 01 00 00       	call   8002d7 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 a0 2d 80 00       	push   $0x802da0
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 d3 2c 80 00       	push   $0x802cd3
  8001af:	e8 23 01 00 00       	call   8002d7 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 d8 2d 80 00       	push   $0x802dd8
  8001be:	6a 21                	push   $0x21
  8001c0:	68 d3 2c 80 00       	push   $0x802cd3
  8001c5:	e8 0d 01 00 00       	call   8002d7 <_panic>

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
  8001dd:	e8 fe 0c 00 00       	call   800ee0 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800241:	a1 20 54 80 00       	mov    0x805420,%eax
  800246:	8b 40 48             	mov    0x48(%eax),%eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	50                   	push   %eax
  80024d:	68 fb 2d 80 00       	push   $0x802dfb
  800252:	e8 76 01 00 00       	call   8003cd <cprintf>
	cprintf("before umain\n");
  800257:	c7 04 24 19 2e 80 00 	movl   $0x802e19,(%esp)
  80025e:	e8 6a 01 00 00       	call   8003cd <cprintf>
	// call user main routine
	umain(argc, argv);
  800263:	83 c4 08             	add    $0x8,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	e8 c2 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800271:	c7 04 24 27 2e 80 00 	movl   $0x802e27,(%esp)
  800278:	e8 50 01 00 00       	call   8003cd <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80027d:	a1 20 54 80 00       	mov    0x805420,%eax
  800282:	8b 40 48             	mov    0x48(%eax),%eax
  800285:	83 c4 08             	add    $0x8,%esp
  800288:	50                   	push   %eax
  800289:	68 34 2e 80 00       	push   $0x802e34
  80028e:	e8 3a 01 00 00       	call   8003cd <cprintf>
	// exit gracefully
	exit();
  800293:	e8 0b 00 00 00       	call   8002a3 <exit>
}
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002a9:	a1 20 54 80 00       	mov    0x805420,%eax
  8002ae:	8b 40 48             	mov    0x48(%eax),%eax
  8002b1:	68 60 2e 80 00       	push   $0x802e60
  8002b6:	50                   	push   %eax
  8002b7:	68 53 2e 80 00       	push   $0x802e53
  8002bc:	e8 0c 01 00 00       	call   8003cd <cprintf>
	close_all();
  8002c1:	e8 0c 16 00 00       	call   8018d2 <close_all>
	sys_env_destroy(0);
  8002c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002cd:	e8 cd 0b 00 00       	call   800e9f <sys_env_destroy>
}
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002dc:	a1 20 54 80 00       	mov    0x805420,%eax
  8002e1:	8b 40 48             	mov    0x48(%eax),%eax
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 8c 2e 80 00       	push   $0x802e8c
  8002ec:	50                   	push   %eax
  8002ed:	68 53 2e 80 00       	push   $0x802e53
  8002f2:	e8 d6 00 00 00       	call   8003cd <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002f7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fa:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800300:	e8 db 0b 00 00       	call   800ee0 <sys_getenvid>
  800305:	83 c4 04             	add    $0x4,%esp
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	56                   	push   %esi
  80030f:	50                   	push   %eax
  800310:	68 68 2e 80 00       	push   $0x802e68
  800315:	e8 b3 00 00 00       	call   8003cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031a:	83 c4 18             	add    $0x18,%esp
  80031d:	53                   	push   %ebx
  80031e:	ff 75 10             	pushl  0x10(%ebp)
  800321:	e8 56 00 00 00       	call   80037c <vcprintf>
	cprintf("\n");
  800326:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  80032d:	e8 9b 00 00 00       	call   8003cd <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800335:	cc                   	int3   
  800336:	eb fd                	jmp    800335 <_panic+0x5e>

00800338 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800342:	8b 13                	mov    (%ebx),%edx
  800344:	8d 42 01             	lea    0x1(%edx),%eax
  800347:	89 03                	mov    %eax,(%ebx)
  800349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800350:	3d ff 00 00 00       	cmp    $0xff,%eax
  800355:	74 09                	je     800360 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800357:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 ff 00 00 00       	push   $0xff
  800368:	8d 43 08             	lea    0x8(%ebx),%eax
  80036b:	50                   	push   %eax
  80036c:	e8 f1 0a 00 00       	call   800e62 <sys_cputs>
		b->idx = 0;
  800371:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	eb db                	jmp    800357 <putch+0x1f>

0080037c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800385:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038c:	00 00 00 
	b.cnt = 0;
  80038f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800396:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	68 38 03 80 00       	push   $0x800338
  8003ab:	e8 4a 01 00 00       	call   8004fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b0:	83 c4 08             	add    $0x8,%esp
  8003b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 9d 0a 00 00       	call   800e62 <sys_cputs>

	return b.cnt;
}
  8003c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d6:	50                   	push   %eax
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	e8 9d ff ff ff       	call   80037c <vcprintf>
	va_end(ap);

	return cnt;
}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	57                   	push   %edi
  8003e5:	56                   	push   %esi
  8003e6:	53                   	push   %ebx
  8003e7:	83 ec 1c             	sub    $0x1c,%esp
  8003ea:	89 c6                	mov    %eax,%esi
  8003ec:	89 d7                	mov    %edx,%edi
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800400:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800404:	74 2c                	je     800432 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800410:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800413:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800416:	39 c2                	cmp    %eax,%edx
  800418:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80041b:	73 43                	jae    800460 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80041d:	83 eb 01             	sub    $0x1,%ebx
  800420:	85 db                	test   %ebx,%ebx
  800422:	7e 6c                	jle    800490 <printnum+0xaf>
				putch(padc, putdat);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	57                   	push   %edi
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	ff d6                	call   *%esi
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	eb eb                	jmp    80041d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	6a 20                	push   $0x20
  800437:	6a 00                	push   $0x0
  800439:	50                   	push   %eax
  80043a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043d:	ff 75 e0             	pushl  -0x20(%ebp)
  800440:	89 fa                	mov    %edi,%edx
  800442:	89 f0                	mov    %esi,%eax
  800444:	e8 98 ff ff ff       	call   8003e1 <printnum>
		while (--width > 0)
  800449:	83 c4 20             	add    $0x20,%esp
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	85 db                	test   %ebx,%ebx
  800451:	7e 65                	jle    8004b8 <printnum+0xd7>
			putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	6a 20                	push   $0x20
  800459:	ff d6                	call   *%esi
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	eb ec                	jmp    80044c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	ff 75 18             	pushl  0x18(%ebp)
  800466:	83 eb 01             	sub    $0x1,%ebx
  800469:	53                   	push   %ebx
  80046a:	50                   	push   %eax
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	ff 75 e4             	pushl  -0x1c(%ebp)
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	e8 f1 25 00 00       	call   802a70 <__udivdi3>
  80047f:	83 c4 18             	add    $0x18,%esp
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	89 fa                	mov    %edi,%edx
  800486:	89 f0                	mov    %esi,%eax
  800488:	e8 54 ff ff ff       	call   8003e1 <printnum>
  80048d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	57                   	push   %edi
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	ff 75 dc             	pushl  -0x24(%ebp)
  80049a:	ff 75 d8             	pushl  -0x28(%ebp)
  80049d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a3:	e8 d8 26 00 00       	call   802b80 <__umoddi3>
  8004a8:	83 c4 14             	add    $0x14,%esp
  8004ab:	0f be 80 93 2e 80 00 	movsbl 0x802e93(%eax),%eax
  8004b2:	50                   	push   %eax
  8004b3:	ff d6                	call   *%esi
  8004b5:	83 c4 10             	add    $0x10,%esp
	}
}
  8004b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bb:	5b                   	pop    %ebx
  8004bc:	5e                   	pop    %esi
  8004bd:	5f                   	pop    %edi
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004cf:	73 0a                	jae    8004db <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d4:	89 08                	mov    %ecx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	88 02                	mov    %al,(%edx)
}
  8004db:	5d                   	pop    %ebp
  8004dc:	c3                   	ret    

008004dd <printfmt>:
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	ff 75 0c             	pushl  0xc(%ebp)
  8004ed:	ff 75 08             	pushl  0x8(%ebp)
  8004f0:	e8 05 00 00 00       	call   8004fa <vprintfmt>
}
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <vprintfmt>:
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
  800500:	83 ec 3c             	sub    $0x3c,%esp
  800503:	8b 75 08             	mov    0x8(%ebp),%esi
  800506:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800509:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050c:	e9 32 04 00 00       	jmp    800943 <vprintfmt+0x449>
		padc = ' ';
  800511:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800515:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80051c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800523:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80052a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800531:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800538:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8d 47 01             	lea    0x1(%edi),%eax
  800540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800543:	0f b6 17             	movzbl (%edi),%edx
  800546:	8d 42 dd             	lea    -0x23(%edx),%eax
  800549:	3c 55                	cmp    $0x55,%al
  80054b:	0f 87 12 05 00 00    	ja     800a63 <vprintfmt+0x569>
  800551:	0f b6 c0             	movzbl %al,%eax
  800554:	ff 24 85 80 30 80 00 	jmp    *0x803080(,%eax,4)
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80055e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800562:	eb d9                	jmp    80053d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800567:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80056b:	eb d0                	jmp    80053d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	0f b6 d2             	movzbl %dl,%edx
  800570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800573:	b8 00 00 00 00       	mov    $0x0,%eax
  800578:	89 75 08             	mov    %esi,0x8(%ebp)
  80057b:	eb 03                	jmp    800580 <vprintfmt+0x86>
  80057d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800580:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800583:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800587:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80058d:	83 fe 09             	cmp    $0x9,%esi
  800590:	76 eb                	jbe    80057d <vprintfmt+0x83>
  800592:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800595:	8b 75 08             	mov    0x8(%ebp),%esi
  800598:	eb 14                	jmp    8005ae <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b2:	79 89                	jns    80053d <vprintfmt+0x43>
				width = precision, precision = -1;
  8005b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005c1:	e9 77 ff ff ff       	jmp    80053d <vprintfmt+0x43>
  8005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c9:	85 c0                	test   %eax,%eax
  8005cb:	0f 48 c1             	cmovs  %ecx,%eax
  8005ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d4:	e9 64 ff ff ff       	jmp    80053d <vprintfmt+0x43>
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005e3:	e9 55 ff ff ff       	jmp    80053d <vprintfmt+0x43>
			lflag++;
  8005e8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ef:	e9 49 ff ff ff       	jmp    80053d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 78 04             	lea    0x4(%eax),%edi
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	ff 30                	pushl  (%eax)
  800600:	ff d6                	call   *%esi
			break;
  800602:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800605:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800608:	e9 33 03 00 00       	jmp    800940 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 78 04             	lea    0x4(%eax),%edi
  800613:	8b 00                	mov    (%eax),%eax
  800615:	99                   	cltd   
  800616:	31 d0                	xor    %edx,%eax
  800618:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061a:	83 f8 11             	cmp    $0x11,%eax
  80061d:	7f 23                	jg     800642 <vprintfmt+0x148>
  80061f:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	74 18                	je     800642 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80062a:	52                   	push   %edx
  80062b:	68 ed 33 80 00       	push   $0x8033ed
  800630:	53                   	push   %ebx
  800631:	56                   	push   %esi
  800632:	e8 a6 fe ff ff       	call   8004dd <printfmt>
  800637:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063d:	e9 fe 02 00 00       	jmp    800940 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800642:	50                   	push   %eax
  800643:	68 ab 2e 80 00       	push   $0x802eab
  800648:	53                   	push   %ebx
  800649:	56                   	push   %esi
  80064a:	e8 8e fe ff ff       	call   8004dd <printfmt>
  80064f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800652:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800655:	e9 e6 02 00 00       	jmp    800940 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 c0 04             	add    $0x4,%eax
  800660:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	b8 a4 2e 80 00       	mov    $0x802ea4,%eax
  80066f:	0f 45 c1             	cmovne %ecx,%eax
  800672:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800675:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800679:	7e 06                	jle    800681 <vprintfmt+0x187>
  80067b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80067f:	75 0d                	jne    80068e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800684:	89 c7                	mov    %eax,%edi
  800686:	03 45 e0             	add    -0x20(%ebp),%eax
  800689:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068c:	eb 53                	jmp    8006e1 <vprintfmt+0x1e7>
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 d8             	pushl  -0x28(%ebp)
  800694:	50                   	push   %eax
  800695:	e8 71 04 00 00       	call   800b0b <strnlen>
  80069a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069d:	29 c1                	sub    %eax,%ecx
  80069f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ae:	eb 0f                	jmp    8006bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b9:	83 ef 01             	sub    $0x1,%edi
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	85 ff                	test   %edi,%edi
  8006c1:	7f ed                	jg     8006b0 <vprintfmt+0x1b6>
  8006c3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006c6:	85 c9                	test   %ecx,%ecx
  8006c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cd:	0f 49 c1             	cmovns %ecx,%eax
  8006d0:	29 c1                	sub    %eax,%ecx
  8006d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006d5:	eb aa                	jmp    800681 <vprintfmt+0x187>
					putch(ch, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	52                   	push   %edx
  8006dc:	ff d6                	call   *%esi
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e6:	83 c7 01             	add    $0x1,%edi
  8006e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ed:	0f be d0             	movsbl %al,%edx
  8006f0:	85 d2                	test   %edx,%edx
  8006f2:	74 4b                	je     80073f <vprintfmt+0x245>
  8006f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f8:	78 06                	js     800700 <vprintfmt+0x206>
  8006fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006fe:	78 1e                	js     80071e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800700:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800704:	74 d1                	je     8006d7 <vprintfmt+0x1dd>
  800706:	0f be c0             	movsbl %al,%eax
  800709:	83 e8 20             	sub    $0x20,%eax
  80070c:	83 f8 5e             	cmp    $0x5e,%eax
  80070f:	76 c6                	jbe    8006d7 <vprintfmt+0x1dd>
					putch('?', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	6a 3f                	push   $0x3f
  800717:	ff d6                	call   *%esi
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	eb c3                	jmp    8006e1 <vprintfmt+0x1e7>
  80071e:	89 cf                	mov    %ecx,%edi
  800720:	eb 0e                	jmp    800730 <vprintfmt+0x236>
				putch(' ', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	6a 20                	push   $0x20
  800728:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072a:	83 ef 01             	sub    $0x1,%edi
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	85 ff                	test   %edi,%edi
  800732:	7f ee                	jg     800722 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
  80073a:	e9 01 02 00 00       	jmp    800940 <vprintfmt+0x446>
  80073f:	89 cf                	mov    %ecx,%edi
  800741:	eb ed                	jmp    800730 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800746:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80074d:	e9 eb fd ff ff       	jmp    80053d <vprintfmt+0x43>
	if (lflag >= 2)
  800752:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800756:	7f 21                	jg     800779 <vprintfmt+0x27f>
	else if (lflag)
  800758:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075c:	74 68                	je     8007c6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800766:	89 c1                	mov    %eax,%ecx
  800768:	c1 f9 1f             	sar    $0x1f,%ecx
  80076b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	eb 17                	jmp    800790 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800784:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 08             	lea    0x8(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800790:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80079c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a0:	78 3f                	js     8007e1 <vprintfmt+0x2e7>
			base = 10;
  8007a2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007a7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007ab:	0f 84 71 01 00 00    	je     800922 <vprintfmt+0x428>
				putch('+', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	6a 2b                	push   $0x2b
  8007b7:	ff d6                	call   *%esi
  8007b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c1:	e9 5c 01 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ce:	89 c1                	mov    %eax,%ecx
  8007d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 04             	lea    0x4(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	eb af                	jmp    800790 <vprintfmt+0x296>
				putch('-', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 2d                	push   $0x2d
  8007e7:	ff d6                	call   *%esi
				num = -(long long) num;
  8007e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ef:	f7 d8                	neg    %eax
  8007f1:	83 d2 00             	adc    $0x0,%edx
  8007f4:	f7 da                	neg    %edx
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800804:	e9 19 01 00 00       	jmp    800922 <vprintfmt+0x428>
	if (lflag >= 2)
  800809:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80080d:	7f 29                	jg     800838 <vprintfmt+0x33e>
	else if (lflag)
  80080f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800813:	74 44                	je     800859 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800822:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 40 04             	lea    0x4(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800833:	e9 ea 00 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 50 04             	mov    0x4(%eax),%edx
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8d 40 08             	lea    0x8(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800854:	e9 c9 00 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	ba 00 00 00 00       	mov    $0x0,%edx
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8d 40 04             	lea    0x4(%eax),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800872:	b8 0a 00 00 00       	mov    $0xa,%eax
  800877:	e9 a6 00 00 00       	jmp    800922 <vprintfmt+0x428>
			putch('0', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	53                   	push   %ebx
  800880:	6a 30                	push   $0x30
  800882:	ff d6                	call   *%esi
	if (lflag >= 2)
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088b:	7f 26                	jg     8008b3 <vprintfmt+0x3b9>
	else if (lflag)
  80088d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800891:	74 3e                	je     8008d1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	ba 00 00 00 00       	mov    $0x0,%edx
  80089d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8d 40 04             	lea    0x4(%eax),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b1:	eb 6f                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 50 04             	mov    0x4(%eax),%edx
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8d 40 08             	lea    0x8(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8008cf:	eb 51                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 04             	lea    0x4(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ef:	eb 31                	jmp    800922 <vprintfmt+0x428>
			putch('0', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	6a 30                	push   $0x30
  8008f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8008f9:	83 c4 08             	add    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	6a 78                	push   $0x78
  8008ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800911:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8d 40 04             	lea    0x4(%eax),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800929:	52                   	push   %edx
  80092a:	ff 75 e0             	pushl  -0x20(%ebp)
  80092d:	50                   	push   %eax
  80092e:	ff 75 dc             	pushl  -0x24(%ebp)
  800931:	ff 75 d8             	pushl  -0x28(%ebp)
  800934:	89 da                	mov    %ebx,%edx
  800936:	89 f0                	mov    %esi,%eax
  800938:	e8 a4 fa ff ff       	call   8003e1 <printnum>
			break;
  80093d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800943:	83 c7 01             	add    $0x1,%edi
  800946:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80094a:	83 f8 25             	cmp    $0x25,%eax
  80094d:	0f 84 be fb ff ff    	je     800511 <vprintfmt+0x17>
			if (ch == '\0')
  800953:	85 c0                	test   %eax,%eax
  800955:	0f 84 28 01 00 00    	je     800a83 <vprintfmt+0x589>
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	53                   	push   %ebx
  80095f:	50                   	push   %eax
  800960:	ff d6                	call   *%esi
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	eb dc                	jmp    800943 <vprintfmt+0x449>
	if (lflag >= 2)
  800967:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80096b:	7f 26                	jg     800993 <vprintfmt+0x499>
	else if (lflag)
  80096d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800971:	74 41                	je     8009b4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800983:	8b 45 14             	mov    0x14(%ebp),%eax
  800986:	8d 40 04             	lea    0x4(%eax),%eax
  800989:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098c:	b8 10 00 00 00       	mov    $0x10,%eax
  800991:	eb 8f                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 50 04             	mov    0x4(%eax),%edx
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	8d 40 08             	lea    0x8(%eax),%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8009af:	e9 6e ff ff ff       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d2:	e9 4b ff ff ff       	jmp    800922 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	74 14                	je     8009fd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009e9:	8b 13                	mov    (%ebx),%edx
  8009eb:	83 fa 7f             	cmp    $0x7f,%edx
  8009ee:	7f 37                	jg     800a27 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009f0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f8:	e9 43 ff ff ff       	jmp    800940 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a02:	bf c9 2f 80 00       	mov    $0x802fc9,%edi
							putch(ch, putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	53                   	push   %ebx
  800a0b:	50                   	push   %eax
  800a0c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a0e:	83 c7 01             	add    $0x1,%edi
  800a11:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	75 eb                	jne    800a07 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	e9 19 ff ff ff       	jmp    800940 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a27:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2e:	bf 01 30 80 00       	mov    $0x803001,%edi
							putch(ch, putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	53                   	push   %ebx
  800a37:	50                   	push   %eax
  800a38:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a3a:	83 c7 01             	add    $0x1,%edi
  800a3d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	85 c0                	test   %eax,%eax
  800a46:	75 eb                	jne    800a33 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4e:	e9 ed fe ff ff       	jmp    800940 <vprintfmt+0x446>
			putch(ch, putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	53                   	push   %ebx
  800a57:	6a 25                	push   $0x25
  800a59:	ff d6                	call   *%esi
			break;
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	e9 dd fe ff ff       	jmp    800940 <vprintfmt+0x446>
			putch('%', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	6a 25                	push   $0x25
  800a69:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	eb 03                	jmp    800a75 <vprintfmt+0x57b>
  800a72:	83 e8 01             	sub    $0x1,%eax
  800a75:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a79:	75 f7                	jne    800a72 <vprintfmt+0x578>
  800a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7e:	e9 bd fe ff ff       	jmp    800940 <vprintfmt+0x446>
}
  800a83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5f                   	pop    %edi
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 18             	sub    $0x18,%esp
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a9e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa8:	85 c0                	test   %eax,%eax
  800aaa:	74 26                	je     800ad2 <vsnprintf+0x47>
  800aac:	85 d2                	test   %edx,%edx
  800aae:	7e 22                	jle    800ad2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab0:	ff 75 14             	pushl  0x14(%ebp)
  800ab3:	ff 75 10             	pushl  0x10(%ebp)
  800ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab9:	50                   	push   %eax
  800aba:	68 c0 04 80 00       	push   $0x8004c0
  800abf:	e8 36 fa ff ff       	call   8004fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800acd:	83 c4 10             	add    $0x10,%esp
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    
		return -E_INVAL;
  800ad2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad7:	eb f7                	jmp    800ad0 <vsnprintf+0x45>

00800ad9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800adf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ae2:	50                   	push   %eax
  800ae3:	ff 75 10             	pushl  0x10(%ebp)
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 9a ff ff ff       	call   800a8b <vsnprintf>
	va_end(ap);

	return rc;
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800af9:	b8 00 00 00 00       	mov    $0x0,%eax
  800afe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b02:	74 05                	je     800b09 <strlen+0x16>
		n++;
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	eb f5                	jmp    800afe <strlen+0xb>
	return n;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b14:	ba 00 00 00 00       	mov    $0x0,%edx
  800b19:	39 c2                	cmp    %eax,%edx
  800b1b:	74 0d                	je     800b2a <strnlen+0x1f>
  800b1d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b21:	74 05                	je     800b28 <strnlen+0x1d>
		n++;
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	eb f1                	jmp    800b19 <strnlen+0xe>
  800b28:	89 d0                	mov    %edx,%eax
	return n;
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	53                   	push   %ebx
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b3f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b42:	83 c2 01             	add    $0x1,%edx
  800b45:	84 c9                	test   %cl,%cl
  800b47:	75 f2                	jne    800b3b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 10             	sub    $0x10,%esp
  800b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b56:	53                   	push   %ebx
  800b57:	e8 97 ff ff ff       	call   800af3 <strlen>
  800b5c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	01 d8                	add    %ebx,%eax
  800b64:	50                   	push   %eax
  800b65:	e8 c2 ff ff ff       	call   800b2c <strcpy>
	return dst;
}
  800b6a:	89 d8                	mov    %ebx,%eax
  800b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7c:	89 c6                	mov    %eax,%esi
  800b7e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b81:	89 c2                	mov    %eax,%edx
  800b83:	39 f2                	cmp    %esi,%edx
  800b85:	74 11                	je     800b98 <strncpy+0x27>
		*dst++ = *src;
  800b87:	83 c2 01             	add    $0x1,%edx
  800b8a:	0f b6 19             	movzbl (%ecx),%ebx
  800b8d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b90:	80 fb 01             	cmp    $0x1,%bl
  800b93:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b96:	eb eb                	jmp    800b83 <strncpy+0x12>
	}
	return ret;
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba7:	8b 55 10             	mov    0x10(%ebp),%edx
  800baa:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bac:	85 d2                	test   %edx,%edx
  800bae:	74 21                	je     800bd1 <strlcpy+0x35>
  800bb0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb6:	39 c2                	cmp    %eax,%edx
  800bb8:	74 14                	je     800bce <strlcpy+0x32>
  800bba:	0f b6 19             	movzbl (%ecx),%ebx
  800bbd:	84 db                	test   %bl,%bl
  800bbf:	74 0b                	je     800bcc <strlcpy+0x30>
			*dst++ = *src++;
  800bc1:	83 c1 01             	add    $0x1,%ecx
  800bc4:	83 c2 01             	add    $0x1,%edx
  800bc7:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bca:	eb ea                	jmp    800bb6 <strlcpy+0x1a>
  800bcc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd1:	29 f0                	sub    %esi,%eax
}
  800bd3:	5b                   	pop    %ebx
  800bd4:	5e                   	pop    %esi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be0:	0f b6 01             	movzbl (%ecx),%eax
  800be3:	84 c0                	test   %al,%al
  800be5:	74 0c                	je     800bf3 <strcmp+0x1c>
  800be7:	3a 02                	cmp    (%edx),%al
  800be9:	75 08                	jne    800bf3 <strcmp+0x1c>
		p++, q++;
  800beb:	83 c1 01             	add    $0x1,%ecx
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	eb ed                	jmp    800be0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf3:	0f b6 c0             	movzbl %al,%eax
  800bf6:	0f b6 12             	movzbl (%edx),%edx
  800bf9:	29 d0                	sub    %edx,%eax
}
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	53                   	push   %ebx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c07:	89 c3                	mov    %eax,%ebx
  800c09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c0c:	eb 06                	jmp    800c14 <strncmp+0x17>
		n--, p++, q++;
  800c0e:	83 c0 01             	add    $0x1,%eax
  800c11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c14:	39 d8                	cmp    %ebx,%eax
  800c16:	74 16                	je     800c2e <strncmp+0x31>
  800c18:	0f b6 08             	movzbl (%eax),%ecx
  800c1b:	84 c9                	test   %cl,%cl
  800c1d:	74 04                	je     800c23 <strncmp+0x26>
  800c1f:	3a 0a                	cmp    (%edx),%cl
  800c21:	74 eb                	je     800c0e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c23:	0f b6 00             	movzbl (%eax),%eax
  800c26:	0f b6 12             	movzbl (%edx),%edx
  800c29:	29 d0                	sub    %edx,%eax
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    
		return 0;
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	eb f6                	jmp    800c2b <strncmp+0x2e>

00800c35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c3f:	0f b6 10             	movzbl (%eax),%edx
  800c42:	84 d2                	test   %dl,%dl
  800c44:	74 09                	je     800c4f <strchr+0x1a>
		if (*s == c)
  800c46:	38 ca                	cmp    %cl,%dl
  800c48:	74 0a                	je     800c54 <strchr+0x1f>
	for (; *s; s++)
  800c4a:	83 c0 01             	add    $0x1,%eax
  800c4d:	eb f0                	jmp    800c3f <strchr+0xa>
			return (char *) s;
	return 0;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c60:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c63:	38 ca                	cmp    %cl,%dl
  800c65:	74 09                	je     800c70 <strfind+0x1a>
  800c67:	84 d2                	test   %dl,%dl
  800c69:	74 05                	je     800c70 <strfind+0x1a>
	for (; *s; s++)
  800c6b:	83 c0 01             	add    $0x1,%eax
  800c6e:	eb f0                	jmp    800c60 <strfind+0xa>
			break;
	return (char *) s;
}
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c7e:	85 c9                	test   %ecx,%ecx
  800c80:	74 31                	je     800cb3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c82:	89 f8                	mov    %edi,%eax
  800c84:	09 c8                	or     %ecx,%eax
  800c86:	a8 03                	test   $0x3,%al
  800c88:	75 23                	jne    800cad <memset+0x3b>
		c &= 0xFF;
  800c8a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c8e:	89 d3                	mov    %edx,%ebx
  800c90:	c1 e3 08             	shl    $0x8,%ebx
  800c93:	89 d0                	mov    %edx,%eax
  800c95:	c1 e0 18             	shl    $0x18,%eax
  800c98:	89 d6                	mov    %edx,%esi
  800c9a:	c1 e6 10             	shl    $0x10,%esi
  800c9d:	09 f0                	or     %esi,%eax
  800c9f:	09 c2                	or     %eax,%edx
  800ca1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ca3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ca6:	89 d0                	mov    %edx,%eax
  800ca8:	fc                   	cld    
  800ca9:	f3 ab                	rep stos %eax,%es:(%edi)
  800cab:	eb 06                	jmp    800cb3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	fc                   	cld    
  800cb1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb3:	89 f8                	mov    %edi,%eax
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc8:	39 c6                	cmp    %eax,%esi
  800cca:	73 32                	jae    800cfe <memmove+0x44>
  800ccc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ccf:	39 c2                	cmp    %eax,%edx
  800cd1:	76 2b                	jbe    800cfe <memmove+0x44>
		s += n;
		d += n;
  800cd3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd6:	89 fe                	mov    %edi,%esi
  800cd8:	09 ce                	or     %ecx,%esi
  800cda:	09 d6                	or     %edx,%esi
  800cdc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce2:	75 0e                	jne    800cf2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ce4:	83 ef 04             	sub    $0x4,%edi
  800ce7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ced:	fd                   	std    
  800cee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf0:	eb 09                	jmp    800cfb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cf2:	83 ef 01             	sub    $0x1,%edi
  800cf5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cf8:	fd                   	std    
  800cf9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cfb:	fc                   	cld    
  800cfc:	eb 1a                	jmp    800d18 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cfe:	89 c2                	mov    %eax,%edx
  800d00:	09 ca                	or     %ecx,%edx
  800d02:	09 f2                	or     %esi,%edx
  800d04:	f6 c2 03             	test   $0x3,%dl
  800d07:	75 0a                	jne    800d13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d0c:	89 c7                	mov    %eax,%edi
  800d0e:	fc                   	cld    
  800d0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d11:	eb 05                	jmp    800d18 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d13:	89 c7                	mov    %eax,%edi
  800d15:	fc                   	cld    
  800d16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d22:	ff 75 10             	pushl  0x10(%ebp)
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 8a ff ff ff       	call   800cba <memmove>
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3d:	89 c6                	mov    %eax,%esi
  800d3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d42:	39 f0                	cmp    %esi,%eax
  800d44:	74 1c                	je     800d62 <memcmp+0x30>
		if (*s1 != *s2)
  800d46:	0f b6 08             	movzbl (%eax),%ecx
  800d49:	0f b6 1a             	movzbl (%edx),%ebx
  800d4c:	38 d9                	cmp    %bl,%cl
  800d4e:	75 08                	jne    800d58 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d50:	83 c0 01             	add    $0x1,%eax
  800d53:	83 c2 01             	add    $0x1,%edx
  800d56:	eb ea                	jmp    800d42 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d58:	0f b6 c1             	movzbl %cl,%eax
  800d5b:	0f b6 db             	movzbl %bl,%ebx
  800d5e:	29 d8                	sub    %ebx,%eax
  800d60:	eb 05                	jmp    800d67 <memcmp+0x35>
	}

	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d79:	39 d0                	cmp    %edx,%eax
  800d7b:	73 09                	jae    800d86 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d7d:	38 08                	cmp    %cl,(%eax)
  800d7f:	74 05                	je     800d86 <memfind+0x1b>
	for (; s < ends; s++)
  800d81:	83 c0 01             	add    $0x1,%eax
  800d84:	eb f3                	jmp    800d79 <memfind+0xe>
			break;
	return (void *) s;
}
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d94:	eb 03                	jmp    800d99 <strtol+0x11>
		s++;
  800d96:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d99:	0f b6 01             	movzbl (%ecx),%eax
  800d9c:	3c 20                	cmp    $0x20,%al
  800d9e:	74 f6                	je     800d96 <strtol+0xe>
  800da0:	3c 09                	cmp    $0x9,%al
  800da2:	74 f2                	je     800d96 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800da4:	3c 2b                	cmp    $0x2b,%al
  800da6:	74 2a                	je     800dd2 <strtol+0x4a>
	int neg = 0;
  800da8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dad:	3c 2d                	cmp    $0x2d,%al
  800daf:	74 2b                	je     800ddc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800db7:	75 0f                	jne    800dc8 <strtol+0x40>
  800db9:	80 39 30             	cmpb   $0x30,(%ecx)
  800dbc:	74 28                	je     800de6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dbe:	85 db                	test   %ebx,%ebx
  800dc0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc5:	0f 44 d8             	cmove  %eax,%ebx
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd0:	eb 50                	jmp    800e22 <strtol+0x9a>
		s++;
  800dd2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800dda:	eb d5                	jmp    800db1 <strtol+0x29>
		s++, neg = 1;
  800ddc:	83 c1 01             	add    $0x1,%ecx
  800ddf:	bf 01 00 00 00       	mov    $0x1,%edi
  800de4:	eb cb                	jmp    800db1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dea:	74 0e                	je     800dfa <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dec:	85 db                	test   %ebx,%ebx
  800dee:	75 d8                	jne    800dc8 <strtol+0x40>
		s++, base = 8;
  800df0:	83 c1 01             	add    $0x1,%ecx
  800df3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800df8:	eb ce                	jmp    800dc8 <strtol+0x40>
		s += 2, base = 16;
  800dfa:	83 c1 02             	add    $0x2,%ecx
  800dfd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e02:	eb c4                	jmp    800dc8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e04:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e07:	89 f3                	mov    %esi,%ebx
  800e09:	80 fb 19             	cmp    $0x19,%bl
  800e0c:	77 29                	ja     800e37 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e0e:	0f be d2             	movsbl %dl,%edx
  800e11:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e17:	7d 30                	jge    800e49 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e22:	0f b6 11             	movzbl (%ecx),%edx
  800e25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e28:	89 f3                	mov    %esi,%ebx
  800e2a:	80 fb 09             	cmp    $0x9,%bl
  800e2d:	77 d5                	ja     800e04 <strtol+0x7c>
			dig = *s - '0';
  800e2f:	0f be d2             	movsbl %dl,%edx
  800e32:	83 ea 30             	sub    $0x30,%edx
  800e35:	eb dd                	jmp    800e14 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e37:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e3a:	89 f3                	mov    %esi,%ebx
  800e3c:	80 fb 19             	cmp    $0x19,%bl
  800e3f:	77 08                	ja     800e49 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e41:	0f be d2             	movsbl %dl,%edx
  800e44:	83 ea 37             	sub    $0x37,%edx
  800e47:	eb cb                	jmp    800e14 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4d:	74 05                	je     800e54 <strtol+0xcc>
		*endptr = (char *) s;
  800e4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	f7 da                	neg    %edx
  800e58:	85 ff                	test   %edi,%edi
  800e5a:	0f 45 c2             	cmovne %edx,%eax
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	89 c3                	mov    %eax,%ebx
  800e75:	89 c7                	mov    %eax,%edi
  800e77:	89 c6                	mov    %eax,%esi
  800e79:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  800e90:	89 d1                	mov    %edx,%ecx
  800e92:	89 d3                	mov    %edx,%ebx
  800e94:	89 d7                	mov    %edx,%edi
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb5:	89 cb                	mov    %ecx,%ebx
  800eb7:	89 cf                	mov    %ecx,%edi
  800eb9:	89 ce                	mov    %ecx,%esi
  800ebb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 03                	push   $0x3
  800ecf:	68 28 32 80 00       	push   $0x803228
  800ed4:	6a 43                	push   $0x43
  800ed6:	68 45 32 80 00       	push   $0x803245
  800edb:	e8 f7 f3 ff ff       	call   8002d7 <_panic>

00800ee0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	ba 00 00 00 00       	mov    $0x0,%edx
  800eeb:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef0:	89 d1                	mov    %edx,%ecx
  800ef2:	89 d3                	mov    %edx,%ebx
  800ef4:	89 d7                	mov    %edx,%edi
  800ef6:	89 d6                	mov    %edx,%esi
  800ef8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <sys_yield>:

void
sys_yield(void)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f05:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 d3                	mov    %edx,%ebx
  800f13:	89 d7                	mov    %edx,%edi
  800f15:	89 d6                	mov    %edx,%esi
  800f17:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	be 00 00 00 00       	mov    $0x0,%esi
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 04 00 00 00       	mov    $0x4,%eax
  800f37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3a:	89 f7                	mov    %esi,%edi
  800f3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	7f 08                	jg     800f4a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	50                   	push   %eax
  800f4e:	6a 04                	push   $0x4
  800f50:	68 28 32 80 00       	push   $0x803228
  800f55:	6a 43                	push   $0x43
  800f57:	68 45 32 80 00       	push   $0x803245
  800f5c:	e8 76 f3 ff ff       	call   8002d7 <_panic>

00800f61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
  800f67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	b8 05 00 00 00       	mov    $0x5,%eax
  800f75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7b:	8b 75 18             	mov    0x18(%ebp),%esi
  800f7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f80:	85 c0                	test   %eax,%eax
  800f82:	7f 08                	jg     800f8c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8c:	83 ec 0c             	sub    $0xc,%esp
  800f8f:	50                   	push   %eax
  800f90:	6a 05                	push   $0x5
  800f92:	68 28 32 80 00       	push   $0x803228
  800f97:	6a 43                	push   $0x43
  800f99:	68 45 32 80 00       	push   $0x803245
  800f9e:	e8 34 f3 ff ff       	call   8002d7 <_panic>

00800fa3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb7:	b8 06 00 00 00       	mov    $0x6,%eax
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 06                	push   $0x6
  800fd4:	68 28 32 80 00       	push   $0x803228
  800fd9:	6a 43                	push   $0x43
  800fdb:	68 45 32 80 00       	push   $0x803245
  800fe0:	e8 f2 f2 ff ff       	call   8002d7 <_panic>

00800fe5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff9:	b8 08 00 00 00       	mov    $0x8,%eax
  800ffe:	89 df                	mov    %ebx,%edi
  801000:	89 de                	mov    %ebx,%esi
  801002:	cd 30                	int    $0x30
	if(check && ret > 0)
  801004:	85 c0                	test   %eax,%eax
  801006:	7f 08                	jg     801010 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801008:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5f                   	pop    %edi
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801010:	83 ec 0c             	sub    $0xc,%esp
  801013:	50                   	push   %eax
  801014:	6a 08                	push   $0x8
  801016:	68 28 32 80 00       	push   $0x803228
  80101b:	6a 43                	push   $0x43
  80101d:	68 45 32 80 00       	push   $0x803245
  801022:	e8 b0 f2 ff ff       	call   8002d7 <_panic>

00801027 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	b8 09 00 00 00       	mov    $0x9,%eax
  801040:	89 df                	mov    %ebx,%edi
  801042:	89 de                	mov    %ebx,%esi
  801044:	cd 30                	int    $0x30
	if(check && ret > 0)
  801046:	85 c0                	test   %eax,%eax
  801048:	7f 08                	jg     801052 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	50                   	push   %eax
  801056:	6a 09                	push   $0x9
  801058:	68 28 32 80 00       	push   $0x803228
  80105d:	6a 43                	push   $0x43
  80105f:	68 45 32 80 00       	push   $0x803245
  801064:	e8 6e f2 ff ff       	call   8002d7 <_panic>

00801069 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801082:	89 df                	mov    %ebx,%edi
  801084:	89 de                	mov    %ebx,%esi
  801086:	cd 30                	int    $0x30
	if(check && ret > 0)
  801088:	85 c0                	test   %eax,%eax
  80108a:	7f 08                	jg     801094 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 0a                	push   $0xa
  80109a:	68 28 32 80 00       	push   $0x803228
  80109f:	6a 43                	push   $0x43
  8010a1:	68 45 32 80 00       	push   $0x803245
  8010a6:	e8 2c f2 ff ff       	call   8002d7 <_panic>

008010ab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010bc:	be 00 00 00 00       	mov    $0x0,%esi
  8010c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c9:	5b                   	pop    %ebx
  8010ca:	5e                   	pop    %esi
  8010cb:	5f                   	pop    %edi
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e4:	89 cb                	mov    %ecx,%ebx
  8010e6:	89 cf                	mov    %ecx,%edi
  8010e8:	89 ce                	mov    %ecx,%esi
  8010ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	7f 08                	jg     8010f8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5f                   	pop    %edi
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	50                   	push   %eax
  8010fc:	6a 0d                	push   $0xd
  8010fe:	68 28 32 80 00       	push   $0x803228
  801103:	6a 43                	push   $0x43
  801105:	68 45 32 80 00       	push   $0x803245
  80110a:	e8 c8 f1 ff ff       	call   8002d7 <_panic>

0080110f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
	asm volatile("int %1\n"
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111a:	8b 55 08             	mov    0x8(%ebp),%edx
  80111d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801120:	b8 0e 00 00 00       	mov    $0xe,%eax
  801125:	89 df                	mov    %ebx,%edi
  801127:	89 de                	mov    %ebx,%esi
  801129:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5f                   	pop    %edi
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	57                   	push   %edi
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
	asm volatile("int %1\n"
  801136:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801143:	89 cb                	mov    %ecx,%ebx
  801145:	89 cf                	mov    %ecx,%edi
  801147:	89 ce                	mov    %ecx,%esi
  801149:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	57                   	push   %edi
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
	asm volatile("int %1\n"
  801156:	ba 00 00 00 00       	mov    $0x0,%edx
  80115b:	b8 10 00 00 00       	mov    $0x10,%eax
  801160:	89 d1                	mov    %edx,%ecx
  801162:	89 d3                	mov    %edx,%ebx
  801164:	89 d7                	mov    %edx,%edi
  801166:	89 d6                	mov    %edx,%esi
  801168:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
	asm volatile("int %1\n"
  801175:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117a:	8b 55 08             	mov    0x8(%ebp),%edx
  80117d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801180:	b8 11 00 00 00       	mov    $0x11,%eax
  801185:	89 df                	mov    %ebx,%edi
  801187:	89 de                	mov    %ebx,%esi
  801189:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	57                   	push   %edi
  801194:	56                   	push   %esi
  801195:	53                   	push   %ebx
	asm volatile("int %1\n"
  801196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a1:	b8 12 00 00 00       	mov    $0x12,%eax
  8011a6:	89 df                	mov    %ebx,%edi
  8011a8:	89 de                	mov    %ebx,%esi
  8011aa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c5:	b8 13 00 00 00       	mov    $0x13,%eax
  8011ca:	89 df                	mov    %ebx,%edi
  8011cc:	89 de                	mov    %ebx,%esi
  8011ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	7f 08                	jg     8011dc <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	50                   	push   %eax
  8011e0:	6a 13                	push   $0x13
  8011e2:	68 28 32 80 00       	push   $0x803228
  8011e7:	6a 43                	push   $0x43
  8011e9:	68 45 32 80 00       	push   $0x803245
  8011ee:	e8 e4 f0 ff ff       	call   8002d7 <_panic>

008011f3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	57                   	push   %edi
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801201:	b8 14 00 00 00       	mov    $0x14,%eax
  801206:	89 cb                	mov    %ecx,%ebx
  801208:	89 cf                	mov    %ecx,%edi
  80120a:	89 ce                	mov    %ecx,%esi
  80120c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	53                   	push   %ebx
  801217:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80121a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801221:	f6 c5 04             	test   $0x4,%ch
  801224:	75 45                	jne    80126b <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801226:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80122d:	83 e1 07             	and    $0x7,%ecx
  801230:	83 f9 07             	cmp    $0x7,%ecx
  801233:	74 6f                	je     8012a4 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801235:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80123c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801242:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801248:	0f 84 b6 00 00 00    	je     801304 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80124e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801255:	83 e1 05             	and    $0x5,%ecx
  801258:	83 f9 05             	cmp    $0x5,%ecx
  80125b:	0f 84 d7 00 00 00    	je     801338 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801261:	b8 00 00 00 00       	mov    $0x0,%eax
  801266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801269:	c9                   	leave  
  80126a:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80126b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801272:	c1 e2 0c             	shl    $0xc,%edx
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80127e:	51                   	push   %ecx
  80127f:	52                   	push   %edx
  801280:	50                   	push   %eax
  801281:	52                   	push   %edx
  801282:	6a 00                	push   $0x0
  801284:	e8 d8 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  801289:	83 c4 20             	add    $0x20,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	79 d1                	jns    801261 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	68 53 32 80 00       	push   $0x803253
  801298:	6a 54                	push   $0x54
  80129a:	68 69 32 80 00       	push   $0x803269
  80129f:	e8 33 f0 ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012a4:	89 d3                	mov    %edx,%ebx
  8012a6:	c1 e3 0c             	shl    $0xc,%ebx
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	68 05 08 00 00       	push   $0x805
  8012b1:	53                   	push   %ebx
  8012b2:	50                   	push   %eax
  8012b3:	53                   	push   %ebx
  8012b4:	6a 00                	push   $0x0
  8012b6:	e8 a6 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  8012bb:	83 c4 20             	add    $0x20,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 2e                	js     8012f0 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	68 05 08 00 00       	push   $0x805
  8012ca:	53                   	push   %ebx
  8012cb:	6a 00                	push   $0x0
  8012cd:	53                   	push   %ebx
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 8c fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  8012d5:	83 c4 20             	add    $0x20,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	79 85                	jns    801261 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012dc:	83 ec 04             	sub    $0x4,%esp
  8012df:	68 53 32 80 00       	push   $0x803253
  8012e4:	6a 5f                	push   $0x5f
  8012e6:	68 69 32 80 00       	push   $0x803269
  8012eb:	e8 e7 ef ff ff       	call   8002d7 <_panic>
			panic("sys_page_map() panic\n");
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	68 53 32 80 00       	push   $0x803253
  8012f8:	6a 5b                	push   $0x5b
  8012fa:	68 69 32 80 00       	push   $0x803269
  8012ff:	e8 d3 ef ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801304:	c1 e2 0c             	shl    $0xc,%edx
  801307:	83 ec 0c             	sub    $0xc,%esp
  80130a:	68 05 08 00 00       	push   $0x805
  80130f:	52                   	push   %edx
  801310:	50                   	push   %eax
  801311:	52                   	push   %edx
  801312:	6a 00                	push   $0x0
  801314:	e8 48 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  801319:	83 c4 20             	add    $0x20,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	0f 89 3d ff ff ff    	jns    801261 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	68 53 32 80 00       	push   $0x803253
  80132c:	6a 66                	push   $0x66
  80132e:	68 69 32 80 00       	push   $0x803269
  801333:	e8 9f ef ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801338:	c1 e2 0c             	shl    $0xc,%edx
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	6a 05                	push   $0x5
  801340:	52                   	push   %edx
  801341:	50                   	push   %eax
  801342:	52                   	push   %edx
  801343:	6a 00                	push   $0x0
  801345:	e8 17 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  80134a:	83 c4 20             	add    $0x20,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	0f 89 0c ff ff ff    	jns    801261 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	68 53 32 80 00       	push   $0x803253
  80135d:	6a 6d                	push   $0x6d
  80135f:	68 69 32 80 00       	push   $0x803269
  801364:	e8 6e ef ff ff       	call   8002d7 <_panic>

00801369 <pgfault>:
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	53                   	push   %ebx
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801373:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801375:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801379:	0f 84 99 00 00 00    	je     801418 <pgfault+0xaf>
  80137f:	89 c2                	mov    %eax,%edx
  801381:	c1 ea 16             	shr    $0x16,%edx
  801384:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	0f 84 84 00 00 00    	je     801418 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801394:	89 c2                	mov    %eax,%edx
  801396:	c1 ea 0c             	shr    $0xc,%edx
  801399:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a0:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013a6:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013ac:	75 6a                	jne    801418 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	6a 07                	push   $0x7
  8013ba:	68 00 f0 7f 00       	push   $0x7ff000
  8013bf:	6a 00                	push   $0x0
  8013c1:	e8 58 fb ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 5f                	js     80142c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	68 00 10 00 00       	push   $0x1000
  8013d5:	53                   	push   %ebx
  8013d6:	68 00 f0 7f 00       	push   $0x7ff000
  8013db:	e8 3c f9 ff ff       	call   800d1c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013e0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013e7:	53                   	push   %ebx
  8013e8:	6a 00                	push   $0x0
  8013ea:	68 00 f0 7f 00       	push   $0x7ff000
  8013ef:	6a 00                	push   $0x0
  8013f1:	e8 6b fb ff ff       	call   800f61 <sys_page_map>
	if(ret < 0)
  8013f6:	83 c4 20             	add    $0x20,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 43                	js     801440 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	68 00 f0 7f 00       	push   $0x7ff000
  801405:	6a 00                	push   $0x0
  801407:	e8 97 fb ff ff       	call   800fa3 <sys_page_unmap>
	if(ret < 0)
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 41                	js     801454 <pgfault+0xeb>
}
  801413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801416:	c9                   	leave  
  801417:	c3                   	ret    
		panic("panic at pgfault()\n");
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	68 74 32 80 00       	push   $0x803274
  801420:	6a 26                	push   $0x26
  801422:	68 69 32 80 00       	push   $0x803269
  801427:	e8 ab ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_alloc()\n");
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 88 32 80 00       	push   $0x803288
  801434:	6a 31                	push   $0x31
  801436:	68 69 32 80 00       	push   $0x803269
  80143b:	e8 97 ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_map()\n");
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	68 a3 32 80 00       	push   $0x8032a3
  801448:	6a 36                	push   $0x36
  80144a:	68 69 32 80 00       	push   $0x803269
  80144f:	e8 83 ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_unmap()\n");
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	68 bc 32 80 00       	push   $0x8032bc
  80145c:	6a 39                	push   $0x39
  80145e:	68 69 32 80 00       	push   $0x803269
  801463:	e8 6f ee ff ff       	call   8002d7 <_panic>

00801468 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	57                   	push   %edi
  80146c:	56                   	push   %esi
  80146d:	53                   	push   %ebx
  80146e:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801471:	68 69 13 80 00       	push   $0x801369
  801476:	e8 24 14 00 00       	call   80289f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80147b:	b8 07 00 00 00       	mov    $0x7,%eax
  801480:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 27                	js     8014b0 <fork+0x48>
  801489:	89 c6                	mov    %eax,%esi
  80148b:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80148d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801492:	75 48                	jne    8014dc <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801494:	e8 47 fa ff ff       	call   800ee0 <sys_getenvid>
  801499:	25 ff 03 00 00       	and    $0x3ff,%eax
  80149e:	c1 e0 07             	shl    $0x7,%eax
  8014a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014a6:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8014ab:	e9 90 00 00 00       	jmp    801540 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 d8 32 80 00       	push   $0x8032d8
  8014b8:	68 8c 00 00 00       	push   $0x8c
  8014bd:	68 69 32 80 00       	push   $0x803269
  8014c2:	e8 10 ee ff ff       	call   8002d7 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014c7:	89 f8                	mov    %edi,%eax
  8014c9:	e8 45 fd ff ff       	call   801213 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d4:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014da:	74 26                	je     801502 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014dc:	89 d8                	mov    %ebx,%eax
  8014de:	c1 e8 16             	shr    $0x16,%eax
  8014e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e8:	a8 01                	test   $0x1,%al
  8014ea:	74 e2                	je     8014ce <fork+0x66>
  8014ec:	89 da                	mov    %ebx,%edx
  8014ee:	c1 ea 0c             	shr    $0xc,%edx
  8014f1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014f8:	83 e0 05             	and    $0x5,%eax
  8014fb:	83 f8 05             	cmp    $0x5,%eax
  8014fe:	75 ce                	jne    8014ce <fork+0x66>
  801500:	eb c5                	jmp    8014c7 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	6a 07                	push   $0x7
  801507:	68 00 f0 bf ee       	push   $0xeebff000
  80150c:	56                   	push   %esi
  80150d:	e8 0c fa ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	78 31                	js     80154a <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	68 0e 29 80 00       	push   $0x80290e
  801521:	56                   	push   %esi
  801522:	e8 42 fb ff ff       	call   801069 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 33                	js     801561 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	6a 02                	push   $0x2
  801533:	56                   	push   %esi
  801534:	e8 ac fa ff ff       	call   800fe5 <sys_env_set_status>
	if(ret < 0)
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 38                	js     801578 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801540:	89 f0                	mov    %esi,%eax
  801542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5f                   	pop    %edi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 88 32 80 00       	push   $0x803288
  801552:	68 98 00 00 00       	push   $0x98
  801557:	68 69 32 80 00       	push   $0x803269
  80155c:	e8 76 ed ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 fc 32 80 00       	push   $0x8032fc
  801569:	68 9b 00 00 00       	push   $0x9b
  80156e:	68 69 32 80 00       	push   $0x803269
  801573:	e8 5f ed ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_status()\n");
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	68 24 33 80 00       	push   $0x803324
  801580:	68 9e 00 00 00       	push   $0x9e
  801585:	68 69 32 80 00       	push   $0x803269
  80158a:	e8 48 ed ff ff       	call   8002d7 <_panic>

0080158f <sfork>:

// Challenge!
int
sfork(void)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	57                   	push   %edi
  801593:	56                   	push   %esi
  801594:	53                   	push   %ebx
  801595:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801598:	68 69 13 80 00       	push   $0x801369
  80159d:	e8 fd 12 00 00       	call   80289f <set_pgfault_handler>
  8015a2:	b8 07 00 00 00       	mov    $0x7,%eax
  8015a7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 27                	js     8015d7 <sfork+0x48>
  8015b0:	89 c7                	mov    %eax,%edi
  8015b2:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015b4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015b9:	75 55                	jne    801610 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015bb:	e8 20 f9 ff ff       	call   800ee0 <sys_getenvid>
  8015c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015c5:	c1 e0 07             	shl    $0x7,%eax
  8015c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015cd:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8015d2:	e9 d4 00 00 00       	jmp    8016ab <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	68 d8 32 80 00       	push   $0x8032d8
  8015df:	68 af 00 00 00       	push   $0xaf
  8015e4:	68 69 32 80 00       	push   $0x803269
  8015e9:	e8 e9 ec ff ff       	call   8002d7 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015ee:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015f3:	89 f0                	mov    %esi,%eax
  8015f5:	e8 19 fc ff ff       	call   801213 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801600:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801606:	77 65                	ja     80166d <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801608:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80160e:	74 de                	je     8015ee <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801610:	89 d8                	mov    %ebx,%eax
  801612:	c1 e8 16             	shr    $0x16,%eax
  801615:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80161c:	a8 01                	test   $0x1,%al
  80161e:	74 da                	je     8015fa <sfork+0x6b>
  801620:	89 da                	mov    %ebx,%edx
  801622:	c1 ea 0c             	shr    $0xc,%edx
  801625:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80162c:	83 e0 05             	and    $0x5,%eax
  80162f:	83 f8 05             	cmp    $0x5,%eax
  801632:	75 c6                	jne    8015fa <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801634:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80163b:	c1 e2 0c             	shl    $0xc,%edx
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	83 e0 07             	and    $0x7,%eax
  801644:	50                   	push   %eax
  801645:	52                   	push   %edx
  801646:	56                   	push   %esi
  801647:	52                   	push   %edx
  801648:	6a 00                	push   $0x0
  80164a:	e8 12 f9 ff ff       	call   800f61 <sys_page_map>
  80164f:	83 c4 20             	add    $0x20,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	74 a4                	je     8015fa <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	68 53 32 80 00       	push   $0x803253
  80165e:	68 ba 00 00 00       	push   $0xba
  801663:	68 69 32 80 00       	push   $0x803269
  801668:	e8 6a ec ff ff       	call   8002d7 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	6a 07                	push   $0x7
  801672:	68 00 f0 bf ee       	push   $0xeebff000
  801677:	57                   	push   %edi
  801678:	e8 a1 f8 ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 31                	js     8016b5 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	68 0e 29 80 00       	push   $0x80290e
  80168c:	57                   	push   %edi
  80168d:	e8 d7 f9 ff ff       	call   801069 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 33                	js     8016cc <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	6a 02                	push   $0x2
  80169e:	57                   	push   %edi
  80169f:	e8 41 f9 ff ff       	call   800fe5 <sys_env_set_status>
	if(ret < 0)
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 38                	js     8016e3 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016ab:	89 f8                	mov    %edi,%eax
  8016ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5f                   	pop    %edi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 88 32 80 00       	push   $0x803288
  8016bd:	68 c0 00 00 00       	push   $0xc0
  8016c2:	68 69 32 80 00       	push   $0x803269
  8016c7:	e8 0b ec ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 fc 32 80 00       	push   $0x8032fc
  8016d4:	68 c3 00 00 00       	push   $0xc3
  8016d9:	68 69 32 80 00       	push   $0x803269
  8016de:	e8 f4 eb ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	68 24 33 80 00       	push   $0x803324
  8016eb:	68 c6 00 00 00       	push   $0xc6
  8016f0:	68 69 32 80 00       	push   $0x803269
  8016f5:	e8 dd eb ff ff       	call   8002d7 <_panic>

008016fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	05 00 00 00 30       	add    $0x30000000,%eax
  801705:	c1 e8 0c             	shr    $0xc,%eax
}
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801715:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80171f:	5d                   	pop    %ebp
  801720:	c3                   	ret    

00801721 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801729:	89 c2                	mov    %eax,%edx
  80172b:	c1 ea 16             	shr    $0x16,%edx
  80172e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801735:	f6 c2 01             	test   $0x1,%dl
  801738:	74 2d                	je     801767 <fd_alloc+0x46>
  80173a:	89 c2                	mov    %eax,%edx
  80173c:	c1 ea 0c             	shr    $0xc,%edx
  80173f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801746:	f6 c2 01             	test   $0x1,%dl
  801749:	74 1c                	je     801767 <fd_alloc+0x46>
  80174b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801750:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801755:	75 d2                	jne    801729 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801760:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801765:	eb 0a                	jmp    801771 <fd_alloc+0x50>
			*fd_store = fd;
  801767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801779:	83 f8 1f             	cmp    $0x1f,%eax
  80177c:	77 30                	ja     8017ae <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80177e:	c1 e0 0c             	shl    $0xc,%eax
  801781:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801786:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80178c:	f6 c2 01             	test   $0x1,%dl
  80178f:	74 24                	je     8017b5 <fd_lookup+0x42>
  801791:	89 c2                	mov    %eax,%edx
  801793:	c1 ea 0c             	shr    $0xc,%edx
  801796:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179d:	f6 c2 01             	test   $0x1,%dl
  8017a0:	74 1a                	je     8017bc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    
		return -E_INVAL;
  8017ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b3:	eb f7                	jmp    8017ac <fd_lookup+0x39>
		return -E_INVAL;
  8017b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ba:	eb f0                	jmp    8017ac <fd_lookup+0x39>
  8017bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c1:	eb e9                	jmp    8017ac <fd_lookup+0x39>

008017c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
  8017c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017d6:	39 08                	cmp    %ecx,(%eax)
  8017d8:	74 38                	je     801812 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017da:	83 c2 01             	add    $0x1,%edx
  8017dd:	8b 04 95 c0 33 80 00 	mov    0x8033c0(,%edx,4),%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	75 ee                	jne    8017d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017e8:	a1 20 54 80 00       	mov    0x805420,%eax
  8017ed:	8b 40 48             	mov    0x48(%eax),%eax
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	51                   	push   %ecx
  8017f4:	50                   	push   %eax
  8017f5:	68 44 33 80 00       	push   $0x803344
  8017fa:	e8 ce eb ff ff       	call   8003cd <cprintf>
	*dev = 0;
  8017ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    
			*dev = devtab[i];
  801812:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801815:	89 01                	mov    %eax,(%ecx)
			return 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	eb f2                	jmp    801810 <dev_lookup+0x4d>

0080181e <fd_close>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	57                   	push   %edi
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
  801824:	83 ec 24             	sub    $0x24,%esp
  801827:	8b 75 08             	mov    0x8(%ebp),%esi
  80182a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80182d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801830:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801831:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801837:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80183a:	50                   	push   %eax
  80183b:	e8 33 ff ff ff       	call   801773 <fd_lookup>
  801840:	89 c3                	mov    %eax,%ebx
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	78 05                	js     80184e <fd_close+0x30>
	    || fd != fd2)
  801849:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80184c:	74 16                	je     801864 <fd_close+0x46>
		return (must_exist ? r : 0);
  80184e:	89 f8                	mov    %edi,%eax
  801850:	84 c0                	test   %al,%al
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	0f 44 d8             	cmove  %eax,%ebx
}
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801864:	83 ec 08             	sub    $0x8,%esp
  801867:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80186a:	50                   	push   %eax
  80186b:	ff 36                	pushl  (%esi)
  80186d:	e8 51 ff ff ff       	call   8017c3 <dev_lookup>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 1a                	js     801895 <fd_close+0x77>
		if (dev->dev_close)
  80187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801881:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801886:	85 c0                	test   %eax,%eax
  801888:	74 0b                	je     801895 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	56                   	push   %esi
  80188e:	ff d0                	call   *%eax
  801890:	89 c3                	mov    %eax,%ebx
  801892:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801895:	83 ec 08             	sub    $0x8,%esp
  801898:	56                   	push   %esi
  801899:	6a 00                	push   $0x0
  80189b:	e8 03 f7 ff ff       	call   800fa3 <sys_page_unmap>
	return r;
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	eb b5                	jmp    80185a <fd_close+0x3c>

008018a5 <close>:

int
close(int fdnum)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ae:	50                   	push   %eax
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	e8 bc fe ff ff       	call   801773 <fd_lookup>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	79 02                	jns    8018c0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    
		return fd_close(fd, 1);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	6a 01                	push   $0x1
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	e8 51 ff ff ff       	call   80181e <fd_close>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	eb ec                	jmp    8018be <close+0x19>

008018d2 <close_all>:

void
close_all(void)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	53                   	push   %ebx
  8018d6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	53                   	push   %ebx
  8018e2:	e8 be ff ff ff       	call   8018a5 <close>
	for (i = 0; i < MAXFD; i++)
  8018e7:	83 c3 01             	add    $0x1,%ebx
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	83 fb 20             	cmp    $0x20,%ebx
  8018f0:	75 ec                	jne    8018de <close_all+0xc>
}
  8018f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	57                   	push   %edi
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801900:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801903:	50                   	push   %eax
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	e8 67 fe ff ff       	call   801773 <fd_lookup>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	0f 88 81 00 00 00    	js     80199a <dup+0xa3>
		return r;
	close(newfdnum);
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	e8 81 ff ff ff       	call   8018a5 <close>

	newfd = INDEX2FD(newfdnum);
  801924:	8b 75 0c             	mov    0xc(%ebp),%esi
  801927:	c1 e6 0c             	shl    $0xc,%esi
  80192a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801930:	83 c4 04             	add    $0x4,%esp
  801933:	ff 75 e4             	pushl  -0x1c(%ebp)
  801936:	e8 cf fd ff ff       	call   80170a <fd2data>
  80193b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80193d:	89 34 24             	mov    %esi,(%esp)
  801940:	e8 c5 fd ff ff       	call   80170a <fd2data>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80194a:	89 d8                	mov    %ebx,%eax
  80194c:	c1 e8 16             	shr    $0x16,%eax
  80194f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801956:	a8 01                	test   $0x1,%al
  801958:	74 11                	je     80196b <dup+0x74>
  80195a:	89 d8                	mov    %ebx,%eax
  80195c:	c1 e8 0c             	shr    $0xc,%eax
  80195f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801966:	f6 c2 01             	test   $0x1,%dl
  801969:	75 39                	jne    8019a4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80196b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	c1 e8 0c             	shr    $0xc,%eax
  801973:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80197a:	83 ec 0c             	sub    $0xc,%esp
  80197d:	25 07 0e 00 00       	and    $0xe07,%eax
  801982:	50                   	push   %eax
  801983:	56                   	push   %esi
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	6a 00                	push   $0x0
  801989:	e8 d3 f5 ff ff       	call   800f61 <sys_page_map>
  80198e:	89 c3                	mov    %eax,%ebx
  801990:	83 c4 20             	add    $0x20,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 31                	js     8019c8 <dup+0xd1>
		goto err;

	return newfdnum;
  801997:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80199a:	89 d8                	mov    %ebx,%eax
  80199c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5f                   	pop    %edi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8019b3:	50                   	push   %eax
  8019b4:	57                   	push   %edi
  8019b5:	6a 00                	push   $0x0
  8019b7:	53                   	push   %ebx
  8019b8:	6a 00                	push   $0x0
  8019ba:	e8 a2 f5 ff ff       	call   800f61 <sys_page_map>
  8019bf:	89 c3                	mov    %eax,%ebx
  8019c1:	83 c4 20             	add    $0x20,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	79 a3                	jns    80196b <dup+0x74>
	sys_page_unmap(0, newfd);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	56                   	push   %esi
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 d0 f5 ff ff       	call   800fa3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019d3:	83 c4 08             	add    $0x8,%esp
  8019d6:	57                   	push   %edi
  8019d7:	6a 00                	push   $0x0
  8019d9:	e8 c5 f5 ff ff       	call   800fa3 <sys_page_unmap>
	return r;
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	eb b7                	jmp    80199a <dup+0xa3>

008019e3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 1c             	sub    $0x1c,%esp
  8019ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f0:	50                   	push   %eax
  8019f1:	53                   	push   %ebx
  8019f2:	e8 7c fd ff ff       	call   801773 <fd_lookup>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 3f                	js     801a3d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019fe:	83 ec 08             	sub    $0x8,%esp
  801a01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a04:	50                   	push   %eax
  801a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a08:	ff 30                	pushl  (%eax)
  801a0a:	e8 b4 fd ff ff       	call   8017c3 <dev_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 27                	js     801a3d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a19:	8b 42 08             	mov    0x8(%edx),%eax
  801a1c:	83 e0 03             	and    $0x3,%eax
  801a1f:	83 f8 01             	cmp    $0x1,%eax
  801a22:	74 1e                	je     801a42 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	8b 40 08             	mov    0x8(%eax),%eax
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	74 35                	je     801a63 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	52                   	push   %edx
  801a38:	ff d0                	call   *%eax
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a42:	a1 20 54 80 00       	mov    0x805420,%eax
  801a47:	8b 40 48             	mov    0x48(%eax),%eax
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	53                   	push   %ebx
  801a4e:	50                   	push   %eax
  801a4f:	68 85 33 80 00       	push   $0x803385
  801a54:	e8 74 e9 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a61:	eb da                	jmp    801a3d <read+0x5a>
		return -E_NOT_SUPP;
  801a63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a68:	eb d3                	jmp    801a3d <read+0x5a>

00801a6a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	57                   	push   %edi
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a76:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a79:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7e:	39 f3                	cmp    %esi,%ebx
  801a80:	73 23                	jae    801aa5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	89 f0                	mov    %esi,%eax
  801a87:	29 d8                	sub    %ebx,%eax
  801a89:	50                   	push   %eax
  801a8a:	89 d8                	mov    %ebx,%eax
  801a8c:	03 45 0c             	add    0xc(%ebp),%eax
  801a8f:	50                   	push   %eax
  801a90:	57                   	push   %edi
  801a91:	e8 4d ff ff ff       	call   8019e3 <read>
		if (m < 0)
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 06                	js     801aa3 <readn+0x39>
			return m;
		if (m == 0)
  801a9d:	74 06                	je     801aa5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a9f:	01 c3                	add    %eax,%ebx
  801aa1:	eb db                	jmp    801a7e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5f                   	pop    %edi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    

00801aaf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	83 ec 1c             	sub    $0x1c,%esp
  801ab6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abc:	50                   	push   %eax
  801abd:	53                   	push   %ebx
  801abe:	e8 b0 fc ff ff       	call   801773 <fd_lookup>
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 3a                	js     801b04 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad0:	50                   	push   %eax
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	ff 30                	pushl  (%eax)
  801ad6:	e8 e8 fc ff ff       	call   8017c3 <dev_lookup>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 22                	js     801b04 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ae9:	74 1e                	je     801b09 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aee:	8b 52 0c             	mov    0xc(%edx),%edx
  801af1:	85 d2                	test   %edx,%edx
  801af3:	74 35                	je     801b2a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	ff d2                	call   *%edx
  801b01:	83 c4 10             	add    $0x10,%esp
}
  801b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b09:	a1 20 54 80 00       	mov    0x805420,%eax
  801b0e:	8b 40 48             	mov    0x48(%eax),%eax
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	53                   	push   %ebx
  801b15:	50                   	push   %eax
  801b16:	68 a1 33 80 00       	push   $0x8033a1
  801b1b:	e8 ad e8 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b28:	eb da                	jmp    801b04 <write+0x55>
		return -E_NOT_SUPP;
  801b2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b2f:	eb d3                	jmp    801b04 <write+0x55>

00801b31 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	e8 30 fc ff ff       	call   801773 <fd_lookup>
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 0e                	js     801b58 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b50:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 1c             	sub    $0x1c,%esp
  801b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	53                   	push   %ebx
  801b69:	e8 05 fc ff ff       	call   801773 <fd_lookup>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 37                	js     801bac <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b75:	83 ec 08             	sub    $0x8,%esp
  801b78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7b:	50                   	push   %eax
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	ff 30                	pushl  (%eax)
  801b81:	e8 3d fc ff ff       	call   8017c3 <dev_lookup>
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 1f                	js     801bac <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b90:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b94:	74 1b                	je     801bb1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b99:	8b 52 18             	mov    0x18(%edx),%edx
  801b9c:	85 d2                	test   %edx,%edx
  801b9e:	74 32                	je     801bd2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	50                   	push   %eax
  801ba7:	ff d2                	call   *%edx
  801ba9:	83 c4 10             	add    $0x10,%esp
}
  801bac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bb1:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bb6:	8b 40 48             	mov    0x48(%eax),%eax
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	53                   	push   %ebx
  801bbd:	50                   	push   %eax
  801bbe:	68 64 33 80 00       	push   $0x803364
  801bc3:	e8 05 e8 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd0:	eb da                	jmp    801bac <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bd2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd7:	eb d3                	jmp    801bac <ftruncate+0x52>

00801bd9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 1c             	sub    $0x1c,%esp
  801be0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be6:	50                   	push   %eax
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	e8 84 fb ff ff       	call   801773 <fd_lookup>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 4b                	js     801c41 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf6:	83 ec 08             	sub    $0x8,%esp
  801bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c00:	ff 30                	pushl  (%eax)
  801c02:	e8 bc fb ff ff       	call   8017c3 <dev_lookup>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 33                	js     801c41 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c11:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c15:	74 2f                	je     801c46 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c17:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c1a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c21:	00 00 00 
	stat->st_isdir = 0;
  801c24:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c2b:	00 00 00 
	stat->st_dev = dev;
  801c2e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	53                   	push   %ebx
  801c38:	ff 75 f0             	pushl  -0x10(%ebp)
  801c3b:	ff 50 14             	call   *0x14(%eax)
  801c3e:	83 c4 10             	add    $0x10,%esp
}
  801c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    
		return -E_NOT_SUPP;
  801c46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c4b:	eb f4                	jmp    801c41 <fstat+0x68>

00801c4d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	56                   	push   %esi
  801c51:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	e8 22 02 00 00       	call   801e81 <open>
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 1b                	js     801c83 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	50                   	push   %eax
  801c6f:	e8 65 ff ff ff       	call   801bd9 <fstat>
  801c74:	89 c6                	mov    %eax,%esi
	close(fd);
  801c76:	89 1c 24             	mov    %ebx,(%esp)
  801c79:	e8 27 fc ff ff       	call   8018a5 <close>
	return r;
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	89 f3                	mov    %esi,%ebx
}
  801c83:	89 d8                	mov    %ebx,%eax
  801c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	89 c6                	mov    %eax,%esi
  801c93:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c95:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c9c:	74 27                	je     801cc5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c9e:	6a 07                	push   $0x7
  801ca0:	68 00 60 80 00       	push   $0x806000
  801ca5:	56                   	push   %esi
  801ca6:	ff 35 00 50 80 00    	pushl  0x805000
  801cac:	e8 ec 0c 00 00       	call   80299d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cb1:	83 c4 0c             	add    $0xc,%esp
  801cb4:	6a 00                	push   $0x0
  801cb6:	53                   	push   %ebx
  801cb7:	6a 00                	push   $0x0
  801cb9:	e8 76 0c 00 00       	call   802934 <ipc_recv>
}
  801cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc1:	5b                   	pop    %ebx
  801cc2:	5e                   	pop    %esi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cc5:	83 ec 0c             	sub    $0xc,%esp
  801cc8:	6a 01                	push   $0x1
  801cca:	e8 26 0d 00 00       	call   8029f5 <ipc_find_env>
  801ccf:	a3 00 50 80 00       	mov    %eax,0x805000
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	eb c5                	jmp    801c9e <fsipc+0x12>

00801cd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ced:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cfc:	e8 8b ff ff ff       	call   801c8c <fsipc>
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <devfile_flush>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1e:	e8 69 ff ff ff       	call   801c8c <fsipc>
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <devfile_stat>:
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	53                   	push   %ebx
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8b 40 0c             	mov    0xc(%eax),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d44:	e8 43 ff ff ff       	call   801c8c <fsipc>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 2c                	js     801d79 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	68 00 60 80 00       	push   $0x806000
  801d55:	53                   	push   %ebx
  801d56:	e8 d1 ed ff ff       	call   800b2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d5b:	a1 80 60 80 00       	mov    0x806080,%eax
  801d60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d66:	a1 84 60 80 00       	mov    0x806084,%eax
  801d6b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <devfile_write>:
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	53                   	push   %ebx
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d93:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d99:	53                   	push   %ebx
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	68 08 60 80 00       	push   $0x806008
  801da2:	e8 75 ef ff ff       	call   800d1c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801da7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dac:	b8 04 00 00 00       	mov    $0x4,%eax
  801db1:	e8 d6 fe ff ff       	call   801c8c <fsipc>
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	78 0b                	js     801dc8 <devfile_write+0x4a>
	assert(r <= n);
  801dbd:	39 d8                	cmp    %ebx,%eax
  801dbf:	77 0c                	ja     801dcd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dc1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc6:	7f 1e                	jg     801de6 <devfile_write+0x68>
}
  801dc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    
	assert(r <= n);
  801dcd:	68 d4 33 80 00       	push   $0x8033d4
  801dd2:	68 db 33 80 00       	push   $0x8033db
  801dd7:	68 98 00 00 00       	push   $0x98
  801ddc:	68 f0 33 80 00       	push   $0x8033f0
  801de1:	e8 f1 e4 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  801de6:	68 fb 33 80 00       	push   $0x8033fb
  801deb:	68 db 33 80 00       	push   $0x8033db
  801df0:	68 99 00 00 00       	push   $0x99
  801df5:	68 f0 33 80 00       	push   $0x8033f0
  801dfa:	e8 d8 e4 ff ff       	call   8002d7 <_panic>

00801dff <devfile_read>:
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e12:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e18:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1d:	b8 03 00 00 00       	mov    $0x3,%eax
  801e22:	e8 65 fe ff ff       	call   801c8c <fsipc>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 1f                	js     801e4c <devfile_read+0x4d>
	assert(r <= n);
  801e2d:	39 f0                	cmp    %esi,%eax
  801e2f:	77 24                	ja     801e55 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e36:	7f 33                	jg     801e6b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	50                   	push   %eax
  801e3c:	68 00 60 80 00       	push   $0x806000
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	e8 71 ee ff ff       	call   800cba <memmove>
	return r;
  801e49:	83 c4 10             	add    $0x10,%esp
}
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    
	assert(r <= n);
  801e55:	68 d4 33 80 00       	push   $0x8033d4
  801e5a:	68 db 33 80 00       	push   $0x8033db
  801e5f:	6a 7c                	push   $0x7c
  801e61:	68 f0 33 80 00       	push   $0x8033f0
  801e66:	e8 6c e4 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  801e6b:	68 fb 33 80 00       	push   $0x8033fb
  801e70:	68 db 33 80 00       	push   $0x8033db
  801e75:	6a 7d                	push   $0x7d
  801e77:	68 f0 33 80 00       	push   $0x8033f0
  801e7c:	e8 56 e4 ff ff       	call   8002d7 <_panic>

00801e81 <open>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	83 ec 1c             	sub    $0x1c,%esp
  801e89:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e8c:	56                   	push   %esi
  801e8d:	e8 61 ec ff ff       	call   800af3 <strlen>
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e9a:	7f 6c                	jg     801f08 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	e8 79 f8 ff ff       	call   801721 <fd_alloc>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 3c                	js     801eed <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	56                   	push   %esi
  801eb5:	68 00 60 80 00       	push   $0x806000
  801eba:	e8 6d ec ff ff       	call   800b2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecf:	e8 b8 fd ff ff       	call   801c8c <fsipc>
  801ed4:	89 c3                	mov    %eax,%ebx
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	78 19                	js     801ef6 <open+0x75>
	return fd2num(fd);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee3:	e8 12 f8 ff ff       	call   8016fa <fd2num>
  801ee8:	89 c3                	mov    %eax,%ebx
  801eea:	83 c4 10             	add    $0x10,%esp
}
  801eed:	89 d8                	mov    %ebx,%eax
  801eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
		fd_close(fd, 0);
  801ef6:	83 ec 08             	sub    $0x8,%esp
  801ef9:	6a 00                	push   $0x0
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	e8 1b f9 ff ff       	call   80181e <fd_close>
		return r;
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	eb e5                	jmp    801eed <open+0x6c>
		return -E_BAD_PATH;
  801f08:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f0d:	eb de                	jmp    801eed <open+0x6c>

00801f0f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f15:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1a:	b8 08 00 00 00       	mov    $0x8,%eax
  801f1f:	e8 68 fd ff ff       	call   801c8c <fsipc>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f2c:	68 07 34 80 00       	push   $0x803407
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	e8 f3 eb ff ff       	call   800b2c <strcpy>
	return 0;
}
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <devsock_close>:
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	53                   	push   %ebx
  801f44:	83 ec 10             	sub    $0x10,%esp
  801f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f4a:	53                   	push   %ebx
  801f4b:	e8 e0 0a 00 00       	call   802a30 <pageref>
  801f50:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f53:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f58:	83 f8 01             	cmp    $0x1,%eax
  801f5b:	74 07                	je     801f64 <devsock_close+0x24>
}
  801f5d:	89 d0                	mov    %edx,%eax
  801f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	ff 73 0c             	pushl  0xc(%ebx)
  801f6a:	e8 b9 02 00 00       	call   802228 <nsipc_close>
  801f6f:	89 c2                	mov    %eax,%edx
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	eb e7                	jmp    801f5d <devsock_close+0x1d>

00801f76 <devsock_write>:
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	ff 75 10             	pushl  0x10(%ebp)
  801f81:	ff 75 0c             	pushl  0xc(%ebp)
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	ff 70 0c             	pushl  0xc(%eax)
  801f8a:	e8 76 03 00 00       	call   802305 <nsipc_send>
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <devsock_read>:
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 10             	pushl  0x10(%ebp)
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	ff 70 0c             	pushl  0xc(%eax)
  801fa5:	e8 ef 02 00 00       	call   802299 <nsipc_recv>
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <fd2sockid>:
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fb2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	e8 b7 f7 ff ff       	call   801773 <fd_lookup>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 10                	js     801fd3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fcc:	39 08                	cmp    %ecx,(%eax)
  801fce:	75 05                	jne    801fd5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fd0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    
		return -E_NOT_SUPP;
  801fd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fda:	eb f7                	jmp    801fd3 <fd2sockid+0x27>

00801fdc <alloc_sockfd>:
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	56                   	push   %esi
  801fe0:	53                   	push   %ebx
  801fe1:	83 ec 1c             	sub    $0x1c,%esp
  801fe4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	e8 32 f7 ff ff       	call   801721 <fd_alloc>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 43                	js     80203b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 07 04 00 00       	push   $0x407
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	6a 00                	push   $0x0
  802005:	e8 14 ef ff ff       	call   800f1e <sys_page_alloc>
  80200a:	89 c3                	mov    %eax,%ebx
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	85 c0                	test   %eax,%eax
  802011:	78 28                	js     80203b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80201c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802028:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	50                   	push   %eax
  80202f:	e8 c6 f6 ff ff       	call   8016fa <fd2num>
  802034:	89 c3                	mov    %eax,%ebx
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	eb 0c                	jmp    802047 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	56                   	push   %esi
  80203f:	e8 e4 01 00 00       	call   802228 <nsipc_close>
		return r;
  802044:	83 c4 10             	add    $0x10,%esp
}
  802047:	89 d8                	mov    %ebx,%eax
  802049:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <accept>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	e8 4e ff ff ff       	call   801fac <fd2sockid>
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 1b                	js     80207d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	ff 75 10             	pushl  0x10(%ebp)
  802068:	ff 75 0c             	pushl  0xc(%ebp)
  80206b:	50                   	push   %eax
  80206c:	e8 0e 01 00 00       	call   80217f <nsipc_accept>
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	85 c0                	test   %eax,%eax
  802076:	78 05                	js     80207d <accept+0x2d>
	return alloc_sockfd(r);
  802078:	e8 5f ff ff ff       	call   801fdc <alloc_sockfd>
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <bind>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	e8 1f ff ff ff       	call   801fac <fd2sockid>
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 12                	js     8020a3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	ff 75 10             	pushl  0x10(%ebp)
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	50                   	push   %eax
  80209b:	e8 31 01 00 00       	call   8021d1 <nsipc_bind>
  8020a0:	83 c4 10             	add    $0x10,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <shutdown>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	e8 f9 fe ff ff       	call   801fac <fd2sockid>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 0f                	js     8020c6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020b7:	83 ec 08             	sub    $0x8,%esp
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	50                   	push   %eax
  8020be:	e8 43 01 00 00       	call   802206 <nsipc_shutdown>
  8020c3:	83 c4 10             	add    $0x10,%esp
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <connect>:
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	e8 d6 fe ff ff       	call   801fac <fd2sockid>
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 12                	js     8020ec <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	ff 75 10             	pushl  0x10(%ebp)
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	50                   	push   %eax
  8020e4:	e8 59 01 00 00       	call   802242 <nsipc_connect>
  8020e9:	83 c4 10             	add    $0x10,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <listen>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	e8 b0 fe ff ff       	call   801fac <fd2sockid>
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 0f                	js     80210f <listen+0x21>
	return nsipc_listen(r, backlog);
  802100:	83 ec 08             	sub    $0x8,%esp
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	50                   	push   %eax
  802107:	e8 6b 01 00 00       	call   802277 <nsipc_listen>
  80210c:	83 c4 10             	add    $0x10,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <socket>:

int
socket(int domain, int type, int protocol)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802117:	ff 75 10             	pushl  0x10(%ebp)
  80211a:	ff 75 0c             	pushl  0xc(%ebp)
  80211d:	ff 75 08             	pushl  0x8(%ebp)
  802120:	e8 3e 02 00 00       	call   802363 <nsipc_socket>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 05                	js     802131 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80212c:	e8 ab fe ff ff       	call   801fdc <alloc_sockfd>
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80213c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802143:	74 26                	je     80216b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802145:	6a 07                	push   $0x7
  802147:	68 00 70 80 00       	push   $0x807000
  80214c:	53                   	push   %ebx
  80214d:	ff 35 04 50 80 00    	pushl  0x805004
  802153:	e8 45 08 00 00       	call   80299d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802158:	83 c4 0c             	add    $0xc,%esp
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	e8 ce 07 00 00       	call   802934 <ipc_recv>
}
  802166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802169:	c9                   	leave  
  80216a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	6a 02                	push   $0x2
  802170:	e8 80 08 00 00       	call   8029f5 <ipc_find_env>
  802175:	a3 04 50 80 00       	mov    %eax,0x805004
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	eb c6                	jmp    802145 <nsipc+0x12>

0080217f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	56                   	push   %esi
  802183:	53                   	push   %ebx
  802184:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80218f:	8b 06                	mov    (%esi),%eax
  802191:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802196:	b8 01 00 00 00       	mov    $0x1,%eax
  80219b:	e8 93 ff ff ff       	call   802133 <nsipc>
  8021a0:	89 c3                	mov    %eax,%ebx
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	79 09                	jns    8021af <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021a6:	89 d8                	mov    %ebx,%eax
  8021a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5e                   	pop    %esi
  8021ad:	5d                   	pop    %ebp
  8021ae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	ff 35 10 70 80 00    	pushl  0x807010
  8021b8:	68 00 70 80 00       	push   $0x807000
  8021bd:	ff 75 0c             	pushl  0xc(%ebp)
  8021c0:	e8 f5 ea ff ff       	call   800cba <memmove>
		*addrlen = ret->ret_addrlen;
  8021c5:	a1 10 70 80 00       	mov    0x807010,%eax
  8021ca:	89 06                	mov    %eax,(%esi)
  8021cc:	83 c4 10             	add    $0x10,%esp
	return r;
  8021cf:	eb d5                	jmp    8021a6 <nsipc_accept+0x27>

008021d1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 08             	sub    $0x8,%esp
  8021d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021e3:	53                   	push   %ebx
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	68 04 70 80 00       	push   $0x807004
  8021ec:	e8 c9 ea ff ff       	call   800cba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8021fc:	e8 32 ff ff ff       	call   802133 <nsipc>
}
  802201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802214:	8b 45 0c             	mov    0xc(%ebp),%eax
  802217:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80221c:	b8 03 00 00 00       	mov    $0x3,%eax
  802221:	e8 0d ff ff ff       	call   802133 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <nsipc_close>:

int
nsipc_close(int s)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802236:	b8 04 00 00 00       	mov    $0x4,%eax
  80223b:	e8 f3 fe ff ff       	call   802133 <nsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	53                   	push   %ebx
  802246:	83 ec 08             	sub    $0x8,%esp
  802249:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802254:	53                   	push   %ebx
  802255:	ff 75 0c             	pushl  0xc(%ebp)
  802258:	68 04 70 80 00       	push   $0x807004
  80225d:	e8 58 ea ff ff       	call   800cba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802262:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802268:	b8 05 00 00 00       	mov    $0x5,%eax
  80226d:	e8 c1 fe ff ff       	call   802133 <nsipc>
}
  802272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802285:	8b 45 0c             	mov    0xc(%ebp),%eax
  802288:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80228d:	b8 06 00 00 00       	mov    $0x6,%eax
  802292:	e8 9c fe ff ff       	call   802133 <nsipc>
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	56                   	push   %esi
  80229d:	53                   	push   %ebx
  80229e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022a9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022af:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022b7:	b8 07 00 00 00       	mov    $0x7,%eax
  8022bc:	e8 72 fe ff ff       	call   802133 <nsipc>
  8022c1:	89 c3                	mov    %eax,%ebx
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	78 1f                	js     8022e6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022c7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022cc:	7f 21                	jg     8022ef <nsipc_recv+0x56>
  8022ce:	39 c6                	cmp    %eax,%esi
  8022d0:	7c 1d                	jl     8022ef <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	50                   	push   %eax
  8022d6:	68 00 70 80 00       	push   $0x807000
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	e8 d7 e9 ff ff       	call   800cba <memmove>
  8022e3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022e6:	89 d8                	mov    %ebx,%eax
  8022e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5d                   	pop    %ebp
  8022ee:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022ef:	68 13 34 80 00       	push   $0x803413
  8022f4:	68 db 33 80 00       	push   $0x8033db
  8022f9:	6a 62                	push   $0x62
  8022fb:	68 28 34 80 00       	push   $0x803428
  802300:	e8 d2 df ff ff       	call   8002d7 <_panic>

00802305 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	53                   	push   %ebx
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802317:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80231d:	7f 2e                	jg     80234d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80231f:	83 ec 04             	sub    $0x4,%esp
  802322:	53                   	push   %ebx
  802323:	ff 75 0c             	pushl  0xc(%ebp)
  802326:	68 0c 70 80 00       	push   $0x80700c
  80232b:	e8 8a e9 ff ff       	call   800cba <memmove>
	nsipcbuf.send.req_size = size;
  802330:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802336:	8b 45 14             	mov    0x14(%ebp),%eax
  802339:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80233e:	b8 08 00 00 00       	mov    $0x8,%eax
  802343:	e8 eb fd ff ff       	call   802133 <nsipc>
}
  802348:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    
	assert(size < 1600);
  80234d:	68 34 34 80 00       	push   $0x803434
  802352:	68 db 33 80 00       	push   $0x8033db
  802357:	6a 6d                	push   $0x6d
  802359:	68 28 34 80 00       	push   $0x803428
  80235e:	e8 74 df ff ff       	call   8002d7 <_panic>

00802363 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802379:	8b 45 10             	mov    0x10(%ebp),%eax
  80237c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802381:	b8 09 00 00 00       	mov    $0x9,%eax
  802386:	e8 a8 fd ff ff       	call   802133 <nsipc>
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	56                   	push   %esi
  802391:	53                   	push   %ebx
  802392:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	ff 75 08             	pushl  0x8(%ebp)
  80239b:	e8 6a f3 ff ff       	call   80170a <fd2data>
  8023a0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023a2:	83 c4 08             	add    $0x8,%esp
  8023a5:	68 40 34 80 00       	push   $0x803440
  8023aa:	53                   	push   %ebx
  8023ab:	e8 7c e7 ff ff       	call   800b2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b0:	8b 46 04             	mov    0x4(%esi),%eax
  8023b3:	2b 06                	sub    (%esi),%eax
  8023b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023c2:	00 00 00 
	stat->st_dev = &devpipe;
  8023c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023cc:	40 80 00 
	return 0;
}
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	53                   	push   %ebx
  8023df:	83 ec 0c             	sub    $0xc,%esp
  8023e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023e5:	53                   	push   %ebx
  8023e6:	6a 00                	push   $0x0
  8023e8:	e8 b6 eb ff ff       	call   800fa3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023ed:	89 1c 24             	mov    %ebx,(%esp)
  8023f0:	e8 15 f3 ff ff       	call   80170a <fd2data>
  8023f5:	83 c4 08             	add    $0x8,%esp
  8023f8:	50                   	push   %eax
  8023f9:	6a 00                	push   $0x0
  8023fb:	e8 a3 eb ff ff       	call   800fa3 <sys_page_unmap>
}
  802400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <_pipeisclosed>:
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	57                   	push   %edi
  802409:	56                   	push   %esi
  80240a:	53                   	push   %ebx
  80240b:	83 ec 1c             	sub    $0x1c,%esp
  80240e:	89 c7                	mov    %eax,%edi
  802410:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802412:	a1 20 54 80 00       	mov    0x805420,%eax
  802417:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	57                   	push   %edi
  80241e:	e8 0d 06 00 00       	call   802a30 <pageref>
  802423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802426:	89 34 24             	mov    %esi,(%esp)
  802429:	e8 02 06 00 00       	call   802a30 <pageref>
		nn = thisenv->env_runs;
  80242e:	8b 15 20 54 80 00    	mov    0x805420,%edx
  802434:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	39 cb                	cmp    %ecx,%ebx
  80243c:	74 1b                	je     802459 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80243e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802441:	75 cf                	jne    802412 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802443:	8b 42 58             	mov    0x58(%edx),%eax
  802446:	6a 01                	push   $0x1
  802448:	50                   	push   %eax
  802449:	53                   	push   %ebx
  80244a:	68 47 34 80 00       	push   $0x803447
  80244f:	e8 79 df ff ff       	call   8003cd <cprintf>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	eb b9                	jmp    802412 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802459:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80245c:	0f 94 c0             	sete   %al
  80245f:	0f b6 c0             	movzbl %al,%eax
}
  802462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5f                   	pop    %edi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    

0080246a <devpipe_write>:
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	57                   	push   %edi
  80246e:	56                   	push   %esi
  80246f:	53                   	push   %ebx
  802470:	83 ec 28             	sub    $0x28,%esp
  802473:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802476:	56                   	push   %esi
  802477:	e8 8e f2 ff ff       	call   80170a <fd2data>
  80247c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80247e:	83 c4 10             	add    $0x10,%esp
  802481:	bf 00 00 00 00       	mov    $0x0,%edi
  802486:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802489:	74 4f                	je     8024da <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80248b:	8b 43 04             	mov    0x4(%ebx),%eax
  80248e:	8b 0b                	mov    (%ebx),%ecx
  802490:	8d 51 20             	lea    0x20(%ecx),%edx
  802493:	39 d0                	cmp    %edx,%eax
  802495:	72 14                	jb     8024ab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802497:	89 da                	mov    %ebx,%edx
  802499:	89 f0                	mov    %esi,%eax
  80249b:	e8 65 ff ff ff       	call   802405 <_pipeisclosed>
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	75 3b                	jne    8024df <devpipe_write+0x75>
			sys_yield();
  8024a4:	e8 56 ea ff ff       	call   800eff <sys_yield>
  8024a9:	eb e0                	jmp    80248b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024b2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024b5:	89 c2                	mov    %eax,%edx
  8024b7:	c1 fa 1f             	sar    $0x1f,%edx
  8024ba:	89 d1                	mov    %edx,%ecx
  8024bc:	c1 e9 1b             	shr    $0x1b,%ecx
  8024bf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024c2:	83 e2 1f             	and    $0x1f,%edx
  8024c5:	29 ca                	sub    %ecx,%edx
  8024c7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024cb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024cf:	83 c0 01             	add    $0x1,%eax
  8024d2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024d5:	83 c7 01             	add    $0x1,%edi
  8024d8:	eb ac                	jmp    802486 <devpipe_write+0x1c>
	return i;
  8024da:	8b 45 10             	mov    0x10(%ebp),%eax
  8024dd:	eb 05                	jmp    8024e4 <devpipe_write+0x7a>
				return 0;
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5f                   	pop    %edi
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    

008024ec <devpipe_read>:
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	57                   	push   %edi
  8024f0:	56                   	push   %esi
  8024f1:	53                   	push   %ebx
  8024f2:	83 ec 18             	sub    $0x18,%esp
  8024f5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024f8:	57                   	push   %edi
  8024f9:	e8 0c f2 ff ff       	call   80170a <fd2data>
  8024fe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	be 00 00 00 00       	mov    $0x0,%esi
  802508:	3b 75 10             	cmp    0x10(%ebp),%esi
  80250b:	75 14                	jne    802521 <devpipe_read+0x35>
	return i;
  80250d:	8b 45 10             	mov    0x10(%ebp),%eax
  802510:	eb 02                	jmp    802514 <devpipe_read+0x28>
				return i;
  802512:	89 f0                	mov    %esi,%eax
}
  802514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802517:	5b                   	pop    %ebx
  802518:	5e                   	pop    %esi
  802519:	5f                   	pop    %edi
  80251a:	5d                   	pop    %ebp
  80251b:	c3                   	ret    
			sys_yield();
  80251c:	e8 de e9 ff ff       	call   800eff <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802521:	8b 03                	mov    (%ebx),%eax
  802523:	3b 43 04             	cmp    0x4(%ebx),%eax
  802526:	75 18                	jne    802540 <devpipe_read+0x54>
			if (i > 0)
  802528:	85 f6                	test   %esi,%esi
  80252a:	75 e6                	jne    802512 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80252c:	89 da                	mov    %ebx,%edx
  80252e:	89 f8                	mov    %edi,%eax
  802530:	e8 d0 fe ff ff       	call   802405 <_pipeisclosed>
  802535:	85 c0                	test   %eax,%eax
  802537:	74 e3                	je     80251c <devpipe_read+0x30>
				return 0;
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	eb d4                	jmp    802514 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802540:	99                   	cltd   
  802541:	c1 ea 1b             	shr    $0x1b,%edx
  802544:	01 d0                	add    %edx,%eax
  802546:	83 e0 1f             	and    $0x1f,%eax
  802549:	29 d0                	sub    %edx,%eax
  80254b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802553:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802556:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802559:	83 c6 01             	add    $0x1,%esi
  80255c:	eb aa                	jmp    802508 <devpipe_read+0x1c>

0080255e <pipe>:
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	56                   	push   %esi
  802562:	53                   	push   %ebx
  802563:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802569:	50                   	push   %eax
  80256a:	e8 b2 f1 ff ff       	call   801721 <fd_alloc>
  80256f:	89 c3                	mov    %eax,%ebx
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	85 c0                	test   %eax,%eax
  802576:	0f 88 23 01 00 00    	js     80269f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257c:	83 ec 04             	sub    $0x4,%esp
  80257f:	68 07 04 00 00       	push   $0x407
  802584:	ff 75 f4             	pushl  -0xc(%ebp)
  802587:	6a 00                	push   $0x0
  802589:	e8 90 e9 ff ff       	call   800f1e <sys_page_alloc>
  80258e:	89 c3                	mov    %eax,%ebx
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	85 c0                	test   %eax,%eax
  802595:	0f 88 04 01 00 00    	js     80269f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80259b:	83 ec 0c             	sub    $0xc,%esp
  80259e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a1:	50                   	push   %eax
  8025a2:	e8 7a f1 ff ff       	call   801721 <fd_alloc>
  8025a7:	89 c3                	mov    %eax,%ebx
  8025a9:	83 c4 10             	add    $0x10,%esp
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	0f 88 db 00 00 00    	js     80268f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 07 04 00 00       	push   $0x407
  8025bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8025bf:	6a 00                	push   $0x0
  8025c1:	e8 58 e9 ff ff       	call   800f1e <sys_page_alloc>
  8025c6:	89 c3                	mov    %eax,%ebx
  8025c8:	83 c4 10             	add    $0x10,%esp
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	0f 88 bc 00 00 00    	js     80268f <pipe+0x131>
	va = fd2data(fd0);
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d9:	e8 2c f1 ff ff       	call   80170a <fd2data>
  8025de:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e0:	83 c4 0c             	add    $0xc,%esp
  8025e3:	68 07 04 00 00       	push   $0x407
  8025e8:	50                   	push   %eax
  8025e9:	6a 00                	push   $0x0
  8025eb:	e8 2e e9 ff ff       	call   800f1e <sys_page_alloc>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	0f 88 82 00 00 00    	js     80267f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	83 ec 0c             	sub    $0xc,%esp
  802600:	ff 75 f0             	pushl  -0x10(%ebp)
  802603:	e8 02 f1 ff ff       	call   80170a <fd2data>
  802608:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80260f:	50                   	push   %eax
  802610:	6a 00                	push   $0x0
  802612:	56                   	push   %esi
  802613:	6a 00                	push   $0x0
  802615:	e8 47 e9 ff ff       	call   800f61 <sys_page_map>
  80261a:	89 c3                	mov    %eax,%ebx
  80261c:	83 c4 20             	add    $0x20,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	78 4e                	js     802671 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802623:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80262d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802630:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802637:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80263c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	ff 75 f4             	pushl  -0xc(%ebp)
  80264c:	e8 a9 f0 ff ff       	call   8016fa <fd2num>
  802651:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802654:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802656:	83 c4 04             	add    $0x4,%esp
  802659:	ff 75 f0             	pushl  -0x10(%ebp)
  80265c:	e8 99 f0 ff ff       	call   8016fa <fd2num>
  802661:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802664:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80266f:	eb 2e                	jmp    80269f <pipe+0x141>
	sys_page_unmap(0, va);
  802671:	83 ec 08             	sub    $0x8,%esp
  802674:	56                   	push   %esi
  802675:	6a 00                	push   $0x0
  802677:	e8 27 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80267c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80267f:	83 ec 08             	sub    $0x8,%esp
  802682:	ff 75 f0             	pushl  -0x10(%ebp)
  802685:	6a 00                	push   $0x0
  802687:	e8 17 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80268c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80268f:	83 ec 08             	sub    $0x8,%esp
  802692:	ff 75 f4             	pushl  -0xc(%ebp)
  802695:	6a 00                	push   $0x0
  802697:	e8 07 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80269c:	83 c4 10             	add    $0x10,%esp
}
  80269f:	89 d8                	mov    %ebx,%eax
  8026a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    

008026a8 <pipeisclosed>:
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b1:	50                   	push   %eax
  8026b2:	ff 75 08             	pushl  0x8(%ebp)
  8026b5:	e8 b9 f0 ff ff       	call   801773 <fd_lookup>
  8026ba:	83 c4 10             	add    $0x10,%esp
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	78 18                	js     8026d9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c7:	e8 3e f0 ff ff       	call   80170a <fd2data>
	return _pipeisclosed(fd, p);
  8026cc:	89 c2                	mov    %eax,%edx
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	e8 2f fd ff ff       	call   802405 <_pipeisclosed>
  8026d6:	83 c4 10             	add    $0x10,%esp
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	56                   	push   %esi
  8026df:	53                   	push   %ebx
  8026e0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026e3:	85 f6                	test   %esi,%esi
  8026e5:	74 13                	je     8026fa <wait+0x1f>
	e = &envs[ENVX(envid)];
  8026e7:	89 f3                	mov    %esi,%ebx
  8026e9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026ef:	c1 e3 07             	shl    $0x7,%ebx
  8026f2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8026f8:	eb 1b                	jmp    802715 <wait+0x3a>
	assert(envid != 0);
  8026fa:	68 5f 34 80 00       	push   $0x80345f
  8026ff:	68 db 33 80 00       	push   $0x8033db
  802704:	6a 09                	push   $0x9
  802706:	68 6a 34 80 00       	push   $0x80346a
  80270b:	e8 c7 db ff ff       	call   8002d7 <_panic>
		sys_yield();
  802710:	e8 ea e7 ff ff       	call   800eff <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802715:	8b 43 48             	mov    0x48(%ebx),%eax
  802718:	39 f0                	cmp    %esi,%eax
  80271a:	75 07                	jne    802723 <wait+0x48>
  80271c:	8b 43 54             	mov    0x54(%ebx),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	75 ed                	jne    802710 <wait+0x35>
}
  802723:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802726:	5b                   	pop    %ebx
  802727:	5e                   	pop    %esi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80272a:	b8 00 00 00 00       	mov    $0x0,%eax
  80272f:	c3                   	ret    

00802730 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802736:	68 75 34 80 00       	push   $0x803475
  80273b:	ff 75 0c             	pushl  0xc(%ebp)
  80273e:	e8 e9 e3 ff ff       	call   800b2c <strcpy>
	return 0;
}
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_write>:
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	57                   	push   %edi
  80274e:	56                   	push   %esi
  80274f:	53                   	push   %ebx
  802750:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802756:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80275b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802761:	3b 75 10             	cmp    0x10(%ebp),%esi
  802764:	73 31                	jae    802797 <devcons_write+0x4d>
		m = n - tot;
  802766:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802769:	29 f3                	sub    %esi,%ebx
  80276b:	83 fb 7f             	cmp    $0x7f,%ebx
  80276e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802773:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	53                   	push   %ebx
  80277a:	89 f0                	mov    %esi,%eax
  80277c:	03 45 0c             	add    0xc(%ebp),%eax
  80277f:	50                   	push   %eax
  802780:	57                   	push   %edi
  802781:	e8 34 e5 ff ff       	call   800cba <memmove>
		sys_cputs(buf, m);
  802786:	83 c4 08             	add    $0x8,%esp
  802789:	53                   	push   %ebx
  80278a:	57                   	push   %edi
  80278b:	e8 d2 e6 ff ff       	call   800e62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802790:	01 de                	add    %ebx,%esi
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	eb ca                	jmp    802761 <devcons_write+0x17>
}
  802797:	89 f0                	mov    %esi,%eax
  802799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80279c:	5b                   	pop    %ebx
  80279d:	5e                   	pop    %esi
  80279e:	5f                   	pop    %edi
  80279f:	5d                   	pop    %ebp
  8027a0:	c3                   	ret    

008027a1 <devcons_read>:
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	83 ec 08             	sub    $0x8,%esp
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b0:	74 21                	je     8027d3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027b2:	e8 c9 e6 ff ff       	call   800e80 <sys_cgetc>
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	75 07                	jne    8027c2 <devcons_read+0x21>
		sys_yield();
  8027bb:	e8 3f e7 ff ff       	call   800eff <sys_yield>
  8027c0:	eb f0                	jmp    8027b2 <devcons_read+0x11>
	if (c < 0)
  8027c2:	78 0f                	js     8027d3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027c4:	83 f8 04             	cmp    $0x4,%eax
  8027c7:	74 0c                	je     8027d5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027cc:	88 02                	mov    %al,(%edx)
	return 1;
  8027ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    
		return 0;
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027da:	eb f7                	jmp    8027d3 <devcons_read+0x32>

008027dc <cputchar>:
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027e8:	6a 01                	push   $0x1
  8027ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ed:	50                   	push   %eax
  8027ee:	e8 6f e6 ff ff       	call   800e62 <sys_cputs>
}
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	c9                   	leave  
  8027f7:	c3                   	ret    

008027f8 <getchar>:
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027fe:	6a 01                	push   $0x1
  802800:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802803:	50                   	push   %eax
  802804:	6a 00                	push   $0x0
  802806:	e8 d8 f1 ff ff       	call   8019e3 <read>
	if (r < 0)
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	85 c0                	test   %eax,%eax
  802810:	78 06                	js     802818 <getchar+0x20>
	if (r < 1)
  802812:	74 06                	je     80281a <getchar+0x22>
	return c;
  802814:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    
		return -E_EOF;
  80281a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80281f:	eb f7                	jmp    802818 <getchar+0x20>

00802821 <iscons>:
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802827:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282a:	50                   	push   %eax
  80282b:	ff 75 08             	pushl  0x8(%ebp)
  80282e:	e8 40 ef ff ff       	call   801773 <fd_lookup>
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	85 c0                	test   %eax,%eax
  802838:	78 11                	js     80284b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802843:	39 10                	cmp    %edx,(%eax)
  802845:	0f 94 c0             	sete   %al
  802848:	0f b6 c0             	movzbl %al,%eax
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <opencons>:
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802853:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802856:	50                   	push   %eax
  802857:	e8 c5 ee ff ff       	call   801721 <fd_alloc>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	85 c0                	test   %eax,%eax
  802861:	78 3a                	js     80289d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	68 07 04 00 00       	push   $0x407
  80286b:	ff 75 f4             	pushl  -0xc(%ebp)
  80286e:	6a 00                	push   $0x0
  802870:	e8 a9 e6 ff ff       	call   800f1e <sys_page_alloc>
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 21                	js     80289d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802885:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802891:	83 ec 0c             	sub    $0xc,%esp
  802894:	50                   	push   %eax
  802895:	e8 60 ee ff ff       	call   8016fa <fd2num>
  80289a:	83 c4 10             	add    $0x10,%esp
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028a5:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028ac:	74 0a                	je     8028b8 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028b6:	c9                   	leave  
  8028b7:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	6a 07                	push   $0x7
  8028bd:	68 00 f0 bf ee       	push   $0xeebff000
  8028c2:	6a 00                	push   $0x0
  8028c4:	e8 55 e6 ff ff       	call   800f1e <sys_page_alloc>
		if(r < 0)
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	78 2a                	js     8028fa <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028d0:	83 ec 08             	sub    $0x8,%esp
  8028d3:	68 0e 29 80 00       	push   $0x80290e
  8028d8:	6a 00                	push   $0x0
  8028da:	e8 8a e7 ff ff       	call   801069 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028df:	83 c4 10             	add    $0x10,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	79 c8                	jns    8028ae <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 b4 34 80 00       	push   $0x8034b4
  8028ee:	6a 25                	push   $0x25
  8028f0:	68 f0 34 80 00       	push   $0x8034f0
  8028f5:	e8 dd d9 ff ff       	call   8002d7 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 84 34 80 00       	push   $0x803484
  802902:	6a 22                	push   $0x22
  802904:	68 f0 34 80 00       	push   $0x8034f0
  802909:	e8 c9 d9 ff ff       	call   8002d7 <_panic>

0080290e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80290e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80290f:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802914:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802916:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802919:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80291d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802921:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802924:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802926:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80292a:	83 c4 08             	add    $0x8,%esp
	popal
  80292d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80292e:	83 c4 04             	add    $0x4,%esp
	popfl
  802931:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802932:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802933:	c3                   	ret    

00802934 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	56                   	push   %esi
  802938:	53                   	push   %ebx
  802939:	8b 75 08             	mov    0x8(%ebp),%esi
  80293c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802942:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802944:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802949:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80294c:	83 ec 0c             	sub    $0xc,%esp
  80294f:	50                   	push   %eax
  802950:	e8 79 e7 ff ff       	call   8010ce <sys_ipc_recv>
	if(ret < 0){
  802955:	83 c4 10             	add    $0x10,%esp
  802958:	85 c0                	test   %eax,%eax
  80295a:	78 2b                	js     802987 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80295c:	85 f6                	test   %esi,%esi
  80295e:	74 0a                	je     80296a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802960:	a1 20 54 80 00       	mov    0x805420,%eax
  802965:	8b 40 74             	mov    0x74(%eax),%eax
  802968:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80296a:	85 db                	test   %ebx,%ebx
  80296c:	74 0a                	je     802978 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80296e:	a1 20 54 80 00       	mov    0x805420,%eax
  802973:	8b 40 78             	mov    0x78(%eax),%eax
  802976:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802978:	a1 20 54 80 00       	mov    0x805420,%eax
  80297d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802983:	5b                   	pop    %ebx
  802984:	5e                   	pop    %esi
  802985:	5d                   	pop    %ebp
  802986:	c3                   	ret    
		if(from_env_store)
  802987:	85 f6                	test   %esi,%esi
  802989:	74 06                	je     802991 <ipc_recv+0x5d>
			*from_env_store = 0;
  80298b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802991:	85 db                	test   %ebx,%ebx
  802993:	74 eb                	je     802980 <ipc_recv+0x4c>
			*perm_store = 0;
  802995:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80299b:	eb e3                	jmp    802980 <ipc_recv+0x4c>

0080299d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
  8029a0:	57                   	push   %edi
  8029a1:	56                   	push   %esi
  8029a2:	53                   	push   %ebx
  8029a3:	83 ec 0c             	sub    $0xc,%esp
  8029a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029af:	85 db                	test   %ebx,%ebx
  8029b1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029b6:	0f 44 d8             	cmove  %eax,%ebx
  8029b9:	eb 05                	jmp    8029c0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029bb:	e8 3f e5 ff ff       	call   800eff <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029c0:	ff 75 14             	pushl  0x14(%ebp)
  8029c3:	53                   	push   %ebx
  8029c4:	56                   	push   %esi
  8029c5:	57                   	push   %edi
  8029c6:	e8 e0 e6 ff ff       	call   8010ab <sys_ipc_try_send>
  8029cb:	83 c4 10             	add    $0x10,%esp
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 1b                	je     8029ed <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029d2:	79 e7                	jns    8029bb <ipc_send+0x1e>
  8029d4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029d7:	74 e2                	je     8029bb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 fe 34 80 00       	push   $0x8034fe
  8029e1:	6a 46                	push   $0x46
  8029e3:	68 13 35 80 00       	push   $0x803513
  8029e8:	e8 ea d8 ff ff       	call   8002d7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029f0:	5b                   	pop    %ebx
  8029f1:	5e                   	pop    %esi
  8029f2:	5f                   	pop    %edi
  8029f3:	5d                   	pop    %ebp
  8029f4:	c3                   	ret    

008029f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
  8029f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a00:	89 c2                	mov    %eax,%edx
  802a02:	c1 e2 07             	shl    $0x7,%edx
  802a05:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a0b:	8b 52 50             	mov    0x50(%edx),%edx
  802a0e:	39 ca                	cmp    %ecx,%edx
  802a10:	74 11                	je     802a23 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a12:	83 c0 01             	add    $0x1,%eax
  802a15:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a1a:	75 e4                	jne    802a00 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	eb 0b                	jmp    802a2e <ipc_find_env+0x39>
			return envs[i].env_id;
  802a23:	c1 e0 07             	shl    $0x7,%eax
  802a26:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a2b:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a2e:	5d                   	pop    %ebp
  802a2f:	c3                   	ret    

00802a30 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a36:	89 d0                	mov    %edx,%eax
  802a38:	c1 e8 16             	shr    $0x16,%eax
  802a3b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a47:	f6 c1 01             	test   $0x1,%cl
  802a4a:	74 1d                	je     802a69 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a4c:	c1 ea 0c             	shr    $0xc,%edx
  802a4f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a56:	f6 c2 01             	test   $0x1,%dl
  802a59:	74 0e                	je     802a69 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a5b:	c1 ea 0c             	shr    $0xc,%edx
  802a5e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a65:	ef 
  802a66:	0f b7 c0             	movzwl %ax,%eax
}
  802a69:	5d                   	pop    %ebp
  802a6a:	c3                   	ret    
  802a6b:	66 90                	xchg   %ax,%ax
  802a6d:	66 90                	xchg   %ax,%ax
  802a6f:	90                   	nop

00802a70 <__udivdi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	53                   	push   %ebx
  802a74:	83 ec 1c             	sub    $0x1c,%esp
  802a77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a87:	85 d2                	test   %edx,%edx
  802a89:	75 4d                	jne    802ad8 <__udivdi3+0x68>
  802a8b:	39 f3                	cmp    %esi,%ebx
  802a8d:	76 19                	jbe    802aa8 <__udivdi3+0x38>
  802a8f:	31 ff                	xor    %edi,%edi
  802a91:	89 e8                	mov    %ebp,%eax
  802a93:	89 f2                	mov    %esi,%edx
  802a95:	f7 f3                	div    %ebx
  802a97:	89 fa                	mov    %edi,%edx
  802a99:	83 c4 1c             	add    $0x1c,%esp
  802a9c:	5b                   	pop    %ebx
  802a9d:	5e                   	pop    %esi
  802a9e:	5f                   	pop    %edi
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    
  802aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	89 d9                	mov    %ebx,%ecx
  802aaa:	85 db                	test   %ebx,%ebx
  802aac:	75 0b                	jne    802ab9 <__udivdi3+0x49>
  802aae:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab3:	31 d2                	xor    %edx,%edx
  802ab5:	f7 f3                	div    %ebx
  802ab7:	89 c1                	mov    %eax,%ecx
  802ab9:	31 d2                	xor    %edx,%edx
  802abb:	89 f0                	mov    %esi,%eax
  802abd:	f7 f1                	div    %ecx
  802abf:	89 c6                	mov    %eax,%esi
  802ac1:	89 e8                	mov    %ebp,%eax
  802ac3:	89 f7                	mov    %esi,%edi
  802ac5:	f7 f1                	div    %ecx
  802ac7:	89 fa                	mov    %edi,%edx
  802ac9:	83 c4 1c             	add    $0x1c,%esp
  802acc:	5b                   	pop    %ebx
  802acd:	5e                   	pop    %esi
  802ace:	5f                   	pop    %edi
  802acf:	5d                   	pop    %ebp
  802ad0:	c3                   	ret    
  802ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	39 f2                	cmp    %esi,%edx
  802ada:	77 1c                	ja     802af8 <__udivdi3+0x88>
  802adc:	0f bd fa             	bsr    %edx,%edi
  802adf:	83 f7 1f             	xor    $0x1f,%edi
  802ae2:	75 2c                	jne    802b10 <__udivdi3+0xa0>
  802ae4:	39 f2                	cmp    %esi,%edx
  802ae6:	72 06                	jb     802aee <__udivdi3+0x7e>
  802ae8:	31 c0                	xor    %eax,%eax
  802aea:	39 eb                	cmp    %ebp,%ebx
  802aec:	77 a9                	ja     802a97 <__udivdi3+0x27>
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	eb a2                	jmp    802a97 <__udivdi3+0x27>
  802af5:	8d 76 00             	lea    0x0(%esi),%esi
  802af8:	31 ff                	xor    %edi,%edi
  802afa:	31 c0                	xor    %eax,%eax
  802afc:	89 fa                	mov    %edi,%edx
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 f9                	mov    %edi,%ecx
  802b12:	b8 20 00 00 00       	mov    $0x20,%eax
  802b17:	29 f8                	sub    %edi,%eax
  802b19:	d3 e2                	shl    %cl,%edx
  802b1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b1f:	89 c1                	mov    %eax,%ecx
  802b21:	89 da                	mov    %ebx,%edx
  802b23:	d3 ea                	shr    %cl,%edx
  802b25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b29:	09 d1                	or     %edx,%ecx
  802b2b:	89 f2                	mov    %esi,%edx
  802b2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b31:	89 f9                	mov    %edi,%ecx
  802b33:	d3 e3                	shl    %cl,%ebx
  802b35:	89 c1                	mov    %eax,%ecx
  802b37:	d3 ea                	shr    %cl,%edx
  802b39:	89 f9                	mov    %edi,%ecx
  802b3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b3f:	89 eb                	mov    %ebp,%ebx
  802b41:	d3 e6                	shl    %cl,%esi
  802b43:	89 c1                	mov    %eax,%ecx
  802b45:	d3 eb                	shr    %cl,%ebx
  802b47:	09 de                	or     %ebx,%esi
  802b49:	89 f0                	mov    %esi,%eax
  802b4b:	f7 74 24 08          	divl   0x8(%esp)
  802b4f:	89 d6                	mov    %edx,%esi
  802b51:	89 c3                	mov    %eax,%ebx
  802b53:	f7 64 24 0c          	mull   0xc(%esp)
  802b57:	39 d6                	cmp    %edx,%esi
  802b59:	72 15                	jb     802b70 <__udivdi3+0x100>
  802b5b:	89 f9                	mov    %edi,%ecx
  802b5d:	d3 e5                	shl    %cl,%ebp
  802b5f:	39 c5                	cmp    %eax,%ebp
  802b61:	73 04                	jae    802b67 <__udivdi3+0xf7>
  802b63:	39 d6                	cmp    %edx,%esi
  802b65:	74 09                	je     802b70 <__udivdi3+0x100>
  802b67:	89 d8                	mov    %ebx,%eax
  802b69:	31 ff                	xor    %edi,%edi
  802b6b:	e9 27 ff ff ff       	jmp    802a97 <__udivdi3+0x27>
  802b70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b73:	31 ff                	xor    %edi,%edi
  802b75:	e9 1d ff ff ff       	jmp    802a97 <__udivdi3+0x27>
  802b7a:	66 90                	xchg   %ax,%ax
  802b7c:	66 90                	xchg   %ax,%ax
  802b7e:	66 90                	xchg   %ax,%ax

00802b80 <__umoddi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	53                   	push   %ebx
  802b84:	83 ec 1c             	sub    $0x1c,%esp
  802b87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b97:	89 da                	mov    %ebx,%edx
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	75 43                	jne    802be0 <__umoddi3+0x60>
  802b9d:	39 df                	cmp    %ebx,%edi
  802b9f:	76 17                	jbe    802bb8 <__umoddi3+0x38>
  802ba1:	89 f0                	mov    %esi,%eax
  802ba3:	f7 f7                	div    %edi
  802ba5:	89 d0                	mov    %edx,%eax
  802ba7:	31 d2                	xor    %edx,%edx
  802ba9:	83 c4 1c             	add    $0x1c,%esp
  802bac:	5b                   	pop    %ebx
  802bad:	5e                   	pop    %esi
  802bae:	5f                   	pop    %edi
  802baf:	5d                   	pop    %ebp
  802bb0:	c3                   	ret    
  802bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	89 fd                	mov    %edi,%ebp
  802bba:	85 ff                	test   %edi,%edi
  802bbc:	75 0b                	jne    802bc9 <__umoddi3+0x49>
  802bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc3:	31 d2                	xor    %edx,%edx
  802bc5:	f7 f7                	div    %edi
  802bc7:	89 c5                	mov    %eax,%ebp
  802bc9:	89 d8                	mov    %ebx,%eax
  802bcb:	31 d2                	xor    %edx,%edx
  802bcd:	f7 f5                	div    %ebp
  802bcf:	89 f0                	mov    %esi,%eax
  802bd1:	f7 f5                	div    %ebp
  802bd3:	89 d0                	mov    %edx,%eax
  802bd5:	eb d0                	jmp    802ba7 <__umoddi3+0x27>
  802bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bde:	66 90                	xchg   %ax,%ax
  802be0:	89 f1                	mov    %esi,%ecx
  802be2:	39 d8                	cmp    %ebx,%eax
  802be4:	76 0a                	jbe    802bf0 <__umoddi3+0x70>
  802be6:	89 f0                	mov    %esi,%eax
  802be8:	83 c4 1c             	add    $0x1c,%esp
  802beb:	5b                   	pop    %ebx
  802bec:	5e                   	pop    %esi
  802bed:	5f                   	pop    %edi
  802bee:	5d                   	pop    %ebp
  802bef:	c3                   	ret    
  802bf0:	0f bd e8             	bsr    %eax,%ebp
  802bf3:	83 f5 1f             	xor    $0x1f,%ebp
  802bf6:	75 20                	jne    802c18 <__umoddi3+0x98>
  802bf8:	39 d8                	cmp    %ebx,%eax
  802bfa:	0f 82 b0 00 00 00    	jb     802cb0 <__umoddi3+0x130>
  802c00:	39 f7                	cmp    %esi,%edi
  802c02:	0f 86 a8 00 00 00    	jbe    802cb0 <__umoddi3+0x130>
  802c08:	89 c8                	mov    %ecx,%eax
  802c0a:	83 c4 1c             	add    $0x1c,%esp
  802c0d:	5b                   	pop    %ebx
  802c0e:	5e                   	pop    %esi
  802c0f:	5f                   	pop    %edi
  802c10:	5d                   	pop    %ebp
  802c11:	c3                   	ret    
  802c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c1f:	29 ea                	sub    %ebp,%edx
  802c21:	d3 e0                	shl    %cl,%eax
  802c23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c27:	89 d1                	mov    %edx,%ecx
  802c29:	89 f8                	mov    %edi,%eax
  802c2b:	d3 e8                	shr    %cl,%eax
  802c2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c39:	09 c1                	or     %eax,%ecx
  802c3b:	89 d8                	mov    %ebx,%eax
  802c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c41:	89 e9                	mov    %ebp,%ecx
  802c43:	d3 e7                	shl    %cl,%edi
  802c45:	89 d1                	mov    %edx,%ecx
  802c47:	d3 e8                	shr    %cl,%eax
  802c49:	89 e9                	mov    %ebp,%ecx
  802c4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c4f:	d3 e3                	shl    %cl,%ebx
  802c51:	89 c7                	mov    %eax,%edi
  802c53:	89 d1                	mov    %edx,%ecx
  802c55:	89 f0                	mov    %esi,%eax
  802c57:	d3 e8                	shr    %cl,%eax
  802c59:	89 e9                	mov    %ebp,%ecx
  802c5b:	89 fa                	mov    %edi,%edx
  802c5d:	d3 e6                	shl    %cl,%esi
  802c5f:	09 d8                	or     %ebx,%eax
  802c61:	f7 74 24 08          	divl   0x8(%esp)
  802c65:	89 d1                	mov    %edx,%ecx
  802c67:	89 f3                	mov    %esi,%ebx
  802c69:	f7 64 24 0c          	mull   0xc(%esp)
  802c6d:	89 c6                	mov    %eax,%esi
  802c6f:	89 d7                	mov    %edx,%edi
  802c71:	39 d1                	cmp    %edx,%ecx
  802c73:	72 06                	jb     802c7b <__umoddi3+0xfb>
  802c75:	75 10                	jne    802c87 <__umoddi3+0x107>
  802c77:	39 c3                	cmp    %eax,%ebx
  802c79:	73 0c                	jae    802c87 <__umoddi3+0x107>
  802c7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c83:	89 d7                	mov    %edx,%edi
  802c85:	89 c6                	mov    %eax,%esi
  802c87:	89 ca                	mov    %ecx,%edx
  802c89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c8e:	29 f3                	sub    %esi,%ebx
  802c90:	19 fa                	sbb    %edi,%edx
  802c92:	89 d0                	mov    %edx,%eax
  802c94:	d3 e0                	shl    %cl,%eax
  802c96:	89 e9                	mov    %ebp,%ecx
  802c98:	d3 eb                	shr    %cl,%ebx
  802c9a:	d3 ea                	shr    %cl,%edx
  802c9c:	09 d8                	or     %ebx,%eax
  802c9e:	83 c4 1c             	add    $0x1c,%esp
  802ca1:	5b                   	pop    %ebx
  802ca2:	5e                   	pop    %esi
  802ca3:	5f                   	pop    %edi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    
  802ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cad:	8d 76 00             	lea    0x0(%esi),%esi
  802cb0:	89 da                	mov    %ebx,%edx
  802cb2:	29 fe                	sub    %edi,%esi
  802cb4:	19 c2                	sbb    %eax,%edx
  802cb6:	89 f1                	mov    %esi,%ecx
  802cb8:	89 c8                	mov    %ecx,%eax
  802cba:	e9 4b ff ff ff       	jmp    802c0a <__umoddi3+0x8a>
