
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
  800056:	68 c0 2c 80 00       	push   $0x802cc0
  80005b:	6a 15                	push   $0x15
  80005d:	68 ef 2c 80 00       	push   $0x802cef
  800062:	e8 d7 02 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 05 2d 80 00       	push   $0x802d05
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 ef 2c 80 00       	push   $0x802cef
  800074:	e8 c5 02 00 00       	call   80033e <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 0e 2d 80 00       	push   $0x802d0e
  80007f:	6a 1d                	push   $0x1d
  800081:	68 ef 2c 80 00       	push   $0x802cef
  800086:	e8 b3 02 00 00       	call   80033e <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 58 18 00 00       	call   8018ec <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 4d 18 00 00       	call   8018ec <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 00 1a 00 00       	call   801ab1 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 01 2d 80 00       	push   $0x802d01
  8000c4:	e8 6b 03 00 00       	call   800434 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 d4 24 00 00       	call   8025a5 <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 cf 13 00 00       	call   8014af <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 fb 17 00 00       	call   8018ec <close>
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
  800101:	e8 ab 19 00 00       	call   801ab1 <readn>
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
  800120:	e8 d1 19 00 00       	call   801af6 <write>
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
  80013f:	68 33 2d 80 00       	push   $0x802d33
  800144:	6a 2e                	push   $0x2e
  800146:	68 ef 2c 80 00       	push   $0x802cef
  80014b:	e8 ee 01 00 00       	call   80033e <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 17 2d 80 00       	push   $0x802d17
  800168:	6a 2b                	push   $0x2b
  80016a:	68 ef 2c 80 00       	push   $0x802cef
  80016f:	e8 ca 01 00 00       	call   80033e <_panic>

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
  80017b:	c7 05 00 40 80 00 4d 	movl   $0x802d4d,0x804000
  800182:	2d 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 17 24 00 00       	call   8025a5 <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 12 13 00 00       	call   8014af <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 3e 17 00 00       	call   8018ec <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 05 2d 80 00       	push   $0x802d05
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 ef 2c 80 00       	push   $0x802cef
  8001c6:	e8 73 01 00 00       	call   80033e <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 0e 2d 80 00       	push   $0x802d0e
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 ef 2c 80 00       	push   $0x802cef
  8001d8:	e8 61 01 00 00       	call   80033e <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 04 17 00 00       	call   8018ec <close>

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
  8001fe:	e8 f3 18 00 00       	call   801af6 <write>
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
  800220:	68 58 2d 80 00       	push   $0x802d58
  800225:	6a 4a                	push   $0x4a
  800227:	68 ef 2c 80 00       	push   $0x802cef
  80022c:	e8 0d 01 00 00       	call   80033e <_panic>

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
  800244:	e8 fe 0c 00 00       	call   800f47 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8002a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8002ad:	8b 40 48             	mov    0x48(%eax),%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	50                   	push   %eax
  8002b4:	68 70 2d 80 00       	push   $0x802d70
  8002b9:	e8 76 01 00 00       	call   800434 <cprintf>
	cprintf("before umain\n");
  8002be:	c7 04 24 8e 2d 80 00 	movl   $0x802d8e,(%esp)
  8002c5:	e8 6a 01 00 00       	call   800434 <cprintf>
	// call user main routine
	umain(argc, argv);
  8002ca:	83 c4 08             	add    $0x8,%esp
  8002cd:	ff 75 0c             	pushl  0xc(%ebp)
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 9c fe ff ff       	call   800174 <umain>
	cprintf("after umain\n");
  8002d8:	c7 04 24 9c 2d 80 00 	movl   $0x802d9c,(%esp)
  8002df:	e8 50 01 00 00       	call   800434 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8002e4:	a1 08 50 80 00       	mov    0x805008,%eax
  8002e9:	8b 40 48             	mov    0x48(%eax),%eax
  8002ec:	83 c4 08             	add    $0x8,%esp
  8002ef:	50                   	push   %eax
  8002f0:	68 a9 2d 80 00       	push   $0x802da9
  8002f5:	e8 3a 01 00 00       	call   800434 <cprintf>
	// exit gracefully
	exit();
  8002fa:	e8 0b 00 00 00       	call   80030a <exit>
}
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800310:	a1 08 50 80 00       	mov    0x805008,%eax
  800315:	8b 40 48             	mov    0x48(%eax),%eax
  800318:	68 d4 2d 80 00       	push   $0x802dd4
  80031d:	50                   	push   %eax
  80031e:	68 c8 2d 80 00       	push   $0x802dc8
  800323:	e8 0c 01 00 00       	call   800434 <cprintf>
	close_all();
  800328:	e8 ec 15 00 00       	call   801919 <close_all>
	sys_env_destroy(0);
  80032d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800334:	e8 cd 0b 00 00       	call   800f06 <sys_env_destroy>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800343:	a1 08 50 80 00       	mov    0x805008,%eax
  800348:	8b 40 48             	mov    0x48(%eax),%eax
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 00 2e 80 00       	push   $0x802e00
  800353:	50                   	push   %eax
  800354:	68 c8 2d 80 00       	push   $0x802dc8
  800359:	e8 d6 00 00 00       	call   800434 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80035e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800361:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800367:	e8 db 0b 00 00       	call   800f47 <sys_getenvid>
  80036c:	83 c4 04             	add    $0x4,%esp
  80036f:	ff 75 0c             	pushl  0xc(%ebp)
  800372:	ff 75 08             	pushl  0x8(%ebp)
  800375:	56                   	push   %esi
  800376:	50                   	push   %eax
  800377:	68 dc 2d 80 00       	push   $0x802ddc
  80037c:	e8 b3 00 00 00       	call   800434 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800381:	83 c4 18             	add    $0x18,%esp
  800384:	53                   	push   %ebx
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	e8 56 00 00 00       	call   8003e3 <vcprintf>
	cprintf("\n");
  80038d:	c7 04 24 8c 2d 80 00 	movl   $0x802d8c,(%esp)
  800394:	e8 9b 00 00 00       	call   800434 <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039c:	cc                   	int3   
  80039d:	eb fd                	jmp    80039c <_panic+0x5e>

0080039f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	53                   	push   %ebx
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a9:	8b 13                	mov    (%ebx),%edx
  8003ab:	8d 42 01             	lea    0x1(%edx),%eax
  8003ae:	89 03                	mov    %eax,(%ebx)
  8003b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bc:	74 09                	je     8003c7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c5:	c9                   	leave  
  8003c6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	68 ff 00 00 00       	push   $0xff
  8003cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 f1 0a 00 00       	call   800ec9 <sys_cputs>
		b->idx = 0;
  8003d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	eb db                	jmp    8003be <putch+0x1f>

008003e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f3:	00 00 00 
	b.cnt = 0;
  8003f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	68 9f 03 80 00       	push   $0x80039f
  800412:	e8 4a 01 00 00       	call   800561 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800417:	83 c4 08             	add    $0x8,%esp
  80041a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800420:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	e8 9d 0a 00 00       	call   800ec9 <sys_cputs>

	return b.cnt;
}
  80042c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043d:	50                   	push   %eax
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	e8 9d ff ff ff       	call   8003e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 1c             	sub    $0x1c,%esp
  800451:	89 c6                	mov    %eax,%esi
  800453:	89 d7                	mov    %edx,%edi
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800467:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80046b:	74 2c                	je     800499 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80046d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800470:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80047d:	39 c2                	cmp    %eax,%edx
  80047f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800482:	73 43                	jae    8004c7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800484:	83 eb 01             	sub    $0x1,%ebx
  800487:	85 db                	test   %ebx,%ebx
  800489:	7e 6c                	jle    8004f7 <printnum+0xaf>
				putch(padc, putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	57                   	push   %edi
  80048f:	ff 75 18             	pushl  0x18(%ebp)
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb eb                	jmp    800484 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800499:	83 ec 0c             	sub    $0xc,%esp
  80049c:	6a 20                	push   $0x20
  80049e:	6a 00                	push   $0x0
  8004a0:	50                   	push   %eax
  8004a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a7:	89 fa                	mov    %edi,%edx
  8004a9:	89 f0                	mov    %esi,%eax
  8004ab:	e8 98 ff ff ff       	call   800448 <printnum>
		while (--width > 0)
  8004b0:	83 c4 20             	add    $0x20,%esp
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7e 65                	jle    80051f <printnum+0xd7>
			putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	57                   	push   %edi
  8004be:	6a 20                	push   $0x20
  8004c0:	ff d6                	call   *%esi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	eb ec                	jmp    8004b3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	ff 75 18             	pushl  0x18(%ebp)
  8004cd:	83 eb 01             	sub    $0x1,%ebx
  8004d0:	53                   	push   %ebx
  8004d1:	50                   	push   %eax
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	e8 8a 25 00 00       	call   802a70 <__udivdi3>
  8004e6:	83 c4 18             	add    $0x18,%esp
  8004e9:	52                   	push   %edx
  8004ea:	50                   	push   %eax
  8004eb:	89 fa                	mov    %edi,%edx
  8004ed:	89 f0                	mov    %esi,%eax
  8004ef:	e8 54 ff ff ff       	call   800448 <printnum>
  8004f4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	57                   	push   %edi
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	ff 75 e4             	pushl  -0x1c(%ebp)
  800507:	ff 75 e0             	pushl  -0x20(%ebp)
  80050a:	e8 71 26 00 00       	call   802b80 <__umoddi3>
  80050f:	83 c4 14             	add    $0x14,%esp
  800512:	0f be 80 07 2e 80 00 	movsbl 0x802e07(%eax),%eax
  800519:	50                   	push   %eax
  80051a:	ff d6                	call   *%esi
  80051c:	83 c4 10             	add    $0x10,%esp
	}
}
  80051f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80052d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800531:	8b 10                	mov    (%eax),%edx
  800533:	3b 50 04             	cmp    0x4(%eax),%edx
  800536:	73 0a                	jae    800542 <sprintputch+0x1b>
		*b->buf++ = ch;
  800538:	8d 4a 01             	lea    0x1(%edx),%ecx
  80053b:	89 08                	mov    %ecx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	88 02                	mov    %al,(%edx)
}
  800542:	5d                   	pop    %ebp
  800543:	c3                   	ret    

00800544 <printfmt>:
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80054a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80054d:	50                   	push   %eax
  80054e:	ff 75 10             	pushl  0x10(%ebp)
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	ff 75 08             	pushl  0x8(%ebp)
  800557:	e8 05 00 00 00       	call   800561 <vprintfmt>
}
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <vprintfmt>:
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	57                   	push   %edi
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 3c             	sub    $0x3c,%esp
  80056a:	8b 75 08             	mov    0x8(%ebp),%esi
  80056d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800570:	8b 7d 10             	mov    0x10(%ebp),%edi
  800573:	e9 32 04 00 00       	jmp    8009aa <vprintfmt+0x449>
		padc = ' ';
  800578:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80057c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800583:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80058a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800591:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800598:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80059f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	8d 47 01             	lea    0x1(%edi),%eax
  8005a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005aa:	0f b6 17             	movzbl (%edi),%edx
  8005ad:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005b0:	3c 55                	cmp    $0x55,%al
  8005b2:	0f 87 12 05 00 00    	ja     800aca <vprintfmt+0x569>
  8005b8:	0f b6 c0             	movzbl %al,%eax
  8005bb:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
  8005c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005c5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005c9:	eb d9                	jmp    8005a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005ce:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005d2:	eb d0                	jmp    8005a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005d4:	0f b6 d2             	movzbl %dl,%edx
  8005d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005da:	b8 00 00 00 00       	mov    $0x0,%eax
  8005df:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e2:	eb 03                	jmp    8005e7 <vprintfmt+0x86>
  8005e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ea:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ee:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005f1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005f4:	83 fe 09             	cmp    $0x9,%esi
  8005f7:	76 eb                	jbe    8005e4 <vprintfmt+0x83>
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ff:	eb 14                	jmp    800615 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800619:	79 89                	jns    8005a4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80061b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80061e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800621:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800628:	e9 77 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
  80062d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800630:	85 c0                	test   %eax,%eax
  800632:	0f 48 c1             	cmovs  %ecx,%eax
  800635:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800638:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80063b:	e9 64 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800643:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80064a:	e9 55 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
			lflag++;
  80064f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800656:	e9 49 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 78 04             	lea    0x4(%eax),%edi
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	ff 30                	pushl  (%eax)
  800667:	ff d6                	call   *%esi
			break;
  800669:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80066c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80066f:	e9 33 03 00 00       	jmp    8009a7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 78 04             	lea    0x4(%eax),%edi
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	99                   	cltd   
  80067d:	31 d0                	xor    %edx,%eax
  80067f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800681:	83 f8 11             	cmp    $0x11,%eax
  800684:	7f 23                	jg     8006a9 <vprintfmt+0x148>
  800686:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	74 18                	je     8006a9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800691:	52                   	push   %edx
  800692:	68 4d 33 80 00       	push   $0x80334d
  800697:	53                   	push   %ebx
  800698:	56                   	push   %esi
  800699:	e8 a6 fe ff ff       	call   800544 <printfmt>
  80069e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a4:	e9 fe 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006a9:	50                   	push   %eax
  8006aa:	68 1f 2e 80 00       	push   $0x802e1f
  8006af:	53                   	push   %ebx
  8006b0:	56                   	push   %esi
  8006b1:	e8 8e fe ff ff       	call   800544 <printfmt>
  8006b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006bc:	e9 e6 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	83 c0 04             	add    $0x4,%eax
  8006c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006cf:	85 c9                	test   %ecx,%ecx
  8006d1:	b8 18 2e 80 00       	mov    $0x802e18,%eax
  8006d6:	0f 45 c1             	cmovne %ecx,%eax
  8006d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e0:	7e 06                	jle    8006e8 <vprintfmt+0x187>
  8006e2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006e6:	75 0d                	jne    8006f5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006eb:	89 c7                	mov    %eax,%edi
  8006ed:	03 45 e0             	add    -0x20(%ebp),%eax
  8006f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f3:	eb 53                	jmp    800748 <vprintfmt+0x1e7>
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 71 04 00 00       	call   800b72 <strnlen>
  800701:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800704:	29 c1                	sub    %eax,%ecx
  800706:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80070e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800712:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800715:	eb 0f                	jmp    800726 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	ff 75 e0             	pushl  -0x20(%ebp)
  80071e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800720:	83 ef 01             	sub    $0x1,%edi
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	85 ff                	test   %edi,%edi
  800728:	7f ed                	jg     800717 <vprintfmt+0x1b6>
  80072a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80072d:	85 c9                	test   %ecx,%ecx
  80072f:	b8 00 00 00 00       	mov    $0x0,%eax
  800734:	0f 49 c1             	cmovns %ecx,%eax
  800737:	29 c1                	sub    %eax,%ecx
  800739:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80073c:	eb aa                	jmp    8006e8 <vprintfmt+0x187>
					putch(ch, putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	52                   	push   %edx
  800743:	ff d6                	call   *%esi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074d:	83 c7 01             	add    $0x1,%edi
  800750:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800754:	0f be d0             	movsbl %al,%edx
  800757:	85 d2                	test   %edx,%edx
  800759:	74 4b                	je     8007a6 <vprintfmt+0x245>
  80075b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80075f:	78 06                	js     800767 <vprintfmt+0x206>
  800761:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800765:	78 1e                	js     800785 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800767:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80076b:	74 d1                	je     80073e <vprintfmt+0x1dd>
  80076d:	0f be c0             	movsbl %al,%eax
  800770:	83 e8 20             	sub    $0x20,%eax
  800773:	83 f8 5e             	cmp    $0x5e,%eax
  800776:	76 c6                	jbe    80073e <vprintfmt+0x1dd>
					putch('?', putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	53                   	push   %ebx
  80077c:	6a 3f                	push   $0x3f
  80077e:	ff d6                	call   *%esi
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	eb c3                	jmp    800748 <vprintfmt+0x1e7>
  800785:	89 cf                	mov    %ecx,%edi
  800787:	eb 0e                	jmp    800797 <vprintfmt+0x236>
				putch(' ', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 20                	push   $0x20
  80078f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800791:	83 ef 01             	sub    $0x1,%edi
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	85 ff                	test   %edi,%edi
  800799:	7f ee                	jg     800789 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80079b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	e9 01 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
  8007a6:	89 cf                	mov    %ecx,%edi
  8007a8:	eb ed                	jmp    800797 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007b4:	e9 eb fd ff ff       	jmp    8005a4 <vprintfmt+0x43>
	if (lflag >= 2)
  8007b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bd:	7f 21                	jg     8007e0 <vprintfmt+0x27f>
	else if (lflag)
  8007bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c3:	74 68                	je     80082d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007cd:	89 c1                	mov    %eax,%ecx
  8007cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	eb 17                	jmp    8007f7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 50 04             	mov    0x4(%eax),%edx
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 08             	lea    0x8(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800803:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800807:	78 3f                	js     800848 <vprintfmt+0x2e7>
			base = 10;
  800809:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80080e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800812:	0f 84 71 01 00 00    	je     800989 <vprintfmt+0x428>
				putch('+', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 2b                	push   $0x2b
  80081e:	ff d6                	call   *%esi
  800820:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
  800828:	e9 5c 01 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800835:	89 c1                	mov    %eax,%ecx
  800837:	c1 f9 1f             	sar    $0x1f,%ecx
  80083a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	eb af                	jmp    8007f7 <vprintfmt+0x296>
				putch('-', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	53                   	push   %ebx
  80084c:	6a 2d                	push   $0x2d
  80084e:	ff d6                	call   *%esi
				num = -(long long) num;
  800850:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800856:	f7 d8                	neg    %eax
  800858:	83 d2 00             	adc    $0x0,%edx
  80085b:	f7 da                	neg    %edx
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800863:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800866:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086b:	e9 19 01 00 00       	jmp    800989 <vprintfmt+0x428>
	if (lflag >= 2)
  800870:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800874:	7f 29                	jg     80089f <vprintfmt+0x33e>
	else if (lflag)
  800876:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80087a:	74 44                	je     8008c0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 40 04             	lea    0x4(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800895:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089a:	e9 ea 00 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 50 04             	mov    0x4(%eax),%edx
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 08             	lea    0x8(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bb:	e9 c9 00 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8d 40 04             	lea    0x4(%eax),%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008de:	e9 a6 00 00 00       	jmp    800989 <vprintfmt+0x428>
			putch('0', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 30                	push   $0x30
  8008e9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008f2:	7f 26                	jg     80091a <vprintfmt+0x3b9>
	else if (lflag)
  8008f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008f8:	74 3e                	je     800938 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800907:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8d 40 04             	lea    0x4(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800913:	b8 08 00 00 00       	mov    $0x8,%eax
  800918:	eb 6f                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 50 04             	mov    0x4(%eax),%edx
  800920:	8b 00                	mov    (%eax),%eax
  800922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 40 08             	lea    0x8(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800931:	b8 08 00 00 00       	mov    $0x8,%eax
  800936:	eb 51                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800951:	b8 08 00 00 00       	mov    $0x8,%eax
  800956:	eb 31                	jmp    800989 <vprintfmt+0x428>
			putch('0', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	6a 30                	push   $0x30
  80095e:	ff d6                	call   *%esi
			putch('x', putdat);
  800960:	83 c4 08             	add    $0x8,%esp
  800963:	53                   	push   %ebx
  800964:	6a 78                	push   $0x78
  800966:	ff d6                	call   *%esi
			num = (unsigned long long)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800978:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 40 04             	lea    0x4(%eax),%eax
  800981:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800984:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800990:	52                   	push   %edx
  800991:	ff 75 e0             	pushl  -0x20(%ebp)
  800994:	50                   	push   %eax
  800995:	ff 75 dc             	pushl  -0x24(%ebp)
  800998:	ff 75 d8             	pushl  -0x28(%ebp)
  80099b:	89 da                	mov    %ebx,%edx
  80099d:	89 f0                	mov    %esi,%eax
  80099f:	e8 a4 fa ff ff       	call   800448 <printnum>
			break;
  8009a4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009aa:	83 c7 01             	add    $0x1,%edi
  8009ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b1:	83 f8 25             	cmp    $0x25,%eax
  8009b4:	0f 84 be fb ff ff    	je     800578 <vprintfmt+0x17>
			if (ch == '\0')
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	0f 84 28 01 00 00    	je     800aea <vprintfmt+0x589>
			putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	50                   	push   %eax
  8009c7:	ff d6                	call   *%esi
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	eb dc                	jmp    8009aa <vprintfmt+0x449>
	if (lflag >= 2)
  8009ce:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009d2:	7f 26                	jg     8009fa <vprintfmt+0x499>
	else if (lflag)
  8009d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009d8:	74 41                	je     800a1b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8d 40 04             	lea    0x4(%eax),%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f3:	b8 10 00 00 00       	mov    $0x10,%eax
  8009f8:	eb 8f                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	8b 50 04             	mov    0x4(%eax),%edx
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a05:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8d 40 08             	lea    0x8(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a11:	b8 10 00 00 00       	mov    $0x10,%eax
  800a16:	e9 6e ff ff ff       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a28:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	8d 40 04             	lea    0x4(%eax),%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a34:	b8 10 00 00 00       	mov    $0x10,%eax
  800a39:	e9 4b ff ff ff       	jmp    800989 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	74 14                	je     800a64 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a50:	8b 13                	mov    (%ebx),%edx
  800a52:	83 fa 7f             	cmp    $0x7f,%edx
  800a55:	7f 37                	jg     800a8e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a57:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5f:	e9 43 ff ff ff       	jmp    8009a7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a69:	bf 3d 2f 80 00       	mov    $0x802f3d,%edi
							putch(ch, putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	53                   	push   %ebx
  800a72:	50                   	push   %eax
  800a73:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a75:	83 c7 01             	add    $0x1,%edi
  800a78:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	75 eb                	jne    800a6e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
  800a89:	e9 19 ff ff ff       	jmp    8009a7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a8e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a95:	bf 75 2f 80 00       	mov    $0x802f75,%edi
							putch(ch, putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	53                   	push   %ebx
  800a9e:	50                   	push   %eax
  800a9f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa1:	83 c7 01             	add    $0x1,%edi
  800aa4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	85 c0                	test   %eax,%eax
  800aad:	75 eb                	jne    800a9a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800aaf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	e9 ed fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
			putch(ch, putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	53                   	push   %ebx
  800abe:	6a 25                	push   $0x25
  800ac0:	ff d6                	call   *%esi
			break;
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	e9 dd fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
			putch('%', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	53                   	push   %ebx
  800ace:	6a 25                	push   $0x25
  800ad0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad2:	83 c4 10             	add    $0x10,%esp
  800ad5:	89 f8                	mov    %edi,%eax
  800ad7:	eb 03                	jmp    800adc <vprintfmt+0x57b>
  800ad9:	83 e8 01             	sub    $0x1,%eax
  800adc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae0:	75 f7                	jne    800ad9 <vprintfmt+0x578>
  800ae2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae5:	e9 bd fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
}
  800aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800afe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	74 26                	je     800b39 <vsnprintf+0x47>
  800b13:	85 d2                	test   %edx,%edx
  800b15:	7e 22                	jle    800b39 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b17:	ff 75 14             	pushl  0x14(%ebp)
  800b1a:	ff 75 10             	pushl  0x10(%ebp)
  800b1d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b20:	50                   	push   %eax
  800b21:	68 27 05 80 00       	push   $0x800527
  800b26:	e8 36 fa ff ff       	call   800561 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b34:	83 c4 10             	add    $0x10,%esp
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    
		return -E_INVAL;
  800b39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3e:	eb f7                	jmp    800b37 <vsnprintf+0x45>

00800b40 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b49:	50                   	push   %eax
  800b4a:	ff 75 10             	pushl  0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 9a ff ff ff       	call   800af2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	b8 00 00 00 00       	mov    $0x0,%eax
  800b65:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b69:	74 05                	je     800b70 <strlen+0x16>
		n++;
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	eb f5                	jmp    800b65 <strlen+0xb>
	return n;
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	74 0d                	je     800b91 <strnlen+0x1f>
  800b84:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b88:	74 05                	je     800b8f <strnlen+0x1d>
		n++;
  800b8a:	83 c2 01             	add    $0x1,%edx
  800b8d:	eb f1                	jmp    800b80 <strnlen+0xe>
  800b8f:	89 d0                	mov    %edx,%eax
	return n;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba9:	83 c2 01             	add    $0x1,%edx
  800bac:	84 c9                	test   %cl,%cl
  800bae:	75 f2                	jne    800ba2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 10             	sub    $0x10,%esp
  800bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bbd:	53                   	push   %ebx
  800bbe:	e8 97 ff ff ff       	call   800b5a <strlen>
  800bc3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	01 d8                	add    %ebx,%eax
  800bcb:	50                   	push   %eax
  800bcc:	e8 c2 ff ff ff       	call   800b93 <strcpy>
	return dst;
}
  800bd1:	89 d8                	mov    %ebx,%eax
  800bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be3:	89 c6                	mov    %eax,%esi
  800be5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be8:	89 c2                	mov    %eax,%edx
  800bea:	39 f2                	cmp    %esi,%edx
  800bec:	74 11                	je     800bff <strncpy+0x27>
		*dst++ = *src;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f b6 19             	movzbl (%ecx),%ebx
  800bf4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf7:	80 fb 01             	cmp    $0x1,%bl
  800bfa:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bfd:	eb eb                	jmp    800bea <strncpy+0x12>
	}
	return ret;
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
  800c08:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	8b 55 10             	mov    0x10(%ebp),%edx
  800c11:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c13:	85 d2                	test   %edx,%edx
  800c15:	74 21                	je     800c38 <strlcpy+0x35>
  800c17:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c1b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c1d:	39 c2                	cmp    %eax,%edx
  800c1f:	74 14                	je     800c35 <strlcpy+0x32>
  800c21:	0f b6 19             	movzbl (%ecx),%ebx
  800c24:	84 db                	test   %bl,%bl
  800c26:	74 0b                	je     800c33 <strlcpy+0x30>
			*dst++ = *src++;
  800c28:	83 c1 01             	add    $0x1,%ecx
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c31:	eb ea                	jmp    800c1d <strlcpy+0x1a>
  800c33:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c35:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c38:	29 f0                	sub    %esi,%eax
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c47:	0f b6 01             	movzbl (%ecx),%eax
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 0c                	je     800c5a <strcmp+0x1c>
  800c4e:	3a 02                	cmp    (%edx),%al
  800c50:	75 08                	jne    800c5a <strcmp+0x1c>
		p++, q++;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	83 c2 01             	add    $0x1,%edx
  800c58:	eb ed                	jmp    800c47 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5a:	0f b6 c0             	movzbl %al,%eax
  800c5d:	0f b6 12             	movzbl (%edx),%edx
  800c60:	29 d0                	sub    %edx,%eax
}
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	53                   	push   %ebx
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 c3                	mov    %eax,%ebx
  800c70:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c73:	eb 06                	jmp    800c7b <strncmp+0x17>
		n--, p++, q++;
  800c75:	83 c0 01             	add    $0x1,%eax
  800c78:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c7b:	39 d8                	cmp    %ebx,%eax
  800c7d:	74 16                	je     800c95 <strncmp+0x31>
  800c7f:	0f b6 08             	movzbl (%eax),%ecx
  800c82:	84 c9                	test   %cl,%cl
  800c84:	74 04                	je     800c8a <strncmp+0x26>
  800c86:	3a 0a                	cmp    (%edx),%cl
  800c88:	74 eb                	je     800c75 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8a:	0f b6 00             	movzbl (%eax),%eax
  800c8d:	0f b6 12             	movzbl (%edx),%edx
  800c90:	29 d0                	sub    %edx,%eax
}
  800c92:	5b                   	pop    %ebx
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		return 0;
  800c95:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9a:	eb f6                	jmp    800c92 <strncmp+0x2e>

00800c9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca6:	0f b6 10             	movzbl (%eax),%edx
  800ca9:	84 d2                	test   %dl,%dl
  800cab:	74 09                	je     800cb6 <strchr+0x1a>
		if (*s == c)
  800cad:	38 ca                	cmp    %cl,%dl
  800caf:	74 0a                	je     800cbb <strchr+0x1f>
	for (; *s; s++)
  800cb1:	83 c0 01             	add    $0x1,%eax
  800cb4:	eb f0                	jmp    800ca6 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cca:	38 ca                	cmp    %cl,%dl
  800ccc:	74 09                	je     800cd7 <strfind+0x1a>
  800cce:	84 d2                	test   %dl,%dl
  800cd0:	74 05                	je     800cd7 <strfind+0x1a>
	for (; *s; s++)
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	eb f0                	jmp    800cc7 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce5:	85 c9                	test   %ecx,%ecx
  800ce7:	74 31                	je     800d1a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce9:	89 f8                	mov    %edi,%eax
  800ceb:	09 c8                	or     %ecx,%eax
  800ced:	a8 03                	test   $0x3,%al
  800cef:	75 23                	jne    800d14 <memset+0x3b>
		c &= 0xFF;
  800cf1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	c1 e3 08             	shl    $0x8,%ebx
  800cfa:	89 d0                	mov    %edx,%eax
  800cfc:	c1 e0 18             	shl    $0x18,%eax
  800cff:	89 d6                	mov    %edx,%esi
  800d01:	c1 e6 10             	shl    $0x10,%esi
  800d04:	09 f0                	or     %esi,%eax
  800d06:	09 c2                	or     %eax,%edx
  800d08:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0d:	89 d0                	mov    %edx,%eax
  800d0f:	fc                   	cld    
  800d10:	f3 ab                	rep stos %eax,%es:(%edi)
  800d12:	eb 06                	jmp    800d1a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	fc                   	cld    
  800d18:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1a:	89 f8                	mov    %edi,%eax
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2f:	39 c6                	cmp    %eax,%esi
  800d31:	73 32                	jae    800d65 <memmove+0x44>
  800d33:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	76 2b                	jbe    800d65 <memmove+0x44>
		s += n;
		d += n;
  800d3a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3d:	89 fe                	mov    %edi,%esi
  800d3f:	09 ce                	or     %ecx,%esi
  800d41:	09 d6                	or     %edx,%esi
  800d43:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d49:	75 0e                	jne    800d59 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d4b:	83 ef 04             	sub    $0x4,%edi
  800d4e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d54:	fd                   	std    
  800d55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d57:	eb 09                	jmp    800d62 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d59:	83 ef 01             	sub    $0x1,%edi
  800d5c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d5f:	fd                   	std    
  800d60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d62:	fc                   	cld    
  800d63:	eb 1a                	jmp    800d7f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	09 ca                	or     %ecx,%edx
  800d69:	09 f2                	or     %esi,%edx
  800d6b:	f6 c2 03             	test   $0x3,%dl
  800d6e:	75 0a                	jne    800d7a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d70:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d73:	89 c7                	mov    %eax,%edi
  800d75:	fc                   	cld    
  800d76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d78:	eb 05                	jmp    800d7f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7a:	89 c7                	mov    %eax,%edi
  800d7c:	fc                   	cld    
  800d7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d89:	ff 75 10             	pushl  0x10(%ebp)
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 8a ff ff ff       	call   800d21 <memmove>
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	89 c6                	mov    %eax,%esi
  800da6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da9:	39 f0                	cmp    %esi,%eax
  800dab:	74 1c                	je     800dc9 <memcmp+0x30>
		if (*s1 != *s2)
  800dad:	0f b6 08             	movzbl (%eax),%ecx
  800db0:	0f b6 1a             	movzbl (%edx),%ebx
  800db3:	38 d9                	cmp    %bl,%cl
  800db5:	75 08                	jne    800dbf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db7:	83 c0 01             	add    $0x1,%eax
  800dba:	83 c2 01             	add    $0x1,%edx
  800dbd:	eb ea                	jmp    800da9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dbf:	0f b6 c1             	movzbl %cl,%eax
  800dc2:	0f b6 db             	movzbl %bl,%ebx
  800dc5:	29 d8                	sub    %ebx,%eax
  800dc7:	eb 05                	jmp    800dce <memcmp+0x35>
	}

	return 0;
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de0:	39 d0                	cmp    %edx,%eax
  800de2:	73 09                	jae    800ded <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de4:	38 08                	cmp    %cl,(%eax)
  800de6:	74 05                	je     800ded <memfind+0x1b>
	for (; s < ends; s++)
  800de8:	83 c0 01             	add    $0x1,%eax
  800deb:	eb f3                	jmp    800de0 <memfind+0xe>
			break;
	return (void *) s;
}
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfb:	eb 03                	jmp    800e00 <strtol+0x11>
		s++;
  800dfd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e00:	0f b6 01             	movzbl (%ecx),%eax
  800e03:	3c 20                	cmp    $0x20,%al
  800e05:	74 f6                	je     800dfd <strtol+0xe>
  800e07:	3c 09                	cmp    $0x9,%al
  800e09:	74 f2                	je     800dfd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e0b:	3c 2b                	cmp    $0x2b,%al
  800e0d:	74 2a                	je     800e39 <strtol+0x4a>
	int neg = 0;
  800e0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e14:	3c 2d                	cmp    $0x2d,%al
  800e16:	74 2b                	je     800e43 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e1e:	75 0f                	jne    800e2f <strtol+0x40>
  800e20:	80 39 30             	cmpb   $0x30,(%ecx)
  800e23:	74 28                	je     800e4d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2c:	0f 44 d8             	cmove  %eax,%ebx
  800e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e37:	eb 50                	jmp    800e89 <strtol+0x9a>
		s++;
  800e39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800e41:	eb d5                	jmp    800e18 <strtol+0x29>
		s++, neg = 1;
  800e43:	83 c1 01             	add    $0x1,%ecx
  800e46:	bf 01 00 00 00       	mov    $0x1,%edi
  800e4b:	eb cb                	jmp    800e18 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e51:	74 0e                	je     800e61 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	75 d8                	jne    800e2f <strtol+0x40>
		s++, base = 8;
  800e57:	83 c1 01             	add    $0x1,%ecx
  800e5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e5f:	eb ce                	jmp    800e2f <strtol+0x40>
		s += 2, base = 16;
  800e61:	83 c1 02             	add    $0x2,%ecx
  800e64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e69:	eb c4                	jmp    800e2f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e6b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e6e:	89 f3                	mov    %esi,%ebx
  800e70:	80 fb 19             	cmp    $0x19,%bl
  800e73:	77 29                	ja     800e9e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e75:	0f be d2             	movsbl %dl,%edx
  800e78:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e7e:	7d 30                	jge    800eb0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e80:	83 c1 01             	add    $0x1,%ecx
  800e83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e89:	0f b6 11             	movzbl (%ecx),%edx
  800e8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e8f:	89 f3                	mov    %esi,%ebx
  800e91:	80 fb 09             	cmp    $0x9,%bl
  800e94:	77 d5                	ja     800e6b <strtol+0x7c>
			dig = *s - '0';
  800e96:	0f be d2             	movsbl %dl,%edx
  800e99:	83 ea 30             	sub    $0x30,%edx
  800e9c:	eb dd                	jmp    800e7b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea1:	89 f3                	mov    %esi,%ebx
  800ea3:	80 fb 19             	cmp    $0x19,%bl
  800ea6:	77 08                	ja     800eb0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea8:	0f be d2             	movsbl %dl,%edx
  800eab:	83 ea 37             	sub    $0x37,%edx
  800eae:	eb cb                	jmp    800e7b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb4:	74 05                	je     800ebb <strtol+0xcc>
		*endptr = (char *) s;
  800eb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	f7 da                	neg    %edx
  800ebf:	85 ff                	test   %edi,%edi
  800ec1:	0f 45 c2             	cmovne %edx,%eax
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	89 c3                	mov    %eax,%ebx
  800edc:	89 c7                	mov    %eax,%edi
  800ede:	89 c6                	mov    %eax,%esi
  800ee0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    

00800ee7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef7:	89 d1                	mov    %edx,%ecx
  800ef9:	89 d3                	mov    %edx,%ebx
  800efb:	89 d7                	mov    %edx,%edi
  800efd:	89 d6                	mov    %edx,%esi
  800eff:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	b8 03 00 00 00       	mov    $0x3,%eax
  800f1c:	89 cb                	mov    %ecx,%ebx
  800f1e:	89 cf                	mov    %ecx,%edi
  800f20:	89 ce                	mov    %ecx,%esi
  800f22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7f 08                	jg     800f30 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	50                   	push   %eax
  800f34:	6a 03                	push   $0x3
  800f36:	68 88 31 80 00       	push   $0x803188
  800f3b:	6a 43                	push   $0x43
  800f3d:	68 a5 31 80 00       	push   $0x8031a5
  800f42:	e8 f7 f3 ff ff       	call   80033e <_panic>

00800f47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f52:	b8 02 00 00 00       	mov    $0x2,%eax
  800f57:	89 d1                	mov    %edx,%ecx
  800f59:	89 d3                	mov    %edx,%ebx
  800f5b:	89 d7                	mov    %edx,%edi
  800f5d:	89 d6                	mov    %edx,%esi
  800f5f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <sys_yield>:

void
sys_yield(void)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f71:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f76:	89 d1                	mov    %edx,%ecx
  800f78:	89 d3                	mov    %edx,%ebx
  800f7a:	89 d7                	mov    %edx,%edi
  800f7c:	89 d6                	mov    %edx,%esi
  800f7e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8e:	be 00 00 00 00       	mov    $0x0,%esi
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	b8 04 00 00 00       	mov    $0x4,%eax
  800f9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fa1:	89 f7                	mov    %esi,%edi
  800fa3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	7f 08                	jg     800fb1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	50                   	push   %eax
  800fb5:	6a 04                	push   $0x4
  800fb7:	68 88 31 80 00       	push   $0x803188
  800fbc:	6a 43                	push   $0x43
  800fbe:	68 a5 31 80 00       	push   $0x8031a5
  800fc3:	e8 76 f3 ff ff       	call   80033e <_panic>

00800fc8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
  800fce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	b8 05 00 00 00       	mov    $0x5,%eax
  800fdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe2:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	7f 08                	jg     800ff3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	50                   	push   %eax
  800ff7:	6a 05                	push   $0x5
  800ff9:	68 88 31 80 00       	push   $0x803188
  800ffe:	6a 43                	push   $0x43
  801000:	68 a5 31 80 00       	push   $0x8031a5
  801005:	e8 34 f3 ff ff       	call   80033e <_panic>

0080100a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
  801010:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801013:	bb 00 00 00 00       	mov    $0x0,%ebx
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101e:	b8 06 00 00 00       	mov    $0x6,%eax
  801023:	89 df                	mov    %ebx,%edi
  801025:	89 de                	mov    %ebx,%esi
  801027:	cd 30                	int    $0x30
	if(check && ret > 0)
  801029:	85 c0                	test   %eax,%eax
  80102b:	7f 08                	jg     801035 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	50                   	push   %eax
  801039:	6a 06                	push   $0x6
  80103b:	68 88 31 80 00       	push   $0x803188
  801040:	6a 43                	push   $0x43
  801042:	68 a5 31 80 00       	push   $0x8031a5
  801047:	e8 f2 f2 ff ff       	call   80033e <_panic>

0080104c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
  801052:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801055:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	b8 08 00 00 00       	mov    $0x8,%eax
  801065:	89 df                	mov    %ebx,%edi
  801067:	89 de                	mov    %ebx,%esi
  801069:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106b:	85 c0                	test   %eax,%eax
  80106d:	7f 08                	jg     801077 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80106f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	50                   	push   %eax
  80107b:	6a 08                	push   $0x8
  80107d:	68 88 31 80 00       	push   $0x803188
  801082:	6a 43                	push   $0x43
  801084:	68 a5 31 80 00       	push   $0x8031a5
  801089:	e8 b0 f2 ff ff       	call   80033e <_panic>

0080108e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
  801094:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a7:	89 df                	mov    %ebx,%edi
  8010a9:	89 de                	mov    %ebx,%esi
  8010ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	7f 08                	jg     8010b9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	50                   	push   %eax
  8010bd:	6a 09                	push   $0x9
  8010bf:	68 88 31 80 00       	push   $0x803188
  8010c4:	6a 43                	push   $0x43
  8010c6:	68 a5 31 80 00       	push   $0x8031a5
  8010cb:	e8 6e f2 ff ff       	call   80033e <_panic>

008010d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e9:	89 df                	mov    %ebx,%edi
  8010eb:	89 de                	mov    %ebx,%esi
  8010ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	7f 08                	jg     8010fb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f6:	5b                   	pop    %ebx
  8010f7:	5e                   	pop    %esi
  8010f8:	5f                   	pop    %edi
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	50                   	push   %eax
  8010ff:	6a 0a                	push   $0xa
  801101:	68 88 31 80 00       	push   $0x803188
  801106:	6a 43                	push   $0x43
  801108:	68 a5 31 80 00       	push   $0x8031a5
  80110d:	e8 2c f2 ff ff       	call   80033e <_panic>

00801112 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
	asm volatile("int %1\n"
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801123:	be 00 00 00 00       	mov    $0x0,%esi
  801128:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80112e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	b8 0d 00 00 00       	mov    $0xd,%eax
  80114b:	89 cb                	mov    %ecx,%ebx
  80114d:	89 cf                	mov    %ecx,%edi
  80114f:	89 ce                	mov    %ecx,%esi
  801151:	cd 30                	int    $0x30
	if(check && ret > 0)
  801153:	85 c0                	test   %eax,%eax
  801155:	7f 08                	jg     80115f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801157:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	5f                   	pop    %edi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	50                   	push   %eax
  801163:	6a 0d                	push   $0xd
  801165:	68 88 31 80 00       	push   $0x803188
  80116a:	6a 43                	push   $0x43
  80116c:	68 a5 31 80 00       	push   $0x8031a5
  801171:	e8 c8 f1 ff ff       	call   80033e <_panic>

00801176 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	57                   	push   %edi
  80117a:	56                   	push   %esi
  80117b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80117c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	b8 0e 00 00 00       	mov    $0xe,%eax
  80118c:	89 df                	mov    %ebx,%edi
  80118e:	89 de                	mov    %ebx,%esi
  801190:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80119d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011aa:	89 cb                	mov    %ecx,%ebx
  8011ac:	89 cf                	mov    %ecx,%edi
  8011ae:	89 ce                	mov    %ecx,%esi
  8011b0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011b2:	5b                   	pop    %ebx
  8011b3:	5e                   	pop    %esi
  8011b4:	5f                   	pop    %edi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	57                   	push   %edi
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8011c7:	89 d1                	mov    %edx,%ecx
  8011c9:	89 d3                	mov    %edx,%ebx
  8011cb:	89 d7                	mov    %edx,%edi
  8011cd:	89 d6                	mov    %edx,%esi
  8011cf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	57                   	push   %edi
  8011da:	56                   	push   %esi
  8011db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e7:	b8 11 00 00 00       	mov    $0x11,%eax
  8011ec:	89 df                	mov    %ebx,%edi
  8011ee:	89 de                	mov    %ebx,%esi
  8011f0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5f                   	pop    %edi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801202:	8b 55 08             	mov    0x8(%ebp),%edx
  801205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801208:	b8 12 00 00 00       	mov    $0x12,%eax
  80120d:	89 df                	mov    %ebx,%edi
  80120f:	89 de                	mov    %ebx,%esi
  801211:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122c:	b8 13 00 00 00       	mov    $0x13,%eax
  801231:	89 df                	mov    %ebx,%edi
  801233:	89 de                	mov    %ebx,%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 13                	push   $0x13
  801249:	68 88 31 80 00       	push   $0x803188
  80124e:	6a 43                	push   $0x43
  801250:	68 a5 31 80 00       	push   $0x8031a5
  801255:	e8 e4 f0 ff ff       	call   80033e <_panic>

0080125a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801261:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801268:	f6 c5 04             	test   $0x4,%ch
  80126b:	75 45                	jne    8012b2 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80126d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801274:	83 e1 07             	and    $0x7,%ecx
  801277:	83 f9 07             	cmp    $0x7,%ecx
  80127a:	74 6f                	je     8012eb <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80127c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801283:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801289:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80128f:	0f 84 b6 00 00 00    	je     80134b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801295:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80129c:	83 e1 05             	and    $0x5,%ecx
  80129f:	83 f9 05             	cmp    $0x5,%ecx
  8012a2:	0f 84 d7 00 00 00    	je     80137f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012b2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012b9:	c1 e2 0c             	shl    $0xc,%edx
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012c5:	51                   	push   %ecx
  8012c6:	52                   	push   %edx
  8012c7:	50                   	push   %eax
  8012c8:	52                   	push   %edx
  8012c9:	6a 00                	push   $0x0
  8012cb:	e8 f8 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  8012d0:	83 c4 20             	add    $0x20,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	79 d1                	jns    8012a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	68 b3 31 80 00       	push   $0x8031b3
  8012df:	6a 54                	push   $0x54
  8012e1:	68 c9 31 80 00       	push   $0x8031c9
  8012e6:	e8 53 f0 ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012eb:	89 d3                	mov    %edx,%ebx
  8012ed:	c1 e3 0c             	shl    $0xc,%ebx
  8012f0:	83 ec 0c             	sub    $0xc,%esp
  8012f3:	68 05 08 00 00       	push   $0x805
  8012f8:	53                   	push   %ebx
  8012f9:	50                   	push   %eax
  8012fa:	53                   	push   %ebx
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 c6 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801302:	83 c4 20             	add    $0x20,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 2e                	js     801337 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	68 05 08 00 00       	push   $0x805
  801311:	53                   	push   %ebx
  801312:	6a 00                	push   $0x0
  801314:	53                   	push   %ebx
  801315:	6a 00                	push   $0x0
  801317:	e8 ac fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  80131c:	83 c4 20             	add    $0x20,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	79 85                	jns    8012a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	68 b3 31 80 00       	push   $0x8031b3
  80132b:	6a 5f                	push   $0x5f
  80132d:	68 c9 31 80 00       	push   $0x8031c9
  801332:	e8 07 f0 ff ff       	call   80033e <_panic>
			panic("sys_page_map() panic\n");
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	68 b3 31 80 00       	push   $0x8031b3
  80133f:	6a 5b                	push   $0x5b
  801341:	68 c9 31 80 00       	push   $0x8031c9
  801346:	e8 f3 ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80134b:	c1 e2 0c             	shl    $0xc,%edx
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	68 05 08 00 00       	push   $0x805
  801356:	52                   	push   %edx
  801357:	50                   	push   %eax
  801358:	52                   	push   %edx
  801359:	6a 00                	push   $0x0
  80135b:	e8 68 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801360:	83 c4 20             	add    $0x20,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	0f 89 3d ff ff ff    	jns    8012a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	68 b3 31 80 00       	push   $0x8031b3
  801373:	6a 66                	push   $0x66
  801375:	68 c9 31 80 00       	push   $0x8031c9
  80137a:	e8 bf ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80137f:	c1 e2 0c             	shl    $0xc,%edx
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	6a 05                	push   $0x5
  801387:	52                   	push   %edx
  801388:	50                   	push   %eax
  801389:	52                   	push   %edx
  80138a:	6a 00                	push   $0x0
  80138c:	e8 37 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801391:	83 c4 20             	add    $0x20,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	0f 89 0c ff ff ff    	jns    8012a8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 b3 31 80 00       	push   $0x8031b3
  8013a4:	6a 6d                	push   $0x6d
  8013a6:	68 c9 31 80 00       	push   $0x8031c9
  8013ab:	e8 8e ef ff ff       	call   80033e <_panic>

008013b0 <pgfault>:
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013ba:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013bc:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013c0:	0f 84 99 00 00 00    	je     80145f <pgfault+0xaf>
  8013c6:	89 c2                	mov    %eax,%edx
  8013c8:	c1 ea 16             	shr    $0x16,%edx
  8013cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d2:	f6 c2 01             	test   $0x1,%dl
  8013d5:	0f 84 84 00 00 00    	je     80145f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013db:	89 c2                	mov    %eax,%edx
  8013dd:	c1 ea 0c             	shr    $0xc,%edx
  8013e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e7:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013ed:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013f3:	75 6a                	jne    80145f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013fa:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	6a 07                	push   $0x7
  801401:	68 00 f0 7f 00       	push   $0x7ff000
  801406:	6a 00                	push   $0x0
  801408:	e8 78 fb ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 5f                	js     801473 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	68 00 10 00 00       	push   $0x1000
  80141c:	53                   	push   %ebx
  80141d:	68 00 f0 7f 00       	push   $0x7ff000
  801422:	e8 5c f9 ff ff       	call   800d83 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801427:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80142e:	53                   	push   %ebx
  80142f:	6a 00                	push   $0x0
  801431:	68 00 f0 7f 00       	push   $0x7ff000
  801436:	6a 00                	push   $0x0
  801438:	e8 8b fb ff ff       	call   800fc8 <sys_page_map>
	if(ret < 0)
  80143d:	83 c4 20             	add    $0x20,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	78 43                	js     801487 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801444:	83 ec 08             	sub    $0x8,%esp
  801447:	68 00 f0 7f 00       	push   $0x7ff000
  80144c:	6a 00                	push   $0x0
  80144e:	e8 b7 fb ff ff       	call   80100a <sys_page_unmap>
	if(ret < 0)
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 41                	js     80149b <pgfault+0xeb>
}
  80145a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	68 d4 31 80 00       	push   $0x8031d4
  801467:	6a 26                	push   $0x26
  801469:	68 c9 31 80 00       	push   $0x8031c9
  80146e:	e8 cb ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_alloc()\n");
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 e8 31 80 00       	push   $0x8031e8
  80147b:	6a 31                	push   $0x31
  80147d:	68 c9 31 80 00       	push   $0x8031c9
  801482:	e8 b7 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_map()\n");
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	68 03 32 80 00       	push   $0x803203
  80148f:	6a 36                	push   $0x36
  801491:	68 c9 31 80 00       	push   $0x8031c9
  801496:	e8 a3 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_unmap()\n");
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	68 1c 32 80 00       	push   $0x80321c
  8014a3:	6a 39                	push   $0x39
  8014a5:	68 c9 31 80 00       	push   $0x8031c9
  8014aa:	e8 8f ee ff ff       	call   80033e <_panic>

008014af <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	57                   	push   %edi
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
  8014b5:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014b8:	68 b0 13 80 00       	push   $0x8013b0
  8014bd:	e8 d5 13 00 00       	call   802897 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8014c7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 27                	js     8014f7 <fork+0x48>
  8014d0:	89 c6                	mov    %eax,%esi
  8014d2:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014d4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014d9:	75 48                	jne    801523 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014db:	e8 67 fa ff ff       	call   800f47 <sys_getenvid>
  8014e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014e5:	c1 e0 07             	shl    $0x7,%eax
  8014e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014ed:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014f2:	e9 90 00 00 00       	jmp    801587 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	68 38 32 80 00       	push   $0x803238
  8014ff:	68 8c 00 00 00       	push   $0x8c
  801504:	68 c9 31 80 00       	push   $0x8031c9
  801509:	e8 30 ee ff ff       	call   80033e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80150e:	89 f8                	mov    %edi,%eax
  801510:	e8 45 fd ff ff       	call   80125a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801515:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80151b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801521:	74 26                	je     801549 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801523:	89 d8                	mov    %ebx,%eax
  801525:	c1 e8 16             	shr    $0x16,%eax
  801528:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80152f:	a8 01                	test   $0x1,%al
  801531:	74 e2                	je     801515 <fork+0x66>
  801533:	89 da                	mov    %ebx,%edx
  801535:	c1 ea 0c             	shr    $0xc,%edx
  801538:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80153f:	83 e0 05             	and    $0x5,%eax
  801542:	83 f8 05             	cmp    $0x5,%eax
  801545:	75 ce                	jne    801515 <fork+0x66>
  801547:	eb c5                	jmp    80150e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	6a 07                	push   $0x7
  80154e:	68 00 f0 bf ee       	push   $0xeebff000
  801553:	56                   	push   %esi
  801554:	e8 2c fa ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 31                	js     801591 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	68 06 29 80 00       	push   $0x802906
  801568:	56                   	push   %esi
  801569:	e8 62 fb ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	85 c0                	test   %eax,%eax
  801573:	78 33                	js     8015a8 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801575:	83 ec 08             	sub    $0x8,%esp
  801578:	6a 02                	push   $0x2
  80157a:	56                   	push   %esi
  80157b:	e8 cc fa ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 38                	js     8015bf <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801587:	89 f0                	mov    %esi,%eax
  801589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 e8 31 80 00       	push   $0x8031e8
  801599:	68 98 00 00 00       	push   $0x98
  80159e:	68 c9 31 80 00       	push   $0x8031c9
  8015a3:	e8 96 ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	68 5c 32 80 00       	push   $0x80325c
  8015b0:	68 9b 00 00 00       	push   $0x9b
  8015b5:	68 c9 31 80 00       	push   $0x8031c9
  8015ba:	e8 7f ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 84 32 80 00       	push   $0x803284
  8015c7:	68 9e 00 00 00       	push   $0x9e
  8015cc:	68 c9 31 80 00       	push   $0x8031c9
  8015d1:	e8 68 ed ff ff       	call   80033e <_panic>

008015d6 <sfork>:

// Challenge!
int
sfork(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	57                   	push   %edi
  8015da:	56                   	push   %esi
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015df:	68 b0 13 80 00       	push   $0x8013b0
  8015e4:	e8 ae 12 00 00       	call   802897 <set_pgfault_handler>
  8015e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8015ee:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 27                	js     80161e <sfork+0x48>
  8015f7:	89 c7                	mov    %eax,%edi
  8015f9:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015fb:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801600:	75 55                	jne    801657 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801602:	e8 40 f9 ff ff       	call   800f47 <sys_getenvid>
  801607:	25 ff 03 00 00       	and    $0x3ff,%eax
  80160c:	c1 e0 07             	shl    $0x7,%eax
  80160f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801614:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801619:	e9 d4 00 00 00       	jmp    8016f2 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 38 32 80 00       	push   $0x803238
  801626:	68 af 00 00 00       	push   $0xaf
  80162b:	68 c9 31 80 00       	push   $0x8031c9
  801630:	e8 09 ed ff ff       	call   80033e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801635:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80163a:	89 f0                	mov    %esi,%eax
  80163c:	e8 19 fc ff ff       	call   80125a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801647:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80164d:	77 65                	ja     8016b4 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80164f:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801655:	74 de                	je     801635 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801657:	89 d8                	mov    %ebx,%eax
  801659:	c1 e8 16             	shr    $0x16,%eax
  80165c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801663:	a8 01                	test   $0x1,%al
  801665:	74 da                	je     801641 <sfork+0x6b>
  801667:	89 da                	mov    %ebx,%edx
  801669:	c1 ea 0c             	shr    $0xc,%edx
  80166c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801673:	83 e0 05             	and    $0x5,%eax
  801676:	83 f8 05             	cmp    $0x5,%eax
  801679:	75 c6                	jne    801641 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80167b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801682:	c1 e2 0c             	shl    $0xc,%edx
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	83 e0 07             	and    $0x7,%eax
  80168b:	50                   	push   %eax
  80168c:	52                   	push   %edx
  80168d:	56                   	push   %esi
  80168e:	52                   	push   %edx
  80168f:	6a 00                	push   $0x0
  801691:	e8 32 f9 ff ff       	call   800fc8 <sys_page_map>
  801696:	83 c4 20             	add    $0x20,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	74 a4                	je     801641 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	68 b3 31 80 00       	push   $0x8031b3
  8016a5:	68 ba 00 00 00       	push   $0xba
  8016aa:	68 c9 31 80 00       	push   $0x8031c9
  8016af:	e8 8a ec ff ff       	call   80033e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	6a 07                	push   $0x7
  8016b9:	68 00 f0 bf ee       	push   $0xeebff000
  8016be:	57                   	push   %edi
  8016bf:	e8 c1 f8 ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 31                	js     8016fc <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	68 06 29 80 00       	push   $0x802906
  8016d3:	57                   	push   %edi
  8016d4:	e8 f7 f9 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 33                	js     801713 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	6a 02                	push   $0x2
  8016e5:	57                   	push   %edi
  8016e6:	e8 61 f9 ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 38                	js     80172a <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016f2:	89 f8                	mov    %edi,%eax
  8016f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 e8 31 80 00       	push   $0x8031e8
  801704:	68 c0 00 00 00       	push   $0xc0
  801709:	68 c9 31 80 00       	push   $0x8031c9
  80170e:	e8 2b ec ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	68 5c 32 80 00       	push   $0x80325c
  80171b:	68 c3 00 00 00       	push   $0xc3
  801720:	68 c9 31 80 00       	push   $0x8031c9
  801725:	e8 14 ec ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	68 84 32 80 00       	push   $0x803284
  801732:	68 c6 00 00 00       	push   $0xc6
  801737:	68 c9 31 80 00       	push   $0x8031c9
  80173c:	e8 fd eb ff ff       	call   80033e <_panic>

00801741 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	05 00 00 00 30       	add    $0x30000000,%eax
  80174c:	c1 e8 0c             	shr    $0xc,%eax
}
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    

00801751 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801770:	89 c2                	mov    %eax,%edx
  801772:	c1 ea 16             	shr    $0x16,%edx
  801775:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80177c:	f6 c2 01             	test   $0x1,%dl
  80177f:	74 2d                	je     8017ae <fd_alloc+0x46>
  801781:	89 c2                	mov    %eax,%edx
  801783:	c1 ea 0c             	shr    $0xc,%edx
  801786:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80178d:	f6 c2 01             	test   $0x1,%dl
  801790:	74 1c                	je     8017ae <fd_alloc+0x46>
  801792:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801797:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80179c:	75 d2                	jne    801770 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017a7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017ac:	eb 0a                	jmp    8017b8 <fd_alloc+0x50>
			*fd_store = fd;
  8017ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017c0:	83 f8 1f             	cmp    $0x1f,%eax
  8017c3:	77 30                	ja     8017f5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017c5:	c1 e0 0c             	shl    $0xc,%eax
  8017c8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017cd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017d3:	f6 c2 01             	test   $0x1,%dl
  8017d6:	74 24                	je     8017fc <fd_lookup+0x42>
  8017d8:	89 c2                	mov    %eax,%edx
  8017da:	c1 ea 0c             	shr    $0xc,%edx
  8017dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017e4:	f6 c2 01             	test   $0x1,%dl
  8017e7:	74 1a                	je     801803 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	89 02                	mov    %eax,(%edx)
	return 0;
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    
		return -E_INVAL;
  8017f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fa:	eb f7                	jmp    8017f3 <fd_lookup+0x39>
		return -E_INVAL;
  8017fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801801:	eb f0                	jmp    8017f3 <fd_lookup+0x39>
  801803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801808:	eb e9                	jmp    8017f3 <fd_lookup+0x39>

0080180a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80181d:	39 08                	cmp    %ecx,(%eax)
  80181f:	74 38                	je     801859 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801821:	83 c2 01             	add    $0x1,%edx
  801824:	8b 04 95 20 33 80 00 	mov    0x803320(,%edx,4),%eax
  80182b:	85 c0                	test   %eax,%eax
  80182d:	75 ee                	jne    80181d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80182f:	a1 08 50 80 00       	mov    0x805008,%eax
  801834:	8b 40 48             	mov    0x48(%eax),%eax
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	51                   	push   %ecx
  80183b:	50                   	push   %eax
  80183c:	68 a4 32 80 00       	push   $0x8032a4
  801841:	e8 ee eb ff ff       	call   800434 <cprintf>
	*dev = 0;
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    
			*dev = devtab[i];
  801859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	eb f2                	jmp    801857 <dev_lookup+0x4d>

00801865 <fd_close>:
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	57                   	push   %edi
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 24             	sub    $0x24,%esp
  80186e:	8b 75 08             	mov    0x8(%ebp),%esi
  801871:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801874:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801877:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801878:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80187e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801881:	50                   	push   %eax
  801882:	e8 33 ff ff ff       	call   8017ba <fd_lookup>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 05                	js     801895 <fd_close+0x30>
	    || fd != fd2)
  801890:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801893:	74 16                	je     8018ab <fd_close+0x46>
		return (must_exist ? r : 0);
  801895:	89 f8                	mov    %edi,%eax
  801897:	84 c0                	test   %al,%al
  801899:	b8 00 00 00 00       	mov    $0x0,%eax
  80189e:	0f 44 d8             	cmove  %eax,%ebx
}
  8018a1:	89 d8                	mov    %ebx,%eax
  8018a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5f                   	pop    %edi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018b1:	50                   	push   %eax
  8018b2:	ff 36                	pushl  (%esi)
  8018b4:	e8 51 ff ff ff       	call   80180a <dev_lookup>
  8018b9:	89 c3                	mov    %eax,%ebx
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 1a                	js     8018dc <fd_close+0x77>
		if (dev->dev_close)
  8018c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	74 0b                	je     8018dc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018d1:	83 ec 0c             	sub    $0xc,%esp
  8018d4:	56                   	push   %esi
  8018d5:	ff d0                	call   *%eax
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	56                   	push   %esi
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 23 f7 ff ff       	call   80100a <sys_page_unmap>
	return r;
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	eb b5                	jmp    8018a1 <fd_close+0x3c>

008018ec <close>:

int
close(int fdnum)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	e8 bc fe ff ff       	call   8017ba <fd_lookup>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 c0                	test   %eax,%eax
  801903:	79 02                	jns    801907 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    
		return fd_close(fd, 1);
  801907:	83 ec 08             	sub    $0x8,%esp
  80190a:	6a 01                	push   $0x1
  80190c:	ff 75 f4             	pushl  -0xc(%ebp)
  80190f:	e8 51 ff ff ff       	call   801865 <fd_close>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	eb ec                	jmp    801905 <close+0x19>

00801919 <close_all>:

void
close_all(void)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
  80191d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801920:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	53                   	push   %ebx
  801929:	e8 be ff ff ff       	call   8018ec <close>
	for (i = 0; i < MAXFD; i++)
  80192e:	83 c3 01             	add    $0x1,%ebx
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	83 fb 20             	cmp    $0x20,%ebx
  801937:	75 ec                	jne    801925 <close_all+0xc>
}
  801939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	57                   	push   %edi
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
  801944:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801947:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 67 fe ff ff       	call   8017ba <fd_lookup>
  801953:	89 c3                	mov    %eax,%ebx
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	0f 88 81 00 00 00    	js     8019e1 <dup+0xa3>
		return r;
	close(newfdnum);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	e8 81 ff ff ff       	call   8018ec <close>

	newfd = INDEX2FD(newfdnum);
  80196b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80196e:	c1 e6 0c             	shl    $0xc,%esi
  801971:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801977:	83 c4 04             	add    $0x4,%esp
  80197a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80197d:	e8 cf fd ff ff       	call   801751 <fd2data>
  801982:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801984:	89 34 24             	mov    %esi,(%esp)
  801987:	e8 c5 fd ff ff       	call   801751 <fd2data>
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801991:	89 d8                	mov    %ebx,%eax
  801993:	c1 e8 16             	shr    $0x16,%eax
  801996:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80199d:	a8 01                	test   $0x1,%al
  80199f:	74 11                	je     8019b2 <dup+0x74>
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	c1 e8 0c             	shr    $0xc,%eax
  8019a6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019ad:	f6 c2 01             	test   $0x1,%dl
  8019b0:	75 39                	jne    8019eb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019b5:	89 d0                	mov    %edx,%eax
  8019b7:	c1 e8 0c             	shr    $0xc,%eax
  8019ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019c9:	50                   	push   %eax
  8019ca:	56                   	push   %esi
  8019cb:	6a 00                	push   $0x0
  8019cd:	52                   	push   %edx
  8019ce:	6a 00                	push   $0x0
  8019d0:	e8 f3 f5 ff ff       	call   800fc8 <sys_page_map>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 20             	add    $0x20,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 31                	js     801a0f <dup+0xd1>
		goto err;

	return newfdnum;
  8019de:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019e1:	89 d8                	mov    %ebx,%eax
  8019e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e6:	5b                   	pop    %ebx
  8019e7:	5e                   	pop    %esi
  8019e8:	5f                   	pop    %edi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f2:	83 ec 0c             	sub    $0xc,%esp
  8019f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8019fa:	50                   	push   %eax
  8019fb:	57                   	push   %edi
  8019fc:	6a 00                	push   $0x0
  8019fe:	53                   	push   %ebx
  8019ff:	6a 00                	push   $0x0
  801a01:	e8 c2 f5 ff ff       	call   800fc8 <sys_page_map>
  801a06:	89 c3                	mov    %eax,%ebx
  801a08:	83 c4 20             	add    $0x20,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	79 a3                	jns    8019b2 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	56                   	push   %esi
  801a13:	6a 00                	push   $0x0
  801a15:	e8 f0 f5 ff ff       	call   80100a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a1a:	83 c4 08             	add    $0x8,%esp
  801a1d:	57                   	push   %edi
  801a1e:	6a 00                	push   $0x0
  801a20:	e8 e5 f5 ff ff       	call   80100a <sys_page_unmap>
	return r;
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	eb b7                	jmp    8019e1 <dup+0xa3>

00801a2a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 1c             	sub    $0x1c,%esp
  801a31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a34:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a37:	50                   	push   %eax
  801a38:	53                   	push   %ebx
  801a39:	e8 7c fd ff ff       	call   8017ba <fd_lookup>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 3f                	js     801a84 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a45:	83 ec 08             	sub    $0x8,%esp
  801a48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4b:	50                   	push   %eax
  801a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4f:	ff 30                	pushl  (%eax)
  801a51:	e8 b4 fd ff ff       	call   80180a <dev_lookup>
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	78 27                	js     801a84 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a60:	8b 42 08             	mov    0x8(%edx),%eax
  801a63:	83 e0 03             	and    $0x3,%eax
  801a66:	83 f8 01             	cmp    $0x1,%eax
  801a69:	74 1e                	je     801a89 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	8b 40 08             	mov    0x8(%eax),%eax
  801a71:	85 c0                	test   %eax,%eax
  801a73:	74 35                	je     801aaa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	ff 75 10             	pushl  0x10(%ebp)
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	52                   	push   %edx
  801a7f:	ff d0                	call   *%eax
  801a81:	83 c4 10             	add    $0x10,%esp
}
  801a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a89:	a1 08 50 80 00       	mov    0x805008,%eax
  801a8e:	8b 40 48             	mov    0x48(%eax),%eax
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	53                   	push   %ebx
  801a95:	50                   	push   %eax
  801a96:	68 e5 32 80 00       	push   $0x8032e5
  801a9b:	e8 94 e9 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa8:	eb da                	jmp    801a84 <read+0x5a>
		return -E_NOT_SUPP;
  801aaa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aaf:	eb d3                	jmp    801a84 <read+0x5a>

00801ab1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	57                   	push   %edi
  801ab5:	56                   	push   %esi
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 0c             	sub    $0xc,%esp
  801aba:	8b 7d 08             	mov    0x8(%ebp),%edi
  801abd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ac0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac5:	39 f3                	cmp    %esi,%ebx
  801ac7:	73 23                	jae    801aec <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	89 f0                	mov    %esi,%eax
  801ace:	29 d8                	sub    %ebx,%eax
  801ad0:	50                   	push   %eax
  801ad1:	89 d8                	mov    %ebx,%eax
  801ad3:	03 45 0c             	add    0xc(%ebp),%eax
  801ad6:	50                   	push   %eax
  801ad7:	57                   	push   %edi
  801ad8:	e8 4d ff ff ff       	call   801a2a <read>
		if (m < 0)
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 06                	js     801aea <readn+0x39>
			return m;
		if (m == 0)
  801ae4:	74 06                	je     801aec <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ae6:	01 c3                	add    %eax,%ebx
  801ae8:	eb db                	jmp    801ac5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aea:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	53                   	push   %ebx
  801afa:	83 ec 1c             	sub    $0x1c,%esp
  801afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b03:	50                   	push   %eax
  801b04:	53                   	push   %ebx
  801b05:	e8 b0 fc ff ff       	call   8017ba <fd_lookup>
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 3a                	js     801b4b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b17:	50                   	push   %eax
  801b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1b:	ff 30                	pushl  (%eax)
  801b1d:	e8 e8 fc ff ff       	call   80180a <dev_lookup>
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 22                	js     801b4b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b30:	74 1e                	je     801b50 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b35:	8b 52 0c             	mov    0xc(%edx),%edx
  801b38:	85 d2                	test   %edx,%edx
  801b3a:	74 35                	je     801b71 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	ff 75 10             	pushl  0x10(%ebp)
  801b42:	ff 75 0c             	pushl  0xc(%ebp)
  801b45:	50                   	push   %eax
  801b46:	ff d2                	call   *%edx
  801b48:	83 c4 10             	add    $0x10,%esp
}
  801b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b50:	a1 08 50 80 00       	mov    0x805008,%eax
  801b55:	8b 40 48             	mov    0x48(%eax),%eax
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	53                   	push   %ebx
  801b5c:	50                   	push   %eax
  801b5d:	68 01 33 80 00       	push   $0x803301
  801b62:	e8 cd e8 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6f:	eb da                	jmp    801b4b <write+0x55>
		return -E_NOT_SUPP;
  801b71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b76:	eb d3                	jmp    801b4b <write+0x55>

00801b78 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b81:	50                   	push   %eax
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	e8 30 fc ff ff       	call   8017ba <fd_lookup>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 0e                	js     801b9f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b97:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 1c             	sub    $0x1c,%esp
  801ba8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bae:	50                   	push   %eax
  801baf:	53                   	push   %ebx
  801bb0:	e8 05 fc ff ff       	call   8017ba <fd_lookup>
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 37                	js     801bf3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc2:	50                   	push   %eax
  801bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc6:	ff 30                	pushl  (%eax)
  801bc8:	e8 3d fc ff ff       	call   80180a <dev_lookup>
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	78 1f                	js     801bf3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bdb:	74 1b                	je     801bf8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be0:	8b 52 18             	mov    0x18(%edx),%edx
  801be3:	85 d2                	test   %edx,%edx
  801be5:	74 32                	je     801c19 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	50                   	push   %eax
  801bee:	ff d2                	call   *%edx
  801bf0:	83 c4 10             	add    $0x10,%esp
}
  801bf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bf8:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bfd:	8b 40 48             	mov    0x48(%eax),%eax
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	53                   	push   %ebx
  801c04:	50                   	push   %eax
  801c05:	68 c4 32 80 00       	push   $0x8032c4
  801c0a:	e8 25 e8 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c17:	eb da                	jmp    801bf3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c1e:	eb d3                	jmp    801bf3 <ftruncate+0x52>

00801c20 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 1c             	sub    $0x1c,%esp
  801c27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c2d:	50                   	push   %eax
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	e8 84 fb ff ff       	call   8017ba <fd_lookup>
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	78 4b                	js     801c88 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c47:	ff 30                	pushl  (%eax)
  801c49:	e8 bc fb ff ff       	call   80180a <dev_lookup>
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 33                	js     801c88 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c5c:	74 2f                	je     801c8d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c5e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c61:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c68:	00 00 00 
	stat->st_isdir = 0;
  801c6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c72:	00 00 00 
	stat->st_dev = dev;
  801c75:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c7b:	83 ec 08             	sub    $0x8,%esp
  801c7e:	53                   	push   %ebx
  801c7f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c82:	ff 50 14             	call   *0x14(%eax)
  801c85:	83 c4 10             	add    $0x10,%esp
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    
		return -E_NOT_SUPP;
  801c8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c92:	eb f4                	jmp    801c88 <fstat+0x68>

00801c94 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	56                   	push   %esi
  801c98:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c99:	83 ec 08             	sub    $0x8,%esp
  801c9c:	6a 00                	push   $0x0
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	e8 22 02 00 00       	call   801ec8 <open>
  801ca6:	89 c3                	mov    %eax,%ebx
  801ca8:	83 c4 10             	add    $0x10,%esp
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 1b                	js     801cca <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801caf:	83 ec 08             	sub    $0x8,%esp
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	50                   	push   %eax
  801cb6:	e8 65 ff ff ff       	call   801c20 <fstat>
  801cbb:	89 c6                	mov    %eax,%esi
	close(fd);
  801cbd:	89 1c 24             	mov    %ebx,(%esp)
  801cc0:	e8 27 fc ff ff       	call   8018ec <close>
	return r;
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	89 f3                	mov    %esi,%ebx
}
  801cca:	89 d8                	mov    %ebx,%eax
  801ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	89 c6                	mov    %eax,%esi
  801cda:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cdc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ce3:	74 27                	je     801d0c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ce5:	6a 07                	push   $0x7
  801ce7:	68 00 60 80 00       	push   $0x806000
  801cec:	56                   	push   %esi
  801ced:	ff 35 00 50 80 00    	pushl  0x805000
  801cf3:	e8 9d 0c 00 00       	call   802995 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cf8:	83 c4 0c             	add    $0xc,%esp
  801cfb:	6a 00                	push   $0x0
  801cfd:	53                   	push   %ebx
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 27 0c 00 00       	call   80292c <ipc_recv>
}
  801d05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5e                   	pop    %esi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	6a 01                	push   $0x1
  801d11:	e8 d7 0c 00 00       	call   8029ed <ipc_find_env>
  801d16:	a3 00 50 80 00       	mov    %eax,0x805000
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	eb c5                	jmp    801ce5 <fsipc+0x12>

00801d20 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d39:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d43:	e8 8b ff ff ff       	call   801cd3 <fsipc>
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <devfile_flush>:
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	8b 40 0c             	mov    0xc(%eax),%eax
  801d56:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d60:	b8 06 00 00 00       	mov    $0x6,%eax
  801d65:	e8 69 ff ff ff       	call   801cd3 <fsipc>
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <devfile_stat>:
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d81:	ba 00 00 00 00       	mov    $0x0,%edx
  801d86:	b8 05 00 00 00       	mov    $0x5,%eax
  801d8b:	e8 43 ff ff ff       	call   801cd3 <fsipc>
  801d90:	85 c0                	test   %eax,%eax
  801d92:	78 2c                	js     801dc0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	68 00 60 80 00       	push   $0x806000
  801d9c:	53                   	push   %ebx
  801d9d:	e8 f1 ed ff ff       	call   800b93 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801da2:	a1 80 60 80 00       	mov    0x806080,%eax
  801da7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dad:	a1 84 60 80 00       	mov    0x806084,%eax
  801db2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <devfile_write>:
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dda:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801de0:	53                   	push   %ebx
  801de1:	ff 75 0c             	pushl  0xc(%ebp)
  801de4:	68 08 60 80 00       	push   $0x806008
  801de9:	e8 95 ef ff ff       	call   800d83 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dee:	ba 00 00 00 00       	mov    $0x0,%edx
  801df3:	b8 04 00 00 00       	mov    $0x4,%eax
  801df8:	e8 d6 fe ff ff       	call   801cd3 <fsipc>
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 0b                	js     801e0f <devfile_write+0x4a>
	assert(r <= n);
  801e04:	39 d8                	cmp    %ebx,%eax
  801e06:	77 0c                	ja     801e14 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e08:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e0d:	7f 1e                	jg     801e2d <devfile_write+0x68>
}
  801e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    
	assert(r <= n);
  801e14:	68 34 33 80 00       	push   $0x803334
  801e19:	68 3b 33 80 00       	push   $0x80333b
  801e1e:	68 98 00 00 00       	push   $0x98
  801e23:	68 50 33 80 00       	push   $0x803350
  801e28:	e8 11 e5 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801e2d:	68 5b 33 80 00       	push   $0x80335b
  801e32:	68 3b 33 80 00       	push   $0x80333b
  801e37:	68 99 00 00 00       	push   $0x99
  801e3c:	68 50 33 80 00       	push   $0x803350
  801e41:	e8 f8 e4 ff ff       	call   80033e <_panic>

00801e46 <devfile_read>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	8b 40 0c             	mov    0xc(%eax),%eax
  801e54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e59:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e64:	b8 03 00 00 00       	mov    $0x3,%eax
  801e69:	e8 65 fe ff ff       	call   801cd3 <fsipc>
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 1f                	js     801e93 <devfile_read+0x4d>
	assert(r <= n);
  801e74:	39 f0                	cmp    %esi,%eax
  801e76:	77 24                	ja     801e9c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e7d:	7f 33                	jg     801eb2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	50                   	push   %eax
  801e83:	68 00 60 80 00       	push   $0x806000
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	e8 91 ee ff ff       	call   800d21 <memmove>
	return r;
  801e90:	83 c4 10             	add    $0x10,%esp
}
  801e93:	89 d8                	mov    %ebx,%eax
  801e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
	assert(r <= n);
  801e9c:	68 34 33 80 00       	push   $0x803334
  801ea1:	68 3b 33 80 00       	push   $0x80333b
  801ea6:	6a 7c                	push   $0x7c
  801ea8:	68 50 33 80 00       	push   $0x803350
  801ead:	e8 8c e4 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801eb2:	68 5b 33 80 00       	push   $0x80335b
  801eb7:	68 3b 33 80 00       	push   $0x80333b
  801ebc:	6a 7d                	push   $0x7d
  801ebe:	68 50 33 80 00       	push   $0x803350
  801ec3:	e8 76 e4 ff ff       	call   80033e <_panic>

00801ec8 <open>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 1c             	sub    $0x1c,%esp
  801ed0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ed3:	56                   	push   %esi
  801ed4:	e8 81 ec ff ff       	call   800b5a <strlen>
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ee1:	7f 6c                	jg     801f4f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee9:	50                   	push   %eax
  801eea:	e8 79 f8 ff ff       	call   801768 <fd_alloc>
  801eef:	89 c3                	mov    %eax,%ebx
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	78 3c                	js     801f34 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	56                   	push   %esi
  801efc:	68 00 60 80 00       	push   $0x806000
  801f01:	e8 8d ec ff ff       	call   800b93 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f09:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	b8 01 00 00 00       	mov    $0x1,%eax
  801f16:	e8 b8 fd ff ff       	call   801cd3 <fsipc>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	78 19                	js     801f3d <open+0x75>
	return fd2num(fd);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2a:	e8 12 f8 ff ff       	call   801741 <fd2num>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
}
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    
		fd_close(fd, 0);
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	6a 00                	push   $0x0
  801f42:	ff 75 f4             	pushl  -0xc(%ebp)
  801f45:	e8 1b f9 ff ff       	call   801865 <fd_close>
		return r;
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	eb e5                	jmp    801f34 <open+0x6c>
		return -E_BAD_PATH;
  801f4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f54:	eb de                	jmp    801f34 <open+0x6c>

00801f56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f61:	b8 08 00 00 00       	mov    $0x8,%eax
  801f66:	e8 68 fd ff ff       	call   801cd3 <fsipc>
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f73:	68 67 33 80 00       	push   $0x803367
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	e8 13 ec ff ff       	call   800b93 <strcpy>
	return 0;
}
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <devsock_close>:
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 10             	sub    $0x10,%esp
  801f8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f91:	53                   	push   %ebx
  801f92:	e8 91 0a 00 00       	call   802a28 <pageref>
  801f97:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f9a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f9f:	83 f8 01             	cmp    $0x1,%eax
  801fa2:	74 07                	je     801fab <devsock_close+0x24>
}
  801fa4:	89 d0                	mov    %edx,%eax
  801fa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	ff 73 0c             	pushl  0xc(%ebx)
  801fb1:	e8 b9 02 00 00       	call   80226f <nsipc_close>
  801fb6:	89 c2                	mov    %eax,%edx
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	eb e7                	jmp    801fa4 <devsock_close+0x1d>

00801fbd <devsock_write>:
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	ff 75 10             	pushl  0x10(%ebp)
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	ff 70 0c             	pushl  0xc(%eax)
  801fd1:	e8 76 03 00 00       	call   80234c <nsipc_send>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <devsock_read>:
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 10             	pushl  0x10(%ebp)
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	ff 70 0c             	pushl  0xc(%eax)
  801fec:	e8 ef 02 00 00       	call   8022e0 <nsipc_recv>
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <fd2sockid>:
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ff9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ffc:	52                   	push   %edx
  801ffd:	50                   	push   %eax
  801ffe:	e8 b7 f7 ff ff       	call   8017ba <fd_lookup>
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	85 c0                	test   %eax,%eax
  802008:	78 10                	js     80201a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802013:	39 08                	cmp    %ecx,(%eax)
  802015:	75 05                	jne    80201c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802017:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    
		return -E_NOT_SUPP;
  80201c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802021:	eb f7                	jmp    80201a <fd2sockid+0x27>

00802023 <alloc_sockfd>:
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 1c             	sub    $0x1c,%esp
  80202b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80202d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802030:	50                   	push   %eax
  802031:	e8 32 f7 ff ff       	call   801768 <fd_alloc>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 43                	js     802082 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	68 07 04 00 00       	push   $0x407
  802047:	ff 75 f4             	pushl  -0xc(%ebp)
  80204a:	6a 00                	push   $0x0
  80204c:	e8 34 ef ff ff       	call   800f85 <sys_page_alloc>
  802051:	89 c3                	mov    %eax,%ebx
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	85 c0                	test   %eax,%eax
  802058:	78 28                	js     802082 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802063:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80206f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	50                   	push   %eax
  802076:	e8 c6 f6 ff ff       	call   801741 <fd2num>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	eb 0c                	jmp    80208e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	56                   	push   %esi
  802086:	e8 e4 01 00 00       	call   80226f <nsipc_close>
		return r;
  80208b:	83 c4 10             	add    $0x10,%esp
}
  80208e:	89 d8                	mov    %ebx,%eax
  802090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5d                   	pop    %ebp
  802096:	c3                   	ret    

00802097 <accept>:
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	e8 4e ff ff ff       	call   801ff3 <fd2sockid>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 1b                	js     8020c4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	50                   	push   %eax
  8020b3:	e8 0e 01 00 00       	call   8021c6 <nsipc_accept>
  8020b8:	83 c4 10             	add    $0x10,%esp
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 05                	js     8020c4 <accept+0x2d>
	return alloc_sockfd(r);
  8020bf:	e8 5f ff ff ff       	call   802023 <alloc_sockfd>
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <bind>:
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	e8 1f ff ff ff       	call   801ff3 <fd2sockid>
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 12                	js     8020ea <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	ff 75 10             	pushl  0x10(%ebp)
  8020de:	ff 75 0c             	pushl  0xc(%ebp)
  8020e1:	50                   	push   %eax
  8020e2:	e8 31 01 00 00       	call   802218 <nsipc_bind>
  8020e7:	83 c4 10             	add    $0x10,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <shutdown>:
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	e8 f9 fe ff ff       	call   801ff3 <fd2sockid>
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 0f                	js     80210d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020fe:	83 ec 08             	sub    $0x8,%esp
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	e8 43 01 00 00       	call   80224d <nsipc_shutdown>
  80210a:	83 c4 10             	add    $0x10,%esp
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <connect>:
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	e8 d6 fe ff ff       	call   801ff3 <fd2sockid>
  80211d:	85 c0                	test   %eax,%eax
  80211f:	78 12                	js     802133 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	ff 75 10             	pushl  0x10(%ebp)
  802127:	ff 75 0c             	pushl  0xc(%ebp)
  80212a:	50                   	push   %eax
  80212b:	e8 59 01 00 00       	call   802289 <nsipc_connect>
  802130:	83 c4 10             	add    $0x10,%esp
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <listen>:
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	e8 b0 fe ff ff       	call   801ff3 <fd2sockid>
  802143:	85 c0                	test   %eax,%eax
  802145:	78 0f                	js     802156 <listen+0x21>
	return nsipc_listen(r, backlog);
  802147:	83 ec 08             	sub    $0x8,%esp
  80214a:	ff 75 0c             	pushl  0xc(%ebp)
  80214d:	50                   	push   %eax
  80214e:	e8 6b 01 00 00       	call   8022be <nsipc_listen>
  802153:	83 c4 10             	add    $0x10,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <socket>:

int
socket(int domain, int type, int protocol)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80215e:	ff 75 10             	pushl  0x10(%ebp)
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 3e 02 00 00       	call   8023aa <nsipc_socket>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 05                	js     802178 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802173:	e8 ab fe ff ff       	call   802023 <alloc_sockfd>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802183:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80218a:	74 26                	je     8021b2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80218c:	6a 07                	push   $0x7
  80218e:	68 00 70 80 00       	push   $0x807000
  802193:	53                   	push   %ebx
  802194:	ff 35 04 50 80 00    	pushl  0x805004
  80219a:	e8 f6 07 00 00       	call   802995 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80219f:	83 c4 0c             	add    $0xc,%esp
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	e8 7f 07 00 00       	call   80292c <ipc_recv>
}
  8021ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021b2:	83 ec 0c             	sub    $0xc,%esp
  8021b5:	6a 02                	push   $0x2
  8021b7:	e8 31 08 00 00       	call   8029ed <ipc_find_env>
  8021bc:	a3 04 50 80 00       	mov    %eax,0x805004
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	eb c6                	jmp    80218c <nsipc+0x12>

008021c6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	56                   	push   %esi
  8021ca:	53                   	push   %ebx
  8021cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021d6:	8b 06                	mov    (%esi),%eax
  8021d8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e2:	e8 93 ff ff ff       	call   80217a <nsipc>
  8021e7:	89 c3                	mov    %eax,%ebx
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	79 09                	jns    8021f6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021ed:	89 d8                	mov    %ebx,%eax
  8021ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	ff 35 10 70 80 00    	pushl  0x807010
  8021ff:	68 00 70 80 00       	push   $0x807000
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	e8 15 eb ff ff       	call   800d21 <memmove>
		*addrlen = ret->ret_addrlen;
  80220c:	a1 10 70 80 00       	mov    0x807010,%eax
  802211:	89 06                	mov    %eax,(%esi)
  802213:	83 c4 10             	add    $0x10,%esp
	return r;
  802216:	eb d5                	jmp    8021ed <nsipc_accept+0x27>

00802218 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	53                   	push   %ebx
  80221c:	83 ec 08             	sub    $0x8,%esp
  80221f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80222a:	53                   	push   %ebx
  80222b:	ff 75 0c             	pushl  0xc(%ebp)
  80222e:	68 04 70 80 00       	push   $0x807004
  802233:	e8 e9 ea ff ff       	call   800d21 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802238:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80223e:	b8 02 00 00 00       	mov    $0x2,%eax
  802243:	e8 32 ff ff ff       	call   80217a <nsipc>
}
  802248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80225b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802263:	b8 03 00 00 00       	mov    $0x3,%eax
  802268:	e8 0d ff ff ff       	call   80217a <nsipc>
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <nsipc_close>:

int
nsipc_close(int s)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80227d:	b8 04 00 00 00       	mov    $0x4,%eax
  802282:	e8 f3 fe ff ff       	call   80217a <nsipc>
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	53                   	push   %ebx
  80228d:	83 ec 08             	sub    $0x8,%esp
  802290:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80229b:	53                   	push   %ebx
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	68 04 70 80 00       	push   $0x807004
  8022a4:	e8 78 ea ff ff       	call   800d21 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022a9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022af:	b8 05 00 00 00       	mov    $0x5,%eax
  8022b4:	e8 c1 fe ff ff       	call   80217a <nsipc>
}
  8022b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8022d9:	e8 9c fe ff ff       	call   80217a <nsipc>
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022f0:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f9:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022fe:	b8 07 00 00 00       	mov    $0x7,%eax
  802303:	e8 72 fe ff ff       	call   80217a <nsipc>
  802308:	89 c3                	mov    %eax,%ebx
  80230a:	85 c0                	test   %eax,%eax
  80230c:	78 1f                	js     80232d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80230e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802313:	7f 21                	jg     802336 <nsipc_recv+0x56>
  802315:	39 c6                	cmp    %eax,%esi
  802317:	7c 1d                	jl     802336 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	50                   	push   %eax
  80231d:	68 00 70 80 00       	push   $0x807000
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	e8 f7 e9 ff ff       	call   800d21 <memmove>
  80232a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80232d:	89 d8                	mov    %ebx,%eax
  80232f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802332:	5b                   	pop    %ebx
  802333:	5e                   	pop    %esi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802336:	68 73 33 80 00       	push   $0x803373
  80233b:	68 3b 33 80 00       	push   $0x80333b
  802340:	6a 62                	push   $0x62
  802342:	68 88 33 80 00       	push   $0x803388
  802347:	e8 f2 df ff ff       	call   80033e <_panic>

0080234c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	53                   	push   %ebx
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80235e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802364:	7f 2e                	jg     802394 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	53                   	push   %ebx
  80236a:	ff 75 0c             	pushl  0xc(%ebp)
  80236d:	68 0c 70 80 00       	push   $0x80700c
  802372:	e8 aa e9 ff ff       	call   800d21 <memmove>
	nsipcbuf.send.req_size = size;
  802377:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80237d:	8b 45 14             	mov    0x14(%ebp),%eax
  802380:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802385:	b8 08 00 00 00       	mov    $0x8,%eax
  80238a:	e8 eb fd ff ff       	call   80217a <nsipc>
}
  80238f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802392:	c9                   	leave  
  802393:	c3                   	ret    
	assert(size < 1600);
  802394:	68 94 33 80 00       	push   $0x803394
  802399:	68 3b 33 80 00       	push   $0x80333b
  80239e:	6a 6d                	push   $0x6d
  8023a0:	68 88 33 80 00       	push   $0x803388
  8023a5:	e8 94 df ff ff       	call   80033e <_panic>

008023aa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023c8:	b8 09 00 00 00       	mov    $0x9,%eax
  8023cd:	e8 a8 fd ff ff       	call   80217a <nsipc>
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	56                   	push   %esi
  8023d8:	53                   	push   %ebx
  8023d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	ff 75 08             	pushl  0x8(%ebp)
  8023e2:	e8 6a f3 ff ff       	call   801751 <fd2data>
  8023e7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023e9:	83 c4 08             	add    $0x8,%esp
  8023ec:	68 a0 33 80 00       	push   $0x8033a0
  8023f1:	53                   	push   %ebx
  8023f2:	e8 9c e7 ff ff       	call   800b93 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023f7:	8b 46 04             	mov    0x4(%esi),%eax
  8023fa:	2b 06                	sub    (%esi),%eax
  8023fc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802402:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802409:	00 00 00 
	stat->st_dev = &devpipe;
  80240c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802413:	40 80 00 
	return 0;
}
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241e:	5b                   	pop    %ebx
  80241f:	5e                   	pop    %esi
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    

00802422 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	53                   	push   %ebx
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80242c:	53                   	push   %ebx
  80242d:	6a 00                	push   $0x0
  80242f:	e8 d6 eb ff ff       	call   80100a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802434:	89 1c 24             	mov    %ebx,(%esp)
  802437:	e8 15 f3 ff ff       	call   801751 <fd2data>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	50                   	push   %eax
  802440:	6a 00                	push   $0x0
  802442:	e8 c3 eb ff ff       	call   80100a <sys_page_unmap>
}
  802447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <_pipeisclosed>:
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	57                   	push   %edi
  802450:	56                   	push   %esi
  802451:	53                   	push   %ebx
  802452:	83 ec 1c             	sub    $0x1c,%esp
  802455:	89 c7                	mov    %eax,%edi
  802457:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802459:	a1 08 50 80 00       	mov    0x805008,%eax
  80245e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802461:	83 ec 0c             	sub    $0xc,%esp
  802464:	57                   	push   %edi
  802465:	e8 be 05 00 00       	call   802a28 <pageref>
  80246a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80246d:	89 34 24             	mov    %esi,(%esp)
  802470:	e8 b3 05 00 00       	call   802a28 <pageref>
		nn = thisenv->env_runs;
  802475:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80247b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80247e:	83 c4 10             	add    $0x10,%esp
  802481:	39 cb                	cmp    %ecx,%ebx
  802483:	74 1b                	je     8024a0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802485:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802488:	75 cf                	jne    802459 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80248a:	8b 42 58             	mov    0x58(%edx),%eax
  80248d:	6a 01                	push   $0x1
  80248f:	50                   	push   %eax
  802490:	53                   	push   %ebx
  802491:	68 a7 33 80 00       	push   $0x8033a7
  802496:	e8 99 df ff ff       	call   800434 <cprintf>
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	eb b9                	jmp    802459 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024a0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024a3:	0f 94 c0             	sete   %al
  8024a6:	0f b6 c0             	movzbl %al,%eax
}
  8024a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    

008024b1 <devpipe_write>:
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	57                   	push   %edi
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 28             	sub    $0x28,%esp
  8024ba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024bd:	56                   	push   %esi
  8024be:	e8 8e f2 ff ff       	call   801751 <fd2data>
  8024c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024d0:	74 4f                	je     802521 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8024d5:	8b 0b                	mov    (%ebx),%ecx
  8024d7:	8d 51 20             	lea    0x20(%ecx),%edx
  8024da:	39 d0                	cmp    %edx,%eax
  8024dc:	72 14                	jb     8024f2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024de:	89 da                	mov    %ebx,%edx
  8024e0:	89 f0                	mov    %esi,%eax
  8024e2:	e8 65 ff ff ff       	call   80244c <_pipeisclosed>
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	75 3b                	jne    802526 <devpipe_write+0x75>
			sys_yield();
  8024eb:	e8 76 ea ff ff       	call   800f66 <sys_yield>
  8024f0:	eb e0                	jmp    8024d2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024f5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024f9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	c1 fa 1f             	sar    $0x1f,%edx
  802501:	89 d1                	mov    %edx,%ecx
  802503:	c1 e9 1b             	shr    $0x1b,%ecx
  802506:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802509:	83 e2 1f             	and    $0x1f,%edx
  80250c:	29 ca                	sub    %ecx,%edx
  80250e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802512:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802516:	83 c0 01             	add    $0x1,%eax
  802519:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80251c:	83 c7 01             	add    $0x1,%edi
  80251f:	eb ac                	jmp    8024cd <devpipe_write+0x1c>
	return i;
  802521:	8b 45 10             	mov    0x10(%ebp),%eax
  802524:	eb 05                	jmp    80252b <devpipe_write+0x7a>
				return 0;
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80252e:	5b                   	pop    %ebx
  80252f:	5e                   	pop    %esi
  802530:	5f                   	pop    %edi
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    

00802533 <devpipe_read>:
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	57                   	push   %edi
  802537:	56                   	push   %esi
  802538:	53                   	push   %ebx
  802539:	83 ec 18             	sub    $0x18,%esp
  80253c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80253f:	57                   	push   %edi
  802540:	e8 0c f2 ff ff       	call   801751 <fd2data>
  802545:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802552:	75 14                	jne    802568 <devpipe_read+0x35>
	return i;
  802554:	8b 45 10             	mov    0x10(%ebp),%eax
  802557:	eb 02                	jmp    80255b <devpipe_read+0x28>
				return i;
  802559:	89 f0                	mov    %esi,%eax
}
  80255b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80255e:	5b                   	pop    %ebx
  80255f:	5e                   	pop    %esi
  802560:	5f                   	pop    %edi
  802561:	5d                   	pop    %ebp
  802562:	c3                   	ret    
			sys_yield();
  802563:	e8 fe e9 ff ff       	call   800f66 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802568:	8b 03                	mov    (%ebx),%eax
  80256a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80256d:	75 18                	jne    802587 <devpipe_read+0x54>
			if (i > 0)
  80256f:	85 f6                	test   %esi,%esi
  802571:	75 e6                	jne    802559 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802573:	89 da                	mov    %ebx,%edx
  802575:	89 f8                	mov    %edi,%eax
  802577:	e8 d0 fe ff ff       	call   80244c <_pipeisclosed>
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 e3                	je     802563 <devpipe_read+0x30>
				return 0;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
  802585:	eb d4                	jmp    80255b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802587:	99                   	cltd   
  802588:	c1 ea 1b             	shr    $0x1b,%edx
  80258b:	01 d0                	add    %edx,%eax
  80258d:	83 e0 1f             	and    $0x1f,%eax
  802590:	29 d0                	sub    %edx,%eax
  802592:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80259a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80259d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025a0:	83 c6 01             	add    $0x1,%esi
  8025a3:	eb aa                	jmp    80254f <devpipe_read+0x1c>

008025a5 <pipe>:
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	56                   	push   %esi
  8025a9:	53                   	push   %ebx
  8025aa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025b0:	50                   	push   %eax
  8025b1:	e8 b2 f1 ff ff       	call   801768 <fd_alloc>
  8025b6:	89 c3                	mov    %eax,%ebx
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	0f 88 23 01 00 00    	js     8026e6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 07 04 00 00       	push   $0x407
  8025cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ce:	6a 00                	push   $0x0
  8025d0:	e8 b0 e9 ff ff       	call   800f85 <sys_page_alloc>
  8025d5:	89 c3                	mov    %eax,%ebx
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	0f 88 04 01 00 00    	js     8026e6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025e2:	83 ec 0c             	sub    $0xc,%esp
  8025e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e8:	50                   	push   %eax
  8025e9:	e8 7a f1 ff ff       	call   801768 <fd_alloc>
  8025ee:	89 c3                	mov    %eax,%ebx
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 db 00 00 00    	js     8026d6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 07 04 00 00       	push   $0x407
  802603:	ff 75 f0             	pushl  -0x10(%ebp)
  802606:	6a 00                	push   $0x0
  802608:	e8 78 e9 ff ff       	call   800f85 <sys_page_alloc>
  80260d:	89 c3                	mov    %eax,%ebx
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	85 c0                	test   %eax,%eax
  802614:	0f 88 bc 00 00 00    	js     8026d6 <pipe+0x131>
	va = fd2data(fd0);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	ff 75 f4             	pushl  -0xc(%ebp)
  802620:	e8 2c f1 ff ff       	call   801751 <fd2data>
  802625:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802627:	83 c4 0c             	add    $0xc,%esp
  80262a:	68 07 04 00 00       	push   $0x407
  80262f:	50                   	push   %eax
  802630:	6a 00                	push   $0x0
  802632:	e8 4e e9 ff ff       	call   800f85 <sys_page_alloc>
  802637:	89 c3                	mov    %eax,%ebx
  802639:	83 c4 10             	add    $0x10,%esp
  80263c:	85 c0                	test   %eax,%eax
  80263e:	0f 88 82 00 00 00    	js     8026c6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802644:	83 ec 0c             	sub    $0xc,%esp
  802647:	ff 75 f0             	pushl  -0x10(%ebp)
  80264a:	e8 02 f1 ff ff       	call   801751 <fd2data>
  80264f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802656:	50                   	push   %eax
  802657:	6a 00                	push   $0x0
  802659:	56                   	push   %esi
  80265a:	6a 00                	push   $0x0
  80265c:	e8 67 e9 ff ff       	call   800fc8 <sys_page_map>
  802661:	89 c3                	mov    %eax,%ebx
  802663:	83 c4 20             	add    $0x20,%esp
  802666:	85 c0                	test   %eax,%eax
  802668:	78 4e                	js     8026b8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80266a:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80266f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802672:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802677:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80267e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802681:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802686:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80268d:	83 ec 0c             	sub    $0xc,%esp
  802690:	ff 75 f4             	pushl  -0xc(%ebp)
  802693:	e8 a9 f0 ff ff       	call   801741 <fd2num>
  802698:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80269d:	83 c4 04             	add    $0x4,%esp
  8026a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a3:	e8 99 f0 ff ff       	call   801741 <fd2num>
  8026a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026b6:	eb 2e                	jmp    8026e6 <pipe+0x141>
	sys_page_unmap(0, va);
  8026b8:	83 ec 08             	sub    $0x8,%esp
  8026bb:	56                   	push   %esi
  8026bc:	6a 00                	push   $0x0
  8026be:	e8 47 e9 ff ff       	call   80100a <sys_page_unmap>
  8026c3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026c6:	83 ec 08             	sub    $0x8,%esp
  8026c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cc:	6a 00                	push   $0x0
  8026ce:	e8 37 e9 ff ff       	call   80100a <sys_page_unmap>
  8026d3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026d6:	83 ec 08             	sub    $0x8,%esp
  8026d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026dc:	6a 00                	push   $0x0
  8026de:	e8 27 e9 ff ff       	call   80100a <sys_page_unmap>
  8026e3:	83 c4 10             	add    $0x10,%esp
}
  8026e6:	89 d8                	mov    %ebx,%eax
  8026e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026eb:	5b                   	pop    %ebx
  8026ec:	5e                   	pop    %esi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    

008026ef <pipeisclosed>:
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026f8:	50                   	push   %eax
  8026f9:	ff 75 08             	pushl  0x8(%ebp)
  8026fc:	e8 b9 f0 ff ff       	call   8017ba <fd_lookup>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	85 c0                	test   %eax,%eax
  802706:	78 18                	js     802720 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802708:	83 ec 0c             	sub    $0xc,%esp
  80270b:	ff 75 f4             	pushl  -0xc(%ebp)
  80270e:	e8 3e f0 ff ff       	call   801751 <fd2data>
	return _pipeisclosed(fd, p);
  802713:	89 c2                	mov    %eax,%edx
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	e8 2f fd ff ff       	call   80244c <_pipeisclosed>
  80271d:	83 c4 10             	add    $0x10,%esp
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	c3                   	ret    

00802728 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80272e:	68 ba 33 80 00       	push   $0x8033ba
  802733:	ff 75 0c             	pushl  0xc(%ebp)
  802736:	e8 58 e4 ff ff       	call   800b93 <strcpy>
	return 0;
}
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <devcons_write>:
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80274e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802753:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802759:	3b 75 10             	cmp    0x10(%ebp),%esi
  80275c:	73 31                	jae    80278f <devcons_write+0x4d>
		m = n - tot;
  80275e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802761:	29 f3                	sub    %esi,%ebx
  802763:	83 fb 7f             	cmp    $0x7f,%ebx
  802766:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80276b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	53                   	push   %ebx
  802772:	89 f0                	mov    %esi,%eax
  802774:	03 45 0c             	add    0xc(%ebp),%eax
  802777:	50                   	push   %eax
  802778:	57                   	push   %edi
  802779:	e8 a3 e5 ff ff       	call   800d21 <memmove>
		sys_cputs(buf, m);
  80277e:	83 c4 08             	add    $0x8,%esp
  802781:	53                   	push   %ebx
  802782:	57                   	push   %edi
  802783:	e8 41 e7 ff ff       	call   800ec9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802788:	01 de                	add    %ebx,%esi
  80278a:	83 c4 10             	add    $0x10,%esp
  80278d:	eb ca                	jmp    802759 <devcons_write+0x17>
}
  80278f:	89 f0                	mov    %esi,%eax
  802791:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802794:	5b                   	pop    %ebx
  802795:	5e                   	pop    %esi
  802796:	5f                   	pop    %edi
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    

00802799 <devcons_read>:
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 08             	sub    $0x8,%esp
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027a8:	74 21                	je     8027cb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027aa:	e8 38 e7 ff ff       	call   800ee7 <sys_cgetc>
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	75 07                	jne    8027ba <devcons_read+0x21>
		sys_yield();
  8027b3:	e8 ae e7 ff ff       	call   800f66 <sys_yield>
  8027b8:	eb f0                	jmp    8027aa <devcons_read+0x11>
	if (c < 0)
  8027ba:	78 0f                	js     8027cb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027bc:	83 f8 04             	cmp    $0x4,%eax
  8027bf:	74 0c                	je     8027cd <devcons_read+0x34>
	*(char*)vbuf = c;
  8027c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c4:	88 02                	mov    %al,(%edx)
	return 1;
  8027c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    
		return 0;
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	eb f7                	jmp    8027cb <devcons_read+0x32>

008027d4 <cputchar>:
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027e0:	6a 01                	push   $0x1
  8027e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027e5:	50                   	push   %eax
  8027e6:	e8 de e6 ff ff       	call   800ec9 <sys_cputs>
}
  8027eb:	83 c4 10             	add    $0x10,%esp
  8027ee:	c9                   	leave  
  8027ef:	c3                   	ret    

008027f0 <getchar>:
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027f6:	6a 01                	push   $0x1
  8027f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fb:	50                   	push   %eax
  8027fc:	6a 00                	push   $0x0
  8027fe:	e8 27 f2 ff ff       	call   801a2a <read>
	if (r < 0)
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	85 c0                	test   %eax,%eax
  802808:	78 06                	js     802810 <getchar+0x20>
	if (r < 1)
  80280a:	74 06                	je     802812 <getchar+0x22>
	return c;
  80280c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    
		return -E_EOF;
  802812:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802817:	eb f7                	jmp    802810 <getchar+0x20>

00802819 <iscons>:
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80281f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802822:	50                   	push   %eax
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	e8 8f ef ff ff       	call   8017ba <fd_lookup>
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	85 c0                	test   %eax,%eax
  802830:	78 11                	js     802843 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80283b:	39 10                	cmp    %edx,(%eax)
  80283d:	0f 94 c0             	sete   %al
  802840:	0f b6 c0             	movzbl %al,%eax
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <opencons>:
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80284b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284e:	50                   	push   %eax
  80284f:	e8 14 ef ff ff       	call   801768 <fd_alloc>
  802854:	83 c4 10             	add    $0x10,%esp
  802857:	85 c0                	test   %eax,%eax
  802859:	78 3a                	js     802895 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	68 07 04 00 00       	push   $0x407
  802863:	ff 75 f4             	pushl  -0xc(%ebp)
  802866:	6a 00                	push   $0x0
  802868:	e8 18 e7 ff ff       	call   800f85 <sys_page_alloc>
  80286d:	83 c4 10             	add    $0x10,%esp
  802870:	85 c0                	test   %eax,%eax
  802872:	78 21                	js     802895 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80287d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	50                   	push   %eax
  80288d:	e8 af ee ff ff       	call   801741 <fd2num>
  802892:	83 c4 10             	add    $0x10,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
  80289a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80289d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028a4:	74 0a                	je     8028b0 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	6a 07                	push   $0x7
  8028b5:	68 00 f0 bf ee       	push   $0xeebff000
  8028ba:	6a 00                	push   $0x0
  8028bc:	e8 c4 e6 ff ff       	call   800f85 <sys_page_alloc>
		if(r < 0)
  8028c1:	83 c4 10             	add    $0x10,%esp
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	78 2a                	js     8028f2 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028c8:	83 ec 08             	sub    $0x8,%esp
  8028cb:	68 06 29 80 00       	push   $0x802906
  8028d0:	6a 00                	push   $0x0
  8028d2:	e8 f9 e7 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028d7:	83 c4 10             	add    $0x10,%esp
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	79 c8                	jns    8028a6 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 f8 33 80 00       	push   $0x8033f8
  8028e6:	6a 25                	push   $0x25
  8028e8:	68 34 34 80 00       	push   $0x803434
  8028ed:	e8 4c da ff ff       	call   80033e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 c8 33 80 00       	push   $0x8033c8
  8028fa:	6a 22                	push   $0x22
  8028fc:	68 34 34 80 00       	push   $0x803434
  802901:	e8 38 da ff ff       	call   80033e <_panic>

00802906 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802906:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802907:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80290c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80290e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802911:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802915:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802919:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80291c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80291e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802922:	83 c4 08             	add    $0x8,%esp
	popal
  802925:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802926:	83 c4 04             	add    $0x4,%esp
	popfl
  802929:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80292a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80292b:	c3                   	ret    

0080292c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	56                   	push   %esi
  802930:	53                   	push   %ebx
  802931:	8b 75 08             	mov    0x8(%ebp),%esi
  802934:	8b 45 0c             	mov    0xc(%ebp),%eax
  802937:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  80293a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80293c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802941:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802944:	83 ec 0c             	sub    $0xc,%esp
  802947:	50                   	push   %eax
  802948:	e8 e8 e7 ff ff       	call   801135 <sys_ipc_recv>
	if(ret < 0){
  80294d:	83 c4 10             	add    $0x10,%esp
  802950:	85 c0                	test   %eax,%eax
  802952:	78 2b                	js     80297f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802954:	85 f6                	test   %esi,%esi
  802956:	74 0a                	je     802962 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802958:	a1 08 50 80 00       	mov    0x805008,%eax
  80295d:	8b 40 74             	mov    0x74(%eax),%eax
  802960:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802962:	85 db                	test   %ebx,%ebx
  802964:	74 0a                	je     802970 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802966:	a1 08 50 80 00       	mov    0x805008,%eax
  80296b:	8b 40 78             	mov    0x78(%eax),%eax
  80296e:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802970:	a1 08 50 80 00       	mov    0x805008,%eax
  802975:	8b 40 70             	mov    0x70(%eax),%eax
}
  802978:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5e                   	pop    %esi
  80297d:	5d                   	pop    %ebp
  80297e:	c3                   	ret    
		if(from_env_store)
  80297f:	85 f6                	test   %esi,%esi
  802981:	74 06                	je     802989 <ipc_recv+0x5d>
			*from_env_store = 0;
  802983:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802989:	85 db                	test   %ebx,%ebx
  80298b:	74 eb                	je     802978 <ipc_recv+0x4c>
			*perm_store = 0;
  80298d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802993:	eb e3                	jmp    802978 <ipc_recv+0x4c>

00802995 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	57                   	push   %edi
  802999:	56                   	push   %esi
  80299a:	53                   	push   %ebx
  80299b:	83 ec 0c             	sub    $0xc,%esp
  80299e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029a7:	85 db                	test   %ebx,%ebx
  8029a9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029ae:	0f 44 d8             	cmove  %eax,%ebx
  8029b1:	eb 05                	jmp    8029b8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029b3:	e8 ae e5 ff ff       	call   800f66 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029b8:	ff 75 14             	pushl  0x14(%ebp)
  8029bb:	53                   	push   %ebx
  8029bc:	56                   	push   %esi
  8029bd:	57                   	push   %edi
  8029be:	e8 4f e7 ff ff       	call   801112 <sys_ipc_try_send>
  8029c3:	83 c4 10             	add    $0x10,%esp
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 1b                	je     8029e5 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029ca:	79 e7                	jns    8029b3 <ipc_send+0x1e>
  8029cc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029cf:	74 e2                	je     8029b3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029d1:	83 ec 04             	sub    $0x4,%esp
  8029d4:	68 42 34 80 00       	push   $0x803442
  8029d9:	6a 4a                	push   $0x4a
  8029db:	68 57 34 80 00       	push   $0x803457
  8029e0:	e8 59 d9 ff ff       	call   80033e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029e8:	5b                   	pop    %ebx
  8029e9:	5e                   	pop    %esi
  8029ea:	5f                   	pop    %edi
  8029eb:	5d                   	pop    %ebp
  8029ec:	c3                   	ret    

008029ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
  8029f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029f8:	89 c2                	mov    %eax,%edx
  8029fa:	c1 e2 07             	shl    $0x7,%edx
  8029fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a03:	8b 52 50             	mov    0x50(%edx),%edx
  802a06:	39 ca                	cmp    %ecx,%edx
  802a08:	74 11                	je     802a1b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a0a:	83 c0 01             	add    $0x1,%eax
  802a0d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a12:	75 e4                	jne    8029f8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	eb 0b                	jmp    802a26 <ipc_find_env+0x39>
			return envs[i].env_id;
  802a1b:	c1 e0 07             	shl    $0x7,%eax
  802a1e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a23:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    

00802a28 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a2e:	89 d0                	mov    %edx,%eax
  802a30:	c1 e8 16             	shr    $0x16,%eax
  802a33:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a3a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a3f:	f6 c1 01             	test   $0x1,%cl
  802a42:	74 1d                	je     802a61 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a44:	c1 ea 0c             	shr    $0xc,%edx
  802a47:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a4e:	f6 c2 01             	test   $0x1,%dl
  802a51:	74 0e                	je     802a61 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a53:	c1 ea 0c             	shr    $0xc,%edx
  802a56:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a5d:	ef 
  802a5e:	0f b7 c0             	movzwl %ax,%eax
}
  802a61:	5d                   	pop    %ebp
  802a62:	c3                   	ret    
  802a63:	66 90                	xchg   %ax,%ax
  802a65:	66 90                	xchg   %ax,%ax
  802a67:	66 90                	xchg   %ax,%ax
  802a69:	66 90                	xchg   %ax,%ax
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
