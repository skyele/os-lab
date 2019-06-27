
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
  80003e:	68 e0 2c 80 00       	push   $0x802ce0
  800043:	e8 41 1e 00 00       	call   801e89 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 d9 1a 00 00       	call   801b39 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 ff 19 00 00       	call   801a72 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 e5 13 00 00       	call   80146a <fork>
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
  800097:	e8 9d 1a 00 00       	call   801b39 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 50 2d 80 00 	movl   $0x802d50,(%esp)
  8000a3:	e8 27 03 00 00       	call   8003cf <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 b7 19 00 00       	call   801a72 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 50 80 00       	push   $0x805020
  8000cf:	68 20 52 80 00       	push   $0x805220
  8000d4:	e8 5b 0c 00 00       	call   800d34 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 1b 2d 80 00       	push   $0x802d1b
  8000ec:	e8 de 02 00 00       	call   8003cf <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 3d 1a 00 00       	call   801b39 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 a9 17 00 00       	call   8018ad <close>
		exit();
  800104:	e8 9c 01 00 00       	call   8002a5 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 ce 25 00 00       	call   8026e3 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 4a 19 00 00       	call   801a72 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 34 2d 80 00       	push   $0x802d34
  80013b:	e8 8f 02 00 00       	call   8003cf <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 65 17 00 00       	call   8018ad <close>
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
  800155:	68 e5 2c 80 00       	push   $0x802ce5
  80015a:	6a 0c                	push   $0xc
  80015c:	68 f3 2c 80 00       	push   $0x802cf3
  800161:	e8 73 01 00 00       	call   8002d9 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 08 2d 80 00       	push   $0x802d08
  80016c:	6a 0f                	push   $0xf
  80016e:	68 f3 2c 80 00       	push   $0x802cf3
  800173:	e8 61 01 00 00       	call   8002d9 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 12 2d 80 00       	push   $0x802d12
  80017e:	6a 12                	push   $0x12
  800180:	68 f3 2c 80 00       	push   $0x802cf3
  800185:	e8 4f 01 00 00       	call   8002d9 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 94 2d 80 00       	push   $0x802d94
  800194:	6a 17                	push   $0x17
  800196:	68 f3 2c 80 00       	push   $0x802cf3
  80019b:	e8 39 01 00 00       	call   8002d9 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 c0 2d 80 00       	push   $0x802dc0
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 f3 2c 80 00       	push   $0x802cf3
  8001af:	e8 25 01 00 00       	call   8002d9 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 f8 2d 80 00       	push   $0x802df8
  8001be:	6a 21                	push   $0x21
  8001c0:	68 f3 2c 80 00       	push   $0x802cf3
  8001c5:	e8 0f 01 00 00       	call   8002d9 <_panic>

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
  8001dd:	e8 00 0d 00 00       	call   800ee2 <sys_getenvid>
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
  800202:	74 23                	je     800227 <libmain+0x5d>
		if(envs[i].env_id == find)
  800204:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80020a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800210:	8b 49 48             	mov    0x48(%ecx),%ecx
  800213:	39 c1                	cmp    %eax,%ecx
  800215:	75 e2                	jne    8001f9 <libmain+0x2f>
  800217:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80021d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800223:	89 fe                	mov    %edi,%esi
  800225:	eb d2                	jmp    8001f9 <libmain+0x2f>
  800227:	89 f0                	mov    %esi,%eax
  800229:	84 c0                	test   %al,%al
  80022b:	74 06                	je     800233 <libmain+0x69>
  80022d:	89 1d 20 54 80 00    	mov    %ebx,0x805420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800237:	7e 0a                	jle    800243 <libmain+0x79>
		binaryname = argv[0];
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	8b 00                	mov    (%eax),%eax
  80023e:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800243:	a1 20 54 80 00       	mov    0x805420,%eax
  800248:	8b 40 48             	mov    0x48(%eax),%eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	50                   	push   %eax
  80024f:	68 1b 2e 80 00       	push   $0x802e1b
  800254:	e8 76 01 00 00       	call   8003cf <cprintf>
	cprintf("before umain\n");
  800259:	c7 04 24 39 2e 80 00 	movl   $0x802e39,(%esp)
  800260:	e8 6a 01 00 00       	call   8003cf <cprintf>
	// call user main routine
	umain(argc, argv);
  800265:	83 c4 08             	add    $0x8,%esp
  800268:	ff 75 0c             	pushl  0xc(%ebp)
  80026b:	ff 75 08             	pushl  0x8(%ebp)
  80026e:	e8 c0 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800273:	c7 04 24 47 2e 80 00 	movl   $0x802e47,(%esp)
  80027a:	e8 50 01 00 00       	call   8003cf <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80027f:	a1 20 54 80 00       	mov    0x805420,%eax
  800284:	8b 40 48             	mov    0x48(%eax),%eax
  800287:	83 c4 08             	add    $0x8,%esp
  80028a:	50                   	push   %eax
  80028b:	68 54 2e 80 00       	push   $0x802e54
  800290:	e8 3a 01 00 00       	call   8003cf <cprintf>
	// exit gracefully
	exit();
  800295:	e8 0b 00 00 00       	call   8002a5 <exit>
}
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a0:	5b                   	pop    %ebx
  8002a1:	5e                   	pop    %esi
  8002a2:	5f                   	pop    %edi
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002ab:	a1 20 54 80 00       	mov    0x805420,%eax
  8002b0:	8b 40 48             	mov    0x48(%eax),%eax
  8002b3:	68 80 2e 80 00       	push   $0x802e80
  8002b8:	50                   	push   %eax
  8002b9:	68 73 2e 80 00       	push   $0x802e73
  8002be:	e8 0c 01 00 00       	call   8003cf <cprintf>
	close_all();
  8002c3:	e8 12 16 00 00       	call   8018da <close_all>
	sys_env_destroy(0);
  8002c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002cf:	e8 cd 0b 00 00       	call   800ea1 <sys_env_destroy>
}
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002de:	a1 20 54 80 00       	mov    0x805420,%eax
  8002e3:	8b 40 48             	mov    0x48(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	68 ac 2e 80 00       	push   $0x802eac
  8002ee:	50                   	push   %eax
  8002ef:	68 73 2e 80 00       	push   $0x802e73
  8002f4:	e8 d6 00 00 00       	call   8003cf <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fc:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800302:	e8 db 0b 00 00       	call   800ee2 <sys_getenvid>
  800307:	83 c4 04             	add    $0x4,%esp
  80030a:	ff 75 0c             	pushl  0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	56                   	push   %esi
  800311:	50                   	push   %eax
  800312:	68 88 2e 80 00       	push   $0x802e88
  800317:	e8 b3 00 00 00       	call   8003cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031c:	83 c4 18             	add    $0x18,%esp
  80031f:	53                   	push   %ebx
  800320:	ff 75 10             	pushl  0x10(%ebp)
  800323:	e8 56 00 00 00       	call   80037e <vcprintf>
	cprintf("\n");
  800328:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  80032f:	e8 9b 00 00 00       	call   8003cf <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800337:	cc                   	int3   
  800338:	eb fd                	jmp    800337 <_panic+0x5e>

0080033a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	53                   	push   %ebx
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800344:	8b 13                	mov    (%ebx),%edx
  800346:	8d 42 01             	lea    0x1(%edx),%eax
  800349:	89 03                	mov    %eax,(%ebx)
  80034b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800352:	3d ff 00 00 00       	cmp    $0xff,%eax
  800357:	74 09                	je     800362 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800359:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800360:	c9                   	leave  
  800361:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	68 ff 00 00 00       	push   $0xff
  80036a:	8d 43 08             	lea    0x8(%ebx),%eax
  80036d:	50                   	push   %eax
  80036e:	e8 f1 0a 00 00       	call   800e64 <sys_cputs>
		b->idx = 0;
  800373:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb db                	jmp    800359 <putch+0x1f>

0080037e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800387:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038e:	00 00 00 
	b.cnt = 0;
  800391:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800398:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a7:	50                   	push   %eax
  8003a8:	68 3a 03 80 00       	push   $0x80033a
  8003ad:	e8 4a 01 00 00       	call   8004fc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b2:	83 c4 08             	add    $0x8,%esp
  8003b5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 9d 0a 00 00       	call   800e64 <sys_cputs>

	return b.cnt;
}
  8003c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cd:	c9                   	leave  
  8003ce:	c3                   	ret    

008003cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d8:	50                   	push   %eax
  8003d9:	ff 75 08             	pushl  0x8(%ebp)
  8003dc:	e8 9d ff ff ff       	call   80037e <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	57                   	push   %edi
  8003e7:	56                   	push   %esi
  8003e8:	53                   	push   %ebx
  8003e9:	83 ec 1c             	sub    $0x1c,%esp
  8003ec:	89 c6                	mov    %eax,%esi
  8003ee:	89 d7                	mov    %edx,%edi
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800402:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800406:	74 2c                	je     800434 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800408:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800412:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800415:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80041d:	73 43                	jae    800462 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	85 db                	test   %ebx,%ebx
  800424:	7e 6c                	jle    800492 <printnum+0xaf>
				putch(padc, putdat);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	57                   	push   %edi
  80042a:	ff 75 18             	pushl  0x18(%ebp)
  80042d:	ff d6                	call   *%esi
  80042f:	83 c4 10             	add    $0x10,%esp
  800432:	eb eb                	jmp    80041f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800434:	83 ec 0c             	sub    $0xc,%esp
  800437:	6a 20                	push   $0x20
  800439:	6a 00                	push   $0x0
  80043b:	50                   	push   %eax
  80043c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043f:	ff 75 e0             	pushl  -0x20(%ebp)
  800442:	89 fa                	mov    %edi,%edx
  800444:	89 f0                	mov    %esi,%eax
  800446:	e8 98 ff ff ff       	call   8003e3 <printnum>
		while (--width > 0)
  80044b:	83 c4 20             	add    $0x20,%esp
  80044e:	83 eb 01             	sub    $0x1,%ebx
  800451:	85 db                	test   %ebx,%ebx
  800453:	7e 65                	jle    8004ba <printnum+0xd7>
			putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	57                   	push   %edi
  800459:	6a 20                	push   $0x20
  80045b:	ff d6                	call   *%esi
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	eb ec                	jmp    80044e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 18             	pushl  0x18(%ebp)
  800468:	83 eb 01             	sub    $0x1,%ebx
  80046b:	53                   	push   %ebx
  80046c:	50                   	push   %eax
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 dc             	pushl  -0x24(%ebp)
  800473:	ff 75 d8             	pushl  -0x28(%ebp)
  800476:	ff 75 e4             	pushl  -0x1c(%ebp)
  800479:	ff 75 e0             	pushl  -0x20(%ebp)
  80047c:	e8 ff 25 00 00       	call   802a80 <__udivdi3>
  800481:	83 c4 18             	add    $0x18,%esp
  800484:	52                   	push   %edx
  800485:	50                   	push   %eax
  800486:	89 fa                	mov    %edi,%edx
  800488:	89 f0                	mov    %esi,%eax
  80048a:	e8 54 ff ff ff       	call   8003e3 <printnum>
  80048f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	57                   	push   %edi
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	ff 75 dc             	pushl  -0x24(%ebp)
  80049c:	ff 75 d8             	pushl  -0x28(%ebp)
  80049f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a5:	e8 e6 26 00 00       	call   802b90 <__umoddi3>
  8004aa:	83 c4 14             	add    $0x14,%esp
  8004ad:	0f be 80 b3 2e 80 00 	movsbl 0x802eb3(%eax),%eax
  8004b4:	50                   	push   %eax
  8004b5:	ff d6                	call   *%esi
  8004b7:	83 c4 10             	add    $0x10,%esp
	}
}
  8004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bd:	5b                   	pop    %ebx
  8004be:	5e                   	pop    %esi
  8004bf:	5f                   	pop    %edi
  8004c0:	5d                   	pop    %ebp
  8004c1:	c3                   	ret    

008004c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004cc:	8b 10                	mov    (%eax),%edx
  8004ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d1:	73 0a                	jae    8004dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d6:	89 08                	mov    %ecx,(%eax)
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	88 02                	mov    %al,(%edx)
}
  8004dd:	5d                   	pop    %ebp
  8004de:	c3                   	ret    

008004df <printfmt>:
{
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e8:	50                   	push   %eax
  8004e9:	ff 75 10             	pushl  0x10(%ebp)
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	ff 75 08             	pushl  0x8(%ebp)
  8004f2:	e8 05 00 00 00       	call   8004fc <vprintfmt>
}
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <vprintfmt>:
{
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	57                   	push   %edi
  800500:	56                   	push   %esi
  800501:	53                   	push   %ebx
  800502:	83 ec 3c             	sub    $0x3c,%esp
  800505:	8b 75 08             	mov    0x8(%ebp),%esi
  800508:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050e:	e9 32 04 00 00       	jmp    800945 <vprintfmt+0x449>
		padc = ' ';
  800513:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800517:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80051e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800525:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80052c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800533:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80053a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053f:	8d 47 01             	lea    0x1(%edi),%eax
  800542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800545:	0f b6 17             	movzbl (%edi),%edx
  800548:	8d 42 dd             	lea    -0x23(%edx),%eax
  80054b:	3c 55                	cmp    $0x55,%al
  80054d:	0f 87 12 05 00 00    	ja     800a65 <vprintfmt+0x569>
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	ff 24 85 a0 30 80 00 	jmp    *0x8030a0(,%eax,4)
  80055d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800560:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800564:	eb d9                	jmp    80053f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800569:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80056d:	eb d0                	jmp    80053f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80056f:	0f b6 d2             	movzbl %dl,%edx
  800572:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800575:	b8 00 00 00 00       	mov    $0x0,%eax
  80057a:	89 75 08             	mov    %esi,0x8(%ebp)
  80057d:	eb 03                	jmp    800582 <vprintfmt+0x86>
  80057f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800582:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800585:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800589:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80058f:	83 fe 09             	cmp    $0x9,%esi
  800592:	76 eb                	jbe    80057f <vprintfmt+0x83>
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	8b 75 08             	mov    0x8(%ebp),%esi
  80059a:	eb 14                	jmp    8005b0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b4:	79 89                	jns    80053f <vprintfmt+0x43>
				width = precision, precision = -1;
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005c3:	e9 77 ff ff ff       	jmp    80053f <vprintfmt+0x43>
  8005c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	0f 48 c1             	cmovs  %ecx,%eax
  8005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d6:	e9 64 ff ff ff       	jmp    80053f <vprintfmt+0x43>
  8005db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005de:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005e5:	e9 55 ff ff ff       	jmp    80053f <vprintfmt+0x43>
			lflag++;
  8005ea:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f1:	e9 49 ff ff ff       	jmp    80053f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8d 78 04             	lea    0x4(%eax),%edi
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	ff 30                	pushl  (%eax)
  800602:	ff d6                	call   *%esi
			break;
  800604:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800607:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80060a:	e9 33 03 00 00       	jmp    800942 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 78 04             	lea    0x4(%eax),%edi
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	31 d0                	xor    %edx,%eax
  80061a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061c:	83 f8 11             	cmp    $0x11,%eax
  80061f:	7f 23                	jg     800644 <vprintfmt+0x148>
  800621:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  800628:	85 d2                	test   %edx,%edx
  80062a:	74 18                	je     800644 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80062c:	52                   	push   %edx
  80062d:	68 0d 34 80 00       	push   $0x80340d
  800632:	53                   	push   %ebx
  800633:	56                   	push   %esi
  800634:	e8 a6 fe ff ff       	call   8004df <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063f:	e9 fe 02 00 00       	jmp    800942 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800644:	50                   	push   %eax
  800645:	68 cb 2e 80 00       	push   $0x802ecb
  80064a:	53                   	push   %ebx
  80064b:	56                   	push   %esi
  80064c:	e8 8e fe ff ff       	call   8004df <printfmt>
  800651:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800654:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800657:	e9 e6 02 00 00       	jmp    800942 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	83 c0 04             	add    $0x4,%eax
  800662:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80066a:	85 c9                	test   %ecx,%ecx
  80066c:	b8 c4 2e 80 00       	mov    $0x802ec4,%eax
  800671:	0f 45 c1             	cmovne %ecx,%eax
  800674:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800677:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067b:	7e 06                	jle    800683 <vprintfmt+0x187>
  80067d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800681:	75 0d                	jne    800690 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800683:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800686:	89 c7                	mov    %eax,%edi
  800688:	03 45 e0             	add    -0x20(%ebp),%eax
  80068b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068e:	eb 53                	jmp    8006e3 <vprintfmt+0x1e7>
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 d8             	pushl  -0x28(%ebp)
  800696:	50                   	push   %eax
  800697:	e8 71 04 00 00       	call   800b0d <strnlen>
  80069c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069f:	29 c1                	sub    %eax,%ecx
  8006a1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006a9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b0:	eb 0f                	jmp    8006c1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bb:	83 ef 01             	sub    $0x1,%edi
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	85 ff                	test   %edi,%edi
  8006c3:	7f ed                	jg     8006b2 <vprintfmt+0x1b6>
  8006c5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006c8:	85 c9                	test   %ecx,%ecx
  8006ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cf:	0f 49 c1             	cmovns %ecx,%eax
  8006d2:	29 c1                	sub    %eax,%ecx
  8006d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006d7:	eb aa                	jmp    800683 <vprintfmt+0x187>
					putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	52                   	push   %edx
  8006de:	ff d6                	call   *%esi
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e8:	83 c7 01             	add    $0x1,%edi
  8006eb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ef:	0f be d0             	movsbl %al,%edx
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	74 4b                	je     800741 <vprintfmt+0x245>
  8006f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006fa:	78 06                	js     800702 <vprintfmt+0x206>
  8006fc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800700:	78 1e                	js     800720 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800702:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800706:	74 d1                	je     8006d9 <vprintfmt+0x1dd>
  800708:	0f be c0             	movsbl %al,%eax
  80070b:	83 e8 20             	sub    $0x20,%eax
  80070e:	83 f8 5e             	cmp    $0x5e,%eax
  800711:	76 c6                	jbe    8006d9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 3f                	push   $0x3f
  800719:	ff d6                	call   *%esi
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	eb c3                	jmp    8006e3 <vprintfmt+0x1e7>
  800720:	89 cf                	mov    %ecx,%edi
  800722:	eb 0e                	jmp    800732 <vprintfmt+0x236>
				putch(' ', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 20                	push   $0x20
  80072a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072c:	83 ef 01             	sub    $0x1,%edi
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	85 ff                	test   %edi,%edi
  800734:	7f ee                	jg     800724 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800736:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
  80073c:	e9 01 02 00 00       	jmp    800942 <vprintfmt+0x446>
  800741:	89 cf                	mov    %ecx,%edi
  800743:	eb ed                	jmp    800732 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800745:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800748:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80074f:	e9 eb fd ff ff       	jmp    80053f <vprintfmt+0x43>
	if (lflag >= 2)
  800754:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800758:	7f 21                	jg     80077b <vprintfmt+0x27f>
	else if (lflag)
  80075a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075e:	74 68                	je     8007c8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800768:	89 c1                	mov    %eax,%ecx
  80076a:	c1 f9 1f             	sar    $0x1f,%ecx
  80076d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	eb 17                	jmp    800792 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 50 04             	mov    0x4(%eax),%edx
  800781:	8b 00                	mov    (%eax),%eax
  800783:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800786:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 08             	lea    0x8(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800792:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800795:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80079e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a2:	78 3f                	js     8007e3 <vprintfmt+0x2e7>
			base = 10;
  8007a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007a9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007ad:	0f 84 71 01 00 00    	je     800924 <vprintfmt+0x428>
				putch('+', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 2b                	push   $0x2b
  8007b9:	ff d6                	call   *%esi
  8007bb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c3:	e9 5c 01 00 00       	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007d0:	89 c1                	mov    %eax,%ecx
  8007d2:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8d 40 04             	lea    0x4(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e1:	eb af                	jmp    800792 <vprintfmt+0x296>
				putch('-', putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	6a 2d                	push   $0x2d
  8007e9:	ff d6                	call   *%esi
				num = -(long long) num;
  8007eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007f1:	f7 d8                	neg    %eax
  8007f3:	83 d2 00             	adc    $0x0,%edx
  8007f6:	f7 da                	neg    %edx
  8007f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fe:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800801:	b8 0a 00 00 00       	mov    $0xa,%eax
  800806:	e9 19 01 00 00       	jmp    800924 <vprintfmt+0x428>
	if (lflag >= 2)
  80080b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80080f:	7f 29                	jg     80083a <vprintfmt+0x33e>
	else if (lflag)
  800811:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800815:	74 44                	je     80085b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
  800821:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800824:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800830:	b8 0a 00 00 00       	mov    $0xa,%eax
  800835:	e9 ea 00 00 00       	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 50 04             	mov    0x4(%eax),%edx
  800840:	8b 00                	mov    (%eax),%eax
  800842:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800845:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8d 40 08             	lea    0x8(%eax),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800851:	b8 0a 00 00 00       	mov    $0xa,%eax
  800856:	e9 c9 00 00 00       	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800868:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800874:	b8 0a 00 00 00       	mov    $0xa,%eax
  800879:	e9 a6 00 00 00       	jmp    800924 <vprintfmt+0x428>
			putch('0', putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	53                   	push   %ebx
  800882:	6a 30                	push   $0x30
  800884:	ff d6                	call   *%esi
	if (lflag >= 2)
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088d:	7f 26                	jg     8008b5 <vprintfmt+0x3b9>
	else if (lflag)
  80088f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800893:	74 3e                	je     8008d3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	ba 00 00 00 00       	mov    $0x0,%edx
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b3:	eb 6f                	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 08             	lea    0x8(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d1:	eb 51                	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	8d 40 04             	lea    0x4(%eax),%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f1:	eb 31                	jmp    800924 <vprintfmt+0x428>
			putch('0', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	53                   	push   %ebx
  8008f7:	6a 30                	push   $0x30
  8008f9:	ff d6                	call   *%esi
			putch('x', putdat);
  8008fb:	83 c4 08             	add    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	6a 78                	push   $0x78
  800901:	ff d6                	call   *%esi
			num = (unsigned long long)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800910:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800913:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	8d 40 04             	lea    0x4(%eax),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800924:	83 ec 0c             	sub    $0xc,%esp
  800927:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80092b:	52                   	push   %edx
  80092c:	ff 75 e0             	pushl  -0x20(%ebp)
  80092f:	50                   	push   %eax
  800930:	ff 75 dc             	pushl  -0x24(%ebp)
  800933:	ff 75 d8             	pushl  -0x28(%ebp)
  800936:	89 da                	mov    %ebx,%edx
  800938:	89 f0                	mov    %esi,%eax
  80093a:	e8 a4 fa ff ff       	call   8003e3 <printnum>
			break;
  80093f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800942:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800945:	83 c7 01             	add    $0x1,%edi
  800948:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80094c:	83 f8 25             	cmp    $0x25,%eax
  80094f:	0f 84 be fb ff ff    	je     800513 <vprintfmt+0x17>
			if (ch == '\0')
  800955:	85 c0                	test   %eax,%eax
  800957:	0f 84 28 01 00 00    	je     800a85 <vprintfmt+0x589>
			putch(ch, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	53                   	push   %ebx
  800961:	50                   	push   %eax
  800962:	ff d6                	call   *%esi
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	eb dc                	jmp    800945 <vprintfmt+0x449>
	if (lflag >= 2)
  800969:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80096d:	7f 26                	jg     800995 <vprintfmt+0x499>
	else if (lflag)
  80096f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800973:	74 41                	je     8009b6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	ba 00 00 00 00       	mov    $0x0,%edx
  80097f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800982:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 40 04             	lea    0x4(%eax),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098e:	b8 10 00 00 00       	mov    $0x10,%eax
  800993:	eb 8f                	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8b 50 04             	mov    0x4(%eax),%edx
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8d 40 08             	lea    0x8(%eax),%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ac:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b1:	e9 6e ff ff ff       	jmp    800924 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	8d 40 04             	lea    0x4(%eax),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d4:	e9 4b ff ff ff       	jmp    800924 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	83 c0 04             	add    $0x4,%eax
  8009df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e5:	8b 00                	mov    (%eax),%eax
  8009e7:	85 c0                	test   %eax,%eax
  8009e9:	74 14                	je     8009ff <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009eb:	8b 13                	mov    (%ebx),%edx
  8009ed:	83 fa 7f             	cmp    $0x7f,%edx
  8009f0:	7f 37                	jg     800a29 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009f2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fa:	e9 43 ff ff ff       	jmp    800942 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a04:	bf e9 2f 80 00       	mov    $0x802fe9,%edi
							putch(ch, putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	53                   	push   %ebx
  800a0d:	50                   	push   %eax
  800a0e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a10:	83 c7 01             	add    $0x1,%edi
  800a13:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a17:	83 c4 10             	add    $0x10,%esp
  800a1a:	85 c0                	test   %eax,%eax
  800a1c:	75 eb                	jne    800a09 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	e9 19 ff ff ff       	jmp    800942 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a29:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a2b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a30:	bf 21 30 80 00       	mov    $0x803021,%edi
							putch(ch, putdat);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	53                   	push   %ebx
  800a39:	50                   	push   %eax
  800a3a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a3c:	83 c7 01             	add    $0x1,%edi
  800a3f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a43:	83 c4 10             	add    $0x10,%esp
  800a46:	85 c0                	test   %eax,%eax
  800a48:	75 eb                	jne    800a35 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a50:	e9 ed fe ff ff       	jmp    800942 <vprintfmt+0x446>
			putch(ch, putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	53                   	push   %ebx
  800a59:	6a 25                	push   $0x25
  800a5b:	ff d6                	call   *%esi
			break;
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	e9 dd fe ff ff       	jmp    800942 <vprintfmt+0x446>
			putch('%', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	53                   	push   %ebx
  800a69:	6a 25                	push   $0x25
  800a6b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	eb 03                	jmp    800a77 <vprintfmt+0x57b>
  800a74:	83 e8 01             	sub    $0x1,%eax
  800a77:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a7b:	75 f7                	jne    800a74 <vprintfmt+0x578>
  800a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a80:	e9 bd fe ff ff       	jmp    800942 <vprintfmt+0x446>
}
  800a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5f                   	pop    %edi
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 18             	sub    $0x18,%esp
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aa0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	74 26                	je     800ad4 <vsnprintf+0x47>
  800aae:	85 d2                	test   %edx,%edx
  800ab0:	7e 22                	jle    800ad4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab2:	ff 75 14             	pushl  0x14(%ebp)
  800ab5:	ff 75 10             	pushl  0x10(%ebp)
  800ab8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800abb:	50                   	push   %eax
  800abc:	68 c2 04 80 00       	push   $0x8004c2
  800ac1:	e8 36 fa ff ff       	call   8004fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800acf:	83 c4 10             	add    $0x10,%esp
}
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    
		return -E_INVAL;
  800ad4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad9:	eb f7                	jmp    800ad2 <vsnprintf+0x45>

00800adb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 10             	pushl  0x10(%ebp)
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	e8 9a ff ff ff       	call   800a8d <vsnprintf>
	va_end(ap);

	return rc;
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b04:	74 05                	je     800b0b <strlen+0x16>
		n++;
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	eb f5                	jmp    800b00 <strlen+0xb>
	return n;
}
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1b:	39 c2                	cmp    %eax,%edx
  800b1d:	74 0d                	je     800b2c <strnlen+0x1f>
  800b1f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b23:	74 05                	je     800b2a <strnlen+0x1d>
		n++;
  800b25:	83 c2 01             	add    $0x1,%edx
  800b28:	eb f1                	jmp    800b1b <strnlen+0xe>
  800b2a:	89 d0                	mov    %edx,%eax
	return n;
}
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b41:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b44:	83 c2 01             	add    $0x1,%edx
  800b47:	84 c9                	test   %cl,%cl
  800b49:	75 f2                	jne    800b3d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	53                   	push   %ebx
  800b52:	83 ec 10             	sub    $0x10,%esp
  800b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b58:	53                   	push   %ebx
  800b59:	e8 97 ff ff ff       	call   800af5 <strlen>
  800b5e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	01 d8                	add    %ebx,%eax
  800b66:	50                   	push   %eax
  800b67:	e8 c2 ff ff ff       	call   800b2e <strcpy>
	return dst;
}
  800b6c:	89 d8                	mov    %ebx,%eax
  800b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7e:	89 c6                	mov    %eax,%esi
  800b80:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	39 f2                	cmp    %esi,%edx
  800b87:	74 11                	je     800b9a <strncpy+0x27>
		*dst++ = *src;
  800b89:	83 c2 01             	add    $0x1,%edx
  800b8c:	0f b6 19             	movzbl (%ecx),%ebx
  800b8f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b92:	80 fb 01             	cmp    $0x1,%bl
  800b95:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b98:	eb eb                	jmp    800b85 <strncpy+0x12>
	}
	return ret;
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba9:	8b 55 10             	mov    0x10(%ebp),%edx
  800bac:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bae:	85 d2                	test   %edx,%edx
  800bb0:	74 21                	je     800bd3 <strlcpy+0x35>
  800bb2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	74 14                	je     800bd0 <strlcpy+0x32>
  800bbc:	0f b6 19             	movzbl (%ecx),%ebx
  800bbf:	84 db                	test   %bl,%bl
  800bc1:	74 0b                	je     800bce <strlcpy+0x30>
			*dst++ = *src++;
  800bc3:	83 c1 01             	add    $0x1,%ecx
  800bc6:	83 c2 01             	add    $0x1,%edx
  800bc9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcc:	eb ea                	jmp    800bb8 <strlcpy+0x1a>
  800bce:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd3:	29 f0                	sub    %esi,%eax
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be2:	0f b6 01             	movzbl (%ecx),%eax
  800be5:	84 c0                	test   %al,%al
  800be7:	74 0c                	je     800bf5 <strcmp+0x1c>
  800be9:	3a 02                	cmp    (%edx),%al
  800beb:	75 08                	jne    800bf5 <strcmp+0x1c>
		p++, q++;
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	eb ed                	jmp    800be2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	0f b6 12             	movzbl (%edx),%edx
  800bfb:	29 d0                	sub    %edx,%eax
}
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	53                   	push   %ebx
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	89 c3                	mov    %eax,%ebx
  800c0b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c0e:	eb 06                	jmp    800c16 <strncmp+0x17>
		n--, p++, q++;
  800c10:	83 c0 01             	add    $0x1,%eax
  800c13:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c16:	39 d8                	cmp    %ebx,%eax
  800c18:	74 16                	je     800c30 <strncmp+0x31>
  800c1a:	0f b6 08             	movzbl (%eax),%ecx
  800c1d:	84 c9                	test   %cl,%cl
  800c1f:	74 04                	je     800c25 <strncmp+0x26>
  800c21:	3a 0a                	cmp    (%edx),%cl
  800c23:	74 eb                	je     800c10 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c25:	0f b6 00             	movzbl (%eax),%eax
  800c28:	0f b6 12             	movzbl (%edx),%edx
  800c2b:	29 d0                	sub    %edx,%eax
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
		return 0;
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
  800c35:	eb f6                	jmp    800c2d <strncmp+0x2e>

00800c37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c41:	0f b6 10             	movzbl (%eax),%edx
  800c44:	84 d2                	test   %dl,%dl
  800c46:	74 09                	je     800c51 <strchr+0x1a>
		if (*s == c)
  800c48:	38 ca                	cmp    %cl,%dl
  800c4a:	74 0a                	je     800c56 <strchr+0x1f>
	for (; *s; s++)
  800c4c:	83 c0 01             	add    $0x1,%eax
  800c4f:	eb f0                	jmp    800c41 <strchr+0xa>
			return (char *) s;
	return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c62:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c65:	38 ca                	cmp    %cl,%dl
  800c67:	74 09                	je     800c72 <strfind+0x1a>
  800c69:	84 d2                	test   %dl,%dl
  800c6b:	74 05                	je     800c72 <strfind+0x1a>
	for (; *s; s++)
  800c6d:	83 c0 01             	add    $0x1,%eax
  800c70:	eb f0                	jmp    800c62 <strfind+0xa>
			break;
	return (char *) s;
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c80:	85 c9                	test   %ecx,%ecx
  800c82:	74 31                	je     800cb5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c84:	89 f8                	mov    %edi,%eax
  800c86:	09 c8                	or     %ecx,%eax
  800c88:	a8 03                	test   $0x3,%al
  800c8a:	75 23                	jne    800caf <memset+0x3b>
		c &= 0xFF;
  800c8c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	c1 e3 08             	shl    $0x8,%ebx
  800c95:	89 d0                	mov    %edx,%eax
  800c97:	c1 e0 18             	shl    $0x18,%eax
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	c1 e6 10             	shl    $0x10,%esi
  800c9f:	09 f0                	or     %esi,%eax
  800ca1:	09 c2                	or     %eax,%edx
  800ca3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ca5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ca8:	89 d0                	mov    %edx,%eax
  800caa:	fc                   	cld    
  800cab:	f3 ab                	rep stos %eax,%es:(%edi)
  800cad:	eb 06                	jmp    800cb5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	fc                   	cld    
  800cb3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb5:	89 f8                	mov    %edi,%eax
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cca:	39 c6                	cmp    %eax,%esi
  800ccc:	73 32                	jae    800d00 <memmove+0x44>
  800cce:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cd1:	39 c2                	cmp    %eax,%edx
  800cd3:	76 2b                	jbe    800d00 <memmove+0x44>
		s += n;
		d += n;
  800cd5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd8:	89 fe                	mov    %edi,%esi
  800cda:	09 ce                	or     %ecx,%esi
  800cdc:	09 d6                	or     %edx,%esi
  800cde:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce4:	75 0e                	jne    800cf4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ce6:	83 ef 04             	sub    $0x4,%edi
  800ce9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cef:	fd                   	std    
  800cf0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf2:	eb 09                	jmp    800cfd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cf4:	83 ef 01             	sub    $0x1,%edi
  800cf7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cfa:	fd                   	std    
  800cfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cfd:	fc                   	cld    
  800cfe:	eb 1a                	jmp    800d1a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	09 ca                	or     %ecx,%edx
  800d04:	09 f2                	or     %esi,%edx
  800d06:	f6 c2 03             	test   $0x3,%dl
  800d09:	75 0a                	jne    800d15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d0e:	89 c7                	mov    %eax,%edi
  800d10:	fc                   	cld    
  800d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d13:	eb 05                	jmp    800d1a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d15:	89 c7                	mov    %eax,%edi
  800d17:	fc                   	cld    
  800d18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d24:	ff 75 10             	pushl  0x10(%ebp)
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	ff 75 08             	pushl  0x8(%ebp)
  800d2d:	e8 8a ff ff ff       	call   800cbc <memmove>
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	89 c6                	mov    %eax,%esi
  800d41:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d44:	39 f0                	cmp    %esi,%eax
  800d46:	74 1c                	je     800d64 <memcmp+0x30>
		if (*s1 != *s2)
  800d48:	0f b6 08             	movzbl (%eax),%ecx
  800d4b:	0f b6 1a             	movzbl (%edx),%ebx
  800d4e:	38 d9                	cmp    %bl,%cl
  800d50:	75 08                	jne    800d5a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d52:	83 c0 01             	add    $0x1,%eax
  800d55:	83 c2 01             	add    $0x1,%edx
  800d58:	eb ea                	jmp    800d44 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d5a:	0f b6 c1             	movzbl %cl,%eax
  800d5d:	0f b6 db             	movzbl %bl,%ebx
  800d60:	29 d8                	sub    %ebx,%eax
  800d62:	eb 05                	jmp    800d69 <memcmp+0x35>
	}

	return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d76:	89 c2                	mov    %eax,%edx
  800d78:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d7b:	39 d0                	cmp    %edx,%eax
  800d7d:	73 09                	jae    800d88 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d7f:	38 08                	cmp    %cl,(%eax)
  800d81:	74 05                	je     800d88 <memfind+0x1b>
	for (; s < ends; s++)
  800d83:	83 c0 01             	add    $0x1,%eax
  800d86:	eb f3                	jmp    800d7b <memfind+0xe>
			break;
	return (void *) s;
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d96:	eb 03                	jmp    800d9b <strtol+0x11>
		s++;
  800d98:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d9b:	0f b6 01             	movzbl (%ecx),%eax
  800d9e:	3c 20                	cmp    $0x20,%al
  800da0:	74 f6                	je     800d98 <strtol+0xe>
  800da2:	3c 09                	cmp    $0x9,%al
  800da4:	74 f2                	je     800d98 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800da6:	3c 2b                	cmp    $0x2b,%al
  800da8:	74 2a                	je     800dd4 <strtol+0x4a>
	int neg = 0;
  800daa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800daf:	3c 2d                	cmp    $0x2d,%al
  800db1:	74 2b                	je     800dde <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800db9:	75 0f                	jne    800dca <strtol+0x40>
  800dbb:	80 39 30             	cmpb   $0x30,(%ecx)
  800dbe:	74 28                	je     800de8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc0:	85 db                	test   %ebx,%ebx
  800dc2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc7:	0f 44 d8             	cmove  %eax,%ebx
  800dca:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd2:	eb 50                	jmp    800e24 <strtol+0x9a>
		s++;
  800dd4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dd7:	bf 00 00 00 00       	mov    $0x0,%edi
  800ddc:	eb d5                	jmp    800db3 <strtol+0x29>
		s++, neg = 1;
  800dde:	83 c1 01             	add    $0x1,%ecx
  800de1:	bf 01 00 00 00       	mov    $0x1,%edi
  800de6:	eb cb                	jmp    800db3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dec:	74 0e                	je     800dfc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dee:	85 db                	test   %ebx,%ebx
  800df0:	75 d8                	jne    800dca <strtol+0x40>
		s++, base = 8;
  800df2:	83 c1 01             	add    $0x1,%ecx
  800df5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dfa:	eb ce                	jmp    800dca <strtol+0x40>
		s += 2, base = 16;
  800dfc:	83 c1 02             	add    $0x2,%ecx
  800dff:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e04:	eb c4                	jmp    800dca <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e06:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e09:	89 f3                	mov    %esi,%ebx
  800e0b:	80 fb 19             	cmp    $0x19,%bl
  800e0e:	77 29                	ja     800e39 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e10:	0f be d2             	movsbl %dl,%edx
  800e13:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e16:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e19:	7d 30                	jge    800e4b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e1b:	83 c1 01             	add    $0x1,%ecx
  800e1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e22:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e24:	0f b6 11             	movzbl (%ecx),%edx
  800e27:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e2a:	89 f3                	mov    %esi,%ebx
  800e2c:	80 fb 09             	cmp    $0x9,%bl
  800e2f:	77 d5                	ja     800e06 <strtol+0x7c>
			dig = *s - '0';
  800e31:	0f be d2             	movsbl %dl,%edx
  800e34:	83 ea 30             	sub    $0x30,%edx
  800e37:	eb dd                	jmp    800e16 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e3c:	89 f3                	mov    %esi,%ebx
  800e3e:	80 fb 19             	cmp    $0x19,%bl
  800e41:	77 08                	ja     800e4b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e43:	0f be d2             	movsbl %dl,%edx
  800e46:	83 ea 37             	sub    $0x37,%edx
  800e49:	eb cb                	jmp    800e16 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4f:	74 05                	je     800e56 <strtol+0xcc>
		*endptr = (char *) s;
  800e51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e56:	89 c2                	mov    %eax,%edx
  800e58:	f7 da                	neg    %edx
  800e5a:	85 ff                	test   %edi,%edi
  800e5c:	0f 45 c2             	cmovne %edx,%eax
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	89 c3                	mov    %eax,%ebx
  800e77:	89 c7                	mov    %eax,%edi
  800e79:	89 c6                	mov    %eax,%esi
  800e7b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e92:	89 d1                	mov    %edx,%ecx
  800e94:	89 d3                	mov    %edx,%ebx
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 03                	push   $0x3
  800ed1:	68 48 32 80 00       	push   $0x803248
  800ed6:	6a 43                	push   $0x43
  800ed8:	68 65 32 80 00       	push   $0x803265
  800edd:	e8 f7 f3 ff ff       	call   8002d9 <_panic>

00800ee2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  800eed:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef2:	89 d1                	mov    %edx,%ecx
  800ef4:	89 d3                	mov    %edx,%ebx
  800ef6:	89 d7                	mov    %edx,%edi
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <sys_yield>:

void
sys_yield(void)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f07:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 d3                	mov    %edx,%ebx
  800f15:	89 d7                	mov    %edx,%edi
  800f17:	89 d6                	mov    %edx,%esi
  800f19:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	b8 04 00 00 00       	mov    $0x4,%eax
  800f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3c:	89 f7                	mov    %esi,%edi
  800f3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	7f 08                	jg     800f4c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 04                	push   $0x4
  800f52:	68 48 32 80 00       	push   $0x803248
  800f57:	6a 43                	push   $0x43
  800f59:	68 65 32 80 00       	push   $0x803265
  800f5e:	e8 76 f3 ff ff       	call   8002d9 <_panic>

00800f63 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 05 00 00 00       	mov    $0x5,%eax
  800f77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7d:	8b 75 18             	mov    0x18(%ebp),%esi
  800f80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7f 08                	jg     800f8e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	50                   	push   %eax
  800f92:	6a 05                	push   $0x5
  800f94:	68 48 32 80 00       	push   $0x803248
  800f99:	6a 43                	push   $0x43
  800f9b:	68 65 32 80 00       	push   $0x803265
  800fa0:	e8 34 f3 ff ff       	call   8002d9 <_panic>

00800fa5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
  800fab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	b8 06 00 00 00       	mov    $0x6,%eax
  800fbe:	89 df                	mov    %ebx,%edi
  800fc0:	89 de                	mov    %ebx,%esi
  800fc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	7f 08                	jg     800fd0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	50                   	push   %eax
  800fd4:	6a 06                	push   $0x6
  800fd6:	68 48 32 80 00       	push   $0x803248
  800fdb:	6a 43                	push   $0x43
  800fdd:	68 65 32 80 00       	push   $0x803265
  800fe2:	e8 f2 f2 ff ff       	call   8002d9 <_panic>

00800fe7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 08 00 00 00       	mov    $0x8,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	if(check && ret > 0)
  801006:	85 c0                	test   %eax,%eax
  801008:	7f 08                	jg     801012 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80100a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	50                   	push   %eax
  801016:	6a 08                	push   $0x8
  801018:	68 48 32 80 00       	push   $0x803248
  80101d:	6a 43                	push   $0x43
  80101f:	68 65 32 80 00       	push   $0x803265
  801024:	e8 b0 f2 ff ff       	call   8002d9 <_panic>

00801029 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	57                   	push   %edi
  80102d:	56                   	push   %esi
  80102e:	53                   	push   %ebx
  80102f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	b8 09 00 00 00       	mov    $0x9,%eax
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
	if(check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7f 08                	jg     801054 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	50                   	push   %eax
  801058:	6a 09                	push   $0x9
  80105a:	68 48 32 80 00       	push   $0x803248
  80105f:	6a 43                	push   $0x43
  801061:	68 65 32 80 00       	push   $0x803265
  801066:	e8 6e f2 ff ff       	call   8002d9 <_panic>

0080106b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801084:	89 df                	mov    %ebx,%edi
  801086:	89 de                	mov    %ebx,%esi
  801088:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	7f 08                	jg     801096 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	50                   	push   %eax
  80109a:	6a 0a                	push   $0xa
  80109c:	68 48 32 80 00       	push   $0x803248
  8010a1:	6a 43                	push   $0x43
  8010a3:	68 65 32 80 00       	push   $0x803265
  8010a8:	e8 2c f2 ff ff       	call   8002d9 <_panic>

008010ad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010be:	be 00 00 00 00       	mov    $0x0,%esi
  8010c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e6:	89 cb                	mov    %ecx,%ebx
  8010e8:	89 cf                	mov    %ecx,%edi
  8010ea:	89 ce                	mov    %ecx,%esi
  8010ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	7f 08                	jg     8010fa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	50                   	push   %eax
  8010fe:	6a 0d                	push   $0xd
  801100:	68 48 32 80 00       	push   $0x803248
  801105:	6a 43                	push   $0x43
  801107:	68 65 32 80 00       	push   $0x803265
  80110c:	e8 c8 f1 ff ff       	call   8002d9 <_panic>

00801111 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	57                   	push   %edi
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
	asm volatile("int %1\n"
  801117:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801122:	b8 0e 00 00 00       	mov    $0xe,%eax
  801127:	89 df                	mov    %ebx,%edi
  801129:	89 de                	mov    %ebx,%esi
  80112b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
	asm volatile("int %1\n"
  801138:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	b8 0f 00 00 00       	mov    $0xf,%eax
  801145:	89 cb                	mov    %ecx,%ebx
  801147:	89 cf                	mov    %ecx,%edi
  801149:	89 ce                	mov    %ecx,%esi
  80114b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80114d:	5b                   	pop    %ebx
  80114e:	5e                   	pop    %esi
  80114f:	5f                   	pop    %edi
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
	asm volatile("int %1\n"
  801158:	ba 00 00 00 00       	mov    $0x0,%edx
  80115d:	b8 10 00 00 00       	mov    $0x10,%eax
  801162:	89 d1                	mov    %edx,%ecx
  801164:	89 d3                	mov    %edx,%ebx
  801166:	89 d7                	mov    %edx,%edi
  801168:	89 d6                	mov    %edx,%esi
  80116a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
	asm volatile("int %1\n"
  801177:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801182:	b8 11 00 00 00       	mov    $0x11,%eax
  801187:	89 df                	mov    %ebx,%edi
  801189:	89 de                	mov    %ebx,%esi
  80118b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
	asm volatile("int %1\n"
  801198:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119d:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a3:	b8 12 00 00 00       	mov    $0x12,%eax
  8011a8:	89 df                	mov    %ebx,%edi
  8011aa:	89 de                	mov    %ebx,%esi
  8011ac:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011ae:	5b                   	pop    %ebx
  8011af:	5e                   	pop    %esi
  8011b0:	5f                   	pop    %edi
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	57                   	push   %edi
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c7:	b8 13 00 00 00       	mov    $0x13,%eax
  8011cc:	89 df                	mov    %ebx,%edi
  8011ce:	89 de                	mov    %ebx,%esi
  8011d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	7f 08                	jg     8011de <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	50                   	push   %eax
  8011e2:	6a 13                	push   $0x13
  8011e4:	68 48 32 80 00       	push   $0x803248
  8011e9:	6a 43                	push   $0x43
  8011eb:	68 65 32 80 00       	push   $0x803265
  8011f0:	e8 e4 f0 ff ff       	call   8002d9 <_panic>

008011f5 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	57                   	push   %edi
  8011f9:	56                   	push   %esi
  8011fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801200:	8b 55 08             	mov    0x8(%ebp),%edx
  801203:	b8 14 00 00 00       	mov    $0x14,%eax
  801208:	89 cb                	mov    %ecx,%ebx
  80120a:	89 cf                	mov    %ecx,%edi
  80120c:	89 ce                	mov    %ecx,%esi
  80120e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	53                   	push   %ebx
  801219:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80121c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801223:	f6 c5 04             	test   $0x4,%ch
  801226:	75 45                	jne    80126d <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801228:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80122f:	83 e1 07             	and    $0x7,%ecx
  801232:	83 f9 07             	cmp    $0x7,%ecx
  801235:	74 6f                	je     8012a6 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801237:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80123e:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801244:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80124a:	0f 84 b6 00 00 00    	je     801306 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801250:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801257:	83 e1 05             	and    $0x5,%ecx
  80125a:	83 f9 05             	cmp    $0x5,%ecx
  80125d:	0f 84 d7 00 00 00    	je     80133a <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
  801268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80126d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801274:	c1 e2 0c             	shl    $0xc,%edx
  801277:	83 ec 0c             	sub    $0xc,%esp
  80127a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801280:	51                   	push   %ecx
  801281:	52                   	push   %edx
  801282:	50                   	push   %eax
  801283:	52                   	push   %edx
  801284:	6a 00                	push   $0x0
  801286:	e8 d8 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0)
  80128b:	83 c4 20             	add    $0x20,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	79 d1                	jns    801263 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	68 73 32 80 00       	push   $0x803273
  80129a:	6a 54                	push   $0x54
  80129c:	68 89 32 80 00       	push   $0x803289
  8012a1:	e8 33 f0 ff ff       	call   8002d9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012a6:	89 d3                	mov    %edx,%ebx
  8012a8:	c1 e3 0c             	shl    $0xc,%ebx
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	68 05 08 00 00       	push   $0x805
  8012b3:	53                   	push   %ebx
  8012b4:	50                   	push   %eax
  8012b5:	53                   	push   %ebx
  8012b6:	6a 00                	push   $0x0
  8012b8:	e8 a6 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0)
  8012bd:	83 c4 20             	add    $0x20,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 2e                	js     8012f2 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	68 05 08 00 00       	push   $0x805
  8012cc:	53                   	push   %ebx
  8012cd:	6a 00                	push   $0x0
  8012cf:	53                   	push   %ebx
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 8c fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0)
  8012d7:	83 c4 20             	add    $0x20,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	79 85                	jns    801263 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	68 73 32 80 00       	push   $0x803273
  8012e6:	6a 5f                	push   $0x5f
  8012e8:	68 89 32 80 00       	push   $0x803289
  8012ed:	e8 e7 ef ff ff       	call   8002d9 <_panic>
			panic("sys_page_map() panic\n");
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	68 73 32 80 00       	push   $0x803273
  8012fa:	6a 5b                	push   $0x5b
  8012fc:	68 89 32 80 00       	push   $0x803289
  801301:	e8 d3 ef ff ff       	call   8002d9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801306:	c1 e2 0c             	shl    $0xc,%edx
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	68 05 08 00 00       	push   $0x805
  801311:	52                   	push   %edx
  801312:	50                   	push   %eax
  801313:	52                   	push   %edx
  801314:	6a 00                	push   $0x0
  801316:	e8 48 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0)
  80131b:	83 c4 20             	add    $0x20,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	0f 89 3d ff ff ff    	jns    801263 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	68 73 32 80 00       	push   $0x803273
  80132e:	6a 66                	push   $0x66
  801330:	68 89 32 80 00       	push   $0x803289
  801335:	e8 9f ef ff ff       	call   8002d9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80133a:	c1 e2 0c             	shl    $0xc,%edx
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	6a 05                	push   $0x5
  801342:	52                   	push   %edx
  801343:	50                   	push   %eax
  801344:	52                   	push   %edx
  801345:	6a 00                	push   $0x0
  801347:	e8 17 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0)
  80134c:	83 c4 20             	add    $0x20,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	0f 89 0c ff ff ff    	jns    801263 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 73 32 80 00       	push   $0x803273
  80135f:	6a 6d                	push   $0x6d
  801361:	68 89 32 80 00       	push   $0x803289
  801366:	e8 6e ef ff ff       	call   8002d9 <_panic>

0080136b <pgfault>:
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	53                   	push   %ebx
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801375:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801377:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80137b:	0f 84 99 00 00 00    	je     80141a <pgfault+0xaf>
  801381:	89 c2                	mov    %eax,%edx
  801383:	c1 ea 16             	shr    $0x16,%edx
  801386:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138d:	f6 c2 01             	test   $0x1,%dl
  801390:	0f 84 84 00 00 00    	je     80141a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801396:	89 c2                	mov    %eax,%edx
  801398:	c1 ea 0c             	shr    $0xc,%edx
  80139b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a2:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013a8:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013ae:	75 6a                	jne    80141a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b5:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	6a 07                	push   $0x7
  8013bc:	68 00 f0 7f 00       	push   $0x7ff000
  8013c1:	6a 00                	push   $0x0
  8013c3:	e8 58 fb ff ff       	call   800f20 <sys_page_alloc>
	if(ret < 0)
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 5f                	js     80142e <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	68 00 10 00 00       	push   $0x1000
  8013d7:	53                   	push   %ebx
  8013d8:	68 00 f0 7f 00       	push   $0x7ff000
  8013dd:	e8 3c f9 ff ff       	call   800d1e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013e2:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013e9:	53                   	push   %ebx
  8013ea:	6a 00                	push   $0x0
  8013ec:	68 00 f0 7f 00       	push   $0x7ff000
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 6b fb ff ff       	call   800f63 <sys_page_map>
	if(ret < 0)
  8013f8:	83 c4 20             	add    $0x20,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 43                	js     801442 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	68 00 f0 7f 00       	push   $0x7ff000
  801407:	6a 00                	push   $0x0
  801409:	e8 97 fb ff ff       	call   800fa5 <sys_page_unmap>
	if(ret < 0)
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 41                	js     801456 <pgfault+0xeb>
}
  801415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801418:	c9                   	leave  
  801419:	c3                   	ret    
		panic("panic at pgfault()\n");
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	68 94 32 80 00       	push   $0x803294
  801422:	6a 26                	push   $0x26
  801424:	68 89 32 80 00       	push   $0x803289
  801429:	e8 ab ee ff ff       	call   8002d9 <_panic>
		panic("panic in sys_page_alloc()\n");
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 a8 32 80 00       	push   $0x8032a8
  801436:	6a 31                	push   $0x31
  801438:	68 89 32 80 00       	push   $0x803289
  80143d:	e8 97 ee ff ff       	call   8002d9 <_panic>
		panic("panic in sys_page_map()\n");
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	68 c3 32 80 00       	push   $0x8032c3
  80144a:	6a 36                	push   $0x36
  80144c:	68 89 32 80 00       	push   $0x803289
  801451:	e8 83 ee ff ff       	call   8002d9 <_panic>
		panic("panic in sys_page_unmap()\n");
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 dc 32 80 00       	push   $0x8032dc
  80145e:	6a 39                	push   $0x39
  801460:	68 89 32 80 00       	push   $0x803289
  801465:	e8 6f ee ff ff       	call   8002d9 <_panic>

0080146a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	57                   	push   %edi
  80146e:	56                   	push   %esi
  80146f:	53                   	push   %ebx
  801470:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801473:	68 6b 13 80 00       	push   $0x80136b
  801478:	e8 2d 14 00 00       	call   8028aa <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80147d:	b8 07 00 00 00       	mov    $0x7,%eax
  801482:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 2a                	js     8014b5 <fork+0x4b>
  80148b:	89 c6                	mov    %eax,%esi
  80148d:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80148f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801494:	75 4b                	jne    8014e1 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801496:	e8 47 fa ff ff       	call   800ee2 <sys_getenvid>
  80149b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014a0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014ab:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8014b0:	e9 90 00 00 00       	jmp    801545 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	68 f8 32 80 00       	push   $0x8032f8
  8014bd:	68 8c 00 00 00       	push   $0x8c
  8014c2:	68 89 32 80 00       	push   $0x803289
  8014c7:	e8 0d ee ff ff       	call   8002d9 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014cc:	89 f8                	mov    %edi,%eax
  8014ce:	e8 42 fd ff ff       	call   801215 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014d3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014df:	74 26                	je     801507 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014e1:	89 d8                	mov    %ebx,%eax
  8014e3:	c1 e8 16             	shr    $0x16,%eax
  8014e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ed:	a8 01                	test   $0x1,%al
  8014ef:	74 e2                	je     8014d3 <fork+0x69>
  8014f1:	89 da                	mov    %ebx,%edx
  8014f3:	c1 ea 0c             	shr    $0xc,%edx
  8014f6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014fd:	83 e0 05             	and    $0x5,%eax
  801500:	83 f8 05             	cmp    $0x5,%eax
  801503:	75 ce                	jne    8014d3 <fork+0x69>
  801505:	eb c5                	jmp    8014cc <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	6a 07                	push   $0x7
  80150c:	68 00 f0 bf ee       	push   $0xeebff000
  801511:	56                   	push   %esi
  801512:	e8 09 fa ff ff       	call   800f20 <sys_page_alloc>
	if(ret < 0)
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 31                	js     80154f <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	68 19 29 80 00       	push   $0x802919
  801526:	56                   	push   %esi
  801527:	e8 3f fb ff ff       	call   80106b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 33                	js     801566 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	6a 02                	push   $0x2
  801538:	56                   	push   %esi
  801539:	e8 a9 fa ff ff       	call   800fe7 <sys_env_set_status>
	if(ret < 0)
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 38                	js     80157d <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801545:	89 f0                	mov    %esi,%eax
  801547:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5f                   	pop    %edi
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	68 a8 32 80 00       	push   $0x8032a8
  801557:	68 98 00 00 00       	push   $0x98
  80155c:	68 89 32 80 00       	push   $0x803289
  801561:	e8 73 ed ff ff       	call   8002d9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	68 1c 33 80 00       	push   $0x80331c
  80156e:	68 9b 00 00 00       	push   $0x9b
  801573:	68 89 32 80 00       	push   $0x803289
  801578:	e8 5c ed ff ff       	call   8002d9 <_panic>
		panic("panic in sys_env_set_status()\n");
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	68 44 33 80 00       	push   $0x803344
  801585:	68 9e 00 00 00       	push   $0x9e
  80158a:	68 89 32 80 00       	push   $0x803289
  80158f:	e8 45 ed ff ff       	call   8002d9 <_panic>

00801594 <sfork>:

// Challenge!
int
sfork(void)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	57                   	push   %edi
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80159d:	68 6b 13 80 00       	push   $0x80136b
  8015a2:	e8 03 13 00 00       	call   8028aa <set_pgfault_handler>
  8015a7:	b8 07 00 00 00       	mov    $0x7,%eax
  8015ac:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 2a                	js     8015df <sfork+0x4b>
  8015b5:	89 c7                	mov    %eax,%edi
  8015b7:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015b9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015be:	75 58                	jne    801618 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015c0:	e8 1d f9 ff ff       	call   800ee2 <sys_getenvid>
  8015c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015ca:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015d5:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8015da:	e9 d4 00 00 00       	jmp    8016b3 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 f8 32 80 00       	push   $0x8032f8
  8015e7:	68 af 00 00 00       	push   $0xaf
  8015ec:	68 89 32 80 00       	push   $0x803289
  8015f1:	e8 e3 ec ff ff       	call   8002d9 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015f6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015fb:	89 f0                	mov    %esi,%eax
  8015fd:	e8 13 fc ff ff       	call   801215 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801602:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801608:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80160e:	77 65                	ja     801675 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801610:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801616:	74 de                	je     8015f6 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801618:	89 d8                	mov    %ebx,%eax
  80161a:	c1 e8 16             	shr    $0x16,%eax
  80161d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801624:	a8 01                	test   $0x1,%al
  801626:	74 da                	je     801602 <sfork+0x6e>
  801628:	89 da                	mov    %ebx,%edx
  80162a:	c1 ea 0c             	shr    $0xc,%edx
  80162d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801634:	83 e0 05             	and    $0x5,%eax
  801637:	83 f8 05             	cmp    $0x5,%eax
  80163a:	75 c6                	jne    801602 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80163c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801643:	c1 e2 0c             	shl    $0xc,%edx
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	83 e0 07             	and    $0x7,%eax
  80164c:	50                   	push   %eax
  80164d:	52                   	push   %edx
  80164e:	56                   	push   %esi
  80164f:	52                   	push   %edx
  801650:	6a 00                	push   $0x0
  801652:	e8 0c f9 ff ff       	call   800f63 <sys_page_map>
  801657:	83 c4 20             	add    $0x20,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	74 a4                	je     801602 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 73 32 80 00       	push   $0x803273
  801666:	68 ba 00 00 00       	push   $0xba
  80166b:	68 89 32 80 00       	push   $0x803289
  801670:	e8 64 ec ff ff       	call   8002d9 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	6a 07                	push   $0x7
  80167a:	68 00 f0 bf ee       	push   $0xeebff000
  80167f:	57                   	push   %edi
  801680:	e8 9b f8 ff ff       	call   800f20 <sys_page_alloc>
	if(ret < 0)
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	78 31                	js     8016bd <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	68 19 29 80 00       	push   $0x802919
  801694:	57                   	push   %edi
  801695:	e8 d1 f9 ff ff       	call   80106b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 33                	js     8016d4 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	6a 02                	push   $0x2
  8016a6:	57                   	push   %edi
  8016a7:	e8 3b f9 ff ff       	call   800fe7 <sys_env_set_status>
	if(ret < 0)
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 38                	js     8016eb <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016b3:	89 f8                	mov    %edi,%eax
  8016b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b8:	5b                   	pop    %ebx
  8016b9:	5e                   	pop    %esi
  8016ba:	5f                   	pop    %edi
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 a8 32 80 00       	push   $0x8032a8
  8016c5:	68 c0 00 00 00       	push   $0xc0
  8016ca:	68 89 32 80 00       	push   $0x803289
  8016cf:	e8 05 ec ff ff       	call   8002d9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 1c 33 80 00       	push   $0x80331c
  8016dc:	68 c3 00 00 00       	push   $0xc3
  8016e1:	68 89 32 80 00       	push   $0x803289
  8016e6:	e8 ee eb ff ff       	call   8002d9 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	68 44 33 80 00       	push   $0x803344
  8016f3:	68 c6 00 00 00       	push   $0xc6
  8016f8:	68 89 32 80 00       	push   $0x803289
  8016fd:	e8 d7 eb ff ff       	call   8002d9 <_panic>

00801702 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	05 00 00 00 30       	add    $0x30000000,%eax
  80170d:	c1 e8 0c             	shr    $0xc,%eax
}
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    

00801712 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80171d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801722:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801731:	89 c2                	mov    %eax,%edx
  801733:	c1 ea 16             	shr    $0x16,%edx
  801736:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80173d:	f6 c2 01             	test   $0x1,%dl
  801740:	74 2d                	je     80176f <fd_alloc+0x46>
  801742:	89 c2                	mov    %eax,%edx
  801744:	c1 ea 0c             	shr    $0xc,%edx
  801747:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174e:	f6 c2 01             	test   $0x1,%dl
  801751:	74 1c                	je     80176f <fd_alloc+0x46>
  801753:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801758:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80175d:	75 d2                	jne    801731 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801768:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80176d:	eb 0a                	jmp    801779 <fd_alloc+0x50>
			*fd_store = fd;
  80176f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801772:	89 01                	mov    %eax,(%ecx)
			return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801781:	83 f8 1f             	cmp    $0x1f,%eax
  801784:	77 30                	ja     8017b6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801786:	c1 e0 0c             	shl    $0xc,%eax
  801789:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80178e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801794:	f6 c2 01             	test   $0x1,%dl
  801797:	74 24                	je     8017bd <fd_lookup+0x42>
  801799:	89 c2                	mov    %eax,%edx
  80179b:	c1 ea 0c             	shr    $0xc,%edx
  80179e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a5:	f6 c2 01             	test   $0x1,%dl
  8017a8:	74 1a                	je     8017c4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	89 02                	mov    %eax,(%edx)
	return 0;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    
		return -E_INVAL;
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bb:	eb f7                	jmp    8017b4 <fd_lookup+0x39>
		return -E_INVAL;
  8017bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c2:	eb f0                	jmp    8017b4 <fd_lookup+0x39>
  8017c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c9:	eb e9                	jmp    8017b4 <fd_lookup+0x39>

008017cb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017de:	39 08                	cmp    %ecx,(%eax)
  8017e0:	74 38                	je     80181a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017e2:	83 c2 01             	add    $0x1,%edx
  8017e5:	8b 04 95 e0 33 80 00 	mov    0x8033e0(,%edx,4),%eax
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 ee                	jne    8017de <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017f0:	a1 20 54 80 00       	mov    0x805420,%eax
  8017f5:	8b 40 48             	mov    0x48(%eax),%eax
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	51                   	push   %ecx
  8017fc:	50                   	push   %eax
  8017fd:	68 64 33 80 00       	push   $0x803364
  801802:	e8 c8 eb ff ff       	call   8003cf <cprintf>
	*dev = 0;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    
			*dev = devtab[i];
  80181a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb f2                	jmp    801818 <dev_lookup+0x4d>

00801826 <fd_close>:
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 24             	sub    $0x24,%esp
  80182f:	8b 75 08             	mov    0x8(%ebp),%esi
  801832:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801835:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801838:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801839:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80183f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801842:	50                   	push   %eax
  801843:	e8 33 ff ff ff       	call   80177b <fd_lookup>
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 05                	js     801856 <fd_close+0x30>
	    || fd != fd2)
  801851:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801854:	74 16                	je     80186c <fd_close+0x46>
		return (must_exist ? r : 0);
  801856:	89 f8                	mov    %edi,%eax
  801858:	84 c0                	test   %al,%al
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	0f 44 d8             	cmove  %eax,%ebx
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801872:	50                   	push   %eax
  801873:	ff 36                	pushl  (%esi)
  801875:	e8 51 ff ff ff       	call   8017cb <dev_lookup>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 1a                	js     80189d <fd_close+0x77>
		if (dev->dev_close)
  801883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801886:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801889:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80188e:	85 c0                	test   %eax,%eax
  801890:	74 0b                	je     80189d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	56                   	push   %esi
  801896:	ff d0                	call   *%eax
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	56                   	push   %esi
  8018a1:	6a 00                	push   $0x0
  8018a3:	e8 fd f6 ff ff       	call   800fa5 <sys_page_unmap>
	return r;
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb b5                	jmp    801862 <fd_close+0x3c>

008018ad <close>:

int
close(int fdnum)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b6:	50                   	push   %eax
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	e8 bc fe ff ff       	call   80177b <fd_lookup>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	79 02                	jns    8018c8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    
		return fd_close(fd, 1);
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	6a 01                	push   $0x1
  8018cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d0:	e8 51 ff ff ff       	call   801826 <fd_close>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	eb ec                	jmp    8018c6 <close+0x19>

008018da <close_all>:

void
close_all(void)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	53                   	push   %ebx
  8018ea:	e8 be ff ff ff       	call   8018ad <close>
	for (i = 0; i < MAXFD; i++)
  8018ef:	83 c3 01             	add    $0x1,%ebx
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	83 fb 20             	cmp    $0x20,%ebx
  8018f8:	75 ec                	jne    8018e6 <close_all+0xc>
}
  8018fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	57                   	push   %edi
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801908:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80190b:	50                   	push   %eax
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	e8 67 fe ff ff       	call   80177b <fd_lookup>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	0f 88 81 00 00 00    	js     8019a2 <dup+0xa3>
		return r;
	close(newfdnum);
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	e8 81 ff ff ff       	call   8018ad <close>

	newfd = INDEX2FD(newfdnum);
  80192c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80192f:	c1 e6 0c             	shl    $0xc,%esi
  801932:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801938:	83 c4 04             	add    $0x4,%esp
  80193b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193e:	e8 cf fd ff ff       	call   801712 <fd2data>
  801943:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801945:	89 34 24             	mov    %esi,(%esp)
  801948:	e8 c5 fd ff ff       	call   801712 <fd2data>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801952:	89 d8                	mov    %ebx,%eax
  801954:	c1 e8 16             	shr    $0x16,%eax
  801957:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80195e:	a8 01                	test   $0x1,%al
  801960:	74 11                	je     801973 <dup+0x74>
  801962:	89 d8                	mov    %ebx,%eax
  801964:	c1 e8 0c             	shr    $0xc,%eax
  801967:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80196e:	f6 c2 01             	test   $0x1,%dl
  801971:	75 39                	jne    8019ac <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801973:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	c1 e8 0c             	shr    $0xc,%eax
  80197b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	25 07 0e 00 00       	and    $0xe07,%eax
  80198a:	50                   	push   %eax
  80198b:	56                   	push   %esi
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	6a 00                	push   $0x0
  801991:	e8 cd f5 ff ff       	call   800f63 <sys_page_map>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	83 c4 20             	add    $0x20,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 31                	js     8019d0 <dup+0xd1>
		goto err;

	return newfdnum;
  80199f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019a2:	89 d8                	mov    %ebx,%eax
  8019a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a7:	5b                   	pop    %ebx
  8019a8:	5e                   	pop    %esi
  8019a9:	5f                   	pop    %edi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8019bb:	50                   	push   %eax
  8019bc:	57                   	push   %edi
  8019bd:	6a 00                	push   $0x0
  8019bf:	53                   	push   %ebx
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 9c f5 ff ff       	call   800f63 <sys_page_map>
  8019c7:	89 c3                	mov    %eax,%ebx
  8019c9:	83 c4 20             	add    $0x20,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	79 a3                	jns    801973 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	56                   	push   %esi
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 ca f5 ff ff       	call   800fa5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019db:	83 c4 08             	add    $0x8,%esp
  8019de:	57                   	push   %edi
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 bf f5 ff ff       	call   800fa5 <sys_page_unmap>
	return r;
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	eb b7                	jmp    8019a2 <dup+0xa3>

008019eb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 1c             	sub    $0x1c,%esp
  8019f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	53                   	push   %ebx
  8019fa:	e8 7c fd ff ff       	call   80177b <fd_lookup>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 3f                	js     801a45 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	50                   	push   %eax
  801a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a10:	ff 30                	pushl  (%eax)
  801a12:	e8 b4 fd ff ff       	call   8017cb <dev_lookup>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 27                	js     801a45 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a21:	8b 42 08             	mov    0x8(%edx),%eax
  801a24:	83 e0 03             	and    $0x3,%eax
  801a27:	83 f8 01             	cmp    $0x1,%eax
  801a2a:	74 1e                	je     801a4a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	8b 40 08             	mov    0x8(%eax),%eax
  801a32:	85 c0                	test   %eax,%eax
  801a34:	74 35                	je     801a6b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	52                   	push   %edx
  801a40:	ff d0                	call   *%eax
  801a42:	83 c4 10             	add    $0x10,%esp
}
  801a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a4a:	a1 20 54 80 00       	mov    0x805420,%eax
  801a4f:	8b 40 48             	mov    0x48(%eax),%eax
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	53                   	push   %ebx
  801a56:	50                   	push   %eax
  801a57:	68 a5 33 80 00       	push   $0x8033a5
  801a5c:	e8 6e e9 ff ff       	call   8003cf <cprintf>
		return -E_INVAL;
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a69:	eb da                	jmp    801a45 <read+0x5a>
		return -E_NOT_SUPP;
  801a6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a70:	eb d3                	jmp    801a45 <read+0x5a>

00801a72 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a7e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a86:	39 f3                	cmp    %esi,%ebx
  801a88:	73 23                	jae    801aad <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	89 f0                	mov    %esi,%eax
  801a8f:	29 d8                	sub    %ebx,%eax
  801a91:	50                   	push   %eax
  801a92:	89 d8                	mov    %ebx,%eax
  801a94:	03 45 0c             	add    0xc(%ebp),%eax
  801a97:	50                   	push   %eax
  801a98:	57                   	push   %edi
  801a99:	e8 4d ff ff ff       	call   8019eb <read>
		if (m < 0)
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 06                	js     801aab <readn+0x39>
			return m;
		if (m == 0)
  801aa5:	74 06                	je     801aad <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801aa7:	01 c3                	add    %eax,%ebx
  801aa9:	eb db                	jmp    801a86 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aab:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5f                   	pop    %edi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	53                   	push   %ebx
  801abb:	83 ec 1c             	sub    $0x1c,%esp
  801abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac4:	50                   	push   %eax
  801ac5:	53                   	push   %ebx
  801ac6:	e8 b0 fc ff ff       	call   80177b <fd_lookup>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 3a                	js     801b0c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad8:	50                   	push   %eax
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	ff 30                	pushl  (%eax)
  801ade:	e8 e8 fc ff ff       	call   8017cb <dev_lookup>
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 22                	js     801b0c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801af1:	74 1e                	je     801b11 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af6:	8b 52 0c             	mov    0xc(%edx),%edx
  801af9:	85 d2                	test   %edx,%edx
  801afb:	74 35                	je     801b32 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	ff 75 10             	pushl  0x10(%ebp)
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	ff d2                	call   *%edx
  801b09:	83 c4 10             	add    $0x10,%esp
}
  801b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b11:	a1 20 54 80 00       	mov    0x805420,%eax
  801b16:	8b 40 48             	mov    0x48(%eax),%eax
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	53                   	push   %ebx
  801b1d:	50                   	push   %eax
  801b1e:	68 c1 33 80 00       	push   $0x8033c1
  801b23:	e8 a7 e8 ff ff       	call   8003cf <cprintf>
		return -E_INVAL;
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b30:	eb da                	jmp    801b0c <write+0x55>
		return -E_NOT_SUPP;
  801b32:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b37:	eb d3                	jmp    801b0c <write+0x55>

00801b39 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b42:	50                   	push   %eax
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	e8 30 fc ff ff       	call   80177b <fd_lookup>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 0e                	js     801b60 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b58:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	53                   	push   %ebx
  801b66:	83 ec 1c             	sub    $0x1c,%esp
  801b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b6f:	50                   	push   %eax
  801b70:	53                   	push   %ebx
  801b71:	e8 05 fc ff ff       	call   80177b <fd_lookup>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 37                	js     801bb4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b83:	50                   	push   %eax
  801b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b87:	ff 30                	pushl  (%eax)
  801b89:	e8 3d fc ff ff       	call   8017cb <dev_lookup>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 1f                	js     801bb4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b98:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b9c:	74 1b                	je     801bb9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba1:	8b 52 18             	mov    0x18(%edx),%edx
  801ba4:	85 d2                	test   %edx,%edx
  801ba6:	74 32                	je     801bda <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	ff d2                	call   *%edx
  801bb1:	83 c4 10             	add    $0x10,%esp
}
  801bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bb9:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bbe:	8b 40 48             	mov    0x48(%eax),%eax
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	53                   	push   %ebx
  801bc5:	50                   	push   %eax
  801bc6:	68 84 33 80 00       	push   $0x803384
  801bcb:	e8 ff e7 ff ff       	call   8003cf <cprintf>
		return -E_INVAL;
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb da                	jmp    801bb4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bda:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdf:	eb d3                	jmp    801bb4 <ftruncate+0x52>

00801be1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 1c             	sub    $0x1c,%esp
  801be8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801beb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	e8 84 fb ff ff       	call   80177b <fd_lookup>
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 4b                	js     801c49 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c08:	ff 30                	pushl  (%eax)
  801c0a:	e8 bc fb ff ff       	call   8017cb <dev_lookup>
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 33                	js     801c49 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c19:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c1d:	74 2f                	je     801c4e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c22:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c29:	00 00 00 
	stat->st_isdir = 0;
  801c2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c33:	00 00 00 
	stat->st_dev = dev;
  801c36:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	53                   	push   %ebx
  801c40:	ff 75 f0             	pushl  -0x10(%ebp)
  801c43:	ff 50 14             	call   *0x14(%eax)
  801c46:	83 c4 10             	add    $0x10,%esp
}
  801c49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c53:	eb f4                	jmp    801c49 <fstat+0x68>

00801c55 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	56                   	push   %esi
  801c59:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	e8 22 02 00 00       	call   801e89 <open>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 1b                	js     801c8b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	50                   	push   %eax
  801c77:	e8 65 ff ff ff       	call   801be1 <fstat>
  801c7c:	89 c6                	mov    %eax,%esi
	close(fd);
  801c7e:	89 1c 24             	mov    %ebx,(%esp)
  801c81:	e8 27 fc ff ff       	call   8018ad <close>
	return r;
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	89 f3                	mov    %esi,%ebx
}
  801c8b:	89 d8                	mov    %ebx,%eax
  801c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    

00801c94 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	56                   	push   %esi
  801c98:	53                   	push   %ebx
  801c99:	89 c6                	mov    %eax,%esi
  801c9b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c9d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ca4:	74 27                	je     801ccd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ca6:	6a 07                	push   $0x7
  801ca8:	68 00 60 80 00       	push   $0x806000
  801cad:	56                   	push   %esi
  801cae:	ff 35 00 50 80 00    	pushl  0x805000
  801cb4:	e8 ef 0c 00 00       	call   8029a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cb9:	83 c4 0c             	add    $0xc,%esp
  801cbc:	6a 00                	push   $0x0
  801cbe:	53                   	push   %ebx
  801cbf:	6a 00                	push   $0x0
  801cc1:	e8 79 0c 00 00       	call   80293f <ipc_recv>
}
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	6a 01                	push   $0x1
  801cd2:	e8 29 0d 00 00       	call   802a00 <ipc_find_env>
  801cd7:	a3 00 50 80 00       	mov    %eax,0x805000
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	eb c5                	jmp    801ca6 <fsipc+0x12>

00801ce1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ced:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801cff:	b8 02 00 00 00       	mov    $0x2,%eax
  801d04:	e8 8b ff ff ff       	call   801c94 <fsipc>
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <devfile_flush>:
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	8b 40 0c             	mov    0xc(%eax),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d21:	b8 06 00 00 00       	mov    $0x6,%eax
  801d26:	e8 69 ff ff ff       	call   801c94 <fsipc>
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <devfile_stat>:
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	b8 05 00 00 00       	mov    $0x5,%eax
  801d4c:	e8 43 ff ff ff       	call   801c94 <fsipc>
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 2c                	js     801d81 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	68 00 60 80 00       	push   $0x806000
  801d5d:	53                   	push   %ebx
  801d5e:	e8 cb ed ff ff       	call   800b2e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d63:	a1 80 60 80 00       	mov    0x806080,%eax
  801d68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d6e:	a1 84 60 80 00       	mov    0x806084,%eax
  801d73:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <devfile_write>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	53                   	push   %ebx
  801d8a:	83 ec 08             	sub    $0x8,%esp
  801d8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	8b 40 0c             	mov    0xc(%eax),%eax
  801d96:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d9b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801da1:	53                   	push   %ebx
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	68 08 60 80 00       	push   $0x806008
  801daa:	e8 6f ef ff ff       	call   800d1e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801daf:	ba 00 00 00 00       	mov    $0x0,%edx
  801db4:	b8 04 00 00 00       	mov    $0x4,%eax
  801db9:	e8 d6 fe ff ff       	call   801c94 <fsipc>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	78 0b                	js     801dd0 <devfile_write+0x4a>
	assert(r <= n);
  801dc5:	39 d8                	cmp    %ebx,%eax
  801dc7:	77 0c                	ja     801dd5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dc9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dce:	7f 1e                	jg     801dee <devfile_write+0x68>
}
  801dd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    
	assert(r <= n);
  801dd5:	68 f4 33 80 00       	push   $0x8033f4
  801dda:	68 fb 33 80 00       	push   $0x8033fb
  801ddf:	68 98 00 00 00       	push   $0x98
  801de4:	68 10 34 80 00       	push   $0x803410
  801de9:	e8 eb e4 ff ff       	call   8002d9 <_panic>
	assert(r <= PGSIZE);
  801dee:	68 1b 34 80 00       	push   $0x80341b
  801df3:	68 fb 33 80 00       	push   $0x8033fb
  801df8:	68 99 00 00 00       	push   $0x99
  801dfd:	68 10 34 80 00       	push   $0x803410
  801e02:	e8 d2 e4 ff ff       	call   8002d9 <_panic>

00801e07 <devfile_read>:
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	8b 40 0c             	mov    0xc(%eax),%eax
  801e15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e1a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	b8 03 00 00 00       	mov    $0x3,%eax
  801e2a:	e8 65 fe ff ff       	call   801c94 <fsipc>
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 1f                	js     801e54 <devfile_read+0x4d>
	assert(r <= n);
  801e35:	39 f0                	cmp    %esi,%eax
  801e37:	77 24                	ja     801e5d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e3e:	7f 33                	jg     801e73 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	50                   	push   %eax
  801e44:	68 00 60 80 00       	push   $0x806000
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	e8 6b ee ff ff       	call   800cbc <memmove>
	return r;
  801e51:	83 c4 10             	add    $0x10,%esp
}
  801e54:	89 d8                	mov    %ebx,%eax
  801e56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e59:	5b                   	pop    %ebx
  801e5a:	5e                   	pop    %esi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
	assert(r <= n);
  801e5d:	68 f4 33 80 00       	push   $0x8033f4
  801e62:	68 fb 33 80 00       	push   $0x8033fb
  801e67:	6a 7c                	push   $0x7c
  801e69:	68 10 34 80 00       	push   $0x803410
  801e6e:	e8 66 e4 ff ff       	call   8002d9 <_panic>
	assert(r <= PGSIZE);
  801e73:	68 1b 34 80 00       	push   $0x80341b
  801e78:	68 fb 33 80 00       	push   $0x8033fb
  801e7d:	6a 7d                	push   $0x7d
  801e7f:	68 10 34 80 00       	push   $0x803410
  801e84:	e8 50 e4 ff ff       	call   8002d9 <_panic>

00801e89 <open>:
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 1c             	sub    $0x1c,%esp
  801e91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e94:	56                   	push   %esi
  801e95:	e8 5b ec ff ff       	call   800af5 <strlen>
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea2:	7f 6c                	jg     801f10 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	e8 79 f8 ff ff       	call   801729 <fd_alloc>
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 3c                	js     801ef5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	56                   	push   %esi
  801ebd:	68 00 60 80 00       	push   $0x806000
  801ec2:	e8 67 ec ff ff       	call   800b2e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	e8 b8 fd ff ff       	call   801c94 <fsipc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 19                	js     801efe <open+0x75>
	return fd2num(fd);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eeb:	e8 12 f8 ff ff       	call   801702 <fd2num>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
}
  801ef5:	89 d8                	mov    %ebx,%eax
  801ef7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5e                   	pop    %esi
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    
		fd_close(fd, 0);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 f4             	pushl  -0xc(%ebp)
  801f06:	e8 1b f9 ff ff       	call   801826 <fd_close>
		return r;
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	eb e5                	jmp    801ef5 <open+0x6c>
		return -E_BAD_PATH;
  801f10:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f15:	eb de                	jmp    801ef5 <open+0x6c>

00801f17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f22:	b8 08 00 00 00       	mov    $0x8,%eax
  801f27:	e8 68 fd ff ff       	call   801c94 <fsipc>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f34:	68 27 34 80 00       	push   $0x803427
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	e8 ed eb ff ff       	call   800b2e <strcpy>
	return 0;
}
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <devsock_close>:
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	53                   	push   %ebx
  801f4c:	83 ec 10             	sub    $0x10,%esp
  801f4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f52:	53                   	push   %ebx
  801f53:	e8 e7 0a 00 00       	call   802a3f <pageref>
  801f58:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f5b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f60:	83 f8 01             	cmp    $0x1,%eax
  801f63:	74 07                	je     801f6c <devsock_close+0x24>
}
  801f65:	89 d0                	mov    %edx,%eax
  801f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	ff 73 0c             	pushl  0xc(%ebx)
  801f72:	e8 b9 02 00 00       	call   802230 <nsipc_close>
  801f77:	89 c2                	mov    %eax,%edx
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	eb e7                	jmp    801f65 <devsock_close+0x1d>

00801f7e <devsock_write>:
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 10             	pushl  0x10(%ebp)
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	ff 70 0c             	pushl  0xc(%eax)
  801f92:	e8 76 03 00 00       	call   80230d <nsipc_send>
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <devsock_read>:
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	ff 75 10             	pushl  0x10(%ebp)
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	ff 70 0c             	pushl  0xc(%eax)
  801fad:	e8 ef 02 00 00       	call   8022a1 <nsipc_recv>
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <fd2sockid>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fba:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fbd:	52                   	push   %edx
  801fbe:	50                   	push   %eax
  801fbf:	e8 b7 f7 ff ff       	call   80177b <fd_lookup>
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 10                	js     801fdb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fd4:	39 08                	cmp    %ecx,(%eax)
  801fd6:	75 05                	jne    801fdd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fd8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    
		return -E_NOT_SUPP;
  801fdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fe2:	eb f7                	jmp    801fdb <fd2sockid+0x27>

00801fe4 <alloc_sockfd>:
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
  801fe9:	83 ec 1c             	sub    $0x1c,%esp
  801fec:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff1:	50                   	push   %eax
  801ff2:	e8 32 f7 ff ff       	call   801729 <fd_alloc>
  801ff7:	89 c3                	mov    %eax,%ebx
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 43                	js     802043 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 07 04 00 00       	push   $0x407
  802008:	ff 75 f4             	pushl  -0xc(%ebp)
  80200b:	6a 00                	push   $0x0
  80200d:	e8 0e ef ff ff       	call   800f20 <sys_page_alloc>
  802012:	89 c3                	mov    %eax,%ebx
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 28                	js     802043 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802024:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802030:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	50                   	push   %eax
  802037:	e8 c6 f6 ff ff       	call   801702 <fd2num>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	eb 0c                	jmp    80204f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	56                   	push   %esi
  802047:	e8 e4 01 00 00       	call   802230 <nsipc_close>
		return r;
  80204c:	83 c4 10             	add    $0x10,%esp
}
  80204f:	89 d8                	mov    %ebx,%eax
  802051:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802054:	5b                   	pop    %ebx
  802055:	5e                   	pop    %esi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    

00802058 <accept>:
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	e8 4e ff ff ff       	call   801fb4 <fd2sockid>
  802066:	85 c0                	test   %eax,%eax
  802068:	78 1b                	js     802085 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	ff 75 10             	pushl  0x10(%ebp)
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	50                   	push   %eax
  802074:	e8 0e 01 00 00       	call   802187 <nsipc_accept>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 05                	js     802085 <accept+0x2d>
	return alloc_sockfd(r);
  802080:	e8 5f ff ff ff       	call   801fe4 <alloc_sockfd>
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <bind>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	e8 1f ff ff ff       	call   801fb4 <fd2sockid>
  802095:	85 c0                	test   %eax,%eax
  802097:	78 12                	js     8020ab <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	ff 75 10             	pushl  0x10(%ebp)
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	50                   	push   %eax
  8020a3:	e8 31 01 00 00       	call   8021d9 <nsipc_bind>
  8020a8:	83 c4 10             	add    $0x10,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <shutdown>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	e8 f9 fe ff ff       	call   801fb4 <fd2sockid>
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 0f                	js     8020ce <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020bf:	83 ec 08             	sub    $0x8,%esp
  8020c2:	ff 75 0c             	pushl  0xc(%ebp)
  8020c5:	50                   	push   %eax
  8020c6:	e8 43 01 00 00       	call   80220e <nsipc_shutdown>
  8020cb:	83 c4 10             	add    $0x10,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <connect>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	e8 d6 fe ff ff       	call   801fb4 <fd2sockid>
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 12                	js     8020f4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	ff 75 10             	pushl  0x10(%ebp)
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	50                   	push   %eax
  8020ec:	e8 59 01 00 00       	call   80224a <nsipc_connect>
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <listen>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	e8 b0 fe ff ff       	call   801fb4 <fd2sockid>
  802104:	85 c0                	test   %eax,%eax
  802106:	78 0f                	js     802117 <listen+0x21>
	return nsipc_listen(r, backlog);
  802108:	83 ec 08             	sub    $0x8,%esp
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	50                   	push   %eax
  80210f:	e8 6b 01 00 00       	call   80227f <nsipc_listen>
  802114:	83 c4 10             	add    $0x10,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <socket>:

int
socket(int domain, int type, int protocol)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80211f:	ff 75 10             	pushl  0x10(%ebp)
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	e8 3e 02 00 00       	call   80236b <nsipc_socket>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	78 05                	js     802139 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802134:	e8 ab fe ff ff       	call   801fe4 <alloc_sockfd>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	53                   	push   %ebx
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802144:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80214b:	74 26                	je     802173 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80214d:	6a 07                	push   $0x7
  80214f:	68 00 70 80 00       	push   $0x807000
  802154:	53                   	push   %ebx
  802155:	ff 35 04 50 80 00    	pushl  0x805004
  80215b:	e8 48 08 00 00       	call   8029a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802160:	83 c4 0c             	add    $0xc,%esp
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	e8 d1 07 00 00       	call   80293f <ipc_recv>
}
  80216e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802171:	c9                   	leave  
  802172:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	6a 02                	push   $0x2
  802178:	e8 83 08 00 00       	call   802a00 <ipc_find_env>
  80217d:	a3 04 50 80 00       	mov    %eax,0x805004
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	eb c6                	jmp    80214d <nsipc+0x12>

00802187 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	56                   	push   %esi
  80218b:	53                   	push   %ebx
  80218c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802197:	8b 06                	mov    (%esi),%eax
  802199:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80219e:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a3:	e8 93 ff ff ff       	call   80213b <nsipc>
  8021a8:	89 c3                	mov    %eax,%ebx
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	79 09                	jns    8021b7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021ae:	89 d8                	mov    %ebx,%eax
  8021b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5d                   	pop    %ebp
  8021b6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	ff 35 10 70 80 00    	pushl  0x807010
  8021c0:	68 00 70 80 00       	push   $0x807000
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	e8 ef ea ff ff       	call   800cbc <memmove>
		*addrlen = ret->ret_addrlen;
  8021cd:	a1 10 70 80 00       	mov    0x807010,%eax
  8021d2:	89 06                	mov    %eax,(%esi)
  8021d4:	83 c4 10             	add    $0x10,%esp
	return r;
  8021d7:	eb d5                	jmp    8021ae <nsipc_accept+0x27>

008021d9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021eb:	53                   	push   %ebx
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	68 04 70 80 00       	push   $0x807004
  8021f4:	e8 c3 ea ff ff       	call   800cbc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802204:	e8 32 ff ff ff       	call   80213b <nsipc>
}
  802209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802224:	b8 03 00 00 00       	mov    $0x3,%eax
  802229:	e8 0d ff ff ff       	call   80213b <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <nsipc_close>:

int
nsipc_close(int s)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80223e:	b8 04 00 00 00       	mov    $0x4,%eax
  802243:	e8 f3 fe ff ff       	call   80213b <nsipc>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 08             	sub    $0x8,%esp
  802251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80225c:	53                   	push   %ebx
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	68 04 70 80 00       	push   $0x807004
  802265:	e8 52 ea ff ff       	call   800cbc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80226a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802270:	b8 05 00 00 00       	mov    $0x5,%eax
  802275:	e8 c1 fe ff ff       	call   80213b <nsipc>
}
  80227a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802295:	b8 06 00 00 00       	mov    $0x6,%eax
  80229a:	e8 9c fe ff ff       	call   80213b <nsipc>
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	56                   	push   %esi
  8022a5:	53                   	push   %ebx
  8022a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022b1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ba:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8022c4:	e8 72 fe ff ff       	call   80213b <nsipc>
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	78 1f                	js     8022ee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022cf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022d4:	7f 21                	jg     8022f7 <nsipc_recv+0x56>
  8022d6:	39 c6                	cmp    %eax,%esi
  8022d8:	7c 1d                	jl     8022f7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	50                   	push   %eax
  8022de:	68 00 70 80 00       	push   $0x807000
  8022e3:	ff 75 0c             	pushl  0xc(%ebp)
  8022e6:	e8 d1 e9 ff ff       	call   800cbc <memmove>
  8022eb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ee:	89 d8                	mov    %ebx,%eax
  8022f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022f7:	68 33 34 80 00       	push   $0x803433
  8022fc:	68 fb 33 80 00       	push   $0x8033fb
  802301:	6a 62                	push   $0x62
  802303:	68 48 34 80 00       	push   $0x803448
  802308:	e8 cc df ff ff       	call   8002d9 <_panic>

0080230d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	53                   	push   %ebx
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80231f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802325:	7f 2e                	jg     802355 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	53                   	push   %ebx
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	68 0c 70 80 00       	push   $0x80700c
  802333:	e8 84 e9 ff ff       	call   800cbc <memmove>
	nsipcbuf.send.req_size = size;
  802338:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80233e:	8b 45 14             	mov    0x14(%ebp),%eax
  802341:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802346:	b8 08 00 00 00       	mov    $0x8,%eax
  80234b:	e8 eb fd ff ff       	call   80213b <nsipc>
}
  802350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802353:	c9                   	leave  
  802354:	c3                   	ret    
	assert(size < 1600);
  802355:	68 54 34 80 00       	push   $0x803454
  80235a:	68 fb 33 80 00       	push   $0x8033fb
  80235f:	6a 6d                	push   $0x6d
  802361:	68 48 34 80 00       	push   $0x803448
  802366:	e8 6e df ff ff       	call   8002d9 <_panic>

0080236b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802381:	8b 45 10             	mov    0x10(%ebp),%eax
  802384:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802389:	b8 09 00 00 00       	mov    $0x9,%eax
  80238e:	e8 a8 fd ff ff       	call   80213b <nsipc>
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	e8 6a f3 ff ff       	call   801712 <fd2data>
  8023a8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023aa:	83 c4 08             	add    $0x8,%esp
  8023ad:	68 60 34 80 00       	push   $0x803460
  8023b2:	53                   	push   %ebx
  8023b3:	e8 76 e7 ff ff       	call   800b2e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b8:	8b 46 04             	mov    0x4(%esi),%eax
  8023bb:	2b 06                	sub    (%esi),%eax
  8023bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023ca:	00 00 00 
	stat->st_dev = &devpipe;
  8023cd:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023d4:	40 80 00 
	return 0;
}
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5d                   	pop    %ebp
  8023e2:	c3                   	ret    

008023e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	53                   	push   %ebx
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ed:	53                   	push   %ebx
  8023ee:	6a 00                	push   $0x0
  8023f0:	e8 b0 eb ff ff       	call   800fa5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f5:	89 1c 24             	mov    %ebx,(%esp)
  8023f8:	e8 15 f3 ff ff       	call   801712 <fd2data>
  8023fd:	83 c4 08             	add    $0x8,%esp
  802400:	50                   	push   %eax
  802401:	6a 00                	push   $0x0
  802403:	e8 9d eb ff ff       	call   800fa5 <sys_page_unmap>
}
  802408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <_pipeisclosed>:
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	57                   	push   %edi
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	83 ec 1c             	sub    $0x1c,%esp
  802416:	89 c7                	mov    %eax,%edi
  802418:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80241a:	a1 20 54 80 00       	mov    0x805420,%eax
  80241f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	57                   	push   %edi
  802426:	e8 14 06 00 00       	call   802a3f <pageref>
  80242b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80242e:	89 34 24             	mov    %esi,(%esp)
  802431:	e8 09 06 00 00       	call   802a3f <pageref>
		nn = thisenv->env_runs;
  802436:	8b 15 20 54 80 00    	mov    0x805420,%edx
  80243c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80243f:	83 c4 10             	add    $0x10,%esp
  802442:	39 cb                	cmp    %ecx,%ebx
  802444:	74 1b                	je     802461 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802446:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802449:	75 cf                	jne    80241a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80244b:	8b 42 58             	mov    0x58(%edx),%eax
  80244e:	6a 01                	push   $0x1
  802450:	50                   	push   %eax
  802451:	53                   	push   %ebx
  802452:	68 67 34 80 00       	push   $0x803467
  802457:	e8 73 df ff ff       	call   8003cf <cprintf>
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	eb b9                	jmp    80241a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802461:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802464:	0f 94 c0             	sete   %al
  802467:	0f b6 c0             	movzbl %al,%eax
}
  80246a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <devpipe_write>:
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	57                   	push   %edi
  802476:	56                   	push   %esi
  802477:	53                   	push   %ebx
  802478:	83 ec 28             	sub    $0x28,%esp
  80247b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80247e:	56                   	push   %esi
  80247f:	e8 8e f2 ff ff       	call   801712 <fd2data>
  802484:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	bf 00 00 00 00       	mov    $0x0,%edi
  80248e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802491:	74 4f                	je     8024e2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802493:	8b 43 04             	mov    0x4(%ebx),%eax
  802496:	8b 0b                	mov    (%ebx),%ecx
  802498:	8d 51 20             	lea    0x20(%ecx),%edx
  80249b:	39 d0                	cmp    %edx,%eax
  80249d:	72 14                	jb     8024b3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80249f:	89 da                	mov    %ebx,%edx
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	e8 65 ff ff ff       	call   80240d <_pipeisclosed>
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	75 3b                	jne    8024e7 <devpipe_write+0x75>
			sys_yield();
  8024ac:	e8 50 ea ff ff       	call   800f01 <sys_yield>
  8024b1:	eb e0                	jmp    802493 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024bd:	89 c2                	mov    %eax,%edx
  8024bf:	c1 fa 1f             	sar    $0x1f,%edx
  8024c2:	89 d1                	mov    %edx,%ecx
  8024c4:	c1 e9 1b             	shr    $0x1b,%ecx
  8024c7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024ca:	83 e2 1f             	and    $0x1f,%edx
  8024cd:	29 ca                	sub    %ecx,%edx
  8024cf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024d7:	83 c0 01             	add    $0x1,%eax
  8024da:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024dd:	83 c7 01             	add    $0x1,%edi
  8024e0:	eb ac                	jmp    80248e <devpipe_write+0x1c>
	return i;
  8024e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_write+0x7a>
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <devpipe_read>:
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	57                   	push   %edi
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	83 ec 18             	sub    $0x18,%esp
  8024fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802500:	57                   	push   %edi
  802501:	e8 0c f2 ff ff       	call   801712 <fd2data>
  802506:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	be 00 00 00 00       	mov    $0x0,%esi
  802510:	3b 75 10             	cmp    0x10(%ebp),%esi
  802513:	75 14                	jne    802529 <devpipe_read+0x35>
	return i;
  802515:	8b 45 10             	mov    0x10(%ebp),%eax
  802518:	eb 02                	jmp    80251c <devpipe_read+0x28>
				return i;
  80251a:	89 f0                	mov    %esi,%eax
}
  80251c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
			sys_yield();
  802524:	e8 d8 e9 ff ff       	call   800f01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802529:	8b 03                	mov    (%ebx),%eax
  80252b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80252e:	75 18                	jne    802548 <devpipe_read+0x54>
			if (i > 0)
  802530:	85 f6                	test   %esi,%esi
  802532:	75 e6                	jne    80251a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802534:	89 da                	mov    %ebx,%edx
  802536:	89 f8                	mov    %edi,%eax
  802538:	e8 d0 fe ff ff       	call   80240d <_pipeisclosed>
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 e3                	je     802524 <devpipe_read+0x30>
				return 0;
  802541:	b8 00 00 00 00       	mov    $0x0,%eax
  802546:	eb d4                	jmp    80251c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802548:	99                   	cltd   
  802549:	c1 ea 1b             	shr    $0x1b,%edx
  80254c:	01 d0                	add    %edx,%eax
  80254e:	83 e0 1f             	and    $0x1f,%eax
  802551:	29 d0                	sub    %edx,%eax
  802553:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802558:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80255b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80255e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802561:	83 c6 01             	add    $0x1,%esi
  802564:	eb aa                	jmp    802510 <devpipe_read+0x1c>

00802566 <pipe>:
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	56                   	push   %esi
  80256a:	53                   	push   %ebx
  80256b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80256e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802571:	50                   	push   %eax
  802572:	e8 b2 f1 ff ff       	call   801729 <fd_alloc>
  802577:	89 c3                	mov    %eax,%ebx
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	85 c0                	test   %eax,%eax
  80257e:	0f 88 23 01 00 00    	js     8026a7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 07 04 00 00       	push   $0x407
  80258c:	ff 75 f4             	pushl  -0xc(%ebp)
  80258f:	6a 00                	push   $0x0
  802591:	e8 8a e9 ff ff       	call   800f20 <sys_page_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 88 04 01 00 00    	js     8026a7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a9:	50                   	push   %eax
  8025aa:	e8 7a f1 ff ff       	call   801729 <fd_alloc>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	0f 88 db 00 00 00    	js     802697 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bc:	83 ec 04             	sub    $0x4,%esp
  8025bf:	68 07 04 00 00       	push   $0x407
  8025c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c7:	6a 00                	push   $0x0
  8025c9:	e8 52 e9 ff ff       	call   800f20 <sys_page_alloc>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	83 c4 10             	add    $0x10,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 88 bc 00 00 00    	js     802697 <pipe+0x131>
	va = fd2data(fd0);
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e1:	e8 2c f1 ff ff       	call   801712 <fd2data>
  8025e6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e8:	83 c4 0c             	add    $0xc,%esp
  8025eb:	68 07 04 00 00       	push   $0x407
  8025f0:	50                   	push   %eax
  8025f1:	6a 00                	push   $0x0
  8025f3:	e8 28 e9 ff ff       	call   800f20 <sys_page_alloc>
  8025f8:	89 c3                	mov    %eax,%ebx
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 88 82 00 00 00    	js     802687 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 f0             	pushl  -0x10(%ebp)
  80260b:	e8 02 f1 ff ff       	call   801712 <fd2data>
  802610:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802617:	50                   	push   %eax
  802618:	6a 00                	push   $0x0
  80261a:	56                   	push   %esi
  80261b:	6a 00                	push   $0x0
  80261d:	e8 41 e9 ff ff       	call   800f63 <sys_page_map>
  802622:	89 c3                	mov    %eax,%ebx
  802624:	83 c4 20             	add    $0x20,%esp
  802627:	85 c0                	test   %eax,%eax
  802629:	78 4e                	js     802679 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80262b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802633:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80263f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802642:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	ff 75 f4             	pushl  -0xc(%ebp)
  802654:	e8 a9 f0 ff ff       	call   801702 <fd2num>
  802659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80265c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80265e:	83 c4 04             	add    $0x4,%esp
  802661:	ff 75 f0             	pushl  -0x10(%ebp)
  802664:	e8 99 f0 ff ff       	call   801702 <fd2num>
  802669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80266c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	bb 00 00 00 00       	mov    $0x0,%ebx
  802677:	eb 2e                	jmp    8026a7 <pipe+0x141>
	sys_page_unmap(0, va);
  802679:	83 ec 08             	sub    $0x8,%esp
  80267c:	56                   	push   %esi
  80267d:	6a 00                	push   $0x0
  80267f:	e8 21 e9 ff ff       	call   800fa5 <sys_page_unmap>
  802684:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802687:	83 ec 08             	sub    $0x8,%esp
  80268a:	ff 75 f0             	pushl  -0x10(%ebp)
  80268d:	6a 00                	push   $0x0
  80268f:	e8 11 e9 ff ff       	call   800fa5 <sys_page_unmap>
  802694:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802697:	83 ec 08             	sub    $0x8,%esp
  80269a:	ff 75 f4             	pushl  -0xc(%ebp)
  80269d:	6a 00                	push   $0x0
  80269f:	e8 01 e9 ff ff       	call   800fa5 <sys_page_unmap>
  8026a4:	83 c4 10             	add    $0x10,%esp
}
  8026a7:	89 d8                	mov    %ebx,%eax
  8026a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    

008026b0 <pipeisclosed>:
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b9:	50                   	push   %eax
  8026ba:	ff 75 08             	pushl  0x8(%ebp)
  8026bd:	e8 b9 f0 ff ff       	call   80177b <fd_lookup>
  8026c2:	83 c4 10             	add    $0x10,%esp
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	78 18                	js     8026e1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cf:	e8 3e f0 ff ff       	call   801712 <fd2data>
	return _pipeisclosed(fd, p);
  8026d4:	89 c2                	mov    %eax,%edx
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	e8 2f fd ff ff       	call   80240d <_pipeisclosed>
  8026de:	83 c4 10             	add    $0x10,%esp
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	56                   	push   %esi
  8026e7:	53                   	push   %ebx
  8026e8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026eb:	85 f6                	test   %esi,%esi
  8026ed:	74 16                	je     802705 <wait+0x22>
	e = &envs[ENVX(envid)];
  8026ef:	89 f3                	mov    %esi,%ebx
  8026f1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026f7:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  8026fd:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802703:	eb 1b                	jmp    802720 <wait+0x3d>
	assert(envid != 0);
  802705:	68 7f 34 80 00       	push   $0x80347f
  80270a:	68 fb 33 80 00       	push   $0x8033fb
  80270f:	6a 09                	push   $0x9
  802711:	68 8a 34 80 00       	push   $0x80348a
  802716:	e8 be db ff ff       	call   8002d9 <_panic>
		sys_yield();
  80271b:	e8 e1 e7 ff ff       	call   800f01 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802720:	8b 43 48             	mov    0x48(%ebx),%eax
  802723:	39 f0                	cmp    %esi,%eax
  802725:	75 07                	jne    80272e <wait+0x4b>
  802727:	8b 43 54             	mov    0x54(%ebx),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	75 ed                	jne    80271b <wait+0x38>
}
  80272e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    

00802735 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	c3                   	ret    

0080273b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802741:	68 95 34 80 00       	push   $0x803495
  802746:	ff 75 0c             	pushl  0xc(%ebp)
  802749:	e8 e0 e3 ff ff       	call   800b2e <strcpy>
	return 0;
}
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <devcons_write>:
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	57                   	push   %edi
  802759:	56                   	push   %esi
  80275a:	53                   	push   %ebx
  80275b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802761:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802766:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80276c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80276f:	73 31                	jae    8027a2 <devcons_write+0x4d>
		m = n - tot;
  802771:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802774:	29 f3                	sub    %esi,%ebx
  802776:	83 fb 7f             	cmp    $0x7f,%ebx
  802779:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80277e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802781:	83 ec 04             	sub    $0x4,%esp
  802784:	53                   	push   %ebx
  802785:	89 f0                	mov    %esi,%eax
  802787:	03 45 0c             	add    0xc(%ebp),%eax
  80278a:	50                   	push   %eax
  80278b:	57                   	push   %edi
  80278c:	e8 2b e5 ff ff       	call   800cbc <memmove>
		sys_cputs(buf, m);
  802791:	83 c4 08             	add    $0x8,%esp
  802794:	53                   	push   %ebx
  802795:	57                   	push   %edi
  802796:	e8 c9 e6 ff ff       	call   800e64 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80279b:	01 de                	add    %ebx,%esi
  80279d:	83 c4 10             	add    $0x10,%esp
  8027a0:	eb ca                	jmp    80276c <devcons_write+0x17>
}
  8027a2:	89 f0                	mov    %esi,%eax
  8027a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5f                   	pop    %edi
  8027aa:	5d                   	pop    %ebp
  8027ab:	c3                   	ret    

008027ac <devcons_read>:
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 08             	sub    $0x8,%esp
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027bb:	74 21                	je     8027de <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027bd:	e8 c0 e6 ff ff       	call   800e82 <sys_cgetc>
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 07                	jne    8027cd <devcons_read+0x21>
		sys_yield();
  8027c6:	e8 36 e7 ff ff       	call   800f01 <sys_yield>
  8027cb:	eb f0                	jmp    8027bd <devcons_read+0x11>
	if (c < 0)
  8027cd:	78 0f                	js     8027de <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027cf:	83 f8 04             	cmp    $0x4,%eax
  8027d2:	74 0c                	je     8027e0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d7:	88 02                	mov    %al,(%edx)
	return 1;
  8027d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    
		return 0;
  8027e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e5:	eb f7                	jmp    8027de <devcons_read+0x32>

008027e7 <cputchar>:
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027f3:	6a 01                	push   $0x1
  8027f5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027f8:	50                   	push   %eax
  8027f9:	e8 66 e6 ff ff       	call   800e64 <sys_cputs>
}
  8027fe:	83 c4 10             	add    $0x10,%esp
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <getchar>:
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802809:	6a 01                	push   $0x1
  80280b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80280e:	50                   	push   %eax
  80280f:	6a 00                	push   $0x0
  802811:	e8 d5 f1 ff ff       	call   8019eb <read>
	if (r < 0)
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 06                	js     802823 <getchar+0x20>
	if (r < 1)
  80281d:	74 06                	je     802825 <getchar+0x22>
	return c;
  80281f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    
		return -E_EOF;
  802825:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80282a:	eb f7                	jmp    802823 <getchar+0x20>

0080282c <iscons>:
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802835:	50                   	push   %eax
  802836:	ff 75 08             	pushl  0x8(%ebp)
  802839:	e8 3d ef ff ff       	call   80177b <fd_lookup>
  80283e:	83 c4 10             	add    $0x10,%esp
  802841:	85 c0                	test   %eax,%eax
  802843:	78 11                	js     802856 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80284e:	39 10                	cmp    %edx,(%eax)
  802850:	0f 94 c0             	sete   %al
  802853:	0f b6 c0             	movzbl %al,%eax
}
  802856:	c9                   	leave  
  802857:	c3                   	ret    

00802858 <opencons>:
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80285e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802861:	50                   	push   %eax
  802862:	e8 c2 ee ff ff       	call   801729 <fd_alloc>
  802867:	83 c4 10             	add    $0x10,%esp
  80286a:	85 c0                	test   %eax,%eax
  80286c:	78 3a                	js     8028a8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 07 04 00 00       	push   $0x407
  802876:	ff 75 f4             	pushl  -0xc(%ebp)
  802879:	6a 00                	push   $0x0
  80287b:	e8 a0 e6 ff ff       	call   800f20 <sys_page_alloc>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	85 c0                	test   %eax,%eax
  802885:	78 21                	js     8028a8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802890:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	50                   	push   %eax
  8028a0:	e8 5d ee ff ff       	call   801702 <fd2num>
  8028a5:	83 c4 10             	add    $0x10,%esp
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028b0:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028b7:	74 0a                	je     8028c3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028c1:	c9                   	leave  
  8028c2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	6a 07                	push   $0x7
  8028c8:	68 00 f0 bf ee       	push   $0xeebff000
  8028cd:	6a 00                	push   $0x0
  8028cf:	e8 4c e6 ff ff       	call   800f20 <sys_page_alloc>
		if(r < 0)
  8028d4:	83 c4 10             	add    $0x10,%esp
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	78 2a                	js     802905 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028db:	83 ec 08             	sub    $0x8,%esp
  8028de:	68 19 29 80 00       	push   $0x802919
  8028e3:	6a 00                	push   $0x0
  8028e5:	e8 81 e7 ff ff       	call   80106b <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028ea:	83 c4 10             	add    $0x10,%esp
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	79 c8                	jns    8028b9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 d4 34 80 00       	push   $0x8034d4
  8028f9:	6a 25                	push   $0x25
  8028fb:	68 10 35 80 00       	push   $0x803510
  802900:	e8 d4 d9 ff ff       	call   8002d9 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 a4 34 80 00       	push   $0x8034a4
  80290d:	6a 22                	push   $0x22
  80290f:	68 10 35 80 00       	push   $0x803510
  802914:	e8 c0 d9 ff ff       	call   8002d9 <_panic>

00802919 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802919:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80291a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80291f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802921:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802924:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802928:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80292c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80292f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802931:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802935:	83 c4 08             	add    $0x8,%esp
	popal
  802938:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802939:	83 c4 04             	add    $0x4,%esp
	popfl
  80293c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80293d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80293e:	c3                   	ret    

0080293f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	56                   	push   %esi
  802943:	53                   	push   %ebx
  802944:	8b 75 08             	mov    0x8(%ebp),%esi
  802947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80294d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80294f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802954:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	50                   	push   %eax
  80295b:	e8 70 e7 ff ff       	call   8010d0 <sys_ipc_recv>
	if(ret < 0){
  802960:	83 c4 10             	add    $0x10,%esp
  802963:	85 c0                	test   %eax,%eax
  802965:	78 2b                	js     802992 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802967:	85 f6                	test   %esi,%esi
  802969:	74 0a                	je     802975 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80296b:	a1 20 54 80 00       	mov    0x805420,%eax
  802970:	8b 40 78             	mov    0x78(%eax),%eax
  802973:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802975:	85 db                	test   %ebx,%ebx
  802977:	74 0a                	je     802983 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802979:	a1 20 54 80 00       	mov    0x805420,%eax
  80297e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802981:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802983:	a1 20 54 80 00       	mov    0x805420,%eax
  802988:	8b 40 74             	mov    0x74(%eax),%eax
}
  80298b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80298e:	5b                   	pop    %ebx
  80298f:	5e                   	pop    %esi
  802990:	5d                   	pop    %ebp
  802991:	c3                   	ret    
		if(from_env_store)
  802992:	85 f6                	test   %esi,%esi
  802994:	74 06                	je     80299c <ipc_recv+0x5d>
			*from_env_store = 0;
  802996:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80299c:	85 db                	test   %ebx,%ebx
  80299e:	74 eb                	je     80298b <ipc_recv+0x4c>
			*perm_store = 0;
  8029a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029a6:	eb e3                	jmp    80298b <ipc_recv+0x4c>

008029a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	57                   	push   %edi
  8029ac:	56                   	push   %esi
  8029ad:	53                   	push   %ebx
  8029ae:	83 ec 0c             	sub    $0xc,%esp
  8029b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029ba:	85 db                	test   %ebx,%ebx
  8029bc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029c1:	0f 44 d8             	cmove  %eax,%ebx
  8029c4:	eb 05                	jmp    8029cb <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029c6:	e8 36 e5 ff ff       	call   800f01 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029cb:	ff 75 14             	pushl  0x14(%ebp)
  8029ce:	53                   	push   %ebx
  8029cf:	56                   	push   %esi
  8029d0:	57                   	push   %edi
  8029d1:	e8 d7 e6 ff ff       	call   8010ad <sys_ipc_try_send>
  8029d6:	83 c4 10             	add    $0x10,%esp
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 1b                	je     8029f8 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029dd:	79 e7                	jns    8029c6 <ipc_send+0x1e>
  8029df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029e2:	74 e2                	je     8029c6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	68 1e 35 80 00       	push   $0x80351e
  8029ec:	6a 46                	push   $0x46
  8029ee:	68 33 35 80 00       	push   $0x803533
  8029f3:	e8 e1 d8 ff ff       	call   8002d9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5f                   	pop    %edi
  8029fe:	5d                   	pop    %ebp
  8029ff:	c3                   	ret    

00802a00 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a0b:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802a11:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a17:	8b 52 50             	mov    0x50(%edx),%edx
  802a1a:	39 ca                	cmp    %ecx,%edx
  802a1c:	74 11                	je     802a2f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802a1e:	83 c0 01             	add    $0x1,%eax
  802a21:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a26:	75 e3                	jne    802a0b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	eb 0e                	jmp    802a3d <ipc_find_env+0x3d>
			return envs[i].env_id;
  802a2f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802a35:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a3a:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a3d:	5d                   	pop    %ebp
  802a3e:	c3                   	ret    

00802a3f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a45:	89 d0                	mov    %edx,%eax
  802a47:	c1 e8 16             	shr    $0x16,%eax
  802a4a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a51:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a56:	f6 c1 01             	test   $0x1,%cl
  802a59:	74 1d                	je     802a78 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a5b:	c1 ea 0c             	shr    $0xc,%edx
  802a5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a65:	f6 c2 01             	test   $0x1,%dl
  802a68:	74 0e                	je     802a78 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a6a:	c1 ea 0c             	shr    $0xc,%edx
  802a6d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a74:	ef 
  802a75:	0f b7 c0             	movzwl %ax,%eax
}
  802a78:	5d                   	pop    %ebp
  802a79:	c3                   	ret    
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	66 90                	xchg   %ax,%ax
  802a7e:	66 90                	xchg   %ax,%ax

00802a80 <__udivdi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a97:	85 d2                	test   %edx,%edx
  802a99:	75 4d                	jne    802ae8 <__udivdi3+0x68>
  802a9b:	39 f3                	cmp    %esi,%ebx
  802a9d:	76 19                	jbe    802ab8 <__udivdi3+0x38>
  802a9f:	31 ff                	xor    %edi,%edi
  802aa1:	89 e8                	mov    %ebp,%eax
  802aa3:	89 f2                	mov    %esi,%edx
  802aa5:	f7 f3                	div    %ebx
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 d9                	mov    %ebx,%ecx
  802aba:	85 db                	test   %ebx,%ebx
  802abc:	75 0b                	jne    802ac9 <__udivdi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f3                	div    %ebx
  802ac7:	89 c1                	mov    %eax,%ecx
  802ac9:	31 d2                	xor    %edx,%edx
  802acb:	89 f0                	mov    %esi,%eax
  802acd:	f7 f1                	div    %ecx
  802acf:	89 c6                	mov    %eax,%esi
  802ad1:	89 e8                	mov    %ebp,%eax
  802ad3:	89 f7                	mov    %esi,%edi
  802ad5:	f7 f1                	div    %ecx
  802ad7:	89 fa                	mov    %edi,%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	39 f2                	cmp    %esi,%edx
  802aea:	77 1c                	ja     802b08 <__udivdi3+0x88>
  802aec:	0f bd fa             	bsr    %edx,%edi
  802aef:	83 f7 1f             	xor    $0x1f,%edi
  802af2:	75 2c                	jne    802b20 <__udivdi3+0xa0>
  802af4:	39 f2                	cmp    %esi,%edx
  802af6:	72 06                	jb     802afe <__udivdi3+0x7e>
  802af8:	31 c0                	xor    %eax,%eax
  802afa:	39 eb                	cmp    %ebp,%ebx
  802afc:	77 a9                	ja     802aa7 <__udivdi3+0x27>
  802afe:	b8 01 00 00 00       	mov    $0x1,%eax
  802b03:	eb a2                	jmp    802aa7 <__udivdi3+0x27>
  802b05:	8d 76 00             	lea    0x0(%esi),%esi
  802b08:	31 ff                	xor    %edi,%edi
  802b0a:	31 c0                	xor    %eax,%eax
  802b0c:	89 fa                	mov    %edi,%edx
  802b0e:	83 c4 1c             	add    $0x1c,%esp
  802b11:	5b                   	pop    %ebx
  802b12:	5e                   	pop    %esi
  802b13:	5f                   	pop    %edi
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	89 f9                	mov    %edi,%ecx
  802b22:	b8 20 00 00 00       	mov    $0x20,%eax
  802b27:	29 f8                	sub    %edi,%eax
  802b29:	d3 e2                	shl    %cl,%edx
  802b2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b2f:	89 c1                	mov    %eax,%ecx
  802b31:	89 da                	mov    %ebx,%edx
  802b33:	d3 ea                	shr    %cl,%edx
  802b35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b39:	09 d1                	or     %edx,%ecx
  802b3b:	89 f2                	mov    %esi,%edx
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 f9                	mov    %edi,%ecx
  802b43:	d3 e3                	shl    %cl,%ebx
  802b45:	89 c1                	mov    %eax,%ecx
  802b47:	d3 ea                	shr    %cl,%edx
  802b49:	89 f9                	mov    %edi,%ecx
  802b4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b4f:	89 eb                	mov    %ebp,%ebx
  802b51:	d3 e6                	shl    %cl,%esi
  802b53:	89 c1                	mov    %eax,%ecx
  802b55:	d3 eb                	shr    %cl,%ebx
  802b57:	09 de                	or     %ebx,%esi
  802b59:	89 f0                	mov    %esi,%eax
  802b5b:	f7 74 24 08          	divl   0x8(%esp)
  802b5f:	89 d6                	mov    %edx,%esi
  802b61:	89 c3                	mov    %eax,%ebx
  802b63:	f7 64 24 0c          	mull   0xc(%esp)
  802b67:	39 d6                	cmp    %edx,%esi
  802b69:	72 15                	jb     802b80 <__udivdi3+0x100>
  802b6b:	89 f9                	mov    %edi,%ecx
  802b6d:	d3 e5                	shl    %cl,%ebp
  802b6f:	39 c5                	cmp    %eax,%ebp
  802b71:	73 04                	jae    802b77 <__udivdi3+0xf7>
  802b73:	39 d6                	cmp    %edx,%esi
  802b75:	74 09                	je     802b80 <__udivdi3+0x100>
  802b77:	89 d8                	mov    %ebx,%eax
  802b79:	31 ff                	xor    %edi,%edi
  802b7b:	e9 27 ff ff ff       	jmp    802aa7 <__udivdi3+0x27>
  802b80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b83:	31 ff                	xor    %edi,%edi
  802b85:	e9 1d ff ff ff       	jmp    802aa7 <__udivdi3+0x27>
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__umoddi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	53                   	push   %ebx
  802b94:	83 ec 1c             	sub    $0x1c,%esp
  802b97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ba7:	89 da                	mov    %ebx,%edx
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	75 43                	jne    802bf0 <__umoddi3+0x60>
  802bad:	39 df                	cmp    %ebx,%edi
  802baf:	76 17                	jbe    802bc8 <__umoddi3+0x38>
  802bb1:	89 f0                	mov    %esi,%eax
  802bb3:	f7 f7                	div    %edi
  802bb5:	89 d0                	mov    %edx,%eax
  802bb7:	31 d2                	xor    %edx,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	89 fd                	mov    %edi,%ebp
  802bca:	85 ff                	test   %edi,%edi
  802bcc:	75 0b                	jne    802bd9 <__umoddi3+0x49>
  802bce:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd3:	31 d2                	xor    %edx,%edx
  802bd5:	f7 f7                	div    %edi
  802bd7:	89 c5                	mov    %eax,%ebp
  802bd9:	89 d8                	mov    %ebx,%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	f7 f5                	div    %ebp
  802bdf:	89 f0                	mov    %esi,%eax
  802be1:	f7 f5                	div    %ebp
  802be3:	89 d0                	mov    %edx,%eax
  802be5:	eb d0                	jmp    802bb7 <__umoddi3+0x27>
  802be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bee:	66 90                	xchg   %ax,%ax
  802bf0:	89 f1                	mov    %esi,%ecx
  802bf2:	39 d8                	cmp    %ebx,%eax
  802bf4:	76 0a                	jbe    802c00 <__umoddi3+0x70>
  802bf6:	89 f0                	mov    %esi,%eax
  802bf8:	83 c4 1c             	add    $0x1c,%esp
  802bfb:	5b                   	pop    %ebx
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	0f bd e8             	bsr    %eax,%ebp
  802c03:	83 f5 1f             	xor    $0x1f,%ebp
  802c06:	75 20                	jne    802c28 <__umoddi3+0x98>
  802c08:	39 d8                	cmp    %ebx,%eax
  802c0a:	0f 82 b0 00 00 00    	jb     802cc0 <__umoddi3+0x130>
  802c10:	39 f7                	cmp    %esi,%edi
  802c12:	0f 86 a8 00 00 00    	jbe    802cc0 <__umoddi3+0x130>
  802c18:	89 c8                	mov    %ecx,%eax
  802c1a:	83 c4 1c             	add    $0x1c,%esp
  802c1d:	5b                   	pop    %ebx
  802c1e:	5e                   	pop    %esi
  802c1f:	5f                   	pop    %edi
  802c20:	5d                   	pop    %ebp
  802c21:	c3                   	ret    
  802c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c2f:	29 ea                	sub    %ebp,%edx
  802c31:	d3 e0                	shl    %cl,%eax
  802c33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c37:	89 d1                	mov    %edx,%ecx
  802c39:	89 f8                	mov    %edi,%eax
  802c3b:	d3 e8                	shr    %cl,%eax
  802c3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c49:	09 c1                	or     %eax,%ecx
  802c4b:	89 d8                	mov    %ebx,%eax
  802c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c51:	89 e9                	mov    %ebp,%ecx
  802c53:	d3 e7                	shl    %cl,%edi
  802c55:	89 d1                	mov    %edx,%ecx
  802c57:	d3 e8                	shr    %cl,%eax
  802c59:	89 e9                	mov    %ebp,%ecx
  802c5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c5f:	d3 e3                	shl    %cl,%ebx
  802c61:	89 c7                	mov    %eax,%edi
  802c63:	89 d1                	mov    %edx,%ecx
  802c65:	89 f0                	mov    %esi,%eax
  802c67:	d3 e8                	shr    %cl,%eax
  802c69:	89 e9                	mov    %ebp,%ecx
  802c6b:	89 fa                	mov    %edi,%edx
  802c6d:	d3 e6                	shl    %cl,%esi
  802c6f:	09 d8                	or     %ebx,%eax
  802c71:	f7 74 24 08          	divl   0x8(%esp)
  802c75:	89 d1                	mov    %edx,%ecx
  802c77:	89 f3                	mov    %esi,%ebx
  802c79:	f7 64 24 0c          	mull   0xc(%esp)
  802c7d:	89 c6                	mov    %eax,%esi
  802c7f:	89 d7                	mov    %edx,%edi
  802c81:	39 d1                	cmp    %edx,%ecx
  802c83:	72 06                	jb     802c8b <__umoddi3+0xfb>
  802c85:	75 10                	jne    802c97 <__umoddi3+0x107>
  802c87:	39 c3                	cmp    %eax,%ebx
  802c89:	73 0c                	jae    802c97 <__umoddi3+0x107>
  802c8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c93:	89 d7                	mov    %edx,%edi
  802c95:	89 c6                	mov    %eax,%esi
  802c97:	89 ca                	mov    %ecx,%edx
  802c99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c9e:	29 f3                	sub    %esi,%ebx
  802ca0:	19 fa                	sbb    %edi,%edx
  802ca2:	89 d0                	mov    %edx,%eax
  802ca4:	d3 e0                	shl    %cl,%eax
  802ca6:	89 e9                	mov    %ebp,%ecx
  802ca8:	d3 eb                	shr    %cl,%ebx
  802caa:	d3 ea                	shr    %cl,%edx
  802cac:	09 d8                	or     %ebx,%eax
  802cae:	83 c4 1c             	add    $0x1c,%esp
  802cb1:	5b                   	pop    %ebx
  802cb2:	5e                   	pop    %esi
  802cb3:	5f                   	pop    %edi
  802cb4:	5d                   	pop    %ebp
  802cb5:	c3                   	ret    
  802cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cbd:	8d 76 00             	lea    0x0(%esi),%esi
  802cc0:	89 da                	mov    %ebx,%edx
  802cc2:	29 fe                	sub    %edi,%esi
  802cc4:	19 c2                	sbb    %eax,%edx
  802cc6:	89 f1                	mov    %esi,%ecx
  802cc8:	89 c8                	mov    %ecx,%eax
  802cca:	e9 4b ff ff ff       	jmp    802c1a <__umoddi3+0x8a>
