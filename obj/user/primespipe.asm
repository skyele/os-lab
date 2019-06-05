
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
  800056:	68 80 2c 80 00       	push   $0x802c80
  80005b:	6a 15                	push   $0x15
  80005d:	68 af 2c 80 00       	push   $0x802caf
  800062:	e8 86 02 00 00       	call   8002ed <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 c5 2c 80 00       	push   $0x802cc5
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 af 2c 80 00       	push   $0x802caf
  800074:	e8 74 02 00 00       	call   8002ed <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 ce 2c 80 00       	push   $0x802cce
  80007f:	6a 1d                	push   $0x1d
  800081:	68 af 2c 80 00       	push   $0x802caf
  800086:	e8 62 02 00 00       	call   8002ed <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 07 18 00 00       	call   80189b <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 fc 17 00 00       	call   80189b <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 af 19 00 00       	call   801a60 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 c1 2c 80 00       	push   $0x802cc1
  8000c4:	e8 1a 03 00 00       	call   8003e3 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 83 24 00 00       	call   802554 <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 7e 13 00 00       	call   80145e <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 aa 17 00 00       	call   80189b <close>
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
  800101:	e8 5a 19 00 00       	call   801a60 <readn>
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
  800120:	e8 80 19 00 00       	call   801aa5 <write>
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
  80013f:	68 f3 2c 80 00       	push   $0x802cf3
  800144:	6a 2e                	push   $0x2e
  800146:	68 af 2c 80 00       	push   $0x802caf
  80014b:	e8 9d 01 00 00       	call   8002ed <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 d7 2c 80 00       	push   $0x802cd7
  800168:	6a 2b                	push   $0x2b
  80016a:	68 af 2c 80 00       	push   $0x802caf
  80016f:	e8 79 01 00 00       	call   8002ed <_panic>

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
  80017b:	c7 05 00 40 80 00 0d 	movl   $0x802d0d,0x804000
  800182:	2d 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 c6 23 00 00       	call   802554 <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 c1 12 00 00       	call   80145e <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 ed 16 00 00       	call   80189b <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 c5 2c 80 00       	push   $0x802cc5
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 af 2c 80 00       	push   $0x802caf
  8001c6:	e8 22 01 00 00       	call   8002ed <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 ce 2c 80 00       	push   $0x802cce
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 af 2c 80 00       	push   $0x802caf
  8001d8:	e8 10 01 00 00       	call   8002ed <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 b3 16 00 00       	call   80189b <close>

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
  8001fe:	e8 a2 18 00 00       	call   801aa5 <write>
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
  800220:	68 18 2d 80 00       	push   $0x802d18
  800225:	6a 4a                	push   $0x4a
  800227:	68 af 2c 80 00       	push   $0x802caf
  80022c:	e8 bc 00 00 00       	call   8002ed <_panic>

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
  80023a:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800241:	00 00 00 
	envid_t find = sys_getenvid();
  800244:	e8 ad 0c 00 00       	call   800ef6 <sys_getenvid>
  800249:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  800292:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029c:	7e 0a                	jle    8002a8 <libmain+0x77>
		binaryname = argv[0];
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	8b 00                	mov    (%eax),%eax
  8002a3:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 30 2d 80 00       	push   $0x802d30
  8002b0:	e8 2e 01 00 00       	call   8003e3 <cprintf>
	// call user main routine
	umain(argc, argv);
  8002b5:	83 c4 08             	add    $0x8,%esp
  8002b8:	ff 75 0c             	pushl  0xc(%ebp)
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 b1 fe ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  8002c3:	e8 0b 00 00 00       	call   8002d3 <exit>
}
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002d9:	e8 ea 15 00 00       	call   8018c8 <close_all>
	sys_env_destroy(0);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	6a 00                	push   $0x0
  8002e3:	e8 cd 0b 00 00       	call   800eb5 <sys_env_destroy>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8002f7:	8b 40 48             	mov    0x48(%eax),%eax
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	68 84 2d 80 00       	push   $0x802d84
  800302:	50                   	push   %eax
  800303:	68 54 2d 80 00       	push   $0x802d54
  800308:	e8 d6 00 00 00       	call   8003e3 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80030d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800310:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800316:	e8 db 0b 00 00       	call   800ef6 <sys_getenvid>
  80031b:	83 c4 04             	add    $0x4,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	56                   	push   %esi
  800325:	50                   	push   %eax
  800326:	68 60 2d 80 00       	push   $0x802d60
  80032b:	e8 b3 00 00 00       	call   8003e3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800330:	83 c4 18             	add    $0x18,%esp
  800333:	53                   	push   %ebx
  800334:	ff 75 10             	pushl  0x10(%ebp)
  800337:	e8 56 00 00 00       	call   800392 <vcprintf>
	cprintf("\n");
  80033c:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800343:	e8 9b 00 00 00       	call   8003e3 <cprintf>
  800348:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80034b:	cc                   	int3   
  80034c:	eb fd                	jmp    80034b <_panic+0x5e>

0080034e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	53                   	push   %ebx
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800358:	8b 13                	mov    (%ebx),%edx
  80035a:	8d 42 01             	lea    0x1(%edx),%eax
  80035d:	89 03                	mov    %eax,(%ebx)
  80035f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800362:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800366:	3d ff 00 00 00       	cmp    $0xff,%eax
  80036b:	74 09                	je     800376 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80036d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800374:	c9                   	leave  
  800375:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 ff 00 00 00       	push   $0xff
  80037e:	8d 43 08             	lea    0x8(%ebx),%eax
  800381:	50                   	push   %eax
  800382:	e8 f1 0a 00 00       	call   800e78 <sys_cputs>
		b->idx = 0;
  800387:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	eb db                	jmp    80036d <putch+0x1f>

00800392 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80039b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a2:	00 00 00 
	b.cnt = 0;
  8003a5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ac:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003bb:	50                   	push   %eax
  8003bc:	68 4e 03 80 00       	push   $0x80034e
  8003c1:	e8 4a 01 00 00       	call   800510 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003c6:	83 c4 08             	add    $0x8,%esp
  8003c9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003cf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d5:	50                   	push   %eax
  8003d6:	e8 9d 0a 00 00       	call   800e78 <sys_cputs>

	return b.cnt;
}
  8003db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003e9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ec:	50                   	push   %eax
  8003ed:	ff 75 08             	pushl  0x8(%ebp)
  8003f0:	e8 9d ff ff ff       	call   800392 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	57                   	push   %edi
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 1c             	sub    $0x1c,%esp
  800400:	89 c6                	mov    %eax,%esi
  800402:	89 d7                	mov    %edx,%edi
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800416:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80041a:	74 2c                	je     800448 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80041c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800426:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800429:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800431:	73 43                	jae    800476 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800433:	83 eb 01             	sub    $0x1,%ebx
  800436:	85 db                	test   %ebx,%ebx
  800438:	7e 6c                	jle    8004a6 <printnum+0xaf>
				putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	57                   	push   %edi
  80043e:	ff 75 18             	pushl  0x18(%ebp)
  800441:	ff d6                	call   *%esi
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	eb eb                	jmp    800433 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800448:	83 ec 0c             	sub    $0xc,%esp
  80044b:	6a 20                	push   $0x20
  80044d:	6a 00                	push   $0x0
  80044f:	50                   	push   %eax
  800450:	ff 75 e4             	pushl  -0x1c(%ebp)
  800453:	ff 75 e0             	pushl  -0x20(%ebp)
  800456:	89 fa                	mov    %edi,%edx
  800458:	89 f0                	mov    %esi,%eax
  80045a:	e8 98 ff ff ff       	call   8003f7 <printnum>
		while (--width > 0)
  80045f:	83 c4 20             	add    $0x20,%esp
  800462:	83 eb 01             	sub    $0x1,%ebx
  800465:	85 db                	test   %ebx,%ebx
  800467:	7e 65                	jle    8004ce <printnum+0xd7>
			putch(padc, putdat);
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	57                   	push   %edi
  80046d:	6a 20                	push   $0x20
  80046f:	ff d6                	call   *%esi
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	eb ec                	jmp    800462 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	83 ec 0c             	sub    $0xc,%esp
  800479:	ff 75 18             	pushl  0x18(%ebp)
  80047c:	83 eb 01             	sub    $0x1,%ebx
  80047f:	53                   	push   %ebx
  800480:	50                   	push   %eax
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 dc             	pushl  -0x24(%ebp)
  800487:	ff 75 d8             	pushl  -0x28(%ebp)
  80048a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048d:	ff 75 e0             	pushl  -0x20(%ebp)
  800490:	e8 8b 25 00 00       	call   802a20 <__udivdi3>
  800495:	83 c4 18             	add    $0x18,%esp
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	89 fa                	mov    %edi,%edx
  80049c:	89 f0                	mov    %esi,%eax
  80049e:	e8 54 ff ff ff       	call   8003f7 <printnum>
  8004a3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	57                   	push   %edi
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b9:	e8 72 26 00 00       	call   802b30 <__umoddi3>
  8004be:	83 c4 14             	add    $0x14,%esp
  8004c1:	0f be 80 8b 2d 80 00 	movsbl 0x802d8b(%eax),%eax
  8004c8:	50                   	push   %eax
  8004c9:	ff d6                	call   *%esi
  8004cb:	83 c4 10             	add    $0x10,%esp
	}
}
  8004ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004dc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e0:	8b 10                	mov    (%eax),%edx
  8004e2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e5:	73 0a                	jae    8004f1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ea:	89 08                	mov    %ecx,(%eax)
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	88 02                	mov    %al,(%edx)
}
  8004f1:	5d                   	pop    %ebp
  8004f2:	c3                   	ret    

008004f3 <printfmt>:
{
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fc:	50                   	push   %eax
  8004fd:	ff 75 10             	pushl  0x10(%ebp)
  800500:	ff 75 0c             	pushl  0xc(%ebp)
  800503:	ff 75 08             	pushl  0x8(%ebp)
  800506:	e8 05 00 00 00       	call   800510 <vprintfmt>
}
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	c9                   	leave  
  80050f:	c3                   	ret    

00800510 <vprintfmt>:
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	57                   	push   %edi
  800514:	56                   	push   %esi
  800515:	53                   	push   %ebx
  800516:	83 ec 3c             	sub    $0x3c,%esp
  800519:	8b 75 08             	mov    0x8(%ebp),%esi
  80051c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800522:	e9 32 04 00 00       	jmp    800959 <vprintfmt+0x449>
		padc = ' ';
  800527:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80052b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800532:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800539:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800540:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800547:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80054e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800553:	8d 47 01             	lea    0x1(%edi),%eax
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800559:	0f b6 17             	movzbl (%edi),%edx
  80055c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80055f:	3c 55                	cmp    $0x55,%al
  800561:	0f 87 12 05 00 00    	ja     800a79 <vprintfmt+0x569>
  800567:	0f b6 c0             	movzbl %al,%eax
  80056a:	ff 24 85 60 2f 80 00 	jmp    *0x802f60(,%eax,4)
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800574:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800578:	eb d9                	jmp    800553 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80057d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800581:	eb d0                	jmp    800553 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800583:	0f b6 d2             	movzbl %dl,%edx
  800586:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800589:	b8 00 00 00 00       	mov    $0x0,%eax
  80058e:	89 75 08             	mov    %esi,0x8(%ebp)
  800591:	eb 03                	jmp    800596 <vprintfmt+0x86>
  800593:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800596:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800599:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80059d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005a3:	83 fe 09             	cmp    $0x9,%esi
  8005a6:	76 eb                	jbe    800593 <vprintfmt+0x83>
  8005a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	eb 14                	jmp    8005c4 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c8:	79 89                	jns    800553 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005d7:	e9 77 ff ff ff       	jmp    800553 <vprintfmt+0x43>
  8005dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005df:	85 c0                	test   %eax,%eax
  8005e1:	0f 48 c1             	cmovs  %ecx,%eax
  8005e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ea:	e9 64 ff ff ff       	jmp    800553 <vprintfmt+0x43>
  8005ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005f9:	e9 55 ff ff ff       	jmp    800553 <vprintfmt+0x43>
			lflag++;
  8005fe:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800602:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800605:	e9 49 ff ff ff       	jmp    800553 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 78 04             	lea    0x4(%eax),%edi
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	ff 30                	pushl  (%eax)
  800616:	ff d6                	call   *%esi
			break;
  800618:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80061b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80061e:	e9 33 03 00 00       	jmp    800956 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 78 04             	lea    0x4(%eax),%edi
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	99                   	cltd   
  80062c:	31 d0                	xor    %edx,%eax
  80062e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800630:	83 f8 10             	cmp    $0x10,%eax
  800633:	7f 23                	jg     800658 <vprintfmt+0x148>
  800635:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  80063c:	85 d2                	test   %edx,%edx
  80063e:	74 18                	je     800658 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800640:	52                   	push   %edx
  800641:	68 c9 32 80 00       	push   $0x8032c9
  800646:	53                   	push   %ebx
  800647:	56                   	push   %esi
  800648:	e8 a6 fe ff ff       	call   8004f3 <printfmt>
  80064d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800650:	89 7d 14             	mov    %edi,0x14(%ebp)
  800653:	e9 fe 02 00 00       	jmp    800956 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800658:	50                   	push   %eax
  800659:	68 a3 2d 80 00       	push   $0x802da3
  80065e:	53                   	push   %ebx
  80065f:	56                   	push   %esi
  800660:	e8 8e fe ff ff       	call   8004f3 <printfmt>
  800665:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800668:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80066b:	e9 e6 02 00 00       	jmp    800956 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	83 c0 04             	add    $0x4,%eax
  800676:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80067e:	85 c9                	test   %ecx,%ecx
  800680:	b8 9c 2d 80 00       	mov    $0x802d9c,%eax
  800685:	0f 45 c1             	cmovne %ecx,%eax
  800688:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80068b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068f:	7e 06                	jle    800697 <vprintfmt+0x187>
  800691:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800695:	75 0d                	jne    8006a4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80069a:	89 c7                	mov    %eax,%edi
  80069c:	03 45 e0             	add    -0x20(%ebp),%eax
  80069f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a2:	eb 53                	jmp    8006f7 <vprintfmt+0x1e7>
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006aa:	50                   	push   %eax
  8006ab:	e8 71 04 00 00       	call   800b21 <strnlen>
  8006b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b3:	29 c1                	sub    %eax,%ecx
  8006b5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006bd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c4:	eb 0f                	jmp    8006d5 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8006cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	83 ef 01             	sub    $0x1,%edi
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	85 ff                	test   %edi,%edi
  8006d7:	7f ed                	jg     8006c6 <vprintfmt+0x1b6>
  8006d9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006dc:	85 c9                	test   %ecx,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	0f 49 c1             	cmovns %ecx,%eax
  8006e6:	29 c1                	sub    %eax,%ecx
  8006e8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006eb:	eb aa                	jmp    800697 <vprintfmt+0x187>
					putch(ch, putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	52                   	push   %edx
  8006f2:	ff d6                	call   *%esi
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006fa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fc:	83 c7 01             	add    $0x1,%edi
  8006ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800703:	0f be d0             	movsbl %al,%edx
  800706:	85 d2                	test   %edx,%edx
  800708:	74 4b                	je     800755 <vprintfmt+0x245>
  80070a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80070e:	78 06                	js     800716 <vprintfmt+0x206>
  800710:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800714:	78 1e                	js     800734 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800716:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80071a:	74 d1                	je     8006ed <vprintfmt+0x1dd>
  80071c:	0f be c0             	movsbl %al,%eax
  80071f:	83 e8 20             	sub    $0x20,%eax
  800722:	83 f8 5e             	cmp    $0x5e,%eax
  800725:	76 c6                	jbe    8006ed <vprintfmt+0x1dd>
					putch('?', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	53                   	push   %ebx
  80072b:	6a 3f                	push   $0x3f
  80072d:	ff d6                	call   *%esi
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	eb c3                	jmp    8006f7 <vprintfmt+0x1e7>
  800734:	89 cf                	mov    %ecx,%edi
  800736:	eb 0e                	jmp    800746 <vprintfmt+0x236>
				putch(' ', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 20                	push   $0x20
  80073e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800740:	83 ef 01             	sub    $0x1,%edi
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	85 ff                	test   %edi,%edi
  800748:	7f ee                	jg     800738 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80074a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	e9 01 02 00 00       	jmp    800956 <vprintfmt+0x446>
  800755:	89 cf                	mov    %ecx,%edi
  800757:	eb ed                	jmp    800746 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80075c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800763:	e9 eb fd ff ff       	jmp    800553 <vprintfmt+0x43>
	if (lflag >= 2)
  800768:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80076c:	7f 21                	jg     80078f <vprintfmt+0x27f>
	else if (lflag)
  80076e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800772:	74 68                	je     8007dc <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80077c:	89 c1                	mov    %eax,%ecx
  80077e:	c1 f9 1f             	sar    $0x1f,%ecx
  800781:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	eb 17                	jmp    8007a6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 50 04             	mov    0x4(%eax),%edx
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80079a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 08             	lea    0x8(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b6:	78 3f                	js     8007f7 <vprintfmt+0x2e7>
			base = 10;
  8007b8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007bd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007c1:	0f 84 71 01 00 00    	je     800938 <vprintfmt+0x428>
				putch('+', putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	6a 2b                	push   $0x2b
  8007cd:	ff d6                	call   *%esi
  8007cf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d7:	e9 5c 01 00 00       	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007e4:	89 c1                	mov    %eax,%ecx
  8007e6:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 40 04             	lea    0x4(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f5:	eb af                	jmp    8007a6 <vprintfmt+0x296>
				putch('-', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 2d                	push   $0x2d
  8007fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8007ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800802:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800805:	f7 d8                	neg    %eax
  800807:	83 d2 00             	adc    $0x0,%edx
  80080a:	f7 da                	neg    %edx
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800812:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800815:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081a:	e9 19 01 00 00       	jmp    800938 <vprintfmt+0x428>
	if (lflag >= 2)
  80081f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800823:	7f 29                	jg     80084e <vprintfmt+0x33e>
	else if (lflag)
  800825:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800829:	74 44                	je     80086f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800844:	b8 0a 00 00 00       	mov    $0xa,%eax
  800849:	e9 ea 00 00 00       	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 50 04             	mov    0x4(%eax),%edx
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 08             	lea    0x8(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800865:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086a:	e9 c9 00 00 00       	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800888:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088d:	e9 a6 00 00 00       	jmp    800938 <vprintfmt+0x428>
			putch('0', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 30                	push   $0x30
  800898:	ff d6                	call   *%esi
	if (lflag >= 2)
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a1:	7f 26                	jg     8008c9 <vprintfmt+0x3b9>
	else if (lflag)
  8008a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008a7:	74 3e                	je     8008e7 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8008c7:	eb 6f                	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 50 04             	mov    0x4(%eax),%edx
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 40 08             	lea    0x8(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008e5:	eb 51                	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8d 40 04             	lea    0x4(%eax),%eax
  8008fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800900:	b8 08 00 00 00       	mov    $0x8,%eax
  800905:	eb 31                	jmp    800938 <vprintfmt+0x428>
			putch('0', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	6a 30                	push   $0x30
  80090d:	ff d6                	call   *%esi
			putch('x', putdat);
  80090f:	83 c4 08             	add    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 78                	push   $0x78
  800915:	ff d6                	call   *%esi
			num = (unsigned long long)
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800924:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800927:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800938:	83 ec 0c             	sub    $0xc,%esp
  80093b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80093f:	52                   	push   %edx
  800940:	ff 75 e0             	pushl  -0x20(%ebp)
  800943:	50                   	push   %eax
  800944:	ff 75 dc             	pushl  -0x24(%ebp)
  800947:	ff 75 d8             	pushl  -0x28(%ebp)
  80094a:	89 da                	mov    %ebx,%edx
  80094c:	89 f0                	mov    %esi,%eax
  80094e:	e8 a4 fa ff ff       	call   8003f7 <printnum>
			break;
  800953:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800956:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800959:	83 c7 01             	add    $0x1,%edi
  80095c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800960:	83 f8 25             	cmp    $0x25,%eax
  800963:	0f 84 be fb ff ff    	je     800527 <vprintfmt+0x17>
			if (ch == '\0')
  800969:	85 c0                	test   %eax,%eax
  80096b:	0f 84 28 01 00 00    	je     800a99 <vprintfmt+0x589>
			putch(ch, putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	53                   	push   %ebx
  800975:	50                   	push   %eax
  800976:	ff d6                	call   *%esi
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	eb dc                	jmp    800959 <vprintfmt+0x449>
	if (lflag >= 2)
  80097d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800981:	7f 26                	jg     8009a9 <vprintfmt+0x499>
	else if (lflag)
  800983:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800987:	74 41                	je     8009ca <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800989:	8b 45 14             	mov    0x14(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	ba 00 00 00 00       	mov    $0x0,%edx
  800993:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800996:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	8d 40 04             	lea    0x4(%eax),%eax
  80099f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a2:	b8 10 00 00 00       	mov    $0x10,%eax
  8009a7:	eb 8f                	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ac:	8b 50 04             	mov    0x4(%eax),%edx
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8d 40 08             	lea    0x8(%eax),%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c0:	b8 10 00 00 00       	mov    $0x10,%eax
  8009c5:	e9 6e ff ff ff       	jmp    800938 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8d 40 04             	lea    0x4(%eax),%eax
  8009e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8009e8:	e9 4b ff ff ff       	jmp    800938 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	83 c0 04             	add    $0x4,%eax
  8009f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	85 c0                	test   %eax,%eax
  8009fd:	74 14                	je     800a13 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009ff:	8b 13                	mov    (%ebx),%edx
  800a01:	83 fa 7f             	cmp    $0x7f,%edx
  800a04:	7f 37                	jg     800a3d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a06:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0e:	e9 43 ff ff ff       	jmp    800956 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a18:	bf c1 2e 80 00       	mov    $0x802ec1,%edi
							putch(ch, putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	53                   	push   %ebx
  800a21:	50                   	push   %eax
  800a22:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a24:	83 c7 01             	add    $0x1,%edi
  800a27:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	75 eb                	jne    800a1d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a35:	89 45 14             	mov    %eax,0x14(%ebp)
  800a38:	e9 19 ff ff ff       	jmp    800956 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a3d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a44:	bf f9 2e 80 00       	mov    $0x802ef9,%edi
							putch(ch, putdat);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	53                   	push   %ebx
  800a4d:	50                   	push   %eax
  800a4e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a50:	83 c7 01             	add    $0x1,%edi
  800a53:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	75 eb                	jne    800a49 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a61:	89 45 14             	mov    %eax,0x14(%ebp)
  800a64:	e9 ed fe ff ff       	jmp    800956 <vprintfmt+0x446>
			putch(ch, putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	53                   	push   %ebx
  800a6d:	6a 25                	push   $0x25
  800a6f:	ff d6                	call   *%esi
			break;
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	e9 dd fe ff ff       	jmp    800956 <vprintfmt+0x446>
			putch('%', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	53                   	push   %ebx
  800a7d:	6a 25                	push   $0x25
  800a7f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 f8                	mov    %edi,%eax
  800a86:	eb 03                	jmp    800a8b <vprintfmt+0x57b>
  800a88:	83 e8 01             	sub    $0x1,%eax
  800a8b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a8f:	75 f7                	jne    800a88 <vprintfmt+0x578>
  800a91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a94:	e9 bd fe ff ff       	jmp    800956 <vprintfmt+0x446>
}
  800a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a9c:	5b                   	pop    %ebx
  800a9d:	5e                   	pop    %esi
  800a9e:	5f                   	pop    %edi
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 18             	sub    $0x18,%esp
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ab4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ab7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800abe:	85 c0                	test   %eax,%eax
  800ac0:	74 26                	je     800ae8 <vsnprintf+0x47>
  800ac2:	85 d2                	test   %edx,%edx
  800ac4:	7e 22                	jle    800ae8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac6:	ff 75 14             	pushl  0x14(%ebp)
  800ac9:	ff 75 10             	pushl  0x10(%ebp)
  800acc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800acf:	50                   	push   %eax
  800ad0:	68 d6 04 80 00       	push   $0x8004d6
  800ad5:	e8 36 fa ff ff       	call   800510 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800add:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
}
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    
		return -E_INVAL;
  800ae8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aed:	eb f7                	jmp    800ae6 <vsnprintf+0x45>

00800aef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800af8:	50                   	push   %eax
  800af9:	ff 75 10             	pushl  0x10(%ebp)
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 9a ff ff ff       	call   800aa1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b14:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b18:	74 05                	je     800b1f <strlen+0x16>
		n++;
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	eb f5                	jmp    800b14 <strlen+0xb>
	return n;
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	74 0d                	je     800b40 <strnlen+0x1f>
  800b33:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b37:	74 05                	je     800b3e <strnlen+0x1d>
		n++;
  800b39:	83 c2 01             	add    $0x1,%edx
  800b3c:	eb f1                	jmp    800b2f <strnlen+0xe>
  800b3e:	89 d0                	mov    %edx,%eax
	return n;
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	53                   	push   %ebx
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b51:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b55:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	84 c9                	test   %cl,%cl
  800b5d:	75 f2                	jne    800b51 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	53                   	push   %ebx
  800b66:	83 ec 10             	sub    $0x10,%esp
  800b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b6c:	53                   	push   %ebx
  800b6d:	e8 97 ff ff ff       	call   800b09 <strlen>
  800b72:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	01 d8                	add    %ebx,%eax
  800b7a:	50                   	push   %eax
  800b7b:	e8 c2 ff ff ff       	call   800b42 <strcpy>
	return dst;
}
  800b80:	89 d8                	mov    %ebx,%eax
  800b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b92:	89 c6                	mov    %eax,%esi
  800b94:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	39 f2                	cmp    %esi,%edx
  800b9b:	74 11                	je     800bae <strncpy+0x27>
		*dst++ = *src;
  800b9d:	83 c2 01             	add    $0x1,%edx
  800ba0:	0f b6 19             	movzbl (%ecx),%ebx
  800ba3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ba6:	80 fb 01             	cmp    $0x1,%bl
  800ba9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bac:	eb eb                	jmp    800b99 <strncpy+0x12>
	}
	return ret;
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	8b 75 08             	mov    0x8(%ebp),%esi
  800bba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbd:	8b 55 10             	mov    0x10(%ebp),%edx
  800bc0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bc2:	85 d2                	test   %edx,%edx
  800bc4:	74 21                	je     800be7 <strlcpy+0x35>
  800bc6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bca:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bcc:	39 c2                	cmp    %eax,%edx
  800bce:	74 14                	je     800be4 <strlcpy+0x32>
  800bd0:	0f b6 19             	movzbl (%ecx),%ebx
  800bd3:	84 db                	test   %bl,%bl
  800bd5:	74 0b                	je     800be2 <strlcpy+0x30>
			*dst++ = *src++;
  800bd7:	83 c1 01             	add    $0x1,%ecx
  800bda:	83 c2 01             	add    $0x1,%edx
  800bdd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800be0:	eb ea                	jmp    800bcc <strlcpy+0x1a>
  800be2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800be4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be7:	29 f0                	sub    %esi,%eax
}
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bf6:	0f b6 01             	movzbl (%ecx),%eax
  800bf9:	84 c0                	test   %al,%al
  800bfb:	74 0c                	je     800c09 <strcmp+0x1c>
  800bfd:	3a 02                	cmp    (%edx),%al
  800bff:	75 08                	jne    800c09 <strcmp+0x1c>
		p++, q++;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	eb ed                	jmp    800bf6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c09:	0f b6 c0             	movzbl %al,%eax
  800c0c:	0f b6 12             	movzbl (%edx),%edx
  800c0f:	29 d0                	sub    %edx,%eax
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	53                   	push   %ebx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	89 c3                	mov    %eax,%ebx
  800c1f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c22:	eb 06                	jmp    800c2a <strncmp+0x17>
		n--, p++, q++;
  800c24:	83 c0 01             	add    $0x1,%eax
  800c27:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c2a:	39 d8                	cmp    %ebx,%eax
  800c2c:	74 16                	je     800c44 <strncmp+0x31>
  800c2e:	0f b6 08             	movzbl (%eax),%ecx
  800c31:	84 c9                	test   %cl,%cl
  800c33:	74 04                	je     800c39 <strncmp+0x26>
  800c35:	3a 0a                	cmp    (%edx),%cl
  800c37:	74 eb                	je     800c24 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c39:	0f b6 00             	movzbl (%eax),%eax
  800c3c:	0f b6 12             	movzbl (%edx),%edx
  800c3f:	29 d0                	sub    %edx,%eax
}
  800c41:	5b                   	pop    %ebx
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    
		return 0;
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
  800c49:	eb f6                	jmp    800c41 <strncmp+0x2e>

00800c4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c55:	0f b6 10             	movzbl (%eax),%edx
  800c58:	84 d2                	test   %dl,%dl
  800c5a:	74 09                	je     800c65 <strchr+0x1a>
		if (*s == c)
  800c5c:	38 ca                	cmp    %cl,%dl
  800c5e:	74 0a                	je     800c6a <strchr+0x1f>
	for (; *s; s++)
  800c60:	83 c0 01             	add    $0x1,%eax
  800c63:	eb f0                	jmp    800c55 <strchr+0xa>
			return (char *) s;
	return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c76:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c79:	38 ca                	cmp    %cl,%dl
  800c7b:	74 09                	je     800c86 <strfind+0x1a>
  800c7d:	84 d2                	test   %dl,%dl
  800c7f:	74 05                	je     800c86 <strfind+0x1a>
	for (; *s; s++)
  800c81:	83 c0 01             	add    $0x1,%eax
  800c84:	eb f0                	jmp    800c76 <strfind+0xa>
			break;
	return (char *) s;
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	53                   	push   %ebx
  800c8e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c94:	85 c9                	test   %ecx,%ecx
  800c96:	74 31                	je     800cc9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c98:	89 f8                	mov    %edi,%eax
  800c9a:	09 c8                	or     %ecx,%eax
  800c9c:	a8 03                	test   $0x3,%al
  800c9e:	75 23                	jne    800cc3 <memset+0x3b>
		c &= 0xFF;
  800ca0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	c1 e3 08             	shl    $0x8,%ebx
  800ca9:	89 d0                	mov    %edx,%eax
  800cab:	c1 e0 18             	shl    $0x18,%eax
  800cae:	89 d6                	mov    %edx,%esi
  800cb0:	c1 e6 10             	shl    $0x10,%esi
  800cb3:	09 f0                	or     %esi,%eax
  800cb5:	09 c2                	or     %eax,%edx
  800cb7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cb9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cbc:	89 d0                	mov    %edx,%eax
  800cbe:	fc                   	cld    
  800cbf:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc1:	eb 06                	jmp    800cc9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	fc                   	cld    
  800cc7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cc9:	89 f8                	mov    %edi,%eax
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cde:	39 c6                	cmp    %eax,%esi
  800ce0:	73 32                	jae    800d14 <memmove+0x44>
  800ce2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce5:	39 c2                	cmp    %eax,%edx
  800ce7:	76 2b                	jbe    800d14 <memmove+0x44>
		s += n;
		d += n;
  800ce9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cec:	89 fe                	mov    %edi,%esi
  800cee:	09 ce                	or     %ecx,%esi
  800cf0:	09 d6                	or     %edx,%esi
  800cf2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cf8:	75 0e                	jne    800d08 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cfa:	83 ef 04             	sub    $0x4,%edi
  800cfd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d03:	fd                   	std    
  800d04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d06:	eb 09                	jmp    800d11 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d08:	83 ef 01             	sub    $0x1,%edi
  800d0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d0e:	fd                   	std    
  800d0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d11:	fc                   	cld    
  800d12:	eb 1a                	jmp    800d2e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d14:	89 c2                	mov    %eax,%edx
  800d16:	09 ca                	or     %ecx,%edx
  800d18:	09 f2                	or     %esi,%edx
  800d1a:	f6 c2 03             	test   $0x3,%dl
  800d1d:	75 0a                	jne    800d29 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d22:	89 c7                	mov    %eax,%edi
  800d24:	fc                   	cld    
  800d25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d27:	eb 05                	jmp    800d2e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d29:	89 c7                	mov    %eax,%edi
  800d2b:	fc                   	cld    
  800d2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d38:	ff 75 10             	pushl  0x10(%ebp)
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	ff 75 08             	pushl  0x8(%ebp)
  800d41:	e8 8a ff ff ff       	call   800cd0 <memmove>
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d53:	89 c6                	mov    %eax,%esi
  800d55:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d58:	39 f0                	cmp    %esi,%eax
  800d5a:	74 1c                	je     800d78 <memcmp+0x30>
		if (*s1 != *s2)
  800d5c:	0f b6 08             	movzbl (%eax),%ecx
  800d5f:	0f b6 1a             	movzbl (%edx),%ebx
  800d62:	38 d9                	cmp    %bl,%cl
  800d64:	75 08                	jne    800d6e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d66:	83 c0 01             	add    $0x1,%eax
  800d69:	83 c2 01             	add    $0x1,%edx
  800d6c:	eb ea                	jmp    800d58 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d6e:	0f b6 c1             	movzbl %cl,%eax
  800d71:	0f b6 db             	movzbl %bl,%ebx
  800d74:	29 d8                	sub    %ebx,%eax
  800d76:	eb 05                	jmp    800d7d <memcmp+0x35>
	}

	return 0;
  800d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d8f:	39 d0                	cmp    %edx,%eax
  800d91:	73 09                	jae    800d9c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d93:	38 08                	cmp    %cl,(%eax)
  800d95:	74 05                	je     800d9c <memfind+0x1b>
	for (; s < ends; s++)
  800d97:	83 c0 01             	add    $0x1,%eax
  800d9a:	eb f3                	jmp    800d8f <memfind+0xe>
			break;
	return (void *) s;
}
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800daa:	eb 03                	jmp    800daf <strtol+0x11>
		s++;
  800dac:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800daf:	0f b6 01             	movzbl (%ecx),%eax
  800db2:	3c 20                	cmp    $0x20,%al
  800db4:	74 f6                	je     800dac <strtol+0xe>
  800db6:	3c 09                	cmp    $0x9,%al
  800db8:	74 f2                	je     800dac <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dba:	3c 2b                	cmp    $0x2b,%al
  800dbc:	74 2a                	je     800de8 <strtol+0x4a>
	int neg = 0;
  800dbe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dc3:	3c 2d                	cmp    $0x2d,%al
  800dc5:	74 2b                	je     800df2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dcd:	75 0f                	jne    800dde <strtol+0x40>
  800dcf:	80 39 30             	cmpb   $0x30,(%ecx)
  800dd2:	74 28                	je     800dfc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dd4:	85 db                	test   %ebx,%ebx
  800dd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ddb:	0f 44 d8             	cmove  %eax,%ebx
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800de6:	eb 50                	jmp    800e38 <strtol+0x9a>
		s++;
  800de8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800deb:	bf 00 00 00 00       	mov    $0x0,%edi
  800df0:	eb d5                	jmp    800dc7 <strtol+0x29>
		s++, neg = 1;
  800df2:	83 c1 01             	add    $0x1,%ecx
  800df5:	bf 01 00 00 00       	mov    $0x1,%edi
  800dfa:	eb cb                	jmp    800dc7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dfc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e00:	74 0e                	je     800e10 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e02:	85 db                	test   %ebx,%ebx
  800e04:	75 d8                	jne    800dde <strtol+0x40>
		s++, base = 8;
  800e06:	83 c1 01             	add    $0x1,%ecx
  800e09:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e0e:	eb ce                	jmp    800dde <strtol+0x40>
		s += 2, base = 16;
  800e10:	83 c1 02             	add    $0x2,%ecx
  800e13:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e18:	eb c4                	jmp    800dde <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e1a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e1d:	89 f3                	mov    %esi,%ebx
  800e1f:	80 fb 19             	cmp    $0x19,%bl
  800e22:	77 29                	ja     800e4d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e24:	0f be d2             	movsbl %dl,%edx
  800e27:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e2a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e2d:	7d 30                	jge    800e5f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e2f:	83 c1 01             	add    $0x1,%ecx
  800e32:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e38:	0f b6 11             	movzbl (%ecx),%edx
  800e3b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e3e:	89 f3                	mov    %esi,%ebx
  800e40:	80 fb 09             	cmp    $0x9,%bl
  800e43:	77 d5                	ja     800e1a <strtol+0x7c>
			dig = *s - '0';
  800e45:	0f be d2             	movsbl %dl,%edx
  800e48:	83 ea 30             	sub    $0x30,%edx
  800e4b:	eb dd                	jmp    800e2a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e4d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e50:	89 f3                	mov    %esi,%ebx
  800e52:	80 fb 19             	cmp    $0x19,%bl
  800e55:	77 08                	ja     800e5f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e57:	0f be d2             	movsbl %dl,%edx
  800e5a:	83 ea 37             	sub    $0x37,%edx
  800e5d:	eb cb                	jmp    800e2a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e63:	74 05                	je     800e6a <strtol+0xcc>
		*endptr = (char *) s;
  800e65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e68:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e6a:	89 c2                	mov    %eax,%edx
  800e6c:	f7 da                	neg    %edx
  800e6e:	85 ff                	test   %edi,%edi
  800e70:	0f 45 c2             	cmovne %edx,%eax
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	89 c3                	mov    %eax,%ebx
  800e8b:	89 c7                	mov    %eax,%edi
  800e8d:	89 c6                	mov    %eax,%esi
  800e8f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea6:	89 d1                	mov    %edx,%ecx
  800ea8:	89 d3                	mov    %edx,%ebx
  800eaa:	89 d7                	mov    %edx,%edi
  800eac:	89 d6                	mov    %edx,%esi
  800eae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
  800ebb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	b8 03 00 00 00       	mov    $0x3,%eax
  800ecb:	89 cb                	mov    %ecx,%ebx
  800ecd:	89 cf                	mov    %ecx,%edi
  800ecf:	89 ce                	mov    %ecx,%esi
  800ed1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7f 08                	jg     800edf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	50                   	push   %eax
  800ee3:	6a 03                	push   $0x3
  800ee5:	68 04 31 80 00       	push   $0x803104
  800eea:	6a 43                	push   $0x43
  800eec:	68 21 31 80 00       	push   $0x803121
  800ef1:	e8 f7 f3 ff ff       	call   8002ed <_panic>

00800ef6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efc:	ba 00 00 00 00       	mov    $0x0,%edx
  800f01:	b8 02 00 00 00       	mov    $0x2,%eax
  800f06:	89 d1                	mov    %edx,%ecx
  800f08:	89 d3                	mov    %edx,%ebx
  800f0a:	89 d7                	mov    %edx,%edi
  800f0c:	89 d6                	mov    %edx,%esi
  800f0e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_yield>:

void
sys_yield(void)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f20:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f25:	89 d1                	mov    %edx,%ecx
  800f27:	89 d3                	mov    %edx,%ebx
  800f29:	89 d7                	mov    %edx,%edi
  800f2b:	89 d6                	mov    %edx,%esi
  800f2d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3d:	be 00 00 00 00       	mov    $0x0,%esi
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	b8 04 00 00 00       	mov    $0x4,%eax
  800f4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f50:	89 f7                	mov    %esi,%edi
  800f52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	7f 08                	jg     800f60 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f60:	83 ec 0c             	sub    $0xc,%esp
  800f63:	50                   	push   %eax
  800f64:	6a 04                	push   $0x4
  800f66:	68 04 31 80 00       	push   $0x803104
  800f6b:	6a 43                	push   $0x43
  800f6d:	68 21 31 80 00       	push   $0x803121
  800f72:	e8 76 f3 ff ff       	call   8002ed <_panic>

00800f77 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f86:	b8 05 00 00 00       	mov    $0x5,%eax
  800f8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f91:	8b 75 18             	mov    0x18(%ebp),%esi
  800f94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f96:	85 c0                	test   %eax,%eax
  800f98:	7f 08                	jg     800fa2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa2:	83 ec 0c             	sub    $0xc,%esp
  800fa5:	50                   	push   %eax
  800fa6:	6a 05                	push   $0x5
  800fa8:	68 04 31 80 00       	push   $0x803104
  800fad:	6a 43                	push   $0x43
  800faf:	68 21 31 80 00       	push   $0x803121
  800fb4:	e8 34 f3 ff ff       	call   8002ed <_panic>

00800fb9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcd:	b8 06 00 00 00       	mov    $0x6,%eax
  800fd2:	89 df                	mov    %ebx,%edi
  800fd4:	89 de                	mov    %ebx,%esi
  800fd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	7f 08                	jg     800fe4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdf:	5b                   	pop    %ebx
  800fe0:	5e                   	pop    %esi
  800fe1:	5f                   	pop    %edi
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe4:	83 ec 0c             	sub    $0xc,%esp
  800fe7:	50                   	push   %eax
  800fe8:	6a 06                	push   $0x6
  800fea:	68 04 31 80 00       	push   $0x803104
  800fef:	6a 43                	push   $0x43
  800ff1:	68 21 31 80 00       	push   $0x803121
  800ff6:	e8 f2 f2 ff ff       	call   8002ed <_panic>

00800ffb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
  801001:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801004:	bb 00 00 00 00       	mov    $0x0,%ebx
  801009:	8b 55 08             	mov    0x8(%ebp),%edx
  80100c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100f:	b8 08 00 00 00       	mov    $0x8,%eax
  801014:	89 df                	mov    %ebx,%edi
  801016:	89 de                	mov    %ebx,%esi
  801018:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7f 08                	jg     801026 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80101e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	50                   	push   %eax
  80102a:	6a 08                	push   $0x8
  80102c:	68 04 31 80 00       	push   $0x803104
  801031:	6a 43                	push   $0x43
  801033:	68 21 31 80 00       	push   $0x803121
  801038:	e8 b0 f2 ff ff       	call   8002ed <_panic>

0080103d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	b8 09 00 00 00       	mov    $0x9,%eax
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7f 08                	jg     801068 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801060:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	50                   	push   %eax
  80106c:	6a 09                	push   $0x9
  80106e:	68 04 31 80 00       	push   $0x803104
  801073:	6a 43                	push   $0x43
  801075:	68 21 31 80 00       	push   $0x803121
  80107a:	e8 6e f2 ff ff       	call   8002ed <_panic>

0080107f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801093:	b8 0a 00 00 00       	mov    $0xa,%eax
  801098:	89 df                	mov    %ebx,%edi
  80109a:	89 de                	mov    %ebx,%esi
  80109c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7f 08                	jg     8010aa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	50                   	push   %eax
  8010ae:	6a 0a                	push   $0xa
  8010b0:	68 04 31 80 00       	push   $0x803104
  8010b5:	6a 43                	push   $0x43
  8010b7:	68 21 31 80 00       	push   $0x803121
  8010bc:	e8 2c f2 ff ff       	call   8002ed <_panic>

008010c1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010d2:	be 00 00 00 00       	mov    $0x0,%esi
  8010d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010da:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010dd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010df:	5b                   	pop    %ebx
  8010e0:	5e                   	pop    %esi
  8010e1:	5f                   	pop    %edi
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010fa:	89 cb                	mov    %ecx,%ebx
  8010fc:	89 cf                	mov    %ecx,%edi
  8010fe:	89 ce                	mov    %ecx,%esi
  801100:	cd 30                	int    $0x30
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	6a 0d                	push   $0xd
  801114:	68 04 31 80 00       	push   $0x803104
  801119:	6a 43                	push   $0x43
  80111b:	68 21 31 80 00       	push   $0x803121
  801120:	e8 c8 f1 ff ff       	call   8002ed <_panic>

00801125 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801136:	b8 0e 00 00 00       	mov    $0xe,%eax
  80113b:	89 df                	mov    %ebx,%edi
  80113d:	89 de                	mov    %ebx,%esi
  80113f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	b8 0f 00 00 00       	mov    $0xf,%eax
  801159:	89 cb                	mov    %ecx,%ebx
  80115b:	89 cf                	mov    %ecx,%edi
  80115d:	89 ce                	mov    %ecx,%esi
  80115f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116c:	ba 00 00 00 00       	mov    $0x0,%edx
  801171:	b8 10 00 00 00       	mov    $0x10,%eax
  801176:	89 d1                	mov    %edx,%ecx
  801178:	89 d3                	mov    %edx,%ebx
  80117a:	89 d7                	mov    %edx,%edi
  80117c:	89 d6                	mov    %edx,%esi
  80117e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801190:	8b 55 08             	mov    0x8(%ebp),%edx
  801193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801196:	b8 11 00 00 00       	mov    $0x11,%eax
  80119b:	89 df                	mov    %ebx,%edi
  80119d:	89 de                	mov    %ebx,%esi
  80119f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b7:	b8 12 00 00 00       	mov    $0x12,%eax
  8011bc:	89 df                	mov    %ebx,%edi
  8011be:	89 de                	mov    %ebx,%esi
  8011c0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5f                   	pop    %edi
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	57                   	push   %edi
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011db:	b8 13 00 00 00       	mov    $0x13,%eax
  8011e0:	89 df                	mov    %ebx,%edi
  8011e2:	89 de                	mov    %ebx,%esi
  8011e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	7f 08                	jg     8011f2 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5f                   	pop    %edi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	50                   	push   %eax
  8011f6:	6a 13                	push   $0x13
  8011f8:	68 04 31 80 00       	push   $0x803104
  8011fd:	6a 43                	push   $0x43
  8011ff:	68 21 31 80 00       	push   $0x803121
  801204:	e8 e4 f0 ff ff       	call   8002ed <_panic>

00801209 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	53                   	push   %ebx
  80120d:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801210:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801217:	f6 c5 04             	test   $0x4,%ch
  80121a:	75 45                	jne    801261 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80121c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801223:	83 e1 07             	and    $0x7,%ecx
  801226:	83 f9 07             	cmp    $0x7,%ecx
  801229:	74 6f                	je     80129a <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80122b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801232:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801238:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80123e:	0f 84 b6 00 00 00    	je     8012fa <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801244:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80124b:	83 e1 05             	and    $0x5,%ecx
  80124e:	83 f9 05             	cmp    $0x5,%ecx
  801251:	0f 84 d7 00 00 00    	je     80132e <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
  80125c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125f:	c9                   	leave  
  801260:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801261:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801268:	c1 e2 0c             	shl    $0xc,%edx
  80126b:	83 ec 0c             	sub    $0xc,%esp
  80126e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801274:	51                   	push   %ecx
  801275:	52                   	push   %edx
  801276:	50                   	push   %eax
  801277:	52                   	push   %edx
  801278:	6a 00                	push   $0x0
  80127a:	e8 f8 fc ff ff       	call   800f77 <sys_page_map>
		if(r < 0)
  80127f:	83 c4 20             	add    $0x20,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	79 d1                	jns    801257 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	68 2f 31 80 00       	push   $0x80312f
  80128e:	6a 54                	push   $0x54
  801290:	68 45 31 80 00       	push   $0x803145
  801295:	e8 53 f0 ff ff       	call   8002ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80129a:	89 d3                	mov    %edx,%ebx
  80129c:	c1 e3 0c             	shl    $0xc,%ebx
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	68 05 08 00 00       	push   $0x805
  8012a7:	53                   	push   %ebx
  8012a8:	50                   	push   %eax
  8012a9:	53                   	push   %ebx
  8012aa:	6a 00                	push   $0x0
  8012ac:	e8 c6 fc ff ff       	call   800f77 <sys_page_map>
		if(r < 0)
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 2e                	js     8012e6 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	68 05 08 00 00       	push   $0x805
  8012c0:	53                   	push   %ebx
  8012c1:	6a 00                	push   $0x0
  8012c3:	53                   	push   %ebx
  8012c4:	6a 00                	push   $0x0
  8012c6:	e8 ac fc ff ff       	call   800f77 <sys_page_map>
		if(r < 0)
  8012cb:	83 c4 20             	add    $0x20,%esp
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	79 85                	jns    801257 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012d2:	83 ec 04             	sub    $0x4,%esp
  8012d5:	68 2f 31 80 00       	push   $0x80312f
  8012da:	6a 5f                	push   $0x5f
  8012dc:	68 45 31 80 00       	push   $0x803145
  8012e1:	e8 07 f0 ff ff       	call   8002ed <_panic>
			panic("sys_page_map() panic\n");
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	68 2f 31 80 00       	push   $0x80312f
  8012ee:	6a 5b                	push   $0x5b
  8012f0:	68 45 31 80 00       	push   $0x803145
  8012f5:	e8 f3 ef ff ff       	call   8002ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012fa:	c1 e2 0c             	shl    $0xc,%edx
  8012fd:	83 ec 0c             	sub    $0xc,%esp
  801300:	68 05 08 00 00       	push   $0x805
  801305:	52                   	push   %edx
  801306:	50                   	push   %eax
  801307:	52                   	push   %edx
  801308:	6a 00                	push   $0x0
  80130a:	e8 68 fc ff ff       	call   800f77 <sys_page_map>
		if(r < 0)
  80130f:	83 c4 20             	add    $0x20,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	0f 89 3d ff ff ff    	jns    801257 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	68 2f 31 80 00       	push   $0x80312f
  801322:	6a 66                	push   $0x66
  801324:	68 45 31 80 00       	push   $0x803145
  801329:	e8 bf ef ff ff       	call   8002ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80132e:	c1 e2 0c             	shl    $0xc,%edx
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	6a 05                	push   $0x5
  801336:	52                   	push   %edx
  801337:	50                   	push   %eax
  801338:	52                   	push   %edx
  801339:	6a 00                	push   $0x0
  80133b:	e8 37 fc ff ff       	call   800f77 <sys_page_map>
		if(r < 0)
  801340:	83 c4 20             	add    $0x20,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	0f 89 0c ff ff ff    	jns    801257 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	68 2f 31 80 00       	push   $0x80312f
  801353:	6a 6d                	push   $0x6d
  801355:	68 45 31 80 00       	push   $0x803145
  80135a:	e8 8e ef ff ff       	call   8002ed <_panic>

0080135f <pgfault>:
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	53                   	push   %ebx
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801369:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80136b:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80136f:	0f 84 99 00 00 00    	je     80140e <pgfault+0xaf>
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 ea 16             	shr    $0x16,%edx
  80137a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801381:	f6 c2 01             	test   $0x1,%dl
  801384:	0f 84 84 00 00 00    	je     80140e <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80138a:	89 c2                	mov    %eax,%edx
  80138c:	c1 ea 0c             	shr    $0xc,%edx
  80138f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801396:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80139c:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013a2:	75 6a                	jne    80140e <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a9:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	6a 07                	push   $0x7
  8013b0:	68 00 f0 7f 00       	push   $0x7ff000
  8013b5:	6a 00                	push   $0x0
  8013b7:	e8 78 fb ff ff       	call   800f34 <sys_page_alloc>
	if(ret < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 5f                	js     801422 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	68 00 10 00 00       	push   $0x1000
  8013cb:	53                   	push   %ebx
  8013cc:	68 00 f0 7f 00       	push   $0x7ff000
  8013d1:	e8 5c f9 ff ff       	call   800d32 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013d6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013dd:	53                   	push   %ebx
  8013de:	6a 00                	push   $0x0
  8013e0:	68 00 f0 7f 00       	push   $0x7ff000
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 8b fb ff ff       	call   800f77 <sys_page_map>
	if(ret < 0)
  8013ec:	83 c4 20             	add    $0x20,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 43                	js     801436 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	68 00 f0 7f 00       	push   $0x7ff000
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 b7 fb ff ff       	call   800fb9 <sys_page_unmap>
	if(ret < 0)
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 41                	js     80144a <pgfault+0xeb>
}
  801409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    
		panic("panic at pgfault()\n");
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	68 50 31 80 00       	push   $0x803150
  801416:	6a 26                	push   $0x26
  801418:	68 45 31 80 00       	push   $0x803145
  80141d:	e8 cb ee ff ff       	call   8002ed <_panic>
		panic("panic in sys_page_alloc()\n");
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	68 64 31 80 00       	push   $0x803164
  80142a:	6a 31                	push   $0x31
  80142c:	68 45 31 80 00       	push   $0x803145
  801431:	e8 b7 ee ff ff       	call   8002ed <_panic>
		panic("panic in sys_page_map()\n");
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	68 7f 31 80 00       	push   $0x80317f
  80143e:	6a 36                	push   $0x36
  801440:	68 45 31 80 00       	push   $0x803145
  801445:	e8 a3 ee ff ff       	call   8002ed <_panic>
		panic("panic in sys_page_unmap()\n");
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	68 98 31 80 00       	push   $0x803198
  801452:	6a 39                	push   $0x39
  801454:	68 45 31 80 00       	push   $0x803145
  801459:	e8 8f ee ff ff       	call   8002ed <_panic>

0080145e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801467:	68 5f 13 80 00       	push   $0x80135f
  80146c:	e8 d5 13 00 00       	call   802846 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801471:	b8 07 00 00 00       	mov    $0x7,%eax
  801476:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 27                	js     8014a6 <fork+0x48>
  80147f:	89 c6                	mov    %eax,%esi
  801481:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801483:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801488:	75 48                	jne    8014d2 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80148a:	e8 67 fa ff ff       	call   800ef6 <sys_getenvid>
  80148f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801494:	c1 e0 07             	shl    $0x7,%eax
  801497:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80149c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014a1:	e9 90 00 00 00       	jmp    801536 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 b4 31 80 00       	push   $0x8031b4
  8014ae:	68 8c 00 00 00       	push   $0x8c
  8014b3:	68 45 31 80 00       	push   $0x803145
  8014b8:	e8 30 ee ff ff       	call   8002ed <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014bd:	89 f8                	mov    %edi,%eax
  8014bf:	e8 45 fd ff ff       	call   801209 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ca:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014d0:	74 26                	je     8014f8 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014d2:	89 d8                	mov    %ebx,%eax
  8014d4:	c1 e8 16             	shr    $0x16,%eax
  8014d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014de:	a8 01                	test   $0x1,%al
  8014e0:	74 e2                	je     8014c4 <fork+0x66>
  8014e2:	89 da                	mov    %ebx,%edx
  8014e4:	c1 ea 0c             	shr    $0xc,%edx
  8014e7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014ee:	83 e0 05             	and    $0x5,%eax
  8014f1:	83 f8 05             	cmp    $0x5,%eax
  8014f4:	75 ce                	jne    8014c4 <fork+0x66>
  8014f6:	eb c5                	jmp    8014bd <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	6a 07                	push   $0x7
  8014fd:	68 00 f0 bf ee       	push   $0xeebff000
  801502:	56                   	push   %esi
  801503:	e8 2c fa ff ff       	call   800f34 <sys_page_alloc>
	if(ret < 0)
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 31                	js     801540 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	68 b5 28 80 00       	push   $0x8028b5
  801517:	56                   	push   %esi
  801518:	e8 62 fb ff ff       	call   80107f <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 33                	js     801557 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	6a 02                	push   $0x2
  801529:	56                   	push   %esi
  80152a:	e8 cc fa ff ff       	call   800ffb <sys_env_set_status>
	if(ret < 0)
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 38                	js     80156e <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801536:	89 f0                	mov    %esi,%eax
  801538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5f                   	pop    %edi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	68 64 31 80 00       	push   $0x803164
  801548:	68 98 00 00 00       	push   $0x98
  80154d:	68 45 31 80 00       	push   $0x803145
  801552:	e8 96 ed ff ff       	call   8002ed <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 d8 31 80 00       	push   $0x8031d8
  80155f:	68 9b 00 00 00       	push   $0x9b
  801564:	68 45 31 80 00       	push   $0x803145
  801569:	e8 7f ed ff ff       	call   8002ed <_panic>
		panic("panic in sys_env_set_status()\n");
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	68 00 32 80 00       	push   $0x803200
  801576:	68 9e 00 00 00       	push   $0x9e
  80157b:	68 45 31 80 00       	push   $0x803145
  801580:	e8 68 ed ff ff       	call   8002ed <_panic>

00801585 <sfork>:

// Challenge!
int
sfork(void)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80158e:	68 5f 13 80 00       	push   $0x80135f
  801593:	e8 ae 12 00 00       	call   802846 <set_pgfault_handler>
  801598:	b8 07 00 00 00       	mov    $0x7,%eax
  80159d:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 27                	js     8015cd <sfork+0x48>
  8015a6:	89 c7                	mov    %eax,%edi
  8015a8:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015aa:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015af:	75 55                	jne    801606 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015b1:	e8 40 f9 ff ff       	call   800ef6 <sys_getenvid>
  8015b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015bb:	c1 e0 07             	shl    $0x7,%eax
  8015be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015c3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015c8:	e9 d4 00 00 00       	jmp    8016a1 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	68 b4 31 80 00       	push   $0x8031b4
  8015d5:	68 af 00 00 00       	push   $0xaf
  8015da:	68 45 31 80 00       	push   $0x803145
  8015df:	e8 09 ed ff ff       	call   8002ed <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015e4:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015e9:	89 f0                	mov    %esi,%eax
  8015eb:	e8 19 fc ff ff       	call   801209 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015f6:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015fc:	77 65                	ja     801663 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015fe:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801604:	74 de                	je     8015e4 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801606:	89 d8                	mov    %ebx,%eax
  801608:	c1 e8 16             	shr    $0x16,%eax
  80160b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801612:	a8 01                	test   $0x1,%al
  801614:	74 da                	je     8015f0 <sfork+0x6b>
  801616:	89 da                	mov    %ebx,%edx
  801618:	c1 ea 0c             	shr    $0xc,%edx
  80161b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801622:	83 e0 05             	and    $0x5,%eax
  801625:	83 f8 05             	cmp    $0x5,%eax
  801628:	75 c6                	jne    8015f0 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80162a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801631:	c1 e2 0c             	shl    $0xc,%edx
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	83 e0 07             	and    $0x7,%eax
  80163a:	50                   	push   %eax
  80163b:	52                   	push   %edx
  80163c:	56                   	push   %esi
  80163d:	52                   	push   %edx
  80163e:	6a 00                	push   $0x0
  801640:	e8 32 f9 ff ff       	call   800f77 <sys_page_map>
  801645:	83 c4 20             	add    $0x20,%esp
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 a4                	je     8015f0 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 2f 31 80 00       	push   $0x80312f
  801654:	68 ba 00 00 00       	push   $0xba
  801659:	68 45 31 80 00       	push   $0x803145
  80165e:	e8 8a ec ff ff       	call   8002ed <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	6a 07                	push   $0x7
  801668:	68 00 f0 bf ee       	push   $0xeebff000
  80166d:	57                   	push   %edi
  80166e:	e8 c1 f8 ff ff       	call   800f34 <sys_page_alloc>
	if(ret < 0)
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	78 31                	js     8016ab <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	68 b5 28 80 00       	push   $0x8028b5
  801682:	57                   	push   %edi
  801683:	e8 f7 f9 ff ff       	call   80107f <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 33                	js     8016c2 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	6a 02                	push   $0x2
  801694:	57                   	push   %edi
  801695:	e8 61 f9 ff ff       	call   800ffb <sys_env_set_status>
	if(ret < 0)
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 38                	js     8016d9 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016a1:	89 f8                	mov    %edi,%eax
  8016a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5f                   	pop    %edi
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 64 31 80 00       	push   $0x803164
  8016b3:	68 c0 00 00 00       	push   $0xc0
  8016b8:	68 45 31 80 00       	push   $0x803145
  8016bd:	e8 2b ec ff ff       	call   8002ed <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 d8 31 80 00       	push   $0x8031d8
  8016ca:	68 c3 00 00 00       	push   $0xc3
  8016cf:	68 45 31 80 00       	push   $0x803145
  8016d4:	e8 14 ec ff ff       	call   8002ed <_panic>
		panic("panic in sys_env_set_status()\n");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 00 32 80 00       	push   $0x803200
  8016e1:	68 c6 00 00 00       	push   $0xc6
  8016e6:	68 45 31 80 00       	push   $0x803145
  8016eb:	e8 fd eb ff ff       	call   8002ed <_panic>

008016f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80170b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801710:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80171f:	89 c2                	mov    %eax,%edx
  801721:	c1 ea 16             	shr    $0x16,%edx
  801724:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80172b:	f6 c2 01             	test   $0x1,%dl
  80172e:	74 2d                	je     80175d <fd_alloc+0x46>
  801730:	89 c2                	mov    %eax,%edx
  801732:	c1 ea 0c             	shr    $0xc,%edx
  801735:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80173c:	f6 c2 01             	test   $0x1,%dl
  80173f:	74 1c                	je     80175d <fd_alloc+0x46>
  801741:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801746:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80174b:	75 d2                	jne    80171f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801756:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80175b:	eb 0a                	jmp    801767 <fd_alloc+0x50>
			*fd_store = fd;
  80175d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801760:	89 01                	mov    %eax,(%ecx)
			return 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80176f:	83 f8 1f             	cmp    $0x1f,%eax
  801772:	77 30                	ja     8017a4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801774:	c1 e0 0c             	shl    $0xc,%eax
  801777:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80177c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801782:	f6 c2 01             	test   $0x1,%dl
  801785:	74 24                	je     8017ab <fd_lookup+0x42>
  801787:	89 c2                	mov    %eax,%edx
  801789:	c1 ea 0c             	shr    $0xc,%edx
  80178c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801793:	f6 c2 01             	test   $0x1,%dl
  801796:	74 1a                	je     8017b2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	89 02                	mov    %eax,(%edx)
	return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
		return -E_INVAL;
  8017a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a9:	eb f7                	jmp    8017a2 <fd_lookup+0x39>
		return -E_INVAL;
  8017ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b0:	eb f0                	jmp    8017a2 <fd_lookup+0x39>
  8017b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b7:	eb e9                	jmp    8017a2 <fd_lookup+0x39>

008017b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
  8017bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017cc:	39 08                	cmp    %ecx,(%eax)
  8017ce:	74 38                	je     801808 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017d0:	83 c2 01             	add    $0x1,%edx
  8017d3:	8b 04 95 9c 32 80 00 	mov    0x80329c(,%edx,4),%eax
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	75 ee                	jne    8017cc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017de:	a1 08 50 80 00       	mov    0x805008,%eax
  8017e3:	8b 40 48             	mov    0x48(%eax),%eax
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	51                   	push   %ecx
  8017ea:	50                   	push   %eax
  8017eb:	68 20 32 80 00       	push   $0x803220
  8017f0:	e8 ee eb ff ff       	call   8003e3 <cprintf>
	*dev = 0;
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    
			*dev = devtab[i];
  801808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
  801812:	eb f2                	jmp    801806 <dev_lookup+0x4d>

00801814 <fd_close>:
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	57                   	push   %edi
  801818:	56                   	push   %esi
  801819:	53                   	push   %ebx
  80181a:	83 ec 24             	sub    $0x24,%esp
  80181d:	8b 75 08             	mov    0x8(%ebp),%esi
  801820:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801823:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801826:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801827:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80182d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801830:	50                   	push   %eax
  801831:	e8 33 ff ff ff       	call   801769 <fd_lookup>
  801836:	89 c3                	mov    %eax,%ebx
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 05                	js     801844 <fd_close+0x30>
	    || fd != fd2)
  80183f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801842:	74 16                	je     80185a <fd_close+0x46>
		return (must_exist ? r : 0);
  801844:	89 f8                	mov    %edi,%eax
  801846:	84 c0                	test   %al,%al
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
  80184d:	0f 44 d8             	cmove  %eax,%ebx
}
  801850:	89 d8                	mov    %ebx,%eax
  801852:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5f                   	pop    %edi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801860:	50                   	push   %eax
  801861:	ff 36                	pushl  (%esi)
  801863:	e8 51 ff ff ff       	call   8017b9 <dev_lookup>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 1a                	js     80188b <fd_close+0x77>
		if (dev->dev_close)
  801871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801874:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801877:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80187c:	85 c0                	test   %eax,%eax
  80187e:	74 0b                	je     80188b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801880:	83 ec 0c             	sub    $0xc,%esp
  801883:	56                   	push   %esi
  801884:	ff d0                	call   *%eax
  801886:	89 c3                	mov    %eax,%ebx
  801888:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	56                   	push   %esi
  80188f:	6a 00                	push   $0x0
  801891:	e8 23 f7 ff ff       	call   800fb9 <sys_page_unmap>
	return r;
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	eb b5                	jmp    801850 <fd_close+0x3c>

0080189b <close>:

int
close(int fdnum)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a4:	50                   	push   %eax
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	e8 bc fe ff ff       	call   801769 <fd_lookup>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	79 02                	jns    8018b6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    
		return fd_close(fd, 1);
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	6a 01                	push   $0x1
  8018bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018be:	e8 51 ff ff ff       	call   801814 <fd_close>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	eb ec                	jmp    8018b4 <close+0x19>

008018c8 <close_all>:

void
close_all(void)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	53                   	push   %ebx
  8018d8:	e8 be ff ff ff       	call   80189b <close>
	for (i = 0; i < MAXFD; i++)
  8018dd:	83 c3 01             	add    $0x1,%ebx
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	83 fb 20             	cmp    $0x20,%ebx
  8018e6:	75 ec                	jne    8018d4 <close_all+0xc>
}
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	57                   	push   %edi
  8018f1:	56                   	push   %esi
  8018f2:	53                   	push   %ebx
  8018f3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018f9:	50                   	push   %eax
  8018fa:	ff 75 08             	pushl  0x8(%ebp)
  8018fd:	e8 67 fe ff ff       	call   801769 <fd_lookup>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	0f 88 81 00 00 00    	js     801990 <dup+0xa3>
		return r;
	close(newfdnum);
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	e8 81 ff ff ff       	call   80189b <close>

	newfd = INDEX2FD(newfdnum);
  80191a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80191d:	c1 e6 0c             	shl    $0xc,%esi
  801920:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801926:	83 c4 04             	add    $0x4,%esp
  801929:	ff 75 e4             	pushl  -0x1c(%ebp)
  80192c:	e8 cf fd ff ff       	call   801700 <fd2data>
  801931:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801933:	89 34 24             	mov    %esi,(%esp)
  801936:	e8 c5 fd ff ff       	call   801700 <fd2data>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801940:	89 d8                	mov    %ebx,%eax
  801942:	c1 e8 16             	shr    $0x16,%eax
  801945:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80194c:	a8 01                	test   $0x1,%al
  80194e:	74 11                	je     801961 <dup+0x74>
  801950:	89 d8                	mov    %ebx,%eax
  801952:	c1 e8 0c             	shr    $0xc,%eax
  801955:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80195c:	f6 c2 01             	test   $0x1,%dl
  80195f:	75 39                	jne    80199a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801961:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801964:	89 d0                	mov    %edx,%eax
  801966:	c1 e8 0c             	shr    $0xc,%eax
  801969:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	25 07 0e 00 00       	and    $0xe07,%eax
  801978:	50                   	push   %eax
  801979:	56                   	push   %esi
  80197a:	6a 00                	push   $0x0
  80197c:	52                   	push   %edx
  80197d:	6a 00                	push   $0x0
  80197f:	e8 f3 f5 ff ff       	call   800f77 <sys_page_map>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 20             	add    $0x20,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 31                	js     8019be <dup+0xd1>
		goto err;

	return newfdnum;
  80198d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801990:	89 d8                	mov    %ebx,%eax
  801992:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5f                   	pop    %edi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80199a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019a9:	50                   	push   %eax
  8019aa:	57                   	push   %edi
  8019ab:	6a 00                	push   $0x0
  8019ad:	53                   	push   %ebx
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 c2 f5 ff ff       	call   800f77 <sys_page_map>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	83 c4 20             	add    $0x20,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	79 a3                	jns    801961 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	56                   	push   %esi
  8019c2:	6a 00                	push   $0x0
  8019c4:	e8 f0 f5 ff ff       	call   800fb9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019c9:	83 c4 08             	add    $0x8,%esp
  8019cc:	57                   	push   %edi
  8019cd:	6a 00                	push   $0x0
  8019cf:	e8 e5 f5 ff ff       	call   800fb9 <sys_page_unmap>
	return r;
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	eb b7                	jmp    801990 <dup+0xa3>

008019d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 1c             	sub    $0x1c,%esp
  8019e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e6:	50                   	push   %eax
  8019e7:	53                   	push   %ebx
  8019e8:	e8 7c fd ff ff       	call   801769 <fd_lookup>
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 3f                	js     801a33 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fa:	50                   	push   %eax
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	ff 30                	pushl  (%eax)
  801a00:	e8 b4 fd ff ff       	call   8017b9 <dev_lookup>
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 27                	js     801a33 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0f:	8b 42 08             	mov    0x8(%edx),%eax
  801a12:	83 e0 03             	and    $0x3,%eax
  801a15:	83 f8 01             	cmp    $0x1,%eax
  801a18:	74 1e                	je     801a38 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	8b 40 08             	mov    0x8(%eax),%eax
  801a20:	85 c0                	test   %eax,%eax
  801a22:	74 35                	je     801a59 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	52                   	push   %edx
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
}
  801a33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a38:	a1 08 50 80 00       	mov    0x805008,%eax
  801a3d:	8b 40 48             	mov    0x48(%eax),%eax
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	53                   	push   %ebx
  801a44:	50                   	push   %eax
  801a45:	68 61 32 80 00       	push   $0x803261
  801a4a:	e8 94 e9 ff ff       	call   8003e3 <cprintf>
		return -E_INVAL;
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a57:	eb da                	jmp    801a33 <read+0x5a>
		return -E_NOT_SUPP;
  801a59:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a5e:	eb d3                	jmp    801a33 <read+0x5a>

00801a60 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	57                   	push   %edi
  801a64:	56                   	push   %esi
  801a65:	53                   	push   %ebx
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a6c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a74:	39 f3                	cmp    %esi,%ebx
  801a76:	73 23                	jae    801a9b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	89 f0                	mov    %esi,%eax
  801a7d:	29 d8                	sub    %ebx,%eax
  801a7f:	50                   	push   %eax
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	03 45 0c             	add    0xc(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	57                   	push   %edi
  801a87:	e8 4d ff ff ff       	call   8019d9 <read>
		if (m < 0)
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 06                	js     801a99 <readn+0x39>
			return m;
		if (m == 0)
  801a93:	74 06                	je     801a9b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a95:	01 c3                	add    %eax,%ebx
  801a97:	eb db                	jmp    801a74 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a99:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a9b:	89 d8                	mov    %ebx,%eax
  801a9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5e                   	pop    %esi
  801aa2:	5f                   	pop    %edi
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    

00801aa5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 1c             	sub    $0x1c,%esp
  801aac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aaf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab2:	50                   	push   %eax
  801ab3:	53                   	push   %ebx
  801ab4:	e8 b0 fc ff ff       	call   801769 <fd_lookup>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 3a                	js     801afa <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac6:	50                   	push   %eax
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aca:	ff 30                	pushl  (%eax)
  801acc:	e8 e8 fc ff ff       	call   8017b9 <dev_lookup>
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 22                	js     801afa <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801adf:	74 1e                	je     801aff <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae4:	8b 52 0c             	mov    0xc(%edx),%edx
  801ae7:	85 d2                	test   %edx,%edx
  801ae9:	74 35                	je     801b20 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	50                   	push   %eax
  801af5:	ff d2                	call   *%edx
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aff:	a1 08 50 80 00       	mov    0x805008,%eax
  801b04:	8b 40 48             	mov    0x48(%eax),%eax
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	53                   	push   %ebx
  801b0b:	50                   	push   %eax
  801b0c:	68 7d 32 80 00       	push   $0x80327d
  801b11:	e8 cd e8 ff ff       	call   8003e3 <cprintf>
		return -E_INVAL;
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b1e:	eb da                	jmp    801afa <write+0x55>
		return -E_NOT_SUPP;
  801b20:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b25:	eb d3                	jmp    801afa <write+0x55>

00801b27 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b30:	50                   	push   %eax
  801b31:	ff 75 08             	pushl  0x8(%ebp)
  801b34:	e8 30 fc ff ff       	call   801769 <fd_lookup>
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 0e                	js     801b4e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	53                   	push   %ebx
  801b5f:	e8 05 fc ff ff       	call   801769 <fd_lookup>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 37                	js     801ba2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b71:	50                   	push   %eax
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	ff 30                	pushl  (%eax)
  801b77:	e8 3d fc ff ff       	call   8017b9 <dev_lookup>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 1f                	js     801ba2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b86:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b8a:	74 1b                	je     801ba7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8f:	8b 52 18             	mov    0x18(%edx),%edx
  801b92:	85 d2                	test   %edx,%edx
  801b94:	74 32                	je     801bc8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b96:	83 ec 08             	sub    $0x8,%esp
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	ff d2                	call   *%edx
  801b9f:	83 c4 10             	add    $0x10,%esp
}
  801ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ba7:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bac:	8b 40 48             	mov    0x48(%eax),%eax
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	53                   	push   %ebx
  801bb3:	50                   	push   %eax
  801bb4:	68 40 32 80 00       	push   $0x803240
  801bb9:	e8 25 e8 ff ff       	call   8003e3 <cprintf>
		return -E_INVAL;
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc6:	eb da                	jmp    801ba2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bc8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bcd:	eb d3                	jmp    801ba2 <ftruncate+0x52>

00801bcf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 1c             	sub    $0x1c,%esp
  801bd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bdc:	50                   	push   %eax
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	e8 84 fb ff ff       	call   801769 <fd_lookup>
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	78 4b                	js     801c37 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf2:	50                   	push   %eax
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	ff 30                	pushl  (%eax)
  801bf8:	e8 bc fb ff ff       	call   8017b9 <dev_lookup>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 33                	js     801c37 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c0b:	74 2f                	je     801c3c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c0d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c10:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c17:	00 00 00 
	stat->st_isdir = 0;
  801c1a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c21:	00 00 00 
	stat->st_dev = dev;
  801c24:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c2a:	83 ec 08             	sub    $0x8,%esp
  801c2d:	53                   	push   %ebx
  801c2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c31:	ff 50 14             	call   *0x14(%eax)
  801c34:	83 c4 10             	add    $0x10,%esp
}
  801c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    
		return -E_NOT_SUPP;
  801c3c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c41:	eb f4                	jmp    801c37 <fstat+0x68>

00801c43 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	6a 00                	push   $0x0
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	e8 22 02 00 00       	call   801e77 <open>
  801c55:	89 c3                	mov    %eax,%ebx
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 1b                	js     801c79 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c5e:	83 ec 08             	sub    $0x8,%esp
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	50                   	push   %eax
  801c65:	e8 65 ff ff ff       	call   801bcf <fstat>
  801c6a:	89 c6                	mov    %eax,%esi
	close(fd);
  801c6c:	89 1c 24             	mov    %ebx,(%esp)
  801c6f:	e8 27 fc ff ff       	call   80189b <close>
	return r;
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	89 f3                	mov    %esi,%ebx
}
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	56                   	push   %esi
  801c86:	53                   	push   %ebx
  801c87:	89 c6                	mov    %eax,%esi
  801c89:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c8b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c92:	74 27                	je     801cbb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c94:	6a 07                	push   $0x7
  801c96:	68 00 60 80 00       	push   $0x806000
  801c9b:	56                   	push   %esi
  801c9c:	ff 35 00 50 80 00    	pushl  0x805000
  801ca2:	e8 9d 0c 00 00       	call   802944 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ca7:	83 c4 0c             	add    $0xc,%esp
  801caa:	6a 00                	push   $0x0
  801cac:	53                   	push   %ebx
  801cad:	6a 00                	push   $0x0
  801caf:	e8 27 0c 00 00       	call   8028db <ipc_recv>
}
  801cb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5d                   	pop    %ebp
  801cba:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	6a 01                	push   $0x1
  801cc0:	e8 d7 0c 00 00       	call   80299c <ipc_find_env>
  801cc5:	a3 00 50 80 00       	mov    %eax,0x805000
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	eb c5                	jmp    801c94 <fsipc+0x12>

00801ccf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ced:	b8 02 00 00 00       	mov    $0x2,%eax
  801cf2:	e8 8b ff ff ff       	call   801c82 <fsipc>
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <devfile_flush>:
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	8b 40 0c             	mov    0xc(%eax),%eax
  801d05:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d14:	e8 69 ff ff ff       	call   801c82 <fsipc>
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <devfile_stat>:
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	53                   	push   %ebx
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d30:	ba 00 00 00 00       	mov    $0x0,%edx
  801d35:	b8 05 00 00 00       	mov    $0x5,%eax
  801d3a:	e8 43 ff ff ff       	call   801c82 <fsipc>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 2c                	js     801d6f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d43:	83 ec 08             	sub    $0x8,%esp
  801d46:	68 00 60 80 00       	push   $0x806000
  801d4b:	53                   	push   %ebx
  801d4c:	e8 f1 ed ff ff       	call   800b42 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d51:	a1 80 60 80 00       	mov    0x806080,%eax
  801d56:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d5c:	a1 84 60 80 00       	mov    0x806084,%eax
  801d61:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <devfile_write>:
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	53                   	push   %ebx
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8b 40 0c             	mov    0xc(%eax),%eax
  801d84:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d89:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d8f:	53                   	push   %ebx
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	68 08 60 80 00       	push   $0x806008
  801d98:	e8 95 ef ff ff       	call   800d32 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801da2:	b8 04 00 00 00       	mov    $0x4,%eax
  801da7:	e8 d6 fe ff ff       	call   801c82 <fsipc>
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 0b                	js     801dbe <devfile_write+0x4a>
	assert(r <= n);
  801db3:	39 d8                	cmp    %ebx,%eax
  801db5:	77 0c                	ja     801dc3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801db7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dbc:	7f 1e                	jg     801ddc <devfile_write+0x68>
}
  801dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    
	assert(r <= n);
  801dc3:	68 b0 32 80 00       	push   $0x8032b0
  801dc8:	68 b7 32 80 00       	push   $0x8032b7
  801dcd:	68 98 00 00 00       	push   $0x98
  801dd2:	68 cc 32 80 00       	push   $0x8032cc
  801dd7:	e8 11 e5 ff ff       	call   8002ed <_panic>
	assert(r <= PGSIZE);
  801ddc:	68 d7 32 80 00       	push   $0x8032d7
  801de1:	68 b7 32 80 00       	push   $0x8032b7
  801de6:	68 99 00 00 00       	push   $0x99
  801deb:	68 cc 32 80 00       	push   $0x8032cc
  801df0:	e8 f8 e4 ff ff       	call   8002ed <_panic>

00801df5 <devfile_read>:
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	56                   	push   %esi
  801df9:	53                   	push   %ebx
  801dfa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	8b 40 0c             	mov    0xc(%eax),%eax
  801e03:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e08:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	b8 03 00 00 00       	mov    $0x3,%eax
  801e18:	e8 65 fe ff ff       	call   801c82 <fsipc>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 1f                	js     801e42 <devfile_read+0x4d>
	assert(r <= n);
  801e23:	39 f0                	cmp    %esi,%eax
  801e25:	77 24                	ja     801e4b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e27:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e2c:	7f 33                	jg     801e61 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	50                   	push   %eax
  801e32:	68 00 60 80 00       	push   $0x806000
  801e37:	ff 75 0c             	pushl  0xc(%ebp)
  801e3a:	e8 91 ee ff ff       	call   800cd0 <memmove>
	return r;
  801e3f:	83 c4 10             	add    $0x10,%esp
}
  801e42:	89 d8                	mov    %ebx,%eax
  801e44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    
	assert(r <= n);
  801e4b:	68 b0 32 80 00       	push   $0x8032b0
  801e50:	68 b7 32 80 00       	push   $0x8032b7
  801e55:	6a 7c                	push   $0x7c
  801e57:	68 cc 32 80 00       	push   $0x8032cc
  801e5c:	e8 8c e4 ff ff       	call   8002ed <_panic>
	assert(r <= PGSIZE);
  801e61:	68 d7 32 80 00       	push   $0x8032d7
  801e66:	68 b7 32 80 00       	push   $0x8032b7
  801e6b:	6a 7d                	push   $0x7d
  801e6d:	68 cc 32 80 00       	push   $0x8032cc
  801e72:	e8 76 e4 ff ff       	call   8002ed <_panic>

00801e77 <open>:
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	56                   	push   %esi
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 1c             	sub    $0x1c,%esp
  801e7f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e82:	56                   	push   %esi
  801e83:	e8 81 ec ff ff       	call   800b09 <strlen>
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e90:	7f 6c                	jg     801efe <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e98:	50                   	push   %eax
  801e99:	e8 79 f8 ff ff       	call   801717 <fd_alloc>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 3c                	js     801ee3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ea7:	83 ec 08             	sub    $0x8,%esp
  801eaa:	56                   	push   %esi
  801eab:	68 00 60 80 00       	push   $0x806000
  801eb0:	e8 8d ec ff ff       	call   800b42 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb8:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec5:	e8 b8 fd ff ff       	call   801c82 <fsipc>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 19                	js     801eec <open+0x75>
	return fd2num(fd);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed9:	e8 12 f8 ff ff       	call   8016f0 <fd2num>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
}
  801ee3:	89 d8                	mov    %ebx,%eax
  801ee5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5e                   	pop    %esi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
		fd_close(fd, 0);
  801eec:	83 ec 08             	sub    $0x8,%esp
  801eef:	6a 00                	push   $0x0
  801ef1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef4:	e8 1b f9 ff ff       	call   801814 <fd_close>
		return r;
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	eb e5                	jmp    801ee3 <open+0x6c>
		return -E_BAD_PATH;
  801efe:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f03:	eb de                	jmp    801ee3 <open+0x6c>

00801f05 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f10:	b8 08 00 00 00       	mov    $0x8,%eax
  801f15:	e8 68 fd ff ff       	call   801c82 <fsipc>
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f22:	68 e3 32 80 00       	push   $0x8032e3
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	e8 13 ec ff ff       	call   800b42 <strcpy>
	return 0;
}
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <devsock_close>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	53                   	push   %ebx
  801f3a:	83 ec 10             	sub    $0x10,%esp
  801f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f40:	53                   	push   %ebx
  801f41:	e8 91 0a 00 00       	call   8029d7 <pageref>
  801f46:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f49:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f4e:	83 f8 01             	cmp    $0x1,%eax
  801f51:	74 07                	je     801f5a <devsock_close+0x24>
}
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 73 0c             	pushl  0xc(%ebx)
  801f60:	e8 b9 02 00 00       	call   80221e <nsipc_close>
  801f65:	89 c2                	mov    %eax,%edx
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	eb e7                	jmp    801f53 <devsock_close+0x1d>

00801f6c <devsock_write>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	ff 75 10             	pushl  0x10(%ebp)
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	ff 70 0c             	pushl  0xc(%eax)
  801f80:	e8 76 03 00 00       	call   8022fb <nsipc_send>
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <devsock_read>:
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	ff 70 0c             	pushl  0xc(%eax)
  801f9b:	e8 ef 02 00 00       	call   80228f <nsipc_recv>
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <fd2sockid>:
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fa8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fab:	52                   	push   %edx
  801fac:	50                   	push   %eax
  801fad:	e8 b7 f7 ff ff       	call   801769 <fd_lookup>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 10                	js     801fc9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fc2:	39 08                	cmp    %ecx,(%eax)
  801fc4:	75 05                	jne    801fcb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fc6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    
		return -E_NOT_SUPP;
  801fcb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fd0:	eb f7                	jmp    801fc9 <fd2sockid+0x27>

00801fd2 <alloc_sockfd>:
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 1c             	sub    $0x1c,%esp
  801fda:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	e8 32 f7 ff ff       	call   801717 <fd_alloc>
  801fe5:	89 c3                	mov    %eax,%ebx
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 43                	js     802031 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	68 07 04 00 00       	push   $0x407
  801ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 34 ef ff ff       	call   800f34 <sys_page_alloc>
  802000:	89 c3                	mov    %eax,%ebx
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 28                	js     802031 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802012:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80201e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	50                   	push   %eax
  802025:	e8 c6 f6 ff ff       	call   8016f0 <fd2num>
  80202a:	89 c3                	mov    %eax,%ebx
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	eb 0c                	jmp    80203d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	56                   	push   %esi
  802035:	e8 e4 01 00 00       	call   80221e <nsipc_close>
		return r;
  80203a:	83 c4 10             	add    $0x10,%esp
}
  80203d:	89 d8                	mov    %ebx,%eax
  80203f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    

00802046 <accept>:
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	e8 4e ff ff ff       	call   801fa2 <fd2sockid>
  802054:	85 c0                	test   %eax,%eax
  802056:	78 1b                	js     802073 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	ff 75 10             	pushl  0x10(%ebp)
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	50                   	push   %eax
  802062:	e8 0e 01 00 00       	call   802175 <nsipc_accept>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 05                	js     802073 <accept+0x2d>
	return alloc_sockfd(r);
  80206e:	e8 5f ff ff ff       	call   801fd2 <alloc_sockfd>
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <bind>:
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	e8 1f ff ff ff       	call   801fa2 <fd2sockid>
  802083:	85 c0                	test   %eax,%eax
  802085:	78 12                	js     802099 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	ff 75 10             	pushl  0x10(%ebp)
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	50                   	push   %eax
  802091:	e8 31 01 00 00       	call   8021c7 <nsipc_bind>
  802096:	83 c4 10             	add    $0x10,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <shutdown>:
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	e8 f9 fe ff ff       	call   801fa2 <fd2sockid>
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	78 0f                	js     8020bc <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020ad:	83 ec 08             	sub    $0x8,%esp
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	50                   	push   %eax
  8020b4:	e8 43 01 00 00       	call   8021fc <nsipc_shutdown>
  8020b9:	83 c4 10             	add    $0x10,%esp
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <connect>:
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	e8 d6 fe ff ff       	call   801fa2 <fd2sockid>
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	78 12                	js     8020e2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	ff 75 10             	pushl  0x10(%ebp)
  8020d6:	ff 75 0c             	pushl  0xc(%ebp)
  8020d9:	50                   	push   %eax
  8020da:	e8 59 01 00 00       	call   802238 <nsipc_connect>
  8020df:	83 c4 10             	add    $0x10,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <listen>:
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	e8 b0 fe ff ff       	call   801fa2 <fd2sockid>
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 0f                	js     802105 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020f6:	83 ec 08             	sub    $0x8,%esp
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	50                   	push   %eax
  8020fd:	e8 6b 01 00 00       	call   80226d <nsipc_listen>
  802102:	83 c4 10             	add    $0x10,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <socket>:

int
socket(int domain, int type, int protocol)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80210d:	ff 75 10             	pushl  0x10(%ebp)
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	e8 3e 02 00 00       	call   802359 <nsipc_socket>
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 05                	js     802127 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802122:	e8 ab fe ff ff       	call   801fd2 <alloc_sockfd>
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	53                   	push   %ebx
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802132:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802139:	74 26                	je     802161 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80213b:	6a 07                	push   $0x7
  80213d:	68 00 70 80 00       	push   $0x807000
  802142:	53                   	push   %ebx
  802143:	ff 35 04 50 80 00    	pushl  0x805004
  802149:	e8 f6 07 00 00       	call   802944 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80214e:	83 c4 0c             	add    $0xc,%esp
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	e8 7f 07 00 00       	call   8028db <ipc_recv>
}
  80215c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215f:	c9                   	leave  
  802160:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	6a 02                	push   $0x2
  802166:	e8 31 08 00 00       	call   80299c <ipc_find_env>
  80216b:	a3 04 50 80 00       	mov    %eax,0x805004
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	eb c6                	jmp    80213b <nsipc+0x12>

00802175 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	56                   	push   %esi
  802179:	53                   	push   %ebx
  80217a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802185:	8b 06                	mov    (%esi),%eax
  802187:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80218c:	b8 01 00 00 00       	mov    $0x1,%eax
  802191:	e8 93 ff ff ff       	call   802129 <nsipc>
  802196:	89 c3                	mov    %eax,%ebx
  802198:	85 c0                	test   %eax,%eax
  80219a:	79 09                	jns    8021a5 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80219c:	89 d8                	mov    %ebx,%eax
  80219e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	ff 35 10 70 80 00    	pushl  0x807010
  8021ae:	68 00 70 80 00       	push   $0x807000
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	e8 15 eb ff ff       	call   800cd0 <memmove>
		*addrlen = ret->ret_addrlen;
  8021bb:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c0:	89 06                	mov    %eax,(%esi)
  8021c2:	83 c4 10             	add    $0x10,%esp
	return r;
  8021c5:	eb d5                	jmp    80219c <nsipc_accept+0x27>

008021c7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	53                   	push   %ebx
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021d9:	53                   	push   %ebx
  8021da:	ff 75 0c             	pushl  0xc(%ebp)
  8021dd:	68 04 70 80 00       	push   $0x807004
  8021e2:	e8 e9 ea ff ff       	call   800cd0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021e7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8021f2:	e8 32 ff ff ff       	call   802129 <nsipc>
}
  8021f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80220a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802212:	b8 03 00 00 00       	mov    $0x3,%eax
  802217:	e8 0d ff ff ff       	call   802129 <nsipc>
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <nsipc_close>:

int
nsipc_close(int s)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80222c:	b8 04 00 00 00       	mov    $0x4,%eax
  802231:	e8 f3 fe ff ff       	call   802129 <nsipc>
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
  80223c:	83 ec 08             	sub    $0x8,%esp
  80223f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80224a:	53                   	push   %ebx
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	68 04 70 80 00       	push   $0x807004
  802253:	e8 78 ea ff ff       	call   800cd0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802258:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80225e:	b8 05 00 00 00       	mov    $0x5,%eax
  802263:	e8 c1 fe ff ff       	call   802129 <nsipc>
}
  802268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802283:	b8 06 00 00 00       	mov    $0x6,%eax
  802288:	e8 9c fe ff ff       	call   802129 <nsipc>
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80229f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a8:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ad:	b8 07 00 00 00       	mov    $0x7,%eax
  8022b2:	e8 72 fe ff ff       	call   802129 <nsipc>
  8022b7:	89 c3                	mov    %eax,%ebx
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	78 1f                	js     8022dc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022bd:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022c2:	7f 21                	jg     8022e5 <nsipc_recv+0x56>
  8022c4:	39 c6                	cmp    %eax,%esi
  8022c6:	7c 1d                	jl     8022e5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	50                   	push   %eax
  8022cc:	68 00 70 80 00       	push   $0x807000
  8022d1:	ff 75 0c             	pushl  0xc(%ebp)
  8022d4:	e8 f7 e9 ff ff       	call   800cd0 <memmove>
  8022d9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022dc:	89 d8                	mov    %ebx,%eax
  8022de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022e5:	68 ef 32 80 00       	push   $0x8032ef
  8022ea:	68 b7 32 80 00       	push   $0x8032b7
  8022ef:	6a 62                	push   $0x62
  8022f1:	68 04 33 80 00       	push   $0x803304
  8022f6:	e8 f2 df ff ff       	call   8002ed <_panic>

008022fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80230d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802313:	7f 2e                	jg     802343 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	53                   	push   %ebx
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	68 0c 70 80 00       	push   $0x80700c
  802321:	e8 aa e9 ff ff       	call   800cd0 <memmove>
	nsipcbuf.send.req_size = size;
  802326:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80232c:	8b 45 14             	mov    0x14(%ebp),%eax
  80232f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802334:	b8 08 00 00 00       	mov    $0x8,%eax
  802339:	e8 eb fd ff ff       	call   802129 <nsipc>
}
  80233e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802341:	c9                   	leave  
  802342:	c3                   	ret    
	assert(size < 1600);
  802343:	68 10 33 80 00       	push   $0x803310
  802348:	68 b7 32 80 00       	push   $0x8032b7
  80234d:	6a 6d                	push   $0x6d
  80234f:	68 04 33 80 00       	push   $0x803304
  802354:	e8 94 df ff ff       	call   8002ed <_panic>

00802359 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80236f:	8b 45 10             	mov    0x10(%ebp),%eax
  802372:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802377:	b8 09 00 00 00       	mov    $0x9,%eax
  80237c:	e8 a8 fd ff ff       	call   802129 <nsipc>
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	ff 75 08             	pushl  0x8(%ebp)
  802391:	e8 6a f3 ff ff       	call   801700 <fd2data>
  802396:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802398:	83 c4 08             	add    $0x8,%esp
  80239b:	68 1c 33 80 00       	push   $0x80331c
  8023a0:	53                   	push   %ebx
  8023a1:	e8 9c e7 ff ff       	call   800b42 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023a6:	8b 46 04             	mov    0x4(%esi),%eax
  8023a9:	2b 06                	sub    (%esi),%eax
  8023ab:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023b1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023b8:	00 00 00 
	stat->st_dev = &devpipe;
  8023bb:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023c2:	40 80 00 
	return 0;
}
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023cd:	5b                   	pop    %ebx
  8023ce:	5e                   	pop    %esi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    

008023d1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	53                   	push   %ebx
  8023d5:	83 ec 0c             	sub    $0xc,%esp
  8023d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023db:	53                   	push   %ebx
  8023dc:	6a 00                	push   $0x0
  8023de:	e8 d6 eb ff ff       	call   800fb9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023e3:	89 1c 24             	mov    %ebx,(%esp)
  8023e6:	e8 15 f3 ff ff       	call   801700 <fd2data>
  8023eb:	83 c4 08             	add    $0x8,%esp
  8023ee:	50                   	push   %eax
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 c3 eb ff ff       	call   800fb9 <sys_page_unmap>
}
  8023f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <_pipeisclosed>:
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	57                   	push   %edi
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
  802401:	83 ec 1c             	sub    $0x1c,%esp
  802404:	89 c7                	mov    %eax,%edi
  802406:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802408:	a1 08 50 80 00       	mov    0x805008,%eax
  80240d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	57                   	push   %edi
  802414:	e8 be 05 00 00       	call   8029d7 <pageref>
  802419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80241c:	89 34 24             	mov    %esi,(%esp)
  80241f:	e8 b3 05 00 00       	call   8029d7 <pageref>
		nn = thisenv->env_runs;
  802424:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80242a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80242d:	83 c4 10             	add    $0x10,%esp
  802430:	39 cb                	cmp    %ecx,%ebx
  802432:	74 1b                	je     80244f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802434:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802437:	75 cf                	jne    802408 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802439:	8b 42 58             	mov    0x58(%edx),%eax
  80243c:	6a 01                	push   $0x1
  80243e:	50                   	push   %eax
  80243f:	53                   	push   %ebx
  802440:	68 23 33 80 00       	push   $0x803323
  802445:	e8 99 df ff ff       	call   8003e3 <cprintf>
  80244a:	83 c4 10             	add    $0x10,%esp
  80244d:	eb b9                	jmp    802408 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80244f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802452:	0f 94 c0             	sete   %al
  802455:	0f b6 c0             	movzbl %al,%eax
}
  802458:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245b:	5b                   	pop    %ebx
  80245c:	5e                   	pop    %esi
  80245d:	5f                   	pop    %edi
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <devpipe_write>:
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	57                   	push   %edi
  802464:	56                   	push   %esi
  802465:	53                   	push   %ebx
  802466:	83 ec 28             	sub    $0x28,%esp
  802469:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80246c:	56                   	push   %esi
  80246d:	e8 8e f2 ff ff       	call   801700 <fd2data>
  802472:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802474:	83 c4 10             	add    $0x10,%esp
  802477:	bf 00 00 00 00       	mov    $0x0,%edi
  80247c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80247f:	74 4f                	je     8024d0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802481:	8b 43 04             	mov    0x4(%ebx),%eax
  802484:	8b 0b                	mov    (%ebx),%ecx
  802486:	8d 51 20             	lea    0x20(%ecx),%edx
  802489:	39 d0                	cmp    %edx,%eax
  80248b:	72 14                	jb     8024a1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80248d:	89 da                	mov    %ebx,%edx
  80248f:	89 f0                	mov    %esi,%eax
  802491:	e8 65 ff ff ff       	call   8023fb <_pipeisclosed>
  802496:	85 c0                	test   %eax,%eax
  802498:	75 3b                	jne    8024d5 <devpipe_write+0x75>
			sys_yield();
  80249a:	e8 76 ea ff ff       	call   800f15 <sys_yield>
  80249f:	eb e0                	jmp    802481 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024a4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024a8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024ab:	89 c2                	mov    %eax,%edx
  8024ad:	c1 fa 1f             	sar    $0x1f,%edx
  8024b0:	89 d1                	mov    %edx,%ecx
  8024b2:	c1 e9 1b             	shr    $0x1b,%ecx
  8024b5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024b8:	83 e2 1f             	and    $0x1f,%edx
  8024bb:	29 ca                	sub    %ecx,%edx
  8024bd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024c1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024c5:	83 c0 01             	add    $0x1,%eax
  8024c8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024cb:	83 c7 01             	add    $0x1,%edi
  8024ce:	eb ac                	jmp    80247c <devpipe_write+0x1c>
	return i;
  8024d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d3:	eb 05                	jmp    8024da <devpipe_write+0x7a>
				return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    

008024e2 <devpipe_read>:
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 18             	sub    $0x18,%esp
  8024eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024ee:	57                   	push   %edi
  8024ef:	e8 0c f2 ff ff       	call   801700 <fd2data>
  8024f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024f6:	83 c4 10             	add    $0x10,%esp
  8024f9:	be 00 00 00 00       	mov    $0x0,%esi
  8024fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802501:	75 14                	jne    802517 <devpipe_read+0x35>
	return i;
  802503:	8b 45 10             	mov    0x10(%ebp),%eax
  802506:	eb 02                	jmp    80250a <devpipe_read+0x28>
				return i;
  802508:	89 f0                	mov    %esi,%eax
}
  80250a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5f                   	pop    %edi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
			sys_yield();
  802512:	e8 fe e9 ff ff       	call   800f15 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802517:	8b 03                	mov    (%ebx),%eax
  802519:	3b 43 04             	cmp    0x4(%ebx),%eax
  80251c:	75 18                	jne    802536 <devpipe_read+0x54>
			if (i > 0)
  80251e:	85 f6                	test   %esi,%esi
  802520:	75 e6                	jne    802508 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802522:	89 da                	mov    %ebx,%edx
  802524:	89 f8                	mov    %edi,%eax
  802526:	e8 d0 fe ff ff       	call   8023fb <_pipeisclosed>
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 e3                	je     802512 <devpipe_read+0x30>
				return 0;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	eb d4                	jmp    80250a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802536:	99                   	cltd   
  802537:	c1 ea 1b             	shr    $0x1b,%edx
  80253a:	01 d0                	add    %edx,%eax
  80253c:	83 e0 1f             	and    $0x1f,%eax
  80253f:	29 d0                	sub    %edx,%eax
  802541:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802549:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80254c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80254f:	83 c6 01             	add    $0x1,%esi
  802552:	eb aa                	jmp    8024fe <devpipe_read+0x1c>

00802554 <pipe>:
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	56                   	push   %esi
  802558:	53                   	push   %ebx
  802559:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80255c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255f:	50                   	push   %eax
  802560:	e8 b2 f1 ff ff       	call   801717 <fd_alloc>
  802565:	89 c3                	mov    %eax,%ebx
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	85 c0                	test   %eax,%eax
  80256c:	0f 88 23 01 00 00    	js     802695 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	68 07 04 00 00       	push   $0x407
  80257a:	ff 75 f4             	pushl  -0xc(%ebp)
  80257d:	6a 00                	push   $0x0
  80257f:	e8 b0 e9 ff ff       	call   800f34 <sys_page_alloc>
  802584:	89 c3                	mov    %eax,%ebx
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	85 c0                	test   %eax,%eax
  80258b:	0f 88 04 01 00 00    	js     802695 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802591:	83 ec 0c             	sub    $0xc,%esp
  802594:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802597:	50                   	push   %eax
  802598:	e8 7a f1 ff ff       	call   801717 <fd_alloc>
  80259d:	89 c3                	mov    %eax,%ebx
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	0f 88 db 00 00 00    	js     802685 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	68 07 04 00 00       	push   $0x407
  8025b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b5:	6a 00                	push   $0x0
  8025b7:	e8 78 e9 ff ff       	call   800f34 <sys_page_alloc>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 88 bc 00 00 00    	js     802685 <pipe+0x131>
	va = fd2data(fd0);
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8025cf:	e8 2c f1 ff ff       	call   801700 <fd2data>
  8025d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d6:	83 c4 0c             	add    $0xc,%esp
  8025d9:	68 07 04 00 00       	push   $0x407
  8025de:	50                   	push   %eax
  8025df:	6a 00                	push   $0x0
  8025e1:	e8 4e e9 ff ff       	call   800f34 <sys_page_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	0f 88 82 00 00 00    	js     802675 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f3:	83 ec 0c             	sub    $0xc,%esp
  8025f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f9:	e8 02 f1 ff ff       	call   801700 <fd2data>
  8025fe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802605:	50                   	push   %eax
  802606:	6a 00                	push   $0x0
  802608:	56                   	push   %esi
  802609:	6a 00                	push   $0x0
  80260b:	e8 67 e9 ff ff       	call   800f77 <sys_page_map>
  802610:	89 c3                	mov    %eax,%ebx
  802612:	83 c4 20             	add    $0x20,%esp
  802615:	85 c0                	test   %eax,%eax
  802617:	78 4e                	js     802667 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802619:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80261e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802621:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802626:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80262d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802630:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802635:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80263c:	83 ec 0c             	sub    $0xc,%esp
  80263f:	ff 75 f4             	pushl  -0xc(%ebp)
  802642:	e8 a9 f0 ff ff       	call   8016f0 <fd2num>
  802647:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80264c:	83 c4 04             	add    $0x4,%esp
  80264f:	ff 75 f0             	pushl  -0x10(%ebp)
  802652:	e8 99 f0 ff ff       	call   8016f0 <fd2num>
  802657:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80265a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80265d:	83 c4 10             	add    $0x10,%esp
  802660:	bb 00 00 00 00       	mov    $0x0,%ebx
  802665:	eb 2e                	jmp    802695 <pipe+0x141>
	sys_page_unmap(0, va);
  802667:	83 ec 08             	sub    $0x8,%esp
  80266a:	56                   	push   %esi
  80266b:	6a 00                	push   $0x0
  80266d:	e8 47 e9 ff ff       	call   800fb9 <sys_page_unmap>
  802672:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	ff 75 f0             	pushl  -0x10(%ebp)
  80267b:	6a 00                	push   $0x0
  80267d:	e8 37 e9 ff ff       	call   800fb9 <sys_page_unmap>
  802682:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802685:	83 ec 08             	sub    $0x8,%esp
  802688:	ff 75 f4             	pushl  -0xc(%ebp)
  80268b:	6a 00                	push   $0x0
  80268d:	e8 27 e9 ff ff       	call   800fb9 <sys_page_unmap>
  802692:	83 c4 10             	add    $0x10,%esp
}
  802695:	89 d8                	mov    %ebx,%eax
  802697:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80269a:	5b                   	pop    %ebx
  80269b:	5e                   	pop    %esi
  80269c:	5d                   	pop    %ebp
  80269d:	c3                   	ret    

0080269e <pipeisclosed>:
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a7:	50                   	push   %eax
  8026a8:	ff 75 08             	pushl  0x8(%ebp)
  8026ab:	e8 b9 f0 ff ff       	call   801769 <fd_lookup>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	78 18                	js     8026cf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026b7:	83 ec 0c             	sub    $0xc,%esp
  8026ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bd:	e8 3e f0 ff ff       	call   801700 <fd2data>
	return _pipeisclosed(fd, p);
  8026c2:	89 c2                	mov    %eax,%edx
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	e8 2f fd ff ff       	call   8023fb <_pipeisclosed>
  8026cc:	83 c4 10             	add    $0x10,%esp
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	c3                   	ret    

008026d7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026dd:	68 36 33 80 00       	push   $0x803336
  8026e2:	ff 75 0c             	pushl  0xc(%ebp)
  8026e5:	e8 58 e4 ff ff       	call   800b42 <strcpy>
	return 0;
}
  8026ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <devcons_write>:
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	57                   	push   %edi
  8026f5:	56                   	push   %esi
  8026f6:	53                   	push   %ebx
  8026f7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026fd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802702:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802708:	3b 75 10             	cmp    0x10(%ebp),%esi
  80270b:	73 31                	jae    80273e <devcons_write+0x4d>
		m = n - tot;
  80270d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802710:	29 f3                	sub    %esi,%ebx
  802712:	83 fb 7f             	cmp    $0x7f,%ebx
  802715:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80271a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	53                   	push   %ebx
  802721:	89 f0                	mov    %esi,%eax
  802723:	03 45 0c             	add    0xc(%ebp),%eax
  802726:	50                   	push   %eax
  802727:	57                   	push   %edi
  802728:	e8 a3 e5 ff ff       	call   800cd0 <memmove>
		sys_cputs(buf, m);
  80272d:	83 c4 08             	add    $0x8,%esp
  802730:	53                   	push   %ebx
  802731:	57                   	push   %edi
  802732:	e8 41 e7 ff ff       	call   800e78 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802737:	01 de                	add    %ebx,%esi
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	eb ca                	jmp    802708 <devcons_write+0x17>
}
  80273e:	89 f0                	mov    %esi,%eax
  802740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802743:	5b                   	pop    %ebx
  802744:	5e                   	pop    %esi
  802745:	5f                   	pop    %edi
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <devcons_read>:
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 08             	sub    $0x8,%esp
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802753:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802757:	74 21                	je     80277a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802759:	e8 38 e7 ff ff       	call   800e96 <sys_cgetc>
  80275e:	85 c0                	test   %eax,%eax
  802760:	75 07                	jne    802769 <devcons_read+0x21>
		sys_yield();
  802762:	e8 ae e7 ff ff       	call   800f15 <sys_yield>
  802767:	eb f0                	jmp    802759 <devcons_read+0x11>
	if (c < 0)
  802769:	78 0f                	js     80277a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80276b:	83 f8 04             	cmp    $0x4,%eax
  80276e:	74 0c                	je     80277c <devcons_read+0x34>
	*(char*)vbuf = c;
  802770:	8b 55 0c             	mov    0xc(%ebp),%edx
  802773:	88 02                	mov    %al,(%edx)
	return 1;
  802775:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    
		return 0;
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	eb f7                	jmp    80277a <devcons_read+0x32>

00802783 <cputchar>:
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80278f:	6a 01                	push   $0x1
  802791:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802794:	50                   	push   %eax
  802795:	e8 de e6 ff ff       	call   800e78 <sys_cputs>
}
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <getchar>:
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
  8027a2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027a5:	6a 01                	push   $0x1
  8027a7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027aa:	50                   	push   %eax
  8027ab:	6a 00                	push   $0x0
  8027ad:	e8 27 f2 ff ff       	call   8019d9 <read>
	if (r < 0)
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	78 06                	js     8027bf <getchar+0x20>
	if (r < 1)
  8027b9:	74 06                	je     8027c1 <getchar+0x22>
	return c;
  8027bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    
		return -E_EOF;
  8027c1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027c6:	eb f7                	jmp    8027bf <getchar+0x20>

008027c8 <iscons>:
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
  8027cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d1:	50                   	push   %eax
  8027d2:	ff 75 08             	pushl  0x8(%ebp)
  8027d5:	e8 8f ef ff ff       	call   801769 <fd_lookup>
  8027da:	83 c4 10             	add    $0x10,%esp
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	78 11                	js     8027f2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ea:	39 10                	cmp    %edx,(%eax)
  8027ec:	0f 94 c0             	sete   %al
  8027ef:	0f b6 c0             	movzbl %al,%eax
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <opencons>:
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027fd:	50                   	push   %eax
  8027fe:	e8 14 ef ff ff       	call   801717 <fd_alloc>
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	85 c0                	test   %eax,%eax
  802808:	78 3a                	js     802844 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	68 07 04 00 00       	push   $0x407
  802812:	ff 75 f4             	pushl  -0xc(%ebp)
  802815:	6a 00                	push   $0x0
  802817:	e8 18 e7 ff ff       	call   800f34 <sys_page_alloc>
  80281c:	83 c4 10             	add    $0x10,%esp
  80281f:	85 c0                	test   %eax,%eax
  802821:	78 21                	js     802844 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80282c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802838:	83 ec 0c             	sub    $0xc,%esp
  80283b:	50                   	push   %eax
  80283c:	e8 af ee ff ff       	call   8016f0 <fd2num>
  802841:	83 c4 10             	add    $0x10,%esp
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80284c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802853:	74 0a                	je     80285f <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	6a 07                	push   $0x7
  802864:	68 00 f0 bf ee       	push   $0xeebff000
  802869:	6a 00                	push   $0x0
  80286b:	e8 c4 e6 ff ff       	call   800f34 <sys_page_alloc>
		if(r < 0)
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	85 c0                	test   %eax,%eax
  802875:	78 2a                	js     8028a1 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802877:	83 ec 08             	sub    $0x8,%esp
  80287a:	68 b5 28 80 00       	push   $0x8028b5
  80287f:	6a 00                	push   $0x0
  802881:	e8 f9 e7 ff ff       	call   80107f <sys_env_set_pgfault_upcall>
		if(r < 0)
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	85 c0                	test   %eax,%eax
  80288b:	79 c8                	jns    802855 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80288d:	83 ec 04             	sub    $0x4,%esp
  802890:	68 74 33 80 00       	push   $0x803374
  802895:	6a 25                	push   $0x25
  802897:	68 b0 33 80 00       	push   $0x8033b0
  80289c:	e8 4c da ff ff       	call   8002ed <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	68 44 33 80 00       	push   $0x803344
  8028a9:	6a 22                	push   $0x22
  8028ab:	68 b0 33 80 00       	push   $0x8033b0
  8028b0:	e8 38 da ff ff       	call   8002ed <_panic>

008028b5 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028b5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028b6:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028bb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028bd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028c0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028c4:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028c8:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028cb:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028cd:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028d1:	83 c4 08             	add    $0x8,%esp
	popal
  8028d4:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028d5:	83 c4 04             	add    $0x4,%esp
	popfl
  8028d8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028d9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028da:	c3                   	ret    

008028db <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
  8028de:	56                   	push   %esi
  8028df:	53                   	push   %ebx
  8028e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8028e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028e9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028eb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028f0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	50                   	push   %eax
  8028f7:	e8 e8 e7 ff ff       	call   8010e4 <sys_ipc_recv>
	if(ret < 0){
  8028fc:	83 c4 10             	add    $0x10,%esp
  8028ff:	85 c0                	test   %eax,%eax
  802901:	78 2b                	js     80292e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802903:	85 f6                	test   %esi,%esi
  802905:	74 0a                	je     802911 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802907:	a1 08 50 80 00       	mov    0x805008,%eax
  80290c:	8b 40 74             	mov    0x74(%eax),%eax
  80290f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802911:	85 db                	test   %ebx,%ebx
  802913:	74 0a                	je     80291f <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802915:	a1 08 50 80 00       	mov    0x805008,%eax
  80291a:	8b 40 78             	mov    0x78(%eax),%eax
  80291d:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80291f:	a1 08 50 80 00       	mov    0x805008,%eax
  802924:	8b 40 70             	mov    0x70(%eax),%eax
}
  802927:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80292a:	5b                   	pop    %ebx
  80292b:	5e                   	pop    %esi
  80292c:	5d                   	pop    %ebp
  80292d:	c3                   	ret    
		if(from_env_store)
  80292e:	85 f6                	test   %esi,%esi
  802930:	74 06                	je     802938 <ipc_recv+0x5d>
			*from_env_store = 0;
  802932:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802938:	85 db                	test   %ebx,%ebx
  80293a:	74 eb                	je     802927 <ipc_recv+0x4c>
			*perm_store = 0;
  80293c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802942:	eb e3                	jmp    802927 <ipc_recv+0x4c>

00802944 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	57                   	push   %edi
  802948:	56                   	push   %esi
  802949:	53                   	push   %ebx
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802950:	8b 75 0c             	mov    0xc(%ebp),%esi
  802953:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802956:	85 db                	test   %ebx,%ebx
  802958:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80295d:	0f 44 d8             	cmove  %eax,%ebx
  802960:	eb 05                	jmp    802967 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802962:	e8 ae e5 ff ff       	call   800f15 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802967:	ff 75 14             	pushl  0x14(%ebp)
  80296a:	53                   	push   %ebx
  80296b:	56                   	push   %esi
  80296c:	57                   	push   %edi
  80296d:	e8 4f e7 ff ff       	call   8010c1 <sys_ipc_try_send>
  802972:	83 c4 10             	add    $0x10,%esp
  802975:	85 c0                	test   %eax,%eax
  802977:	74 1b                	je     802994 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802979:	79 e7                	jns    802962 <ipc_send+0x1e>
  80297b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80297e:	74 e2                	je     802962 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 be 33 80 00       	push   $0x8033be
  802988:	6a 48                	push   $0x48
  80298a:	68 d3 33 80 00       	push   $0x8033d3
  80298f:	e8 59 d9 ff ff       	call   8002ed <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802994:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802997:	5b                   	pop    %ebx
  802998:	5e                   	pop    %esi
  802999:	5f                   	pop    %edi
  80299a:	5d                   	pop    %ebp
  80299b:	c3                   	ret    

0080299c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029a7:	89 c2                	mov    %eax,%edx
  8029a9:	c1 e2 07             	shl    $0x7,%edx
  8029ac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029b2:	8b 52 50             	mov    0x50(%edx),%edx
  8029b5:	39 ca                	cmp    %ecx,%edx
  8029b7:	74 11                	je     8029ca <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029b9:	83 c0 01             	add    $0x1,%eax
  8029bc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029c1:	75 e4                	jne    8029a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c8:	eb 0b                	jmp    8029d5 <ipc_find_env+0x39>
			return envs[i].env_id;
  8029ca:	c1 e0 07             	shl    $0x7,%eax
  8029cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029d2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029d5:	5d                   	pop    %ebp
  8029d6:	c3                   	ret    

008029d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	c1 e8 16             	shr    $0x16,%eax
  8029e2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029ee:	f6 c1 01             	test   $0x1,%cl
  8029f1:	74 1d                	je     802a10 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029f3:	c1 ea 0c             	shr    $0xc,%edx
  8029f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029fd:	f6 c2 01             	test   $0x1,%dl
  802a00:	74 0e                	je     802a10 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a02:	c1 ea 0c             	shr    $0xc,%edx
  802a05:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a0c:	ef 
  802a0d:	0f b7 c0             	movzwl %ax,%eax
}
  802a10:	5d                   	pop    %ebp
  802a11:	c3                   	ret    
  802a12:	66 90                	xchg   %ax,%ax
  802a14:	66 90                	xchg   %ax,%ax
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	66 90                	xchg   %ax,%ax
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <__udivdi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
  802a24:	83 ec 1c             	sub    $0x1c,%esp
  802a27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a37:	85 d2                	test   %edx,%edx
  802a39:	75 4d                	jne    802a88 <__udivdi3+0x68>
  802a3b:	39 f3                	cmp    %esi,%ebx
  802a3d:	76 19                	jbe    802a58 <__udivdi3+0x38>
  802a3f:	31 ff                	xor    %edi,%edi
  802a41:	89 e8                	mov    %ebp,%eax
  802a43:	89 f2                	mov    %esi,%edx
  802a45:	f7 f3                	div    %ebx
  802a47:	89 fa                	mov    %edi,%edx
  802a49:	83 c4 1c             	add    $0x1c,%esp
  802a4c:	5b                   	pop    %ebx
  802a4d:	5e                   	pop    %esi
  802a4e:	5f                   	pop    %edi
  802a4f:	5d                   	pop    %ebp
  802a50:	c3                   	ret    
  802a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a58:	89 d9                	mov    %ebx,%ecx
  802a5a:	85 db                	test   %ebx,%ebx
  802a5c:	75 0b                	jne    802a69 <__udivdi3+0x49>
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	31 d2                	xor    %edx,%edx
  802a65:	f7 f3                	div    %ebx
  802a67:	89 c1                	mov    %eax,%ecx
  802a69:	31 d2                	xor    %edx,%edx
  802a6b:	89 f0                	mov    %esi,%eax
  802a6d:	f7 f1                	div    %ecx
  802a6f:	89 c6                	mov    %eax,%esi
  802a71:	89 e8                	mov    %ebp,%eax
  802a73:	89 f7                	mov    %esi,%edi
  802a75:	f7 f1                	div    %ecx
  802a77:	89 fa                	mov    %edi,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	39 f2                	cmp    %esi,%edx
  802a8a:	77 1c                	ja     802aa8 <__udivdi3+0x88>
  802a8c:	0f bd fa             	bsr    %edx,%edi
  802a8f:	83 f7 1f             	xor    $0x1f,%edi
  802a92:	75 2c                	jne    802ac0 <__udivdi3+0xa0>
  802a94:	39 f2                	cmp    %esi,%edx
  802a96:	72 06                	jb     802a9e <__udivdi3+0x7e>
  802a98:	31 c0                	xor    %eax,%eax
  802a9a:	39 eb                	cmp    %ebp,%ebx
  802a9c:	77 a9                	ja     802a47 <__udivdi3+0x27>
  802a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa3:	eb a2                	jmp    802a47 <__udivdi3+0x27>
  802aa5:	8d 76 00             	lea    0x0(%esi),%esi
  802aa8:	31 ff                	xor    %edi,%edi
  802aaa:	31 c0                	xor    %eax,%eax
  802aac:	89 fa                	mov    %edi,%edx
  802aae:	83 c4 1c             	add    $0x1c,%esp
  802ab1:	5b                   	pop    %ebx
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    
  802ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802abd:	8d 76 00             	lea    0x0(%esi),%esi
  802ac0:	89 f9                	mov    %edi,%ecx
  802ac2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ac7:	29 f8                	sub    %edi,%eax
  802ac9:	d3 e2                	shl    %cl,%edx
  802acb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802acf:	89 c1                	mov    %eax,%ecx
  802ad1:	89 da                	mov    %ebx,%edx
  802ad3:	d3 ea                	shr    %cl,%edx
  802ad5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ad9:	09 d1                	or     %edx,%ecx
  802adb:	89 f2                	mov    %esi,%edx
  802add:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae1:	89 f9                	mov    %edi,%ecx
  802ae3:	d3 e3                	shl    %cl,%ebx
  802ae5:	89 c1                	mov    %eax,%ecx
  802ae7:	d3 ea                	shr    %cl,%edx
  802ae9:	89 f9                	mov    %edi,%ecx
  802aeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802aef:	89 eb                	mov    %ebp,%ebx
  802af1:	d3 e6                	shl    %cl,%esi
  802af3:	89 c1                	mov    %eax,%ecx
  802af5:	d3 eb                	shr    %cl,%ebx
  802af7:	09 de                	or     %ebx,%esi
  802af9:	89 f0                	mov    %esi,%eax
  802afb:	f7 74 24 08          	divl   0x8(%esp)
  802aff:	89 d6                	mov    %edx,%esi
  802b01:	89 c3                	mov    %eax,%ebx
  802b03:	f7 64 24 0c          	mull   0xc(%esp)
  802b07:	39 d6                	cmp    %edx,%esi
  802b09:	72 15                	jb     802b20 <__udivdi3+0x100>
  802b0b:	89 f9                	mov    %edi,%ecx
  802b0d:	d3 e5                	shl    %cl,%ebp
  802b0f:	39 c5                	cmp    %eax,%ebp
  802b11:	73 04                	jae    802b17 <__udivdi3+0xf7>
  802b13:	39 d6                	cmp    %edx,%esi
  802b15:	74 09                	je     802b20 <__udivdi3+0x100>
  802b17:	89 d8                	mov    %ebx,%eax
  802b19:	31 ff                	xor    %edi,%edi
  802b1b:	e9 27 ff ff ff       	jmp    802a47 <__udivdi3+0x27>
  802b20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b23:	31 ff                	xor    %edi,%edi
  802b25:	e9 1d ff ff ff       	jmp    802a47 <__udivdi3+0x27>
  802b2a:	66 90                	xchg   %ax,%ax
  802b2c:	66 90                	xchg   %ax,%ax
  802b2e:	66 90                	xchg   %ax,%ax

00802b30 <__umoddi3>:
  802b30:	55                   	push   %ebp
  802b31:	57                   	push   %edi
  802b32:	56                   	push   %esi
  802b33:	53                   	push   %ebx
  802b34:	83 ec 1c             	sub    $0x1c,%esp
  802b37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b47:	89 da                	mov    %ebx,%edx
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	75 43                	jne    802b90 <__umoddi3+0x60>
  802b4d:	39 df                	cmp    %ebx,%edi
  802b4f:	76 17                	jbe    802b68 <__umoddi3+0x38>
  802b51:	89 f0                	mov    %esi,%eax
  802b53:	f7 f7                	div    %edi
  802b55:	89 d0                	mov    %edx,%eax
  802b57:	31 d2                	xor    %edx,%edx
  802b59:	83 c4 1c             	add    $0x1c,%esp
  802b5c:	5b                   	pop    %ebx
  802b5d:	5e                   	pop    %esi
  802b5e:	5f                   	pop    %edi
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    
  802b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b68:	89 fd                	mov    %edi,%ebp
  802b6a:	85 ff                	test   %edi,%edi
  802b6c:	75 0b                	jne    802b79 <__umoddi3+0x49>
  802b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b73:	31 d2                	xor    %edx,%edx
  802b75:	f7 f7                	div    %edi
  802b77:	89 c5                	mov    %eax,%ebp
  802b79:	89 d8                	mov    %ebx,%eax
  802b7b:	31 d2                	xor    %edx,%edx
  802b7d:	f7 f5                	div    %ebp
  802b7f:	89 f0                	mov    %esi,%eax
  802b81:	f7 f5                	div    %ebp
  802b83:	89 d0                	mov    %edx,%eax
  802b85:	eb d0                	jmp    802b57 <__umoddi3+0x27>
  802b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8e:	66 90                	xchg   %ax,%ax
  802b90:	89 f1                	mov    %esi,%ecx
  802b92:	39 d8                	cmp    %ebx,%eax
  802b94:	76 0a                	jbe    802ba0 <__umoddi3+0x70>
  802b96:	89 f0                	mov    %esi,%eax
  802b98:	83 c4 1c             	add    $0x1c,%esp
  802b9b:	5b                   	pop    %ebx
  802b9c:	5e                   	pop    %esi
  802b9d:	5f                   	pop    %edi
  802b9e:	5d                   	pop    %ebp
  802b9f:	c3                   	ret    
  802ba0:	0f bd e8             	bsr    %eax,%ebp
  802ba3:	83 f5 1f             	xor    $0x1f,%ebp
  802ba6:	75 20                	jne    802bc8 <__umoddi3+0x98>
  802ba8:	39 d8                	cmp    %ebx,%eax
  802baa:	0f 82 b0 00 00 00    	jb     802c60 <__umoddi3+0x130>
  802bb0:	39 f7                	cmp    %esi,%edi
  802bb2:	0f 86 a8 00 00 00    	jbe    802c60 <__umoddi3+0x130>
  802bb8:	89 c8                	mov    %ecx,%eax
  802bba:	83 c4 1c             	add    $0x1c,%esp
  802bbd:	5b                   	pop    %ebx
  802bbe:	5e                   	pop    %esi
  802bbf:	5f                   	pop    %edi
  802bc0:	5d                   	pop    %ebp
  802bc1:	c3                   	ret    
  802bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bc8:	89 e9                	mov    %ebp,%ecx
  802bca:	ba 20 00 00 00       	mov    $0x20,%edx
  802bcf:	29 ea                	sub    %ebp,%edx
  802bd1:	d3 e0                	shl    %cl,%eax
  802bd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bd7:	89 d1                	mov    %edx,%ecx
  802bd9:	89 f8                	mov    %edi,%eax
  802bdb:	d3 e8                	shr    %cl,%eax
  802bdd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802be1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802be5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802be9:	09 c1                	or     %eax,%ecx
  802beb:	89 d8                	mov    %ebx,%eax
  802bed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bf1:	89 e9                	mov    %ebp,%ecx
  802bf3:	d3 e7                	shl    %cl,%edi
  802bf5:	89 d1                	mov    %edx,%ecx
  802bf7:	d3 e8                	shr    %cl,%eax
  802bf9:	89 e9                	mov    %ebp,%ecx
  802bfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bff:	d3 e3                	shl    %cl,%ebx
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	89 d1                	mov    %edx,%ecx
  802c05:	89 f0                	mov    %esi,%eax
  802c07:	d3 e8                	shr    %cl,%eax
  802c09:	89 e9                	mov    %ebp,%ecx
  802c0b:	89 fa                	mov    %edi,%edx
  802c0d:	d3 e6                	shl    %cl,%esi
  802c0f:	09 d8                	or     %ebx,%eax
  802c11:	f7 74 24 08          	divl   0x8(%esp)
  802c15:	89 d1                	mov    %edx,%ecx
  802c17:	89 f3                	mov    %esi,%ebx
  802c19:	f7 64 24 0c          	mull   0xc(%esp)
  802c1d:	89 c6                	mov    %eax,%esi
  802c1f:	89 d7                	mov    %edx,%edi
  802c21:	39 d1                	cmp    %edx,%ecx
  802c23:	72 06                	jb     802c2b <__umoddi3+0xfb>
  802c25:	75 10                	jne    802c37 <__umoddi3+0x107>
  802c27:	39 c3                	cmp    %eax,%ebx
  802c29:	73 0c                	jae    802c37 <__umoddi3+0x107>
  802c2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c33:	89 d7                	mov    %edx,%edi
  802c35:	89 c6                	mov    %eax,%esi
  802c37:	89 ca                	mov    %ecx,%edx
  802c39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c3e:	29 f3                	sub    %esi,%ebx
  802c40:	19 fa                	sbb    %edi,%edx
  802c42:	89 d0                	mov    %edx,%eax
  802c44:	d3 e0                	shl    %cl,%eax
  802c46:	89 e9                	mov    %ebp,%ecx
  802c48:	d3 eb                	shr    %cl,%ebx
  802c4a:	d3 ea                	shr    %cl,%edx
  802c4c:	09 d8                	or     %ebx,%eax
  802c4e:	83 c4 1c             	add    $0x1c,%esp
  802c51:	5b                   	pop    %ebx
  802c52:	5e                   	pop    %esi
  802c53:	5f                   	pop    %edi
  802c54:	5d                   	pop    %ebp
  802c55:	c3                   	ret    
  802c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c5d:	8d 76 00             	lea    0x0(%esi),%esi
  802c60:	89 da                	mov    %ebx,%edx
  802c62:	29 fe                	sub    %edi,%esi
  802c64:	19 c2                	sbb    %eax,%edx
  802c66:	89 f1                	mov    %esi,%ecx
  802c68:	89 c8                	mov    %ecx,%eax
  802c6a:	e9 4b ff ff ff       	jmp    802bba <__umoddi3+0x8a>
