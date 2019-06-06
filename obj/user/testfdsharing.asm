
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
  80003e:	68 a0 2c 80 00       	push   $0x802ca0
  800043:	e8 19 1e 00 00       	call   801e61 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 b1 1a 00 00       	call   801b11 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 d7 19 00 00       	call   801a4a <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 c3 13 00 00       	call   801448 <fork>
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
  800097:	e8 75 1a 00 00       	call   801b11 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 10 2d 80 00 	movl   $0x802d10,(%esp)
  8000a3:	e8 25 03 00 00       	call   8003cd <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 8f 19 00 00       	call   801a4a <readn>
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
  8000e7:	68 db 2c 80 00       	push   $0x802cdb
  8000ec:	e8 dc 02 00 00       	call   8003cd <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 15 1a 00 00       	call   801b11 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 81 17 00 00       	call   801885 <close>
		exit();
  800104:	e8 9a 01 00 00       	call   8002a3 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 a6 25 00 00       	call   8026bb <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 22 19 00 00       	call   801a4a <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 f4 2c 80 00       	push   $0x802cf4
  80013b:	e8 8d 02 00 00       	call   8003cd <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 3d 17 00 00       	call   801885 <close>
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
  800155:	68 a5 2c 80 00       	push   $0x802ca5
  80015a:	6a 0c                	push   $0xc
  80015c:	68 b3 2c 80 00       	push   $0x802cb3
  800161:	e8 71 01 00 00       	call   8002d7 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 c8 2c 80 00       	push   $0x802cc8
  80016c:	6a 0f                	push   $0xf
  80016e:	68 b3 2c 80 00       	push   $0x802cb3
  800173:	e8 5f 01 00 00       	call   8002d7 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 d2 2c 80 00       	push   $0x802cd2
  80017e:	6a 12                	push   $0x12
  800180:	68 b3 2c 80 00       	push   $0x802cb3
  800185:	e8 4d 01 00 00       	call   8002d7 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 54 2d 80 00       	push   $0x802d54
  800194:	6a 17                	push   $0x17
  800196:	68 b3 2c 80 00       	push   $0x802cb3
  80019b:	e8 37 01 00 00       	call   8002d7 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 80 2d 80 00       	push   $0x802d80
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 b3 2c 80 00       	push   $0x802cb3
  8001af:	e8 23 01 00 00       	call   8002d7 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 b8 2d 80 00       	push   $0x802db8
  8001be:	6a 21                	push   $0x21
  8001c0:	68 b3 2c 80 00       	push   $0x802cb3
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
  80024d:	68 db 2d 80 00       	push   $0x802ddb
  800252:	e8 76 01 00 00       	call   8003cd <cprintf>
	cprintf("before umain\n");
  800257:	c7 04 24 f9 2d 80 00 	movl   $0x802df9,(%esp)
  80025e:	e8 6a 01 00 00       	call   8003cd <cprintf>
	// call user main routine
	umain(argc, argv);
  800263:	83 c4 08             	add    $0x8,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	e8 c2 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800271:	c7 04 24 07 2e 80 00 	movl   $0x802e07,(%esp)
  800278:	e8 50 01 00 00       	call   8003cd <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80027d:	a1 20 54 80 00       	mov    0x805420,%eax
  800282:	8b 40 48             	mov    0x48(%eax),%eax
  800285:	83 c4 08             	add    $0x8,%esp
  800288:	50                   	push   %eax
  800289:	68 14 2e 80 00       	push   $0x802e14
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
  8002b1:	68 40 2e 80 00       	push   $0x802e40
  8002b6:	50                   	push   %eax
  8002b7:	68 33 2e 80 00       	push   $0x802e33
  8002bc:	e8 0c 01 00 00       	call   8003cd <cprintf>
	close_all();
  8002c1:	e8 ec 15 00 00       	call   8018b2 <close_all>
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
  8002e7:	68 6c 2e 80 00       	push   $0x802e6c
  8002ec:	50                   	push   %eax
  8002ed:	68 33 2e 80 00       	push   $0x802e33
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
  800310:	68 48 2e 80 00       	push   $0x802e48
  800315:	e8 b3 00 00 00       	call   8003cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031a:	83 c4 18             	add    $0x18,%esp
  80031d:	53                   	push   %ebx
  80031e:	ff 75 10             	pushl  0x10(%ebp)
  800321:	e8 56 00 00 00       	call   80037c <vcprintf>
	cprintf("\n");
  800326:	c7 04 24 f7 2d 80 00 	movl   $0x802df7,(%esp)
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
  80047a:	e8 d1 25 00 00       	call   802a50 <__udivdi3>
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
  8004a3:	e8 b8 26 00 00       	call   802b60 <__umoddi3>
  8004a8:	83 c4 14             	add    $0x14,%esp
  8004ab:	0f be 80 73 2e 80 00 	movsbl 0x802e73(%eax),%eax
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
  800554:	ff 24 85 60 30 80 00 	jmp    *0x803060(,%eax,4)
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
  80061f:	8b 14 85 c0 31 80 00 	mov    0x8031c0(,%eax,4),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	74 18                	je     800642 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80062a:	52                   	push   %edx
  80062b:	68 cd 33 80 00       	push   $0x8033cd
  800630:	53                   	push   %ebx
  800631:	56                   	push   %esi
  800632:	e8 a6 fe ff ff       	call   8004dd <printfmt>
  800637:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063d:	e9 fe 02 00 00       	jmp    800940 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800642:	50                   	push   %eax
  800643:	68 8b 2e 80 00       	push   $0x802e8b
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
  80066a:	b8 84 2e 80 00       	mov    $0x802e84,%eax
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
  800a02:	bf a9 2f 80 00       	mov    $0x802fa9,%edi
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
  800a2e:	bf e1 2f 80 00       	mov    $0x802fe1,%edi
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
  800ecf:	68 08 32 80 00       	push   $0x803208
  800ed4:	6a 43                	push   $0x43
  800ed6:	68 25 32 80 00       	push   $0x803225
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
  800f50:	68 08 32 80 00       	push   $0x803208
  800f55:	6a 43                	push   $0x43
  800f57:	68 25 32 80 00       	push   $0x803225
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
  800f92:	68 08 32 80 00       	push   $0x803208
  800f97:	6a 43                	push   $0x43
  800f99:	68 25 32 80 00       	push   $0x803225
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
  800fd4:	68 08 32 80 00       	push   $0x803208
  800fd9:	6a 43                	push   $0x43
  800fdb:	68 25 32 80 00       	push   $0x803225
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
  801016:	68 08 32 80 00       	push   $0x803208
  80101b:	6a 43                	push   $0x43
  80101d:	68 25 32 80 00       	push   $0x803225
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
  801058:	68 08 32 80 00       	push   $0x803208
  80105d:	6a 43                	push   $0x43
  80105f:	68 25 32 80 00       	push   $0x803225
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
  80109a:	68 08 32 80 00       	push   $0x803208
  80109f:	6a 43                	push   $0x43
  8010a1:	68 25 32 80 00       	push   $0x803225
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
  8010fe:	68 08 32 80 00       	push   $0x803208
  801103:	6a 43                	push   $0x43
  801105:	68 25 32 80 00       	push   $0x803225
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
  8011e2:	68 08 32 80 00       	push   $0x803208
  8011e7:	6a 43                	push   $0x43
  8011e9:	68 25 32 80 00       	push   $0x803225
  8011ee:	e8 e4 f0 ff ff       	call   8002d7 <_panic>

008011f3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011fa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801201:	f6 c5 04             	test   $0x4,%ch
  801204:	75 45                	jne    80124b <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801206:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80120d:	83 e1 07             	and    $0x7,%ecx
  801210:	83 f9 07             	cmp    $0x7,%ecx
  801213:	74 6f                	je     801284 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801215:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80121c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801222:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801228:	0f 84 b6 00 00 00    	je     8012e4 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80122e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801235:	83 e1 05             	and    $0x5,%ecx
  801238:	83 f9 05             	cmp    $0x5,%ecx
  80123b:	0f 84 d7 00 00 00    	je     801318 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
  801246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801249:	c9                   	leave  
  80124a:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80124b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801252:	c1 e2 0c             	shl    $0xc,%edx
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80125e:	51                   	push   %ecx
  80125f:	52                   	push   %edx
  801260:	50                   	push   %eax
  801261:	52                   	push   %edx
  801262:	6a 00                	push   $0x0
  801264:	e8 f8 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  801269:	83 c4 20             	add    $0x20,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	79 d1                	jns    801241 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	68 33 32 80 00       	push   $0x803233
  801278:	6a 54                	push   $0x54
  80127a:	68 49 32 80 00       	push   $0x803249
  80127f:	e8 53 f0 ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801284:	89 d3                	mov    %edx,%ebx
  801286:	c1 e3 0c             	shl    $0xc,%ebx
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	68 05 08 00 00       	push   $0x805
  801291:	53                   	push   %ebx
  801292:	50                   	push   %eax
  801293:	53                   	push   %ebx
  801294:	6a 00                	push   $0x0
  801296:	e8 c6 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  80129b:	83 c4 20             	add    $0x20,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 2e                	js     8012d0 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	68 05 08 00 00       	push   $0x805
  8012aa:	53                   	push   %ebx
  8012ab:	6a 00                	push   $0x0
  8012ad:	53                   	push   %ebx
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 ac fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  8012b5:	83 c4 20             	add    $0x20,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	79 85                	jns    801241 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	68 33 32 80 00       	push   $0x803233
  8012c4:	6a 5f                	push   $0x5f
  8012c6:	68 49 32 80 00       	push   $0x803249
  8012cb:	e8 07 f0 ff ff       	call   8002d7 <_panic>
			panic("sys_page_map() panic\n");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 33 32 80 00       	push   $0x803233
  8012d8:	6a 5b                	push   $0x5b
  8012da:	68 49 32 80 00       	push   $0x803249
  8012df:	e8 f3 ef ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012e4:	c1 e2 0c             	shl    $0xc,%edx
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	68 05 08 00 00       	push   $0x805
  8012ef:	52                   	push   %edx
  8012f0:	50                   	push   %eax
  8012f1:	52                   	push   %edx
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 68 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  8012f9:	83 c4 20             	add    $0x20,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	0f 89 3d ff ff ff    	jns    801241 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	68 33 32 80 00       	push   $0x803233
  80130c:	6a 66                	push   $0x66
  80130e:	68 49 32 80 00       	push   $0x803249
  801313:	e8 bf ef ff ff       	call   8002d7 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801318:	c1 e2 0c             	shl    $0xc,%edx
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	6a 05                	push   $0x5
  801320:	52                   	push   %edx
  801321:	50                   	push   %eax
  801322:	52                   	push   %edx
  801323:	6a 00                	push   $0x0
  801325:	e8 37 fc ff ff       	call   800f61 <sys_page_map>
		if(r < 0)
  80132a:	83 c4 20             	add    $0x20,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	0f 89 0c ff ff ff    	jns    801241 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	68 33 32 80 00       	push   $0x803233
  80133d:	6a 6d                	push   $0x6d
  80133f:	68 49 32 80 00       	push   $0x803249
  801344:	e8 8e ef ff ff       	call   8002d7 <_panic>

00801349 <pgfault>:
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	53                   	push   %ebx
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801353:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801355:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801359:	0f 84 99 00 00 00    	je     8013f8 <pgfault+0xaf>
  80135f:	89 c2                	mov    %eax,%edx
  801361:	c1 ea 16             	shr    $0x16,%edx
  801364:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136b:	f6 c2 01             	test   $0x1,%dl
  80136e:	0f 84 84 00 00 00    	je     8013f8 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801374:	89 c2                	mov    %eax,%edx
  801376:	c1 ea 0c             	shr    $0xc,%edx
  801379:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801380:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801386:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80138c:	75 6a                	jne    8013f8 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80138e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801393:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	6a 07                	push   $0x7
  80139a:	68 00 f0 7f 00       	push   $0x7ff000
  80139f:	6a 00                	push   $0x0
  8013a1:	e8 78 fb ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 5f                	js     80140c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 00 10 00 00       	push   $0x1000
  8013b5:	53                   	push   %ebx
  8013b6:	68 00 f0 7f 00       	push   $0x7ff000
  8013bb:	e8 5c f9 ff ff       	call   800d1c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013c0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013c7:	53                   	push   %ebx
  8013c8:	6a 00                	push   $0x0
  8013ca:	68 00 f0 7f 00       	push   $0x7ff000
  8013cf:	6a 00                	push   $0x0
  8013d1:	e8 8b fb ff ff       	call   800f61 <sys_page_map>
	if(ret < 0)
  8013d6:	83 c4 20             	add    $0x20,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 43                	js     801420 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	68 00 f0 7f 00       	push   $0x7ff000
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 b7 fb ff ff       	call   800fa3 <sys_page_unmap>
	if(ret < 0)
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 41                	js     801434 <pgfault+0xeb>
}
  8013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 54 32 80 00       	push   $0x803254
  801400:	6a 26                	push   $0x26
  801402:	68 49 32 80 00       	push   $0x803249
  801407:	e8 cb ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_alloc()\n");
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 68 32 80 00       	push   $0x803268
  801414:	6a 31                	push   $0x31
  801416:	68 49 32 80 00       	push   $0x803249
  80141b:	e8 b7 ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_map()\n");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 83 32 80 00       	push   $0x803283
  801428:	6a 36                	push   $0x36
  80142a:	68 49 32 80 00       	push   $0x803249
  80142f:	e8 a3 ee ff ff       	call   8002d7 <_panic>
		panic("panic in sys_page_unmap()\n");
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	68 9c 32 80 00       	push   $0x80329c
  80143c:	6a 39                	push   $0x39
  80143e:	68 49 32 80 00       	push   $0x803249
  801443:	e8 8f ee ff ff       	call   8002d7 <_panic>

00801448 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	57                   	push   %edi
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801451:	68 49 13 80 00       	push   $0x801349
  801456:	e8 24 14 00 00       	call   80287f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80145b:	b8 07 00 00 00       	mov    $0x7,%eax
  801460:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	78 27                	js     801490 <fork+0x48>
  801469:	89 c6                	mov    %eax,%esi
  80146b:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80146d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801472:	75 48                	jne    8014bc <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801474:	e8 67 fa ff ff       	call   800ee0 <sys_getenvid>
  801479:	25 ff 03 00 00       	and    $0x3ff,%eax
  80147e:	c1 e0 07             	shl    $0x7,%eax
  801481:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801486:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  80148b:	e9 90 00 00 00       	jmp    801520 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	68 b8 32 80 00       	push   $0x8032b8
  801498:	68 8c 00 00 00       	push   $0x8c
  80149d:	68 49 32 80 00       	push   $0x803249
  8014a2:	e8 30 ee ff ff       	call   8002d7 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014a7:	89 f8                	mov    %edi,%eax
  8014a9:	e8 45 fd ff ff       	call   8011f3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014b4:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014ba:	74 26                	je     8014e2 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014bc:	89 d8                	mov    %ebx,%eax
  8014be:	c1 e8 16             	shr    $0x16,%eax
  8014c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c8:	a8 01                	test   $0x1,%al
  8014ca:	74 e2                	je     8014ae <fork+0x66>
  8014cc:	89 da                	mov    %ebx,%edx
  8014ce:	c1 ea 0c             	shr    $0xc,%edx
  8014d1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014d8:	83 e0 05             	and    $0x5,%eax
  8014db:	83 f8 05             	cmp    $0x5,%eax
  8014de:	75 ce                	jne    8014ae <fork+0x66>
  8014e0:	eb c5                	jmp    8014a7 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014e2:	83 ec 04             	sub    $0x4,%esp
  8014e5:	6a 07                	push   $0x7
  8014e7:	68 00 f0 bf ee       	push   $0xeebff000
  8014ec:	56                   	push   %esi
  8014ed:	e8 2c fa ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 31                	js     80152a <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	68 ee 28 80 00       	push   $0x8028ee
  801501:	56                   	push   %esi
  801502:	e8 62 fb ff ff       	call   801069 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 33                	js     801541 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	6a 02                	push   $0x2
  801513:	56                   	push   %esi
  801514:	e8 cc fa ff ff       	call   800fe5 <sys_env_set_status>
	if(ret < 0)
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 38                	js     801558 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801520:	89 f0                	mov    %esi,%eax
  801522:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	68 68 32 80 00       	push   $0x803268
  801532:	68 98 00 00 00       	push   $0x98
  801537:	68 49 32 80 00       	push   $0x803249
  80153c:	e8 96 ed ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	68 dc 32 80 00       	push   $0x8032dc
  801549:	68 9b 00 00 00       	push   $0x9b
  80154e:	68 49 32 80 00       	push   $0x803249
  801553:	e8 7f ed ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_status()\n");
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	68 04 33 80 00       	push   $0x803304
  801560:	68 9e 00 00 00       	push   $0x9e
  801565:	68 49 32 80 00       	push   $0x803249
  80156a:	e8 68 ed ff ff       	call   8002d7 <_panic>

0080156f <sfork>:

// Challenge!
int
sfork(void)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	57                   	push   %edi
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
  801575:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801578:	68 49 13 80 00       	push   $0x801349
  80157d:	e8 fd 12 00 00       	call   80287f <set_pgfault_handler>
  801582:	b8 07 00 00 00       	mov    $0x7,%eax
  801587:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 27                	js     8015b7 <sfork+0x48>
  801590:	89 c7                	mov    %eax,%edi
  801592:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801594:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801599:	75 55                	jne    8015f0 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80159b:	e8 40 f9 ff ff       	call   800ee0 <sys_getenvid>
  8015a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015a5:	c1 e0 07             	shl    $0x7,%eax
  8015a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015ad:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8015b2:	e9 d4 00 00 00       	jmp    80168b <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015b7:	83 ec 04             	sub    $0x4,%esp
  8015ba:	68 b8 32 80 00       	push   $0x8032b8
  8015bf:	68 af 00 00 00       	push   $0xaf
  8015c4:	68 49 32 80 00       	push   $0x803249
  8015c9:	e8 09 ed ff ff       	call   8002d7 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015ce:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015d3:	89 f0                	mov    %esi,%eax
  8015d5:	e8 19 fc ff ff       	call   8011f3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015e0:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015e6:	77 65                	ja     80164d <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015e8:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015ee:	74 de                	je     8015ce <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015f0:	89 d8                	mov    %ebx,%eax
  8015f2:	c1 e8 16             	shr    $0x16,%eax
  8015f5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015fc:	a8 01                	test   $0x1,%al
  8015fe:	74 da                	je     8015da <sfork+0x6b>
  801600:	89 da                	mov    %ebx,%edx
  801602:	c1 ea 0c             	shr    $0xc,%edx
  801605:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80160c:	83 e0 05             	and    $0x5,%eax
  80160f:	83 f8 05             	cmp    $0x5,%eax
  801612:	75 c6                	jne    8015da <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801614:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80161b:	c1 e2 0c             	shl    $0xc,%edx
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	83 e0 07             	and    $0x7,%eax
  801624:	50                   	push   %eax
  801625:	52                   	push   %edx
  801626:	56                   	push   %esi
  801627:	52                   	push   %edx
  801628:	6a 00                	push   $0x0
  80162a:	e8 32 f9 ff ff       	call   800f61 <sys_page_map>
  80162f:	83 c4 20             	add    $0x20,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	74 a4                	je     8015da <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 33 32 80 00       	push   $0x803233
  80163e:	68 ba 00 00 00       	push   $0xba
  801643:	68 49 32 80 00       	push   $0x803249
  801648:	e8 8a ec ff ff       	call   8002d7 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	6a 07                	push   $0x7
  801652:	68 00 f0 bf ee       	push   $0xeebff000
  801657:	57                   	push   %edi
  801658:	e8 c1 f8 ff ff       	call   800f1e <sys_page_alloc>
	if(ret < 0)
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	85 c0                	test   %eax,%eax
  801662:	78 31                	js     801695 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	68 ee 28 80 00       	push   $0x8028ee
  80166c:	57                   	push   %edi
  80166d:	e8 f7 f9 ff ff       	call   801069 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 33                	js     8016ac <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	6a 02                	push   $0x2
  80167e:	57                   	push   %edi
  80167f:	e8 61 f9 ff ff       	call   800fe5 <sys_env_set_status>
	if(ret < 0)
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 38                	js     8016c3 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80168b:	89 f8                	mov    %edi,%eax
  80168d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801690:	5b                   	pop    %ebx
  801691:	5e                   	pop    %esi
  801692:	5f                   	pop    %edi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	68 68 32 80 00       	push   $0x803268
  80169d:	68 c0 00 00 00       	push   $0xc0
  8016a2:	68 49 32 80 00       	push   $0x803249
  8016a7:	e8 2b ec ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	68 dc 32 80 00       	push   $0x8032dc
  8016b4:	68 c3 00 00 00       	push   $0xc3
  8016b9:	68 49 32 80 00       	push   $0x803249
  8016be:	e8 14 ec ff ff       	call   8002d7 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	68 04 33 80 00       	push   $0x803304
  8016cb:	68 c6 00 00 00       	push   $0xc6
  8016d0:	68 49 32 80 00       	push   $0x803249
  8016d5:	e8 fd eb ff ff       	call   8002d7 <_panic>

008016da <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	05 00 00 00 30       	add    $0x30000000,%eax
  8016e5:	c1 e8 0c             	shr    $0xc,%eax
}
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016fa:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801709:	89 c2                	mov    %eax,%edx
  80170b:	c1 ea 16             	shr    $0x16,%edx
  80170e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801715:	f6 c2 01             	test   $0x1,%dl
  801718:	74 2d                	je     801747 <fd_alloc+0x46>
  80171a:	89 c2                	mov    %eax,%edx
  80171c:	c1 ea 0c             	shr    $0xc,%edx
  80171f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801726:	f6 c2 01             	test   $0x1,%dl
  801729:	74 1c                	je     801747 <fd_alloc+0x46>
  80172b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801730:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801735:	75 d2                	jne    801709 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801740:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801745:	eb 0a                	jmp    801751 <fd_alloc+0x50>
			*fd_store = fd;
  801747:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80174a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801759:	83 f8 1f             	cmp    $0x1f,%eax
  80175c:	77 30                	ja     80178e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80175e:	c1 e0 0c             	shl    $0xc,%eax
  801761:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801766:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80176c:	f6 c2 01             	test   $0x1,%dl
  80176f:	74 24                	je     801795 <fd_lookup+0x42>
  801771:	89 c2                	mov    %eax,%edx
  801773:	c1 ea 0c             	shr    $0xc,%edx
  801776:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80177d:	f6 c2 01             	test   $0x1,%dl
  801780:	74 1a                	je     80179c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	89 02                	mov    %eax,(%edx)
	return 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    
		return -E_INVAL;
  80178e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801793:	eb f7                	jmp    80178c <fd_lookup+0x39>
		return -E_INVAL;
  801795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179a:	eb f0                	jmp    80178c <fd_lookup+0x39>
  80179c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a1:	eb e9                	jmp    80178c <fd_lookup+0x39>

008017a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017b6:	39 08                	cmp    %ecx,(%eax)
  8017b8:	74 38                	je     8017f2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017ba:	83 c2 01             	add    $0x1,%edx
  8017bd:	8b 04 95 a0 33 80 00 	mov    0x8033a0(,%edx,4),%eax
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	75 ee                	jne    8017b6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017c8:	a1 20 54 80 00       	mov    0x805420,%eax
  8017cd:	8b 40 48             	mov    0x48(%eax),%eax
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	51                   	push   %ecx
  8017d4:	50                   	push   %eax
  8017d5:	68 24 33 80 00       	push   $0x803324
  8017da:	e8 ee eb ff ff       	call   8003cd <cprintf>
	*dev = 0;
  8017df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    
			*dev = devtab[i];
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	eb f2                	jmp    8017f0 <dev_lookup+0x4d>

008017fe <fd_close>:
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	57                   	push   %edi
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	83 ec 24             	sub    $0x24,%esp
  801807:	8b 75 08             	mov    0x8(%ebp),%esi
  80180a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80180d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801810:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801811:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801817:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80181a:	50                   	push   %eax
  80181b:	e8 33 ff ff ff       	call   801753 <fd_lookup>
  801820:	89 c3                	mov    %eax,%ebx
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	78 05                	js     80182e <fd_close+0x30>
	    || fd != fd2)
  801829:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80182c:	74 16                	je     801844 <fd_close+0x46>
		return (must_exist ? r : 0);
  80182e:	89 f8                	mov    %edi,%eax
  801830:	84 c0                	test   %al,%al
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	0f 44 d8             	cmove  %eax,%ebx
}
  80183a:	89 d8                	mov    %ebx,%eax
  80183c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5f                   	pop    %edi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80184a:	50                   	push   %eax
  80184b:	ff 36                	pushl  (%esi)
  80184d:	e8 51 ff ff ff       	call   8017a3 <dev_lookup>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	78 1a                	js     801875 <fd_close+0x77>
		if (dev->dev_close)
  80185b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801861:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801866:	85 c0                	test   %eax,%eax
  801868:	74 0b                	je     801875 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	56                   	push   %esi
  80186e:	ff d0                	call   *%eax
  801870:	89 c3                	mov    %eax,%ebx
  801872:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801875:	83 ec 08             	sub    $0x8,%esp
  801878:	56                   	push   %esi
  801879:	6a 00                	push   $0x0
  80187b:	e8 23 f7 ff ff       	call   800fa3 <sys_page_unmap>
	return r;
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	eb b5                	jmp    80183a <fd_close+0x3c>

00801885 <close>:

int
close(int fdnum)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	50                   	push   %eax
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	e8 bc fe ff ff       	call   801753 <fd_lookup>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	79 02                	jns    8018a0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
		return fd_close(fd, 1);
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	6a 01                	push   $0x1
  8018a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a8:	e8 51 ff ff ff       	call   8017fe <fd_close>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	eb ec                	jmp    80189e <close+0x19>

008018b2 <close_all>:

void
close_all(void)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	53                   	push   %ebx
  8018b6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	53                   	push   %ebx
  8018c2:	e8 be ff ff ff       	call   801885 <close>
	for (i = 0; i < MAXFD; i++)
  8018c7:	83 c3 01             	add    $0x1,%ebx
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	83 fb 20             	cmp    $0x20,%ebx
  8018d0:	75 ec                	jne    8018be <close_all+0xc>
}
  8018d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	57                   	push   %edi
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018e3:	50                   	push   %eax
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	e8 67 fe ff ff       	call   801753 <fd_lookup>
  8018ec:	89 c3                	mov    %eax,%ebx
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	0f 88 81 00 00 00    	js     80197a <dup+0xa3>
		return r;
	close(newfdnum);
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	e8 81 ff ff ff       	call   801885 <close>

	newfd = INDEX2FD(newfdnum);
  801904:	8b 75 0c             	mov    0xc(%ebp),%esi
  801907:	c1 e6 0c             	shl    $0xc,%esi
  80190a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801910:	83 c4 04             	add    $0x4,%esp
  801913:	ff 75 e4             	pushl  -0x1c(%ebp)
  801916:	e8 cf fd ff ff       	call   8016ea <fd2data>
  80191b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80191d:	89 34 24             	mov    %esi,(%esp)
  801920:	e8 c5 fd ff ff       	call   8016ea <fd2data>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	c1 e8 16             	shr    $0x16,%eax
  80192f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801936:	a8 01                	test   $0x1,%al
  801938:	74 11                	je     80194b <dup+0x74>
  80193a:	89 d8                	mov    %ebx,%eax
  80193c:	c1 e8 0c             	shr    $0xc,%eax
  80193f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801946:	f6 c2 01             	test   $0x1,%dl
  801949:	75 39                	jne    801984 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80194b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80194e:	89 d0                	mov    %edx,%eax
  801950:	c1 e8 0c             	shr    $0xc,%eax
  801953:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	25 07 0e 00 00       	and    $0xe07,%eax
  801962:	50                   	push   %eax
  801963:	56                   	push   %esi
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	6a 00                	push   $0x0
  801969:	e8 f3 f5 ff ff       	call   800f61 <sys_page_map>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	83 c4 20             	add    $0x20,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 31                	js     8019a8 <dup+0xd1>
		goto err;

	return newfdnum;
  801977:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80197a:	89 d8                	mov    %ebx,%eax
  80197c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5f                   	pop    %edi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801984:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	25 07 0e 00 00       	and    $0xe07,%eax
  801993:	50                   	push   %eax
  801994:	57                   	push   %edi
  801995:	6a 00                	push   $0x0
  801997:	53                   	push   %ebx
  801998:	6a 00                	push   $0x0
  80199a:	e8 c2 f5 ff ff       	call   800f61 <sys_page_map>
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	83 c4 20             	add    $0x20,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	79 a3                	jns    80194b <dup+0x74>
	sys_page_unmap(0, newfd);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	56                   	push   %esi
  8019ac:	6a 00                	push   $0x0
  8019ae:	e8 f0 f5 ff ff       	call   800fa3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019b3:	83 c4 08             	add    $0x8,%esp
  8019b6:	57                   	push   %edi
  8019b7:	6a 00                	push   $0x0
  8019b9:	e8 e5 f5 ff ff       	call   800fa3 <sys_page_unmap>
	return r;
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	eb b7                	jmp    80197a <dup+0xa3>

008019c3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 1c             	sub    $0x1c,%esp
  8019ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d0:	50                   	push   %eax
  8019d1:	53                   	push   %ebx
  8019d2:	e8 7c fd ff ff       	call   801753 <fd_lookup>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 3f                	js     801a1d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e4:	50                   	push   %eax
  8019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e8:	ff 30                	pushl  (%eax)
  8019ea:	e8 b4 fd ff ff       	call   8017a3 <dev_lookup>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 27                	js     801a1d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f9:	8b 42 08             	mov    0x8(%edx),%eax
  8019fc:	83 e0 03             	and    $0x3,%eax
  8019ff:	83 f8 01             	cmp    $0x1,%eax
  801a02:	74 1e                	je     801a22 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	8b 40 08             	mov    0x8(%eax),%eax
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	74 35                	je     801a43 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	ff 75 10             	pushl  0x10(%ebp)
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	52                   	push   %edx
  801a18:	ff d0                	call   *%eax
  801a1a:	83 c4 10             	add    $0x10,%esp
}
  801a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a22:	a1 20 54 80 00       	mov    0x805420,%eax
  801a27:	8b 40 48             	mov    0x48(%eax),%eax
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	53                   	push   %ebx
  801a2e:	50                   	push   %eax
  801a2f:	68 65 33 80 00       	push   $0x803365
  801a34:	e8 94 e9 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a41:	eb da                	jmp    801a1d <read+0x5a>
		return -E_NOT_SUPP;
  801a43:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a48:	eb d3                	jmp    801a1d <read+0x5a>

00801a4a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	57                   	push   %edi
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a56:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a59:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a5e:	39 f3                	cmp    %esi,%ebx
  801a60:	73 23                	jae    801a85 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	89 f0                	mov    %esi,%eax
  801a67:	29 d8                	sub    %ebx,%eax
  801a69:	50                   	push   %eax
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	03 45 0c             	add    0xc(%ebp),%eax
  801a6f:	50                   	push   %eax
  801a70:	57                   	push   %edi
  801a71:	e8 4d ff ff ff       	call   8019c3 <read>
		if (m < 0)
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 06                	js     801a83 <readn+0x39>
			return m;
		if (m == 0)
  801a7d:	74 06                	je     801a85 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a7f:	01 c3                	add    %eax,%ebx
  801a81:	eb db                	jmp    801a5e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a83:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5f                   	pop    %edi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	53                   	push   %ebx
  801a93:	83 ec 1c             	sub    $0x1c,%esp
  801a96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a99:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9c:	50                   	push   %eax
  801a9d:	53                   	push   %ebx
  801a9e:	e8 b0 fc ff ff       	call   801753 <fd_lookup>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 3a                	js     801ae4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab0:	50                   	push   %eax
  801ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab4:	ff 30                	pushl  (%eax)
  801ab6:	e8 e8 fc ff ff       	call   8017a3 <dev_lookup>
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 22                	js     801ae4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ac9:	74 1e                	je     801ae9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ace:	8b 52 0c             	mov    0xc(%edx),%edx
  801ad1:	85 d2                	test   %edx,%edx
  801ad3:	74 35                	je     801b0a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	50                   	push   %eax
  801adf:	ff d2                	call   *%edx
  801ae1:	83 c4 10             	add    $0x10,%esp
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ae9:	a1 20 54 80 00       	mov    0x805420,%eax
  801aee:	8b 40 48             	mov    0x48(%eax),%eax
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	53                   	push   %ebx
  801af5:	50                   	push   %eax
  801af6:	68 81 33 80 00       	push   $0x803381
  801afb:	e8 cd e8 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801b00:	83 c4 10             	add    $0x10,%esp
  801b03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b08:	eb da                	jmp    801ae4 <write+0x55>
		return -E_NOT_SUPP;
  801b0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0f:	eb d3                	jmp    801ae4 <write+0x55>

00801b11 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	e8 30 fc ff ff       	call   801753 <fd_lookup>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 0e                	js     801b38 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 1c             	sub    $0x1c,%esp
  801b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b47:	50                   	push   %eax
  801b48:	53                   	push   %ebx
  801b49:	e8 05 fc ff ff       	call   801753 <fd_lookup>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 37                	js     801b8c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5b:	50                   	push   %eax
  801b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5f:	ff 30                	pushl  (%eax)
  801b61:	e8 3d fc ff ff       	call   8017a3 <dev_lookup>
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 1f                	js     801b8c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b74:	74 1b                	je     801b91 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b79:	8b 52 18             	mov    0x18(%edx),%edx
  801b7c:	85 d2                	test   %edx,%edx
  801b7e:	74 32                	je     801bb2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b80:	83 ec 08             	sub    $0x8,%esp
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	50                   	push   %eax
  801b87:	ff d2                	call   *%edx
  801b89:	83 c4 10             	add    $0x10,%esp
}
  801b8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b91:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b96:	8b 40 48             	mov    0x48(%eax),%eax
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	53                   	push   %ebx
  801b9d:	50                   	push   %eax
  801b9e:	68 44 33 80 00       	push   $0x803344
  801ba3:	e8 25 e8 ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb0:	eb da                	jmp    801b8c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bb7:	eb d3                	jmp    801b8c <ftruncate+0x52>

00801bb9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	53                   	push   %ebx
  801bbd:	83 ec 1c             	sub    $0x1c,%esp
  801bc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	e8 84 fb ff ff       	call   801753 <fd_lookup>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 4b                	js     801c21 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdc:	50                   	push   %eax
  801bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be0:	ff 30                	pushl  (%eax)
  801be2:	e8 bc fb ff ff       	call   8017a3 <dev_lookup>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 33                	js     801c21 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bf5:	74 2f                	je     801c26 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bf7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bfa:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c01:	00 00 00 
	stat->st_isdir = 0;
  801c04:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c0b:	00 00 00 
	stat->st_dev = dev;
  801c0e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	53                   	push   %ebx
  801c18:	ff 75 f0             	pushl  -0x10(%ebp)
  801c1b:	ff 50 14             	call   *0x14(%eax)
  801c1e:	83 c4 10             	add    $0x10,%esp
}
  801c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    
		return -E_NOT_SUPP;
  801c26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c2b:	eb f4                	jmp    801c21 <fstat+0x68>

00801c2d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c32:	83 ec 08             	sub    $0x8,%esp
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	e8 22 02 00 00       	call   801e61 <open>
  801c3f:	89 c3                	mov    %eax,%ebx
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 1b                	js     801c63 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	50                   	push   %eax
  801c4f:	e8 65 ff ff ff       	call   801bb9 <fstat>
  801c54:	89 c6                	mov    %eax,%esi
	close(fd);
  801c56:	89 1c 24             	mov    %ebx,(%esp)
  801c59:	e8 27 fc ff ff       	call   801885 <close>
	return r;
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 f3                	mov    %esi,%ebx
}
  801c63:	89 d8                	mov    %ebx,%eax
  801c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    

00801c6c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	89 c6                	mov    %eax,%esi
  801c73:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c75:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c7c:	74 27                	je     801ca5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c7e:	6a 07                	push   $0x7
  801c80:	68 00 60 80 00       	push   $0x806000
  801c85:	56                   	push   %esi
  801c86:	ff 35 00 50 80 00    	pushl  0x805000
  801c8c:	e8 ec 0c 00 00       	call   80297d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c91:	83 c4 0c             	add    $0xc,%esp
  801c94:	6a 00                	push   $0x0
  801c96:	53                   	push   %ebx
  801c97:	6a 00                	push   $0x0
  801c99:	e8 76 0c 00 00       	call   802914 <ipc_recv>
}
  801c9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	6a 01                	push   $0x1
  801caa:	e8 26 0d 00 00       	call   8029d5 <ipc_find_env>
  801caf:	a3 00 50 80 00       	mov    %eax,0x805000
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	eb c5                	jmp    801c7e <fsipc+0x12>

00801cb9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cdc:	e8 8b ff ff ff       	call   801c6c <fsipc>
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <devfile_flush>:
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	8b 40 0c             	mov    0xc(%eax),%eax
  801cef:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf9:	b8 06 00 00 00       	mov    $0x6,%eax
  801cfe:	e8 69 ff ff ff       	call   801c6c <fsipc>
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <devfile_stat>:
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	53                   	push   %ebx
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	8b 40 0c             	mov    0xc(%eax),%eax
  801d15:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d24:	e8 43 ff ff ff       	call   801c6c <fsipc>
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 2c                	js     801d59 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	68 00 60 80 00       	push   $0x806000
  801d35:	53                   	push   %ebx
  801d36:	e8 f1 ed ff ff       	call   800b2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d3b:	a1 80 60 80 00       	mov    0x806080,%eax
  801d40:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d46:	a1 84 60 80 00       	mov    0x806084,%eax
  801d4b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <devfile_write>:
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	53                   	push   %ebx
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d73:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d79:	53                   	push   %ebx
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	68 08 60 80 00       	push   $0x806008
  801d82:	e8 95 ef ff ff       	call   800d1c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d87:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8c:	b8 04 00 00 00       	mov    $0x4,%eax
  801d91:	e8 d6 fe ff ff       	call   801c6c <fsipc>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 0b                	js     801da8 <devfile_write+0x4a>
	assert(r <= n);
  801d9d:	39 d8                	cmp    %ebx,%eax
  801d9f:	77 0c                	ja     801dad <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801da1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da6:	7f 1e                	jg     801dc6 <devfile_write+0x68>
}
  801da8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    
	assert(r <= n);
  801dad:	68 b4 33 80 00       	push   $0x8033b4
  801db2:	68 bb 33 80 00       	push   $0x8033bb
  801db7:	68 98 00 00 00       	push   $0x98
  801dbc:	68 d0 33 80 00       	push   $0x8033d0
  801dc1:	e8 11 e5 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  801dc6:	68 db 33 80 00       	push   $0x8033db
  801dcb:	68 bb 33 80 00       	push   $0x8033bb
  801dd0:	68 99 00 00 00       	push   $0x99
  801dd5:	68 d0 33 80 00       	push   $0x8033d0
  801dda:	e8 f8 e4 ff ff       	call   8002d7 <_panic>

00801ddf <devfile_read>:
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801df2:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801df8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfd:	b8 03 00 00 00       	mov    $0x3,%eax
  801e02:	e8 65 fe ff ff       	call   801c6c <fsipc>
  801e07:	89 c3                	mov    %eax,%ebx
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	78 1f                	js     801e2c <devfile_read+0x4d>
	assert(r <= n);
  801e0d:	39 f0                	cmp    %esi,%eax
  801e0f:	77 24                	ja     801e35 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e11:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e16:	7f 33                	jg     801e4b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	50                   	push   %eax
  801e1c:	68 00 60 80 00       	push   $0x806000
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	e8 91 ee ff ff       	call   800cba <memmove>
	return r;
  801e29:	83 c4 10             	add    $0x10,%esp
}
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    
	assert(r <= n);
  801e35:	68 b4 33 80 00       	push   $0x8033b4
  801e3a:	68 bb 33 80 00       	push   $0x8033bb
  801e3f:	6a 7c                	push   $0x7c
  801e41:	68 d0 33 80 00       	push   $0x8033d0
  801e46:	e8 8c e4 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  801e4b:	68 db 33 80 00       	push   $0x8033db
  801e50:	68 bb 33 80 00       	push   $0x8033bb
  801e55:	6a 7d                	push   $0x7d
  801e57:	68 d0 33 80 00       	push   $0x8033d0
  801e5c:	e8 76 e4 ff ff       	call   8002d7 <_panic>

00801e61 <open>:
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	56                   	push   %esi
  801e65:	53                   	push   %ebx
  801e66:	83 ec 1c             	sub    $0x1c,%esp
  801e69:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e6c:	56                   	push   %esi
  801e6d:	e8 81 ec ff ff       	call   800af3 <strlen>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e7a:	7f 6c                	jg     801ee8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e82:	50                   	push   %eax
  801e83:	e8 79 f8 ff ff       	call   801701 <fd_alloc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 3c                	js     801ecd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	56                   	push   %esi
  801e95:	68 00 60 80 00       	push   $0x806000
  801e9a:	e8 8d ec ff ff       	call   800b2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	e8 b8 fd ff ff       	call   801c6c <fsipc>
  801eb4:	89 c3                	mov    %eax,%ebx
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	78 19                	js     801ed6 <open+0x75>
	return fd2num(fd);
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec3:	e8 12 f8 ff ff       	call   8016da <fd2num>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	83 c4 10             	add    $0x10,%esp
}
  801ecd:	89 d8                	mov    %ebx,%eax
  801ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed2:	5b                   	pop    %ebx
  801ed3:	5e                   	pop    %esi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
		fd_close(fd, 0);
  801ed6:	83 ec 08             	sub    $0x8,%esp
  801ed9:	6a 00                	push   $0x0
  801edb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ede:	e8 1b f9 ff ff       	call   8017fe <fd_close>
		return r;
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	eb e5                	jmp    801ecd <open+0x6c>
		return -E_BAD_PATH;
  801ee8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eed:	eb de                	jmp    801ecd <open+0x6c>

00801eef <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	b8 08 00 00 00       	mov    $0x8,%eax
  801eff:	e8 68 fd ff ff       	call   801c6c <fsipc>
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f0c:	68 e7 33 80 00       	push   $0x8033e7
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	e8 13 ec ff ff       	call   800b2c <strcpy>
	return 0;
}
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <devsock_close>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 10             	sub    $0x10,%esp
  801f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f2a:	53                   	push   %ebx
  801f2b:	e8 e0 0a 00 00       	call   802a10 <pageref>
  801f30:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f33:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f38:	83 f8 01             	cmp    $0x1,%eax
  801f3b:	74 07                	je     801f44 <devsock_close+0x24>
}
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 73 0c             	pushl  0xc(%ebx)
  801f4a:	e8 b9 02 00 00       	call   802208 <nsipc_close>
  801f4f:	89 c2                	mov    %eax,%edx
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	eb e7                	jmp    801f3d <devsock_close+0x1d>

00801f56 <devsock_write>:
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	ff 75 10             	pushl  0x10(%ebp)
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	ff 70 0c             	pushl  0xc(%eax)
  801f6a:	e8 76 03 00 00       	call   8022e5 <nsipc_send>
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <devsock_read>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	ff 75 10             	pushl  0x10(%ebp)
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	ff 70 0c             	pushl  0xc(%eax)
  801f85:	e8 ef 02 00 00       	call   802279 <nsipc_recv>
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <fd2sockid>:
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f92:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f95:	52                   	push   %edx
  801f96:	50                   	push   %eax
  801f97:	e8 b7 f7 ff ff       	call   801753 <fd_lookup>
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	78 10                	js     801fb3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fac:	39 08                	cmp    %ecx,(%eax)
  801fae:	75 05                	jne    801fb5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fb0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    
		return -E_NOT_SUPP;
  801fb5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fba:	eb f7                	jmp    801fb3 <fd2sockid+0x27>

00801fbc <alloc_sockfd>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	56                   	push   %esi
  801fc0:	53                   	push   %ebx
  801fc1:	83 ec 1c             	sub    $0x1c,%esp
  801fc4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc9:	50                   	push   %eax
  801fca:	e8 32 f7 ff ff       	call   801701 <fd_alloc>
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 43                	js     80201b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	68 07 04 00 00       	push   $0x407
  801fe0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 34 ef ff ff       	call   800f1e <sys_page_alloc>
  801fea:	89 c3                	mov    %eax,%ebx
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 28                	js     80201b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ffc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802008:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	50                   	push   %eax
  80200f:	e8 c6 f6 ff ff       	call   8016da <fd2num>
  802014:	89 c3                	mov    %eax,%ebx
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	eb 0c                	jmp    802027 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	56                   	push   %esi
  80201f:	e8 e4 01 00 00       	call   802208 <nsipc_close>
		return r;
  802024:	83 c4 10             	add    $0x10,%esp
}
  802027:	89 d8                	mov    %ebx,%eax
  802029:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    

00802030 <accept>:
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	e8 4e ff ff ff       	call   801f8c <fd2sockid>
  80203e:	85 c0                	test   %eax,%eax
  802040:	78 1b                	js     80205d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	ff 75 10             	pushl  0x10(%ebp)
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	50                   	push   %eax
  80204c:	e8 0e 01 00 00       	call   80215f <nsipc_accept>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	78 05                	js     80205d <accept+0x2d>
	return alloc_sockfd(r);
  802058:	e8 5f ff ff ff       	call   801fbc <alloc_sockfd>
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <bind>:
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	e8 1f ff ff ff       	call   801f8c <fd2sockid>
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 12                	js     802083 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	ff 75 10             	pushl  0x10(%ebp)
  802077:	ff 75 0c             	pushl  0xc(%ebp)
  80207a:	50                   	push   %eax
  80207b:	e8 31 01 00 00       	call   8021b1 <nsipc_bind>
  802080:	83 c4 10             	add    $0x10,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <shutdown>:
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	e8 f9 fe ff ff       	call   801f8c <fd2sockid>
  802093:	85 c0                	test   %eax,%eax
  802095:	78 0f                	js     8020a6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802097:	83 ec 08             	sub    $0x8,%esp
  80209a:	ff 75 0c             	pushl  0xc(%ebp)
  80209d:	50                   	push   %eax
  80209e:	e8 43 01 00 00       	call   8021e6 <nsipc_shutdown>
  8020a3:	83 c4 10             	add    $0x10,%esp
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <connect>:
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	e8 d6 fe ff ff       	call   801f8c <fd2sockid>
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	78 12                	js     8020cc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	ff 75 10             	pushl  0x10(%ebp)
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	50                   	push   %eax
  8020c4:	e8 59 01 00 00       	call   802222 <nsipc_connect>
  8020c9:	83 c4 10             	add    $0x10,%esp
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <listen>:
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	e8 b0 fe ff ff       	call   801f8c <fd2sockid>
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 0f                	js     8020ef <listen+0x21>
	return nsipc_listen(r, backlog);
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	50                   	push   %eax
  8020e7:	e8 6b 01 00 00       	call   802257 <nsipc_listen>
  8020ec:	83 c4 10             	add    $0x10,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020f7:	ff 75 10             	pushl  0x10(%ebp)
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	ff 75 08             	pushl  0x8(%ebp)
  802100:	e8 3e 02 00 00       	call   802343 <nsipc_socket>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 05                	js     802111 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80210c:	e8 ab fe ff ff       	call   801fbc <alloc_sockfd>
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	53                   	push   %ebx
  802117:	83 ec 04             	sub    $0x4,%esp
  80211a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80211c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802123:	74 26                	je     80214b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802125:	6a 07                	push   $0x7
  802127:	68 00 70 80 00       	push   $0x807000
  80212c:	53                   	push   %ebx
  80212d:	ff 35 04 50 80 00    	pushl  0x805004
  802133:	e8 45 08 00 00       	call   80297d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802138:	83 c4 0c             	add    $0xc,%esp
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	e8 ce 07 00 00       	call   802914 <ipc_recv>
}
  802146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802149:	c9                   	leave  
  80214a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	6a 02                	push   $0x2
  802150:	e8 80 08 00 00       	call   8029d5 <ipc_find_env>
  802155:	a3 04 50 80 00       	mov    %eax,0x805004
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	eb c6                	jmp    802125 <nsipc+0x12>

0080215f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80216f:	8b 06                	mov    (%esi),%eax
  802171:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	e8 93 ff ff ff       	call   802113 <nsipc>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	85 c0                	test   %eax,%eax
  802184:	79 09                	jns    80218f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802186:	89 d8                	mov    %ebx,%eax
  802188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	ff 35 10 70 80 00    	pushl  0x807010
  802198:	68 00 70 80 00       	push   $0x807000
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	e8 15 eb ff ff       	call   800cba <memmove>
		*addrlen = ret->ret_addrlen;
  8021a5:	a1 10 70 80 00       	mov    0x807010,%eax
  8021aa:	89 06                	mov    %eax,(%esi)
  8021ac:	83 c4 10             	add    $0x10,%esp
	return r;
  8021af:	eb d5                	jmp    802186 <nsipc_accept+0x27>

008021b1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	53                   	push   %ebx
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021c3:	53                   	push   %ebx
  8021c4:	ff 75 0c             	pushl  0xc(%ebp)
  8021c7:	68 04 70 80 00       	push   $0x807004
  8021cc:	e8 e9 ea ff ff       	call   800cba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021d1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8021dc:	e8 32 ff ff ff       	call   802113 <nsipc>
}
  8021e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021fc:	b8 03 00 00 00       	mov    $0x3,%eax
  802201:	e8 0d ff ff ff       	call   802113 <nsipc>
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <nsipc_close>:

int
nsipc_close(int s)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802216:	b8 04 00 00 00       	mov    $0x4,%eax
  80221b:	e8 f3 fe ff ff       	call   802113 <nsipc>
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	53                   	push   %ebx
  802226:	83 ec 08             	sub    $0x8,%esp
  802229:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802234:	53                   	push   %ebx
  802235:	ff 75 0c             	pushl  0xc(%ebp)
  802238:	68 04 70 80 00       	push   $0x807004
  80223d:	e8 78 ea ff ff       	call   800cba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802242:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802248:	b8 05 00 00 00       	mov    $0x5,%eax
  80224d:	e8 c1 fe ff ff       	call   802113 <nsipc>
}
  802252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802265:	8b 45 0c             	mov    0xc(%ebp),%eax
  802268:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80226d:	b8 06 00 00 00       	mov    $0x6,%eax
  802272:	e8 9c fe ff ff       	call   802113 <nsipc>
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	56                   	push   %esi
  80227d:	53                   	push   %ebx
  80227e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802289:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80228f:	8b 45 14             	mov    0x14(%ebp),%eax
  802292:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802297:	b8 07 00 00 00       	mov    $0x7,%eax
  80229c:	e8 72 fe ff ff       	call   802113 <nsipc>
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	78 1f                	js     8022c6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022a7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022ac:	7f 21                	jg     8022cf <nsipc_recv+0x56>
  8022ae:	39 c6                	cmp    %eax,%esi
  8022b0:	7c 1d                	jl     8022cf <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	50                   	push   %eax
  8022b6:	68 00 70 80 00       	push   $0x807000
  8022bb:	ff 75 0c             	pushl  0xc(%ebp)
  8022be:	e8 f7 e9 ff ff       	call   800cba <memmove>
  8022c3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022c6:	89 d8                	mov    %ebx,%eax
  8022c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5e                   	pop    %esi
  8022cd:	5d                   	pop    %ebp
  8022ce:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022cf:	68 f3 33 80 00       	push   $0x8033f3
  8022d4:	68 bb 33 80 00       	push   $0x8033bb
  8022d9:	6a 62                	push   $0x62
  8022db:	68 08 34 80 00       	push   $0x803408
  8022e0:	e8 f2 df ff ff       	call   8002d7 <_panic>

008022e5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	53                   	push   %ebx
  8022e9:	83 ec 04             	sub    $0x4,%esp
  8022ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022f7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022fd:	7f 2e                	jg     80232d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	53                   	push   %ebx
  802303:	ff 75 0c             	pushl  0xc(%ebp)
  802306:	68 0c 70 80 00       	push   $0x80700c
  80230b:	e8 aa e9 ff ff       	call   800cba <memmove>
	nsipcbuf.send.req_size = size;
  802310:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802316:	8b 45 14             	mov    0x14(%ebp),%eax
  802319:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80231e:	b8 08 00 00 00       	mov    $0x8,%eax
  802323:	e8 eb fd ff ff       	call   802113 <nsipc>
}
  802328:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    
	assert(size < 1600);
  80232d:	68 14 34 80 00       	push   $0x803414
  802332:	68 bb 33 80 00       	push   $0x8033bb
  802337:	6a 6d                	push   $0x6d
  802339:	68 08 34 80 00       	push   $0x803408
  80233e:	e8 94 df ff ff       	call   8002d7 <_panic>

00802343 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802359:	8b 45 10             	mov    0x10(%ebp),%eax
  80235c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802361:	b8 09 00 00 00       	mov    $0x9,%eax
  802366:	e8 a8 fd ff ff       	call   802113 <nsipc>
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	56                   	push   %esi
  802371:	53                   	push   %ebx
  802372:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	ff 75 08             	pushl  0x8(%ebp)
  80237b:	e8 6a f3 ff ff       	call   8016ea <fd2data>
  802380:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802382:	83 c4 08             	add    $0x8,%esp
  802385:	68 20 34 80 00       	push   $0x803420
  80238a:	53                   	push   %ebx
  80238b:	e8 9c e7 ff ff       	call   800b2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802390:	8b 46 04             	mov    0x4(%esi),%eax
  802393:	2b 06                	sub    (%esi),%eax
  802395:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80239b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023a2:	00 00 00 
	stat->st_dev = &devpipe;
  8023a5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023ac:	40 80 00 
	return 0;
}
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5d                   	pop    %ebp
  8023ba:	c3                   	ret    

008023bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023c5:	53                   	push   %ebx
  8023c6:	6a 00                	push   $0x0
  8023c8:	e8 d6 eb ff ff       	call   800fa3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023cd:	89 1c 24             	mov    %ebx,(%esp)
  8023d0:	e8 15 f3 ff ff       	call   8016ea <fd2data>
  8023d5:	83 c4 08             	add    $0x8,%esp
  8023d8:	50                   	push   %eax
  8023d9:	6a 00                	push   $0x0
  8023db:	e8 c3 eb ff ff       	call   800fa3 <sys_page_unmap>
}
  8023e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <_pipeisclosed>:
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	57                   	push   %edi
  8023e9:	56                   	push   %esi
  8023ea:	53                   	push   %ebx
  8023eb:	83 ec 1c             	sub    $0x1c,%esp
  8023ee:	89 c7                	mov    %eax,%edi
  8023f0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023f2:	a1 20 54 80 00       	mov    0x805420,%eax
  8023f7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023fa:	83 ec 0c             	sub    $0xc,%esp
  8023fd:	57                   	push   %edi
  8023fe:	e8 0d 06 00 00       	call   802a10 <pageref>
  802403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802406:	89 34 24             	mov    %esi,(%esp)
  802409:	e8 02 06 00 00       	call   802a10 <pageref>
		nn = thisenv->env_runs;
  80240e:	8b 15 20 54 80 00    	mov    0x805420,%edx
  802414:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	39 cb                	cmp    %ecx,%ebx
  80241c:	74 1b                	je     802439 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80241e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802421:	75 cf                	jne    8023f2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802423:	8b 42 58             	mov    0x58(%edx),%eax
  802426:	6a 01                	push   $0x1
  802428:	50                   	push   %eax
  802429:	53                   	push   %ebx
  80242a:	68 27 34 80 00       	push   $0x803427
  80242f:	e8 99 df ff ff       	call   8003cd <cprintf>
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	eb b9                	jmp    8023f2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802439:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80243c:	0f 94 c0             	sete   %al
  80243f:	0f b6 c0             	movzbl %al,%eax
}
  802442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5f                   	pop    %edi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    

0080244a <devpipe_write>:
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	57                   	push   %edi
  80244e:	56                   	push   %esi
  80244f:	53                   	push   %ebx
  802450:	83 ec 28             	sub    $0x28,%esp
  802453:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802456:	56                   	push   %esi
  802457:	e8 8e f2 ff ff       	call   8016ea <fd2data>
  80245c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	bf 00 00 00 00       	mov    $0x0,%edi
  802466:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802469:	74 4f                	je     8024ba <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80246b:	8b 43 04             	mov    0x4(%ebx),%eax
  80246e:	8b 0b                	mov    (%ebx),%ecx
  802470:	8d 51 20             	lea    0x20(%ecx),%edx
  802473:	39 d0                	cmp    %edx,%eax
  802475:	72 14                	jb     80248b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802477:	89 da                	mov    %ebx,%edx
  802479:	89 f0                	mov    %esi,%eax
  80247b:	e8 65 ff ff ff       	call   8023e5 <_pipeisclosed>
  802480:	85 c0                	test   %eax,%eax
  802482:	75 3b                	jne    8024bf <devpipe_write+0x75>
			sys_yield();
  802484:	e8 76 ea ff ff       	call   800eff <sys_yield>
  802489:	eb e0                	jmp    80246b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80248b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80248e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802492:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802495:	89 c2                	mov    %eax,%edx
  802497:	c1 fa 1f             	sar    $0x1f,%edx
  80249a:	89 d1                	mov    %edx,%ecx
  80249c:	c1 e9 1b             	shr    $0x1b,%ecx
  80249f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024a2:	83 e2 1f             	and    $0x1f,%edx
  8024a5:	29 ca                	sub    %ecx,%edx
  8024a7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024af:	83 c0 01             	add    $0x1,%eax
  8024b2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024b5:	83 c7 01             	add    $0x1,%edi
  8024b8:	eb ac                	jmp    802466 <devpipe_write+0x1c>
	return i;
  8024ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bd:	eb 05                	jmp    8024c4 <devpipe_write+0x7a>
				return 0;
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    

008024cc <devpipe_read>:
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	57                   	push   %edi
  8024d0:	56                   	push   %esi
  8024d1:	53                   	push   %ebx
  8024d2:	83 ec 18             	sub    $0x18,%esp
  8024d5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024d8:	57                   	push   %edi
  8024d9:	e8 0c f2 ff ff       	call   8016ea <fd2data>
  8024de:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	be 00 00 00 00       	mov    $0x0,%esi
  8024e8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024eb:	75 14                	jne    802501 <devpipe_read+0x35>
	return i;
  8024ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f0:	eb 02                	jmp    8024f4 <devpipe_read+0x28>
				return i;
  8024f2:	89 f0                	mov    %esi,%eax
}
  8024f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5f                   	pop    %edi
  8024fa:	5d                   	pop    %ebp
  8024fb:	c3                   	ret    
			sys_yield();
  8024fc:	e8 fe e9 ff ff       	call   800eff <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802501:	8b 03                	mov    (%ebx),%eax
  802503:	3b 43 04             	cmp    0x4(%ebx),%eax
  802506:	75 18                	jne    802520 <devpipe_read+0x54>
			if (i > 0)
  802508:	85 f6                	test   %esi,%esi
  80250a:	75 e6                	jne    8024f2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80250c:	89 da                	mov    %ebx,%edx
  80250e:	89 f8                	mov    %edi,%eax
  802510:	e8 d0 fe ff ff       	call   8023e5 <_pipeisclosed>
  802515:	85 c0                	test   %eax,%eax
  802517:	74 e3                	je     8024fc <devpipe_read+0x30>
				return 0;
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	eb d4                	jmp    8024f4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802520:	99                   	cltd   
  802521:	c1 ea 1b             	shr    $0x1b,%edx
  802524:	01 d0                	add    %edx,%eax
  802526:	83 e0 1f             	and    $0x1f,%eax
  802529:	29 d0                	sub    %edx,%eax
  80252b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802533:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802536:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802539:	83 c6 01             	add    $0x1,%esi
  80253c:	eb aa                	jmp    8024e8 <devpipe_read+0x1c>

0080253e <pipe>:
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	56                   	push   %esi
  802542:	53                   	push   %ebx
  802543:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	e8 b2 f1 ff ff       	call   801701 <fd_alloc>
  80254f:	89 c3                	mov    %eax,%ebx
  802551:	83 c4 10             	add    $0x10,%esp
  802554:	85 c0                	test   %eax,%eax
  802556:	0f 88 23 01 00 00    	js     80267f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	68 07 04 00 00       	push   $0x407
  802564:	ff 75 f4             	pushl  -0xc(%ebp)
  802567:	6a 00                	push   $0x0
  802569:	e8 b0 e9 ff ff       	call   800f1e <sys_page_alloc>
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	83 c4 10             	add    $0x10,%esp
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 88 04 01 00 00    	js     80267f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80257b:	83 ec 0c             	sub    $0xc,%esp
  80257e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802581:	50                   	push   %eax
  802582:	e8 7a f1 ff ff       	call   801701 <fd_alloc>
  802587:	89 c3                	mov    %eax,%ebx
  802589:	83 c4 10             	add    $0x10,%esp
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 88 db 00 00 00    	js     80266f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 07 04 00 00       	push   $0x407
  80259c:	ff 75 f0             	pushl  -0x10(%ebp)
  80259f:	6a 00                	push   $0x0
  8025a1:	e8 78 e9 ff ff       	call   800f1e <sys_page_alloc>
  8025a6:	89 c3                	mov    %eax,%ebx
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 88 bc 00 00 00    	js     80266f <pipe+0x131>
	va = fd2data(fd0);
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b9:	e8 2c f1 ff ff       	call   8016ea <fd2data>
  8025be:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c0:	83 c4 0c             	add    $0xc,%esp
  8025c3:	68 07 04 00 00       	push   $0x407
  8025c8:	50                   	push   %eax
  8025c9:	6a 00                	push   $0x0
  8025cb:	e8 4e e9 ff ff       	call   800f1e <sys_page_alloc>
  8025d0:	89 c3                	mov    %eax,%ebx
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	0f 88 82 00 00 00    	js     80265f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025dd:	83 ec 0c             	sub    $0xc,%esp
  8025e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e3:	e8 02 f1 ff ff       	call   8016ea <fd2data>
  8025e8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025ef:	50                   	push   %eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	56                   	push   %esi
  8025f3:	6a 00                	push   $0x0
  8025f5:	e8 67 e9 ff ff       	call   800f61 <sys_page_map>
  8025fa:	89 c3                	mov    %eax,%ebx
  8025fc:	83 c4 20             	add    $0x20,%esp
  8025ff:	85 c0                	test   %eax,%eax
  802601:	78 4e                	js     802651 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802603:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80260d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802610:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802617:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80261c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802626:	83 ec 0c             	sub    $0xc,%esp
  802629:	ff 75 f4             	pushl  -0xc(%ebp)
  80262c:	e8 a9 f0 ff ff       	call   8016da <fd2num>
  802631:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802634:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802636:	83 c4 04             	add    $0x4,%esp
  802639:	ff 75 f0             	pushl  -0x10(%ebp)
  80263c:	e8 99 f0 ff ff       	call   8016da <fd2num>
  802641:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802644:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80264f:	eb 2e                	jmp    80267f <pipe+0x141>
	sys_page_unmap(0, va);
  802651:	83 ec 08             	sub    $0x8,%esp
  802654:	56                   	push   %esi
  802655:	6a 00                	push   $0x0
  802657:	e8 47 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80265c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80265f:	83 ec 08             	sub    $0x8,%esp
  802662:	ff 75 f0             	pushl  -0x10(%ebp)
  802665:	6a 00                	push   $0x0
  802667:	e8 37 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80266c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80266f:	83 ec 08             	sub    $0x8,%esp
  802672:	ff 75 f4             	pushl  -0xc(%ebp)
  802675:	6a 00                	push   $0x0
  802677:	e8 27 e9 ff ff       	call   800fa3 <sys_page_unmap>
  80267c:	83 c4 10             	add    $0x10,%esp
}
  80267f:	89 d8                	mov    %ebx,%eax
  802681:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802684:	5b                   	pop    %ebx
  802685:	5e                   	pop    %esi
  802686:	5d                   	pop    %ebp
  802687:	c3                   	ret    

00802688 <pipeisclosed>:
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80268e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802691:	50                   	push   %eax
  802692:	ff 75 08             	pushl  0x8(%ebp)
  802695:	e8 b9 f0 ff ff       	call   801753 <fd_lookup>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	85 c0                	test   %eax,%eax
  80269f:	78 18                	js     8026b9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a7:	e8 3e f0 ff ff       	call   8016ea <fd2data>
	return _pipeisclosed(fd, p);
  8026ac:	89 c2                	mov    %eax,%edx
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	e8 2f fd ff ff       	call   8023e5 <_pipeisclosed>
  8026b6:	83 c4 10             	add    $0x10,%esp
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026c3:	85 f6                	test   %esi,%esi
  8026c5:	74 13                	je     8026da <wait+0x1f>
	e = &envs[ENVX(envid)];
  8026c7:	89 f3                	mov    %esi,%ebx
  8026c9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026cf:	c1 e3 07             	shl    $0x7,%ebx
  8026d2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8026d8:	eb 1b                	jmp    8026f5 <wait+0x3a>
	assert(envid != 0);
  8026da:	68 3f 34 80 00       	push   $0x80343f
  8026df:	68 bb 33 80 00       	push   $0x8033bb
  8026e4:	6a 09                	push   $0x9
  8026e6:	68 4a 34 80 00       	push   $0x80344a
  8026eb:	e8 e7 db ff ff       	call   8002d7 <_panic>
		sys_yield();
  8026f0:	e8 0a e8 ff ff       	call   800eff <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026f5:	8b 43 48             	mov    0x48(%ebx),%eax
  8026f8:	39 f0                	cmp    %esi,%eax
  8026fa:	75 07                	jne    802703 <wait+0x48>
  8026fc:	8b 43 54             	mov    0x54(%ebx),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	75 ed                	jne    8026f0 <wait+0x35>
}
  802703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802706:	5b                   	pop    %ebx
  802707:	5e                   	pop    %esi
  802708:	5d                   	pop    %ebp
  802709:	c3                   	ret    

0080270a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80270a:	b8 00 00 00 00       	mov    $0x0,%eax
  80270f:	c3                   	ret    

00802710 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802716:	68 55 34 80 00       	push   $0x803455
  80271b:	ff 75 0c             	pushl  0xc(%ebp)
  80271e:	e8 09 e4 ff ff       	call   800b2c <strcpy>
	return 0;
}
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <devcons_write>:
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	57                   	push   %edi
  80272e:	56                   	push   %esi
  80272f:	53                   	push   %ebx
  802730:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802736:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80273b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802741:	3b 75 10             	cmp    0x10(%ebp),%esi
  802744:	73 31                	jae    802777 <devcons_write+0x4d>
		m = n - tot;
  802746:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802749:	29 f3                	sub    %esi,%ebx
  80274b:	83 fb 7f             	cmp    $0x7f,%ebx
  80274e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802753:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	53                   	push   %ebx
  80275a:	89 f0                	mov    %esi,%eax
  80275c:	03 45 0c             	add    0xc(%ebp),%eax
  80275f:	50                   	push   %eax
  802760:	57                   	push   %edi
  802761:	e8 54 e5 ff ff       	call   800cba <memmove>
		sys_cputs(buf, m);
  802766:	83 c4 08             	add    $0x8,%esp
  802769:	53                   	push   %ebx
  80276a:	57                   	push   %edi
  80276b:	e8 f2 e6 ff ff       	call   800e62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802770:	01 de                	add    %ebx,%esi
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	eb ca                	jmp    802741 <devcons_write+0x17>
}
  802777:	89 f0                	mov    %esi,%eax
  802779:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80277c:	5b                   	pop    %ebx
  80277d:	5e                   	pop    %esi
  80277e:	5f                   	pop    %edi
  80277f:	5d                   	pop    %ebp
  802780:	c3                   	ret    

00802781 <devcons_read>:
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 08             	sub    $0x8,%esp
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80278c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802790:	74 21                	je     8027b3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802792:	e8 e9 e6 ff ff       	call   800e80 <sys_cgetc>
  802797:	85 c0                	test   %eax,%eax
  802799:	75 07                	jne    8027a2 <devcons_read+0x21>
		sys_yield();
  80279b:	e8 5f e7 ff ff       	call   800eff <sys_yield>
  8027a0:	eb f0                	jmp    802792 <devcons_read+0x11>
	if (c < 0)
  8027a2:	78 0f                	js     8027b3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027a4:	83 f8 04             	cmp    $0x4,%eax
  8027a7:	74 0c                	je     8027b5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ac:	88 02                	mov    %al,(%edx)
	return 1;
  8027ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    
		return 0;
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ba:	eb f7                	jmp    8027b3 <devcons_read+0x32>

008027bc <cputchar>:
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027c8:	6a 01                	push   $0x1
  8027ca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027cd:	50                   	push   %eax
  8027ce:	e8 8f e6 ff ff       	call   800e62 <sys_cputs>
}
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <getchar>:
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027de:	6a 01                	push   $0x1
  8027e0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027e3:	50                   	push   %eax
  8027e4:	6a 00                	push   $0x0
  8027e6:	e8 d8 f1 ff ff       	call   8019c3 <read>
	if (r < 0)
  8027eb:	83 c4 10             	add    $0x10,%esp
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 06                	js     8027f8 <getchar+0x20>
	if (r < 1)
  8027f2:	74 06                	je     8027fa <getchar+0x22>
	return c;
  8027f4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    
		return -E_EOF;
  8027fa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027ff:	eb f7                	jmp    8027f8 <getchar+0x20>

00802801 <iscons>:
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80280a:	50                   	push   %eax
  80280b:	ff 75 08             	pushl  0x8(%ebp)
  80280e:	e8 40 ef ff ff       	call   801753 <fd_lookup>
  802813:	83 c4 10             	add    $0x10,%esp
  802816:	85 c0                	test   %eax,%eax
  802818:	78 11                	js     80282b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802823:	39 10                	cmp    %edx,(%eax)
  802825:	0f 94 c0             	sete   %al
  802828:	0f b6 c0             	movzbl %al,%eax
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <opencons>:
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802836:	50                   	push   %eax
  802837:	e8 c5 ee ff ff       	call   801701 <fd_alloc>
  80283c:	83 c4 10             	add    $0x10,%esp
  80283f:	85 c0                	test   %eax,%eax
  802841:	78 3a                	js     80287d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 07 04 00 00       	push   $0x407
  80284b:	ff 75 f4             	pushl  -0xc(%ebp)
  80284e:	6a 00                	push   $0x0
  802850:	e8 c9 e6 ff ff       	call   800f1e <sys_page_alloc>
  802855:	83 c4 10             	add    $0x10,%esp
  802858:	85 c0                	test   %eax,%eax
  80285a:	78 21                	js     80287d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802865:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802871:	83 ec 0c             	sub    $0xc,%esp
  802874:	50                   	push   %eax
  802875:	e8 60 ee ff ff       	call   8016da <fd2num>
  80287a:	83 c4 10             	add    $0x10,%esp
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802885:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80288c:	74 0a                	je     802898 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	6a 07                	push   $0x7
  80289d:	68 00 f0 bf ee       	push   $0xeebff000
  8028a2:	6a 00                	push   $0x0
  8028a4:	e8 75 e6 ff ff       	call   800f1e <sys_page_alloc>
		if(r < 0)
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	78 2a                	js     8028da <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028b0:	83 ec 08             	sub    $0x8,%esp
  8028b3:	68 ee 28 80 00       	push   $0x8028ee
  8028b8:	6a 00                	push   $0x0
  8028ba:	e8 aa e7 ff ff       	call   801069 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	79 c8                	jns    80288e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028c6:	83 ec 04             	sub    $0x4,%esp
  8028c9:	68 94 34 80 00       	push   $0x803494
  8028ce:	6a 25                	push   $0x25
  8028d0:	68 d0 34 80 00       	push   $0x8034d0
  8028d5:	e8 fd d9 ff ff       	call   8002d7 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 64 34 80 00       	push   $0x803464
  8028e2:	6a 22                	push   $0x22
  8028e4:	68 d0 34 80 00       	push   $0x8034d0
  8028e9:	e8 e9 d9 ff ff       	call   8002d7 <_panic>

008028ee <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028ee:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028ef:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028f4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028f6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028f9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028fd:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802901:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802904:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802906:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80290a:	83 c4 08             	add    $0x8,%esp
	popal
  80290d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80290e:	83 c4 04             	add    $0x4,%esp
	popfl
  802911:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802912:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802913:	c3                   	ret    

00802914 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802914:	55                   	push   %ebp
  802915:	89 e5                	mov    %esp,%ebp
  802917:	56                   	push   %esi
  802918:	53                   	push   %ebx
  802919:	8b 75 08             	mov    0x8(%ebp),%esi
  80291c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802922:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802924:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802929:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80292c:	83 ec 0c             	sub    $0xc,%esp
  80292f:	50                   	push   %eax
  802930:	e8 99 e7 ff ff       	call   8010ce <sys_ipc_recv>
	if(ret < 0){
  802935:	83 c4 10             	add    $0x10,%esp
  802938:	85 c0                	test   %eax,%eax
  80293a:	78 2b                	js     802967 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80293c:	85 f6                	test   %esi,%esi
  80293e:	74 0a                	je     80294a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802940:	a1 20 54 80 00       	mov    0x805420,%eax
  802945:	8b 40 74             	mov    0x74(%eax),%eax
  802948:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80294a:	85 db                	test   %ebx,%ebx
  80294c:	74 0a                	je     802958 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80294e:	a1 20 54 80 00       	mov    0x805420,%eax
  802953:	8b 40 78             	mov    0x78(%eax),%eax
  802956:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802958:	a1 20 54 80 00       	mov    0x805420,%eax
  80295d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802960:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802963:	5b                   	pop    %ebx
  802964:	5e                   	pop    %esi
  802965:	5d                   	pop    %ebp
  802966:	c3                   	ret    
		if(from_env_store)
  802967:	85 f6                	test   %esi,%esi
  802969:	74 06                	je     802971 <ipc_recv+0x5d>
			*from_env_store = 0;
  80296b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802971:	85 db                	test   %ebx,%ebx
  802973:	74 eb                	je     802960 <ipc_recv+0x4c>
			*perm_store = 0;
  802975:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80297b:	eb e3                	jmp    802960 <ipc_recv+0x4c>

0080297d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80297d:	55                   	push   %ebp
  80297e:	89 e5                	mov    %esp,%ebp
  802980:	57                   	push   %edi
  802981:	56                   	push   %esi
  802982:	53                   	push   %ebx
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	8b 7d 08             	mov    0x8(%ebp),%edi
  802989:	8b 75 0c             	mov    0xc(%ebp),%esi
  80298c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80298f:	85 db                	test   %ebx,%ebx
  802991:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802996:	0f 44 d8             	cmove  %eax,%ebx
  802999:	eb 05                	jmp    8029a0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80299b:	e8 5f e5 ff ff       	call   800eff <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029a0:	ff 75 14             	pushl  0x14(%ebp)
  8029a3:	53                   	push   %ebx
  8029a4:	56                   	push   %esi
  8029a5:	57                   	push   %edi
  8029a6:	e8 00 e7 ff ff       	call   8010ab <sys_ipc_try_send>
  8029ab:	83 c4 10             	add    $0x10,%esp
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 1b                	je     8029cd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029b2:	79 e7                	jns    80299b <ipc_send+0x1e>
  8029b4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029b7:	74 e2                	je     80299b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 de 34 80 00       	push   $0x8034de
  8029c1:	6a 46                	push   $0x46
  8029c3:	68 f3 34 80 00       	push   $0x8034f3
  8029c8:	e8 0a d9 ff ff       	call   8002d7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029d0:	5b                   	pop    %ebx
  8029d1:	5e                   	pop    %esi
  8029d2:	5f                   	pop    %edi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    

008029d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029e0:	89 c2                	mov    %eax,%edx
  8029e2:	c1 e2 07             	shl    $0x7,%edx
  8029e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029eb:	8b 52 50             	mov    0x50(%edx),%edx
  8029ee:	39 ca                	cmp    %ecx,%edx
  8029f0:	74 11                	je     802a03 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029f2:	83 c0 01             	add    $0x1,%eax
  8029f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029fa:	75 e4                	jne    8029e0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802a01:	eb 0b                	jmp    802a0e <ipc_find_env+0x39>
			return envs[i].env_id;
  802a03:	c1 e0 07             	shl    $0x7,%eax
  802a06:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a0b:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    

00802a10 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a16:	89 d0                	mov    %edx,%eax
  802a18:	c1 e8 16             	shr    $0x16,%eax
  802a1b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a27:	f6 c1 01             	test   $0x1,%cl
  802a2a:	74 1d                	je     802a49 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a2c:	c1 ea 0c             	shr    $0xc,%edx
  802a2f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a36:	f6 c2 01             	test   $0x1,%dl
  802a39:	74 0e                	je     802a49 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a3b:	c1 ea 0c             	shr    $0xc,%edx
  802a3e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a45:	ef 
  802a46:	0f b7 c0             	movzwl %ax,%eax
}
  802a49:	5d                   	pop    %ebp
  802a4a:	c3                   	ret    
  802a4b:	66 90                	xchg   %ax,%ax
  802a4d:	66 90                	xchg   %ax,%ax
  802a4f:	90                   	nop

00802a50 <__udivdi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	83 ec 1c             	sub    $0x1c,%esp
  802a57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a67:	85 d2                	test   %edx,%edx
  802a69:	75 4d                	jne    802ab8 <__udivdi3+0x68>
  802a6b:	39 f3                	cmp    %esi,%ebx
  802a6d:	76 19                	jbe    802a88 <__udivdi3+0x38>
  802a6f:	31 ff                	xor    %edi,%edi
  802a71:	89 e8                	mov    %ebp,%eax
  802a73:	89 f2                	mov    %esi,%edx
  802a75:	f7 f3                	div    %ebx
  802a77:	89 fa                	mov    %edi,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 d9                	mov    %ebx,%ecx
  802a8a:	85 db                	test   %ebx,%ebx
  802a8c:	75 0b                	jne    802a99 <__udivdi3+0x49>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f3                	div    %ebx
  802a97:	89 c1                	mov    %eax,%ecx
  802a99:	31 d2                	xor    %edx,%edx
  802a9b:	89 f0                	mov    %esi,%eax
  802a9d:	f7 f1                	div    %ecx
  802a9f:	89 c6                	mov    %eax,%esi
  802aa1:	89 e8                	mov    %ebp,%eax
  802aa3:	89 f7                	mov    %esi,%edi
  802aa5:	f7 f1                	div    %ecx
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	39 f2                	cmp    %esi,%edx
  802aba:	77 1c                	ja     802ad8 <__udivdi3+0x88>
  802abc:	0f bd fa             	bsr    %edx,%edi
  802abf:	83 f7 1f             	xor    $0x1f,%edi
  802ac2:	75 2c                	jne    802af0 <__udivdi3+0xa0>
  802ac4:	39 f2                	cmp    %esi,%edx
  802ac6:	72 06                	jb     802ace <__udivdi3+0x7e>
  802ac8:	31 c0                	xor    %eax,%eax
  802aca:	39 eb                	cmp    %ebp,%ebx
  802acc:	77 a9                	ja     802a77 <__udivdi3+0x27>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	eb a2                	jmp    802a77 <__udivdi3+0x27>
  802ad5:	8d 76 00             	lea    0x0(%esi),%esi
  802ad8:	31 ff                	xor    %edi,%edi
  802ada:	31 c0                	xor    %eax,%eax
  802adc:	89 fa                	mov    %edi,%edx
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	89 f9                	mov    %edi,%ecx
  802af2:	b8 20 00 00 00       	mov    $0x20,%eax
  802af7:	29 f8                	sub    %edi,%eax
  802af9:	d3 e2                	shl    %cl,%edx
  802afb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aff:	89 c1                	mov    %eax,%ecx
  802b01:	89 da                	mov    %ebx,%edx
  802b03:	d3 ea                	shr    %cl,%edx
  802b05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b09:	09 d1                	or     %edx,%ecx
  802b0b:	89 f2                	mov    %esi,%edx
  802b0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b11:	89 f9                	mov    %edi,%ecx
  802b13:	d3 e3                	shl    %cl,%ebx
  802b15:	89 c1                	mov    %eax,%ecx
  802b17:	d3 ea                	shr    %cl,%edx
  802b19:	89 f9                	mov    %edi,%ecx
  802b1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b1f:	89 eb                	mov    %ebp,%ebx
  802b21:	d3 e6                	shl    %cl,%esi
  802b23:	89 c1                	mov    %eax,%ecx
  802b25:	d3 eb                	shr    %cl,%ebx
  802b27:	09 de                	or     %ebx,%esi
  802b29:	89 f0                	mov    %esi,%eax
  802b2b:	f7 74 24 08          	divl   0x8(%esp)
  802b2f:	89 d6                	mov    %edx,%esi
  802b31:	89 c3                	mov    %eax,%ebx
  802b33:	f7 64 24 0c          	mull   0xc(%esp)
  802b37:	39 d6                	cmp    %edx,%esi
  802b39:	72 15                	jb     802b50 <__udivdi3+0x100>
  802b3b:	89 f9                	mov    %edi,%ecx
  802b3d:	d3 e5                	shl    %cl,%ebp
  802b3f:	39 c5                	cmp    %eax,%ebp
  802b41:	73 04                	jae    802b47 <__udivdi3+0xf7>
  802b43:	39 d6                	cmp    %edx,%esi
  802b45:	74 09                	je     802b50 <__udivdi3+0x100>
  802b47:	89 d8                	mov    %ebx,%eax
  802b49:	31 ff                	xor    %edi,%edi
  802b4b:	e9 27 ff ff ff       	jmp    802a77 <__udivdi3+0x27>
  802b50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b53:	31 ff                	xor    %edi,%edi
  802b55:	e9 1d ff ff ff       	jmp    802a77 <__udivdi3+0x27>
  802b5a:	66 90                	xchg   %ax,%ax
  802b5c:	66 90                	xchg   %ax,%ax
  802b5e:	66 90                	xchg   %ax,%ax

00802b60 <__umoddi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	53                   	push   %ebx
  802b64:	83 ec 1c             	sub    $0x1c,%esp
  802b67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b77:	89 da                	mov    %ebx,%edx
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 43                	jne    802bc0 <__umoddi3+0x60>
  802b7d:	39 df                	cmp    %ebx,%edi
  802b7f:	76 17                	jbe    802b98 <__umoddi3+0x38>
  802b81:	89 f0                	mov    %esi,%eax
  802b83:	f7 f7                	div    %edi
  802b85:	89 d0                	mov    %edx,%eax
  802b87:	31 d2                	xor    %edx,%edx
  802b89:	83 c4 1c             	add    $0x1c,%esp
  802b8c:	5b                   	pop    %ebx
  802b8d:	5e                   	pop    %esi
  802b8e:	5f                   	pop    %edi
  802b8f:	5d                   	pop    %ebp
  802b90:	c3                   	ret    
  802b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b98:	89 fd                	mov    %edi,%ebp
  802b9a:	85 ff                	test   %edi,%edi
  802b9c:	75 0b                	jne    802ba9 <__umoddi3+0x49>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	31 d2                	xor    %edx,%edx
  802ba5:	f7 f7                	div    %edi
  802ba7:	89 c5                	mov    %eax,%ebp
  802ba9:	89 d8                	mov    %ebx,%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	f7 f5                	div    %ebp
  802baf:	89 f0                	mov    %esi,%eax
  802bb1:	f7 f5                	div    %ebp
  802bb3:	89 d0                	mov    %edx,%eax
  802bb5:	eb d0                	jmp    802b87 <__umoddi3+0x27>
  802bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bbe:	66 90                	xchg   %ax,%ax
  802bc0:	89 f1                	mov    %esi,%ecx
  802bc2:	39 d8                	cmp    %ebx,%eax
  802bc4:	76 0a                	jbe    802bd0 <__umoddi3+0x70>
  802bc6:	89 f0                	mov    %esi,%eax
  802bc8:	83 c4 1c             	add    $0x1c,%esp
  802bcb:	5b                   	pop    %ebx
  802bcc:	5e                   	pop    %esi
  802bcd:	5f                   	pop    %edi
  802bce:	5d                   	pop    %ebp
  802bcf:	c3                   	ret    
  802bd0:	0f bd e8             	bsr    %eax,%ebp
  802bd3:	83 f5 1f             	xor    $0x1f,%ebp
  802bd6:	75 20                	jne    802bf8 <__umoddi3+0x98>
  802bd8:	39 d8                	cmp    %ebx,%eax
  802bda:	0f 82 b0 00 00 00    	jb     802c90 <__umoddi3+0x130>
  802be0:	39 f7                	cmp    %esi,%edi
  802be2:	0f 86 a8 00 00 00    	jbe    802c90 <__umoddi3+0x130>
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	83 c4 1c             	add    $0x1c,%esp
  802bed:	5b                   	pop    %ebx
  802bee:	5e                   	pop    %esi
  802bef:	5f                   	pop    %edi
  802bf0:	5d                   	pop    %ebp
  802bf1:	c3                   	ret    
  802bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bf8:	89 e9                	mov    %ebp,%ecx
  802bfa:	ba 20 00 00 00       	mov    $0x20,%edx
  802bff:	29 ea                	sub    %ebp,%edx
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c07:	89 d1                	mov    %edx,%ecx
  802c09:	89 f8                	mov    %edi,%eax
  802c0b:	d3 e8                	shr    %cl,%eax
  802c0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c19:	09 c1                	or     %eax,%ecx
  802c1b:	89 d8                	mov    %ebx,%eax
  802c1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c21:	89 e9                	mov    %ebp,%ecx
  802c23:	d3 e7                	shl    %cl,%edi
  802c25:	89 d1                	mov    %edx,%ecx
  802c27:	d3 e8                	shr    %cl,%eax
  802c29:	89 e9                	mov    %ebp,%ecx
  802c2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c2f:	d3 e3                	shl    %cl,%ebx
  802c31:	89 c7                	mov    %eax,%edi
  802c33:	89 d1                	mov    %edx,%ecx
  802c35:	89 f0                	mov    %esi,%eax
  802c37:	d3 e8                	shr    %cl,%eax
  802c39:	89 e9                	mov    %ebp,%ecx
  802c3b:	89 fa                	mov    %edi,%edx
  802c3d:	d3 e6                	shl    %cl,%esi
  802c3f:	09 d8                	or     %ebx,%eax
  802c41:	f7 74 24 08          	divl   0x8(%esp)
  802c45:	89 d1                	mov    %edx,%ecx
  802c47:	89 f3                	mov    %esi,%ebx
  802c49:	f7 64 24 0c          	mull   0xc(%esp)
  802c4d:	89 c6                	mov    %eax,%esi
  802c4f:	89 d7                	mov    %edx,%edi
  802c51:	39 d1                	cmp    %edx,%ecx
  802c53:	72 06                	jb     802c5b <__umoddi3+0xfb>
  802c55:	75 10                	jne    802c67 <__umoddi3+0x107>
  802c57:	39 c3                	cmp    %eax,%ebx
  802c59:	73 0c                	jae    802c67 <__umoddi3+0x107>
  802c5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c63:	89 d7                	mov    %edx,%edi
  802c65:	89 c6                	mov    %eax,%esi
  802c67:	89 ca                	mov    %ecx,%edx
  802c69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c6e:	29 f3                	sub    %esi,%ebx
  802c70:	19 fa                	sbb    %edi,%edx
  802c72:	89 d0                	mov    %edx,%eax
  802c74:	d3 e0                	shl    %cl,%eax
  802c76:	89 e9                	mov    %ebp,%ecx
  802c78:	d3 eb                	shr    %cl,%ebx
  802c7a:	d3 ea                	shr    %cl,%edx
  802c7c:	09 d8                	or     %ebx,%eax
  802c7e:	83 c4 1c             	add    $0x1c,%esp
  802c81:	5b                   	pop    %ebx
  802c82:	5e                   	pop    %esi
  802c83:	5f                   	pop    %edi
  802c84:	5d                   	pop    %ebp
  802c85:	c3                   	ret    
  802c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	89 da                	mov    %ebx,%edx
  802c92:	29 fe                	sub    %edi,%esi
  802c94:	19 c2                	sbb    %eax,%edx
  802c96:	89 f1                	mov    %esi,%ecx
  802c98:	89 c8                	mov    %ecx,%eax
  802c9a:	e9 4b ff ff ff       	jmp    802bea <__umoddi3+0x8a>
