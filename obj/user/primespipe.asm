
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 00 02 00 00       	call   800231 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800045:	eb 5e                	jmp    8000a5 <primeproc+0x72>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	85 c0                	test   %eax,%eax
  80004c:	ba 00 00 00 00       	mov    $0x0,%edx
  800051:	0f 4e d0             	cmovle %eax,%edx
  800054:	52                   	push   %edx
  800055:	50                   	push   %eax
  800056:	68 c0 26 80 00       	push   $0x8026c0
  80005b:	6a 15                	push   $0x15
  80005d:	68 ef 26 80 00       	push   $0x8026ef
  800062:	e8 71 02 00 00       	call   8002d8 <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 05 27 80 00       	push   $0x802705
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 ef 26 80 00       	push   $0x8026ef
  800074:	e8 5f 02 00 00       	call   8002d8 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 0e 27 80 00       	push   $0x80270e
  80007f:	6a 1d                	push   $0x1d
  800081:	68 ef 26 80 00       	push   $0x8026ef
  800086:	e8 4d 02 00 00       	call   8002d8 <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 1b 17 00 00       	call   8017af <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 10 17 00 00       	call   8017af <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 c3 18 00 00       	call   801974 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 01 27 80 00       	push   $0x802701
  8000c4:	e8 05 03 00 00       	call   8003ce <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 c9 1e 00 00       	call   801f9a <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 7d 12 00 00       	call   80135d <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 be 16 00 00       	call   8017af <close>
	wfd = pfd[1];
  8000f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f4:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f7:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	e8 6e 18 00 00       	call   801974 <readn>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	83 f8 04             	cmp    $0x4,%eax
  80010c:	75 42                	jne    800150 <primeproc+0x11d>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d e0             	idivl  -0x20(%ebp)
  800115:	85 d2                	test   %edx,%edx
  800117:	74 e1                	je     8000fa <primeproc+0xc7>
			if ((r=write(wfd, &i, 4)) != 4)
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	6a 04                	push   $0x4
  80011e:	56                   	push   %esi
  80011f:	57                   	push   %edi
  800120:	e8 94 18 00 00       	call   8019b9 <write>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	83 f8 04             	cmp    $0x4,%eax
  80012b:	74 cd                	je     8000fa <primeproc+0xc7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	85 c0                	test   %eax,%eax
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	0f 4e d0             	cmovle %eax,%edx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	ff 75 e0             	pushl  -0x20(%ebp)
  80013f:	68 33 27 80 00       	push   $0x802733
  800144:	6a 2e                	push   $0x2e
  800146:	68 ef 26 80 00       	push   $0x8026ef
  80014b:	e8 88 01 00 00       	call   8002d8 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 17 27 80 00       	push   $0x802717
  800168:	6a 2b                	push   $0x2b
  80016a:	68 ef 26 80 00       	push   $0x8026ef
  80016f:	e8 64 01 00 00       	call   8002d8 <_panic>

00800174 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017b:	c7 05 00 30 80 00 4d 	movl   $0x80274d,0x803000
  800182:	27 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 0c 1e 00 00       	call   801f9a <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 c0 11 00 00       	call   80135d <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 01 16 00 00       	call   8017af <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 05 27 80 00       	push   $0x802705
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 ef 26 80 00       	push   $0x8026ef
  8001c6:	e8 0d 01 00 00       	call   8002d8 <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 0e 27 80 00       	push   $0x80270e
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 ef 26 80 00       	push   $0x8026ef
  8001d8:	e8 fb 00 00 00       	call   8002d8 <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 c7 15 00 00       	call   8017af <close>

	// feed all the integers through
	for (i=2;; i++)
  8001e8:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001ef:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 04                	push   $0x4
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8001fe:	e8 b6 17 00 00       	call   8019b9 <write>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	83 f8 04             	cmp    $0x4,%eax
  800209:	75 06                	jne    800211 <umain+0x9d>
	for (i=2;; i++)
  80020b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80020f:	eb e4                	jmp    8001f5 <umain+0x81>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	85 c0                	test   %eax,%eax
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	0f 4e d0             	cmovle %eax,%edx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 58 27 80 00       	push   $0x802758
  800225:	6a 4a                	push   $0x4a
  800227:	68 ef 26 80 00       	push   $0x8026ef
  80022c:	e8 a7 00 00 00       	call   8002d8 <_panic>

00800231 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80023a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800241:	00 00 00 
	envid_t find = sys_getenvid();
  800244:	e8 98 0c 00 00       	call   800ee1 <sys_getenvid>
  800249:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  80024f:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800254:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800259:	bf 01 00 00 00       	mov    $0x1,%edi
  80025e:	eb 0b                	jmp    80026b <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800260:	83 c2 01             	add    $0x1,%edx
  800263:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800269:	74 21                	je     80028c <libmain+0x5b>
		if(envs[i].env_id == find)
  80026b:	89 d1                	mov    %edx,%ecx
  80026d:	c1 e1 07             	shl    $0x7,%ecx
  800270:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800276:	8b 49 48             	mov    0x48(%ecx),%ecx
  800279:	39 c1                	cmp    %eax,%ecx
  80027b:	75 e3                	jne    800260 <libmain+0x2f>
  80027d:	89 d3                	mov    %edx,%ebx
  80027f:	c1 e3 07             	shl    $0x7,%ebx
  800282:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800288:	89 fe                	mov    %edi,%esi
  80028a:	eb d4                	jmp    800260 <libmain+0x2f>
  80028c:	89 f0                	mov    %esi,%eax
  80028e:	84 c0                	test   %al,%al
  800290:	74 06                	je     800298 <libmain+0x67>
  800292:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029c:	7e 0a                	jle    8002a8 <libmain+0x77>
		binaryname = argv[0];
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	8b 00                	mov    (%eax),%eax
  8002a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	e8 be fe ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  8002b6:	e8 0b 00 00 00       	call   8002c6 <exit>
}
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8002cc:	6a 00                	push   $0x0
  8002ce:	e8 cd 0b 00 00       	call   800ea0 <sys_env_destroy>
}
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8002e2:	8b 40 48             	mov    0x48(%eax),%eax
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	68 ac 27 80 00       	push   $0x8027ac
  8002ed:	50                   	push   %eax
  8002ee:	68 7a 27 80 00       	push   $0x80277a
  8002f3:	e8 d6 00 00 00       	call   8003ce <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002f8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800301:	e8 db 0b 00 00       	call   800ee1 <sys_getenvid>
  800306:	83 c4 04             	add    $0x4,%esp
  800309:	ff 75 0c             	pushl  0xc(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	56                   	push   %esi
  800310:	50                   	push   %eax
  800311:	68 88 27 80 00       	push   $0x802788
  800316:	e8 b3 00 00 00       	call   8003ce <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031b:	83 c4 18             	add    $0x18,%esp
  80031e:	53                   	push   %ebx
  80031f:	ff 75 10             	pushl  0x10(%ebp)
  800322:	e8 56 00 00 00       	call   80037d <vcprintf>
	cprintf("\n");
  800327:	c7 04 24 b9 2b 80 00 	movl   $0x802bb9,(%esp)
  80032e:	e8 9b 00 00 00       	call   8003ce <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800336:	cc                   	int3   
  800337:	eb fd                	jmp    800336 <_panic+0x5e>

00800339 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	53                   	push   %ebx
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800343:	8b 13                	mov    (%ebx),%edx
  800345:	8d 42 01             	lea    0x1(%edx),%eax
  800348:	89 03                	mov    %eax,(%ebx)
  80034a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800351:	3d ff 00 00 00       	cmp    $0xff,%eax
  800356:	74 09                	je     800361 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800358:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035f:	c9                   	leave  
  800360:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	68 ff 00 00 00       	push   $0xff
  800369:	8d 43 08             	lea    0x8(%ebx),%eax
  80036c:	50                   	push   %eax
  80036d:	e8 f1 0a 00 00       	call   800e63 <sys_cputs>
		b->idx = 0;
  800372:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800378:	83 c4 10             	add    $0x10,%esp
  80037b:	eb db                	jmp    800358 <putch+0x1f>

0080037d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800386:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038d:	00 00 00 
	b.cnt = 0;
  800390:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800397:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80039a:	ff 75 0c             	pushl  0xc(%ebp)
  80039d:	ff 75 08             	pushl  0x8(%ebp)
  8003a0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	68 39 03 80 00       	push   $0x800339
  8003ac:	e8 4a 01 00 00       	call   8004fb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b1:	83 c4 08             	add    $0x8,%esp
  8003b4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ba:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	e8 9d 0a 00 00       	call   800e63 <sys_cputs>

	return b.cnt;
}
  8003c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d7:	50                   	push   %eax
  8003d8:	ff 75 08             	pushl  0x8(%ebp)
  8003db:	e8 9d ff ff ff       	call   80037d <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	57                   	push   %edi
  8003e6:	56                   	push   %esi
  8003e7:	53                   	push   %ebx
  8003e8:	83 ec 1c             	sub    $0x1c,%esp
  8003eb:	89 c6                	mov    %eax,%esi
  8003ed:	89 d7                	mov    %edx,%edi
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800401:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800405:	74 2c                	je     800433 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800407:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800411:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800414:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800417:	39 c2                	cmp    %eax,%edx
  800419:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80041c:	73 43                	jae    800461 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80041e:	83 eb 01             	sub    $0x1,%ebx
  800421:	85 db                	test   %ebx,%ebx
  800423:	7e 6c                	jle    800491 <printnum+0xaf>
				putch(padc, putdat);
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	57                   	push   %edi
  800429:	ff 75 18             	pushl  0x18(%ebp)
  80042c:	ff d6                	call   *%esi
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	eb eb                	jmp    80041e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	6a 20                	push   $0x20
  800438:	6a 00                	push   $0x0
  80043a:	50                   	push   %eax
  80043b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043e:	ff 75 e0             	pushl  -0x20(%ebp)
  800441:	89 fa                	mov    %edi,%edx
  800443:	89 f0                	mov    %esi,%eax
  800445:	e8 98 ff ff ff       	call   8003e2 <printnum>
		while (--width > 0)
  80044a:	83 c4 20             	add    $0x20,%esp
  80044d:	83 eb 01             	sub    $0x1,%ebx
  800450:	85 db                	test   %ebx,%ebx
  800452:	7e 65                	jle    8004b9 <printnum+0xd7>
			putch(padc, putdat);
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	57                   	push   %edi
  800458:	6a 20                	push   $0x20
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	eb ec                	jmp    80044d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	ff 75 18             	pushl  0x18(%ebp)
  800467:	83 eb 01             	sub    $0x1,%ebx
  80046a:	53                   	push   %ebx
  80046b:	50                   	push   %eax
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 dc             	pushl  -0x24(%ebp)
  800472:	ff 75 d8             	pushl  -0x28(%ebp)
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	e8 e0 1f 00 00       	call   802460 <__udivdi3>
  800480:	83 c4 18             	add    $0x18,%esp
  800483:	52                   	push   %edx
  800484:	50                   	push   %eax
  800485:	89 fa                	mov    %edi,%edx
  800487:	89 f0                	mov    %esi,%eax
  800489:	e8 54 ff ff ff       	call   8003e2 <printnum>
  80048e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	57                   	push   %edi
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	ff 75 dc             	pushl  -0x24(%ebp)
  80049b:	ff 75 d8             	pushl  -0x28(%ebp)
  80049e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a4:	e8 c7 20 00 00       	call   802570 <__umoddi3>
  8004a9:	83 c4 14             	add    $0x14,%esp
  8004ac:	0f be 80 b3 27 80 00 	movsbl 0x8027b3(%eax),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff d6                	call   *%esi
  8004b6:	83 c4 10             	add    $0x10,%esp
	}
}
  8004b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bc:	5b                   	pop    %ebx
  8004bd:	5e                   	pop    %esi
  8004be:	5f                   	pop    %edi
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    

008004c1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004cb:	8b 10                	mov    (%eax),%edx
  8004cd:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d0:	73 0a                	jae    8004dc <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d5:	89 08                	mov    %ecx,(%eax)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	88 02                	mov    %al,(%edx)
}
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    

008004de <printfmt>:
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e7:	50                   	push   %eax
  8004e8:	ff 75 10             	pushl  0x10(%ebp)
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	ff 75 08             	pushl  0x8(%ebp)
  8004f1:	e8 05 00 00 00       	call   8004fb <vprintfmt>
}
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vprintfmt>:
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	57                   	push   %edi
  8004ff:	56                   	push   %esi
  800500:	53                   	push   %ebx
  800501:	83 ec 3c             	sub    $0x3c,%esp
  800504:	8b 75 08             	mov    0x8(%ebp),%esi
  800507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050d:	e9 32 04 00 00       	jmp    800944 <vprintfmt+0x449>
		padc = ' ';
  800512:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800516:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80051d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800524:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80052b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800532:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800539:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053e:	8d 47 01             	lea    0x1(%edi),%eax
  800541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800544:	0f b6 17             	movzbl (%edi),%edx
  800547:	8d 42 dd             	lea    -0x23(%edx),%eax
  80054a:	3c 55                	cmp    $0x55,%al
  80054c:	0f 87 12 05 00 00    	ja     800a64 <vprintfmt+0x569>
  800552:	0f b6 c0             	movzbl %al,%eax
  800555:	ff 24 85 a0 29 80 00 	jmp    *0x8029a0(,%eax,4)
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80055f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800563:	eb d9                	jmp    80053e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800568:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80056c:	eb d0                	jmp    80053e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80056e:	0f b6 d2             	movzbl %dl,%edx
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800574:	b8 00 00 00 00       	mov    $0x0,%eax
  800579:	89 75 08             	mov    %esi,0x8(%ebp)
  80057c:	eb 03                	jmp    800581 <vprintfmt+0x86>
  80057e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800581:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800584:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800588:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80058e:	83 fe 09             	cmp    $0x9,%esi
  800591:	76 eb                	jbe    80057e <vprintfmt+0x83>
  800593:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800596:	8b 75 08             	mov    0x8(%ebp),%esi
  800599:	eb 14                	jmp    8005af <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b3:	79 89                	jns    80053e <vprintfmt+0x43>
				width = precision, precision = -1;
  8005b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005c2:	e9 77 ff ff ff       	jmp    80053e <vprintfmt+0x43>
  8005c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 48 c1             	cmovs  %ecx,%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d5:	e9 64 ff ff ff       	jmp    80053e <vprintfmt+0x43>
  8005da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005e4:	e9 55 ff ff ff       	jmp    80053e <vprintfmt+0x43>
			lflag++;
  8005e9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f0:	e9 49 ff ff ff       	jmp    80053e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 78 04             	lea    0x4(%eax),%edi
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	ff 30                	pushl  (%eax)
  800601:	ff d6                	call   *%esi
			break;
  800603:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800606:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800609:	e9 33 03 00 00       	jmp    800941 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 78 04             	lea    0x4(%eax),%edi
  800614:	8b 00                	mov    (%eax),%eax
  800616:	99                   	cltd   
  800617:	31 d0                	xor    %edx,%eax
  800619:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061b:	83 f8 0f             	cmp    $0xf,%eax
  80061e:	7f 23                	jg     800643 <vprintfmt+0x148>
  800620:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  800627:	85 d2                	test   %edx,%edx
  800629:	74 18                	je     800643 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80062b:	52                   	push   %edx
  80062c:	68 32 2d 80 00       	push   $0x802d32
  800631:	53                   	push   %ebx
  800632:	56                   	push   %esi
  800633:	e8 a6 fe ff ff       	call   8004de <printfmt>
  800638:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063e:	e9 fe 02 00 00       	jmp    800941 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800643:	50                   	push   %eax
  800644:	68 cb 27 80 00       	push   $0x8027cb
  800649:	53                   	push   %ebx
  80064a:	56                   	push   %esi
  80064b:	e8 8e fe ff ff       	call   8004de <printfmt>
  800650:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800653:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800656:	e9 e6 02 00 00       	jmp    800941 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	83 c0 04             	add    $0x4,%eax
  800661:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800669:	85 c9                	test   %ecx,%ecx
  80066b:	b8 c4 27 80 00       	mov    $0x8027c4,%eax
  800670:	0f 45 c1             	cmovne %ecx,%eax
  800673:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	7e 06                	jle    800682 <vprintfmt+0x187>
  80067c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800680:	75 0d                	jne    80068f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800682:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800685:	89 c7                	mov    %eax,%edi
  800687:	03 45 e0             	add    -0x20(%ebp),%eax
  80068a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068d:	eb 53                	jmp    8006e2 <vprintfmt+0x1e7>
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 d8             	pushl  -0x28(%ebp)
  800695:	50                   	push   %eax
  800696:	e8 71 04 00 00       	call   800b0c <strnlen>
  80069b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069e:	29 c1                	sub    %eax,%ecx
  8006a0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006a8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006af:	eb 0f                	jmp    8006c0 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	83 ef 01             	sub    $0x1,%edi
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	85 ff                	test   %edi,%edi
  8006c2:	7f ed                	jg     8006b1 <vprintfmt+0x1b6>
  8006c4:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c1             	cmovns %ecx,%eax
  8006d1:	29 c1                	sub    %eax,%ecx
  8006d3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006d6:	eb aa                	jmp    800682 <vprintfmt+0x187>
					putch(ch, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	52                   	push   %edx
  8006dd:	ff d6                	call   *%esi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e7:	83 c7 01             	add    $0x1,%edi
  8006ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ee:	0f be d0             	movsbl %al,%edx
  8006f1:	85 d2                	test   %edx,%edx
  8006f3:	74 4b                	je     800740 <vprintfmt+0x245>
  8006f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f9:	78 06                	js     800701 <vprintfmt+0x206>
  8006fb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ff:	78 1e                	js     80071f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800701:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800705:	74 d1                	je     8006d8 <vprintfmt+0x1dd>
  800707:	0f be c0             	movsbl %al,%eax
  80070a:	83 e8 20             	sub    $0x20,%eax
  80070d:	83 f8 5e             	cmp    $0x5e,%eax
  800710:	76 c6                	jbe    8006d8 <vprintfmt+0x1dd>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 3f                	push   $0x3f
  800718:	ff d6                	call   *%esi
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb c3                	jmp    8006e2 <vprintfmt+0x1e7>
  80071f:	89 cf                	mov    %ecx,%edi
  800721:	eb 0e                	jmp    800731 <vprintfmt+0x236>
				putch(' ', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 20                	push   $0x20
  800729:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072b:	83 ef 01             	sub    $0x1,%edi
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	85 ff                	test   %edi,%edi
  800733:	7f ee                	jg     800723 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800735:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
  80073b:	e9 01 02 00 00       	jmp    800941 <vprintfmt+0x446>
  800740:	89 cf                	mov    %ecx,%edi
  800742:	eb ed                	jmp    800731 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800744:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800747:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80074e:	e9 eb fd ff ff       	jmp    80053e <vprintfmt+0x43>
	if (lflag >= 2)
  800753:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800757:	7f 21                	jg     80077a <vprintfmt+0x27f>
	else if (lflag)
  800759:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075d:	74 68                	je     8007c7 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800767:	89 c1                	mov    %eax,%ecx
  800769:	c1 f9 1f             	sar    $0x1f,%ecx
  80076c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
  800778:	eb 17                	jmp    800791 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 50 04             	mov    0x4(%eax),%edx
  800780:	8b 00                	mov    (%eax),%eax
  800782:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800785:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 08             	lea    0x8(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800791:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800794:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80079d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a1:	78 3f                	js     8007e2 <vprintfmt+0x2e7>
			base = 10;
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007a8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007ac:	0f 84 71 01 00 00    	je     800923 <vprintfmt+0x428>
				putch('+', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 2b                	push   $0x2b
  8007b8:	ff d6                	call   *%esi
  8007ba:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c2:	e9 5c 01 00 00       	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007cf:	89 c1                	mov    %eax,%ecx
  8007d1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e0:	eb af                	jmp    800791 <vprintfmt+0x296>
				putch('-', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 2d                	push   $0x2d
  8007e8:	ff d6                	call   *%esi
				num = -(long long) num;
  8007ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007f0:	f7 d8                	neg    %eax
  8007f2:	83 d2 00             	adc    $0x0,%edx
  8007f5:	f7 da                	neg    %edx
  8007f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800800:	b8 0a 00 00 00       	mov    $0xa,%eax
  800805:	e9 19 01 00 00       	jmp    800923 <vprintfmt+0x428>
	if (lflag >= 2)
  80080a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80080e:	7f 29                	jg     800839 <vprintfmt+0x33e>
	else if (lflag)
  800810:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800814:	74 44                	je     80085a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	ba 00 00 00 00       	mov    $0x0,%edx
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800834:	e9 ea 00 00 00       	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 50 04             	mov    0x4(%eax),%edx
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 40 08             	lea    0x8(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800850:	b8 0a 00 00 00       	mov    $0xa,%eax
  800855:	e9 c9 00 00 00       	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	ba 00 00 00 00       	mov    $0x0,%edx
  800864:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800867:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800873:	b8 0a 00 00 00       	mov    $0xa,%eax
  800878:	e9 a6 00 00 00       	jmp    800923 <vprintfmt+0x428>
			putch('0', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	6a 30                	push   $0x30
  800883:	ff d6                	call   *%esi
	if (lflag >= 2)
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088c:	7f 26                	jg     8008b4 <vprintfmt+0x3b9>
	else if (lflag)
  80088e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800892:	74 3e                	je     8008d2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8d 40 04             	lea    0x4(%eax),%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b2:	eb 6f                	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8d 40 08             	lea    0x8(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d0:	eb 51                	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f0:	eb 31                	jmp    800923 <vprintfmt+0x428>
			putch('0', putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	53                   	push   %ebx
  8008f6:	6a 30                	push   $0x30
  8008f8:	ff d6                	call   *%esi
			putch('x', putdat);
  8008fa:	83 c4 08             	add    $0x8,%esp
  8008fd:	53                   	push   %ebx
  8008fe:	6a 78                	push   $0x78
  800900:	ff d6                	call   *%esi
			num = (unsigned long long)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	ba 00 00 00 00       	mov    $0x0,%edx
  80090c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800912:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8d 40 04             	lea    0x4(%eax),%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800923:	83 ec 0c             	sub    $0xc,%esp
  800926:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80092a:	52                   	push   %edx
  80092b:	ff 75 e0             	pushl  -0x20(%ebp)
  80092e:	50                   	push   %eax
  80092f:	ff 75 dc             	pushl  -0x24(%ebp)
  800932:	ff 75 d8             	pushl  -0x28(%ebp)
  800935:	89 da                	mov    %ebx,%edx
  800937:	89 f0                	mov    %esi,%eax
  800939:	e8 a4 fa ff ff       	call   8003e2 <printnum>
			break;
  80093e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800941:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800944:	83 c7 01             	add    $0x1,%edi
  800947:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80094b:	83 f8 25             	cmp    $0x25,%eax
  80094e:	0f 84 be fb ff ff    	je     800512 <vprintfmt+0x17>
			if (ch == '\0')
  800954:	85 c0                	test   %eax,%eax
  800956:	0f 84 28 01 00 00    	je     800a84 <vprintfmt+0x589>
			putch(ch, putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	53                   	push   %ebx
  800960:	50                   	push   %eax
  800961:	ff d6                	call   *%esi
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	eb dc                	jmp    800944 <vprintfmt+0x449>
	if (lflag >= 2)
  800968:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80096c:	7f 26                	jg     800994 <vprintfmt+0x499>
	else if (lflag)
  80096e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800972:	74 41                	je     8009b5 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
  80097e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800981:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	8d 40 04             	lea    0x4(%eax),%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098d:	b8 10 00 00 00       	mov    $0x10,%eax
  800992:	eb 8f                	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 40 08             	lea    0x8(%eax),%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b0:	e9 6e ff ff ff       	jmp    800923 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	8d 40 04             	lea    0x4(%eax),%eax
  8009cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d3:	e9 4b ff ff ff       	jmp    800923 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	85 c0                	test   %eax,%eax
  8009e8:	74 14                	je     8009fe <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009ea:	8b 13                	mov    (%ebx),%edx
  8009ec:	83 fa 7f             	cmp    $0x7f,%edx
  8009ef:	7f 37                	jg     800a28 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009f1:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f9:	e9 43 ff ff ff       	jmp    800941 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a03:	bf e9 28 80 00       	mov    $0x8028e9,%edi
							putch(ch, putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	53                   	push   %ebx
  800a0c:	50                   	push   %eax
  800a0d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a0f:	83 c7 01             	add    $0x1,%edi
  800a12:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	85 c0                	test   %eax,%eax
  800a1b:	75 eb                	jne    800a08 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	e9 19 ff ff ff       	jmp    800941 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a28:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2f:	bf 21 29 80 00       	mov    $0x802921,%edi
							putch(ch, putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	53                   	push   %ebx
  800a38:	50                   	push   %eax
  800a39:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a3b:	83 c7 01             	add    $0x1,%edi
  800a3e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	85 c0                	test   %eax,%eax
  800a47:	75 eb                	jne    800a34 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a4c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4f:	e9 ed fe ff ff       	jmp    800941 <vprintfmt+0x446>
			putch(ch, putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	53                   	push   %ebx
  800a58:	6a 25                	push   $0x25
  800a5a:	ff d6                	call   *%esi
			break;
  800a5c:	83 c4 10             	add    $0x10,%esp
  800a5f:	e9 dd fe ff ff       	jmp    800941 <vprintfmt+0x446>
			putch('%', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	53                   	push   %ebx
  800a68:	6a 25                	push   $0x25
  800a6a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	89 f8                	mov    %edi,%eax
  800a71:	eb 03                	jmp    800a76 <vprintfmt+0x57b>
  800a73:	83 e8 01             	sub    $0x1,%eax
  800a76:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a7a:	75 f7                	jne    800a73 <vprintfmt+0x578>
  800a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7f:	e9 bd fe ff ff       	jmp    800941 <vprintfmt+0x446>
}
  800a84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a87:	5b                   	pop    %ebx
  800a88:	5e                   	pop    %esi
  800a89:	5f                   	pop    %edi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 18             	sub    $0x18,%esp
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a9f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa9:	85 c0                	test   %eax,%eax
  800aab:	74 26                	je     800ad3 <vsnprintf+0x47>
  800aad:	85 d2                	test   %edx,%edx
  800aaf:	7e 22                	jle    800ad3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab1:	ff 75 14             	pushl  0x14(%ebp)
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	68 c1 04 80 00       	push   $0x8004c1
  800ac0:	e8 36 fa ff ff       	call   8004fb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ace:	83 c4 10             	add    $0x10,%esp
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    
		return -E_INVAL;
  800ad3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad8:	eb f7                	jmp    800ad1 <vsnprintf+0x45>

00800ada <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 10             	pushl  0x10(%ebp)
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 9a ff ff ff       	call   800a8c <vsnprintf>
	va_end(ap);

	return rc;
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b03:	74 05                	je     800b0a <strlen+0x16>
		n++;
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	eb f5                	jmp    800aff <strlen+0xb>
	return n;
}
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b15:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	74 0d                	je     800b2b <strnlen+0x1f>
  800b1e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b22:	74 05                	je     800b29 <strnlen+0x1d>
		n++;
  800b24:	83 c2 01             	add    $0x1,%edx
  800b27:	eb f1                	jmp    800b1a <strnlen+0xe>
  800b29:	89 d0                	mov    %edx,%eax
	return n;
}
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b37:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b40:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b43:	83 c2 01             	add    $0x1,%edx
  800b46:	84 c9                	test   %cl,%cl
  800b48:	75 f2                	jne    800b3c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	53                   	push   %ebx
  800b51:	83 ec 10             	sub    $0x10,%esp
  800b54:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b57:	53                   	push   %ebx
  800b58:	e8 97 ff ff ff       	call   800af4 <strlen>
  800b5d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	01 d8                	add    %ebx,%eax
  800b65:	50                   	push   %eax
  800b66:	e8 c2 ff ff ff       	call   800b2d <strcpy>
	return dst;
}
  800b6b:	89 d8                	mov    %ebx,%eax
  800b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7d:	89 c6                	mov    %eax,%esi
  800b7f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	39 f2                	cmp    %esi,%edx
  800b86:	74 11                	je     800b99 <strncpy+0x27>
		*dst++ = *src;
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	0f b6 19             	movzbl (%ecx),%ebx
  800b8e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b91:	80 fb 01             	cmp    $0x1,%bl
  800b94:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b97:	eb eb                	jmp    800b84 <strncpy+0x12>
	}
	return ret;
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	8b 55 10             	mov    0x10(%ebp),%edx
  800bab:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bad:	85 d2                	test   %edx,%edx
  800baf:	74 21                	je     800bd2 <strlcpy+0x35>
  800bb1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	74 14                	je     800bcf <strlcpy+0x32>
  800bbb:	0f b6 19             	movzbl (%ecx),%ebx
  800bbe:	84 db                	test   %bl,%bl
  800bc0:	74 0b                	je     800bcd <strlcpy+0x30>
			*dst++ = *src++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcb:	eb ea                	jmp    800bb7 <strlcpy+0x1a>
  800bcd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bcf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd2:	29 f0                	sub    %esi,%eax
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be1:	0f b6 01             	movzbl (%ecx),%eax
  800be4:	84 c0                	test   %al,%al
  800be6:	74 0c                	je     800bf4 <strcmp+0x1c>
  800be8:	3a 02                	cmp    (%edx),%al
  800bea:	75 08                	jne    800bf4 <strcmp+0x1c>
		p++, q++;
  800bec:	83 c1 01             	add    $0x1,%ecx
  800bef:	83 c2 01             	add    $0x1,%edx
  800bf2:	eb ed                	jmp    800be1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf4:	0f b6 c0             	movzbl %al,%eax
  800bf7:	0f b6 12             	movzbl (%edx),%edx
  800bfa:	29 d0                	sub    %edx,%eax
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	53                   	push   %ebx
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c08:	89 c3                	mov    %eax,%ebx
  800c0a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c0d:	eb 06                	jmp    800c15 <strncmp+0x17>
		n--, p++, q++;
  800c0f:	83 c0 01             	add    $0x1,%eax
  800c12:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c15:	39 d8                	cmp    %ebx,%eax
  800c17:	74 16                	je     800c2f <strncmp+0x31>
  800c19:	0f b6 08             	movzbl (%eax),%ecx
  800c1c:	84 c9                	test   %cl,%cl
  800c1e:	74 04                	je     800c24 <strncmp+0x26>
  800c20:	3a 0a                	cmp    (%edx),%cl
  800c22:	74 eb                	je     800c0f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c24:	0f b6 00             	movzbl (%eax),%eax
  800c27:	0f b6 12             	movzbl (%edx),%edx
  800c2a:	29 d0                	sub    %edx,%eax
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    
		return 0;
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	eb f6                	jmp    800c2c <strncmp+0x2e>

00800c36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c40:	0f b6 10             	movzbl (%eax),%edx
  800c43:	84 d2                	test   %dl,%dl
  800c45:	74 09                	je     800c50 <strchr+0x1a>
		if (*s == c)
  800c47:	38 ca                	cmp    %cl,%dl
  800c49:	74 0a                	je     800c55 <strchr+0x1f>
	for (; *s; s++)
  800c4b:	83 c0 01             	add    $0x1,%eax
  800c4e:	eb f0                	jmp    800c40 <strchr+0xa>
			return (char *) s;
	return 0;
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c61:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c64:	38 ca                	cmp    %cl,%dl
  800c66:	74 09                	je     800c71 <strfind+0x1a>
  800c68:	84 d2                	test   %dl,%dl
  800c6a:	74 05                	je     800c71 <strfind+0x1a>
	for (; *s; s++)
  800c6c:	83 c0 01             	add    $0x1,%eax
  800c6f:	eb f0                	jmp    800c61 <strfind+0xa>
			break;
	return (char *) s;
}
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c7f:	85 c9                	test   %ecx,%ecx
  800c81:	74 31                	je     800cb4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c83:	89 f8                	mov    %edi,%eax
  800c85:	09 c8                	or     %ecx,%eax
  800c87:	a8 03                	test   $0x3,%al
  800c89:	75 23                	jne    800cae <memset+0x3b>
		c &= 0xFF;
  800c8b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c8f:	89 d3                	mov    %edx,%ebx
  800c91:	c1 e3 08             	shl    $0x8,%ebx
  800c94:	89 d0                	mov    %edx,%eax
  800c96:	c1 e0 18             	shl    $0x18,%eax
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	c1 e6 10             	shl    $0x10,%esi
  800c9e:	09 f0                	or     %esi,%eax
  800ca0:	09 c2                	or     %eax,%edx
  800ca2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ca4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ca7:	89 d0                	mov    %edx,%eax
  800ca9:	fc                   	cld    
  800caa:	f3 ab                	rep stos %eax,%es:(%edi)
  800cac:	eb 06                	jmp    800cb4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb1:	fc                   	cld    
  800cb2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc9:	39 c6                	cmp    %eax,%esi
  800ccb:	73 32                	jae    800cff <memmove+0x44>
  800ccd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cd0:	39 c2                	cmp    %eax,%edx
  800cd2:	76 2b                	jbe    800cff <memmove+0x44>
		s += n;
		d += n;
  800cd4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd7:	89 fe                	mov    %edi,%esi
  800cd9:	09 ce                	or     %ecx,%esi
  800cdb:	09 d6                	or     %edx,%esi
  800cdd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce3:	75 0e                	jne    800cf3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ce5:	83 ef 04             	sub    $0x4,%edi
  800ce8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ceb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cee:	fd                   	std    
  800cef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf1:	eb 09                	jmp    800cfc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cf3:	83 ef 01             	sub    $0x1,%edi
  800cf6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cf9:	fd                   	std    
  800cfa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cfc:	fc                   	cld    
  800cfd:	eb 1a                	jmp    800d19 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	09 ca                	or     %ecx,%edx
  800d03:	09 f2                	or     %esi,%edx
  800d05:	f6 c2 03             	test   $0x3,%dl
  800d08:	75 0a                	jne    800d14 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d0d:	89 c7                	mov    %eax,%edi
  800d0f:	fc                   	cld    
  800d10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d12:	eb 05                	jmp    800d19 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d14:	89 c7                	mov    %eax,%edi
  800d16:	fc                   	cld    
  800d17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d23:	ff 75 10             	pushl  0x10(%ebp)
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	ff 75 08             	pushl  0x8(%ebp)
  800d2c:	e8 8a ff ff ff       	call   800cbb <memmove>
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	89 c6                	mov    %eax,%esi
  800d40:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d43:	39 f0                	cmp    %esi,%eax
  800d45:	74 1c                	je     800d63 <memcmp+0x30>
		if (*s1 != *s2)
  800d47:	0f b6 08             	movzbl (%eax),%ecx
  800d4a:	0f b6 1a             	movzbl (%edx),%ebx
  800d4d:	38 d9                	cmp    %bl,%cl
  800d4f:	75 08                	jne    800d59 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d51:	83 c0 01             	add    $0x1,%eax
  800d54:	83 c2 01             	add    $0x1,%edx
  800d57:	eb ea                	jmp    800d43 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d59:	0f b6 c1             	movzbl %cl,%eax
  800d5c:	0f b6 db             	movzbl %bl,%ebx
  800d5f:	29 d8                	sub    %ebx,%eax
  800d61:	eb 05                	jmp    800d68 <memcmp+0x35>
	}

	return 0;
  800d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d75:	89 c2                	mov    %eax,%edx
  800d77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d7a:	39 d0                	cmp    %edx,%eax
  800d7c:	73 09                	jae    800d87 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d7e:	38 08                	cmp    %cl,(%eax)
  800d80:	74 05                	je     800d87 <memfind+0x1b>
	for (; s < ends; s++)
  800d82:	83 c0 01             	add    $0x1,%eax
  800d85:	eb f3                	jmp    800d7a <memfind+0xe>
			break;
	return (void *) s;
}
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d95:	eb 03                	jmp    800d9a <strtol+0x11>
		s++;
  800d97:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d9a:	0f b6 01             	movzbl (%ecx),%eax
  800d9d:	3c 20                	cmp    $0x20,%al
  800d9f:	74 f6                	je     800d97 <strtol+0xe>
  800da1:	3c 09                	cmp    $0x9,%al
  800da3:	74 f2                	je     800d97 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800da5:	3c 2b                	cmp    $0x2b,%al
  800da7:	74 2a                	je     800dd3 <strtol+0x4a>
	int neg = 0;
  800da9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dae:	3c 2d                	cmp    $0x2d,%al
  800db0:	74 2b                	je     800ddd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800db8:	75 0f                	jne    800dc9 <strtol+0x40>
  800dba:	80 39 30             	cmpb   $0x30,(%ecx)
  800dbd:	74 28                	je     800de7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dbf:	85 db                	test   %ebx,%ebx
  800dc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc6:	0f 44 d8             	cmove  %eax,%ebx
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd1:	eb 50                	jmp    800e23 <strtol+0x9a>
		s++;
  800dd3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dd6:	bf 00 00 00 00       	mov    $0x0,%edi
  800ddb:	eb d5                	jmp    800db2 <strtol+0x29>
		s++, neg = 1;
  800ddd:	83 c1 01             	add    $0x1,%ecx
  800de0:	bf 01 00 00 00       	mov    $0x1,%edi
  800de5:	eb cb                	jmp    800db2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800deb:	74 0e                	je     800dfb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ded:	85 db                	test   %ebx,%ebx
  800def:	75 d8                	jne    800dc9 <strtol+0x40>
		s++, base = 8;
  800df1:	83 c1 01             	add    $0x1,%ecx
  800df4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800df9:	eb ce                	jmp    800dc9 <strtol+0x40>
		s += 2, base = 16;
  800dfb:	83 c1 02             	add    $0x2,%ecx
  800dfe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e03:	eb c4                	jmp    800dc9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e05:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e08:	89 f3                	mov    %esi,%ebx
  800e0a:	80 fb 19             	cmp    $0x19,%bl
  800e0d:	77 29                	ja     800e38 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e0f:	0f be d2             	movsbl %dl,%edx
  800e12:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e15:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e18:	7d 30                	jge    800e4a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e1a:	83 c1 01             	add    $0x1,%ecx
  800e1d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e23:	0f b6 11             	movzbl (%ecx),%edx
  800e26:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e29:	89 f3                	mov    %esi,%ebx
  800e2b:	80 fb 09             	cmp    $0x9,%bl
  800e2e:	77 d5                	ja     800e05 <strtol+0x7c>
			dig = *s - '0';
  800e30:	0f be d2             	movsbl %dl,%edx
  800e33:	83 ea 30             	sub    $0x30,%edx
  800e36:	eb dd                	jmp    800e15 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e38:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e3b:	89 f3                	mov    %esi,%ebx
  800e3d:	80 fb 19             	cmp    $0x19,%bl
  800e40:	77 08                	ja     800e4a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e42:	0f be d2             	movsbl %dl,%edx
  800e45:	83 ea 37             	sub    $0x37,%edx
  800e48:	eb cb                	jmp    800e15 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4e:	74 05                	je     800e55 <strtol+0xcc>
		*endptr = (char *) s;
  800e50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e53:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e55:	89 c2                	mov    %eax,%edx
  800e57:	f7 da                	neg    %edx
  800e59:	85 ff                	test   %edi,%edi
  800e5b:	0f 45 c2             	cmovne %edx,%eax
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	89 c3                	mov    %eax,%ebx
  800e76:	89 c7                	mov    %eax,%edi
  800e78:	89 c6                	mov    %eax,%esi
  800e7a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e87:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  800e91:	89 d1                	mov    %edx,%ecx
  800e93:	89 d3                	mov    %edx,%ebx
  800e95:	89 d7                	mov    %edx,%edi
  800e97:	89 d6                	mov    %edx,%esi
  800e99:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 03                	push   $0x3
  800ed0:	68 40 2b 80 00       	push   $0x802b40
  800ed5:	6a 43                	push   $0x43
  800ed7:	68 5d 2b 80 00       	push   $0x802b5d
  800edc:	e8 f7 f3 ff ff       	call   8002d8 <_panic>

00800ee1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  800eec:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef1:	89 d1                	mov    %edx,%ecx
  800ef3:	89 d3                	mov    %edx,%ebx
  800ef5:	89 d7                	mov    %edx,%edi
  800ef7:	89 d6                	mov    %edx,%esi
  800ef9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800efb:	5b                   	pop    %ebx
  800efc:	5e                   	pop    %esi
  800efd:	5f                   	pop    %edi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_yield>:

void
sys_yield(void)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f06:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f10:	89 d1                	mov    %edx,%ecx
  800f12:	89 d3                	mov    %edx,%ebx
  800f14:	89 d7                	mov    %edx,%edi
  800f16:	89 d6                	mov    %edx,%esi
  800f18:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f28:	be 00 00 00 00       	mov    $0x0,%esi
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	b8 04 00 00 00       	mov    $0x4,%eax
  800f38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3b:	89 f7                	mov    %esi,%edi
  800f3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7f 08                	jg     800f4b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	50                   	push   %eax
  800f4f:	6a 04                	push   $0x4
  800f51:	68 40 2b 80 00       	push   $0x802b40
  800f56:	6a 43                	push   $0x43
  800f58:	68 5d 2b 80 00       	push   $0x802b5d
  800f5d:	e8 76 f3 ff ff       	call   8002d8 <_panic>

00800f62 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	b8 05 00 00 00       	mov    $0x5,%eax
  800f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7c:	8b 75 18             	mov    0x18(%ebp),%esi
  800f7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7f 08                	jg     800f8d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	50                   	push   %eax
  800f91:	6a 05                	push   $0x5
  800f93:	68 40 2b 80 00       	push   $0x802b40
  800f98:	6a 43                	push   $0x43
  800f9a:	68 5d 2b 80 00       	push   $0x802b5d
  800f9f:	e8 34 f3 ff ff       	call   8002d8 <_panic>

00800fa4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800fbd:	89 df                	mov    %ebx,%edi
  800fbf:	89 de                	mov    %ebx,%esi
  800fc1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	7f 08                	jg     800fcf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	50                   	push   %eax
  800fd3:	6a 06                	push   $0x6
  800fd5:	68 40 2b 80 00       	push   $0x802b40
  800fda:	6a 43                	push   $0x43
  800fdc:	68 5d 2b 80 00       	push   $0x802b5d
  800fe1:	e8 f2 f2 ff ff       	call   8002d8 <_panic>

00800fe6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	b8 08 00 00 00       	mov    $0x8,%eax
  800fff:	89 df                	mov    %ebx,%edi
  801001:	89 de                	mov    %ebx,%esi
  801003:	cd 30                	int    $0x30
	if(check && ret > 0)
  801005:	85 c0                	test   %eax,%eax
  801007:	7f 08                	jg     801011 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801009:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	50                   	push   %eax
  801015:	6a 08                	push   $0x8
  801017:	68 40 2b 80 00       	push   $0x802b40
  80101c:	6a 43                	push   $0x43
  80101e:	68 5d 2b 80 00       	push   $0x802b5d
  801023:	e8 b0 f2 ff ff       	call   8002d8 <_panic>

00801028 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801031:	bb 00 00 00 00       	mov    $0x0,%ebx
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103c:	b8 09 00 00 00       	mov    $0x9,%eax
  801041:	89 df                	mov    %ebx,%edi
  801043:	89 de                	mov    %ebx,%esi
  801045:	cd 30                	int    $0x30
	if(check && ret > 0)
  801047:	85 c0                	test   %eax,%eax
  801049:	7f 08                	jg     801053 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801053:	83 ec 0c             	sub    $0xc,%esp
  801056:	50                   	push   %eax
  801057:	6a 09                	push   $0x9
  801059:	68 40 2b 80 00       	push   $0x802b40
  80105e:	6a 43                	push   $0x43
  801060:	68 5d 2b 80 00       	push   $0x802b5d
  801065:	e8 6e f2 ff ff       	call   8002d8 <_panic>

0080106a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801073:	bb 00 00 00 00       	mov    $0x0,%ebx
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801083:	89 df                	mov    %ebx,%edi
  801085:	89 de                	mov    %ebx,%esi
  801087:	cd 30                	int    $0x30
	if(check && ret > 0)
  801089:	85 c0                	test   %eax,%eax
  80108b:	7f 08                	jg     801095 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	50                   	push   %eax
  801099:	6a 0a                	push   $0xa
  80109b:	68 40 2b 80 00       	push   $0x802b40
  8010a0:	6a 43                	push   $0x43
  8010a2:	68 5d 2b 80 00       	push   $0x802b5d
  8010a7:	e8 2c f2 ff ff       	call   8002d8 <_panic>

008010ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010bd:	be 00 00 00 00       	mov    $0x0,%esi
  8010c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	57                   	push   %edi
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
  8010d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e5:	89 cb                	mov    %ecx,%ebx
  8010e7:	89 cf                	mov    %ecx,%edi
  8010e9:	89 ce                	mov    %ecx,%esi
  8010eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	7f 08                	jg     8010f9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f9:	83 ec 0c             	sub    $0xc,%esp
  8010fc:	50                   	push   %eax
  8010fd:	6a 0d                	push   $0xd
  8010ff:	68 40 2b 80 00       	push   $0x802b40
  801104:	6a 43                	push   $0x43
  801106:	68 5d 2b 80 00       	push   $0x802b5d
  80110b:	e8 c8 f1 ff ff       	call   8002d8 <_panic>

00801110 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
	asm volatile("int %1\n"
  801116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111b:	8b 55 08             	mov    0x8(%ebp),%edx
  80111e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801121:	b8 0e 00 00 00       	mov    $0xe,%eax
  801126:	89 df                	mov    %ebx,%edi
  801128:	89 de                	mov    %ebx,%esi
  80112a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
	asm volatile("int %1\n"
  801137:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801144:	89 cb                	mov    %ecx,%ebx
  801146:	89 cf                	mov    %ecx,%edi
  801148:	89 ce                	mov    %ecx,%esi
  80114a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	53                   	push   %ebx
  801155:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801158:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80115f:	83 e1 07             	and    $0x7,%ecx
  801162:	83 f9 07             	cmp    $0x7,%ecx
  801165:	74 32                	je     801199 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801167:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80116e:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801174:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80117a:	74 7d                	je     8011f9 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80117c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801183:	83 e1 05             	and    $0x5,%ecx
  801186:	83 f9 05             	cmp    $0x5,%ecx
  801189:	0f 84 9e 00 00 00    	je     80122d <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80118f:	b8 00 00 00 00       	mov    $0x0,%eax
  801194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801197:	c9                   	leave  
  801198:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801199:	89 d3                	mov    %edx,%ebx
  80119b:	c1 e3 0c             	shl    $0xc,%ebx
  80119e:	83 ec 0c             	sub    $0xc,%esp
  8011a1:	68 05 08 00 00       	push   $0x805
  8011a6:	53                   	push   %ebx
  8011a7:	50                   	push   %eax
  8011a8:	53                   	push   %ebx
  8011a9:	6a 00                	push   $0x0
  8011ab:	e8 b2 fd ff ff       	call   800f62 <sys_page_map>
		if(r < 0)
  8011b0:	83 c4 20             	add    $0x20,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 2e                	js     8011e5 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011b7:	83 ec 0c             	sub    $0xc,%esp
  8011ba:	68 05 08 00 00       	push   $0x805
  8011bf:	53                   	push   %ebx
  8011c0:	6a 00                	push   $0x0
  8011c2:	53                   	push   %ebx
  8011c3:	6a 00                	push   $0x0
  8011c5:	e8 98 fd ff ff       	call   800f62 <sys_page_map>
		if(r < 0)
  8011ca:	83 c4 20             	add    $0x20,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	79 be                	jns    80118f <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	68 6b 2b 80 00       	push   $0x802b6b
  8011d9:	6a 57                	push   $0x57
  8011db:	68 81 2b 80 00       	push   $0x802b81
  8011e0:	e8 f3 f0 ff ff       	call   8002d8 <_panic>
			panic("sys_page_map() panic\n");
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	68 6b 2b 80 00       	push   $0x802b6b
  8011ed:	6a 53                	push   $0x53
  8011ef:	68 81 2b 80 00       	push   $0x802b81
  8011f4:	e8 df f0 ff ff       	call   8002d8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011f9:	c1 e2 0c             	shl    $0xc,%edx
  8011fc:	83 ec 0c             	sub    $0xc,%esp
  8011ff:	68 05 08 00 00       	push   $0x805
  801204:	52                   	push   %edx
  801205:	50                   	push   %eax
  801206:	52                   	push   %edx
  801207:	6a 00                	push   $0x0
  801209:	e8 54 fd ff ff       	call   800f62 <sys_page_map>
		if(r < 0)
  80120e:	83 c4 20             	add    $0x20,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	0f 89 76 ff ff ff    	jns    80118f <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	68 6b 2b 80 00       	push   $0x802b6b
  801221:	6a 5e                	push   $0x5e
  801223:	68 81 2b 80 00       	push   $0x802b81
  801228:	e8 ab f0 ff ff       	call   8002d8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80122d:	c1 e2 0c             	shl    $0xc,%edx
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	6a 05                	push   $0x5
  801235:	52                   	push   %edx
  801236:	50                   	push   %eax
  801237:	52                   	push   %edx
  801238:	6a 00                	push   $0x0
  80123a:	e8 23 fd ff ff       	call   800f62 <sys_page_map>
		if(r < 0)
  80123f:	83 c4 20             	add    $0x20,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	0f 89 45 ff ff ff    	jns    80118f <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80124a:	83 ec 04             	sub    $0x4,%esp
  80124d:	68 6b 2b 80 00       	push   $0x802b6b
  801252:	6a 65                	push   $0x65
  801254:	68 81 2b 80 00       	push   $0x802b81
  801259:	e8 7a f0 ff ff       	call   8002d8 <_panic>

0080125e <pgfault>:
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	53                   	push   %ebx
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801268:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80126a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80126e:	0f 84 99 00 00 00    	je     80130d <pgfault+0xaf>
  801274:	89 c2                	mov    %eax,%edx
  801276:	c1 ea 16             	shr    $0x16,%edx
  801279:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801280:	f6 c2 01             	test   $0x1,%dl
  801283:	0f 84 84 00 00 00    	je     80130d <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801289:	89 c2                	mov    %eax,%edx
  80128b:	c1 ea 0c             	shr    $0xc,%edx
  80128e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801295:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80129b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012a1:	75 6a                	jne    80130d <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a8:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	6a 07                	push   $0x7
  8012af:	68 00 f0 7f 00       	push   $0x7ff000
  8012b4:	6a 00                	push   $0x0
  8012b6:	e8 64 fc ff ff       	call   800f1f <sys_page_alloc>
	if(ret < 0)
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 5f                	js     801321 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	68 00 10 00 00       	push   $0x1000
  8012ca:	53                   	push   %ebx
  8012cb:	68 00 f0 7f 00       	push   $0x7ff000
  8012d0:	e8 48 fa ff ff       	call   800d1d <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012d5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012dc:	53                   	push   %ebx
  8012dd:	6a 00                	push   $0x0
  8012df:	68 00 f0 7f 00       	push   $0x7ff000
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 77 fc ff ff       	call   800f62 <sys_page_map>
	if(ret < 0)
  8012eb:	83 c4 20             	add    $0x20,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 43                	js     801335 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	68 00 f0 7f 00       	push   $0x7ff000
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 a3 fc ff ff       	call   800fa4 <sys_page_unmap>
	if(ret < 0)
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 41                	js     801349 <pgfault+0xeb>
}
  801308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    
		panic("panic at pgfault()\n");
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	68 8c 2b 80 00       	push   $0x802b8c
  801315:	6a 26                	push   $0x26
  801317:	68 81 2b 80 00       	push   $0x802b81
  80131c:	e8 b7 ef ff ff       	call   8002d8 <_panic>
		panic("panic in sys_page_alloc()\n");
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	68 a0 2b 80 00       	push   $0x802ba0
  801329:	6a 31                	push   $0x31
  80132b:	68 81 2b 80 00       	push   $0x802b81
  801330:	e8 a3 ef ff ff       	call   8002d8 <_panic>
		panic("panic in sys_page_map()\n");
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	68 bb 2b 80 00       	push   $0x802bbb
  80133d:	6a 36                	push   $0x36
  80133f:	68 81 2b 80 00       	push   $0x802b81
  801344:	e8 8f ef ff ff       	call   8002d8 <_panic>
		panic("panic in sys_page_unmap()\n");
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 d4 2b 80 00       	push   $0x802bd4
  801351:	6a 39                	push   $0x39
  801353:	68 81 2b 80 00       	push   $0x802b81
  801358:	e8 7b ef ff ff       	call   8002d8 <_panic>

0080135d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	57                   	push   %edi
  801361:	56                   	push   %esi
  801362:	53                   	push   %ebx
  801363:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801366:	68 5e 12 80 00       	push   $0x80125e
  80136b:	e8 1c 0f 00 00       	call   80228c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801370:	b8 07 00 00 00       	mov    $0x7,%eax
  801375:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 27                	js     8013a5 <fork+0x48>
  80137e:	89 c6                	mov    %eax,%esi
  801380:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801382:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801387:	75 48                	jne    8013d1 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801389:	e8 53 fb ff ff       	call   800ee1 <sys_getenvid>
  80138e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801393:	c1 e0 07             	shl    $0x7,%eax
  801396:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80139b:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8013a0:	e9 90 00 00 00       	jmp    801435 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	68 f0 2b 80 00       	push   $0x802bf0
  8013ad:	68 85 00 00 00       	push   $0x85
  8013b2:	68 81 2b 80 00       	push   $0x802b81
  8013b7:	e8 1c ef ff ff       	call   8002d8 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013bc:	89 f8                	mov    %edi,%eax
  8013be:	e8 8e fd ff ff       	call   801151 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013c9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013cf:	74 26                	je     8013f7 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013d1:	89 d8                	mov    %ebx,%eax
  8013d3:	c1 e8 16             	shr    $0x16,%eax
  8013d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013dd:	a8 01                	test   $0x1,%al
  8013df:	74 e2                	je     8013c3 <fork+0x66>
  8013e1:	89 da                	mov    %ebx,%edx
  8013e3:	c1 ea 0c             	shr    $0xc,%edx
  8013e6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013ed:	83 e0 05             	and    $0x5,%eax
  8013f0:	83 f8 05             	cmp    $0x5,%eax
  8013f3:	75 ce                	jne    8013c3 <fork+0x66>
  8013f5:	eb c5                	jmp    8013bc <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	6a 07                	push   $0x7
  8013fc:	68 00 f0 bf ee       	push   $0xeebff000
  801401:	56                   	push   %esi
  801402:	e8 18 fb ff ff       	call   800f1f <sys_page_alloc>
	if(ret < 0)
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 31                	js     80143f <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	68 fb 22 80 00       	push   $0x8022fb
  801416:	56                   	push   %esi
  801417:	e8 4e fc ff ff       	call   80106a <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 33                	js     801456 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	6a 02                	push   $0x2
  801428:	56                   	push   %esi
  801429:	e8 b8 fb ff ff       	call   800fe6 <sys_env_set_status>
	if(ret < 0)
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 38                	js     80146d <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801435:	89 f0                	mov    %esi,%eax
  801437:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 a0 2b 80 00       	push   $0x802ba0
  801447:	68 91 00 00 00       	push   $0x91
  80144c:	68 81 2b 80 00       	push   $0x802b81
  801451:	e8 82 ee ff ff       	call   8002d8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 14 2c 80 00       	push   $0x802c14
  80145e:	68 94 00 00 00       	push   $0x94
  801463:	68 81 2b 80 00       	push   $0x802b81
  801468:	e8 6b ee ff ff       	call   8002d8 <_panic>
		panic("panic in sys_env_set_status()\n");
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	68 3c 2c 80 00       	push   $0x802c3c
  801475:	68 97 00 00 00       	push   $0x97
  80147a:	68 81 2b 80 00       	push   $0x802b81
  80147f:	e8 54 ee ff ff       	call   8002d8 <_panic>

00801484 <sfork>:

// Challenge!
int
sfork(void)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80148d:	a1 04 40 80 00       	mov    0x804004,%eax
  801492:	8b 40 48             	mov    0x48(%eax),%eax
  801495:	68 5c 2c 80 00       	push   $0x802c5c
  80149a:	50                   	push   %eax
  80149b:	68 7a 27 80 00       	push   $0x80277a
  8014a0:	e8 29 ef ff ff       	call   8003ce <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014a5:	c7 04 24 5e 12 80 00 	movl   $0x80125e,(%esp)
  8014ac:	e8 db 0d 00 00       	call   80228c <set_pgfault_handler>
  8014b1:	b8 07 00 00 00       	mov    $0x7,%eax
  8014b6:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 27                	js     8014e6 <sfork+0x62>
  8014bf:	89 c7                	mov    %eax,%edi
  8014c1:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014c8:	75 55                	jne    80151f <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014ca:	e8 12 fa ff ff       	call   800ee1 <sys_getenvid>
  8014cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014d4:	c1 e0 07             	shl    $0x7,%eax
  8014d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014dc:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8014e1:	e9 d4 00 00 00       	jmp    8015ba <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  8014e6:	83 ec 04             	sub    $0x4,%esp
  8014e9:	68 f0 2b 80 00       	push   $0x802bf0
  8014ee:	68 a9 00 00 00       	push   $0xa9
  8014f3:	68 81 2b 80 00       	push   $0x802b81
  8014f8:	e8 db ed ff ff       	call   8002d8 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014fd:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801502:	89 f0                	mov    %esi,%eax
  801504:	e8 48 fc ff ff       	call   801151 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801509:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80150f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801515:	77 65                	ja     80157c <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  801517:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80151d:	74 de                	je     8014fd <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80151f:	89 d8                	mov    %ebx,%eax
  801521:	c1 e8 16             	shr    $0x16,%eax
  801524:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80152b:	a8 01                	test   $0x1,%al
  80152d:	74 da                	je     801509 <sfork+0x85>
  80152f:	89 da                	mov    %ebx,%edx
  801531:	c1 ea 0c             	shr    $0xc,%edx
  801534:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80153b:	83 e0 05             	and    $0x5,%eax
  80153e:	83 f8 05             	cmp    $0x5,%eax
  801541:	75 c6                	jne    801509 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801543:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80154a:	c1 e2 0c             	shl    $0xc,%edx
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	83 e0 07             	and    $0x7,%eax
  801553:	50                   	push   %eax
  801554:	52                   	push   %edx
  801555:	56                   	push   %esi
  801556:	52                   	push   %edx
  801557:	6a 00                	push   $0x0
  801559:	e8 04 fa ff ff       	call   800f62 <sys_page_map>
  80155e:	83 c4 20             	add    $0x20,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	74 a4                	je     801509 <sfork+0x85>
				panic("sys_page_map() panic\n");
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	68 6b 2b 80 00       	push   $0x802b6b
  80156d:	68 b4 00 00 00       	push   $0xb4
  801572:	68 81 2b 80 00       	push   $0x802b81
  801577:	e8 5c ed ff ff       	call   8002d8 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	6a 07                	push   $0x7
  801581:	68 00 f0 bf ee       	push   $0xeebff000
  801586:	57                   	push   %edi
  801587:	e8 93 f9 ff ff       	call   800f1f <sys_page_alloc>
	if(ret < 0)
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 31                	js     8015c4 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	68 fb 22 80 00       	push   $0x8022fb
  80159b:	57                   	push   %edi
  80159c:	e8 c9 fa ff ff       	call   80106a <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 33                	js     8015db <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	6a 02                	push   $0x2
  8015ad:	57                   	push   %edi
  8015ae:	e8 33 fa ff ff       	call   800fe6 <sys_env_set_status>
	if(ret < 0)
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 38                	js     8015f2 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015ba:	89 f8                	mov    %edi,%eax
  8015bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5f                   	pop    %edi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 a0 2b 80 00       	push   $0x802ba0
  8015cc:	68 ba 00 00 00       	push   $0xba
  8015d1:	68 81 2b 80 00       	push   $0x802b81
  8015d6:	e8 fd ec ff ff       	call   8002d8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 14 2c 80 00       	push   $0x802c14
  8015e3:	68 bd 00 00 00       	push   $0xbd
  8015e8:	68 81 2b 80 00       	push   $0x802b81
  8015ed:	e8 e6 ec ff ff       	call   8002d8 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 3c 2c 80 00       	push   $0x802c3c
  8015fa:	68 c0 00 00 00       	push   $0xc0
  8015ff:	68 81 2b 80 00       	push   $0x802b81
  801604:	e8 cf ec ff ff       	call   8002d8 <_panic>

00801609 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	05 00 00 00 30       	add    $0x30000000,%eax
  801614:	c1 e8 0c             	shr    $0xc,%eax
}
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801624:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801629:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801638:	89 c2                	mov    %eax,%edx
  80163a:	c1 ea 16             	shr    $0x16,%edx
  80163d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801644:	f6 c2 01             	test   $0x1,%dl
  801647:	74 2d                	je     801676 <fd_alloc+0x46>
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 ea 0c             	shr    $0xc,%edx
  80164e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 1c                	je     801676 <fd_alloc+0x46>
  80165a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80165f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801664:	75 d2                	jne    801638 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80166f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801674:	eb 0a                	jmp    801680 <fd_alloc+0x50>
			*fd_store = fd;
  801676:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801679:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801688:	83 f8 1f             	cmp    $0x1f,%eax
  80168b:	77 30                	ja     8016bd <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80168d:	c1 e0 0c             	shl    $0xc,%eax
  801690:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801695:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80169b:	f6 c2 01             	test   $0x1,%dl
  80169e:	74 24                	je     8016c4 <fd_lookup+0x42>
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	c1 ea 0c             	shr    $0xc,%edx
  8016a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ac:	f6 c2 01             	test   $0x1,%dl
  8016af:	74 1a                	je     8016cb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	89 02                	mov    %eax,(%edx)
	return 0;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    
		return -E_INVAL;
  8016bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c2:	eb f7                	jmp    8016bb <fd_lookup+0x39>
		return -E_INVAL;
  8016c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c9:	eb f0                	jmp    8016bb <fd_lookup+0x39>
  8016cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d0:	eb e9                	jmp    8016bb <fd_lookup+0x39>

008016d2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016db:	ba e0 2c 80 00       	mov    $0x802ce0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016e5:	39 08                	cmp    %ecx,(%eax)
  8016e7:	74 33                	je     80171c <dev_lookup+0x4a>
  8016e9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8016ec:	8b 02                	mov    (%edx),%eax
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	75 f3                	jne    8016e5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016f2:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f7:	8b 40 48             	mov    0x48(%eax),%eax
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	51                   	push   %ecx
  8016fe:	50                   	push   %eax
  8016ff:	68 64 2c 80 00       	push   $0x802c64
  801704:	e8 c5 ec ff ff       	call   8003ce <cprintf>
	*dev = 0;
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    
			*dev = devtab[i];
  80171c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
  801726:	eb f2                	jmp    80171a <dev_lookup+0x48>

00801728 <fd_close>:
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	57                   	push   %edi
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	83 ec 24             	sub    $0x24,%esp
  801731:	8b 75 08             	mov    0x8(%ebp),%esi
  801734:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801737:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80173a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80173b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801741:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801744:	50                   	push   %eax
  801745:	e8 38 ff ff ff       	call   801682 <fd_lookup>
  80174a:	89 c3                	mov    %eax,%ebx
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 05                	js     801758 <fd_close+0x30>
	    || fd != fd2)
  801753:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801756:	74 16                	je     80176e <fd_close+0x46>
		return (must_exist ? r : 0);
  801758:	89 f8                	mov    %edi,%eax
  80175a:	84 c0                	test   %al,%al
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
  801761:	0f 44 d8             	cmove  %eax,%ebx
}
  801764:	89 d8                	mov    %ebx,%eax
  801766:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801769:	5b                   	pop    %ebx
  80176a:	5e                   	pop    %esi
  80176b:	5f                   	pop    %edi
  80176c:	5d                   	pop    %ebp
  80176d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	ff 36                	pushl  (%esi)
  801777:	e8 56 ff ff ff       	call   8016d2 <dev_lookup>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	78 1a                	js     80179f <fd_close+0x77>
		if (dev->dev_close)
  801785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801788:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80178b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801790:	85 c0                	test   %eax,%eax
  801792:	74 0b                	je     80179f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	56                   	push   %esi
  801798:	ff d0                	call   *%eax
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	56                   	push   %esi
  8017a3:	6a 00                	push   $0x0
  8017a5:	e8 fa f7 ff ff       	call   800fa4 <sys_page_unmap>
	return r;
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	eb b5                	jmp    801764 <fd_close+0x3c>

008017af <close>:

int
close(int fdnum)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b8:	50                   	push   %eax
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	e8 c1 fe ff ff       	call   801682 <fd_lookup>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	79 02                	jns    8017ca <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
		return fd_close(fd, 1);
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	6a 01                	push   $0x1
  8017cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d2:	e8 51 ff ff ff       	call   801728 <fd_close>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	eb ec                	jmp    8017c8 <close+0x19>

008017dc <close_all>:

void
close_all(void)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017e3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017e8:	83 ec 0c             	sub    $0xc,%esp
  8017eb:	53                   	push   %ebx
  8017ec:	e8 be ff ff ff       	call   8017af <close>
	for (i = 0; i < MAXFD; i++)
  8017f1:	83 c3 01             	add    $0x1,%ebx
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	83 fb 20             	cmp    $0x20,%ebx
  8017fa:	75 ec                	jne    8017e8 <close_all+0xc>
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	57                   	push   %edi
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80180a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	e8 6c fe ff ff       	call   801682 <fd_lookup>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	0f 88 81 00 00 00    	js     8018a4 <dup+0xa3>
		return r;
	close(newfdnum);
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	e8 81 ff ff ff       	call   8017af <close>

	newfd = INDEX2FD(newfdnum);
  80182e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801831:	c1 e6 0c             	shl    $0xc,%esi
  801834:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80183a:	83 c4 04             	add    $0x4,%esp
  80183d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801840:	e8 d4 fd ff ff       	call   801619 <fd2data>
  801845:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801847:	89 34 24             	mov    %esi,(%esp)
  80184a:	e8 ca fd ff ff       	call   801619 <fd2data>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801854:	89 d8                	mov    %ebx,%eax
  801856:	c1 e8 16             	shr    $0x16,%eax
  801859:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801860:	a8 01                	test   $0x1,%al
  801862:	74 11                	je     801875 <dup+0x74>
  801864:	89 d8                	mov    %ebx,%eax
  801866:	c1 e8 0c             	shr    $0xc,%eax
  801869:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801870:	f6 c2 01             	test   $0x1,%dl
  801873:	75 39                	jne    8018ae <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801875:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	c1 e8 0c             	shr    $0xc,%eax
  80187d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801884:	83 ec 0c             	sub    $0xc,%esp
  801887:	25 07 0e 00 00       	and    $0xe07,%eax
  80188c:	50                   	push   %eax
  80188d:	56                   	push   %esi
  80188e:	6a 00                	push   $0x0
  801890:	52                   	push   %edx
  801891:	6a 00                	push   $0x0
  801893:	e8 ca f6 ff ff       	call   800f62 <sys_page_map>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 20             	add    $0x20,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 31                	js     8018d2 <dup+0xd1>
		goto err;

	return newfdnum;
  8018a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5f                   	pop    %edi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b5:	83 ec 0c             	sub    $0xc,%esp
  8018b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8018bd:	50                   	push   %eax
  8018be:	57                   	push   %edi
  8018bf:	6a 00                	push   $0x0
  8018c1:	53                   	push   %ebx
  8018c2:	6a 00                	push   $0x0
  8018c4:	e8 99 f6 ff ff       	call   800f62 <sys_page_map>
  8018c9:	89 c3                	mov    %eax,%ebx
  8018cb:	83 c4 20             	add    $0x20,%esp
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	79 a3                	jns    801875 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018d2:	83 ec 08             	sub    $0x8,%esp
  8018d5:	56                   	push   %esi
  8018d6:	6a 00                	push   $0x0
  8018d8:	e8 c7 f6 ff ff       	call   800fa4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018dd:	83 c4 08             	add    $0x8,%esp
  8018e0:	57                   	push   %edi
  8018e1:	6a 00                	push   $0x0
  8018e3:	e8 bc f6 ff ff       	call   800fa4 <sys_page_unmap>
	return r;
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb b7                	jmp    8018a4 <dup+0xa3>

008018ed <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	53                   	push   %ebx
  8018f1:	83 ec 1c             	sub    $0x1c,%esp
  8018f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fa:	50                   	push   %eax
  8018fb:	53                   	push   %ebx
  8018fc:	e8 81 fd ff ff       	call   801682 <fd_lookup>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 3f                	js     801947 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	ff 30                	pushl  (%eax)
  801914:	e8 b9 fd ff ff       	call   8016d2 <dev_lookup>
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 27                	js     801947 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801920:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801923:	8b 42 08             	mov    0x8(%edx),%eax
  801926:	83 e0 03             	and    $0x3,%eax
  801929:	83 f8 01             	cmp    $0x1,%eax
  80192c:	74 1e                	je     80194c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801931:	8b 40 08             	mov    0x8(%eax),%eax
  801934:	85 c0                	test   %eax,%eax
  801936:	74 35                	je     80196d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	ff 75 10             	pushl  0x10(%ebp)
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	52                   	push   %edx
  801942:	ff d0                	call   *%eax
  801944:	83 c4 10             	add    $0x10,%esp
}
  801947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80194c:	a1 04 40 80 00       	mov    0x804004,%eax
  801951:	8b 40 48             	mov    0x48(%eax),%eax
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	53                   	push   %ebx
  801958:	50                   	push   %eax
  801959:	68 a5 2c 80 00       	push   $0x802ca5
  80195e:	e8 6b ea ff ff       	call   8003ce <cprintf>
		return -E_INVAL;
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80196b:	eb da                	jmp    801947 <read+0x5a>
		return -E_NOT_SUPP;
  80196d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801972:	eb d3                	jmp    801947 <read+0x5a>

00801974 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	57                   	push   %edi
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	83 ec 0c             	sub    $0xc,%esp
  80197d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801980:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801983:	bb 00 00 00 00       	mov    $0x0,%ebx
  801988:	39 f3                	cmp    %esi,%ebx
  80198a:	73 23                	jae    8019af <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	89 f0                	mov    %esi,%eax
  801991:	29 d8                	sub    %ebx,%eax
  801993:	50                   	push   %eax
  801994:	89 d8                	mov    %ebx,%eax
  801996:	03 45 0c             	add    0xc(%ebp),%eax
  801999:	50                   	push   %eax
  80199a:	57                   	push   %edi
  80199b:	e8 4d ff ff ff       	call   8018ed <read>
		if (m < 0)
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 06                	js     8019ad <readn+0x39>
			return m;
		if (m == 0)
  8019a7:	74 06                	je     8019af <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019a9:	01 c3                	add    %eax,%ebx
  8019ab:	eb db                	jmp    801988 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ad:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5f                   	pop    %edi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    

008019b9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	53                   	push   %ebx
  8019bd:	83 ec 1c             	sub    $0x1c,%esp
  8019c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c6:	50                   	push   %eax
  8019c7:	53                   	push   %ebx
  8019c8:	e8 b5 fc ff ff       	call   801682 <fd_lookup>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 3a                	js     801a0e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019da:	50                   	push   %eax
  8019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019de:	ff 30                	pushl  (%eax)
  8019e0:	e8 ed fc ff ff       	call   8016d2 <dev_lookup>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 22                	js     801a0e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ef:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019f3:	74 1e                	je     801a13 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f8:	8b 52 0c             	mov    0xc(%edx),%edx
  8019fb:	85 d2                	test   %edx,%edx
  8019fd:	74 35                	je     801a34 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	ff 75 10             	pushl  0x10(%ebp)
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	50                   	push   %eax
  801a09:	ff d2                	call   *%edx
  801a0b:	83 c4 10             	add    $0x10,%esp
}
  801a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a13:	a1 04 40 80 00       	mov    0x804004,%eax
  801a18:	8b 40 48             	mov    0x48(%eax),%eax
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	53                   	push   %ebx
  801a1f:	50                   	push   %eax
  801a20:	68 c1 2c 80 00       	push   $0x802cc1
  801a25:	e8 a4 e9 ff ff       	call   8003ce <cprintf>
		return -E_INVAL;
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a32:	eb da                	jmp    801a0e <write+0x55>
		return -E_NOT_SUPP;
  801a34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a39:	eb d3                	jmp    801a0e <write+0x55>

00801a3b <seek>:

int
seek(int fdnum, off_t offset)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a44:	50                   	push   %eax
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	e8 35 fc ff ff       	call   801682 <fd_lookup>
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 0e                	js     801a62 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
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
  801a73:	e8 0a fc ff ff       	call   801682 <fd_lookup>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 37                	js     801ab6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a89:	ff 30                	pushl  (%eax)
  801a8b:	e8 42 fc ff ff       	call   8016d2 <dev_lookup>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 1f                	js     801ab6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a9e:	74 1b                	je     801abb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa3:	8b 52 18             	mov    0x18(%edx),%edx
  801aa6:	85 d2                	test   %edx,%edx
  801aa8:	74 32                	je     801adc <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	ff d2                	call   *%edx
  801ab3:	83 c4 10             	add    $0x10,%esp
}
  801ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    
			thisenv->env_id, fdnum);
  801abb:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ac0:	8b 40 48             	mov    0x48(%eax),%eax
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	53                   	push   %ebx
  801ac7:	50                   	push   %eax
  801ac8:	68 84 2c 80 00       	push   $0x802c84
  801acd:	e8 fc e8 ff ff       	call   8003ce <cprintf>
		return -E_INVAL;
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ada:	eb da                	jmp    801ab6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801adc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae1:	eb d3                	jmp    801ab6 <ftruncate+0x52>

00801ae3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 1c             	sub    $0x1c,%esp
  801aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af0:	50                   	push   %eax
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	e8 89 fb ff ff       	call   801682 <fd_lookup>
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 4b                	js     801b4b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b06:	50                   	push   %eax
  801b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0a:	ff 30                	pushl  (%eax)
  801b0c:	e8 c1 fb ff ff       	call   8016d2 <dev_lookup>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 33                	js     801b4b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b1f:	74 2f                	je     801b50 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b21:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b24:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b2b:	00 00 00 
	stat->st_isdir = 0;
  801b2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b35:	00 00 00 
	stat->st_dev = dev;
  801b38:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	53                   	push   %ebx
  801b42:	ff 75 f0             	pushl  -0x10(%ebp)
  801b45:	ff 50 14             	call   *0x14(%eax)
  801b48:	83 c4 10             	add    $0x10,%esp
}
  801b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    
		return -E_NOT_SUPP;
  801b50:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b55:	eb f4                	jmp    801b4b <fstat+0x68>

00801b57 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b5c:	83 ec 08             	sub    $0x8,%esp
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 bb 01 00 00       	call   801d24 <open>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 1b                	js     801b8d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	e8 65 ff ff ff       	call   801ae3 <fstat>
  801b7e:	89 c6                	mov    %eax,%esi
	close(fd);
  801b80:	89 1c 24             	mov    %ebx,(%esp)
  801b83:	e8 27 fc ff ff       	call   8017af <close>
	return r;
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	89 f3                	mov    %esi,%ebx
}
  801b8d:	89 d8                	mov    %ebx,%eax
  801b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    

00801b96 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	56                   	push   %esi
  801b9a:	53                   	push   %ebx
  801b9b:	89 c6                	mov    %eax,%esi
  801b9d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b9f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801ba6:	74 27                	je     801bcf <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba8:	6a 07                	push   $0x7
  801baa:	68 00 50 80 00       	push   $0x805000
  801baf:	56                   	push   %esi
  801bb0:	ff 35 00 40 80 00    	pushl  0x804000
  801bb6:	e8 cf 07 00 00       	call   80238a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bbb:	83 c4 0c             	add    $0xc,%esp
  801bbe:	6a 00                	push   $0x0
  801bc0:	53                   	push   %ebx
  801bc1:	6a 00                	push   $0x0
  801bc3:	e8 59 07 00 00       	call   802321 <ipc_recv>
}
  801bc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	6a 01                	push   $0x1
  801bd4:	e8 09 08 00 00       	call   8023e2 <ipc_find_env>
  801bd9:	a3 00 40 80 00       	mov    %eax,0x804000
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	eb c5                	jmp    801ba8 <fsipc+0x12>

00801be3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8b 40 0c             	mov    0xc(%eax),%eax
  801bef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801c01:	b8 02 00 00 00       	mov    $0x2,%eax
  801c06:	e8 8b ff ff ff       	call   801b96 <fsipc>
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <devfile_flush>:
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	8b 40 0c             	mov    0xc(%eax),%eax
  801c19:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	b8 06 00 00 00       	mov    $0x6,%eax
  801c28:	e8 69 ff ff ff       	call   801b96 <fsipc>
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <devfile_stat>:
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	53                   	push   %ebx
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c44:	ba 00 00 00 00       	mov    $0x0,%edx
  801c49:	b8 05 00 00 00       	mov    $0x5,%eax
  801c4e:	e8 43 ff ff ff       	call   801b96 <fsipc>
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 2c                	js     801c83 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c57:	83 ec 08             	sub    $0x8,%esp
  801c5a:	68 00 50 80 00       	push   $0x805000
  801c5f:	53                   	push   %ebx
  801c60:	e8 c8 ee ff ff       	call   800b2d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c65:	a1 80 50 80 00       	mov    0x805080,%eax
  801c6a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c70:	a1 84 50 80 00       	mov    0x805084,%eax
  801c75:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <devfile_write>:
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801c8e:	68 f0 2c 80 00       	push   $0x802cf0
  801c93:	68 90 00 00 00       	push   $0x90
  801c98:	68 0e 2d 80 00       	push   $0x802d0e
  801c9d:	e8 36 e6 ff ff       	call   8002d8 <_panic>

00801ca2 <devfile_read>:
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cb5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc0:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc5:	e8 cc fe ff ff       	call   801b96 <fsipc>
  801cca:	89 c3                	mov    %eax,%ebx
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	78 1f                	js     801cef <devfile_read+0x4d>
	assert(r <= n);
  801cd0:	39 f0                	cmp    %esi,%eax
  801cd2:	77 24                	ja     801cf8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cd4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cd9:	7f 33                	jg     801d0e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	50                   	push   %eax
  801cdf:	68 00 50 80 00       	push   $0x805000
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	e8 cf ef ff ff       	call   800cbb <memmove>
	return r;
  801cec:	83 c4 10             	add    $0x10,%esp
}
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
	assert(r <= n);
  801cf8:	68 19 2d 80 00       	push   $0x802d19
  801cfd:	68 20 2d 80 00       	push   $0x802d20
  801d02:	6a 7c                	push   $0x7c
  801d04:	68 0e 2d 80 00       	push   $0x802d0e
  801d09:	e8 ca e5 ff ff       	call   8002d8 <_panic>
	assert(r <= PGSIZE);
  801d0e:	68 35 2d 80 00       	push   $0x802d35
  801d13:	68 20 2d 80 00       	push   $0x802d20
  801d18:	6a 7d                	push   $0x7d
  801d1a:	68 0e 2d 80 00       	push   $0x802d0e
  801d1f:	e8 b4 e5 ff ff       	call   8002d8 <_panic>

00801d24 <open>:
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	83 ec 1c             	sub    $0x1c,%esp
  801d2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d2f:	56                   	push   %esi
  801d30:	e8 bf ed ff ff       	call   800af4 <strlen>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d3d:	7f 6c                	jg     801dab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d45:	50                   	push   %eax
  801d46:	e8 e5 f8 ff ff       	call   801630 <fd_alloc>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	85 c0                	test   %eax,%eax
  801d52:	78 3c                	js     801d90 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d54:	83 ec 08             	sub    $0x8,%esp
  801d57:	56                   	push   %esi
  801d58:	68 00 50 80 00       	push   $0x805000
  801d5d:	e8 cb ed ff ff       	call   800b2d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d65:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d72:	e8 1f fe ff ff       	call   801b96 <fsipc>
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	78 19                	js     801d99 <open+0x75>
	return fd2num(fd);
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	ff 75 f4             	pushl  -0xc(%ebp)
  801d86:	e8 7e f8 ff ff       	call   801609 <fd2num>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 10             	add    $0x10,%esp
}
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    
		fd_close(fd, 0);
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801da1:	e8 82 f9 ff ff       	call   801728 <fd_close>
		return r;
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	eb e5                	jmp    801d90 <open+0x6c>
		return -E_BAD_PATH;
  801dab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801db0:	eb de                	jmp    801d90 <open+0x6c>

00801db2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801db8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbd:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc2:	e8 cf fd ff ff       	call   801b96 <fsipc>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	ff 75 08             	pushl  0x8(%ebp)
  801dd7:	e8 3d f8 ff ff       	call   801619 <fd2data>
  801ddc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dde:	83 c4 08             	add    $0x8,%esp
  801de1:	68 41 2d 80 00       	push   $0x802d41
  801de6:	53                   	push   %ebx
  801de7:	e8 41 ed ff ff       	call   800b2d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dec:	8b 46 04             	mov    0x4(%esi),%eax
  801def:	2b 06                	sub    (%esi),%eax
  801df1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfe:	00 00 00 
	stat->st_dev = &devpipe;
  801e01:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801e08:	30 80 00 
	return 0;
}
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    

00801e17 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e21:	53                   	push   %ebx
  801e22:	6a 00                	push   $0x0
  801e24:	e8 7b f1 ff ff       	call   800fa4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e29:	89 1c 24             	mov    %ebx,(%esp)
  801e2c:	e8 e8 f7 ff ff       	call   801619 <fd2data>
  801e31:	83 c4 08             	add    $0x8,%esp
  801e34:	50                   	push   %eax
  801e35:	6a 00                	push   $0x0
  801e37:	e8 68 f1 ff ff       	call   800fa4 <sys_page_unmap>
}
  801e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <_pipeisclosed>:
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	57                   	push   %edi
  801e45:	56                   	push   %esi
  801e46:	53                   	push   %ebx
  801e47:	83 ec 1c             	sub    $0x1c,%esp
  801e4a:	89 c7                	mov    %eax,%edi
  801e4c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e4e:	a1 04 40 80 00       	mov    0x804004,%eax
  801e53:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	57                   	push   %edi
  801e5a:	e8 be 05 00 00       	call   80241d <pageref>
  801e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e62:	89 34 24             	mov    %esi,(%esp)
  801e65:	e8 b3 05 00 00       	call   80241d <pageref>
		nn = thisenv->env_runs;
  801e6a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e70:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	39 cb                	cmp    %ecx,%ebx
  801e78:	74 1b                	je     801e95 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e7a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e7d:	75 cf                	jne    801e4e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e7f:	8b 42 58             	mov    0x58(%edx),%eax
  801e82:	6a 01                	push   $0x1
  801e84:	50                   	push   %eax
  801e85:	53                   	push   %ebx
  801e86:	68 48 2d 80 00       	push   $0x802d48
  801e8b:	e8 3e e5 ff ff       	call   8003ce <cprintf>
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	eb b9                	jmp    801e4e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e98:	0f 94 c0             	sete   %al
  801e9b:	0f b6 c0             	movzbl %al,%eax
}
  801e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea1:	5b                   	pop    %ebx
  801ea2:	5e                   	pop    %esi
  801ea3:	5f                   	pop    %edi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <devpipe_write>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	57                   	push   %edi
  801eaa:	56                   	push   %esi
  801eab:	53                   	push   %ebx
  801eac:	83 ec 28             	sub    $0x28,%esp
  801eaf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eb2:	56                   	push   %esi
  801eb3:	e8 61 f7 ff ff       	call   801619 <fd2data>
  801eb8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec5:	74 4f                	je     801f16 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec7:	8b 43 04             	mov    0x4(%ebx),%eax
  801eca:	8b 0b                	mov    (%ebx),%ecx
  801ecc:	8d 51 20             	lea    0x20(%ecx),%edx
  801ecf:	39 d0                	cmp    %edx,%eax
  801ed1:	72 14                	jb     801ee7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ed3:	89 da                	mov    %ebx,%edx
  801ed5:	89 f0                	mov    %esi,%eax
  801ed7:	e8 65 ff ff ff       	call   801e41 <_pipeisclosed>
  801edc:	85 c0                	test   %eax,%eax
  801ede:	75 3b                	jne    801f1b <devpipe_write+0x75>
			sys_yield();
  801ee0:	e8 1b f0 ff ff       	call   800f00 <sys_yield>
  801ee5:	eb e0                	jmp    801ec7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef1:	89 c2                	mov    %eax,%edx
  801ef3:	c1 fa 1f             	sar    $0x1f,%edx
  801ef6:	89 d1                	mov    %edx,%ecx
  801ef8:	c1 e9 1b             	shr    $0x1b,%ecx
  801efb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801efe:	83 e2 1f             	and    $0x1f,%edx
  801f01:	29 ca                	sub    %ecx,%edx
  801f03:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f07:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f0b:	83 c0 01             	add    $0x1,%eax
  801f0e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f11:	83 c7 01             	add    $0x1,%edi
  801f14:	eb ac                	jmp    801ec2 <devpipe_write+0x1c>
	return i;
  801f16:	8b 45 10             	mov    0x10(%ebp),%eax
  801f19:	eb 05                	jmp    801f20 <devpipe_write+0x7a>
				return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <devpipe_read>:
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	57                   	push   %edi
  801f2c:	56                   	push   %esi
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 18             	sub    $0x18,%esp
  801f31:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f34:	57                   	push   %edi
  801f35:	e8 df f6 ff ff       	call   801619 <fd2data>
  801f3a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	be 00 00 00 00       	mov    $0x0,%esi
  801f44:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f47:	75 14                	jne    801f5d <devpipe_read+0x35>
	return i;
  801f49:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4c:	eb 02                	jmp    801f50 <devpipe_read+0x28>
				return i;
  801f4e:	89 f0                	mov    %esi,%eax
}
  801f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5e                   	pop    %esi
  801f55:	5f                   	pop    %edi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    
			sys_yield();
  801f58:	e8 a3 ef ff ff       	call   800f00 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f5d:	8b 03                	mov    (%ebx),%eax
  801f5f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f62:	75 18                	jne    801f7c <devpipe_read+0x54>
			if (i > 0)
  801f64:	85 f6                	test   %esi,%esi
  801f66:	75 e6                	jne    801f4e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f68:	89 da                	mov    %ebx,%edx
  801f6a:	89 f8                	mov    %edi,%eax
  801f6c:	e8 d0 fe ff ff       	call   801e41 <_pipeisclosed>
  801f71:	85 c0                	test   %eax,%eax
  801f73:	74 e3                	je     801f58 <devpipe_read+0x30>
				return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	eb d4                	jmp    801f50 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f7c:	99                   	cltd   
  801f7d:	c1 ea 1b             	shr    $0x1b,%edx
  801f80:	01 d0                	add    %edx,%eax
  801f82:	83 e0 1f             	and    $0x1f,%eax
  801f85:	29 d0                	sub    %edx,%eax
  801f87:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f92:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f95:	83 c6 01             	add    $0x1,%esi
  801f98:	eb aa                	jmp    801f44 <devpipe_read+0x1c>

00801f9a <pipe>:
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	56                   	push   %esi
  801f9e:	53                   	push   %ebx
  801f9f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa5:	50                   	push   %eax
  801fa6:	e8 85 f6 ff ff       	call   801630 <fd_alloc>
  801fab:	89 c3                	mov    %eax,%ebx
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	0f 88 23 01 00 00    	js     8020db <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 07 04 00 00       	push   $0x407
  801fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc3:	6a 00                	push   $0x0
  801fc5:	e8 55 ef ff ff       	call   800f1f <sys_page_alloc>
  801fca:	89 c3                	mov    %eax,%ebx
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	0f 88 04 01 00 00    	js     8020db <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fdd:	50                   	push   %eax
  801fde:	e8 4d f6 ff ff       	call   801630 <fd_alloc>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	0f 88 db 00 00 00    	js     8020cb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 07 04 00 00       	push   $0x407
  801ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffb:	6a 00                	push   $0x0
  801ffd:	e8 1d ef ff ff       	call   800f1f <sys_page_alloc>
  802002:	89 c3                	mov    %eax,%ebx
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	85 c0                	test   %eax,%eax
  802009:	0f 88 bc 00 00 00    	js     8020cb <pipe+0x131>
	va = fd2data(fd0);
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	ff 75 f4             	pushl  -0xc(%ebp)
  802015:	e8 ff f5 ff ff       	call   801619 <fd2data>
  80201a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201c:	83 c4 0c             	add    $0xc,%esp
  80201f:	68 07 04 00 00       	push   $0x407
  802024:	50                   	push   %eax
  802025:	6a 00                	push   $0x0
  802027:	e8 f3 ee ff ff       	call   800f1f <sys_page_alloc>
  80202c:	89 c3                	mov    %eax,%ebx
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	85 c0                	test   %eax,%eax
  802033:	0f 88 82 00 00 00    	js     8020bb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	ff 75 f0             	pushl  -0x10(%ebp)
  80203f:	e8 d5 f5 ff ff       	call   801619 <fd2data>
  802044:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80204b:	50                   	push   %eax
  80204c:	6a 00                	push   $0x0
  80204e:	56                   	push   %esi
  80204f:	6a 00                	push   $0x0
  802051:	e8 0c ef ff ff       	call   800f62 <sys_page_map>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 20             	add    $0x20,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 4e                	js     8020ad <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80205f:	a1 20 30 80 00       	mov    0x803020,%eax
  802064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802067:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802076:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	ff 75 f4             	pushl  -0xc(%ebp)
  802088:	e8 7c f5 ff ff       	call   801609 <fd2num>
  80208d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802090:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802092:	83 c4 04             	add    $0x4,%esp
  802095:	ff 75 f0             	pushl  -0x10(%ebp)
  802098:	e8 6c f5 ff ff       	call   801609 <fd2num>
  80209d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020ab:	eb 2e                	jmp    8020db <pipe+0x141>
	sys_page_unmap(0, va);
  8020ad:	83 ec 08             	sub    $0x8,%esp
  8020b0:	56                   	push   %esi
  8020b1:	6a 00                	push   $0x0
  8020b3:	e8 ec ee ff ff       	call   800fa4 <sys_page_unmap>
  8020b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020bb:	83 ec 08             	sub    $0x8,%esp
  8020be:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 dc ee ff ff       	call   800fa4 <sys_page_unmap>
  8020c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020cb:	83 ec 08             	sub    $0x8,%esp
  8020ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d1:	6a 00                	push   $0x0
  8020d3:	e8 cc ee ff ff       	call   800fa4 <sys_page_unmap>
  8020d8:	83 c4 10             	add    $0x10,%esp
}
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    

008020e4 <pipeisclosed>:
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ed:	50                   	push   %eax
  8020ee:	ff 75 08             	pushl  0x8(%ebp)
  8020f1:	e8 8c f5 ff ff       	call   801682 <fd_lookup>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 18                	js     802115 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	ff 75 f4             	pushl  -0xc(%ebp)
  802103:	e8 11 f5 ff ff       	call   801619 <fd2data>
	return _pipeisclosed(fd, p);
  802108:	89 c2                	mov    %eax,%edx
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	e8 2f fd ff ff       	call   801e41 <_pipeisclosed>
  802112:	83 c4 10             	add    $0x10,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
  80211c:	c3                   	ret    

0080211d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802123:	68 5b 2d 80 00       	push   $0x802d5b
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	e8 fd e9 ff ff       	call   800b2d <strcpy>
	return 0;
}
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <devcons_write>:
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	57                   	push   %edi
  80213b:	56                   	push   %esi
  80213c:	53                   	push   %ebx
  80213d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802143:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802148:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80214e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802151:	73 31                	jae    802184 <devcons_write+0x4d>
		m = n - tot;
  802153:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802156:	29 f3                	sub    %esi,%ebx
  802158:	83 fb 7f             	cmp    $0x7f,%ebx
  80215b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802160:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	53                   	push   %ebx
  802167:	89 f0                	mov    %esi,%eax
  802169:	03 45 0c             	add    0xc(%ebp),%eax
  80216c:	50                   	push   %eax
  80216d:	57                   	push   %edi
  80216e:	e8 48 eb ff ff       	call   800cbb <memmove>
		sys_cputs(buf, m);
  802173:	83 c4 08             	add    $0x8,%esp
  802176:	53                   	push   %ebx
  802177:	57                   	push   %edi
  802178:	e8 e6 ec ff ff       	call   800e63 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80217d:	01 de                	add    %ebx,%esi
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	eb ca                	jmp    80214e <devcons_write+0x17>
}
  802184:	89 f0                	mov    %esi,%eax
  802186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    

0080218e <devcons_read>:
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802199:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219d:	74 21                	je     8021c0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80219f:	e8 dd ec ff ff       	call   800e81 <sys_cgetc>
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	75 07                	jne    8021af <devcons_read+0x21>
		sys_yield();
  8021a8:	e8 53 ed ff ff       	call   800f00 <sys_yield>
  8021ad:	eb f0                	jmp    80219f <devcons_read+0x11>
	if (c < 0)
  8021af:	78 0f                	js     8021c0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021b1:	83 f8 04             	cmp    $0x4,%eax
  8021b4:	74 0c                	je     8021c2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b9:	88 02                	mov    %al,(%edx)
	return 1;
  8021bb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    
		return 0;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	eb f7                	jmp    8021c0 <devcons_read+0x32>

008021c9 <cputchar>:
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d5:	6a 01                	push   $0x1
  8021d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021da:	50                   	push   %eax
  8021db:	e8 83 ec ff ff       	call   800e63 <sys_cputs>
}
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <getchar>:
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021eb:	6a 01                	push   $0x1
  8021ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f0:	50                   	push   %eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	e8 f5 f6 ff ff       	call   8018ed <read>
	if (r < 0)
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 06                	js     802205 <getchar+0x20>
	if (r < 1)
  8021ff:	74 06                	je     802207 <getchar+0x22>
	return c;
  802201:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    
		return -E_EOF;
  802207:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220c:	eb f7                	jmp    802205 <getchar+0x20>

0080220e <iscons>:
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802217:	50                   	push   %eax
  802218:	ff 75 08             	pushl  0x8(%ebp)
  80221b:	e8 62 f4 ff ff       	call   801682 <fd_lookup>
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	85 c0                	test   %eax,%eax
  802225:	78 11                	js     802238 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802230:	39 10                	cmp    %edx,(%eax)
  802232:	0f 94 c0             	sete   %al
  802235:	0f b6 c0             	movzbl %al,%eax
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <opencons>:
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802243:	50                   	push   %eax
  802244:	e8 e7 f3 ff ff       	call   801630 <fd_alloc>
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	85 c0                	test   %eax,%eax
  80224e:	78 3a                	js     80228a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	68 07 04 00 00       	push   $0x407
  802258:	ff 75 f4             	pushl  -0xc(%ebp)
  80225b:	6a 00                	push   $0x0
  80225d:	e8 bd ec ff ff       	call   800f1f <sys_page_alloc>
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	85 c0                	test   %eax,%eax
  802267:	78 21                	js     80228a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802272:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	50                   	push   %eax
  802282:	e8 82 f3 ff ff       	call   801609 <fd2num>
  802287:	83 c4 10             	add    $0x10,%esp
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802292:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802299:	74 0a                	je     8022a5 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	6a 07                	push   $0x7
  8022aa:	68 00 f0 bf ee       	push   $0xeebff000
  8022af:	6a 00                	push   $0x0
  8022b1:	e8 69 ec ff ff       	call   800f1f <sys_page_alloc>
		if(r < 0)
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	78 2a                	js     8022e7 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8022bd:	83 ec 08             	sub    $0x8,%esp
  8022c0:	68 fb 22 80 00       	push   $0x8022fb
  8022c5:	6a 00                	push   $0x0
  8022c7:	e8 9e ed ff ff       	call   80106a <sys_env_set_pgfault_upcall>
		if(r < 0)
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	79 c8                	jns    80229b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 98 2d 80 00       	push   $0x802d98
  8022db:	6a 25                	push   $0x25
  8022dd:	68 d4 2d 80 00       	push   $0x802dd4
  8022e2:	e8 f1 df ff ff       	call   8002d8 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	68 68 2d 80 00       	push   $0x802d68
  8022ef:	6a 22                	push   $0x22
  8022f1:	68 d4 2d 80 00       	push   $0x802dd4
  8022f6:	e8 dd df ff ff       	call   8002d8 <_panic>

008022fb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022fb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022fc:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802301:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802303:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802306:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80230a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80230e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802311:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802313:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802317:	83 c4 08             	add    $0x8,%esp
	popal
  80231a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80231b:	83 c4 04             	add    $0x4,%esp
	popfl
  80231e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80231f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802320:	c3                   	ret    

00802321 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	56                   	push   %esi
  802325:	53                   	push   %ebx
  802326:	8b 75 08             	mov    0x8(%ebp),%esi
  802329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  80232f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802331:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802336:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802339:	83 ec 0c             	sub    $0xc,%esp
  80233c:	50                   	push   %eax
  80233d:	e8 8d ed ff ff       	call   8010cf <sys_ipc_recv>
	if(ret < 0){
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	85 c0                	test   %eax,%eax
  802347:	78 2b                	js     802374 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802349:	85 f6                	test   %esi,%esi
  80234b:	74 0a                	je     802357 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80234d:	a1 04 40 80 00       	mov    0x804004,%eax
  802352:	8b 40 74             	mov    0x74(%eax),%eax
  802355:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802357:	85 db                	test   %ebx,%ebx
  802359:	74 0a                	je     802365 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80235b:	a1 04 40 80 00       	mov    0x804004,%eax
  802360:	8b 40 78             	mov    0x78(%eax),%eax
  802363:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802365:	a1 04 40 80 00       	mov    0x804004,%eax
  80236a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80236d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5d                   	pop    %ebp
  802373:	c3                   	ret    
		if(from_env_store)
  802374:	85 f6                	test   %esi,%esi
  802376:	74 06                	je     80237e <ipc_recv+0x5d>
			*from_env_store = 0;
  802378:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80237e:	85 db                	test   %ebx,%ebx
  802380:	74 eb                	je     80236d <ipc_recv+0x4c>
			*perm_store = 0;
  802382:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802388:	eb e3                	jmp    80236d <ipc_recv+0x4c>

0080238a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 0c             	sub    $0xc,%esp
  802393:	8b 7d 08             	mov    0x8(%ebp),%edi
  802396:	8b 75 0c             	mov    0xc(%ebp),%esi
  802399:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80239c:	85 db                	test   %ebx,%ebx
  80239e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023a3:	0f 44 d8             	cmove  %eax,%ebx
  8023a6:	eb 05                	jmp    8023ad <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023a8:	e8 53 eb ff ff       	call   800f00 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023ad:	ff 75 14             	pushl  0x14(%ebp)
  8023b0:	53                   	push   %ebx
  8023b1:	56                   	push   %esi
  8023b2:	57                   	push   %edi
  8023b3:	e8 f4 ec ff ff       	call   8010ac <sys_ipc_try_send>
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 1b                	je     8023da <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023bf:	79 e7                	jns    8023a8 <ipc_send+0x1e>
  8023c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023c4:	74 e2                	je     8023a8 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	68 e2 2d 80 00       	push   $0x802de2
  8023ce:	6a 49                	push   $0x49
  8023d0:	68 f7 2d 80 00       	push   $0x802df7
  8023d5:	e8 fe de ff ff       	call   8002d8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023dd:	5b                   	pop    %ebx
  8023de:	5e                   	pop    %esi
  8023df:	5f                   	pop    %edi
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    

008023e2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023e8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	c1 e2 07             	shl    $0x7,%edx
  8023f2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023f8:	8b 52 50             	mov    0x50(%edx),%edx
  8023fb:	39 ca                	cmp    %ecx,%edx
  8023fd:	74 11                	je     802410 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023ff:	83 c0 01             	add    $0x1,%eax
  802402:	3d 00 04 00 00       	cmp    $0x400,%eax
  802407:	75 e4                	jne    8023ed <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	eb 0b                	jmp    80241b <ipc_find_env+0x39>
			return envs[i].env_id;
  802410:	c1 e0 07             	shl    $0x7,%eax
  802413:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802418:	8b 40 48             	mov    0x48(%eax),%eax
}
  80241b:	5d                   	pop    %ebp
  80241c:	c3                   	ret    

0080241d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802423:	89 d0                	mov    %edx,%eax
  802425:	c1 e8 16             	shr    $0x16,%eax
  802428:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802434:	f6 c1 01             	test   $0x1,%cl
  802437:	74 1d                	je     802456 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802439:	c1 ea 0c             	shr    $0xc,%edx
  80243c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802443:	f6 c2 01             	test   $0x1,%dl
  802446:	74 0e                	je     802456 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802448:	c1 ea 0c             	shr    $0xc,%edx
  80244b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802452:	ef 
  802453:	0f b7 c0             	movzwl %ax,%eax
}
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	66 90                	xchg   %ax,%ax
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__udivdi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80246b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80246f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802473:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802477:	85 d2                	test   %edx,%edx
  802479:	75 4d                	jne    8024c8 <__udivdi3+0x68>
  80247b:	39 f3                	cmp    %esi,%ebx
  80247d:	76 19                	jbe    802498 <__udivdi3+0x38>
  80247f:	31 ff                	xor    %edi,%edi
  802481:	89 e8                	mov    %ebp,%eax
  802483:	89 f2                	mov    %esi,%edx
  802485:	f7 f3                	div    %ebx
  802487:	89 fa                	mov    %edi,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 d9                	mov    %ebx,%ecx
  80249a:	85 db                	test   %ebx,%ebx
  80249c:	75 0b                	jne    8024a9 <__udivdi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f3                	div    %ebx
  8024a7:	89 c1                	mov    %eax,%ecx
  8024a9:	31 d2                	xor    %edx,%edx
  8024ab:	89 f0                	mov    %esi,%eax
  8024ad:	f7 f1                	div    %ecx
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	89 e8                	mov    %ebp,%eax
  8024b3:	89 f7                	mov    %esi,%edi
  8024b5:	f7 f1                	div    %ecx
  8024b7:	89 fa                	mov    %edi,%edx
  8024b9:	83 c4 1c             	add    $0x1c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	39 f2                	cmp    %esi,%edx
  8024ca:	77 1c                	ja     8024e8 <__udivdi3+0x88>
  8024cc:	0f bd fa             	bsr    %edx,%edi
  8024cf:	83 f7 1f             	xor    $0x1f,%edi
  8024d2:	75 2c                	jne    802500 <__udivdi3+0xa0>
  8024d4:	39 f2                	cmp    %esi,%edx
  8024d6:	72 06                	jb     8024de <__udivdi3+0x7e>
  8024d8:	31 c0                	xor    %eax,%eax
  8024da:	39 eb                	cmp    %ebp,%ebx
  8024dc:	77 a9                	ja     802487 <__udivdi3+0x27>
  8024de:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e3:	eb a2                	jmp    802487 <__udivdi3+0x27>
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	31 ff                	xor    %edi,%edi
  8024ea:	31 c0                	xor    %eax,%eax
  8024ec:	89 fa                	mov    %edi,%edx
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 f9                	mov    %edi,%ecx
  802502:	b8 20 00 00 00       	mov    $0x20,%eax
  802507:	29 f8                	sub    %edi,%eax
  802509:	d3 e2                	shl    %cl,%edx
  80250b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80250f:	89 c1                	mov    %eax,%ecx
  802511:	89 da                	mov    %ebx,%edx
  802513:	d3 ea                	shr    %cl,%edx
  802515:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802519:	09 d1                	or     %edx,%ecx
  80251b:	89 f2                	mov    %esi,%edx
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 f9                	mov    %edi,%ecx
  802523:	d3 e3                	shl    %cl,%ebx
  802525:	89 c1                	mov    %eax,%ecx
  802527:	d3 ea                	shr    %cl,%edx
  802529:	89 f9                	mov    %edi,%ecx
  80252b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80252f:	89 eb                	mov    %ebp,%ebx
  802531:	d3 e6                	shl    %cl,%esi
  802533:	89 c1                	mov    %eax,%ecx
  802535:	d3 eb                	shr    %cl,%ebx
  802537:	09 de                	or     %ebx,%esi
  802539:	89 f0                	mov    %esi,%eax
  80253b:	f7 74 24 08          	divl   0x8(%esp)
  80253f:	89 d6                	mov    %edx,%esi
  802541:	89 c3                	mov    %eax,%ebx
  802543:	f7 64 24 0c          	mull   0xc(%esp)
  802547:	39 d6                	cmp    %edx,%esi
  802549:	72 15                	jb     802560 <__udivdi3+0x100>
  80254b:	89 f9                	mov    %edi,%ecx
  80254d:	d3 e5                	shl    %cl,%ebp
  80254f:	39 c5                	cmp    %eax,%ebp
  802551:	73 04                	jae    802557 <__udivdi3+0xf7>
  802553:	39 d6                	cmp    %edx,%esi
  802555:	74 09                	je     802560 <__udivdi3+0x100>
  802557:	89 d8                	mov    %ebx,%eax
  802559:	31 ff                	xor    %edi,%edi
  80255b:	e9 27 ff ff ff       	jmp    802487 <__udivdi3+0x27>
  802560:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802563:	31 ff                	xor    %edi,%edi
  802565:	e9 1d ff ff ff       	jmp    802487 <__udivdi3+0x27>
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	66 90                	xchg   %ax,%ax
  80256e:	66 90                	xchg   %ax,%ax

00802570 <__umoddi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	53                   	push   %ebx
  802574:	83 ec 1c             	sub    $0x1c,%esp
  802577:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80257b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80257f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802587:	89 da                	mov    %ebx,%edx
  802589:	85 c0                	test   %eax,%eax
  80258b:	75 43                	jne    8025d0 <__umoddi3+0x60>
  80258d:	39 df                	cmp    %ebx,%edi
  80258f:	76 17                	jbe    8025a8 <__umoddi3+0x38>
  802591:	89 f0                	mov    %esi,%eax
  802593:	f7 f7                	div    %edi
  802595:	89 d0                	mov    %edx,%eax
  802597:	31 d2                	xor    %edx,%edx
  802599:	83 c4 1c             	add    $0x1c,%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5e                   	pop    %esi
  80259e:	5f                   	pop    %edi
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    
  8025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	89 fd                	mov    %edi,%ebp
  8025aa:	85 ff                	test   %edi,%edi
  8025ac:	75 0b                	jne    8025b9 <__umoddi3+0x49>
  8025ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b3:	31 d2                	xor    %edx,%edx
  8025b5:	f7 f7                	div    %edi
  8025b7:	89 c5                	mov    %eax,%ebp
  8025b9:	89 d8                	mov    %ebx,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f5                	div    %ebp
  8025bf:	89 f0                	mov    %esi,%eax
  8025c1:	f7 f5                	div    %ebp
  8025c3:	89 d0                	mov    %edx,%eax
  8025c5:	eb d0                	jmp    802597 <__umoddi3+0x27>
  8025c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ce:	66 90                	xchg   %ax,%ax
  8025d0:	89 f1                	mov    %esi,%ecx
  8025d2:	39 d8                	cmp    %ebx,%eax
  8025d4:	76 0a                	jbe    8025e0 <__umoddi3+0x70>
  8025d6:	89 f0                	mov    %esi,%eax
  8025d8:	83 c4 1c             	add    $0x1c,%esp
  8025db:	5b                   	pop    %ebx
  8025dc:	5e                   	pop    %esi
  8025dd:	5f                   	pop    %edi
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    
  8025e0:	0f bd e8             	bsr    %eax,%ebp
  8025e3:	83 f5 1f             	xor    $0x1f,%ebp
  8025e6:	75 20                	jne    802608 <__umoddi3+0x98>
  8025e8:	39 d8                	cmp    %ebx,%eax
  8025ea:	0f 82 b0 00 00 00    	jb     8026a0 <__umoddi3+0x130>
  8025f0:	39 f7                	cmp    %esi,%edi
  8025f2:	0f 86 a8 00 00 00    	jbe    8026a0 <__umoddi3+0x130>
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	83 c4 1c             	add    $0x1c,%esp
  8025fd:	5b                   	pop    %ebx
  8025fe:	5e                   	pop    %esi
  8025ff:	5f                   	pop    %edi
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    
  802602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	ba 20 00 00 00       	mov    $0x20,%edx
  80260f:	29 ea                	sub    %ebp,%edx
  802611:	d3 e0                	shl    %cl,%eax
  802613:	89 44 24 08          	mov    %eax,0x8(%esp)
  802617:	89 d1                	mov    %edx,%ecx
  802619:	89 f8                	mov    %edi,%eax
  80261b:	d3 e8                	shr    %cl,%eax
  80261d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802621:	89 54 24 04          	mov    %edx,0x4(%esp)
  802625:	8b 54 24 04          	mov    0x4(%esp),%edx
  802629:	09 c1                	or     %eax,%ecx
  80262b:	89 d8                	mov    %ebx,%eax
  80262d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802631:	89 e9                	mov    %ebp,%ecx
  802633:	d3 e7                	shl    %cl,%edi
  802635:	89 d1                	mov    %edx,%ecx
  802637:	d3 e8                	shr    %cl,%eax
  802639:	89 e9                	mov    %ebp,%ecx
  80263b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80263f:	d3 e3                	shl    %cl,%ebx
  802641:	89 c7                	mov    %eax,%edi
  802643:	89 d1                	mov    %edx,%ecx
  802645:	89 f0                	mov    %esi,%eax
  802647:	d3 e8                	shr    %cl,%eax
  802649:	89 e9                	mov    %ebp,%ecx
  80264b:	89 fa                	mov    %edi,%edx
  80264d:	d3 e6                	shl    %cl,%esi
  80264f:	09 d8                	or     %ebx,%eax
  802651:	f7 74 24 08          	divl   0x8(%esp)
  802655:	89 d1                	mov    %edx,%ecx
  802657:	89 f3                	mov    %esi,%ebx
  802659:	f7 64 24 0c          	mull   0xc(%esp)
  80265d:	89 c6                	mov    %eax,%esi
  80265f:	89 d7                	mov    %edx,%edi
  802661:	39 d1                	cmp    %edx,%ecx
  802663:	72 06                	jb     80266b <__umoddi3+0xfb>
  802665:	75 10                	jne    802677 <__umoddi3+0x107>
  802667:	39 c3                	cmp    %eax,%ebx
  802669:	73 0c                	jae    802677 <__umoddi3+0x107>
  80266b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80266f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802673:	89 d7                	mov    %edx,%edi
  802675:	89 c6                	mov    %eax,%esi
  802677:	89 ca                	mov    %ecx,%edx
  802679:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80267e:	29 f3                	sub    %esi,%ebx
  802680:	19 fa                	sbb    %edi,%edx
  802682:	89 d0                	mov    %edx,%eax
  802684:	d3 e0                	shl    %cl,%eax
  802686:	89 e9                	mov    %ebp,%ecx
  802688:	d3 eb                	shr    %cl,%ebx
  80268a:	d3 ea                	shr    %cl,%edx
  80268c:	09 d8                	or     %ebx,%eax
  80268e:	83 c4 1c             	add    $0x1c,%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    
  802696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80269d:	8d 76 00             	lea    0x0(%esi),%esi
  8026a0:	89 da                	mov    %ebx,%edx
  8026a2:	29 fe                	sub    %edi,%esi
  8026a4:	19 c2                	sbb    %eax,%edx
  8026a6:	89 f1                	mov    %esi,%ecx
  8026a8:	89 c8                	mov    %ecx,%eax
  8026aa:	e9 4b ff ff ff       	jmp    8025fa <__umoddi3+0x8a>
