
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
  800056:	68 60 2c 80 00       	push   $0x802c60
  80005b:	6a 15                	push   $0x15
  80005d:	68 8f 2c 80 00       	push   $0x802c8f
  800062:	e8 47 02 00 00       	call   8002ae <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 a5 2c 80 00       	push   $0x802ca5
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 8f 2c 80 00       	push   $0x802c8f
  800074:	e8 35 02 00 00       	call   8002ae <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 ae 2c 80 00       	push   $0x802cae
  80007f:	6a 1d                	push   $0x1d
  800081:	68 8f 2c 80 00       	push   $0x802c8f
  800086:	e8 23 02 00 00       	call   8002ae <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 ee 17 00 00       	call   801882 <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 e3 17 00 00       	call   801882 <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 96 19 00 00       	call   801a47 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 a1 2c 80 00       	push   $0x802ca1
  8000c4:	e8 db 02 00 00       	call   8003a4 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 6a 24 00 00       	call   80253b <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 5f 13 00 00       	call   80143f <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 91 17 00 00       	call   801882 <close>
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
  800101:	e8 41 19 00 00       	call   801a47 <readn>
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
  800120:	e8 67 19 00 00       	call   801a8c <write>
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
  80013f:	68 d3 2c 80 00       	push   $0x802cd3
  800144:	6a 2e                	push   $0x2e
  800146:	68 8f 2c 80 00       	push   $0x802c8f
  80014b:	e8 5e 01 00 00       	call   8002ae <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 b7 2c 80 00       	push   $0x802cb7
  800168:	6a 2b                	push   $0x2b
  80016a:	68 8f 2c 80 00       	push   $0x802c8f
  80016f:	e8 3a 01 00 00       	call   8002ae <_panic>

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
  80017b:	c7 05 00 40 80 00 ed 	movl   $0x802ced,0x804000
  800182:	2c 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 ad 23 00 00       	call   80253b <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 a2 12 00 00       	call   80143f <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 d4 16 00 00       	call   801882 <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 a5 2c 80 00       	push   $0x802ca5
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 8f 2c 80 00       	push   $0x802c8f
  8001c6:	e8 e3 00 00 00       	call   8002ae <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 ae 2c 80 00       	push   $0x802cae
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 8f 2c 80 00       	push   $0x802c8f
  8001d8:	e8 d1 00 00 00       	call   8002ae <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 9a 16 00 00       	call   801882 <close>

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
  8001fe:	e8 89 18 00 00       	call   801a8c <write>
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
  800220:	68 f8 2c 80 00       	push   $0x802cf8
  800225:	6a 4a                	push   $0x4a
  800227:	68 8f 2c 80 00       	push   $0x802c8f
  80022c:	e8 7d 00 00 00       	call   8002ae <_panic>

00800231 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800239:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80023c:	e8 76 0c 00 00       	call   800eb7 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800241:	25 ff 03 00 00       	and    $0x3ff,%eax
  800246:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80024c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800251:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 07                	jle    800261 <libmain+0x30>
		binaryname = argv[0];
  80025a:	8b 06                	mov    (%esi),%eax
  80025c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	e8 09 ff ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  80026b:	e8 0a 00 00 00       	call   80027a <exit>
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800280:	a1 08 50 80 00       	mov    0x805008,%eax
  800285:	8b 40 48             	mov    0x48(%eax),%eax
  800288:	68 28 2d 80 00       	push   $0x802d28
  80028d:	50                   	push   %eax
  80028e:	68 1a 2d 80 00       	push   $0x802d1a
  800293:	e8 0c 01 00 00       	call   8003a4 <cprintf>
	close_all();
  800298:	e8 12 16 00 00       	call   8018af <close_all>
	sys_env_destroy(0);
  80029d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a4:	e8 cd 0b 00 00       	call   800e76 <sys_env_destroy>
}
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002b3:	a1 08 50 80 00       	mov    0x805008,%eax
  8002b8:	8b 40 48             	mov    0x48(%eax),%eax
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	68 54 2d 80 00       	push   $0x802d54
  8002c3:	50                   	push   %eax
  8002c4:	68 1a 2d 80 00       	push   $0x802d1a
  8002c9:	e8 d6 00 00 00       	call   8003a4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002d7:	e8 db 0b 00 00       	call   800eb7 <sys_getenvid>
  8002dc:	83 c4 04             	add    $0x4,%esp
  8002df:	ff 75 0c             	pushl  0xc(%ebp)
  8002e2:	ff 75 08             	pushl  0x8(%ebp)
  8002e5:	56                   	push   %esi
  8002e6:	50                   	push   %eax
  8002e7:	68 30 2d 80 00       	push   $0x802d30
  8002ec:	e8 b3 00 00 00       	call   8003a4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002f1:	83 c4 18             	add    $0x18,%esp
  8002f4:	53                   	push   %ebx
  8002f5:	ff 75 10             	pushl  0x10(%ebp)
  8002f8:	e8 56 00 00 00       	call   800353 <vcprintf>
	cprintf("\n");
  8002fd:	c7 04 24 61 31 80 00 	movl   $0x803161,(%esp)
  800304:	e8 9b 00 00 00       	call   8003a4 <cprintf>
  800309:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80030c:	cc                   	int3   
  80030d:	eb fd                	jmp    80030c <_panic+0x5e>

0080030f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	53                   	push   %ebx
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800319:	8b 13                	mov    (%ebx),%edx
  80031b:	8d 42 01             	lea    0x1(%edx),%eax
  80031e:	89 03                	mov    %eax,(%ebx)
  800320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800323:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800327:	3d ff 00 00 00       	cmp    $0xff,%eax
  80032c:	74 09                	je     800337 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80032e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800335:	c9                   	leave  
  800336:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	68 ff 00 00 00       	push   $0xff
  80033f:	8d 43 08             	lea    0x8(%ebx),%eax
  800342:	50                   	push   %eax
  800343:	e8 f1 0a 00 00       	call   800e39 <sys_cputs>
		b->idx = 0;
  800348:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80034e:	83 c4 10             	add    $0x10,%esp
  800351:	eb db                	jmp    80032e <putch+0x1f>

00800353 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80035c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800363:	00 00 00 
	b.cnt = 0;
  800366:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80036d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800370:	ff 75 0c             	pushl  0xc(%ebp)
  800373:	ff 75 08             	pushl  0x8(%ebp)
  800376:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037c:	50                   	push   %eax
  80037d:	68 0f 03 80 00       	push   $0x80030f
  800382:	e8 4a 01 00 00       	call   8004d1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800387:	83 c4 08             	add    $0x8,%esp
  80038a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800390:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800396:	50                   	push   %eax
  800397:	e8 9d 0a 00 00       	call   800e39 <sys_cputs>

	return b.cnt;
}
  80039c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ad:	50                   	push   %eax
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 9d ff ff ff       	call   800353 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    

008003b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	57                   	push   %edi
  8003bc:	56                   	push   %esi
  8003bd:	53                   	push   %ebx
  8003be:	83 ec 1c             	sub    $0x1c,%esp
  8003c1:	89 c6                	mov    %eax,%esi
  8003c3:	89 d7                	mov    %edx,%edi
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003d7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003db:	74 2c                	je     800409 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003f2:	73 43                	jae    800437 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003f4:	83 eb 01             	sub    $0x1,%ebx
  8003f7:	85 db                	test   %ebx,%ebx
  8003f9:	7e 6c                	jle    800467 <printnum+0xaf>
				putch(padc, putdat);
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	57                   	push   %edi
  8003ff:	ff 75 18             	pushl  0x18(%ebp)
  800402:	ff d6                	call   *%esi
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	eb eb                	jmp    8003f4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	6a 20                	push   $0x20
  80040e:	6a 00                	push   $0x0
  800410:	50                   	push   %eax
  800411:	ff 75 e4             	pushl  -0x1c(%ebp)
  800414:	ff 75 e0             	pushl  -0x20(%ebp)
  800417:	89 fa                	mov    %edi,%edx
  800419:	89 f0                	mov    %esi,%eax
  80041b:	e8 98 ff ff ff       	call   8003b8 <printnum>
		while (--width > 0)
  800420:	83 c4 20             	add    $0x20,%esp
  800423:	83 eb 01             	sub    $0x1,%ebx
  800426:	85 db                	test   %ebx,%ebx
  800428:	7e 65                	jle    80048f <printnum+0xd7>
			putch(padc, putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	57                   	push   %edi
  80042e:	6a 20                	push   $0x20
  800430:	ff d6                	call   *%esi
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	eb ec                	jmp    800423 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800437:	83 ec 0c             	sub    $0xc,%esp
  80043a:	ff 75 18             	pushl  0x18(%ebp)
  80043d:	83 eb 01             	sub    $0x1,%ebx
  800440:	53                   	push   %ebx
  800441:	50                   	push   %eax
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 dc             	pushl  -0x24(%ebp)
  800448:	ff 75 d8             	pushl  -0x28(%ebp)
  80044b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80044e:	ff 75 e0             	pushl  -0x20(%ebp)
  800451:	e8 aa 25 00 00       	call   802a00 <__udivdi3>
  800456:	83 c4 18             	add    $0x18,%esp
  800459:	52                   	push   %edx
  80045a:	50                   	push   %eax
  80045b:	89 fa                	mov    %edi,%edx
  80045d:	89 f0                	mov    %esi,%eax
  80045f:	e8 54 ff ff ff       	call   8003b8 <printnum>
  800464:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	57                   	push   %edi
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	ff 75 e4             	pushl  -0x1c(%ebp)
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	e8 91 26 00 00       	call   802b10 <__umoddi3>
  80047f:	83 c4 14             	add    $0x14,%esp
  800482:	0f be 80 5b 2d 80 00 	movsbl 0x802d5b(%eax),%eax
  800489:	50                   	push   %eax
  80048a:	ff d6                	call   *%esi
  80048c:	83 c4 10             	add    $0x10,%esp
	}
}
  80048f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800492:	5b                   	pop    %ebx
  800493:	5e                   	pop    %esi
  800494:	5f                   	pop    %edi
  800495:	5d                   	pop    %ebp
  800496:	c3                   	ret    

00800497 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80049d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a1:	8b 10                	mov    (%eax),%edx
  8004a3:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a6:	73 0a                	jae    8004b2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ab:	89 08                	mov    %ecx,(%eax)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	88 02                	mov    %al,(%edx)
}
  8004b2:	5d                   	pop    %ebp
  8004b3:	c3                   	ret    

008004b4 <printfmt>:
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ba:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004bd:	50                   	push   %eax
  8004be:	ff 75 10             	pushl  0x10(%ebp)
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	e8 05 00 00 00       	call   8004d1 <vprintfmt>
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <vprintfmt>:
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	57                   	push   %edi
  8004d5:	56                   	push   %esi
  8004d6:	53                   	push   %ebx
  8004d7:	83 ec 3c             	sub    $0x3c,%esp
  8004da:	8b 75 08             	mov    0x8(%ebp),%esi
  8004dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004e3:	e9 32 04 00 00       	jmp    80091a <vprintfmt+0x449>
		padc = ' ';
  8004e8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004ec:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004f3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800501:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800508:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80050f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8d 47 01             	lea    0x1(%edi),%eax
  800517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80051a:	0f b6 17             	movzbl (%edi),%edx
  80051d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800520:	3c 55                	cmp    $0x55,%al
  800522:	0f 87 12 05 00 00    	ja     800a3a <vprintfmt+0x569>
  800528:	0f b6 c0             	movzbl %al,%eax
  80052b:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  800532:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800535:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800539:	eb d9                	jmp    800514 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80053e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800542:	eb d0                	jmp    800514 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800544:	0f b6 d2             	movzbl %dl,%edx
  800547:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	89 75 08             	mov    %esi,0x8(%ebp)
  800552:	eb 03                	jmp    800557 <vprintfmt+0x86>
  800554:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800557:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80055a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80055e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800561:	8d 72 d0             	lea    -0x30(%edx),%esi
  800564:	83 fe 09             	cmp    $0x9,%esi
  800567:	76 eb                	jbe    800554 <vprintfmt+0x83>
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	8b 75 08             	mov    0x8(%ebp),%esi
  80056f:	eb 14                	jmp    800585 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800582:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800585:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800589:	79 89                	jns    800514 <vprintfmt+0x43>
				width = precision, precision = -1;
  80058b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800591:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800598:	e9 77 ff ff ff       	jmp    800514 <vprintfmt+0x43>
  80059d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a0:	85 c0                	test   %eax,%eax
  8005a2:	0f 48 c1             	cmovs  %ecx,%eax
  8005a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ab:	e9 64 ff ff ff       	jmp    800514 <vprintfmt+0x43>
  8005b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005b3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005ba:	e9 55 ff ff ff       	jmp    800514 <vprintfmt+0x43>
			lflag++;
  8005bf:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005c6:	e9 49 ff ff ff       	jmp    800514 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 78 04             	lea    0x4(%eax),%edi
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	ff 30                	pushl  (%eax)
  8005d7:	ff d6                	call   *%esi
			break;
  8005d9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005dc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005df:	e9 33 03 00 00       	jmp    800917 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 78 04             	lea    0x4(%eax),%edi
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	99                   	cltd   
  8005ed:	31 d0                	xor    %edx,%eax
  8005ef:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005f1:	83 f8 11             	cmp    $0x11,%eax
  8005f4:	7f 23                	jg     800619 <vprintfmt+0x148>
  8005f6:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  8005fd:	85 d2                	test   %edx,%edx
  8005ff:	74 18                	je     800619 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800601:	52                   	push   %edx
  800602:	68 ad 32 80 00       	push   $0x8032ad
  800607:	53                   	push   %ebx
  800608:	56                   	push   %esi
  800609:	e8 a6 fe ff ff       	call   8004b4 <printfmt>
  80060e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800611:	89 7d 14             	mov    %edi,0x14(%ebp)
  800614:	e9 fe 02 00 00       	jmp    800917 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800619:	50                   	push   %eax
  80061a:	68 73 2d 80 00       	push   $0x802d73
  80061f:	53                   	push   %ebx
  800620:	56                   	push   %esi
  800621:	e8 8e fe ff ff       	call   8004b4 <printfmt>
  800626:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800629:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80062c:	e9 e6 02 00 00       	jmp    800917 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	83 c0 04             	add    $0x4,%eax
  800637:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	b8 6c 2d 80 00       	mov    $0x802d6c,%eax
  800646:	0f 45 c1             	cmovne %ecx,%eax
  800649:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80064c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800650:	7e 06                	jle    800658 <vprintfmt+0x187>
  800652:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800656:	75 0d                	jne    800665 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800658:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065b:	89 c7                	mov    %eax,%edi
  80065d:	03 45 e0             	add    -0x20(%ebp),%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800663:	eb 53                	jmp    8006b8 <vprintfmt+0x1e7>
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 d8             	pushl  -0x28(%ebp)
  80066b:	50                   	push   %eax
  80066c:	e8 71 04 00 00       	call   800ae2 <strnlen>
  800671:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800674:	29 c1                	sub    %eax,%ecx
  800676:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80067e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800685:	eb 0f                	jmp    800696 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	ff 75 e0             	pushl  -0x20(%ebp)
  80068e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	83 ef 01             	sub    $0x1,%edi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	85 ff                	test   %edi,%edi
  800698:	7f ed                	jg     800687 <vprintfmt+0x1b6>
  80069a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80069d:	85 c9                	test   %ecx,%ecx
  80069f:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a4:	0f 49 c1             	cmovns %ecx,%eax
  8006a7:	29 c1                	sub    %eax,%ecx
  8006a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006ac:	eb aa                	jmp    800658 <vprintfmt+0x187>
					putch(ch, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	52                   	push   %edx
  8006b3:	ff d6                	call   *%esi
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006bb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bd:	83 c7 01             	add    $0x1,%edi
  8006c0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c4:	0f be d0             	movsbl %al,%edx
  8006c7:	85 d2                	test   %edx,%edx
  8006c9:	74 4b                	je     800716 <vprintfmt+0x245>
  8006cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006cf:	78 06                	js     8006d7 <vprintfmt+0x206>
  8006d1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006d5:	78 1e                	js     8006f5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006db:	74 d1                	je     8006ae <vprintfmt+0x1dd>
  8006dd:	0f be c0             	movsbl %al,%eax
  8006e0:	83 e8 20             	sub    $0x20,%eax
  8006e3:	83 f8 5e             	cmp    $0x5e,%eax
  8006e6:	76 c6                	jbe    8006ae <vprintfmt+0x1dd>
					putch('?', putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 3f                	push   $0x3f
  8006ee:	ff d6                	call   *%esi
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	eb c3                	jmp    8006b8 <vprintfmt+0x1e7>
  8006f5:	89 cf                	mov    %ecx,%edi
  8006f7:	eb 0e                	jmp    800707 <vprintfmt+0x236>
				putch(' ', putdat);
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	53                   	push   %ebx
  8006fd:	6a 20                	push   $0x20
  8006ff:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800701:	83 ef 01             	sub    $0x1,%edi
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	85 ff                	test   %edi,%edi
  800709:	7f ee                	jg     8006f9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80070b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
  800711:	e9 01 02 00 00       	jmp    800917 <vprintfmt+0x446>
  800716:	89 cf                	mov    %ecx,%edi
  800718:	eb ed                	jmp    800707 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80071d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800724:	e9 eb fd ff ff       	jmp    800514 <vprintfmt+0x43>
	if (lflag >= 2)
  800729:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80072d:	7f 21                	jg     800750 <vprintfmt+0x27f>
	else if (lflag)
  80072f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800733:	74 68                	je     80079d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073d:	89 c1                	mov    %eax,%ecx
  80073f:	c1 f9 1f             	sar    $0x1f,%ecx
  800742:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
  80074e:	eb 17                	jmp    800767 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 50 04             	mov    0x4(%eax),%edx
  800756:	8b 00                	mov    (%eax),%eax
  800758:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 08             	lea    0x8(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800773:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800777:	78 3f                	js     8007b8 <vprintfmt+0x2e7>
			base = 10;
  800779:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80077e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800782:	0f 84 71 01 00 00    	je     8008f9 <vprintfmt+0x428>
				putch('+', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 2b                	push   $0x2b
  80078e:	ff d6                	call   *%esi
  800790:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800793:	b8 0a 00 00 00       	mov    $0xa,%eax
  800798:	e9 5c 01 00 00       	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a5:	89 c1                	mov    %eax,%ecx
  8007a7:	c1 f9 1f             	sar    $0x1f,%ecx
  8007aa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 04             	lea    0x4(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b6:	eb af                	jmp    800767 <vprintfmt+0x296>
				putch('-', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	6a 2d                	push   $0x2d
  8007be:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007c6:	f7 d8                	neg    %eax
  8007c8:	83 d2 00             	adc    $0x0,%edx
  8007cb:	f7 da                	neg    %edx
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007db:	e9 19 01 00 00       	jmp    8008f9 <vprintfmt+0x428>
	if (lflag >= 2)
  8007e0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007e4:	7f 29                	jg     80080f <vprintfmt+0x33e>
	else if (lflag)
  8007e6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ea:	74 44                	je     800830 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800805:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080a:	e9 ea 00 00 00       	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 50 04             	mov    0x4(%eax),%edx
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 08             	lea    0x8(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800826:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082b:	e9 c9 00 00 00       	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800849:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084e:	e9 a6 00 00 00       	jmp    8008f9 <vprintfmt+0x428>
			putch('0', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	6a 30                	push   $0x30
  800859:	ff d6                	call   *%esi
	if (lflag >= 2)
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800862:	7f 26                	jg     80088a <vprintfmt+0x3b9>
	else if (lflag)
  800864:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800868:	74 3e                	je     8008a8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	ba 00 00 00 00       	mov    $0x0,%edx
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800883:	b8 08 00 00 00       	mov    $0x8,%eax
  800888:	eb 6f                	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8d 40 08             	lea    0x8(%eax),%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a6:	eb 51                	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8d 40 04             	lea    0x4(%eax),%eax
  8008be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8008c6:	eb 31                	jmp    8008f9 <vprintfmt+0x428>
			putch('0', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	6a 30                	push   $0x30
  8008ce:	ff d6                	call   *%esi
			putch('x', putdat);
  8008d0:	83 c4 08             	add    $0x8,%esp
  8008d3:	53                   	push   %ebx
  8008d4:	6a 78                	push   $0x78
  8008d6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8d 40 04             	lea    0x4(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008f9:	83 ec 0c             	sub    $0xc,%esp
  8008fc:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800900:	52                   	push   %edx
  800901:	ff 75 e0             	pushl  -0x20(%ebp)
  800904:	50                   	push   %eax
  800905:	ff 75 dc             	pushl  -0x24(%ebp)
  800908:	ff 75 d8             	pushl  -0x28(%ebp)
  80090b:	89 da                	mov    %ebx,%edx
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	e8 a4 fa ff ff       	call   8003b8 <printnum>
			break;
  800914:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091a:	83 c7 01             	add    $0x1,%edi
  80091d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800921:	83 f8 25             	cmp    $0x25,%eax
  800924:	0f 84 be fb ff ff    	je     8004e8 <vprintfmt+0x17>
			if (ch == '\0')
  80092a:	85 c0                	test   %eax,%eax
  80092c:	0f 84 28 01 00 00    	je     800a5a <vprintfmt+0x589>
			putch(ch, putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	50                   	push   %eax
  800937:	ff d6                	call   *%esi
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	eb dc                	jmp    80091a <vprintfmt+0x449>
	if (lflag >= 2)
  80093e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800942:	7f 26                	jg     80096a <vprintfmt+0x499>
	else if (lflag)
  800944:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800948:	74 41                	je     80098b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	ba 00 00 00 00       	mov    $0x0,%edx
  800954:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800957:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8d 40 04             	lea    0x4(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800963:	b8 10 00 00 00       	mov    $0x10,%eax
  800968:	eb 8f                	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 50 04             	mov    0x4(%eax),%edx
  800970:	8b 00                	mov    (%eax),%eax
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	8d 40 08             	lea    0x8(%eax),%eax
  80097e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800981:	b8 10 00 00 00       	mov    $0x10,%eax
  800986:	e9 6e ff ff ff       	jmp    8008f9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800998:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8d 40 04             	lea    0x4(%eax),%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a4:	b8 10 00 00 00       	mov    $0x10,%eax
  8009a9:	e9 4b ff ff ff       	jmp    8008f9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	83 c0 04             	add    $0x4,%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	74 14                	je     8009d4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009c0:	8b 13                	mov    (%ebx),%edx
  8009c2:	83 fa 7f             	cmp    $0x7f,%edx
  8009c5:	7f 37                	jg     8009fe <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009c7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cf:	e9 43 ff ff ff       	jmp    800917 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d9:	bf 91 2e 80 00       	mov    $0x802e91,%edi
							putch(ch, putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	53                   	push   %ebx
  8009e2:	50                   	push   %eax
  8009e3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009e5:	83 c7 01             	add    $0x1,%edi
  8009e8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	75 eb                	jne    8009de <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f9:	e9 19 ff ff ff       	jmp    800917 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009fe:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a05:	bf c9 2e 80 00       	mov    $0x802ec9,%edi
							putch(ch, putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	53                   	push   %ebx
  800a0e:	50                   	push   %eax
  800a0f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a11:	83 c7 01             	add    $0x1,%edi
  800a14:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	75 eb                	jne    800a0a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
  800a25:	e9 ed fe ff ff       	jmp    800917 <vprintfmt+0x446>
			putch(ch, putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	53                   	push   %ebx
  800a2e:	6a 25                	push   $0x25
  800a30:	ff d6                	call   *%esi
			break;
  800a32:	83 c4 10             	add    $0x10,%esp
  800a35:	e9 dd fe ff ff       	jmp    800917 <vprintfmt+0x446>
			putch('%', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	53                   	push   %ebx
  800a3e:	6a 25                	push   $0x25
  800a40:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	89 f8                	mov    %edi,%eax
  800a47:	eb 03                	jmp    800a4c <vprintfmt+0x57b>
  800a49:	83 e8 01             	sub    $0x1,%eax
  800a4c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a50:	75 f7                	jne    800a49 <vprintfmt+0x578>
  800a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a55:	e9 bd fe ff ff       	jmp    800917 <vprintfmt+0x446>
}
  800a5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5e                   	pop    %esi
  800a5f:	5f                   	pop    %edi
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 18             	sub    $0x18,%esp
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a71:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a75:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	74 26                	je     800aa9 <vsnprintf+0x47>
  800a83:	85 d2                	test   %edx,%edx
  800a85:	7e 22                	jle    800aa9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a87:	ff 75 14             	pushl  0x14(%ebp)
  800a8a:	ff 75 10             	pushl  0x10(%ebp)
  800a8d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	68 97 04 80 00       	push   $0x800497
  800a96:	e8 36 fa ff ff       	call   8004d1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a9e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    
		return -E_INVAL;
  800aa9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aae:	eb f7                	jmp    800aa7 <vsnprintf+0x45>

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ab9:	50                   	push   %eax
  800aba:	ff 75 10             	pushl  0x10(%ebp)
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	ff 75 08             	pushl  0x8(%ebp)
  800ac3:	e8 9a ff ff ff       	call   800a62 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad9:	74 05                	je     800ae0 <strlen+0x16>
		n++;
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	eb f5                	jmp    800ad5 <strlen+0xb>
	return n;
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	39 c2                	cmp    %eax,%edx
  800af2:	74 0d                	je     800b01 <strnlen+0x1f>
  800af4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800af8:	74 05                	je     800aff <strnlen+0x1d>
		n++;
  800afa:	83 c2 01             	add    $0x1,%edx
  800afd:	eb f1                	jmp    800af0 <strnlen+0xe>
  800aff:	89 d0                	mov    %edx,%eax
	return n;
}
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b16:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b19:	83 c2 01             	add    $0x1,%edx
  800b1c:	84 c9                	test   %cl,%cl
  800b1e:	75 f2                	jne    800b12 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b20:	5b                   	pop    %ebx
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	53                   	push   %ebx
  800b27:	83 ec 10             	sub    $0x10,%esp
  800b2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b2d:	53                   	push   %ebx
  800b2e:	e8 97 ff ff ff       	call   800aca <strlen>
  800b33:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	01 d8                	add    %ebx,%eax
  800b3b:	50                   	push   %eax
  800b3c:	e8 c2 ff ff ff       	call   800b03 <strcpy>
	return dst;
}
  800b41:	89 d8                	mov    %ebx,%eax
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	39 f2                	cmp    %esi,%edx
  800b5c:	74 11                	je     800b6f <strncpy+0x27>
		*dst++ = *src;
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	0f b6 19             	movzbl (%ecx),%ebx
  800b64:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b67:	80 fb 01             	cmp    $0x1,%bl
  800b6a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b6d:	eb eb                	jmp    800b5a <strncpy+0x12>
	}
	return ret;
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	8b 75 08             	mov    0x8(%ebp),%esi
  800b7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7e:	8b 55 10             	mov    0x10(%ebp),%edx
  800b81:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b83:	85 d2                	test   %edx,%edx
  800b85:	74 21                	je     800ba8 <strlcpy+0x35>
  800b87:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b8b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b8d:	39 c2                	cmp    %eax,%edx
  800b8f:	74 14                	je     800ba5 <strlcpy+0x32>
  800b91:	0f b6 19             	movzbl (%ecx),%ebx
  800b94:	84 db                	test   %bl,%bl
  800b96:	74 0b                	je     800ba3 <strlcpy+0x30>
			*dst++ = *src++;
  800b98:	83 c1 01             	add    $0x1,%ecx
  800b9b:	83 c2 01             	add    $0x1,%edx
  800b9e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ba1:	eb ea                	jmp    800b8d <strlcpy+0x1a>
  800ba3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ba5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba8:	29 f0                	sub    %esi,%eax
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bb7:	0f b6 01             	movzbl (%ecx),%eax
  800bba:	84 c0                	test   %al,%al
  800bbc:	74 0c                	je     800bca <strcmp+0x1c>
  800bbe:	3a 02                	cmp    (%edx),%al
  800bc0:	75 08                	jne    800bca <strcmp+0x1c>
		p++, q++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	eb ed                	jmp    800bb7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bca:	0f b6 c0             	movzbl %al,%eax
  800bcd:	0f b6 12             	movzbl (%edx),%edx
  800bd0:	29 d0                	sub    %edx,%eax
}
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800be3:	eb 06                	jmp    800beb <strncmp+0x17>
		n--, p++, q++;
  800be5:	83 c0 01             	add    $0x1,%eax
  800be8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800beb:	39 d8                	cmp    %ebx,%eax
  800bed:	74 16                	je     800c05 <strncmp+0x31>
  800bef:	0f b6 08             	movzbl (%eax),%ecx
  800bf2:	84 c9                	test   %cl,%cl
  800bf4:	74 04                	je     800bfa <strncmp+0x26>
  800bf6:	3a 0a                	cmp    (%edx),%cl
  800bf8:	74 eb                	je     800be5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bfa:	0f b6 00             	movzbl (%eax),%eax
  800bfd:	0f b6 12             	movzbl (%edx),%edx
  800c00:	29 d0                	sub    %edx,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    
		return 0;
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	eb f6                	jmp    800c02 <strncmp+0x2e>

00800c0c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c16:	0f b6 10             	movzbl (%eax),%edx
  800c19:	84 d2                	test   %dl,%dl
  800c1b:	74 09                	je     800c26 <strchr+0x1a>
		if (*s == c)
  800c1d:	38 ca                	cmp    %cl,%dl
  800c1f:	74 0a                	je     800c2b <strchr+0x1f>
	for (; *s; s++)
  800c21:	83 c0 01             	add    $0x1,%eax
  800c24:	eb f0                	jmp    800c16 <strchr+0xa>
			return (char *) s;
	return 0;
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c37:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c3a:	38 ca                	cmp    %cl,%dl
  800c3c:	74 09                	je     800c47 <strfind+0x1a>
  800c3e:	84 d2                	test   %dl,%dl
  800c40:	74 05                	je     800c47 <strfind+0x1a>
	for (; *s; s++)
  800c42:	83 c0 01             	add    $0x1,%eax
  800c45:	eb f0                	jmp    800c37 <strfind+0xa>
			break;
	return (char *) s;
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c55:	85 c9                	test   %ecx,%ecx
  800c57:	74 31                	je     800c8a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c59:	89 f8                	mov    %edi,%eax
  800c5b:	09 c8                	or     %ecx,%eax
  800c5d:	a8 03                	test   $0x3,%al
  800c5f:	75 23                	jne    800c84 <memset+0x3b>
		c &= 0xFF;
  800c61:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c65:	89 d3                	mov    %edx,%ebx
  800c67:	c1 e3 08             	shl    $0x8,%ebx
  800c6a:	89 d0                	mov    %edx,%eax
  800c6c:	c1 e0 18             	shl    $0x18,%eax
  800c6f:	89 d6                	mov    %edx,%esi
  800c71:	c1 e6 10             	shl    $0x10,%esi
  800c74:	09 f0                	or     %esi,%eax
  800c76:	09 c2                	or     %eax,%edx
  800c78:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c7a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c7d:	89 d0                	mov    %edx,%eax
  800c7f:	fc                   	cld    
  800c80:	f3 ab                	rep stos %eax,%es:(%edi)
  800c82:	eb 06                	jmp    800c8a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	fc                   	cld    
  800c88:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c8a:	89 f8                	mov    %edi,%eax
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c9f:	39 c6                	cmp    %eax,%esi
  800ca1:	73 32                	jae    800cd5 <memmove+0x44>
  800ca3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca6:	39 c2                	cmp    %eax,%edx
  800ca8:	76 2b                	jbe    800cd5 <memmove+0x44>
		s += n;
		d += n;
  800caa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cad:	89 fe                	mov    %edi,%esi
  800caf:	09 ce                	or     %ecx,%esi
  800cb1:	09 d6                	or     %edx,%esi
  800cb3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cb9:	75 0e                	jne    800cc9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cbb:	83 ef 04             	sub    $0x4,%edi
  800cbe:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cc4:	fd                   	std    
  800cc5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc7:	eb 09                	jmp    800cd2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cc9:	83 ef 01             	sub    $0x1,%edi
  800ccc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ccf:	fd                   	std    
  800cd0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd2:	fc                   	cld    
  800cd3:	eb 1a                	jmp    800cef <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd5:	89 c2                	mov    %eax,%edx
  800cd7:	09 ca                	or     %ecx,%edx
  800cd9:	09 f2                	or     %esi,%edx
  800cdb:	f6 c2 03             	test   $0x3,%dl
  800cde:	75 0a                	jne    800cea <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ce3:	89 c7                	mov    %eax,%edi
  800ce5:	fc                   	cld    
  800ce6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce8:	eb 05                	jmp    800cef <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cea:	89 c7                	mov    %eax,%edi
  800cec:	fc                   	cld    
  800ced:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf9:	ff 75 10             	pushl  0x10(%ebp)
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	ff 75 08             	pushl  0x8(%ebp)
  800d02:	e8 8a ff ff ff       	call   800c91 <memmove>
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d14:	89 c6                	mov    %eax,%esi
  800d16:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d19:	39 f0                	cmp    %esi,%eax
  800d1b:	74 1c                	je     800d39 <memcmp+0x30>
		if (*s1 != *s2)
  800d1d:	0f b6 08             	movzbl (%eax),%ecx
  800d20:	0f b6 1a             	movzbl (%edx),%ebx
  800d23:	38 d9                	cmp    %bl,%cl
  800d25:	75 08                	jne    800d2f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d27:	83 c0 01             	add    $0x1,%eax
  800d2a:	83 c2 01             	add    $0x1,%edx
  800d2d:	eb ea                	jmp    800d19 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d2f:	0f b6 c1             	movzbl %cl,%eax
  800d32:	0f b6 db             	movzbl %bl,%ebx
  800d35:	29 d8                	sub    %ebx,%eax
  800d37:	eb 05                	jmp    800d3e <memcmp+0x35>
	}

	return 0;
  800d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d4b:	89 c2                	mov    %eax,%edx
  800d4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d50:	39 d0                	cmp    %edx,%eax
  800d52:	73 09                	jae    800d5d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d54:	38 08                	cmp    %cl,(%eax)
  800d56:	74 05                	je     800d5d <memfind+0x1b>
	for (; s < ends; s++)
  800d58:	83 c0 01             	add    $0x1,%eax
  800d5b:	eb f3                	jmp    800d50 <memfind+0xe>
			break;
	return (void *) s;
}
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6b:	eb 03                	jmp    800d70 <strtol+0x11>
		s++;
  800d6d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d70:	0f b6 01             	movzbl (%ecx),%eax
  800d73:	3c 20                	cmp    $0x20,%al
  800d75:	74 f6                	je     800d6d <strtol+0xe>
  800d77:	3c 09                	cmp    $0x9,%al
  800d79:	74 f2                	je     800d6d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d7b:	3c 2b                	cmp    $0x2b,%al
  800d7d:	74 2a                	je     800da9 <strtol+0x4a>
	int neg = 0;
  800d7f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d84:	3c 2d                	cmp    $0x2d,%al
  800d86:	74 2b                	je     800db3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d88:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d8e:	75 0f                	jne    800d9f <strtol+0x40>
  800d90:	80 39 30             	cmpb   $0x30,(%ecx)
  800d93:	74 28                	je     800dbd <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d95:	85 db                	test   %ebx,%ebx
  800d97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d9c:	0f 44 d8             	cmove  %eax,%ebx
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800da7:	eb 50                	jmp    800df9 <strtol+0x9a>
		s++;
  800da9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dac:	bf 00 00 00 00       	mov    $0x0,%edi
  800db1:	eb d5                	jmp    800d88 <strtol+0x29>
		s++, neg = 1;
  800db3:	83 c1 01             	add    $0x1,%ecx
  800db6:	bf 01 00 00 00       	mov    $0x1,%edi
  800dbb:	eb cb                	jmp    800d88 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dbd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dc1:	74 0e                	je     800dd1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dc3:	85 db                	test   %ebx,%ebx
  800dc5:	75 d8                	jne    800d9f <strtol+0x40>
		s++, base = 8;
  800dc7:	83 c1 01             	add    $0x1,%ecx
  800dca:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dcf:	eb ce                	jmp    800d9f <strtol+0x40>
		s += 2, base = 16;
  800dd1:	83 c1 02             	add    $0x2,%ecx
  800dd4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dd9:	eb c4                	jmp    800d9f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ddb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dde:	89 f3                	mov    %esi,%ebx
  800de0:	80 fb 19             	cmp    $0x19,%bl
  800de3:	77 29                	ja     800e0e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800de5:	0f be d2             	movsbl %dl,%edx
  800de8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800deb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dee:	7d 30                	jge    800e20 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800df0:	83 c1 01             	add    $0x1,%ecx
  800df3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800df7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800df9:	0f b6 11             	movzbl (%ecx),%edx
  800dfc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dff:	89 f3                	mov    %esi,%ebx
  800e01:	80 fb 09             	cmp    $0x9,%bl
  800e04:	77 d5                	ja     800ddb <strtol+0x7c>
			dig = *s - '0';
  800e06:	0f be d2             	movsbl %dl,%edx
  800e09:	83 ea 30             	sub    $0x30,%edx
  800e0c:	eb dd                	jmp    800deb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e11:	89 f3                	mov    %esi,%ebx
  800e13:	80 fb 19             	cmp    $0x19,%bl
  800e16:	77 08                	ja     800e20 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e18:	0f be d2             	movsbl %dl,%edx
  800e1b:	83 ea 37             	sub    $0x37,%edx
  800e1e:	eb cb                	jmp    800deb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e24:	74 05                	je     800e2b <strtol+0xcc>
		*endptr = (char *) s;
  800e26:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e29:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	f7 da                	neg    %edx
  800e2f:	85 ff                	test   %edi,%edi
  800e31:	0f 45 c2             	cmovne %edx,%eax
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	89 c3                	mov    %eax,%ebx
  800e4c:	89 c7                	mov    %eax,%edi
  800e4e:	89 c6                	mov    %eax,%esi
  800e50:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e62:	b8 01 00 00 00       	mov    $0x1,%eax
  800e67:	89 d1                	mov    %edx,%ecx
  800e69:	89 d3                	mov    %edx,%ebx
  800e6b:	89 d7                	mov    %edx,%edi
  800e6d:	89 d6                	mov    %edx,%esi
  800e6f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	b8 03 00 00 00       	mov    $0x3,%eax
  800e8c:	89 cb                	mov    %ecx,%ebx
  800e8e:	89 cf                	mov    %ecx,%edi
  800e90:	89 ce                	mov    %ecx,%esi
  800e92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 03                	push   $0x3
  800ea6:	68 e8 30 80 00       	push   $0x8030e8
  800eab:	6a 43                	push   $0x43
  800ead:	68 05 31 80 00       	push   $0x803105
  800eb2:	e8 f7 f3 ff ff       	call   8002ae <_panic>

00800eb7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ec7:	89 d1                	mov    %edx,%ecx
  800ec9:	89 d3                	mov    %edx,%ebx
  800ecb:	89 d7                	mov    %edx,%edi
  800ecd:	89 d6                	mov    %edx,%esi
  800ecf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_yield>:

void
sys_yield(void)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee6:	89 d1                	mov    %edx,%ecx
  800ee8:	89 d3                	mov    %edx,%ebx
  800eea:	89 d7                	mov    %edx,%edi
  800eec:	89 d6                	mov    %edx,%esi
  800eee:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
  800efb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efe:	be 00 00 00 00       	mov    $0x0,%esi
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	b8 04 00 00 00       	mov    $0x4,%eax
  800f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f11:	89 f7                	mov    %esi,%edi
  800f13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f15:	85 c0                	test   %eax,%eax
  800f17:	7f 08                	jg     800f21 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	50                   	push   %eax
  800f25:	6a 04                	push   $0x4
  800f27:	68 e8 30 80 00       	push   $0x8030e8
  800f2c:	6a 43                	push   $0x43
  800f2e:	68 05 31 80 00       	push   $0x803105
  800f33:	e8 76 f3 ff ff       	call   8002ae <_panic>

00800f38 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
  800f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f47:	b8 05 00 00 00       	mov    $0x5,%eax
  800f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	8b 75 18             	mov    0x18(%ebp),%esi
  800f55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7f 08                	jg     800f63 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	50                   	push   %eax
  800f67:	6a 05                	push   $0x5
  800f69:	68 e8 30 80 00       	push   $0x8030e8
  800f6e:	6a 43                	push   $0x43
  800f70:	68 05 31 80 00       	push   $0x803105
  800f75:	e8 34 f3 ff ff       	call   8002ae <_panic>

00800f7a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7f 08                	jg     800fa5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa5:	83 ec 0c             	sub    $0xc,%esp
  800fa8:	50                   	push   %eax
  800fa9:	6a 06                	push   $0x6
  800fab:	68 e8 30 80 00       	push   $0x8030e8
  800fb0:	6a 43                	push   $0x43
  800fb2:	68 05 31 80 00       	push   $0x803105
  800fb7:	e8 f2 f2 ff ff       	call   8002ae <_panic>

00800fbc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
  800fc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd5:	89 df                	mov    %ebx,%edi
  800fd7:	89 de                	mov    %ebx,%esi
  800fd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	7f 08                	jg     800fe7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe7:	83 ec 0c             	sub    $0xc,%esp
  800fea:	50                   	push   %eax
  800feb:	6a 08                	push   $0x8
  800fed:	68 e8 30 80 00       	push   $0x8030e8
  800ff2:	6a 43                	push   $0x43
  800ff4:	68 05 31 80 00       	push   $0x803105
  800ff9:	e8 b0 f2 ff ff       	call   8002ae <_panic>

00800ffe <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801007:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	b8 09 00 00 00       	mov    $0x9,%eax
  801017:	89 df                	mov    %ebx,%edi
  801019:	89 de                	mov    %ebx,%esi
  80101b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	7f 08                	jg     801029 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	50                   	push   %eax
  80102d:	6a 09                	push   $0x9
  80102f:	68 e8 30 80 00       	push   $0x8030e8
  801034:	6a 43                	push   $0x43
  801036:	68 05 31 80 00       	push   $0x803105
  80103b:	e8 6e f2 ff ff       	call   8002ae <_panic>

00801040 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
  801046:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801049:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801054:	b8 0a 00 00 00       	mov    $0xa,%eax
  801059:	89 df                	mov    %ebx,%edi
  80105b:	89 de                	mov    %ebx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	50                   	push   %eax
  80106f:	6a 0a                	push   $0xa
  801071:	68 e8 30 80 00       	push   $0x8030e8
  801076:	6a 43                	push   $0x43
  801078:	68 05 31 80 00       	push   $0x803105
  80107d:	e8 2c f2 ff ff       	call   8002ae <_panic>

00801082 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
	asm volatile("int %1\n"
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801093:	be 00 00 00 00       	mov    $0x0,%esi
  801098:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80109b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80109e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010bb:	89 cb                	mov    %ecx,%ebx
  8010bd:	89 cf                	mov    %ecx,%edi
  8010bf:	89 ce                	mov    %ecx,%esi
  8010c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	7f 08                	jg     8010cf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	50                   	push   %eax
  8010d3:	6a 0d                	push   $0xd
  8010d5:	68 e8 30 80 00       	push   $0x8030e8
  8010da:	6a 43                	push   $0x43
  8010dc:	68 05 31 80 00       	push   $0x803105
  8010e1:	e8 c8 f1 ff ff       	call   8002ae <_panic>

008010e6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010fc:	89 df                	mov    %ebx,%edi
  8010fe:	89 de                	mov    %ebx,%esi
  801100:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801112:	8b 55 08             	mov    0x8(%ebp),%edx
  801115:	b8 0f 00 00 00       	mov    $0xf,%eax
  80111a:	89 cb                	mov    %ecx,%ebx
  80111c:	89 cf                	mov    %ecx,%edi
  80111e:	89 ce                	mov    %ecx,%esi
  801120:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	57                   	push   %edi
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112d:	ba 00 00 00 00       	mov    $0x0,%edx
  801132:	b8 10 00 00 00       	mov    $0x10,%eax
  801137:	89 d1                	mov    %edx,%ecx
  801139:	89 d3                	mov    %edx,%ebx
  80113b:	89 d7                	mov    %edx,%edi
  80113d:	89 d6                	mov    %edx,%esi
  80113f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801157:	b8 11 00 00 00       	mov    $0x11,%eax
  80115c:	89 df                	mov    %ebx,%edi
  80115e:	89 de                	mov    %ebx,%esi
  801160:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	57                   	push   %edi
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801178:	b8 12 00 00 00       	mov    $0x12,%eax
  80117d:	89 df                	mov    %ebx,%edi
  80117f:	89 de                	mov    %ebx,%esi
  801181:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801191:	bb 00 00 00 00       	mov    $0x0,%ebx
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119c:	b8 13 00 00 00       	mov    $0x13,%eax
  8011a1:	89 df                	mov    %ebx,%edi
  8011a3:	89 de                	mov    %ebx,%esi
  8011a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	7f 08                	jg     8011b3 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ae:	5b                   	pop    %ebx
  8011af:	5e                   	pop    %esi
  8011b0:	5f                   	pop    %edi
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	50                   	push   %eax
  8011b7:	6a 13                	push   $0x13
  8011b9:	68 e8 30 80 00       	push   $0x8030e8
  8011be:	6a 43                	push   $0x43
  8011c0:	68 05 31 80 00       	push   $0x803105
  8011c5:	e8 e4 f0 ff ff       	call   8002ae <_panic>

008011ca <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	b8 14 00 00 00       	mov    $0x14,%eax
  8011dd:	89 cb                	mov    %ecx,%ebx
  8011df:	89 cf                	mov    %ecx,%edi
  8011e1:	89 ce                	mov    %ecx,%esi
  8011e3:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011f1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011f8:	f6 c5 04             	test   $0x4,%ch
  8011fb:	75 45                	jne    801242 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011fd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801204:	83 e1 07             	and    $0x7,%ecx
  801207:	83 f9 07             	cmp    $0x7,%ecx
  80120a:	74 6f                	je     80127b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80120c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801213:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801219:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80121f:	0f 84 b6 00 00 00    	je     8012db <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801225:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80122c:	83 e1 05             	and    $0x5,%ecx
  80122f:	83 f9 05             	cmp    $0x5,%ecx
  801232:	0f 84 d7 00 00 00    	je     80130f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
  80123d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801240:	c9                   	leave  
  801241:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801242:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801249:	c1 e2 0c             	shl    $0xc,%edx
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801255:	51                   	push   %ecx
  801256:	52                   	push   %edx
  801257:	50                   	push   %eax
  801258:	52                   	push   %edx
  801259:	6a 00                	push   $0x0
  80125b:	e8 d8 fc ff ff       	call   800f38 <sys_page_map>
		if(r < 0)
  801260:	83 c4 20             	add    $0x20,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	79 d1                	jns    801238 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	68 13 31 80 00       	push   $0x803113
  80126f:	6a 54                	push   $0x54
  801271:	68 29 31 80 00       	push   $0x803129
  801276:	e8 33 f0 ff ff       	call   8002ae <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80127b:	89 d3                	mov    %edx,%ebx
  80127d:	c1 e3 0c             	shl    $0xc,%ebx
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	68 05 08 00 00       	push   $0x805
  801288:	53                   	push   %ebx
  801289:	50                   	push   %eax
  80128a:	53                   	push   %ebx
  80128b:	6a 00                	push   $0x0
  80128d:	e8 a6 fc ff ff       	call   800f38 <sys_page_map>
		if(r < 0)
  801292:	83 c4 20             	add    $0x20,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	78 2e                	js     8012c7 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	68 05 08 00 00       	push   $0x805
  8012a1:	53                   	push   %ebx
  8012a2:	6a 00                	push   $0x0
  8012a4:	53                   	push   %ebx
  8012a5:	6a 00                	push   $0x0
  8012a7:	e8 8c fc ff ff       	call   800f38 <sys_page_map>
		if(r < 0)
  8012ac:	83 c4 20             	add    $0x20,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	79 85                	jns    801238 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	68 13 31 80 00       	push   $0x803113
  8012bb:	6a 5f                	push   $0x5f
  8012bd:	68 29 31 80 00       	push   $0x803129
  8012c2:	e8 e7 ef ff ff       	call   8002ae <_panic>
			panic("sys_page_map() panic\n");
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	68 13 31 80 00       	push   $0x803113
  8012cf:	6a 5b                	push   $0x5b
  8012d1:	68 29 31 80 00       	push   $0x803129
  8012d6:	e8 d3 ef ff ff       	call   8002ae <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012db:	c1 e2 0c             	shl    $0xc,%edx
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	68 05 08 00 00       	push   $0x805
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	52                   	push   %edx
  8012e9:	6a 00                	push   $0x0
  8012eb:	e8 48 fc ff ff       	call   800f38 <sys_page_map>
		if(r < 0)
  8012f0:	83 c4 20             	add    $0x20,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	0f 89 3d ff ff ff    	jns    801238 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	68 13 31 80 00       	push   $0x803113
  801303:	6a 66                	push   $0x66
  801305:	68 29 31 80 00       	push   $0x803129
  80130a:	e8 9f ef ff ff       	call   8002ae <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80130f:	c1 e2 0c             	shl    $0xc,%edx
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	6a 05                	push   $0x5
  801317:	52                   	push   %edx
  801318:	50                   	push   %eax
  801319:	52                   	push   %edx
  80131a:	6a 00                	push   $0x0
  80131c:	e8 17 fc ff ff       	call   800f38 <sys_page_map>
		if(r < 0)
  801321:	83 c4 20             	add    $0x20,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	0f 89 0c ff ff ff    	jns    801238 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	68 13 31 80 00       	push   $0x803113
  801334:	6a 6d                	push   $0x6d
  801336:	68 29 31 80 00       	push   $0x803129
  80133b:	e8 6e ef ff ff       	call   8002ae <_panic>

00801340 <pgfault>:
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	53                   	push   %ebx
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80134a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80134c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801350:	0f 84 99 00 00 00    	je     8013ef <pgfault+0xaf>
  801356:	89 c2                	mov    %eax,%edx
  801358:	c1 ea 16             	shr    $0x16,%edx
  80135b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801362:	f6 c2 01             	test   $0x1,%dl
  801365:	0f 84 84 00 00 00    	je     8013ef <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	c1 ea 0c             	shr    $0xc,%edx
  801370:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801377:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80137d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801383:	75 6a                	jne    8013ef <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	6a 07                	push   $0x7
  801391:	68 00 f0 7f 00       	push   $0x7ff000
  801396:	6a 00                	push   $0x0
  801398:	e8 58 fb ff ff       	call   800ef5 <sys_page_alloc>
	if(ret < 0)
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 5f                	js     801403 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013a4:	83 ec 04             	sub    $0x4,%esp
  8013a7:	68 00 10 00 00       	push   $0x1000
  8013ac:	53                   	push   %ebx
  8013ad:	68 00 f0 7f 00       	push   $0x7ff000
  8013b2:	e8 3c f9 ff ff       	call   800cf3 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013b7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013be:	53                   	push   %ebx
  8013bf:	6a 00                	push   $0x0
  8013c1:	68 00 f0 7f 00       	push   $0x7ff000
  8013c6:	6a 00                	push   $0x0
  8013c8:	e8 6b fb ff ff       	call   800f38 <sys_page_map>
	if(ret < 0)
  8013cd:	83 c4 20             	add    $0x20,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 43                	js     801417 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	68 00 f0 7f 00       	push   $0x7ff000
  8013dc:	6a 00                	push   $0x0
  8013de:	e8 97 fb ff ff       	call   800f7a <sys_page_unmap>
	if(ret < 0)
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 41                	js     80142b <pgfault+0xeb>
}
  8013ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	68 34 31 80 00       	push   $0x803134
  8013f7:	6a 26                	push   $0x26
  8013f9:	68 29 31 80 00       	push   $0x803129
  8013fe:	e8 ab ee ff ff       	call   8002ae <_panic>
		panic("panic in sys_page_alloc()\n");
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 48 31 80 00       	push   $0x803148
  80140b:	6a 31                	push   $0x31
  80140d:	68 29 31 80 00       	push   $0x803129
  801412:	e8 97 ee ff ff       	call   8002ae <_panic>
		panic("panic in sys_page_map()\n");
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	68 63 31 80 00       	push   $0x803163
  80141f:	6a 36                	push   $0x36
  801421:	68 29 31 80 00       	push   $0x803129
  801426:	e8 83 ee ff ff       	call   8002ae <_panic>
		panic("panic in sys_page_unmap()\n");
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	68 7c 31 80 00       	push   $0x80317c
  801433:	6a 39                	push   $0x39
  801435:	68 29 31 80 00       	push   $0x803129
  80143a:	e8 6f ee ff ff       	call   8002ae <_panic>

0080143f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801448:	68 40 13 80 00       	push   $0x801340
  80144d:	e8 db 13 00 00       	call   80282d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801452:	b8 07 00 00 00       	mov    $0x7,%eax
  801457:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 2a                	js     80148a <fork+0x4b>
  801460:	89 c6                	mov    %eax,%esi
  801462:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801464:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801469:	75 4b                	jne    8014b6 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80146b:	e8 47 fa ff ff       	call   800eb7 <sys_getenvid>
  801470:	25 ff 03 00 00       	and    $0x3ff,%eax
  801475:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80147b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801480:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801485:	e9 90 00 00 00       	jmp    80151a <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 98 31 80 00       	push   $0x803198
  801492:	68 8c 00 00 00       	push   $0x8c
  801497:	68 29 31 80 00       	push   $0x803129
  80149c:	e8 0d ee ff ff       	call   8002ae <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014a1:	89 f8                	mov    %edi,%eax
  8014a3:	e8 42 fd ff ff       	call   8011ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ae:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014b4:	74 26                	je     8014dc <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014b6:	89 d8                	mov    %ebx,%eax
  8014b8:	c1 e8 16             	shr    $0x16,%eax
  8014bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c2:	a8 01                	test   $0x1,%al
  8014c4:	74 e2                	je     8014a8 <fork+0x69>
  8014c6:	89 da                	mov    %ebx,%edx
  8014c8:	c1 ea 0c             	shr    $0xc,%edx
  8014cb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014d2:	83 e0 05             	and    $0x5,%eax
  8014d5:	83 f8 05             	cmp    $0x5,%eax
  8014d8:	75 ce                	jne    8014a8 <fork+0x69>
  8014da:	eb c5                	jmp    8014a1 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	6a 07                	push   $0x7
  8014e1:	68 00 f0 bf ee       	push   $0xeebff000
  8014e6:	56                   	push   %esi
  8014e7:	e8 09 fa ff ff       	call   800ef5 <sys_page_alloc>
	if(ret < 0)
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 31                	js     801524 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	68 9c 28 80 00       	push   $0x80289c
  8014fb:	56                   	push   %esi
  8014fc:	e8 3f fb ff ff       	call   801040 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 33                	js     80153b <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	6a 02                	push   $0x2
  80150d:	56                   	push   %esi
  80150e:	e8 a9 fa ff ff       	call   800fbc <sys_env_set_status>
	if(ret < 0)
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 38                	js     801552 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80151a:	89 f0                	mov    %esi,%eax
  80151c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5f                   	pop    %edi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 48 31 80 00       	push   $0x803148
  80152c:	68 98 00 00 00       	push   $0x98
  801531:	68 29 31 80 00       	push   $0x803129
  801536:	e8 73 ed ff ff       	call   8002ae <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	68 bc 31 80 00       	push   $0x8031bc
  801543:	68 9b 00 00 00       	push   $0x9b
  801548:	68 29 31 80 00       	push   $0x803129
  80154d:	e8 5c ed ff ff       	call   8002ae <_panic>
		panic("panic in sys_env_set_status()\n");
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 e4 31 80 00       	push   $0x8031e4
  80155a:	68 9e 00 00 00       	push   $0x9e
  80155f:	68 29 31 80 00       	push   $0x803129
  801564:	e8 45 ed ff ff       	call   8002ae <_panic>

00801569 <sfork>:

// Challenge!
int
sfork(void)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	57                   	push   %edi
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801572:	68 40 13 80 00       	push   $0x801340
  801577:	e8 b1 12 00 00       	call   80282d <set_pgfault_handler>
  80157c:	b8 07 00 00 00       	mov    $0x7,%eax
  801581:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	85 c0                	test   %eax,%eax
  801588:	78 2a                	js     8015b4 <sfork+0x4b>
  80158a:	89 c7                	mov    %eax,%edi
  80158c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80158e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801593:	75 58                	jne    8015ed <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801595:	e8 1d f9 ff ff       	call   800eb7 <sys_getenvid>
  80159a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80159f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015aa:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015af:	e9 d4 00 00 00       	jmp    801688 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 98 31 80 00       	push   $0x803198
  8015bc:	68 af 00 00 00       	push   $0xaf
  8015c1:	68 29 31 80 00       	push   $0x803129
  8015c6:	e8 e3 ec ff ff       	call   8002ae <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015cb:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015d0:	89 f0                	mov    %esi,%eax
  8015d2:	e8 13 fc ff ff       	call   8011ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015dd:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015e3:	77 65                	ja     80164a <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8015e5:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015eb:	74 de                	je     8015cb <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015ed:	89 d8                	mov    %ebx,%eax
  8015ef:	c1 e8 16             	shr    $0x16,%eax
  8015f2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f9:	a8 01                	test   $0x1,%al
  8015fb:	74 da                	je     8015d7 <sfork+0x6e>
  8015fd:	89 da                	mov    %ebx,%edx
  8015ff:	c1 ea 0c             	shr    $0xc,%edx
  801602:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801609:	83 e0 05             	and    $0x5,%eax
  80160c:	83 f8 05             	cmp    $0x5,%eax
  80160f:	75 c6                	jne    8015d7 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801611:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801618:	c1 e2 0c             	shl    $0xc,%edx
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	83 e0 07             	and    $0x7,%eax
  801621:	50                   	push   %eax
  801622:	52                   	push   %edx
  801623:	56                   	push   %esi
  801624:	52                   	push   %edx
  801625:	6a 00                	push   $0x0
  801627:	e8 0c f9 ff ff       	call   800f38 <sys_page_map>
  80162c:	83 c4 20             	add    $0x20,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 a4                	je     8015d7 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	68 13 31 80 00       	push   $0x803113
  80163b:	68 ba 00 00 00       	push   $0xba
  801640:	68 29 31 80 00       	push   $0x803129
  801645:	e8 64 ec ff ff       	call   8002ae <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	6a 07                	push   $0x7
  80164f:	68 00 f0 bf ee       	push   $0xeebff000
  801654:	57                   	push   %edi
  801655:	e8 9b f8 ff ff       	call   800ef5 <sys_page_alloc>
	if(ret < 0)
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 31                	js     801692 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	68 9c 28 80 00       	push   $0x80289c
  801669:	57                   	push   %edi
  80166a:	e8 d1 f9 ff ff       	call   801040 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 33                	js     8016a9 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	6a 02                	push   $0x2
  80167b:	57                   	push   %edi
  80167c:	e8 3b f9 ff ff       	call   800fbc <sys_env_set_status>
	if(ret < 0)
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 38                	js     8016c0 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801688:	89 f8                	mov    %edi,%eax
  80168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	68 48 31 80 00       	push   $0x803148
  80169a:	68 c0 00 00 00       	push   $0xc0
  80169f:	68 29 31 80 00       	push   $0x803129
  8016a4:	e8 05 ec ff ff       	call   8002ae <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 bc 31 80 00       	push   $0x8031bc
  8016b1:	68 c3 00 00 00       	push   $0xc3
  8016b6:	68 29 31 80 00       	push   $0x803129
  8016bb:	e8 ee eb ff ff       	call   8002ae <_panic>
		panic("panic in sys_env_set_status()\n");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 e4 31 80 00       	push   $0x8031e4
  8016c8:	68 c6 00 00 00       	push   $0xc6
  8016cd:	68 29 31 80 00       	push   $0x803129
  8016d2:	e8 d7 eb ff ff       	call   8002ae <_panic>

008016d7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	05 00 00 00 30       	add    $0x30000000,%eax
  8016e2:	c1 e8 0c             	shr    $0xc,%eax
}
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016f7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801706:	89 c2                	mov    %eax,%edx
  801708:	c1 ea 16             	shr    $0x16,%edx
  80170b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801712:	f6 c2 01             	test   $0x1,%dl
  801715:	74 2d                	je     801744 <fd_alloc+0x46>
  801717:	89 c2                	mov    %eax,%edx
  801719:	c1 ea 0c             	shr    $0xc,%edx
  80171c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801723:	f6 c2 01             	test   $0x1,%dl
  801726:	74 1c                	je     801744 <fd_alloc+0x46>
  801728:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80172d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801732:	75 d2                	jne    801706 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80173d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801742:	eb 0a                	jmp    80174e <fd_alloc+0x50>
			*fd_store = fd;
  801744:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801747:	89 01                	mov    %eax,(%ecx)
			return 0;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801756:	83 f8 1f             	cmp    $0x1f,%eax
  801759:	77 30                	ja     80178b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80175b:	c1 e0 0c             	shl    $0xc,%eax
  80175e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801763:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801769:	f6 c2 01             	test   $0x1,%dl
  80176c:	74 24                	je     801792 <fd_lookup+0x42>
  80176e:	89 c2                	mov    %eax,%edx
  801770:	c1 ea 0c             	shr    $0xc,%edx
  801773:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80177a:	f6 c2 01             	test   $0x1,%dl
  80177d:	74 1a                	je     801799 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	89 02                	mov    %eax,(%edx)
	return 0;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    
		return -E_INVAL;
  80178b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801790:	eb f7                	jmp    801789 <fd_lookup+0x39>
		return -E_INVAL;
  801792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801797:	eb f0                	jmp    801789 <fd_lookup+0x39>
  801799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179e:	eb e9                	jmp    801789 <fd_lookup+0x39>

008017a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
  8017a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017b3:	39 08                	cmp    %ecx,(%eax)
  8017b5:	74 38                	je     8017ef <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017b7:	83 c2 01             	add    $0x1,%edx
  8017ba:	8b 04 95 80 32 80 00 	mov    0x803280(,%edx,4),%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	75 ee                	jne    8017b3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017c5:	a1 08 50 80 00       	mov    0x805008,%eax
  8017ca:	8b 40 48             	mov    0x48(%eax),%eax
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	51                   	push   %ecx
  8017d1:	50                   	push   %eax
  8017d2:	68 04 32 80 00       	push   $0x803204
  8017d7:	e8 c8 eb ff ff       	call   8003a4 <cprintf>
	*dev = 0;
  8017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    
			*dev = devtab[i];
  8017ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb f2                	jmp    8017ed <dev_lookup+0x4d>

008017fb <fd_close>:
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	57                   	push   %edi
  8017ff:	56                   	push   %esi
  801800:	53                   	push   %ebx
  801801:	83 ec 24             	sub    $0x24,%esp
  801804:	8b 75 08             	mov    0x8(%ebp),%esi
  801807:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80180a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80180d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80180e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801814:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801817:	50                   	push   %eax
  801818:	e8 33 ff ff ff       	call   801750 <fd_lookup>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 05                	js     80182b <fd_close+0x30>
	    || fd != fd2)
  801826:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801829:	74 16                	je     801841 <fd_close+0x46>
		return (must_exist ? r : 0);
  80182b:	89 f8                	mov    %edi,%eax
  80182d:	84 c0                	test   %al,%al
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	0f 44 d8             	cmove  %eax,%ebx
}
  801837:	89 d8                	mov    %ebx,%eax
  801839:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183c:	5b                   	pop    %ebx
  80183d:	5e                   	pop    %esi
  80183e:	5f                   	pop    %edi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801847:	50                   	push   %eax
  801848:	ff 36                	pushl  (%esi)
  80184a:	e8 51 ff ff ff       	call   8017a0 <dev_lookup>
  80184f:	89 c3                	mov    %eax,%ebx
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 1a                	js     801872 <fd_close+0x77>
		if (dev->dev_close)
  801858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80185e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801863:	85 c0                	test   %eax,%eax
  801865:	74 0b                	je     801872 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	56                   	push   %esi
  80186b:	ff d0                	call   *%eax
  80186d:	89 c3                	mov    %eax,%ebx
  80186f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	56                   	push   %esi
  801876:	6a 00                	push   $0x0
  801878:	e8 fd f6 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	eb b5                	jmp    801837 <fd_close+0x3c>

00801882 <close>:

int
close(int fdnum)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801888:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188b:	50                   	push   %eax
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	e8 bc fe ff ff       	call   801750 <fd_lookup>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	79 02                	jns    80189d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    
		return fd_close(fd, 1);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	6a 01                	push   $0x1
  8018a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a5:	e8 51 ff ff ff       	call   8017fb <fd_close>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	eb ec                	jmp    80189b <close+0x19>

008018af <close_all>:

void
close_all(void)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	53                   	push   %ebx
  8018bf:	e8 be ff ff ff       	call   801882 <close>
	for (i = 0; i < MAXFD; i++)
  8018c4:	83 c3 01             	add    $0x1,%ebx
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	83 fb 20             	cmp    $0x20,%ebx
  8018cd:	75 ec                	jne    8018bb <close_all+0xc>
}
  8018cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	57                   	push   %edi
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018e0:	50                   	push   %eax
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	e8 67 fe ff ff       	call   801750 <fd_lookup>
  8018e9:	89 c3                	mov    %eax,%ebx
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	0f 88 81 00 00 00    	js     801977 <dup+0xa3>
		return r;
	close(newfdnum);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	e8 81 ff ff ff       	call   801882 <close>

	newfd = INDEX2FD(newfdnum);
  801901:	8b 75 0c             	mov    0xc(%ebp),%esi
  801904:	c1 e6 0c             	shl    $0xc,%esi
  801907:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80190d:	83 c4 04             	add    $0x4,%esp
  801910:	ff 75 e4             	pushl  -0x1c(%ebp)
  801913:	e8 cf fd ff ff       	call   8016e7 <fd2data>
  801918:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80191a:	89 34 24             	mov    %esi,(%esp)
  80191d:	e8 c5 fd ff ff       	call   8016e7 <fd2data>
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801927:	89 d8                	mov    %ebx,%eax
  801929:	c1 e8 16             	shr    $0x16,%eax
  80192c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801933:	a8 01                	test   $0x1,%al
  801935:	74 11                	je     801948 <dup+0x74>
  801937:	89 d8                	mov    %ebx,%eax
  801939:	c1 e8 0c             	shr    $0xc,%eax
  80193c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801943:	f6 c2 01             	test   $0x1,%dl
  801946:	75 39                	jne    801981 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80194b:	89 d0                	mov    %edx,%eax
  80194d:	c1 e8 0c             	shr    $0xc,%eax
  801950:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	25 07 0e 00 00       	and    $0xe07,%eax
  80195f:	50                   	push   %eax
  801960:	56                   	push   %esi
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	6a 00                	push   $0x0
  801966:	e8 cd f5 ff ff       	call   800f38 <sys_page_map>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	83 c4 20             	add    $0x20,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 31                	js     8019a5 <dup+0xd1>
		goto err;

	return newfdnum;
  801974:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801977:	89 d8                	mov    %ebx,%eax
  801979:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80197c:	5b                   	pop    %ebx
  80197d:	5e                   	pop    %esi
  80197e:	5f                   	pop    %edi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801981:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801988:	83 ec 0c             	sub    $0xc,%esp
  80198b:	25 07 0e 00 00       	and    $0xe07,%eax
  801990:	50                   	push   %eax
  801991:	57                   	push   %edi
  801992:	6a 00                	push   $0x0
  801994:	53                   	push   %ebx
  801995:	6a 00                	push   $0x0
  801997:	e8 9c f5 ff ff       	call   800f38 <sys_page_map>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 20             	add    $0x20,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	79 a3                	jns    801948 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	56                   	push   %esi
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 ca f5 ff ff       	call   800f7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019b0:	83 c4 08             	add    $0x8,%esp
  8019b3:	57                   	push   %edi
  8019b4:	6a 00                	push   $0x0
  8019b6:	e8 bf f5 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	eb b7                	jmp    801977 <dup+0xa3>

008019c0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 1c             	sub    $0x1c,%esp
  8019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019cd:	50                   	push   %eax
  8019ce:	53                   	push   %ebx
  8019cf:	e8 7c fd ff ff       	call   801750 <fd_lookup>
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 3f                	js     801a1a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e1:	50                   	push   %eax
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	ff 30                	pushl  (%eax)
  8019e7:	e8 b4 fd ff ff       	call   8017a0 <dev_lookup>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 27                	js     801a1a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f6:	8b 42 08             	mov    0x8(%edx),%eax
  8019f9:	83 e0 03             	and    $0x3,%eax
  8019fc:	83 f8 01             	cmp    $0x1,%eax
  8019ff:	74 1e                	je     801a1f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	8b 40 08             	mov    0x8(%eax),%eax
  801a07:	85 c0                	test   %eax,%eax
  801a09:	74 35                	je     801a40 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	52                   	push   %edx
  801a15:	ff d0                	call   *%eax
  801a17:	83 c4 10             	add    $0x10,%esp
}
  801a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a1f:	a1 08 50 80 00       	mov    0x805008,%eax
  801a24:	8b 40 48             	mov    0x48(%eax),%eax
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	53                   	push   %ebx
  801a2b:	50                   	push   %eax
  801a2c:	68 45 32 80 00       	push   $0x803245
  801a31:	e8 6e e9 ff ff       	call   8003a4 <cprintf>
		return -E_INVAL;
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a3e:	eb da                	jmp    801a1a <read+0x5a>
		return -E_NOT_SUPP;
  801a40:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a45:	eb d3                	jmp    801a1a <read+0x5a>

00801a47 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	57                   	push   %edi
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a53:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a56:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a5b:	39 f3                	cmp    %esi,%ebx
  801a5d:	73 23                	jae    801a82 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	89 f0                	mov    %esi,%eax
  801a64:	29 d8                	sub    %ebx,%eax
  801a66:	50                   	push   %eax
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	03 45 0c             	add    0xc(%ebp),%eax
  801a6c:	50                   	push   %eax
  801a6d:	57                   	push   %edi
  801a6e:	e8 4d ff ff ff       	call   8019c0 <read>
		if (m < 0)
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 06                	js     801a80 <readn+0x39>
			return m;
		if (m == 0)
  801a7a:	74 06                	je     801a82 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a7c:	01 c3                	add    %eax,%ebx
  801a7e:	eb db                	jmp    801a5b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a80:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5f                   	pop    %edi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    

00801a8c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 1c             	sub    $0x1c,%esp
  801a93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a99:	50                   	push   %eax
  801a9a:	53                   	push   %ebx
  801a9b:	e8 b0 fc ff ff       	call   801750 <fd_lookup>
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 3a                	js     801ae1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa7:	83 ec 08             	sub    $0x8,%esp
  801aaa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aad:	50                   	push   %eax
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab1:	ff 30                	pushl  (%eax)
  801ab3:	e8 e8 fc ff ff       	call   8017a0 <dev_lookup>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 22                	js     801ae1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ac6:	74 1e                	je     801ae6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801acb:	8b 52 0c             	mov    0xc(%edx),%edx
  801ace:	85 d2                	test   %edx,%edx
  801ad0:	74 35                	je     801b07 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	ff d2                	call   *%edx
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ae6:	a1 08 50 80 00       	mov    0x805008,%eax
  801aeb:	8b 40 48             	mov    0x48(%eax),%eax
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	53                   	push   %ebx
  801af2:	50                   	push   %eax
  801af3:	68 61 32 80 00       	push   $0x803261
  801af8:	e8 a7 e8 ff ff       	call   8003a4 <cprintf>
		return -E_INVAL;
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b05:	eb da                	jmp    801ae1 <write+0x55>
		return -E_NOT_SUPP;
  801b07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0c:	eb d3                	jmp    801ae1 <write+0x55>

00801b0e <seek>:

int
seek(int fdnum, off_t offset)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b17:	50                   	push   %eax
  801b18:	ff 75 08             	pushl  0x8(%ebp)
  801b1b:	e8 30 fc ff ff       	call   801750 <fd_lookup>
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 0e                	js     801b35 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	53                   	push   %ebx
  801b3b:	83 ec 1c             	sub    $0x1c,%esp
  801b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b44:	50                   	push   %eax
  801b45:	53                   	push   %ebx
  801b46:	e8 05 fc ff ff       	call   801750 <fd_lookup>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 37                	js     801b89 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b58:	50                   	push   %eax
  801b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5c:	ff 30                	pushl  (%eax)
  801b5e:	e8 3d fc ff ff       	call   8017a0 <dev_lookup>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 1f                	js     801b89 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b71:	74 1b                	je     801b8e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b76:	8b 52 18             	mov    0x18(%edx),%edx
  801b79:	85 d2                	test   %edx,%edx
  801b7b:	74 32                	je     801baf <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	50                   	push   %eax
  801b84:	ff d2                	call   *%edx
  801b86:	83 c4 10             	add    $0x10,%esp
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b8e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b93:	8b 40 48             	mov    0x48(%eax),%eax
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	53                   	push   %ebx
  801b9a:	50                   	push   %eax
  801b9b:	68 24 32 80 00       	push   $0x803224
  801ba0:	e8 ff e7 ff ff       	call   8003a4 <cprintf>
		return -E_INVAL;
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bad:	eb da                	jmp    801b89 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801baf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bb4:	eb d3                	jmp    801b89 <ftruncate+0x52>

00801bb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 1c             	sub    $0x1c,%esp
  801bbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc3:	50                   	push   %eax
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	e8 84 fb ff ff       	call   801750 <fd_lookup>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 4b                	js     801c1e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd3:	83 ec 08             	sub    $0x8,%esp
  801bd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd9:	50                   	push   %eax
  801bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdd:	ff 30                	pushl  (%eax)
  801bdf:	e8 bc fb ff ff       	call   8017a0 <dev_lookup>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 33                	js     801c1e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bee:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bf2:	74 2f                	je     801c23 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bf4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bf7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bfe:	00 00 00 
	stat->st_isdir = 0;
  801c01:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c08:	00 00 00 
	stat->st_dev = dev;
  801c0b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	53                   	push   %ebx
  801c15:	ff 75 f0             	pushl  -0x10(%ebp)
  801c18:	ff 50 14             	call   *0x14(%eax)
  801c1b:	83 c4 10             	add    $0x10,%esp
}
  801c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    
		return -E_NOT_SUPP;
  801c23:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c28:	eb f4                	jmp    801c1e <fstat+0x68>

00801c2a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	56                   	push   %esi
  801c2e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c2f:	83 ec 08             	sub    $0x8,%esp
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	e8 22 02 00 00       	call   801e5e <open>
  801c3c:	89 c3                	mov    %eax,%ebx
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 1b                	js     801c60 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	50                   	push   %eax
  801c4c:	e8 65 ff ff ff       	call   801bb6 <fstat>
  801c51:	89 c6                	mov    %eax,%esi
	close(fd);
  801c53:	89 1c 24             	mov    %ebx,(%esp)
  801c56:	e8 27 fc ff ff       	call   801882 <close>
	return r;
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	89 f3                	mov    %esi,%ebx
}
  801c60:	89 d8                	mov    %ebx,%eax
  801c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	56                   	push   %esi
  801c6d:	53                   	push   %ebx
  801c6e:	89 c6                	mov    %eax,%esi
  801c70:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c72:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c79:	74 27                	je     801ca2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c7b:	6a 07                	push   $0x7
  801c7d:	68 00 60 80 00       	push   $0x806000
  801c82:	56                   	push   %esi
  801c83:	ff 35 00 50 80 00    	pushl  0x805000
  801c89:	e8 9d 0c 00 00       	call   80292b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c8e:	83 c4 0c             	add    $0xc,%esp
  801c91:	6a 00                	push   $0x0
  801c93:	53                   	push   %ebx
  801c94:	6a 00                	push   $0x0
  801c96:	e8 27 0c 00 00       	call   8028c2 <ipc_recv>
}
  801c9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	6a 01                	push   $0x1
  801ca7:	e8 d7 0c 00 00       	call   802983 <ipc_find_env>
  801cac:	a3 00 50 80 00       	mov    %eax,0x805000
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	eb c5                	jmp    801c7b <fsipc+0x12>

00801cb6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	b8 02 00 00 00       	mov    $0x2,%eax
  801cd9:	e8 8b ff ff ff       	call   801c69 <fsipc>
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devfile_flush>:
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cec:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf6:	b8 06 00 00 00       	mov    $0x6,%eax
  801cfb:	e8 69 ff ff ff       	call   801c69 <fsipc>
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <devfile_stat>:
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	53                   	push   %ebx
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d12:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	b8 05 00 00 00       	mov    $0x5,%eax
  801d21:	e8 43 ff ff ff       	call   801c69 <fsipc>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 2c                	js     801d56 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	68 00 60 80 00       	push   $0x806000
  801d32:	53                   	push   %ebx
  801d33:	e8 cb ed ff ff       	call   800b03 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d38:	a1 80 60 80 00       	mov    0x806080,%eax
  801d3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d43:	a1 84 60 80 00       	mov    0x806084,%eax
  801d48:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <devfile_write>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
  801d5f:	83 ec 08             	sub    $0x8,%esp
  801d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d70:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d76:	53                   	push   %ebx
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	68 08 60 80 00       	push   $0x806008
  801d7f:	e8 6f ef ff ff       	call   800cf3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d84:	ba 00 00 00 00       	mov    $0x0,%edx
  801d89:	b8 04 00 00 00       	mov    $0x4,%eax
  801d8e:	e8 d6 fe ff ff       	call   801c69 <fsipc>
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 0b                	js     801da5 <devfile_write+0x4a>
	assert(r <= n);
  801d9a:	39 d8                	cmp    %ebx,%eax
  801d9c:	77 0c                	ja     801daa <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da3:	7f 1e                	jg     801dc3 <devfile_write+0x68>
}
  801da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    
	assert(r <= n);
  801daa:	68 94 32 80 00       	push   $0x803294
  801daf:	68 9b 32 80 00       	push   $0x80329b
  801db4:	68 98 00 00 00       	push   $0x98
  801db9:	68 b0 32 80 00       	push   $0x8032b0
  801dbe:	e8 eb e4 ff ff       	call   8002ae <_panic>
	assert(r <= PGSIZE);
  801dc3:	68 bb 32 80 00       	push   $0x8032bb
  801dc8:	68 9b 32 80 00       	push   $0x80329b
  801dcd:	68 99 00 00 00       	push   $0x99
  801dd2:	68 b0 32 80 00       	push   $0x8032b0
  801dd7:	e8 d2 e4 ff ff       	call   8002ae <_panic>

00801ddc <devfile_read>:
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dea:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801def:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801df5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfa:	b8 03 00 00 00       	mov    $0x3,%eax
  801dff:	e8 65 fe ff ff       	call   801c69 <fsipc>
  801e04:	89 c3                	mov    %eax,%ebx
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 1f                	js     801e29 <devfile_read+0x4d>
	assert(r <= n);
  801e0a:	39 f0                	cmp    %esi,%eax
  801e0c:	77 24                	ja     801e32 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e0e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e13:	7f 33                	jg     801e48 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	50                   	push   %eax
  801e19:	68 00 60 80 00       	push   $0x806000
  801e1e:	ff 75 0c             	pushl  0xc(%ebp)
  801e21:	e8 6b ee ff ff       	call   800c91 <memmove>
	return r;
  801e26:	83 c4 10             	add    $0x10,%esp
}
  801e29:	89 d8                	mov    %ebx,%eax
  801e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    
	assert(r <= n);
  801e32:	68 94 32 80 00       	push   $0x803294
  801e37:	68 9b 32 80 00       	push   $0x80329b
  801e3c:	6a 7c                	push   $0x7c
  801e3e:	68 b0 32 80 00       	push   $0x8032b0
  801e43:	e8 66 e4 ff ff       	call   8002ae <_panic>
	assert(r <= PGSIZE);
  801e48:	68 bb 32 80 00       	push   $0x8032bb
  801e4d:	68 9b 32 80 00       	push   $0x80329b
  801e52:	6a 7d                	push   $0x7d
  801e54:	68 b0 32 80 00       	push   $0x8032b0
  801e59:	e8 50 e4 ff ff       	call   8002ae <_panic>

00801e5e <open>:
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	83 ec 1c             	sub    $0x1c,%esp
  801e66:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e69:	56                   	push   %esi
  801e6a:	e8 5b ec ff ff       	call   800aca <strlen>
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e77:	7f 6c                	jg     801ee5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e7f:	50                   	push   %eax
  801e80:	e8 79 f8 ff ff       	call   8016fe <fd_alloc>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	78 3c                	js     801eca <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e8e:	83 ec 08             	sub    $0x8,%esp
  801e91:	56                   	push   %esi
  801e92:	68 00 60 80 00       	push   $0x806000
  801e97:	e8 67 ec ff ff       	call   800b03 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eac:	e8 b8 fd ff ff       	call   801c69 <fsipc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 19                	js     801ed3 <open+0x75>
	return fd2num(fd);
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec0:	e8 12 f8 ff ff       	call   8016d7 <fd2num>
  801ec5:	89 c3                	mov    %eax,%ebx
  801ec7:	83 c4 10             	add    $0x10,%esp
}
  801eca:	89 d8                	mov    %ebx,%eax
  801ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
		fd_close(fd, 0);
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	6a 00                	push   $0x0
  801ed8:	ff 75 f4             	pushl  -0xc(%ebp)
  801edb:	e8 1b f9 ff ff       	call   8017fb <fd_close>
		return r;
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	eb e5                	jmp    801eca <open+0x6c>
		return -E_BAD_PATH;
  801ee5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eea:	eb de                	jmp    801eca <open+0x6c>

00801eec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	b8 08 00 00 00       	mov    $0x8,%eax
  801efc:	e8 68 fd ff ff       	call   801c69 <fsipc>
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f09:	68 c7 32 80 00       	push   $0x8032c7
  801f0e:	ff 75 0c             	pushl  0xc(%ebp)
  801f11:	e8 ed eb ff ff       	call   800b03 <strcpy>
	return 0;
}
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <devsock_close>:
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	53                   	push   %ebx
  801f21:	83 ec 10             	sub    $0x10,%esp
  801f24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f27:	53                   	push   %ebx
  801f28:	e8 95 0a 00 00       	call   8029c2 <pageref>
  801f2d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f30:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f35:	83 f8 01             	cmp    $0x1,%eax
  801f38:	74 07                	je     801f41 <devsock_close+0x24>
}
  801f3a:	89 d0                	mov    %edx,%eax
  801f3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f41:	83 ec 0c             	sub    $0xc,%esp
  801f44:	ff 73 0c             	pushl  0xc(%ebx)
  801f47:	e8 b9 02 00 00       	call   802205 <nsipc_close>
  801f4c:	89 c2                	mov    %eax,%edx
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	eb e7                	jmp    801f3a <devsock_close+0x1d>

00801f53 <devsock_write>:
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 10             	pushl  0x10(%ebp)
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	ff 70 0c             	pushl  0xc(%eax)
  801f67:	e8 76 03 00 00       	call   8022e2 <nsipc_send>
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <devsock_read>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	ff 75 10             	pushl  0x10(%ebp)
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	ff 70 0c             	pushl  0xc(%eax)
  801f82:	e8 ef 02 00 00       	call   802276 <nsipc_recv>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <fd2sockid>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f92:	52                   	push   %edx
  801f93:	50                   	push   %eax
  801f94:	e8 b7 f7 ff ff       	call   801750 <fd_lookup>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 10                	js     801fb0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fa9:	39 08                	cmp    %ecx,(%eax)
  801fab:	75 05                	jne    801fb2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    
		return -E_NOT_SUPP;
  801fb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fb7:	eb f7                	jmp    801fb0 <fd2sockid+0x27>

00801fb9 <alloc_sockfd>:
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	56                   	push   %esi
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 1c             	sub    $0x1c,%esp
  801fc1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc6:	50                   	push   %eax
  801fc7:	e8 32 f7 ff ff       	call   8016fe <fd_alloc>
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 43                	js     802018 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 07 04 00 00       	push   $0x407
  801fdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe0:	6a 00                	push   $0x0
  801fe2:	e8 0e ef ff ff       	call   800ef5 <sys_page_alloc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 28                	js     802018 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ff9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802005:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	50                   	push   %eax
  80200c:	e8 c6 f6 ff ff       	call   8016d7 <fd2num>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	eb 0c                	jmp    802024 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	56                   	push   %esi
  80201c:	e8 e4 01 00 00       	call   802205 <nsipc_close>
		return r;
  802021:	83 c4 10             	add    $0x10,%esp
}
  802024:	89 d8                	mov    %ebx,%eax
  802026:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    

0080202d <accept>:
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	e8 4e ff ff ff       	call   801f89 <fd2sockid>
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 1b                	js     80205a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	ff 75 10             	pushl  0x10(%ebp)
  802045:	ff 75 0c             	pushl  0xc(%ebp)
  802048:	50                   	push   %eax
  802049:	e8 0e 01 00 00       	call   80215c <nsipc_accept>
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	85 c0                	test   %eax,%eax
  802053:	78 05                	js     80205a <accept+0x2d>
	return alloc_sockfd(r);
  802055:	e8 5f ff ff ff       	call   801fb9 <alloc_sockfd>
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <bind>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	e8 1f ff ff ff       	call   801f89 <fd2sockid>
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 12                	js     802080 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	50                   	push   %eax
  802078:	e8 31 01 00 00       	call   8021ae <nsipc_bind>
  80207d:	83 c4 10             	add    $0x10,%esp
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <shutdown>:
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	e8 f9 fe ff ff       	call   801f89 <fd2sockid>
  802090:	85 c0                	test   %eax,%eax
  802092:	78 0f                	js     8020a3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802094:	83 ec 08             	sub    $0x8,%esp
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	50                   	push   %eax
  80209b:	e8 43 01 00 00       	call   8021e3 <nsipc_shutdown>
  8020a0:	83 c4 10             	add    $0x10,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <connect>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	e8 d6 fe ff ff       	call   801f89 <fd2sockid>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 12                	js     8020c9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	50                   	push   %eax
  8020c1:	e8 59 01 00 00       	call   80221f <nsipc_connect>
  8020c6:	83 c4 10             	add    $0x10,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <listen>:
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	e8 b0 fe ff ff       	call   801f89 <fd2sockid>
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	78 0f                	js     8020ec <listen+0x21>
	return nsipc_listen(r, backlog);
  8020dd:	83 ec 08             	sub    $0x8,%esp
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	50                   	push   %eax
  8020e4:	e8 6b 01 00 00       	call   802254 <nsipc_listen>
  8020e9:	83 c4 10             	add    $0x10,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <socket>:

int
socket(int domain, int type, int protocol)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020f4:	ff 75 10             	pushl  0x10(%ebp)
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	ff 75 08             	pushl  0x8(%ebp)
  8020fd:	e8 3e 02 00 00       	call   802340 <nsipc_socket>
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	85 c0                	test   %eax,%eax
  802107:	78 05                	js     80210e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802109:	e8 ab fe ff ff       	call   801fb9 <alloc_sockfd>
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	53                   	push   %ebx
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802119:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802120:	74 26                	je     802148 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802122:	6a 07                	push   $0x7
  802124:	68 00 70 80 00       	push   $0x807000
  802129:	53                   	push   %ebx
  80212a:	ff 35 04 50 80 00    	pushl  0x805004
  802130:	e8 f6 07 00 00       	call   80292b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802135:	83 c4 0c             	add    $0xc,%esp
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	e8 7f 07 00 00       	call   8028c2 <ipc_recv>
}
  802143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802146:	c9                   	leave  
  802147:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802148:	83 ec 0c             	sub    $0xc,%esp
  80214b:	6a 02                	push   $0x2
  80214d:	e8 31 08 00 00       	call   802983 <ipc_find_env>
  802152:	a3 04 50 80 00       	mov    %eax,0x805004
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	eb c6                	jmp    802122 <nsipc+0x12>

0080215c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	56                   	push   %esi
  802160:	53                   	push   %ebx
  802161:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80216c:	8b 06                	mov    (%esi),%eax
  80216e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802173:	b8 01 00 00 00       	mov    $0x1,%eax
  802178:	e8 93 ff ff ff       	call   802110 <nsipc>
  80217d:	89 c3                	mov    %eax,%ebx
  80217f:	85 c0                	test   %eax,%eax
  802181:	79 09                	jns    80218c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802183:	89 d8                	mov    %ebx,%eax
  802185:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802188:	5b                   	pop    %ebx
  802189:	5e                   	pop    %esi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	ff 35 10 70 80 00    	pushl  0x807010
  802195:	68 00 70 80 00       	push   $0x807000
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	e8 ef ea ff ff       	call   800c91 <memmove>
		*addrlen = ret->ret_addrlen;
  8021a2:	a1 10 70 80 00       	mov    0x807010,%eax
  8021a7:	89 06                	mov    %eax,(%esi)
  8021a9:	83 c4 10             	add    $0x10,%esp
	return r;
  8021ac:	eb d5                	jmp    802183 <nsipc_accept+0x27>

008021ae <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	53                   	push   %ebx
  8021b2:	83 ec 08             	sub    $0x8,%esp
  8021b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021c0:	53                   	push   %ebx
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	68 04 70 80 00       	push   $0x807004
  8021c9:	e8 c3 ea ff ff       	call   800c91 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021ce:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8021d9:	e8 32 ff ff ff       	call   802110 <nsipc>
}
  8021de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8021fe:	e8 0d ff ff ff       	call   802110 <nsipc>
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <nsipc_close>:

int
nsipc_close(int s)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802213:	b8 04 00 00 00       	mov    $0x4,%eax
  802218:	e8 f3 fe ff ff       	call   802110 <nsipc>
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	53                   	push   %ebx
  802223:	83 ec 08             	sub    $0x8,%esp
  802226:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802231:	53                   	push   %ebx
  802232:	ff 75 0c             	pushl  0xc(%ebp)
  802235:	68 04 70 80 00       	push   $0x807004
  80223a:	e8 52 ea ff ff       	call   800c91 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80223f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802245:	b8 05 00 00 00       	mov    $0x5,%eax
  80224a:	e8 c1 fe ff ff       	call   802110 <nsipc>
}
  80224f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802262:	8b 45 0c             	mov    0xc(%ebp),%eax
  802265:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80226a:	b8 06 00 00 00       	mov    $0x6,%eax
  80226f:	e8 9c fe ff ff       	call   802110 <nsipc>
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	56                   	push   %esi
  80227a:	53                   	push   %ebx
  80227b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802286:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80228c:	8b 45 14             	mov    0x14(%ebp),%eax
  80228f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802294:	b8 07 00 00 00       	mov    $0x7,%eax
  802299:	e8 72 fe ff ff       	call   802110 <nsipc>
  80229e:	89 c3                	mov    %eax,%ebx
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 1f                	js     8022c3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022a4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022a9:	7f 21                	jg     8022cc <nsipc_recv+0x56>
  8022ab:	39 c6                	cmp    %eax,%esi
  8022ad:	7c 1d                	jl     8022cc <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	50                   	push   %eax
  8022b3:	68 00 70 80 00       	push   $0x807000
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	e8 d1 e9 ff ff       	call   800c91 <memmove>
  8022c0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022c3:	89 d8                	mov    %ebx,%eax
  8022c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c8:	5b                   	pop    %ebx
  8022c9:	5e                   	pop    %esi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022cc:	68 d3 32 80 00       	push   $0x8032d3
  8022d1:	68 9b 32 80 00       	push   $0x80329b
  8022d6:	6a 62                	push   $0x62
  8022d8:	68 e8 32 80 00       	push   $0x8032e8
  8022dd:	e8 cc df ff ff       	call   8002ae <_panic>

008022e2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	53                   	push   %ebx
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022f4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022fa:	7f 2e                	jg     80232a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	53                   	push   %ebx
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	68 0c 70 80 00       	push   $0x80700c
  802308:	e8 84 e9 ff ff       	call   800c91 <memmove>
	nsipcbuf.send.req_size = size;
  80230d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802313:	8b 45 14             	mov    0x14(%ebp),%eax
  802316:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80231b:	b8 08 00 00 00       	mov    $0x8,%eax
  802320:	e8 eb fd ff ff       	call   802110 <nsipc>
}
  802325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802328:	c9                   	leave  
  802329:	c3                   	ret    
	assert(size < 1600);
  80232a:	68 f4 32 80 00       	push   $0x8032f4
  80232f:	68 9b 32 80 00       	push   $0x80329b
  802334:	6a 6d                	push   $0x6d
  802336:	68 e8 32 80 00       	push   $0x8032e8
  80233b:	e8 6e df ff ff       	call   8002ae <_panic>

00802340 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802356:	8b 45 10             	mov    0x10(%ebp),%eax
  802359:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80235e:	b8 09 00 00 00       	mov    $0x9,%eax
  802363:	e8 a8 fd ff ff       	call   802110 <nsipc>
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	56                   	push   %esi
  80236e:	53                   	push   %ebx
  80236f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802372:	83 ec 0c             	sub    $0xc,%esp
  802375:	ff 75 08             	pushl  0x8(%ebp)
  802378:	e8 6a f3 ff ff       	call   8016e7 <fd2data>
  80237d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80237f:	83 c4 08             	add    $0x8,%esp
  802382:	68 00 33 80 00       	push   $0x803300
  802387:	53                   	push   %ebx
  802388:	e8 76 e7 ff ff       	call   800b03 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80238d:	8b 46 04             	mov    0x4(%esi),%eax
  802390:	2b 06                	sub    (%esi),%eax
  802392:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802398:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80239f:	00 00 00 
	stat->st_dev = &devpipe;
  8023a2:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023a9:	40 80 00 
	return 0;
}
  8023ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b4:	5b                   	pop    %ebx
  8023b5:	5e                   	pop    %esi
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    

008023b8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	53                   	push   %ebx
  8023bc:	83 ec 0c             	sub    $0xc,%esp
  8023bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023c2:	53                   	push   %ebx
  8023c3:	6a 00                	push   $0x0
  8023c5:	e8 b0 eb ff ff       	call   800f7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023ca:	89 1c 24             	mov    %ebx,(%esp)
  8023cd:	e8 15 f3 ff ff       	call   8016e7 <fd2data>
  8023d2:	83 c4 08             	add    $0x8,%esp
  8023d5:	50                   	push   %eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	e8 9d eb ff ff       	call   800f7a <sys_page_unmap>
}
  8023dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <_pipeisclosed>:
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	57                   	push   %edi
  8023e6:	56                   	push   %esi
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 1c             	sub    $0x1c,%esp
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8023f4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023f7:	83 ec 0c             	sub    $0xc,%esp
  8023fa:	57                   	push   %edi
  8023fb:	e8 c2 05 00 00       	call   8029c2 <pageref>
  802400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802403:	89 34 24             	mov    %esi,(%esp)
  802406:	e8 b7 05 00 00       	call   8029c2 <pageref>
		nn = thisenv->env_runs;
  80240b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802411:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	39 cb                	cmp    %ecx,%ebx
  802419:	74 1b                	je     802436 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80241b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80241e:	75 cf                	jne    8023ef <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802420:	8b 42 58             	mov    0x58(%edx),%eax
  802423:	6a 01                	push   $0x1
  802425:	50                   	push   %eax
  802426:	53                   	push   %ebx
  802427:	68 07 33 80 00       	push   $0x803307
  80242c:	e8 73 df ff ff       	call   8003a4 <cprintf>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	eb b9                	jmp    8023ef <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802436:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802439:	0f 94 c0             	sete   %al
  80243c:	0f b6 c0             	movzbl %al,%eax
}
  80243f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802442:	5b                   	pop    %ebx
  802443:	5e                   	pop    %esi
  802444:	5f                   	pop    %edi
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    

00802447 <devpipe_write>:
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	57                   	push   %edi
  80244b:	56                   	push   %esi
  80244c:	53                   	push   %ebx
  80244d:	83 ec 28             	sub    $0x28,%esp
  802450:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802453:	56                   	push   %esi
  802454:	e8 8e f2 ff ff       	call   8016e7 <fd2data>
  802459:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80245b:	83 c4 10             	add    $0x10,%esp
  80245e:	bf 00 00 00 00       	mov    $0x0,%edi
  802463:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802466:	74 4f                	je     8024b7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802468:	8b 43 04             	mov    0x4(%ebx),%eax
  80246b:	8b 0b                	mov    (%ebx),%ecx
  80246d:	8d 51 20             	lea    0x20(%ecx),%edx
  802470:	39 d0                	cmp    %edx,%eax
  802472:	72 14                	jb     802488 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802474:	89 da                	mov    %ebx,%edx
  802476:	89 f0                	mov    %esi,%eax
  802478:	e8 65 ff ff ff       	call   8023e2 <_pipeisclosed>
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 3b                	jne    8024bc <devpipe_write+0x75>
			sys_yield();
  802481:	e8 50 ea ff ff       	call   800ed6 <sys_yield>
  802486:	eb e0                	jmp    802468 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802488:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80248b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80248f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802492:	89 c2                	mov    %eax,%edx
  802494:	c1 fa 1f             	sar    $0x1f,%edx
  802497:	89 d1                	mov    %edx,%ecx
  802499:	c1 e9 1b             	shr    $0x1b,%ecx
  80249c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80249f:	83 e2 1f             	and    $0x1f,%edx
  8024a2:	29 ca                	sub    %ecx,%edx
  8024a4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024ac:	83 c0 01             	add    $0x1,%eax
  8024af:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024b2:	83 c7 01             	add    $0x1,%edi
  8024b5:	eb ac                	jmp    802463 <devpipe_write+0x1c>
	return i;
  8024b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ba:	eb 05                	jmp    8024c1 <devpipe_write+0x7a>
				return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5f                   	pop    %edi
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    

008024c9 <devpipe_read>:
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	57                   	push   %edi
  8024cd:	56                   	push   %esi
  8024ce:	53                   	push   %ebx
  8024cf:	83 ec 18             	sub    $0x18,%esp
  8024d2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024d5:	57                   	push   %edi
  8024d6:	e8 0c f2 ff ff       	call   8016e7 <fd2data>
  8024db:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	be 00 00 00 00       	mov    $0x0,%esi
  8024e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024e8:	75 14                	jne    8024fe <devpipe_read+0x35>
	return i;
  8024ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ed:	eb 02                	jmp    8024f1 <devpipe_read+0x28>
				return i;
  8024ef:	89 f0                	mov    %esi,%eax
}
  8024f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5f                   	pop    %edi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    
			sys_yield();
  8024f9:	e8 d8 e9 ff ff       	call   800ed6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024fe:	8b 03                	mov    (%ebx),%eax
  802500:	3b 43 04             	cmp    0x4(%ebx),%eax
  802503:	75 18                	jne    80251d <devpipe_read+0x54>
			if (i > 0)
  802505:	85 f6                	test   %esi,%esi
  802507:	75 e6                	jne    8024ef <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802509:	89 da                	mov    %ebx,%edx
  80250b:	89 f8                	mov    %edi,%eax
  80250d:	e8 d0 fe ff ff       	call   8023e2 <_pipeisclosed>
  802512:	85 c0                	test   %eax,%eax
  802514:	74 e3                	je     8024f9 <devpipe_read+0x30>
				return 0;
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	eb d4                	jmp    8024f1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80251d:	99                   	cltd   
  80251e:	c1 ea 1b             	shr    $0x1b,%edx
  802521:	01 d0                	add    %edx,%eax
  802523:	83 e0 1f             	and    $0x1f,%eax
  802526:	29 d0                	sub    %edx,%eax
  802528:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80252d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802530:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802533:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802536:	83 c6 01             	add    $0x1,%esi
  802539:	eb aa                	jmp    8024e5 <devpipe_read+0x1c>

0080253b <pipe>:
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	56                   	push   %esi
  80253f:	53                   	push   %ebx
  802540:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802546:	50                   	push   %eax
  802547:	e8 b2 f1 ff ff       	call   8016fe <fd_alloc>
  80254c:	89 c3                	mov    %eax,%ebx
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	85 c0                	test   %eax,%eax
  802553:	0f 88 23 01 00 00    	js     80267c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 07 04 00 00       	push   $0x407
  802561:	ff 75 f4             	pushl  -0xc(%ebp)
  802564:	6a 00                	push   $0x0
  802566:	e8 8a e9 ff ff       	call   800ef5 <sys_page_alloc>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	0f 88 04 01 00 00    	js     80267c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80257e:	50                   	push   %eax
  80257f:	e8 7a f1 ff ff       	call   8016fe <fd_alloc>
  802584:	89 c3                	mov    %eax,%ebx
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	85 c0                	test   %eax,%eax
  80258b:	0f 88 db 00 00 00    	js     80266c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	68 07 04 00 00       	push   $0x407
  802599:	ff 75 f0             	pushl  -0x10(%ebp)
  80259c:	6a 00                	push   $0x0
  80259e:	e8 52 e9 ff ff       	call   800ef5 <sys_page_alloc>
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	0f 88 bc 00 00 00    	js     80266c <pipe+0x131>
	va = fd2data(fd0);
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b6:	e8 2c f1 ff ff       	call   8016e7 <fd2data>
  8025bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bd:	83 c4 0c             	add    $0xc,%esp
  8025c0:	68 07 04 00 00       	push   $0x407
  8025c5:	50                   	push   %eax
  8025c6:	6a 00                	push   $0x0
  8025c8:	e8 28 e9 ff ff       	call   800ef5 <sys_page_alloc>
  8025cd:	89 c3                	mov    %eax,%ebx
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	0f 88 82 00 00 00    	js     80265c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025da:	83 ec 0c             	sub    $0xc,%esp
  8025dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e0:	e8 02 f1 ff ff       	call   8016e7 <fd2data>
  8025e5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025ec:	50                   	push   %eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	56                   	push   %esi
  8025f0:	6a 00                	push   $0x0
  8025f2:	e8 41 e9 ff ff       	call   800f38 <sys_page_map>
  8025f7:	89 c3                	mov    %eax,%ebx
  8025f9:	83 c4 20             	add    $0x20,%esp
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	78 4e                	js     80264e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802600:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802608:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802617:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802623:	83 ec 0c             	sub    $0xc,%esp
  802626:	ff 75 f4             	pushl  -0xc(%ebp)
  802629:	e8 a9 f0 ff ff       	call   8016d7 <fd2num>
  80262e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802631:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802633:	83 c4 04             	add    $0x4,%esp
  802636:	ff 75 f0             	pushl  -0x10(%ebp)
  802639:	e8 99 f0 ff ff       	call   8016d7 <fd2num>
  80263e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802641:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802644:	83 c4 10             	add    $0x10,%esp
  802647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80264c:	eb 2e                	jmp    80267c <pipe+0x141>
	sys_page_unmap(0, va);
  80264e:	83 ec 08             	sub    $0x8,%esp
  802651:	56                   	push   %esi
  802652:	6a 00                	push   $0x0
  802654:	e8 21 e9 ff ff       	call   800f7a <sys_page_unmap>
  802659:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80265c:	83 ec 08             	sub    $0x8,%esp
  80265f:	ff 75 f0             	pushl  -0x10(%ebp)
  802662:	6a 00                	push   $0x0
  802664:	e8 11 e9 ff ff       	call   800f7a <sys_page_unmap>
  802669:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80266c:	83 ec 08             	sub    $0x8,%esp
  80266f:	ff 75 f4             	pushl  -0xc(%ebp)
  802672:	6a 00                	push   $0x0
  802674:	e8 01 e9 ff ff       	call   800f7a <sys_page_unmap>
  802679:	83 c4 10             	add    $0x10,%esp
}
  80267c:	89 d8                	mov    %ebx,%eax
  80267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802681:	5b                   	pop    %ebx
  802682:	5e                   	pop    %esi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    

00802685 <pipeisclosed>:
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80268b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80268e:	50                   	push   %eax
  80268f:	ff 75 08             	pushl  0x8(%ebp)
  802692:	e8 b9 f0 ff ff       	call   801750 <fd_lookup>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	85 c0                	test   %eax,%eax
  80269c:	78 18                	js     8026b6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80269e:	83 ec 0c             	sub    $0xc,%esp
  8026a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a4:	e8 3e f0 ff ff       	call   8016e7 <fd2data>
	return _pipeisclosed(fd, p);
  8026a9:	89 c2                	mov    %eax,%edx
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	e8 2f fd ff ff       	call   8023e2 <_pipeisclosed>
  8026b3:	83 c4 10             	add    $0x10,%esp
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bd:	c3                   	ret    

008026be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026c4:	68 1a 33 80 00       	push   $0x80331a
  8026c9:	ff 75 0c             	pushl  0xc(%ebp)
  8026cc:	e8 32 e4 ff ff       	call   800b03 <strcpy>
	return 0;
}
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <devcons_write>:
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	57                   	push   %edi
  8026dc:	56                   	push   %esi
  8026dd:	53                   	push   %ebx
  8026de:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026e4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026e9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026ef:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026f2:	73 31                	jae    802725 <devcons_write+0x4d>
		m = n - tot;
  8026f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026f7:	29 f3                	sub    %esi,%ebx
  8026f9:	83 fb 7f             	cmp    $0x7f,%ebx
  8026fc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802701:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	53                   	push   %ebx
  802708:	89 f0                	mov    %esi,%eax
  80270a:	03 45 0c             	add    0xc(%ebp),%eax
  80270d:	50                   	push   %eax
  80270e:	57                   	push   %edi
  80270f:	e8 7d e5 ff ff       	call   800c91 <memmove>
		sys_cputs(buf, m);
  802714:	83 c4 08             	add    $0x8,%esp
  802717:	53                   	push   %ebx
  802718:	57                   	push   %edi
  802719:	e8 1b e7 ff ff       	call   800e39 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80271e:	01 de                	add    %ebx,%esi
  802720:	83 c4 10             	add    $0x10,%esp
  802723:	eb ca                	jmp    8026ef <devcons_write+0x17>
}
  802725:	89 f0                	mov    %esi,%eax
  802727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80272a:	5b                   	pop    %ebx
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	5d                   	pop    %ebp
  80272e:	c3                   	ret    

0080272f <devcons_read>:
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	83 ec 08             	sub    $0x8,%esp
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80273a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80273e:	74 21                	je     802761 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802740:	e8 12 e7 ff ff       	call   800e57 <sys_cgetc>
  802745:	85 c0                	test   %eax,%eax
  802747:	75 07                	jne    802750 <devcons_read+0x21>
		sys_yield();
  802749:	e8 88 e7 ff ff       	call   800ed6 <sys_yield>
  80274e:	eb f0                	jmp    802740 <devcons_read+0x11>
	if (c < 0)
  802750:	78 0f                	js     802761 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802752:	83 f8 04             	cmp    $0x4,%eax
  802755:	74 0c                	je     802763 <devcons_read+0x34>
	*(char*)vbuf = c;
  802757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275a:	88 02                	mov    %al,(%edx)
	return 1;
  80275c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    
		return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	eb f7                	jmp    802761 <devcons_read+0x32>

0080276a <cputchar>:
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802776:	6a 01                	push   $0x1
  802778:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277b:	50                   	push   %eax
  80277c:	e8 b8 e6 ff ff       	call   800e39 <sys_cputs>
}
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <getchar>:
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80278c:	6a 01                	push   $0x1
  80278e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802791:	50                   	push   %eax
  802792:	6a 00                	push   $0x0
  802794:	e8 27 f2 ff ff       	call   8019c0 <read>
	if (r < 0)
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	85 c0                	test   %eax,%eax
  80279e:	78 06                	js     8027a6 <getchar+0x20>
	if (r < 1)
  8027a0:	74 06                	je     8027a8 <getchar+0x22>
	return c;
  8027a2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    
		return -E_EOF;
  8027a8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027ad:	eb f7                	jmp    8027a6 <getchar+0x20>

008027af <iscons>:
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b8:	50                   	push   %eax
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	e8 8f ef ff ff       	call   801750 <fd_lookup>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 11                	js     8027d9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027d1:	39 10                	cmp    %edx,(%eax)
  8027d3:	0f 94 c0             	sete   %al
  8027d6:	0f b6 c0             	movzbl %al,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <opencons>:
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e4:	50                   	push   %eax
  8027e5:	e8 14 ef ff ff       	call   8016fe <fd_alloc>
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	78 3a                	js     80282b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027f1:	83 ec 04             	sub    $0x4,%esp
  8027f4:	68 07 04 00 00       	push   $0x407
  8027f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027fc:	6a 00                	push   $0x0
  8027fe:	e8 f2 e6 ff ff       	call   800ef5 <sys_page_alloc>
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	85 c0                	test   %eax,%eax
  802808:	78 21                	js     80282b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802813:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	50                   	push   %eax
  802823:	e8 af ee ff ff       	call   8016d7 <fd2num>
  802828:	83 c4 10             	add    $0x10,%esp
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802833:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80283a:	74 0a                	je     802846 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	6a 07                	push   $0x7
  80284b:	68 00 f0 bf ee       	push   $0xeebff000
  802850:	6a 00                	push   $0x0
  802852:	e8 9e e6 ff ff       	call   800ef5 <sys_page_alloc>
		if(r < 0)
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	85 c0                	test   %eax,%eax
  80285c:	78 2a                	js     802888 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80285e:	83 ec 08             	sub    $0x8,%esp
  802861:	68 9c 28 80 00       	push   $0x80289c
  802866:	6a 00                	push   $0x0
  802868:	e8 d3 e7 ff ff       	call   801040 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80286d:	83 c4 10             	add    $0x10,%esp
  802870:	85 c0                	test   %eax,%eax
  802872:	79 c8                	jns    80283c <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	68 58 33 80 00       	push   $0x803358
  80287c:	6a 25                	push   $0x25
  80287e:	68 94 33 80 00       	push   $0x803394
  802883:	e8 26 da ff ff       	call   8002ae <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 28 33 80 00       	push   $0x803328
  802890:	6a 22                	push   $0x22
  802892:	68 94 33 80 00       	push   $0x803394
  802897:	e8 12 da ff ff       	call   8002ae <_panic>

0080289c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80289c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80289d:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028a2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028a4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028a7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028ab:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028af:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028b2:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028b4:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028b8:	83 c4 08             	add    $0x8,%esp
	popal
  8028bb:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028bc:	83 c4 04             	add    $0x4,%esp
	popfl
  8028bf:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028c0:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028c1:	c3                   	ret    

008028c2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	56                   	push   %esi
  8028c6:	53                   	push   %ebx
  8028c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8028ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028d0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028d2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028d7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	50                   	push   %eax
  8028de:	e8 c2 e7 ff ff       	call   8010a5 <sys_ipc_recv>
	if(ret < 0){
  8028e3:	83 c4 10             	add    $0x10,%esp
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	78 2b                	js     802915 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028ea:	85 f6                	test   %esi,%esi
  8028ec:	74 0a                	je     8028f8 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8028ee:	a1 08 50 80 00       	mov    0x805008,%eax
  8028f3:	8b 40 78             	mov    0x78(%eax),%eax
  8028f6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028f8:	85 db                	test   %ebx,%ebx
  8028fa:	74 0a                	je     802906 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8028fc:	a1 08 50 80 00       	mov    0x805008,%eax
  802901:	8b 40 7c             	mov    0x7c(%eax),%eax
  802904:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802906:	a1 08 50 80 00       	mov    0x805008,%eax
  80290b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80290e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802911:	5b                   	pop    %ebx
  802912:	5e                   	pop    %esi
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    
		if(from_env_store)
  802915:	85 f6                	test   %esi,%esi
  802917:	74 06                	je     80291f <ipc_recv+0x5d>
			*from_env_store = 0;
  802919:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80291f:	85 db                	test   %ebx,%ebx
  802921:	74 eb                	je     80290e <ipc_recv+0x4c>
			*perm_store = 0;
  802923:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802929:	eb e3                	jmp    80290e <ipc_recv+0x4c>

0080292b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	57                   	push   %edi
  80292f:	56                   	push   %esi
  802930:	53                   	push   %ebx
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	8b 7d 08             	mov    0x8(%ebp),%edi
  802937:	8b 75 0c             	mov    0xc(%ebp),%esi
  80293a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80293d:	85 db                	test   %ebx,%ebx
  80293f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802944:	0f 44 d8             	cmove  %eax,%ebx
  802947:	eb 05                	jmp    80294e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802949:	e8 88 e5 ff ff       	call   800ed6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80294e:	ff 75 14             	pushl  0x14(%ebp)
  802951:	53                   	push   %ebx
  802952:	56                   	push   %esi
  802953:	57                   	push   %edi
  802954:	e8 29 e7 ff ff       	call   801082 <sys_ipc_try_send>
  802959:	83 c4 10             	add    $0x10,%esp
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 1b                	je     80297b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802960:	79 e7                	jns    802949 <ipc_send+0x1e>
  802962:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802965:	74 e2                	je     802949 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 a2 33 80 00       	push   $0x8033a2
  80296f:	6a 46                	push   $0x46
  802971:	68 b7 33 80 00       	push   $0x8033b7
  802976:	e8 33 d9 ff ff       	call   8002ae <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80297b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80297e:	5b                   	pop    %ebx
  80297f:	5e                   	pop    %esi
  802980:	5f                   	pop    %edi
  802981:	5d                   	pop    %ebp
  802982:	c3                   	ret    

00802983 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802983:	55                   	push   %ebp
  802984:	89 e5                	mov    %esp,%ebp
  802986:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802989:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80298e:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802994:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80299a:	8b 52 50             	mov    0x50(%edx),%edx
  80299d:	39 ca                	cmp    %ecx,%edx
  80299f:	74 11                	je     8029b2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8029a1:	83 c0 01             	add    $0x1,%eax
  8029a4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029a9:	75 e3                	jne    80298e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	eb 0e                	jmp    8029c0 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8029b2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8029b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029c0:	5d                   	pop    %ebp
  8029c1:	c3                   	ret    

008029c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
  8029c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c8:	89 d0                	mov    %edx,%eax
  8029ca:	c1 e8 16             	shr    $0x16,%eax
  8029cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029d9:	f6 c1 01             	test   $0x1,%cl
  8029dc:	74 1d                	je     8029fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029de:	c1 ea 0c             	shr    $0xc,%edx
  8029e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029e8:	f6 c2 01             	test   $0x1,%dl
  8029eb:	74 0e                	je     8029fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029ed:	c1 ea 0c             	shr    $0xc,%edx
  8029f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029f7:	ef 
  8029f8:	0f b7 c0             	movzwl %ax,%eax
}
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    
  8029fd:	66 90                	xchg   %ax,%ax
  8029ff:	90                   	nop

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
